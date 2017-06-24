----------------------------------------------------------
-- Load RayUI Environment
----------------------------------------------------------
RayUI:LoadEnv("Misc")


local M = _Misc
local mod = M:NewModule("AltPower", "AceEvent-3.0")

function mod:Initialize()
    local holder = CreateFrame("Frame", "AltPowerBarHolder", UIParent)
    holder:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 70)
    holder:Size(128, 50)

    PlayerPowerBarAlt:ClearAllPoints()
    PlayerPowerBarAlt:SetPoint("CENTER", holder, "CENTER")
    PlayerPowerBarAlt:SetParent(holder)
    PlayerPowerBarAlt.ignoreFramePositionManager = true

    hooksecurefunc(PlayerPowerBarAlt, "ClearAllPoints", function(self)
            self:SetPoint("CENTER", AltPowerBarHolder, "CENTER")
        end)

    R:CreateMover(holder, "AltPowerBarMover", L["副资源条"])
end

M:RegisterMiscModule(mod:GetName())
