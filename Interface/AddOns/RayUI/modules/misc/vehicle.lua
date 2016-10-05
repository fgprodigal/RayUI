local R, L, P, G = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, GlobalDB
local M = R:GetModule("Misc")
local mod = M:NewModule("VehicleMove")

--Cache global variables
--Lua functions
local _G = _G

--WoW API / Variables
local hooksecurefunc = hooksecurefunc

--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: VehicleSeatIndicator, VehicleSeatMover

function mod:Initialize()
    hooksecurefunc(VehicleSeatIndicator,"SetPoint",function(_,_,parent) -- vehicle seat indicator
            if (parent == "MinimapCluster") or (parent == _G["MinimapCluster"]) then
                VehicleSeatIndicator:ClearAllPoints()
                if VehicleSeatMover then
                    VehicleSeatIndicator:Point("LEFT", VehicleSeatMover, "LEFT", 0, 0)
                else
                    VehicleSeatIndicator:Point("LEFT", R.UIParent, "LEFT", 45, 120)
                    R:CreateMover(VehicleSeatIndicator, "VehicleSeatMover", L["载具指示锚点"])
                end
            end
        end)
end

M:RegisterMiscModule(mod:GetName())
