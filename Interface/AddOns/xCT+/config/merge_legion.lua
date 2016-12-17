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
local Leg_World = CreateMergeHeader("Legion", "World Zones", "93BE3D")
local Leg_QuestItems = CreateMergeHeader("Legion", "Quest Items", "93BE3D")
local Leg_BG = CreateMergeHeader("Legion", "Bodyguards", "93BE3D")
local Leg_Items = CreateMergeHeader("Legion", "Items", "93BE3D")
local Leg_Cons = CreateMergeHeader("Legion", "Consumables", "93BE3D")
local Leg_Raid = CreateMergeHeader("Legion", "Raids", "93BE3D")

-- ---------------------------
-- Bodyguards               --
-- ---------------------------
-- Druid
addon.merges[218797]      = CreateMergeSpellEntry(Leg_BG, 3.5, "Broll Bearmantle (Moonfire)")

-- Paladin
addon.merges[221647]      = CreateMergeSpellEntry(Leg_BG, 0.5, "Vindicator Boros (Hammer of the Righteous)")
addon.merges[222175]      = CreateMergeSpellEntry(Leg_BG, 1.5, "Blood Vanguard (Trample)")
addon.merges[222175]      = CreateMergeSpellEntry(Leg_BG, 1.5, "Arator the Redeemer (Divine Storm)")
addon.merges[221720]      = CreateMergeSpellEntry(Leg_BG, 1.5, "Arator the Redeemer (Divine Storm Heal)")

-- Monk
addon.merges[212141]      = CreateMergeSpellEntry(Leg_BG, 1.5, "The Monkey King (Spinning Crane Kick)")

-- ---------------------------
-- Consumables              --
-- ---------------------------
addon.merges[188091]      = CreateMergeSpellEntry(Leg_Cons, 1.5, "Potion: Potion of Deadly Grace")
addon.merges[188028]      = CreateMergeSpellEntry(Leg_Cons, 1.5, "Potion: Potion of the Old War") -- Buff ID
addon.merge2h[233150]     = 188028 -- Hack to give the potion a icon
addon.merges[225623]      = CreateMergeSpellEntry(Leg_Cons, 1.5, "Food: Fishbrul Special")
addon.merge2h[201573]     = 225623 -- Pepper Breath
addon.merge2h[225624]     = 225623 -- Pepper Breath

-- ---------------------------
-- Items                    --
-- ---------------------------
-- Trinkets
addon.merges[214052]      = CreateMergeSpellEntry(Leg_Items, 0.5, "Trinket: Eye of Skovald")
addon.merges[215047]      = CreateMergeSpellEntry(Leg_Items, 3.0, "Trinket: Terrorbound Nexus")
addon.merges[222168]      = CreateMergeSpellEntry(Leg_Items, 1.5, "Trinket: Spontaneous Appendages")
addon.merges[214169]      = CreateMergeSpellEntry(Leg_Items, 1.5, "Trinket: Spiked Counterweight")
addon.merges[215047]      = CreateMergeSpellEntry(Leg_Items, 3.0, "Trinket: Terrorbound Nexus")
addon.merge2h[228780]     = 214169 -- Brutal Haymaker (Spiked Counterweight)

addon.merges[213786]      = CreateMergeSpellEntry(Leg_Items, 1.5, "Trinket: Corrupted Starlight")
addon.merge2h[213782]     = 213786 -- Nightfall
addon.merge2h[213833]     = 213786 -- Nightfall
addon.merge2h[213784]     = 213786 -- Nightfall
addon.merge2h[213785]     = 213786 -- Nightfall

addon.merges[221845]      = CreateMergeSpellEntry(Leg_Items, 1.5, "Trinket: Twisting Wind")
addon.merge2h[221865]     = 221845

addon.merges[221804]      = CreateMergeSpellEntry(Leg_Items,   5, "Trinket: Ravaged Seed Pod")

addon.merges[222197]      = CreateMergeSpellEntry(Leg_Items,  .5, "Trinket: Unstable Horrorslime")

-- ---------------------------
-- World Zone               --
-- ---------------------------
-- All
addon.merges[205238]      = CreateMergeSpellEntry(Leg_World, 0.5, "World Quest: PvP Warden Tower's (Powder Keg)")

-- Suramar
addon.merges[203148]      = CreateMergeSpellEntry(Leg_World, 0.5, "World Quest: Air Superiority (Unstable Mana)")
addon.merges[221254]      = CreateMergeSpellEntry(Leg_World, 0.5, "World Quest: Life Finds a Way (Devour Demon)")
addon.merges[218895]      = CreateMergeSpellEntry(Leg_World, 1.0, "World Quest: Withered Army Training (Throw Rock)")
addon.merges[23106]       = CreateMergeSpellEntry(Leg_World, 1.0, "World Quest: Withered Army Training (Chain Lightning)")
addon.merges[204204]      = CreateMergeSpellEntry(Leg_World, 0.5, "World Quest: The Battle Rages On (Unleashed Magic)")

-- Broken Shore
addon.merges[200009]      = CreateMergeSpellEntry(Leg_World, 0.5, "Quest: The Battle for Broken Shore (Fel Cannonball)")

-- Stormheim
addon.merges[184427]      = CreateMergeSpellEntry(Leg_World, 2.5, "Quest: Greymane's Gambit (Skyfire Deck Gun)")
addon.merges[179021]      = CreateMergeSpellEntry(Leg_World, 0.5, "Quest: Murlocs: The Next Generation (Slime)")
addon.merges[179041]      = CreateMergeSpellEntry(Leg_World, 0.5, "Quest: Murlocs: The Next Generation (Pufferfish")

-- Karazhan (Artifact Quests)
addon.merges[201645]      = CreateMergeSpellEntry(Leg_World, 0.5, "Quest: Revil Cost (Cudgel of Light)")
addon.merges[201877]      = CreateMergeSpellEntry(Leg_World, 0.5, "Quest: Revil Cost (Holy Nova)")
addon.merges[201642]      = CreateMergeSpellEntry(Leg_World, 3.5, "Quest: Revil Cost (Holy Fire)")

-- Val'sharah
addon.merges[218594]      = CreateMergeSpellEntry(Leg_World, 0.5, "Quest: Softening the Target (Terrorfiend)")

-- Stormheim
addon.merges[183058]      = CreateMergeSpellEntry(Leg_World, 0.5, "Quest: Cry Thunder!")
addon.merges[183042]      = CreateMergeSpellEntry(Leg_World, 0.5, "Quest: Cry Thunder!")
addon.merges[190863]      = CreateMergeSpellEntry(Leg_World, 0.5, "Quest: Gates of Valor (Call of the Storm)")
addon.merges[190919]      = CreateMergeSpellEntry(Leg_World, 0.5, "Quest: Gates of Valor (Guardian Orbs)")
addon.merges[187780]      = CreateMergeSpellEntry(Leg_World, 3.5, "Quest: Skold-Ashil (Aspirant's Conviction)")

-- Highmountain
addon.merges[215729]      = CreateMergeSpellEntry(Leg_World, 2.5, "Quest: Lifespring Cavern (Healing Rain)")
addon.merges[192997]      = CreateMergeSpellEntry(Leg_World, 1.5, "Quest: Huln's War - The Arrival (Wild Carve)")
addon.merges[193008]      = CreateMergeSpellEntry(Leg_World, 0.5, "Quest: Huln's War - The Arrival (Harpoon Stomp)")
addon.merges[193091]      = CreateMergeSpellEntry(Leg_World, 0.5, "Quest: Huln's War - The Arrival (Harpoon Stomp)")
addon.merges[213474]      = CreateMergeSpellEntry(Leg_World, 0.5, "Quest: Justice Rains from Above (Skyhorn Strafing Run)")
addon.merges[214479]      = CreateMergeSpellEntry(Leg_World, 0.5, "Quest: Bolas Bastion (Flaming Bolas)")

-- Azsuna
addon.merges[179217]      = CreateMergeSpellEntry(Leg_World, 1.5, "Quest: The Walk of Shame (Prince Farondis)")
addon.merges[215555]      = CreateMergeSpellEntry(Leg_World, 1.5, "Quest: The Walk of Shame (Prince Farondis)")

-- ---------------------------
-- Quest Items              --
-- ---------------------------
-- Val'sharah
addon.merges[202917]      = CreateMergeSpellEntry(Leg_QuestItems, 2.5, "Trinket: Temple Priestess' Charm")
addon.merges[202891]      = CreateMergeSpellEntry(Leg_QuestItems, 2.5, "Trinket: Lodestone of the Stormbreaker")

-- ---------------------------
-- Raids                    --
-- ---------------------------
addon.merges[215300]      = CreateMergeSpellEntry(Leg_Raid, 2.0, "Elerethe Renferal: Web of Pain [Tanks]") -- Should maybe be ignored by default
addon.merges[215307]      = CreateMergeSpellEntry(Leg_Raid, 2.0, "Elerethe Renferal: Web of Pain [Other]") -- Should maybe be ignored by default
