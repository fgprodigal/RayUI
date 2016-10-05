local R, L, P, G = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, GlobalDB
local M = R:GetModule("Misc")
local mod = M:NewModule("RaidUtility", "AceEvent-3.0")
local S = R:GetModule("Skins")

--Cache global variables
--Lua functions
local _G = _G
local pairs = pairs

--WoW API / Variables
local CreateFrame = CreateFrame
local IsInInstance = IsInInstance
local GetNumSubgroupMembers = GetNumSubgroupMembers
local UnitInRaid = UnitInRaid
local UnitIsGroupLeader = UnitIsGroupLeader
local UnitIsGroupAssistant = UnitIsGroupAssistant
local InCombatLockdown = InCombatLockdown
local UninviteUnit = UninviteUnit
local GetNumGroupMembers = GetNumGroupMembers
local GetRaidRosterInfo = GetRaidRosterInfo
local UnitExists = UnitExists
local UnitName = UnitName
local LeaveParty = LeaveParty
local StaticPopup_Show = StaticPopup_Show
local InitiateRolePoll = InitiateRolePoll
local DoReadyCheck = DoReadyCheck
local ToggleFriendsFrame = ToggleFriendsFrame

--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: MAX_PARTY_MEMBERS, RaidUtilityShowButton, CLOSE, RaidUtilityCloseButton
-- GLOBALS: DisbandRaidButton, ROLE_POLL, RoleCheckButton, MAINTANK, MainTankButton
-- GLOBALS: MAINASSIST, MainAssistButton, READY_CHECK, ReadyCheckButton
-- GLOBALS: CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButton, CompactRaidFrameManagerDisplayFrameLeaderOptionsInitiateReadyCheck, CompactRaidFrameManagerDisplayFrameLeaderOptionsInitiateRolePoll, CompactRaidFrameManagerDisplayFrameLockedModeToggle, CompactRaidFrameManagerDisplayFrameHiddenModeToggle
-- GLOBALS: RAID_CONTROL, RaidControlButton, SlashCmdList, SLASH_GROUPDISBAND1, ACCEPT, CANCEL, StaticPopupDialogs

local function CheckRaidStatus()
    local inInstance, instanceType = IsInInstance()
    if ((GetNumSubgroupMembers() > 0 and not UnitInRaid("player")) or UnitIsGroupLeader("player") or UnitIsGroupAssistant("player")) and not (inInstance and (instanceType == "pvp" or instanceType == "arena")) then
        return true
    else
        return false
    end
end

function mod:CreateButton(name, parent, template, width, height, point, relativeto, point2, xOfs, yOfs, text, texture)
    local b = CreateFrame("Button", name, parent, template)
    b:SetWidth(width)
    b:SetHeight(height)
    b:SetPoint(point, relativeto, point2, xOfs, yOfs)
    b:EnableMouse(true)
    if text then
        local t = b:CreateFontString(nil,"OVERLAY",b)
        t:SetFont(R["media"].font,12)
        t:SetPoint("TOPLEFT")
        t:SetPoint("BOTTOMRIGHT")
        t:SetJustifyH("CENTER")
        t:SetText(text)
        b:SetFontString(t)
    elseif texture then
        local t = b:CreateTexture(nil,"OVERLAY",nil)
        t:SetTexture(texture)
        t:SetPoint("TOPLEFT", b, "TOPLEFT", R.mult, -R.mult)
        t:SetPoint("BOTTOMRIGHT", b, "BOTTOMRIGHT", -R.mult, R.mult)
    end
    b:SetFrameStrata("HIGH")
end

local function DisbandRaidGroup()
    if InCombatLockdown() then return end -- Prevent user error in combat

    if UnitInRaid("player") then
        for i = 1, GetNumGroupMembers() do
            local name, _, _, _, _, _, _, online = GetRaidRosterInfo(i)
            if online and name ~= R.myname then
                UninviteUnit(name)
            end
        end
    else
        for i = MAX_PARTY_MEMBERS, 1, -1 do
            if UnitExists("party"..i) then
                UninviteUnit(UnitName("party"..i))
            end
        end
    end
    LeaveParty()
end

function mod:Initialize()
    local panel_height = ((R:Scale(5)*5) + (R:Scale(20)*5))

    --Create main frame
    local RaidUtilityPanel = CreateFrame("Frame", "RaidUtilityPanel", R.UIParent)
    RaidUtilityPanel:SetFrameLevel(1)
    RaidUtilityPanel:SetHeight(panel_height)
    RaidUtilityPanel:Width(230)
    RaidUtilityPanel:SetFrameStrata("BACKGROUND")
    RaidUtilityPanel:Point("TOP", R.UIParent, "TOP", 0, 1)
    RaidUtilityPanel:SetFrameLevel(3)
    RaidUtilityPanel.toggled = false
    S:CreateBD(RaidUtilityPanel)
    S:CreateSD(RaidUtilityPanel)

    --Show Button
    self:CreateButton("RaidUtilityShowButton", R.UIParent, "UIMenuButtonStretchTemplate, SecureHandlerClickTemplate", 80, 18, "TOP", R.UIParent, "TOP", 0, 2, L["团队工具"], nil)
    RaidUtilityShowButton:SetFrameRef("RaidUtilityPanel", RaidUtilityPanel)
    RaidUtilityShowButton:SetAttribute("_onclick", [=[self:Hide(); self:GetFrameRef("RaidUtilityPanel"):Show();]=])
    RaidUtilityShowButton:SetScript("OnMouseUp", function(self) RaidUtilityPanel.toggled = true end)

    --Close Button
    self:CreateButton("RaidUtilityCloseButton", RaidUtilityPanel, "UIMenuButtonStretchTemplate, SecureHandlerClickTemplate", 80, 18, "TOP", RaidUtilityPanel, "BOTTOM", 0, -1, CLOSE, nil)
    RaidUtilityCloseButton:SetFrameRef("RaidUtilityShowButton", RaidUtilityShowButton)
    RaidUtilityCloseButton:SetAttribute("_onclick", [=[self:GetParent():Hide(); self:GetFrameRef("RaidUtilityShowButton"):Show();]=])
    RaidUtilityCloseButton:SetScript("OnMouseUp", function(self) RaidUtilityPanel.toggled = false end)

    --Disband Raid button
    self:CreateButton("DisbandRaidButton", RaidUtilityPanel, "UIMenuButtonStretchTemplate", RaidUtilityPanel:GetWidth() * 0.8, R:Scale(18), "TOP", RaidUtilityPanel, "TOP", 0, R:Scale(-5), L["解散队伍"], nil)
    DisbandRaidButton:SetScript("OnMouseUp", function(self)
            if CheckRaidStatus() then
                StaticPopup_Show("DISBAND_RAID")
            end
        end)

    --Role Check button
    self:CreateButton("RoleCheckButton", RaidUtilityPanel, "UIMenuButtonStretchTemplate", RaidUtilityPanel:GetWidth() * 0.8, R:Scale(18), "TOP", DisbandRaidButton, "BOTTOM", 0, R:Scale(-5), ROLE_POLL, nil)
    RoleCheckButton:SetScript("OnMouseUp", function(self)
            if CheckRaidStatus() then
                InitiateRolePoll()
            end
        end)

    --MainTank Button
    self:CreateButton("MainTankButton", RaidUtilityPanel, "SecureActionButtonTemplate, UIMenuButtonStretchTemplate", (DisbandRaidButton:GetWidth() / 2) - R:Scale(2), R:Scale(18), "TOPLEFT", RoleCheckButton, "BOTTOMLEFT", 0, R:Scale(-5), MAINTANK, nil)
    MainTankButton:SetAttribute("type", "maintank")
    MainTankButton:SetAttribute("unit", "target")
    MainTankButton:SetAttribute("action", "toggle")

    --MainAssist Button
    self:CreateButton("MainAssistButton", RaidUtilityPanel, "SecureActionButtonTemplate, UIMenuButtonStretchTemplate", (DisbandRaidButton:GetWidth() / 2) - R:Scale(2), R:Scale(18), "TOPRIGHT", RoleCheckButton, "BOTTOMRIGHT", 0, R:Scale(-5), MAINASSIST, nil)
    MainAssistButton:SetAttribute("type", "mainassist")
    MainAssistButton:SetAttribute("unit", "target")
    MainAssistButton:SetAttribute("action", "toggle")

    --Ready Check button
    self:CreateButton("ReadyCheckButton", RaidUtilityPanel, "UIMenuButtonStretchTemplate", RoleCheckButton:GetWidth() * 0.75, R:Scale(18), "TOPLEFT", MainTankButton, "BOTTOMLEFT", 0, R:Scale(-5), READY_CHECK, nil)
    ReadyCheckButton:SetScript("OnMouseUp", function(self)
            if CheckRaidStatus() then
                DoReadyCheck()
            end
        end)

    --Reposition/Resize and Reuse the World Marker Button
    CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButton:ClearAllPoints()
    CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButton:SetPoint("TOPRIGHT", MainAssistButton, "BOTTOMRIGHT", 0, R:Scale(-5))
    CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButton:SetParent("RaidUtilityPanel")
    CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButton:SetHeight(R:Scale(18))
    CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButton:SetWidth(RoleCheckButton:GetWidth() * 0.22)

    --Put other stuff back
    CompactRaidFrameManagerDisplayFrameLeaderOptionsInitiateReadyCheck:ClearAllPoints()
    CompactRaidFrameManagerDisplayFrameLeaderOptionsInitiateReadyCheck:SetPoint("BOTTOMLEFT", CompactRaidFrameManagerDisplayFrameLockedModeToggle, "TOPLEFT", 0, 1)
    CompactRaidFrameManagerDisplayFrameLeaderOptionsInitiateReadyCheck:SetPoint("BOTTOMRIGHT", CompactRaidFrameManagerDisplayFrameHiddenModeToggle, "TOPRIGHT", 0, 1)

    CompactRaidFrameManagerDisplayFrameLeaderOptionsInitiateRolePoll:ClearAllPoints()
    CompactRaidFrameManagerDisplayFrameLeaderOptionsInitiateRolePoll:SetPoint("BOTTOMLEFT", CompactRaidFrameManagerDisplayFrameLeaderOptionsInitiateReadyCheck, "TOPLEFT", 0, 1)
    CompactRaidFrameManagerDisplayFrameLeaderOptionsInitiateRolePoll:SetPoint("BOTTOMRIGHT", CompactRaidFrameManagerDisplayFrameLeaderOptionsInitiateReadyCheck, "TOPRIGHT", 0, 1)

    --Raid Control Panel
    self:CreateButton("RaidControlButton", RaidUtilityPanel, "UIMenuButtonStretchTemplate", RoleCheckButton:GetWidth(), R:Scale(18), "TOPLEFT", ReadyCheckButton, "BOTTOMLEFT", 0, R:Scale(-5), RAID_CONTROL, nil)
    RaidControlButton:SetScript("OnMouseUp", function(self)
            ToggleFriendsFrame(4)
        end)

    --Reskin Stuff
    do
        local buttons = {
            "CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButton",
            "DisbandRaidButton",
            "MainTankButton",
            "MainAssistButton",
            "RoleCheckButton",
            "ReadyCheckButton",
            "RaidControlButton",
            "RaidUtilityShowButton",
            "RaidUtilityCloseButton"
        }
        CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButton.SetNormalTexture = function() end
        CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButton.SetPushedTexture = function() end
        for i, button in pairs(buttons) do
            local f = _G[button]
            f.BottomLeft:SetAlpha(0)
            f.BottomRight:SetAlpha(0)
            f.BottomMiddle:SetAlpha(0)
            f.TopMiddle:SetAlpha(0)
            f.TopLeft:SetAlpha(0)
            f.TopRight:SetAlpha(0)
            f.MiddleLeft:SetAlpha(0)
            f.MiddleRight:SetAlpha(0)
            f.MiddleMiddle:SetAlpha(0)

            f:SetHighlightTexture("")
            f:SetDisabledTexture("")
            S:Reskin(f)
        end
    end

    local function ToggleRaidUtil(self, event)
        if InCombatLockdown() then
            self:RegisterEvent("PLAYER_REGEN_ENABLED")
            return
        end

        if CheckRaidStatus() then
            if RaidUtilityPanel.toggled == true then
                RaidUtilityShowButton:Hide()
                RaidUtilityPanel:Show()
            else
                RaidUtilityShowButton:Show()
                RaidUtilityPanel:Hide()
            end
        else
            RaidUtilityShowButton:Hide()
            RaidUtilityPanel:Hide()
        end

        if event == "PLAYER_REGEN_ENABLED" then
            self:UnregisterEvent("PLAYER_REGEN_ENABLED")
        end
    end

    --Automatically show/hide the frame if we have RaidLeader or RaidOfficer
    local LeadershipCheck = CreateFrame("Frame")
    LeadershipCheck:RegisterEvent("GROUP_ROSTER_UPDATE")
    LeadershipCheck:RegisterEvent("PLAYER_ENTERING_WORLD")
    LeadershipCheck:SetScript("OnEvent", ToggleRaidUtil)

    SlashCmdList["GROUPDISBAND"] = function()
        StaticPopup_Show("DISBAND_RAID")
    end
    SLASH_GROUPDISBAND1 = '/rd'

    StaticPopupDialogs["DISBAND_RAID"] = {
        text = L["是否确定解散队伍?"],
        button1 = ACCEPT,
        button2 = CANCEL,
        OnAccept = DisbandRaidGroup,
        timeout = 0,
        whileDead = 1,
    }
end

M:RegisterMiscModule(mod:GetName())
