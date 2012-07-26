local R, L, P = unpack(select(2, ...)) --Inport: Engine, Locales, ProfileDB
local M = R:GetModule("Misc")

local function LoadFunc()
	if not M.db.autorelease then return end

	local autoreleasepvp = CreateFrame("frame")
	autoreleasepvp:RegisterEvent("PLAYER_DEAD")
	autoreleasepvp:SetScript("OnEvent", function(self, event)
		local soulstone = GetSpellInfo(20707)
		if ((R.myclass ~= "SHAMAN") and not (soulstone and UnitBuff("player", soulstone))) and BattlefieldMinimap.status == "active" then
			RepopMe()
		end
	end)
end

M:RegisterMiscModule("AutoRelease", LoadFunc)