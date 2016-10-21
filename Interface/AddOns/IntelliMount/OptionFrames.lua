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
local NOT_BOUND = NOT_BOUND

local _, addon = ...
local L = addon.L

addon.db = {}

local frame = UICreateInterfaceOptionPage("IntelliMountOptionFrame", "IntelliMount", L["desc"])
addon.optionFrame = frame

local group = frame:CreateMultiSelectionGroup(L["summon regular mount"])
frame:AnchorToTopLeft(group, 0, -10)

group:AddButton(L["draenor fly unlocked"], "draenorFlyable", 1)
group:AddButton(L["legion fly unlocked"], "legionFlyable", 1)
group:AddDummy(format(L["auto specia forms"], addon:QueryName("Travel Form"), addon:QueryName("Cat Form"), addon:QueryName("Ghost Wolf")), 1)
group:AddButton(format(L["prefer travel form"], addon:QueryName("Travel Form")), "travelFormFirst", 1)
group:AddButton(format(L["prefer seahorse"], addon:QueryName("Abyssal Seahorse")), "seahorseFirst", 1)
local dragonwrathButton = group:AddButton(format(L["prefer dragonwrath"], addon:QueryName("Dragonwrath, Tarecgosa's Rest")), "dragonwrathFirst", 1)
group:AddButton(format(L["prefer magic broom"], addon:QueryName("Magic Broom")), "broomFirst", 1)
group:AddButton(L["use surface mount if not flyable"], "surfaceIfNotFlable", 1)
group:AddDummy(L["summon system random mounts otherwise"], 1)
group:AddButton(L["enable debug mode"], "debugMode")

group.bindingName = "INTELLIMOUNT_HOTKEY1"
group.hotkeyText = frame:CreateFontString(nil, "ARTWORK", "GameFontGreen")
group.hotkeyText:SetPoint("LEFT", group, "RIGHT", 4, 0)

function group:OnCheckInit(value)
	if value == "surfaceIfNotFlable" then
		return addon.chardb[value]
	else
		return addon.db[value]
	end
end

function group:OnCheckChanged(value, checked)
	if value == "surfaceIfNotFlable" then
		addon.chardb[value] = checked
	else
		addon.db[value] = checked
	end

	addon:BroadcastOptionEvent(value, checked)
end

local comboBoxes = {}

local function Combo_OnComboInit(self)
	return addon.db[self.dbKey]
end

local function Combo_OnComboChanged(self, value)
	if value then
		addon.db[self.dbKey] = value
		addon:BroadcastOptionEvent("utilityMount", self.key, value)
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
	local key = GetBindingKey(self.bindingName)
	self.hotkeyText:SetText("<"..(key or NOT_BOUND)..">")
	if key then
		self.hotkeyText:SetTextColor(0, 1, 0)
	else
		self.hotkeyText:SetTextColor(0.5, 0.5, 0.5)
	end
end

local firstCombo
local function CreateMountCombo(key)
	local button = addon:GetActionButton(key)
	if not button then
		return -- Should never happen
	end

	local combo = frame:CreateComboBox(button.bindingText, nil, 1)
	tinsert(comboBoxes, combo)
	combo:SetWidth(240)
	combo.key = key
	combo.dbKey, combo.bindingName = button.dbKey, button.bindingName

	if button:GetID() == 2 then
		firstCombo = combo
		combo:SetPoint("TOPLEFT", group[-1], "BOTTOMLEFT", 4, -46)
	elseif button:GetID() == 4 then
		combo:SetPoint("LEFT", firstCombo, "RIGHT", 24, 0)
	else
		local prev = comboBoxes[button:GetID() - 2]
		combo:SetPoint("TOPLEFT", prev, "BOTTOMLEFT", 0, -30)
	end

	local hotkeyText = frame:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
	combo.hotkeyText = hotkeyText
	hotkeyText:SetPoint("LEFT", combo.text, "RIGHT", 4, 0)

	local i
	for i = 1, addon:GetNumUtilityMounts() do
		local data = addon:GetUtilityMountData(i)
		if data[key] then
			combo:AddLine(data.name, data.name, data.icon)
		end
	end

	combo.OnComboInit = Combo_OnComboInit
	combo.OnComboChanged = Combo_OnComboChanged

	return combo
end

CreateMountCombo("passenger")
CreateMountCombo("vendor")
CreateMountCombo("surface")
CreateMountCombo("underwater")

frame:SetScript("OnShow", function(self)
	Combo_UpdateHotkeyText(group)
	dragonwrathButton.text:SetText(format(L["prefer dragonwrath"], addon:QueryName("Dragonwrath, Tarecgosa's Rest")))
	addon:UpdateUtilityMounts()

	local _, combo
	for _, combo in ipairs(comboBoxes) do
		Combo_UpdateStats(combo)
		Combo_UpdateHotkeyText(combo)
	end

	-- For taking an enUS screenshot...
	if addon.FORCE_ENUS then
		comboBoxes[1]:SetText("X-53 Touring Rocket")
		comboBoxes[2]:SetText("Traveler's Tundra Mammoth")
		comboBoxes[3]:SetText("Azure Water Strider")
		comboBoxes[4]:SetText("Riding Turtle")
	end
end)

local function InitOption(key, chardb)
	if chardb then
		addon:BroadcastOptionEvent(key, addon.chardb[key])
	else
		addon:BroadcastOptionEvent(key, addon.db[key])
	end
end

addon:RegisterEventCallback("OnInitialize", function(db)
	InitOption("travelFormFirst")
	InitOption("seahorseFirst")
	InitOption("dragonwrathFirst")
	InitOption("broomFirst")
	InitOption("draenorFlyable")
	InitOption("legionFlyable")
	InitOption("surfaceIfNotFlable", 1)
	InitOption("debugMode")

	local _, combo
	for _, combo in ipairs(comboBoxes) do
		addon:BroadcastOptionEvent("utilityMount", combo.key, db[combo.dbKey])
	end
end)

BINDING_HEADER_INTELLIMOUNT_TITLE = "IntelliMount"