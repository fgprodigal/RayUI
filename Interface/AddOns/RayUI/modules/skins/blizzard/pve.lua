local R, L, P = unpack(select(2, ...)) --Inport: Engine, Locales, ProfileDB
local S = R:GetModule("Skins")

local function LoadSkin()
	PVEFrame:DisableDrawLayer("ARTWORK")
	PVEFrameLeftInset:DisableDrawLayer("BORDER")
	PVEFrameBlueBg:Hide()
	PVEFrameLeftInsetBg:Hide()
	PVEFrame.shadows:Hide()
	select(24, PVEFrame:GetRegions()):Hide()
	select(25, PVEFrame:GetRegions()):Hide()
	
	PVEFrameTab2:SetPoint("LEFT", PVEFrameTab1, "RIGHT", -15, 0)
	
	GroupFinderFrameGroupButton1.icon:SetTexture("Interface\\Icons\\INV_Helmet_08")
	GroupFinderFrameGroupButton2.icon:SetTexture("Interface\\Icons\\inv_helmet_06")
	GroupFinderFrameGroupButton3.icon:SetTexture("Interface\\Icons\\Icon_Scenarios")
	
	local function onEnter(self)
		self:SetBackdropColor(r, g, b, .4)
	end
	
	local function onLeave(self)
		self:SetBackdropColor(0, 0, 0, 0)
	end

	for i = 1, 3 do
		local bu = GroupFinderFrame["groupButton"..i]

		bu.ring:Hide()
		bu.bg:SetTexture(S["media"].backdrop)
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
		for i = 1, 3 do
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

	S:Reskin(LFDQueueFrameFindGroupButton)
	S:Reskin(LFDQueueFrameCancelButton)
	S:Reskin(LFDRoleCheckPopupAcceptButton)
	S:Reskin(LFDRoleCheckPopupDeclineButton)
	S:Reskin(LFDQueueFramePartyBackfillBackfillButton)
	S:Reskin(RaidFinderQueueFramePartyBackfillBackfillButton)
	S:Reskin(LFDQueueFramePartyBackfillNoBackfillButton)
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
			button.bg2:SetPoint("BOTTOMRIGHT", na, "BOTTOMRIGHT")
			S:CreateBD(button.bg2, 0)

			button.reskinned = true
		end
	end)

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
end

S:RegisterSkin("RayUI", LoadSkin)
