----------------------------------------------------------
-- Load RayUI Environment
----------------------------------------------------------
_LoadRayUIEnv_()


local M = R:GetModule("Misc")
local mod = M:NewModule("TimeTracker", "AceEvent-3.0")

function mod:SkinIt(bar)
    for i=1, bar:GetNumRegions() do
        local region = select(i, bar:GetRegions())
        if region:GetObjectType() == "Texture" then
            region:SetTexture(nil)
        elseif region:GetObjectType() == "FontString" then
            region:SetFont(R["media"].font,R["media"].fontsize, "THINOUTLINE")
            region:SetShadowColor(0,0,0,0)
        end
    end

    bar:SetStatusBarTexture(R["media"].normal)
    bar:SetStatusBarColor(95/255, 182/255, 255/255)
	R:SetStatusBarGradient(bar)
    bar:Height(18)

    local spark = bar:CreateTexture(nil, "OVERLAY")
    spark:SetTexture[[Interface\CastingBar\UI-CastingBar-Spark]]
    spark:SetBlendMode("ADD")
    spark:SetAlpha(.8)
    spark:Point("TOPLEFT", bar:GetStatusBarTexture(), "TOPRIGHT", -10, 13)
    spark:Point("BOTTOMRIGHT", bar:GetStatusBarTexture(), "BOTTOMRIGHT", 10, -13)

    bar:CreateShadow("Background")
end

function mod:START_TIMER(event)
    for _, b in pairs(TimerTracker.timerList) do
        if b["bar"] and not b["bar"].skinned then
            self:SkinIt(b["bar"])
            b["bar"].skinned = true
        end
    end
end

function mod:Initialize()
    --Dummy Bar
    --/run TimerTracker_OnLoad(TimerTracker); TimerTracker_OnEvent(TimerTracker, "START_TIMER", 1, 30, 30)
    self:RegisterEvent("START_TIMER")
end

M:RegisterMiscModule(mod:GetName())
