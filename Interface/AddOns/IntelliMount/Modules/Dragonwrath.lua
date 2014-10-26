------------------------------------------------------------
-- Dragonwrath.lua
--
-- Abin
-- 2014/10/22
------------------------------------------------------------

local GetInventoryItemID = GetInventoryItemID

local _, addon = ...

local DRAGONWRATH = GetItemInfo(71086) -- "Dragonwrath, Tarecgosa's Rest"

--local DRAGONWRATH = "Dragonwrath, Tarecgosa's Rest" -- For taking an enUS screenshot...

function addon:GetDragonwrathName()
	if DRAGONWRATH then
		return DRAGONWRATH
	end

	DRAGONWRATH = GetItemInfo(71086)
	return DRAGONWRATH or "Hitem:71086"
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")

frame:SetScript("OnEvent", function(self, event)
	local dragonwrathEquipped
	if GetInventoryItemID("player", 16) == 71086 then
		dragonwrathEquipped = 1
	end

	if addon.dragonwrathEquipped ~= dragonwrathEquipped then
		addon.dragonwrathEquipped = dragonwrathEquipped
		addon:UpdateAttributes()
	end
end)