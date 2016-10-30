local R, L, P, G = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, GlobalDB
local S = R:GetModule("Skins")

local function LoadSkin()
	S:SetBD(SpellBookFrame)
	S:ReskinArrow(SpellBookPrevPageButton, "left")
	S:ReskinArrow(SpellBookNextPageButton, "right")
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
		if SpellBookFrame.bookType == BOOKTYPE_PROFESSION then return end

		local slot, slotType = SpellBook_GetSpellBookSlot(self)
		local name = self:GetName()
		local subSpellString = _G[name.."SubSpellName"]

		local isOffSpec = self.offSpecID ~= 0 and SpellBookFrame.bookType == BOOKTYPE_SPELL

		subSpellString:SetTextColor(1, 1, 1)

		if slotType == "FUTURESPELL" then
			local level = GetSpellAvailableLevel(slot, SpellBookFrame.bookType)
			if level and level > UnitLevel("player") then
				self.SpellName:SetTextColor(.7, .7, .7)
				subSpellString:SetTextColor(.7, .7, .7)
			end
		else
			if slotType == "SPELL" and isOffSpec then
				subSpellString:SetTextColor(.7, .7, .7)
			end
		end

		self.RequiredLevelString:SetTextColor(.7, .7, .7)

		local ic = _G[name.."IconTexture"]
		if not ic.bg then return end
		if ic:IsShown() then
			ic.bg:Show()
		else
			ic.bg:Hide()
		end
	end)

	SpellBookSkillLineTab1:SetPoint("TOPLEFT", SpellBookSideTabsFrame, "TOPRIGHT", 5, -36)

	hooksecurefunc("SpellBookFrame_UpdateSkillLineTabs", function()
		for i = 1, MAX_SKILLLINE_TABS do
			local tab = _G["SpellBookSkillLineTab"..i]
			if tab:GetNormalTexture() then
				tab:GetNormalTexture():SetTexCoord(.08, .92, .08, .92)
			end
			if not tab.styled then
				tab:StripTextures()
				-- Avoid a lua error when using the character boost. The spells are learned through "combat training" and are not ready to be skinned.

				tab.pushed = true
				tab:CreateShadow("Background")
				tab:StyleButton(true)
				hooksecurefunc(tab:GetHighlightTexture(), "SetTexture", function(self, texPath)
					if texPath ~= nil then
						self:SetPushedTexture(nil)
					end
				end)

				hooksecurefunc(tab:GetCheckedTexture(), "SetTexture", function(self, texPath)
					if texPath ~= nil then
						self:SetHighlightTexture(nil)
					end
				end)

				tab.styled = true
			end
		end
	end)
	SpellBookFrame_UpdateSkillLineTabs()

	-- professions

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

		local bg = CreateFrame("Frame", nil, bu)
		bg:SetPoint("TOPLEFT")
		bg:Point("BOTTOMRIGHT", 0, -4)
		bg:SetFrameLevel(0)
		S:CreateBD(bg, .25)

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

	for i = 1, 2 do
		local br = _G["PrimaryProfession"..i.."IconBorder"]
		local icon = _G["PrimaryProfession"..i.."Icon"]
		local ulb = _G["PrimaryProfession"..i.."UnlearnButton"]

		br:Hide()
		S:ReskinIcon(icon)

		ulb:ClearAllPoints()
		ulb:SetPoint("RIGHT", _G["PrimaryProfession"..i.."ProfessionName"], "LEFT", -2, 0)
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

	SpellBookFrameTutorialButton.Ring:Hide()
	SpellBookFrameTutorialButton:SetPoint("TOPLEFT", SpellBookFrame, "TOPLEFT", -12, 12)
end

S:AddCallback("SpellBook", LoadSkin)
