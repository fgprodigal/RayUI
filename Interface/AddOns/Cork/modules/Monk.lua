
local myname, Cork = ...
if Cork.MYCLASS ~= "MONK" then return end


-- Legacy of the Emperor
local spellname, _, icon = GetSpellInfo(115921)
local MARK, KINGS = GetSpellInfo(1126), GetSpellInfo(20217)
local GRACE, MIGHT = GetSpellInfo(116956), GetSpellInfo(19740)
Cork:GenerateRaidBuffer(spellname, icon, nil, nil, function(unit)
	-- If a druid already hit this unit, we don't need to
	if UnitAura(unit, MARK) then return true end

	-- If a pally cast Kings when he should have put up Might, overwrite it
	if UnitAura(unit, KINGS) then
		-- If either mastery buff is also present, we're good and don't need to buff
		return UnitAura(unit, MIGHT) or UnitAura(unit, GRACE)
	end
end)


-- Legacy of the White Tiger
local spellname, _, icon = GetSpellInfo(116781)
local ARCBRIL, DALBRIL = GetSpellInfo(1459), GetSpellInfo(61316)
Cork:GenerateRaidBuffer(spellname, icon, ARCBRIL, nil, function(unit)
	-- We have to account for all forms of arcane briliance, ugh
	if UnitAura(unit, DALBRIL) then return true end
end)


-- Stance
Cork:GenerateAdvancedSelfBuffer("Stance", {103985, 115069, 115070}, false, true)


-- Enlightenment (EXP boost buff)
local UnitAura = Cork.UnitAura or UnitAura
local ldb, ae = LibStub:GetLibrary("LibDataBroker-1.1"), LibStub("AceEvent-3.0")
local spellname, _, icon = GetSpellInfo(130283)
local iconline = Cork.IconLine(icon, spellname)
local dataobj = LibStub:GetLibrary("LibDataBroker-1.1"):NewDataObject("Cork "..spellname, {
	type = "cork",
	tiplink = GetSpellLink(130283),
})

function dataobj:Init()
	local level = UnitLevel('player')
	Cork.defaultspc[spellname.."-enabled"] = level >= 20 and level < 90
end

local function Test(unit)
	if not Cork.dbpc[spellname.."-enabled"] then return end
	if UnitAura("player", spellname) then return end

	-- We only need to check the level 20 quest, they all return true if any one
	-- has been completed.  It's like the fishing dailies, a random one each day.
	if IsQuestFlaggedCompleted(31840) then return end

	local level = UnitLevel('player')
	if level < 20 or level >= 90 then return end

	return iconline
end

function dataobj:Scan() self.player = Test() end

ae.RegisterEvent(dataobj, "PLAYER_UPDATE_RESTING", "Scan")
ae.RegisterEvent("Cork "..spellname, "UNIT_AURA", function(event, unit)
	if unit == "player" then dataobj.player = Test() end
end)
