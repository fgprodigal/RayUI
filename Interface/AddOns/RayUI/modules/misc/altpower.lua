local R, L, P = unpack(select(2, ...)) --Inport: Engine, Locales, ProfileDB
local M = R:GetModule("Misc")

local function LoadFunc()
	local holder = CreateFrame("Frame", "AltPowerBarHolder", UIParent)
	holder:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 100)
	holder:Size(128, 50)

	PlayerPowerBarAlt:ClearAllPoints()
	PlayerPowerBarAlt:SetPoint("CENTER", holder, "CENTER")
	PlayerPowerBarAlt:SetParent(holder)
	PlayerPowerBarAlt.ignoreFramePositionManager = true
	
	R:CreateMover(holder, "AltPowerBarMover", "Alternative Power")
end

M:RegisterMiscModule("AltPower", LoadFunc)