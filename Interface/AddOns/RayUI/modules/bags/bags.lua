local R, L, P = unpack(RayUI) --Inport: Engine, Locales, ProfileDB
local B = R:NewModule("Bag", "AceEvent-3.0", "AceHook-3.0")
local S = R:GetModule("Skins")

B.modName = L["背包"]

local Bag = CreateFrame("Frame", nil, UIParent)
local ST_NORMAL = 1
local ST_SOULBAG = 2
local ST_SPECIAL = 3
local ST_QUIVER = 4
local bagFrame, bankFrame
local BAGS_BACKPACK = {0, 1, 2, 3, 4}
local BAGS_BANK = {-1, 5, 6, 7, 8, 9, 10, 11}
local trashParent = CreateFrame("Frame", nil, UIParent)
local trashButton, trashBag = {}, {}
local _highlight = false

B.buttons = {}
B.bags = {}

local function ResetAndClear(self)
	if not self then return end

	if self:GetParent().detail then
		self:GetParent().detail:Show()
	end

	self:ClearFocus()
	B:SearchReset()
end

--This one isn't for the actual bag buttons its for the buttons you can use to swap bags.
function B:BagFrameSlotNew(frame, slot)
	for _, v in ipairs(frame.buttons) do
		if v.slot == slot then
			return v, false
		end
	end

	local ret = {}
	if slot > 3 then
		ret.slot = slot
		slot = slot - 4
		ret.frame = CreateFrame("CheckButton", "RayUIBankBag" .. slot, frame, "BankItemButtonBagTemplate")
		ret.frame:SetID(slot + 4)
		table.insert(frame.buttons, ret)

		if not ret.frame.tooltipText then
			ret.frame.tooltipText = ""
		end
	else
		--This is fucking retarded, the frame name needs to have 9 digits before the word Bag.
		ret.frame = CreateFrame("CheckButton", "RayUIMainBag" .. slot .. "Slot", frame, "BagSlotButtonTemplate")
		ret.slot = slot
		table.insert(frame.buttons, ret)
	end

	ret.frame:HookScript("OnEnter", function()
		local bag
		for ind, val in ipairs(self.buttons) do
			if val.bag == ret.slot then
				val.frame:SetAlpha(1)
			else
				val.frame:SetAlpha(0.2)
			end
		end
	end)

	ret.frame:HookScript("OnLeave", function()
		for _, btn in ipairs(self.buttons) do
			btn.frame:SetAlpha(1)
		end
	end)

	ret.frame:SetScript("OnClick", nil)

	ret.frame:StyleButton()
	ret.frame:SetFrameLevel(ret.frame:GetFrameLevel() + 1)
	if not ret.frame.border then
		local border = CreateFrame("Frame", nil, ret.frame)
		border:Point("TOPLEFT", 1, -1)
		border:Point("BOTTOMRIGHT", -1, 1)
		border:SetFrameLevel(0)
		ret.frame.border = border
		ret.frame.border:CreateBorder()
	end

	local t = _G[ret.frame:GetName().."IconTexture"]
	ret.frame:SetPushedTexture("")
	ret.frame:SetNormalTexture("")
	ret.frame:SetCheckedTexture(nil)
	t:SetTexCoord(.08, .92, .08, .92)
	t:Point("TOPLEFT", ret.frame, 2, -2)
	t:Point("BOTTOMRIGHT", ret.frame, -2, 2)

	return ret
end

local BAGTYPE_PROFESSION = 0x0008 + 0x0010 + 0x0020 + 0x0040 + 0x0080 + 0x0200 + 0x0400
local BAGTYPE_FISHING = 32768
function B:BagType(bag)
	local bagType = select(2, GetContainerNumFreeSlots(bag))

	if bit.band(bagType, BAGTYPE_FISHING) > 0 then
		return ST_FISHBAG
	elseif bit.band(bagType, BAGTYPE_PROFESSION) > 0 then
		return ST_SPECIAL
	end

	return ST_NORMAL
end

function B:BagNew(bag, f)
	for i, v in pairs(self.bags) do
		if v:GetID() == bag then
			v.bagType = self:BagType(bag)
			return v
		end
	end

	local ret

	if #trashBag > 0 then
		local f = -1
		for i, v in pairs(trashBag) do
			if v:GetID() == bag then
				f = i
				break
			end
		end

		if f ~= -1 then
			ret = trashBag[f]
			table.remove(trashBag, f)
			ret:Show()
			ret.bagType = B:BagType(bag)
			return ret
		end
	end

	ret = CreateFrame("Frame", "RayUIBag" .. bag, f)
	ret.bagType = B:BagType(bag)

	ret:SetID(bag)
	return ret
end

function B:SlotUpdate(b)
	local texture, count, locked = GetContainerItemInfo(b.bag, b.slot)
	local isQuest, questId, isActive = GetContainerItemQuestInfo(b.bag, b.slot)
	local clink = GetContainerItemLink(b.bag, b.slot)

	if not b.frame.lock or b.frame.special then
		b.frame.border:SetBackdropBorderColor(unpack(R["media"].bordercolor))
	end

	if b.Cooldown then
		local cd_start, cd_finish, cd_enable = GetContainerItemCooldown(b.bag, b.slot)
		CooldownFrame_SetTimer(b.Cooldown, cd_start, cd_finish, cd_enable)
	end

	if(clink) then
		local iType
		b.name, _, b.rarity, _, _, iType = GetItemInfo(clink)

		if R:IsItemUnusable(clink) then
			_G[b.frame:GetName().."IconTexture"]:SetVertexColor(RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b)
		else
			_G[b.frame:GetName().."IconTexture"]:SetVertexColor(1, 1, 1)
		end
		b.frame:SetBackdropColor(0, 0, 0)
		-- color slot according to item quality
		if ( not b.frame.lock or b.frame.special ) and b.rarity and b.rarity > 1 then
			b.frame.border:SetBackdropBorderColor(GetItemQualityColor(b.rarity))
			_G[b.frame:GetName().."IconTexture"]:Point("TOPLEFT", 1, -1)
			_G[b.frame:GetName().."IconTexture"]:Point("BOTTOMRIGHT", -1, 1)
			b.frame:GetHighlightTexture():Point("TOPLEFT", 1, -1)
			b.frame:GetHighlightTexture():Point("BOTTOMRIGHT", -1, 1)
			b.frame:GetPushedTexture():Point("TOPLEFT", 1, -1)
			b.frame:GetPushedTexture():Point("BOTTOMRIGHT", -1, 1)
		elseif isQuest then
			b.frame.border:SetBackdropBorderColor(1, 1, 0)
			_G[b.frame:GetName().."IconTexture"]:Point("TOPLEFT", 1, -1)
			_G[b.frame:GetName().."IconTexture"]:Point("BOTTOMRIGHT", -1, 1)
			b.frame:GetHighlightTexture():Point("TOPLEFT", 1, -1)
			b.frame:GetHighlightTexture():Point("BOTTOMRIGHT", -1, 1)
			b.frame:GetPushedTexture():Point("TOPLEFT", 1, -1)
			b.frame:GetPushedTexture():Point("BOTTOMRIGHT", -1, 1)
		else
			_G[b.frame:GetName().."IconTexture"]:SetAllPoints()
			b.frame:GetHighlightTexture():SetAllPoints()
			b.frame:GetPushedTexture():SetAllPoints()
		end
		if isActive == false then
			b.frame.quest:SetText("!")
		else
			b.frame.quest:SetText("")
		end
	else
		b.name, b.rarity = nil, nil
		b.frame:SetBackdropColor(0, 0, 0, 0)
		b.frame.quest:SetText("")
	end

	SetItemButtonTexture(b.frame, texture)
	SetItemButtonCount(b.frame, count)
	SetItemButtonDesaturated(b.frame, locked, 0.5, 0.5, 0.5)

	b.frame:Show()
end

function B:SlotNew(bag, slot)
	for _, v in ipairs(self.buttons) do
		if v.bag == bag and v.slot == slot then
			return v, false
		end
	end

	local tpl = "ContainerFrameItemButtonTemplate"

	if bag == -1 then
		tpl = "BankItemButtonGenericTemplate"
	end

	local ret = {}

	if #trashButton > 0 then
		local f = -1
		for i, v in ipairs(trashButton) do
			local b, s = v:GetName():match("(%d+)_(%d+)")

			b = tonumber(b)
			s = tonumber(s)

			if b == bag and s == slot then
				f = i
				break
			end
		end

		if f ~= -1 then
			ret.frame = trashButton[f]
			table.remove(trashButton, f)
		end
	end

	if not ret.frame then
		ret.frame = CreateFrame("CheckButton", "RayUINormBag" .. bag .. "_" .. slot, self.bags[bag], tpl)
		ret.frame:StyleButton(true)

		if not ret.frame.border then
			local border = CreateFrame("Frame", nil, ret.frame)
			border:Point("TOPLEFT", -1, 1)
			border:Point("BOTTOMRIGHT", 1, -1)
			border:SetFrameLevel(0)
			ret.frame.border = border
			ret.frame.border:CreateBorder()

			local tex = ret.frame:CreateTexture(nil, "BACKGROUND")
			tex:SetAllPoints()
			tex:SetTexture(S["media"].backdrop)
			tex:SetGradientAlpha(unpack(S["media"].DefGradient))
		end

		if not ret.frame.shadow then
			ret.frame:CreateShadow()
			ret.frame.shadow:Hide()
		end

		ret.frame:SetBackdrop({
			bgFile = R["media"].blank, 
			insets = { left = 0, right = 0, top = 0, bottom = 0 }
		})

		local t = _G[ret.frame:GetName().."IconTexture"]
		ret.frame:SetNormalTexture(nil)
		ret.frame:SetCheckedTexture(nil)

		t:SetTexCoord(.08, .92, .08, .92)
		t:SetAllPoints()

		local count = _G[ret.frame:GetName().."Count"]
		count:ClearAllPoints()
		count:Point("BOTTOMRIGHT", ret.frame, "BOTTOMRIGHT", 1, 0)
		count:SetFont(R["media"].pxfont, R.mult*10, "OUTLINE,MONOCHROME")
	end

	if not ret.frame.quest then
		ret.frame.quest = ret.frame:CreateFontString(nil, "OVERLAY")
		ret.frame.quest:SetFont(R["media"].pxfont, 30, R["media"].fontflag)
		ret.frame.quest:SetTextColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
		ret.frame.quest:SetShadowOffset(R.mult, -R.mult)
		ret.frame.quest:SetShadowColor(0, 0, 0)
		ret.frame.quest:SetPoint("TOPRIGHT", 2, 6)
	end

	ret.bag = bag
	ret.slot = slot
	ret.frame:SetID(slot)

	ret.Cooldown = _G[ret.frame:GetName() .. "Cooldown"]
	ret.Cooldown:Show()

	self:SlotUpdate(ret)

	return ret, true
end

function B:Layout(isBank)
	local slots = 0
	local rows = 0
	local offset = 26
	local cols, f, bs, bSize, BagWidth
	local spacing = 5

	if not isBank then
		BagWidth = 370
		bs = BAGS_BACKPACK
		f = bagFrame
		bSize = 32
		-- cols = (floor((BagWidth - 10)/370 * 10))
		cols = floor((BagWidth - 10 + spacing)/((bSize + 1) + spacing))
	else
		BagWidth = 600
		bs = BAGS_BANK
		f = bankFrame
		bSize = 32
		-- cols = (floor((BagWidth - 10)/370 * 10))
		cols = floor((BagWidth - 10 + spacing)/((bSize + 1) + spacing))
	end

	if not f then return end

	local w = 0
	w = w + ((#bs - 1) * bSize)
	w = w + (12 * (#bs - 2))

	f.ContainerHolder:Height(10 + bSize)
	f.ContainerHolder:Width(w)

	--Position BagFrame Bag Icons
	local idx = 0
	local numSlots, full = GetNumBankSlots()
	for i, v in ipairs(bs) do
		if (not isBank and v <= 3 ) or (isBank and v ~= -1 and numSlots >= 1) then
			local b = B:BagFrameSlotNew(f.ContainerHolder, v)

			local xOff = 12
			xOff = xOff + (idx * bSize)
			xOff = xOff + (idx * 4)

			b.frame:ClearAllPoints()
			b.frame:Point("LEFT", f.ContainerHolder, "LEFT", xOff, 0)
			b.frame:Size(bSize)

			if isBank then
				BankFrameItemButton_Update(b.frame)
				BankFrameItemButton_UpdateLocked(b.frame)
			end

			idx = idx + 1

			if isBank and not full and i > numSlots then
				break
			end
		end
	end

	for _, i in ipairs(bs) do
		local x = GetContainerNumSlots(i)
		if x > 0 then
			if not self.bags[i] then
				self.bags[i] = self:BagNew(i, f)
			end

			slots = slots + GetContainerNumSlots(i)
		end
	end

	rows = floor (slots / cols)
	if (slots % cols) ~= 0 then
		rows = rows + 1
	end

	f:Width(BagWidth)
	f:Height(rows * (bSize + 1) + (rows - 1) * spacing + offset + 24)

	f.HolderFrame:SetWidth(((bSize + 1) + spacing) * cols - spacing)
	f.HolderFrame:SetHeight(f:GetHeight() - 3)
	f.HolderFrame:SetPoint("BOTTOM", f, "BOTTOM")

	--Fun Part, Position Actual Bag Buttons
	local idx = 0
	for _, i in ipairs(bs) do
		local bag_cnt = GetContainerNumSlots(i)

		if bag_cnt > 0 then
			self.bags[i] = B:BagNew(i, f)
			local bagType = self.bags[i].bagType
			self.bags[i]:Show()

			for j = 1, bag_cnt do
				local b, isnew = self:SlotNew(i, j)
				local xOff
				local yOff
				local x = (idx % cols)
				local y = floor(idx / cols)

				if isnew then
					table.insert(self.buttons, idx + 1, b)
				end

				xOff = (x * (bSize + 1)) + (x * spacing)

				yOff = offset + 12 + (y * (bSize + 1)) + ((y - 1) * spacing)
				yOff = yOff * -1

				b.frame:ClearAllPoints()
				b.frame:SetPoint("TOPLEFT", f.HolderFrame, "TOPLEFT", xOff, yOff)
				b.frame:Size(bSize)

				local clink = GetContainerItemLink
				if (clink and b.rarity and b.rarity > 1) then
					b.frame.border:SetBackdropBorderColor(GetItemQualityColor(b.rarity))
					b.frame.shadow:Hide()
					b.frame.special = nil
				elseif (clink and b.qitem) then
					b.frame.border:SetBackdropBorderColor(1, 0, 0)
					b.frame.shadow:Hide()
					b.frame.special = nil
				elseif bagType == ST_QUIVER then
					-- b.frame.border:SetBackdropBorderColor(0.8, 0.8, 0.2)
					b.frame.shadow:SetBackdropBorderColor(0.8, 0.8, 0.2)
					b.frame.shadow:Show()
					b.frame.lock = true
					b.frame.special = true
				elseif bagType == ST_SOULBAG then
					-- b.frame.border:SetBackdropBorderColor(0.5, 0.2, 0.2)
					b.frame.shadow:SetBackdropBorderColor(0.5, 0.2, 0.2)
					b.frame.shadow:Show()
					b.frame.lock = true
					b.frame.special = true
				elseif bagType == ST_SPECIAL then
					-- b.frame:SetBackdropBorderColor(0.2, 0.2, 0.8)
					b.frame.shadow:SetBackdropBorderColor(0.2, 0.2, 0.8)
					b.frame.shadow:Show()
					b.frame.lock = true
					b.frame.special = true
				end

				-- color profession bag slot border ~yellow
				if bagType == ST_SPECIAL then
					-- b.frame.border:SetBackdropBorderColor(0.8, 0.8, 0.2)
					b.frame.shadow:SetBackdropBorderColor(0.8, 0.8, 0.2)
					b.frame.shadow:Show()
					b.frame.lock = true
					b.frame.special = true
				end

				idx = idx + 1
			end
		end
	end
end

function B:BagSlotUpdate(bag)
	if not self.buttons then
		return
	end

	for _, v in ipairs (self.buttons) do
		if v.bag == bag then
			self:SlotUpdate(v)
		end
	end
end

function B:Bags_OnShow()
	B:PLAYERBANKSLOTS_CHANGED(29)
	B:Layout()
end

function B:Bags_OnHide()
	if bankFrame then
		bankFrame:Hide()
	end
end

local UpdateSearch = function(self, t)
	if t == true then
		B:SearchUpdate(self:GetText(), self:GetParent())
	end
end

function B:SearchUpdate(str, frameMatch)
	str = string.lower(str)
	_highlight = false
	for _, b in ipairs(self.buttons) do
		if b.name then
			local _, setName = GetContainerItemEquipmentSetInfo(b.bag, b.slot)
			setName = setName or ""
			local ilink = GetContainerItemLink(b.bag, b.slot)
			local class, subclass, _, equipSlot = select(6, GetItemInfo(ilink))
			equipSlot = _G[equipSlot] or ""
			if (not string.find (string.lower(b.name), str) and not string.find (string.lower(setName), str) and not string.find (string.lower(class), str) and not string.find (string.lower(subclass), str) and not string.find (string.lower(equipSlot), str)) and b.frame:GetParent():GetParent() == frameMatch then
				-- SetItemButtonDesaturated(b.frame, 1, 1, 1, 1)
				b.frame:SetAlpha(0.4)
			else
				-- SetItemButtonDesaturated(b.frame, 0, 1, 1, 1)
				b.frame:SetAlpha(1)
			end
		end
	end
end

function B:SearchReset()
	for _, b in ipairs(self.buttons) do
		-- SetItemButtonDesaturated(b.frame, 0, 1, 1, 1)
		b.frame:SetAlpha(1)
	end
end

local function OpenEditbox(self)
	self:GetParent().detail:Hide()
	self:GetParent().editBox:Show()
	self:GetParent().editBox:SetText(SEARCH)
	self:GetParent().editBox:HighlightText()
end


local function Tooltip_Hide(self)
	if self.backdropTexture then
		self:SetBackdropBorderColor(unpack(R["media"].bordercolor))
	end

	GameTooltip:Hide()
end

local function Tooltip_Show(self)
	GameTooltip:SetOwner(self:GetParent(), "ANCHOR_TOP", 0, 4)
	GameTooltip:ClearLines()
	GameTooltip:AddLine(self.ttText)

	if self.ttText2 then
		GameTooltip:AddLine(" ")
		GameTooltip:AddDoubleLine(self.ttText2, self.ttText2desc, 1, 1, 1)
	end

	GameTooltip:Show()

	if self.backdropTexture then
		self:SetBackdropBorderColor(0, .5, 1)
	end
end

function B:CreateBagFrame(type)
	local name = type.."Frame"
	local f = CreateFrame("Button", name, UIParent)
	S:SetBD(f)
	f:SetFrameStrata("DIALOG")
	f:SetMovable(true)
	f:SetClampedToScreen(true)
	f:RegisterForDrag("LeftButton")
	f:SetScript("OnDragStart", function(self) self:StartMoving() self:SetUserPlaced(false) end)
	f:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)

	if type == "Bags" then
		f:Point("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -15, 30)
	else
		f:Point("BOTTOMRIGHT", BagsFrameHolderFrame, "BOTTOMLEFT", -30, 0)
	end

	f.HolderFrame = CreateFrame("Frame", name.."HolderFrame", f)

	f.closeButton = CreateFrame("Button", name.."CloseButton", f)
	f.closeButton:Point("TOPRIGHT", -3, -3)
	f.closeButton:Size(15, 15)
	f.closeButton:SetScript("OnEnter", Tooltip_Show)
	f.closeButton:SetScript("OnLeave", Tooltip_Hide)
	S:ReskinClose(f.closeButton)

	if type == "bags" then
		f.closeButton:SetScript("OnClick", self.CloseBags)
	else
		f.closeButton:SetScript("OnClick", function() f:Hide() end)
	end

	f.editBox = CreateFrame("EditBox", name.."EditBox", f)
	f.editBox:Hide()
	f.editBox:SetFrameLevel(f.editBox:GetFrameLevel() + 2)
	f.editBox:Height(15)
	f.editBox:Point("BOTTOMLEFT", f.HolderFrame, "TOPLEFT", 2, -31)
	f.editBox:Point("BOTTOMRIGHT", f.HolderFrame, "TOPRIGHT", -123, -31)
	f.editBox:SetAutoFocus(true)
	f.editBox:SetScript("OnEscapePressed", ResetAndClear)
	f.editBox:SetScript("OnEnterPressed", ResetAndClear)
	f.editBox:SetScript("OnEditFocusLost", f.editBox.Hide)
	f.editBox:SetScript("OnEditFocusGained", f.editBox.HighlightText)
	f.editBox:SetScript("OnTextChanged", UpdateSearch)
	f.editBox:SetText(SEARCH)
	f.editBox:SetFont(R["media"].font, R["media"].fontsize)
	f.editBox:SetShadowColor(0, 0, 0)
	f.editBox:SetShadowOffset(R.mult, -R.mult)
	f.editBox.border = CreateFrame("Frame", nil, f.editBox)
	f.editBox.border:Point("TOPLEFT", -3, 0)
	f.editBox.border:Point("BOTTOMRIGHT", 0, 0)
	S:CreateBD(f.editBox.border, 0)

	local tex = f.editBox:CreateTexture(nil, "BACKGROUND")
	tex:Point("TOPLEFT", -3, 0)
	tex:Point("BOTTOMRIGHT", 0, 0)
	tex:SetTexture(S["media"].backdrop)
	tex:SetGradientAlpha("VERTICAL", 0, 0, 0, .3, .35, .35, .35, .35)

	f.detail = f:CreateFontString(nil, "ARTWORK")
	f.detail:SetFont(R["media"].font, R["media"].fontsize)
	f.detail:SetShadowColor(0, 0, 0)
	f.detail:SetShadowOffset(R.mult, -R.mult)
	f.detail:SetAllPoints(f.editBox)
	f.detail:SetJustifyH("LEFT")
	f.detail:SetText(SEARCH)

	local button = CreateFrame("Button", nil, f)
	button:RegisterForClicks("LeftButtonUp", "RightButtonUp")
	button:SetAllPoints(f.detail)
	button.ttText = SEARCHING_FOR_ITEMS
	button:SetScript("OnClick", function(self, btn)
		if btn == "RightButton" then
			OpenEditbox(self)
		else
			if self:GetParent().editBox:IsShown() then
				self:GetParent().editBox:Hide()
				self:GetParent().editBox:ClearFocus()
				self:GetParent().detail:Show()
				B:SearchReset()
			else
				OpenEditbox(self)
			end
		end
	end)

	button:SetScript("OnEnter", Tooltip_Show)
	button:SetScript("OnLeave", Tooltip_Hide)

	f.ContainerHolder = CreateFrame("Frame", name.."ContainerHolder", f)
	f.ContainerHolder:SetFrameLevel(f.ContainerHolder:GetFrameLevel() + 4)
	f.ContainerHolder:Point("BOTTOMLEFT", f, "TOPLEFT", 0, 1)
	f.ContainerHolder.buttons = {}
	f.ContainerHolder:Hide()
	S:CreateBD(f.ContainerHolder)

	return f
end

function B:InitBags()
	local f = self:CreateBagFrame("Bags")
	f:SetScript("OnShow", self.Bags_OnShow)
	f:SetScript("OnHide", self.Bags_OnHide)

	--Gold Text
	f.goldText = f:CreateFontString(nil, "OVERLAY")
	f.goldText:SetFont(R["media"].font, R["media"].fontsize)
	f.goldText:SetShadowColor(0, 0, 0)
	f.goldText:SetShadowOffset(R.mult, -R.mult)
	f.goldText:Height(15)
	f.goldText:Point("BOTTOMLEFT", f.detail, "BOTTOMRIGHT", 4, 0)
	f.goldText:Point("TOPRIGHT", f.HolderFrame, "TOPRIGHT", -12, -17)
	f.goldText:SetJustifyH("RIGHT")
	f.goldText:SetText(GetCoinTextureString(GetMoney(), 12))

	f:SetScript("OnEvent", function(self)
		self.goldText:SetText(GetCoinTextureString(GetMoney(), 12))
	end)
	f:RegisterEvent("PLAYER_MONEY")
	f:RegisterEvent("PLAYER_ENTERING_WORLD")
	f:RegisterEvent("PLAYER_TRADE_MONEY")
	f:RegisterEvent("TRADE_MONEY_CHANGED")

	--Sort Button
	f.sortButton = CreateFrame("Button", nil, f)
	f.sortButton:Point("TOPLEFT", f, "TOPLEFT", 7, -4)
	f.sortButton:Size(55, 10)
	f.sortButton.ttText = L["整理背包"]
	f.sortButton.ttText2 = L["按住shift:"]
	f.sortButton.ttText2desc = L["整理特殊背包"]
	f.sortButton:SetScript("OnEnter", Tooltip_Show)
	f.sortButton:SetScript("OnLeave", Tooltip_Hide)
	f.sortButton:SetScript("OnClick", function()
		if IsShiftKeyDown() then
			B:Sort(f, "c/p")
		else
			B:Sort(f, "d")
		end
	end)
	S:Reskin(f.sortButton)

	--ItemSets Button
	f.itemSetsButton = CreateFrame("Button", nil, f)
	f.itemSetsButton:Point("LEFT", f.sortButton, "RIGHT", 3, 0)
	f.itemSetsButton:Size(55, 10)
	f.itemSetsButton.ttText = L["高亮套装"]
	f.itemSetsButton.ttText2 = L["按住shift:"]
	f.itemSetsButton.ttText2desc = L["反向显示"]
	f.itemSetsButton:SetScript("OnEnter", Tooltip_Show)
	f.itemSetsButton:SetScript("OnLeave", Tooltip_Hide)
	f.itemSetsButton:SetScript("OnClick", function()
		B:HighlightItemSets(IsShiftKeyDown())
	end)
	S:Reskin(f.itemSetsButton)

	--Bags Button
	f.bagsButton = CreateFrame("Button", nil, f)
	f.bagsButton:Point("LEFT", f.itemSetsButton, "RIGHT", 3, 0)
	f.bagsButton:Size(55, 10)
	f.bagsButton.ttText = L["显示背包"]
	f.bagsButton:SetScript("OnEnter", Tooltip_Show)
	f.bagsButton:SetScript("OnLeave", Tooltip_Hide)
	f.bagsButton:SetScript("OnClick", function() 
		ToggleFrame(f.ContainerHolder) 
	end)
	S:Reskin(f.bagsButton)

	tinsert(UISpecialFrames, f:GetName())

	f:Hide()
	bagFrame = f
end

function B:InitBank()
	local f = self:CreateBagFrame("Bank")
	f:SetScript("OnHide", CloseBankFrame)

	--Gold Text
	f.purchaseBagButton = CreateFrame("Button", nil, f)
	f.purchaseBagButton:Size(100, 17)
	f.purchaseBagButton:Point("TOPRIGHT", f, "TOPRIGHT", -25, -4)
	f.purchaseBagButton:SetFrameLevel(f.purchaseBagButton:GetFrameLevel() + 2)
	f.purchaseBagButton.text = f.purchaseBagButton:CreateFontString(nil, "OVERLAY")
	f.purchaseBagButton.text:SetFont(R["media"].font, R["media"].fontsize)
	f.purchaseBagButton.text:SetShadowColor(0, 0, 0)
	f.purchaseBagButton.text:SetShadowOffset(R.mult, -R.mult)
	f.purchaseBagButton.text:SetPoint("CENTER", 0, 1)
	f.purchaseBagButton.text:SetJustifyH("CENTER")
	f.purchaseBagButton.text:SetText(BankFramePurchaseButton:GetText())
	f.purchaseBagButton:SetScript("OnEnter", Tooltip_Show)
	f.purchaseBagButton:SetScript("OnLeave", Tooltip_Hide)
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
	f.sortButton:Point("TOPLEFT", f, "TOPLEFT", 7, -4)
	f.sortButton:Size(55, 10)
	f.sortButton.ttText = L["整理背包"]
	f.sortButton.ttText2 = L["按住shift:"]
	f.sortButton.ttText2desc = L["整理特殊背包"]
	f.sortButton:SetScript("OnEnter", Tooltip_Show)
	f.sortButton:SetScript("OnLeave", Tooltip_Hide)
	f.sortButton:SetScript("OnClick", function()
		if IsShiftKeyDown() then
			B:Sort(f, "c/p", true)
		else
			B:Sort(f, "d", true)
		end
	end)
	S:Reskin(f.sortButton)

	--ItemSets Button
	f.itemSetsButton = CreateFrame("Button", nil, f)
	f.itemSetsButton:Point("LEFT", f.sortButton, "RIGHT", 3, 0)
	f.itemSetsButton:Size(55, 10)
	f.itemSetsButton.ttText = L["高亮套装"]
	f.itemSetsButton.ttText2 = L["按住shift:"]
	f.itemSetsButton.ttText2desc = L["反向显示"]
	f.itemSetsButton:SetScript("OnEnter", Tooltip_Show)
	f.itemSetsButton:SetScript("OnLeave", Tooltip_Hide)
	f.itemSetsButton:SetScript("OnClick", function() 
		B:HighlightItemSets(IsShiftKeyDown())
	end)
	S:Reskin(f.itemSetsButton)

	--Bags Button
	f.bagsButton = CreateFrame("Button", nil, f)
	f.bagsButton:Point("LEFT", f.itemSetsButton, "RIGHT", 3, 0)
	f.bagsButton:Size(55, 10)
	f.bagsButton.ttText = L["显示背包"]
	f.bagsButton:SetScript("OnEnter", Tooltip_Show)
	f.bagsButton:SetScript("OnLeave", Tooltip_Hide)
	f.bagsButton:SetScript("OnClick", function() 
		ToggleFrame(f.ContainerHolder) 
	end)
	S:Reskin(f.bagsButton)

	bankFrame = f
end

function B:BAG_UPDATE(event, id)
	self:BagSlotUpdate(id)
end

function B:QUEST_ACCEPTED(event)
	for _, x in ipairs(BAGS_BACKPACK) do
		self:BagSlotUpdate(x)
	end
end

function B:UNIT_QUEST_LOG_CHANGED(event, unit)
	if unit ~= "player" then return end
	for _, x in ipairs(BAGS_BACKPACK) do
		self:BagSlotUpdate(x)
	end
end

function B:ITEM_LOCK_CHANGED(event, bag, slot)
	if slot == nil then
		return
	end

	for _, v in ipairs(self.buttons) do
		if v.bag == bag and v.slot == slot then
			self:SlotUpdate(v)
			break
		end
	end
end

function B:BANKFRAME_OPENED(event)
	if not bankFrame then
		self:InitBank()
	end

	self:Layout(true)
	for _, x in ipairs(BAGS_BANK) do
		self:BagSlotUpdate(x)
	end

	bankFrame:Show()
	self:OpenBags()
end

function B:BANKFRAME_CLOSED(event)
	if not bankFrame then return end
	bankFrame:Hide()
end

function B:PLAYERBANKSLOTS_CHANGED(event)
	for i, v in pairs(self.buttons) do
		self:SlotUpdate(v)
	end

	for _, x in ipairs(BAGS_BANK) do
		self:BagSlotUpdate(x)
	end
end

function B:GUILDBANKBAGSLOTS_CHANGED(event)
	for i, v in pairs(self.buttons) do
		self:SlotUpdate(v)
	end

	for _, x in ipairs(BAGS_BANK) do
		self:BagSlotUpdate(x)
	end
end

function B:BAG_CLOSED(event, id)
	local b = self.bags[id]
	if b then
		table.remove(self.bags, id)
		b:Hide()
		table.insert(trashBag, #trashBag + 1, b)
	end

	while true do
		local changed = false

		for i, v in ipairs(self.buttons) do
			if v.bag == id then
				v.frame:Hide()

				table.insert(trashButton, #trashButton + 1, v.frame)
				table.remove(self.buttons, i)

				v = nil
				changed = true
			end
		end

		if not changed then
			break
		end
	end

	if bagFrame:IsShown() then
		ToggleFrame(bagFrame)
		ToggleFrame(bagFrame)
	end
end

function B:CloseBags()
	self:HighlightItemSets(nil, true)
	bagFrame:Hide()

	if bankFrame then
		bankFrame:Hide()
	end
end

function B:OpenBags()
	bagFrame:Show()
end

function B:ToggleBags()
	if bagFrame:IsShown() then
		self:HighlightItemSets(nil, true)
	end
	ToggleFrame(bagFrame)
end

function B:RestackOnUpdate(e)
	if not self.elapsed then
		self.elapsed = 0
	end

	self.elapsed = self.elapsed + e

	if self.elapsed < 0.1 then
		return
	end

	self.elapsed = 0
	B:RestackAndSort(self)
end

local function InBags(x)
	if not B.bags[x] then
		return false
	end

	for _, v in ipairs(B.sortBags) do
		if x == v then
			return true
		end
	end
	return false
end

function B:BAG_UPDATE_COOLDOWN()
	for i, v in pairs(self.buttons) do
		self:SlotUpdate(v)
	end
end

function B:RestackAndSort(frame)
	local st = {}

	B:OpenBags()

	for i, v in pairs(self.buttons) do
		if InBags(v.bag) then
			local tex, cnt, _, _, _, _, clink = GetContainerItemInfo(v.bag, v.slot)
			if clink then
				local n, _, _, _, _, _, _, s = GetItemInfo(clink)

				if cnt ~= s then
					if not st[n] then
						st[n] = {{
							item = v,
							size = cnt,
							max = s
						}}
					else
						table.insert(st[n], {
							item = v,
							size = cnt,
							max = s
						})
					end
				end
			end
		end
	end

	local did_restack = false

	for i, v in pairs(st) do
		if #v > 1 then
			for j = 2, #v, 2 do
				local a, b = v[j - 1], v[j]
				local _, _, l1 = GetContainerItemInfo(a.item.bag, a.item.slot)
				local _, _, l2 = GetContainerItemInfo(b.item.bag, b.item.slot)

				if l1 or l2 then
					did_restack = true
				else
					PickupContainerItem (a.item.bag, a.item.slot)
					PickupContainerItem (b.item.bag, b.item.slot)
					did_restack = true
				end
			end
		end
	end

	if did_restack then
		frame:SetScript("OnUpdate", B.RestackOnUpdate)
	else
		frame:SetScript("OnUpdate", B.SortOnUpdate)
	end
end

function B:SortOnUpdate(e)
	if not self.elapsed then
		self.elapsed = 0
	end

	if not B.itmax then
		B.itmax = 0
	end

	self.elapsed = self.elapsed + e

	if self.elapsed < 0.1 then
		return
	end

	self.elapsed = 0
	B.itmax = B.itmax + 1

	local changed, blocked  = false, false

	if B.sortList == nil or next(B.sortList, nil) == nil then
		-- wait for all item locks to be released.
		local locks = false

		for i, v in pairs(B.buttons) do
			local _, _, l = GetContainerItemInfo(v.bag, v.slot)
			if l then
				locks = true
			else
				v.block = false
			end
		end

		if locks then
			-- something still locked. wait some more.
			return
		else
			-- all unlocked. get a new table.
			self:SetScript("OnUpdate", nil)
			B:SortBags(self)

			if B.sortList == nil then
				return
			end
		end
	end

	-- go through the list and move stuff if we can.
	for i, v in ipairs (B.sortList) do
		repeat
			if v.ignore then
				blocked = true
				break
			end

			if v.srcSlot.block then
				changed = true
				break
			end

			if v.dstSlot.block then
				changed = true
				break
			end

			local _, _, l1 = GetContainerItemInfo(v.dstSlot.bag, v.dstSlot.slot)
			local _, _, l2 = GetContainerItemInfo(v.srcSlot.bag, v.srcSlot.slot)

			if l1 then
				v.dstSlot.block = true
			end

			if l2 then
				v.srcSlot.block = true
			end

			if l1 or l2 then
				break
			end

			if v.sbag ~= v.dbag or v.sslot ~= v.dslot then
				if v.srcSlot.name ~= v.dstSlot.name then
					v.srcSlot.block = true
					v.dstSlot.block = true
					PickupContainerItem (v.sbag, v.sslot)
					PickupContainerItem (v.dbag, v.dslot)
					changed = true
					break
				end
			end
		until true
	end

	B.sortList = nil

	if (not changed and not blocked) or B.itmax > 250 then
		self:SetScript("OnUpdate", nil)
		B.sortList = nil
	end
end

function B:SortBags(frame)
	if InCombatLockdown() then return end
	local bs = self.sortBags
	if #bs < 1 then
		return
	end

	local st = {}
	self:OpenBags()

	for i, v in pairs(self.buttons) do
		if InBags(v.bag) then
			self:SlotUpdate(v)

			if v.name then
				local tex, cnt, _, _, _, _, clink = GetContainerItemInfo(v.bag, v.slot)
				local n, _, q, iL, rL, c1, c2, _, Sl = GetItemInfo(clink)
				table.insert(st, {
					srcSlot = v,
					sslot = v.slot,
					sbag = v.bag,
					--sort = q .. iL .. c1 .. c2 .. rL .. Sl .. n .. i,
					--sort = q .. iL .. c1 .. c2 .. rL .. Sl .. n .. (#self.buttons - i),
					-- sort = q .. c1 .. c2 .. rL .. n .. iL .. Sl .. (#self.buttons - i),
					sort = q .. c1 .. c2 .. Sl .. rL .. n .. iL .. cnt ..  (#self.buttons - i) ,
					--sort = q .. (#self.buttons - i) .. n,
				})
			end
		end
	end

	table.sort (st, function(a, b)
		return a.sort > b.sort
	end)

	local st_idx = #bs
	local dbag = bs[st_idx]
	local dslot = GetContainerNumSlots(dbag)
 
	for i, v in ipairs (st) do
		v.dbag = dbag
		v.dslot = dslot
		v.dstSlot = self:SlotNew(dbag, dslot)
 
		dslot = dslot - 1
 
		if dslot == 0 then
			while true do
				st_idx = st_idx - 1
 
				if st_idx < 0 then
					break
				end
 
				dbag = bs[st_idx]

				if dbag and (B:BagType(dbag) == ST_NORMAL or B:BagType(dbag) == ST_SPECIAL or dbag < 1) then
					break
				end
			end

			if dbag then
				dslot = GetContainerNumSlots(dbag)
			else
				dslot = 8
			end
		end
	end

	local changed = true
	while changed do
		changed = false
		for i, v in ipairs (st) do
			if (v.sslot == v.dslot) and (v.sbag == v.dbag) then
				table.remove (st, i)
				changed = true
			end
		end
	end

	if st == nil or next(st, nil) == nil then
		frame:SetScript("OnUpdate", nil)
	else
		self.sortList = st
		frame:SetScript("OnUpdate", B.SortOnUpdate)
	end
end

function B:SetBagsForSorting(c, bank)
	self:OpenBags()

	self.sortBags = {}

	local cmd = ((c == nil or c == "") and {"d"} or {strsplit("/", c)})

	for _, s in ipairs(cmd) do
		if s == "c" then
			self.sortBags = {}
		elseif s == "d" then
			if not bank then
				for _, i in ipairs(BAGS_BACKPACK) do
					if self.bags[i] and self.bags[i].bagType == ST_NORMAL then
						table.insert(self.sortBags, i)
					end
				end
			else
				for _, i in ipairs(BAGS_BANK) do
					if self.bags[i] and self.bags[i].bagType == ST_NORMAL then
						table.insert(self.sortBags, i)
					end
				end
			end
		elseif s == "p" then
			if not bank then
				for _, i in ipairs(BAGS_BACKPACK) do
					if self.bags[i] and self.bags[i].bagType == ST_SPECIAL then
						table.insert(self.sortBags, i)
					end
				end
			else
				for _, i in ipairs(BAGS_BANK) do
					if self.bags[i] and self.bags[i].bagType == ST_SPECIAL then
						table.insert(self.sortBags, i)
					end
				end
			end
		else
			table.insert(self.sortBags, tonumber(s))
		end
	end
end

function B:Sort(frame, args, bank)
	if not args then
		args = ""
	end

	if _highlight then
		self:HighlightItemSets(nil, true)
	end

	self.itmax = 0
	self:SetBagsForSorting(args, bank)
	-- self:SortBags(frame)
	self:RestackAndSort(frame)
end

function B:HighlightItemSets(reverse, reset)
	if reset then
		for _, b in ipairs(self.buttons) do
			if b.name then
				-- SetItemButtonDesaturated(b.frame, 0, 1, 1, 1)
				b.frame:SetAlpha(1)
			end
		end
		_highlight = false
		return
	end
	if not _highlight then
		for _, b in ipairs(self.buttons) do
			if b.name then
				local _, setName = GetContainerItemEquipmentSetInfo(b.bag, b.slot)
				if setName then
					if reverse then
						-- SetItemButtonDesaturated(b.frame, 1, 1, 1, 1)
						b.frame:SetAlpha(0.4)
					else
						-- SetItemButtonDesaturated(b.frame, 0, 1, 1, 1)
						b.frame:SetAlpha(1)
					end
				else
					if reverse then
						-- SetItemButtonDesaturated(b.frame, 0, 1, 1, 1)
						b.frame:SetAlpha(1)
					else
						-- SetItemButtonDesaturated(b.frame, 1, 1, 1, 1)
						b.frame:SetAlpha(0.4)
					end
				end
			end
		end
		_highlight = true
	else
		for _, b in ipairs(self.buttons) do
			if b.name then
				-- SetItemButtonDesaturated(b.frame, 0, 1, 1, 1)
				b.frame:SetAlpha(1)
			end
		end
		_highlight = false
	end
end

function B:Initialize()
	self:InitBags()

	--Register Events
	self:RegisterEvent("QUEST_ACCEPTED")
	self:RegisterEvent("UNIT_QUEST_LOG_CHANGED")
	self:RegisterEvent("BAG_UPDATE")
	self:RegisterEvent("ITEM_LOCK_CHANGED")
	self:RegisterEvent("BANKFRAME_OPENED")
	self:RegisterEvent("BANKFRAME_CLOSED")
	self:RegisterEvent("PLAYERBANKSLOTS_CHANGED")
	self:RegisterEvent("BAG_CLOSED")
	self:RegisterEvent("BAG_UPDATE_COOLDOWN")
	self:RegisterEvent("GUILDBANKBAGSLOTS_CHANGED")

	--Hook onto Blizzard Functions
	self:RawHook("ToggleBackpack", "ToggleBags", true)
	self:RawHook("ToggleBag", "ToggleBags", true)
	self:RawHook("ToggleAllBags", "ToggleBags", true)
	self:RawHook("OpenAllBags", "OpenBags", true)
	self:RawHook("OpenBackpack", "OpenBags", true)
	self:RawHook("CloseAllBags", "CloseBags", true)
	self:RawHook("CloseBackpack", "CloseBags", true)

	TradeFrame:HookScript("OnShow", function() B:OpenBags() end)
	TradeFrame:HookScript("OnHide", function() B:CloseBags() end)

	--Stop Blizzard bank bags from functioning.
	BankFrame:UnregisterAllEvents()

	StackSplitFrame:SetFrameStrata("DIALOG")
	LootFrame:SetFrameStrata("DIALOG")

	ToggleBackpack()
	ToggleBackpack()
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
	preferredIndex = 3
}

StaticPopupDialogs["CANNOT_BUY_BANK_SLOT"] = {
	text = L["不能购买更多的银行栏位了!"],
	button1 = ACCEPT,
	timeout = 0,
	whileDead = 1,
	preferredIndex = 3
}

StaticPopupDialogs["NO_BANK_BAGS"] = {
	text = L["你必须先购买一个银行栏位!"],
	button1 = ACCEPT,
	timeout = 0,
	whileDead = 1,
	preferredIndex = 3
}

R:RegisterModule(B:GetName())
