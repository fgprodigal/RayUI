local R, L, P = unpack(select(2, ...)) --Inport: Engine, Locales, ProfileDB
local S = R:GetModule("Skins")

local function LoadSkin()
	local r, g, b = S["media"].classcolours[R.myclass].r, S["media"].classcolours[R.myclass].g, S["media"].classcolours[R.myclass].b
	for i = 1, 14 do
		if i ~= 8 then
			select(i, PetJournalParent:GetRegions()):Hide()
		end
	end
	for i = 1, 9 do
		select(i, MountJournal.MountCount:GetRegions()):Hide()
		select(i, PetJournal.PetCount:GetRegions()):Hide()
	end

	MountJournalMountButton_RightSeparator:Hide()
	MountJournal.LeftInset:Hide()
	MountJournal.RightInset:Hide()
	PetJournal.LeftInset:Hide()
	PetJournal.RightInset:Hide()
	PetJournal.PetCardInset:Hide()
	PetJournal.loadoutBorder:Hide()
	MountJournal.MountDisplay:GetRegions():Hide()
	MountJournal.MountDisplay.ShadowOverlay:Hide()
	PetJournalFilterButtonLeft:Hide()
	PetJournalFilterButtonRight:Hide()
	PetJournalFilterButtonMiddle:Hide()
	PetJournalTutorialButton.Ring:Hide()

	S:CreateBD(PetJournalParent)
	S:CreateSD(PetJournalParent)
	S:CreateBD(MountJournal.MountCount, .25)
	S:CreateBD(PetJournal.PetCount, .25)
	S:CreateBD(MountJournal.MountDisplay.ModelFrame, .25)

	S:Reskin(MountJournalMountButton)
	S:Reskin(PetJournalSummonButton)
	S:Reskin(PetJournalFindBattle)
	S:Reskin(PetJournalFilterButton)
	S:CreateTab(PetJournalParentTab1)
	S:CreateTab(PetJournalParentTab2)
	S:ReskinClose(PetJournalParentCloseButton)
	S:ReskinScroll(MountJournalListScrollFrameScrollBar)
	S:ReskinScroll(PetJournalListScrollFrameScrollBar)
	S:ReskinInput(PetJournalSearchBox)
	S:ReskinArrow(MountJournal.MountDisplay.ModelFrame.RotateLeftButton, "left")
	S:ReskinArrow(MountJournal.MountDisplay.ModelFrame.RotateRightButton, "right")

	PetJournalTutorialButton:SetPoint("TOPLEFT", PetJournal, "TOPLEFT", -14, 14)

	PetJournalParentTab2:SetPoint("LEFT", PetJournalParentTab1, "RIGHT", -15, 0)

	PetJournalHealPetButtonBorder:Hide()
	PetJournalHealPetButtonIconTexture:SetTexCoord(.08, .92, .08, .92)
	PetJournal.HealPetButton:StyleButton(true)
	S:CreateBG(PetJournal.HealPetButton)

	local scrollFrames = {MountJournal.ListScrollFrame.buttons, PetJournal.listScroll.buttons}
	for _, scrollFrame in pairs(scrollFrames) do
		for i = 1, #scrollFrame do
			local bu = scrollFrame[i]

			bu:GetRegions():Hide()
			bu:SetHighlightTexture("")

			bu.selectedTexture:Point("TOPLEFT", 1, -1)
			bu.selectedTexture:Point("BOTTOMRIGHT", -1, 1)
			bu.selectedTexture:SetTexture(S["media"].backdrop)
			bu.selectedTexture:SetVertexColor(r, g, b, .2)

			local bg = CreateFrame("Frame", nil, bu)
			bg:Point("TOPLEFT", 1, -1)
			bg:Point("BOTTOMRIGHT", -1, 1)
			bg:SetFrameLevel(bu:GetFrameLevel()-1)
			S:CreateBD(bg, .25)
			bu.bg = bg

			bu.icon:SetTexCoord(.08, .92, .08, .92)
			bu.icon:SetDrawLayer("OVERLAY")
			S:CreateBG(bu.icon)

			bu.name:SetParent(bg)
			bu:StyleButton()

			if bu.DragButton then
				bu.DragButton:StyleButton(1)
				bu.DragButton.ActiveTexture:SetTexture(S["media"].checked)
			else
				bu.dragButton:StyleButton(1)
				bu.dragButton.ActiveTexture:SetTexture(S["media"].checked)
				bu.dragButton.levelBG:SetAlpha(0)
				bu.dragButton.level:SetFontObject(GameFontNormal)
				bu.dragButton.level:SetTextColor(1, 1, 1)
			end
		end
	end

	local function updateScroll()
		local buttons = MountJournal.ListScrollFrame.buttons
		for i = 1, #buttons do
			local bu = buttons[i]
			if i == 2 then
				bu:Point("TOPLEFT", buttons[i-1], "BOTTOMLEFT", 0, -1)
			elseif i > 2 then
				bu:SetPoint("TOPLEFT", buttons[i-1], "BOTTOMLEFT", 0, 0)
			end
		end
	end

	hooksecurefunc("MountJournal_UpdateMountList", updateScroll)
	MountJournalListScrollFrame:HookScript("OnVerticalScroll", updateScroll)
	MountJournalListScrollFrame:HookScript("OnMouseWheel", updateScroll)

	local tooltips = {PetJournalPrimaryAbilityTooltip, PetJournalSecondaryAbilityTooltip}
	for _, f in pairs(tooltips) do
		f:DisableDrawLayer("BACKGROUND")
		local bg = CreateFrame("Frame", nil, f)
		bg:SetAllPoints()
		bg:SetFrameLevel(0)
		S:CreateBD(bg)
	end

	PetJournalLoadoutBorderSlotHeaderText:SetParent(PetJournal)
	PetJournalLoadoutBorderSlotHeaderText:Point("CENTER", PetJournalLoadoutBorderTop, "TOP", 0, 4)

	local card = PetJournalPetCard

	PetJournalPetCardBG:Hide()
	card.AbilitiesBG:SetAlpha(0)
	card.PetInfo.levelBG:SetAlpha(0)

	card.PetInfo.level:SetFontObject(GameFontNormal)
	card.PetInfo.level:SetTextColor(1, 1, 1)

	card.PetInfo.icon:SetTexCoord(.08, .92, .08, .92)
	S:CreateBG(card.PetInfo.icon)

	S:CreateBD(card, .25)

	for i = 2, 12 do
		select(i, card.xpBar:GetRegions()):Hide()
	end

	card.xpBar:SetStatusBarTexture(S["media"].backdrop)
	S:CreateBDFrame(card.xpBar, .25)

	PetJournalPetCardHealthFramehealthStatusBarLeft:Hide()
	PetJournalPetCardHealthFramehealthStatusBarRight:Hide()
	PetJournalPetCardHealthFramehealthStatusBarMiddle:Hide()
	PetJournalPetCardHealthFramehealthStatusBarBGMiddle:Hide()

	card.HealthFrame.healthBar:SetStatusBarTexture(S["media"].backdrop)
	S:CreateBDFrame(card.HealthFrame.healthBar, .25)

	for i = 1, 6 do
		local bu = card["spell"..i]

		bu.icon:SetTexCoord(.08, .92, .08, .92)
		S:CreateBG(bu.icon)
	end

	for i = 1, 3 do
		local bu = PetJournal.Loadout["Pet"..i]

		_G["PetJournalLoadoutPet"..i.."BG"]:Hide()

		bu.iconBorder:SetAlpha(0)
		bu.levelBG:SetAlpha(0)
		bu.helpFrame:GetRegions():Hide()

		bu.level:SetFontObject(GameFontNormal)
		bu.level:SetTextColor(1, 1, 1)

		bu.icon:SetTexCoord(.08, .92, .08, .92)
		bu.icon.bg = CreateFrame("Frame", nil, bu)
		bu.icon.bg:Point("TOPLEFT", bu.icon, -1, 1)
		bu.icon.bg:Point("BOTTOMRIGHT", bu.icon, 1, -1)
		bu.icon.bg:SetFrameLevel(bu:GetFrameLevel()-1)
		S:CreateBD(bu.icon.bg, .25)

		bu.setButton:GetRegions():Point("TOPLEFT", bu.icon, -5, 5)
		bu.setButton:GetRegions():Point("BOTTOMRIGHT", bu.icon, 5, -5)
		bu.dragButton:StyleButton()

		S:CreateBD(bu, .25)

		for i = 2, 12 do
			select(i, bu.xpBar:GetRegions()):Hide()
		end

		bu.xpBar:SetStatusBarTexture(S["media"].backdrop)
		S:CreateBDFrame(bu.xpBar, .25)

		_G["PetJournalLoadoutPet"..i.."HealthFramehealthStatusBarLeft"]:Hide()
		_G["PetJournalLoadoutPet"..i.."HealthFramehealthStatusBarRight"]:Hide()
		_G["PetJournalLoadoutPet"..i.."HealthFramehealthStatusBarMiddle"]:Hide()
		_G["PetJournalLoadoutPet"..i.."HealthFramehealthStatusBarBGMiddle"]:Hide()

		bu.healthFrame.healthBar:SetStatusBarTexture(S["media"].backdrop)
		S:CreateBDFrame(bu.healthFrame.healthBar, .25)

		for j = 1, 3 do
			local spell = bu["spell"..j]

			spell:StyleButton(true)

			spell.selected:SetTexture(nil)
			spell:GetRegions():Hide()

			spell.FlyoutArrow:SetTexture(S["media"].arrowDown)
			spell.FlyoutArrow:SetSize(8, 8)
			spell.FlyoutArrow:SetTexCoord(0, 1, 0, 1)

			spell.icon:SetTexCoord(.08, .92, .08, .92)
			S:CreateBG(spell.icon)
		end
	end

	hooksecurefunc("PetJournal_UpdatePetLoadOut", function()
		for i = 1, 3 do
			local bu = PetJournal.Loadout["Pet"..i]
			bu.icon.bg:SetShown(not bu.helpFrame:IsShown())
			bu.dragButton:SetEnabled(not bu.helpFrame:IsShown())
		end
	end)

	PetJournal.SpellSelect.BgEnd:Hide()
	PetJournal.SpellSelect.BgTiled:Hide()

	for i = 1, 2 do
		local bu = PetJournal.SpellSelect["Spell"..i]

		bu:StyleButton(true)

		bu.icon:SetDrawLayer("ARTWORK")
		bu.icon:SetTexCoord(.08, .92, .08, .92)
		S:CreateBG(bu.icon)
	end
end

S:RegisterSkin("Blizzard_PetJournal", LoadSkin)