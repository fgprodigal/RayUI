local AddOnName, Engine = ...
local AddOn = LibStub("AceAddon-3.0"):NewAddon(AddOnName, "AceConsole-3.0", "AceEvent-3.0", "AceHook-3.0")
local Locale = LibStub("AceLocale-3.0"):GetLocale(AddOnName, false)
local AceConfig = LibStub("AceConfig-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")
local DEFAULT_WIDTH = 850
local DEFAULT_HEIGHT = 650
AddOn.callbacks = AddOn.callbacks or LibStub("CallbackHandler-1.0"):New(AddOn)
AddOn.DF = {}
AddOn.DF["profile"] = {}
AddOn.DF["global"] = {}

Engine[1] = AddOn
Engine[2] = Locale
Engine[3] = AddOn.DF["profile"]
Engine[4] = AddOn.DF["global"]

_G[AddOnName] = Engine

function AddOn:OnProfileChanged(event, database, newProfileKey)
	StaticPopup_Show("CFG_RELOAD")
end

function AddOn:OnInitialize()
	if not RayUICharacterData then
		RayUICharacterData = {}
	end

	self.data = LibStub("AceDB-3.0"):New("RayUIData", self.DF)
	self.data.RegisterCallback(self, "OnProfileChanged", "OnProfileChanged")
	self.data.RegisterCallback(self, "OnProfileCopied", "OnProfileChanged")
	self.data.RegisterCallback(self, "OnProfileReset", "OnProfileChanged")
	self.db = self.data.profile
	self.global = self.data.global

	AceConfig:RegisterOptionsTable("RayUI", AddOn.Options)
	self.Options.args.profiles = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.data)
	AceConfig:RegisterOptionsTable("RayUIProfiles", self.Options.args.profiles)
	self.Options.args.profiles.order = -10

	self:UIScale()
	self:UpdateMedia()

	for k, v in self:IterateModules() do
		if self.db[k] and self.DF["profile"][k] and (( self.DF["profile"][k].enable~=nil and self.DF["profile"][k].enable == true) or self.DF["profile"][k].enable == nil) and v.GetOptions then
			AddOn.Options.args[k:gsub(" ", "_")] = {
				type = "group",
				name = (v.modName or k),
				args = nil,
				get = function(info)
					return AddOn.db[k][ info[#info] ]
				end,
				set = function(info, value)
					AddOn.db[k][ info[#info] ] = value
					StaticPopup_Show("CFG_RELOAD")
				end,
			}
			local t = v:GetOptions()
			t.settingsHeader = {
				type = "header",
				name = Locale["设置"],
				order = 4
			}
			if self.db[k] and self.db[k].enable ~= nil then
				t.toggle = {
					type = "toggle",
					name = v.toggleLabel or (Locale["启用"] .. (v.modName or k)),
					width = "double",
					desc = v.Info and v:Info() or (Locale["启用"] .. (v.modName or k)),
					order = 3,
					get = function()
						return AddOn.db[k].enable ~= false or false
					end,
					set = function(info, v)
						AddOn.db[k].enable = v
						StaticPopup_Show("CFG_RELOAD")
					end,
				}
			end
			t.header = {
				type = "header",
				name = v.modName or k,
				order = 1
			}
			if v.Info then
				t.description = {
					type = "description",
					name = v:Info() .. "\n\n",
					order = 2
				}
			end
			AddOn.Options.args[k:gsub(" ", "_")].args = t
		end
		v.db = AddOn.db[k]
	end

	self:InitializeModules()
	self.initialized = true
	self:RegisterEvent("PLAYER_REGEN_DISABLED")
	self:RegisterEvent("PLAYER_LOGIN", "Initialize")
	self:RegisterChatCommand("RayUI", "OpenConfig")
	self:RegisterChatCommand("RC", "OpenConfig")
	self:RegisterChatCommand("cpuusage", "GetTopCPUFunc")
	self:RegisterChatCommand("gm", ToggleHelpFrame)
end

function AddOn:PLAYER_REGEN_ENABLED()
	AceConfigDialog:Open(AddOnName)
	self:UnregisterEvent("PLAYER_REGEN_ENABLED")
end

function AddOn:PLAYER_REGEN_DISABLED()
	local err = false
	if AceConfigDialog.OpenFrames[AddOnName] then
		self:RegisterEvent("PLAYER_REGEN_ENABLED")
		AceConfigDialog:Close(AddOnName)
		err = true
	end
	for name, _ in pairs(self.CreatedMovers) do
		if _G[name]:IsShown() then
			err = true
			_G[name]:Hide()
		end
	end
	if err == true then
		self:Print(ERR_NOT_IN_COMBAT)
		self:ToggleConfigMode(true)
	end
end

function AddOn:OpenConfig()
	if InCombatLockdown() then
		self:Print(ERR_NOT_IN_COMBAT)
		self:RegisterEvent("PLAYER_REGEN_ENABLED")
		return
	end
	AceConfigDialog:SetDefaultSize("RayUI", 850, 650)
	AceConfigDialog:Open("RayUI")
	local f = AceConfigDialog.OpenFrames["RayUI"].frame
end
