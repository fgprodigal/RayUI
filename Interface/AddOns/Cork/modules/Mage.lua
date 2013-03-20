
local myname, Cork = ...
if Cork.MYCLASS ~= "MAGE" then return end


-- Armor
Cork:GenerateAdvancedSelfBuffer("Armor", {30482, 7302, 6117})


-- Arcane Brilliance
local altspellname, spellname, _, icon = GetSpellInfo(61316), GetSpellInfo(1459)
Cork:GenerateRaidBuffer(spellname, icon, altspellname, true)


-- Ice Barrier
local spellname, _, icon = GetSpellInfo(11426)
Cork:GenerateSelfBuffer(spellname, icon)


-- Water Elemental (frost pet)
local UnitAura = Cork.UnitAura or UnitAura
local ldb, ae = LibStub:GetLibrary("LibDataBroker-1.1"), LibStub("AceEvent-3.0")
local spellname, _, icon = GetSpellInfo(31687)
local iconline = Cork.IconLine(icon, spellname)

local function Init(self)
	local name = GetSpellInfo(spellname)
	Cork.defaultspc[spellname.."-enabled"] = name ~= nil
end

local function TestWithoutResting()
	if Cork.dbpc[spellname.."-enabled"] and not UnitExists('pet') then
		return iconline
	end
end

local function Test()
	return not (IsResting() and not Cork.db.debug) and TestWithoutResting()
end

local function Scan(self, ...) self.player = Test() end

local function CorkIt(self, frame)
	if self.player then
		return frame:SetManyAttributes("type1", "spell", "spell", spellname,
			"unit", "player")
	end
end

local function UNIT_PET(self, event, unit)
	if unit == "player" then self:Scan() end
end


local dataobj = ldb:NewDataObject("Cork "..spellname, {
	type      = "cork",
	tiplink   = GetSpellLink(spellname),
	Init      = Init,
	Scan      = Scan,
	CorkIt    = CorkIt,
	UNIT_PET  = UNIT_PET,
})

ae.RegisterEvent(dataobj, "UNIT_PET")
ae.RegisterEvent(dataobj, "PLAYER_UPDATE_RESTING", "Scan")
