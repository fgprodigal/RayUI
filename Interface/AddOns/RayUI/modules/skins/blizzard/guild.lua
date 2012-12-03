local R, L, P = unpack(select(2, ...)) --Inport: Engine, Locales, ProfileDB
local S = R:GetModule("Skins")

local function LoadSkin()
    local r, g, b = S["media"].classcolours[R.myclass].r, S["media"].classcolours[R.myclass].g, S["media"].classcolours[R.myclass].b
    S:SetBD(GuildFrame)
    S:CreateBD(GuildMemberDetailFrame)
    S:CreateBD(GuildMemberNoteBackground, .25)
    S:CreateBD(GuildMemberOfficerNoteBackground, .25)
    S:CreateBD(GuildLogFrame)
    S:CreateBD(GuildLogContainer, .25)
    S:CreateBD(GuildNewsFiltersFrame)
    S:CreateBD(GuildTextEditFrame)
    S:CreateSD(GuildTextEditFrame)
    S:CreateBD(GuildTextEditContainer, .25)
    S:CreateBD(GuildRecruitmentInterestFrame, .25)
    S:CreateBD(GuildRecruitmentAvailabilityFrame, .25)
    S:CreateBD(GuildRecruitmentRolesFrame, .25)
    S:CreateBD(GuildRecruitmentLevelFrame, .25)
    for i = 1, 5 do
        S:CreateTab(_G["GuildFrameTab"..i])
    end
    GuildInfoMOTD:SetFontObject(GameFontNormal)
    GuildInfoDetails:SetFont(R["media"].font, 12)
    GuildFrameTabardBackground:Hide()
    GuildFrameTabardEmblem:Hide()
    GuildFrameTabardBorder:Hide()
    select(5, GuildInfoFrameInfo:GetRegions()):Hide()
    select(11, GuildMemberDetailFrame:GetRegions()):Hide()
    GuildMemberDetailCorner:Hide()
    for i = 1, 9 do
        select(i, GuildLogFrame:GetRegions()):Hide()
        select(i, GuildNewsFiltersFrame:GetRegions()):Hide()
        select(i, GuildTextEditFrame:GetRegions()):Hide()
    end
    select(2, GuildNewPerksFrame:GetRegions()):Hide()
    select(3, GuildNewPerksFrame:GetRegions()):Hide()
    GuildAllPerksFrame:GetRegions():Hide()
    GuildNewsFrame:GetRegions():Hide()
    GuildRewardsFrame:GetRegions():Hide()
    GuildNewsBossModelShadowOverlay:Hide()
    GuildPerksToggleButtonLeft:Hide()
    GuildPerksToggleButtonMiddle:Hide()
    GuildPerksToggleButtonRight:Hide()
    GuildPerksToggleButtonHighlightLeft:Hide()
    GuildPerksToggleButtonHighlightMiddle:Hide()
    GuildPerksToggleButtonHighlightRight:Hide()
    GuildPerksContainerScrollBarTrack:Hide()
    GuildNewPerksFrameHeader1:Hide()
    GuildNewsContainerScrollBarTrack:Hide()
    GuildInfoDetailsFrameScrollBarTrack:Hide()
    GuildInfoFrameInfoHeader1:SetAlpha(0)
    GuildInfoFrameInfoHeader2:SetAlpha(0)
    GuildInfoFrameInfoHeader3:SetAlpha(0)
    select(9, GuildInfoFrameInfo:GetRegions()):Hide()
    GuildRecruitmentCommentInputFrameTop:Hide()
    GuildRecruitmentCommentInputFrameTopLeft:Hide()
    GuildRecruitmentCommentInputFrameTopRight:Hide()
    GuildRecruitmentCommentInputFrameBottom:Hide()
    GuildRecruitmentCommentInputFrameBottomLeft:Hide()
    GuildRecruitmentCommentInputFrameBottomRight:Hide()
    GuildRecruitmentInterestFrameBg:Hide()
    GuildRecruitmentAvailabilityFrameBg:Hide()
    GuildRecruitmentRolesFrameBg:Hide()
    GuildRecruitmentLevelFrameBg:Hide()
    GuildRecruitmentCommentFrameBg:Hide()

    GuildFrame:DisableDrawLayer("BACKGROUND")
    GuildFrame:DisableDrawLayer("BORDER")
    GuildFrameInset:DisableDrawLayer("BACKGROUND")
    GuildFrameInset:DisableDrawLayer("BORDER")
    GuildFrameBottomInset:DisableDrawLayer("BACKGROUND")
    GuildFrameBottomInset:DisableDrawLayer("BORDER")
    GuildInfoFrameInfoBar1Left:SetAlpha(0)
    GuildInfoFrameInfoBar2Left:SetAlpha(0)
    select(2, GuildInfoFrameInfo:GetRegions()):SetAlpha(0)
    select(4, GuildInfoFrameInfo:GetRegions()):SetAlpha(0)
    GuildFramePortraitFrame:Hide()
    GuildFrameTopRightCorner:Hide()
    GuildFrameTopBorder:Hide()
    GuildRosterColumnButton1:DisableDrawLayer("BACKGROUND")
    GuildRosterColumnButton2:DisableDrawLayer("BACKGROUND")
    GuildRosterColumnButton3:DisableDrawLayer("BACKGROUND")
    GuildRosterColumnButton4:DisableDrawLayer("BACKGROUND")
    GuildAddMemberButton_RightSeparator:Hide()
    GuildControlButton_LeftSeparator:Hide()
    GuildNewsBossModel:DisableDrawLayer("BACKGROUND")
    GuildNewsBossModel:DisableDrawLayer("OVERLAY")
    GuildNewsBossNameText:SetDrawLayer("ARTWORK")
    GuildNewsBossModelTextFrame:DisableDrawLayer("BACKGROUND")
    for i = 2, 6 do
        select(i, GuildNewsBossModelTextFrame:GetRegions()):Hide()
    end

    GuildMemberRankDropdown:HookScript("OnShow", function()
        GuildMemberDetailRankText:Hide()
    end)
    GuildMemberRankDropdown:HookScript("OnHide", function()
        GuildMemberDetailRankText:Show()
    end)

    S:ReskinClose(GuildFrameCloseButton)
    S:ReskinClose(GuildNewsFiltersFrameCloseButton)
    S:ReskinClose(GuildLogFrameCloseButton)
    S:ReskinClose(GuildMemberDetailCloseButton)
    S:ReskinClose(GuildTextEditFrameCloseButton)
    S:ReskinScroll(GuildPerksContainerScrollBar)
    S:ReskinScroll(GuildRosterContainerScrollBar)
    S:ReskinScroll(GuildNewsContainerScrollBar)
    S:ReskinScroll(GuildRewardsContainerScrollBar)
    S:ReskinScroll(GuildInfoDetailsFrameScrollBar)
    S:ReskinScroll(GuildLogScrollFrameScrollBar)
    S:ReskinScroll(GuildTextEditScrollFrameScrollBar)
    S:ReskinScroll(GuildInfoFrameInfoMOTDScrollFrameScrollBar)
    GuildInfoFrameInfoMOTDScrollFrameScrollBarThumbTexture.bg:Hide()
    GuildInfoFrameInfoMOTDScrollFrameScrollBar:DisableDrawLayer("BACKGROUND")
    S:ReskinDropDown(GuildRosterViewDropdown)
    S:ReskinDropDown(GuildMemberRankDropdown)
    S:ReskinInput(GuildRecruitmentCommentInputFrame)
    GuildRecruitmentCommentInputFrame:SetWidth(312)
    GuildRecruitmentCommentEditBox:SetWidth(284)
    GuildRecruitmentCommentFrame:ClearAllPoints()
    GuildRecruitmentCommentFrame:SetPoint("TOPLEFT", GuildRecruitmentLevelFrame, "BOTTOMLEFT", 0, 1)
    S:ReskinCheck(GuildRosterShowOfflineButton)
    for i = 1, 7 do
        S:ReskinCheck(_G["GuildNewsFilterButton"..i])
    end

    local a1, p, a2, x, y = GuildNewsBossModel:GetPoint()
    GuildNewsBossModel:ClearAllPoints()
    GuildNewsBossModel:SetPoint(a1, p, a2, x+5, y)

    local f = CreateFrame("Frame", nil, GuildNewsBossModel)
    f:SetPoint("TOPLEFT", 0, 1)
    f:SetPoint("BOTTOMRIGHT", 1, -52)
    f:SetFrameLevel(GuildNewsBossModel:GetFrameLevel()-1)
    S:CreateBD(f)

    local line = CreateFrame("Frame", nil, GuildNewsBossModel)
    line:SetPoint("BOTTOMLEFT", 0, -1)
    line:SetPoint("BOTTOMRIGHT", 0, -1)
    line:SetHeight(1)
    line:SetFrameLevel(GuildNewsBossModel:GetFrameLevel()-1)
    S:CreateBD(line, 0)

    GuildNewsFiltersFrame:SetWidth(224)
    GuildNewsFiltersFrame:SetPoint("TOPLEFT", GuildFrame, "TOPRIGHT", 1, -20)
    GuildMemberDetailFrame:SetPoint("TOPLEFT", GuildFrame, "TOPRIGHT", 1, -28)
    GuildLogFrame:SetPoint("TOPLEFT", GuildFrame, "TOPRIGHT", 1, 0)

    for i = 1, 5 do
        local bu = _G["GuildInfoFrameApplicantsContainerButton"..i]
        S:CreateBD(bu, .25)
        bu:SetHighlightTexture("")
        bu:GetRegions():SetTexture(S["media"].backdrop)
        bu:GetRegions():SetVertexColor(r, g, b, .2)
    end

    GuildFactionBarProgress:SetTexture(S["media"].backdrop)
    GuildFactionBarLeft:Hide()
    GuildFactionBarMiddle:Hide()
    GuildFactionBarRight:Hide()
    GuildFactionBarShadow:Hide()
    GuildFactionBarBG:Hide()
    GuildFactionBarCap:SetAlpha(0)
    GuildFactionBar.bg = CreateFrame("Frame", nil, GuildFactionFrame)
    GuildFactionBar.bg:SetPoint("TOPLEFT", GuildFactionFrame, -1, -1)
    GuildFactionBar.bg:SetPoint("BOTTOMRIGHT", GuildFactionFrame, -3, 0)
    GuildFactionBar.bg:SetFrameLevel(0)
    S:CreateBD(GuildFactionBar.bg, .25)

    GuildXPFrame:ClearAllPoints()
    GuildXPFrame:SetPoint("TOP", GuildFrame, "TOP", 0, -40)
    GuildXPBarProgress:SetTexture(S["media"].backdrop)
    GuildXPBarLeft:Hide()
    GuildXPBarRight:Hide()
    GuildXPBarMiddle:Hide()
    GuildXPBarBG:Hide()
    GuildXPBarShadow:SetAlpha(0)
    GuildXPBarCap:SetAlpha(0)
    GuildXPBarDivider1:Hide()
    GuildXPBarDivider2:Hide()
    GuildXPBarDivider3:Hide()
    GuildXPBarDivider4:Hide()
    GuildXPBar.bg = CreateFrame("Frame", nil, GuildXPBar)
    GuildXPBar.bg:Point("TOPLEFT", GuildXPFrame, -1, -3)
    GuildXPBar.bg:Point("BOTTOMRIGHT", GuildXPFrame, 0, 1)
    GuildXPBar.bg:SetFrameLevel(0)
    S:CreateBD(GuildXPBar.bg, .25)

    local perkbuttons = {"GuildLatestPerkButton", "GuildNextPerkButton"}
    for _, button in pairs(perkbuttons) do
        local bu = _G[button]
        local ic = _G[button.."IconTexture"]
        local na = _G[button.."NameFrame"]

        na:Hide()
        ic:SetTexCoord(.08, .92, .08, .92)
        ic:SetDrawLayer("OVERLAY")
        S:CreateBG(ic)

        bu.bg = CreateFrame("Frame", nil, bu)
        bu.bg:SetPoint("TOPLEFT", 0, -1)
        bu.bg:SetPoint("BOTTOMRIGHT", 0, 2)
        bu.bg:SetFrameLevel(0)
        S:CreateBD(bu.bg, .25)
    end

    select(5, GuildLatestPerkButton:GetRegions()):Hide()
    select(6, GuildLatestPerkButton:GetRegions()):Hide()

    local reskinnedperks = false
    GuildPerksToggleButton:HookScript("OnClick", function()
        if not reskinnedperks == true then
            for i = 1, 8 do
                local button = "GuildPerksContainerButton"..i
                local bu = _G[button]
                local ic = _G[button.."IconTexture"]

                bu:DisableDrawLayer("BACKGROUND")
                bu:DisableDrawLayer("BORDER")
                bu.EnableDrawLayer = R.dummy
                ic:SetTexCoord(.08, .92, .08, .92)

                ic.bg = CreateFrame("Frame", nil, bu)
                ic.bg:SetPoint("TOPLEFT", ic, -1, 1)
                ic.bg:SetPoint("BOTTOMRIGHT", ic, 1, -1)
                S:CreateBD(ic.bg, 0)
            end
            reskinnedperks = true
        end
    end)

    local reskinnedrewards = false
    GuildFrameTab4:HookScript("OnClick", function()
        if not reskinnedrewards == true then
            for i = 1, 8 do
                local button = "GuildRewardsContainerButton"..i
                local bu = _G[button]
                local ic = _G[button.."Icon"]

                local bg = CreateFrame("Frame", nil, bu)
                bg:SetPoint("TOPLEFT", 0, -1)
                bg:SetPoint("BOTTOMRIGHT")
                S:CreateBD(bg, 0)

                bu:SetHighlightTexture(S["media"].backdrop)
                local hl = bu:GetHighlightTexture()
                hl:SetVertexColor(r, g, b, .2)
                hl:SetPoint("TOPLEFT", 0, -1)
                hl:SetPoint("BOTTOMRIGHT")

                ic:SetTexCoord(.08, .92, .08, .92)

                select(6, bu:GetRegions()):SetAlpha(0)
                select(7, bu:GetRegions()):SetTexture(S["media"].backdrop)
                select(7, bu:GetRegions()):SetVertexColor(0, 0, 0, .25)
                select(7, bu:GetRegions()):SetPoint("TOPLEFT", 0, -1)
                select(7, bu:GetRegions()):SetPoint("BOTTOMRIGHT", 0, 1)

                S:CreateBG(ic)
            end
            reskinnedrewards = true
        end
    end)

    for i = 1, 16 do
        local bu = _G["GuildRosterContainerButton"..i]
        local ic = _G["GuildRosterContainerButton"..i.."Icon"]

        bu:SetHighlightTexture(S["media"].backdrop)
        bu:GetHighlightTexture():SetVertexColor(r, g, b, .2)

        bu.bg = S:CreateBG(ic)
    end

    local function createButtonBg(bu)
        bu:SetHighlightTexture(S["media"].backdrop)
        bu:GetHighlightTexture():SetVertexColor(r, g, b, .2)
        bu.bg = S:CreateBG(bu.icon)
    end

    local tcoords = {
        ["WARRIOR"]     = {0.02, 0.23, 0.02, 0.23},
        ["MAGE"]        = {0.27, 0.47609375, 0.02, 0.23},
        ["ROGUE"]       = {0.51609375, 0.7221875, 0.02, 0.23},
        ["DRUID"]       = {0.7621875, 0.96828125, 0.02, 0.23},
        ["HUNTER"]      = {0.02, 0.23, 0.27, 0.48},
        ["SHAMAN"]      = {0.27, 0.47609375, 0.27, 0.48},
        ["PRIEST"]      = {0.51609375, 0.7221875, 0.27, 0.48},
        ["WARLOCK"]     = {0.7621875, 0.96828125, 0.27, 0.48},
        ["PALADIN"]     = {0.02, 0.23, 0.52, 0.73},
        ["DEATHKNIGHT"] = {0.27, .48, 0.52, .73},
        ["MONK"]		= {0.52, 0.71828125, 0.52, .73},
    }

    local UpdateIcons = function()
        local index
        local offset = HybridScrollFrame_GetOffset(GuildRosterContainer)
        local totalMembers, onlineMembers = GetNumGuildMembers()
        local visibleMembers = onlineMembers
        local numbuttons = #GuildRosterContainer.buttons
        if GetGuildRosterShowOffline() then
            visibleMembers = totalMembers
        end

        for i = 1, numbuttons do
            local button = GuildRosterContainer.buttons[i]
            if not button.bg then
                createButtonBg(button)
            end
            index = offset + i
            local name, _, _, _, _, _, _, _, _, _, classFileName  = GetGuildRosterInfo(index)
            if name and index <= visibleMembers then
                if button.icon:IsShown() then
                    button.icon:SetTexCoord(unpack(tcoords[classFileName]))
                    button.bg:Show()
                else
                    button.bg:Hide()
                end
            end
        end
    end

    hooksecurefunc("GuildRoster_Update", UpdateIcons)
    GuildRosterContainer:HookScript("OnMouseWheel", UpdateIcons)
    GuildRosterContainer:HookScript("OnVerticalScroll", UpdateIcons)

    GuildLevelFrame:SetAlpha(0)
    local closebutton = select(4, GuildTextEditFrame:GetChildren())
    S:Reskin(closebutton)
    local logbutton = select(3, GuildLogFrame:GetChildren())
    S:Reskin(logbutton)
    local gbuttons = {"GuildAddMemberButton", "GuildViewLogButton", "GuildControlButton", "GuildTextEditFrameAcceptButton", "GuildMemberGroupInviteButton", "GuildMemberRemoveButton", "GuildRecruitmentInviteButton", "GuildRecruitmentMessageButton", "GuildRecruitmentDeclineButton", "GuildPerksToggleButton", "GuildRecruitmentListGuildButton"}
    for i = 1, #gbuttons do
        local gbutton = _G[gbuttons[i]]
        if gbutton then
            S:Reskin(gbutton)
        end
    end

    for i = 1, 3 do
        for j = 1, 6 do
            select(j, _G["GuildInfoFrameTab"..i]:GetRegions()):Hide()
            select(j, _G["GuildInfoFrameTab"..i]:GetRegions()).Show = R.dummy
        end
    end

    local tcoords = {
        ["WARRIOR"]     = {0.02, 0.23, 0.02, 0.23},
        ["MAGE"]        = {0.27, 0.47609375, 0.02, 0.23},
        ["ROGUE"]       = {0.51609375, 0.7221875, 0.02, 0.23},
        ["DRUID"]       = {0.7621875, 0.96828125, 0.02, 0.23},
        ["HUNTER"]      = {0.02, 0.23, 0.27, 0.48},
        ["SHAMAN"]      = {0.27, 0.47609375, 0.27, 0.48},
        ["PRIEST"]      = {0.51609375, 0.7221875, 0.27, 0.48},
        ["WARLOCK"]     = {0.7621875, 0.96828125, 0.27, 0.48},
        ["PALADIN"]     = {0.02, 0.23, 0.52, 0.73},
        ["DEATHKNIGHT"] = {0.27, .48, 0.52, .73},
        ["MONK"]        = {0.52, 0.71828125, 0.52, .73},
    }

    local UpdateIcons = function()
        local index
        local offset = HybridScrollFrame_GetOffset(GuildRosterContainer)
        local totalMembers, onlineMembers, onlineAndMobileMembers = GetNumGuildMembers()
        local visibleMembers = onlineAndMobileMembers
        local numbuttons = #GuildRosterContainer.buttons
        if GetGuildRosterShowOffline() then
            visibleMembers = totalMembers
        end

        for i = 1, numbuttons do
            local bu = GuildRosterContainer.buttons[i]

            if not bu.bg then
                bu:SetHighlightTexture(S["media"].backdrop)
                bu:GetHighlightTexture():SetVertexColor(r, g, b, .2)

                bu.bg = S:CreateBG(bu.icon)
            end

            index = offset + i
            local name, _, _, _, _, _, _, _, _, _, classFileName  = GetGuildRosterInfo(index)
            if name and index <= visibleMembers and bu.icon:IsShown() then
                bu.icon:SetTexCoord(unpack(tcoords[classFileName]))
                bu.bg:Show()
            else
                bu.bg:Hide()
            end
        end
    end

    hooksecurefunc("GuildRoster_Update", UpdateIcons)
    hooksecurefunc(GuildRosterContainer, "update", UpdateIcons)
end

S:RegisterSkin("Blizzard_GuildUI", LoadSkin)
