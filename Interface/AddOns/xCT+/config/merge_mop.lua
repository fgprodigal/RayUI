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
local MOP_Items   = CreateMergeHeader("Mists of Pandaria", "Trinkets", "F1A864")
local MOP_Cloak   = CreateMergeHeader("Mists of Pandaria", "Legendary Cloaks", "F1A864")



-- ---------------------------
-- Items                    --
-- ---------------------------

-- Legendary Cloaks
addon.merges[147891]    = CreateMergeSpellEntry(MOP_Cloak, 3.5, "Legedary Cloak for Melee")        -- Legedary Cloak (Melee - dmg over 3s)
addon.merges[148008]    = CreateMergeSpellEntry(MOP_Cloak, 3.5, "Legedary Cloak for Casters")      -- Legedary Cloak (Caster - dmg over 3s)
addon.merges[148009]    = CreateMergeSpellEntry(MOP_Cloak, 5.0, "Legedary Cloak for Healers")      -- Legedary Cloak (Healer - heal over 10s)
addon.merges[149276]    = CreateMergeSpellEntry(MOP_Cloak, 3.5, "Legedary Cloak for Hunters")      -- Legedary Cloak (Hunter - dmg over 3s)

-- Trinket: Kardris' Toxic Totem
addon.merges[146061]    = CreateMergeSpellEntry(MOP_Items, 5, "Physical Damage (Melee)")           -- Multi-Strike (Physical, Melee)
addon.merges[146063]    = CreateMergeSpellEntry(MOP_Items, 5, "Holy Damage")                       -- Multi-Strike (Holy Dmg, ?????)
addon.merges[146064]    = CreateMergeSpellEntry(MOP_Items, 5, "Arcane Damage (Balance Druids)")    -- Multi-Strike (Arcane Boomkin)
addon.merges[146065]    = CreateMergeSpellEntry(MOP_Items, 5, "Shadow Damage (Priests, Warlocks)") -- Multi-Strike (Shadow, Lock/Priest)
addon.merges[146067]    = CreateMergeSpellEntry(MOP_Items, 5, "Fire, Frost Damage (Mages)")        -- Multi-Strike (Fire, Frost Mage)
addon.merges[146069]    = CreateMergeSpellEntry(MOP_Items, 5, "Physical Damage (Hunters)")         -- Multi-Strike (Physical, Hunter)
addon.merges[146071]    = CreateMergeSpellEntry(MOP_Items, 5, "Nature Damage (Elemental Shamans)") -- Multi-Strike (Nature, Ele Shaman)
addon.merges[146070]    = CreateMergeSpellEntry(MOP_Items, 5, "Arcane Damage (Mages)")             -- Multi-Strike (Arcane Mage)
addon.merges[146075]    = CreateMergeSpellEntry(MOP_Items, 5, "Nature Damage (Windwalker Monks)")  -- Multi-Strike (Nature, Monk)
addon.merges[146177]    = CreateMergeSpellEntry(MOP_Items, 5, "Holy Healing (Priest, Paladin)")    -- Multi-Strike (Holy, Healing)
addon.merges[146178]    = CreateMergeSpellEntry(MOP_Items, 5, "Nature Healing (Druid, Monk)")      -- Multi-Strike (Nature, Healing)

-- Trinket: Thok's Acid-Grooved Tooth
addon.merges[146137]    = CreateMergeSpellEntry(MOP_Items, .5, "Physical Damage (Melee)")          -- Cleave (Physical, Melee)
addon.merges[146157]    = CreateMergeSpellEntry(MOP_Items, .5, "Holy Damage")                      -- Cleave (Holy Dmg, ?????)
addon.merges[146158]    = CreateMergeSpellEntry(MOP_Items, .5, "Arcane Damage (Balance Druids)")   -- Cleave (Arcane Boomkin)
addon.merges[146159]    = CreateMergeSpellEntry(MOP_Items, .5, "Shadow Damage (Priests, Warlocks)")-- Cleave (Shadow, Lock/Priest)
addon.merges[146160]    = CreateMergeSpellEntry(MOP_Items, .5, "Fire, Frost Damage (Mages)")       -- Cleave (Fire, Frost Mage)
addon.merges[146162]    = CreateMergeSpellEntry(MOP_Items, .5, "Physical Damage (Hunters)")        -- Cleave (Physical, Hunter)
addon.merges[146166]    = CreateMergeSpellEntry(MOP_Items, .5, "Arcane Damage (Mages)")            -- Cleave (Arcane Mage)
addon.merges[146171]    = CreateMergeSpellEntry(MOP_Items, .5, "Nature Damage (Elemental Shamans)")-- Cleave (Nature, Ele)
addon.merges[148234]    = CreateMergeSpellEntry(MOP_Items, .5, "Holy Healing (Priests, Paladins)") -- Cleave (Holy, Healing)
addon.merges[148235]    = CreateMergeSpellEntry(MOP_Items, .5, "Nature Healing (Monks, Druids)")   -- Cleave (Nature, Healing)
