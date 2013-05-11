local R, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local S = R:GetModule("Skins")

local function LoadSkin()
	FriendsFrameIcon:Hide()
	FriendsFrameTopRightCorner:Hide()
	FriendsFrameTopLeftCorner:Hide()
	FriendsFrameTopBorder:Hide()
	FriendsFramePortraitFrame:Hide()
	FriendsFrameIcon:Hide()
	FriendsFrameInsetBg:Hide()
	FriendsFrameFriendsScrollFrameTop:Hide()
	FriendsFrameFriendsScrollFrameMiddle:Hide()
	FriendsFrameFriendsScrollFrameBottom:Hide()
	WhoFrameListInsetBg:Hide()
	WhoFrameEditBoxInsetBg:Hide()
	ChannelFrameLeftInsetBg:Hide()
	ChannelFrameRightInsetBg:Hide()
	IgnoreListFrameTop:Hide()
	IgnoreListFrameMiddle:Hide()
	IgnoreListFrameBottom:Hide()
	PendingListFrameTop:Hide()
	PendingListFrameMiddle:Hide()
	PendingListFrameBottom:Hide()
	ChannelFrameDaughterFrameTitlebar:Hide()
	ChannelFrameDaughterFrameCorner:Hide()
	S:ReskinDropDown(WhoFrameDropDown)
	S:ReskinDropDown(FriendsFriendsFrameDropDown)
	S:ReskinScroll(FriendsFrameFriendsScrollFrameScrollBar)
	S:ReskinScroll(WhoListScrollFrameScrollBar)
	S:ReskinScroll(FriendsFriendsScrollFrameScrollBar)
	S:ReskinScroll(ChannelRosterScrollFrameScrollBar)
	S:ReskinInput(AddFriendNameEditBox)
	S:ReskinInput(FriendsFrameBroadcastInput)
	S:ReskinInput(ChannelFrameDaughterFrameChannelName)
	S:ReskinInput(ChannelFrameDaughterFrameChannelPassword)
	S:ReskinClose(ChannelFrameDaughterFrameDetailCloseButton)
	S:ReskinClose(FriendsFrameCloseButton)
	ChannelRosterScrollFrame:Point("TOPRIGHT", ChannelFrame, "TOPRIGHT", -39, -60)
	FriendsTabHeaderSoRButton:StyleButton(true)

	for i = 1, 4 do
		S:CreateTab(_G["FriendsFrameTab"..i])
	end

	for i = 1, MAX_DISPLAY_CHANNEL_BUTTONS do
		_G["ChannelButton"..i]:SetNormalTexture("")
	end

	for i=1, MAX_CHANNEL_BUTTONS do
		_G["ChannelButton"..i.."Text"]:SetFont(R["media"].font, R["media"].fontsize)
	end

	for i = 1, 6 do
		for j = 1, 3 do
			select(i, _G["FriendsTabHeaderTab"..j]:GetRegions()):Hide()
			select(i, _G["FriendsTabHeaderTab"..j]:GetRegions()).Show = R.dummy
		end
	end

	local buttons = {
		"WhoFrameAddFriendButton",
		"WhoFrameGroupInviteButton",
		"FriendsFrameAddFriendButton",
		"FriendsFrameSendMessageButton",
		"AddFriendEntryFrameAcceptButton",
		"AddFriendEntryFrameCancelButton",
		"FriendsFriendsSendRequestButton",
		"FriendsFriendsCloseButton",
		"FriendsFrameUnsquelchButton",
		"FriendsFramePendingButton1AcceptButton",
		"FriendsFramePendingButton1DeclineButton",
		"FriendsFrameIgnorePlayerButton",
		"AddFriendInfoFrameContinueButton",
		"ChannelFrameNewButton",
		"ChannelFrameDaughterFrameOkayButton",
		"ChannelFrameDaughterFrameCancelButton",
		"WhoFrameWhoButton",
		"PendingListInfoFrameContinueButton",
		"FriendsFrameMutePlayerButton"
	}
	for i = 1, #buttons do
		local button = _G[buttons[i]]
		S:Reskin(button)
	end

	for i = 1, FRIENDS_TO_DISPLAY do
		local bu = _G["FriendsFrameFriendsScrollFrameButton"..i]
		local ic = bu.gameIcon

		bu.background:Hide()
		bu.travelPassButton:SetAlpha(0)
		bu.travelPassButton:EnableMouse(false)

		bu:SetHighlightTexture(S.media.backdrop)
		bu:GetHighlightTexture():SetVertexColor(.24, .56, 1, .2)

		ic:Size(22, 22)
		ic:SetTexCoord(.15, .85, .15, .85)

		bu.bg = CreateFrame("Frame", nil, bu)
		bu.bg:SetAllPoints(ic)
		S:CreateBD(bu.bg, 0)
	end

	local function UpdateScroll()
		for i = 1, FRIENDS_TO_DISPLAY do
			local bu = _G["FriendsFrameFriendsScrollFrameButton"..i]

			if bu.gameIcon:IsShown() then
				bu.bg:Show()
				bu.gameIcon:Point("TOPRIGHT", bu, "TOPRIGHT", -2, -2)
			else
				bu.bg:Hide()
			end
		end
	end

	local bu1 = FriendsFrameFriendsScrollFrameButton1
	bu1.bg:Point("BOTTOMRIGHT", bu1.gameIcon, 0, -1)

	hooksecurefunc("FriendsFrame_UpdateFriends", UpdateScroll)
	hooksecurefunc(FriendsFrameFriendsScrollFrame, "update", UpdateScroll)

	FriendsFrameStatusDropDown:ClearAllPoints()
	FriendsFrameStatusDropDown:Point("TOPLEFT", FriendsFrame, "TOPLEFT", 10, -28)

	FriendsTabHeaderSoRButton:SetPushedTexture("")
	FriendsTabHeaderSoRButtonIcon:SetTexCoord(.08, .92, .08, .92)
	local SoRBg = CreateFrame("Frame", nil, FriendsTabHeaderSoRButton)
	SoRBg:Point("TOPLEFT", -1, 1)
	SoRBg:Point("BOTTOMRIGHT", 1, -1)
	S:CreateBD(SoRBg, 0)

	S:CreateBD(FriendsFrameBattlenetFrame.UnavailableInfoFrame)
	FriendsFrameBattlenetFrame.UnavailableInfoFrame:Point("TOPLEFT", FriendsFrame, "TOPRIGHT", 1, -18)

	S:ReskinInput(FriendsFrameBroadcastInput)
	FriendsFrameBattlenetFrame:GetRegions():Hide()
	S:CreateBD(FriendsFrameBattlenetFrame, .25)

	FriendsFrameBattlenetFrame.Tag:SetParent(FriendsListFrame)
	FriendsFrameBattlenetFrame.Tag:Point("TOP", FriendsFrame, "TOP", 0, -8)

	hooksecurefunc("FriendsFrame_CheckBattlenetStatus", function()
		if BNFeaturesEnabled() then
			local frame = FriendsFrameBattlenetFrame

			frame.BroadcastButton:Hide()

			if BNConnected() then
				frame:Hide()
				FriendsFrameBroadcastInput:Show()
				FriendsFrameBroadcastInput_UpdateDisplay()
			end
		end
	end)
	FriendsFrame_CheckBattlenetStatus()

	hooksecurefunc("FriendsFrame_Update", function()
		if FriendsFrame.selectedTab == 1 and FriendsTabHeader.selectedTab == 1 and FriendsFrameBattlenetFrame.Tag:IsShown() then
			FriendsFrameTitleText:Hide()
		else
			FriendsFrameTitleText:Show()
		end
	end)

	local whoBg = CreateFrame("Frame", nil, WhoFrameEditBoxInset)
	whoBg:SetPoint("TOPLEFT")
	whoBg:Point("BOTTOMRIGHT", -1, 1)
	whoBg:SetFrameLevel(WhoFrameEditBoxInset:GetFrameLevel()-1)
	S:CreateBD(whoBg, .25)

	S:ReskinPortraitFrame(FriendsFrame, true)
	S:ReskinDropDown(FriendsFrameStatusDropDown)

	-- Battletag invite frame
	for i = 1, 9 do
		select(i, BattleTagInviteFrame.NoteFrame:GetRegions()):Hide()
	end

	S:CreateBD(BattleTagInviteFrame)
	S:CreateSD(BattleTagInviteFrame)
	S:CreateBD(BattleTagInviteFrame.NoteFrame, .25)

	local _, send, cancel = BattleTagInviteFrame:GetChildren()
	S:Reskin(send)
	S:Reskin(cancel)

	S:ReskinScroll(BattleTagInviteFrameScrollFrameScrollBar)
end

S:RegisterSkin("RayUI", LoadSkin)
