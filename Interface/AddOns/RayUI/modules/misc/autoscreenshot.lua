----------------------------------------------------------
-- Load RayUI Environment
----------------------------------------------------------
_LoadRayUIEnv_()


local M = R:GetModule("Misc")
local mod = M:NewModule("AutoScreeshot", "AceEvent-3.0")

function mod:TakeScreenshot(event, ...)
    C_Timer.After(1, Screenshot)
end

function mod:Initialize()
    if not M.db.autoscreenshot then return end
    self:RegisterEvent("ACHIEVEMENT_EARNED", "TakeScreenshot")
    self:RegisterEvent("SHOW_LOOT_TOAST_LEGENDARY_LOOTED", "TakeScreenshot")
end

M:RegisterMiscModule(mod:GetName())
