local R, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local M = R:GetModule("Misc")

local function LoadFunc()
	local autoreleasepvp = CreateFrame("frame")
	autoreleasepvp:RegisterEvent("PLAYER_DEAD")
	autoreleasepvp:SetScript("OnEvent", function(self, event)
        if not M.db.autorelease then return end
		local soulstone = GetSpellInfo(20707)
		if ((R.myclass ~= "SHAMAN") and not (soulstone and UnitBuff("player", soulstone))) then
			for i=1,5 do
				local status = GetBattlefieldStatus(i)
				if status == "active" then
					RepopMe()
					break
				end
			end
		end
	end)
end

M:RegisterMiscModule("AutoRelease", LoadFunc)
