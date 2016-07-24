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
          prep = prep       or 0,
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
    return "|cff".. expColor .. expName .. " |cff798BDD(" ..catName.. ")|r"
end



-- ---------------------------
-- Merge Headers            --
-- ---------------------------
local Leg_World = CreateMergeHeader("Legion|r™", "World Zones", "93BE3D")
local Leg_QuestItems = CreateMergeHeader("Legion|r™", "Quest Items", "93BE3D")
local Leg_BG = CreateMergeHeader("Legion|r™", "Bodyguards", "93BE3D")



-- ---------------------------
-- Bodyguards               --
-- ---------------------------

-- Druid
addon.merges[218797]      = CreateMergeSpellEntry(Leg_BG, 3.5, "Broll Bearmantle (Moonfire)")

-- Paladin
addon.merges[221647]      = CreateMergeSpellEntry(Leg_BG, 0.5, "Vindicator Boros (Hammer of the Righteous)")
addon.merges[222175]      = CreateMergeSpellEntry(Leg_BG, 1.5, "Blood Vanguard (Trample)")



-- ---------------------------
-- World Zone               --
-- ---------------------------

-- Broken Shore
addon.merges[200009]      = CreateMergeSpellEntry(Leg_World, 0.5, "Unattended Cannon (Fel Cannonball)")

-- Stormheim
addon.merges[184427]      = CreateMergeSpellEntry(Leg_World, 2.5, "Skyfire Deck Gun")
addon.merges[179021]      = CreateMergeSpellEntry(Leg_World, 0.5, "Murky - Slime")
addon.merges[179041]      = CreateMergeSpellEntry(Leg_World, 0.5, "Murky - Pufferfish")

-- Karazhan (Artifact Quests)
addon.merges[201645]      = CreateMergeSpellEntry(Leg_World, 0.5, "Revil Cost (Cudgel of Light)")
addon.merges[201877]      = CreateMergeSpellEntry(Leg_World, 0.5, "Revil Cost (Holy Nova)")
addon.merges[201642]      = CreateMergeSpellEntry(Leg_World, 3.5, "Revil Cost (Holy Fire)")

-- Val'sharah
addon.merges[218594]      = CreateMergeSpellEntry(Leg_World, 0.5, "Quest: Softening the Target (Terrorfiend)")

-- Stormheim
addon.merges[183058]      = CreateMergeSpellEntry(Leg_World, 0.5, "Quest: Cry Thunder!")
addon.merges[183042]      = CreateMergeSpellEntry(Leg_World, 0.5, "Quest: Cry Thunder!")
addon.merges[190863]      = CreateMergeSpellEntry(Leg_World, 0.5, "Call of the Storm (Gates of Valor)")
addon.merges[190919]      = CreateMergeSpellEntry(Leg_World, 0.5, "Guardian Orbs (Gates of Valor)")
addon.merges[187780]      = CreateMergeSpellEntry(Leg_World, 3.5, "Aspirant's Conviction (Skold-Ashil)")

-- Highmountain
addon.merges[215729]      = CreateMergeSpellEntry(Leg_World, 2.5, "Healing Rain (Lifespring Cavern)")
addon.merges[192997]      = CreateMergeSpellEntry(Leg_World, 1.5, "Wild Carve (Q: Huln's War - The Arrival)")
addon.merges[193008]      = CreateMergeSpellEntry(Leg_World, 0.5, "Harpoon Stomp (Q: Huln's War - The Arrival)")
addon.merges[193091]      = CreateMergeSpellEntry(Leg_World, 0.5, "Harpoon Stomp (Q: Huln's War - The Arrival)")
addon.merges[213474]      = CreateMergeSpellEntry(Leg_World, 0.5, "Skyhorn Strafing Run (Q: Justice Rains from Above)")
addon.merges[214479]      = CreateMergeSpellEntry(Leg_World, 0.5, "Flaming Bolas (Q: Bolas Bastion)")

-- Azsuna
addon.merges[179217]      = CreateMergeSpellEntry(Leg_World, 1.5, "Quest: The Walk of Shame (Prince Farondis)")
addon.merges[215555]      = CreateMergeSpellEntry(Leg_World, 1.5, "Quest: The Walk of Shame (Prince Farondis)")



-- ---------------------------
-- Quest Items              --
-- ---------------------------

-- Val'sharah
addon.merges[202917]      = CreateMergeSpellEntry(Leg_QuestItems, 2.5, "Trinket: Temple Priestess' Charm")
addon.merges[202891]      = CreateMergeSpellEntry(Leg_QuestItems, 2.5, "Trinket: Lodestone of the Stormbreaker")
