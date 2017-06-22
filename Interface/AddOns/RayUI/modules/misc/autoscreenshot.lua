----------------------------------------------------------
-- Load RayUI Environment
----------------------------------------------------------
RayUI:LoadEnv("Misc")


local M = _Misc
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
