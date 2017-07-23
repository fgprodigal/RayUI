----------------------------------------------------------
-- Load RayUI Environment
----------------------------------------------------------
RayUI:LoadEnv("UnitFrames")


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

_AuraFilters = {}
P.UnitFrames.aurafilters = _AuraFilters

_InvalidSpells = {
    [65148] = true,
}

_AuraFilters["Blacklist"] = {
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

_AuraFilters["Whitelist"] = {
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

_AuraFilters["TurtleBuffs"] = {
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

_AuraFilters["CCDebuffs"] = {
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

_ChannelTicks = {
    --Warlock
    [SpellName(198590)] = 6, -- "Drain Soul"
    -- [SpellName(108371)] = 6, -- "Harvest Life"
    [SpellName(5740)] = 4, -- "Rain of Fire"
    [SpellName(755)] = 6, -- Health Funnel
    -- [SpellName(103103)] = 4, --Malefic Grasp
    --Druid
    --Priest
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
        _ChannelTicks[SpellName(47540)] = penanceTicks --Penance
    end)

_ChannelTicksSize = {
    --Warlock
    [SpellName(198590)] = 1, -- "Drain Soul"
}

--Spells Effected By Haste
_HastedChannelTicks = {

}

_SpellRangeCheck = {
    ["PRIEST"] = {
        ["enemySpells"] = {
            [585] = true, -- Smite (40 yards)
            [589] = true, -- Shadow Word: Pain (40 yards)
        },
        ["longEnemySpells"] = {},
        ["friendlySpells"] = {
            [2061] = true, -- Flash Heal (40 yards)
            [17] = true, -- Power Word: Shield (40 yards)
        },
        ["resSpells"] = {
            [2006] = true, -- Resurrection (40 yards)
        },
        ["petSpells"] = {},
    },
    ["DRUID"] = {
        ["enemySpells"] = {
            [8921] = true, -- Moonfire (40 yards, all specs, lvl 3)
        },
        ["longEnemySpells"] = {},
        ["friendlySpells"] = {
            [8936] = true, -- Regrowth (40 yards, all specs, lvl 5)
        },
        ["resSpells"] = {
            [50769] = true, -- Revive (40 yards, all specs, lvl 14)
        },
        ["petSpells"] = {},
    },
    ["PALADIN"] = {
        ["enemySpells"] = {
            [20271] = true, -- Judgement (30 yards)
        },
        ["longEnemySpells"] = {
            [20473] = true, -- Holy Shock (40 yards)
        },
        ["friendlySpells"] = {
            [19750] = true, -- Flash of Light (40 yards)
        },
        ["resSpells"] = {
            [7328] = true, -- Redemption (40 yards)
        },
        ["petSpells"] = {},
    },
    ["SHAMAN"] = {
        ["enemySpells"] = {
            [188196] = true, -- Lightning Bolt (Elemental) (40 yards)
            [187837] = true, -- Lightning Bolt (Enhancement) (40 yards)
            [403] = true, -- Lightning Bolt (Resto) (40 yards)
        },
        ["longEnemySpells"] = {},
        ["friendlySpells"] = {
            [8004] = true, -- Healing Surge (Resto/Elemental) (40 yards)
            [188070] = true, -- Healing Surge (Enhancement) (40 yards)
        },
        ["resSpells"] = {
            [2008] = true, -- Ancestral Spirit (40 yards)
        },
        ["petSpells"] = {},
    },
    ["WARLOCK"] = {
        ["enemySpells"] = {
            [5782] = true, -- Fear (30 yards)
        },
        ["longEnemySpells"] = {
            [234153] = true, -- Drain Life (40 yards)
            [198590] = true, --Drain Soul (40 yards)
            [232670] = true, --Shadow Bolt (40 yards, lvl 1 spell)
            [686] = true, --Shadow Bolt (Demonology) (40 yards, lvl 1 spell)
        },
        ["friendlySpells"] = {
            [20707] = true, -- Soulstone (40 yards)
        },
        ["resSpells"] = {},
        ["petSpells"] = {
            [755] = true, -- Health Funnel (45 yards)
        },
    },
    ["MAGE"] = {
        ["enemySpells"] = {
            [118] = true, -- Polymorph (30 yards)
        },
        ["longEnemySpells"] = {
            [116] = true, -- Frostbolt (Frost) (40 yards)
            [44425] = true, -- Arcane Barrage (Arcane) (40 yards)
            [133] = true, -- Fireball (Fire) (40 yards)
        },
        ["friendlySpells"] = {
            [130] = true, -- Slow Fall (40 yards)
        },
        ["resSpells"] = {},
        ["petSpells"] = {},
    },
    ["HUNTER"] = {
        ["enemySpells"] = {
            [75] = true, -- Auto Shot (40 yards)
        },
        ["longEnemySpells"] = {},
        ["friendlySpells"] = {},
        ["resSpells"] = {},
        ["petSpells"] = {
            [982] = true, -- Mend Pet (45 yards)
        },
    },
    ["DEATHKNIGHT"] = {
        ["enemySpells"] = {
            [49576] = true, -- Death Grip
        },
        ["longEnemySpells"] = {
            [47541] = true, -- Death Coil (Unholy) (40 yards)
        },
        ["friendlySpells"] = {},
        ["resSpells"] = {
            [61999] = true, -- Raise Ally (40 yards)
        },
        ["petSpells"] = {},
    },
    ["ROGUE"] = {
        ["enemySpells"] = {
            [185565] = true, -- Poisoned Knife (Assassination) (30 yards)
            [185763] = true, -- Pistol Shot (Outlaw) (20 yards)
            [114014] = true, -- Shuriken Toss (Sublety) (30 yards)
            [1725] = true, -- Distract (30 yards)
        },
        ["longEnemySpells"] = {},
        ["friendlySpells"] = {
            [57934] = true, -- Tricks of the Trade (100 yards)
        },
        ["resSpells"] = {},
        ["petSpells"] = {},
    },
    ["WARRIOR"] = {
        ["enemySpells"] = {
            [5246] = true, -- Intimidating Shout (Arms/Fury) (8 yards)
            [100] = true, -- Charge (Arms/Fury) (8-25 yards)
        },
        ["longEnemySpells"] = {
            [355] = true, -- Taunt (30 yards)
        },
        ["friendlySpells"] = {},
        ["resSpells"] = {},
        ["petSpells"] = {},
    },
    ["MONK"] = {
        ["enemySpells"] = {
            [115546] = true, -- Provoke (30 yards)
        },
        ["longEnemySpells"] = {
            [117952] = true, -- Crackling Jade Lightning (40 yards)
        },
        ["friendlySpells"] = {
            [116694] = true, -- Effuse (40 yards)
        },
        ["resSpells"] = {
            [115178] = true, -- Resuscitate (40 yards)
        },
        ["petSpells"] = {},
    },
    ["DEMONHUNTER"] = {
        ["enemySpells"] = {
            [183752] = true, -- Consume Magic (20 yards)
        },
        ["longEnemySpells"] = {
            [185123] = true, -- Throw Glaive (Havoc) (30 yards)
            [204021] = true, -- Fiery Brand (Vengeance) (30 yards)
        },
        ["friendlySpells"] = {},
        ["resSpells"] = {},
        ["petSpells"] = {},
    },
}
