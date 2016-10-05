local R, L, P, G = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, GlobalDB
local M = R:GetModule("Misc")
local mod = M:NewModule("RaidMarker", "AceEvent-3.0")

--Cache global variables
--Lua functions
local sin, cos = math.sin, math.cos

--WoW API / Variables
local CreateFrame = CreateFrame
local GetNumGroupMembers = GetNumGroupMembers
local IsRaidLeader = IsRaidLeader
local UnitIsGroupAssistant = UnitIsGroupAssistant
local UnitExists = UnitExists
local UnitIsDead = UnitIsDead
local GetCursorPosition = GetCursorPosition
local PlaySound = PlaySound
local SetRaidTarget = SetRaidTarget
local SetRaidTargetIconTexture = SetRaidTargetIconTexture

--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: UIParent, RaidMark_HotkeyPressed, BINDING_NAME_RAIDMARKER, UIErrorsFrame, UIERRORS_HOLD_TIME

BINDING_NAME_RAIDMARKER = L["快速团队标记"]
local ButtonIsDown

function mod:RaidMarkCanMark()
    if GetNumGroupMembers() > 0 then
        if IsRaidLeader()or UnitIsGroupAssistant("player")then
            return true
        else
            UIErrorsFrame:AddMessage(L["你没有权限设置团队标记"], 1.0, 0.1, 0.1, 1.0, UIERRORS_HOLD_TIME)
            return false
        end
    else
        return true
    end
end

function mod:PLAYER_TARGET_CHANGED()
    if ButtonIsDown then
        self:RaidMarkShowIcons()
    end
end

function mod:RaidMarkShowIcons()
    if not UnitExists("target") or UnitIsDead("target")then
        return
    end
    local X, Y = GetCursorPosition()
    local Scale = UIParent:GetEffectiveScale()
    self.RaidMarkFrame:SetPoint("CENTER", R.UIParent, "BOTTOMLEFT", X / Scale, Y / Scale)
    self.RaidMarkFrame:Show()
end

function mod:RaidMarkButton_OnEnter()
    self.Texture:ClearAllPoints()
    self.Texture:SetPoint("TOPLEFT", -10, 10)
    self.Texture:SetPoint("BOTTOMRIGHT", 10, -10)
end

function mod:RaidMarkButton_OnLeave()
    self.Texture:SetAllPoints()
end

function mod:RaidMarkButton_OnClick(arg1)
    PlaySound("UChatScrollButton")
    SetRaidTarget("target", (arg1~="RightButton") and self:GetID()or 0)
    self:GetParent():Hide()
end

function RaidMark_HotkeyPressed(keystate)
    ButtonIsDown = (keystate=="down") and mod:RaidMarkCanMark()
    if ButtonIsDown then
        mod:RaidMarkShowIcons()
    else
        mod.RaidMarkFrame:Hide()
    end
end

function mod:Initialize()
    local RaidMarkFrame = CreateFrame("Frame", nil, R.UIParent)
    RaidMarkFrame:EnableMouse(true)
    RaidMarkFrame:SetSize(100, 100)
    RaidMarkFrame:SetFrameStrata("DIALOG")

    self:RegisterEvent("PLAYER_TARGET_CHANGED")

    local Button, Angle
    for i = 1, 8 do
        Button = CreateFrame("Button", "BaudMarkIconButton"..i, RaidMarkFrame)
        Button:SetSize(40, 40)
        Button:SetID(i)
        Button.Texture = Button:CreateTexture(Button:GetName().."NormalTexture", "ARTWORK");
        Button.Texture:SetTexture("Interface\\AddOns\\RayUI\\media\\raidicons.blp")
        Button.Texture:SetAllPoints()
        SetRaidTargetIconTexture(Button.Texture, i)
        Button:RegisterForClicks("LeftButtonUp","RightButtonUp")
        Button:SetScript("OnClick", mod.RaidMarkButton_OnClick)
        Button:SetScript("OnEnter", mod.RaidMarkButton_OnEnter)
        Button:SetScript("OnLeave", mod.RaidMarkButton_OnLeave)
        if(i==8)then
            Button:SetPoint("CENTER")
        else
            Angle = 360 / 7 * i
            Button:SetPoint("CENTER", sin(Angle) * 60, cos(Angle) * 60)
        end
    end

    self.RaidMarkFrame = RaidMarkFrame
end

M:RegisterMiscModule(mod:GetName())
