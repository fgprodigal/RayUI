local R, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local S = R:GetModule("Skins")

local function LoadSkin()
	local r, g, b = S["media"].classcolours[R.myclass].r, S["media"].classcolours[R.myclass].g, S["media"].classcolours[R.myclass].b
	-- [[ Shared functions ]]

	local function restyleFollowerPortrait(portrait)
		local level = portrait.Level
		local cover = portrait.PortraitRingCover

		portrait.PortraitRing:Hide()
		portrait.PortraitRingQuality:SetTexture("")

		portrait.LevelBorder:SetTexture(0, 0, 0, .5)
		portrait.LevelBorder:SetSize(44, 11)
		portrait.LevelBorder:ClearAllPoints()
		portrait.LevelBorder:SetPoint("BOTTOM", 0, 12)

		level:ClearAllPoints()
		level:SetPoint("BOTTOM", portrait, 0, 12)

		local squareBG = CreateFrame("Frame", nil, portrait)
		squareBG:SetFrameLevel(portrait:GetFrameLevel()-1)
		squareBG:SetPoint("TOPLEFT", 3, -3)
		squareBG:SetPoint("BOTTOMRIGHT", -3, 11)
		S:CreateBD(squareBG, 1)
		portrait.squareBG = squareBG

		cover:SetTexture(0, 0, 0)
		cover:SetAllPoints(squareBG)
	end

	-- [[ Capacitive display frame ]]

	local GarrisonCapacitiveDisplayFrame = GarrisonCapacitiveDisplayFrame

	S:ReskinPortraitFrame(GarrisonCapacitiveDisplayFrame, true)
	S:Reskin(GarrisonCapacitiveDisplayFrame.StartWorkOrderButton, true)

	-- Capacitive display

	local CapacitiveDisplay = GarrisonCapacitiveDisplayFrame.CapacitiveDisplay

	CapacitiveDisplay.IconBG:SetAlpha(0)

	do
		local icon = CapacitiveDisplay.ShipmentIconFrame.Icon

		icon:SetTexCoord(.08, .92, .08, .92)
		S:CreateBG(icon)
	end

	do
		local reagentIndex = 1

		hooksecurefunc("GarrisonCapacitiveDisplayFrame_Update", function(self)
			local reagents = CapacitiveDisplay.Reagents

			local reagent = reagents[reagentIndex]
			while reagent do
				reagent.NameFrame:SetAlpha(0)

				reagent.Icon:SetTexCoord(.08, .92, .08, .92)
				reagent.Icon:SetDrawLayer("BORDER")
				S:CreateBG(reagent.Icon)

				local bg = CreateFrame("Frame", nil, reagent)
				bg:SetPoint("TOPLEFT")
				bg:SetPoint("BOTTOMRIGHT", 0, 2)
				bg:SetFrameLevel(reagent:GetFrameLevel() - 1)
				S:CreateBD(bg, .25)

				reagentIndex = reagentIndex + 1
				reagent = reagents[reagentIndex]
			end
		end)
	end

	-- [[ Landing page ]]

	local GarrisonLandingPage = GarrisonLandingPage

	for i = 1, 10 do
		select(i, GarrisonLandingPage:GetRegions()):Hide()
	end

	S:CreateBD(GarrisonLandingPage)
	S:ReskinClose(GarrisonLandingPage.CloseButton)
	S:CreateTab(GarrisonLandingPageTab1)
	S:CreateTab(GarrisonLandingPageTab2)

	GarrisonLandingPageTab1:ClearAllPoints()
	GarrisonLandingPageTab1:SetPoint("TOPLEFT", GarrisonLandingPage, "BOTTOMLEFT", 70, 2)

	-- Report

	local Report = GarrisonLandingPage.Report

	Report.List:GetRegions():Hide()

	local scrollFrame = Report.List.listScroll

	S:ReskinScroll(scrollFrame.scrollBar)

	local buttons = scrollFrame.buttons
	for i = 1, #buttons do
		local button = buttons[i]

		button.BG:Hide()

		local bg = CreateFrame("Frame", nil, button)
		bg:SetPoint("TOPLEFT")
		bg:SetPoint("BOTTOMRIGHT", 0, 1)
		bg:SetFrameLevel(button:GetFrameLevel() - 1)

		for _, reward in pairs(button.Rewards) do
			reward:GetRegions():Hide()
			reward.Icon:SetTexCoord(.08, .92, .08, .92)
			S:CreateBG(reward.Icon)
		end

		S:CreateBD(bg, .25)
	end

	for _, tab in pairs({Report.InProgress, Report.Available}) do
		tab:SetHighlightTexture("")

		tab.Text:ClearAllPoints()
		tab.Text:SetPoint("CENTER")

		local bg = CreateFrame("Frame", nil, tab)
		bg:SetFrameLevel(tab:GetFrameLevel() - 1)
		S:CreateBD(bg, .25)

		local selectedTex = bg:CreateTexture(nil, "BACKGROUND")
		selectedTex:SetAllPoints()
		selectedTex:SetTexture(r, g, b, .2)
		selectedTex:Hide()
		tab.selectedTex = selectedTex

		if tab == Report.InProgress then
			bg:SetPoint("TOPLEFT", 5, 0)
			bg:SetPoint("BOTTOMRIGHT")
		else
			bg:SetPoint("TOPLEFT")
			bg:SetPoint("BOTTOMRIGHT", -7, 0)
		end
	end

	hooksecurefunc("GarrisonLandingPageReport_SetTab", function(self)
		local unselectedTab = Report.unselectedTab

		unselectedTab:SetHeight(36)

		unselectedTab:SetNormalTexture("")
		unselectedTab.selectedTex:Hide()
		self:SetNormalTexture("")
		self.selectedTex:Show()
	end)

	-- Follower list

	local FollowerList = GarrisonLandingPage.FollowerList

	select(2, FollowerList:GetRegions()):Hide()
	FollowerList.FollowerHeaderBar:Hide()

	S:ReskinInput(FollowerList.SearchBox)

	local scrollFrame = FollowerList.listScroll

	S:ReskinScroll(scrollFrame.scrollBar)

	local buttons = FollowerList.listScroll.buttons
	for i = 1, #buttons do
		local button = buttons[i]
		select(9,button:GetRegions()):Hide()
	end

	-- Follower tab

	local FollowerTab = GarrisonLandingPage.FollowerTab

	do
		local xpBar = FollowerTab.XPBar

		select(1, xpBar:GetRegions()):Hide()
		xpBar.XPLeft:Hide()
		xpBar.XPRight:Hide()
		select(4, xpBar:GetRegions()):Hide()

		xpBar:SetStatusBarTexture(R["media"].gloss)

		S:CreateBDFrame(xpBar)
	end

	-- [[ Mission UI ]]

	local GarrisonMissionFrame = GarrisonMissionFrame

	for i = 1, 18 do
		select(i, GarrisonMissionFrame:GetRegions()):Hide()
	end

	GarrisonMissionFrame.TitleText:Show()

	S:CreateBD(GarrisonMissionFrame)
	S:ReskinClose(GarrisonMissionFrame.CloseButton)
	S:CreateTab(GarrisonMissionFrameTab1)
	S:CreateTab(GarrisonMissionFrameTab2)

	GarrisonMissionFrameTab1:ClearAllPoints()
	GarrisonMissionFrameTab1:SetPoint("BOTTOMLEFT", 11, -40)

	do
		local f = CreateFrame("Frame")
		f:RegisterEvent("ADDON_LOADED")
		f:SetScript("OnEvent", function(self, event, addon)
			if addon == "MasterPlan" then
				S:CreateTab(GarrisonMissionFrameTab3)
				if GarrisonMissionFrameTab4 then
					S:CreateTab(GarrisonMissionFrameTab4)
				end
				self:UnregisterEvent("ADDON_LOADED")
			end
		end)
	end

	-- Follower list

	local FollowerList = GarrisonMissionFrame.FollowerList

	FollowerList:DisableDrawLayer("BORDER")
	FollowerList.MaterialFrame:GetRegions():Hide()

	S:ReskinInput(FollowerList.SearchBox)
	S:ReskinScroll(FollowerList.listScroll.scrollBar)

	local MissionTab = GarrisonMissionFrame.MissionTab

	-- Mission list

	local MissionList = MissionTab.MissionList

	MissionList:DisableDrawLayer("BORDER")

	S:ReskinScroll(MissionList.listScroll.scrollBar)

	for i = 1, 2 do
		local tab = _G["GarrisonMissionFrameMissionsTab"..i]

		tab.Left:Hide()
		tab.Middle:Hide()
		tab.Right:Hide()
		tab.SelectedLeft:SetTexture("")
		tab.SelectedMid:SetTexture("")
		tab.SelectedRight:SetTexture("")

		S:CreateBD(tab, .25)
	end

	GarrisonMissionFrameMissionsTab1:SetBackdropColor(r, g, b, .2)

	hooksecurefunc("GarrisonMissonListTab_SetSelected", function(tab, isSelected)
		if isSelected then
			tab:SetBackdropColor(r, g, b, .2)
		else
			tab:SetBackdropColor(0, 0, 0, .25)
		end
	end)

	do
		MissionList.MaterialFrame:GetRegions():Hide()
		local bg = S:CreateBDFrame(MissionList.MaterialFrame, .25)
		bg:SetPoint("TOPLEFT", 5, -5)
		bg:SetPoint("BOTTOMRIGHT", -5, 6)
	end

	S:Reskin(MissionList.CompleteDialog.BorderFrame.ViewButton)

	local buttons = MissionList.listScroll.buttons
	for i = 1, #buttons do
		local button = buttons[i]

		for i = 1, 12 do
			local rareOverlay = button.RareOverlay
			local rareText = button.RareText

			select(i, button:GetRegions()):Hide()

			S:CreateBD(button, .25)

			rareText:ClearAllPoints()
			rareText:SetPoint("BOTTOMLEFT", button, 20, 10)

			rareOverlay:SetDrawLayer("BACKGROUND")
			rareOverlay:SetTexture(R["media"].gloss)
			rareOverlay:ClearAllPoints()
			rareOverlay:SetAllPoints()
			rareOverlay:SetVertexColor(0.098, 0.537, 0.969, 0.2)
		end
	end

	hooksecurefunc("GarrisonMissionButton_SetRewards", function(self, rewards, numRewards)
		if self.numRewardsStyled == nil then
			self.numRewardsStyled = 0
		end

		while self.numRewardsStyled < numRewards do
			self.numRewardsStyled = self.numRewardsStyled + 1

			local reward = self.Rewards[self.numRewardsStyled]
			local icon = reward.Icon

			reward:GetRegions():Hide()

			reward.Icon:SetTexCoord(.08, .92, .08, .92)
			S:CreateBG(reward.Icon)
		end
	end)

	-- Mission page

	local MissionPage = MissionTab.MissionPage

	for i = 1, 11 do
		select(i, MissionPage:GetRegions()):Hide()
	end

	S:Reskin(MissionPage.StartMissionButton)
	S:ReskinClose(MissionPage.CloseButton)

	MissionPage.CloseButton:ClearAllPoints()
	MissionPage.CloseButton:SetPoint("TOPRIGHT", -10, -5)

	for i = 4, 8 do
		select(i, MissionPage.Stage:GetRegions()):Hide()
	end
	for i = 19, 21 do
		select(i, MissionPage.Stage:GetRegions()):Hide()
	end

	do
		local bg = CreateFrame("Frame", nil, MissionPage.Stage)
		bg:SetPoint("TOPLEFT", 4, 1)
		bg:SetPoint("BOTTOMRIGHT", -4, -1)
		bg:SetFrameLevel(MissionPage.Stage:GetFrameLevel() - 1)
		S:CreateBD(bg)

		local overlay = MissionPage.Stage:CreateTexture()
		overlay:SetDrawLayer("ARTWORK", 3)
		overlay:SetAllPoints(bg)
		overlay:SetTexture(0, 0, 0, .5)

		local iconbg = MissionPage.Stage.IconBG
		iconbg:ClearAllPoints()
		iconbg:SetPoint("TOPLEFT", 3, -1)
	end

	for i = 1, 3 do
		local follower = MissionPage.Followers[i]

		follower:GetRegions():Hide()

		S:CreateBD(follower, .25)
	end

	hooksecurefunc("GarrisonMissionPage_SetFollower", function(frame)
		local portrait = frame.PortraitFrame

		portrait.LevelBorder:SetTexture(0, 0, 0, .5)
		portrait.LevelBorder:SetSize(44, 11)
	end)

	hooksecurefunc("GarrisonMissionPage_ClearFollower", function(frame)
		local portrait = frame.PortraitFrame

		portrait.LevelBorder:SetTexture(0, 0, 0, .5)
		portrait.LevelBorder:SetSize(44, 11)

		if portrait.squareBG then portrait.squareBG:SetBackdropBorderColor(0, 0, 0) end
	end)

	for i = 1, 10 do
		select(i, MissionPage.RewardsFrame:GetRegions()):Hide()
	end

	S:CreateBD(MissionPage.RewardsFrame, .25)

	for i = 1, 2 do
		local reward = MissionPage.RewardsFrame.Rewards[i]
		local icon = reward.Icon

		reward.BG:Hide()

		icon:SetTexCoord(.08, .92, .08, .92)
		icon:SetDrawLayer("BORDER", 1)
		S:CreateBG(icon)

		reward.ItemBurst:SetDrawLayer("BORDER", 2)

		S:CreateBD(reward, .15)
	end

	-- Follower tab

	local FollowerTab = GarrisonMissionFrame.FollowerTab

	FollowerTab:DisableDrawLayer("BORDER")

	do
		local xpBar = FollowerTab.XPBar

		select(1, xpBar:GetRegions()):Hide()
		xpBar.XPLeft:Hide()
		xpBar.XPRight:Hide()
		select(4, xpBar:GetRegions()):Hide()

		xpBar:SetStatusBarTexture(R["media"].gloss)

		S:CreateBDFrame(xpBar)
	end

	for _, item in pairs({FollowerTab.ItemWeapon, FollowerTab.ItemArmor}) do
		local icon = item.Icon

		item.Border:Hide()

		icon:SetTexCoord(.08, .92, .08, .92)
		S:CreateBG(icon)

		local bg = S:CreateBDFrame(item, .25)
		bg:SetPoint("TOPLEFT", 41, -1)
		bg:SetPoint("BOTTOMRIGHT", 0, 1)
	end

	-- Portraits

	hooksecurefunc("GarrisonMissionFrame_SetFollowerPortrait", function(portraitFrame, followerInfo)
		if not portraitFrame.styled then
			restyleFollowerPortrait(portraitFrame)
			portraitFrame.styled = true
		end

		local color = ITEM_QUALITY_COLORS[followerInfo.quality]

		portraitFrame.squareBG:SetBackdropBorderColor(color.r, color.g, color.b)
	end)

	-- [[ Recruiter frame ]]

	local GarrisonRecruiterFrame = GarrisonRecruiterFrame

	for i = 18, 22 do
		select(i, GarrisonRecruiterFrame:GetRegions()):Hide()
	end

	S:ReskinPortraitFrame(GarrisonRecruiterFrame, true)

	-- Unavailable frame

	local UnavailableFrame = GarrisonRecruiterFrame.UnavailableFrame

	S:Reskin(UnavailableFrame:GetChildren())

	-- [[ Shared templates ]]

	hooksecurefunc("GarrisonFollowerList_Update", function(self)
		local followerFrame = self
		local followers = followerFrame.FollowerList.followers
		local followersList = followerFrame.FollowerList.followersList
		local numFollowers = #followersList
		local scrollFrame = followerFrame.FollowerList.listScroll
		local offset = HybridScrollFrame_GetOffset(scrollFrame)
		local buttons = scrollFrame.buttons
		local numButtons = #buttons

		for i = 1, #buttons do
			local button = buttons[i]
			local portrait = button.PortraitFrame

			if not button.restyled then
				button.BG:Hide()
				button.Selection:SetTexture("")
				button.AbilitiesBG:SetTexture("")

				S:CreateBD(button, .25)

				button.BusyFrame:SetAllPoints()

				if portrait then
					restyleFollowerPortrait(portrait)
					portrait:ClearAllPoints()
					portrait:SetPoint("TOPLEFT", 4, -1)
				end

				button.restyled = true
			end

			if button.Selection:IsShown() then
				button:SetBackdropColor(r, g, b, .2)
			else
				button:SetBackdropColor(0, 0, 0, .25)
			end

			if portrait then
				if portrait.PortraitRingQuality:IsShown() then
					portrait.squareBG:SetBackdropBorderColor(portrait.PortraitRingQuality:GetVertexColor())
				else
					portrait.squareBG:SetBackdropBorderColor(0, 0, 0)
				end
			end
			select(9,button:GetRegions()):Hide()
		end
	end)

	hooksecurefunc("GarrisonFollowerButton_AddAbility", function(self, index)
		local ability = self.Abilities[index]

		if not ability.styled then
			local icon = ability.Icon

			icon:SetSize(19, 19)
			icon:SetTexCoord(.08, .92, .08, .92)
			S:CreateBG(icon)

			ability.styled = true
		end
	end)

	hooksecurefunc("GarrisonFollowerPage_ShowFollower", function(self, followerID)
		local abilities = self.AbilitiesFrame.Abilities

		if self.numAbilitiesStyled == nil then
			self.numAbilitiesStyled = 1
		end

		local numAbilitiesStyled = self.numAbilitiesStyled

		local ability = abilities[numAbilitiesStyled]
		while ability do
			local icon = ability.IconButton.Icon

			icon:SetTexCoord(.08, .92, .08, .92)
			S:CreateBG(icon)

			numAbilitiesStyled = numAbilitiesStyled + 1
			ability = abilities[numAbilitiesStyled]
		end

		self.numAbilitiesStyled = numAbilitiesStyled
	end)
end

local function SkinTooltip()
	local function restyleGarrisonFollowerTooltipTemplate(frame)
		for i = 1, 9 do
			select(i, frame:GetRegions()):Hide()
		end

		S:CreateBD(frame)
	end

	local function restyleGarrisonFollowerAbilityTooltipTemplate(frame)
		for i = 1, 9 do
			select(i, frame:GetRegions()):Hide()
		end

		local icon = frame.Icon

		icon:SetTexCoord(.08, .92, .08, .92)
		S:CreateBG(icon)

		S:CreateBD(frame)
	end

	restyleGarrisonFollowerTooltipTemplate(GarrisonFollowerTooltip)
	restyleGarrisonFollowerAbilityTooltipTemplate(GarrisonFollowerAbilityTooltip)

	restyleGarrisonFollowerTooltipTemplate(FloatingGarrisonFollowerTooltip)
	S:ReskinClose(FloatingGarrisonFollowerTooltip.CloseButton)

	restyleGarrisonFollowerAbilityTooltipTemplate(FloatingGarrisonFollowerAbilityTooltip)
	S:ReskinClose(FloatingGarrisonFollowerAbilityTooltip.CloseButton)

	hooksecurefunc("GarrisonFollowerTooltipTemplate_SetGarrisonFollower", function(tooltipFrame)
		-- Abilities

		if tooltipFrame.numAbilitiesStyled == nil then
			tooltipFrame.numAbilitiesStyled = 1
		end

		local numAbilitiesStyled = tooltipFrame.numAbilitiesStyled

		local abilities = tooltipFrame.Abilities

		local ability = abilities[numAbilitiesStyled]
		while ability do
			local icon = ability.Icon

			icon:SetTexCoord(.08, .92, .08, .92)
			S:CreateBG(icon)

			numAbilitiesStyled = numAbilitiesStyled + 1
			ability = abilities[numAbilitiesStyled]
		end

		tooltipFrame.numAbilitiesStyled = numAbilitiesStyled

		-- Traits

		if tooltipFrame.numTraitsStyled == nil then
			tooltipFrame.numTraitsStyled = 1
		end

		local numTraitsStyled = tooltipFrame.numTraitsStyled

		local traits = tooltipFrame.Traits

		local trait = traits[numTraitsStyled]
		while trait do
			local icon = trait.Icon

			icon:SetTexCoord(.08, .92, .08, .92)
			S:CreateBG(icon)

			numTraitsStyled = numTraitsStyled + 1
			trait = traits[numTraitsStyled]
		end

		tooltipFrame.numTraitsStyled = numTraitsStyled
	end)
end

S:RegisterSkin("Blizzard_GarrisonUI", LoadSkin)
S:RegisterSkin("RayUI", SkinTooltip)
