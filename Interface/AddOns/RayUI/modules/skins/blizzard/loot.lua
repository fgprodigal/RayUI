local R, L, P = unpack(select(2, ...)) --Inport: Engine, Locales, ProfileDB
local S = R:GetModule("Skins")

local function LoadSkin()
	if not(IsAddOnLoaded("Butsu") or IsAddOnLoaded("LovelyLoot") or IsAddOnLoaded("XLoot")) then
		local slotsize = 36
		lootSlots = {}
		local anchorframe = CreateFrame("Frame", "ItemLoot", UIParent)
		anchorframe:SetSize(200, 15)
		anchorframe:SetPoint("TOPLEFT", 300, -300)

		local function OnClick(self)
			if IsModifiedClick() then
				HandleModifiedItemClick(GetLootSlotLink(self.id))
			else
				StaticPopup_Hide("CONFIRM_LOOT_DISTRIBUTION")
				LootFrame.selectedSlot = self.id
				LootFrame.selectedQuality = self.quality
				LootFrame.selectedItemName = self.text:GetText()
				LootSlot(self.id)
			end
		end

		local function OnEnter(self)
			if GetLootSlotType(self.id) == LOOT_SLOT_ITEM then
				GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
				GameTooltip:SetLootItem(self.id)
				CursorUpdate(self)
			end
		end

		local function OnLeave(self)
			GameTooltip:Hide()
			ResetCursor()
		end

		local function CreateLootSlot(self, id)
			local slot = CreateFrame("Button", nil, self)
			slot:SetPoint("TOPLEFT", 3, -20 - (id - 1) * (slotsize + 5))
			slot:SetSize(slotsize, slotsize)
			slot:SetBackdrop({
					bgFile = R["media"].blank, 
					insets = { left = -R.mult, right = -R.mult, top = -R.mult, bottom = -R.mult }
				})
			slot:StyleButton()
			slot.texture = slot:CreateTexture(nil, "BORDER")
			slot.texture:Point("TOPLEFT", 2, -2)
			slot.texture:Point("BOTTOMRIGHT", -2, 2)
			slot.texture:SetTexCoord(0.08, 0.92, 0.08, 0.92)
			slot.text = slot:CreateFontString(nil, "OVERLAY")
			slot.text:SetFont(R["media"].font, R["media"].fontsize, R["media"].fontflag)
			slot.text:SetPoint("LEFT", slot, "RIGHT", 4, 0)
			slot.text:SetPoint("RIGHT", slot:GetParent(), "RIGHT", -4, 0)
			slot.text:SetJustifyH("LEFT")
			slot.glow = CreateFrame("Frame", nil, slot)
			slot.glow:SetAllPoints()
			slot.glow:SetFrameLevel(slot:GetFrameLevel()+1)
			slot.glow:CreateBorder()
			slot.count = slot:CreateFontString(nil, "OVERLAY")
			slot.count:SetFont(R["media"].font, R["media"].fontsize, R["media"].fontflag)
			slot.count:SetPoint("BOTTOMRIGHT", 0, 4)
			slot.quest = slot:CreateTexture(nil, "OVERLAY")
			slot.quest:SetTexture(TEXTURE_ITEM_QUEST_BANG)
			slot.quest:SetInside(slot)
			slot.quest:SetTexCoord(.08, .92, .08, .92)
			slot.quest:Hide()
			slot:SetScript("OnClick", OnClick)
			slot:SetScript("OnEnter", OnEnter)
			slot:SetScript("OnLeave", OnLeave)
			slot:Hide()
			return slot
		end

		local function GetLootSlot(self, id)
			if not lootSlots[id] then 
				lootSlots[id] = CreateLootSlot(self, id)
			end
			return lootSlots[id]
		end

		local function UpdateLootSlot(self, id)
			local lootSlot = GetLootSlot(self, id)
			local texture, item, quantity, quality, locked, isQuestItem, questId, isActive = GetLootSlotInfo(id)
			if not item then return end
            local color = ITEM_QUALITY_COLORS[quality]
            lootSlot.quality = quality
			lootSlot.id = id
			lootSlot.texture:SetTexture(texture)
			lootSlot.text:SetText(item)
			lootSlot.text:SetTextColor(color.r, color.g, color.b)
			if quantity > 1 then
				lootSlot.count:SetText(quantity)
				lootSlot.count:Show()
			else
				lootSlot.count:Hide()
			end
			if isActive == false then
				lootSlot.quest:Show()
			else
				lootSlot.quest:Hide()
			end
			local glow = lootSlot.glow
			if quality and quality > 1 then
				lootSlot.texture:SetInside()
				lootSlot:StyleButton()
				glow:SetBackdropBorderColor(color.r, color.g, color.b)
				lootSlot:SetBackdropColor(0, 0, 0)
			else
				lootSlot.texture:SetAllPoints()
				glow:SetBackdropBorderColor(0, 0, 0)
				lootSlot:SetBackdropColor(0, 0, 0, 0)
				lootSlot:StyleButton(true)
			end
			if R:IsItemUnusable(GetLootSlotLink(id)) or locked then
				lootSlot.texture:SetVertexColor(RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b)
			else
				lootSlot.texture:SetVertexColor(1, 1, 1)
			end
			lootSlot:Show()
		end

		local function OnEvent(self, event, ...)
			if event == "LOOT_OPENED" then
				local autoLoot = ...
				self:Show()
				if UnitExists("target") and UnitIsDead("target") then
					self.title:SetText(UnitName("target"))
				else
					self.title:SetText(ITEMS)
				end
				local numLootItems = GetNumLootItems()
				self:SetHeight(numLootItems * (slotsize + 5) + 20)
				if GetCVar("lootUnderMouse") == "1" then
					local x, y = GetCursorPosition()
					x = x / self:GetEffectiveScale()
					y = y / self:GetEffectiveScale()
					local posX = x - 15
					local posY = y + 32
					if posY < 350 then
						posY = 350
					end
					self:ClearAllPoints()
					self:SetPoint("TOPLEFT", nil, "BOTTOMLEFT", posX, posY)
					self:GetCenter()
					self:Raise()
				end
				if numLootItems > 0 then
					for i = 1, numLootItems do
						UpdateLootSlot(self, i)
					end
				else
					CloseLoot()
				end
				if not self:IsShown() then
					CloseLoot(autoLoot == 0)
				end
			elseif event == "LOOT_SLOT_CLEARED" then
				local slotId = ...
				if not self:IsShown() then return end
				if slotId > 0 then
					if lootSlots[slotId] then
						lootSlots[slotId]:Hide()
					end
				end
			elseif event == "LOOT_SLOT_CHANGED" then
				local slotId = ...
				UpdateLootSlot(self, slotId)
			elseif event == "LOOT_CLOSED" then
				StaticPopup_Hide("LOOT_BIND")
				for i, v in pairs(lootSlots) do
					v:Hide()
				end
				self:Hide()
			elseif event == "OPEN_MASTER_LOOT_LIST" then
				ToggleDropDownMenu(1, nil, GroupLootDropDown, lootSlots[LootFrame.selectedSlot], 0, 0)
			elseif event == "UPDATE_MASTER_LOOT_LIST" then
				UIDropDownMenu_Refresh(GroupLootDropDown)
			end
		end

		local loot = CreateFrame("Frame", nil, UIParent)
		loot:SetScript("OnEvent", OnEvent)
		loot:RegisterEvent("LOOT_OPENED")
		loot:RegisterEvent("LOOT_SLOT_CLEARED")
		loot:RegisterEvent("LOOT_SLOT_CHANGED")
		loot:RegisterEvent("LOOT_CLOSED")
		loot:RegisterEvent("OPEN_MASTER_LOOT_LIST")
		loot:RegisterEvent("UPDATE_MASTER_LOOT_LIST")
		LootFrame:UnregisterAllEvents()

		S:CreateBD(loot)
		loot:SetWidth(200)
		loot:SetPoint("TOP", anchorframe, 0, 0)
		loot:SetFrameStrata("FULLSCREEN_DIALOG")
		loot:SetToplevel(true)
		loot:EnableMouse(true)
		loot:SetMovable(true)
		loot:RegisterForDrag("LeftButton")
		loot:SetScript("OnDragStart", function(self) self:StartMoving() self:SetUserPlaced(false) end)
		loot:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
		loot.title = loot:CreateFontString(nil, "OVERLAY")
		loot.title:SetFont(R["media"].font, R["media"].fontsize, R["media"].fontflag)
		loot.title:SetPoint("TOPLEFT", 3, -4)
		loot.title:SetPoint("TOPRIGHT", -105, -4)
		loot.title:SetJustifyH("LEFT")
		loot.button = CreateFrame("Button", nil, loot)
		loot.button:SetPoint("TOPRIGHT")
		loot.button:SetSize(17, 17)
		S:ReskinClose(loot.button)
		loot.button:SetScript("OnClick", function()
			CloseLoot()
		end)

		local chn = { "say", "guild", "party", "raid"}
		local chncolor = {
			say = { 1, 1, 1},
			guild = { .25, 1, .25},
			party = { 2/3, 2/3, 1},
			raid = { 1, .5, 0},
		}
		local function Announce(chn)
			local nums = GetNumLootItems()
			if(nums == 0) then return end
			if UnitIsPlayer("target") or not UnitExists("target") then -- Chests are hard to identify!
				SendChatMessage(format("*** %s ***", L["箱子中的战利品"]), chn)
			else
				SendChatMessage(format("*** %s%s ***", UnitName("target"), L["的战利品"]), chn)
			end
			for i = 1, GetNumLootItems() do
				local link
				if(LootSlotHasItem(i)) then     --判断，只发送物品
					link = GetLootSlotLink(i)
				else
					_, link = GetLootSlotInfo(i)
				end
				if link then
					local messlink = "- %s"
					SendChatMessage(format(messlink, link), chn)
				end
			end
		end

		loot.announce = {}
		for i = 1, #chn do
			loot.announce[i] = CreateFrame("Button", "ItemLootAnnounceButton"..i, loot)
			loot.announce[i]:SetSize(17, 17)
			loot.announce[i]:SetPoint("RIGHT", i==1 and loot.button or loot.announce[i-1], "LEFT", -3, 0)
			loot.announce[i]:SetScript("OnClick", function() Announce(chn[i]) end)
			loot.announce[i]:SetScript("OnEnter", function(self)
				GameTooltip:SetOwner(self, "ANCHOR_TOP", 0, 5)
				GameTooltip:ClearLines()
				GameTooltip:AddLine(L["将战利品通报至"].._G[chn[i]:upper()])
				GameTooltip:Show()
			end)
			loot.announce[i]:SetScript("OnLeave", GameTooltip_Hide)
			loot.announce[i]:SetBackdrop({
				bgFile = R["media"].blank,
				edgeFile = R["media"].blank, 
				edgeSize = R.mult
			})
			loot.announce[i]:SetBackdropBorderColor(unpack(R["media"].bordercolor))
			loot.announce[i]:SetBackdropColor(unpack(chncolor[chn[i]]))
			loot.announce[i]:StyleButton(1)
		end
	end
	
	-- Missing loot frame
	MissingLootFrameCorner:Hide()

	hooksecurefunc("MissingLootFrame_Show", function()
		for i = 1, GetNumMissingLootItems() do
			local bu = _G["MissingLootFrameItem"..i]

			if not bu.styled then
				_G["MissingLootFrameItem"..i.."NameFrame"]:Hide()

				bu.icon:SetTexCoord(.08, .92, .08, .92)
				bu.icon.bg = S:CreateBG(bu.icon)
				bu:StyleButton(true)

				bu.styled = true
			end

			bu.icon.bg:SetVertexColor(bu.name:GetVertexColor())
		end
	end)

	S:CreateBD(MissingLootFrame)
	S:ReskinClose(MissingLootFramePassButton)
end

S:RegisterSkin("RayUI", LoadSkin)
