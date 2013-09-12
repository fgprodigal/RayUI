local R, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local S = R:GetModule("Skins")

local function LoadSkin()
    TimeManagerGlobe:Hide()
    StopwatchFrameBackgroundLeft:Hide()
    select(2, StopwatchFrame:GetRegions()):Hide()
    StopwatchTabFrameLeft:Hide()
    StopwatchTabFrameMiddle:Hide()
    StopwatchTabFrameRight:Hide()

    TimeManagerStopwatchCheck:GetNormalTexture():SetTexCoord(.08, .92, .08, .92)
    TimeManagerStopwatchCheck:SetCheckedTexture(S["media"].checked)
    S:CreateBG(TimeManagerStopwatchCheck)

    TimeManagerAlarmHourDropDown:SetWidth(80)
    TimeManagerAlarmMinuteDropDown:SetWidth(80)
    TimeManagerAlarmAMPMDropDown:SetWidth(90)

    S:ReskinPortraitFrame(TimeManagerFrame, true)
    S:CreateBD(StopwatchFrame)
    S:ReskinDropDown(TimeManagerAlarmHourDropDown)
    S:ReskinDropDown(TimeManagerAlarmMinuteDropDown)
    S:ReskinDropDown(TimeManagerAlarmAMPMDropDown)
    S:ReskinInput(TimeManagerAlarmMessageEditBox)
    S:ReskinCheck(TimeManagerMilitaryTimeCheck)
    S:ReskinCheck(TimeManagerLocalTimeCheck)
    S:ReskinCheck(TimeManagerAlarmEnabledButton)
    S:ReskinClose(StopwatchCloseButton, "TOPRIGHT", StopwatchFrame, "TOPRIGHT", -2, -2)
end

S:RegisterSkin("Blizzard_TimeManager", LoadSkin)
