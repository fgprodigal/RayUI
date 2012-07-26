------------------------------------------------------------
-- Core.lua
--
-- Abin
-- 2011/2/20
------------------------------------------------------------

local pairs = pairs
local InCombatLockdown = InCombatLockdown
local GetRealZoneText = GetRealZoneText
local wipe = wipe
local GetNumCompanions = GetNumCompanions
local GetCompanionInfo = GetCompanionInfo
local UnitBuff = UnitBuff
local ClearOverrideBindings = ClearOverrideBindings
local GetBindingKey = GetBindingKey
local SetOverrideBindingClick = SetOverrideBindingClick
local type = type
local strfind = strfind

local addonName, addon = ...
_G["EasyMount"] = addon
addon.version = GetAddOnMetadata(addonName, "Version") or "1.0"
local L = addon.L

local function CreateMountButton(name)
	local button = CreateFrame("Button", name, UIParent, "SecureActionButtonTemplate,SecureHandlerMouseUpDownTemplate")
	button:SetAttribute("type", "macro")
	return button
end

local normalButton = CreateMountButton("EasyMountNormalButton")
local groundButton = CreateMountButton("EasyMountGroundButton")

local travelData = addon.TRAVEL_CLASSES[addon.CLASS]
if travelData then
	local key, value
	for key, value in pairs(travelData) do
		normalButton:SetAttribute(key, value)
	end
end

normalButton:SetAttribute("_onmouseup", [[
	local macro, spell, key, count
	local swimMounts = self:GetAttribute("swimMountCount") or 0
	local flyMounts = self:GetAttribute("flyMountCount") or 0
	local groundMounts = self:GetAttribute("groundMountCount") or 0
	local aquatic = self:GetAttribute("aquatic")
	local combat = self:GetAttribute("combat")
	local swimming = IsSwimming() or self:GetAttribute("underwater")

	if UnitHasVehicleUI("player") then
		macro = "/script VehicleExit()"
	elseif IsMounted() then
		macro = "/dismount"
	elseif aquatic and GetShapeshiftForm() == self:GetAttribute("flightForm") then
		macro = "/cancelform"
	elseif combat and PlayerInCombat() then
		if aquatic and swimming then
			spell = aquatic
		else
			spell = combat
		end
	elseif swimming and swimMounts > 0 then
		key, count = "swim", swimMounts
	elseif IsFlyableArea() and flyMounts > 0 then
		key, count = "fly", flyMounts
	elseif groundMounts > 0 then
		key, count = "ground", groundMounts
	end

	if key then
		if count > 1 then
			spell = self:GetAttribute(key.."Mount"..random(count))
		else
			spell = self:GetAttribute(key.."Mount1")
		end
	end

	self:SetAttribute("macrotext", macro or (spell and "/cast "..spell))
]])

groundButton:SetAttribute("_onmouseup", [[
	local macro, spell
	local count = self:GetAttribute("groundMountCount") or 0

	if UnitHasVehicleUI("player") then
		macro = "/script VehicleExit()"
	elseif IsMounted() then
		macro = "/dismount"
	elseif self:GetAttribute("aquatic") and GetShapeshiftForm() == self:GetAttribute("flightForm") then
		macro = "/cancelform"
	elseif count > 1 then
		spell = self:GetAttribute("groundMount"..random(count))
	else
		spell = self:GetAttribute("groundMount1")
	end
	self:SetAttribute("macrotext", macro or (spell and "/cast "..spell))
]])

local function UpdateAttributeList(button, list, key)
	local count = 0
	if list then
		local id, name
		for id, name in pairs(list) do
			if not addon.db.blacklist[id] then
				count = count + 1
				button:SetAttribute(key.."Mount"..count, name)
			end
		end
	end
	button:SetAttribute(key.."MountCount", count)
end

function addon:UpdateAttributeLists()
	if InCombatLockdown() then
		return
	end

	if self.CLASS == "DRUID" then
		local flightForm
		local numForms = GetNumShapeshiftForms()
		if numForms > 0 then
			local _, name = GetShapeshiftFormInfo(numForms)
			if name == self:GetMountName(40120) or name == self:GetMountName(33943) then
				flightForm = numForms
			end
		end
		normalButton:SetAttribute("flightForm", flightForm)
		groundButton:SetAttribute("flightForm", flightForm)
	end

	normalButton:SetAttribute("underwater", self.underwater)

	UpdateAttributeList(normalButton, not self.vashjir and self.fly, "fly") -- Regardless of what IsFlyableArea() returns, some areas in Vashj'ir are not flyable
	local groundList = GetRealZoneText() == L["taq"] and self.taq or self.ground
	UpdateAttributeList(normalButton, groundList, "ground")
	UpdateAttributeList(groundButton, groundList, "ground")

	-- Abyssal Seahorse only usable in Vashj'ir
	if self.vashjir and self.seahorse then
		self.swim[75207] = self.seahorse
	else
		self.swim[75207] = nil
	end
	UpdateAttributeList(normalButton, self.swim, "swim")
end

function addon:UpdateMounts()
	local key
	for key in pairs(addon.MOUNT_KEYS) do
		wipe(self[key])
	end
	self.seahorse = nil
	self:UpdateClassSpells()

	local i
	for i = 1, GetNumCompanions("MOUNT") do
		local _, _, id = GetCompanionInfo("MOUNT", i)
		local data = self:GetMountData(id)
		if data then
			local name, key = data.name, data.key
			if self.MOUNT_KEYS[key] then
				self[key][id] = name
			elseif key == "both" then
				self.ground[id] = name
				self.fly[id] = name
			elseif key == "seahorse" then
				self.seahorse = name
			end
		end
	end

	self:UpdateAttributeLists()
end

-- Event handler

local function AssignHotkey(button, id)
	ClearOverrideBindings(button)
	local key1, key2 = GetBindingKey("EASYMOUNT_HOTKEY"..id)
	if key2 then
		SetOverrideBindingClick(button, false, key2, button:GetName())
	end

	if key1 then
		SetOverrideBindingClick(button, false, key1, button:GetName())
	end
end

local function UpdateBindings()
	if not InCombatLockdown() then
		AssignHotkey(normalButton, 1)
		AssignHotkey(groundButton, 2)
	end
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:SetScript("OnEvent", function(self, event, ...)
	local func = self[event]
	if func then
		func(self, ...)
	end
end)

function frame:ADDON_LOADED(name)
	if name ~= addonName then
		return
	end

	self:UnregisterAllEvents()
	if type(EasyMountDB) ~= "table" then
		EasyMountDB = {}
	end

	addon.db = EasyMountDB
	if type(addon.db.blacklist) ~= "table" then
		addon.db.blacklist = {}
	end

	if not addon:IsClassSpellFinal() then
		self:RegisterEvent("CHAT_MSG_SYSTEM")
	end

	self:RegisterEvent("PLAYER_ENTERING_WORLD")
	self:RegisterEvent("COMPANION_LEARNED")
	self:RegisterEvent("UPDATE_BINDINGS")
	self:RegisterEvent("UNIT_AURA")
	self:RegisterEvent("PLAYER_REGEN_ENABLED")
	if addon.CLASS == "DRUID" then
		self:RegisterEvent("UPDATE_SHAPESHIFT_FORMS")
	end
	self:UNIT_AURA("player")
end

function frame:COMPANION_LEARNED()
	addon:UpdateMounts()
end

frame.PLAYER_ENTERING_WORLD = frame.COMPANION_LEARNED

local SEA_LEGS = GetSpellInfo(73701) -- The buff which determines whether the player is located in Vashj'ir
function frame:UNIT_AURA(unit)
	if unit ~= "player" then
		return
	end

	local vashjir = UnitBuff("player", SEA_LEGS)
	if addon.vashjir ~= vashjir then
		addon.vashjir = vashjir
		if vashjir then
			self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		else
			self:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		end
		addon:UpdateAttributeLists()
		return 1
	end
end

function frame:COMBAT_LOG_EVENT_UNFILTERED(_, flag, _, guid, _, _, _, _, _, id)
	if id == 75966 and (flag == "SPELL_AURA_APPLIED" or flag == "SPELL_AURA_REMOVED") and guid == UnitGUID("player") then
		local underwater
		if flag == "SPELL_AURA_APPLIED" then
			underwater = 1
		end

		if addon.underwater ~= underwater then
			addon.underwater = underwater
			addon:UpdateAttributeLists()
		end
	end
end

function frame:UPDATE_BINDINGS()
	UpdateBindings()
end

function frame:PLAYER_REGEN_ENABLED()
	UpdateBindings()
	if not self:UNIT_AURA("player") then
		addon:UpdateAttributeLists()
	end
end

local SPELL_LEARNED = gsub(ERR_LEARN_SPELL_S, "%%s", "(.+)Hspell:(%%d+)(.+)")
function frame:CHAT_MSG_SYSTEM(text)
	local _, _, _, id = strfind(text, SPELL_LEARNED)
	if id == "33943" or id == "40120" or id == "87840" then
		addon:UpdateMounts()
	end

	if addon:IsClassSpellFinal() then
		self:UnregisterEvent("CHAT_MSG_SYSTEM")
	end
end

function frame:UPDATE_SHAPESHIFT_FORMS()
	addon:UpdateAttributeLists()
end