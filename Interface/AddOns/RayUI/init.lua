local AddOnName, Engine = ...
local AddOn = LibStub("AceAddon-3.0"):NewAddon(AddOnName, "AceConsole-3.0", "AceEvent-3.0")
local Locale = LibStub("AceLocale-3.0"):GetLocale(AddOnName, false)
local AceConfig = LibStub("AceConfig-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")
local DEFAULT_WIDTH = 850
local DEFAULT_HEIGHT = 650
AddOn.DF = {}
AddOn.DF["profile"] = {}

AddOn.Options = {
	type = "group",
	name = AddOnName,
	args = {
		general = {
			order = 1,
			type = "group",
			name = Locale["一般"],
			get = function(info)
				return AddOn.db.general[ info[#info] ]
			end,
			set = function(info, value)
				AddOn.db.general[ info[#info] ] = value
				StaticPopup_Show("CFG_RELOAD")
			end,
			args = {
				uiscale = {
					order = 1,
					name = Locale["UI缩放"],
					desc = Locale["UI界面缩放"],
					type = "range",
					min = 0.64, max = 1, step = 0.01,
					isPercent = true,
				},
				logo = {
					order = 2,
					type = "toggle",
					name = Locale["登陆Logo"],
					desc = Locale["开关登陆时的Logo"],
				},
				spacer = {
					order = 3,
					name = " ",
					desc = " ",
					type = "description",
				},
				ToggleAnchors = {
					order = 4,
					type = "execute",
					name = Locale["解锁锚点"],
					desc = Locale["解锁并移动头像和动作条"],
					func = function()
						AceConfigDialog["Close"](AceConfigDialog,"RayUI")
						AddOn:ToggleMovers()
						GameTooltip_Hide()
					end,
				},
			},
		},
	},
}

Engine[1] = AddOn
Engine[2] = Locale
Engine[3] = AddOn.DF["profile"]

_G[AddOnName] = Engine

function AddOn:OnProfileChanged(event, database, newProfileKey)
	StaticPopup_Show("CFG_RELOAD")
end

function AddOn:OnInitialize()
	self.data = LibStub("AceDB-3.0"):New("RayUIData", self.DF)
	self.data.RegisterCallback(self, "OnProfileChanged", "OnProfileChanged")
	self.data.RegisterCallback(self, "OnProfileCopied", "OnProfileChanged")
	self.data.RegisterCallback(self, "OnProfileReset", "OnProfileChanged")
	self.db = self.data.profile

	AceConfig:RegisterOptionsTable("RayUI", AddOn.Options)
	self.Options.args.profiles = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.data)
	AceConfig:RegisterOptionsTable("RayUIProfiles", self.Options.args.profiles)
	self.Options.args.profiles.order = -10

	self:UIScale()
	self:UpdateMedia()

	for k, v in self:IterateModules() do
		if self.db[k] and (( self.db[k].enable~=nil and self.db[k].enable == true) or self.db[k].enable == nil) and v.GetOptions then
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
	self:RegisterEvent("PLAYER_LOGIN", "Initialize")
	self:RegisterChatCommand("RayUI", "OpenConfig")
	self:RegisterChatCommand("RC", "OpenConfig")
	self:RegisterChatCommand("gm", ToggleHelpFrame)
end

function AddOn:OpenConfig()
	AceConfigDialog:SetDefaultSize("RayUI", 850, 650)
	AceConfigDialog:Open("RayUI")
	local f = AceConfigDialog.OpenFrames["RayUI"].frame
	f:SetMovable(true)
	f:RegisterForDrag("LeftButton")
	f:SetScript("OnDragStart", function(self) self:StartMoving() self:SetUserPlaced(false) end)
	f:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
end

function AddOn:PLAYER_ENTERING_WORLD()
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	RequestTimePlayed()
	Advanced_UIScaleSlider:Kill()
	Advanced_UseUIScale:Kill()
	SetCVar("useUiScale", 1)
	SetCVar("uiScale", AddOn.db.general.uiscale)
	DEFAULT_CHAT_FRAME:AddMessage("欢迎使用|cff7aa6d6Ray|r|cffff0000U|r|cff7aa6d6I|r(v"..AddOn.version..")，插件发布网址: |cff8A9DDE[|Hurl:http://fgprodigal.com|hhttp://fgprodigal.com|h]|r")
	self:UnregisterEvent("PLAYER_ENTERING_WORLD" )

	local eventcount = 0
	local RayUIGarbageCollector = CreateFrame("Frame")
	RayUIGarbageCollector:RegisterAllEvents()
	RayUIGarbageCollector:SetScript("OnEvent", function(self, event, addon)
		eventcount = eventcount + 1
		if QuestDifficultyColors["trivial"].r ~= 0.50 then
			QuestDifficultyColors["trivial"].r = 0.50
			QuestDifficultyColors["trivial"].g = 0.50
			QuestDifficultyColors["trivial"].b = 0.50
			QuestDifficultyColors["trivial"].font = QuestDifficulty_Trivial
		end
		if InCombatLockdown() then return end

		if eventcount > 6000 then
			collectgarbage("collect")
			eventcount = 0
		end
	end)
end

function AddOn:Initialize()
	self:CheckRole()

	self:RegisterEvent("PLAYER_ENTERING_WORLD", "CheckRole")
	self:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED", "CheckRole")
	self:RegisterEvent("PLAYER_TALENT_UPDATE", "CheckRole")
	self:RegisterEvent("CHARACTER_POINTS_CHANGED", "CheckRole")
	self:RegisterEvent("UNIT_INVENTORY_CHANGED", "CheckRole")
	self:RegisterEvent("UPDATE_BONUS_ACTIONBAR", "CheckRole")
	self:RegisterEvent("PLAYER_ENTERING_WORLD")
	self:Delay(5, function() collectgarbage("collect") end)

	local configButton = CreateFrame("Button", "RayUIConfigButton", GameMenuFrame, "GameMenuButtonTemplate")
	configButton:SetSize(GameMenuButtonMacros:GetWidth(), GameMenuButtonMacros:GetHeight())
	GameMenuFrame:SetHeight(GameMenuFrame:GetHeight()+GameMenuButtonMacros:GetHeight());
	GameMenuButtonOptions:SetPoint("TOP", configButton, "BOTTOM", 0, -2)
	configButton:SetPoint("TOP", GameMenuButtonHelp, "BOTTOM", 0, -2)
	configButton:SetText(Locale["|cff7aa6d6Ray|r|cffff0000U|r|cff7aa6d6I|r设置"])
	configButton:SetScript("OnClick", function()
		if RayUIConfigTutorial then
			RayUIConfigTutorial:Hide()
			AddOn.db.RayUIConfigTutorial = true
		end
		HideUIPanel(GameMenuFrame)
		self:OpenConfig()
	end)

	local S = self:GetModule("Skins")
	S:Reskin(configButton)
end

StaticPopupDialogs["CFG_RELOAD"] = {
	text = Locale["改变参数需重载应用设置"],
	button1 = ACCEPT,
	button2 = CANCEL,
	OnAccept = function() ReloadUI() end,
	timeout = 0,
	whileDead = 1,
}
