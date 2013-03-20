
local myname, Cork = ...
local UnitAura = Cork.UnitAura or UnitAura
local IsSpellInRange = Cork.IsSpellInRange
local ldb, ae = LibStub:GetLibrary("LibDataBroker-1.1"), LibStub("AceEvent-3.0")


local blist = {npc = true, vehicle = true}
for i=1,5 do blist["arena"..i], blist["arenapet"..i] = true, true end

local MagicClasses = {["DRUID"] = true, ["MAGE"] = true, ["PALADIN"] = true, ["PRIEST"] = true, ["SHAMAN"] = true, ["WARLOCK"] = true}

-- Create a raid buffing module.  This module will try to make sure all group
-- members have this buff
--
--      spellname - the name of our spell (give a localized one!)
--           icon - the icon to show in the tip
--   altspellname - name of other buff that fills this need, like Kings and Mark
-- manausers_only - this buff is useless to folks without mana, ignore them
--     extra_test - an extra check not covered in the generator.  If this
--                  returns false and other conditions are not met, the need is
--                  displayed.  Return true if the need is filled.
function Cork:GenerateRaidBuffer(spellname, icon, altspellname, manausers_only, extra_test)
	local SpellCastableOnUnit, IconLine = self.SpellCastableOnUnit, self.IconLine

	local dataobj = ldb:NewDataObject("Cork "..spellname, {type = "cork", tiplink = GetSpellLink(spellname)})

	function dataobj:Init()
		Cork.defaultspc[spellname.."-enabled"] = GetSpellInfo(spellname) ~= nil
	end

	local function Test(unit)
		if not Cork.dbpc[spellname.."-enabled"] or (IsResting() and not Cork.db.debug) or not Cork:ValidUnit(unit) then return end

		if not UnitAura(unit, spellname) and (not altspellname or not UnitAura(unit, altspellname)) and (not extra_test or not extra_test(unit)) then
			local _, token = UnitClass(unit)
			if not manausers_only or MagicClasses[token] then return IconLine(icon, UnitName(unit), token) end
		end
	end
	Cork:RegisterRaidEvents(spellname, dataobj, Test)
	dataobj.Scan = Cork:GenerateRaidScan(Test)

	ae.RegisterEvent(dataobj, "PLAYER_UPDATE_RESTING", "Scan")


	dataobj.RaidLine = IconLine(icon, spellname.." (%d)")


	function dataobj:CorkIt(frame)
		local spell = altspellname and GetSpellInfo(altspellname) or spellname
		if self.player and SpellCastableOnUnit(spell, "player") then return frame:SetManyAttributes("type1", "spell", "spell", spell, "unit", "player") end
		for unit in ldb:pairs(self) do if SpellCastableOnUnit(spell, unit) then return frame:SetManyAttributes("type1", "spell", "spell", spell, "unit", unit) end end
	end
end

local raidunits, partyunits, otherunits = {}, {}, { ["player"] = true, ["target"] = true, ["focus"] = true }
for i=1,40 do raidunits["raid"..i] = i end
for i=1,4 do partyunits["party"..i] = i end
function Cork:ValidUnit(unit)
	if blist[unit] or not UnitExists(unit) or (UnitIsPlayer(unit) and (not UnitIsConnected(unit) or UnitIsDeadOrGhost(unit) or UnitInVehicle(unit)))
		or (UnitPlayerControlled(unit) and not UnitIsPlayer(unit)) -- No pets, ever
		or (unit ~= "player" and UnitIsUnit(unit, "player"))
		or (unit == "target" and (UnitIsUnit("target", "focus") or not UnitCanAssist("player", unit) or not UnitIsPlayer(unit) or UnitIsEnemy("player", unit)))
		or (unit == "focus" and not UnitCanAssist("player", unit))
		or (IsInRaid() and partyunits[unit])
		or raidunits[unit] and select(3, GetRaidRosterInfo(raidunits[unit])) > Cork.RaidThresh() then return end

	return true
end
local function isScanUnit(unit)
	return not not (raidunits[unit] or partyunits[unit] or otherunits[unit])
end


function Cork:RegisterRaidEvents(spellname, dataobj, Test)
	local function TestUnit(event, unit) if isScanUnit(unit) then dataobj[unit] = Test(unit) end end
	ae.RegisterEvent("Cork "..spellname, "UNIT_AURA", TestUnit)
	ae.RegisterEvent("Cork "..spellname, "UNIT_DYNAMIC_FLAGS", TestUnit)
	ae.RegisterEvent("Cork "..spellname, "UNIT_ENTERED_VEHICLE", TestUnit)
	ae.RegisterEvent("Cork "..spellname, "UNIT_EXITED_VEHICLE", TestUnit)
	ae.RegisterEvent("Cork "..spellname, "UNIT_FLAGS", TestUnit)
	ae.RegisterEvent("Cork "..spellname, "GROUP_ROSTER_UPDATE", function()
		for k, _ in pairs(partyunits) do dataobj[k] = Test(k) end
		for k, _ in pairs(raidunits) do dataobj[k] = Test(k) end
	end)
	local function TestTargetandFocus() dataobj.target, dataobj.focus = Test("target"), Test("focus") end
	ae.RegisterEvent("Cork "..spellname, "PLAYER_TARGET_CHANGED", TestTargetandFocus)
	ae.RegisterEvent("Cork "..spellname, "PLAYER_FOCUS_CHANGED", TestTargetandFocus)
end


function Cork:GenerateRaidScan(Test)
	return function(self)
		for k, _ in pairs(otherunits) do self[k] = Test(k) end
		for k, _ in pairs(partyunits) do self[k] = Test(k) end
		for k, _ in pairs(raidunits) do self[k] = Test(k) end
	end
end
