--[[   ____    ______      
      /\  _`\ /\__  _\   __
 __  _\ \ \/\_\/_/\ \/ /_\ \___ 
/\ \/'\\ \ \/_/_ \ \ \/\___  __\
\/>  </ \ \ \L\ \ \ \ \/__/\_\_/
 /\_/\_\ \ \____/  \ \_\  \/_/
 \//\/_/  \/___/    \/_/
 
 [=====================================]
 [  Author: Dandruff @ Whisperwind-US  ]
 [  xCT+ Version 3.x.x                 ]
 [  ?012. All Rights Reserved.        ]
 [====================================]]

 -- This file is a static default profile.  After your first profile is created, editing this file will do nothing.
local ADDON_NAME, addon = ...

-- =====================================================
-- CreateMergeSpellEntry(
--    default,       [bool] - This specs current activated spell (only one per spec)
--    spellID,        [int] - the spell id to watch for
--    watchUnit,   [string] - look for the spell id on this unit
--  )
--    Creates a merge settings entry for a spell.
-- =====================================================
local function CreateComboSpellEntry(default, spellID, watchUnit)
  return {
       enabled = default,
            id = spellID,
          unit = watchUnit  or "player",
    }
end

addon.defaults = {
  profile = {
    showStartupText = false,
    hideConfig = true,
    
    blizzardFCT = {
      blizzardHeadNumbers = true,
      enabled = true,
      font = "RayUI Normal",
      fontName = [[Fonts\ARHei.TTF]],
      fontSize = 32,
      fontOutline = "2OUTLINE",
      
      -- CVars
      ["CombatThreatChanges"] = true,
      ["CombatDamage"] = true,
      ["CombatHealing"] = true,
      ["PetMeleeDamage"] = true,
      ["CombatLogPeriodicSpells"] = true,
      ["CombatHealingAbsorbTarget"] = false,
      ["fctSpellMechanics"] = false,
      ["fctSpellMechanicsOther"] = false,
      ["CombatDamageStyle"] = 1,
    },
    
    frameSettings = {
      clearLeavingCombat = false,
      showGrid = true,
      showPositions = true,
      frameStrata = "5HIGH",
    },
    
    megaDamage = {
      thousandSymbol = "|cffFF8000K|r",
      millionSymbol = "|cffFF0000M|r",
      decimalPoint = true,
    },
    
    frames = {
      general = {
        ["enabledFrame"] = true,
        ["secondaryFrame"] = 0,
        ["insertText"] = "bottom",
        ["alpha"] = 100,
        ["megaDamage"] = false,
        
      -- position
        ["X"] = 0,
        ["Y"] = 224,
        ["Width"] = 256,
        ["Height"] = 128,
        
      -- fonts
        ["font"] = "RayUI Normal",
        ["fontSize"] = 18,
        ["fontOutline"] = "2OUTLINE",
        ["fontJustify"] = "CENTER",

      -- font colors
        colors = {
          ["interrupts"]   = { enabled = false, desc = "Interrupts",     default = { 1.00, 0.50, 0.00 } },
          ["killingBlow"]  = { enabled = false, desc = "Killing Blows",  default = { 0.20, 1.00, 0.20 } },
          ["honorGains"]   = { enabled = false, desc = "Honor Gained",   default = { 0.10, 0.10, 1.00 } },

          ["auras"] = {
            enabled = false, desc = "Buffs and Debuffs",
            colors = {
              ["buffsGained"]        = { enabled = false, desc = "Buffs Gained",       default = { 1.00, 0.50, 0.50 } },
              ["buffsFaded"]         = { enabled = false, desc = "Buffs Faded",        default = { 0.50, 0.50, 0.50 } },
              ["debuffsGained"]      = { enabled = false, desc = "Debuffs Gained",     default = { 1.00, 0.10, 0.10 } },
              ["debuffsFaded"]       = { enabled = false, desc = "Debuffs Faded",      default = { 0.50, 0.50, 0.50 } },
            },
          },
          ["dispells"] = {
            enabled = false, desc = "Dispell Buffs and Debuffs",
            colors = {
              ["dispellBuffs"]       = { enabled = false, desc = "Buffs",              default = { 0.00, 1.00, 0.50 } },
              ["dispellDebuffs"]     = { enabled = false, desc = "Debuffs",            default = { 1.00, 0.00, 0.50 } },
              ["dispellStolen"]      = { enabled = false, desc = "Spell Stolen",       default = { 0.31, 0.71, 1.00 } },
            },
          },
          ["reputation"] = {
            enabled = false, desc = "Reputation",
            colors = {
              ["reputationGain"]     = { enabled = false, desc = "Reputation Gained",  default = { 0.10, 0.10, 1.00 } },
              ["reputationLoss"]     = { enabled = false, desc = "Reputation Lost",    default = { 1.00, 0.10, 0.10 } },
            },
          },
          ["combat"] = {
            enabled = false, desc = "Combat Status",
            colors = {
              ["combatEntering"]     = { enabled = false, desc = "Entering Combat",    default = { 1.00, 0.10, 0.10 } },
              ["combatLeaving"]      = { enabled = false, desc = "Leaving Combat",     default = { 0.10, 1.00, 0.10 } },
            },
          },
          ["lowResources"] = {
            enabled = false, desc = "Low Resources",
            colors = {
              ["lowResourcesHealth"] = { enabled = false, desc = "Low Health",         default = { 1.00, 0.10, 0.10 } },
              ["lowResourcesMana"]   = { enabled = false, desc = "Low Mana",           default = { 1.00, 0.10, 0.10 } },
            },
          },
        },
        
      -- scrollable
        ["enableScrollable"] = false,
        ["scrollableLines"] = 10,
        
      -- fading text
        ["enableCustomFade"] = false,
        ["enableFade"] = true,
        ["fadeTime"] = 0.3,
        ["visibilityTime"] = 5,
        
      -- special tweaks
        ["showInterrupts"] = false,
        ["showDispells"] = false,
        ["showPartyKills"] = false,
        ["showBuffs"] = true,
        ["showDebuffs"] = true,
        ["showLowManaHealth"] = true,
        ["showCombatState"] = true,
        ["showRepChanges"] = true,
        ["showHonorGains"] = true,
      },
      
      outgoing = {
        ["enabledFrame"] = true,
        ["secondaryFrame"] = 0,
        ["insertText"] = "bottom",
        ["alpha"] = 100,
        ["megaDamage"] = false,
        
      -- position
        ["X"] = 382,
        ["Y"] = 58,
        ["Width"] = 128,
        ["Height"] = 260,
        
      -- fonts
        ["font"] = "RayUI Normal",
        ["fontSize"] = 15,
        ["fontOutline"] = "2OUTLINE",
        ["fontJustify"] = "RIGHT",
        
      -- font colors
        colors = {
          ['genericDamage']         = { enabled = false, desc = "Generic Damage",   default = { 1.00, 0.82, 0.00 } },
          ['misstypesOut']          = { enabled = false, desc = "Missed",           default = { 0.50, 0.50, 0.50 } },
          
          ["spellSchools"] = {
            enabled = false, desc = "Spell School Colors",
            colors = {
              ['SpellSchool_Physical']  = { enabled = false, desc = "Physical Damage",  default = { 1.00, 1.00, 0.00 } },
              ['SpellSchool_Holy']      = { enabled = false, desc = "Holy Damage",      default = { 1.00, 0.90, 0.50 } },
              ['SpellSchool_Fire']      = { enabled = false, desc = "Fire Damage",      default = { 1.00, 0.50, 0.00 } },
              ['SpellSchool_Nature']    = { enabled = false, desc = "Nature Damage",    default = { 0.30, 1.00, 0.30 } },
              ['SpellSchool_Frost']     = { enabled = false, desc = "Frost Damage",     default = { 0.50, 1.00, 1.00 } },
              ['SpellSchool_Shadow']    = { enabled = false, desc = "Shadow Damage",    default = { 0.50, 0.50, 1.00 } },
              ['SpellSchool_Arcane']    = { enabled = false, desc = "Arcane Damage",    default = { 1.00, 0.50, 1.00 } },
            },
          },
          ['healingSpells'] = {
            enabled = false, desc = "Healing Colors",
            colors = {
              ['shieldOut']             = { enabled = false, desc = "Shields",          default = { 0.60, 0.65, 1.00 } },
              ['healingOut']            = { enabled = false, desc = "Healing",          default = { 0.10, 0.75, 0.10 } },
              ['healingOutPeriodic']    = { enabled = false, desc = "Healing Periodic", default = { 0.10, 0.50, 0.10 } },
            },
          },
        },

      -- icons
        ["iconsEnabled"] = true,
        ["iconsSize"] = 28,
        
      -- scrollable
        ["enableScrollable"] = false,
        ["scrollableLines"] = 10,
        ["scrollableInCombat"] = false,
        
      -- fading text
        ["enableCustomFade"] = false,
        ["enableFade"] = true,
        ["fadeTime"] = 0.3,
        ["visibilityTime"] = 5,
        
      -- special tweaks
        ["enableOutDmg"] = true,
        ["enableOutHeal"] = true,
        ["enablePetDmg"] = true,
        ["enableAutoAttack"] = true,
        ["enableDotDmg"] = true,
        ["enableHots"] = true,
        ["enableImmunes"] = true,
        ["enableMisses"] = true,
      },
      
      critical = {
        ["enabledFrame"] = false,
        ["secondaryFrame"] = 2,
        ["insertText"] = "bottom",
        ["alpha"] = 100,
        ["megaDamage"] = false,
      
      -- position
        ["X"] = 256,
        ["Y"] = 0,
        ["Width"] = 256,
        ["Height"] = 128,
        
      -- fonts
        ["font"] = "RayUI Normal",
        ["fontSize"] = 30,
        ["fontOutline"] = "2OUTLINE",
        ["fontJustify"] = "RIGHT",
        
      -- font colors
        colors = {
          ['genericDamageCritical']  = { enabled = false, desc = "Critical Generic Damage", default = { 1.00, 1.00, 0.00 } },

          ['healingSpells'] = {
            enabled = false, desc = "Healing Colors",
            colors = {
              ['healingOutCritical'] = { enabled = false, desc = "Critical Healing", default = { 0.10, 1.00, 0.10 } },
            },
          },
        },

      -- critical appearance
        ["critPrefix"] = "|cffFF0000*|r",
        ["critPostfix"] = "|cffFF0000*|r",
        
      -- icons
        ["iconsEnabled"] = true,
        ["iconsSize"] = 28,
        
      -- scrollable
        ["enableScrollable"] = false,
        ["scrollableLines"] = 10,
        ["scrollableInCombat"] = false,
        
      -- fading text
        ["enableCustomFade"] = false,
        ["enableFade"] = true,
        ["fadeTime"] = 0.3,
        ["visibilityTime"] = 5,
        
      -- special tweaks
        ["showSwing"] = true,
        ["prefixSwing"] = true,
      },
      
      damage = {
        ["enabledFrame"] = true,
        ["secondaryFrame"] = 0,
        ["insertText"] = "bottom",
        ["alpha"] = 100,
        ["megaDamage"] = false,
        
      -- position
        ["X"] = -325,
        ["Y"] = -30,
        ["Width"] = 190,
        ["Height"] = 144,
        
      -- fonts
        ["font"] = "RayUI Normal",
        ["fontSize"] = 15,
        ["fontOutline"] = "2OUTLINE",
        ["fontJustify"] = "LEFT",

      -- font colors
        colors = {
          ['damageTaken']               = { enabled = false, desc = "Physical Damage",          default = { 0.75, 0.10, 0.10 } },
          ['damageTakenCritical']       = { enabled = false, desc = "Critical Physical Damage", default = { 1.00, 0.10, 0.10 } },
          ['spellDamageTaken']          = { enabled = false, desc = "Spell Damage",             default = { 0.75, 0.30, 0.85 } },
          ['spellDamageTakenCritical']  = { enabled = false, desc = "Critical Spell Damage",    default = { 0.75, 0.30, 0.85 } },

          ['missTypesTaken'] = {
            enabled = false, desc = "Miss Types",
            colors = {
              ['missTypeMiss']    = { enabled = false, desc = "Missed",   default = { 0.50, 0.50, 0.50 } },
              ['missTypeDodge']   = { enabled = false, desc = "Dodged",   default = { 0.50, 0.50, 0.50 } },
              ['missTypeParry']   = { enabled = false, desc = "Parry",    default = { 0.50, 0.50, 0.50 } },
              ['missTypeEvade']   = { enabled = false, desc = "Evade",    default = { 0.50, 0.50, 0.50 } },
              ['missTypeImmune']  = { enabled = false, desc = "Immune",   default = { 0.50, 0.50, 0.50 } },
              ['missTypeDeflect'] = { enabled = false, desc = "Deflect",  default = { 0.50, 0.50, 0.50 } },
              ['missTypeReflect'] = { enabled = false, desc = "Reflect",  default = { 0.50, 0.50, 0.50 } },
              ['missTypeResist']  = { enabled = false, desc = "Resisted", default = { 0.50, 0.50, 0.50 } },
              ['missTypeBlock']   = { enabled = false, desc = "Blocked",  default = { 0.50, 0.50, 0.50 } },
              ['missTypeAbsorb']  = { enabled = false, desc = "Asorbed",  default = { 0.50, 0.50, 0.50 } },
            },
          },
        },
        
      -- scrollable
        ["enableScrollable"] = false,
        ["scrollableLines"] = 10,
        ["scrollableInCombat"] = false,
        
      -- fading text
        ["enableCustomFade"] = false,
        ["enableFade"] = true,
        ["fadeTime"] = 0.3,
        ["visibilityTime"] = 5,
      
      -- Special Tweaks
        ["showDodgeParryMiss"] = true,
        ["showDamageReduction"] = true,
      },

      healing = {
        ["enabledFrame"] = true,
        ["secondaryFrame"] = 0,
        ["insertText"] = "bottom",
        ["alpha"] = 100,
        ["megaDamage"] = false,
      
      -- positioon
        ["X"] = -415,
        ["Y"] = 5,
        ["Width"] = 128,
        ["Height"] = 260,
        
      -- fonts
        ["font"] = "RayUI Normal",
        ["fontSize"] = 15,
        ["fontOutline"] = "2OUTLINE",
        ["fontJustify"] = "LEFT",
        
      -- font colors
        colors = {
          ['shieldTaken']          = { enabled = false, desc = "Shields",          default = { 0.60, 0.65, 1.00 } },
          ['healingTaken']         = { enabled = false, desc = "Healing",          default = { 0.10, 0.75, 0.10 } },
          ['healingTakenCritical'] = { enabled = false, desc = "Critical Healing", default = { 0.10, 1.00, 0.10 } },
          ['healingTakenPeriodic'] = { enabled = false, desc = "Periodic Healing", default = { 0.10, 0.50, 0.10 } },
          ['healingTakenPeriodicCritical'] = { enabled = false, desc = "Critical Periodic Healing", default = { 0.10, 0.50, 0.10 } },
        },
        
      -- scrollable
        ["enableScrollable"] = false,
        ["scrollableLines"] = 10,
        ["scrollableInCombat"] = false,
        
      -- fading text
        ["enableCustomFade"] = false,
        ["enableFade"] = true,
        ["fadeTime"] = 0.3,
        ["visibilityTime"] = 5,
        
      -- special tweaks
        ["showFriendlyHealers"] = false,
        ["enableClassNames"] = true,
        ["enableRealmNames"] = false,
        ["enableOverHeal"] = false,
        ["enableSelfAbsorbs"] = true,
      },
      
      class = {
        ["enabledFrame"] = false,
        ["alpha"] = 100,
        
      -- position
        ["X"] = 0,
        ["Y"] = 64,
        ["Width"] = 64,
        ["Height"] = 64,
        
      -- fonts
        ["font"] = "RayUI Normal",
        ["fontSize"] = 32,
        ["fontOutline"] = "2OUTLINE",
        
      -- font colors
        colors = {
          ['comboPoints']     = { enabled = false, desc = "Combo Points",     default = { 1.00, 0.82, 0.00 } },
          ['comboPointsMax']  = { enabled = false, desc = "Max Combo Points", default = { 0.00, 0.82, 1.00 } },
        },
      },
      
      power = {
        ["enabledFrame"] = true,
        ["secondaryFrame"] = 0,
        ["insertText"] = "bottom",
        ["alpha"] = 100,
        ["megaDamage"] = false,
        
      -- position
        ["X"] = 0,
        ["Y"] = -95,
        ["Width"] = 256,
        ["Height"] = 128,
        
      -- fonts
        ["font"] = "RayUI Normal",
        ["fontSize"] = 15,
        ["fontOutline"] = "2OUTLINE",
        ["fontJustify"] = "CENTER",
        
      -- font colors
        ["customColor"] = false,
        ["fontColor"] = nil,
        
      -- scrollable
        ["enableScrollable"] = false,
        ["scrollableLines"] = 10,
        ["scrollableInCombat"] = false,
        
      -- fading text
        ["enableCustomFade"] = false,
        ["enableFade"] = true,
        ["fadeTime"] = 0.3,
        ["visibilityTime"] = 5,
        
      -- special tweaks
        ["showEnergyGains"] = true,
        ["showPeriodicEnergyGains"] = true,
      },
      
      procs = {
        ["enabledFrame"] = false,
        ["secondaryFrame"] = 1,
        ["insertText"] = "top",
        ["alpha"] = 100,
        
      -- position
        ["X"] = -256,
        ["Y"] = -64,
        ["Width"] = 256,
        ["Height"] = 128,
        
      -- fonts
        ["font"] = "RayUI Normal",
        ["fontSize"] = 20,
        ["fontOutline"] = "2OUTLINE",
        ["fontJustify"] = "CENTER",
        
      -- font colors
        colors = {
          ['spellProc']     = { enabled = false, desc = "Spell Procs",    default = { 1.00, 0.82, 0.00 } },
          ['spellReactive'] = { enabled = false, desc = "Spell Reactive", default = { 1.00, 0.82, 0.00 } },
        },

      -- icons
        ["iconsEnabled"] = true,
        ["iconsSize"] = 16,

      -- scrollable
        ["enableScrollable"] = false,
        ["scrollableLines"] = 10,
        ["scrollableInCombat"] = false,
        
      -- fading text
        ["enableCustomFade"] = false,
        ["enableFade"] = true,
        ["fadeTime"] = 0.3,
        ["visibilityTime"] = 5,
      },
      
      loot = {
        ["enabledFrame"] = true,
        ["secondaryFrame"] = 0,
        ["insertText"] = "top",
        ["alpha"] = 100,
        
      -- position 
        ["X"] = 0,
        ["Y"] = -245,
        ["Width"] = 325,
        ["Height"] = 128,
        
      -- fonts
        ["font"] = "RayUI Normal",
        ["fontSize"] = 15,
        ["fontOutline"] = "2OUTLINE",
        ["fontJustify"] = "CENTER",
        
      -- icons
        ["iconsEnabled"] = true,
        ["iconsSize"] = 16,
        
      -- scrollable
        ["enableScrollable"] = false,
        ["scrollableLines"] = 10,
        ["scrollableInCombat"] = false,
        
      -- fading text
        ["enableCustomFade"] = false,
        ["enableFade"] = true,
        ["fadeTime"] = 0.3,
        ["visibilityTime"] = 5,
        
      -- special tweaks
        ["showItems"] = true,
        ["showItemTypes"] = true,
        ["showMoney"] = true,
        ["showItemTotal"] = true,
        ["showCrafted"] = true,
        ["showQuest"] = true,
        ["colorBlindMoney"] = false,
        ["filterItemQuality"] = 3,
      },
    },
    
    spells = {
      enableMerger = true,        -- enable/disable spam merger
      enableMergerDebug = false,  -- Shows spell IDs for debugging merged spells
      mergeHealing = true,
      mergeSwings = true,
      mergeRanged = true,
      mergeDispells = true,
      
      -- Only one of these can be true
      mergeDontMergeCriticals = true,
      mergeCriticalsWithOutgoing = false,
      mergeCriticalsByThemselves = false,
      
      -- Abbreviate or Groups Settings
      formatAbbreviate = true,
      formatGroups = false,
      
      combo = {
        ["DEATHKNIGHT"] = {
          [1] = {                                         -- Blood
            CreateComboSpellEntry(false, 49222),          --   Bone Shield
            CreateComboSpellEntry(true, 114851),          --   Blood Charge
            CreateComboSpellEntry(false, 50421),          --   Scent of Blood
          },
          [2] = { },    -- Frost
          [3] = {                                         -- Unholy
            CreateComboSpellEntry(true, 91342, "pet"),    --   Shadow Infusion
          },
        },
        
        ["DRUID"] = {
          [1] = {                                         -- Balance
            --CreateComboSpellEntry(true, 81192),           --   Lunar Shower
          },
          [2] = {                                         -- Feral
            [COMBAT_TEXT_SHOW_COMBO_POINTS_TEXT] = true,
          }, 
          [3] = { },    -- Guardian
          [4] = { },    -- Restoration
        },
      
        ["HUNTER"] = {
          [1] = {                                         -- Beast Mastery
            CreateComboSpellEntry(true, 19615, "pet"),    --   Frenzy Effect
          },
          [2] = {                                         -- Marksman
            --CreateComboSpellEntry(true, 82925),           --   Ready, Set, Aim...
          },
          [3] = {                                         -- Survival
            CreateComboSpellEntry(true, 56453),           --   Lock 'n Load
          },
        },
        
        ["MAGE"] = {
          [1] = { },    -- Arcane
          [2] = { },    -- Fire
          [3] = { },    -- Frost
        },
        
        ["MONK"] = {
          [CHI] = true,
          
          -- DO NOT USE - MONKS GET CHI
          [1] = { },    -- Brewmaster
          [2] = { },    -- Mistweaver
          [3] = { },    -- Windwalker
        },
        
        ["PALADIN"] = {
          [HOLY_POWER] = true,
        
          -- DO NOT USE - PALADINS GET HOLY POWER
          [1] = { },    -- Holy
          [2] = { },    -- Protection
          [3] = { },    -- Retribution
        },
        
        ["PRIEST"] = {
          [1] = {                                         -- Discipline
            CreateComboSpellEntry(true, 81661),           --   Evangelism
          },    
          [2] = {                                         -- Holy
            CreateComboSpellEntry(true, 63735),           --   Serendipity
            CreateComboSpellEntry(false, 114255),         --   Surge of Light
          },    
          -- DO NOT USE - SHADOW PRIEST GET SHADOW ORBS
          [3] = {                                         -- Shadow
            [SHADOW_ORBS] = true,
            -- 87160 Surge of Darkness
          },    
        },
        
        ["ROGUE"] = {
          [COMBAT_TEXT_SHOW_COMBO_POINTS_TEXT] = true,
        
          -- DO NOT USE - ROGUES GET COMBO POINTS
          [1] = { },    -- Assassination
          [2] = { },    -- Combat
          [3] = { },    -- Subtlety
        },

        ["SHAMAN"] = {
          [1] = {                                         -- Elemental
            CreateComboSpellEntry(true, 324),             --   Fulmination
          },    
          [2] = {                                         -- Enhancement
            CreateComboSpellEntry(true, 53817),           --   Maelstrom Weapon
          },
          [3] = {                                         -- Restoration
            CreateComboSpellEntry(true, 53390),           --   Tidal Waves
          },
        },

        ["WARLOCK"] = {
          -- DO NOT USE - AFFLICTION WARLOCKS GET SOUL SHARDS
          [1] = { [SOUL_SHARDS] = true },                 -- Affliction
          
          -- DO NOT USE - DEMONOLOGY WARLOCKS GET DEMONIC FURY
          [2] = { [DEMONIC_FURY] = true },                -- Demonology
          
          -- DO NOT USE - DESTRUCTION WARLOCKS GET BURNING EMBERS
          [3] = { [BURNING_EMBERS] = true },              -- Destruction
        },
        
        ["WARRIOR"] = {
          [1] = { },    -- Arms
          [2] = { },    -- Fury
          [3] = { },    -- Protection
        },
        
      },
      
      -- yes this is supposed to be blank :P
      -- it is generated in merge.lua
      merge = { },
    
      -- yes this is supposed to be blank :P
      -- it is dynamically generated in core.lua
      items = { },

      -- multistike items here
      multistrikeEnabled = true,
      multistrikeLatency = 600,
      multistikeDebug = false,
      multistikeAutoAdjust = true,
      showMultistrikeIcons = true,
      multistrikeIconMultiplier = 50,
    },
    
    spellFilter = {
      ["whitelistBuffs"]    = false,
      ["whitelistDebuffs"]  = false,
      ["whitelistSpells"]   = false,
      ["whitelistProcs"]    = false,
	  ["whitelistItems"]    = false,
	  
      ["trackSpells"]       = false,
      
      listBuffs    = { },  -- Used to filter gains/fades of buffs    (Spell Name)
      listDebuffs  = { },  -- Used to filter gains/fades of debuffs  (Spell Name)
      listSpells   = { },  -- Used to filter outgoing spells         (Spell ID)
      listProcs    = { },  -- Used to filter spell procs             (Proc Name)
	  listItems    = { },  -- Used to filter Items                   (Item ID)
      
      -- Minimal Spell Amount
      filterPowerValue = 0,
      filterOutgoingDamageValue = 0,
      filterOutgoingHealingValue = 0,
      filterIncomingDamageValue = 0,
      filterIncomingHealingValue = 0,
    },
  },
}
