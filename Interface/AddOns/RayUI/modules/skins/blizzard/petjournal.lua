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
	S:ReskinInput(MountJournalSearchBox)
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
				bu.dragButton.level:SetFont(R["media"].font, 12, "OUTLINE")
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
	card.PetInfo.qualityBorder:SetAlpha(0)

	card.PetInfo.level:SetFont(R["media"].font, 12, "OUTLINE")
	card.PetInfo.level:SetTextColor(1, 1, 1)

	card.PetInfo.icon:SetTexCoord(.08, .92, .08, .92)
	card.PetInfo.icon.bg = CreateFrame("Frame", nil, card.PetInfo)
	card.PetInfo.icon.bg:Point("TOPLEFT", card.PetInfo.icon, -2, 2)
	card.PetInfo.icon.bg:Point("BOTTOMRIGHT", card.PetInfo.icon, 2, -2)
	card.PetInfo.icon.bg:SetFrameLevel(card.PetInfo:GetFrameLevel()-1)
	S:CreateBD(card.PetInfo.icon.bg)

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
		bu.qualityBorder:SetAlpha(0)
		bu.levelBG:SetAlpha(0)
		bu.helpFrame:GetRegions():Hide()

		bu.level:SetFont(R["media"].font, 12, "OUTLINE")
		bu.level:SetTextColor(1, 1, 1)

		bu.icon:SetTexCoord(.08, .92, .08, .92)
		bu.icon.bg = CreateFrame("Frame", nil, bu)
		bu.icon.bg:Point("TOPLEFT", bu.icon, -2, 2)
		bu.icon.bg:Point("BOTTOMRIGHT", bu.icon, 2, -2)
		bu.icon.bg:SetFrameLevel(bu:GetFrameLevel()-1)
		S:CreateBD(bu.icon.bg)

		bu.setButton:GetRegions():Point("TOPLEFT", bu.icon, -5, 5)
		bu.setButton:GetRegions():Point("BOTTOMRIGHT", bu.icon, 5, -5)
		bu.dragButton:StyleButton(true)

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
			local petID, _, _, _, locked =  C_PetJournal.GetPetLoadOutInfo(i)
			local bu = PetJournal.Loadout["Pet"..i]
			bu.icon.bg:SetShown(not bu.helpFrame:IsShown())
			local r, g, b = bu.qualityBorder:GetVertexColor()
			if r == 1 and g == 1 then r, g, b = 0, 0, 0 end

			bu.icon.bg:SetBackdropBorderColor(r, g, b)
			bu.dragButton:SetEnabled(not bu.helpFrame:IsShown())
			if not locked and petID then
				local _, customName, _, _, _, _, _, name = C_PetJournal.GetPetInfoByPetID(petID)
				local rarity = select(5,C_PetJournal.GetPetStats(petID))
				local hex  = select(4,GetItemQualityColor(rarity-1))
                name = customName or name
                bu.name:SetText("|c"..hex..name.."|r")
            end
		end
	end)

	hooksecurefunc("PetJournal_UpdatePetCard", function(self)
		local r, g, b = self.PetInfo.qualityBorder:GetVertexColor()
		if r == 1 and g == 1 then r, g, b = 0, 0, 0 end

		self.PetInfo.icon.bg:SetBackdropBorderColor(r, g, b)
		if PetJournalPetCard.petID  then
            local speciesID, customName, _, _, _, _, _, name, icon, petType, creatureID, sourceText, description, isWild, canBattle, tradable = C_PetJournal.GetPetInfoByPetID(PetJournalPetCard.petID)
            if canBattle then
                local health, maxHealth, power, speed, rarity = C_PetJournal.GetPetStats(PetJournalPetCard.petID)
                PetJournalPetCard.QualityFrame.quality:SetText(_G["BATTLE_PET_BREED_QUALITY"..rarity])
                local r,g,b,hex  = GetItemQualityColor(rarity-1)

                name = customName or name
                PetJournalPetCard.PetInfo.name:SetText("|c"..hex..name.."|r")
            end
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

     local function UpdatePetList()
        local scrollFrame = PetJournal.listScroll
        local offset = HybridScrollFrame_GetOffset(scrollFrame)
        local petButtons = scrollFrame.buttons
        for i = 1,#petButtons do
            pet = petButtons[i]
            index = offset + i
            local petID, speciesID, isOwned, customName, level, favorite, isRevoked, name, icon, petType, creatureID, sourceText, description, isWildPet, canBattle = C_PetJournal.GetPetInfoByIndex(index)
            if petID then
                local health, maxHealth, attack, speed, rarity = C_PetJournal.GetPetStats(petID)
                if rarity then
                    local r, g, b, hex  = GetItemQualityColor(rarity - 1)
                    name = customName or name
                    pet.name:SetText("|c"..hex..name.."|r")
                end
            end
        end
    end

    hooksecurefunc("PetJournal_UpdatePetList", UpdatePetList)
    hooksecurefunc(PetJournal.listScroll, "update", UpdatePetList)

    -- local filter = ""
    -- local filterTable = {}
    -- local filterFlags = {
        -- ["swimming"] = true,
        -- ["flying"] = true,
        -- ["ground"] = true,
        -- ["combined"] = true,
        -- ["unknown"] = true,
    -- }

    -- local Search = CreateFrame("EditBox", "MountSearch", MountJournal, "SearchBoxTemplate")
    -- Search:SetSize(145, 20)
    -- Search:SetPoint("TOPLEFT", MountJournal.LeftInset, 15, -9)
    -- Search:SetMaxLetters(40)
    -- Search:SetScript("OnTextChanged", function(self)
        -- local text = self:GetText()
        -- if(text == SEARCH) then
            -- filter = ""
        -- else
            -- filter = text
        -- end

        -- MountJournal_UpdateMountList()
    -- end)
    -- S:ReskinInput(Search)

    -- local mounts = {}
    -- local function BuildMounts(self, event)
        -- if(event and event ~= "COMPANION_LEARNED") then return end

        -- for index = 1, GetNumCompanions("MOUNT") do
            -- local id, name, _, _, _, flag = GetCompanionInfo("MOUNT", index)
            -- if(flag == 12) then
                -- mounts[index] = "swimming"
            -- elseif(flag == 7 or flag == 15) then
                -- mounts[index] = "flying"
            -- elseif(flag == 29) then
                -- mounts[index] = "ground"
            -- elseif(flag == 31) then
                -- mounts[index] = "combined"
            -- else
                -- mounts[index] = "unknown"
            -- end

            -- if(id == 34187) then
                -- mounts[index] = "swimming"
            -- end
        -- end
    -- end

    -- MountJournal:HookScript("OnEvent", BuildMounts)
    -- BuildMounts()

    -- function MountJournal_UpdateMountList()
        -- local scroll = MountJournal.ListScrollFrame
        -- local offset = HybridScrollFrame_GetOffset(scroll)
        -- local total = GetNumCompanions("MOUNT")

        -- local lowbie = UnitLevel("player") < 20
        -- if(lowbie or total < 1) then
            -- MountJournal.MountDisplay.NoMounts:Show()
            -- MountJournal.selectedSpellID = 0
            -- MountJournal_UpdateMountDisplay()
            -- MountJournal.MountButton:SetEnabled(false)
        -- else
            -- MountJournal.MountDisplay.NoMounts:Hide()
            -- MountJournal.MountButton:SetEnabled(true)
        -- end

        -- table.wipe(filterTable)

        -- for index = 1, total do
            -- local id, name, spell, icon, active, flag = GetCompanionInfo("MOUNT", index)
            -- if(name:lower():find(filter) and filterFlags[mounts[index]]) then
                -- table.insert(filterTable, index)
            -- end
        -- end

        -- local buttons = scroll.buttons
        -- for j = 1, #buttons do
            -- local button = buttons[j]
            -- local index = j + offset
            -- if(index <= #filterTable) then
                -- local _, name, spell, icon, active = GetCompanionInfo("MOUNT", filterTable[index])
                -- button.name:SetText(name)
                -- button.icon:SetTexture(icon)
                -- button.index = filterTable[index]
                -- button.spellID = spell
                -- button.active = active

                -- if(active) then
                    -- button.DragButton.ActiveTexture:Show()
                -- else
                    -- button.DragButton.ActiveTexture:Hide()
                -- end

                -- button:Show()

                -- if(MountJournal.selectedSpellID == spell) then
                    -- button.selected = true
                    -- button.selectedTexture:Show()
                -- else
                    -- button.selected = false
                    -- button.selectedTexture:Hide()
                -- end

                -- button:SetEnabled(not lowbie)
                -- button.DragButton:SetEnabled(not lowbie)

                -- button.additionalText = nil
                -- button.icon:SetDesaturated(lowbie)
                -- button.icon:SetAlpha(1)
                -- button.name:SetFontObject("GameFontNormal")

                -- if(button.showingTooltip) then
                    -- MountJournalMountButton_UpdateTooltip(button)
                -- end
            -- else
                -- button:Hide()
            -- end
        -- end

        -- HybridScrollFrame_Update(scroll, #filterTable * 46, scroll:GetHeight())
        -- MountJournal.MountCount.Count:SetText(total)
    -- end

    -- local scroll = MountJournal.ListScrollFrame
    -- scroll.update = MountJournal_UpdateMountList
    -- scroll:SetPoint("TOPLEFT", MountJournal.LeftInset, 3, -36)
    -- scroll.scrollBar:SetPoint("TOPLEFT", scroll, "TOPRIGHT", 4, 20)

    -- local function CreateDropDown()
        -- local info = UIDropDownMenu_CreateInfo()
        -- info.keepShownOnClick = true
        -- info.isNotRadio = true

        -- info.text = L["飞行"]
        -- info.checked = filterFlags.flying
        -- info.func = function(...)
            -- local _, _, _, enabled = ...
            -- filterFlags.flying = enabled
            -- MountJournal_UpdateMountList()
        -- end
        -- UIDropDownMenu_AddButton(info)

        -- info.text = L["地面"]
        -- info.checked = filterFlags.ground
        -- info.func = function(...)
            -- local _, _, _, enabled = ...
            -- filterFlags.ground = enabled
            -- MountJournal_UpdateMountList()
        -- end
        -- UIDropDownMenu_AddButton(info)

        -- info.text = L["飞行 & 地面"]
        -- info.checked = filterFlags.combined
        -- info.func = function(...)
            -- local _, _, _, enabled = ...
            -- filterFlags.combined = enabled
            -- MountJournal_UpdateMountList()
        -- end
        -- UIDropDownMenu_AddButton(info)

        -- info.text = L["游泳"]
        -- info.checked = filterFlags.swimming
        -- info.func = function(...)
            -- local _, _, _, enabled = ...
            -- filterFlags.swimming = enabled
            -- MountJournal_UpdateMountList()
        -- end
        -- UIDropDownMenu_AddButton(info)

        -- info.text = L["未知"]
        -- info.checked = filterFlags.unknown
        -- info.func = function(...)
            -- local _, _, _, enabled = ...
            -- filterFlags.unknown = enabled
            -- MountJournal_UpdateMountList()
        -- end
        -- UIDropDownMenu_AddButton(info)
    -- end

    -- local FilterDropDown = CreateFrame("Frame")
    -- FilterDropDown.initialize = CreateDropDown
    -- FilterDropDown.displayMode = "MENU"

    -- local Filter = CreateFrame("Button", "MountFilter", MountJournal, "UIMenuButtonStretchTemplate")
    -- Filter:SetSize(93, 22)
    -- Filter:SetPoint("TOPRIGHT", MountJournal.LeftInset, -5, -9)
    -- Filter:SetText(FILTER)
    -- Filter.rightArrow:Show()
    -- Filter:SetScript("OnClick", function()
        -- PlaySound("igMainMenuOptionCheckBoxOn")
        -- ToggleDropDownMenu(1, nil, FilterDropDown, MountFilter, 74, 15)
    -- end)
	-- MountFilterLeft:Hide()
	-- MountFilterRight:Hide()
	-- MountFilterMiddle:Hide()
    -- S:Reskin(Filter)
end

S:RegisterSkin("Blizzard_PetJournal", LoadSkin)
