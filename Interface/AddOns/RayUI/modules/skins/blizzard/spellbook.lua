local R, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local S = R:GetModule("Skins")

local function LoadSkin()
	S:SetBD(SpellBookFrame)
	S:ReskinArrow(SpellBookPrevPageButton, "left")
	S:ReskinArrow(SpellBookNextPageButton, "right")
	S:Reskin(SpellBookCompanionSummonButton)
	S:ReskinClose(SpellBookFrameCloseButton)
	SpellBookFrame:DisableDrawLayer("BACKGROUND")
	SpellBookFrame:DisableDrawLayer("BORDER")
	SpellBookFrame:DisableDrawLayer("OVERLAY")
	SpellBookFrameInset:DisableDrawLayer("BORDER")
	SpellBookPageText:SetTextColor(.8, .8, .8)

	hooksecurefunc("UpdateProfessionButton", function(self)
		self.spellString:SetTextColor(1, 1, 1);
		self.subSpellString:SetTextColor(1, 1, 1)
	end)

	local lightbds = {
		"SecondaryProfession1",
		"SecondaryProfession2",
		"SecondaryProfession3",
		"SecondaryProfession4"
	}
	for i = 1, #lightbds do
		S:CreateBD(_G[lightbds[i]], .25)
	end

	for i = 1, 5 do
		S:CreateTab(_G["SpellBookFrameTabButton"..i])
	end

	for i = 1, SPELLS_PER_PAGE do
		local bu = _G["SpellButton"..i]
		local ic = _G["SpellButton"..i.."IconTexture"]
		_G["SpellButton"..i.."Background"]:SetAlpha(0)
		_G["SpellButton"..i.."TextBackground"]:Hide()
		_G["SpellButton"..i.."SlotFrame"]:SetAlpha(0)
		_G["SpellButton"..i.."UnlearnedSlotFrame"]:SetAlpha(0)

		bu:SetCheckedTexture("")
		bu:SetPushedTexture("")

		ic:SetTexCoord(.08, .92, .08, .92)

		ic.bg = S:CreateBG(bu)
	end

	hooksecurefunc("SpellButton_UpdateButton", function(self)
		local slot, slotType = SpellBook_GetSpellBookSlot(self)
		local name = self:GetName()
		local subSpellString = _G[name.."SubSpellName"]

		subSpellString:SetTextColor(1, 1, 1)
		if slotType == "FUTURESPELL" then
			local level = GetSpellAvailableLevel(slot, SpellBookFrame.bookType)
			if (level and level > UnitLevel("player")) then
				self.RequiredLevelString:SetTextColor(.7, .7, .7)
				self.SpellName:SetTextColor(.7, .7, .7)
				subSpellString:SetTextColor(.7, .7, .7)
			end
		end

		local ic = _G[name.."IconTexture"]
		if not ic.bg then return end
		if ic:IsShown() then
			ic.bg:Show()
		else
			ic.bg:Hide()
		end
		if self.shine then
			self.shine:SetAllPoints()
		end
		if _G[name.."AutoCastable"] then
			_G[name.."AutoCastable"]:SetSize(75, 75)
		end
		for i = 1, SPELLS_PER_PAGE do
			local bu = _G["SpellButton"..i]
			local ic = _G["SpellButton"..i.."IconTexture"]

			if _G["SpellButton"..i.."Highlight"] then
				_G["SpellButton"..i.."Highlight"]:SetTexture(1, 1, 1, 0.3)
				_G["SpellButton"..i.."Highlight"]:ClearAllPoints()
				_G["SpellButton"..i.."Highlight"]:SetAllPoints(ic)
			end

			if ic:GetTexture() then
				_G["SpellButton"..i.."TextBackground2"]:Show()
			else
				_G["SpellButton"..i.."TextBackground2"]:Hide()
			end
		end		
	end)

	for i = 1, 5 do
		local tab = _G["SpellBookSkillLineTab"..i]
		tab:StripTextures()
		local a1, p, a2, x, y = tab:GetPoint()
		tab:Point(a1, p, a2, x + 11, y)
		S:CreateBG(tab)
		S:CreateSD(tab, 5, 0, 0, 0, 1, 1)
		_G["SpellBookSkillLineTab"..i.."TabardIconFrame"]:SetTexCoord(.08, .92, .08, .92)
		select(4, tab:GetRegions()):SetTexCoord(.08, .92, .08, .92)

		tab:StyleButton(true)
		tab:SetPushedTexture(nil)
	end

	local professions = {
		"PrimaryProfession1",
		"PrimaryProfession2",
		"SecondaryProfession1",
		"SecondaryProfession2",
		"SecondaryProfession3",
		"SecondaryProfession4"
	}

	for _, button in pairs(professions) do
		local bu = _G[button]
		bu.professionName:SetTextColor(1, 1, 1)
		bu.missingHeader:SetTextColor(1, 1, 1)
		bu.missingText:SetTextColor(1, 1, 1)

		bu.statusBar:SetHeight(13)
		bu.statusBar:SetStatusBarTexture(R["media"].gloss)
		bu.statusBar:GetStatusBarTexture():SetGradient("VERTICAL", 0, .6, 0, 0, .8, 0)
		bu.statusBar.rankText:SetPoint("CENTER")

		local _, p = bu.statusBar:GetPoint()
		bu.statusBar:Point("TOPLEFT", p, "BOTTOMLEFT", 1, -3)

		_G[button.."StatusBarLeft"]:Hide()
		bu.statusBar.capRight:SetAlpha(0)
		_G[button.."StatusBarBGLeft"]:Hide()
		_G[button.."StatusBarBGMiddle"]:Hide()
		_G[button.."StatusBarBGRight"]:Hide()

		local bg = CreateFrame("Frame", nil, bu.statusBar)
		bg:Point("TOPLEFT", -1, 1)
		bg:Point("BOTTOMRIGHT", 1, -1)
		bg:SetFrameLevel(bu:GetFrameLevel()-1)
		S:CreateBD(bg, .25)
	end

	local professionbuttons = {
		"PrimaryProfession1SpellButtonTop",
		"PrimaryProfession1SpellButtonBottom",
		"PrimaryProfession2SpellButtonTop",
		"PrimaryProfession2SpellButtonBottom",
		"SecondaryProfession1SpellButtonLeft",
		"SecondaryProfession1SpellButtonRight",
		"SecondaryProfession2SpellButtonLeft",
		"SecondaryProfession2SpellButtonRight",
		"SecondaryProfession3SpellButtonLeft",
		"SecondaryProfession3SpellButtonRight",
		"SecondaryProfession4SpellButtonLeft",
		"SecondaryProfession4SpellButtonRight"
	}

	for _, button in pairs(professionbuttons) do
		local icon = _G[button.."IconTexture"]
		local bu = _G[button]
		_G[button.."NameFrame"]:SetAlpha(0)

		bu:StripTextures()
		bu:SetPushedTexture("")
		bu:GetHighlightTexture():Hide()

		if icon then
			icon:SetTexCoord(.08, .92, .08, .92)
			icon:ClearAllPoints()
			icon:Point("TOPLEFT", 2, -2)
			icon:Point("BOTTOMRIGHT", -2, 2)
			S:CreateBG(icon)
		end
	end

	for i = 1, 2 do
		local bu = _G["PrimaryProfession"..i]
		local bg = CreateFrame("Frame", nil, bu)
		bg:SetPoint("TOPLEFT")
		bg:Point("BOTTOMRIGHT", 0, -4)
		bg:SetFrameLevel(0)
		S:CreateBD(bg, .25)
	end

	local coreTabsSkinned = false
	hooksecurefunc("SpellBookCoreAbilities_UpdateTabs", function()
		if coreTabsSkinned then return end
		coreTabsSkinned = true
		for i = 1, GetNumSpecializations() do
			local tab = SpellBookCoreAbilitiesFrame.SpecTabs[i]

			tab:GetRegions():Hide()
			tab:StyleButton(true)
			tab:SetPushedTexture(nil)

			S:CreateBG(tab)
			S:CreateSD(tab, 5, 0, 0, 0, 1, 1)

			tab:GetNormalTexture():SetTexCoord(.08, .92, .08, .92)

			if i == 1 then
				tab:SetPoint("TOPLEFT", SpellBookCoreAbilitiesFrame, "TOPRIGHT", 11, -53)
			end
		end
	end)

	hooksecurefunc("SpellBook_UpdateCoreAbilitiesTab", function()
		for i = 1, #SpellBookCoreAbilitiesFrame.Abilities do
			local bu = SpellBook_GetCoreAbilityButton(i)
			if not bu.reskinned then
				bu.EmptySlot:SetAlpha(0)
				bu.ActiveTexture:SetAlpha(0)
				bu.FutureTexture:SetAlpha(0)
				bu.RequiredLevel:SetTextColor(1, 1, 1)

				bu.iconTexture:SetTexCoord(.08, .92, .08, .92)
				bu.iconTexture.bg = S:CreateBG(bu.iconTexture)

				if bu.FutureTexture:IsShown() then
					bu.Name:SetTextColor(.8, .8, .8)
					bu.InfoText:SetTextColor(.7, .7, .7)
				else
					bu.Name:SetTextColor(1, 1, 1)
					bu.InfoText:SetTextColor(.9, .9, .9)
				end
				bu:StyleButton(true)
				bu.reskinned = true
			end
		end
	end)

	SpellBookFrameTutorialButton.Ring:Hide()
	SpellBookFrameTutorialButton:SetPoint("TOPLEFT", SpellBookFrame, "TOPLEFT", -12, 12)
end

S:RegisterSkin("RayUI", LoadSkin)