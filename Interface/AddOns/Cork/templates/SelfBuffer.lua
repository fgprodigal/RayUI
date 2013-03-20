
local myname, Cork = ...
local UnitAura = Cork.UnitAura or UnitAura
local ldb, ae = LibStub:GetLibrary("LibDataBroker-1.1"), LibStub("AceEvent-3.0")


local function HasBuff(spells)
	for _,spell in pairs(spells) do
		if UnitAura("player", spell) then return true end
	end
end

local function Init(self)
	local name = GetSpellInfo(self.spellname)
	Cork.defaultspc[self.spellname.."-enabled"] = name ~= nil
end

local function TestWithoutResting(self)
	if Cork.dbpc[self.spellname.."-enabled"] and not HasBuff(self.spells) then
		return self.iconline
	end
end

local function Test(self)
	return not (IsResting() and not Cork.db.debug) and TestWithoutResting(self)
end

local function Scan(self, ...) self.player = self:Test() end

local function CorkIt(self, frame)
	if self.player then
		return frame:SetManyAttributes("type1", "spell", "spell", self.spellname,
			"unit", "player")
	end
end

local function UNIT_AURA(self, event, unit)
	if unit == "player" then self:Scan() end
end


function Cork:GenerateSelfBuffer(spellname, icon, ...)
	local dataobj = ldb:NewDataObject("Cork "..spellname, {
		type      = "cork",
		tiplink   = GetSpellLink(spellname),
		iconline  = self.IconLine(icon, spellname),
		spells    = {spellname, ...},
		spellname = spellname,
		Init      = Init,
		Test      = Test,
		Scan      = Scan,
		CorkIt    = CorkIt,
		UNIT_AURA = UNIT_AURA,
		TestWithoutResting = TestWithoutResting,
	})

	ae.RegisterEvent(dataobj, "UNIT_AURA")
	ae.RegisterEvent(dataobj, "PLAYER_UPDATE_RESTING", "Scan")

	return dataobj
end
