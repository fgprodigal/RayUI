----------------------------------------------------------
-- Load RayUI Environment
----------------------------------------------------------
RayUI:LoadEnv("Skins")


local S = _Skins

local function LoadSkin()
	local r, g, b = _r, _g, _b

	EncounterJournalEncounterFrameInfo:DisableDrawLayer("BACKGROUND")
	EncounterJournal:DisableDrawLayer("BORDER")
	EncounterJournalInset:DisableDrawLayer("BORDER")
	EncounterJournalNavBar:DisableDrawLayer("BORDER")
	-- EncounterJournalSearchResults:DisableDrawLayer("BORDER")
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
	EncounterJournalEncounterFrameInfoModelFrameShadow:Hide()
	EncounterJournalEncounterFrameInfoModelFrame.dungeonBG:Hide()
	EncounterJournal.encounter.info.difficulty.UpLeft:SetAlpha(0)
	EncounterJournal.encounter.info.difficulty.UpRight:SetAlpha(0)
	EncounterJournal.encounter.info.difficulty.DownLeft:SetAlpha(0)
	EncounterJournal.encounter.info.difficulty.DownRight:SetAlpha(0)
	select(5, EncounterJournalEncounterFrameInfoDifficulty:GetRegions()):Hide()
	select(6, EncounterJournalEncounterFrameInfoDifficulty:GetRegions()):Hide()
	EncounterJournal.encounter.info.lootScroll.slotFilter.UpLeft:SetAlpha(0)
	EncounterJournal.encounter.info.lootScroll.slotFilter.UpRight:SetAlpha(0)
	EncounterJournal.encounter.info.lootScroll.slotFilter.DownLeft:SetAlpha(0)
	EncounterJournal.encounter.info.lootScroll.slotFilter.DownRight:SetAlpha(0)
	select(5, EncounterJournalEncounterFrameInfoLootScrollFrameSlotFilterToggle:GetRegions()):Hide()
	select(6, EncounterJournalEncounterFrameInfoLootScrollFrameSlotFilterToggle:GetRegions()):Hide()
	EncounterJournal.encounter.info.lootScroll.filter.UpLeft:SetAlpha(0)
	EncounterJournal.encounter.info.lootScroll.filter.UpRight:SetAlpha(0)
	EncounterJournal.encounter.info.lootScroll.filter.DownLeft:SetAlpha(0)
	EncounterJournal.encounter.info.lootScroll.filter.DownRight:SetAlpha(0)
	select(5, EncounterJournalEncounterFrameInfoLootScrollFrameFilterToggle:GetRegions()):Hide()
	select(6, EncounterJournalEncounterFrameInfoLootScrollFrameFilterToggle:GetRegions()):Hide()

	EncounterJournalSearchResultsBg:Hide()

	S:SetBD(EncounterJournal)
	S:CreateBD(EncounterJournalSearchResults, .75)
	S:Reskin(EncounterJournalNavBarHomeButton)

	-- [[ Dungeon / raid tabs ]]

	local function onEnable(self)
		self:SetHeight(self.storedHeight) -- prevent it from resizing
		self:SetBackdropColor(0, 0, 0, 0)
	end

	local function onDisable(self)
		self:SetBackdropColor(r, g, b, .2)
	end

	local function onClick(self)
		self:GetFontString():SetTextColor(1, 1, 1)
	end

	for _, tabName in pairs({"EncounterJournalInstanceSelectSuggestTab", "EncounterJournalInstanceSelectDungeonTab", "EncounterJournalInstanceSelectRaidTab","EncounterJournalInstanceSelectLootJournalTab"}) do
		local tab = _G[tabName]
		local text = tab:GetFontString()

		tab:DisableDrawLayer("OVERLAY")

		tab.mid:Hide()
		tab.left:Hide()
		tab.right:Hide()

		tab.midHighlight:SetAlpha(0)
		tab.leftHighlight:SetAlpha(0)
		tab.rightHighlight:SetAlpha(0)

		tab:SetHeight(tab.storedHeight)
		tab.grayBox:GetRegions():SetAllPoints(tab)

		text:SetPoint("CENTER")
		text:SetTextColor(1, 1, 1)

		tab:HookScript("OnEnable", onEnable)
		tab:HookScript("OnDisable", onDisable)
		tab:HookScript("OnClick", onClick)

		S:Reskin(tab)
	end

	EncounterJournalInstanceSelectSuggestTab:SetBackdropColor(r, g, b, .2)

	-- [[ Side tabs ]]

	local tabs = {
		EncounterJournalEncounterFrameInfoOverviewTab,
		EncounterJournalEncounterFrameInfoLootTab,
		EncounterJournalEncounterFrameInfoBossTab,
		EncounterJournalEncounterFrameInfoModelTab
	}
	for _, tab in pairs(tabs) do
		S:CreateBD(tab)

		tab:SetNormalTexture("")
		tab:SetPushedTexture("")
		tab:SetDisabledTexture("")
		tab:SetHighlightTexture("")
	end

	EncounterJournalEncounterFrameInfoOverviewTab:ClearAllPoints()
	EncounterJournalEncounterFrameInfoOverviewTab:Point("TOPLEFT", EncounterJournalEncounterFrameInfo, "TOPRIGHT", 7 + R.Border, -35)
	EncounterJournalEncounterFrameInfoLootTab:ClearAllPoints()
	EncounterJournalEncounterFrameInfoLootTab:SetPoint("TOP", EncounterJournalEncounterFrameInfoOverviewTab, "BOTTOM", 0, 1)
	EncounterJournalEncounterFrameInfoBossTab:ClearAllPoints()
	EncounterJournalEncounterFrameInfoBossTab:SetPoint("TOP", EncounterJournalEncounterFrameInfoLootTab, "BOTTOM", 0, 1)

	-- [[ Instance select ]]

	S:ReskinDropDown(EncounterJournalInstanceSelectTierDropDown)

	local index = 1

	local function listInstances()
		while true do
			local bu = EncounterJournal.instanceSelect.scroll.child["instance"..index]
			if not bu then return end

			bu:SetNormalTexture("")
			bu:SetHighlightTexture("")
			bu:SetPushedTexture("")

			bu.bgImage:SetDrawLayer("BACKGROUND", 1)

			local bg = S:CreateBG(bu.bgImage)
			bg:SetPoint("TOPLEFT", 3, -3)
			bg:SetPoint("BOTTOMRIGHT", -4, 2)

			index = index + 1
		end
	end

	hooksecurefunc("EncounterJournal_ListInstances", listInstances)
	listInstances()

	-- [[ Encounter frame ]]

	EncounterJournalEncounterFrameInfoOverviewScrollFrameScrollChildHeader:Hide()
	EncounterJournalEncounterFrameInfoOverviewScrollFrameScrollChildTitle:SetFontObject("GameFontNormalLarge")

	EncounterJournalEncounterFrameInfoEncounterTitle:SetTextColor(1, 1, 1)
	EncounterJournalEncounterFrameInstanceFrameLoreScrollFrameScrollChildLore:SetTextColor(1, 1, 1)
	EncounterJournalEncounterFrameInfoDetailsScrollFrameScrollChildDescription:SetTextColor(1, 1, 1)
	EncounterJournalEncounterFrameInfoOverviewScrollFrameScrollChildLoreDescription:SetTextColor(1, 1, 1)
	EncounterJournalEncounterFrameInfoOverviewScrollFrameScrollChildTitle:SetTextColor(1, 1, 1)
	EncounterJournalEncounterFrameInfoOverviewScrollFrameScrollChild.overviewDescription.Text:SetTextColor(1, 1, 1)

	S:CreateBDFrame(EncounterJournalEncounterFrameInfoModelFrame, .25)

	EncounterJournalEncounterFrameInfoCreatureButton1:SetPoint("TOPLEFT", EncounterJournalEncounterFrameInfoModelFrame, 0, -35)

	do
		local numBossButtons = 1
		local bossButton

		hooksecurefunc("EncounterJournal_DisplayInstance", function()
			bossButton = _G["EncounterJournalBossButton"..numBossButtons]
			while bossButton do
				S:Reskin(bossButton, true)

				bossButton.text:SetTextColor(1, 1, 1)
				bossButton.text.SetTextColor = R.dummy

				local hl = bossButton:GetHighlightTexture()
				hl:SetColorTexture(r, g, b, .2)
				hl:SetPoint("TOPLEFT", 2, -1)
				hl:SetPoint("BOTTOMRIGHT", 0, 1)

				bossButton.creature:SetPoint("TOPLEFT", 0, -4)

				numBossButtons = numBossButtons + 1
				bossButton = _G["EncounterJournalBossButton"..numBossButtons]
			end

			-- move last tab
			local _, point = EncounterJournalEncounterFrameInfoModelTab:GetPoint()
			EncounterJournalEncounterFrameInfoModelTab:SetPoint("TOP", point, "BOTTOM", 0, 1)
		end)
	end

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

				S:Reskin(header.button, true)

				header.button.abilityIcon:SetTexCoord(.08, .92, .08, .92)
				header.button.bg = S:CreateBG(header.button.abilityIcon)

				if header.button.abilityIcon:IsShown() then
					header.button.bg:Show()
				else
					header.button.bg:Hide()
				end

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

			-- Blizzard already uses .tex for this frame, so we can't do highlights
			S:Reskin(header.button, true)

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

		item.icon:SetPoint("TOPLEFT", 1, -1)

		item.icon:SetTexCoord(.08, .92, .08, .92)
		item.icon:SetDrawLayer("OVERLAY")
		S:CreateBG(item.icon)

		local bg = CreateFrame("Frame", nil, item)
		bg:SetPoint("TOPLEFT")
		bg:SetPoint("BOTTOMRIGHT", 0, 1)
		bg:SetFrameLevel(item:GetFrameLevel() - 1)
		S:CreateBD(bg, .25)

		item.IconBorder:Kill()
	end

	-- [[ Search results ]]

	for i = 1, 11 do
		select(i, EncounterJournalSearchResults:GetRegions()):Hide()
	end
	EncounterJournalSearchResultsTitleText:Show()

	EncounterJournal.searchBox.searchPreviewContainer.botLeftCorner:Hide()
	EncounterJournal.searchBox.searchPreviewContainer.botRightCorner:Hide()
	EncounterJournal.searchBox.searchPreviewContainer.bottomBorder:Hide()
	EncounterJournal.searchBox.searchPreviewContainer.leftBorder:Hide()
	EncounterJournal.searchBox.searchPreviewContainer.rightBorder:Hide()

	local function resultOnEnter(self)
		self.hl:Show()
	end

	local function resultOnLeave(self)
		self.hl:Hide()
	end

	local function styleSearchButton(result, index)
		if index == 1 then
			result:SetPoint("TOPLEFT", EncounterJournalSearchBox, "BOTTOMLEFT", 0, 1)
			result:SetPoint("TOPRIGHT", EncounterJournalSearchBox, "BOTTOMRIGHT", -5, 1)
		else
			result:SetPoint("TOPLEFT", EncounterJournalSearchBox["sbutton"..index-1], "BOTTOMLEFT", 0, 1)
			result:SetPoint("TOPRIGHT", EncounterJournalSearchBox["sbutton"..index-1], "BOTTOMRIGHT", 0, 1)
		end

		result:SetNormalTexture("")
		result:SetPushedTexture("")
		result:SetHighlightTexture("")

		local hl = result:CreateTexture(nil, "BACKGROUND")
		hl:SetAllPoints()
		hl:SetTexture(R["media"].normal)
		hl:SetVertexColor(r, g, b, .2)
		hl:Hide()
		result.hl = hl

		S:CreateBD(result)
		result:SetBackdropColor(.1, .1, .1, .9)

		if result.icon then
			result:GetRegions():Hide() -- icon frame

			result.icon:SetTexCoord(.08, .92, .08, .92)

			local bg = S:CreateBG(result.icon)
			bg:SetDrawLayer("BACKGROUND", 1)
		end

		result:HookScript("OnEnter", resultOnEnter)
		result:HookScript("OnLeave", resultOnLeave)
	end

	for i = 1, 5 do
		styleSearchButton(EncounterJournalSearchBox["sbutton"..i], i)
	end

	styleSearchButton(EncounterJournalSearchBox.showAllResults, 6)

	hooksecurefunc("EncounterJournal_SearchUpdate", function()
		local scrollFrame = EncounterJournal.searchResults.scrollFrame
		local offset = HybridScrollFrame_GetOffset(scrollFrame)
		local results = scrollFrame.buttons
		local result, index

		local numResults = EJ_GetNumSearchResults()

		for i = 1, #results do
			result = results[i]
			index = offset + i

			if index <= numResults then
				if not result.styled then
					result:SetNormalTexture("")
					result:SetPushedTexture("")
					result:GetRegions():Hide()

					result.resultType:SetTextColor(1, 1, 1)
					result.path:SetTextColor(1, 1, 1)

					S:CreateBG(result.icon)

					result.styled = true
				end

				if result.icon:GetTexCoord() == 0 then
					result.icon:SetTexCoord(.08, .92, .08, .92)
				end
			end
		end
	end)

	hooksecurefunc(EncounterJournal.searchResults.scrollFrame, "update", function(self)
		for i = 1, #self.buttons do
			local result = self.buttons[i]

			if result.icon:GetTexCoord() == 0 then
				result.icon:SetTexCoord(.08, .92, .08, .92)
			end
		end
	end)

	S:ReskinClose(EncounterJournalSearchResultsCloseButton)
	S:ReskinScroll(EncounterJournalSearchResultsScrollFrameScrollBar)

	-- [[ Various controls ]]

	S:Reskin(EncounterJournalEncounterFrameInfoDifficulty)
	S:Reskin(EncounterJournalEncounterFrameInfoResetButton)
	S:Reskin(EncounterJournalEncounterFrameInfoLootScrollFrameFilterToggle)
	S:Reskin(EncounterJournalEncounterFrameInfoLootScrollFrameSlotFilterToggle)
	S:ReskinClose(EncounterJournalCloseButton)
	S:ReskinInput(EncounterJournalSearchBox)
	S:ReskinScroll(EncounterJournalInstanceSelectScrollFrameScrollBar)
	S:ReskinScroll(EncounterJournalEncounterFrameInstanceFrameLoreScrollFrameScrollBar)
	S:ReskinScroll(EncounterJournalEncounterFrameInfoOverviewScrollFrameScrollBar)
	S:ReskinScroll(EncounterJournalEncounterFrameInfoBossesScrollFrameScrollBar)
	S:ReskinScroll(EncounterJournalEncounterFrameInfoDetailsScrollFrameScrollBar)
	S:ReskinScroll(EncounterJournalEncounterFrameInfoLootScrollFrameScrollBar)

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
					-- item.newBg:SetVertexColor(item.IconBorder:GetVertexColor())
					item.IconBorder:Hide()
				else
					item.newBg:SetVertexColor(0, 0, 0)
				end
			end
		end
	end

	--[[ Suggestion 1 ]]

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
				suggestion.icon:SetMask("")
				suggestion.icon:SetTexture(data.iconPath)
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
					suggestion.icon:SetMask("")
					suggestion.icon:SetTexture(data.iconPath)
					suggestion.icon:SetTexCoord(.08, .92, .08, .92)
				end
			end
		end
	end)

	hooksecurefunc("EJSuggestFrame_UpdateRewards", function(suggestion)
		local rewardData = suggestion.reward.data
		if rewardData then
			local texture = rewardData.itemIcon or rewardData.currencyIcon or [[Interface\Icons\achievement_guildperk_mobilebanking]]
			suggestion.reward.icon:SetMask("")
			suggestion.reward.icon:SetTexture(texture)
			suggestion.reward.icon:SetTexCoord(.08, .92, .08, .92)
		end
	end)

	-- [[ Loot tab ]]

	S:Reskin(EncounterJournal.LootJournal.LegendariesFrame.ClassButton)
	EncounterJournal.LootJournal.LegendariesFrame.ClassButton:GetFontString():SetTextColor(1, 1, 1)
	select(5, EncounterJournal.LootJournal.LegendariesFrame.ClassButton:GetRegions()):Hide()
	select(6, EncounterJournal.LootJournal.LegendariesFrame.ClassButton:GetRegions()):Hide()
	EncounterJournal.LootJournal.LegendariesFrame.ClassButton.UpLeft:SetAlpha(0)
	EncounterJournal.LootJournal.LegendariesFrame.ClassButton.UpRight:SetAlpha(0)
	EncounterJournal.LootJournal.LegendariesFrame.ClassButton.HighLeft:SetAlpha(0)
	EncounterJournal.LootJournal.LegendariesFrame.ClassButton.HighRight:SetAlpha(0)
	EncounterJournal.LootJournal.LegendariesFrame.ClassButton.DownLeft:SetAlpha(0)
	EncounterJournal.LootJournal.LegendariesFrame.ClassButton.DownRight:SetAlpha(0)

	S:Reskin(EncounterJournal.LootJournal.LegendariesFrame.SlotButton)
	EncounterJournal.LootJournal.LegendariesFrame.SlotButton:GetFontString():SetTextColor(1, 1, 1)
	select(5, EncounterJournal.LootJournal.LegendariesFrame.SlotButton:GetRegions()):Hide()
	select(6, EncounterJournal.LootJournal.LegendariesFrame.SlotButton:GetRegions()):Hide()
	EncounterJournal.LootJournal.LegendariesFrame.SlotButton.UpLeft:SetAlpha(0)
	EncounterJournal.LootJournal.LegendariesFrame.SlotButton.UpRight:SetAlpha(0)
	EncounterJournal.LootJournal.LegendariesFrame.SlotButton.HighLeft:SetAlpha(0)
	EncounterJournal.LootJournal.LegendariesFrame.SlotButton.HighRight:SetAlpha(0)
	EncounterJournal.LootJournal.LegendariesFrame.SlotButton.DownLeft:SetAlpha(0)
	EncounterJournal.LootJournal.LegendariesFrame.SlotButton.DownRight:SetAlpha(0)

	EncounterJournal.LootJournal:DisableDrawLayer("BACKGROUND")
	S:ReskinScroll(EncounterJournalScrollBar)
	S:ReskinDropDown(LootJournalViewDropDown)

	local itemsLeftSide = EncounterJournal.LootJournal.LegendariesFrame.buttons
	local itemsRightSide = EncounterJournal.LootJournal.LegendariesFrame.rightSideButtons
	for _, items in ipairs({itemsLeftSide, itemsRightSide}) do
		for i = 1, #items do
			local item = items[i]

			item.ItemType:SetTextColor(1, 1, 1)
			item.Background:Hide()

			item.Icon:SetPoint("TOPLEFT", 1, -1)

			item.Icon:SetTexCoord(.08, .92, .08, .92)
			item.Icon:SetDrawLayer("OVERLAY")
			S:CreateBG(item.Icon)

			local bg = CreateFrame("Frame", nil, item)
			bg:SetPoint("TOPLEFT")
			bg:SetPoint("BOTTOMRIGHT", 0, 1)
			bg:SetFrameLevel(item:GetFrameLevel() - 1)
			S:CreateBD(bg, .25)
		end
	end

	S:Reskin(EncounterJournal.LootJournal.ItemSetsFrame.ClassButton)
	EncounterJournal.LootJournal.ItemSetsFrame.ClassButton:GetFontString():SetTextColor(1, 1, 1)
	select(5, EncounterJournal.LootJournal.ItemSetsFrame.ClassButton:GetRegions()):Hide()
	select(6, EncounterJournal.LootJournal.ItemSetsFrame.ClassButton:GetRegions()):Hide()
	EncounterJournal.LootJournal.ItemSetsFrame.ClassButton.UpLeft:SetAlpha(0)
	EncounterJournal.LootJournal.ItemSetsFrame.ClassButton.UpRight:SetAlpha(0)
	EncounterJournal.LootJournal.ItemSetsFrame.ClassButton.HighLeft:SetAlpha(0)
	EncounterJournal.LootJournal.ItemSetsFrame.ClassButton.HighRight:SetAlpha(0)
	EncounterJournal.LootJournal.ItemSetsFrame.ClassButton.DownLeft:SetAlpha(0)
	EncounterJournal.LootJournal.ItemSetsFrame.ClassButton.DownRight:SetAlpha(0)

	hooksecurefunc(EncounterJournal.LootJournal.ItemSetsFrame, "UpdateList", function()
		local itemSets = EncounterJournal.LootJournal.ItemSetsFrame.buttons
		for i = 1, #itemSets do
			local itemSet = itemSets[i]

			itemSet.ItemLevel:SetTextColor(1, 1, 1)
			itemSet.Background:Hide()

			if not itemSet.bg then
				local bg = CreateFrame("Frame", nil, itemSet)
				bg:SetPoint("TOPLEFT")
				bg:SetPoint("BOTTOMRIGHT", 0, 1)
				bg:SetFrameLevel(itemSet:GetFrameLevel() - 1)
				S:CreateBD(bg, .25)
				itemSet.bg = bg
			end

			local items = itemSet.ItemButtons
			for j = 1, #items do
				local item = items[j]

				item.Border:Hide()
				item.Icon:SetPoint("TOPLEFT", 1, -1)

				item.Icon:SetTexCoord(.08, .92, .08, .92)
				item.Icon:SetDrawLayer("OVERLAY")
				S:CreateBG(item.Icon)
			end
		end
	end)
end

S:AddCallbackForAddon("Blizzard_EncounterJournal", "EncounterJournal", LoadSkin)
