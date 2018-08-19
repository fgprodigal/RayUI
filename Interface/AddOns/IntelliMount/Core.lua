------------------------------------------------------------
-- Core.lua
--
-- Abin
-- 2014/11/03
------------------------------------------------------------

local InCombatLockdown = InCombatLockdown
local pairs = pairs
local type = type
local GetItemInfo = GetItemInfo
local GetSpellInfo = GetSpellInfo
local wipe = wipe
local GetCurrentMapContinent = GetCurrentMapContinent
local IsInInstance = IsInInstance
local IsAddOnLoaded = IsAddOnLoaded
local DisableAddOn = DisableAddOn

local addon = LibAddonManager:CreateAddon(...)
local L = addon.L

addon:RegisterDB("IntelliMountDB", true)
addon:RegisterSlashCmd("intellimount", "inm")

addon.FORCE_ENUS = nil -- Set to true if taking an enUS screenshot...

local registeredNames = {}
local actionButtons = {}

addon.debugAttrs = { "onVehicle", "mounted", "inCombat", "indoor", "flyableArea", "flyForbidden", "flyable", "swimming", "battleground" }

function addon:RegisterDebugAttr(name)
	tinsert(self.debugAttrs, name)
end

function addon:RegisterName(key, id, item)
	if type(key) ~= "string" or type(id) ~= "number" or id < 1 then
		return
	end

	local name
	if item then
		name = GetItemInfo(id)
	else
		name = GetSpellInfo(id)
		if not name then
			return
		end
	end

	local data = { id = id, name = name }
	registeredNames[key] = data
	return name
end

function addon:QueryName(key)
	-- For taking an enUS screenshot...
	if self.FORCE_ENUS then
		return key
	end

	local data = registeredNames[key]
	if not data then
		return
	end

	if not data.name then
		data.name = GetItemInfo(data.id)
	end

	return data.name or "Hitem:"..data.id
end

function addon:GetActionButton(key)
	return actionButtons[key]
end

local function CreateActionButton(name, id, key, dbKey, bindingName, bindingText, templates)
	local button = CreateFrame("Button", name, UIParent, templates or "SecureActionButtonTemplate")
	actionButtons[key] = button
	button:SetID(id)
	addon:RegisterBindingClick(button, bindingName, bindingText)

	if dbKey then
		button:SetAttribute("type", "spell")
		button.dbKey = dbKey
		addon:RegisterOptionCallback(dbKey, function(value)
			button:SetAttribute("spell", value)
		end)
	end

	return button
end

------------------------------------------------------------
-- Snippets definitions
------------------------------------------------------------

local SNIPPET_VAR_DEF = [[
	local isOnVehicle = UnitHasVehicleUI("player")
	local isMounted = IsMounted()
	local isInCombat = PlayerInCombat()
	local isIndoor = IsIndoors()
	local flyableArea = IsFlyableArea()
	local flyForbidden = self:GetAttribute("flyForbidden")
	local isFlyable = flyableArea and not flyForbidden
	local isSwimming = IsSwimming()
	local inBattleground = self:GetAttribute("battleground")

	self:SetAttribute("onVehicle", isOnVehicle)
	self:SetAttribute("mounted", isMounted)
	self:SetAttribute("inCombat", isInCombat)
	self:SetAttribute("indoor", isIndoor)
	self:SetAttribute("flyableArea", flyableArea)
	self:SetAttribute("flyForbidden", flyForbidden)
	self:SetAttribute("flyable", isFlyable)
	self:SetAttribute("swimming", isSwimming)
]] -- Module variables appeneded here

local SNIPPET_CON_STA = [[

	local macro
	if isOnVehicle then
		macro = "/leavevehicle"
	elseif isMounted then
		macro = "/dismount"
]] -- Module condition statements appeneded here

local SNIPPET_CON_END = [[

	else
		local preSummon = self:GetAttribute("PreSummonRandom")
		if preSummon then
			preSummon = preSummon.."\n"
		else
			preSummon = ""
		end

		local surface
		if not inBattleground and not isFlyable and self:GetAttribute("surfaceIfNotFlable") then
			surface = self:GetAttribute("surfaceMount")
		end

		if surface then
			macro = preSummon.."/cast "..surface
		else
			macro = preSummon.."/script C_MountJournal.SummonByID(0)"
		end
	end

	self:SetAttribute("macrotext", macro)
]]

------------------------------------------------------------

local button = CreateActionButton("IntelliMountNormalButton", 1, "normal", "dummy", "INTELLIMOUNT_HOTKEY1", L["summon regular mount"], "SecureActionButtonTemplate,SecureHandlerMouseUpDownTemplate")

button:SetAttribute("type", "macro")

button:SetScript("OnMouseDown", function(self)
	addon:BroadcastEvent("PreClick", self)
end)

button:SetScript("PostClick", function(self)
	if addon.db.debugMode then
		local _, attr
		for _, attr in ipairs(addon.debugAttrs) do
			addon:Print("Debug: "..attr.."="..tostring(self:GetAttribute(attr)))
		end
		addon:Print("Debug: macrotext="..self:GetAttribute("macrotext"))
	end

	addon:BroadcastEvent("PostClick", self)
end)

CreateActionButton("IntelliMountPassengerButton", 2, "passenger", "passengerMount", "INTELLIMOUNT_HOTKEY2", L["summon passenger mount"])
CreateActionButton("IntelliMountVendorsButton", 3, "vendor", "vendorMount", "INTELLIMOUNT_HOTKEY3", L["summon vendors mount"])
CreateActionButton("IntelliMountWaterSurfaceButton", 4, "surface", addon.class == "WARLOCK" and "warlockSurfaceMount" or "surfaceMount", "INTELLIMOUNT_HOTKEY4", L["summon water surface mount"])
CreateActionButton("IntelliMountUnderwaterButton", 5, "underwater", "underwaterMount", "INTELLIMOUNT_HOTKEY5", L["summon underwater mount"])

addon:RegisterOptionCallback("utilityMount", function(key, value)
	local button = addon:GetActionButton(key)
	if button then
		button:SetAttribute("spell", value)
	end
end)

local pendingAttributes = {}

function addon:SetAttribute(attribute, value)
	if button:GetAttribute(attribute) ~= value then
		if InCombatLockdown() then
			pendingAttributes[attribute] = value
		else
			button:SetAttribute(attribute, value)
		end
	end
end

function addon:AppendVariables(snippet)
	if type(snippet) == "string" then
		SNIPPET_VAR_DEF = SNIPPET_VAR_DEF.."\n"..snippet
	end
end

function addon:AppendConditions(snippet)
	if type(snippet) == "string" then
		SNIPPET_CON_STA = SNIPPET_CON_STA.."\n"..snippet
	end
end

function addon:AppendPreSumRandom(snippet)
	if type(snippet) ~= "string" then
		return
	end

	local texts = button:GetAttribute("PreSummonRandom")
	if texts then
		texts = texts.."\n"..snippet
	else
		texts = snippet
	end

	self:SetAttribute("PreSummonRandom", texts)
end

addon:RegisterEvent("ZONE_CHANGED_NEW_AREA")

function addon:OnInitialize(db, dbIsNew, chardb)
	if dbIsNew then
		addon:BroadcastEvent("OnNewUserData", db, chardb)
	end

	db.surfaceIfNotFlable = nil -- Remove old version data

	addon:BroadcastEvent("OnInitialize", db, chardb)
	button:SetAttribute("_onmouseup", SNIPPET_VAR_DEF..SNIPPET_CON_STA..SNIPPET_CON_END)

	if IsAddOnLoaded("EasyMount") then
		DisableAddOn("EasyMount") -- Disable the old addon
	end

	self:RegisterTick(1) -- Only delayed checks return correct info
end

function addon:CheckZoneInfo()
	local inInstance, instanceType = IsInInstance()
	if inInstance and (instanceType == "arena" or instanceType == "pvp") then
		self:SetAttribute("battleground", 1)
	else
		self:SetAttribute("battleground", nil)
	end

    local mapInfo = C_Map.GetMapInfo(C_Map.GetBestMapForUnit("player"))
    local instanceID = select(4, UnitPosition("player"))

	if (mapInfo.mapType == Enum.UIMapType.Cosmic and not IsInInstance()) or (instanceID == 1116 and not self.db.draenorFlyable) or (instanceID == 1220 and not self.db.legionFlyable) then
		self:SetAttribute("flyForbidden", 1)
	else
		self:SetAttribute("flyForbidden", nil)
	end
end

local tickCount = 0
function addon:OnTick()
	tickCount = tickCount + 1
	self:CheckZoneInfo()
	if tickCount > 30 then
		self:UnregisterTick()
	end
end

function addon:ZONE_CHANGED_NEW_AREA()
	self:CheckZoneInfo()
	self:UnregisterTick() -- This is the real ZONE_CHANGED_NEW_AREA event so cancel all pending checks
end

addon:RegisterOptionCallback("draenorFlyable", function(value)
	addon:CheckZoneInfo()
end)

addon:RegisterOptionCallback("legionFlyable", function(value)
	addon:CheckZoneInfo()
end)

function addon:OnLeaveCombat()
	local attr, value
	for attr, value in pairs(pendingAttributes) do
		button:SetAttribute(attr, value)
	end
	wipe(pendingAttributes)
end