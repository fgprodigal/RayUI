local R, L, P, G = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, GlobalDB
local M = R:GetModule("Misc")
local mod = M:NewModule("AltPower", "AceEvent-3.0")

--Cache global variables
--Lua functions
--WoW API / Variables
local CreateFrame = CreateFrame
local hooksecurefunc = hooksecurefunc

--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: UIParent, PlayerPowerBarAlt, AltPowerBarHolder

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
