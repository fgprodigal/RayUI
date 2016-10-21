------------------------------------------------------------
-- ShapeShifts.lua
--
-- Abin
-- 2014/10/21
------------------------------------------------------------

local IsSpellKnown = IsSpellKnown

local _, addon = ...

addon:RegisterName("Travel Form", 783)
addon:RegisterName("Cat Form", 768)
addon:RegisterName("Ghost Wolf", 2645)

addon:RegisterDebugAttr("indoorForm")
addon:RegisterDebugAttr("combatForm")
addon:RegisterDebugAttr("travelForm")

addon:RegisterEventCallback("OnNewUserData", function(db)
	db.travelFormFirst = 1
end)

if addon.class ~= "DRUID" and addon.class ~= "SHAMAN" then return end

local IS_DRUID = addon.class == "DRUID"
local CAT_FORM = addon:QueryName("Cat Form")
local GHOST_WOLF = addon:QueryName("Ghost Wolf")
local TRAVEL_FORM = addon:QueryName("Travel Form")

local hasTravelForm

if IS_DRUID then
	addon:AppendPreSumRandom("/cancelform [form:1/2]") -- Druids must cancel bear/cat forms before summoning mounts
	addon:SetAttribute("indoorForm", CAT_FORM)
else
	addon:SetAttribute("indoorForm", GHOST_WOLF)
end

local module = addon:CreateModule("ShapeShifts")

function module:OnInitialize()
	self:Enable()
end

function module:OnEnable()
	self:RegisterEvent("SPELLS_CHANGED")
	self:SPELLS_CHANGED()
end

function module:SPELLS_CHANGED(arg1)
	if arg1 then
	elseif IS_DRUID then
		hasTravelForm = 1
		addon:SetAttribute("travelForm", TRAVEL_FORM)
		addon:SetAttribute("combatForm", TRAVEL_FORM)
		addon:SetAttribute("combatForm", CAT_FORM)
	else
		addon:SetAttribute("combatForm", GHOST_WOLF)
	end
end

addon:RegisterOptionCallback("travelFormFirst", function(value)
	if value and hasTravelForm then
		addon:SetAttribute("travelForm", TRAVEL_FORM)
	else
		addon:SetAttribute("travelForm", nil)
	end
end)

addon:AppendVariables([[
	local indoorForm = self:GetAttribute("indoorForm")
	local combatForm = self:GetAttribute("combatForm")
	local travelForm = self:GetAttribute("travelForm")
]])

addon:AppendConditions([[
	elseif indoorForm and isIndoor then
		macro = "/cast "..indoorForm
	elseif combatForm and isInCombat then
		macro = "/cast "..combatForm
	elseif travelForm and (isFlyable or isSwimming) then
		macro = "/cast "..travelForm
]])

