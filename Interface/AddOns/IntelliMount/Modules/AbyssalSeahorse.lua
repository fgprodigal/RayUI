------------------------------------------------------------
-- AbyssalSeahorse.lua
--
-- Abin
-- 2014/11/03
------------------------------------------------------------

local IsUsableSpell = IsUsableSpell
local UnitBuff = UnitBuff

local _, addon = ...

addon:RegisterName("Abyssal Seahorse", 75207)
addon:RegisterDebugAttr("abyssalSeahorse")

addon:RegisterEventCallback("OnNewUserData", function(db)
	db.seahorseFirst = 1
end)

local SEA_LEGS = GetSpellInfo(73701) -- The buff which determines whether the player is located in Vashj'ir

addon:RegisterEventCallback("PreClick", function()
	local seahorse
	if addon.db.seahorseFirst and IsUsableSpell(75207) and UnitBuff("player", SEA_LEGS) then
		seahorse = addon:QueryName("Abyssal Seahorse")
	end

	addon:SetAttribute("abyssalSeahorse", seahorse)
end)

addon:AppendVariables([[
	local abyssalSeahorse = self:GetAttribute("abyssalSeahorse")
]])

addon:AppendConditions([[
	elseif abyssalSeahorse then
		macro = "/cast "..abyssalSeahorse
]])