------------------------------------------------------------
-- Halloween.lua
--
-- Abin
-- 2014/10/21
------------------------------------------------------------

local GetItemCount = GetItemCount

local _, addon = ...

local MAGIC_BROOM = GetSpellInfo(47977) -- Magic Broom

local TODAY = tonumber(date("%m")..date("%d"))

if TODAY < 1018 or TODAY > 1101 then return end -- Only check magic broom during Halloween

local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:RegisterEvent("BAG_UPDATE")

frame:SetScript("OnEvent", function(self, event)
	local name
	if GetItemCount(37011) > 0 then
		name = MAGIC_BROOM
	end

	if addon.hasBroom ~= name then
		addon.hasBroom = name
		addon:UpdateAttributes()
	end
end)