
local myname, Cork = ...
local UnitAura = Cork.UnitAura or UnitAura
local IsSpellInRange = Cork.IsSpellInRange
local ldb, ae = LibStub:GetLibrary("LibDataBroker-1.1"), LibStub("AceEvent-3.0")


local partyunits, raidunits = {}, {}
for i=1,4 do partyunits["party"..i] = i end
for i=1,40 do raidunits["raid"..i] = i end
local function ValidUnit(unit, nopets)
	if not (unit == "player" or partyunits[unit] or raidunits[unit]) or not UnitExists(unit) or (not UnitIsConnected(unit) or UnitIsDeadOrGhost(unit) or UnitInVehicle(unit))
		or raidunits[unit] and select(3, GetRaidRosterInfo(raidunits[unit])) > Cork.RaidThresh() then return end

	return true
end


function Cork:GenerateItemBuffer(class, itemid, spellid, classspellid)
	local multiclass = type(class) == "table"
	if Cork.MYCLASS == class or multiclass and class[Cork.MYCLASS] then return end

	Cork.hasgroupspell = true

	local spellname = GetSpellInfo(spellid)
	local classspellname = GetSpellInfo(classspellid)
	local itemname = GetItemInfo(itemid)
	local icon = GetItemIcon(itemid)

	local SpellCastableOnUnit, IconLine = self.SpellCastableOnUnit, self.IconLine

	local dataobj = ldb:NewDataObject("Cork "..spellname, {type = "cork", tiplink = "item:"..itemid})

	Cork.defaultspc[spellname.."-enabled"] = true

	local hasclass
	local function TestUnit(unit)
		local _, _, _, _, _, c = GetRaidRosterInfo(unit)
		return class == c or multiclass and class[c]
	end
	local function ScanForClass()
		hasclass = false
		for i=1,GetNumGroupMembers() do if TestUnit(i) then hasclass = true; return end end
	end

	local function Test(unit)
		if hasclass or not Cork.dbpc[spellname.."-enabled"] or (IsResting() and not Cork.db.debug) or not ValidUnit(unit) or (GetItemCount(itemid) or 0) == 0 then return end
		if unit == "player" and GetNumGroupMembers() == 0 then return end

		if not (UnitAura(unit, classspellname) or UnitAura(unit, spellname)) then
			local _, token = UnitClass(unit)
			return IconLine(icon, UnitName(unit), token)
		end
	end

	function dataobj:Scan()
		ScanForClass()
		self.player = Test("player")
		for i=1,4 do self["party"..i] = Test("party"..i) end
		for i=1,40 do self["raid"..i] = Test("raid"..i) end
	end

	ae.RegisterEvent(dataobj, "GROUP_ROSTER_UPDATE", "Scan")
	ae.RegisterEvent(dataobj, "PLAYER_UPDATE_RESTING", "Scan")
	ae.RegisterEvent("Cork "..spellname, "UNIT_AURA", function(event, unit) dataobj[unit] = Test(unit) end)


	dataobj.RaidLine = IconLine(icon, spellname.." (%d)")


	local raidneeds = {}
	function dataobj:CorkIt(frame)
		if (GetItemCount(itemid) or 0) == 0 then return end

		-- Only use our item if everyone in need is in range, online and alive
		local cast = false
		for i=1,GetNumGroupMembers() do
			local unit = "raid"..i
			if select(3, GetRaidRosterInfo(i)) > Cork.RaidThresh() then
				local _, _, _, _, _, _, zone, online, dead = GetRaidRosterInfo(i)
				if not online or dead then return end
				if dataobj[unit] and (not zone or not ValidUnit(unit) or IsItemInRange(17202, unit) ~= 1) then return end
				if dataobj[unit] then cast = true end
			end
		end
		for i=1,GetNumSubgroupMembers() do
			local unit = "party"..i
			if dataobj[unit] and (not ValidUnit(unit) or IsItemInRange(17202, unit) ~= 1) then return end
			if dataobj[unit] then cast = true end
		end
		if cast then return frame:SetManyAttributes("type1", "item", "item1", "item:"..itemid) end
	end
end
