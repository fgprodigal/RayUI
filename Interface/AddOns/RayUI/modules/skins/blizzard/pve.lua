local R, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local S = R:GetModule("Skins")

local function LoadSkin()
	local r, g, b = S["media"].classcolours[R.myclass].r, S["media"].classcolours[R.myclass].g, S["media"].classcolours[R.myclass].b
	PVEFrame:DisableDrawLayer("ARTWORK")
	PVEFrameLeftInset:DisableDrawLayer("BORDER")
	PVEFrameBlueBg:Hide()
	PVEFrameLeftInsetBg:Hide()
	PVEFrame.shadows:Hide()
	select(24, PVEFrame:GetRegions()):Hide()
	select(25, PVEFrame:GetRegions()):Hide()

	PVEFrameTab2:SetPoint("LEFT", PVEFrameTab1, "RIGHT", -15, 0)
	PVEFrameTab3:SetPoint("LEFT", PVEFrameTab2, "RIGHT", -15, 0)

	GroupFinderFrameGroupButton1.icon:SetTexture("Interface\\Icons\\INV_Helmet_08")
	GroupFinderFrameGroupButton2.icon:SetTexture("Interface\\Icons\\inv_helmet_06")
	GroupFinderFrameGroupButton3.icon:SetTexture("Interface\\Icons\\Icon_Scenarios")

	local function onEnter(self)
		self:SetBackdropColor(r, g, b, .4)
	end

	local function onLeave(self)
		self:SetBackdropColor(0, 0, 0, 0)
	end

	for i = 1, 4 do
		local bu = GroupFinderFrame["groupButton"..i]

		bu.ring:Hide()
		bu.bg:SetTexture(R["media"].gloss)
		bu.bg:SetVertexColor(r, g, b, .2)
		bu.bg:SetAllPoints()


		S:Reskin(bu, true)
		bu:SetScript("OnEnter", onEnter)
		bu:SetScript("OnLeave", onLeave)

		bu.icon:SetTexCoord(.08, .92, .08, .92)
		bu.icon:SetPoint("LEFT", bu, "LEFT")
		bu.icon:SetDrawLayer("OVERLAY")
		bu.icon.bg = S:CreateBG(bu.icon)
		bu.icon.bg:SetDrawLayer("ARTWORK")
	end

	hooksecurefunc("GroupFinderFrame_SelectGroupButton", function(index)
		local self = GroupFinderFrame
		for i = 1, 4 do
			local button = self["groupButton"..i]
			if i == index then
				button.bg:Show()
			else
				button.bg:Hide()
			end
		end
	end)

	S:ReskinPortraitFrame(PVEFrame)
	S:CreateTab(PVEFrameTab1)
	S:CreateTab(PVEFrameTab2)
	S:CreateTab(PVEFrameTab3)

	S:Reskin(LFDQueueFrameFindGroupButton)
	S:Reskin(LFDQueueFrameCancelButton)
	S:Reskin(LFDRoleCheckPopupAcceptButton)
	S:Reskin(LFDRoleCheckPopupDeclineButton)
	S:Reskin(LFDQueueFramePartyBackfillBackfillButton)
	S:Reskin(RaidFinderQueueFramePartyBackfillBackfillButton)
	S:Reskin(LFDQueueFramePartyBackfillNoBackfillButton)
	S:Reskin(LFDQueueFrameRandomScrollFrameChildFrameBonusRepFrame.ChooseButton)
	S:Reskin(ScenarioQueueFrameRandomScrollFrameChildFrameBonusRepFrame.ChooseButton)
	S:Reskin(RaidFinderQueueFramePartyBackfillNoBackfillButton)
	S:ReskinClose(LFGDungeonReadyStatusCloseButton)
	S:ReskinCheck(LFGInvitePopupRoleButtonTank:GetChildren())
	S:ReskinCheck(LFGInvitePopupRoleButtonHealer:GetChildren())
	S:ReskinCheck(LFGInvitePopupRoleButtonDPS:GetChildren())
	S:CreateBD(LFGInvitePopup)
	S:CreateSD(LFGInvitePopup)
	S:Reskin(LFGInvitePopupAcceptButton)
	S:Reskin(LFGInvitePopupDeclineButton)
	S:ReskinCheck(LFDQueueFrameRoleButtonTank:GetChildren())
	S:ReskinCheck(LFDQueueFrameRoleButtonHealer:GetChildren())
	S:ReskinCheck(LFDQueueFrameRoleButtonDPS:GetChildren())
	S:ReskinCheck(LFDQueueFrameRoleButtonLeader:GetChildren())
	S:ReskinCheck(RaidFinderQueueFrameRoleButtonTank:GetChildren())
	S:ReskinCheck(RaidFinderQueueFrameRoleButtonHealer:GetChildren())
	S:ReskinCheck(RaidFinderQueueFrameRoleButtonDPS:GetChildren())
	S:ReskinCheck(RaidFinderQueueFrameRoleButtonLeader:GetChildren())
	S:ReskinCheck(LFDRoleCheckPopupRoleButtonTank:GetChildren())
	S:ReskinCheck(LFDRoleCheckPopupRoleButtonHealer:GetChildren())
	S:ReskinCheck(LFDRoleCheckPopupRoleButtonDPS:GetChildren())
	S:ReskinScroll(LFDQueueFrameSpecificListScrollFrameScrollBar)
	S:ReskinScroll(LFDQueueFrameRandomScrollFrameScrollBar)
	S:ReskinScroll(ScenarioQueueFrameRandomScrollFrameScrollBar)
	S:ReskinDropDown(LFDQueueFrameTypeDropDown)

	LFDParentFrame:DisableDrawLayer("BACKGROUND")
	LFDParentFrame:DisableDrawLayer("BORDER")
	LFDParentFrame:DisableDrawLayer("OVERLAY")
	LFDParentFrameInset:DisableDrawLayer("BACKGROUND")
	LFDParentFrameInset:DisableDrawLayer("BORDER")
	LFDQueueFrameBackground:Hide()
	LFDQueueFrameCooldownFrameBlackFilter:SetAlpha(.6)
	LFDQueueFrameRandomScrollFrameScrollBackground:Hide()
	LFDQueueFramePartyBackfill:SetAlpha(.6)
	LFDQueueFrameFindGroupButton_RightSeparator:Hide()
	LFDQueueFrameSpecificListScrollFrameScrollBackgroundTopLeft:Hide()
	LFDQueueFrameSpecificListScrollFrameScrollBackgroundBottomRight:Hide()
	LFDQueueFrameSpecificListScrollFrameScrollBarScrollDownButton:SetPoint("TOP", LFDQueueFrameSpecificListScrollFrameScrollBar, "BOTTOM", 0, 2)
	LFDQueueFrameRandomScrollFrameScrollBarScrollDownButton:SetPoint("TOP", LFDQueueFrameRandomScrollFrameScrollBar, "BOTTOM", 0, 2)
	LFDQueueFrameRandomScrollFrame:SetWidth(304)

	hooksecurefunc("LFGRewardsFrame_SetItemButton", function(parentFrame, dungeonID, index)
		local parentName = parentFrame:GetName()
		local button = _G[parentName.."Item"..index]
		local icon = _G[parentName.."Item"..index.."IconTexture"]
		icon:SetTexCoord(.08, .92, .08, .92)
		if not button.reskinned then
			local cta = _G[parentName.."Item"..index.."ShortageBorder"]
			local count = _G[parentName.."Item"..index.."Count"]
			local na = _G[parentName.."Item"..index.."NameFrame"]

			S:CreateBG(icon)
			icon:SetDrawLayer("OVERLAY")
			count:SetDrawLayer("OVERLAY")
			na:SetTexture(0, 0, 0, .25)
			na:SetSize(118, 39)
			cta:SetAlpha(0)

			button.bg2 = CreateFrame("Frame", nil, button)
			button.bg2:SetPoint("TOPLEFT", na, "TOPLEFT", 10, 0)
			button.bg2:SetPoint("BOTTOMRIGHT", na, "BOTTOMRIGHT", -2, 0)
			S:CreateBD(button.bg2, 0)

			button.reskinned = true
		end
	end)

	function ReskinGoldIcon(button)
		_G[button.."IconTexture"]:SetTexCoord(.08, .92, .08, .92)
		_G[button.."IconTexture"]:SetDrawLayer("OVERLAY")
		_G[button.."Count"]:SetDrawLayer("OVERLAY")
		_G[button.."NameFrame"]:SetTexture()

		S:CreateBG(_G[button.."IconTexture"])
		_G[button.."NameFrame"]:SetTexture(0, 0, 0, .25)
		_G[button.."NameFrame"]:SetSize(118, 39)
		_G[button].bg2 = CreateFrame("Frame", nil, _G[button])
		_G[button].bg2:SetPoint("TOPLEFT", _G[button.."NameFrame"], "TOPLEFT", 10, 0)
		_G[button].bg2:SetPoint("BOTTOMRIGHT", _G[button.."NameFrame"], "BOTTOMRIGHT", -2, 0)
		S:CreateBD(_G[button].bg2, 0)
	end
	ReskinGoldIcon("LFDQueueFrameRandomScrollFrameChildFrameMoneyReward")
	ReskinGoldIcon("RaidFinderQueueFrameScrollFrameChildFrameMoneyReward")
	ReskinGoldIcon("ScenarioQueueFrameRandomScrollFrameChildFrameMoneyReward")

	LFGDungeonReadyDialog.SetBackdrop = R.dummy
	LFGDungeonReadyDialogBackground:Hide()
	LFGDungeonReadyDialogBottomArt:Hide()
	LFGDungeonReadyDialogFiligree:Hide()
	S:Reskin(LFGDungeonReadyDialogEnterDungeonButton)
	S:Reskin(LFGDungeonReadyDialogLeaveQueueButton)
	S:Reskin(LFDQueueFrameNoLFDWhileLFRLeaveQueueButton)

	for i = 1, 9 do
		select(i, QueueStatusFrame:GetRegions()):Hide()
	end

	QueueStatusMinimapButtonBorder:Kill()
	QueueStatusMinimapButton:ClearAllPoints()
	QueueStatusMinimapButton:Point("TOP", Minimap, "TOP")
	QueueStatusFrame:ClearAllPoints()
	QueueStatusFrame:Point("TOPLEFT", Minimap, "TOPRIGHT", 5, 2)
	S:Reskin(LFRQueueFrameFindGroupButton)
	S:Reskin(LFRQueueFrameAcceptCommentButton)
	S:Reskin(LFRBrowseFrameSendMessageButton)
	S:Reskin(LFRBrowseFrameInviteButton)
	S:Reskin(LFRBrowseFrameRefreshButton)
	S:ReskinCheck(LFRQueueFrameRoleButtonTank:GetChildren())
	S:ReskinCheck(LFRQueueFrameRoleButtonHealer:GetChildren())
	S:ReskinCheck(LFRQueueFrameRoleButtonDPS:GetChildren())
	S:ReskinDropDown(LFRBrowseFrameRaidDropDown)
	LFRQueueFrame:DisableDrawLayer("BACKGROUND")
	LFRBrowseFrame:DisableDrawLayer("BACKGROUND")
	for i = 1, 7 do
		_G["LFRBrowseFrameColumnHeader"..i]:DisableDrawLayer("BACKGROUND")
	end
	RaidParentFrame:DisableDrawLayer("BACKGROUND")
	RaidParentFrame:DisableDrawLayer("BORDER")
	RaidParentFrameInset:DisableDrawLayer("BORDER")
	RaidFinderFrameRoleInset:DisableDrawLayer("BORDER")
	LFRQueueFrameRoleInset:DisableDrawLayer("BORDER")
	LFRQueueFrameListInset:DisableDrawLayer("BORDER")
	LFRQueueFrameCommentInset:DisableDrawLayer("BORDER")
	LFRQueueFrameRoleInsetBg:Hide()
	LFRQueueFrameListInsetBg:Hide()
	LFRQueueFrameCommentInsetBg:Hide()
	RaidFinderQueueFrameBackground:Hide()
	RaidParentFrameInsetBg:Hide()
	RaidFinderFrameRoleInsetBg:Hide()
	RaidFinderFrameRoleBackground:Hide()
	RaidParentFramePortraitFrame:Hide()
	RaidParentFramePortrait:Hide()
	RaidParentFrameTopBorder:Hide()
	RaidParentFrameTopRightCorner:Hide()
	RaidFinderFrameFindRaidButton_RightSeparator:Hide()
	RaidFinderFrameBottomInset:DisableDrawLayer("BORDER")
	RaidFinderFrameBottomInsetBg:Hide()
	RaidFinderFrameBtnCornerRight:Hide()
	RaidFinderFrameButtonBottomBorder:Hide()

	S:Reskin(RaidFinderFrameFindRaidButton)
	S:Reskin(RaidFinderFrameCancelButton)
	S:Reskin(RaidFinderQueueFrameIneligibleFrameLeaveQueueButton)
	S:ReskinDropDown(RaidFinderQueueFrameSelectionDropDown)
	S:ReskinClose(RaidParentFrameCloseButton)

	-- Scenario finder
	ScenarioFinderFrameInset:DisableDrawLayer("BORDER")
	ScenarioFinderFrame.TopTileStreaks:Hide()
	ScenarioFinderFrameBtnCornerRight:Hide()
	ScenarioFinderFrameButtonBottomBorder:Hide()
	ScenarioQueueFrame.Bg:Hide()
	ScenarioFinderFrameInset:GetRegions():Hide()

	S:Reskin(ScenarioQueueFrameFindGroupButton)
	S:ReskinDropDown(ScenarioQueueFrameTypeDropDown)

	-- Raid frame (social frame)
	S:Reskin(RaidFrameRaidBrowserButton)

	-- Looking for raid
	LFRBrowseFrameRoleInset:DisableDrawLayer("BORDER")
	LFRQueueFrameSpecificListScrollFrameScrollBackgroundTopLeft:Hide()
	LFRQueueFrameSpecificListScrollFrameScrollBackgroundBottomRight:Hide()
	LFRBrowseFrameRoleInsetBg:Hide()

	S:ReskinPortraitFrame(RaidBrowserFrame)
	S:ReskinScroll(LFRQueueFrameSpecificListScrollFrameScrollBar)
	S:ReskinScroll(LFRQueueFrameCommentScrollFrameScrollBar)

	for i = 1, 2 do
		local tab = _G["LFRParentFrameSideTab"..i]
		tab:GetRegions():Hide()
		tab:SetCheckedTexture(S["media"].checked)
		if i == 1 then
			local a1, p, a2, x, y = tab:GetPoint()
			tab:SetPoint(a1, p, a2, x + 11, y)
		end
		S:CreateBG(tab)
		S:CreateSD(tab, 5, 0, 0, 0, 1, 1)
		select(2, tab:GetRegions()):SetTexCoord(.08, .92, .08, .92)
	end

	local LFGListFrame = LFGListFrame

	-- [[ Category selection ]]

	local CategorySelection = LFGListFrame.CategorySelection

	CategorySelection.Inset.Bg:Hide()
	select(10, CategorySelection.Inset:GetRegions()):Hide()
	CategorySelection.Inset:DisableDrawLayer("BORDER")

	S:Reskin(CategorySelection.FindGroupButton)
	S:Reskin(CategorySelection.StartGroupButton)

	CategorySelection.CategoryButtons[1]:SetNormalFontObject(GameFontNormal)

	hooksecurefunc("LFGListCategorySelection_AddButton", function(self, btnIndex)
		local bu = self.CategoryButtons[btnIndex]

		if bu and not bu.styled then
			bu.Cover:Hide()

			bu.Icon:SetDrawLayer("BACKGROUND", 1)
			bu.Icon:SetTexCoord(.01, .99, .01, .99)

			local bg = S:CreateBG(bu)
			bg:SetPoint("TOPLEFT", 4, -4)
			bg:SetPoint("BOTTOMRIGHT", -4, 4)

			bu.styled = true
		end
	end)

	-- [[ Search panel ]]

	local SearchPanel = LFGListFrame.SearchPanel

	SearchPanel.ResultsInset.Bg:Hide()
	SearchPanel.ResultsInset:DisableDrawLayer("BORDER")

	S:Reskin(SearchPanel.RefreshButton)
	S:Reskin(SearchPanel.BackButton)
	S:Reskin(SearchPanel.SignUpButton)
	S:Reskin(SearchPanel.ScrollFrame.StartGroupButton)
	S:ReskinInput(SearchPanel.SearchBox)
	S:ReskinScroll(SearchPanel.ScrollFrame.scrollBar)

	SearchPanel.RefreshButton:SetSize(24, 24)
	SearchPanel.RefreshButton.Icon:SetPoint("CENTER")

	-- Auto complete frame

	SearchPanel.AutoCompleteFrame.BottomLeftBorder:Hide()
	SearchPanel.AutoCompleteFrame.BottomRightBorder:Hide()
	SearchPanel.AutoCompleteFrame.BottomBorder:Hide()
	SearchPanel.AutoCompleteFrame.LeftBorder:Hide()
	SearchPanel.AutoCompleteFrame.RightBorder:Hide()

	local function resultOnEnter(self)
		self.hl:Show()
	end

	local function resultOnLeave(self)
		self.hl:Hide()
	end

	local numResults = 1
	hooksecurefunc("LFGListSearchPanel_UpdateAutoComplete", function(self)
		local AutoCompleteFrame = self.AutoCompleteFrame

		for i = numResults, #AutoCompleteFrame.Results do
			local result = AutoCompleteFrame.Results[i]

			if numResults == 1 then
				result:SetPoint("TOPLEFT", AutoCompleteFrame.LeftBorder, "TOPRIGHT", -8, 1)
				result:SetPoint("TOPRIGHT", AutoCompleteFrame.RightBorder, "TOPLEFT", 5, 1)
			else
				result:SetPoint("TOPLEFT", AutoCompleteFrame.Results[i-1], "BOTTOMLEFT", 0, 1)
				result:SetPoint("TOPRIGHT", AutoCompleteFrame.Results[i-1], "BOTTOMRIGHT", 0, 1)
			end

			result:SetNormalTexture("")
			result:SetPushedTexture("")
			result:SetHighlightTexture("")

			local hl = result:CreateTexture(nil, "BACKGROUND")
			hl:SetAllPoints()
			hl:SetTexture(R["media"].gloss)
			hl:SetVertexColor(r, g, b, .2)
			hl:Hide()
			result.hl = hl

			S:CreateBD(result, .5)

			result:HookScript("OnEnter", resultOnEnter)
			result:HookScript("OnLeave", resultOnLeave)

			numResults = numResults + 1
		end
	end)

	-- [[ Application viewer ]]

	local ApplicationViewer = LFGListFrame.ApplicationViewer

	ApplicationViewer.InfoBackground:Hide()

	ApplicationViewer.Inset.Bg:Hide()
	ApplicationViewer.Inset:DisableDrawLayer("BORDER")

	local function headerOnEnter(self)
		self.hl:Show()
	end

	local function headerOnLeave(self)
		self.hl:Hide()
	end

	for _, headerName in pairs({"NameColumnHeader", "RoleColumnHeader", "ItemLevelColumnHeader"}) do
		local header = ApplicationViewer[headerName]
		header.Left:Hide()
		header.Middle:Hide()
		header.Right:Hide()

		header:SetHighlightTexture("")

		local hl = header:CreateTexture(nil, "BACKGROUND")
		hl:SetAllPoints()
		hl:SetTexture(R["media"].gloss)
		hl:SetVertexColor(r, g, b, .2)
		hl:Hide()
		header.hl = hl

		S:CreateBD(header, .25)

		header:HookScript("OnEnter", headerOnEnter)
		header:HookScript("OnLeave", headerOnLeave)
	end

	ApplicationViewer.RoleColumnHeader:SetPoint("LEFT", ApplicationViewer.NameColumnHeader, "RIGHT", 1, 0)
	ApplicationViewer.ItemLevelColumnHeader:SetPoint("LEFT", ApplicationViewer.RoleColumnHeader, "RIGHT", 1, 0)

	S:Reskin(ApplicationViewer.RefreshButton)
	S:Reskin(ApplicationViewer.RemoveEntryButton)
	S:Reskin(ApplicationViewer.EditButton)
	S:ReskinScroll(LFGListApplicationViewerScrollFrameScrollBar)

	ApplicationViewer.RefreshButton:SetSize(24, 24)
	ApplicationViewer.RefreshButton.Icon:SetPoint("CENTER")

	-- [[ Entry creation ]]

	local EntryCreation = LFGListFrame.EntryCreation

	EntryCreation.Inset.Bg:Hide()
	select(10, EntryCreation.Inset:GetRegions()):Hide()
	EntryCreation.Inset:DisableDrawLayer("BORDER")

	for i = 1, 9 do
		select(i, EntryCreation.Description:GetRegions()):Hide()
	end

	S:Reskin(EntryCreation.ListGroupButton)
	S:Reskin(EntryCreation.CancelButton)
	S:CreateBD(EntryCreation.Description, 0)
	S:ReskinInput(EntryCreation.Name)
	S:ReskinInput(EntryCreation.ItemLevel.EditBox)
	S:ReskinInput(EntryCreation.VoiceChat.EditBox)
	S:ReskinDropDown(EntryCreation.CategoryDropDown)
	S:ReskinDropDown(EntryCreation.GroupDropDown)
	S:ReskinDropDown(EntryCreation.ActivityDropDown)
	S:ReskinCheck(EntryCreation.ItemLevel.CheckButton)
	S:ReskinCheck(EntryCreation.VoiceChat.CheckButton)

	-- Activity finder

	local ActivityFinder = EntryCreation.ActivityFinder

	ActivityFinder.Background:SetTexture("")
	ActivityFinder.Dialog.Bg:Hide()
	for i = 1, 9 do
		select(i, ActivityFinder.Dialog.BorderFrame:GetRegions()):Hide()
	end

	S:CreateBD(ActivityFinder.Dialog)
	ActivityFinder.Dialog:SetBackdropColor(.2, .2, .2, .9)

	S:Reskin(ActivityFinder.Dialog.SelectButton)
	S:Reskin(ActivityFinder.Dialog.CancelButton)
	S:ReskinInput(ActivityFinder.Dialog.EntryBox)
	S:ReskinScroll(LFGListEntryCreationSearchScrollFrameScrollBar)
end

S:RegisterSkin("RayUI", LoadSkin)
