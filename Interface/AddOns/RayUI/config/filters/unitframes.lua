local R, L, P, G = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, GlobalDB

local function SpellName(id)
    local name = GetSpellInfo(id)
    if not name then
        R:Print("SpellID is not valid in unitframe aura list: "..id..".")
        return "Unknown"
    else
        return name
    end
end

local function Defaults(priorityOverride)
    return {["enable"] = true, ["priority"] = priorityOverride or 0, ["stackThreshold"] = 0}
end

G.UnitFrames.aurafilters = {}

G.UnitFrames.InvalidSpells = {
    [65148] = true,
}

G.UnitFrames.aurafilters["Blacklist"] = {
    [36900] = Defaults(), --Soul Split: Evil!
    [36901] = Defaults(), --Soul Split: Good
    [36893] = Defaults(), --Transporter Malfunction
    [114216] = Defaults(), --Angelic Bulwark
    [97821] = Defaults(), --Void-Touched
    [36032] = Defaults(), -- Arcane Charge
    [8733] = Defaults(), --Blessing of Blackfathom
    [57724] = Defaults(), --Sated
    [25771] = Defaults(), --forbearance
    [57723] = Defaults(), --Exhaustion
    [58539] = Defaults(), --watchers corpse
    [26013] = Defaults(), --deserter
    [71041] = Defaults(), --dungeon deserter
    [41425] = Defaults(), --"Hypothermia"
    [55711] = Defaults(), --Weakened Heart
    [8326] = Defaults(), --ghost
    [23445] = Defaults(), --evil twin
    [24755] = Defaults(), --gay homosexual tricked or treated debuff
    [25163] = Defaults(), --fucking annoying pet debuff oozeling disgusting aura
    [80354] = Defaults(), --timewarp debuff
    [95223] = Defaults(), --group res debuff
    [124275] = Defaults(), -- Stagger
    [124274] = Defaults(), -- Stagger
    [124273] = Defaults(), -- Stagger
    [117870] = Defaults(), -- Touch of The Titans
    [123981] = Defaults(), -- Perdition
    [15007] = Defaults(), -- Ress Sickness
    [113942] = Defaults(), -- Demonic: Gateway
    [89140] = Defaults(), -- Demonic Rebirth: Cooldown
    [95809] = Defaults(), --Insanity debuff (Hunter Pet heroism)
}

G.UnitFrames.aurafilters["Whitelist"] = {
    [31821] = Defaults(), -- Devotion Aura
    [2825] = Defaults(), -- Bloodlust
    [32182] = Defaults(), -- Heroism
    [80353] = Defaults(), -- Time Warp
    [90355] = Defaults(), -- Ancient Hysteria
    [47788] = Defaults(), -- Guardian Spirit
    [33206] = Defaults(), -- Pain Suppression
    [116849] = Defaults(), -- Life Cocoon
    [22812] = Defaults(), -- Barkskin
    [192132] = Defaults(), -- Mystic Empowerment: Thunder (Hyrja, Halls of Valor)
    [192133] = Defaults(), -- Mystic Empowerment: Holy (Hyrja, Halls of Valor)
}

G.UnitFrames.aurafilters["TurtleBuffs"] = {
    --Mage
    [45438] = Defaults(5), -- Ice Block
    [115610] = Defaults(), -- Temporal Shield
    --Death Knight
    [48797] = Defaults(5), -- Anti-Magic Shell
    [48792] = Defaults(), -- Icebound Fortitude
    [49039] = Defaults(), -- Lichborne
    [87256] = Defaults(4), -- Dancing Rune Weapon
    [55233] = Defaults(), -- Vampiric Blood
    [50461] = Defaults(), -- Anti-Magic Zone
    --Priest
    [33206] = Defaults(3), -- Pain Suppression
    [47788] = Defaults(), -- Guardian Spirit
    [81782] = Defaults(), -- Power Word: Barrier
    [47585] = Defaults(5), -- Dispersion
    --Warlock
    [104773] = Defaults(), -- Unending Resolve
    --[110913] = Defaults(), -- Dark Bargain
    [108359] = Defaults(), -- Dark Regeneration
    --Druid
    [22812] = Defaults(2), -- Barkskin
    [102342] = Defaults(2), -- Ironbark
    [61336] = Defaults(), -- Survival Instincts
    --Hunter
    [19263] = Defaults(5), -- Deterrence
    [53480] = Defaults(), -- Roar of Sacrifice (Cunning)
    --Rogue
    [1966] = Defaults(), -- Feint
    [31224] = Defaults(), -- Cloak of Shadows
    [74001] = Defaults(), -- Combat Readiness
    [5277] = Defaults(5), -- Evasion
    [45182] = Defaults(), -- Cheating Death
    --Shaman
    [98007] = Defaults(), -- Spirit Link Totem
    [30823] = Defaults(), -- Shamanistic Rage
    --Paladin
    [1022] = Defaults(5), -- Hand of Protection
    [6940] = Defaults(), -- Hand of Sacrifice
    [31821] = Defaults(3), -- Devotion Aura
    [498] = Defaults(2), -- Divine Protection
    [642] = Defaults(5), -- Divine Shield
    [86659] = Defaults(4), -- Guardian of the Ancient Kings (Prot)
    [31850] = Defaults(4), -- Ardent Defender
    --Warrior
    [118038] = Defaults(5), -- Die by the Sword
    [97463] = Defaults(), -- Rallying Cry
    [12975] = Defaults(), -- Last Stand
    [114029] = Defaults(2), -- Safeguard
    [871] = Defaults(3), -- Shield Wall
    [114030] = Defaults(), -- Vigilance
    --Monk
    [120954] = Defaults(2), -- Fortifying Brew
    [122783] = Defaults(), -- Diffuse Magic
    [122278] = Defaults(), -- Dampen Harm
    [116849] = Defaults(), -- Life Cocoon
    --Racial
    [20594] = Defaults(), -- Stoneform
}

G.UnitFrames.aurafilters["CCDebuffs"] = {
    -- Death Knight
    [47476] = Defaults(), --Strangulate
    [91800] = Defaults(), --Gnaw (Pet)
    [91807] = Defaults(), --Shambling Rush (Pet)
    [91797] = Defaults(), --Monstrous Blow (Pet)
    [108194] = Defaults(), --Asphyxiate
    -- Druid
    [33786] = Defaults(), --Cyclone
    [339] = Defaults(), --Entangling Roots
    [78675] = Defaults(), --Solar Beam
    [22570] = Defaults(), --Maim
    [5211] = Defaults(), --Mighty Bash
    [102359] = Defaults(), --Mass Entanglement
    [99] = Defaults(), --Disorienting Roar
    [127797] = Defaults(), --Ursol's Vortex
    [45334] = Defaults(), --Immobilized
    -- Hunter
    [3355] = Defaults(), --Freezing Trap
    [24394] = Defaults(), --Intimidation
    [64803] = Defaults(), --Entrapment
    [19386] = Defaults(), --Wyvern Sting
    [117405] = Defaults(), --Binding Shot
    [128405] = Defaults(), --Narrow Escape
    -- Mage
    [31661] = Defaults(), --Dragon's Breath
    [118] = Defaults(), --Polymorph
    [122] = Defaults(), --Frost Nova
    [82691] = Defaults(), --Ring of Frost
    [44572] = Defaults(), --Deep Freeze
    [33395] = Defaults(), --Freeze (Water Ele)
    [102051] = Defaults(), --Frostjaw
    -- Paladin
    [20066] = Defaults(), --Repentance
    [853] = Defaults(), --Hammer of Justice
    [31935] = Defaults(), --Avenger's Shield
    [105421] = Defaults(), --Blinding Light
    -- Priest
    [605] = Defaults(), --Dominate Mind
    [64044] = Defaults(), --Psychic Horror
    [8122] = Defaults(), --Psychic Scream
    [9484] = Defaults(), --Shackle Undead
    [15487] = Defaults(), --Silence
    [114404] = Defaults(), --Void Tendrils
    [88625] = Defaults(), --Holy Word: Chastise
    -- Rogue
    [2094] = Defaults(), --Blind
    [1776] = Defaults(), --Gouge
    [6770] = Defaults(), --Sap
    [1833] = Defaults(), --Cheap Shot
    [1330] = Defaults(), --Garrote - Silence
    [408] = Defaults(), --Kidney Shot
    [88611] = Defaults(), --Smoke Bomb
    -- Shaman
    [51514] = Defaults(), --Hex
    [64695] = Defaults(), --Earthgrab
    --[63685] = Defaults(), --Freeze (Frozen Power)
    [118905] = Defaults(), --Static Charge
    [118345] = Defaults(), --Pulverize (Earth Elemental)
    -- Warlock
    [710] = Defaults(), --Banish
    [6789] = Defaults(), --Mortal Coil
    [118699] = Defaults(), --Fear
    [5484] = Defaults(), --Howl of Terror
    [6358] = Defaults(), --Seduction
    [30283] = Defaults(), --Shadowfury
    [115268] = Defaults(), --Mesmerize (Shivarra)
    [89766] = Defaults(), --Axe Toss (Felguard)
    --[137143] = Defaults(), --Blood Horror
    -- Warrior
    [7922] = Defaults(), --Charge Stun
    [105771] = Defaults(), --Warbringer
    [107566] = Defaults(), --Staggering Shout
    [132168] = Defaults(), --Shockwave
    [107570] = Defaults(), --Storm Bolt
    -- Monk
    [116706] = Defaults(), --Disable
    [115078] = Defaults(), --Paralysis
    --[119392] = Defaults(), --Charging Ox Wave
    [119381] = Defaults(), --Leg Sweep
    [120086] = Defaults(), --Fists of Fury
    [140023] = Defaults(), --Ring of Peace
    -- Racial
    [25046] = Defaults(), --Arcane Torrent
    [20549] = Defaults(), --War Stomp
    [107079] = Defaults(), --Quaking Palm
}

G.UnitFrames.ChannelTicks = {
    --Warlock
    [SpellName(689)] = 6, -- "Drain Life"
    [SpellName(198590)] = 6, -- "Drain Soul"
    -- [SpellName(108371)] = 6, -- "Harvest Life"
    [SpellName(5740)] = 4, -- "Rain of Fire"
    [SpellName(755)] = 6, -- Health Funnel
    -- [SpellName(103103)] = 4, --Malefic Grasp
    --Druid
    --Priest
    [SpellName(48045)] = 5, -- "Mind Sear"
    [SpellName(179338)] = 5, -- "Searing insanity"
    [SpellName(64843)] = 4, -- Divine Hymn
    [SpellName(15407)] = 4, -- Mind Flay
    --Mage
    [SpellName(5143)] = 5, -- "Arcane Missiles"
    [SpellName(12051)] = 3, -- "Evocation"
}

local priestTier17 = {115560,115561,115562,115563,115564}
local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
f:SetScript("OnEvent", function(self, event)
        local class = select(2, UnitClass("player"))
        if strlower(class) ~= "priest" then return end

        local penanceTicks = 3
        local equippedPriestTier17 = 0
        for _, item in pairs(priestTier17) do
            if IsEquippedItem(item) then
                equippedPriestTier17 = equippedPriestTier17 + 1
            end
        end
        if equippedPriestTier17 >= 2 then
            penanceTicks = 4
        end
        R.global.UnitFrames.ChannelTicks[SpellName(47540)] = penanceTicks --Penance
    end)

G.UnitFrames.ChannelTicksSize = {
    --Warlock
    [SpellName(689)] = 1, -- "Drain Life"
    [SpellName(198590)] = 1, -- "Drain Soul"
}

--Spells Effected By Haste
G.UnitFrames.HastedChannelTicks = {

}
