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



-- ---------------------------
-- Rogue                    --
-- ---------------------------

-- All Specs
addon.merges[152150]    = CreateMergeSpellEntry("ROGUE", 0.5, 0)            -- Death from Above
addon.merges[209043]    = CreateMergeSpellEntry("ROGUE", 0.5, 0)            -- Insignia of Ravenholdt (Legendary Ring - All Specs)

-- Assassination (ID: 259)
addon.merges[5374]      = CreateMergeSpellEntry("ROGUE", 0.5, 259)          -- Mutilate (MH)
addon.merges[2818]      = CreateMergeSpellEntry("ROGUE", 3.5, 259)          -- Deadly Poison (DoT)
addon.merges[113780]    = CreateMergeSpellEntry("ROGUE", 0.5, 259)          -- Deadly Poison (Instant)
addon.merges[51723]     = CreateMergeSpellEntry("ROGUE", 0.5, 259)          -- Fan of Knives
addon.merges[192660]    = CreateMergeSpellEntry("ROGUE", 2.5, 259)          -- Poison Bomb
addon.merge2h[192380]   = 113780                                            -- Artifact: Poison Knives
addon.merge2h[27576]    = 5374                                              -- Mutilate (OH)

-- Outlaw (ID: 260)
addon.merges[22482]     = CreateMergeSpellEntry("ROGUE", 1.5, 260)          -- Blade Flurry
addon.merges[57841]     = CreateMergeSpellEntry("ROGUE", 3.5, 260)          -- Killing Spree
addon.merges[185779]    = CreateMergeSpellEntry("ROGUE", 2.0, 260)          -- Talent: Cannonball Barrage
addon.merges[202822]    = CreateMergeSpellEntry("ROGUE", 0.5, 260)          -- Artifact: Greed
addon.merges[193315]    = CreateMergeSpellEntry("ROGUE", 0.5, 260)          -- Saber Slash
addon.merge2h[202823]   = 202822                                            -- [MH/OH Merger] Artifact: Greed
addon.merge2h[197834]   = 193315                                            -- [Proc Merger] Saber Slash

-- Sublety (ID: 261)
addon.merges[197835]    = CreateMergeSpellEntry("ROGUE", 0.5, 261)          -- Shuriken Storm
addon.merges[197800]    = CreateMergeSpellEntry("ROGUE", 0.5, 261)          -- Shadow Nova



-- ---------------------------
-- Warrior                  --
-- ---------------------------

-- All Specs
addon.merges[52174]     = CreateMergeSpellEntry("WARRIOR", 0.5, 0)          -- Heroic Leap
addon.merges[46968]     = CreateMergeSpellEntry("WARRIOR", 0.5, 0)          -- Shockwave
addon.merges[156287]    = CreateMergeSpellEntry("WARRIOR", 2.5, 0)          -- Ravager

-- Arms (ID: 71)
addon.merges[845]       = CreateMergeSpellEntry("WARRIOR", 0.5, 71)         -- Cleave
addon.merges[12294]     = CreateMergeSpellEntry("WARRIOR", 0.5, 71)         -- Talent: Sweeping Strikes (Mortal Strike)
addon.merges[772]       = CreateMergeSpellEntry("WARRIOR", 3.5, 71)         -- Talent: Rend
addon.merges[215537]    = CreateMergeSpellEntry("WARRIOR", 2.5, 71)         -- Talent: Trauma
addon.merges[209569]    = CreateMergeSpellEntry("WARRIOR", 2.5, 71)         -- Artifact: Corrupted Blood of Zakajz
addon.merges[209700]    = CreateMergeSpellEntry("WARRIOR", 0.5, 71)         -- Artifact: Void Cleave
addon.merges[209577]    = CreateMergeSpellEntry("WARRIOR", 2.5, 71)         -- Artifact: Warbreaker
addon.merges[199658]    = CreateMergeSpellEntry("WARRIOR", 1.5, 71)         -- Whirlwind
addon.merge2h[199850]   = 199658                                            -- [Spell Merger] Whirlwind

-- Fury (ID: 72)
addon.merges[184367]    = CreateMergeSpellEntry("WARRIOR", 2.5, 72)         -- Rampage (Red Face Icon)
addon.merges[96103]     = CreateMergeSpellEntry("WARRIOR", 0.5, 72)         -- Raging Blow
addon.merges[199667]    = CreateMergeSpellEntry("WARRIOR", 1.5, 72)         -- Whirlwind
addon.merges[23881]     = CreateMergeSpellEntry("WARRIOR", 0.5, 72)         -- Bloodthirst (Whirlwind: Meat Cleaver)
addon.merges[113344]    = CreateMergeSpellEntry("WARRIOR", 2.5, 72)         -- Talent: Bloodbath
addon.merges[118000]    = CreateMergeSpellEntry("WARRIOR", 0.5, 72)         -- Talent: Dragon Roar
addon.merges[50622]     = CreateMergeSpellEntry("WARRIOR", 2.5, 72)         -- Talent: Bladestorm
addon.merges[205546]    = CreateMergeSpellEntry("WARRIOR", 3.0, 72)         -- Artifact: Odyn's Fury (DoT)
addon.merge2h[205547]   = 205546                                            -- Artifact: Odyn's Fury (Hit)
addon.merge2h[85384]    = 96103                                             -- [MH/OH] Raging Blow
addon.merge2h[44949]    = 199667                                            -- [MH/OH] Whirlwind
addon.merge2h[95738]    = 50622                                             -- [MH/OH] Bladestorm
addon.merge2h[218617]   = 184367                                            -- Rampage (1st Hit)
addon.merge2h[184707]   = 184367                                            -- Rampage (2nd Hit)
addon.merge2h[184709]   = 184367                                            -- Rampage (3rd Hit)
addon.merge2h[201364]   = 184367                                            -- Rampage (4th Hit)
addon.merge2h[201363]   = 184367                                            -- Rampage (5th Hit)

-- Protection (ID: 73)
addon.merges[6572]      = CreateMergeSpellEntry("WARRIOR", 0.5, 73)         -- Revenge
addon.merges[115767]    = CreateMergeSpellEntry("WARRIOR", 3.5, 73)         -- Deep Wounds
addon.merges[6343]      = CreateMergeSpellEntry("WARRIOR", 0.5, 73)         -- Thunder Clap
addon.merges[7922]      = CreateMergeSpellEntry("WARRIOR", 0.5, 73)         -- Talent: Warbringer
addon.merges[222944]    = CreateMergeSpellEntry("WARRIOR", 3.0, 73)         -- Talent: Inspiring Presence
addon.merges[203526]    = CreateMergeSpellEntry("WARRIOR", 3.5, 73)         -- Artifact: Neltharion's Fury


-- ---------------------------
-- Priest                   --
-- ---------------------------

-- All Specs
addon.merges[589]       = CreateMergeSpellEntry("PRIEST", 2.5, 0)           -- Shadow Word: Pain
addon.merges[122128]    = CreateMergeSpellEntry("PRIEST", 2.5, 0)           -- Talent: Divine Star (Damage)
addon.merges[110745]    = CreateMergeSpellEntry("PRIEST", 2.5, 0)           -- Talent: Divine Star (Heal)
addon.merges[120696]    = CreateMergeSpellEntry("PRIEST", 2.0, 0)           -- Talent: Halo (Damage)
addon.merges[120692]    = CreateMergeSpellEntry("PRIEST", 2.0, 0)           -- Talent: Halo (Heal)
-- Discipline (ID: 256)
addon.merges[81751]     = CreateMergeSpellEntry("PRIEST", 2.5, 256)         -- Atonement
addon.merges[47666]     = CreateMergeSpellEntry("PRIEST", 2.5, 256)         -- Penance (Heal)
addon.merges[194509]    = CreateMergeSpellEntry("PRIEST", 0.5, 256)         -- Power Word: Radiance
addon.merges[204065]    = CreateMergeSpellEntry("PRIEST", 0.5, 256)         -- Talent: Shadow Covenant
addon.merges[47750]     = CreateMergeSpellEntry("PRIEST", 2.5, 256)         -- Talent: Penance (Damage)
addon.merges[204213]    = CreateMergeSpellEntry("PRIEST", 2.5, 256)         -- Talent: Purge the Wicked (DoT)
addon.merge2h[204197]   = 204213                                            -- Talent: Purge the Wicked (Instant)

-- Holy (ID: 257)
addon.merges[139]       = CreateMergeSpellEntry("PRIEST", 3.5, 257)         -- Renew
addon.merges[14914]     = CreateMergeSpellEntry("PRIEST", 2.5, 257)         -- Holy Fire
addon.merges[132157]    = CreateMergeSpellEntry("PRIEST", 0.5, 257)         -- Holy Nova
addon.merges[34861]     = CreateMergeSpellEntry("PRIEST", 0.5, 257)         -- Holy Word: Sanctify
addon.merges[596]       = CreateMergeSpellEntry("PRIEST", 0.5, 257)         -- Prayer of Healing
addon.merges[77489]     = CreateMergeSpellEntry("PRIEST", 3.5, 257)         -- Mastery: Echo of Light
addon.merges[2061]      = CreateMergeSpellEntry("PRIEST", 0.5, 257)         -- Talent: Trail of Light (Flash Heal)
addon.merges[32546]     = CreateMergeSpellEntry("PRIEST", 0.5, 257)         -- Talent: Binding Heal
addon.merges[204883]    = CreateMergeSpellEntry("PRIEST", 0.5, 257)         -- Talent: Circle of Healing

-- Shadow (ID: 258)
addon.merges[49821]     = CreateMergeSpellEntry("PRIEST", 1.5, 258)         -- Mind Sear
addon.merges[34914]     = CreateMergeSpellEntry("PRIEST", 2.5, 258)         -- Vampiric Touch
addon.merges[148859]    = CreateMergeSpellEntry("PRIEST", 2.5, 258)         -- Shadowy Apparition
addon.merges[15407]     = CreateMergeSpellEntry("PRIEST", 2.0, 258)         -- Mind Flay
addon.merges[205386]    = CreateMergeSpellEntry("PRIEST", 0.5, 258)         -- Talent: Shadow Crash
addon.merges[217676]    = CreateMergeSpellEntry("PRIEST", 0.5, 258)         -- Talent: Mind Spike
addon.merges[193473]    = CreateMergeSpellEntry("PRIEST", 2.0, 258)         -- Artifact: Void Tendril (Mind Flay)
addon.merges[205065]    = CreateMergeSpellEntry("PRIEST", 2.0, 258)         -- Artifact: Void Torrent
addon.merges[194238]    = CreateMergeSpellEntry("PRIEST", 2.5, 258)         -- Artifact: Sphere of Insanity
addon.merges[204778]    = CreateMergeSpellEntry("PRIEST", 2.5, 258)         -- Honor Talent: Void Shield


-- ---------------------------
-- Paladin                  --
-- ---------------------------

-- All Specs
addon.merges[81297]     = CreateMergeSpellEntry("PALADIN", 2.5, 0)          -- Consecration
addon.merges[105421]    = CreateMergeSpellEntry("PALADIN", 0.5, 0)          -- Talent: Blinding Light
addon.merges[183811]    = CreateMergeSpellEntry("PALADIN", 2.5, 0)          -- Talent: Judgment of Light

-- Holy (ID: 65)
addon.merges[225311]    = CreateMergeSpellEntry("PALADIN", 0.5, 65)         -- Light of Dawn
addon.merges[53652]     = CreateMergeSpellEntry("PALADIN", 1.5, 65)         -- Becon of Light
addon.merges[119952]    = CreateMergeSpellEntry("PALADIN", 2.5, 65)         -- Talent: Light's Hammer (Heal)
addon.merges[114919]    = CreateMergeSpellEntry("PALADIN", 2.5, 65)         -- Talent: Light's Hammer (Damage)
addon.merges[114852]    = CreateMergeSpellEntry("PALADIN", 0.5, 65)         -- Talent: Holy Prism (Heal)
addon.merges[114871]    = CreateMergeSpellEntry("PALADIN", 0.5, 65)         -- Talent: Holy Prism (Damage)
addon.merges[210291]    = CreateMergeSpellEntry("PALADIN", 2.5, 65)         -- Talent: Aura of Mercy
addon.merges[200654]    = CreateMergeSpellEntry("PALADIN", 2.5, 65)         -- Artifact: Tyr's Deliverance

-- Protection (ID: 66)
addon.merges[31935]     = CreateMergeSpellEntry("PALADIN", 1.5, 66)         -- Avenger's Shield
addon.merges[88263]     = CreateMergeSpellEntry("PALADIN", 0.5, 66)         -- Hammer of the Righteous
addon.merges[204301]    = CreateMergeSpellEntry("PALADIN", 2.5, 66)         -- Blessed Hammer
addon.merges[209478]    = CreateMergeSpellEntry("PALADIN", 1.5, 66)         -- Artifact: Tyr's Enforcer
addon.merges[209202]    = CreateMergeSpellEntry("PALADIN", 0.5, 66)         -- Artifact: Eye of Tyr

-- Retribution (ID: 70)
addon.merges[224266]    = CreateMergeSpellEntry("PALADIN", 1.0, 70)         -- Templar's Verdict (Echo of the Highlord) *Delay on second hit
addon.merges[205729]    = CreateMergeSpellEntry("PALADIN", 1.0, 70)         -- Greater Blessing of Might
addon.merges[217020]    = CreateMergeSpellEntry("PALADIN", 0.5, 70)         -- Zeal
addon.merges[203539]    = CreateMergeSpellEntry("PALADIN", 5.5, 70)         -- Greater Blessings of Wisdom
addon.merges[184689]    = CreateMergeSpellEntry("PALADIN", 0.5, 70)         -- Shield of Vengeance
addon.merges[20271]     = CreateMergeSpellEntry("PALADIN", 1.5, 70)         -- Talent: Greater Judgment
addon.merges[198137]    = CreateMergeSpellEntry("PALADIN", 2.5, 70)         -- Talent: Divine Hammer
addon.merges[210220]    = CreateMergeSpellEntry("PALADIN", 0.5, 70)         -- Talent: Holy Wrath
addon.merges[205273]    = CreateMergeSpellEntry("PALADIN", 2.0, 70)         -- Artifact: Wake of Ashes
addon.merges[224239]    = CreateMergeSpellEntry("PALADIN", 1.5, 70)         -- Artifact: Divine Tempest (Divine Storm)
addon.merges[20271]     = CreateMergeSpellEntry("PALADIN", 0.5, 70)         -- Judgment
addon.merge2h[228288]   = 20271                                             -- [Bounce Merger] Judgment
addon.merge2h[216527]   = 20271                                             -- [PvP Talent] Lawbringer


-- ---------------------------
-- Hunter                   --
-- ---------------------------

-- All Specs
addon.merges[2643]      = CreateMergeSpellEntry("HUNTER", 0.5, 0)           -- Multi-Shot
addon.merges[131900]    = CreateMergeSpellEntry("HUNTER", 2.5, 0)           -- Talent: A Murder of Crows
addon.merges[194392]    = CreateMergeSpellEntry("HUNTER", 0.5, 0)           -- Talent: Volley
addon.merges[120361]    = CreateMergeSpellEntry("HUNTER", 1.5, 0)           -- Talent: Barrage

-- Beast Mastery (ID: 253)
addon.merges[118459]    = CreateMergeSpellEntry("HUNTER", 2.5, 253)         -- Pet: Beast Cleave
addon.merges[201754]    = CreateMergeSpellEntry("HUNTER", 0.5, 253)         -- Talent: Stomp
addon.merges[217207]    = CreateMergeSpellEntry("HUNTER", 0.5, 253)         -- Talent: Dire Frenzy
addon.merges[171454]    = CreateMergeSpellEntry("HUNTER", 0.5, 253)         -- Talent: Chimaera Shot
addon.merges[197465]    = CreateMergeSpellEntry("HUNTER", 0.5, 253)         -- Artifact: Surge of the Stormgod
addon.merges[207097]    = CreateMergeSpellEntry("HUNTER", 1.5, 253)         -- Artifact: Titan's Thunder
addon.merge2h[171457]   = 171454                                            -- [Cleave Merger] Chimaera Shot

-- Marksmanship (ID: 254)
addon.merges[19434]     = CreateMergeSpellEntry("HUNTER", 0.5, 254)         -- Aimed Shot (Talent: Trick Shot + Windburst)
addon.merges[212621]    = CreateMergeSpellEntry("HUNTER", 0.5, 254)         -- Marked Shot
addon.merges[186387]    = CreateMergeSpellEntry("HUNTER", 0.5, 254)         -- Bursting Shot
addon.merges[212680]    = CreateMergeSpellEntry("HUNTER", 0.5, 254)         -- Talent: Explosive Shot
addon.merges[214581]    = CreateMergeSpellEntry("HUNTER", 1.5, 254)         -- Talent: Sidewinders
addon.merges[198670]    = CreateMergeSpellEntry("HUNTER", 0.5, 254)         -- Talent: Piercing Shot
addon.merges[191070]    = CreateMergeSpellEntry("HUNTER", 0.5, 254)         -- Artifact: Call of the Hunter
addon.merge2h[191043]   = 19434                                             -- Windburst

-- Survival (ID: 255)
addon.merges[187708]    = CreateMergeSpellEntry("HUNTER", 0.5, 255)         -- Carve
addon.merges[13812]     = CreateMergeSpellEntry("HUNTER", 2.5, 255)         -- Explosive Trap
addon.merges[194279]    = CreateMergeSpellEntry("HUNTER", 2.5, 255)         -- Talent: Caltrops
addon.merges[212436]    = CreateMergeSpellEntry("HUNTER", 0.5, 255)         -- Talent: Butchery
addon.merges[203413]    = CreateMergeSpellEntry("HUNTER", 2.5, 255)         -- Artifact: Fury of the Eagle
addon.merges[194859]    = CreateMergeSpellEntry("HUNTER", 2.5, 255)         -- Artifact: Dragonsfire Conflagration
addon.merges[194858]    = CreateMergeSpellEntry("HUNTER", 2.5, 255)         -- Artifact: Dragonsfire Grenade
addon.merges[164857]    = CreateMergeSpellEntry("HUNTER", 5.0, 255)         -- Passive: Survivalist


-- ---------------------------
-- Shaman                   --
-- ---------------------------

-- Elemental (ID: 262)
addon.merges[51505]     = CreateMergeSpellEntry("SHAMAN", 1.0, 262)         -- Lavaburst (Elemental)
addon.merges[188196]    = CreateMergeSpellEntry("SHAMAN", 1.0, 262)         -- Lightning Bolt (Elemental)
addon.merges[188443]    = CreateMergeSpellEntry("SHAMAN", 1.5, 262)         -- Chain Lightning (Elemental)
addon.merges[77478]     = CreateMergeSpellEntry("SHAMAN", 1.5, 262)         -- Earthquake
addon.merges[191732]    = CreateMergeSpellEntry("SHAMAN", 1.5, 262)         -- Artifact Greater Lightning Elemental
addon.merges[205533]    = CreateMergeSpellEntry("SHAMAN", 1.5, 262)         -- Artifact Greater Lightning Elemental
addon.merges[188389]    = CreateMergeSpellEntry("SHAMAN", 2.5, 262)         -- Flame Shock
addon.merges[51490]     = CreateMergeSpellEntry("SHAMAN", 0.5, 262)         -- Thunderstorm
addon.merges[192231]    = CreateMergeSpellEntry("SHAMAN", 2.5, 262)         -- Talent: Liquid Magma Totem
addon.merges[170379]    = CreateMergeSpellEntry("SHAMAN", 2.0, 262)         -- Talent: Earthn Rage
addon.merges[197568]    = CreateMergeSpellEntry("SHAMAN", 0.5, 262)         -- Talent: Lightning Rod
addon.merges[117588]    = CreateMergeSpellEntry("SHAMAN", 0.5, 262)         -- Talent: Primal Elementalist [Fire]
addon.merge2h[77451]    = 51505                                             -- [Mastery Merger] Lavaburst Overload
addon.merge2h[45297]    = 188443                                            -- [Mastery Merger] Chain Lightning Overload
addon.merge2h[45284]    = 188196                                            -- [Mastery Merger] Lightning Bolt Overload

-- Enhancement (ID: 263)
addon.merges[195256]    = CreateMergeSpellEntry("SHAMAN", 1.5, 263)         -- Stormlash (Gets Spammy!)
addon.merges[187874]    = CreateMergeSpellEntry("SHAMAN", 0.5, 263)         -- Crash Lightning
addon.merges[192592]    = CreateMergeSpellEntry("SHAMAN", 1.5, 263)         -- Stormstrike: Crash Lightning (TODO: Not working?)
addon.merges[25504]     = CreateMergeSpellEntry("SHAMAN", 0.5, 263)         -- Windfury Attacks
addon.merges[32175]     = CreateMergeSpellEntry("SHAMAN", 0.5, 263)         -- Stormstrike MH/OH Merger
addon.merges[10444]     = CreateMergeSpellEntry("SHAMAN", 1.5, 263)         -- Flametongue
addon.merges[199054]    = CreateMergeSpellEntry("SHAMAN", 0.5, 263)         -- Artifact: Unleash Doom
addon.merges[198485]    = CreateMergeSpellEntry("SHAMAN", 0.5, 263)         -- Artifact: Alpha Wolf
addon.merges[198483]    = CreateMergeSpellEntry("SHAMAN", 1.5, 263)         -- Artifact: Doom Wolves
addon.merges[199116]    = CreateMergeSpellEntry("SHAMAN", 2.0, 263)         -- Artifact: Doom Vortex
addon.merges[210854]    = CreateMergeSpellEntry("SHAMAN", 0.5, 263)         -- Talent: Hailstorm
addon.merges[210801]    = CreateMergeSpellEntry("SHAMAN", 2.5, 263)         -- Talent: Crashing Storm
addon.merges[197385]    = CreateMergeSpellEntry("SHAMAN", 2.5, 263)         -- Talent: Fury of Air
addon.merges[197214]    = CreateMergeSpellEntry("SHAMAN", 2.5, 263)         -- Talent: Sundering
addon.merge2h[32176]    = 32175                                             -- [MH/OH Merger] Stormstrike
addon.merge2h[199053]   = 199054                                            -- [MH/OH Merger] Artifact: Unleash Weapons

-- Restoration (Shaman) (ID: 264)
addon.merges[421]       = CreateMergeSpellEntry("SHAMAN", 0.5, 264)         -- Chain Lightning (Resto)
addon.merges[1064]      = CreateMergeSpellEntry("SHAMAN", 0.5, 264)         -- Chain Heal
addon.merges[73921]     = CreateMergeSpellEntry("SHAMAN", 2.5, 264)         -- Healing Rain
addon.merges[61295]     = CreateMergeSpellEntry("SHAMAN", 3.5, 264)         -- Riptide
addon.merges[52042]     = CreateMergeSpellEntry("SHAMAN", 3.0, 264)         -- Healing Stream Totem
addon.merges[114942]    = CreateMergeSpellEntry("SHAMAN", 2.5, 264)         -- Healing Tide Totem
addon.merges[197997]    = CreateMergeSpellEntry("SHAMAN", 2.5, 264)         -- Talent: Wellspring
addon.merges[114911]    = CreateMergeSpellEntry("SHAMAN", 2.5, 264)         -- Talent: Ancestral Guidance
addon.merges[157503]    = CreateMergeSpellEntry("SHAMAN", 0.5, 264)         -- Talent: Cloudburst
addon.merges[114083]    = CreateMergeSpellEntry("SHAMAN", 1.5, 264)         -- Talent: Ascendance
addon.merges[201633]    = CreateMergeSpellEntry("SHAMAN", 2.5, 264)         -- Talent: Earthen Shield
addon.merges[209069]    = CreateMergeSpellEntry("SHAMAN", 2.5, 264)         -- Artifact: Tidal Pools
addon.merges[208899]    = CreateMergeSpellEntry("SHAMAN", 3.0, 264)         -- Artifact: Queen's Decree
addon.merges[207778]    = CreateMergeSpellEntry("SHAMAN", 0.5, 264)         -- Artifact: Gift of the Queen


-- ---------------------------
-- Mage                     --
-- ---------------------------

-- All Specs
addon.merges[122]       = CreateMergeSpellEntry("MAGE", 1.5, 0)             -- Frost Nova

-- Arcane (ID: 62)
addon.merges[1449]      = CreateMergeSpellEntry("MAGE", 0.5, 62)            -- Arcane Explosion
addon.merges[7268]      = CreateMergeSpellEntry("MAGE", 2.5, 62)            -- Arcane Missiles
addon.merges[44425]     = CreateMergeSpellEntry("MAGE", 1.0, 62)            -- Arcane Barrage (Cleave)
addon.merges[88084]     = CreateMergeSpellEntry("MAGE", 0.5, 62)            -- Talent: Mirror Images
addon.merges[157980]    = CreateMergeSpellEntry("MAGE", 0.5, 62)            -- Talent: Supernova
addon.merges[114923]    = CreateMergeSpellEntry("MAGE", 2.5, 62)            -- Talent: Nether Tempest
addon.merges[153640]    = CreateMergeSpellEntry("MAGE", 2.5, 62)            -- Talent: Arcane Orb
addon.merges[157979]    = CreateMergeSpellEntry("MAGE", 0.5, 62)            -- Talent: Unstable Magic
addon.merges[210833]    = CreateMergeSpellEntry("MAGE", 0.5, 62)            -- Artifact: Touch of the Magi
addon.merges[211088]    = CreateMergeSpellEntry("MAGE", 2.5, 62)            -- Artifact: Mark of Aluneth (DoT)
addon.merge2h[210817]   = 44425                                             -- [DD/Splash Merger] Arcane Rebound
addon.merge2h[114954]   = 114923                                            -- [DD/DoT Merger] Arcane Rebound
addon.merge2h[211076]   = 211088                                            -- [DD/Splash Merger] Arcane Rebound

-- Fire (ID: 63)
addon.merges[31661]     = CreateMergeSpellEntry("MAGE", 0.5, 63)            -- Dragon's Breath
addon.merges[2120]      = CreateMergeSpellEntry("MAGE", 1.5, 63)            -- Flamestrike (Longer for talent)
addon.merges[12654]     = CreateMergeSpellEntry("MAGE", 2.5, 63)            -- Ignite (DoT)
addon.merges[205345]    = CreateMergeSpellEntry("MAGE", 2.5, 63)            -- Talent: Conflagration
addon.merges[88082]     = CreateMergeSpellEntry("MAGE", 2.0, 63)            -- Talent: Mirror Images
addon.merges[157981]    = CreateMergeSpellEntry("MAGE", 0.5, 63)            -- Talent: Blast Wave
addon.merges[157977]    = CreateMergeSpellEntry("MAGE", 0.5, 63)            -- Talent: Unstable Magic
addon.merges[198928]    = CreateMergeSpellEntry("MAGE", 1.5, 63)            -- Talent: Cinderstorm
addon.merges[217694]    = CreateMergeSpellEntry("MAGE", 3.5, 63)            -- Talent: Living Bomb (DoT)
addon.merges[44461]     = CreateMergeSpellEntry("MAGE", 0.5, 63)            -- Talent: Living Bomb (Explosion)
addon.merges[153564]    = CreateMergeSpellEntry("MAGE", 0.5, 63)            -- Talent: Meteor (Explosion)
addon.merges[155158]    = CreateMergeSpellEntry("MAGE", 2.5, 63)            -- Talent: Meteor (DoT)
addon.merges[194466]    = CreateMergeSpellEntry("MAGE", 0.5, 63)            -- Artifact: Phoenix's Flames
addon.merges[194522]    = CreateMergeSpellEntry("MAGE", 2.5, 63)            -- Artifact: Blast Furnace
addon.merges[215775]    = CreateMergeSpellEntry("MAGE", 1.5, 63)            -- Artifact: Phoenix Reborn
addon.merge2h[224637]   = 194466                                            -- [DD/Splash Merger] Phoenix's Flames
addon.merge2h[226757]   = 205345                                            -- [DD/Splash Merger] Conflagration
addon.merge2h[205472]   = 2120                                              -- [DD/DoT Merger] Talent: Flame Patch

-- Frost (ID: 64)
addon.merges[84721]     = CreateMergeSpellEntry("MAGE", 1.5, 64)            -- Frozen Orb
addon.merges[59638]     = CreateMergeSpellEntry("MAGE", 2.0, 64)            -- Talent: Mirror Images
addon.merges[157997]    = CreateMergeSpellEntry("MAGE", 0.5, 64)            -- Talent: Ice Nova
addon.merges[30455]     = CreateMergeSpellEntry("MAGE", 1.0, 64)            -- Talent: Spliting Ice
addon.merges[113092]    = CreateMergeSpellEntry("MAGE", 1.0, 64)            -- Talent: Frost Bomb
addon.merges[157978]    = CreateMergeSpellEntry("MAGE", 0.5, 64)            -- Talent: Unstable Magic
addon.merges[148022]    = CreateMergeSpellEntry("MAGE", 2.5, 64)            -- Icicles
addon.merges[190357]    = CreateMergeSpellEntry("MAGE", 2.5, 64)            -- Blizzard
addon.merges[153596]    = CreateMergeSpellEntry("MAGE", 2.5, 64)            -- Comet Storm


-- ---------------------------
-- Warlock                  --
-- ---------------------------

-- All Specs
addon.merges[689]       = CreateMergeSpellEntry("WARLOCK", 1.5, 0)          -- Drain Life

-- Affliction (ID: 265)
addon.merges[980]       = CreateMergeSpellEntry("WARLOCK", 2.5, 265)        -- Agony
addon.merges[146739]    = CreateMergeSpellEntry("WARLOCK", 2.5, 265)        -- Corruption
addon.merges[233490]    = CreateMergeSpellEntry("WARLOCK", 1.5, 265)        -- Unstable Affliction
addon.merges[27285]     = CreateMergeSpellEntry("WARLOCK", 0.5, 265)        -- Seed of Corruption
addon.merges[22703]     = CreateMergeSpellEntry("WARLOCK", 0.5, 265)        -- Infernal: Awakening
addon.merges[20153]     = CreateMergeSpellEntry("WARLOCK", 1.5, 265)        -- Infernal: Immolation
addon.merges[198590]    = CreateMergeSpellEntry("WARLOCK", 1.5, 265)        -- Talent: Drain Soul
addon.merges[205246]    = CreateMergeSpellEntry("WARLOCK", 1.5, 265)        -- Talent: Phantom Singularity
addon.merges[196100]    = CreateMergeSpellEntry("WARLOCK", 0.5, 265)        -- Talent: Grimoire of Sacrifice
addon.merges[218615]    = CreateMergeSpellEntry("WARLOCK", 0.5, 265)        -- Artifact: Harvester of Souls
addon.merges[199581]    = CreateMergeSpellEntry("WARLOCK", 0.5, 265)        -- Artifact: Soul Flame
addon.merge2h[233496]   = 233490                                            -- Unstable Affliction (Multiple Applications)
addon.merge2h[233499]   = 233490                                            -- Unstable Affliction (Multiple Applications)
addon.merge2h[233497]   = 233490                                            -- Unstable Affliction (Multiple Applications)
addon.merge2h[233498]   = 233490                                            -- Unstable Affliction (Multiple Applications)
addon.merge2h[231489]   = 233490                                            -- Unstable Affliction (Artifact: Compounding Horror)

-- Demonlogy (ID: 266)
addon.merges[603]       = CreateMergeSpellEntry("WARLOCK", 0.5, 266)        -- Doom
addon.merges[89753]     = CreateMergeSpellEntry("WARLOCK", 2.5, 266)        -- Felguard: Felstorm
addon.merges[104318]    = CreateMergeSpellEntry("WARLOCK", 1.5, 266)        -- Wild Imp: Fel Firebolt
addon.merges[193439]    = CreateMergeSpellEntry("WARLOCK", 1.5, 266)        -- Demonwrath
addon.merges[86040]     = CreateMergeSpellEntry("WARLOCK", 0.5, 266)        -- Hand of Gul'dan
addon.merges[196278]    = CreateMergeSpellEntry("WARLOCK", 0.5, 266)        -- Talent: Implosion
addon.merges[205231]    = CreateMergeSpellEntry("WARLOCK", 0.5, 266)        -- Talent: Summon Darkglare
addon.merges[211727]    = CreateMergeSpellEntry("WARLOCK", 0.5, 266)        -- Artifact: Thal'kiel's Discord
addon.merges[211714]    = CreateMergeSpellEntry("WARLOCK", 0.5, 266)        -- Artifact: Thal'kiel's Consumption (Demon Life Tap)

-- Destruction (ID: 267)
addon.merges[157736]    = CreateMergeSpellEntry("WARLOCK", 3.5, 267)        -- Immolate
addon.merges[29722]     = CreateMergeSpellEntry("WARLOCK", 0.5, 267)        -- Incinerate (Havoc / F&B Talent)
addon.merges[116858]    = CreateMergeSpellEntry("WARLOCK", 0.5, 267)        -- Choas Bolt (Havoc)
addon.merges[17962]     = CreateMergeSpellEntry("WARLOCK", 0.5, 267)        -- Conflagrate (Havoc)
addon.merges[42223]     = CreateMergeSpellEntry("WARLOCK", 2.5, 267)        -- Rain of Fire
addon.merges[152108]    = CreateMergeSpellEntry("WARLOCK", 0.5, 267)        -- Talent: Cataclysm
addon.merges[196448]    = CreateMergeSpellEntry("WARLOCK", 1.5, 267)        -- Talent: Channel Demonfire
addon.merges[187394]    = CreateMergeSpellEntry("WARLOCK", 1.5, 267)        -- Artifact: Dimensional Rift
addon.merge2h[348]      = 157736                                            -- [DD/DoT Merger] Immolate


-- ---------------------------
-- Monk                     --
-- ---------------------------

-- All Specs
addon.merges[130654]    = CreateMergeSpellEntry("MONK", 1.5, 0)             -- Chi Burst (Healing)
addon.merges[148135]    = CreateMergeSpellEntry("MONK", 1.5, 0)             -- Chi Burst (Damage)
addon.merges[196608]    = CreateMergeSpellEntry("MONK", 2.5, 0)             -- Talent: Eye of the Tiger
addon.merges[132467]    = CreateMergeSpellEntry("MONK", 1.5, 0)             -- Talent: Chi Wave (Damage)
addon.merges[132463]    = CreateMergeSpellEntry("MONK", 2.5, 0)             -- Talent: Chi Wave (Healing)
addon.merges[148187]    = CreateMergeSpellEntry("MONK", 1.5, 0)             -- Talent: Rushing Jade Wind
addon.merges[107270]    = CreateMergeSpellEntry("MONK", 1.5, 0)             -- Spinning Crane Kick
addon.merges[100784]    = CreateMergeSpellEntry("MONK", 1.0, 0)             -- Blackout Kick

-- Brewmaster (ID: 268)
addon.merges[124255]    = CreateMergeSpellEntry("MONK", 1.5, 268)           -- DmgTkn: Stagger
addon.merges[216521]    = CreateMergeSpellEntry("MONK", 1.0, 268)           -- Celestial Fortune
addon.merges[124507]    = CreateMergeSpellEntry("MONK", 0.5, 268)           -- Gift of the Ox
addon.merges[115181]    = CreateMergeSpellEntry("MONK", 0.5, 268)           -- Breath of Fire
addon.merges[123725]    = CreateMergeSpellEntry("MONK", 2.5, 268)           -- Breath of Fire (DoT)
addon.merges[121253]    = CreateMergeSpellEntry("MONK", 0.5, 268)           -- Keg Smash
addon.merges[130654]    = CreateMergeSpellEntry("MONK", 1.5, 268)           -- Chi Burst (Healing)
addon.merges[130654]    = CreateMergeSpellEntry("MONK", 1.5, 268)           -- Chi Burst (Damage)
addon.merges[227291]    = CreateMergeSpellEntry("MONK", 0.5, 268)           -- Talent: Niuzao, The Black Ox (Stomp)
addon.merges[196733]    = CreateMergeSpellEntry("MONK", 0.5, 268)           -- Talent: Special Delivery
addon.merges[214326]    = CreateMergeSpellEntry("MONK", 0.5, 268)           -- Artifact: Exploding Keg
addon.merges[227681]    = CreateMergeSpellEntry("MONK", 1.5, 268)           -- Artifact: Dragonfire Brew
addon.merge2h[178173]   = 124507                                            -- [Greater Merger] Artifact: Overflow (double check)

-- Windwalker (ID: 269)
addon.merges[117952]    = CreateMergeSpellEntry("MONK", 0.5, 269)           -- Crackling Jade Lightning (SEF)
addon.merges[124280]    = CreateMergeSpellEntry("MONK", 2.0, 269)           -- Touch of Karma
addon.merges[123586]    = CreateMergeSpellEntry("MONK", 0.5, 269)           -- Flying Serpent Kick
addon.merges[117418]    = CreateMergeSpellEntry("MONK", 2.0, 269)           -- Fists of Fury
addon.merges[100780]    = CreateMergeSpellEntry("MONK", 0.5, 269)           -- Tiger Palm (SEF)
addon.merges[185099]    = CreateMergeSpellEntry("MONK", 0.5, 269)           -- Rising Sun Kick (SEF)
addon.merges[196748]    = CreateMergeSpellEntry("MONK", 0.5, 269)           -- Talent: Chi Orbit
addon.merges[158221]    = CreateMergeSpellEntry("MONK", 0.5, 269)           -- Talent: Whirling Dragon Punch
addon.merges[222029]    = CreateMergeSpellEntry("MONK", 0.5, 269)           -- Artifact: Strike of the Windlord
addon.merge2h[205414]   = 222029                                            -- [MH/OH Merger] Artifact: Strike of the Windlord
addon.merge2h[196061]   = 117418                                            -- [DMG Merger] Artifact: Crosswinds

-- Mistweaver (ID: 270)
addon.merges[115175]    = CreateMergeSpellEntry("MONK", 1.5, 270)           -- Soothing Mist
addon.merges[124682]    = CreateMergeSpellEntry("MONK", 1.5, 270)           -- Eneloping Mist
addon.merges[191840]    = CreateMergeSpellEntry("MONK", 1.5, 270)           -- Essence Font
addon.merges[119611]    = CreateMergeSpellEntry("MONK", 2.0, 270)           -- Renewing Mists
addon.merges[115310]    = CreateMergeSpellEntry("MONK", 0.5, 270)           -- Revival
addon.merges[116670]    = CreateMergeSpellEntry("MONK", 0.5, 270)           -- Vivify
addon.merges[124081]    = CreateMergeSpellEntry("MONK", 1.5, 270)           -- Talent: Zen Pulse
addon.merges[162530]    = CreateMergeSpellEntry("MONK", 1.5, 270)           -- Talent: Refreshing Jade Wind
addon.merges[198756]    = CreateMergeSpellEntry("MONK", 2.5, 270)           -- Talent: Invoke Chi'Ji
addon.merges[199668]    = CreateMergeSpellEntry("MONK", 2.0, 270)           -- Artifact: Blessing of Yu'lon
addon.merges[199656]    = CreateMergeSpellEntry("MONK", 2.0, 270)           -- Artifact: Celestial Breath
addon.merge2h[198533]   = 115175                                            -- [Statue Merger] Talent: Jade Serpent Statue
addon.merge2h[228649]   = 100784                                            -- [Passive Merger] Teachings of the Monastery


-- ---------------------------
-- Druid                    --
-- ---------------------------

-- All Specs
addon.merges[164812]    = CreateMergeSpellEntry("DRUID", 2.5, 0)            -- Moonfire
addon.merges[164815]    = CreateMergeSpellEntry("DRUID", 2.5, 0)            -- Sunfire

-- Balance (ID: 102)
addon.merges[194153]    = CreateMergeSpellEntry("DRUID", 0.5, 102)          -- Lunar Strike
addon.merges[191037]    = CreateMergeSpellEntry("DRUID", 2.0, 102)          -- Starfall
addon.merges[202347]    = CreateMergeSpellEntry("DRUID", 2.5, 102)          -- Talent: Stellar Flare
addon.merges[202497]    = CreateMergeSpellEntry("DRUID", 2.5, 102)          -- Talent: Shooting Stars
addon.merges[211545]    = CreateMergeSpellEntry("DRUID", 2.5, 102)          -- Talent: Fury of Elune
addon.merges[202771]    = CreateMergeSpellEntry("DRUID", 0.5, 102)          -- Artifact: Full Moon
addon.merge2h[226104]   = 191037                                            -- Artifact: Echoing Stars

-- Feral (ID: 103)
addon.merges[106785]    = CreateMergeSpellEntry("DRUID", 0.5, 103)          -- Swipe (Cat)
addon.merges[106830]    = CreateMergeSpellEntry("DRUID", 2.5, 103)          -- Thrash (Cat)
addon.merges[155722]    = CreateMergeSpellEntry("DRUID", 2.5, 103)          -- Rake
addon.merges[1079]      = CreateMergeSpellEntry("DRUID", 2.5, 103)          -- Rip
addon.merges[155625]    = CreateMergeSpellEntry("DRUID", 2.5, 103)          -- Talent: Lunar Inspiration
addon.merges[202028]    = CreateMergeSpellEntry("DRUID", 0.5, 103)          -- Talent: Brutal Slash
addon.merges[210723]    = CreateMergeSpellEntry("DRUID", 1.5, 103)          -- Artifact: Ashamane's Frenzy
addon.merges[210687]    = CreateMergeSpellEntry("DRUID", 0.5, 103)          -- Artifact: Shadow Thrash
addon.merge2h[1822]     = 155722                                            -- [DD/DoT Merger] Rake

-- Guardian (ID: 104)
addon.merges[227034]    = CreateMergeSpellEntry("DRUID", 1.5, 104)          -- Mastery: Nature's Guardian
addon.merges[22842]     = CreateMergeSpellEntry("DRUID", 1.5, 104)          -- Frenzied Regeneration
addon.merges[33917]     = CreateMergeSpellEntry("DRUID", 0.5, 104)          -- Mangle (Incarnation Cleave)
addon.merges[213771]    = CreateMergeSpellEntry("DRUID", 0.5, 104)          -- Swipe (Bear)
addon.merges[77758]     = CreateMergeSpellEntry("DRUID", 2.5, 104)          -- Thrash (Bear)
addon.merges[213709]    = CreateMergeSpellEntry("DRUID", 2.5, 104)          -- Talent: Brambles
addon.merges[204069]    = CreateMergeSpellEntry("DRUID", 2.5, 104)          -- Talent: Lunbar Beam
addon.merges[219432]    = CreateMergeSpellEntry("DRUID", 2.5, 104)          -- Artifact: Rage of the Sleeper
addon.merge2h[192090]   = 77758                                             -- [DD/DoT Merger] Thrash
addon.merge2h[203958]   = 213709                                            -- [Barkskin Merger] Brambles

-- Restoration (Druid) (ID: 105)
addon.merges[81269]     = CreateMergeSpellEntry("DRUID", 1.5, 105)          -- Efflorescence
addon.merges[33763]     = CreateMergeSpellEntry("DRUID", 1.5, 105)          -- Lifebloom
addon.merges[774]       = CreateMergeSpellEntry("DRUID", 3.5, 105)          -- Rejuvenation
addon.merges[8936]      = CreateMergeSpellEntry("DRUID", 2.5, 105)          -- Regrowth
addon.merges[157982]    = CreateMergeSpellEntry("DRUID", 2.5, 105)          -- Tranquility
addon.merges[48438]     = CreateMergeSpellEntry("DRUID", 2.5, 105)          -- Wild Growth (Instant)
addon.merges[42231]     = CreateMergeSpellEntry("DRUID", 2.5, 105)          -- Hurricane
addon.merges[200389]    = CreateMergeSpellEntry("DRUID", 3.5, 105)          -- Talent: Cultivation
addon.merges[189853]    = CreateMergeSpellEntry("DRUID", 0.5, 105)          -- Artifact: Dreamwalker
addon.merge2h[189800]   = 48438                                             -- [HoT/Artifact Merger] Nature's Essence
addon.merge2h[155777]   = 774                                               -- [HoT/HoT Merger] Talent: Germination
addon.merge2h[207386]   = 81269                                             -- [Heal/HoT Merger] Talent: Spring Blossom


-- ---------------------------
-- Demon Hunter             --
-- ---------------------------

-- Havoc (ID: 577)
addon.merges[222031]    = CreateMergeSpellEntry("DEMONHUNTER", 3.0, 577)    -- Chaos Strike (server side delay?)
addon.merges[185123]    = CreateMergeSpellEntry("DEMONHUNTER", 1.5, 577)    -- Throw Glaive (Havoc)
addon.merges[198030]    = CreateMergeSpellEntry("DEMONHUNTER", 1.5, 577)    -- Eye Beam
addon.merges[192611]    = CreateMergeSpellEntry("DEMONHUNTER", 1.5, 577)    -- Fel Rush
addon.merges[185123]    = CreateMergeSpellEntry("DEMONHUNTER", 1.5, 577)    -- Throw Glaive
addon.merges[199552]    = CreateMergeSpellEntry("DEMONHUNTER", 2.0, 577)    -- Blade Dance
addon.merges[200166]    = CreateMergeSpellEntry("DEMONHUNTER", 0.5, 577)    -- Metamorphosis (Landing)
addon.merges[198813]    = CreateMergeSpellEntry("DEMONHUNTER", 0.5, 577)    -- Vengeful Retreat
addon.merges[179057]    = CreateMergeSpellEntry("DEMONHUNTER", 0.5, 577)    -- Chaos Nova
addon.merges[203796]    = CreateMergeSpellEntry("DEMONHUNTER", 2.5, 577)    -- Talent: Demon Blades
addon.merges[211052]    = CreateMergeSpellEntry("DEMONHUNTER", 1.5, 577)    -- Talent: Fel Barrage
addon.merges[202388]    = CreateMergeSpellEntry("DEMONHUNTER", 0.5, 577)    -- Artifact: Inner Demons
addon.merges[201628]    = CreateMergeSpellEntry("DEMONHUNTER", 1.5, 577)    -- Artifact: Fury of the Illidari
addon.merges[217070]    = CreateMergeSpellEntry("DEMONHUNTER", 0.5, 577)    -- Artifact: Rage of the Illidari
addon.merges[202446]    = CreateMergeSpellEntry("DEMONHUNTER", 0.5, 577)    -- Artifact: Anguish
addon.merge2h[199547]   = 222031                                            -- [MH/OH Merger] Chaos Strike
addon.merge2h[200685]   = 199552                                            -- [MH/OH Merger] Blade Dance
addon.merge2h[201789]   = 201628                                            -- [MH/OH Merger] Fury of the Illidari

-- Vengeance  (ID: 581)
addon.merges[204157]    = CreateMergeSpellEntry("DEMONHUNTER", 1.5, 581)    -- Throw Glaive (Vengeance)
addon.merges[187727]    = CreateMergeSpellEntry("DEMONHUNTER", 2.5, 581)    -- Immolation Aura
addon.merges[204598]    = CreateMergeSpellEntry("DEMONHUNTER", 2.5, 581)    -- Sigil of Flame
addon.merges[189112]    = CreateMergeSpellEntry("DEMONHUNTER", 0.5, 581)    -- Infernal Strike
addon.merges[222030]    = CreateMergeSpellEntry("DEMONHUNTER", 0.5, 581)    -- Soul Cleave
addon.merges[203794]    = CreateMergeSpellEntry("DEMONHUNTER", 1.5, 581)    -- Consume Soul
addon.merges[207771]    = CreateMergeSpellEntry("DEMONHUNTER", 2.5, 581)    -- Talent: Burning Alive
addon.merges[227255]    = CreateMergeSpellEntry("DEMONHUNTER", 1.5, 581)    -- Talent: Fel Devastation
addon.merges[218677]    = CreateMergeSpellEntry("DEMONHUNTER", 0.5, 581)    -- Talent: Spirit Bomb
addon.merges[218677]    = CreateMergeSpellEntry("DEMONHUNTER", 1.5, 581)    -- Talent: Spirit Bomb (Frailty Heal)
addon.merges[213011]    = CreateMergeSpellEntry("DEMONHUNTER", 2.5, 581)    -- Artifact: Charred Warblades
addon.merges[207407]    = CreateMergeSpellEntry("DEMONHUNTER", 1.5, 581)    -- Artifact: Soul Carver (DoT)
addon.merge2h[178741]   = 187727                                            -- [DD/DoT Merger] Immolation Aura
addon.merge2h[208038]   = 222030                                            -- [DD/DoT Merger] Soul Cleave
addon.merge2h[214743]   = 207407                                            -- [DD/DoT Merger] Soul Cleave
addon.merge2h[212106]   = 227255                                            -- [MH/OH Merger] Fel Devastation
addon.merge2h[212084]   = 227255                                            -- Reported From Curse: Should be Fel Devastation


-- ---------------------------
-- Death Knight             --
-- ---------------------------

-- All Specs
addon.merges[52212]     = CreateMergeSpellEntry("DEATHKNIGHT", 2.5, 0)      -- Death and Decay

-- Blood (ID: 250)
addon.merges[55078]     = CreateMergeSpellEntry("DEATHKNIGHT", 3.5, 250)    -- Blood Plague
addon.merges[50842]     = CreateMergeSpellEntry("DEATHKNIGHT", 0.5, 250)    -- Blood Boil
addon.merges[195292]    = CreateMergeSpellEntry("DEATHKNIGHT", 0.5, 250)    -- Death's Caress (DRW)
addon.merges[49998]     = CreateMergeSpellEntry("DEATHKNIGHT", 0.5, 250)    -- Death Strike (DRW)
addon.merges[206930]    = CreateMergeSpellEntry("DEATHKNIGHT", 0.5, 250)    -- Heart Strike
addon.merges[212744]    = CreateMergeSpellEntry("DEATHKNIGHT", 0.5, 250)    -- Talent: Soulgorge
addon.merges[196528]    = CreateMergeSpellEntry("DEATHKNIGHT", 1.5, 250)    -- Talent: Bonestorm (DMG)
addon.merges[196545]    = CreateMergeSpellEntry("DEATHKNIGHT", 1.5, 250)    -- Talent: Bonestorm (Heal)
addon.merges[205223]    = CreateMergeSpellEntry("DEATHKNIGHT", 0.5, 250)    -- Artifact: Consumption (DMG)
addon.merges[205224]    = CreateMergeSpellEntry("DEATHKNIGHT", 0.5, 250)    -- Artifact: Consumption (Heal)
addon.merges[203166]    = CreateMergeSpellEntry("DEATHKNIGHT", 2.5, 250)    -- PVP Talent: Blight (ID: 203172)
addon.merges[203174]    = CreateMergeSpellEntry("DEATHKNIGHT", 0.5, 250)    -- PVP Talent: Death Chain (ID: 203173)

-- Frost (ID: 251)
addon.merges[196771]    = CreateMergeSpellEntry("DEATHKNIGHT", 2.5, 251)    -- Remorseless Winter
addon.merges[55095]     = CreateMergeSpellEntry("DEATHKNIGHT", 3.5, 251)    -- Frost Fever
addon.merges[49184]     = CreateMergeSpellEntry("DEATHKNIGHT", 0.5, 251)    -- Howling Blast
addon.merges[222024]    = CreateMergeSpellEntry("DEATHKNIGHT", 3.0, 251)    -- Obliterate (For Merge)
addon.merges[222026]    = CreateMergeSpellEntry("DEATHKNIGHT", 3.0, 251)    -- Frost Strike (For Merge)
addon.merges[207194]    = CreateMergeSpellEntry("DEATHKNIGHT", 0.5, 251)    -- Talent: Volatile Shielding
addon.merges[195750]    = CreateMergeSpellEntry("DEATHKNIGHT", 0.5, 251)    -- Talent: Frozen Pulse
addon.merges[207150]    = CreateMergeSpellEntry("DEATHKNIGHT", 0.5, 251)    -- Talent: Avalanche
addon.merges[207230]    = CreateMergeSpellEntry("DEATHKNIGHT", 0.5, 251)    -- Talent: Frostscythe
addon.merges[195975]    = CreateMergeSpellEntry("DEATHKNIGHT", 0.5, 251)    -- Talent: Glacial Advance
addon.merges[155166]    = CreateMergeSpellEntry("DEATHKNIGHT", 2.5, 251)    -- Talent: Breath of Sindragosa
addon.merges[190780]    = CreateMergeSpellEntry("DEATHKNIGHT", 1.5, 251)    -- Artifact: Sindragosa's Fury
addon.merges[204959]    = CreateMergeSpellEntry("DEATHKNIGHT", 0.5, 251)    -- Artifact: Frozen Soul
addon.merge2h[66198]    = 222024                                            -- [MH/OH Merger] Obliterate
addon.merge2h[66196]    = 222026                                            -- [MH/OH Merger] Frost Strike

-- Unholy (ID: 252)
addon.merges[215969]    = CreateMergeSpellEntry("DEATHKNIGHT", 0.5, 252)    -- Virulent Plague (DoT)
addon.merges[70890]     = CreateMergeSpellEntry("DEATHKNIGHT", 3.0, 252)    -- Scourge Strike
addon.merges[194311]    = CreateMergeSpellEntry("DEATHKNIGHT", 0.5, 252)    -- Festering Wound
addon.merges[91778]     = CreateMergeSpellEntry("DEATHKNIGHT", 0.5, 252)    -- Pet: Sweeping Claws
addon.merges[199373]    = CreateMergeSpellEntry("DEATHKNIGHT", 2.5, 252)    -- Army: Claw
addon.merges[191587]    = CreateMergeSpellEntry("DEATHKNIGHT", 2.5, 252)    -- Virulent Plague (DoT)
addon.merges[218321]    = CreateMergeSpellEntry("DEATHKNIGHT", 1.5, 252)    -- Artifact: Dragged to Helheim
addon.merges[191758]    = CreateMergeSpellEntry("DEATHKNIGHT", 0.5, 252)    -- Artifact: Corpse Explosion
addon.merges[207267]    = CreateMergeSpellEntry("DEATHKNIGHT", 0.5, 252)    -- Talent: Dragged to Helheim
addon.merges[212338]    = CreateMergeSpellEntry("DEATHKNIGHT", 0.5, 252)    -- Talent: Sludge Belcher
addon.merges[212739]    = CreateMergeSpellEntry("DEATHKNIGHT", 0.5, 252)    -- Talent: Epidemic
addon.merges[156000]    = CreateMergeSpellEntry("DEATHKNIGHT", 2.5, 252)    -- Talent: Defile
addon.merge2h[55090]    = 70890                                             -- [Cleave Merger] Scourge Strike
addon.merge2h[191685]   = 215969                                            -- [DD/DoT Merger] Virulent Plague Eruption
addon.merge2h[212969]   = 212739                                            -- [DD/DoT Merger] Talent: Epidemic
