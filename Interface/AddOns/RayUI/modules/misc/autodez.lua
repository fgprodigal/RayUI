local R, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local M = R:GetModule("Misc")

local function LoadFunc()
	local autogreed = CreateFrame("frame")
	autogreed:RegisterEvent("START_LOOT_ROLL")
	autogreed:SetScript("OnEvent", function(self, event, id)
        if not M.db.autodez then return end
		if UnitLevel("player") ~= MAX_PLAYER_LEVEL then return end
		local texture, name, count, quality, bop, canNeed, canGreed, canDisenchant = GetLootRollItemInfo(id)
		if id and quality == 2 and not bop then
			if canDisenchant and IsSpellKnown(13262) then
				RollOnLoot(id, 3)
			else
				RollOnLoot(id, 2)
			end
		end
	end)
end

M:RegisterMiscModule("AutoDez", LoadFunc)
