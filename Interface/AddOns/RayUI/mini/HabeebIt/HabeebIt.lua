local _, ns = ...

local currentEncounterID
local itemButtons = {}

local BACKDROP = {
	bgFile = [=[Interface\ChatFrame\ChatFrameBackground]=], tile = true, tileSize = 16,
	edgeFile = [=[Interface\Tooltips\UI-Tooltip-Border]=], edgeSize = 16,
	insets = {left = 4, right = 4, top = 4, bottom = 4}
}

local Container = CreateFrame("Frame", "HabeebItContainer", BonusRollFrame)
local Handle = CreateFrame("Button", "HabeebItHandle", BonusRollFrame)

local Hotspot = CreateFrame("Frame", nil, BonusRollFrame)
local Buttons = CreateFrame("Frame", "HabeebItSpecButtons", Hotspot)
Buttons:Hide()

local function SpecButtonClick(self)
	SetLootSpecialization(self.specID)
	Buttons:Hide()
	BonusRollFrame.SpecIcon:SetDesaturated(false)
end

local function SpecButtonEnter(self)
	GameTooltip:SetOwner(self, "ANCHOR_TOP")
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
				SpecButton:Point("LEFT", index * 28, 0)
				SpecButton:SetSize(22, 22)
				SpecButton:SetScript("OnClick", SpecButtonClick)
				SpecButton:SetScript("OnEnter", SpecButtonEnter)
				SpecButton:SetScript("OnLeave", GameTooltip_Hide)

				SpecButton.specID = specID
				SpecButton.name = name

				local Icon = SpecButton:CreateTexture(nil, "OVERLAY", nil, 1)
				Icon:SetTexCoord(0.08, .92, .08, .92)
				Icon:SetAllPoints()
				Icon:SetTexture(texture)

				local Ring = SpecButton:CreateTexture(nil, "OVERLAY", nil, 2)
				Ring:Point("TOPLEFT", -6, 6)
				Ring:SetSize(58, 58)
				Ring:SetTexture([=[Interface\Minimap\Minimap-TrackingBorder]=])
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

local collapsed = true
local function HandleClick()
	Handle:ClearAllPoints()

	if(collapsed) then
		Handle.Arrow:SetTexture("Interface\\AddOns\\RayUI\\media\\arrow-left-active")
		Handle:Point("LEFT", BonusRollFrame, "RIGHT", 288, 0)
		Container:Show()
	else
		Handle.Arrow:SetTexture("Interface\\AddOns\\RayUI\\media\\arrow-right-active")
		Handle:Point("LEFT", BonusRollFrame, "RIGHT", 1, 0)
		Container:Hide()
	end

	collapsed = not collapsed
end

function Container:HandleUpdate()
	self:ClearAllPoints()
	self:Point("TOPLEFT", BonusRollFrame, "TOPRIGHT", 1, 0)
	Handle.Arrow:SetTexture("Interface\\AddOns\\RayUI\\media\\arrow-right-active")
	Handle.TopCenter:Show()
	Handle.TopRight:Show()
	Handle.TopLeft:Show()
	Handle.BottomCenter:Hide()
	Handle.BottomRight:Hide()
	Handle.BottomLeft:Hide()
	self:Hide()
	collapsed = true
end

local function HookStartRoll()
	-- local specID = GetLootSpecialization()
	-- if(not specID or specID == 0) then
		-- SetLootSpecialization(GetSpecializationInfo(GetSpecialization()))
	-- end
end

local function ItemButtonUpdate(self, elapsed)
	if(IsModifiedClick("COMPAREITEMS")) then
		GameTooltip_ShowCompareItem()
	else
		ShoppingTooltip1:Hide()
		ShoppingTooltip2:Hide()
		ShoppingTooltip3:Hide()
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
	GameTooltip:Point("TOPLEFT", Container, "TOPRIGHT", 0, 2)
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
		ItemButton = CreateFrame("Button", nil, Container)
		ItemButton:SetSize(276, 38)

		local Icon = ItemButton:CreateTexture(nil, "ARTWORK")
		Icon:SetTexCoord(.08, .92, .08, .92)
		Icon:Point("TOPLEFT", 1, -1)
		Icon:SetSize(36, 36)
		Icon.b = S:CreateBG(Icon)
		ItemButton.Icon = Icon

		local Background = ItemButton:CreateTexture(nil, "BORDER")
		Background:SetAllPoints()
		Background:SetTexture([[Interface\EncounterJournal\UI-EncounterJournalTextures]])
		Background:SetTexCoord(0.00195313, 0.62890625, 0.61816406, 0.66210938)
		Background:SetDesaturated(true)

		local Name = ItemButton:CreateFontString(nil, "ARTWORK", "GameFontNormalMed3")
		Name:Point("TOPLEFT", Icon, "TOPRIGHT", 7, -4)
		Name:Point("TOPRIGHT", -6, -4)
		Name:SetHeight(12)
		Name:SetJustifyH("LEFT")
		ItemButton.Name = Name

		local Class = ItemButton:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
		Class:Point("BOTTOMRIGHT", Name, "TOPLEFT", 224, -28)
		Class:SetSize(0, 12)
		Class:SetJustifyH("RIGHT")
		ItemButton.Class = Class

		local Slot = ItemButton:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
		Slot:Point("BOTTOMLEFT", Icon, "BOTTOMRIGHT", 7, 4)
		Slot:Point("BOTTOMRIGHT", Class, "BOTTOMLEFT", -15, 0)
		Slot:SetSize(0, 12)
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
		if(encounterID == currentEncounterID) then
			numItems = numItems + 1

			local ItemButton = GetItemLine(numItems)
			ItemButton.Icon:SetTexture(texture)
			ItemButton.Name:SetText(name)
			ItemButton.Slot:SetText(slot)
			ItemButton.Class:SetText(itemClass)

			ItemButton.itemID = itemID
			ItemButton.itemLink = itemLink
			ItemButton:Point("TOP", 0, (6 + ((numItems - 1) * 40)) * -1)
			ItemButton:Show()
		end
	end

	self:SetHeight(math.max(50, 10 + (numItems * 40)))

	if(numItems > 0) then
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

	for index, button in pairs(itemButtons) do
		button:Hide()
	end

	local _, _, difficulty = GetInstanceInfo()
	EJ_SetDifficulty(difficulty > 2 and (difficulty - 2) or 1)

	local currentInstance = EJ_GetCurrentInstance()
	EJ_SelectInstance(currentInstance > 0 and currentInstance or 322)
	EJ_SelectEncounter(currentEncounterID)

	local _, _, classID = UnitClass("player")
	EJ_SetLootFilter(classID, GetLootSpecialization() or GetSpecializationInfo(GetSpecialization() or 0) or 0)

	self:Populate()
end

function Container:Initialize()
	collapsed = false
	HandleClick()

	Container:Update()
end

function Container:EJ_LOOT_DATA_RECIEVED(event)
	if(EncounterJournal) then
		EncounterJournal:UnregisterEvent(event)
	end

	self:Populate()
end

function Container:PLAYER_LOOT_SPEC_UPDATED(event)
	self:Update()
end

function Container:SPELL_CONFIRMATION_PROMPT(event, spellID, confirmType)
	if(confirmType == CONFIRMATION_PROMPT_BONUS_ROLL) then
		currentEncounterID = ns.GetEncounterID(spellID)

		if(currentEncounterID) then
			self:RegisterEvent("EJ_LOOT_DATA_RECIEVED")
			self:RegisterEvent("PLAYER_LOOT_SPEC_UPDATED")

			self:Initialize()
		else
			print("|cffff8080HabeebIt:|r Found an unknown spell [" .. spellID .. "]. Please report this!")
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

	self:Point("TOPLEFT", BonusRollFrame, "TOPRIGHT", 1, 0)
	Handle:Point("LEFT", BonusRollFrame, "RIGHT", 1, 0)

	self:SetWidth(286)
	self:SetFrameLevel(self:GetParent():GetFrameLevel() - 2)
	self:SetBackdrop(BACKDROP)
	self:SetBackdropColor(0, 0, 0, 0.8)
	self:SetBackdropBorderColor(2/3, 2/3, 2/3)

	self:RegisterEvent("SPELL_CONFIRMATION_PROMPT")
	self:RegisterEvent("SPELL_CONFIRMATION_TIMEOUT")

	local Empty = self:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
	Empty:SetPoint("CENTER")
	Empty:SetText("This encounter has no possible items for\nyour current class and/or specialization.")
	self.Empty = Empty

	Handle:SetSize(16, 64)
	Handle:SetScript("OnClick", HandleClick)
	Handle.Arrow = Handle:GetNormalTexture()
	Handle.Arrow = Handle:CreateTexture(nil, "ARTWORK")
	Handle.Arrow:Size(8, 8)
	Handle.Arrow:SetPoint("CENTER")
	Handle.Arrow:SetVertexColor(1, 1, 1)

	local HandleBackground = Handle:CreateTexture(nil, "BACKGROUND")
	HandleBackground:SetAllPoints()
	HandleBackground:SetTexture(0, 0, 0, 0.8)

	local TopCenter = Handle:CreateTexture(nil, "BORDER")
	TopCenter:Point("TOP", 0, 4.5)
	TopCenter:SetSize(24, 12)
	TopCenter:SetTexture([=[Interface\RaidFrame\RaidPanel-UpperMiddle]=])
	Handle.TopCenter = TopCenter

	local TopRight = Handle:CreateTexture(nil, "BORDER")
	TopRight:Point("TOPRIGHT", 4, 4)
	TopRight:SetSize(24, 20)
	TopRight:SetTexture([=[Interface\RaidFrame\RaidPanel-UpperRight]=])
	TopRight:SetTexCoord(0, 1, 0, 0.8)
	Handle.TopRight = TopRight

	local TopLeft = Handle:CreateTexture(nil, "BORDER")
	TopLeft:Point("TOPLEFT", -4, 4)
	TopLeft:SetSize(24, 20)
	TopLeft:SetTexture([=[Interface\RaidFrame\RaidPanel-UpperLeft]=])
	TopLeft:SetTexCoord(0, 1, 0, 0.8)
	Handle.TopLeft = TopLeft

	local BottomCenter = Handle:CreateTexture(nil, "BORDER")
	BottomCenter:Point("BOTTOM", 0, -9)
	BottomCenter:SetSize(24, 12)
	BottomCenter:SetTexture([=[Interface\RaidFrame\RaidPanel-BottomMiddle]=])
	Handle.BottomCenter = BottomCenter

	local BottomRight = Handle:CreateTexture(nil, "BORDER")
	BottomRight:Point("BOTTOMRIGHT", 4, -6)
	BottomRight:SetSize(24, 22)
	BottomRight:SetTexture([=[Interface\RaidFrame\RaidPanel-BottomRight]=])
	BottomRight:SetTexCoord(0, 1, 0.1, 1)
	Handle.BottomRight = BottomRight

	local BottomLeft = Handle:CreateTexture(nil, "BORDER")
	BottomLeft:Point("BOTTOMLEFT", -4, -6)
	BottomLeft:SetSize(24, 22)
	BottomLeft:SetTexture([=[Interface\RaidFrame\RaidPanel-BottomLeft]=])
	BottomLeft:SetTexCoord(0, 1, 0.1, 1)
	Handle.BottomLeft = BottomLeft

	self:HandleUpdate()

	Hotspot:SetAllPoints(BonusRollFrame.SpecIcon)
	Hotspot:SetScript("OnEnter", HotspotEnter)
	Hotspot:SetScript("OnLeave", HotspotLeave)

	Buttons:Point("LEFT", 4, 4)
	Buttons:SetScript("OnLeave", ButtonsLeave)

	hooksecurefunc("BonusRollFrame_StartBonusRoll", HookStartRoll)

	S:Reskin(Handle)
	S:CreateBD(Container)
end

Container:RegisterEvent("PLAYER_LOGIN")
Container:SetScript("OnEvent", function(self, event, ...) self[event](self, event, ...) end)

SLASH_TestHabeebIt1 = "/test"
SlashCmdList.TestHabeebIt = function()
	BonusRollFrame_StartBonusRoll(123, "123", 120)
	-- Container:SPELL_CONFIRMATION_PROMPT("SPELL_CONFIRMATION_PROMPT", 139691, CONFIRMATION_PROMPT_BONUS_ROLL)
	local numItems = 0
	for index = 1, 6 do
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
		ItemButton:Point("TOP", 0, (6 + ((numItems - 1) * 40)) * -1)

		ItemButton:Show()
	end

	Container:SetHeight(math.max(50, 10 + (numItems * 40)))

	if(numItems > 0) then
		Container.Empty:Hide()
	else
		Container.Empty:Show()
	end
end
