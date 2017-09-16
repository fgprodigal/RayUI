----------------------------------------------------------
-- Load RayUI Environment
----------------------------------------------------------
RayUI:LoadEnv("Skins")


local S = _Skins

local function LoadSkin()
	S:CreateBD(AchievementFrame)
	S:CreateSD(AchievementFrame)
	AchievementFrameCategories:SetBackdrop(nil)
	AchievementFrameSummary:SetBackdrop(nil)
	for i = 1, 17 do
		select(i, AchievementFrame:GetRegions()):Hide()
	end
	AchievementFrameSummaryBackground:Hide()
	AchievementFrameSummary:GetChildren():Hide()
	AchievementFrameCategoriesContainerScrollBarBG:SetAlpha(0)
	for i = 1, 4 do
		select(i, AchievementFrameHeader:GetRegions()):Hide()
	end
	AchievementFrameHeader:StripTextures()
	AchievementFrameHeaderRightDDLInset:SetAlpha(0)
	select(2, AchievementFrameAchievements:GetChildren()):Hide()
	AchievementFrameAchievementsBackground:Hide()
	select(3, AchievementFrameAchievements:GetRegions()):Hide()
	AchievementFrameStatsBG:Hide()
	AchievementFrameSummaryAchievementsHeaderHeader:Hide()
	AchievementFrameSummaryCategoriesHeaderTexture:Hide()
	select(3, AchievementFrameStats:GetChildren()):Hide()
	select(5, AchievementFrameComparison:GetChildren()):Hide()
	AchievementFrameComparisonHeaderBG:Hide()
	AchievementFrameComparisonHeaderPortrait:Hide()
	AchievementFrameComparisonHeaderPortraitBg:Hide()
	AchievementFrameComparisonBackground:Hide()
	AchievementFrameComparisonDark:SetAlpha(0)
	AchievementFrameComparisonSummaryPlayerBackground:Hide()
	AchievementFrameComparisonSummaryFriendBackground:Hide()

	local first = 1
	hooksecurefunc("AchievementFrameCategories_Update", function()
		if first == 1 then
			for i = 1, 19 do
				_G["AchievementFrameCategoriesContainerButton"..i.."Background"]:Hide()
			end
			first = 0
		end
	end)

	AchievementFrameHeaderPoints:SetPoint("TOP", AchievementFrame, "TOP", 0, -6)
	S:ReskinInput(AchievementFrame.searchBox)
	AchievementFrame.searchBox:ClearAllPoints()
	AchievementFrame.searchBox:Point("BOTTOMRIGHT", AchievementFrameAchievementsContainer, "TOPRIGHT", -2, -2)
	AchievementFrame.searchBox:Height(20)
	AchievementFrameFilterDropDown:ClearAllPoints()
	AchievementFrameFilterDropDown:Point("RIGHT", AchievementFrame.searchBox, "LEFT", 2, -2)
	AchievementFrameFilterDropDownText:ClearAllPoints()
	AchievementFrameFilterDropDownText:SetPoint("CENTER", -10, 1)

	for i = 1, 3 do
		local tab = _G["AchievementFrameTab"..i]
		if tab then
			S:CreateTab(tab)
		end
	end

	AchievementFrameSummaryCategoriesStatusBar:SetStatusBarTexture(R["media"].normal)
	AchievementFrameSummaryCategoriesStatusBar:GetStatusBarTexture():SetGradient("VERTICAL", R:GetGradientColor(0, 1, 0))
	AchievementFrameSummaryCategoriesStatusBarLeft:Hide()
	AchievementFrameSummaryCategoriesStatusBarMiddle:Hide()
	AchievementFrameSummaryCategoriesStatusBarRight:Hide()
	AchievementFrameSummaryCategoriesStatusBarFillBar:Hide()
	AchievementFrameSummaryCategoriesStatusBarTitle:SetTextColor(1, 1, 1)
	AchievementFrameSummaryCategoriesStatusBarTitle:SetPoint("LEFT", AchievementFrameSummaryCategoriesStatusBar, "LEFT", 6, 0)
	AchievementFrameSummaryCategoriesStatusBarText:SetPoint("RIGHT", AchievementFrameSummaryCategoriesStatusBar, "RIGHT", -5, 0)

	local bg = CreateFrame("Frame", nil, AchievementFrameSummaryCategoriesStatusBar)
	bg:Point("TOPLEFT", -1, 1)
	bg:Point("BOTTOMRIGHT", 1, -1)
	bg:SetFrameLevel(AchievementFrameSummaryCategoriesStatusBar:GetFrameLevel()-1)
	S:CreateBD(bg, .25)

	for i = 1, 7 do
		local bu = _G["AchievementFrameAchievementsContainerButton"..i]
		bu:DisableDrawLayer("BORDER")

		bu.background:SetTexture(R["media"].normal)
		bu.background:SetVertexColor(0, 0, 0, .25)

		bu.description:SetTextColor(.9, .9, .9)
		bu.description.SetTextColor = R.dummy
		bu.description:SetShadowOffset(1, -1)
		bu.description.SetShadowOffset = R.dummy

		_G["AchievementFrameAchievementsContainerButton"..i.."TitleBackground"]:Hide()
		_G["AchievementFrameAchievementsContainerButton"..i.."Glow"]:Hide()
		_G["AchievementFrameAchievementsContainerButton"..i.."RewardBackground"]:SetAlpha(0)
		_G["AchievementFrameAchievementsContainerButton"..i.."PlusMinus"]:SetAlpha(0)
		_G["AchievementFrameAchievementsContainerButton"..i.."Highlight"]:SetAlpha(0)
		_G["AchievementFrameAchievementsContainerButton"..i.."IconOverlay"]:Hide()
		_G["AchievementFrameAchievementsContainerButton"..i.."GuildCornerL"]:SetAlpha(0)
		_G["AchievementFrameAchievementsContainerButton"..i.."GuildCornerR"]:SetAlpha(0)

		local bg = CreateFrame("Frame", nil, bu)
		bg:Point("TOPLEFT", 2, -2)
		bg:Point("BOTTOMRIGHT", -2, 2)
		S:CreateBD(bg, 0)

		bu.icon.texture:SetTexCoord(.08, .92, .08, .92)
		S:CreateBG(bu.icon.texture)
	end

	hooksecurefunc("AchievementButton_DisplayAchievement", function(button, category, achievement)
		local _, _, _, completed = GetAchievementInfo(category, achievement)
		if completed then
			if button.accountWide then
				button.label:SetTextColor(0, .6, 1)
			else
				button.label:SetTextColor(.9, .9, .9)
			end
		else
			if button.accountWide then
				button.label:SetTextColor(0, .3, .5)
			else
				button.label:SetTextColor(.65, .65, .65)
			end
		end
	end)

	hooksecurefunc("AchievementObjectives_DisplayCriteria", function(objectivesFrame, id)
		for i = 1, GetAchievementNumCriteria(id) do
			local name = _G["AchievementFrameCriteria"..i.."Name"]
			if name and select(2, name:GetTextColor()) == 0 then
				name:SetTextColor(1, 1, 1)
			end

			local bu = _G["AchievementFrameMeta"..i]
			if bu and select(2, bu.label:GetTextColor()) == 0 then
				bu.label:SetTextColor(1, 1, 1)
			end
		end
	end)

	hooksecurefunc("AchievementButton_GetProgressBar", function(index)
		local bar = _G["AchievementFrameProgressBar"..index]
		if not bar.reskinned then
            local r, g, b = bar:GetStatusBarColor()
			bar:SetStatusBarTexture(R["media"].normal)
        	bar:GetStatusBarTexture():SetGradient("VERTICAL", R:GetGradientColor(r, g, b))

			_G["AchievementFrameProgressBar"..index.."BG"]:SetColorTexture(0, 0, 0, .25)
			_G["AchievementFrameProgressBar"..index.."BorderLeft"]:Hide()
			_G["AchievementFrameProgressBar"..index.."BorderCenter"]:Hide()
			_G["AchievementFrameProgressBar"..index.."BorderRight"]:Hide()

			local bg = CreateFrame("Frame", nil, bar)
			bg:Point("TOPLEFT", -1, 1)
			bg:Point("BOTTOMRIGHT", 1, -1)
			S:CreateBD(bg, 0)

			bar.reskinned = true
		end
	end)

	hooksecurefunc("AchievementFrameSummary_UpdateAchievements", function()
		for i = 1, ACHIEVEMENTUI_MAX_SUMMARY_ACHIEVEMENTS do
			local bu = _G["AchievementFrameSummaryAchievement"..i]
			if not bu.reskinned then
				bu:DisableDrawLayer("BORDER")

				local bd = _G["AchievementFrameSummaryAchievement"..i.."Background"]

				bd:SetTexture(R["media"].normal)
				bd:SetVertexColor(0, 0, 0, .25)

				_G["AchievementFrameSummaryAchievement"..i.."TitleBackground"]:Hide()
				_G["AchievementFrameSummaryAchievement"..i.."Glow"]:Hide()
				_G["AchievementFrameSummaryAchievement"..i.."Highlight"]:SetAlpha(0)
				_G["AchievementFrameSummaryAchievement"..i.."IconOverlay"]:Hide()

				local text = _G["AchievementFrameSummaryAchievement"..i.."Description"]
				text:SetTextColor(.9, .9, .9)
				text.SetTextColor = R.dummy
				text:SetShadowOffset(1, -1)
				text.SetShadowOffset = R.dummy

				local bg = CreateFrame("Frame", nil, bu)
				bg:Point("TOPLEFT", 2, -2)
				bg:Point("BOTTOMRIGHT", -2, 2)
				S:CreateBD(bg, 0)

				local ic = _G["AchievementFrameSummaryAchievement"..i.."IconTexture"]
				ic:SetTexCoord(.08, .92, .08, .92)
				S:CreateBG(ic)

				bu.reskinned = true
			end
		end
	end)

	AchievementFrame:HookScript("OnShow", function()
		for i=1, 20 do
			local frame = _G["AchievementFrameCategoriesContainerButton"..i]

			frame:StyleButton()
			frame:GetHighlightTexture():Point("TOPLEFT", 0, -4)
			frame:GetHighlightTexture():Point("BOTTOMRiGHT", 0, -3)
			frame:GetPushedTexture():Point("TOPLEFT", 0, -4)
			frame:GetPushedTexture():Point("BOTTOMRiGHT", 0, -3)
		end
	end)

	for i = 1, 12 do
		local bu = _G["AchievementFrameSummaryCategoriesCategory"..i]
		local bar = bu:GetStatusBarTexture()
		local label = _G["AchievementFrameSummaryCategoriesCategory"..i.."Label"]

		bu:SetStatusBarTexture(R["media"].normal)
		bar:SetGradient("VERTICAL", R:GetGradientColor(0, 1, 0))
		label:SetTextColor(1, 1, 1)
		label:Point("LEFT", bu, "LEFT", 6, 0)

		local bg = CreateFrame("Frame", nil, bu)
		bg:Point("TOPLEFT", -1, 1)
		bg:Point("BOTTOMRIGHT", 1, -1)
		bg:SetFrameLevel(bu:GetFrameLevel()-1)
		S:CreateBD(bg, .25)

		_G["AchievementFrameSummaryCategoriesCategory"..i.."Left"]:Hide()
		_G["AchievementFrameSummaryCategoriesCategory"..i.."Middle"]:Hide()
		_G["AchievementFrameSummaryCategoriesCategory"..i.."Right"]:Hide()
		_G["AchievementFrameSummaryCategoriesCategory"..i.."FillBar"]:Hide()
		_G["AchievementFrameSummaryCategoriesCategory"..i.."ButtonHighlight"]:SetAlpha(0)
		_G["AchievementFrameSummaryCategoriesCategory"..i.."Text"]:SetPoint("RIGHT", bu, "RIGHT", -5, 0)
	end

	for i = 1, 20 do
		_G["AchievementFrameStatsContainerButton"..i.."BG"]:Hide()
		_G["AchievementFrameStatsContainerButton"..i.."BG"].Show = R.dummy
		_G["AchievementFrameStatsContainerButton"..i.."HeaderLeft"]:SetAlpha(0)
		_G["AchievementFrameStatsContainerButton"..i.."HeaderMiddle"]:SetAlpha(0)
		_G["AchievementFrameStatsContainerButton"..i.."HeaderRight"]:SetAlpha(0)
	end

	AchievementFrameComparisonHeader:SetPoint("BOTTOMRIGHT", AchievementFrameComparison, "TOPRIGHT", 39, 25)

	local headerbg = CreateFrame("Frame", nil, AchievementFrameComparisonHeader)
	headerbg:SetPoint("TOPLEFT", 20, -20)
	headerbg:SetPoint("BOTTOMRIGHT", -28, -5)
	headerbg:SetFrameLevel(AchievementFrameComparisonHeader:GetFrameLevel()-1)
	S:CreateBD(headerbg, .25)

	local summaries = {AchievementFrameComparisonSummaryPlayer, AchievementFrameComparisonSummaryFriend}

	for _, frame in pairs(summaries) do
		frame:SetBackdrop(nil)
		local bg = CreateFrame("Frame", nil, frame)
		bg:Point("TOPLEFT", 2, -2)
		bg:Point("BOTTOMRIGHT", -2, 0)
		bg:SetFrameLevel(frame:GetFrameLevel()-1)
		S:CreateBD(bg, .25)
	end

	local bars = {AchievementFrameComparisonSummaryPlayerStatusBar, AchievementFrameComparisonSummaryFriendStatusBar}

	for _, bar in pairs(bars) do
		local name = bar:GetName()
		bar:SetStatusBarTexture(R["media"].normal)
	--	bar:GetStatusBarTexture():SetGradient("VERTICAL", 0, .4, 0, 0, .6, 0)
		_G[name.."Left"]:Hide()
		_G[name.."Middle"]:Hide()
		_G[name.."Right"]:Hide()
		_G[name.."FillBar"]:Hide()
		_G[name.."Title"]:SetTextColor(1, 1, 1)
		_G[name.."Title"]:SetPoint("LEFT", bar, "LEFT", 6, 0)
		_G[name.."Text"]:SetPoint("RIGHT", bar, "RIGHT", -5, 0)

		local bg = CreateFrame("Frame", nil, bar)
		bg:Point("TOPLEFT", -1, 1)
		bg:Point("BOTTOMRIGHT", 1, -1)
		bg:SetFrameLevel(bar:GetFrameLevel()-1)
		S:CreateBD(bg, .25)
	end

	for i = 1, 9 do
		local buttons = {_G["AchievementFrameComparisonContainerButton"..i.."Player"], _G["AchievementFrameComparisonContainerButton"..i.."Friend"]}

		for _, button in pairs(buttons) do
			button:DisableDrawLayer("BORDER")
			local bg = CreateFrame("Frame", nil, button)
			bg:Point("TOPLEFT", 2, -2)
			bg:Point("BOTTOMRIGHT", -2, 2)
			S:CreateBD(bg, 0)
		end

		local bd = _G["AchievementFrameComparisonContainerButton"..i.."PlayerBackground"]
		bd:SetTexture(R["media"].normal)
		bd:SetVertexColor(0, 0, 0, .25)

		local bd = _G["AchievementFrameComparisonContainerButton"..i.."FriendBackground"]
		bd:SetTexture(R["media"].normal)
		bd:SetVertexColor(0, 0, 0, .25)

		local text = _G["AchievementFrameComparisonContainerButton"..i.."PlayerDescription"]
		text:SetTextColor(.9, .9, .9)
		text.SetTextColor = R.dummy
		text:SetShadowOffset(1, -1)
		text.SetShadowOffset = R.dummy

		_G["AchievementFrameComparisonContainerButton"..i.."PlayerTitleBackground"]:Hide()
		_G["AchievementFrameComparisonContainerButton"..i.."PlayerGlow"]:Hide()
		_G["AchievementFrameComparisonContainerButton"..i.."PlayerIconOverlay"]:Hide()
		_G["AchievementFrameComparisonContainerButton"..i.."FriendTitleBackground"]:Hide()
		_G["AchievementFrameComparisonContainerButton"..i.."FriendGlow"]:Hide()
		_G["AchievementFrameComparisonContainerButton"..i.."FriendIconOverlay"]:Hide()

		local ic = _G["AchievementFrameComparisonContainerButton"..i.."PlayerIconTexture"]
		ic:SetTexCoord(.08, .92, .08, .92)
		S:CreateBG(ic)

		local ic = _G["AchievementFrameComparisonContainerButton"..i.."FriendIconTexture"]
		ic:SetTexCoord(.08, .92, .08, .92)
		S:CreateBG(ic)
	end

	S:ReskinClose(AchievementFrameCloseButton)
	S:ReskinScroll(AchievementFrameAchievementsContainerScrollBar)
	S:ReskinScroll(AchievementFrameStatsContainerScrollBar)
	S:ReskinScroll(AchievementFrameCategoriesContainerScrollBar)
	S:ReskinScroll(AchievementFrameComparisonContainerScrollBar)
	S:ReskinDropDown(AchievementFrameFilterDropDown)

	-- Search results

	for i = 1, 14 do
		select(i, AchievementFrame.searchResults:GetRegions()):Hide()
	end
	AchievementFrame.searchResults.titleText:Show()
	S:CreateBD(AchievementFrame.searchResults, .75)

	AchievementFrame.searchPreviewContainer.borderAnchor:Hide()
	AchievementFrame.searchPreviewContainer.botRightCorner:Hide()
	AchievementFrame.searchPreviewContainer.topBorder:Hide()
	AchievementFrame.searchPreviewContainer.bottomBorder:Hide()
	AchievementFrame.searchPreviewContainer.leftBorder:Hide()
	AchievementFrame.searchPreviewContainer.rightBorder:Hide()

	local function resultOnEnter(self)
		self.hl:Show()
	end

	local function resultOnLeave(self)
		self.hl:Hide()
	end

	local function styleSearchPreview(preview, index)
		if index == 1 then
			preview:SetPoint("TOPLEFT", AchievementFrame.searchBox, "BOTTOMLEFT", 0, 1)
			preview:SetPoint("TOPRIGHT", AchievementFrame.searchBox, "BOTTOMRIGHT", 80, 1)
		else
			preview:SetPoint("TOPLEFT", AchievementFrame.searchPreview[index - 1], "BOTTOMLEFT", 0, 1)
			preview:SetPoint("TOPRIGHT", AchievementFrame.searchPreview[index - 1], "BOTTOMRIGHT", 0, 1)
		end

		preview:SetNormalTexture("")
		preview:SetPushedTexture("")
		preview:SetHighlightTexture("")

		local hl = preview:CreateTexture(nil, "BACKGROUND")
		hl:SetAllPoints()
		hl:SetTexture(R["media"].normal)
		hl:SetVertexColor(r, g, b, .2)
		hl:Hide()
		preview.hl = hl

		S:CreateBD(preview)
		preview:SetBackdropColor(.1, .1, .1, .9)

		if preview.icon then
			preview:GetRegions():Hide() -- icon frame

			preview.icon:SetTexCoord(.08, .92, .08, .92)

			local bg = S:CreateBG(preview.icon)
			bg:SetDrawLayer("BACKGROUND", 1)
		end

		preview:HookScript("OnEnter", resultOnEnter)
		preview:HookScript("OnLeave", resultOnLeave)
	end

	for i = 1, 5 do
		styleSearchPreview(AchievementFrame.searchPreview[i], i)
	end

	styleSearchPreview(AchievementFrame.showAllSearchResults, 6)

	hooksecurefunc("AchievementFrame_UpdateFullSearchResults", function()
		local numResults = GetNumFilteredAchievements()

		local scrollFrame = AchievementFrame.searchResults.scrollFrame
		local offset = HybridScrollFrame_GetOffset(scrollFrame)
		local results = scrollFrame.buttons
		local result, index

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

	hooksecurefunc(AchievementFrame.searchResults.scrollFrame, "update", function(self)
		for i = 1, #self.buttons do
			local result = self.buttons[i]

			if result.icon:GetTexCoord() == 0 then
				result.icon:SetTexCoord(.08, .92, .08, .92)
			end
		end
	end)

	S:ReskinClose(AchievementFrame.searchResults.closeButton)
	S:ReskinScroll(AchievementFrameScrollFrameScrollBar)
end

S:AddCallbackForAddon("Blizzard_AchievementUI", "Achievement", LoadSkin)
