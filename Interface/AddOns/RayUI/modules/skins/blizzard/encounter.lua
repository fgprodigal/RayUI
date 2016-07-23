local R, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local S = R:GetModule("Skins")

local function LoadSkin()
	EncounterJournalEncounterFrameInfo:DisableDrawLayer("BACKGROUND")
	EncounterJournal:DisableDrawLayer("BORDER")
	EncounterJournalInset:DisableDrawLayer("BORDER")
	EncounterJournalNavBar:DisableDrawLayer("BORDER")
	EncounterJournalSearchResults:DisableDrawLayer("BORDER")
	EncounterJournal:DisableDrawLayer("OVERLAY")
	EncounterJournalInstanceSelectSuggestTab:DisableDrawLayer("OVERLAY")
	EncounterJournalInstanceSelectDungeonTab:DisableDrawLayer("OVERLAY")
	EncounterJournalInstanceSelectRaidTab:DisableDrawLayer("OVERLAY")

	EncounterJournalPortrait:Hide()
	EncounterJournalInstanceSelectBG:Hide()
	EncounterJournalNavBar:GetRegions():Hide()
	EncounterJournalNavBarOverlay:Hide()
	EncounterJournalBg:Hide()
	EncounterJournalTitleBg:Hide()
	EncounterJournalInsetBg:Hide()
	EncounterJournalInstanceSelectSuggestTabMid:Hide()
	EncounterJournalInstanceSelectSuggestTabLeft:Hide()
	EncounterJournalInstanceSelectSuggestTabRight:Hide()
	EncounterJournalInstanceSelectDungeonTabMid:Hide()
	EncounterJournalInstanceSelectDungeonTabLeft:Hide()
	EncounterJournalInstanceSelectDungeonTabRight:Hide()
	EncounterJournalInstanceSelectRaidTabMid:Hide()
	EncounterJournalInstanceSelectRaidTabLeft:Hide()
	EncounterJournalInstanceSelectRaidTabRight:Hide()
	EncounterJournalNavBarHomeButtonLeft:Hide()
	for i = 8, 10 do
		select(i, EncounterJournalInstanceSelectSuggestTab:GetRegions()):SetAlpha(0)
		select(i, EncounterJournalInstanceSelectDungeonTab:GetRegions()):SetAlpha(0)
		select(i, EncounterJournalInstanceSelectRaidTab:GetRegions()):SetAlpha(0)
	end
	EncounterJournalEncounterFrameInfoModelFrameShadow:Hide()
	EncounterJournalEncounterFrameInfoModelFrame.dungeonBG:Hide()
	select(5, EncounterJournalEncounterFrameInfoDifficulty:GetRegions()):Hide()
	select(6, EncounterJournalEncounterFrameInfoDifficulty:GetRegions()):Hide()
	select(5, EncounterJournalEncounterFrameInfoLootScrollFrameFilterToggle:GetRegions()):Hide()
	select(6, EncounterJournalEncounterFrameInfoLootScrollFrameFilterToggle:GetRegions()):Hide()
	EncounterJournalSearchResultsBg:Hide()

	S:SetBD(EncounterJournal)
	S:CreateBD(EncounterJournalSearchResults, .75)

	EncounterJournalEncounterFrameInfoOverviewTab:ClearAllPoints()
	EncounterJournalEncounterFrameInfoOverviewTab:SetPoint("TOPRIGHT", EncounterJournalEncounterFrame, "TOPRIGHT", 75, 20)

	local tabs = {EncounterJournalEncounterFrameInfoBossTab, EncounterJournalEncounterFrameInfoLootTab, EncounterJournalEncounterFrameInfoModelTab, EncounterJournalEncounterFrameInfoOverviewTab}
	for _, tab in pairs(tabs) do
		tab:SetScale(.75)

		tab:SetBackdrop({
			bgFile = R["media"].gloss,
			edgeFile = R["media"].gloss,
			edgeSize = 1 / .75,
		})

		tab:SetBackdropColor(0, 0, 0, .5)
		tab:SetBackdropBorderColor(0, 0, 0)

		tab:SetNormalTexture("")
		tab:SetPushedTexture("")
		tab:SetDisabledTexture("")
		tab:SetHighlightTexture("")
	end

	EncounterJournalInstanceSelectScrollFrameScrollChildInstanceButton1:SetNormalTexture("")
	EncounterJournalInstanceSelectScrollFrameScrollChildInstanceButton1:SetHighlightTexture("")

	local bg = CreateFrame("Frame", nil, EncounterJournalInstanceSelectScrollFrameScrollChildInstanceButton1)
	bg:SetPoint("TOPLEFT", 3, -3)
	bg:SetPoint("BOTTOMRIGHT", -4, 2)
	bg:SetFrameLevel(EncounterJournalInstanceSelectScrollFrameScrollChildInstanceButton1:GetFrameLevel()-1)
	S:CreateBD(bg, 1)

	local index = 2

	local function listInstances()
		while true do
			local bu = EncounterJournal.instanceSelect.scroll.child["instance"..index]
			if not bu then return end

			bu:SetNormalTexture("")
			bu:SetHighlightTexture("")

			local bg = CreateFrame("Frame", nil, bu)
			bg:SetPoint("TOPLEFT", 3, -3)
			bg:SetPoint("BOTTOMRIGHT", -4, 2)
			bg:SetFrameLevel(bu:GetFrameLevel()-1)
			S:CreateBD(bg, 1)

			index = index + 1
		end
	end

	hooksecurefunc("EncounterJournal_ListInstances", listInstances)
	listInstances()

	EncounterJournalEncounterFrameInfoOverviewScrollFrameScrollChildHeader:Hide()
	EncounterJournalEncounterFrameInfoOverviewScrollFrameScrollChildTitle:SetFontObject("GameFontNormalLarge")

	EncounterJournalEncounterFrameInstanceFrameLoreScrollFrameScrollChildLore:SetTextColor(1, 1, 1)
	EncounterJournalEncounterFrameInstanceFrameLoreScrollFrameScrollChildLore:SetShadowOffset(1, -1)
	EncounterJournalEncounterFrameInfoDetailsScrollFrameScrollChildDescription:SetTextColor(1, 1, 1)
	EncounterJournalEncounterFrameInfoDetailsScrollFrameScrollChildDescription:SetShadowOffset(1, -1)
	EncounterJournalEncounterFrameInfoOverviewScrollFrameScrollChildLoreDescription:SetTextColor(1, 1, 1)
	EncounterJournalEncounterFrameInfoEncounterTitle:SetTextColor(1, 1, 1)
	EncounterJournalEncounterFrameInfoOverviewScrollFrameScrollChildTitle:SetTextColor(1, 1, 1)
	EncounterJournalEncounterFrameInfoOverviewScrollFrameScrollChild.overviewDescription.Text:SetTextColor(1, 1, 1)

	S:CreateBDFrame(EncounterJournalEncounterFrameInfoModelFrame, .25)

	hooksecurefunc("EncounterJournal_DisplayInstance", function()
		local bossIndex = 1;
		local name, description, bossID, _, link = EJ_GetEncounterInfoByIndex(bossIndex)
		while bossID do
			local bossButton = _G["EncounterJournalBossButton"..bossIndex]

			if not bossButton.reskinned then
				bossButton.reskinned = true

				S:Reskin(bossButton, true)
				bossButton.text:SetTextColor(1, 1, 1)
				bossButton.text.SetTextColor = R.dummy
			end


			bossIndex = bossIndex + 1
			name, description, bossID, _, link = EJ_GetEncounterInfoByIndex(bossIndex)
		end
	end)

	hooksecurefunc("EncounterJournal_ToggleHeaders", function(self)
		local index = 1
		local header = _G["EncounterJournalInfoHeader"..index]
		while header do
			if not header.styled then
				header.flashAnim.Play = R.dummy

				header.descriptionBG:SetAlpha(0)
				header.descriptionBGBottom:SetAlpha(0)
				for i = 4, 18 do
					select(i, header.button:GetRegions()):SetTexture("")
				end

				header.description:SetTextColor(1, 1, 1)
				header.button.title:SetTextColor(1, 1, 1)
				header.button.title.SetTextColor = R.dummy
				header.button.expandedIcon:SetTextColor(1, 1, 1)
				header.button.expandedIcon.SetTextColor = R.dummy

				S:Reskin(header.button)

				header.button.abilityIcon:SetTexCoord(.08, .92, .08, .92)
				header.button.bg = S:CreateBG(header.button.abilityIcon)

				header.styled = true
			end

			if header.button.abilityIcon:IsShown() then
				header.button.bg:Show()
			else
				header.button.bg:Hide()
			end

			index = index + 1
			header = _G["EncounterJournalInfoHeader"..index]
		end
	end)

	hooksecurefunc("EncounterJournal_SetUpOverview", function(self, role, index)
		local header = self.overviews[index]
		if not header.styled then
			header.flashAnim.Play = R.dummy

			header.descriptionBG:SetAlpha(0)
			header.descriptionBGBottom:SetAlpha(0)
			for i = 4, 18 do
				select(i, header.button:GetRegions()):SetTexture("")
			end

			header.button.title:SetTextColor(1, 1, 1)
			header.button.title.SetTextColor = R.dummy
			header.button.expandedIcon:SetTextColor(1, 1, 1)
			header.button.expandedIcon.SetTextColor = R.dummy

			S:Reskin(header.button)

			header.styled = true
		end
	end)

	hooksecurefunc("EncounterJournal_SetBullets", function(object, description)
		local parent = object:GetParent()

		if parent.Bullets then
			for _, bullet in pairs(parent.Bullets) do
				if not bullet.styled then
					bullet.Text:SetTextColor(1, 1, 1)
					bullet.styled = true
				end
			end
		end
	end)

	local items = EncounterJournal.encounter.info.lootScroll.buttons

	for i = 1, #items do
		local item = items[i]

		item.boss:SetTextColor(1, 1, 1)
		item.slot:SetTextColor(1, 1, 1)
		item.armorType:SetTextColor(1, 1, 1)

		item.bossTexture:SetAlpha(0)
		item.bosslessTexture:SetAlpha(0)

		item.icon:Point("TOPLEFT", 1, -1)
		item.icon:SetTexCoord(.08, .92, .08, .92)
		item.icon:SetDrawLayer("OVERLAY")
		S:CreateBG(item.icon)

		local bg = CreateFrame("Frame", nil, item)
		bg:SetPoint("TOPLEFT")
		bg:Point("BOTTOMRIGHT", 0, 1)
		bg:SetFrameStrata("BACKGROUND")
		S:CreateBD(bg, 0)

		local tex = item:CreateTexture(nil, "BACKGROUND")
		tex:SetPoint("TOPLEFT")
		tex:Point("BOTTOMRIGHT", -1, 2)
		tex:SetTexture(R["media"].gloss)
		tex:SetVertexColor(0, 0, 0, .25)
	end

	hooksecurefunc("EncounterJournal_SearchUpdate", function()
		local results = EncounterJournal.searchResults.scrollFrame.buttons
		local result

		for i = 1, #results do
			results[i]:SetNormalTexture("")
		end
	end)

		-- [[ Suggest frame ]]

	local suggestFrame = EncounterJournal.suggestFrame

	-- Tooltip

	local EncounterJournalTooltip = EncounterJournalTooltip

	S:CreateBD(EncounterJournalTooltip)

	EncounterJournalTooltip.Item1.newBg = S:ReskinIcon(EncounterJournalTooltip.Item1.icon)
	EncounterJournalTooltip.Item2.newBg = S:ReskinIcon(EncounterJournalTooltip.Item2.icon)

	local function rewardOnEnter()
		for i = 1, 2 do
			local item = EncounterJournalTooltip["Item"..i]
			if item:IsShown() then
				if item.IconBorder:IsShown() then
					item.newBg:SetVertexColor(item.IconBorder:GetVertexColor())
					item.IconBorder:Hide()
				else
					item.newBg:SetVertexColor(0, 0, 0)
				end
			end
		end
	end

	-- Suggestion 1

	local suggestion = suggestFrame.Suggestion1

	suggestion.bg:Hide()

	S:CreateBD(suggestion, .25)

	suggestion.icon:SetPoint("TOPLEFT", 135, -15)
	S:CreateBG(suggestion.icon)

	local centerDisplay = suggestion.centerDisplay

	centerDisplay.title.text:SetTextColor(1, 1, 1)
	centerDisplay.description.text:SetTextColor(.9, .9, .9)

	S:Reskin(suggestion.button)

	local reward = suggestion.reward

	reward:HookScript("OnEnter", rewardOnEnter)
	reward.text:SetTextColor(.9, .9, .9)
	reward.iconRing:Hide()
	reward.iconRingHighlight:SetTexture("")
	S:CreateBG(reward.icon)

	S:ReskinArrow(suggestion.prevButton, "left")
	S:ReskinArrow(suggestion.nextButton, "right")

	-- Suggestion 2 and 3

	for i = 2, 3 do
		local suggestion = suggestFrame["Suggestion"..i]

		suggestion.bg:Hide()

		S:CreateBD(suggestion, .25)

		suggestion.icon:SetPoint("TOPLEFT", 10, -10)
		S:CreateBG(suggestion.icon)

		local centerDisplay = suggestion.centerDisplay

		centerDisplay:ClearAllPoints()
		centerDisplay:SetPoint("TOPLEFT", 85, -10)
		centerDisplay.title.text:SetTextColor(1, 1, 1)
		centerDisplay.description.text:SetTextColor(.9, .9, .9)

		S:Reskin(centerDisplay.button)

		local reward = suggestion.reward

		reward:HookScript("OnEnter", rewardOnEnter)
		reward.iconRing:Hide()
		reward.iconRingHighlight:SetTexture("")
		S:CreateBG(reward.icon)
	end

	-- Hook functions

	hooksecurefunc("EJSuggestFrame_RefreshDisplay", function()
		local self = suggestFrame

		if #self.suggestions > 0 then
			local suggestion = self.Suggestion1
			local data = self.suggestions[1]

			suggestion.iconRing:Hide()

			if data.iconPath then
				suggestion.icon:SetMask(nil)
				suggestion.icon:SetTexCoord(.08, .92, .08, .92)
			end
		end

		if #self.suggestions > 1 then
			for i = 2, #self.suggestions do
				local suggestion = self["Suggestion"..i]
				if not suggestion then break end

				local data = self.suggestions[i]

				suggestion.iconRing:Hide()

				if data.iconPath then
					suggestion.icon:SetMask(nil)
					suggestion.icon:SetTexCoord(.08, .92, .08, .92)
				end
			end
		end
	end)

	hooksecurefunc("EJSuggestFrame_UpdateRewards", function(suggestion)
		if suggestion.reward.data then
			suggestion.reward.icon:SetMask(nil)
			suggestion.reward.icon:SetTexCoord(.08, .92, .08, .92)
		end
	end)

	S:Reskin(EncounterJournalNavBarHomeButton)
	S:Reskin(EncounterJournalInstanceSelectSuggestTab)
	S:Reskin(EncounterJournalInstanceSelectDungeonTab)
	S:Reskin(EncounterJournalInstanceSelectRaidTab)
	S:Reskin(EncounterJournalEncounterFrameInfoDifficulty)
	S:Reskin(EncounterJournalEncounterFrameInfoResetButton)
	S:Reskin(EncounterJournalEncounterFrameInfoLootScrollFrameFilterToggle)
	S:ReskinClose(EncounterJournalCloseButton)
	S:ReskinClose(EncounterJournalSearchResultsCloseButton)
	S:ReskinInput(EncounterJournalSearchBox)
	S:ReskinScroll(EncounterJournalInstanceSelectScrollFrameScrollBar)
	S:ReskinScroll(EncounterJournalEncounterFrameInstanceFrameLoreScrollFrameScrollBar)
	S:ReskinScroll(EncounterJournalEncounterFrameInfoDetailsScrollFrameScrollBar)
	S:ReskinScroll(EncounterJournalEncounterFrameInfoLootScrollFrameScrollBar)
	S:ReskinScroll(EncounterJournalEncounterFrameInfoBossesScrollFrameScrollBar)
	S:ReskinScroll(EncounterJournalSearchResultsScrollFrameScrollBar)
end

S:RegisterSkin("Blizzard_EncounterJournal", LoadSkin)
