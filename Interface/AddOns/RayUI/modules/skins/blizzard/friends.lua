local R, L, P, G = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, GlobalDB
local S = R:GetModule("Skins")

local FRIENDS_LEVEL_TEMPLATE = FRIENDS_LEVEL_TEMPLATE:gsub('%%d', '%%s')
FRIENDS_LEVEL_TEMPLATE = FRIENDS_LEVEL_TEMPLATE:gsub('%$d', '%$s')

local BC = {}

for k, v in pairs(LOCALIZED_CLASS_NAMES_MALE) do
    BC[v] = k
end

for k, v in pairs(LOCALIZED_CLASS_NAMES_FEMALE) do
    BC[v] = k
end

local function getDiffColorString(level)
    local color = GetQuestDifficultyColor(level)
    return R:RGBToHex(color.r, color.g, color.b)
end

local function getClassColorString(class)
    local color = R.colors.class[BC[class] or class]
    return R:RGBToHex(color.r, color.g, color.b)
end

local function updateFriendsColor()
    local scrollFrame = FriendsFrameFriendsScrollFrame
    local offset = HybridScrollFrame_GetOffset(scrollFrame)
    local buttons = scrollFrame.buttons

    local playerArea = GetRealZoneText()

    for i = 1, #buttons do
        local nameText, infoText, button, index
        button = buttons[i]
        index = offset + i
        if(button:IsShown()) then
            if ( button.buttonType == FRIENDS_BUTTON_TYPE_WOW ) then
                local name, level, class, area, connected, status, note = GetFriendInfo(button.id)
                if(connected) then
                    nameText = getClassColorString(class) .. name.."|r, "..format(FRIENDS_LEVEL_TEMPLATE, getDiffColorString(level) .. level .. '|r', class)
                    if(area == playerArea) then
                        infoText = format('|cff00ff00%s|r', area)
                    end
                end
            elseif (button.buttonType == FRIENDS_BUTTON_TYPE_BNET) then
                local presenceID, presenceName, battleTag, isBattleTagPresence, toonName, toonID, client, isOnline, lastOnline, isAFK, isDND, messageText, noteText, isRIDFriend, messageTime, canSoR = BNGetFriendInfo(button.id)
                if(isOnline and client==BNET_CLIENT_WOW) then
                    local hasFocus, toonName, client, realmName, realmID, faction, race, class, guild, zoneName, level, gameText, broadcastText, broadcastTime = BNGetGameAccountInfo(toonID)
                    if(presenceName and toonName and class) then
                        nameText = presenceName .. ' ' .. FRIENDS_WOW_NAME_COLOR_CODE..'('..
                        getClassColorString(class) .. toonName .. FRIENDS_WOW_NAME_COLOR_CODE .. ')'
                        if(zoneName == playerArea) then
                            infoText = format('|cff00ff00%s|r', zoneName)
                        end
                    end
                end
            end
        end

        if(nameText) then
            button.name:SetText(nameText)
        end
        if(infoText) then
            button.info:SetText(infoText)
        end
    end
end

local function LoadSkin()
    local StripAllTextures = {
        "ScrollOfResurrectionSelectionFrame",
        "ScrollOfResurrectionSelectionFrameList",
        "FriendsListFrame",
        "FriendsTabHeader",
        "FriendsFrameFriendsScrollFrame",
        "WhoFrameColumnHeader1",
        "WhoFrameColumnHeader2",
        "WhoFrameColumnHeader3",
        "WhoFrameColumnHeader4",
        "ChannelListScrollFrame",
        "ChannelRoster",
        "ChannelFrameDaughterFrame",
        "AddFriendFrame",
        "AddFriendNoteFrame",
    }

    local KillTextures = {
        "FriendsFrameBroadcastInputLeft",
        "FriendsFrameBroadcastInputRight",
        "FriendsFrameBroadcastInputMiddle",
    }

    FriendsFrameInset:StripTextures()
    WhoFrameListInset:StripTextures()
    WhoFrameEditBoxInset:StripTextures()
    ChannelFrameRightInset:StripTextures()
    ChannelFrameLeftInset:StripTextures()
    LFRQueueFrameListInset:StripTextures()
    LFRQueueFrameRoleInset:StripTextures()
    LFRQueueFrameCommentInset:StripTextures()

    for _, texture in pairs(KillTextures) do
        _G[texture]:Kill()
    end

    for _, object in pairs(StripAllTextures) do
        _G[object]:StripTextures()
    end

    for i=1, FriendsFrame:GetNumRegions() do
        local region = select(i, FriendsFrame:GetRegions())
        if region:GetObjectType() == "Texture" then
            region:SetTexture(nil)
            region:SetAlpha(0)
        end
    end

    --Who Frame
    local function UpdateWhoSkins()
        WhoListScrollFrame:StripTextures()
    end
    --Channel Frame
    local function UpdateChannel()
        ChannelRosterScrollFrame:StripTextures()
    end

    ChannelFrame:HookScript("OnShow", UpdateChannel)
    hooksecurefunc("FriendsFrame_OnEvent", UpdateChannel)

    WhoFrame:HookScript("OnShow", UpdateWhoSkins)
    hooksecurefunc("FriendsFrame_OnEvent", UpdateWhoSkins)

    WhoFrameColumn_SetWidth(WhoFrameColumnHeader3, 37)

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
    FriendsFriendsFrame:StripTextures()
    FriendsFriendsList:StripTextures()
    S:SetBD(FriendsFriendsFrame)
    S:CreateBD(FriendsFriendsList)
    S:Reskin(FriendsFriendsSendRequestButton)
    S:Reskin(FriendsFriendsCloseButton)

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
        "FriendsFrameAddFriendButton",
        "FriendsFrameSendMessageButton",
        "WhoFrameWhoButton",
        "WhoFrameAddFriendButton",
        "WhoFrameGroupInviteButton",
        "ChannelFrameNewButton",
        "FriendsFrameIgnorePlayerButton",
        "FriendsFrameUnsquelchButton",
        "ChannelFrameDaughterFrameOkayButton",
        "ChannelFrameDaughterFrameCancelButton",
        "AddFriendEntryFrameAcceptButton",
        "AddFriendEntryFrameCancelButton",
        "AddFriendInfoFrameContinueButton",
        "ScrollOfResurrectionSelectionFrameAcceptButton",
        "ScrollOfResurrectionSelectionFrameCancelButton",
    }
    for i = 1, #buttons do
        local button = _G[buttons[i]]
        S:Reskin(button)
    end

    for i = 1, FRIENDS_TO_DISPLAY do
        local bu = _G["FriendsFrameFriendsScrollFrameButton"..i]
        local ic = _G["FriendsFrameFriendsScrollFrameButton"..i.."GameIcon"]
        local inv = _G["FriendsFrameFriendsScrollFrameButton"..i.."TravelPassButton"]
        local summon = _G["FriendsFrameFriendsScrollFrameButton"..i.."SummonButton"]
        bu:SetHighlightTexture(R["media"].gloss)
        bu:GetHighlightTexture():SetVertexColor(.24, .56, 1, .2)

        ic:Size(22, 22)
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
    S:SetBD(AddFriendFrame)

    -- Battletag invite frame
    -- for i = 1, 9 do
    -- select(i, BattleTagInviteFrame.NoteFrame:GetRegions()):Hide()
    -- end

    S:CreateBD(BattleTagInviteFrame)
    S:CreateSD(BattleTagInviteFrame)
    -- S:CreateBD(BattleTagInviteFrame.NoteFrame, .25)

    local send, cancel = BattleTagInviteFrame:GetChildren()
    S:Reskin(send)
    S:Reskin(cancel)

    FriendsTabHeaderRecruitAFriendButton:SetTemplate("Default")
    FriendsTabHeaderRecruitAFriendButton:StyleButton(true)
    FriendsTabHeaderRecruitAFriendButtonIcon:SetDrawLayer("OVERLAY")
    FriendsTabHeaderRecruitAFriendButtonIcon:SetTexCoord(.08, .92, .08, .92)
    S:CreateBG(FriendsTabHeaderRecruitAFriendButtonIcon)

    local RecruitAFriendFrame = RecruitAFriendFrame
    local RecruitAFriendSentFrame = RecruitAFriendSentFrame

    RecruitAFriendFrame.NoteFrame:DisableDrawLayer("BACKGROUND")

    S:CreateBD(RecruitAFriendFrame)
    S:ReskinClose(RecruitAFriendFrameCloseButton)
    S:Reskin(RecruitAFriendFrame.SendButton)
    S:ReskinInput(RecruitAFriendNameEditBox)

    S:CreateBDFrame(RecruitAFriendFrame.NoteFrame, .25)

    S:CreateBD(RecruitAFriendSentFrame)
    S:Reskin(RecruitAFriendSentFrame.OKButton)
    S:ReskinClose(RecruitAFriendSentFrameCloseButton)

    --Quick join
    S:ReskinScroll(QuickJoinScrollFrameScrollBar)
    S:Reskin(QuickJoinFrame.JoinQueueButton)
    QuickJoinFrame.JoinQueueButton:SetSize(131, 21) --Match button on other tab
    QuickJoinFrame.JoinQueueButton:ClearAllPoints()
    QuickJoinFrame.JoinQueueButton:Point("BOTTOMRIGHT", QuickJoinFrame, "BOTTOMRIGHT", -6, 4)
    QuickJoinScrollFrameTop:SetTexture(nil)
    QuickJoinScrollFrameBottom:SetTexture(nil)
    QuickJoinScrollFrameMiddle:SetTexture(nil)

    hooksecurefunc(FriendsFrameFriendsScrollFrame, "update", updateFriendsColor)
    hooksecurefunc("FriendsFrame_UpdateFriends", updateFriendsColor)
end

S:AddCallback("Friends", LoadSkin)
