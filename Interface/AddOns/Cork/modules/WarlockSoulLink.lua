
local myname, Cork = ...
if Cork.MYCLASS ~= "WARLOCK" then return end

local myname, Cork = ...
local UnitAura = UnitAura
local ldb, ae = LibStub:GetLibrary("LibDataBroker-1.1"), LibStub("AceEvent-3.0")


local soul_link_enabled = select(5, GetTalentInfo(7))
if soul_link_enabled then
	local spellname, _, icon = GetSpellInfo(108415)
	local IconLine = Cork.IconLine(icon, spellname)

	local dataobj = LibStub:GetLibrary("LibDataBroker-1.1"):NewDataObject("Cork "..spellname, {type = "cork", tiplink = GetSpellLink(spellname)})

	function dataobj:Init() Cork.defaultspc[spellname.."-enabled"] = GetSpellInfo(spellname) ~= nil end

	local function Test(unit)
		if Cork.dbpc[spellname.."-enabled"] and UnitExists("pet") and not UnitIsDead("pet") and not UnitAura("pet", spellname) and UnitName("pet") ~= UNKNOWN and not IsMounted() then
			return IconLine
		end
	end

	ae.RegisterEvent("Cork "..spellname, "UNIT_PET", function(event, unit) if unit == "player" then dataobj.pet = Test() end end)
	ae.RegisterEvent("Cork "..spellname, "UNIT_AURA", function(event, unit) if unit == "pet" then dataobj.pet = Test() end end)

	function dataobj:Scan() self.pet = Test() end

	function dataobj:CorkIt(frame)
		if self.pet then return frame:SetManyAttributes("type1", "spell", "spell", spellname) end
	end
end
