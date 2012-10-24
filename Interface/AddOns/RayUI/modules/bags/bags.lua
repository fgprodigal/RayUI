local R, L, P = unpack(RayUI) --Inport: Engine, Locales, ProfileDB
local B = R:NewModule("Bags", "AceHook-3.0", "AceEvent-3.0", "AceTimer-3.0")
local S = R:GetModule("Skins")

B.modName = L["背包"]

function B:GetOptions()
	local options = {
		bagSize = {
			order = 5,
			type = "range",
			name = L["背包格大小"],
			min = 15, max = 45, step = 1,
			set = function(info, value) R.db.Bags[ info[#info] ] = value B:Layout() end,
		},
		bankSize = {
			order = 6,
			type = "range",
			name = L["银行格大小"],
			min = 15, max = 45, step = 1,
			set = function(info, value) R.db.Bags[ info[#info] ] = value B:Layout(true) end,
		},				
		sortInverted = {
			order = 7,
			type = "toggle",
			name = L["逆序整理"],
			set = function(info, value) R.db.Bags[ info[#info] ] = value end,
		},				
		bagWidth = {
			order = 8,
			type = "range",
			name = L["背包面板宽度"],
			min = 150, max = 700, step = 1,
			set = function(info, value) R.db.Bags[ info[#info] ] = value B:Layout()end,
		},
		bankWidth = {
			order = 9,
			type = "range",
			name = L["银行面板宽度"],
			min = 150, max = 700, step = 1,
			set = function(info, value) R.db.Bags[ info[#info] ] = value B:Layout(true) end,
		},
	}
	return options
end

B.ProfessionColors = {
	[0x0008] = {224/255, 187/255, 74/255}, -- Leatherworking
	[0x0010] = {74/255, 77/255, 224/255}, -- Inscription
	[0x0020] = {18/255, 181/255, 32/255}, -- Herbs
	[0x0040] = {160/255, 3/255, 168/255}, -- Enchanting
	[0x0080] = {232/255, 118/255, 46/255}, -- Engineering
	[0x0200] = {8/255, 180/255, 207/255}, -- Gems
	[0x0400] = {105/255, 79/255,  7/255} -- Mining
}

function B:GetContainerFrame(arg)
	if type(arg) == "boolean" and arg == true then
		return self.BankFrame
	elseif type(arg) == "number" then
		if self.BankFrame then
			for _, bagID in ipairs(self.BankFrame.BagIDs) do
				if bagID == arg then
					return self.BankFrame
				end
			end
		end
	end
	return self.BagFrame
end

function B:Tooltip_Show()
	GameTooltip:SetOwner(self:GetParent(), "ANCHOR_TOP", 0, 4)
	GameTooltip:ClearLines()
	GameTooltip:AddLine(self.ttText)
	if self.ttText2 then
		GameTooltip:AddLine(" ")
		GameTooltip:AddDoubleLine(self.ttText2, self.ttText2desc, 1, 1, 1)
	end
	GameTooltip:Show()
end

function B:Tooltip_Hide()
	GameTooltip:Hide()
end

function B:DisableBlizzard()
	BankFrame:UnregisterAllEvents()
	for i=1, NUM_CONTAINER_FRAMES do
		_G["ContainerFrame"..i]:Kill()
	end
end

function B:SearchReset()
	SetItemSearch("")
end

function B:UpdateSearch()
	local MIN_REPEAT_CHARACTERS = 3
	local searchString = self:GetText()
	if (string.len(searchString) > MIN_REPEAT_CHARACTERS) then
		local repeatChar = true
		for i=1, MIN_REPEAT_CHARACTERS, 1 do
			if ( string.sub(searchString,(0-i), (0-i)) ~= string.sub(searchString,(-1-i),(-1-i)) ) then
				repeatChar = false
				break
			end
		end
		if ( repeatChar ) then
			B.ResetAndClear(self)
			return
		end
	end
	SetItemSearch(searchString)
end

function B:OpenEditbox()
	self.BagFrame.detail:Hide()
	self.BagFrame.editBox:Show()
	self.BagFrame.editBox:SetText(SEARCH)
	self.BagFrame.editBox:HighlightText()
end

function B:ResetAndClear()
	self:GetParent().detail:Show()
	self:ClearFocus()
	B:SearchReset()
end

function B:INVENTORY_SEARCH_UPDATE()
	for _, bagFrame in pairs(self.BagFrames) do
		for _, bagID in ipairs(bagFrame.BagIDs) do
			for slotID = 1, GetContainerNumSlots(bagID) do
				local _, _, _, _, _, _, _, isFiltered = GetContainerItemInfo(bagID, slotID)
				local button = bagFrame.Bags[bagID][slotID]
				if button:IsShown() then
					if ( isFiltered ) then
						SetItemButtonDesaturated(button, 1, 1, 1, 1)
						button:SetAlpha(0.4)
					else
						SetItemButtonDesaturated(button, 0, 1, 1, 1)
						button:SetAlpha(1)
					end
				end
			end
		end
	end
end

function B:UpdateSlot(bagID, slotID)
	if (self.Bags[bagID] and self.Bags[bagID].numSlots ~= GetContainerNumSlots(bagID)) or not self.Bags[bagID] or not self.Bags[bagID][slotID] then
		return
	end
	local slot = self.Bags[bagID][slotID]
	local bagType = self.Bags[bagID].type
	local texture, count, locked = GetContainerItemInfo(bagID, slotID)
	local clink = GetContainerItemLink(bagID, slotID)
	local specialType = select(2, GetContainerNumFreeSlots(bagID))
	slot:Show()
	slot.questIcon:Hide()
	slot.name, slot.rarity = nil, nil
	local start, duration, enable = GetContainerItemCooldown(bagID, slotID)
	CooldownFrame_SetTimer(slot.cooldown, start, duration, enable)
	if B.ProfessionColors[bagType] then
		slot.shadow:Show()
		slot.shadow:SetBackdropBorderColor(unpack(B.ProfessionColors[bagType]))
	else
		slot.shadow:Hide()
	end
	if (clink) then
		local iType, _
		slot.name, _, slot.rarity, _, _, iType = GetItemInfo(clink)
		if R:IsItemUnusable(clink) then
			SetItemButtonTextureVertexColor(slot, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b)
		else
			SetItemButtonTextureVertexColor(slot, 1, 1, 1)
		end
		local isQuestItem, questId, isActive = GetContainerItemQuestInfo(bagID, slotID)
		-- color slot according to item quality
		if questId and not isActive then
			slot.iconTexture:SetInside()
			slot:StyleButton()
			slot:SetBackdropColor(0, 0, 0)
			slot.border:SetBackdropBorderColor(1.0, 0.2, 0.2)
			slot.questIcon:Show()
		elseif questId or isQuestItem then
			slot.iconTexture:SetInside()
			slot:StyleButton()
			slot:SetBackdropColor(0, 0, 0)
			slot.border:SetBackdropBorderColor(1.0, 0.2, 0.2)
		elseif slot.rarity and slot.rarity > 1 then
			local r, g, b = GetItemQualityColor(slot.rarity)
			slot.iconTexture:SetInside()
			slot:StyleButton()
			slot:SetBackdropColor(0, 0, 0)
			slot.border:SetBackdropBorderColor(r, g, b)
		else
			slot.iconTexture:SetAllPoints()
			slot:StyleButton(true)
			slot:SetBackdropColor(0, 0, 0, 0, 0)
			slot.border:SetBackdropBorderColor(unpack(R["media"].bordercolor))
		end
	else
		slot.iconTexture:SetAllPoints()
		slot:StyleButton(true)
		slot:SetBackdropColor(0, 0, 0, 0)
		slot.border:SetBackdropBorderColor(unpack(R["media"].bordercolor))
	end
	SetItemButtonTexture(slot, texture)
	SetItemButtonCount(slot, count)
	SetItemButtonDesaturated(slot, locked, 0.5, 0.5, 0.5)
end

function B:UpdateBagSlots(bagID)
	for slotID = 1, GetContainerNumSlots(bagID) do
		if self.UpdateSlot then
			self:UpdateSlot(bagID, slotID)
		else
			self:GetParent():UpdateSlot(bagID, slotID)
		end
	end
end

function B:UpdateCooldowns()
	for _, bagID in ipairs(self.BagIDs) do
         if self.Bags[bagID] then
			for slotID = 1, GetContainerNumSlots(bagID) do
				local start, duration, enable = GetContainerItemCooldown(bagID, slotID)
				CooldownFrame_SetTimer(self.Bags[bagID][slotID].cooldown, start, duration, enable)
			end
         end
	end
end

function B:UpdateAllSlots()
	for _, bagID in ipairs(self.BagIDs) do
		if self.Bags[bagID] then
			self.Bags[bagID]:UpdateBagSlots(bagID)
		end
	end
end

function B:SetSlotAlphaForBag(f)
	for _, bagID in ipairs(f.BagIDs) do
		if f.Bags[bagID] then
			local numSlots = GetContainerNumSlots(bagID)
			for slotID = 1, numSlots do
				if f.Bags[bagID][slotID] then
					if bagID == self.id then
						f.Bags[bagID][slotID]:SetAlpha(1)
					else
						f.Bags[bagID][slotID]:SetAlpha(0.1)
					end
				end
			end
		end
	end
end

function B:ResetSlotAlphaForBags(f)
	for _, bagID in ipairs(f.BagIDs) do
		if f.Bags[bagID] then
			local numSlots = GetContainerNumSlots(bagID)
			for slotID = 1, numSlots do
				if f.Bags[bagID][slotID] then
					f.Bags[bagID][slotID]:SetAlpha(1)
				end
			end
		end
	end
end

function B:Layout(isBank)
	local f = self:GetContainerFrame(isBank)
	if not f then return end
	local buttonSize = isBank and self.db.bankSize or self.db.bagSize
	local buttonSpacing = 4
	local containerWidth = isBank and self.db.bankWidth or self.db.bagWidth
	local numContainerColumns = math.floor(containerWidth / (buttonSize + buttonSpacing))
	local holderWidth = ((buttonSize + buttonSpacing) * numContainerColumns) - buttonSpacing
	local numContainerRows = 0
	local bottomPadding = (containerWidth - holderWidth) / 2
	f.holderFrame:Width(holderWidth)
	f.totalSlots = 0
	local lastButton
	local lastRowButton
	local lastContainerButton
	local numContainerSlots, fullContainerSlots = GetNumBankSlots()
	for i, bagID in ipairs(f.BagIDs) do
		--Bag Containers
		if (not isBank and bagID <= 3 ) or (isBank and bagID ~= -1 and numContainerSlots >= 1 and not (i - 1 > numContainerSlots)) then
			if not f.ContainerHolder[i] then
				if isBank then
					f.ContainerHolder[i] = CreateFrame("CheckButton", "RayUIBankBag" .. bagID - 4, f.ContainerHolder, "BankItemButtonBagTemplate")
				else
					f.ContainerHolder[i] = CreateFrame("CheckButton", "RayUIMainBag" .. bagID .. "Slot", f.ContainerHolder, "BagSlotButtonTemplate")
				end
				f.ContainerHolder[i]:StyleButton(1)
				f.ContainerHolder[i]:SetNormalTexture("")
				f.ContainerHolder[i]:SetCheckedTexture(nil)
				f.ContainerHolder[i]:SetPushedTexture("")
				f.ContainerHolder[i]:SetScript("OnClick", nil)
				f.ContainerHolder[i].id = isBank and bagID or bagID + 1
				f.ContainerHolder[i]:HookScript("OnEnter", function(self) B.SetSlotAlphaForBag(self, f) end)
				f.ContainerHolder[i]:HookScript("OnLeave", function(self) B.ResetSlotAlphaForBags(self, f) end)
				if isBank then
					f.ContainerHolder[i]:SetID(bagID)
					if not f.ContainerHolder[i].tooltipText then
						f.ContainerHolder[i].tooltipText = ""
					end
				end
				f.ContainerHolder[i].iconTexture = _G[f.ContainerHolder[i]:GetName().."IconTexture"]
				f.ContainerHolder[i].iconTexture:SetTexCoord(.08, .92, .08, .92)
				if not f.ContainerHolder[i].border then
					local border = CreateFrame("Frame", nil, f.ContainerHolder[i])
					border:SetAllPoints()
					border:SetFrameLevel(f.ContainerHolder[i]:GetFrameLevel()+1)
					f.ContainerHolder[i].border = border
					f.ContainerHolder[i].border:CreateBorder()
					S:CreateBackdropTexture(f.ContainerHolder[i], 0.6)
				end
			end
			f.ContainerHolder:Size(((buttonSize + buttonSpacing) * (isBank and i - 1 or i)) + buttonSpacing,buttonSize + (buttonSpacing * 2))
			if isBank then
				BankFrameItemButton_Update(f.ContainerHolder[i])
				BankFrameItemButton_UpdateLocked(f.ContainerHolder[i])
			end
			f.ContainerHolder[i]:Size(buttonSize)
			f.ContainerHolder[i]:ClearAllPoints()
			if (isBank and i == 2) or (not isBank and i == 1) then
				f.ContainerHolder[i]:SetPoint("BOTTOMLEFT", f.ContainerHolder, "BOTTOMLEFT", buttonSpacing, buttonSpacing)
			else
				f.ContainerHolder[i]:SetPoint("LEFT", lastContainerButton, "RIGHT", buttonSpacing, 0)
			end
			lastContainerButton = f.ContainerHolder[i]
		end
		--Bag Slots
		local numSlots = GetContainerNumSlots(bagID)
		if numSlots > 0 then
			if not f.Bags[bagID] then
				f.Bags[bagID] = CreateFrame("Frame", f:GetName().."Bag"..bagID, f)
				f.Bags[bagID]:SetID(bagID)
				f.Bags[bagID].UpdateBagSlots = B.UpdateBagSlots
				f.Bags[bagID].UpdateSlot = UpdateSlot
			end
			f.Bags[bagID].numSlots = numSlots
			f.Bags[bagID].type = select(2, GetContainerNumFreeSlots(bagID))
			--Hide unused slots
			for i = 1, MAX_CONTAINER_ITEMS do
				if f.Bags[bagID][i] then
					f.Bags[bagID][i]:Hide()
				end
			end
			for slotID = 1, numSlots do
				f.totalSlots = f.totalSlots + 1
				if not f.Bags[bagID][slotID] then
					f.Bags[bagID][slotID] = CreateFrame("CheckButton", f.Bags[bagID]:GetName().."Slot"..slotID, f.Bags[bagID], bagID == -1 and "BankItemButtonGenericTemplate" or "ContainerFrameItemButtonTemplate")
					f.Bags[bagID][slotID]:SetBackdrop({
						bgFile = R["media"].blank, 
						insets = { left = -R.mult, right = -R.mult, top = -R.mult, bottom = -R.mult }
					})
					if not f.Bags[bagID][slotID].border then
						local border = CreateFrame("Frame", nil, f.Bags[bagID][slotID])
						border:SetAllPoints()
						border:SetFrameLevel(f.Bags[bagID][slotID]:GetFrameLevel()+1)
						f.Bags[bagID][slotID].border = border
						f.Bags[bagID][slotID].border:CreateBorder()
						S:CreateBackdropTexture(f.Bags[bagID][slotID], 0.6)
					end
					if not f.Bags[bagID][slotID].shadow then
						local shadow = CreateFrame("Frame", nil, f.Bags[bagID][slotID])
						shadow:SetOutside(f.Bags[bagID][slotID], 3, 3)
						shadow:SetFrameLevel(0)
						f.Bags[bagID][slotID].shadow = shadow
						f.Bags[bagID][slotID].shadow:SetBackdrop( { 
							edgeFile = R["media"].glow,
							edgeSize = R:Scale(3),
							insets = {left = R:Scale(3), right = R:Scale(3), top = R:Scale(3), bottom = R:Scale(3)},
						})
						f.Bags[bagID][slotID].shadow:SetBackdropColor(unpack(R["media"].bordercolor))
						f.Bags[bagID][slotID].shadow:Hide()
					end
					f.Bags[bagID][slotID]:StyleButton()
					f.Bags[bagID][slotID]:SetNormalTexture(nil)
					f.Bags[bagID][slotID]:SetCheckedTexture(nil)
					f.Bags[bagID][slotID].count:ClearAllPoints()
					f.Bags[bagID][slotID].count:Point("BOTTOMRIGHT", 0, 2)
					f.Bags[bagID][slotID].count:SetFont(R["media"].pxfont, R.mult*10, "OUTLINE,MONOCHROME")
					f.Bags[bagID][slotID].questIcon = _G[f.Bags[bagID][slotID]:GetName().."IconQuestTexture"]
					f.Bags[bagID][slotID].questIcon:SetTexture(TEXTURE_ITEM_QUEST_BANG)
					f.Bags[bagID][slotID].questIcon:SetInside(f.Bags[bagID][slotID])
					f.Bags[bagID][slotID].questIcon:SetTexCoord(.08, .92, .08, .92)
					f.Bags[bagID][slotID].questIcon:Hide()
					f.Bags[bagID][slotID].iconTexture = _G[f.Bags[bagID][slotID]:GetName().."IconTexture"]
					f.Bags[bagID][slotID].iconTexture:SetInside(f.Bags[bagID][slotID])
					f.Bags[bagID][slotID].iconTexture:SetTexCoord(.08, .92, .08, .92)
					f.Bags[bagID][slotID].cooldown = _G[f.Bags[bagID][slotID]:GetName().."Cooldown"]
					f.Bags[bagID][slotID].bagID = bagID
					f.Bags[bagID][slotID].slotID = slotID
				end
				f.Bags[bagID][slotID]:SetID(slotID)
				f.Bags[bagID][slotID]:Size(buttonSize)
				f:UpdateSlot(bagID, slotID)
				if f.Bags[bagID][slotID]:GetPoint() then
					f.Bags[bagID][slotID]:ClearAllPoints()
				end
				if lastButton then
					if (f.totalSlots - 1) % numContainerColumns == 0 then
						f.Bags[bagID][slotID]:Point("TOP", lastRowButton, "BOTTOM", 0, -buttonSpacing)
						lastRowButton = f.Bags[bagID][slotID]
						numContainerRows = numContainerRows + 1
					else
						f.Bags[bagID][slotID]:Point("LEFT", lastButton, "RIGHT", buttonSpacing, 0)
					end
				else
					f.Bags[bagID][slotID]:Point("TOPLEFT", f.holderFrame, "TOPLEFT")
					lastRowButton = f.Bags[bagID][slotID]
					numContainerRows = numContainerRows + 1
				end
				lastButton = f.Bags[bagID][slotID]
			end
		else
			--Hide unused slots
			for i = 1, MAX_CONTAINER_ITEMS do
				if f.Bags[bagID] and f.Bags[bagID][i] then
					f.Bags[bagID][i]:Hide()
				end
			end
			if f.Bags[bagID] then
				f.Bags[bagID].numSlots = numSlots
			end
			if self.isBank then
				if self.ContainerHolder[i] then
					BankFrameItemButton_Update(self.ContainerHolder[i])
					BankFrameItemButton_UpdateLocked(self.ContainerHolder[i])
				end
			end
		end
	end
	f:Size(containerWidth, (((buttonSize + buttonSpacing) * numContainerRows) - buttonSpacing) + f.topOffset + f.bottomOffset); -- 8 is the cussion of the f.holderFrame
end

function B:UpdateAll()
	if self.BagFrame then
		self:Layout()
	end
	if self.BankFrame then
		self:Layout(true)
	end
end

function B:OnEvent(event, ...)
	if event == "ITEM_LOCK_CHANGED" or event == "ITEM_UNLOCKED" then
		self:UpdateSlot(...)
	elseif event == "BAG_UPDATE" then
		for _, bagID in ipairs(self.BagIDs) do
			local numSlots = GetContainerNumSlots(bagID)
			if (not self.Bags[bagID] and numSlots ~= 0) or (self.Bags[bagID] and numSlots ~= self.Bags[bagID].numSlots) then
				B:Layout(self.isBank)
				return
			end
		end
		self:UpdateBagSlots(...)
	elseif event == "BAG_UPDATE_COOLDOWN" then
		self:UpdateCooldowns()
	elseif event == "PLAYERBANKSLOTS_CHANGED" or event == "QUEST_ACCEPTED" or event == "UNIT_QUEST_LOG_CHANGED" then
		self:UpdateAllSlots()
	end
end

function B:UpdateTokens()
	local f = self.BagFrame
	local numTokens = 0
	for i = 1, MAX_WATCHED_TOKENS do
		local name, count, icon, currencyID = GetBackpackCurrencyInfo(i)
		local button = f.currencyButton[i]
		button:ClearAllPoints()
		if name then
			button.icon:SetTexture(icon)
			button.text:SetText(name..": "..count)
			button.currencyID = currencyID
			button:Show()
			numTokens = numTokens + 1
		else
			button:Hide()
		end
	end
	if numTokens == 0 then
		f.bottomOffset = 8
		if f.currencyButton:IsShown() then
			f.currencyButton:Hide()
			self:Layout()
		end
		return
	elseif not f.currencyButton:IsShown() then
		f.bottomOffset = 28
		f.currencyButton:Show()
		self:Layout()
	end
	f.bottomOffset = 28
	if numTokens == 1 then
		f.currencyButton[1]:Point("BOTTOM", f.currencyButton, "BOTTOM", -(f.currencyButton[1].text:GetWidth() / 2), 3)
	elseif numTokens == 2 then
		f.currencyButton[1]:Point("BOTTOM", f.currencyButton, "BOTTOM", -(f.currencyButton[1].text:GetWidth()) - (f.currencyButton[1]:GetWidth() / 2), 3)
		f.currencyButton[2]:Point("BOTTOMLEFT", f.currencyButton, "BOTTOM", f.currencyButton[2]:GetWidth() / 2, 3)
	else
		f.currencyButton[1]:Point("BOTTOMLEFT", f.currencyButton, "BOTTOMLEFT", 3, 3)
		f.currencyButton[2]:Point("BOTTOM", f.currencyButton, "BOTTOM", -(f.currencyButton[2].text:GetWidth() / 3), 3)
		f.currencyButton[3]:Point("BOTTOMRIGHT", f.currencyButton, "BOTTOMRIGHT", -(f.currencyButton[3].text:GetWidth()) - (f.currencyButton[3]:GetWidth() / 2), 3)
	end
end

function B:Token_OnEnter()
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
	GameTooltip:SetBackpackToken(self:GetID())
end

function B:Token_OnClick()
	if ( IsModifiedClick("CHATLINK") ) then
		HandleModifiedItemClick(GetCurrencyLink(self.currencyID))
	end
end

function B:UpdateGoldText()
	self.BagFrame.goldText:SetText(GetCoinTextureString(GetMoney(), 12))
end

function B:ContructContainerFrame(name, isBank)
	local f = CreateFrame("Button", name, UIParent)
	S:SetBD(f)
	f:SetFrameStrata("DIALOG")
	f.UpdateSlot = B.UpdateSlot
	f.UpdateAllSlots = B.UpdateAllSlots
	f.UpdateBagSlots = B.UpdateBagSlots
	f.UpdateCooldowns = B.UpdateCooldowns
	f:RegisterEvent("ITEM_LOCK_CHANGED")
	f:RegisterEvent("ITEM_UNLOCKED")
	f:RegisterEvent("BAG_UPDATE_COOLDOWN")
	f:RegisterEvent("BAG_UPDATE")
	f:RegisterEvent("QUEST_ACCEPTED")
	f:RegisterUnitEvent("UNIT_QUEST_LOG_CHANGED", "player")
	f:RegisterEvent("PLAYERBANKSLOTS_CHANGED")
	f:SetMovable(true)
	f:RegisterForDrag("LeftButton", "RightButton")
	f:RegisterForClicks("AnyUp")
	f:SetScript("OnDragStart", function(self) self:StartMoving() end)
	f:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
	f:SetScript("OnClick", function(self) if IsControlKeyDown() then B:PositionBagFrames() end end)
	f:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
	f.isBank = isBank
	f:SetScript("OnEvent", B.OnEvent)
	f:Hide()
	f.bottomOffset = isBank and 8 or 28
	f.topOffset = isBank and 45 or 50
	f.BagIDs = isBank and {-1, 5, 6, 7, 8, 9, 10, 11} or {0, 1, 2, 3, 4}
	f.Bags = {}
	f.closeButton = CreateFrame("Button", name.."CloseButton", f, "UIPanelCloseButton")
	f.closeButton:Point("TOPRIGHT", -4, -4)
	S:ReskinClose(f.closeButton)
	f.holderFrame = CreateFrame("Frame", nil, f)
	f.holderFrame:Point("TOP", f, "TOP", 0, -f.topOffset)
	f.holderFrame:Point("BOTTOM", f, "BOTTOM", 0, 8)
	f.ContainerHolder = CreateFrame("Button", name.."ContainerHolder", f)
	f.ContainerHolder:Point("BOTTOMLEFT", f, "TOPLEFT", 0, 1)
	S:CreateBD(f.ContainerHolder)
	f.ContainerHolder:Hide()
	if isBank then
		f.purchaseBagButton = CreateFrame("Button", nil, f)
		f.purchaseBagButton:Height(20)
		f.purchaseBagButton:Width(150)
		f.purchaseBagButton:Point("BOTTOMLEFT", f.holderFrame, "TOPLEFT", 0, 4)
		f.purchaseBagButton:SetFrameLevel(f.purchaseBagButton:GetFrameLevel() + 2)
		f.purchaseBagButton.text = f.purchaseBagButton:CreateFontString(nil, "OVERLAY")
		f.purchaseBagButton.text:FontTemplate()
		f.purchaseBagButton.text:SetPoint("CENTER")
		f.purchaseBagButton.text:SetJustifyH("CENTER")
		f.purchaseBagButton.text:SetText(PURCHASE)
		f.purchaseBagButton:SetScript("OnEnter", self.Tooltip_Show)
		f.purchaseBagButton:SetScript("OnLeave", self.Tooltip_Hide)
		f.purchaseBagButton:SetScript("OnClick", function()
			local _, full = GetNumBankSlots()
			if not full then
				StaticPopup_Show("BUY_BANK_SLOT")
			else
				StaticPopup_Show("CANNOT_BUY_BANK_SLOT")
			end
		end)
		S:Reskin(f.purchaseBagButton)

		--Sort Button
		f.sortButton = CreateFrame("Button", nil, f)
		f.sortButton:Point("TOPLEFT", f, "TOPLEFT", 14, -4)
		f.sortButton:Size(55, 10)
		f.sortButton.ttText = L["整理背包"]
		f.sortButton:SetScript("OnEnter", self.Tooltip_Show)
		f.sortButton:SetScript("OnLeave", self.Tooltip_Hide)
		f.sortButton:SetScript("OnClick", function() B:CommandDecorator(B.SortBags, "bank")() end)
		S:Reskin(f.sortButton)

		--Stack Button
		f.stackButton = CreateFrame("Button", nil, f)
		f.stackButton:Point("LEFT", f.sortButton, "RIGHT", 3, 0)
		f.stackButton:Size(55, 10)
		f.stackButton.ttText = L["堆叠物品"]
		f.stackButton:SetScript("OnEnter", self.Tooltip_Show)
		f.stackButton:SetScript("OnLeave", self.Tooltip_Hide)
		f.stackButton:SetScript("OnClick", function() B:CommandDecorator(B.Compress, "bank")() end)
		S:Reskin(f.stackButton)

		--Transfer Button
		f.transferButton = CreateFrame("Button", nil, f)
		f.transferButton:Point("LEFT", f.stackButton, "RIGHT", 3, 0)
		f.transferButton:Size(55, 10)
		f.transferButton.ttText = L["堆叠至银行"]
		f.transferButton:SetScript("OnEnter", self.Tooltip_Show)
		f.transferButton:SetScript("OnLeave", self.Tooltip_Hide)
		f.transferButton:SetScript("OnClick", function() B:CommandDecorator(B.Stack, "bank bags")() end)
		S:Reskin(f.transferButton)

		--Toggle Bags Button
		f.bagsButton = CreateFrame("Button", nil, f)
		f.bagsButton:Point("LEFT", f.transferButton, "RIGHT", 3, 0)
		f.bagsButton:Size(55, 10)
		f.bagsButton.ttText = L["显示背包"]
		f.bagsButton:SetScript("OnEnter", self.Tooltip_Show)
		f.bagsButton:SetScript("OnLeave", self.Tooltip_Hide)
		f.bagsButton:SetScript("OnClick", function()
		local numSlots, full = GetNumBankSlots()
			if numSlots >= 1 then
				ToggleFrame(f.ContainerHolder)
			else
				StaticPopup_Show("NO_BANK_BAGS")
			end
		end)
		S:Reskin(f.bagsButton)
		f:SetScript("OnHide", CloseBankFrame)
	else
		--Gold Text
		f.goldText = f:CreateFontString(nil, "OVERLAY")
		f.goldText:FontTemplate()
		f.goldText:Point("BOTTOMRIGHT", f.holderFrame, "TOPRIGHT", -2, 4)
		f.goldText:SetJustifyH("RIGHT")
		--Search
		f.editBox = CreateFrame("EditBox", name.."EditBox", f)
		f.editBox:SetFrameLevel(f.editBox:GetFrameLevel() + 2)
		f.editBox:Height(15)
		f.editBox:Hide()
		f.editBox:Point("BOTTOMLEFT", f.holderFrame, "TOPLEFT", 3, 4)
		f.editBox:Point("RIGHT", f.goldText, "LEFT", -5, 0)
		f.editBox:SetAutoFocus(true)
		f.editBox:SetScript("OnEscapePressed", self.ResetAndClear)
		f.editBox:SetScript("OnEnterPressed", self.ResetAndClear)
		f.editBox:SetScript("OnEditFocusLost", f.editBox.Hide)
		f.editBox:SetScript("OnEditFocusGained", f.editBox.HighlightText)
		f.editBox:SetScript("OnTextChanged", self.UpdateSearch)
		f.editBox:SetScript("OnChar", self.UpdateSearch)
		f.editBox:SetText(SEARCH)
		f.editBox:FontTemplate()
		f.editBox.border = CreateFrame("Frame", nil, f.editBox)
		f.editBox.border:Point("TOPLEFT", -3, 0)
		f.editBox.border:Point("BOTTOMRIGHT", 0, 0)
		S:CreateBD(f.editBox.border, 0)

		f.detail = f:CreateFontString(nil, "ARTWORK")
		f.detail:FontTemplate()
		f.detail:SetAllPoints(f.editBox)
		f.detail:SetJustifyH("LEFT")
		f.detail:SetText(SEARCH)
		local button = CreateFrame("Button", nil, f)
		button:RegisterForClicks("LeftButtonUp", "RightButtonUp")
		button:SetAllPoints(f.detail)
		button:SetScript("OnClick", function(f, btn)
			if btn == "RightButton" then
				self:OpenEditbox()
			else
				if f:GetParent().editBox:IsShown() then
					f:GetParent().editBox:Hide()
					f:GetParent().editBox:ClearFocus()
					f:GetParent().detail:Show()
					self:SearchReset()
				else
					self:OpenEditbox()
				end
			end
		end)
		--Sort Button
		f.sortButton = CreateFrame("Button", nil, f)
		f.sortButton:Point("TOPLEFT", f, "TOPLEFT", 14, -4)
		f.sortButton:Size(55, 10)
		f.sortButton.ttText = L["整理背包"]
		f.sortButton:SetScript("OnEnter", self.Tooltip_Show)
		f.sortButton:SetScript("OnLeave", self.Tooltip_Hide)
		f.sortButton:SetScript("OnClick", function() B:CommandDecorator(B.SortBags, "bags")() end)
		S:Reskin(f.sortButton)

		--Stack Button
		f.stackButton = CreateFrame("Button", nil, f)
		f.stackButton:Point("LEFT", f.sortButton, "RIGHT", 3, 0)
		f.stackButton:Size(55, 10)
		f.stackButton.ttText = L["堆叠物品"]
		f.stackButton:SetScript("OnEnter", self.Tooltip_Show)
		f.stackButton:SetScript("OnLeave", self.Tooltip_Hide)
		f.stackButton:SetScript("OnClick", function() B:CommandDecorator(B.Compress, "bags")() end)
		S:Reskin(f.stackButton)

		--Transfer Button
		f.transferButton = CreateFrame("Button", nil, f)
		f.transferButton:Point("LEFT", f.stackButton, "RIGHT", 3, 0)
		f.transferButton:Size(55, 10)
		f.transferButton.ttText = L["堆叠至银行"]
		f.transferButton:SetScript("OnEnter", self.Tooltip_Show)
		f.transferButton:SetScript("OnLeave", self.Tooltip_Hide)
		f.transferButton:SetScript("OnClick", function() B:CommandDecorator(B.Stack, "bags bank")() end)
		S:Reskin(f.transferButton)

		--Bags Button
		f.bagsButton = CreateFrame("Button", nil, f)
		f.bagsButton:Point("LEFT", f.transferButton, "RIGHT", 3, 0)
		f.bagsButton:Size(55, 10)
		f.bagsButton.ttText = L["显示背包"]
		f.bagsButton:SetScript("OnEnter", self.Tooltip_Show)
		f.bagsButton:SetScript("OnLeave", self.Tooltip_Hide)
		f.bagsButton:SetScript("OnClick", function() ToggleFrame(f.ContainerHolder) end)
		S:Reskin(f.bagsButton)

		--Currency
		f.currencyButton = CreateFrame("Frame", nil, f)
		f.currencyButton:Point("BOTTOM", 0, 1)
		f.currencyButton:Point("TOPLEFT", f.holderFrame, "BOTTOMLEFT", 0, 18)
		f.currencyButton:Point("TOPRIGHT", f.holderFrame, "BOTTOMRIGHT", 0, 18)
		f.currencyButton:Height(22)
		for i = 1, MAX_WATCHED_TOKENS do
			f.currencyButton[i] = CreateFrame("Button", nil, f.currencyButton)
			f.currencyButton[i]:Size(16)
			f.currencyButton[i]:SetID(i)
			f.currencyButton[i].icon = f.currencyButton[i]:CreateTexture(nil, "OVERLAY")
			S:CreateBD(f.currencyButton[i])
			f.currencyButton[i].icon:SetInside(nil, 1, 1)
			f.currencyButton[i].icon:SetTexCoord(.08, .92, .08, .92)
			f.currencyButton[i].text = f.currencyButton[i]:CreateFontString(nil, "OVERLAY")
			f.currencyButton[i].text:Point("LEFT", f.currencyButton[i], "RIGHT", 2, 0)
			f.currencyButton[i].text:FontTemplate()
			f.currencyButton[i]:SetScript("OnEnter", B.Token_OnEnter)
			f.currencyButton[i]:SetScript("OnLeave", function() GameTooltip:Hide() end)
			f.currencyButton[i]:SetScript("OnClick", B.Token_OnClick)
			f.currencyButton[i]:Hide()
		end
		f:SetScript("OnHide", CloseAllBags)
	end
	tinsert(UISpecialFrames, f:GetName()) --Keep an eye on this for taints..
	table.insert(self.BagFrames, f)
	return f
end

function B:PositionBagFrames()
	if self.BagFrame then
		self.BagFrame:ClearAllPoints()
		self.BagFrame:Point("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -55, 30)
	end
	if self.BankFrame then
		self.BankFrame:ClearAllPoints()
		self.BankFrame:Point("BOTTOMRIGHT", self.BagFrame, "BOTTOMLEFT", -30, 0)
	end
end

function B:ToggleBags(id)
	if id and GetContainerNumSlots(id) == 0 then return end --Closes a bag when inserting a new container..
	if self.BagFrame:IsShown() then
		self:CloseBags()
	else
		self:OpenBags()
	end
end

function B:ToggleBackpack()
	if ( IsOptionFrameOpen() ) then
		return
	end
	if IsBagOpen(0) then
		self:OpenBags()
	else
		self:CloseBags()
	end
end

function B:OpenBags()
	self.BagFrame:Show()
	self.BagFrame:UpdateAllSlots()
	R:GetModule("Tooltip"):GameTooltip_SetDefaultAnchor(GameTooltip)
end

function B:CloseBags()
	self.BagFrame:Hide()
	if self.BankFrame then
		self.BankFrame:Hide()
	end
	R:GetModule("Tooltip"):GameTooltip_SetDefaultAnchor(GameTooltip)
end

function B:OpenBank()
	if not self.BankFrame then
		self.BankFrame = self:ContructContainerFrame("RayUI_BankContainerFrame", true)
		self:PositionBagFrames()
	end
	self:Layout(true)
	self.BankFrame:Show()
	self.BankFrame:UpdateAllSlots()
	self.BagFrame:Show()
	self:UpdateTokens()
end

function B:PLAYERBANKBAGSLOTS_CHANGED()
	self:Layout(true)
end

function B:CloseBank()
	if not self.BankFrame then return end -- WHY???, WHO KNOWS!
	self.BankFrame:Hide()
end

function B:PLAYER_ENTERING_WORLD()
	ToggleBackpack()
	ToggleBackpack()
	self:UpdateGoldText()
end

function B:Initialize()
	self.BagFrames = {}
	self.BagFrame = self:ContructContainerFrame("RayUI_ContainerFrame")
	--Hook onto Blizzard Functions
	self:SecureHook("OpenAllBags", "OpenBags")
	self:SecureHook("CloseAllBags", "CloseBags")
	self:SecureHook("ToggleBag", "ToggleBags")
	self:SecureHook("ToggleAllBags", "ToggleBackpack")
	self:SecureHook("ToggleBackpack")
	self:SecureHook("BackpackTokenFrame_Update", "UpdateTokens")
	self:PositionBagFrames()
	self:Layout()
	self:DisableBlizzard()
	self:RegisterEvent("INVENTORY_SEARCH_UPDATE")
	self:RegisterEvent("PLAYER_ENTERING_WORLD")
	self:RegisterEvent("PLAYER_MONEY", "UpdateGoldText")
	self:RegisterEvent("PLAYER_TRADE_MONEY", "UpdateGoldText")
	self:RegisterEvent("TRADE_MONEY_CHANGED", "UpdateGoldText")
	self:RegisterEvent("BANKFRAME_OPENED", "OpenBank")
	self:RegisterEvent("BANKFRAME_CLOSED", "CloseBank")
	self:RegisterEvent("PLAYERBANKBAGSLOTS_CHANGED")
	StackSplitFrame:SetFrameStrata("DIALOG")
	self:HookScript(TradeFrame, "OnShow", "OpenBags")
	self:HookScript(TradeFrame, "OnHide", "CloseBags")
end

function B:Info()
	return L["|cff7aa6d6Ray|r|cffff0000U|r|cff7aa6d6I|r背包模块."]
end

function B:UpdateContainerFrameAnchors()
	local frame, xOffset, yOffset, screenHeight, freeScreenHeight, leftMostPoint, column
	local screenWidth = GetScreenWidth()
	local containerScale = 1
	local leftLimit = 0
	if ( BankFrame:IsShown() ) then
		leftLimit = BankFrame:GetRight() - 25
	end
	while ( containerScale > CONTAINER_SCALE ) do
		screenHeight = GetScreenHeight() / containerScale
		-- Adjust the start anchor for bags depending on the multibars
		xOffset = CONTAINER_OFFSET_X / containerScale
		yOffset = CONTAINER_OFFSET_Y / containerScale
		-- freeScreenHeight determines when to start a new column of bags
		freeScreenHeight = screenHeight - yOffset
		leftMostPoint = screenWidth - xOffset
		column = 1
		local frameHeight
		for index, frameName in ipairs(ContainerFrame1.bags) do
			frameHeight = _G[frameName]:GetHeight()
			if ( freeScreenHeight < frameHeight ) then
				-- Start a new column
				column = column + 1
				leftMostPoint = screenWidth - ( column * CONTAINER_WIDTH * containerScale ) - xOffset
				freeScreenHeight = screenHeight - yOffset
			end
			freeScreenHeight = freeScreenHeight - frameHeight - VISIBLE_CONTAINER_SPACING
		end
		if ( leftMostPoint < leftLimit ) then
			containerScale = containerScale - 0.01
		else
			break
		end
	end
	if ( containerScale < CONTAINER_SCALE ) then
		containerScale = CONTAINER_SCALE
	end
	screenHeight = GetScreenHeight() / containerScale
	-- Adjust the start anchor for bags depending on the multibars
	xOffset = CONTAINER_OFFSET_X / containerScale
	yOffset = CONTAINER_OFFSET_Y / containerScale
	-- freeScreenHeight determines when to start a new column of bags
	freeScreenHeight = screenHeight - yOffset
	column = 0
	local bagsPerColumn = 0
	for index, frameName in ipairs(ContainerFrame1.bags) do
		frame = _G[frameName]
		frame:SetScale(1)
		if ( index == 1 ) then
			-- First bag
			frame:SetPoint("BOTTOMRIGHT", RightChatToggleButton, "TOPRIGHT", 2, 2)
			bagsPerColumn = bagsPerColumn + 1
		elseif ( freeScreenHeight < frame:GetHeight() ) then
			-- Start a new column
			column = column + 1
			freeScreenHeight = screenHeight - yOffset
			if column > 1 then
				frame:SetPoint("BOTTOMRIGHT", ContainerFrame1.bags[(index - bagsPerColumn) - 1], "BOTTOMLEFT", -CONTAINER_SPACING, 0 )
			else
				frame:SetPoint("BOTTOMRIGHT", ContainerFrame1.bags[index - bagsPerColumn], "BOTTOMLEFT", -CONTAINER_SPACING, 0 )
			end
			bagsPerColumn = 0
		else
			-- Anchor to the previous bag
			frame:SetPoint("BOTTOMRIGHT", ContainerFrame1.bags[index - 1], "TOPRIGHT", 0, CONTAINER_SPACING)
			bagsPerColumn = bagsPerColumn + 1
		end
		freeScreenHeight = freeScreenHeight - frame:GetHeight() - VISIBLE_CONTAINER_SPACING
	end
end

StaticPopupDialogs["BUY_BANK_SLOT"] = {
	text = CONFIRM_BUY_BANK_SLOT,
	button1 = YES,
	button2 = NO,
	OnAccept = function(self)
		PurchaseSlot()
	end,
	OnShow = function(self)
		MoneyFrame_Update(self.moneyFrame, GetBankSlotCost())
	end,
	hasMoneyFrame = 1,
	timeout = 0,
	hideOnEscape = 1,
}

StaticPopupDialogs["CANNOT_BUY_BANK_SLOT"] = {
	text = L["不能购买更多的银行栏位了!"],
	button1 = ACCEPT,
	timeout = 0,
	whileDead = 1,	
}

StaticPopupDialogs["NO_BANK_BAGS"] = {
	text = L["你必须先购买一个银行栏位!"],
	button1 = ACCEPT,
	timeout = 0,
	whileDead = 1,	
}

R:RegisterModule(B:GetName())
