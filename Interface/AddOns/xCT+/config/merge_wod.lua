--[[   ____    ______
      /\  _`\ /\__  _\   __
 __  _\ \ \/\_\/_/\ \/ /_\ \___
/\ \/'\\ \ \/_/_ \ \ \/\___  __\
\/>  </ \ \ \L\ \ \ \ \/__/\_\_/
 /\_/\_\ \ \____/  \ \_\  \/_/
 \//\/_/  \/___/    \/_/

 [=====================================]
 [  Author: Dandraffbal-Stormreaver US ]
 [  xCT+ Version 4.x.x                 ]
 [  ©2015. All Rights Reserved.        ]
 [====================================]]

local ADDON_NAME, addon = ...

-- =====================================================
-- CreateMergeSpellEntry(
--    class,       [string] - class name that spell belongs to
--    interval,       [int] - How often to update merged data (in seconds)
--    desc,        [string] - A short, helpful qualifier (1-2 words)
--    prep,           [int] - The minimum time to wait to update merged data (NOT USED YET)
--  )
--    Creates a merge settings entry for a spell.
-- =====================================================
local function CreateMergeSpellEntry(class, interval, desc, prep)
  return {
         class = class      or "ITEM",
      interval = interval   or 3,
          prep = prep       or interval or 3,
          desc = desc,
    }
end

-- =====================================================
-- CreateMergeHeader(
--    expName,        [string] - name of the expansion
--    catName,        [string] - name of the category
--    expColor,       [int] - hex color without the #
--  )
--    Creates a string for a category heading
-- =====================================================
local function CreateMergeHeader(expName, catName, expColor)
    return "|cff".. expColor .. expName .. "|r™ |cff798BDD(" ..catName.. ")|r"
end



-- ---------------------------
-- Merge Headers            --
-- ---------------------------
local Item_WOD  =  CreateMergeHeader("Warlords of Draenor", "Items", "A32C12")
local Bodyg_WOD =  CreateMergeHeader("Warlords of Draenor", "Bodyguards", "A32C12")
local Raid_WOD  =  CreateMergeHeader("Warlords of Draenor", "Raids", "A32C12")
local World_WOD =  CreateMergeHeader("Warlords of Draenor", "World Zone", "A32C12")



-- ---------------------------
-- Items                    --
-- ---------------------------

-- Enchants
addon.merges[159238]    = CreateMergeSpellEntry(Item_WOD, 3.5, "Shattered Hand")              -- WoD Shattered Hand Enchant
addon.merges[188505]    = CreateMergeSpellEntry(Item_WOD, 0.5, "Felmouth Frenzy")             -- Felmouth Frenzy Food (Tanaan)

-- Legendary Rings
addon.merges[187626]    = CreateMergeSpellEntry(Item_WOD, 0.5, "Legedary Ring: Agi DPS")      -- Legedary Ring (Agility DPS - INSTANT)
addon.merges[187625]    = CreateMergeSpellEntry(Item_WOD, 0.5, "Legedary Ring: Int DPS")      -- Legedary Ring (Intellect DPS - INSTANT)
addon.merges[187624]    = CreateMergeSpellEntry(Item_WOD, 0.5, "Legedary Ring: Str DPS")      -- Legedary Ring (Strength DPS - INSTANT)

-- WoD Trinkets
addon.merges[184280]    = CreateMergeSpellEntry(Item_WOD, 3.5, "Mirror of the Blademaster")   -- Felstorm (every 2s for 20s)
addon.merges[184256]    = CreateMergeSpellEntry(Item_WOD, 2.5, "Empty Drinking Horn")         -- Empty Drinking Horn
addon.merges[184248]    = CreateMergeSpellEntry(Item_WOD, 0.5, "Discordant Chorus")           -- Discordant Chorus
addon.merges[185098]    = CreateMergeSpellEntry(Item_WOD, 4.5, "Soothing Breeze")             -- Monk Class Trinket (Sacred Draenic Incense)
addon.merges[184075]    = CreateMergeSpellEntry(Item_WOD, 0.5, "Prophecy of Fear")            -- Propecy of Fear
addon.merges[184559]    = CreateMergeSpellEntry(Item_WOD, 0.5, "Soul Capacitor")              -- Soul Capacitor (Spirit Eruption)
addon.merges[185321]    = CreateMergeSpellEntry(Item_WOD, 1.5, "Seed of Creation (Guardian)") -- Class Trinket (Guardian Druid)

-- Tier Gear
addon.merges[188046]    = CreateMergeSpellEntry(Item_WOD, 1.5, "T18 Druid Balance 2P")        -- Fey Moonwing (Fey Missile)

-- ---------------------------
-- Pets / NPC's             --
-- ---------------------------

-- Bodyguards
addon.merges[171764]    = CreateMergeSpellEntry(Bodyg_WOD, 3.5, "Bodyguard: Vivianne")         -- Fireball (for 8s)
addon.merges[175806]    = CreateMergeSpellEntry(Bodyg_WOD, 3.5, "Bodyguard: Vivianne")         -- Meteor (Initial Dmg - AoE - every 5s for 8s)
addon.merges[173010]    = CreateMergeSpellEntry(Bodyg_WOD, 3.5, "Bodyguard: Vivianne")         -- Blizzard
addon.merges[175814]    = CreateMergeSpellEntry(Bodyg_WOD, 3.5, "Bodyguard: Vivianne")         -- Meteor Burn (DoT - AoE - every 5s for 8s)
addon.merges[176020]    = CreateMergeSpellEntry(Bodyg_WOD, 0.5, "Bodyguard: Aeda")             -- Demonic Leap (INSTANT)
addon.merges[176017]    = CreateMergeSpellEntry(Bodyg_WOD, 3.5, "Bodyguard: Aeda")             -- Shadow Bolt Volley
addon.merges[172965]    = CreateMergeSpellEntry(Bodyg_WOD, 3.5, "Bodyguard: Delvar")           -- Death and Decay
addon.merges[175796]    = CreateMergeSpellEntry(Bodyg_WOD, 3.5, "Bodyguard: Delvar")           -- Breath of Sindragosa

-- Vehicles
addon.merges[165421]    = CreateMergeSpellEntry(World_WOD, 3.5, "Shredder")                    -- Gorgrond Shredder
addon.merges[164603]    = CreateMergeSpellEntry(World_WOD, 3.5, "Shredder")                    -- Gorgrond Shredder



-- ---------------------------
-- Raids                    --
-- ---------------------------

-- HFC
addon.merges[181102]    = CreateMergeSpellEntry(Raid_WOD,  .5, "Mark Eruption")               -- HFC Mannoroth (Mark of Doom)
addon.merges[182635]    = CreateMergeSpellEntry(Raid_WOD, 0.5, "HFC Construct #1")            -- HFC Construct (Reverberating Blow)
addon.merges[182218]    = CreateMergeSpellEntry(Raid_WOD, 0.5, "HFC Construct #2")            -- HFC Construct (Volatile Felblast)
addon.merges[180223]    = CreateMergeSpellEntry(Raid_WOD, 1.5, "HFC Construct #4")            -- HFC Construct (Felblaze Residue)
addon.merges[185656]    = CreateMergeSpellEntry(Raid_WOD, 0.5, "Shadowfel Annihilation")      -- HFC Xhul'horac (Friendly Fire)
