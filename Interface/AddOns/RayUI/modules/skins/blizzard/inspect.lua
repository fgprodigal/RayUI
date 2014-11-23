local R, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
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

	-- InspectPVPTeam1:DisableDrawLayer("BACKGROUND")
	-- InspectPVPTeam2:DisableDrawLayer("BACKGROUND")
	-- InspectPVPTeam3:DisableDrawLayer("BACKGROUND")
	InspectFramePortrait:Hide()
	InspectGuildFrameBG:Hide()
	for i = 1, 5 do
		select(i, InspectModelFrame:GetRegions()):Hide()
	end
	InspectFramePortraitFrame:Hide()
	InspectFrameTopBorder:Hide()
	InspectFrameTopRightCorner:Hide()
	-- InspectPVPFrameBG:SetAlpha(0)
	-- InspectPVPFrameBottom:SetAlpha(0)
	for i = 1, 4 do
		local tab = _G["InspectFrameTab"..i]
		S:CreateTab(tab)
		if i ~= 1 then
			tab:SetPoint("LEFT", _G["InspectFrameTab"..i-1], "RIGHT", -15, 0)
		end
	end

	for i = 1, MAX_TALENT_TIERS do
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
		slot:StripTextures()
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

		hooksecurefunc(slot.IconBorder, "SetVertexColor", function(self, r, g, b)
			self:GetParent().glow:SetBackdropBorderColor(r, g, b)
			self:GetParent():SetBackdropColor(0, 0, 0)
		end)
		hooksecurefunc(slot.IconBorder, "Hide", function(self)
			self:GetParent().glow:SetBackdropBorderColor(0, 0, 0)
			self:GetParent():SetBackdropColor(0, 0, 0, 0)
		end)
	end
	select(8, InspectMainHandSlot:GetRegions()):Kill()

	S:ReskinClose(InspectFrameCloseButton)

	-- for i = 1, MAX_NUM_TALENTS do
		-- local bu = _G["InspectTalentFrameTalent"..i]
		-- local ic = _G["InspectTalentFrameTalent"..i.."IconTexture"]
		-- if bu then
			-- bu:StyleButton()
			-- bu:GetPushedTexture():StyleButton(1)
			-- bu.SetHighlightTexture = R.dummy
			-- bu.SetPushedTexture = R.dummy

			-- _G["InspectTalentFrameTalent"..i.."Slot"]:SetAlpha(0)
			-- _G["InspectTalentFrameTalent"..i.."SlotShadow"]:SetAlpha(0)
			-- _G["InspectTalentFrameTalent"..i.."GoldBorder"]:SetAlpha(0)

			-- ic:SetTexCoord(.08, .92, .08, .92)
			-- ic:SetPoint("TOPLEFT", 1, -1)
			-- ic:SetPoint("BOTTOMRIGHT", -1, 1)

			-- S:CreateBD(bu)
		-- end
	-- end
end

S:RegisterSkin("Blizzard_InspectUI", LoadSkin)