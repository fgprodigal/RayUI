------------------------------------------------------------
-- ShapeShifts.lua
--
-- Abin
-- 2014/10/21
------------------------------------------------------------

local IsSpellKnown = IsSpellKnown

local _, addon = ...

local TRAVEL_FORM = GetSpellInfo(783) -- Travel Form
local WOLF_FORM = GetSpellInfo(2645) -- Wolf Form

local PLAYER_CLASS = select(2, UnitClass("player"))
if PLAYER_CLASS ~= "DRUID" and PLAYER_CLASS ~= "SHAMAN" then return end

local _, addon = ...

local frame = CreateFrame("Frame")
frame:RegisterEvent("SPELLS_CHANGED")

frame:SetScript("OnEvent", function(self, event, arg1)
	if arg1 then
		return
	end

	local result
	if PLAYER_CLASS == "DRUID" then
		if IsSpellKnown(783) then
			result = TRAVEL_FORM
		end
	else
		if IsSpellKnown(2645) then
			result = WOLF_FORM
		end
	end

	if not result then
		return
	end

	self:UnregisterAllEvents() -- No longer needs to check spells anymore

	if PLAYER_CLASS == "DRUID" then
		addon.hasTravelForm = result
	end

	addon.combatShift = result
	addon:UpdateAttributes()
end)