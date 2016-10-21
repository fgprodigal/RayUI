------------------------------------------------------------
-- Dragonwrath.lua
--
-- Abin
-- 2014/10/22
------------------------------------------------------------

local GetInventoryItemID = GetInventoryItemID

local _, addon = ...

addon:RegisterName("Dragonwrath, Tarecgosa's Rest", 71086, 1)
addon:RegisterDebugAttr("dragonwrath")

local module = addon:CreateModule("Dragonwrath")

function module:OnEnable()
	self:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
	self:PLAYER_EQUIPMENT_CHANGED()
end

function module:OnDisable()
	addon:SetAttribute("dragonwrath", nil)
end

function module:PLAYER_EQUIPMENT_CHANGED()
	addon:SetAttribute("dragonwrath", GetInventoryItemID("player", 16) == 71086)
end

addon:RegisterEventCallback("OnNewUserData", function(db)
	db.dragonwrathFirst = 1
end)

addon:RegisterOptionCallback("dragonwrathFirst", function(value)
	if value then
		module:Enable()
	else
		module:Disable()
	end
end)

addon:AppendVariables([[
	local dragonwrath = self:GetAttribute("dragonwrath")
]])

addon:AppendConditions([[
	elseif dragonwrath then
		macro = "/use 16"
]])