------------------------------------------------------------
-- OptionFrames.lua
--
-- Abin
-- 2014/10/21
------------------------------------------------------------

local format = format
local type = type
local GetBindingKey = GetBindingKey
local GetItemInfo = GetItemInfo
local OPTION_TOOLTIP_AUTO_LOOT_NONE_KEY = OPTION_TOOLTIP_AUTO_LOOT_NONE_KEY

local addonName, addon = ...
_G.IntelliMount = addon

local L = addon.L

BINDING_HEADER_INTELLIMOUNT_TITLE = "IntelliMount"
BINDING_NAME_INTELLIMOUNT_HOTKEY1 = L["summon regular mount"]
BINDING_NAME_INTELLIMOUNT_HOTKEY2 = L["summon passenger mount"]
BINDING_NAME_INTELLIMOUNT_HOTKEY3 = L["summon vendors mount"]
BINDING_NAME_INTELLIMOUNT_HOTKEY4 = L["summon water strider"]

addon.db = {}

local frame = UICreateInterfaceOptionPage("IntelliMountOptionFrame", "IntelliMount", L["desc"])
addon.optionFrame = frame

local group = frame:CreateMultiSelectionGroup(L["summon regular mount"])
frame:AnchorToTopLeft(group, 0, -16)

local TRAVEL_FORM = GetSpellInfo(783) -- "Travel Form"
local WOLF_FORM = GetSpellInfo(2645) -- "Ghost Wolf"
local MAGIC_BROOM = GetSpellInfo(47977) -- "Magic Broom"
local ABYSS_SEAHORSE = GetSpellInfo(75207) -- "Abyssal Seahorse"

--[[
-- For taking an enUS screenshot...
local TRAVEL_FORM = "Travel Form"
local WOLF_FORM = "Ghost Wolf"
local MAGIC_BROOM = "Magic Broom"
local ABYSS_SEAHORSE = "Abyssal Seahorse"
--]]

local function CreateDummyCheck(text)
	local button = group:AddButton(text)
	button:Disable()
	button.text:SetTextColor(1, 1, 1)
	return button
end

CreateDummyCheck(format(L["tavel or wolf in combat"], TRAVEL_FORM, WOLF_FORM))
group:AddButton(format(L["prefer travel form"], TRAVEL_FORM), "travelFormFirst", 1)
group:AddButton(format(L["prefer seahorse"], ABYSS_SEAHORSE), "seahorseFirst", 1)
local dragonwrathButton = group:AddButton(format(L["prefer dragonwrath"], addon:GetDragonwrathName()), "dragonwrathFirst", 1)
group:AddButton(format(L["prefer magic broom"], MAGIC_BROOM), "broomFirst", 1)
CreateDummyCheck(L["summon system random mounts otherwise"])

group.buttonId = 1
group.hotkeyText = frame:CreateFontString(nil, "ARTWORK", "GameFontGreen")
group.hotkeyText:SetPoint("LEFT", group, "RIGHT", 4, 0)

function group:OnCheckInit(value)
	if value then
		return addon.db[value]
	end

	return 1
end

function group:OnCheckChanged(value, checked)
	addon.db[value] = checked
	addon:UpdateAttributes()
end

local comboBoxes = {}

local function Combo_OnComboInit(self)
	return addon.db[self.dbKey]
end

local function Combo_OnComboChanged(self, value)
	if value then
		addon.db[self.dbKey] = value
		addon:UpdateAttributes()
	end
end

local function Combo_UpdateStats(self)
	local i
	for i = 1, self:NumLines() do
		local data = self:GetLineData(i)
		data.disabled = not addon:IsMountLearned(data.value)
	end
end

local function Combo_UpdateHotkeyText(self)
	self.hotkeyText:SetText("<"..(GetBindingKey("INTELLIMOUNT_HOTKEY"..self.buttonId) or OPTION_TOOLTIP_AUTO_LOOT_NONE_KEY)..">")
end

local function CreateMountCombo(text, buttonId, dbKey, dataKey)
	local combo = frame:CreateComboBox(text, nil, 1)
	tinsert(comboBoxes, combo)
	combo:SetWidth(240)
	combo.buttonId, combo.dbKey = buttonId, dbKey

	if buttonId == 2 then
		combo:SetPoint("TOPLEFT", group[-1], "BOTTOMLEFT", 4, -40)
	else
		local prev = comboBoxes[buttonId - 2]
		combo:SetPoint("TOPLEFT", prev, "BOTTOMLEFT", 0, -40)
	end

	local hotkeyText = frame:CreateFontString(nil, "ARTWORK", "GameFontGreen")
	combo.hotkeyText = hotkeyText
	hotkeyText:SetPoint("LEFT", combo.text, "RIGHT", 4, 0)

	local i
	for i = 1, addon:GetNumUtilityMounts() do
		local data = addon:GetUtilityMountData(i)
		if data[dataKey] then
			combo:AddLine(data.name, data.name, data.icon)
		end
	end

	combo.OnComboInit = Combo_OnComboInit
	combo.OnComboChanged = Combo_OnComboChanged

	return combo
end

CreateMountCombo(L["summon passenger mount"], 2, "passengerMount", "passenger")
CreateMountCombo(L["summon vendors mount"], 3, "vendorMount", "vendor")
CreateMountCombo(L["summon water strider"], 4, "waterStrider", "water")

frame:SetScript("OnShow", function(self)
	Combo_UpdateHotkeyText(group)
	dragonwrathButton.text:SetText(format(L["prefer dragonwrath"], addon:GetDragonwrathName()))
	addon:UpdateUtilityMounts()

	local _, combo
	for _, combo in ipairs(comboBoxes) do
		Combo_UpdateStats(combo)
		Combo_UpdateHotkeyText(combo)
	end

	--[[
	-- For taking an enUS screenshot...
	comboBoxes[1].dropdown.text:SetText("X-53 Touring Rocket")
	comboBoxes[2].dropdown.text:SetText("Traveler's Tundra Mammoth")
	comboBoxes[3].dropdown.text:SetText("Azure Water Strider")
	--]]
end)

frame:RegisterEvent("ADDON_LOADED")
frame:SetScript("OnEvent", function(self, event, arg1)
	if event == "ADDON_LOADED" and arg1 == addonName then
		if type(IntelliMountDB) ~= "table" then
			IntelliMountDB = { travelFormFirst = 1, seahorseFirst = 1, dragonwrathFirst = 1, broomFirst = 1 }
		end

		addon.db = IntelliMountDB
		addon:UpdateBindings()
		addon:UpdateAttributes()
	end
end)

SLASH_INTELLIMOUNT1 = "/intellimount"
SLASH_INTELLIMOUNT2 = "/inm"
SlashCmdList["INTELLIMOUNT"] = function()
	frame:Open()
end