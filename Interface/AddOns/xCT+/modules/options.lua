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
 [  ©2012. All Rights Reserved.        ]
 [====================================]]

local ADDON_NAME, addon = ...
local LSM = LibStub("LibSharedMedia-3.0")
local x, noop = addon.engine, addon.noop
local blankTable, unpack, select = {}, unpack, select
local string_gsub, string_match, sformat, pairs = string.gsub, string.match, string.format, pairs

-- New Icon "!"
local NEW = x.new

-- Store Localized Strings
-- To remove: "Changed Target!"
local XCT_CT_DEC_0, XCT_CT_DEC_1, XCT_CT_DEC_2 = COMBAT_THREAT_DECREASE_0, COMBAT_THREAT_DECREASE_1, COMBAT_THREAT_DECREASE_2
local XCT_CT_INC_1, XCT_CT_INC_3 = COMBAT_THREAT_INCREASE_1, COMBAT_THREAT_INCREASE_3

local PLAYER_NAME = UnitName('player')
local _, PLAYER_CLASS = UnitClass('player')
if PLAYER_CLASS then
  PLAYER_NAME = ('|c%s%s|r'):format(RAID_CLASS_COLORS[PLAYER_CLASS].colorStr, PLAYER_NAME)
end

-- Creating an Config
addon.options = {
  -- Add a place for the user to grab
  name = "                                                      " .. "Version: "..(GetAddOnMetadata("xCT+", "Version") or "Unknown") .. "                                                      ",
  handler = x,
  type = 'group',
  args = {
    xCT_Title = {
      order = 0,
      type = 'description',
      fontSize = 'large',
      name = "|cffFF0000x|rCT|cffFFFF00+|r |cff798BDDConfiguration Tool|r\n",
      width = 'double',
    },

    spacer0 = {
      order = 1,
      type = 'description',
      name = "|cffFFFF00Helpful Tips:|r\n\n",
      width = 'half',
    },

    helpfulTip = {
      order = 2,
      type = 'description',
      fontSize = 'medium',
      name = "On the left list, under the |cffFFFF00Startup Message|r checkbox, you can click on the |cff798BDD+ Buttons|r (plus) to show more options.",
      width = 'double',
    },

    --[[xCT_Header = {
      order = 10,
      type = "header",
      name = "Version: "..(GetAddOnMetadata("xCT+", "Version") or "Unknown"),
      width = "full",
    },]]

    space1 = {
      order = 10,
      type = 'description',
      name = "\n",
      width = 'full',
    },

    showStartupText = {
      order = 11,
      type = 'toggle',
      name = "Startup Message",
      get = function(info) return x.db.profile.showStartupText end,
      set = function(info, value) x.db.profile.showStartupText = value end,
    },  
    hideConfig = {
      order = 12,
      type = 'toggle',
      name = "Hide Config in Combat",
      desc = "This option helps prevent UI taints by closing the config when you enter combat.\n\n|cffFF8000Highly Recommended Enabled|r",
      get = function(info) return x.db.profile.hideConfig end,
      set = function(info, value) x.db.profile.hideConfig = value; if not value then StaticPopup_Show("XCT_PLUS_HIDE_IN_COMBAT") end end,
    },
    --[==[RestoreDefaults = {
      order = 3,
      type = 'execute',
      name = "Restore Defaults",
      func = x.RestoreAllDefaults,
    },]==]
    space2 = {
      order = 20,
      type = 'description',
      name = " ",
      width = 'half',
    },
    --[==[space3 = {
      order = 3,
      type = 'description',
      name = " ",
      width = 'half',
    },
    space4 = {
      order = 3,
      type = 'description',
      name = " ",
      width = 'half',
    },]==]
    ToggleTestMode = {
      order = 21,
      type = 'execute',
      name = "Toggle Test Mode",
      func = x.ToggleTestMode,
    },
    ToggleFrames = {
      order = 22,
      type = 'execute',
      name = "Toggle Frames",
      func = x.ToggleConfigMode,
    },

    hiddenObjectShhhhhh = {
      order = 9001,
      type = 'description',
      name = function(info) x:OnAddonConfigRefreshed() return "" end,
    },
  },
}

-- A fast C-Var Update routine
x.cvar_udpate = function()
  -- Always have Combat Text Enabled
  SetCVar("enableCombatText", 1)
  _G["SHOW_COMBAT_TEXT"] = "1"
  
  -- We dont care about "combatTextFloatMode"
  -- _G["COMBAT_TEXT_FLOAT_MODE"] = "1"

  -- Check: fctLowManaHealth (General Option)
  if x.db.profile.frames.general.showLowManaHealth then
    SetCVar("fctLowManaHealth", 1)
    _G["COMBAT_TEXT_SHOW_LOW_HEALTH_MANA"] = "1"
  else
    SetCVar("fctLowManaHealth", 0)
    _G["COMBAT_TEXT_SHOW_LOW_HEALTH_MANA"] = "0"
  end
  
  -- Check: fctAuras (General Option)
  if x.db.profile.frames.general.showBuffs or x.db.profile.frames.general.showDebuffs then
    SetCVar("fctAuras", 1)
    _G["COMBAT_TEXT_SHOW_AURAS"] = "1"
    _G["COMBAT_TEXT_SHOW_AURA_FADE"] = "1"
  else
    SetCVar("fctAuras", 0)
    _G["COMBAT_TEXT_SHOW_AURAS"] = "0"
    _G["COMBAT_TEXT_SHOW_AURA_FADE"] = "0"
  end
  
  -- Check: fctCombatState (General Option)
  if x.db.profile.frames.general.showCombatState then
    SetCVar("fctCombatState", 1)
    _G["COMBAT_TEXT_SHOW_COMBAT_STATE"] = "1"
  else
    SetCVar("fctCombatState", 0)
    _G["COMBAT_TEXT_SHOW_COMBAT_STATE"] = "0"
  end
  
  -- Check: fctDodgeParryMiss (Damage Option)
  if x.db.profile.frames.damage.showDodgeParryMiss then
    SetCVar("fctDodgeParryMiss", 1)
    _G["COMBAT_TEXT_SHOW_DODGE_PARRY_MISS"] = "1"
  else
    SetCVar("fctDodgeParryMiss", 0)
    _G["COMBAT_TEXT_SHOW_DODGE_PARRY_MISS"] = "0"
  end
  
  -- Check: fctDamageReduction (Damage Option)
  if x.db.profile.frames.damage.showDamageReduction then
    SetCVar("fctDamageReduction", 1)
    _G["COMBAT_TEXT_SHOW_RESISTANCES"] = "1"
  else
    SetCVar("fctDamageReduction", 0)
    _G["COMBAT_TEXT_SHOW_RESISTANCES"] = "0"
  end
  
  -- Check: fctRepChanges (General Option)
  if x.db.profile.frames.general.showRepChanges then
    SetCVar("fctRepChanges", 1)
    _G["COMBAT_TEXT_SHOW_REPUTATION"] = "1"
  else
    SetCVar("fctRepChanges", 0)
    _G["COMBAT_TEXT_SHOW_REPUTATION"] = "0"
  end
  
  -- Check: fctHonorGains (General Option)
  if x.db.profile.frames.damage.showHonorGains then
    SetCVar("fctHonorGains", 0)
    _G["COMBAT_TEXT_SHOW_HONOR_GAINED"] = "0"
  else
    SetCVar("fctHonorGains", 0)
    _G["COMBAT_TEXT_SHOW_HONOR_GAINED"] = "0"
  end
  
  -- Check: fctReactives (Attach to Procs Frame)
  if x.db.profile.frames.procs.enabledFrame then
    SetCVar("fctReactives", 1)
    _G["COMBAT_TEXT_SHOW_REACTIVES"] = "1"
  else
    SetCVar("fctReactives", 0)
    _G["COMBAT_TEXT_SHOW_REACTIVES"] = "0"
  end
  
  -- Check: fctFriendlyHealers (Healing Option)
  if x.db.profile.frames.healing.showFriendlyHealers then
    SetCVar("fctFriendlyHealers", 1)
    _G["COMBAT_TEXT_SHOW_FRIENDLY_NAMES"] = "1"
  else
    SetCVar("fctFriendlyHealers", 0)
    _G["COMBAT_TEXT_SHOW_FRIENDLY_NAMES"] = "0"
  end
  
  -- Check: CombatHealingAbsorbSelf (Healing Option)
  if x.db.profile.frames.healing.enableSelfAbsorbs then
    SetCVar("CombatHealingAbsorbSelf", 1)
    _G["SHOW_COMBAT_HEALING_ABSORB_SELF"] = "1"
  else
    SetCVar("CombatHealingAbsorbSelf", 0)
    _G["SHOW_COMBAT_HEALING_ABSORB_SELF"] = "0"
  end
  
  -- Check: fctComboPoints (COMBO Option)
  if x.player.class == "ROGUE" and x.db.profile.frames.class.enabledFrame then
    SetCVar("fctComboPoints", 1)
    _G["COMBAT_TEXT_SHOW_COMBO_POINTS"] = "1"
  else
    SetCVar("fctComboPoints", 0)
    _G["COMBAT_TEXT_SHOW_COMBO_POINTS"] = "0"
  end
  
  -- Check: fctEnergyGains (Power Option)
  if x.db.profile.frames.power.showEnergyGains then
    SetCVar("fctEnergyGains", 1)
    _G["COMBAT_TEXT_SHOW_ENERGIZE"] = "1"
  else
    SetCVar("fctEnergyGains", 0)
    _G["COMBAT_TEXT_SHOW_ENERGIZE"] = "0"
  end
  
  -- Check: fctPeriodicEnergyGains (Power Option)
  if x.db.profile.frames.power.showPeriodicEnergyGains then
    SetCVar("fctPeriodicEnergyGains", 1)
    _G["COMBAT_TEXT_SHOW_PERIODIC_ENERGIZE"] = "1"
  else
    SetCVar("fctPeriodicEnergyGains", 0)
    _G["COMBAT_TEXT_SHOW_PERIODIC_ENERGIZE"] = "0"
  end
  
  -- Floating Combat Text: Effects
  if x.db.profile.blizzardFCT.fctSpellMechanics then
    SetCVar("fctSpellMechanics", 1)
  else
    SetCVar("fctSpellMechanics", 0)
  end
  
  -- Floating Combat Text: Effects (Others)
  if x.db.profile.blizzardFCT.fctSpellMechanicsOther then
    SetCVar("fctSpellMechanicsOther", 1)
  else
    SetCVar("fctSpellMechanicsOther", 0)
  end
  
  -- Floating Combat Text: Outgoing Damage
  if x.db.profile.blizzardFCT.CombatDamage then
    SetCVar("CombatDamage", 1)
  else
    SetCVar("CombatDamage", 0)
  end
  
  -- Floating Combat Text: Outgoing Dots and Hots
  if x.db.profile.blizzardFCT.CombatLogPeriodicSpells then
    SetCVar("CombatLogPeriodicSpells", 1)
  else
    SetCVar("CombatLogPeriodicSpells", 0)
  end
  
  -- Floating Combat Text: Outgoing Pet Damage
  if x.db.profile.blizzardFCT.PetMeleeDamage then
    SetCVar("PetMeleeDamage", 1)
  else
    SetCVar("PetMeleeDamage", 0)
  end
  
  -- Floating Combat Text: Outgoing Healing
  if x.db.profile.blizzardFCT.CombatHealing then
    SetCVar("CombatHealing", 1)
  else
    SetCVar("CombatHealing", 0)
  end
  
  -- Floating Combat Text: Outgoing Absorbs
  if x.db.profile.blizzardFCT.CombatHealingAbsorbTarget then
    SetCVar("CombatHealingAbsorbTarget", 1)
  else
    SetCVar("CombatHealingAbsorbTarget", 0)
  end
  
  -- Floating Combat Text: Threat Changes
  if x.db.profile.blizzardFCT.CombatThreatChanges then
    COMBAT_THREAT_DECREASE_0, COMBAT_THREAT_DECREASE_1, COMBAT_THREAT_DECREASE_2 = XCT_CT_DEC_0, XCT_CT_DEC_1, XCT_CT_DEC_2
    COMBAT_THREAT_INCREASE_1, COMBAT_THREAT_INCREASE_3 = XCT_CT_INC_1, XCT_CT_INC_3
  else
    COMBAT_THREAT_DECREASE_0, COMBAT_THREAT_DECREASE_1, COMBAT_THREAT_DECREASE_2 = "", "", ""
    COMBAT_THREAT_INCREASE_1, COMBAT_THREAT_INCREASE_3 = "", ""
  end
  
end

-- Generic Get/Set methods
local function get0(info) return x.db.profile[info[#info-1]][info[#info]] end
local function set0(info, value) x.db.profile[info[#info-1]][info[#info]] = value; x.cvar_udpate() end
local function set0_update(info, value) x.db.profile[info[#info-1]][info[#info]] = value; x:UpdateFrames(); x.cvar_udpate() end
local function get0_1(info) return x.db.profile[info[#info-2]][info[#info]] end
local function set0_1(info, value) x.db.profile[info[#info-2]][info[#info]] = value; x.cvar_udpate() end
local function getTextIn0(info) return string_gsub(x.db.profile[info[#info-1]][info[#info]], "|", "||") end
local function setTextIn0(info, value) x.db.profile[info[#info-1]][info[#info]] = string_gsub(value, "||", "|"); x.cvar_udpate() end
local function get1(info) return x.db.profile.frames[info[#info-1]][info[#info]] end
local function set1(info, value) x.db.profile.frames[info[#info-1]][info[#info]] = value; x.cvar_udpate() end
local function set1_update(info, value) set1(info, value); x:UpdateFrames(info[#info-1]); x.cvar_udpate() end
local function get2(info) return x.db.profile.frames[info[#info-2]][info[#info]] end
local function set2(info, value) x.db.profile.frames[info[#info-2]][info[#info]] = value; x.cvar_udpate() end
local function set2_update(info, value) set2(info, value); x:UpdateFrames(info[#info-2]); x.cvar_udpate() end
local function getColor2(info) return unpack(x.db.profile.frames[info[#info-2]][info[#info]] or blankTable) end
local function setColor2(info, r, g, b) x.db.profile.frames[info[#info-2]][info[#info]] = {r,g,b} end
local function getTextIn2(info) return string_gsub(x.db.profile.frames[info[#info-2]][info[#info]], "|", "||") end
local function setTextIn2(info, value) x.db.profile.frames[info[#info-2]][info[#info]] = string_gsub(value, "||", "|") end
local function getNumber2(info) return tostring(x.db.profile[info[#info-2]][info[#info]]) end
local function setNumber2(info, value) if tonumber(value) then x.db.profile[info[#info-2]][info[#info]] = tonumber(value) end end

local function outgoingSpellColorsHidden(info) return not x.db.profile.frames["outgoing"].standardSpellColor end

local function isFrameEnabled(info) return x.db.profile.frames[info[#info-1]].enabledFrame end
local function isFrameDisabled(info) return not x.db.profile.frames[info[#info-1]].enabledFrame end
local function isFrameItemDisabled(info) return not x.db.profile.frames[info[#info-2]].enabledFrame end
local function isFrameNotScrollable(info) return isFrameItemDisabled(info) or not x.db.profile.frames[info[#info-2]].enableScrollable end
local function isFrameUseCustomFade(info) return not x.db.profile.frames[info[#info-2]].enableCustomFade or isFrameItemDisabled(info) end
local function isFrameFadingDisabled(info) return isFrameUseCustomFade(info) or not x.db.profile.frames[info[#info-2]].enableFade end
local function isFrameIconDisabled(info) return isFrameItemDisabled(info) or not x.db.profile.frames[info[#info-2]].iconsEnabled end

-- This is TEMP
local function isFrameItemEnabled(info) return x.db.profile.frames[info[#info-2]].enabledFrame end



local function setSpecialCriticalOptions(info, value)
  x.db.profile[info[#info-2]].mergeCriticalsWithOutgoing = false
  x.db.profile[info[#info-2]].mergeCriticalsByThemselves = false
  x.db.profile[info[#info-2]].mergeDontMergeCriticals = false

  x.db.profile[info[#info-2]][info[#info]] = true
end

local function setFormating(info, value)
  x.db.profile.spells.formatAbbreviate = false
  x.db.profile.spells.formatGroups = false

  x.db.profile.spells[info[#info]] = true
end

local function getDBSpells(info)
  return x.db.profile.spells[info[#info]]
end

-- Apply to All variables
local miscFont, miscFontOutline, miscEnableCustomFade;

-- Spell Filter Methods
local checkAdd = {
  listBuffs = false,
  listDebuffs = false,
  listSpells = false,
  listProcs = false,
}

local function getCheckAdd(info) return checkAdd[info[#info-1]] end
local function setCheckAdd(info, value) checkAdd[info[#info-1]] = value end

local function trim(s)
  return ( s:gsub("^%s*(.-)%s*$", "%1") )
end

-- For each 'comma' separated value in 'input' (string) do 'func(value, ...)'
local function foreach(input, comma, func, ...)
  local pattern = ("[^%s]+"):format(comma)
  local s, e = 0, 0
  while e do
    s, e = input:find(pattern, e + 1)
    if s and e then
      func(trim(input:sub(s, e)), ...)
    end
  end
end

local function setSpell(info, value)
  if not checkAdd[info[#info-1]] then
    -- Add Spell
    foreach(value, ';', x.AddFilteredSpell, info[#info-1])
  else
    -- Remove Spell
    foreach(value, ';', x.RemoveFilteredSpell, info[#info-1])
  end
end

local function IsTrackSpellsDisabled() return not x.db.profile.spellFilter.trackSpells end

-- Lists that will be used to show tracked spells
local buffHistory, debuffHistory, spellHistory, procHistory, itemHistory = { }, { }, { }, { }, { }

local function GetBuffHistory()
  for i in pairs(buffHistory) do
    buffHistory[i] = nil
  end
  
  for i in pairs(x.spellCache.buffs) do
    buffHistory[i] = x:GetSpellTextureFormatted(i, 16).." "..i
  end
  
  return buffHistory
end

local function GetDebuffHistory()
  for i in pairs(debuffHistory) do
    debuffHistory[i] = nil
  end
  
  for i in pairs(x.spellCache.debuffs) do
    debuffHistory[i] = x:GetSpellTextureFormatted(i, 16).." "..i
  end
  
  return debuffHistory
end

local function GetSpellHistory()
  for i in pairs(spellHistory) do
    spellHistory[i] = nil
  end
  
  for i in pairs(x.spellCache.spells) do
    local name = GetSpellInfo(i) or "Unknown Spell ID"
    spellHistory[tostring(i)] = x:GetSpellTextureFormatted(i, 16).." "..name.." (|cff798BDD"..i.."|r)"
  end
  
  return spellHistory
end

local function GetProcHistory()
  for i in pairs(procHistory) do
    procHistory[i] = nil
  end
  
  for i in pairs(x.spellCache.procs) do
    procHistory[i] = x:GetSpellTextureFormatted(i, 16).." "..i
  end
  
  return procHistory
end

local function GetItemHistory()
  for i in pairs(itemHistory) do
    itemHistory[i] = nil
  end
  
  for i in pairs(x.spellCache.items) do
	local name, _, _, _, _, _, _, _, _, texture = GetItemInfo( i )
    itemHistory[i] = sformat("|T%s:%d:%d:0:0:64:64:5:59:5:59|t %s", texture, 16, 16, name)
  end
  
  return itemHistory
end


addon.options.args["spells"] = {
  name = "Spam Merger",
  type = 'group',
  order = 2,
  args = {
    
    mergeOptions = {
      name = "Merge Options",
      type = 'group',
      guiInline = true,
      order = 11,
      args = {

        enableMerger = {
          order = 1,
          type = 'toggle',
          name = "Enable Merger",
          get = get0_1,
          set = set0_1,
        },
        enableMergerDebug = {
          order = 2,
          type = 'toggle',
          width = "double",
          name = "Show Spell IDs",
          get = get0_1,
          set = set0_1,
        },

        listSpacer1 = {
          type = "description",
          order = 10,
          name = "\n|cff798BDDMerge Incoming Healing|r:",
          fontSize = 'large',
        },
      
        mergeHealing = {
          order = 11,
          type = 'toggle',
          name = "Merge Healing by Name",
          desc = "Merges incoming healing by the name of the person that healed you.",
          get = get0_1,
          set = set0_1,
          width = 'double',
        },
        
        listSpacer2 = {
          type = "description",
          order = 20,
          name = "\n|cff798BDDMerge Multiple Dispells|r:",
          fontSize = 'large',
        },
      
        mergeDispells = {
          order = 21,
          type = 'toggle',
          name = "Merge Dispells by Spell Name",
          desc = "Merges multiple dispells that you perform together, if the aura name is the same.",
          get = get0_1,
          set = set0_1,
          width = 'double',
        },
        
        listSpacer3 = {
          type = "description",
          order = 30,
          name = "\n|cff798BDDMerge Auto-Attacks|r:",
          fontSize = 'large',
        },
      
        mergeSwings = {
          order = 31,
          type = 'toggle',
          name = "Merge Melee Swings",
          desc = "|cffFF0000ID|r 6603 |cff798BDD(Player Melee)|r\n|cffFF0000ID|r 0 |cff798BDD(Pet Melee)|r",
          get = get0_1,
          set = set0_1,
        },
        
        mergeRanged = {
          order = 32,
          type = 'toggle',
          name = "Merge Ranged Attacks",
          desc = "|cffFF0000ID|r 75",
          get = get0_1,
          set = set0_1,
        },
        
        listSpacer4 = {
          type = "description",
          order = 40,
          name = "\n|cff798BDDMerge Critical Hits|r (Choose one):",
          fontSize = 'large',
        },
        
        mergeDontMergeCriticals = {
          order = 41,
          type = 'toggle',
          name = "Don't Merge Critical Together",
          desc = "Crits will not get merged in the critical frame, but they will be included in the outgoing total. |cffFFFF00(Default)|r",
          get = get0_1,
          set = setSpecialCriticalOptions,
          width = 'full',
        },
        
        mergeCriticalsWithOutgoing = {
          order = 42,
          type = 'toggle',
          name = "Merge Critical Hits with Outgoing",
          desc = "Crits will be merged, but the total merged amount in the outgoing frame includes crits.",
          get = get0_1,
          set = setSpecialCriticalOptions,
          width = 'full',
        },
        
        mergeCriticalsByThemselves = {
          order = 43,
          type = 'toggle',
          name = "Merge Critical Hits by Themselves",
          desc = "Crits will be merged and the total merged amount in the outgoing frame |cffFF0000DOES NOT|r include crits.",
          get = get0_1,
          set = setSpecialCriticalOptions,
          width = 'full',
        },

      },
    },
    
    spellList = {
      name = "Class Specific Spells", --"List of Mergeable Spells |cff798BDD(Class Specific)|r",
      type = 'group',
      order = 20,
      args = {
        title = {
          type = 'description',
          order = 0,
          name = "List of Mergeable Spells |cff798BDD(Class Specific)|r",
          fontSize = "large",
          width = "double",
        },
        
        --[[  TODO: Add Check all and uncheck all buttons ]]
        
        mergeListDesc = {
          type = "description",
          order = 1,
          fontSize = "small",
          name = "Uncheck a spell if you do not want it merged. Contact me to add new spells. See |cffFFFF00Credits|r for contact info.\n\n",
        },
      },
    },
    
    itemList = {
      name = "Items and Spells for All Classes",
      type = 'group',
      order = 21,
      args = {
        title = {
          type = 'description',
          order = 0,
          name = "List of Mergeable Spells |cff798BDD(Items)|r",
          fontSize = "large",
          width = "double",
        },
        mergeListDesc = {
          type = "description",
          order = 1,
          fontSize = "small",
          name = "Uncheck an item if you do not want it merged. Contact me to add new items. See |cffFFFF00Credits|r for contact info.\n\n",
        },
      },
    },
  },
}

addon.options.args["spellFilter"] = {
  name = "Filters",
  type = "group",
  order = 3,
  args = {
    filterSpacer1 = {
      type = 'description',
      order = 1,
      fontSize = "medium",
      name = "",
    },
    
    filterValues = {
      name = "Minimal Value Thresholds",
      type = 'group',
      order = 10,
      guiInline = true,
      args = {
        listSpacer0 = {
          type = "description",
          order = 0,
          name = "|cff798BDDIncoming Player Power Threshold|r: (Mana, Rage, Energy, etc.)",
          fontSize = "large",
        },
        
        filterPowerValue = {
          order = 1,
          type = 'input',
          name = "Incoming Power",
          desc = "The minimal amount of player's power required inorder for it to be displayed.",
          set = setNumber2,
          get = getNumber2,
        },
      
        listSpacer1 = {
          type = "description",
          order = 10,
          name = "\n|cff798BDDOutgoing Damage and Healing Threshold|r:",
          fontSize = "large",
        },
        
        filterOutgoingDamageValue = {
          order = 11,
          type = 'input',
          name = "Outgoing Damage",
          desc = "The minimal amount of damage required inorder for it to be displayed.",
          set = setNumber2,
          get = getNumber2,
        },
        
        filterOutgoingHealingValue = {
          order = 12,
          type = 'input',
          name = "Outgoing Healing",
          desc = "The minimal amount of healing required inorder for it to be displayed.",
          set = setNumber2,
          get = getNumber2,
        },
        
        listSpacer2 = {
          type = "description",
          order = 20,
          name = "\n|cff798BDDIncoming Damage and Healing Threshold|r:",
          fontSize = "large",
        },
        
        filterIncomingDamageValue = {
          order = 21,
          type = 'input',
          name = "Incoming Damage",
          desc = "The minimal amount of damage required inorder for it to be displayed.",
          set = setNumber2,
          get = getNumber2,
        },
        
        filterIncomingHealingValue = {
          order = 22,
          type = 'input',
          name = "Incoming Healing",
          set = setNumber2,
          get = getNumber2,
        },
      },
    },
  
    spellFilter = {
      name = "Track Spell History",
      type = 'group',
      order = 11,
      guiInline = true,
      args = {
    
        -- This is a feature option that I will enable when I get more time D:
        trackSpells = {
          order = 1,
          type = 'toggle',
          name = "Enable History",
          desc = "\n\nTrack incoming |cff1AFF1ABuff|r and |cff1AFF1ADebuff|r names, as well as |cff71d5ffOutgoing Spell|r IDs. |cffFF0000(RECOMMEND FOR TEMPORARY USE ONLY)|r\n",
          set = set0_1,
          get = get0_1,
        },

        description = {
          type = 'description',
          order = 2,
          name = "\n|cffFF0000WARNING:|r This option was designed to help you filter spells more easily. Because of the large |cffFF8000memory requirements|r to hold a list of all the spells you use, this option is meant for temporary use! It is best used during a test Boss pull like in LFR. After you disable this option, you should perform a |cff798BDDUI Reload|r to reclaim the resources (e.g. type: '|cffFFFF00/reload|r').",
        },
      },
    },
    
    
    listBuffs = {
      name = "|cffFFFFFFFilter:|r |cff798BDDBuffs|r",
      type = 'group',
      order = 20,
      guiInline = false,
      args = {
        title = {
          order = 0,
          type = "description",
          name = "These options allow you to filter out |cff1AFF1ABuff|r auras that your player gains or loses.  In order to filter them, you need to type the |cffFFFF00exact name of the aura|r (case sensitive).",
        },
        whitelistBuffs = {
          order = 1,
          type = 'toggle',
          name = "Whitelist",
          desc = "Filtered auras gains and fades that are |cff1AFF1ABuffs|r will be on a whitelist (opposed to a blacklist).",
          set = set0_1,
          get = get0_1,
          width = "full",
        },
        spellName = {
          order = 6,
          type = 'input',
          name = "Aura Name",
          desc = "The full, case-sensitive name of the |cff1AFF1ABuff|r you want to filter.\n\nYou can add/remove |cff798BDDmultiple|r entries by separating them with a |cffFF8000semicolon|r (e.g. 'Shadowform;Power Word: Fortitude').",
          set = setSpell,
          get = noop,
        },
        checkAdd = {
          order = 7,
          type = 'toggle',
          name = "Remove",
          desc = "Check to remove the aura from the filtered list.",
          get = getCheckAdd,
          set = setCheckAdd,
        },
        
        -- This is a feature option that I will enable when I get more time D:
        selectTracked = {
          order = 8,
          type = 'select',
          name = "Buff History:",
          desc = "A list of |cff1AFF1ABuff|r names that have been seen. |cffFF0000Requires:|r |cff798BDDTrack Spell History|r",
          disabled = IsTrackSpellsDisabled,
          values = GetBuffHistory,
          get = noop,
          set = setSpell,
        },
      },
    },
    
    listDebuffs = {
      name = "|cffFFFFFFFilter:|r |cff798BDDDebuffs|r",
      type = 'group',
      order = 30,
      guiInline = false,
      args = {
        title = {
          order = 0,
          type = "description",
          name = "These options allow you to filter out |cffFF1A1ADebuff|r auras that your player gains or loses. In order to filter them, you need to type the |cffFFFF00exact name of the aura|r (case sensitive).",
        },
        whitelistDebuffs = {
          order = 1,
          type = 'toggle',
          name = "Whitelist",
          desc = "Filtered auras gains and fades that are |cffFF1A1ADebuffs|r will be on a whitelist (opposed to a blacklist).",
          set = set0_1,
          get = get0_1,
          width = "full",
        },
        spellName = {
          order = 2,
          type = 'input',
          name = "Aura Name",
          desc = "The full, case-sensitive name of the |cffFF1A1ADebuff|r you want to filter.",
          set = setSpell,
          get = noop,
        },
        checkAdd = {
          order = 3,
          type = 'toggle',
          name = "Remove",
          desc = "Check to remove the aura from the filtered list.",
          get = getCheckAdd,
          set = setCheckAdd,
        },
        
        -- This is a feature option that I will enable when I get more time D:
        selectTracked = {
          order = 4,
          type = 'select',
          name = "Debuff History:",
          desc = "A list of |cffFF1A1ABuff|r names that have been seen. |cffFF0000Requires:|r |cff798BDDTrack Spell History|r",
          disabled = IsTrackSpellsDisabled,
          values = GetDebuffHistory,
          get = noop,
          set = setSpell,
        },
      },
    },

    listProcs = {
      name = "|cffFFFFFFFilter:|r |cff798BDDProcs|r",
      type = 'group',
      order = 40,
      guiInline = false,
      args = {
        title = {
          order = 0,
          type = "description",
          name = "case sensative spell procs",
        },
        whitelistProcs = {
          order = 1,
          type = 'toggle',
          name = "Whitelist",
          desc = "Check for whitelist, uncheck for blacklist.",
          set = set0_1,
          get = get0_1,
          width = "full",
        },
        spellName = {
          order = 6,
          type = 'input',
          name = "Proc Name",
          desc = "The full, case-sensitive name of the |cff1AFF1AProc|r you want to filter.\n\nYou can add/remove |cff798BDDmultiple|r entries by separating them with a |cffFF8000semicolon|r (e.g. 'Shadowform;Power Word: Fortitude').",
          set = setProc,
          get = noop,
        },
        checkAdd = {
          order = 7,
          type = 'toggle',
          name = "Remove",
          desc = "Check to remove the item from the filtered list.",
          get = getCheckAdd,
          set = setCheckAdd,
        },
        
        -- This is a feature option that I will enable when I get more time D:
        selectTracked = {
          order = 8,
          type = 'select',
          name = "Proc History:",
          desc = "A list of |cff1AFF1AProc|r items that have been seen. |cffFF0000Requires:|r |cff798BDDTrack Spell History|r",
          disabled = IsTrackSpellsDisabled,
          values = GetProcHistory,
          get = noop,
          set = setSpell,
        },
      },
    },
    
    listSpells = {
      name = "|cffFFFFFFFilter:|r |cff798BDDOutgoing Spells|r",
      type = 'group',
      order = 50,
      guiInline = false,
      args = {
        title = {
          order = 0,
          type = "description",
          name = "These options allow you to filter |cff71d5ffOutgoing Spells|r that your player does. In order to filter them, you need to type the |cffFFFF00Spell ID|r of the spell.",
        },
        whitelistSpells = {
          order = 1,
          type = 'toggle',
          name = "Whitelist",
          desc = "Filtered |cff71d5ffOutgoing Spells|r will be on a whitelist (opposed to a blacklist).",
          set = set0_1,
          get = get0_1,
          width = "full",
        },
        spellName = {
          order = 2,
          type = 'input',
          name = "Spell ID",
          desc = "The spell ID of the |cff71d5ffOutgoing Spell|r you want to filter.",
          set = setSpell,
          get = noop,
        },
        checkAdd = {
          order = 3,
          type = 'toggle',
          name = "Remove",
          desc = "Check to remove the spell from the filtered list.",
          get = getCheckAdd,
          set = setCheckAdd,
        },
        
        -- This is a feature option that I will enable when I get more time D:
        selectTracked = {
          order = 4,
          type = 'select',
          name = "Spell History:",
          desc = "A list of |cff71d5ffOutgoing Spell|r IDs that have been seen. |cffFF0000Requires:|r |cff798BDDTrack Spell History|r",
          disabled = IsTrackSpellsDisabled,
          values = GetSpellHistory,
          get = noop,
          set = setSpell,
        },
      },
    },
    
	listItems = {
      name = "|cffFFFFFFFilter:|r |cff798BDDItems (Plus)|r",
      type = 'group',
      order = 50,
      guiInline = false,
      args = {
        title = {
          order = 0,
          type = "description",
          name = "Description goes here.",
        },
        whitelistItems = {
          order = 1,
          type = 'toggle',
          name = "Whitelist",
          desc = "Filtered |cff798BDDItems (Plus)|r will be on a whitelist (opposed to a blacklist).",
          set = set0_1,
          get = get0_1,
          width = "full",
        },
        spellName = {
          order = 2,
          type = 'input',
          name = "Item ID",
          desc = "The Item ID of the |cff798BDDItem|r you want to filter.",
          set = setSpell,
          get = noop,
        },
        checkAdd = {
          order = 3,
          type = 'toggle',
          name = "Remove",
          desc = "Check to remove the spell from the filtered list.",
          get = getCheckAdd,
          set = setCheckAdd,
        },
        
        -- This is a feature option that I will enable when I get more time D:
        selectTracked = {
          order = 4,
          type = 'select',
          name = "Item History:",
          desc = "A list of |cff798BDDItem|r IDs that have been seen. |cffFF0000Requires:|r |cff798BDDTrack Spell History|r",
          disabled = IsTrackSpellsDisabled,
          values = GetItemHistory,
          get = noop,
          set = setSpell,
        },
      },
    },
	
	
  },
}

addon.options.args["Credits"] = {
  name = "Credits",
  type = 'group',
  order = 4,
  args = {
    title = {
      type = "header",
      order = 0,
      name = "Credits",
    },
    specialThanksTitle = {
      type = 'description',
      order = 1,
      name = "|cffFFFF00Special Thanks|r",
      fontSize = "large",
    },
    specialThanksList = {
      type = 'description',
      order = 2,
      fontSize = "medium",
      name = "  |cffAA0000Tukz|r, |cffAA0000Elv|r, |cffFFFF00Affli|r, |cffFF8000BuG|r, |cff8080FFShestak|r, Nidra, gnangnan, NitZo, Naughtia, Derap, sortokk, ckaotik, Cecile.",
    },
    testerTitleSpace1 = {
      type = 'description',
      order = 3,
      name = " ",
    },
    testerTitle = {
      type = 'description',
      order = 4,
      name = "|cffFFFF00Beta Testers|r",
      fontSize = "large",
    },
    userName1 = {
      type = 'description',
      order = 5,
      fontSize = "medium",
      name = " |cffAAAAFF Alex|r,|cff8080EE BuG|r,|cffAAAAFF Kkthnxbye|r,|cff8080EE Azilroka|r,|cffAAAAFF Prizma|r,|cff8080EE schmeebs|r,|cffAAAAFF Pat|r,|cff8080EE hgwells|r,|cffAAAAFF Jaron|r,|cff8080EE Fitzbattleaxe|r,|cffAAAAFF Nihan|r,|cff8080EE Jaxo|r,|cffAAAAFF Schaduw|r,|cff8080EE sylenced|r,|cffAAAAFF kaleidoscope|r,|cff8080EE Killatones|r,|cffAAAAFF Trokko|r,|cff8080EE Yperia|r,|cffAAAAFF Edoc|r,|cff8080EE Cazart|r,|cffAAAAFF Nevah|r,|cff8080EE Refrakt|r,|cffAAAAFF Thakah|r,|cff8080EE johnis007|r,|cffAAAAFF Sgt|r,|cff8080EE NitZo|r,|cffAAAAFF cptblackgb|r,|cff8080EE pollyzoid|r.",
    },
    testerTitleSpace2 = {
      type = 'description',
      order = 6,
      name = " ",
    },
    contactTitle = {
      type = 'description',
      order = 7,
      name = "|cffFFFF00Contact Me|r",
      fontSize = "large",
    },
    contactStep1 = {
      type = 'description',
      order = 8,
      name = "1. GitHub: |cff22FF80https://github.com/dandruff/xCT|r\n\n2. Send a PM to |cffFF8000Dandruff|r on http://tukui.org",
    },
  },
}

addon.options.args["FloatingCombatText"] = {
  name = "Floating Combat Text",
  type = 'group',
  order = 1,
  args = {
    title2 = {
      order = 0,
      type = "description",
      name = "|cffA0A0A0Some changes might require a full|r |cffD0D000Client Restart|r |cffA0A0A0(completely exit out of WoW). Do not|r |cffD00000Alt+F4|r |cffA0A0A0or|r |cffD00000Command+Q|r |cffA0A0A0or your settings might not save. Use '|r|cff798BDD/exit|r|cffA0A0A0' to close the client.|r\n\n",
      fontSize = "small",
    },
    blizzardFCT = {
      name = "Blizzard's Floating Combat Text |cffFFFFFF(Head Numbers)|r",
      type = 'group',
      order = 1,
      guiInline = true,
      args = {
        listSpacer0 = {
          type = "description",
          order = 1,
          name = "|cff798BDDFloating Combat Text Options|r:",
          fontSize = 'large',
        },
        CombatDamage = {
          order = 2,
          type = 'toggle',
          name = "Show Damage",
          desc = "Enable this option if you want your damage as Floating Combat Text.",
          get = get0,
          set = set0_update,
        },
        
        CombatLogPeriodicSpells = {
          order = 3,
          type = 'toggle',
          name = "Show Damage over Time",
          desc = "Enable this option if you want your DoT's as Floating Combat Text.",
          get = get0,
          set = set0_update,
          disabled = function(info) return not x.db.profile.blizzardFCT.CombatDamage end,
        },
        
        PetMeleeDamage = {
          order = 4,
          type = 'toggle',
          name = "Show Pet Melee Damage",
          desc = "Enable this option if you want your pet's melee damage as Floating Combat Text.",
          get = get0,
          set = set0_update,
          disabled = function(info) return not x.db.profile.blizzardFCT.CombatDamage end, 
        },
        
        CombatHealing = {
          order = 5,
          type = 'toggle',
          name = "Show Healing",
          desc = "Enable this option if you want your healing as Floating Combat Text.",
          get = get0,
          set = set0_update,
        },
        
        CombatHealingAbsorbTarget = {
          order = 6,
          type = 'toggle',
          name = "Show Absorbs",
          desc = "Enable this option if you want your aborbs as Floating Combat Text.",
          get = get0,
          set = set0_update,
        },
        
        CombatThreatChanges = {
          order = 7,
          type = 'toggle',
          name = "Show Threat Changes",
          desc = "Enable this option if you want threat changes as Floating Combat Text.",
          get = get0,
          set = set0_update,
        },
        
        -- Floating Combat Text Effects
        fctSpellMechanics = {
          order = 8,
          type = 'toggle',
          name = "Show Effects",
          desc = "Enable this option if you want to see your snares and roots.",
          get = get0,
          set = set0_update,
        },
        
        fctSpellMechanicsOther = {
          order = 9,
          type = 'toggle',
          name = "Show Other's Effects",
          desc = "Enable this option if you want to see other player's snares and roots too.",
          get = get0,
          set = set0_update,
          disabled = function(info) return not x.db.profile.blizzardFCT.fctSpellMechanics end, 
        },

        listSpacer1 = {
          type = "description",
          order = 10,
          name = "\n\n|cff798BDDFloating Combat Text Font|r:",
          fontSize = 'large',
        },
        
        enabled = {
          order = 11,
          type = 'toggle',
          name = "Customize",
          get = get0,
          set = set0_update,
        },
        
        font = {
          type = 'select', dialogControl = 'LSM30_Font',
          order = 12,
          name = "Blizzard's FCT Font",
          desc = "Set the font Blizzard's head numbers (|cffFFFF00Default:|r Friz Quadrata TT)",
          values = AceGUIWidgetLSMlists.font,
          get = get0,
          set = function(info, value)
            x.db.profile.blizzardFCT.font = value
            x.db.profile.blizzardFCT.fontName = LSM:Fetch("font", value)
            
            --x:UpdateFrames()
            --x.cvar_udpate()
          end,
          disabled = function(info) return not x.db.profile.blizzardFCT.enabled end,
        },
      },
    },
  },
}

addon.options.args["Frames"] = {
  name = "Frames",
  type = 'group',
  order = 0,
  args = {
    

    frameSettings = {
      name = "Frame Settings ",
      type = 'group',
      order = 1,
      guiInline = true,
      args = {
        
        listSpacer0 = {
          type = "description",
          order = 1,
          name = "|cff798BDDWhen Moving the Frames|r:",
          fontSize = 'large',
        },

        showGrid = {
          order = 2,
          type = 'toggle',
          name = "Show Align Grid",
          desc = "Shows a grid after you |cffFFFF00Toggle Frames|r to help you align |cffFF0000x|r|cffFFFF00CT|r|cffFF0000+|r frames better.",
          get = get0,
          set = set0,
        },
        
        showPositions = {
          order = 3,
          type = 'toggle',
          name = "Show Positions",
          desc = "Shows the locations and sizes of your frames after you |cffFFFF00Toggle Frames|r to help you align |cffFF0000x|r|cffFFFF00CT|r|cffFF0000+|r frames better.",
          get = get0,
          set = set0,
        },

        listSpacer1 = {
          type = "description",
          order = 10,
          name = "\n|cff798BDDWhen Showing the Frames|r:",
          fontSize = 'large',
        },

        frameStrata = {
          type = 'select',
          order = 11,
          name = "Frame Strata",
          desc = "The Z-Layer to place the |cffFF0000x|r|cffFFFF00CT|r|cffFF0000+|r frames onto. If you find that another addon is in front of |cffFF0000x|r|cffFFFF00CT|r|cffFF0000+|r frames, try increasing the Frame Strata.",
          values = {
            --["1PARENT"]             = "Parent |cffFF0000(Lowest)|r",
            ["2BACKGROUND"]         = "Background |cffFF0000(Lowest)|r",
            ["3LOW"]                = "Low",
            ["4MEDIUM"]             = "Medium",
            ["5HIGH"]               = "High |cffFFFF00(Default)|r",
            ["6DIALOG"]             = "Dialog",
            ["7FULLSCREEN"]         = "Fullscreen",
            ["8FULLSCREEN_DIALOG"]  = "Fullscreen Dialog",
            ["9TOOLTIP"]            = "ToolTip |cffAAFF80(Highest)|r",
          },
          get = get0,
          set = set0_update,
        },
        
        listSpacer2 = {
          type = "description",
          order = 20,
          name = "\n|cff798BDDWhen Leaving Combat|r:",
          fontSize = 'large',
        },

        clearLeavingCombat = {
          order = 21,
          type = 'toggle',
          name = "Clear Frames",
          desc = "Enable this option if you have problems with 'floating' icons.",
          width = "full",
          get = get0,
          set = set0,
        },

      },
    },

    spacer1 = {
      type = 'description',
      name = "\n",
      order = 2,
    },

    megaDamage = {
      name = "Number Format Settings",
      type = 'group',
      order = 3,
      guiInline = true,
      args = {
        listSpacer0 = {
          type = "description",
          order = 0,
          name = "|cff798BDDFormat Numbers in the Frames|r (Choose one):",
          fontSize = 'large',
        },
        formatAbbreviate = {
          type = 'toggle',
          order = 1,
          name = "Abbreviate Numbers",
          set = setFormating,
          get = getDBSpells,
        },
        formatGroups = {
          type = 'toggle',
          order = 2,
          name = "Decimal Marks",
          desc = "Groups decimals and separates them by commas; this allows for better responsiveness when reading numbers.\n\n|cffFF0000EXAMPLE|r |cff798BDD12,890|r",
          set = setFormating,
          get = getDBSpells,
        },

        abbDesc = {
          type = "description",
          order = 9,
          name = "\n\n|cffFFFF00PLEASE NOTE|r |cffAAAAAAFormat settings need to be independently enabled on each frame through its respective settings page.|r",
          fontSize = 'small',
        },

        listSpacer1 = {
          type = "description",
          order = 10,
          name = "\n|cff798BDDAdditional Abbreviation Settings|r:",
          fontSize = 'large',
        },
        thousandSymbol = {
          order = 11,
          type = 'input',
          name = "Thousand",
          desc = "Symbol for: |cffFF0000Thousands|r |cff798BDD(10e+3)|r",
          get = getTextIn0,
          set = setTextIn0,
        },
        millionSymbol = {
          order = 12,
          type = 'input',
          name = "Million",
          desc = "Symbol for: |cffFF0000Millions|r |cff798BDD(10e+6)|r",
          get = getTextIn0,
          set = setTextIn0,
        },
        decimalPoint = {
          order = 13,
          type = 'toggle',
          name = "Single Decimal",
          desc = "Shows a single decimal when abbreviating the value (e.g. will show |cff798BDD5.9K|r instead of |cff798BDD6K|r).",
          get = get0,
          set = set0,
        },
      },
    },

    spacer2 = {
      type = 'description',
      name = "\n",
      order = 4,
    },

    miscFonts = {
      order = 5,
      type = 'group',
      guiInline = true,
      name = "Global Frame Settings |cffFFFFFF(Experimental)|r",
      args = {
        miscDesc = {
          type = "description",
          order = 0,
          name = "The following settings are marked as experimental. They should all work, but they might not be very useful. Expect chanrges or updates to these in the near future.\n\nClick |cffFFFF00Set All|r to apply setting to all |cffFF0000x|r|cffFFFF00CT|r|cffFF0000+|r frames.\n",
        },
        
        
        font = {
          type = 'select', dialogControl = 'LSM30_Font',
          order = 1,
          name = "Font",
          desc = "Set the font of the frame.",
          values = AceGUIWidgetLSMlists.font,
          get = function(info) return miscFont end,
          set = function(info, value) miscFont = value end,
        },
        
        applyFont = {
          type = 'execute',
          order = 2,
          name = "Set All",
          width = "half",
          func = function()
            if miscFont then
              for framename, settings in pairs(x.db.profile.frames) do
                settings.font = miscFont
              end
              x:UpdateFrames()
            end
          end,
        },
        
        spacer1 = {
          type = 'description',
          order = 3,
          name = "",
        },
        
        fontOutline = {
          type = 'select',
          order = 4,
          name = "Font Outline",
          desc = "Set the font outline.",
          values = {
            ['1NONE'] = "None",
            ['2OUTLINE'] = 'OUTLINE',
            -- BUG: Setting font to monochrome AND above size 16 will crash WoW
            -- http://us.battle.net/wow/en/forum/topic/6470967362
            --['3MONOCHROME'] = 'MONOCHROME',
            ['4MONOCHROMEOUTLINE'] = 'MONOCHROMEOUTLINE',
            ['5THICKOUTLINE'] = 'THICKOUTLINE',
          },
          get = function(info) return miscFontOutline end,
          set = function(info, value) miscFontOutline = value end,
        },
        
        applyFontOutline = {
          type = 'execute',
          order = 5,
          name = "Set All",
          width = "half",
          func = function()
            if miscFontOutline then
              for framename, settings in pairs(x.db.profile.frames) do
                settings.fontOutline = miscFontOutline
              end
              x:UpdateFrames()
            end
          end,
        },
        
        spacer2 = {
          type = 'description',
          order = 6,
          name = "",
        },
        
        customFade = {
          type = 'toggle',
          order = 7,
          name = "Use Custom Fade",
          desc = "Allows you to customize the fade time of each frame.",
          get = function(info) return miscEnableCustomFade end,
          set = function(info, value) miscEnableCustomFade = value end,
        },
        
        applyCustomFade = {
          type = 'execute',
          order = 8,
          name = "Set All",
          width = "half",
          func = function()
            if miscEnableCustomFade ~= nil then
              for framename, settings in pairs(x.db.profile.frames) do
                if settings.enableCustomFade ~= nil then
                  settings.enableCustomFade = miscEnableCustomFade
                end
              end
              x:UpdateFrames()
            end
          end,
        },
        
      },
    },

    spacer3 = {
      type = 'description',
      name = "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n",
      order = 6,
    },

--[[ XCT+ The Frames: ]]
    general = {
      name = "|cffFFFFFFGeneral|r",
      type = 'group',
      order = 11,
      childGroups = 'tab',
      args = {

        frameSettings = {
          order = 10,
          type = 'group',
          name = "Frame Settings",
          args = {
            frameSettings = {
              type = 'description',
              order = 0,
              name = "|cff798BDDFrame Settings|r:",
              fontSize = 'large',
            },
            enabledFrame = {
              order = 1,
              type = 'toggle',
              name = "Enable",
              width = 'half',
              get = get2,
              set = set2,
            },
            secondaryFrame = {
              type = 'select',
              order = 2,
              name = "Secondary Frame",
              desc = "A frame to forward messages to when this frame is disabled.",
              values = {
                [0] = "None",
                --[1] = "General",
                [2] = "Outgoing",
                [3] = "Outgoing (Criticals)",
                [4] = "Incoming (Damage)",
                [5] = "Incoming (Healing)",
                [6] = "Class Power",
                [7] = "Special Effects (Procs)",
                [8] = "Loot & Money",
              },
              get = get2,
              set = set2,
              disabled = isFrameItemEnabled,
            },
            insertText = {
              type = 'select',
              order = 3,
              name = "Text Direction",
              desc = "Changes the direction that the text travels in the frame.",
              values = {
                ["top"] = "Down",
                ["bottom"] = "Up",
              },
              get = get2,
              set = set2_update,
              disabled = isFrameItemDisabled,
            },
            alpha = {
              order = 4,
              name = "Frame Alpha",
              desc = "Sets the alpha of the frame.",
              type = 'range',
              min = 0, max = 100, step = 1,
              get = get2,
              set = set2_update,
              disabled = isFrameItemDisabled,
            },
            megaDamage = {
              order = 5,
              type = 'toggle',
              name = "Number Formatting",
              desc = "Enables number formatting. This option can be customized in the main |cff00FF00Frames|r options page to be either |cff798BDDAbbreviation|r or |cff798BDDDecimal Marks|r. ",
              get = get2,
              set = set2,
            },

            frameScrolling = {
              type = 'description',
              order = 10,
              name = "\n|cff798BDDScrollable Frame Settings|r:",
              fontSize = 'large',
            },
            enableScrollable = {
              order = 11,
              type = 'toggle',
              name = "Enabled",
              get = get2,
              set = set2_update,
              disabled = isFrameItemDisabled,
            },
            scrollableLines = {
              order = 12,
              name = "Number of Lines",
              type = 'range',
              min = 10, max = 60, step = 1,
              get = get2,
              set = set2_update,
              disabled = isFrameNotScrollable,
            },

            frameFading = {
              type = 'description',
              order = 20,
              name = "\n|cff798BDDFading Text Settings|r:",
              fontSize = 'large',
            },
            enableCustomFade = {
              order = 21,
              type = 'toggle',
              name = "Use Custom Fade (See |cffFF0000Warning|r)",
              desc = "|cffFF0000WARNING:|r Blizzard has a bug where you may see \"floating\" icons when you change the |cffFFFF00Fading Text|r. It is highly recommended that you also enable |cffFFFF00Clear Frames When Leaving Combat|r on the main options page.",
              width = 'full',
              get = get2,
              set = set2_update,
              disabled = isFrameItemDisabled,
            },
            enableFade = {
              order = 22,
              type = 'toggle',
              name = "Enable",
              desc = "Turn off to disable fading all together.\n\n|cffFF0000Requires:|r |cffFFFF00Use Custom Fade|r",
              width = 'half',
              get = get2,
              set = set2_update,
              disabled = isFrameUseCustomFade,
            },
            fadeTime = {
              order = 23,
              name = "Fade Out Duration",
              desc = "The duration of the fade out animation. |cffFFFF00(Default: |cff798BDD0.3|r)|r\n\n|cffFF0000Requires:|r |cffFFFF00Use Custom Fade|r",
              type = 'range',
              min = 0, max = 2, step = .1,
              get = get2,
              set = set2_update,
              disabled = isFrameFadingDisabled,
            },
            visibilityTime = {
              order = 24,
              name = "Visibility Duration",
              desc = "The duration that the text is shown in the frame. |cffFFFF00(Default: |cff798BDD5|r)|r\n\n|cffFF0000Requires:|r |cffFFFF00Use Custom Fade|r",
              type = 'range',
              min = 2, max = 15, step = 1,
              get = get2,
              set = set2_update,
              disabled = isFrameFadingDisabled,
            },

          },
        },

        fonts = {
          order = 20,
          type = 'group',
          name = "Font Settings",
          args = {
            fontSettings = {
              type = 'description',
              order = 0,
              name = "|cff798BDDFont Settings|r:",
              fontSize = 'large',
            },
            font = {
              type = 'select', dialogControl = 'LSM30_Font',
              order = 1,
              name = "Font",
              desc = "Set the font of the frame.",
              values = AceGUIWidgetLSMlists.font,
              get = get2,
              set = set2_update,
              disabled = isFrameItemDisabled,
            },
            fontSize = {
              order = 2,
              name = "Font Size",
              desc = "Set the font size of the frame.",
              type = 'range',
              min = 6, max = 32, step = 1,
              get = get2,
              set = set2_update,
              disabled = isFrameItemDisabled,
            },
            fontOutline = {
              type = 'select',
              order = 3,
              name = "Font Outline",
              desc = "Set the font outline.",
              values = {
                ['1NONE'] = "None",
                ['2OUTLINE'] = 'OUTLINE',
                -- BUG: Setting font to monochrome AND above size 16 will crash WoW
                -- http://us.battle.net/wow/en/forum/topic/6470967362
                --['3MONOCHROME'] = 'MONOCHROME',
                ['4MONOCHROMEOUTLINE'] = 'MONOCHROMEOUTLINE',
                ['5THICKOUTLINE'] = 'THICKOUTLINE',
              },
              get = get2,
              set = set2_update,
              disabled = isFrameItemDisabled,
            },
            fontJustify = {
              type = 'select',
              order = 4,
              name = "Justification",
              desc = "Justifies the output to a side.",
              values = {
                ['RIGHT']  = "Right",
                ['LEFT']   = "Left",
                ['CENTER'] = "Center",
              },
              get = get2,
              set = set2_update,
            },
          },
        },

        fontColors = {
          order = 30,
          type = 'group',
          name = "Custom Colors",
          args = {
            customColors = {
              type = 'description',
              order = 0,
              name = "|cff798BDDCustom Colors|r:\n",
              fontSize = 'large',
            },
          },
        },

        specialTweaks = {
          order = 40,
          name = "Special Tweaks",
          type = 'group',
          args = {
            specialTweaks = {
              type = 'description',
              order = 0,
              name = "|cff798BDDSpecial Tweaks|r:",
              fontSize = 'large',
            },
            showInterrupts = {
              order = 1,
              type = 'toggle',
              name = "Interrupts",
              desc = "Display the spell you successfully interrupted.",
              get = get2,
              set = set2,
            },
            showDispells = {
              order = 2,
              type = 'toggle',
              name = "Dispell/Steal",
              desc = "Show the spell that you dispelled or stole.",
              get = get2,
              set = set2,
            },
            showPartyKills = {
              order = 3,
              type = 'toggle',
              name = "Unit Killed",
              desc = "Display unit that was killed by your final blow.",
              get = get2,
              set = set2,
            },
            showBuffs = {
              order = 4,
              type = 'toggle',
              name = "Buff Gains/Fades",
              desc = "Display the names of helpful auras |cff00FF00(Buffs)|r that you gain and lose.",
              get = get2,
              set = set2,
            },
            showDebuffs = {
              order = 5,
              type = 'toggle',
              name = "Debuff Gains/Fades",
              desc = "Display the names of harmful auras |cffFF0000(Debuffs)|r that you gain and lose.",
              get = get2,
              set = set2,
            },
            showLowManaHealth = {
              order = 6,
              type = 'toggle',
              name = "Low Mana/Health",
              desc = "Displays 'Low Health/Mana' when your health/mana reaches the low threshold.",
              get = get2,
              set = set2,
            },
            showCombatState = {
              order = 7,
              type = 'toggle',
              name = "Leave/Enter Combat",
              desc = "Displays when the player is leaving or entering combat.",
              get = get2,
              set = set2,
            },
            showRepChanges = {
              order = 8,
              type = 'toggle',
              name = "Show Reputation",
              desc = "Displays your player's reputation gains and losses.",
              get = get2,
              set = set2,
            },
            showHonorGains = {
              order = 9,
              type = 'toggle',
              name = "Show Honor",
              desc = "Displays your player's honor gains.",
              get = get2,
              set = set2,
            },
          },
        },

      },
    },
    
    outgoing = {
      name = "|cffFFFFFFOutgoing|r",
      type = 'group',
      order = 12,
      childGroups = 'tab',
      args = {

        frameSettings = {
          order = 10,
          type = 'group',
          name = "Frame Settings",
          args = {
            frameSettings = {
              type = 'description',
              order = 0,
              name = "|cff798BDDFrame Settings|r:",
              fontSize = 'large',
            },
            enabledFrame = {
              order = 1,
              type = 'toggle',
              name = "Enable",
              width = 'half',
              get = get2,
              set = set2,
            },
            secondaryFrame = {
              type = 'select',
              order = 2,
              name = "Secondary Frame",
              desc = "A frame to forward messages to when this frame is disabled.",
              values = {
                [0] = "None",
                [1] = "General",
                --[2] = "Outgoing",
                [3] = "Outgoing (Criticals)",
                [4] = "Incoming (Damage)",
                [5] = "Incoming (Healing)",
                [6] = "Class Power",
                [7] = "Special Effects (Procs)",
                [8] = "Loot & Money",
              },
              get = get2,
              set = set2,
              disabled = isFrameItemEnabled,
            },
            insertText = {
              type = 'select',
              order = 3,
              name = "Text Direction",
              desc = "Changes the direction that the text travels in the frame.",
              values = {
                ["top"] = "Down",
                ["bottom"] = "Up",
              },
              get = get2,
              set = set2_update,
              disabled = isFrameItemDisabled,
            },
            alpha = {
              order = 4,
              name = "Frame Alpha",
              desc = "Sets the alpha of the frame.",
              type = 'range',
              min = 0, max = 100, step = 1,
              get = get2,
              set = set2_update,
              disabled = isFrameItemDisabled,
            },
            megaDamage = {
              order = 5,
              type = 'toggle',
              name = "Number Formatting",
              desc = "Enables number formatting. This option can be customized in the main |cff00FF00Frames|r options page to be either |cff798BDDAbbreviation|r or |cff798BDDDecimal Marks|r. ",
              get = get2,
              set = set2,
            },

            frameScrolling = {
              type = 'description',
              order = 10,
              name = "\n|cff798BDDScrollable Frame Settings|r:",
              fontSize = 'large',
            },
            enableScrollable = {
              order = 11,
              type = 'toggle',
              name = "Enabled",
              get = get2,
              set = set2_update,
              disabled = isFrameItemDisabled,
            },
            scrollableLines = {
              order = 12,
              name = "Number of Lines",
              type = 'range',
              min = 10, max = 60, step = 1,
              get = get2,
              set = set2_update,
              disabled = isFrameNotScrollable,
            },

            frameFading = {
              type = 'description',
              order = 30,
              name = "\n|cff798BDDFading Text Settings|r:",
              fontSize = 'large',
            },
            enableCustomFade = {
              order = 31,
              type = 'toggle',
              name = "Use Custom Fade (See |cffFF0000Warning|r)",
              desc = "|cffFF0000WARNING:|r Blizzard has a bug where you may see \"floating\" icons when you change the |cffFFFF00Fading Text|r. It is highly recommended that you also enable |cffFFFF00Clear Frames When Leaving Combat|r on the main options page.",
              width = 'full',
              get = get2,
              set = set2_update,
              disabled = isFrameItemDisabled,
            },
            enableFade = {
              order = 32,
              type = 'toggle',
              name = "Enable",
              desc = "Turn off to disable fading all together.\n\n|cffFF0000Requires:|r |cffFFFF00Use Custom Fade|r",
              width = 'half',
              get = get2,
              set = set2_update,
              disabled = isFrameUseCustomFade,
            },
            fadeTime = {
              order = 33,
              name = "Fade Out Duration",
              desc = "The duration of the fade out animation. |cffFFFF00(Default: |cff798BDD0.3|r)|r\n\n|cffFF0000Requires:|r |cffFFFF00Use Custom Fade|r",
              type = 'range',
              min = 0, max = 2, step = .1,
              get = get2,
              set = set2_update,
              disabled = isFrameFadingDisabled,
            },
            visibilityTime = {
              order = 34,
              name = "Visibility Duration",
              desc = "The duration that the text is shown in the frame. |cffFFFF00(Default: |cff798BDD5|r)|r\n\n|cffFF0000Requires:|r |cffFFFF00Use Custom Fade|r",
              type = 'range',
              min = 2, max = 15, step = 1,
              get = get2,
              set = set2_update,
              disabled = isFrameFadingDisabled,
            },

          },
        },

        fonts = {
          order = 20,
          type = 'group',
          name = "Font Settings",
          args = {
            fontSettings = {
              type = 'description',
              order = 0,
              name = "|cff798BDDFont Settings|r:",
              fontSize = 'large',
            },
            font = {
              type = 'select', dialogControl = 'LSM30_Font',
              order = 1,
              name = "Font",
              desc = "Set the font of the frame.",
              values = AceGUIWidgetLSMlists.font,
              get = get2,
              set = set2_update,
              disabled = isFrameItemDisabled,
            },
            fontSize = {
              order = 2,
              name = "Font Size",
              desc = "Set the font size of the frame.",
              type = 'range',
              min = 6, max = 32, step = 1,
              get = get2,
              set = set2_update,
              disabled = isFrameItemDisabled,
            },
            fontOutline = {
              type = 'select',
              order = 3,
              name = "Font Outline",
              desc = "Set the font outline.",
              values = {
                ['1NONE'] = "None",
                ['2OUTLINE'] = 'OUTLINE',
                -- BUG: Setting font to monochrome AND above size 16 will crash WoW
                -- http://us.battle.net/wow/en/forum/topic/6470967362
                --['3MONOCHROME'] = 'MONOCHROME',
                ['4MONOCHROMEOUTLINE'] = 'MONOCHROMEOUTLINE',
                ['5THICKOUTLINE'] = 'THICKOUTLINE',
              },
              get = get2,
              set = set2_update,
              disabled = isFrameItemDisabled,
            },
            fontJustify = {
              type = 'select',
              order = 4,
              name = "Justification",
              desc = "Justifies the output to a side.",
              values = {
                ['RIGHT']  = "Right",
                ['LEFT']   = "Left",
                ['CENTER'] = "Center",
              },
              get = get2,
              set = set2_update,
            },

            iconSizeSettings = {
              type = 'description',
              order = 10,
              name = "\n|cff798BDDIcon Size Settings|r:",
              fontSize = 'large',
            },
            iconsEnabled = {
              order = 11,
              type = 'toggle',
              name = "Icons",
              desc = "Show icons next to your damage.",
              get = get2,
              set = set2,
              disabled = isFrameItemDisabled,
            },
            iconsSize = {
              order = 12,
              name = "Icon Size",
              desc = "Set the icon size.",
              type = 'range',
              min = 6, max = 22, step = 1,
              get = get2,
              set = set2,
              disabled = isFrameIconDisabled,
            },
          },
        },

        fontColors = {
          order = 30,
          type = 'group',
          name = "Font Colors",
          args = {
            customColors = {
              type = 'description',
              order = 0,
              name = "|cff798BDDCustom Colors|r:\n",
              fontSize = 'large',
            },
          },
        },

        specialTweaks = {
          order = 40,
          type = 'group',
          name = "Special Tweaks",
          args = {
            specialTweaks = {
              type = 'description',
              order = 0,
              name = "|cff798BDDSpecial Tweaks|r:",
              fontSize = 'large',
            },
            enableOutDmg = {
              order = 1,
              type = 'toggle',
              name = "Show Outgoing Damage",
              desc = "Show damage you do.",
              get = get2,
              set = set2,
            },
            enableOutHeal = {
              order = 2,
              type = 'toggle',
              name = "Show Outgoing Healing",
              desc = "Show healing you do.",
              get = get2,
              set = set2,
            },
            enablePetDmg = {
              order = 3,
              type = 'toggle',
              name = "Show Pet Damage",
              desc = "Show your pet's damage.",
              get = get2,
              set = set2,
            },
            enableAutoAttack = {
              order = 4,
              type = 'toggle',
              name = "Show Auto Attack",
              desc = "Show your auto attack damage.",
              get = get2,
              set = set2,
            },
            enableDotDmg = {
              order = 5,
              type = 'toggle',
              name = "Show DoTs",
              desc = "Show your Damage-Over-Time (DOT) damage. (|cffFF0000Requires:|r Outgoing Damage)",
              get = get2,
              set = set2,
            },
            enableHots = {
              order = 6,
              type = 'toggle',
              name = "Show HoTs",
              desc = "Show your Heal-Over-Time (HOT) healing. (|cffFF0000Requires:|r Outgoing Healing)",
              get = get2,
              set = set2,
            },
            enableImmunes = {
              order = 7,
              type = 'toggle',
              name = "Show Immunes",
              desc = "Display 'Immune' when your target cannot take damage.",
              get = get2,
              set = set2,
            },
            enableMisses = {
              order = 8,
              type = 'toggle',
              name = "Show Miss Types",
              desc = "Display 'Miss', 'Dodge', 'Parry' when you miss your target.",
              get = get2,
              set = set2,
            },
          },
        },

      },
    },
    
    critical = {
      name = "|cffFFFFFFOutgoing|r |cff798BDD(Criticals)|r",
      type = 'group',
      order = 13,
      childGroups = 'tab',
      args = {


        frameSettings = {
          order = 10,
          type = 'group',
          name = "Frame Settings",
          args = {
            frameSettings = {
              type = 'description',
              order = 0,
              name = "|cff798BDDFrame Settings|r:",
              fontSize = 'large',
            },
            enabledFrame = {
              order = 1,
              type = 'toggle',
              name = "Enable",
              width = 'half',
              get = get2,
              set = set2,
            },
            secondaryFrame = {
              type = 'select',
              order = 2,
              name = "Secondary Frame",
              desc = "A frame to forward messages to when this frame is disabled.",
              values = {
                [0] = "None",
                [1] = "General",
                [2] = "Outgoing",
                --[3] = "Outgoing (Criticals)",
                [4] = "Incoming (Damage)",
                [5] = "Incoming (Healing)",
                [6] = "Class Power",
                [7] = "Special Effects (Procs)",
                [8] = "Loot & Money",
              },
              get = get2,
              set = set2,
              disabled = isFrameItemEnabled,
            },
            insertText = {
              type = 'select',
              order = 3,
              name = "Text Direction",
              desc = "Changes the direction that the text travels in the frame.",
              values = {
                ["top"] = "Down",
                ["bottom"] = "Up",
              },
              get = get2,
              set = set2_update,
              disabled = isFrameItemDisabled,
            },
            alpha = {
              order = 4,
              name = "Frame Alpha",
              desc = "Sets the alpha of the frame.",
              type = 'range',
              min = 0, max = 100, step = 1,
              get = get2,
              set = set2_update,
              disabled = isFrameItemDisabled,
            },
            megaDamage = {
              order = 5,
              type = 'toggle',
              name = "Number Formatting",
              desc = "Enables number formatting. This option can be customized in the main |cff00FF00Frames|r options page to be either |cff798BDDAbbreviation|r or |cff798BDDDecimal Marks|r. ",
              get = get2,
              set = set2,
            },

            frameScrolling = {
              type = 'description',
              order = 10,
              name = "\n|cff798BDDScrollable Frame Settings|r:",
              fontSize = 'large',
            },
            enableScrollable = {
              order = 11,
              type = 'toggle',
              name = "Enabled",
              get = get2,
              set = set2_update,
              disabled = isFrameItemDisabled,
            },
            scrollableLines = {
              order = 12,
              name = "Number of Lines",
              type = 'range',
              min = 10, max = 60, step = 1,
              get = get2,
              set = set2_update,
              disabled = isFrameNotScrollable,
            },

            frameFading = {
              type = 'description',
              order = 30,
              name = "\n|cff798BDDFading Text Settings|r:",
              fontSize = 'large',
            },
            enableCustomFade = {
              order = 31,
              type = 'toggle',
              name = "Use Custom Fade (See |cffFF0000Warning|r)",
              desc = "|cffFF0000WARNING:|r Blizzard has a bug where you may see \"floating\" icons when you change the |cffFFFF00Fading Text|r. It is highly recommended that you also enable |cffFFFF00Clear Frames When Leaving Combat|r on the main options page.",
              width = 'full',
              get = get2,
              set = set2_update,
              disabled = isFrameItemDisabled,
            },
            enableFade = {
              order = 32,
              type = 'toggle',
              name = "Enable",
              desc = "Turn off to disable fading all together.\n\n|cffFF0000Requires:|r |cffFFFF00Use Custom Fade|r",
              width = 'half',
              get = get2,
              set = set2_update,
              disabled = isFrameUseCustomFade,
            },
            fadeTime = {
              order = 33,
              name = "Fade Out Duration",
              desc = "The duration of the fade out animation. |cffFFFF00(Default: |cff798BDD0.3|r)|r\n\n|cffFF0000Requires:|r |cffFFFF00Use Custom Fade|r",
              type = 'range',
              min = 0, max = 2, step = .1,
              get = get2,
              set = set2_update,
              disabled = isFrameFadingDisabled,
            },
            visibilityTime = {
              order = 34,
              name = "Visibility Duration",
              desc = "The duration that the text is shown in the frame. |cffFFFF00(Default: |cff798BDD5|r)|r\n\n|cffFF0000Requires:|r |cffFFFF00Use Custom Fade|r",
              type = 'range',
              min = 2, max = 15, step = 1,
              get = get2,
              set = set2_update,
              disabled = isFrameFadingDisabled,
            },
          },
        },

        fonts = {
          order = 20,
          type = 'group',
          name = "Font Settings",
          args = {
            fontSettings = {
              type = 'description',
              order = 0,
              name = "|cff798BDDFont Settings|r:",
              fontSize = 'large',
            },
            font = {
              type = 'select', dialogControl = 'LSM30_Font',
              order = 1,
              name = "Font",
              desc = "Set the font of the frame.",
              values = AceGUIWidgetLSMlists.font,
              get = get2,
              set = set2_update,
              disabled = isFrameItemDisabled,
            },
            fontSize = {
              order = 2,
              name = "Font Size",
              desc = "Set the font size of the frame.",
              type = 'range',
              min = 6, max = 32, step = 1,
              get = get2,
              set = set2_update,
              disabled = isFrameItemDisabled,
            },
            fontOutline = {
              type = 'select',
              order = 3,
              name = "Font Outline",
              desc = "Set the font outline.",
              values = {
                ['1NONE'] = "None",
                ['2OUTLINE'] = 'OUTLINE',
                -- BUG: Setting font to monochrome AND above size 16 will crash WoW
                -- http://us.battle.net/wow/en/forum/topic/6470967362
                --['3MONOCHROME'] = 'MONOCHROME',
                ['4MONOCHROMEOUTLINE'] = 'MONOCHROMEOUTLINE',
                ['5THICKOUTLINE'] = 'THICKOUTLINE',
              },
              get = get2,
              set = set2_update,
              disabled = isFrameItemDisabled,
            },
            fontJustify = {
              type = 'select',
              order = 4,
              name = "Justification",
              desc = "Justifies the output to a side.",
              values = {
                ['RIGHT']  = "Right",
                ['LEFT']   = "Left",
                ['CENTER'] = "Center",
              },
              get = get2,
              set = set2_update,
            },

            iconSizeSettings = {
              type = 'description',
              order = 10,
              name = "\n|cff798BDDIcon Size Settings|r:",
              fontSize = 'large',
            },
            iconsEnabled = {
              order = 11,
              type = 'toggle',
              name = "Icons",
              desc = "Show icons next to your damage.",
              get = get2,
              set = set2,
              disabled = isFrameItemDisabled,
            },
            iconsSize = {
              order = 12,
              name = "Icon Size",
              desc = "Set the icon size.",
              type = 'range',
              min = 6, max = 22, step = 1,
              get = get2,
              set = set2,
              disabled = isFrameIconDisabled,
            },
          },
        },

        fontColors = {
          order = 30,
          type = 'group',
          name = "Font Colors",
          args = {
            customColors = {
              type = 'description',
              order = 0,
              name = "|cff798BDDCustom Colors|r:\n",
              fontSize = 'large',
            },
          },
        },

        specialTweaks = {
          order = 40,
          type = 'group',
          name = "Special Tweaks",
          args = {
            specialTweaks = {
              type = 'description',
              order = 0,
              name = "|cff798BDDSpecial Tweaks|r:",
              fontSize = 'large',
            },
            showSwing = {
              order = 1,
              type = 'toggle',
              name = "Swing Crits",
              desc = "Show Swing and Auto Attack crits in this frame.",
              get = get2,
              set = set2,
            },
            prefixSwing = {
              order = 2,
              type = 'toggle',
              name = "Swing (Pre)Postfix",
              desc = "Make Swing and Auto Attack crits more visible by adding the prefix and postfix.",
              get = get2,
              set = set2,
            },

            criticalAppearance = {
              type = 'description',
              order = 10,
              name = "\n|cff798BDDCritical Appearance|r:",
              fontSize = 'large',
            },
            critPrefix = {
              order = 11,
              type = 'input',
              name = "Prefix",
              desc = "Prefix this value to the beginning when displaying a critical amount.",
              get = getTextIn2,
              set = setTextIn2,
              disabled = isFrameItemDisabled,
            },
            critPostfix = {
              order = 12,
              type = 'input',
              name = "Postfix",
              desc = "Postfix this value to the end when displaying a critical amount.",
              get = getTextIn2,
              set = setTextIn2,
              disabled = isFrameItemDisabled,
            },
          },

        },
      },
    },
    
    damage = {
      name = "|cffFFFFFFIncoming|r |cff798BDD(Damage)|r",
      type = 'group',
      order = 14,
      childGroups = 'tab',
      args = {

        frameSettings = {
          order = 10,
          type = 'group',
          name = "Frame Settings",
          args = {
            frameSettings = {
              type = 'description',
              order = 0,
              name = "|cff798BDDFrame Settings|r:",
              fontSize = 'large',
            },
            enabledFrame = {
              order = 1,
              type = 'toggle',
              name = "Enable",
              width = 'half',
              get = get2,
              set = set2,
            },
            secondaryFrame = {
              type = 'select',
              order = 2,
              name = "Secondary Frame",
              desc = "A frame to forward messages to when this frame is disabled.",
              values = {
                [0] = "None",
                [1] = "General",
                [2] = "Outgoing",
                [3] = "Outgoing (Criticals)",
                --[4] = "Incoming (Damage)",
                [5] = "Incoming (Healing)",
                [6] = "Class Power",
                [7] = "Special Effects (Procs)",
                [8] = "Loot & Money",
              },
              get = get2,
              set = set2,
              disabled = isFrameItemEnabled,
            },
            insertText = {
              type = 'select',
              order = 3,
              name = "Text Direction",
              desc = "Changes the direction that the text travels in the frame.",
              values = {
                ["top"] = "Down",
                ["bottom"] = "Up",
              },
              get = get2,
              set = set2_update,
              disabled = isFrameItemDisabled,
            },
            alpha = {
              order = 4,
              name = "Frame Alpha",
              desc = "Sets the alpha of the frame.",
              type = 'range',
              min = 0, max = 100, step = 1,
              get = get2,
              set = set2_update,
              disabled = isFrameItemDisabled,
            },
            megaDamage = {
              order = 5,
              type = 'toggle',
              name = "Number Formatting",
              desc = "Enables number formatting. This option can be customized in the main |cff00FF00Frames|r options page to be either |cff798BDDAbbreviation|r or |cff798BDDDecimal Marks|r. ",
              get = get2,
              set = set2,
            },

            frameScrolling = {
              type = 'description',
              order = 10,
              name = "\n|cff798BDDScrollable Frame Settings|r:",
              fontSize = 'large',
            },
            enableScrollable = {
              order = 11,
              type = 'toggle',
              name = "Enabled",
              get = get2,
              set = set2_update,
              disabled = isFrameItemDisabled,
            },
            scrollableLines = {
              order = 12,
              name = "Number of Lines",
              type = 'range',
              min = 10, max = 60, step = 1,
              get = get2,
              set = set2_update,
              disabled = isFrameNotScrollable,
            },

            frameFading = {
              type = 'description',
              order = 20,
              name = "\n|cff798BDDFading Text Settings|r:",
              fontSize = 'large',
            },
            enableCustomFade = {
              order = 21,
              type = 'toggle',
              name = "Use Custom Fade (See |cffFF0000Warning|r)",
              desc = "|cffFF0000WARNING:|r Blizzard has a bug where you may see \"floating\" icons when you change the |cffFFFF00Fading Text|r. It is highly recommended that you also enable |cffFFFF00Clear Frames When Leaving Combat|r on the main options page.",
              width = 'full',
              get = get2,
              set = set2_update,
              disabled = isFrameItemDisabled,
            },
            enableFade = {
              order = 22,
              type = 'toggle',
              name = "Enable",
              desc = "Turn off to disable fading all together.\n\n|cffFF0000Requires:|r |cffFFFF00Use Custom Fade|r",
              width = 'half',
              get = get2,
              set = set2_update,
              disabled = isFrameUseCustomFade,
            },
            fadeTime = {
              order = 23,
              name = "Fade Out Duration",
              desc = "The duration of the fade out animation. |cffFFFF00(Default: |cff798BDD0.3|r)|r\n\n|cffFF0000Requires:|r |cffFFFF00Use Custom Fade|r",
              type = 'range',
              min = 0, max = 2, step = .1,
              get = get2,
              set = set2_update,
              disabled = isFrameFadingDisabled,
            },
            visibilityTime = {
              order = 24,
              name = "Visibility Duration",
              desc = "The duration that the text is shown in the frame. |cffFFFF00(Default: |cff798BDD5|r)|r\n\n|cffFF0000Requires:|r |cffFFFF00Use Custom Fade|r",
              type = 'range',
              min = 2, max = 15, step = 1,
              get = get2,
              set = set2_update,
              disabled = isFrameFadingDisabled,
            },

          },
        },

        fonts = {
          order = 20,
          type = 'group',
          name = "Font Settings",
          args = {
            fontSettings = {
              type = 'description',
              order = 0,
              name = "|cff798BDDFont Settings|r:",
              fontSize = 'large',
            },
            font = {
              type = 'select', dialogControl = 'LSM30_Font',
              order = 1,
              name = "Font",
              desc = "Set the font of the frame.",
              values = AceGUIWidgetLSMlists.font,
              get = get2,
              set = set2_update,
              disabled = isFrameItemDisabled,
            },
            fontSize = {
              order = 2,
              name = "Font Size",
              desc = "Set the font size of the frame.",
              type = 'range',
              min = 6, max = 32, step = 1,
              get = get2,
              set = set2_update,
              disabled = isFrameItemDisabled,
            },
            fontOutline = {
              type = 'select',
              order = 3,
              name = "Font Outline",
              desc = "Set the font outline.",
              values = {
                ['1NONE'] = "None",
                ['2OUTLINE'] = 'OUTLINE',
                -- BUG: Setting font to monochrome AND above size 16 will crash WoW
                -- http://us.battle.net/wow/en/forum/topic/6470967362
                --['3MONOCHROME'] = 'MONOCHROME',
                ['4MONOCHROMEOUTLINE'] = 'MONOCHROMEOUTLINE',
                ['5THICKOUTLINE'] = 'THICKOUTLINE',
              },
              get = get2,
              set = set2_update,
              disabled = isFrameItemDisabled,
            },
            fontJustify = {
              type = 'select',
              order = 4,
              name = "Justification",
              desc = "Justifies the output to a side.",
              values = {
                ['RIGHT']  = "Right",
                ['LEFT']   = "Left",
                ['CENTER'] = "Center",
              },
              get = get2,
              set = set2_update,
            },
          },
        },

        fontColors = {
          order = 30,
          type = 'group',
          name = "Custom Colors",
          args = {
            customColors = {
              type = 'description',
              order = 0,
              name = "|cff798BDDCustom Colors|r:\n",
              fontSize = 'large',
            },
          },
        },

        specialTweaks = {
          order = 40,
          name = "Special Tweaks",
          type = 'group',
          args = {
            specialTweaks = {
              type = 'description',
              order = 0,
              name = "|cff798BDDSpecial Tweaks|r:",
              fontSize = 'large',
            },
            showDodgeParryMiss = {
              order = 1,
              type = 'toggle',
              name = "Show Miss Types",
              desc = "Displays Dodge, Parry, or Miss when you miss incoming damage.",
              get = get2,
              set = set2,
            },
            showDamageReduction = {
              order = 2,
              type = 'toggle',
              name = "Show Reductions",
              desc = "Formats incoming damage to show how much was absorbed.",
              get = get2,
              set = set2,
            },
          },
        },
      },
    },
    
    healing = {
      name = "|cffFFFFFFIncoming|r |cff798BDD(Healing)|r",
      type = 'group',
      order = 15,
      childGroups = 'tab',
      args = {

        frameSettings = {
          order = 10,
          type = 'group',
          name = "Frame Settings",
          args = {
            frameSettings = {
              type = 'description',
              order = 0,
              name = "|cff798BDDFrame Settings|r:",
              fontSize = 'large',
            },
            enabledFrame = {
              order = 1,
              type = 'toggle',
              name = "Enable",
              width = 'half',
              get = get2,
              set = set2,
            },
            secondaryFrame = {
              type = 'select',
              order = 2,
              name = "Secondary Frame",
              desc = "A frame to forward messages to when this frame is disabled.",
              values = {
                [0] = "None",
                [1] = "General",
                [2] = "Outgoing",
                [3] = "Outgoing (Criticals)",
                [4] = "Incoming (Damage)",
                --[5] = "Incoming (Healing)",
                [6] = "Class Power",
                [7] = "Special Effects (Procs)",
                [8] = "Loot & Money",
              },
              get = get2,
              set = set2,
              disabled = isFrameItemEnabled,
            },
            insertText = {
              type = 'select',
              order = 3,
              name = "Text Direction",
              desc = "Changes the direction that the text travels in the frame.",
              values = {
                ["top"] = "Down",
                ["bottom"] = "Up",
              },
              get = get2,
              set = set2_update,
              disabled = isFrameItemDisabled,
            },
            alpha = {
              order = 4,
              name = "Frame Alpha",
              desc = "Sets the alpha of the frame.",
              type = 'range',
              min = 0, max = 100, step = 1,
              get = get2,
              set = set2_update,
              disabled = isFrameItemDisabled,
            },
            megaDamage = {
              order = 5,
              type = 'toggle',
              name = "Number Formatting",
              desc = "Enables number formatting. This option can be customized in the main |cff00FF00Frames|r options page to be either |cff798BDDAbbreviation|r or |cff798BDDDecimal Marks|r. ",
              get = get2,
              set = set2,
            },

            frameScrolling = {
              type = 'description',
              order = 10,
              name = "\n|cff798BDDScrollable Frame Settings|r:",
              fontSize = 'large',
            },
            enableScrollable = {
              order = 11,
              type = 'toggle',
              name = "Enabled",
              get = get2,
              set = set2_update,
              disabled = isFrameItemDisabled,
            },
            scrollableLines = {
              order = 12,
              name = "Number of Lines",
              type = 'range',
              min = 10, max = 60, step = 1,
              get = get2,
              set = set2_update,
              disabled = isFrameNotScrollable,
            },

            frameFading = {
              type = 'description',
              order = 20,
              name = "\n|cff798BDDFading Text Settings|r:",
              fontSize = 'large',
            },
            enableCustomFade = {
              order = 21,
              type = 'toggle',
              name = "Use Custom Fade (See |cffFF0000Warning|r)",
              desc = "|cffFF0000WARNING:|r Blizzard has a bug where you may see \"floating\" icons when you change the |cffFFFF00Fading Text|r. It is highly recommended that you also enable |cffFFFF00Clear Frames When Leaving Combat|r on the main options page.",
              width = 'full',
              get = get2,
              set = set2_update,
              disabled = isFrameItemDisabled,
            },
            enableFade = {
              order = 22,
              type = 'toggle',
              name = "Enable",
              desc = "Turn off to disable fading all together.\n\n|cffFF0000Requires:|r |cffFFFF00Use Custom Fade|r",
              width = 'half',
              get = get2,
              set = set2_update,
              disabled = isFrameUseCustomFade,
            },
            fadeTime = {
              order = 23,
              name = "Fade Out Duration",
              desc = "The duration of the fade out animation. |cffFFFF00(Default: |cff798BDD0.3|r)|r\n\n|cffFF0000Requires:|r |cffFFFF00Use Custom Fade|r",
              type = 'range',
              min = 0, max = 2, step = .1,
              get = get2,
              set = set2_update,
              disabled = isFrameFadingDisabled,
            },
            visibilityTime = {
              order = 24,
              name = "Visibility Duration",
              desc = "The duration that the text is shown in the frame. |cffFFFF00(Default: |cff798BDD5|r)|r\n\n|cffFF0000Requires:|r |cffFFFF00Use Custom Fade|r",
              type = 'range',
              min = 2, max = 15, step = 1,
              get = get2,
              set = set2_update,
              disabled = isFrameFadingDisabled,
            },

          },
        },

        fonts = {
          order = 20,
          type = 'group',
          name = "Font Settings",
          args = {
            fontSettings = {
              type = 'description',
              order = 0,
              name = "|cff798BDDFont Settings|r:",
              fontSize = 'large',
            },
            font = {
              type = 'select', dialogControl = 'LSM30_Font',
              order = 1,
              name = "Font",
              desc = "Set the font of the frame.",
              values = AceGUIWidgetLSMlists.font,
              get = get2,
              set = set2_update,
              disabled = isFrameItemDisabled,
            },
            fontSize = {
              order = 2,
              name = "Font Size",
              desc = "Set the font size of the frame.",
              type = 'range',
              min = 6, max = 32, step = 1,
              get = get2,
              set = set2_update,
              disabled = isFrameItemDisabled,
            },
            fontOutline = {
              type = 'select',
              order = 3,
              name = "Font Outline",
              desc = "Set the font outline.",
              values = {
                ['1NONE'] = "None",
                ['2OUTLINE'] = 'OUTLINE',
                -- BUG: Setting font to monochrome AND above size 16 will crash WoW
                -- http://us.battle.net/wow/en/forum/topic/6470967362
                --['3MONOCHROME'] = 'MONOCHROME',
                ['4MONOCHROMEOUTLINE'] = 'MONOCHROMEOUTLINE',
                ['5THICKOUTLINE'] = 'THICKOUTLINE',
              },
              get = get2,
              set = set2_update,
              disabled = isFrameItemDisabled,
            },
            fontJustify = {
              type = 'select',
              order = 4,
              name = "Justification",
              desc = "Justifies the output to a side.",
              values = {
                ['RIGHT']  = "Right",
                ['LEFT']   = "Left",
                ['CENTER'] = "Center",
              },
              get = get2,
              set = set2_update,
            },
          },
        },

        fontColors = {
          order = 30,
          type = 'group',
          name = "Custom Colors",
          args = {
            customColors = {
              type = 'description',
              order = 0,
              name = "|cff798BDDCustom Colors|r:\n",
              fontSize = 'large',
            },
          },
        },

        specialTweaks = {
          order = 40,
          name = "Special Tweaks",
          type = 'group',
          args = {
            specialTweaks = {
              type = 'description',
              order = 0,
              name = "|cff798BDDSpecial Tweaks|r:",
              fontSize = 'large',
            },
            showFriendlyHealers = {
              order = 1,
              type = 'toggle',
              name = "Show Names",
              desc = "Shows the healer names next to incoming heals.",
              get = get2,
              set = set2,
            },
            enableClassNames = {
              order = 2,
              type = 'toggle',
              name = "Class Color Names",
              desc = "Color healer names by class. \n\n|cffFF0000Requires:|r Healer in |cffAAAAFFParty|r or |cffFF8000Raid|r",
              get = get2,
              set = set2,
            },
            enableRealmNames = {
              order = 3,
              type = 'toggle',
              name = "Show Realm Names",
              desc = "Show incoming healer names with their realm name.",
              get = get2,
              set = set2,
            },
            enableOverHeal = {
              order = 4,
              type = 'toggle',
              name = "Show Overheals",
              desc = "Show the overhealing you do in your heals. Switch off to not show overheal and make healing less spamming.",
              get = get2,
              set = set2,
            },
            enableSelfAbsorbs = {
              order = 5,
              type = 'toggle',
              name = "Show Absorbs",
              desc = "Shows incoming absorbs.",
              get = get2,
              set = set2,
            },
          },
        },
      },
    },
    
    class = {
      name = "|cffFFFFFFClass Combo Points|r",
      type = 'group',
      order = 16,
      childGroups = 'tab',
      args = {
        frameSettings = {
          order = 10,
          type = 'group',
          name = "Frame Settings",
          args = {
            frameSettings = {
              type = 'description',
              order = 0,
              name = "|cff798BDDFrame Settings|r:",
              fontSize = 'large',
            },
            enabledFrame = {
              order = 1,
              type = 'toggle',
              name = "Enable",
              width = 'half',
              get = get2,
              set = set2,
            },
            secondaryFrame = {
              type = 'description',
              order = 2,
              name = "\n|cffFF0000Secondary Frame Not Available|r - |cffFFFFFFThis frame cannot output to another frame when it is disabled.\n\n",
              width = "double",
            },
            alpha = {
              order = 4,
              name = "Frame Alpha",
              desc = "Sets the alpha of the frame.",
              type = 'range',
              min = 0, max = 100, step = 1,
              get = get2,
              set = set2_update,
              disabled = isFrameItemDisabled,
            },

            frameScrolling = {
              type = 'description',
              order = 10,
              name = "\n|cff798BDDScrollable Frame Settings|r:",
              fontSize = 'large',
            },
            enableScrollable = {
              order = 11,
              type = 'toggle',
              name = "Enabled",
              get = get2,
              set = set2_update,
              disabled = isFrameItemDisabled,
            },
            scrollableLines = {
              order = 12,
              name = "Number of Lines",
              type = 'range',
              min = 10, max = 60, step = 1,
              get = get2,
              set = set2_update,
              disabled = isFrameNotScrollable,
            },
          },
        },

        fonts = {
          order = 20,
          type = 'group',
          name = "Font Settings",
          args = {
            fontSettings = {
              type = 'description',
              order = 0,
              name = "|cff798BDDFont Settings|r:",
              fontSize = 'large',
            },
            font = {
              type = 'select', dialogControl = 'LSM30_Font',
              order = 1,
              name = "Font",
              desc = "Set the font of the frame.",
              values = AceGUIWidgetLSMlists.font,
              get = get2,
              set = set2_update,
              disabled = isFrameItemDisabled,
            },
            fontSize = {
              order = 2,
              name = "Font Size",
              desc = "Set the font size of the frame.",
              type = 'range',
              min = 6, max = 32, step = 1,
              get = get2,
              set = set2_update,
              disabled = isFrameItemDisabled,
            },
            fontOutline = {
              type = 'select',
              order = 3,
              name = "Font Outline",
              desc = "Set the font outline.",
              values = {
                ['1NONE'] = "None",
                ['2OUTLINE'] = 'OUTLINE',
                -- BUG: Setting font to monochrome AND above size 16 will crash WoW
                -- http://us.battle.net/wow/en/forum/topic/6470967362
                --['3MONOCHROME'] = 'MONOCHROME',
                ['4MONOCHROMEOUTLINE'] = 'MONOCHROMEOUTLINE',
                ['5THICKOUTLINE'] = 'THICKOUTLINE',
              },
              get = get2,
              set = set2_update,
              disabled = isFrameItemDisabled,
            },
          },
        },

        fontColors = {
          order = 30,
          type = 'group',
          name = "Custom Colors",
          args = {
            customColors = {
              type = 'description',
              order = 0,
              name = "|cff798BDDCustom Colors|r:\n",
              fontSize = 'large',
            },
          },
        },

      },
    },
    
    power = {
      name = "|cffFFFFFFClass Power|r",
      type = 'group',
      order = 17,
      childGroups = 'tab',
      args = {

        frameSettings = {
          order = 10,
          type = 'group',
          name = "Frame Settings",
          args = {
            frameSettings = {
              type = 'description',
              order = 0,
              name = "|cff798BDDFrame Settings|r:",
              fontSize = 'large',
            },
            enabledFrame = {
              order = 1,
              type = 'toggle',
              name = "Enable",
              width = 'half',
              get = get2,
              set = set2,
            },
            secondaryFrame = {
              type = 'select',
              order = 2,
              name = "Secondary Frame",
              desc = "A frame to forward messages to when this frame is disabled.",
              values = {
                [0] = "None",
                [1] = "General",
                [2] = "Outgoing",
                [3] = "Outgoing (Criticals)",
                [4] = "Incoming (Damage)",
                [5] = "Incoming (Healing)",
                --[6] = "Class Power",
                [7] = "Special Effects (Procs)",
                [8] = "Loot & Money",
              },
              get = get2,
              set = set2,
              disabled = isFrameItemEnabled,
            },
            insertText = {
              type = 'select',
              order = 3,
              name = "Text Direction",
              desc = "Changes the direction that the text travels in the frame.",
              values = {
                ["top"] = "Down",
                ["bottom"] = "Up",
              },
              get = get2,
              set = set2_update,
              disabled = isFrameItemDisabled,
            },
            alpha = {
              order = 4,
              name = "Frame Alpha",
              desc = "Sets the alpha of the frame.",
              type = 'range',
              min = 0, max = 100, step = 1,
              get = get2,
              set = set2_update,
              disabled = isFrameItemDisabled,
            },
            megaDamage = {
              order = 5,
              type = 'toggle',
              name = "Number Formatting",
              desc = "Enables number formatting. This option can be customized in the main |cff00FF00Frames|r options page to be either |cff798BDDAbbreviation|r or |cff798BDDDecimal Marks|r. ",
              get = get2,
              set = set2,
            },

            frameScrolling = {
              type = 'description',
              order = 10,
              name = "\n|cff798BDDScrollable Frame Settings|r:",
              fontSize = 'large',
            },
            enableScrollable = {
              order = 11,
              type = 'toggle',
              name = "Enabled",
              get = get2,
              set = set2_update,
              disabled = isFrameItemDisabled,
            },
            scrollableLines = {
              order = 12,
              name = "Number of Lines",
              type = 'range',
              min = 10, max = 60, step = 1,
              get = get2,
              set = set2_update,
              disabled = isFrameNotScrollable,
            },

            frameFading = {
              type = 'description',
              order = 20,
              name = "\n|cff798BDDFading Text Settings|r:",
              fontSize = 'large',
            },
            enableCustomFade = {
              order = 21,
              type = 'toggle',
              name = "Use Custom Fade (See |cffFF0000Warning|r)",
              desc = "|cffFF0000WARNING:|r Blizzard has a bug where you may see \"floating\" icons when you change the |cffFFFF00Fading Text|r. It is highly recommended that you also enable |cffFFFF00Clear Frames When Leaving Combat|r on the main options page.",
              width = 'full',
              get = get2,
              set = set2_update,
              disabled = isFrameItemDisabled,
            },
            enableFade = {
              order = 22,
              type = 'toggle',
              name = "Enable",
              desc = "Turn off to disable fading all together.\n\n|cffFF0000Requires:|r |cffFFFF00Use Custom Fade|r",
              width = 'half',
              get = get2,
              set = set2_update,
              disabled = isFrameUseCustomFade,
            },
            fadeTime = {
              order = 23,
              name = "Fade Out Duration",
              desc = "The duration of the fade out animation. |cffFFFF00(Default: |cff798BDD0.3|r)|r\n\n|cffFF0000Requires:|r |cffFFFF00Use Custom Fade|r",
              type = 'range',
              min = 0, max = 2, step = .1,
              get = get2,
              set = set2_update,
              disabled = isFrameFadingDisabled,
            },
            visibilityTime = {
              order = 24,
              name = "Visibility Duration",
              desc = "The duration that the text is shown in the frame. |cffFFFF00(Default: |cff798BDD5|r)|r\n\n|cffFF0000Requires:|r |cffFFFF00Use Custom Fade|r",
              type = 'range',
              min = 2, max = 15, step = 1,
              get = get2,
              set = set2_update,
              disabled = isFrameFadingDisabled,
            },

          },
        },

        fonts = {
          order = 20,
          type = 'group',
          name = "Font Settings",
          args = {
            fontSettings = {
              type = 'description',
              order = 0,
              name = "|cff798BDDFont Settings|r:",
              fontSize = 'large',
            },
            font = {
              type = 'select', dialogControl = 'LSM30_Font',
              order = 1,
              name = "Font",
              desc = "Set the font of the frame.",
              values = AceGUIWidgetLSMlists.font,
              get = get2,
              set = set2_update,
              disabled = isFrameItemDisabled,
            },
            fontSize = {
              order = 2,
              name = "Font Size",
              desc = "Set the font size of the frame.",
              type = 'range',
              min = 6, max = 32, step = 1,
              get = get2,
              set = set2_update,
              disabled = isFrameItemDisabled,
            },
            fontOutline = {
              type = 'select',
              order = 3,
              name = "Font Outline",
              desc = "Set the font outline.",
              values = {
                ['1NONE'] = "None",
                ['2OUTLINE'] = 'OUTLINE',
                -- BUG: Setting font to monochrome AND above size 16 will crash WoW
                -- http://us.battle.net/wow/en/forum/topic/6470967362
                --['3MONOCHROME'] = 'MONOCHROME',
                ['4MONOCHROMEOUTLINE'] = 'MONOCHROMEOUTLINE',
                ['5THICKOUTLINE'] = 'THICKOUTLINE',
              },
              get = get2,
              set = set2_update,
              disabled = isFrameItemDisabled,
            },
            fontJustify = {
              type = 'select',
              order = 4,
              name = "Justification",
              desc = "Justifies the output to a side.",
              values = {
                ['RIGHT']  = "Right",
                ['LEFT']   = "Left",
                ['CENTER'] = "Center",
              },
              get = get2,
              set = set2_update,
            },
          },
        },

        -- TODO: Add Color Options to Class Power frame
        --[[fontColors = {
          order = 30,
          type = 'group',
          name = "Custom Colors",
          args = {
            customColors = {
              type = 'description',
              order = 0,
              name = "|cff798BDDCustom Colors|r:\n",
              fontSize = 'large',
            },
          },
        },]]

        specialTweaks = {
          order = 40,
          name = "Special Tweaks",
          type = 'group',
          args = {
            specialTweaks = {
              type = 'description',
              order = 0,
              name = "|cff798BDDSpecial Tweaks|r:",
              fontSize = 'large',
            },
            showEnergyGains = {
              order = 1,
              type = 'toggle',
              name = "Show Energy Gains",
              desc = "Show instant energy gains.",
              get = get2,
              set = set2,
            },
            showPeriodicEnergyGains = {
              order = 2,
              type = 'toggle',
              name = "Show Periodic Energy Gains",
              desc = "Show energy gained over time.",
              get = get2,
              set = set2,
              width = "double",
            },
          },
        },
      },
    },
    
    procs = {
      name = "|cffFFFFFFSpecial Effects|r |cff798BDD(Procs)|r",
      type = 'group',
      order = 18,
      childGroups = 'tab',
      args = {

        frameSettings = {
          order = 10,
          type = 'group',
          name = "Frame Settings",
          args = {
            frameSettings = {
              type = 'description',
              order = 0,
              name = "|cff798BDDFrame Settings|r:",
              fontSize = 'large',
            },
            enabledFrame = {
              order = 1,
              type = 'toggle',
              name = "Enable",
              width = 'half',
              get = get2,
              set = set2,
            },
            secondaryFrame = {
              type = 'select',
              order = 2,
              name = "Secondary Frame",
              desc = "A frame to forward messages to when this frame is disabled.",
              values = {
                [0] = "None",
                [1] = "General",
                [2] = "Outgoing",
                [3] = "Outgoing (Criticals)",
                [4] = "Incoming (Damage)",
                [5] = "Incoming (Healing)",
                [6] = "Class Power",
                --[7] = "Special Effects (Procs)",
                [8] = "Loot & Money",
              },
              get = get2,
              set = set2,
              disabled = isFrameItemEnabled,
            },
            insertText = {
              type = 'select',
              order = 3,
              name = "Text Direction",
              desc = "Changes the direction that the text travels in the frame.",
              values = {
                ["top"] = "Down",
                ["bottom"] = "Up",
              },
              get = get2,
              set = set2_update,
              disabled = isFrameItemDisabled,
            },
            alpha = {
              order = 4,
              name = "Frame Alpha",
              desc = "Sets the alpha of the frame.",
              type = 'range',
              min = 0, max = 100, step = 1,
              get = get2,
              set = set2_update,
              disabled = isFrameItemDisabled,
            },

            frameScrolling = {
              type = 'description',
              order = 10,
              name = "\n|cff798BDDScrollable Frame Settings|r:",
              fontSize = 'large',
            },
            enableScrollable = {
              order = 11,
              type = 'toggle',
              name = "Enabled",
              get = get2,
              set = set2_update,
              disabled = isFrameItemDisabled,
            },
            scrollableLines = {
              order = 12,
              name = "Number of Lines",
              type = 'range',
              min = 10, max = 60, step = 1,
              get = get2,
              set = set2_update,
              disabled = isFrameNotScrollable,
            },

            frameFading = {
              type = 'description',
              order = 20,
              name = "\n|cff798BDDFading Text Settings|r:",
              fontSize = 'large',
            },
            enableCustomFade = {
              order = 21,
              type = 'toggle',
              name = "Use Custom Fade (See |cffFF0000Warning|r)",
              desc = "|cffFF0000WARNING:|r Blizzard has a bug where you may see \"floating\" icons when you change the |cffFFFF00Fading Text|r. It is highly recommended that you also enable |cffFFFF00Clear Frames When Leaving Combat|r on the main options page.",
              width = 'full',
              get = get2,
              set = set2_update,
              disabled = isFrameItemDisabled,
            },
            enableFade = {
              order = 22,
              type = 'toggle',
              name = "Enable",
              desc = "Turn off to disable fading all together.\n\n|cffFF0000Requires:|r |cffFFFF00Use Custom Fade|r",
              width = 'half',
              get = get2,
              set = set2_update,
              disabled = isFrameUseCustomFade,
            },
            fadeTime = {
              order = 23,
              name = "Fade Out Duration",
              desc = "The duration of the fade out animation. |cffFFFF00(Default: |cff798BDD0.3|r)|r\n\n|cffFF0000Requires:|r |cffFFFF00Use Custom Fade|r",
              type = 'range',
              min = 0, max = 2, step = .1,
              get = get2,
              set = set2_update,
              disabled = isFrameFadingDisabled,
            },
            visibilityTime = {
              order = 24,
              name = "Visibility Duration",
              desc = "The duration that the text is shown in the frame. |cffFFFF00(Default: |cff798BDD5|r)|r\n\n|cffFF0000Requires:|r |cffFFFF00Use Custom Fade|r",
              type = 'range',
              min = 2, max = 15, step = 1,
              get = get2,
              set = set2_update,
              disabled = isFrameFadingDisabled,
            },
          },
        },

        fonts = {
          order = 20,
          type = 'group',
          name = "Font Settings",
          args = {
            fontSettings = {
              type = 'description',
              order = 0,
              name = "|cff798BDDFont Settings|r:",
              fontSize = 'large',
            },
            font = {
              type = 'select', dialogControl = 'LSM30_Font',
              order = 1,
              name = "Font",
              desc = "Set the font of the frame.",
              values = AceGUIWidgetLSMlists.font,
              get = get2,
              set = set2_update,
              disabled = isFrameItemDisabled,
            },
            fontSize = {
              order = 2,
              name = "Font Size",
              desc = "Set the font size of the frame.",
              type = 'range',
              min = 6, max = 32, step = 1,
              get = get2,
              set = set2_update,
              disabled = isFrameItemDisabled,
            },
            fontOutline = {
              type = 'select',
              order = 3,
              name = "Font Outline",
              desc = "Set the font outline.",
              values = {
                ['1NONE'] = "None",
                ['2OUTLINE'] = 'OUTLINE',
                -- BUG: Setting font to monochrome AND above size 16 will crash WoW
                -- http://us.battle.net/wow/en/forum/topic/6470967362
                --['3MONOCHROME'] = 'MONOCHROME',
                ['4MONOCHROMEOUTLINE'] = 'MONOCHROMEOUTLINE',
                ['5THICKOUTLINE'] = 'THICKOUTLINE',
              },
              get = get2,
              set = set2_update,
              disabled = isFrameItemDisabled,
            },
            fontJustify = {
              type = 'select',
              order = 4,
              name = "Justification",
              desc = "Justifies the output to a side.",
              values = {
                ['RIGHT']  = "Right",
                ['LEFT']   = "Left",
                ['CENTER'] = "Center",
              },
              get = get2,
              set = set2_update,
            },

            iconSizeSettings = {
              type = 'description',
              order = 10,
              name = "\n|cff798BDDIcon Size Settings|r:",
              fontSize = 'large',
            },
            iconsEnabled = {
              order = 11,
              type = 'toggle',
              name = "Icons",
              desc = "Show icons next to your damage.",
              get = get2,
              set = set2,
              disabled = isFrameItemDisabled,
            },
            iconsSize = {
              order = 12,
              name = "Icon Size",
              desc = "Set the icon size.",
              type = 'range',
              min = 6, max = 22, step = 1,
              get = get2,
              set = set2,
              disabled = isFrameIconDisabled,
            },
          },
        },

        fontColors = {
          order = 30,
          type = 'group',
          name = "Custom Colors",
          args = {
            customColors = {
              type = 'description',
              order = 0,
              name = "|cff798BDDCustom Colors|r:\n",
              fontSize = 'large',
            },
          },
        },

      },
    },
    
    loot = {
      name = "|cffFFFFFFLoot & Money|r",
      type = 'group',
      order = 19,
      childGroups = 'tab',
      args = {

        frameSettings = {
          order = 10,
          type = 'group',
          name = "Frame Settings",
          args = {
            frameSettings = {
              type = 'description',
              order = 0,
              name = "|cff798BDDFrame Settings|r:",
              fontSize = 'large',
            },
            enabledFrame = {
              order = 1,
              type = 'toggle',
              name = "Enable",
              width = 'half',
              get = get2,
              set = set2,
            },
            secondaryFrame = {
              type = 'select',
              order = 2,
              name = "Secondary Frame",
              desc = "A frame to forward messages to when this frame is disabled.",
              values = {
                [0] = "None",
                [1] = "General",
                [2] = "Outgoing",
                [3] = "Outgoing (Criticals)",
                [4] = "Incoming (Damage)",
                [5] = "Incoming (Healing)",
                [6] = "Class Power",
                [7] = "Special Effects (Procs)",
                --[8] = "Loot & Money",
              },
              get = get2,
              set = set2,
              disabled = isFrameItemEnabled,
            },
            insertText = {
              type = 'select',
              order = 3,
              name = "Text Direction",
              desc = "Changes the direction that the text travels in the frame.",
              values = {
                ["top"] = "Down",
                ["bottom"] = "Up",
              },
              get = get2,
              set = set2_update,
              disabled = isFrameItemDisabled,
            },
            alpha = {
              order = 4,
              name = "Frame Alpha",
              desc = "Sets the alpha of the frame.",
              type = 'range',
              min = 0, max = 100, step = 1,
              get = get2,
              set = set2_update,
              disabled = isFrameItemDisabled,
            },

            frameScrolling = {
              type = 'description',
              order = 10,
              name = "\n|cff798BDDScrollable Frame Settings|r:",
              fontSize = 'large',
            },
            enableScrollable = {
              order = 11,
              type = 'toggle',
              name = "Enabled",
              get = get2,
              set = set2_update,
              disabled = isFrameItemDisabled,
            },
            scrollableLines = {
              order = 12,
              name = "Number of Lines",
              type = 'range',
              min = 10, max = 60, step = 1,
              get = get2,
              set = set2_update,
              disabled = isFrameNotScrollable,
            },

            frameFading = {
              type = 'description',
              order = 30,
              name = "\n|cff798BDDFading Text Settings|r:",
              fontSize = 'large',
            },
            enableCustomFade = {
              order = 31,
              type = 'toggle',
              name = "Use Custom Fade (See |cffFF0000Warning|r)",
              desc = "|cffFF0000WARNING:|r Blizzard has a bug where you may see \"floating\" icons when you change the |cffFFFF00Fading Text|r. It is highly recommended that you also enable |cffFFFF00Clear Frames When Leaving Combat|r on the main options page.",
              width = 'full',
              get = get2,
              set = set2_update,
              disabled = isFrameItemDisabled,
            },
            enableFade = {
              order = 32,
              type = 'toggle',
              name = "Enable",
              desc = "Turn off to disable fading all together.\n\n|cffFF0000Requires:|r |cffFFFF00Use Custom Fade|r",
              width = 'half',
              get = get2,
              set = set2_update,
              disabled = isFrameUseCustomFade,
            },
            fadeTime = {
              order = 33,
              name = "Fade Out Duration",
              desc = "The duration of the fade out animation. |cffFFFF00(Default: |cff798BDD0.3|r)|r\n\n|cffFF0000Requires:|r |cffFFFF00Use Custom Fade|r",
              type = 'range',
              min = 0, max = 2, step = .1,
              get = get2,
              set = set2_update,
              disabled = isFrameFadingDisabled,
            },
            visibilityTime = {
              order = 34,
              name = "Visibility Duration",
              desc = "The duration that the text is shown in the frame. |cffFFFF00(Default: |cff798BDD5|r)|r\n\n|cffFF0000Requires:|r |cffFFFF00Use Custom Fade|r",
              type = 'range',
              min = 2, max = 15, step = 1,
              get = get2,
              set = set2_update,
              disabled = isFrameFadingDisabled,
            },

          },
        },

        fonts = {
          order = 20,
          type = 'group',
          name = "Font Settings",
          args = {
            fontSettings = {
              type = 'description',
              order = 0,
              name = "|cff798BDDFont Settings|r:",
              fontSize = 'large',
            },
            font = {
              type = 'select', dialogControl = 'LSM30_Font',
              order = 1,
              name = "Font",
              desc = "Set the font of the frame.",
              values = AceGUIWidgetLSMlists.font,
              get = get2,
              set = set2_update,
              disabled = isFrameItemDisabled,
            },
            fontSize = {
              order = 2,
              name = "Font Size",
              desc = "Set the font size of the frame.",
              type = 'range',
              min = 6, max = 32, step = 1,
              get = get2,
              set = set2_update,
              disabled = isFrameItemDisabled,
            },
            fontOutline = {
              type = 'select',
              order = 3,
              name = "Font Outline",
              desc = "Set the font outline.",
              values = {
                ['1NONE'] = "None",
                ['2OUTLINE'] = 'OUTLINE',
                -- BUG: Setting font to monochrome AND above size 16 will crash WoW
                -- http://us.battle.net/wow/en/forum/topic/6470967362
                --['3MONOCHROME'] = 'MONOCHROME',
                ['4MONOCHROMEOUTLINE'] = 'MONOCHROMEOUTLINE',
                ['5THICKOUTLINE'] = 'THICKOUTLINE',
              },
              get = get2,
              set = set2_update,
              disabled = isFrameItemDisabled,
            },
            fontJustify = {
              type = 'select',
              order = 4,
              name = "Justification",
              desc = "Justifies the output to a side.",
              values = {
                ['RIGHT']  = "Right",
                ['LEFT']   = "Left",
                ['CENTER'] = "Center",
              },
              get = get2,
              set = set2_update,
            },

            iconSizeSettings = {
              type = 'description',
              order = 10,
              name = "\n|cff798BDDIcon Size Settings|r:",
              fontSize = 'large',
            },
            iconsEnabled = {
              order = 11,
              type = 'toggle',
              name = "Icons",
              desc = "Show icons next to your damage.",
              get = get2,
              set = set2,
              disabled = isFrameItemDisabled,
            },
            iconsSize = {
              order = 12,
              name = "Icon Size",
              desc = "Set the icon size.",
              type = 'range',
              min = 6, max = 22, step = 1,
              get = get2,
              set = set2,
              disabled = isFrameIconDisabled,
            },
          },
        },

        specialTweaks = {
          order = 40,
          type = 'group',
          name = "Special Tweaks",
          args = {
            specialTweaks = {
              type = 'description',
              order = 0,
              name = "|cff798BDDSpecial Tweaks|r:",
              fontSize = 'large',
            },
            showMoney = {
              order = 1,
              type = 'toggle',
              name = "Looted Money",
              desc = "Displays money that you pick up.",
              get = get2,
              set = set2,
            },
            showItems = {
              order = 2,
              type = 'toggle',
              name = "Looted Items",
              desc = "Displays items that you pick up.",
              get = get2,
              set = set2,
            },
            showItemTypes = {
              order = 3,
              type = 'toggle',
              name = "Show Item Types",
              desc = "Formats the looted message to also include the type of item (e.g. Trade Goods, Armor, Junk, etc.).",
              get = get2,
              set = set2,
            },
            showItemTotal = {
              order = 4,
              type = 'toggle',
              name = "Total Items",
              desc = "Displays how many items you have in your bag.",
              get = get2,
              set = set2,
            },
            showCrafted = {
              order = 5,
              type = 'toggle',
              name = "Crafted Items",
              desc = "Displays items that you crafted.",
              get = get2,
              set = set2,
            },
            showQuest = {
              order = 6,
              type = 'toggle',
              name = "Quest Items",
              desc = "Displays items that pertain to a quest.",
              get = get2,
              set = set2,
            },
            colorBlindMoney = {
              order = 7,
              type = 'toggle',
              name = "Color Blind Mode",
              desc = "Displays money using letters G, S, and C instead of icons.",
              get = get2,
              set = set2,
            },
            filterItemQuality = {
              order = 8,
              type = 'select',
              name = "Filter Item Quality",
              desc = "Will not display any items that are below this quality (does not filter Quest or Crafted items).",
              values = {
                [0] = '1. |cff9d9d9d'..ITEM_QUALITY0_DESC..'|r',   -- Poor
                [1] = '2. |cffffffff'..ITEM_QUALITY1_DESC..'|r',   -- Common
                [2] = '3. |cff1eff00'..ITEM_QUALITY2_DESC..'|r',   -- Uncommon
                [3] = '4. |cff0070dd'..ITEM_QUALITY3_DESC..'|r',   -- Rare
                [4] = '5. |cffa335ee'..ITEM_QUALITY4_DESC..'|r',   -- Epic
                [5] = '6. |cffff8000'..ITEM_QUALITY5_DESC..'|r',   -- Legendary
                [6] = '7. |cffe6cc80'..ITEM_QUALITY6_DESC..'|r',   -- Artifact
                [7] = '8. |cffe6cc80'..ITEM_QUALITY7_DESC..'|r',   -- Heirloom
              },
              get = get2,
              set = set2,
            },
          },
        },

      },
    },
  },
}
