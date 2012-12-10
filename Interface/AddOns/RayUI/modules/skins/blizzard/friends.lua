local R, L, P = unpack(select(2, ...)) --Inport: Engine, Locales, ProfileDB
local S = R:GetModule("Skins")

local function LoadSkin()
	WhoFrameWhoButton:SetPoint("RIGHT", WhoFrameAddFriendButton, "LEFT", -1, 0)
	WhoFrameAddFriendButton:SetPoint("RIGHT", WhoFrameGroupInviteButton, "LEFT", -1, 0)
	WhoListScrollFrame:GetRegions():Hide()
	select(2, WhoListScrollFrame:GetRegions()):Hide()
	ChannelFrameDaughterFrameCorner:Hide()
	ChannelFrameDaughterFrameTitlebar:Hide()
	ChannelRosterScrollFrameTop:SetAlpha(0)
	ChannelRosterScrollFrameBottom:SetAlpha(0)
	FriendsFrameStatusDropDown:ClearAllPoints()

	S:ReskinScroll(FriendsFrameFriendsScrollFrameScrollBar)
	S:ReskinScroll(WhoListScrollFrameScrollBar)
	S:ReskinScroll(FriendsFriendsScrollFrameScrollBar)
	S:ReskinScroll(ChannelRosterScrollFrameScrollBar)
	ChannelRosterScrollFrame:Point("TOPRIGHT", ChannelFrame, "TOPRIGHT", -39, -60)
	S:ReskinDropDown(FriendsFrameStatusDropDown)
	S:ReskinDropDown(WhoFrameDropDown)
	S:ReskinDropDown(FriendsFriendsFrameDropDown)
	S:ReskinInput(AddFriendNameEditBox)
	S:ReskinInput(FriendsFrameBroadcastInput)
	S:ReskinInput(ChannelFrameDaughterFrameChannelName)
	S:ReskinInput(ChannelFrameDaughterFrameChannelPassword)
	S:ReskinClose(ChannelFrameDaughterFrameDetailCloseButton)
	S:ReskinClose(FriendsFrameCloseButton)
	FriendsTabHeaderSoRButton:StyleButton(true)

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

	local bglayers = {
		"FriendsFrame",
		"WhoFrameColumnHeader1",
		"WhoFrameColumnHeader2",
		"WhoFrameColumnHeader3",
		"WhoFrameColumnHeader4"
	}
	for i = 1, #bglayers do
		_G[bglayers[i]]:DisableDrawLayer("BACKGROUND")
	end

	local borderlayers = {
		"FriendsFrame",
		"FriendsFrameInset",
		"WhoFrameListInset",
		"WhoFrameEditBoxInset",
		"WhoFrameColumnHeader4",
		"ChannelFrameLeftInset",
		"ChannelFrameRightInset"
	}
	for i = 1, #borderlayers do
		_G[borderlayers[i]]:DisableDrawLayer("BORDER")
	end

	local lightbds = {
		"FriendsFriendsList",
		"AddFriendNoteFrame",
		"FriendsFriendsNoteFrame"
	}
	for i = 1, #lightbds do
		S:CreateBD(_G[lightbds[i]], .25)
	end

	FriendsFrameStatusDropDown:SetPoint("TOPLEFT", FriendsFrame, "TOPLEFT", 10, -32)
	FriendsFrameTitleText:SetPoint("TOP", FriendsFrame, "TOP", 0, -8)
	S:SetBD(FriendsFrame)
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

	for i = 1, 6 do
		for j = 1, 3 do
			select(i, _G["FriendsTabHeaderTab"..j]:GetRegions()):Hide()
			select(i, _G["FriendsTabHeaderTab"..j]:GetRegions()).Show = R.dummy
		end
	end

	for i = 1, 4 do
		S:CreateTab(_G["FriendsFrameTab"..i])
	end

	for i = 1, 9 do
		select(i, FriendsFriendsNoteFrame:GetRegions()):Hide()
		select(i, AddFriendNoteFrame:GetRegions()):Hide()
	end

	for i = 1, MAX_DISPLAY_CHANNEL_BUTTONS do
		_G["ChannelButton"..i]:SetNormalTexture("")
	end

	for i = 1, FRIENDS_TO_DISPLAY do
		local bu = _G["FriendsFrameFriendsScrollFrameButton"..i]
		local ic = _G["FriendsFrameFriendsScrollFrameButton"..i.."GameIcon"]
		local inv = _G["FriendsFrameFriendsScrollFrameButton"..i.."TravelPassButton"]
		local summon = _G["FriendsFrameFriendsScrollFrameButton"..i.."SummonButton"]
		bu:SetHighlightTexture(S["media"].backdrop)
		bu:GetHighlightTexture():SetVertexColor(.24, .56, 1, .2)

		ic:Size(25, 25)
		ic:SetTexCoord(.15, .85, .15, .85)

		ic:ClearAllPoints()
		ic:Point("RIGHT", bu, "RIGHT", -24, 0)
		ic.SetPoint = R.dummy

		S:Reskin(inv)
		inv:Size(15, 25)
		inv:ClearAllPoints()
		inv:Point("RIGHT", bu, "RIGHT", -4, 0)
		inv.SetPoint = R.dummy
		local text = inv:CreateFontString(nil, "OVERLAY")
		text:SetFont(R["media"].font, R["media"].fontsize)
		text:SetShadowOffset(R.mult, -R.mult)
		text:SetPoint("CENTER")
		text:SetText("+")

        select(1, summon:GetRegions()):SetTexCoord( .08, .92, .08, .92)
        select(10, summon:GetRegions()):SetAlpha(0)
        summon:StyleButton(1)
        S:CreateBD(summon, 0)
	end

	local function UpdateScroll()
		for i = 1, FRIENDS_TO_DISPLAY do
			local bu = _G["FriendsFrameFriendsScrollFrameButton"..i]
			local ic = _G["FriendsFrameFriendsScrollFrameButton"..i.."GameIcon"]
			local inv = _G["FriendsFrameFriendsScrollFrameButton"..i.."TravelPassButton"]
			if not ic.bg then
				ic.bg = CreateFrame("Frame", nil, bu)
				ic.bg:Point("TOPLEFT", ic)
				ic.bg:Point("BOTTOMRIGHT", ic)
				ic.bg:SetFrameLevel(bu:GetFrameLevel())
				S:CreateBD(ic.bg, 0)
			end
			if ic:IsShown() then
				ic.bg:Show()
				if inv:IsEnabled() then
					inv:SetAlpha(1)
					inv:EnableMouse(true)
				else
					inv:SetAlpha(0)
					inv:EnableMouse(false)
				end
				ic:SetDrawLayer("OVERLAY", 7)
			else
				ic.bg:Hide()
			end
		end
	end

	local friendshandler = CreateFrame("Frame")
	friendshandler:RegisterEvent("FRIENDLIST_UPDATE")
	friendshandler:RegisterEvent("BN_FRIEND_TOON_ONLINE")
	friendshandler:RegisterEvent("BN_FRIEND_ACCOUNT_OFFLINE")
	friendshandler:SetScript("OnEvent", UpdateScroll)
	FriendsFrameFriendsScrollFrame:HookScript("OnVerticalScroll", UpdateScroll)
    hooksecurefunc(FriendsFrameFriendsScrollFrame, "update", UpdateScroll)

	local whobg = CreateFrame("Frame", nil, WhoFrameEditBoxInset)
	whobg:SetPoint("TOPLEFT")
	whobg:Point("BOTTOMRIGHT", -1, 1)
	whobg:SetFrameLevel(WhoFrameEditBoxInset:GetFrameLevel()-1)
	S:CreateBD(whobg, .25)

	FriendsTabHeaderSoRButtonIcon:SetTexCoord(.08, .92, .08, .92)
	local sorbg = CreateFrame("Frame", nil, FriendsTabHeaderSoRButton)
	sorbg:Point("TOPLEFT", -1, 1)
	sorbg:Point("BOTTOMRIGHT", 1, -1)
	S:CreateBD(sorbg, 0)
	for i=1, MAX_CHANNEL_BUTTONS do
		_G["ChannelButton"..i.."Text"]:SetFont(R["media"].font, R["media"].fontsize)
	end

	FriendsFrameBattlenetFrame:StripTextures()
	FriendsFrameBattlenetFrame.BroadcastFrame:StripTextures()
	FriendsFrameBattlenetFrame.BroadcastFrame:ClearAllPoints()
	FriendsFrameBattlenetFrame.BroadcastFrame:Point("TOPLEFT", FriendsFrame, "TOPRIGHT", 1, 0)
	S:CreateBD(FriendsFrameBattlenetFrame.BroadcastFrame)
	S:Reskin(FriendsFrameBattlenetFrame.BroadcastFrame.ScrollFrame.CancelButton)
	S:Reskin(FriendsFrameBattlenetFrame.BroadcastFrame.ScrollFrame.UpdateButton)
	FriendsFrameBattlenetFrame.BroadcastFrame.ScrollFrame.TopBorder:Hide()
	FriendsFrameBattlenetFrame.BroadcastFrame.ScrollFrame.BottomBorder:Hide()
	FriendsFrameBattlenetFrame.BroadcastFrame.ScrollFrame.LeftBorder:Hide()
	FriendsFrameBattlenetFrame.BroadcastFrame.ScrollFrame.RightBorder:Hide()
	FriendsFrameBattlenetFrame.BroadcastFrame.ScrollFrame.MiddleBorder:Hide()
	FriendsFrameBattlenetFrame.BroadcastFrame.ScrollFrame.TopRightBorder:Hide()
	FriendsFrameBattlenetFrame.BroadcastFrame.ScrollFrame.TopLeftBorder:Hide()
	FriendsFrameBattlenetFrame.BroadcastFrame.ScrollFrame.BottomRightBorder:Hide()
	FriendsFrameBattlenetFrame.BroadcastFrame.ScrollFrame.BottomLeftBorder:Hide()
	S:CreateBD(FriendsFrameBattlenetFrame.BroadcastFrame.ScrollFrame)
	S:CreateBD(FriendsFrameBattlenetFrame.BroadcastButton, 0)
	FriendsFrameBattlenetFrame.BroadcastButton:Size(19, 19)
	FriendsFrameStatusDropDown:ClearAllPoints()
	FriendsFrameStatusDropDown:SetPoint("TOPLEFT", FriendsFrame, "TOPLEFT", 40, -28)
	FriendsFrameBattlenetFrame.BroadcastButton:ClearAllPoints()
	FriendsFrameBattlenetFrame.BroadcastButton:Point("RIGHT", FriendsFrameStatusDropDown, "LEFT", 0, 1)
	FriendsFrameBattlenetFrame.BroadcastButton:GetNormalTexture():SetTexCoord(.28, .72, .28, .72)
	FriendsFrameBattlenetFrame.BroadcastButton:GetPushedTexture():SetTexCoord(.28, .72, .28, .72)
	FriendsFrameBattlenetFrame.BroadcastButton:GetHighlightTexture():SetTexCoord(.28, .72, .28, .72)

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
