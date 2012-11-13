local R, L, P, G = unpack(select(2, ...)) --Inport: Engine, Locales, ProfileDB

local function SpellName(id)
	local name = GetSpellInfo(id)
	if not name then
		R:Print("SpellID is not valid in raid aura list: "..id..".")
		return "Unknown"
	else
		return name
	end
end

G.UnitFrames.aurafilters = {}

G.UnitFrames.InvalidSpells = {
	[65148] = true,
}

G.UnitFrames.aurafilters["Blacklist"] = {
    [SpellName(36032)] = true, -- Arcane Charge
    [SpellName(76691)] = true, -- Vengeance
    [SpellName(8733)] = true, --Blessing of Blackfathom
    [SpellName(57724)] = true, --Sated
    [SpellName(25771)] = true, --forbearance
    [SpellName(57723)] = true, --Exhaustion
    [SpellName(36032)] = true, --arcane blast
    [SpellName(58539)] = true, --watchers corpse
    [SpellName(26013)] = true, --deserter
    [SpellName(6788)] = true, --weakended soul
    [SpellName(71041)] = true, --dungeon deserter
    [SpellName(41425)] = true, --"Hypothermia"
    [SpellName(55711)] = true, --Weakened Heart
    [SpellName(8326)] = true, --ghost
    [SpellName(23445)] = true, --evil twin
    [SpellName(24755)] = true, --gay homosexual tricked or treated debuff
    [SpellName(25163)] = true, --fucking annoying pet debuff oozeling disgusting aura
    [SpellName(80354)] = true, --timewarp debuff
    [SpellName(95223)] = true, --group res debuff		
}

G.UnitFrames.aurafilters["Whitelist"] = {
    [SpellName(2825)] = true, -- Bloodlust
    [SpellName(32182)] = true, -- Heroism	
    [SpellName(80353)] = true, --Time Warp
    [SpellName(90355)] = true, --Ancient Hysteria		
}
