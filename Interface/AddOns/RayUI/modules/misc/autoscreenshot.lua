local R, L, P, G = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, GlobalDB
local M = R:GetModule("Misc")
local mod = M:NewModule("AutoScreeshot", "AceEvent-3.0")

--Cache global variables
--Lua functions
--WoW API / Variables
local Screenshot = Screenshot
local C_Timer = C_Timer

function mod:TakeScreenshot(event, ...)
    C_Timer.After(1.2, Screenshot)
end

function mod:Initialize()
    if not M.db.autoscreenshot then return end
    self:RegisterEvent("ACHIEVEMENT_EARNED", "TakeScreenshot")
    self:RegisterEvent("SHOW_LOOT_TOAST_LEGENDARY_LOOTED", "TakeScreenshot")
end

M:RegisterMiscModule(mod:GetName())
