local R, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local M = R:GetModule("Misc")
local mod = M:NewModule("VehicleMove")

function mod:Initialize()
	hooksecurefunc(VehicleSeatIndicator,"SetPoint",function(_,_,parent) -- vehicle seat indicator
		if (parent == "MinimapCluster") or (parent == _G["MinimapCluster"]) then
			VehicleSeatIndicator:ClearAllPoints()
			if VehicleSeatMover then
				VehicleSeatIndicator:Point("LEFT", VehicleSeatMover, "LEFT", 0, 0)
			else
				VehicleSeatIndicator:Point("LEFT", UIParent, "LEFT", 45, 120)
				R:CreateMover(VehicleSeatIndicator, "VehicleSeatMover", L["载具指示锚点"])
			end
		end
	end)
end

M:RegisterMiscModule(mod:GetName())