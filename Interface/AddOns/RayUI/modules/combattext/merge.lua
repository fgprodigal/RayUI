----------------------------------------------------------
-- Load RayUI Environment
----------------------------------------------------------
RayUI:LoadEnv("CombatText")


local CT = _CombatText

_Merges = {}
_Merges2H = {}
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
_Merges[152150]    = CreateMergeSpellEntry("ROGUE", 0.5, 0)            -- Death from Above
_Merges[209043]    = CreateMergeSpellEntry("ROGUE", 0.5, 0)            -- Insignia of Ravenholdt (Legendary Ring - All Specs)

-- Assassination (ID: 259)
_Merges[5374]      = CreateMergeSpellEntry("ROGUE", 0.5, 259)          -- Mutilate (MH)
_Merges[2818]      = CreateMergeSpellEntry("ROGUE", 3.5, 259)          -- Deadly Poison (DoT)
_Merges[113780]    = CreateMergeSpellEntry("ROGUE", 0.5, 259)          -- Deadly Poison (Instant)
_Merges[51723]     = CreateMergeSpellEntry("ROGUE", 0.5, 259)          -- Fan of Knives
_Merges[192660]    = CreateMergeSpellEntry("ROGUE", 2.5, 259)          -- Poison Bomb
_Merges2H[192380]   = 113780                                            -- Artifact: Poison Knives
_Merges2H[27576]    = 5374                                              -- Mutilate (OH)

-- Outlaw (ID: 260)
_Merges[22482]     = CreateMergeSpellEntry("ROGUE", 1.5, 260)          -- Blade Flurry
_Merges[57841]     = CreateMergeSpellEntry("ROGUE", 3.5, 260)          -- Killing Spree
_Merges[185779]    = CreateMergeSpellEntry("ROGUE", 2.0, 260)          -- Talent: Cannonball Barrage
_Merges[202822]    = CreateMergeSpellEntry("ROGUE", 0.5, 260)          -- Artifact: Greed
_Merges[193315]    = CreateMergeSpellEntry("ROGUE", 0.5, 260)          -- Saber Slash
_Merges2H[202823]   = 202822                                            -- [MH/OH Merger] Artifact: Greed
_Merges2H[197834]   = 193315                                            -- [Proc Merger] Saber Slash

-- Sublety (ID: 261)
_Merges[197835]    = CreateMergeSpellEntry("ROGUE", 0.5, 261)          -- Shuriken Storm
_Merges[197800]    = CreateMergeSpellEntry("ROGUE", 0.5, 261)          -- Shadow Nova



-- ---------------------------
-- Warrior                  --
-- ---------------------------

-- All Specs
_Merges[52174]     = CreateMergeSpellEntry("WARRIOR", 0.5, 0)          -- Heroic Leap
_Merges[46968]     = CreateMergeSpellEntry("WARRIOR", 0.5, 0)          -- Shockwave
_Merges[156287]    = CreateMergeSpellEntry("WARRIOR", 2.5, 0)          -- Ravager

-- Arms (ID: 71)
_Merges[845]       = CreateMergeSpellEntry("WARRIOR", 0.5, 71)         -- Cleave
_Merges[12294]     = CreateMergeSpellEntry("WARRIOR", 0.5, 71)         -- Talent: Sweeping Strikes (Mortal Strike)
_Merges[772]       = CreateMergeSpellEntry("WARRIOR", 3.5, 71)         -- Talent: Rend
_Merges[215537]    = CreateMergeSpellEntry("WARRIOR", 2.5, 71)         -- Talent: Trauma
_Merges[209569]    = CreateMergeSpellEntry("WARRIOR", 2.5, 71)         -- Artifact: Corrupted Blood of Zakajz
_Merges[209700]    = CreateMergeSpellEntry("WARRIOR", 0.5, 71)         -- Artifact: Void Cleave
_Merges[209577]    = CreateMergeSpellEntry("WARRIOR", 2.5, 71)         -- Artifact: Warbreaker
_Merges[199658]    = CreateMergeSpellEntry("WARRIOR", 1.5, 71)         -- Whirlwind
_Merges2H[199850]   = 199658                                            -- [Spell Merger] Whirlwind

-- Fury (ID: 72)
_Merges[184367]    = CreateMergeSpellEntry("WARRIOR", 2.5, 72)         -- Rampage (Red Face Icon)
_Merges[96103]     = CreateMergeSpellEntry("WARRIOR", 0.5, 72)         -- Raging Blow
_Merges[199667]    = CreateMergeSpellEntry("WARRIOR", 1.5, 72)         -- Whirlwind
_Merges[23881]     = CreateMergeSpellEntry("WARRIOR", 0.5, 72)         -- Bloodthirst (Whirlwind: Meat Cleaver)
_Merges[113344]    = CreateMergeSpellEntry("WARRIOR", 2.5, 72)         -- Talent: Bloodbath
_Merges[118000]    = CreateMergeSpellEntry("WARRIOR", 0.5, 72)         -- Talent: Dragon Roar
_Merges[50622]     = CreateMergeSpellEntry("WARRIOR", 2.5, 72)         -- Talent: Bladestorm
_Merges[205546]    = CreateMergeSpellEntry("WARRIOR", 3.0, 72)         -- Artifact: Odyn's Fury (DoT)
_Merges2H[205547]   = 205546                                            -- Artifact: Odyn's Fury (Hit)
_Merges2H[85384]    = 96103                                             -- [MH/OH] Raging Blow
_Merges2H[44949]    = 199667                                            -- [MH/OH] Whirlwind
_Merges2H[95738]    = 50622                                             -- [MH/OH] Bladestorm
_Merges2H[218617]   = 184367                                            -- Rampage (1st Hit)
_Merges2H[184707]   = 184367                                            -- Rampage (2nd Hit)
_Merges2H[184709]   = 184367                                            -- Rampage (3rd Hit)
_Merges2H[201364]   = 184367                                            -- Rampage (4th Hit)
_Merges2H[201363]   = 184367                                            -- Rampage (5th Hit)

-- Protection (ID: 73)
_Merges[6572]      = CreateMergeSpellEntry("WARRIOR", 0.5, 73)         -- Revenge
_Merges[115767]    = CreateMergeSpellEntry("WARRIOR", 3.5, 73)         -- Deep Wounds
_Merges[6343]      = CreateMergeSpellEntry("WARRIOR", 0.5, 73)         -- Thunder Clap
_Merges[7922]      = CreateMergeSpellEntry("WARRIOR", 0.5, 73)         -- Talent: Warbringer
_Merges[222944]    = CreateMergeSpellEntry("WARRIOR", 3.0, 73)         -- Talent: Inspiring Presence
_Merges[203526]    = CreateMergeSpellEntry("WARRIOR", 3.5, 73)         -- Artifact: Neltharion's Fury


-- ---------------------------
-- Priest                   --
-- ---------------------------

-- All Specs
_Merges[589]       = CreateMergeSpellEntry("PRIEST", 2.5, 0)           -- Shadow Word: Pain
_Merges[122128]    = CreateMergeSpellEntry("PRIEST", 2.5, 0)           -- Talent: Divine Star (Damage)
_Merges[110745]    = CreateMergeSpellEntry("PRIEST", 2.5, 0)           -- Talent: Divine Star (Heal)
_Merges[120696]    = CreateMergeSpellEntry("PRIEST", 2.0, 0)           -- Talent: Halo (Damage)
_Merges[120692]    = CreateMergeSpellEntry("PRIEST", 2.0, 0)           -- Talent: Halo (Heal)
-- Discipline (ID: 256)
_Merges[81751]     = CreateMergeSpellEntry("PRIEST", 2.5, 256)         -- Atonement
_Merges[47666]     = CreateMergeSpellEntry("PRIEST", 2.5, 256)         -- Penance (Heal)
_Merges[194509]    = CreateMergeSpellEntry("PRIEST", 0.5, 256)         -- Power Word: Radiance
_Merges[204065]    = CreateMergeSpellEntry("PRIEST", 0.5, 256)         -- Talent: Shadow Covenant
_Merges[47750]     = CreateMergeSpellEntry("PRIEST", 2.5, 256)         -- Talent: Penance (Damage)
_Merges[204213]    = CreateMergeSpellEntry("PRIEST", 2.5, 256)         -- Talent: Purge the Wicked (DoT)
_Merges2H[204197]   = 204213                                            -- Talent: Purge the Wicked (Instant)

-- Holy (ID: 257)
_Merges[139]       = CreateMergeSpellEntry("PRIEST", 3.5, 257)         -- Renew
_Merges[14914]     = CreateMergeSpellEntry("PRIEST", 2.5, 257)         -- Holy Fire
_Merges[132157]    = CreateMergeSpellEntry("PRIEST", 0.5, 257)         -- Holy Nova
_Merges[34861]     = CreateMergeSpellEntry("PRIEST", 0.5, 257)         -- Holy Word: Sanctify
_Merges[596]       = CreateMergeSpellEntry("PRIEST", 0.5, 257)         -- Prayer of Healing
_Merges[77489]     = CreateMergeSpellEntry("PRIEST", 3.5, 257)         -- Mastery: Echo of Light
_Merges[2061]      = CreateMergeSpellEntry("PRIEST", 0.5, 257)         -- Talent: Trail of Light (Flash Heal)
_Merges[32546]     = CreateMergeSpellEntry("PRIEST", 0.5, 257)         -- Talent: Binding Heal
_Merges[204883]    = CreateMergeSpellEntry("PRIEST", 0.5, 257)         -- Talent: Circle of Healing

-- Shadow (ID: 258)
_Merges[49821]     = CreateMergeSpellEntry("PRIEST", 1.5, 258)         -- Mind Sear
_Merges[34914]     = CreateMergeSpellEntry("PRIEST", 2.5, 258)         -- Vampiric Touch
_Merges[148859]    = CreateMergeSpellEntry("PRIEST", 2.5, 258)         -- Shadowy Apparition
_Merges[15407]     = CreateMergeSpellEntry("PRIEST", 2.0, 258)         -- Mind Flay
_Merges[205386]    = CreateMergeSpellEntry("PRIEST", 0.5, 258)         -- Talent: Shadow Crash
_Merges[217676]    = CreateMergeSpellEntry("PRIEST", 0.5, 258)         -- Talent: Mind Spike
_Merges[193473]    = CreateMergeSpellEntry("PRIEST", 2.0, 258)         -- Artifact: Void Tendril (Mind Flay)
_Merges[205065]    = CreateMergeSpellEntry("PRIEST", 2.0, 258)         -- Artifact: Void Torrent
_Merges[194238]    = CreateMergeSpellEntry("PRIEST", 2.5, 258)         -- Artifact: Sphere of Insanity
_Merges[204778]    = CreateMergeSpellEntry("PRIEST", 2.5, 258)         -- Honor Talent: Void Shield


-- ---------------------------
-- Paladin                  --
-- ---------------------------

-- All Specs
_Merges[81297]     = CreateMergeSpellEntry("PALADIN", 2.5, 0)          -- Consecration
_Merges[105421]    = CreateMergeSpellEntry("PALADIN", 0.5, 0)          -- Talent: Blinding Light
_Merges[183811]    = CreateMergeSpellEntry("PALADIN", 2.5, 0)          -- Talent: Judgment of Light

-- Holy (ID: 65)
_Merges[225311]    = CreateMergeSpellEntry("PALADIN", 0.5, 65)         -- Light of Dawn
_Merges[53652]     = CreateMergeSpellEntry("PALADIN", 1.5, 65)         -- Becon of Light
_Merges[119952]    = CreateMergeSpellEntry("PALADIN", 2.5, 65)         -- Talent: Light's Hammer (Heal)
_Merges[114919]    = CreateMergeSpellEntry("PALADIN", 2.5, 65)         -- Talent: Light's Hammer (Damage)
_Merges[114852]    = CreateMergeSpellEntry("PALADIN", 0.5, 65)         -- Talent: Holy Prism (Heal)
_Merges[114871]    = CreateMergeSpellEntry("PALADIN", 0.5, 65)         -- Talent: Holy Prism (Damage)
_Merges[210291]    = CreateMergeSpellEntry("PALADIN", 2.5, 65)         -- Talent: Aura of Mercy
_Merges[200654]    = CreateMergeSpellEntry("PALADIN", 2.5, 65)         -- Artifact: Tyr's Deliverance

-- Protection (ID: 66)
_Merges[31935]     = CreateMergeSpellEntry("PALADIN", 1.5, 66)         -- Avenger's Shield
_Merges[88263]     = CreateMergeSpellEntry("PALADIN", 0.5, 66)         -- Hammer of the Righteous
_Merges[204301]    = CreateMergeSpellEntry("PALADIN", 2.5, 66)         -- Blessed Hammer
_Merges[209478]    = CreateMergeSpellEntry("PALADIN", 1.5, 66)         -- Artifact: Tyr's Enforcer
_Merges[209202]    = CreateMergeSpellEntry("PALADIN", 0.5, 66)         -- Artifact: Eye of Tyr

-- Retribution (ID: 70)
_Merges[224266]    = CreateMergeSpellEntry("PALADIN", 1.0, 70)         -- Templar's Verdict (Echo of the Highlord) *Delay on second hit
_Merges[205729]    = CreateMergeSpellEntry("PALADIN", 1.0, 70)         -- Greater Blessing of Might
_Merges[217020]    = CreateMergeSpellEntry("PALADIN", 0.5, 70)         -- Zeal
_Merges[203539]    = CreateMergeSpellEntry("PALADIN", 5.5, 70)         -- Greater Blessings of Wisdom
_Merges[184689]    = CreateMergeSpellEntry("PALADIN", 0.5, 70)         -- Shield of Vengeance
_Merges[20271]     = CreateMergeSpellEntry("PALADIN", 1.5, 70)         -- Talent: Greater Judgment
_Merges[198137]    = CreateMergeSpellEntry("PALADIN", 2.5, 70)         -- Talent: Divine Hammer
_Merges[210220]    = CreateMergeSpellEntry("PALADIN", 0.5, 70)         -- Talent: Holy Wrath
_Merges[205273]    = CreateMergeSpellEntry("PALADIN", 2.0, 70)         -- Artifact: Wake of Ashes
_Merges[224239]    = CreateMergeSpellEntry("PALADIN", 1.5, 70)         -- Artifact: Divine Tempest (Divine Storm)
_Merges[20271]     = CreateMergeSpellEntry("PALADIN", 0.5, 70)         -- Judgment
_Merges2H[228288]   = 20271                                             -- [Bounce Merger] Judgment
_Merges2H[216527]   = 20271                                             -- [PvP Talent] Lawbringer


-- ---------------------------
-- Hunter                   --
-- ---------------------------

-- All Specs
_Merges[2643]      = CreateMergeSpellEntry("HUNTER", 0.5, 0)           -- Multi-Shot
_Merges[131900]    = CreateMergeSpellEntry("HUNTER", 2.5, 0)           -- Talent: A Murder of Crows
_Merges[194392]    = CreateMergeSpellEntry("HUNTER", 0.5, 0)           -- Talent: Volley
_Merges[120361]    = CreateMergeSpellEntry("HUNTER", 1.5, 0)           -- Talent: Barrage

-- Beast Mastery (ID: 253)
_Merges[118459]    = CreateMergeSpellEntry("HUNTER", 2.5, 253)         -- Pet: Beast Cleave
_Merges[201754]    = CreateMergeSpellEntry("HUNTER", 0.5, 253)         -- Talent: Stomp
_Merges[217207]    = CreateMergeSpellEntry("HUNTER", 0.5, 253)         -- Talent: Dire Frenzy
_Merges[171454]    = CreateMergeSpellEntry("HUNTER", 0.5, 253)         -- Talent: Chimaera Shot
_Merges[197465]    = CreateMergeSpellEntry("HUNTER", 0.5, 253)         -- Artifact: Surge of the Stormgod
_Merges[207097]    = CreateMergeSpellEntry("HUNTER", 1.5, 253)         -- Artifact: Titan's Thunder
_Merges2H[171457]   = 171454                                            -- [Cleave Merger] Chimaera Shot

-- Marksmanship (ID: 254)
_Merges[19434]     = CreateMergeSpellEntry("HUNTER", 0.5, 254)         -- Aimed Shot (Talent: Trick Shot + Windburst)
_Merges[212621]    = CreateMergeSpellEntry("HUNTER", 0.5, 254)         -- Marked Shot
_Merges[186387]    = CreateMergeSpellEntry("HUNTER", 0.5, 254)         -- Bursting Shot
_Merges[212680]    = CreateMergeSpellEntry("HUNTER", 0.5, 254)         -- Talent: Explosive Shot
_Merges[214581]    = CreateMergeSpellEntry("HUNTER", 1.5, 254)         -- Talent: Sidewinders
_Merges[198670]    = CreateMergeSpellEntry("HUNTER", 0.5, 254)         -- Talent: Piercing Shot
_Merges[191070]    = CreateMergeSpellEntry("HUNTER", 0.5, 254)         -- Artifact: Call of the Hunter
_Merges2H[191043]   = 19434                                             -- Windburst

-- Survival (ID: 255)
_Merges[187708]    = CreateMergeSpellEntry("HUNTER", 0.5, 255)         -- Carve
_Merges[13812]     = CreateMergeSpellEntry("HUNTER", 2.5, 255)         -- Explosive Trap
_Merges[194279]    = CreateMergeSpellEntry("HUNTER", 2.5, 255)         -- Talent: Caltrops
_Merges[212436]    = CreateMergeSpellEntry("HUNTER", 0.5, 255)         -- Talent: Butchery
_Merges[203413]    = CreateMergeSpellEntry("HUNTER", 2.5, 255)         -- Artifact: Fury of the Eagle
_Merges[194859]    = CreateMergeSpellEntry("HUNTER", 2.5, 255)         -- Artifact: Dragonsfire Conflagration
_Merges[194858]    = CreateMergeSpellEntry("HUNTER", 2.5, 255)         -- Artifact: Dragonsfire Grenade
_Merges[164857]    = CreateMergeSpellEntry("HUNTER", 5.0, 255)         -- Passive: Survivalist


-- ---------------------------
-- Shaman                   --
-- ---------------------------

-- Elemental (ID: 262)
_Merges[51505]     = CreateMergeSpellEntry("SHAMAN", 1.0, 262)         -- Lavaburst (Elemental)
_Merges[188196]    = CreateMergeSpellEntry("SHAMAN", 1.0, 262)         -- Lightning Bolt (Elemental)
_Merges[188443]    = CreateMergeSpellEntry("SHAMAN", 1.5, 262)         -- Chain Lightning (Elemental)
_Merges[77478]     = CreateMergeSpellEntry("SHAMAN", 1.5, 262)         -- Earthquake
_Merges[191732]    = CreateMergeSpellEntry("SHAMAN", 1.5, 262)         -- Artifact Greater Lightning Elemental
_Merges[205533]    = CreateMergeSpellEntry("SHAMAN", 1.5, 262)         -- Artifact Greater Lightning Elemental
_Merges[188389]    = CreateMergeSpellEntry("SHAMAN", 2.5, 262)         -- Flame Shock
_Merges[51490]     = CreateMergeSpellEntry("SHAMAN", 0.5, 262)         -- Thunderstorm
_Merges[192231]    = CreateMergeSpellEntry("SHAMAN", 2.5, 262)         -- Talent: Liquid Magma Totem
_Merges[170379]    = CreateMergeSpellEntry("SHAMAN", 2.0, 262)         -- Talent: Earthn Rage
_Merges[197568]    = CreateMergeSpellEntry("SHAMAN", 0.5, 262)         -- Talent: Lightning Rod
_Merges[117588]    = CreateMergeSpellEntry("SHAMAN", 0.5, 262)         -- Talent: Primal Elementalist [Fire]
_Merges2H[77451]    = 51505                                             -- [Mastery Merger] Lavaburst Overload
_Merges2H[45297]    = 188443                                            -- [Mastery Merger] Chain Lightning Overload
_Merges2H[45284]    = 188196                                            -- [Mastery Merger] Lightning Bolt Overload

-- Enhancement (ID: 263)
_Merges[195256]    = CreateMergeSpellEntry("SHAMAN", 1.5, 263)         -- Stormlash (Gets Spammy!)
_Merges[187874]    = CreateMergeSpellEntry("SHAMAN", 0.5, 263)         -- Crash Lightning
_Merges[192592]    = CreateMergeSpellEntry("SHAMAN", 1.5, 263)         -- Stormstrike: Crash Lightning (TODO: Not working?)
_Merges[25504]     = CreateMergeSpellEntry("SHAMAN", 0.5, 263)         -- Windfury Attacks
_Merges[32175]     = CreateMergeSpellEntry("SHAMAN", 0.5, 263)         -- Stormstrike MH/OH Merger
_Merges[10444]     = CreateMergeSpellEntry("SHAMAN", 1.5, 263)         -- Flametongue
_Merges[199054]    = CreateMergeSpellEntry("SHAMAN", 0.5, 263)         -- Artifact: Unleash Doom
_Merges[198485]    = CreateMergeSpellEntry("SHAMAN", 0.5, 263)         -- Artifact: Alpha Wolf
_Merges[198483]    = CreateMergeSpellEntry("SHAMAN", 1.5, 263)         -- Artifact: Doom Wolves
_Merges[199116]    = CreateMergeSpellEntry("SHAMAN", 2.0, 263)         -- Artifact: Doom Vortex
_Merges[210854]    = CreateMergeSpellEntry("SHAMAN", 0.5, 263)         -- Talent: Hailstorm
_Merges[210801]    = CreateMergeSpellEntry("SHAMAN", 2.5, 263)         -- Talent: Crashing Storm
_Merges[197385]    = CreateMergeSpellEntry("SHAMAN", 2.5, 263)         -- Talent: Fury of Air
_Merges[197214]    = CreateMergeSpellEntry("SHAMAN", 2.5, 263)         -- Talent: Sundering
_Merges2H[32176]    = 32175                                             -- [MH/OH Merger] Stormstrike
_Merges2H[199053]   = 199054                                            -- [MH/OH Merger] Artifact: Unleash Weapons

-- Restoration (Shaman) (ID: 264)
_Merges[421]       = CreateMergeSpellEntry("SHAMAN", 0.5, 264)         -- Chain Lightning (Resto)
_Merges[1064]      = CreateMergeSpellEntry("SHAMAN", 0.5, 264)         -- Chain Heal
_Merges[73921]     = CreateMergeSpellEntry("SHAMAN", 2.5, 264)         -- Healing Rain
_Merges[61295]     = CreateMergeSpellEntry("SHAMAN", 3.5, 264)         -- Riptide
_Merges[52042]     = CreateMergeSpellEntry("SHAMAN", 3.0, 264)         -- Healing Stream Totem
_Merges[114942]    = CreateMergeSpellEntry("SHAMAN", 2.5, 264)         -- Healing Tide Totem
_Merges[197997]    = CreateMergeSpellEntry("SHAMAN", 2.5, 264)         -- Talent: Wellspring
_Merges[114911]    = CreateMergeSpellEntry("SHAMAN", 2.5, 264)         -- Talent: Ancestral Guidance
_Merges[157503]    = CreateMergeSpellEntry("SHAMAN", 0.5, 264)         -- Talent: Cloudburst
_Merges[114083]    = CreateMergeSpellEntry("SHAMAN", 1.5, 264)         -- Talent: Ascendance
_Merges[201633]    = CreateMergeSpellEntry("SHAMAN", 2.5, 264)         -- Talent: Earthen Shield
_Merges[209069]    = CreateMergeSpellEntry("SHAMAN", 2.5, 264)         -- Artifact: Tidal Pools
_Merges[208899]    = CreateMergeSpellEntry("SHAMAN", 3.0, 264)         -- Artifact: Queen's Decree
_Merges[207778]    = CreateMergeSpellEntry("SHAMAN", 0.5, 264)         -- Artifact: Gift of the Queen


-- ---------------------------
-- Mage                     --
-- ---------------------------

-- All Specs
_Merges[122]       = CreateMergeSpellEntry("MAGE", 1.5, 0)             -- Frost Nova

-- Arcane (ID: 62)
_Merges[1449]      = CreateMergeSpellEntry("MAGE", 0.5, 62)            -- Arcane Explosion
_Merges[7268]      = CreateMergeSpellEntry("MAGE", 2.5, 62)            -- Arcane Missiles
_Merges[44425]     = CreateMergeSpellEntry("MAGE", 1.0, 62)            -- Arcane Barrage (Cleave)
_Merges[88084]     = CreateMergeSpellEntry("MAGE", 0.5, 62)            -- Talent: Mirror Images
_Merges[157980]    = CreateMergeSpellEntry("MAGE", 0.5, 62)            -- Talent: Supernova
_Merges[114923]    = CreateMergeSpellEntry("MAGE", 2.5, 62)            -- Talent: Nether Tempest
_Merges[153640]    = CreateMergeSpellEntry("MAGE", 2.5, 62)            -- Talent: Arcane Orb
_Merges[157979]    = CreateMergeSpellEntry("MAGE", 0.5, 62)            -- Talent: Unstable Magic
_Merges[210833]    = CreateMergeSpellEntry("MAGE", 0.5, 62)            -- Artifact: Touch of the Magi
_Merges[211088]    = CreateMergeSpellEntry("MAGE", 2.5, 62)            -- Artifact: Mark of Aluneth (DoT)
_Merges2H[210817]   = 44425                                             -- [DD/Splash Merger] Arcane Rebound
_Merges2H[114954]   = 114923                                            -- [DD/DoT Merger] Arcane Rebound
_Merges2H[211076]   = 211088                                            -- [DD/Splash Merger] Arcane Rebound

-- Fire (ID: 63)
_Merges[31661]     = CreateMergeSpellEntry("MAGE", 0.5, 63)            -- Dragon's Breath
_Merges[2120]      = CreateMergeSpellEntry("MAGE", 1.5, 63)            -- Flamestrike (Longer for talent)
_Merges[12654]     = CreateMergeSpellEntry("MAGE", 2.5, 63)            -- Ignite (DoT)
_Merges[205345]    = CreateMergeSpellEntry("MAGE", 2.5, 63)            -- Talent: Conflagration
_Merges[88082]     = CreateMergeSpellEntry("MAGE", 2.0, 63)            -- Talent: Mirror Images
_Merges[157981]    = CreateMergeSpellEntry("MAGE", 0.5, 63)            -- Talent: Blast Wave
_Merges[157977]    = CreateMergeSpellEntry("MAGE", 0.5, 63)            -- Talent: Unstable Magic
_Merges[198928]    = CreateMergeSpellEntry("MAGE", 1.5, 63)            -- Talent: Cinderstorm
_Merges[217694]    = CreateMergeSpellEntry("MAGE", 3.5, 63)            -- Talent: Living Bomb (DoT)
_Merges[44461]     = CreateMergeSpellEntry("MAGE", 0.5, 63)            -- Talent: Living Bomb (Explosion)
_Merges[153564]    = CreateMergeSpellEntry("MAGE", 0.5, 63)            -- Talent: Meteor (Explosion)
_Merges[155158]    = CreateMergeSpellEntry("MAGE", 2.5, 63)            -- Talent: Meteor (DoT)
_Merges[194466]    = CreateMergeSpellEntry("MAGE", 0.5, 63)            -- Artifact: Phoenix's Flames
_Merges[194522]    = CreateMergeSpellEntry("MAGE", 2.5, 63)            -- Artifact: Blast Furnace
_Merges[215775]    = CreateMergeSpellEntry("MAGE", 1.5, 63)            -- Artifact: Phoenix Reborn
_Merges2H[224637]   = 194466                                            -- [DD/Splash Merger] Phoenix's Flames
_Merges2H[226757]   = 205345                                            -- [DD/Splash Merger] Conflagration
_Merges2H[205472]   = 2120                                              -- [DD/DoT Merger] Talent: Flame Patch

-- Frost (ID: 64)
_Merges[84721]     = CreateMergeSpellEntry("MAGE", 1.5, 64)            -- Frozen Orb
_Merges[59638]     = CreateMergeSpellEntry("MAGE", 2.0, 64)            -- Talent: Mirror Images
_Merges[157997]    = CreateMergeSpellEntry("MAGE", 0.5, 64)            -- Talent: Ice Nova
_Merges[30455]     = CreateMergeSpellEntry("MAGE", 1.0, 64)            -- Talent: Spliting Ice
_Merges[113092]    = CreateMergeSpellEntry("MAGE", 1.0, 64)            -- Talent: Frost Bomb
_Merges[157978]    = CreateMergeSpellEntry("MAGE", 0.5, 64)            -- Talent: Unstable Magic
_Merges[148022]    = CreateMergeSpellEntry("MAGE", 2.5, 64)            -- Icicles
_Merges[190357]    = CreateMergeSpellEntry("MAGE", 2.5, 64)            -- Blizzard
_Merges[153596]    = CreateMergeSpellEntry("MAGE", 2.5, 64)            -- Comet Storm


-- ---------------------------
-- Warlock                  --
-- ---------------------------

-- All Specs
_Merges[689]       = CreateMergeSpellEntry("WARLOCK", 1.5, 0)          -- Drain Life

-- Affliction (ID: 265)
_Merges[980]       = CreateMergeSpellEntry("WARLOCK", 2.5, 265)        -- Agony
_Merges[146739]    = CreateMergeSpellEntry("WARLOCK", 2.5, 265)        -- Corruption
_Merges[233490]    = CreateMergeSpellEntry("WARLOCK", 1.5, 265)        -- Unstable Affliction
_Merges[27285]     = CreateMergeSpellEntry("WARLOCK", 0.5, 265)        -- Seed of Corruption
_Merges[22703]     = CreateMergeSpellEntry("WARLOCK", 0.5, 265)        -- Infernal: Awakening
_Merges[20153]     = CreateMergeSpellEntry("WARLOCK", 1.5, 265)        -- Infernal: Immolation
_Merges[198590]    = CreateMergeSpellEntry("WARLOCK", 1.5, 265)        -- Talent: Drain Soul
_Merges[205246]    = CreateMergeSpellEntry("WARLOCK", 1.5, 265)        -- Talent: Phantom Singularity
_Merges[196100]    = CreateMergeSpellEntry("WARLOCK", 0.5, 265)        -- Talent: Grimoire of Sacrifice
_Merges[218615]    = CreateMergeSpellEntry("WARLOCK", 0.5, 265)        -- Artifact: Harvester of Souls
_Merges[199581]    = CreateMergeSpellEntry("WARLOCK", 0.5, 265)        -- Artifact: Soul Flame
_Merges2H[233496]   = 233490                                            -- Unstable Affliction (Multiple Applications)
_Merges2H[233499]   = 233490                                            -- Unstable Affliction (Multiple Applications)
_Merges2H[233497]   = 233490                                            -- Unstable Affliction (Multiple Applications)
_Merges2H[233498]   = 233490                                            -- Unstable Affliction (Multiple Applications)
_Merges2H[231489]   = 233490                                            -- Unstable Affliction (Artifact: Compounding Horror)

-- Demonlogy (ID: 266)
_Merges[603]       = CreateMergeSpellEntry("WARLOCK", 0.5, 266)        -- Doom
_Merges[89753]     = CreateMergeSpellEntry("WARLOCK", 2.5, 266)        -- Felguard: Felstorm
_Merges[104318]    = CreateMergeSpellEntry("WARLOCK", 1.5, 266)        -- Wild Imp: Fel Firebolt
_Merges[193439]    = CreateMergeSpellEntry("WARLOCK", 1.5, 266)        -- Demonwrath
_Merges[86040]     = CreateMergeSpellEntry("WARLOCK", 0.5, 266)        -- Hand of Gul'dan
_Merges[196278]    = CreateMergeSpellEntry("WARLOCK", 0.5, 266)        -- Talent: Implosion
_Merges[205231]    = CreateMergeSpellEntry("WARLOCK", 0.5, 266)        -- Talent: Summon Darkglare
_Merges[211727]    = CreateMergeSpellEntry("WARLOCK", 0.5, 266)        -- Artifact: Thal'kiel's Discord
_Merges[211714]    = CreateMergeSpellEntry("WARLOCK", 0.5, 266)        -- Artifact: Thal'kiel's Consumption (Demon Life Tap)

-- Destruction (ID: 267)
_Merges[157736]    = CreateMergeSpellEntry("WARLOCK", 3.5, 267)        -- Immolate
_Merges[29722]     = CreateMergeSpellEntry("WARLOCK", 0.5, 267)        -- Incinerate (Havoc / F&B Talent)
_Merges[116858]    = CreateMergeSpellEntry("WARLOCK", 0.5, 267)        -- Choas Bolt (Havoc)
_Merges[17962]     = CreateMergeSpellEntry("WARLOCK", 0.5, 267)        -- Conflagrate (Havoc)
_Merges[42223]     = CreateMergeSpellEntry("WARLOCK", 2.5, 267)        -- Rain of Fire
_Merges[152108]    = CreateMergeSpellEntry("WARLOCK", 0.5, 267)        -- Talent: Cataclysm
_Merges[196448]    = CreateMergeSpellEntry("WARLOCK", 1.5, 267)        -- Talent: Channel Demonfire
_Merges[187394]    = CreateMergeSpellEntry("WARLOCK", 1.5, 267)        -- Artifact: Dimensional Rift
_Merges2H[348]      = 157736                                            -- [DD/DoT Merger] Immolate


-- ---------------------------
-- Monk                     --
-- ---------------------------

-- All Specs
_Merges[130654]    = CreateMergeSpellEntry("MONK", 1.5, 0)             -- Chi Burst (Healing)
_Merges[148135]    = CreateMergeSpellEntry("MONK", 1.5, 0)             -- Chi Burst (Damage)
_Merges[196608]    = CreateMergeSpellEntry("MONK", 2.5, 0)             -- Talent: Eye of the Tiger
_Merges[132467]    = CreateMergeSpellEntry("MONK", 1.5, 0)             -- Talent: Chi Wave (Damage)
_Merges[132463]    = CreateMergeSpellEntry("MONK", 2.5, 0)             -- Talent: Chi Wave (Healing)
_Merges[148187]    = CreateMergeSpellEntry("MONK", 1.5, 0)             -- Talent: Rushing Jade Wind
_Merges[107270]    = CreateMergeSpellEntry("MONK", 1.5, 0)             -- Spinning Crane Kick
_Merges[100784]    = CreateMergeSpellEntry("MONK", 1.0, 0)             -- Blackout Kick

-- Brewmaster (ID: 268)
_Merges[124255]    = CreateMergeSpellEntry("MONK", 1.5, 268)           -- DmgTkn: Stagger
_Merges[216521]    = CreateMergeSpellEntry("MONK", 1.0, 268)           -- Celestial Fortune
_Merges[124507]    = CreateMergeSpellEntry("MONK", 0.5, 268)           -- Gift of the Ox
_Merges[115181]    = CreateMergeSpellEntry("MONK", 0.5, 268)           -- Breath of Fire
_Merges[123725]    = CreateMergeSpellEntry("MONK", 2.5, 268)           -- Breath of Fire (DoT)
_Merges[121253]    = CreateMergeSpellEntry("MONK", 0.5, 268)           -- Keg Smash
_Merges[130654]    = CreateMergeSpellEntry("MONK", 1.5, 268)           -- Chi Burst (Healing)
_Merges[130654]    = CreateMergeSpellEntry("MONK", 1.5, 268)           -- Chi Burst (Damage)
_Merges[227291]    = CreateMergeSpellEntry("MONK", 0.5, 268)           -- Talent: Niuzao, The Black Ox (Stomp)
_Merges[196733]    = CreateMergeSpellEntry("MONK", 0.5, 268)           -- Talent: Special Delivery
_Merges[214326]    = CreateMergeSpellEntry("MONK", 0.5, 268)           -- Artifact: Exploding Keg
_Merges[227681]    = CreateMergeSpellEntry("MONK", 1.5, 268)           -- Artifact: Dragonfire Brew
_Merges2H[178173]   = 124507                                            -- [Greater Merger] Artifact: Overflow (double check)

-- Windwalker (ID: 269)
_Merges[117952]    = CreateMergeSpellEntry("MONK", 0.5, 269)           -- Crackling Jade Lightning (SEF)
_Merges[124280]    = CreateMergeSpellEntry("MONK", 2.0, 269)           -- Touch of Karma
_Merges[123586]    = CreateMergeSpellEntry("MONK", 0.5, 269)           -- Flying Serpent Kick
_Merges[117418]    = CreateMergeSpellEntry("MONK", 2.0, 269)           -- Fists of Fury
_Merges[100780]    = CreateMergeSpellEntry("MONK", 0.5, 269)           -- Tiger Palm (SEF)
_Merges[185099]    = CreateMergeSpellEntry("MONK", 0.5, 269)           -- Rising Sun Kick (SEF)
_Merges[196748]    = CreateMergeSpellEntry("MONK", 0.5, 269)           -- Talent: Chi Orbit
_Merges[158221]    = CreateMergeSpellEntry("MONK", 0.5, 269)           -- Talent: Whirling Dragon Punch
_Merges[222029]    = CreateMergeSpellEntry("MONK", 0.5, 269)           -- Artifact: Strike of the Windlord
_Merges2H[205414]   = 222029                                            -- [MH/OH Merger] Artifact: Strike of the Windlord
_Merges2H[196061]   = 117418                                            -- [DMG Merger] Artifact: Crosswinds

-- Mistweaver (ID: 270)
_Merges[115175]    = CreateMergeSpellEntry("MONK", 1.5, 270)           -- Soothing Mist
_Merges[124682]    = CreateMergeSpellEntry("MONK", 1.5, 270)           -- Eneloping Mist
_Merges[191840]    = CreateMergeSpellEntry("MONK", 1.5, 270)           -- Essence Font
_Merges[119611]    = CreateMergeSpellEntry("MONK", 2.0, 270)           -- Renewing Mists
_Merges[115310]    = CreateMergeSpellEntry("MONK", 0.5, 270)           -- Revival
_Merges[116670]    = CreateMergeSpellEntry("MONK", 0.5, 270)           -- Vivify
_Merges[124081]    = CreateMergeSpellEntry("MONK", 1.5, 270)           -- Talent: Zen Pulse
_Merges[162530]    = CreateMergeSpellEntry("MONK", 1.5, 270)           -- Talent: Refreshing Jade Wind
_Merges[198756]    = CreateMergeSpellEntry("MONK", 2.5, 270)           -- Talent: Invoke Chi'Ji
_Merges[199668]    = CreateMergeSpellEntry("MONK", 2.0, 270)           -- Artifact: Blessing of Yu'lon
_Merges[199656]    = CreateMergeSpellEntry("MONK", 2.0, 270)           -- Artifact: Celestial Breath
_Merges2H[198533]   = 115175                                            -- [Statue Merger] Talent: Jade Serpent Statue
_Merges2H[228649]   = 100784                                            -- [Passive Merger] Teachings of the Monastery


-- ---------------------------
-- Druid                    --
-- ---------------------------

-- All Specs
_Merges[164812]    = CreateMergeSpellEntry("DRUID", 2.5, 0)            -- Moonfire
_Merges[164815]    = CreateMergeSpellEntry("DRUID", 2.5, 0)            -- Sunfire

-- Balance (ID: 102)
_Merges[194153]    = CreateMergeSpellEntry("DRUID", 0.5, 102)          -- Lunar Strike
_Merges[191037]    = CreateMergeSpellEntry("DRUID", 2.0, 102)          -- Starfall
_Merges[202347]    = CreateMergeSpellEntry("DRUID", 2.5, 102)          -- Talent: Stellar Flare
_Merges[202497]    = CreateMergeSpellEntry("DRUID", 2.5, 102)          -- Talent: Shooting Stars
_Merges[211545]    = CreateMergeSpellEntry("DRUID", 2.5, 102)          -- Talent: Fury of Elune
_Merges[202771]    = CreateMergeSpellEntry("DRUID", 0.5, 102)          -- Artifact: Full Moon
_Merges2H[226104]   = 191037                                            -- Artifact: Echoing Stars

-- Feral (ID: 103)
_Merges[106785]    = CreateMergeSpellEntry("DRUID", 0.5, 103)          -- Swipe (Cat)
_Merges[106830]    = CreateMergeSpellEntry("DRUID", 2.5, 103)          -- Thrash (Cat)
_Merges[155722]    = CreateMergeSpellEntry("DRUID", 2.5, 103)          -- Rake
_Merges[1079]      = CreateMergeSpellEntry("DRUID", 2.5, 103)          -- Rip
_Merges[155625]    = CreateMergeSpellEntry("DRUID", 2.5, 103)          -- Talent: Lunar Inspiration
_Merges[202028]    = CreateMergeSpellEntry("DRUID", 0.5, 103)          -- Talent: Brutal Slash
_Merges[210723]    = CreateMergeSpellEntry("DRUID", 1.5, 103)          -- Artifact: Ashamane's Frenzy
_Merges[210687]    = CreateMergeSpellEntry("DRUID", 0.5, 103)          -- Artifact: Shadow Thrash
_Merges2H[1822]     = 155722                                            -- [DD/DoT Merger] Rake

-- Guardian (ID: 104)
_Merges[227034]    = CreateMergeSpellEntry("DRUID", 1.5, 104)          -- Mastery: Nature's Guardian
_Merges[22842]     = CreateMergeSpellEntry("DRUID", 1.5, 104)          -- Frenzied Regeneration
_Merges[33917]     = CreateMergeSpellEntry("DRUID", 0.5, 104)          -- Mangle (Incarnation Cleave)
_Merges[213771]    = CreateMergeSpellEntry("DRUID", 0.5, 104)          -- Swipe (Bear)
_Merges[77758]     = CreateMergeSpellEntry("DRUID", 2.5, 104)          -- Thrash (Bear)
_Merges[213709]    = CreateMergeSpellEntry("DRUID", 2.5, 104)          -- Talent: Brambles
_Merges[204069]    = CreateMergeSpellEntry("DRUID", 2.5, 104)          -- Talent: Lunbar Beam
_Merges[219432]    = CreateMergeSpellEntry("DRUID", 2.5, 104)          -- Artifact: Rage of the Sleeper
_Merges2H[192090]   = 77758                                             -- [DD/DoT Merger] Thrash
_Merges2H[203958]   = 213709                                            -- [Barkskin Merger] Brambles

-- Restoration (Druid) (ID: 105)
_Merges[81269]     = CreateMergeSpellEntry("DRUID", 1.5, 105)          -- Efflorescence
_Merges[33763]     = CreateMergeSpellEntry("DRUID", 1.5, 105)          -- Lifebloom
_Merges[774]       = CreateMergeSpellEntry("DRUID", 3.5, 105)          -- Rejuvenation
_Merges[8936]      = CreateMergeSpellEntry("DRUID", 2.5, 105)          -- Regrowth
_Merges[157982]    = CreateMergeSpellEntry("DRUID", 2.5, 105)          -- Tranquility
_Merges[48438]     = CreateMergeSpellEntry("DRUID", 2.5, 105)          -- Wild Growth (Instant)
_Merges[42231]     = CreateMergeSpellEntry("DRUID", 2.5, 105)          -- Hurricane
_Merges[200389]    = CreateMergeSpellEntry("DRUID", 3.5, 105)          -- Talent: Cultivation
_Merges[189853]    = CreateMergeSpellEntry("DRUID", 0.5, 105)          -- Artifact: Dreamwalker
_Merges2H[189800]   = 48438                                             -- [HoT/Artifact Merger] Nature's Essence
_Merges2H[155777]   = 774                                               -- [HoT/HoT Merger] Talent: Germination
_Merges2H[207386]   = 81269                                             -- [Heal/HoT Merger] Talent: Spring Blossom


-- ---------------------------
-- Demon Hunter             --
-- ---------------------------

-- Havoc (ID: 577)
_Merges[222031]    = CreateMergeSpellEntry("DEMONHUNTER", 3.0, 577)    -- Chaos Strike (server side delay?)
_Merges[185123]    = CreateMergeSpellEntry("DEMONHUNTER", 1.5, 577)    -- Throw Glaive (Havoc)
_Merges[198030]    = CreateMergeSpellEntry("DEMONHUNTER", 1.5, 577)    -- Eye Beam
_Merges[192611]    = CreateMergeSpellEntry("DEMONHUNTER", 1.5, 577)    -- Fel Rush
_Merges[185123]    = CreateMergeSpellEntry("DEMONHUNTER", 1.5, 577)    -- Throw Glaive
_Merges[199552]    = CreateMergeSpellEntry("DEMONHUNTER", 2.0, 577)    -- Blade Dance
_Merges[200166]    = CreateMergeSpellEntry("DEMONHUNTER", 0.5, 577)    -- Metamorphosis (Landing)
_Merges[198813]    = CreateMergeSpellEntry("DEMONHUNTER", 0.5, 577)    -- Vengeful Retreat
_Merges[179057]    = CreateMergeSpellEntry("DEMONHUNTER", 0.5, 577)    -- Chaos Nova
_Merges[203796]    = CreateMergeSpellEntry("DEMONHUNTER", 2.5, 577)    -- Talent: Demon Blades
_Merges[211052]    = CreateMergeSpellEntry("DEMONHUNTER", 1.5, 577)    -- Talent: Fel Barrage
_Merges[202388]    = CreateMergeSpellEntry("DEMONHUNTER", 0.5, 577)    -- Artifact: Inner Demons
_Merges[201628]    = CreateMergeSpellEntry("DEMONHUNTER", 1.5, 577)    -- Artifact: Fury of the Illidari
_Merges[217070]    = CreateMergeSpellEntry("DEMONHUNTER", 0.5, 577)    -- Artifact: Rage of the Illidari
_Merges[202446]    = CreateMergeSpellEntry("DEMONHUNTER", 0.5, 577)    -- Artifact: Anguish
_Merges2H[199547]   = 222031                                            -- [MH/OH Merger] Chaos Strike
_Merges2H[200685]   = 199552                                            -- [MH/OH Merger] Blade Dance
_Merges2H[201789]   = 201628                                            -- [MH/OH Merger] Fury of the Illidari

-- Vengeance  (ID: 581)
_Merges[204157]    = CreateMergeSpellEntry("DEMONHUNTER", 1.5, 581)    -- Throw Glaive (Vengeance)
_Merges[187727]    = CreateMergeSpellEntry("DEMONHUNTER", 2.5, 581)    -- Immolation Aura
_Merges[204598]    = CreateMergeSpellEntry("DEMONHUNTER", 2.5, 581)    -- Sigil of Flame
_Merges[189112]    = CreateMergeSpellEntry("DEMONHUNTER", 0.5, 581)    -- Infernal Strike
_Merges[222030]    = CreateMergeSpellEntry("DEMONHUNTER", 0.5, 581)    -- Soul Cleave
_Merges[203794]    = CreateMergeSpellEntry("DEMONHUNTER", 1.5, 581)    -- Consume Soul
_Merges[207771]    = CreateMergeSpellEntry("DEMONHUNTER", 2.5, 581)    -- Talent: Burning Alive
_Merges[227255]    = CreateMergeSpellEntry("DEMONHUNTER", 1.5, 581)    -- Talent: Fel Devastation
_Merges[218677]    = CreateMergeSpellEntry("DEMONHUNTER", 0.5, 581)    -- Talent: Spirit Bomb
_Merges[218677]    = CreateMergeSpellEntry("DEMONHUNTER", 1.5, 581)    -- Talent: Spirit Bomb (Frailty Heal)
_Merges[213011]    = CreateMergeSpellEntry("DEMONHUNTER", 2.5, 581)    -- Artifact: Charred Warblades
_Merges[207407]    = CreateMergeSpellEntry("DEMONHUNTER", 1.5, 581)    -- Artifact: Soul Carver (DoT)
_Merges2H[178741]   = 187727                                            -- [DD/DoT Merger] Immolation Aura
_Merges2H[208038]   = 222030                                            -- [DD/DoT Merger] Soul Cleave
_Merges2H[214743]   = 207407                                            -- [DD/DoT Merger] Soul Cleave
_Merges2H[212106]   = 227255                                            -- [MH/OH Merger] Fel Devastation
_Merges2H[212084]   = 227255                                            -- Reported From Curse: Should be Fel Devastation


-- ---------------------------
-- Death Knight             --
-- ---------------------------

-- All Specs
_Merges[52212]     = CreateMergeSpellEntry("DEATHKNIGHT", 2.5, 0)      -- Death and Decay

-- Blood (ID: 250)
_Merges[55078]     = CreateMergeSpellEntry("DEATHKNIGHT", 3.5, 250)    -- Blood Plague
_Merges[50842]     = CreateMergeSpellEntry("DEATHKNIGHT", 0.5, 250)    -- Blood Boil
_Merges[195292]    = CreateMergeSpellEntry("DEATHKNIGHT", 0.5, 250)    -- Death's Caress (DRW)
_Merges[49998]     = CreateMergeSpellEntry("DEATHKNIGHT", 0.5, 250)    -- Death Strike (DRW)
_Merges[206930]    = CreateMergeSpellEntry("DEATHKNIGHT", 0.5, 250)    -- Heart Strike
_Merges[212744]    = CreateMergeSpellEntry("DEATHKNIGHT", 0.5, 250)    -- Talent: Soulgorge
_Merges[196528]    = CreateMergeSpellEntry("DEATHKNIGHT", 1.5, 250)    -- Talent: Bonestorm (DMG)
_Merges[196545]    = CreateMergeSpellEntry("DEATHKNIGHT", 1.5, 250)    -- Talent: Bonestorm (Heal)
_Merges[205223]    = CreateMergeSpellEntry("DEATHKNIGHT", 0.5, 250)    -- Artifact: Consumption (DMG)
_Merges[205224]    = CreateMergeSpellEntry("DEATHKNIGHT", 0.5, 250)    -- Artifact: Consumption (Heal)
_Merges[203166]    = CreateMergeSpellEntry("DEATHKNIGHT", 2.5, 250)    -- PVP Talent: Blight (ID: 203172)
_Merges[203174]    = CreateMergeSpellEntry("DEATHKNIGHT", 0.5, 250)    -- PVP Talent: Death Chain (ID: 203173)

-- Frost (ID: 251)
_Merges[196771]    = CreateMergeSpellEntry("DEATHKNIGHT", 2.5, 251)    -- Remorseless Winter
_Merges[55095]     = CreateMergeSpellEntry("DEATHKNIGHT", 3.5, 251)    -- Frost Fever
_Merges[49184]     = CreateMergeSpellEntry("DEATHKNIGHT", 0.5, 251)    -- Howling Blast
_Merges[222024]    = CreateMergeSpellEntry("DEATHKNIGHT", 3.0, 251)    -- Obliterate (For Merge)
_Merges[222026]    = CreateMergeSpellEntry("DEATHKNIGHT", 3.0, 251)    -- Frost Strike (For Merge)
_Merges[207194]    = CreateMergeSpellEntry("DEATHKNIGHT", 0.5, 251)    -- Talent: Volatile Shielding
_Merges[195750]    = CreateMergeSpellEntry("DEATHKNIGHT", 0.5, 251)    -- Talent: Frozen Pulse
_Merges[207150]    = CreateMergeSpellEntry("DEATHKNIGHT", 0.5, 251)    -- Talent: Avalanche
_Merges[207230]    = CreateMergeSpellEntry("DEATHKNIGHT", 0.5, 251)    -- Talent: Frostscythe
_Merges[195975]    = CreateMergeSpellEntry("DEATHKNIGHT", 0.5, 251)    -- Talent: Glacial Advance
_Merges[155166]    = CreateMergeSpellEntry("DEATHKNIGHT", 2.5, 251)    -- Talent: Breath of Sindragosa
_Merges[190780]    = CreateMergeSpellEntry("DEATHKNIGHT", 1.5, 251)    -- Artifact: Sindragosa's Fury
_Merges[204959]    = CreateMergeSpellEntry("DEATHKNIGHT", 0.5, 251)    -- Artifact: Frozen Soul
_Merges2H[66198]    = 222024                                            -- [MH/OH Merger] Obliterate
_Merges2H[66196]    = 222026                                            -- [MH/OH Merger] Frost Strike

-- Unholy (ID: 252)
_Merges[215969]    = CreateMergeSpellEntry("DEATHKNIGHT", 0.5, 252)    -- Virulent Plague (DoT)
_Merges[70890]     = CreateMergeSpellEntry("DEATHKNIGHT", 3.0, 252)    -- Scourge Strike
_Merges[194311]    = CreateMergeSpellEntry("DEATHKNIGHT", 0.5, 252)    -- Festering Wound
_Merges[91778]     = CreateMergeSpellEntry("DEATHKNIGHT", 0.5, 252)    -- Pet: Sweeping Claws
_Merges[199373]    = CreateMergeSpellEntry("DEATHKNIGHT", 2.5, 252)    -- Army: Claw
_Merges[191587]    = CreateMergeSpellEntry("DEATHKNIGHT", 2.5, 252)    -- Virulent Plague (DoT)
_Merges[218321]    = CreateMergeSpellEntry("DEATHKNIGHT", 1.5, 252)    -- Artifact: Dragged to Helheim
_Merges[191758]    = CreateMergeSpellEntry("DEATHKNIGHT", 0.5, 252)    -- Artifact: Corpse Explosion
_Merges[207267]    = CreateMergeSpellEntry("DEATHKNIGHT", 0.5, 252)    -- Talent: Dragged to Helheim
_Merges[212338]    = CreateMergeSpellEntry("DEATHKNIGHT", 0.5, 252)    -- Talent: Sludge Belcher
_Merges[212739]    = CreateMergeSpellEntry("DEATHKNIGHT", 0.5, 252)    -- Talent: Epidemic
_Merges[156000]    = CreateMergeSpellEntry("DEATHKNIGHT", 2.5, 252)    -- Talent: Defile
_Merges2H[55090]    = 70890                                             -- [Cleave Merger] Scourge Strike
_Merges2H[191685]   = 215969                                            -- [DD/DoT Merger] Virulent Plague Eruption
_Merges2H[212969]   = 212739                                            -- [DD/DoT Merger] Talent: Epidemic
