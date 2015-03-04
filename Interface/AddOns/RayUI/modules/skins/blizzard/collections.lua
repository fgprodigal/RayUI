local R, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local S = R:GetModule("Skins")

local ToyBoxFilterFixerFilter = false

local function LoadSkin()
	local r, g, b = S["media"].classcolours[R.myclass].r, S["media"].classcolours[R.myclass].g, S["media"].classcolours[R.myclass].b
	-- [[ Mounts and pets ]]

	local PetJournal = PetJournal
	local MountJournal = MountJournal

	for i = 1, 14 do
		if i ~= 8 then
			select(i, CollectionsJournal:GetRegions()):Hide()
		end
	end
	for i = 1, 9 do
		select(i, MountJournal.MountCount:GetRegions()):Hide()
		select(i, PetJournal.PetCount:GetRegions()):Hide()
	end
	
	S:CreateBD(CollectionsJournal)
	S:CreateTab(CollectionsJournalTab1)
	S:CreateTab(CollectionsJournalTab2)
	S:CreateTab(CollectionsJournalTab3)
	S:CreateTab(CollectionsJournalTab4)
	S:ReskinClose(CollectionsJournalCloseButton)
	
	CollectionsJournalTab2:SetPoint("LEFT", CollectionsJournalTab1, "RIGHT", -15, 0)
	CollectionsJournalTab3:SetPoint("LEFT", CollectionsJournalTab2, "RIGHT", -15, 0)
	CollectionsJournalTab4:SetPoint("LEFT", CollectionsJournalTab3, "RIGHT", -15, 0)

	MountJournal.LeftInset:Hide()
	MountJournal.RightInset:Hide()
	PetJournal.LeftInset:Hide()
	PetJournal.RightInset:Hide()
	PetJournal.PetCardInset:Hide()
	PetJournal.loadoutBorder:Hide()
	MountJournal.MountDisplay.YesMountsTex:SetAlpha(0)
	MountJournal.MountDisplay.NoMountsTex:SetAlpha(0)
	MountJournal.MountDisplay.ShadowOverlay:Hide()
	PetJournalTutorialButton.Ring:Hide()

	S:CreateBD(MountJournal.MountCount, .25)
	S:CreateBD(PetJournal.PetCount, .25)
	S:CreateBD(MountJournal.MountDisplay.ModelFrame, .25)

	S:Reskin(MountJournalMountButton)
	S:Reskin(PetJournalSummonButton)
	S:Reskin(PetJournalFindBattle)
	S:ReskinScroll(MountJournalListScrollFrameScrollBar)
	S:ReskinScroll(PetJournalListScrollFrameScrollBar)
	S:ReskinInput(MountJournalSearchBox)
	S:ReskinInput(PetJournalSearchBox)
	S:ReskinArrow(MountJournal.MountDisplay.ModelFrame.RotateLeftButton, "left")
	S:ReskinArrow(MountJournal.MountDisplay.ModelFrame.RotateRightButton, "right")
	S:ReskinFilterButton(PetJournalFilterButton)
	S:ReskinFilterButton(MountJournalFilterButton)

	MountJournalFilterButton:SetPoint("TOPRIGHT", MountJournal.LeftInset, -5, -8)
	PetJournalFilterButton:SetPoint("TOPRIGHT", PetJournalLeftInset, -5, -8)

	PetJournalTutorialButton:SetPoint("TOPLEFT", PetJournal, "TOPLEFT", -14, 14)

	local scrollFrames = {MountJournal.ListScrollFrame.buttons, PetJournal.listScroll.buttons}
	for _, scrollFrame in pairs(scrollFrames) do
		for i = 1, #scrollFrame do
			local bu = scrollFrame[i]
			local ic = bu.icon

			bu:GetRegions():Hide()
			bu:SetHighlightTexture("")
			bu.iconBorder:SetTexture("")
			bu.selectedTexture:SetTexture("")

			local bg = CreateFrame("Frame", nil, bu)
			bg:SetPoint("TOPLEFT", 0, -1)
			bg:SetPoint("BOTTOMRIGHT", 0, 1)
			bg:SetFrameLevel(bu:GetFrameLevel()-1)
			S:CreateBD(bg, .25)
			bu.bg = bg

			ic:SetTexCoord(.08, .92, .08, .92)
			ic.bg = S:CreateBG(ic)

			bu.name:SetParent(bg)

			if bu.DragButton then
				bu.DragButton:StyleButton(1)
				bu.DragButton.ActiveTexture:SetTexture(S["media"].checked)
				bu.DragButton.ActiveTexture:SetVertexColor(r, g, b)
			else
				bu.dragButton:StyleButton(1)
				bu.dragButton.ActiveTexture:SetTexture(S["media"].checked)
				bu.dragButton.ActiveTexture:SetVertexColor(r, g, b)
				bu.dragButton.levelBG:SetAlpha(0)
				bu.dragButton.level:SetFontObject(GameFontNormal)
				bu.dragButton.level:SetTextColor(1, 1, 1)
			end
		end
	end

	local function updateMountScroll()
		local buttons = MountJournal.ListScrollFrame.buttons
		for i = 1, #buttons do
			local bu = buttons[i]
			if bu.index ~= nil then
				bu.bg:Show()
				bu.icon:Show()
				bu.icon.bg:Show()

				if bu.selectedTexture:IsShown() then
					bu.bg:SetBackdropColor(r, g, b, .25)
				else
					bu.bg:SetBackdropColor(0, 0, 0, .25)
				end
			else
				bu.bg:Hide()
				bu.icon:Hide()
				bu.icon.bg:Hide()
			end
		end
	end

	hooksecurefunc("MountJournal_UpdateMountList", updateMountScroll)
	hooksecurefunc(MountJournalListScrollFrame, "update", updateMountScroll)

	local function updatePetScroll()
		local petButtons = PetJournal.listScroll.buttons
		if petButtons then
			for i = 1, #petButtons do
				local bu = petButtons[i]

				local index = bu.index
				if index then
					local petID, _, isOwned = C_PetJournal.GetPetInfoByIndex(index)

					if petID and isOwned then
						local _, _, _, _, rarity = C_PetJournal.GetPetStats(petID)

						if rarity then
							local color = ITEM_QUALITY_COLORS[rarity-1]
							bu.name:SetTextColor(color.r, color.g, color.b)
						else
							bu.name:SetTextColor(1, 1, 1)
						end
					else
						bu.name:SetTextColor(.5, .5, .5)
					end

					if bu.selectedTexture:IsShown() then
						bu.bg:SetBackdropColor(r, g, b, .25)
					else
						bu.bg:SetBackdropColor(0, 0, 0, .25)
					end
				end
			end
		end
	end

	hooksecurefunc("PetJournal_UpdatePetList", updatePetScroll)
	hooksecurefunc(PetJournalListScrollFrame, "update", updatePetScroll)

	PetJournalHealPetButtonBorder:Hide()
	PetJournalHealPetButtonIconTexture:SetTexCoord(.08, .92, .08, .92)
	PetJournal.HealPetButton:SetPushedTexture("")
	S:CreateBG(PetJournal.HealPetButton)

	MountJournalSummonRandomFavoriteButton:SetPoint("TOPRIGHT", -7, -32)
	MountJournalSummonRandomFavoriteButtonBorder:Hide()
	MountJournalSummonRandomFavoriteButtonIconTexture:SetTexCoord(.08, .92, .08, .92)
	MountJournalSummonRandomFavoriteButton:StyleButton(true)
	S:CreateBG(MountJournalSummonRandomFavoriteButton)

	do
		local ic = MountJournal.MountDisplay.InfoButton.Icon
		ic:SetTexCoord(.08, .92, .08, .92)
		S:CreateBG(ic)
	end

	for _, f in pairs({PetJournalPrimaryAbilityTooltip, PetJournalSecondaryAbilityTooltip}) do
		f:DisableDrawLayer("BACKGROUND")
		local bg = CreateFrame("Frame", nil, f)
		bg:SetAllPoints()
		bg:SetFrameLevel(0)
		S:CreateBD(bg)
	end

	PetJournalLoadoutBorderSlotHeaderText:SetParent(PetJournal)
	PetJournalLoadoutBorderSlotHeaderText:SetPoint("CENTER", PetJournalLoadoutBorderTop, "TOP", 0, 4)

	-- Pet card

	local card = PetJournalPetCard

	PetJournalPetCardBG:Hide()
	card.PetInfo.levelBG:SetAlpha(0)
	card.PetInfo.qualityBorder:SetAlpha(0)
	card.AbilitiesBG1:SetAlpha(0)
	card.AbilitiesBG2:SetAlpha(0)
	card.AbilitiesBG3:SetAlpha(0)

	card.PetInfo.level:SetFontObject(GameFontNormal)
	card.PetInfo.level:SetTextColor(1, 1, 1)

	card.PetInfo.icon:SetTexCoord(.08, .92, .08, .92)
	card.PetInfo.icon.bg = S:CreateBG(card.PetInfo.icon)

	S:CreateBD(card, .25)

	for i = 2, 12 do
		select(i, card.xpBar:GetRegions()):Hide()
	end

	-- card.xpBar:SetStatusBarTexture(R["media"].gloss)
	S:CreateBDFrame(card.xpBar, .25)

	PetJournalPetCardHealthFramehealthStatusBarLeft:Hide()
	PetJournalPetCardHealthFramehealthStatusBarRight:Hide()
	PetJournalPetCardHealthFramehealthStatusBarMiddle:Hide()
	PetJournalPetCardHealthFramehealthStatusBarBGMiddle:Hide()

	-- card.HealthFrame.healthBar:SetStatusBarTexture(R["media"].gloss)
	S:CreateBDFrame(card.HealthFrame.healthBar, .25)

	for i = 1, 6 do
		local bu = card["spell"..i]

		bu.icon:SetTexCoord(.08, .92, .08, .92)
		S:CreateBG(bu.icon)
	end

	hooksecurefunc("PetJournal_UpdatePetCard", function(self)
		local border = self.PetInfo.qualityBorder
		local r, g, b

		if border:IsShown() then
			r, g, b = self.PetInfo.qualityBorder:GetVertexColor()
		else
			r, g, b = 0, 0, 0
		end

		self.PetInfo.icon.bg:SetVertexColor(r, g, b)
	end)

	-- Pet loadout

	for i = 1, 3 do
		local bu = PetJournal.Loadout["Pet"..i]

		_G["PetJournalLoadoutPet"..i.."BG"]:Hide()

		bu.iconBorder:SetAlpha(0)
		bu.qualityBorder:SetTexture("")
		bu.levelBG:SetAlpha(0)
		bu.helpFrame:GetRegions():Hide()

		bu.level:SetFontObject(GameFontNormal)
		bu.level:SetTextColor(1, 1, 1)

		bu.icon:SetTexCoord(.08, .92, .08, .92)
		bu.icon.bg = S:CreateBDFrame(bu.icon, .25)

		bu.setButton:GetRegions():SetPoint("TOPLEFT", bu.icon, -5, 5)
		bu.setButton:GetRegions():SetPoint("BOTTOMRIGHT", bu.icon, 5, -5)

		S:CreateBD(bu, .25)

		for i = 2, 12 do
			select(i, bu.xpBar:GetRegions()):Hide()
		end

		-- bu.xpBar:SetStatusBarTexture(R["media"].gloss)
		S:CreateBDFrame(bu.xpBar, .25)

		_G["PetJournalLoadoutPet"..i.."HealthFramehealthStatusBarLeft"]:Hide()
		_G["PetJournalLoadoutPet"..i.."HealthFramehealthStatusBarRight"]:Hide()
		_G["PetJournalLoadoutPet"..i.."HealthFramehealthStatusBarMiddle"]:Hide()
		_G["PetJournalLoadoutPet"..i.."HealthFramehealthStatusBarBGMiddle"]:Hide()

		-- bu.healthFrame.healthBar:SetStatusBarTexture(R["media"].gloss)
		S:CreateBDFrame(bu.healthFrame.healthBar, .25)

		for j = 1, 3 do
			local spell = bu["spell"..j]

			spell:SetPushedTexture("")

			spell.selected:SetTexture(S["media"].checked)

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
			bu.icon.bg:SetBackdropBorderColor(bu.qualityBorder:GetVertexColor())

			bu.dragButton:SetEnabled(not bu.helpFrame:IsShown())
		end
	end)

	PetJournal.SpellSelect.BgEnd:Hide()
	PetJournal.SpellSelect.BgTiled:Hide()

	for i = 1, 2 do
		local bu = PetJournal.SpellSelect["Spell"..i]

		bu:SetCheckedTexture(S["media"].checked)
		bu:SetPushedTexture("")

		bu.icon:SetDrawLayer("ARTWORK")
		bu.icon:SetTexCoord(.08, .92, .08, .92)
		S:CreateBG(bu.icon)
	end

	-- [[ Toy box ]]

	local ToyBox = ToyBox

	local icons = ToyBox.iconsFrame
	icons.Bg:Hide()
	icons.BackgroundTile:Hide()
	icons:DisableDrawLayer("BORDER")
	icons:DisableDrawLayer("ARTWORK")
	icons:DisableDrawLayer("OVERLAY")

	S:ReskinInput(ToyBox.searchBox)
	S:ReskinFilterButton(ToyBoxFilterButton)
	S:ReskinArrow(ToyBox.navigationFrame.prevPageButton, "left")
	S:ReskinArrow(ToyBox.navigationFrame.nextPageButton, "right")

	ToyBox.navigationFrame.prevPageButton:SetPoint("BOTTOMRIGHT", -320, 51)
	ToyBox.navigationFrame.nextPageButton:SetPoint("BOTTOMRIGHT", -285, 51)

	-- Progress bar

	local progressBar = ToyBox.progressBar
	progressBar.border:Hide()
	progressBar:DisableDrawLayer("BACKGROUND")

	progressBar.text:SetPoint("CENTER", 0, 1)
	progressBar:SetStatusBarTexture(R["media"].gloss)

	S:CreateBDFrame(progressBar, .25)

	-- Toys!

	local shouldChangeTextColor = true

	local changeTextColor = function(toyString)
		if shouldChangeTextColor then
			shouldChangeTextColor = false

			local self = toyString:GetParent()

			if PlayerHasToy(self.itemID) then
				local _, _, quality = GetItemInfo(self.itemID)
				if quality then
					toyString:SetTextColor(GetItemQualityColor(quality))
				else
					toyString:SetTextColor(1, 1, 1)
				end
			else
				toyString:SetTextColor(.5, .5, .5)
			end

			shouldChangeTextColor = true
		end
	end

	local buttons = ToyBox.iconsFrame
	for i = 1, 18 do
		local bu = buttons["spellButton"..i]
		local ic = bu.iconTexture

		bu:StyleButton(true)

		bu.cooldown:SetAllPoints(ic)

		bu.slotFrameCollected:SetTexture("")
		bu.slotFrameUncollected:SetTexture("")
		bu.hover:SetAllPoints(ic)
		bu.checked:SetAllPoints(ic)
		bu.pushed:SetAllPoints(ic)
		bu.cooldown:SetAllPoints(ic)

		ic:SetTexCoord(.08, .92, .08, .92)
		S:CreateBG(ic)

		hooksecurefunc(bu.name, "SetTextColor", changeTextColor)
	end

	C_ToyBox.SetFilterUncollected(ToyBoxFilterFixerFilter)
	hooksecurefunc(C_ToyBox, "SetFilterUncollected", function(filter) ToyBoxFilterFixerFilter = filter end)

	-- [[ Heirlooms ]]

	local HeirloomsJournal = HeirloomsJournal

	local icons = HeirloomsJournal.iconsFrame
	icons.Bg:Hide()
	icons.BackgroundTile:Hide()
	icons:DisableDrawLayer("BORDER")
	icons:DisableDrawLayer("ARTWORK")
	icons:DisableDrawLayer("OVERLAY")

	S:ReskinInput(HeirloomsJournalSearchBox)
	S:ReskinDropDown(HeirloomsJournalClassDropDown)
	S:ReskinFilterButton(HeirloomsJournalFilterButton)
	S:ReskinArrow(HeirloomsJournal.navigationFrame.prevPageButton, "left")
	S:ReskinArrow(HeirloomsJournal.navigationFrame.nextPageButton, "right")

	HeirloomsJournal.navigationFrame.prevPageButton:SetPoint("BOTTOMRIGHT", -320, 51)
	HeirloomsJournal.navigationFrame.nextPageButton:SetPoint("BOTTOMRIGHT", -285, 51)

	-- Progress bar

	local progressBar = HeirloomsJournal.progressBar
	progressBar.border:Hide()
	progressBar:DisableDrawLayer("BACKGROUND")

	progressBar.text:SetPoint("CENTER", 0, 1)
	progressBar:SetStatusBarTexture(R["media"].gloss)

	S:CreateBDFrame(progressBar, .25)
end

S:RegisterSkin("Blizzard_Collections", LoadSkin)
