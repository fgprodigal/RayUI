local _, ns = ...
local currentEncounterID
local itemButtons = {}

local BACKDROP = {
	bgFile = [[Interface\ChatFrame\ChatFrameBackground]], tile = true, tileSize = 16,
	edgeFile = [[Interface\Tooltips\UI-Tooltip-Border]], edgeSize = 16,
	insets = {left = 4, right = 4, top = 4, bottom = 4}
}

local Container = CreateFrame("Frame", "BonusRollPreviewContainer", BonusRollFrame)
local Handle = CreateFrame("Button", "BonusRollPreviewHandle", BonusRollFrame)

local Hotspot = CreateFrame("Frame", nil, BonusRollFrame)
local Buttons = CreateFrame("Frame", "BonusRollPreviewSpecButtons", Hotspot)
Buttons:Hide()

local function SpecButtonClick(self)
	SetLootSpecialization(self.specID)
	Buttons:Hide()
	BonusRollFrame.SpecIcon:SetDesaturated(false)
end

local function SpecButtonEnter(self)
	GameTooltip:SetOwner(self, "ANCHOR_TOPRIGHT")
	GameTooltip:AddLine(self.name, 1, 1, 1)
	GameTooltip:Show()
end

local specButtons
local function HotspotEnter()
	if(not Buttons:IsShown()) then
		if(not specButtons) then
			local numSpecs = GetNumSpecializations()
			for index = 1, numSpecs do
				local specID, name, _, texture = GetSpecializationInfo(index)

				local SpecButton = CreateFrame("Button", nil, Buttons)
				SpecButton:SetPoint("LEFT", index * 28, 0)
				SpecButton:SetSize(22, 22)
				SpecButton:SetScript("OnClick", SpecButtonClick)
				SpecButton:SetScript("OnEnter", SpecButtonEnter)
				SpecButton:SetScript("OnLeave", GameTooltip_Hide)
				SpecButton:SetHighlightTexture([[Interface\Minimap\UI-Minimap-ZoomButton-Highlight]])

				SpecButton.specID = specID
				SpecButton.name = name

				local Icon = SpecButton:CreateTexture(nil, "OVERLAY", nil, 1)
				Icon:SetTexCoord(0.08, .92, .08, .92)
				Icon:SetAllPoints()
				Icon:SetTexture(texture)

				local Bg = RayUI[1]:GetModule("Skins"):CreateBG(SpecButton)
			end

			Buttons:SetSize(numSpecs * 28 + 34, 38)

			specButtons = true
		end

		BonusRollFrame.SpecIcon:SetDesaturated(true)
		Buttons:Show()
	end
end

local function HotspotLeave()
	if(not Buttons:IsMouseOver()) then
		BonusRollFrame.SpecIcon:SetDesaturated(false)
		Buttons:Hide()
	end
end

local function ButtonsLeave(self)
	local parent = GetMouseFocus():GetParent()
	if(not Hotspot:IsMouseOver() and not (parent and parent == self)) then
		BonusRollFrame.SpecIcon:SetDesaturated(false)
		self:Hide()
	end
end

local function HookStartRoll(self, frame)
	local specID = GetLootSpecialization()
	if(not specID or specID == 0) then
		SetLootSpecialization(GetSpecializationInfo(GetSpecialization()))
	end
end

local function PositionDownwards()
	return (GetScreenHeight() - (BonusRollFrame:GetTop() or 200)) < 345
end

local collapsed
local function HandleClick(self)
	if(self) then
		collapsed = not collapsed
	else
		collapsed = true
	end

	Handle:ClearAllPoints()
	if(collapsed) then
		if(PositionDownwards()) then
			Handle.Arrow:SetTexture("Interface\\AddOns\\RayUI\\media\\arrow-down-active")
			Handle:SetPoint("TOP", BonusRollFrame, "BOTTOM", 0, 2)
		else
			Handle.Arrow:SetTexture("Interface\\AddOns\\RayUI\\media\\arrow-up-active")
			Handle:SetPoint("BOTTOM", BonusRollFrame, "TOP", 0, -2)
		end

		Container:Hide()
	else
		if(PositionDownwards()) then
			Handle.Arrow:SetTexture("Interface\\AddOns\\RayUI\\media\\arrow-up-active")
			Handle:SetPoint("BOTTOM", Container, 0, -14)
		else
			Handle.Arrow:SetTexture("Interface\\AddOns\\RayUI\\media\\arrow-down-active")
			Handle:SetPoint("TOP", Container, 0, 14)
		end

		Container:Show()
	end
end

local function HandlePosition()
	Container:ClearAllPoints()
	if(PositionDownwards()) then
		Container:SetPoint("TOP", BonusRollFrame, "BOTTOM")

		Handle.Arrow:SetTexture("Interface\\AddOns\\RayUI\\media\\arrow-down-active")
		Handle.TopCenter:Hide()
		Handle.TopRight:Hide()
		Handle.TopLeft:Hide()
		Handle.BottomCenter:Show()
		Handle.BottomRight:Show()
		Handle.BottomLeft:Show()
	else
		Container:SetPoint("BOTTOM", BonusRollFrame, "TOP")

		Handle.Arrow:SetTexture("Interface\\AddOns\\RayUI\\media\\arrow-up-active")
		Handle.TopCenter:Show()
		Handle.TopRight:Show()
		Handle.TopLeft:Show()
		Handle.BottomCenter:Hide()
		Handle.BottomRight:Hide()
		Handle.BottomLeft:Hide()
	end

	HandleClick()
end

local function ItemButtonUpdate(self, elapsed)
	if(IsModifiedClick("COMPAREITEMS") or (GetCVarBool("alwaysCompareItems") and not IsEquippedItem(self.itemID))) then
		GameTooltip_ShowCompareItem()
	else
		ShoppingTooltip1:Hide()
		ShoppingTooltip2:Hide()
	end

	if(IsModifiedClick("DRESSUP")) then
		ShowInspectCursor()
	else
		ResetCursor()
	end
end

local function ItemButtonClick(self)
	HandleModifiedItemClick(self.itemLink)
end

local function ItemButtonEnter(self)
	GameTooltip:SetOwner(Container, "ANCHOR_NONE")
	if PositionDownwards() then
		GameTooltip:Point("BOTTOMLEFT", BonusRollFrame, "TOPLEFT", 0, 2)
	else
		GameTooltip:Point("TOPLEFT", BonusRollFrame, "BOTTOMLEFT", 0, -2)
	end
	GameTooltip:SetItemByID(self.itemID)

	self:SetScript("OnUpdate", ItemButtonUpdate)
end

local function ItemButtonLeave(self)
	GameTooltip:Hide()

	self:SetScript("OnUpdate", nil)
end

local function GetItemLine(index)
	local ItemButton = itemButtons[index]
	if(not ItemButton) then
		local S = RayUI[1]:GetModule("Skins")
		ItemButton = CreateFrame("Button", nil, Container.ScrollChild)
		ItemButton:Point("TOPLEFT", 6, (index - 1) * -40)
		ItemButton:Point("TOPRIGHT", -22, (index - 1) * -40)
		ItemButton:Height(38)

		local Icon = ItemButton:CreateTexture(nil, "ARTWORK")
		Icon:SetTexCoord(.08, .92, .08, .92)
		Icon:Point("TOPLEFT", 1, -1)
		Icon:Size(36, 36)
		Icon.b = S:CreateBG(Icon)
		ItemButton.Icon = Icon

		local Name = ItemButton:CreateFontString(nil, "ARTWORK", "GameFontNormalMed3")
		Name:Point("TOPLEFT", Icon, "TOPRIGHT", 7, -4)
		Name:Point("TOPRIGHT", -6, -4)
		Name:Height(12)
		Name:SetJustifyH("LEFT")
		ItemButton.Name = Name

		local Class = ItemButton:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
		Class:Point("BOTTOMRIGHT", -6, 5)
		Class:Size(0, 12)
		Class:SetJustifyH("RIGHT")
		ItemButton.Class = Class

		local Slot = ItemButton:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
		Slot:Point("BOTTOMLEFT", Icon, "BOTTOMRIGHT", 7, 4)
		Slot:Point("BOTTOMRIGHT", Class, "BOTTOMLEFT", -15, 0)
		Slot:Size(0, 12)
		Slot:SetJustifyH("LEFT")
		ItemButton.Slot = Slot

		ItemButton:SetScript("OnClick", ItemButtonClick)
		ItemButton:SetScript("OnEnter", ItemButtonEnter)
		ItemButton:SetScript("OnLeave", ItemButtonLeave)

		itemButtons[index] = ItemButton
	end

	return ItemButton
end

function Container:Populate()
	local numItems = 0
	for index = 1, EJ_GetNumLoot() do
		local name, texture, slot, itemClass, itemID, itemLink, encounterID = EJ_GetLootInfoByIndex(index)
		if(encounterID == currentEncounterID and not ns.itemBlacklist[itemID]) then
			numItems = numItems + 1

			local ItemButton = GetItemLine(numItems)
			ItemButton.Icon:SetTexture(texture)
			ItemButton.Name:SetText(name)
			ItemButton.Slot:SetText(slot)
			ItemButton.Class:SetText(itemClass)

			ItemButton.itemID = itemID
			ItemButton.itemLink = itemLink

			ItemButton:Show()
		end
	end
	for i = numItems + 1, #itemButtons do
	 	itemButtons[i]:Hide()
	end

	self:SetHeight(math.min(250, math.max(50, 10 + (numItems * 40))))

	if(numItems > 0) then
		local height = (10 + (numItems * 40)) - self:GetHeight()
		self.Slider:SetMinMaxValues(0, height > 0 and height or 0)
		self.Slider:SetValue(0)

		if(numItems > 6) then
			self:EnableMouseWheel(true)
			self.Slider:Show()
			self.ScrollChild:SetWidth(286)
		else
			self:EnableMouseWheel(false)
			self.Slider:Hide()
			self.ScrollChild:SetWidth(302)
		end

		self.Empty:Hide()
	else
		self.Empty:Show()
	end

	if(EncounterJournal) then
		EncounterJournal:RegisterEvent("EJ_LOOT_DATA_RECIEVED")
		EncounterJournal:RegisterEvent("EJ_DIFFICULTY_UPDATE")
	end
end

function Container:Update()
	if(EncounterJournal) then
		EncounterJournal:UnregisterEvent("EJ_DIFFICULTY_UPDATE")
	end

	for index, button in next, itemButtons do
		button:Hide()
	end

	local _, _, difficulty = GetInstanceInfo()
	EJ_SetDifficulty(difficulty > 0 and difficulty or 4)

	local currentInstance = EJ_GetCurrentInstance()
	if(not currentInstance or currentInstance == 0) then
		local oldMap = GetCurrentMapAreaID()
		SetMapToCurrentZone()
		currentInstance = ns.continents[GetCurrentMapContinent()]
		SetMapByID(oldMap)
	end

	EJ_SelectInstance(currentInstance)
	EJ_SelectEncounter(currentEncounterID)

	local _, _, classID = UnitClass("player")
	EJ_SetLootFilter(classID, GetLootSpecialization() or GetSpecializationInfo(GetSpecialization() or 0) or 0)

	self:Populate()
end

function Container:EJ_LOOT_DATA_RECIEVED(event)
	if(EncounterJournal) then
		EncounterJournal:UnregisterEvent(event)
	end

	self:Populate()
end

function Container:PLAYER_LOOT_SPEC_UPDATED(event)
	self:Update()
	HandlePosition()
end

function Container:SPELL_CONFIRMATION_PROMPT(event, spellID, confirmType, _, _, currencyID)
	if(confirmType == CONFIRMATION_PROMPT_BONUS_ROLL) then
		currentEncounterID = ns.encounterIDs[spellID]

		if(currentEncounterID) then
			local _, count = GetCurrencyInfo(currencyID)
			if(count > 0) then
				self:RegisterEvent("EJ_LOOT_DATA_RECIEVED")
				self:RegisterEvent("PLAYER_LOOT_SPEC_UPDATED")
				self:Update()
			end
		else
			print("|cffff8080BonusRollPreview:|r Found an unknown spell [" .. spellID .. "]. Please report this!")
		end
	end
end

function Container:SPELL_CONFIRMATION_TIMEOUT()
	currentEncounterID = nil

	self:UnregisterEvent("EJ_LOOT_DATA_RECIEVED")
	self:UnregisterEvent("PLAYER_LOOT_SPEC_UPDATED")
end

function Container:PLAYER_LOGIN()
	local S = RayUI[1]:GetModule("Skins")
	local ScrollChild = CreateFrame("Frame", nil, self)
	ScrollChild:SetHeight(1)
	self.ScrollChild = ScrollChild

	local Scroll = CreateFrame("ScrollFrame", nil, self)
	Scroll:SetPoint("TOPLEFT", 0, -6)
	Scroll:SetPoint("BOTTOMRIGHT", 0, 6)
	Scroll:SetScrollChild(ScrollChild)

	self:SetWidth(286)
	self:SetFrameLevel(self:GetParent():GetFrameLevel() - 2)
	self:SetBackdrop(BACKDROP)
	self:SetBackdropColor(0, 0, 0, 0.8)
	self:SetBackdropBorderColor(2/3, 2/3, 2/3)
	self:EnableMouseWheel(true)

	local Slider = CreateFrame("Slider", nil, Scroll)
	Slider:SetPoint("TOPRIGHT", -5, -16)
	Slider:SetPoint("BOTTOMRIGHT", -5, 14)
	Slider:SetWidth(16)
	Slider:SetFrameLevel(self:GetFrameLevel() + 10)
	Slider:SetThumbTexture([[Interface\Buttons\UI-ScrollBar-Knob]])
	self.Slider = Slider

	local Thumb = Slider:GetThumbTexture()
	Thumb:SetAlpha(0)
	Thumb:Width(17)
	Thumb.bg = CreateFrame("Frame", nil, Scroll)
	Thumb.bg:Point("TOPLEFT", Thumb, 0, -2)
	Thumb.bg:Point("BOTTOMRIGHT", Thumb, 0, 4)
	S:CreateBD(Thumb.bg, 0)
	S:CreateBackdropTexture(Scroll)
	Scroll.backdropTexture:SetInside(Thumb.bg, 1, 1)

	local Up = CreateFrame("Button", nil, Slider)
	Up:SetPoint("BOTTOM", Slider, "TOP")
	Up:Size(17, 17)
	Up:SetScript("OnClick", function()
		Slider:SetValue(Slider:GetValue() - Slider:GetHeight() / 3)
	end)
	local uptex = Up:CreateTexture(nil, "ARTWORK")
	uptex:SetTexture("Interface\\AddOns\\RayUI\\media\\arrow-up-active")
	uptex:Size(8, 8)
	uptex:SetPoint("CENTER")
	uptex:SetVertexColor(1, 1, 1)
	S:Reskin(Up)

	local Down = CreateFrame("Button", nil, Slider)
	Down:SetPoint("TOP", Slider, "BOTTOM")
	Down:Size(17, 17)
	Down:SetScript("OnClick", function()
		Slider:SetValue(Slider:GetValue() + Slider:GetHeight() / 3)
	end)
	local uptex = Down:CreateTexture(nil, "ARTWORK")
	uptex:SetTexture("Interface\\AddOns\\RayUI\\media\\arrow-down-active")
	uptex:Size(8, 8)
	uptex:SetPoint("CENTER")
	uptex:SetVertexColor(1, 1, 1)
	S:Reskin(Down)

	Slider:SetScript("OnValueChanged", function(self, value)
		local min, max = self:GetMinMaxValues()
		if(value == min) then
			Up:Disable()
		else
			Up:Enable()
		end

		if(value == max) then
			Down:Disable()
		else
			Down:Enable()
		end

		local Parent = self:GetParent()
		Parent:SetVerticalScroll(value)
		ScrollChild:SetPoint("TOP", 0, value)
	end)

	Scroll:SetScript("OnMouseWheel", function(self, alpha)
		if(alpha > 0) then
			Slider:SetValue(Slider:GetValue() - Slider:GetHeight() / 3)
		else
			Slider:SetValue(Slider:GetValue() + Slider:GetHeight() / 3)
		end
	end)

	local Empty = self:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
	Empty:SetPoint("CENTER")
	Empty:SetText("This encounter has no possible items for\nyour current class and/or specialization.")
	self.Empty = Empty

	Handle:SetSize(64, 16)
	Handle:SetScript("OnClick", HandleClick)
	Handle.Arrow = Handle:CreateTexture(nil, "ARTWORK")
	Handle.Arrow:Size(8, 8)
	Handle.Arrow:SetPoint("CENTER")
	Handle.Arrow:SetVertexColor(1, 1, 1)

	local HandleBackground = Handle:CreateTexture(nil, "BACKGROUND")
	HandleBackground:SetAllPoints()
	HandleBackground:SetTexture(0, 0, 0, 0.8)

	local TopCenter = Handle:CreateTexture(nil, "BORDER")
	TopCenter:SetPoint("TOP", 0, 4.5)
	TopCenter:SetSize(24, 12)
	TopCenter:SetTexture([[Interface\RaidFrame\RaidPanel-UpperMiddle]])
	Handle.TopCenter = TopCenter

	local TopRight = Handle:CreateTexture(nil, "BORDER")
	TopRight:SetPoint("TOPRIGHT", 4, 4)
	TopRight:SetSize(24, 20)
	TopRight:SetTexture([[Interface\RaidFrame\RaidPanel-UpperRight]])
	TopRight:SetTexCoord(0, 1, 0, 0.8)
	Handle.TopRight = TopRight

	local TopLeft = Handle:CreateTexture(nil, "BORDER")
	TopLeft:SetPoint("TOPLEFT", -4, 4)
	TopLeft:SetSize(24, 20)
	TopLeft:SetTexture([[Interface\RaidFrame\RaidPanel-UpperLeft]])
	TopLeft:SetTexCoord(0, 1, 0, 0.8)
	Handle.TopLeft = TopLeft

	local BottomCenter = Handle:CreateTexture(nil, "BORDER")
	BottomCenter:SetPoint("BOTTOM", 0, -9)
	BottomCenter:SetSize(24, 12)
	BottomCenter:SetTexture([[Interface\RaidFrame\RaidPanel-BottomMiddle]])
	Handle.BottomCenter = BottomCenter

	local BottomRight = Handle:CreateTexture(nil, "BORDER")
	BottomRight:SetPoint("BOTTOMRIGHT", 4, -6)
	BottomRight:SetSize(24, 22)
	BottomRight:SetTexture([[Interface\RaidFrame\RaidPanel-BottomRight]])
	BottomRight:SetTexCoord(0, 1, 0.1, 1)
	Handle.BottomRight = BottomRight

	local BottomLeft = Handle:CreateTexture(nil, "BORDER")
	BottomLeft:SetPoint("BOTTOMLEFT", -4, -6)
	BottomLeft:SetSize(24, 22)
	BottomLeft:SetTexture([[Interface\RaidFrame\RaidPanel-BottomLeft]])
	BottomLeft:SetTexCoord(0, 1, 0.1, 1)
	Handle.BottomLeft = BottomLeft

	Hotspot:SetAllPoints(BonusRollFrame.SpecIcon)
	Hotspot:SetScript("OnEnter", HotspotEnter)
	Hotspot:SetScript("OnLeave", HotspotLeave)

	Buttons:SetPoint("LEFT", 4, 4)
	Buttons:SetScript("OnLeave", ButtonsLeave)

	self:RegisterEvent("SPELL_CONFIRMATION_PROMPT")
	self:RegisterEvent("SPELL_CONFIRMATION_TIMEOUT")

	hooksecurefunc("BonusRollFrame_StartBonusRoll", HookStartRoll)
	hooksecurefunc(BonusRollFrame, "SetPoint", HandlePosition)

	S:Reskin(Handle)
	S:CreateBD(Container)
end

Container:SetScript("OnEvent", function(self, event, ...) self[event](self, event, ...) end)
Container:RegisterEvent("PLAYER_LOGIN")

SLASH_TestBonusRollPreview1 = "/testbonusroll"
SlashCmdList.TestBonusRollPreview = function()
	BonusRollFrame_StartBonusRoll(123, "123", 120)
	Container:SPELL_CONFIRMATION_PROMPT("SPELL_CONFIRMATION_PROMPT", 139691, CONFIRMATION_PROMPT_BONUS_ROLL, nil, nil, 0)
	local numItems = 0
	for index = 1, 8 do
		local itemID = 94522
		local name, itemLink, _ , _ , _ , _ , _ , _ , _ , texture = GetItemInfo(itemID)
		local slot, itemClass = "Trinket", "Rogue"
		numItems = numItems + 1

		local ItemButton = GetItemLine(numItems)
		ItemButton.Icon:SetTexture(texture)
		ItemButton.Name:SetText(name)
		ItemButton.Slot:SetText(slot)
		ItemButton.Class:SetText(itemClass)

		ItemButton.itemID = itemID
		ItemButton.itemLink = itemLink

		ItemButton:Show()
	end

	Container:SetHeight(math.min(250, math.max(50, 10 + (numItems * 40))))

	if(numItems > 0) then
		local height = (10 + (numItems * 40)) - Container:GetHeight()
		Container.Slider:SetMinMaxValues(0, height > 0 and height or 0)
		Container.Slider:SetValue(0)

		if(numItems > 6) then
			Container:EnableMouseWheel(true)
			Container.Slider:Show()
			Container.ScrollChild:SetWidth(286)
		else
			Container:EnableMouseWheel(false)
			Container.Slider:Hide()
			Container.ScrollChild:SetWidth(302)
		end

		Container.Empty:Hide()
	else
		Container.Empty:Show()
	end
end