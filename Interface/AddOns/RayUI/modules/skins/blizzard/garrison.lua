local R, L, P, G = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, GlobalDB
local S = R:GetModule("Skins")

local function LoadSkin()
	local r, g, b = S["media"].classcolours[R.myclass].r, S["media"].classcolours[R.myclass].g, S["media"].classcolours[R.myclass].b

	-- [[ Shared functions ]]

	local function restyleFollowerPortrait(portrait)
		local level = portrait.Level
		local cover = portrait.PortraitRingCover

		portrait.PortraitRing:Hide()
		portrait.PortraitRingQuality:SetTexture("")

		portrait.LevelBorder:SetColorTexture(0, 0, 0, .5)
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

		cover:SetColorTexture(0, 0, 0)
		cover:SetAllPoints(squareBG)
	end

	-- [[ Capacitive display frame ]]

	local GarrisonCapacitiveDisplayFrame = GarrisonCapacitiveDisplayFrame

	GarrisonCapacitiveDisplayFrame:SetFrameStrata("MEDIUM")
	GarrisonCapacitiveDisplayFrame:SetFrameLevel(45)

	S:ReskinPortraitFrame(GarrisonCapacitiveDisplayFrame, true)
	S:Reskin(GarrisonCapacitiveDisplayFrame.StartWorkOrderButton, true)
	S:Reskin(GarrisonCapacitiveDisplayFrame.CreateAllWorkOrdersButton, true)
	GarrisonCapacitiveDisplayFrame.Count:StripTextures()
	S:ReskinInput(GarrisonCapacitiveDisplayFrame.Count)
	S:ReskinArrow(GarrisonCapacitiveDisplayFrame.DecrementButton, "left")
	S:ReskinArrow(GarrisonCapacitiveDisplayFrame.IncrementButton, "right")

	-- Capacitive display

	local CapacitiveDisplay = GarrisonCapacitiveDisplayFrame.CapacitiveDisplay

	CapacitiveDisplay.IconBG:SetAlpha(0)

	do
		local icon = CapacitiveDisplay.ShipmentIconFrame.Icon

		S:ReskinIcon(icon)
	end

	do
		local reagentIndex = 1

		hooksecurefunc("GarrisonCapacitiveDisplayFrame_Update", function(self)
			local reagents = CapacitiveDisplay.Reagents

			local reagent = reagents[reagentIndex]
			while reagent do
				reagent.NameFrame:SetAlpha(0)

				reagent.Icon:SetDrawLayer("BORDER")
				S:ReskinIcon(reagent.Icon)

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
	S:CreateTab(GarrisonLandingPageTab3)

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
			reward.IconBorder:Kill()
			S:ReskinIcon(reward.Icon)
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
		selectedTex:SetColorTexture(r, g, b, .2)
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
	FollowerList:GetRegions():Hide()

	S:ReskinInput(FollowerList.SearchBox)

	local scrollFrame = FollowerList.listScroll

	S:ReskinScroll(scrollFrame.scrollBar)

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

	-- Ship Follower list

	local FollowerList = GarrisonLandingPage.ShipFollowerList

	select(2, FollowerList:GetRegions()):Hide()
	FollowerList:GetRegions():Hide()

	S:ReskinInput(FollowerList.SearchBox)

	local scrollFrame = FollowerList.listScroll

	S:ReskinScroll(scrollFrame.scrollBar)

	-- Ship Follower tab

	local FollowerTab = GarrisonLandingPage.ShipFollowerTab

	do
		local xpBar = FollowerTab.XPBar

		select(1, xpBar:GetRegions()):Hide()
		xpBar.XPLeft:Hide()
		xpBar.XPRight:Hide()
		select(4, xpBar:GetRegions()):Hide()

		xpBar:SetStatusBarTexture(R["media"].gloss)

		S:CreateBDFrame(xpBar)
	end

	for i = 1, 2 do
		local trait = FollowerTab.Traits[i]

		trait.Border:Hide()
		S:ReskinIcon(trait.Portrait)

		local equipment = FollowerTab.EquipmentFrame.Equipment[i]

		equipment.BG:Hide()
		equipment.Border:Hide()

		S:ReskinIcon(equipment.Icon)
	end

	-- [[ Mission UI ]]

	local GarrisonMissionFrame = GarrisonMissionFrame

	for i = 1, 14 do
		select(i, GarrisonMissionFrame:GetRegions()):Hide()
	end

	GarrisonMissionFrame.GarrCorners:StripTextures()
	GarrisonMissionFrame.TitleText:Show()

	S:CreateBD(GarrisonMissionFrame)
	S:ReskinClose(GarrisonMissionFrame.CloseButton)
	S:CreateTab(GarrisonMissionFrameTab1)
	S:CreateTab(GarrisonMissionFrameTab2)

	GarrisonMissionFrameTab1:ClearAllPoints()
	GarrisonMissionFrameTab1:SetPoint("BOTTOMLEFT", 11, -40)

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

			reward.IconBorder:Kill()
			S:ReskinIcon(icon)
		end
	end)

	-- Mission page

	local MissionPage = MissionTab.MissionPage

	for i = 1, 15 do
		select(i, MissionPage:GetRegions()):Hide()
	end
	for i = 18, 20 do
		select(i, MissionPage:GetRegions()):Hide()
	end
	for i = 4, 8 do
		select(i, MissionPage.Stage:GetRegions()):Hide()
	end

	S:Reskin(MissionPage.StartMissionButton)

	S:ReskinClose(MissionPage.CloseButton)
	MissionPage.CloseButton:ClearAllPoints()
	MissionPage.CloseButton:SetPoint("TOPRIGHT", -10, -5)

	do
		local bg = CreateFrame("Frame", nil, MissionPage.Stage)
		bg:SetPoint("TOPLEFT", 4, 1)
		bg:SetPoint("BOTTOMRIGHT", -4, -1)
		bg:SetFrameLevel(MissionPage.Stage:GetFrameLevel() - 1)
		S:CreateBD(bg)

		local overlay = MissionPage.Stage:CreateTexture()
		overlay:SetDrawLayer("ARTWORK", 3)
		overlay:SetAllPoints(bg)
		overlay:SetColorTexture(0, 0, 0, .5)

		local iconbg = select(16, MissionPage:GetRegions())
		iconbg:ClearAllPoints()
		iconbg:SetPoint("TOPLEFT", 3, -1)
	end

	for i = 1, 3 do
		local follower = MissionPage.Followers[i]

		follower:GetRegions():Hide()

		S:CreateBD(follower, .25)
	end

	local function onAssignFollowerToMission(self, frame)
		local portrait = frame.PortraitFrame

		portrait.LevelBorder:SetColorTexture(0, 0, 0, .5)
		portrait.LevelBorder:SetSize(44, 11)
	end

	local function onRemoveFollowerFromMission(self, frame)
		local portrait = frame.PortraitFrame

		portrait.LevelBorder:SetColorTexture(0, 0, 0, .5)
		portrait.LevelBorder:SetSize(44, 11)

		if portrait.squareBG then portrait.squareBG:SetBackdropBorderColor(0, 0, 0) end
	end

	hooksecurefunc(GarrisonMissionFrame, "AssignFollowerToMission", onAssignFollowerToMission)
	hooksecurefunc(GarrisonMissionFrame, "RemoveFollowerFromMission", onRemoveFollowerFromMission)

	for i = 1, 10 do
		select(i, MissionPage.RewardsFrame:GetRegions()):Hide()
	end

	S:CreateBD(MissionPage.RewardsFrame, .25)

	for i = 1, 2 do
		local reward = MissionPage.RewardsFrame.Rewards[i]
		local icon = reward.Icon

		reward.BG:Hide()

		icon:SetDrawLayer("BORDER", 1)
		S:ReskinIcon(icon)

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

		S:ReskinIcon(icon)

		local bg = S:CreateBDFrame(item, .25)
		bg:SetPoint("TOPLEFT", 41, -1)
		bg:SetPoint("BOTTOMRIGHT", 0, 1)
	end

	-- Mechanic tooltip

	GarrisonMissionMechanicTooltip:SetBackdrop(nil)
	GarrisonMissionMechanicFollowerCounterTooltip:SetBackdrop(nil)
	S:CreateBDFrame(GarrisonMissionMechanicTooltip, .6)
	S:CreateBDFrame(GarrisonMissionMechanicFollowerCounterTooltip, .6)

	-- [[ Recruiter frame ]]

	local GarrisonRecruiterFrame = GarrisonRecruiterFrame

	for i = 18, 22 do
		select(i, GarrisonRecruiterFrame:GetRegions()):Hide()
	end

	S:ReskinPortraitFrame(GarrisonRecruiterFrame, true)

	-- Pick

	local Pick = GarrisonRecruiterFrame.Pick

	S:Reskin(Pick.ChooseRecruits)
	S:ReskinDropDown(Pick.ThreatDropDown)

	-- Unavailable frame

	local UnavailableFrame = GarrisonRecruiterFrame.UnavailableFrame

	S:Reskin(UnavailableFrame:GetChildren())

	-- [[ Recruiter select frame ]]
	
	local GarrisonRecruitSelectFrame = GarrisonRecruitSelectFrame
	
	for i = 1, 14 do
		select(i, GarrisonRecruitSelectFrame:GetRegions()):Hide()
	end
	GarrisonRecruitSelectFrame.TitleText:Show()
	
	S:CreateBD(GarrisonRecruitSelectFrame)
	S:ReskinClose(GarrisonRecruitSelectFrame.CloseButton)
	
	-- Follower list
	
	local FollowerList = GarrisonRecruitSelectFrame.FollowerList
	
	FollowerList:DisableDrawLayer("BORDER")
	
	S:ReskinScroll(FollowerList.listScroll.scrollBar)
	S:ReskinInput(FollowerList.SearchBox)

	local scrollFrame = FollowerList.listScroll

	S:ReskinScroll(scrollFrame.scrollBar)
	
	-- Follower selection
	
	local FollowerSelection = GarrisonRecruitSelectFrame.FollowerSelection
	
	FollowerSelection:DisableDrawLayer("BORDER")
	FollowerSelection:DisableDrawLayer("MEDIUM")

	for i = 1, 3 do
		local recruit = FollowerSelection["Recruit"..i]

		restyleFollowerPortrait(recruit.PortraitFrame)

		S:Reskin(recruit.HireRecruits)
	end

	hooksecurefunc("GarrisonRecruitSelectFrame_UpdateRecruits", function(waiting)
		if waiting then return end

		for i = 1, 3 do
			local recruit = FollowerSelection["Recruit"..i]
			local portrait = recruit.PortraitFrame

			portrait.squareBG:SetBackdropBorderColor(portrait.LevelBorder:GetVertexColor())

		end
	end)

	-- [[ Building frame ]]
 
	local GarrisonBuildingFrame = GarrisonBuildingFrame
 
	for i = 1, 14 do
		select(i, GarrisonBuildingFrame:GetRegions()):Hide()
	end
	GarrisonBuildingFrame.GarrCorners:Hide()
	
	GarrisonBuildingFrame.TitleText:Show()
	S:CreateBD(GarrisonBuildingFrame)
	S:ReskinClose(GarrisonBuildingFrame.CloseButton)
	
	-- Tutorial button
	
	local MainHelpButton = GarrisonBuildingFrame.MainHelpButton
	
	MainHelpButton.Ring:Hide()
	MainHelpButton:SetPoint("TOPLEFT", GarrisonBuildingFrame, "TOPLEFT", -12, 12)

	-- Building list
	
	local BuildingList = GarrisonBuildingFrame.BuildingList
	
	BuildingList:DisableDrawLayer("BORDER")
	
	BuildingList.MaterialFrame:GetRegions():Hide()
	
	for i = 1, GARRISON_NUM_BUILDING_SIZES do
		local tab = BuildingList["Tab"..i]
		
		tab:GetNormalTexture():SetAlpha(0)
		
		local bg = CreateFrame("Frame", nil, tab)
		bg:SetPoint("TOPLEFT", 6, -7)
		bg:SetPoint("BOTTOMRIGHT", -6, 7)
		bg:SetFrameLevel(tab:GetFrameLevel()-1)
		S:CreateBD(bg, .25)
		tab.bg = bg
		
		local hl = tab:GetHighlightTexture()
		hl:SetColorTexture(r, g, b, .1)
		hl:ClearAllPoints()
		hl:SetPoint("TOPLEFT", bg, 1, -1)
		hl:SetPoint("BOTTOMRIGHT", bg, -1, 1)
	end
	
	hooksecurefunc("GarrisonBuildingList_SelectTab", function(tab)
		local list = GarrisonBuildingFrame.BuildingList
		
		for i = 1, GARRISON_NUM_BUILDING_SIZES do
			local otherTab = list["Tab"..i]
			if i ~= tab:GetID() then
				otherTab.bg:SetBackdropColor(0, 0, 0, .25)
			end
		end
		tab.bg:SetBackdropColor(r, g, b, .2)
	
		for _, button in pairs(list.Buttons) do
			if not button.styled then
				button.BG:Hide()
			
				S:ReskinIcon(button.Icon)
			
				local bg = CreateFrame("Frame", nil, button)
				bg:SetPoint("TOPLEFT", 44, -5)
				bg:SetPoint("BOTTOMRIGHT", 0, 6)
				bg:SetFrameLevel(button:GetFrameLevel()-1)
				S:CreateBD(bg, .25)
			
				button.SelectedBG:SetColorTexture(r, g, b, .2)
				button.SelectedBG:ClearAllPoints()
				button.SelectedBG:SetPoint("TOPLEFT", bg, 1, -1)
				button.SelectedBG:SetPoint("BOTTOMRIGHT", bg, -1, 1)
			
				local hl = button:GetHighlightTexture()
				hl:SetColorTexture(r, g, b, .1)
				hl:ClearAllPoints()
				hl:SetPoint("TOPLEFT", bg, 1, -1)
				hl:SetPoint("BOTTOMRIGHT", bg, -1, 1)
			
				button.styled = true
			end
		end
	end)

	-- Building tooltip
	
	local BuildingLevelTooltip = GarrisonBuildingFrame.BuildingLevelTooltip
	
	for i = 1, 9 do
		select(i, BuildingLevelTooltip:GetRegions()):Hide()
		S:CreateBD(BuildingLevelTooltip)
	end

	-- Info box
	
	local InfoBox = GarrisonBuildingFrame.InfoBox
	local TownHallBox = GarrisonBuildingFrame.TownHallBox
	
	for i = 1, 25 do
		select(i, InfoBox:GetRegions()):Hide()
		select(i, TownHallBox:GetRegions()):Hide()
	end

	S:CreateBD(InfoBox, .25)
	S:CreateBD(TownHallBox, .25)
	S:Reskin(InfoBox.UpgradeButton)
	S:Reskin(TownHallBox.UpgradeButton)

	do
		local FollowerPortrait = InfoBox.FollowerPortrait
		
		restyleFollowerPortrait(FollowerPortrait)
		
		FollowerPortrait:SetPoint("BOTTOMLEFT", 230, 10)
		FollowerPortrait.RemoveFollowerButton:ClearAllPoints()
		FollowerPortrait.RemoveFollowerButton:SetPoint("TOPRIGHT", 4, 4)
	end
	
	hooksecurefunc("GarrisonBuildingInfoBox_ShowFollowerPortrait", function(_, _, infoBox)
		local portrait = infoBox.FollowerPortrait
		
		if portrait:IsShown() then
			portrait.squareBG:SetBackdropBorderColor(portrait.PortraitRing:GetVertexColor())
		end
	end)

	-- Follower list
	
	local FollowerList = GarrisonBuildingFrame.FollowerList
	
	FollowerList:DisableDrawLayer("BACKGROUND")
	FollowerList:DisableDrawLayer("BORDER")
	S:ReskinScroll(FollowerList.listScroll.scrollBar)
	
	FollowerList:ClearAllPoints()
	FollowerList:SetPoint("BOTTOMLEFT", 24, 34)

	local scrollFrame = FollowerList.listScroll

	S:ReskinScroll(scrollFrame.scrollBar)

	-- Confirmation popup
	
	local Confirmation = GarrisonBuildingFrame.Confirmation
	
	Confirmation:GetRegions():Hide()
	
	S:CreateBD(Confirmation)
	
	S:Reskin(Confirmation.CancelButton)
	S:Reskin(Confirmation.BuildButton)
	S:Reskin(Confirmation.UpgradeButton)
	S:Reskin(Confirmation.UpgradeGarrisonButton)
	S:Reskin(Confirmation.ReplaceButton)
	S:Reskin(Confirmation.SwitchButton)

	-- [[ Monuments ]]

	local GarrisonMonumentFrame = GarrisonMonumentFrame

	GarrisonMonumentFrame.Background:Hide()
	S:SetBD(GarrisonMonumentFrame, 6, -10, -6, 4)

	do
		local left = GarrisonMonumentFrame.LeftBtn
		local right = GarrisonMonumentFrame.RightBtn

		left.Texture:Hide()
		right.Texture:Hide()

		S:ReskinArrow(left, "left")
		S:ReskinArrow(right, "right")
		left:SetSize(35, 35)
		right:SetSize(35, 35)
	end

	-- [[ Shipyard UI ]]

	local GarrisonShipyardFrame = GarrisonShipyardFrame

	GarrisonShipyardFrame:StripTextures(true)
	GarrisonShipyardFrame.BorderFrame:StripTextures(true)
	GarrisonShipyardFrame.BorderFrame.GarrCorners:Hide()
	
	S:CreateBD(GarrisonShipyardFrame)

	S:ReskinClose(GarrisonShipyardFrame.BorderFrame.CloseButton2)
	S:CreateTab(GarrisonShipyardFrameTab1)
	S:CreateTab(GarrisonShipyardFrameTab2)

	-- Shipyard Map Mission Tooltip
	
	S:CreateBD(GarrisonShipyardMapMissionTooltip)

	-- Ship Follower list

	local FollowerList = GarrisonShipyardFrame.FollowerList

	FollowerList:DisableDrawLayer("BORDER")
	FollowerList.MaterialFrame:GetRegions():Hide()

	S:ReskinInput(FollowerList.SearchBox)
	S:ReskinScroll(FollowerList.listScroll.scrollBar)

	local MissionTab = GarrisonShipyardFrame.MissionTab
	
	-- Ship Follower tab

	local FollowerTab = GarrisonShipyardFrame.FollowerTab

	for i = 1, 22 do
		select(i, FollowerTab:GetRegions()):Hide()
	end

	do
		local xpBar = FollowerTab.XPBar

		select(1, xpBar:GetRegions()):Hide()
		xpBar.XPLeft:Hide()
		xpBar.XPRight:Hide()
		select(4, xpBar:GetRegions()):Hide()

		xpBar:SetStatusBarTexture(R["media"].gloss)

		S:CreateBDFrame(xpBar)
	end

	for i = 1, 2 do
		local trait = FollowerTab.Traits[i]

		trait.Border:Hide()
		S:ReskinIcon(trait.Portrait)

		local equipment = FollowerTab.EquipmentFrame.Equipment[i]

		equipment.BG:Hide()
		equipment.Border:Hide()

		S:ReskinIcon(equipment.Icon)
	end

	-- Mission page

	local MissionPage = MissionTab.MissionPage

	for i = 1, 15 do
		select(i, MissionPage:GetRegions()):Hide()
	end
	for i = 18, 20 do
		select(i, MissionPage:GetRegions()):Hide()
	end
	for i = 4, 8 do
		select(i, MissionPage.Stage:GetRegions()):Hide()
	end

	S:Reskin(MissionPage.StartMissionButton)
	S:ReskinClose(MissionPage.CloseButton)
	MissionPage.CloseButton:ClearAllPoints()
	MissionPage.CloseButton:SetPoint("TOPRIGHT", -10, -5)

	do
		local bg = CreateFrame("Frame", nil, MissionPage.Stage)
		bg:SetPoint("TOPLEFT", 4, 1)
		bg:SetPoint("BOTTOMRIGHT", -4, -1)
		bg:SetFrameLevel(MissionPage.Stage:GetFrameLevel() - 1)
		S:CreateBD(bg)

		local overlay = MissionPage.Stage:CreateTexture()
		overlay:SetDrawLayer("ARTWORK", 3)
		overlay:SetAllPoints(bg)
		overlay:SetColorTexture(0, 0, 0, .5)

		local iconbg = select(16, MissionPage:GetRegions())
		iconbg:ClearAllPoints()
		iconbg:SetPoint("TOPLEFT", 3, -1)
	end

	for i = 1, 10 do
		select(i, MissionPage.RewardsFrame:GetRegions()):Hide()
	end

	S:CreateBD(MissionPage.RewardsFrame, .25)

	for i = 1, 2 do
		local reward = MissionPage.RewardsFrame.Rewards[i]
		local icon = reward.Icon

		reward.BG:Hide()

		icon:SetDrawLayer("BORDER", 1)
		S:ReskinIcon(icon)

		reward.ItemBurst:SetDrawLayer("BORDER", 2)

		S:CreateBD(reward, .15)
	end

	-- [[ Shared templates ]]

	local function onUpdateData(self)
		local followerFrame = self:GetParent()
		local followers = followerFrame.FollowerList.followers
		local followersList = followerFrame.FollowerList.followersList
		local scrollFrame = followerFrame.FollowerList.listScroll
		--
		if GarrisonLandingPage.ShipFollowerTab:IsVisible() then
			scrollFrame = followerFrame.ShipFollowerList.listScroll
		end
		--
		local buttons = scrollFrame.buttons
		local numFollowers = #followersList
		local offset = HybridScrollFrame_GetOffset(scrollFrame)
		local numButtons = #buttons

		for i = 1, #buttons do
			local button = buttons[i]
			local portrait = button.PortraitFrame

			if not button.restyled then
				S:CreateBD(button, .25)

				if portrait then
					restyleFollowerPortrait(portrait)
					portrait:ClearAllPoints()
					portrait:SetPoint("TOPLEFT", 4, -1)
				end

				button.restyled = true
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
	end

	hooksecurefunc(GarrisonMissionFrameFollowers, "UpdateData", onUpdateData)
	hooksecurefunc(GarrisonShipyardFrameFollowers, "UpdateData", onUpdateData)
	hooksecurefunc(GarrisonBuildingFrameFollowers, "UpdateData", onUpdateData)
	hooksecurefunc(GarrisonRecruitSelectFrame.FollowerList, "UpdateData", onUpdateData)
	hooksecurefunc(GarrisonLandingPageFollowerList, "UpdateData", onUpdateData)
	hooksecurefunc(GarrisonLandingPageShipFollowerList, "UpdateData", onUpdateData)

	hooksecurefunc("GarrisonFollowerButton_AddAbility", function(self, index)
		local ability = self.Abilities[index]

		if not ability.styled then
			local icon = ability.Icon

			icon:SetSize(19, 19)
			S:ReskinIcon(icon)

			ability.styled = true
		end
	end)

	local function onShowFollower(self, followerId)
		local followerList = self
		local self = self.followerTab

		local abilities = self.AbilitiesFrame.Abilities

		if self.numAbilitiesStyled == nil then
			self.numAbilitiesStyled = 1
		end

		local numAbilitiesStyled = self.numAbilitiesStyled

		local ability = abilities[numAbilitiesStyled]
		while ability do
			local icon = ability.IconButton.Icon

			icon:SetDrawLayer("BACKGROUND", 1)
			S:ReskinIcon(icon)

			numAbilitiesStyled = numAbilitiesStyled + 1
			ability = abilities[numAbilitiesStyled]
		end

		self.numAbilitiesStyled = numAbilitiesStyled
	end

	hooksecurefunc(GarrisonMissionFrame.FollowerList, "ShowFollower", onShowFollower)
	hooksecurefunc(GarrisonLandingPageFollowerList, "ShowFollower", onShowFollower)

	-- [[ Master plan support ]]
	do
		local f = CreateFrame("Frame")
		f:RegisterEvent("ADDON_LOADED")
		f:SetScript("OnEvent", function(self, event, addon)
			if addon == "MasterPlan" then
				GarrisonMissionFrameTab3.Pulse:Stop()
				GarrisonMissionFrameTab3.Pulse = GarrisonMissionFrameTab3:CreateAnimationGroup()
				GarrisonMissionFrameTab3:StripTextures()
				S:CreateTab(GarrisonMissionFrameTab3)
				if GarrisonMissionFrameTab4 then
					S:CreateTab(GarrisonMissionFrameTab4)
				end

				local cb = GarrisonMissionFrame.MissionTab.MissionPage.CloseButton
				S:ReskinClose(cb)
				cb:Point("TOPRIGHT", -14, -4)

				S:CreateTab(GarrisonShipyardFrameTab3)
				S:CreateTab(GarrisonLandingPageTab4)

				self:UnregisterEvent("ADDON_LOADED")
			end
		end)
	end

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

		S:ReskinIcon(icon)

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

			S:ReskinIcon(icon)

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

			S:ReskinIcon(icon)

			numTraitsStyled = numTraitsStyled + 1
			trait = traits[numTraitsStyled]
		end

		tooltipFrame.numTraitsStyled = numTraitsStyled
	end)
end

S:AddCallbackForAddon("Blizzard_GarrisonUI", "Garrison", LoadSkin)
S:AddCallback("GarrisonTooltip", SkinTooltip)
