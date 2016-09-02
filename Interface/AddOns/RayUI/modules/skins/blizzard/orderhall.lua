local R, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local S = R:GetModule("Skins")

local function LoadSkin()
	local classColor = S["media"].classcolours[R.myclass]

	-- CommandBar
	OrderHallCommandBar:StripTextures()
	OrderHallCommandBar:CreateShadow("Background")
	OrderHallCommandBar.ClassIcon:SetTexture("Interface\\TargetingFrame\\UI-Classes-Circles")
	OrderHallCommandBar.ClassIcon:SetSize(46, 20)
	OrderHallCommandBar.CurrencyIcon:SetAtlas("legionmission-icon-currency", false)
	OrderHallCommandBar.AreaName:SetVertexColor(classColor.r, classColor.g, classColor.b)
	OrderHallCommandBar:ClearAllPoints()
	OrderHallCommandBar:SetPoint("TOP")
	OrderHallCommandBar:SetWidth(350)
	--Dumb
	OrderHallCommandBar.WorldMapButton:Kill()
	-- OrderHallCommandBar.WorldMapButton:ClearAllPoints()
	-- OrderHallCommandBar.WorldMapButton:SetPoint("RIGHT", OrderHallCommandBar, -5, -2)

	-- MissionFrame
	OrderHallMissionFrame.ClassHallIcon:Kill()
	OrderHallMissionFrame:StripTextures()
	S:SetBD(OrderHallMissionFrame)

	S:ReskinClose(OrderHallMissionFrame.CloseButton)

	for i = 1, 3 do 
		S:CreateTab(_G["OrderHallMissionFrameTab" .. i])
	end

	OrderHallMissionFrameMissions:StripTextures()
	OrderHallMissionFrameMissionsListScrollFrame:StripTextures()
	OrderHallMissionFrame.MissionTab:StripTextures()

	S:ReskinScroll(OrderHallMissionFrameMissionsListScrollFrameScrollBar)
	S:Reskin(OrderHallMissionFrameMissions.CombatAllyUI.InProgress.Unassign)
	S:ReskinClose(OrderHallMissionFrame.MissionTab.ZoneSupportMissionPage.CloseButton)
	S:Reskin(OrderHallMissionFrame.MissionTab.ZoneSupportMissionPage.StartMissionButton)

	for i, v in ipairs(OrderHallMissionFrame.MissionTab.MissionList.listScroll.buttons) do
		local Button = _G["OrderHallMissionFrameMissionsListScrollFrameButton" .. i]
		if Button and not Button.skinned then
			Button:StripTextures()
			Button:SetTemplate()
			S:Reskin(Button)
			Button:SetBackdropBorderColor(0, 0, 0, 0)
			Button.LocBG:Hide()
			for i = 1, #Button.Rewards do
				local Texture = Button.Rewards[i].Icon:GetTexture()

				Button.Rewards[i]:StripTextures()
				-- S:Reskin(Button.Rewards[i])
				-- Button.Rewards[i]:CreateBackdrop()
				Button.Rewards[i].Icon:SetTexture(Texture)
				-- Button.Rewards[i].backdrop:ClearAllPoints()
				-- Button.Rewards[i].backdrop:SetOutside(Button.Rewards[i].Icon)
				Button.Rewards[i].Icon:SetTexCoord(.08, .92, .08, .92)
			end
			Button.isSkinned = true
		end
	end

	-- Mission Tab
	local follower = OrderHallMissionFrameFollowers
	follower:StripTextures()
	follower.MaterialFrame:StripTextures()

	S:ReskinInput(follower.SearchBox)
	S:ReskinClose(OrderHallMissionFrame.MissionTab.MissionPage.CloseButton)
	S:Reskin(OrderHallMissionFrame.MissionTab.MissionPage.StartMissionButton)
	S:ReskinScroll(OrderHallMissionFrameFollowersListScrollFrameScrollBar)

	-- Follower Tab
	local followerList = OrderHallMissionFrame.FollowerTab
	followerList:StripTextures()
	followerList.ModelCluster:StripTextures()
	followerList.Class:SetSize(50, 43)
	followerList.XPBar:StripTextures()
	followerList.XPBar:SetStatusBarTexture(R["media"].gloss)
	-- followerList.XPBar:CreateBackdrop()

	-- Mission Stage
	local mission = OrderHallMissionFrameMissions
	mission.CompleteDialog:StripTextures()
	mission.CompleteDialog:CreateShadow("Background")

	S:Reskin(mission.CompleteDialog.BorderFrame.ViewButton)
	S:Reskin(OrderHallMissionFrame.MissionComplete.NextMissionButton)

	-- TalentFrame
	OrderHallTalentFrame:StripTextures()
	OrderHallTalentFrame:CreateShadow("Background")
	ClassHallTalentInset:StripTextures()
	OrderHallTalentFrame.CurrencyIcon:SetAtlas("legionmission-icon-currency", false)

	S:ReskinClose(OrderHallTalentFrameCloseButton)

	-- Needs Review
	-- Scouting Map Quest Choise
	AdventureMapQuestChoiceDialog:StripTextures()
	AdventureMapQuestChoiceDialog:CreateShadow("Background")

	-- Quick Fix for the Font Color
	AdventureMapQuestChoiceDialog.Details.Child.TitleHeader:SetTextColor(1, 1, 0)
	AdventureMapQuestChoiceDialog.Details.Child.DescriptionText:SetTextColor(1, 1, 1)

	AdventureMapQuestChoiceDialog.Details.Child.ObjectivesHeader:SetTextColor(1, 1, 0)
	AdventureMapQuestChoiceDialog.Details.Child.ObjectivesText:SetTextColor(1, 1, 1)

	S:ReskinClose(AdventureMapQuestChoiceDialog.CloseButton)
	S:ReskinScroll(AdventureMapQuestChoiceDialog.Details.ScrollBar)
	S:Reskin(AdventureMapQuestChoiceDialog.AcceptButton)
	S:Reskin(AdventureMapQuestChoiceDialog.DeclineButton)
end

S:RegisterSkin("Blizzard_OrderHallUI", LoadSkin)
