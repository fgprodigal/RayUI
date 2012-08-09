local R, L, P = unpack(select(2, ...)) --Inport: Engine, Locales, ProfileDB
local S = R:GetModule("Skins")

local function LoadSkin()
	S:SetBD(InspectFrame)
	InspectFrame:DisableDrawLayer("BACKGROUND")
	InspectFrame:DisableDrawLayer("BORDER")
	InspectFrameInset:DisableDrawLayer("BACKGROUND")
	InspectFrameInset:DisableDrawLayer("BORDER")
	InspectModelFrame:DisableDrawLayer("OVERLAY")
	InspectTalentFrame:DisableDrawLayer("BACKGROUND")
	InspectTalentFrame:DisableDrawLayer("BORDER")

	InspectPVPTeam1:DisableDrawLayer("BACKGROUND")
	InspectPVPTeam2:DisableDrawLayer("BACKGROUND")
	InspectPVPTeam3:DisableDrawLayer("BACKGROUND")
	InspectFramePortrait:Hide()
	InspectGuildFrameBG:Hide()
	for i = 1, 5 do
		select(i, InspectModelFrame:GetRegions()):Hide()
	end
	InspectFramePortraitFrame:Hide()
	InspectFrameTopBorder:Hide()
	InspectFrameTopRightCorner:Hide()
	InspectPVPFrameBG:SetAlpha(0)
	InspectPVPFrameBottom:SetAlpha(0)
	for i = 1, 4 do
		local tab = _G["InspectFrameTab"..i]
		S:CreateTab(tab)
		if i ~= 1 then
			tab:SetPoint("LEFT", _G["InspectFrameTab"..i-1], "RIGHT", -15, 0)
		end
	end

	for i = 1, MAX_NUM_TALENT_TIERS do
			local row = _G["TalentsTalentRow"..i]
			row:DisableDrawLayer("BORDER")

			for j = 1, NUM_TALENT_COLUMNS do
				local bu = _G["TalentsTalentRow"..i.."Talent"..j]
				local border = _G["TalentsTalentRow"..i.."Talent"..j.."Border"]
				local ic = _G["TalentsTalentRow"..i.."Talent"..j.."IconTexture"]

				border:Kill()
				bu:SetHighlightTexture("")
				bu.Slot:SetAlpha(0)

				ic:SetDrawLayer("ARTWORK")
				ic:SetTexCoord(.08, .92, .08, .92)
				S:CreateBG(ic)
			end
		end

	local slots = {
		"Head",
		"Neck",
		"Shoulder",
		"Shirt",
		"Chest",
		"Waist",
		"Legs",
		"Feet",
		"Wrist",
		"Hands",
		"Finger0",
		"Finger1",
		"Trinket0",
		"Trinket1",
		"Back",
		"MainHand",
		"SecondaryHand",
		"Tabard"
	}

	for i = 1, #slots do
		local slot = _G["Inspect"..slots[i].."Slot"]
		local icon = _G["Inspect"..slots[i].."SlotIconTexture"]
		_G["Inspect"..slots[i].."SlotFrame"]:Hide()
		slot:SetNormalTexture("")
		slot.backgroundTextureName = ""
		slot.checkRelic = nil
		slot:SetNormalTexture("")
		slot:StyleButton()
		icon:SetTexCoord(.08, .92, .08, .92)
		icon:Point("TOPLEFT", 2, -2)
		icon:Point("BOTTOMRIGHT", -2, 2)
		slot.glow = CreateFrame("Frame", nil, slot)
		slot.glow:SetAllPoints()
		slot.glow:CreateBorder()
	end
	select(7, InspectMainHandSlot:GetRegions()):Kill()
	-- select(7, InspectRangedSlot:GetRegions()):Kill()

	S:ReskinClose(InspectFrameCloseButton)

	local CheckItemBorderColor = CreateFrame("Frame")

	local function ColorItemBorder(slotName, itemLink)
		local target = _G["Inspect"..slotName.."Slot"]
		local icon = _G["Inspect"..slotName.."SlotIconTexture"]
		local glow = target.glow
		if itemLink then
			local _, _, rarity, _, _, _, _, _, _, _, _ = GetItemInfo(itemLink)
			if rarity and rarity > 1 then
				glow:SetAllPoints()
				glow:SetBackdropBorderColor(GetItemQualityColor(rarity))
				target:SetBackdrop({
					bgFile = R["media"].blank, 
					insets = { left = -R.mult, right = -R.mult, top = -R.mult, bottom = -R.mult }
				})
				target:SetBackdropColor(0, 0, 0)
			else
				glow:Point("TOPLEFT", 1, -1)
				glow:Point("BOTTOMRIGHT", -1, 1)
				glow:SetBackdropBorderColor(0, 0, 0)
				target:SetBackdropColor(0, 0, 0, 0)
			end
		else
			glow:SetBackdropBorderColor(0, 0, 0, 0)
			target:SetBackdropColor(0, 0, 0, 0)
		end
	end

	local _MISSING = {}

	CheckItemBorderColor:SetScript("OnUpdate", function(self, elapsed)
		local unit = InspectFrame.unit
		if(not unit) then
			self:Hide()
			table.wipe(_MISSING)
		end

		for i, slotName in next, _MISSING do
			local itemLink = GetInventoryItemLink(unit, i)
			if(itemLink) then
				ColorItemBorder(slotName, itemLink)

				_MISSING[i] = nil
			end
		end

		if(not next(_MISSING)) then
			self:Hide()
		end
	end)

	local function update()
		if(not InspectFrame or not InspectFrame:IsShown()) then return end

		local unit = InspectFrame.unit
		for i, slotName in next, slots do
			local itemLink = GetInventoryItemLink(unit, i)
			local itemTexture = GetInventoryItemTexture(unit, i)

			if(itemTexture and not itemLink) then
				_MISSING[i] = slotName
				CheckItemBorderColor:Show()
			end

			ColorItemBorder(slotName, itemLink)
		end
	end

	local function SlotUpdate(self)
		local unit = InspectFrame.unit
		local itemLink = GetInventoryItemLink(unit, self:GetID())
		ColorItemBorder(self:GetName():match("Inspect(.+)Slot"), itemLink)
	end

	CheckItemBorderColor:RegisterEvent("PLAYER_TARGET_CHANGED")
	CheckItemBorderColor:RegisterEvent("UNIT_INVENTORY_CHANGED")
	CheckItemBorderColor:RegisterEvent("INSPECT_READY")
	CheckItemBorderColor:SetScript("OnEvent", function(self, event, unit)
		if event == "UNIT_INVENTORY_CHANGED" then
			if(InspectFrame.unit == unit) then
				update()
			end
		else
			update()
		end
	end)
	InspectFrame:HookScript("OnShow", update)
	hooksecurefunc("InspectPaperDollItemSlotButton_Update", SlotUpdate)

	for i = 1, MAX_NUM_TALENTS do
		local bu = _G["InspectTalentFrameTalent"..i]
		local ic = _G["InspectTalentFrameTalent"..i.."IconTexture"]
		if bu then
			bu:StyleButton()
			bu:GetPushedTexture():StyleButton(1)
			bu.SetHighlightTexture = R.dummy
			bu.SetPushedTexture = R.dummy

			_G["InspectTalentFrameTalent"..i.."Slot"]:SetAlpha(0)
			_G["InspectTalentFrameTalent"..i.."SlotShadow"]:SetAlpha(0)
			_G["InspectTalentFrameTalent"..i.."GoldBorder"]:SetAlpha(0)

			ic:SetTexCoord(.08, .92, .08, .92)
			ic:SetPoint("TOPLEFT", 1, -1)
			ic:SetPoint("BOTTOMRIGHT", -1, 1)

			S:CreateBD(bu)
		end
	end
end

S:RegisterSkin("Blizzard_InspectUI", LoadSkin)