local R, L, P, G = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB

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

G.UnitFrames.ChannelTicks = {
    --Warlock
    [SpellName(1120)] = 6, --"Drain Soul"
    [SpellName(689)] = 6, -- "Drain Life"
    [SpellName(108371)] = 6, -- "Harvest Life"
    [SpellName(5740)] = 4, -- "Rain of Fire"
    [SpellName(755)] = 6, -- Health Funnel
    [SpellName(103103)] = 4, --Malefic Grasp
    --Druid
    [SpellName(44203)] = 4, -- "Tranquility"
    [SpellName(16914)] = 10, -- "Hurricane"
    --Priest
    [SpellName(15407)] = 3, -- "Mind Flay"
    [SpellName(129197)] = 3, -- "Mind Flay (Insanity)"
    [SpellName(48045)] = 5, -- "Mind Sear"
    [SpellName(47540)] = 2, -- "Penance"
    [SpellName(64901)] = 4, -- Hymn of Hope
    [SpellName(64843)] = 4, -- Divine Hymn
    --Mage
    [SpellName(5143)] = 5, -- "Arcane Missiles"
    [SpellName(10)] = 8, -- "Blizzard"
    [SpellName(12051)] = 4, -- "Evocation"

    --Monk
    [SpellName(115175)] = 9, -- "Smoothing Mist"
}

G.UnitFrames.ChannelTicksSize = {
    --Warlock
    [SpellName(1120)] = 2, --"Drain Soul"
    [SpellName(689)] = 1, -- "Drain Life"
    [SpellName(108371)] = 1, -- "Harvest Life"
    [SpellName(103103)] = 1, -- "Malefic Grasp"
}

--Spells Effected By Haste
G.UnitFrames.HastedChannelTicks = {
    [SpellName(64901)] = true, -- Hymn of Hope
    [SpellName(64843)] = true, -- Divine Hymn
}
