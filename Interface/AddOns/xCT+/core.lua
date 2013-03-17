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

-- Get Addon's name and Blizzard's Addon Stub
local AddonName, addon = ...

local sgsub, ipairs, pairs, type, string_format, table_insert, print, tostring, tonumber, select, string_lower, collectgarbage, string_match =
  string.gsub, ipairs, pairs, type, string.format, table.insert, print, tostring, tonumber, select, string.lower, collectgarbage, string.match

-- Local Handle to the Engine
local x = addon.engine

-- Handle Addon Initialized
function x:OnInitialize()
  if xCT or ct and ct.myname and ct.myclass then
    print("|cffFF0000WARNING:|r xCT+ cannot load. Please disable xCT in order to use xCT+.")
    return
  end

  -- Load the Data Base
  self.db = LibStub('AceDB-3.0'):New('xCTSavedDB')
  self.db:RegisterDefaults(addon.defaults)
  self.db.RegisterCallback(self, 'OnProfileChanged', 'RefreshConfig')
  self.db.RegisterCallback(self, 'OnProfileCopied', 'RefreshConfig')
  self.db.RegisterCallback(self, 'OnProfileReset', 'RefreshConfig')
  self.db:GetCurrentProfile()
  
  -- Add the profile options to my dialog config
  addon.options.args['Profiles'] = LibStub('AceDBOptions-3.0'):GetOptionsTable(self.db)
  
  -- Perform xCT+ Update
  x:UpdatePlayer()
  
  -- Delay updating frames until all other addons are loaded!
  --x:UpdateFrames()
  
  x:UpdateCombatTextEvents(true)
  x:UpdateSpamSpells()
  x:UpdateItemTypes()
  x:UpdateAuraSpellFilter()
  
  -- Update combat text engine CVars
  x.cvar_udpate()
  
  -- Everything got Initialized, show Startup Text
  if self.db.profile.showStartupText then
    print("Loaded |cffFF0000x|r|cffFFFF00CT|r|cffFF0000+|r. To configure, type: |cffFF0000/xct|r")
  end
end

-- Need to create a handle to update frames when every other addon is done.
local frameUpdate = CreateFrame("FRAME")
frameUpdate:RegisterEvent("PLAYER_ENTERING_WORLD")
frameUpdate:SetScript("OnEvent", function(self)
  self:UnregisterEvent("PLAYER_ENTERING_WORLD")
  x:UpdateFrames()
end)

-- Profile Updated, need to refresh important stuff 
function x:RefreshConfig()
  x:UpdateFrames()
  x:UpdateSpamSpells()
  x:UpdateItemTypes()
  collectgarbage()
end

-- Spammy Spell Get/Set Functions
local function SpamSpellGet(info) return x.db.profile.spells.merge[tonumber(info[#info])].enabled end
local function SpamSpellSet(info, value) x.db.profile.spells.merge[tonumber(info[#info])].enabled = value end

-- Gets spammy spells from the database and creates options
function x:UpdateSpamSpells()
  for id, item in pairs(addon.merges) do
    if item.class == x.player.class then
      if not self.db.profile.spells.merge[id] then
        self.db.profile.spells.merge[id] = item
        self.db.profile.spells.merge[id]['enabled'] = true    -- default all to on
      else
      -- update merge setting incase they are outdated
        self.db.profile.spells.merge[id].interval = item.interval
        self.db.profile.spells.merge[id].prep = item.prep
      end
    end
  end

  local spells = addon.options.args.spells.args.spellList.args
  for spellID, entry in pairs(self.db.profile.spells.merge) do
    if entry.class == x.player.class then
      local name = GetSpellInfo(spellID)
      if name then
        local desc = "|cffFF0000ID|r |cff798BDD" .. spellID .. "|r\n"
      
        if entry.interval <= 0.5 then
          desc = desc .. "|cffFF0000Interval|r Instant" 
        else
          desc = desc .. "|cffFF0000Interval|r Merge every |cffFFFF00" .. tostring(entry.interval) .. "|r seconds"
        end
      
        spells[tostring(spellID)] = {
          order = 3,
          type = 'toggle',
          name = name,
          desc = desc,
          get = SpamSpellGet,
          set = SpamSpellSet,
        }
      end
    end
  end
end

local function ItemToggleAll(info)
  local state = (info[#info] == "disableAll")
  for key in pairs(x.db.profile.spells.items[info[#info-1]]) do
    x.db.profile.spells.items[info[#info-1]][key] = state
  end
end

local function getIF_1(info) return x.db.profile.spells.items[info[#info - 1]][info[#info]] end
local function setIF_1(info, value) x.db.profile.spells.items[info[#info - 1]][info[#info]] = value end
local function getIF_2(info) return x.db.profile.spells.items[info[#info - 1]][info[#info - 1]] end
local function setIF_2(info, value) x.db.profile.spells.items[info[#info - 1]][info[#info - 1]] = value end

-- Updates item filter list
function x:UpdateItemTypes()
  -- check to see if this is the first time we are loading this version
  local first = false
  if not self.db.profile.spells.items.version then
    self.db.profile.spells.items.version = 1
    first = true
  end

  local itemTypes = { GetAuctionItemClasses() }
  
  local allTypes = {
    order = 100,
    name = "|cffFFFFFFFilter:|r |cff798BDDLoot|r",
    type = 'group',
    childGroups = "select",
    args = {
      secondaryFrame = {
          type = 'description',
          order = 0,
          name = "These options allow you to bypass the loot item filter and always show a item from any category, reguardless of the quality.\n",
        },
    },
  }
  
  for i, itype in ipairs(itemTypes) do
    local subtypes = { GetAuctionItemSubClasses(i) }
    
    if self.db.profile.spells.items[itype] == nil then
      self.db.profile.spells.items[itype] = { }
    end
    
    -- Page for the MAIN ITEM GROUP
    local group = {
      order = i,
      name = itype,
      type = 'group',
      args = { },
    }

    -- the footer for the current MAIN ITEM GROUP
    if #subtypes > 0 then
      -- Separator for the TOP toggle switches, and the BOTTOM enable/disable buttons
      group.args['enableHeader'] = {
        order = 100,
        type = 'header',
        name = "",
        width = "full",
      }
      
      -- Button to DISABLE all
      group.args['disableAll'] = {
        order = 101,
        type = 'execute',
        name = "|cffDDDD00Enable All|r",
        --width = "half",
        func = ItemToggleAll,
      }
      
      -- Button to ENABLE all
      group.args['enableAll'] = {
        order = 102,
        type = 'execute',
        name = "|cffDD0000Disable All|r",
        --width = "half",
        func = ItemToggleAll,
      }
    else
      -- Quest Items... maybe others
      if first or self.db.profile.spells.items[itype][itype] == nil then
        self.db.profile.spells.items[itype][itype] = false
      end
      
      group.args[itype] = {
        order = 1,
        type = 'toggle',
        name = "Enable",
        get = getIF_2,
        set = setIF_2,
      }
    end

    -- add all the SUBITEMS
    for j, subtype in ipairs(subtypes) do
      if first or self.db.profile.spells.items[itype][subtype] == nil then
        self.db.profile.spells.items[itype][subtype] = false
      end
    
      group.args[subtype] = {
        order = j,
        type = 'toggle',
        name = subtype,
        get = getIF_1, --function(info) return self.db.profile.spells.items[itype][subtype] end,
        set = setIF_1, --function(info, value) self.db.profile.spells.items[itype][subtype] = value end,
      }
    end
    
    allTypes.args[itype] = group
  end

  addon.options.args["spellFilter"].args["typeFilter"] = allTypes
end

local function getCP_1(info) return x.db.profile.spells.combo[x.player.class][info[#info]] end
local function setCP_1(info, value) x.db.profile.spells.combo[x.player.class][info[#info]] = value end

local function getCP_2(info)
  local spec, index = string_match(info[#info], "(%d+),(.+)")
  local value = x.db.profile.spells.combo[x.player.class][tonumber(spec)][tonumber(index) or index]
  if type(value) == "table" then
    return value.enabled
  else
    return value
  end
end
local function setCP_2(info, value)
  local spec, index = string_match(info[#info], "(%d+),(.+)")
  
  if value == true then
    for key, entry in pairs(x.db.profile.spells.combo[x.player.class][tonumber(spec)]) do
      if type(entry) == "table" then
        entry.enabled = false
      else
        x.db.profile.spells.combo[x.player.class][tonumber(spec)][key] = false
      end
    end
  end
  
  if tonumber(index) then   -- it is a spell ID
    x.db.profile.spells.combo[x.player.class][tonumber(spec)][tonumber(index)].enabled = value
  else                      -- it is a unit's power
    x.db.profile.spells.combo[x.player.class][tonumber(spec)][index] = value
  end
  
  -- Update tracker
  x:UpdateComboTracker()
end

-- Update the combo point list
function x:UpdateComboPointOptions(force)
  if x.LOADED_COMBO_POINTS_OPTIONS and not force then return end
  local myClass, offset = x.player.class, 1
  
  local comboSpells = {
    order = 100,
    name = "Tracking Spells |cffFFFFFF(Choose one per specialization)|r",
    type = 'group',
    guiInline = true,
    args = { },
  }

  -- Add "All Specializations" Entries
  for name in pairs(x.db.profile.spells.combo[myClass]) do
    if not tonumber(name) then
      if not comboSpells.args['allSpecsHeader'] then
        comboSpells.args['allSpecsHeader'] = {
          order = 0,
          type = 'header',
          name = "All Specializations",
          width = "full",
        }
      end
      comboSpells.args[name] = {
        order = offset,
        type = 'toggle',
        name = name,
        get = getCP_1,
        set = setCP_1,
      }
      offset = offset + 1
    end
  end
  
  -- Add the each spec
  for spec in ipairs(x.db.profile.spells.combo[myClass]) do
    local haveSpec = false
    for index, entry in pairs(x.db.profile.spells.combo[myClass][spec] or { }) do
      if not haveSpec then
        haveSpec = true
        local mySpecName = select(2, GetSpecializationInfo(spec)) or "Tree " .. spec
        
        comboSpells.args["title" .. tostring(spec)] = {
            order = offset,
            type = 'header',
            name = "Specialization: |cff798BDD" .. mySpecName .. "|r",
            width = "full",
          }
        offset = offset + 1
      end
    
      if tonumber(index) then
        -- Class Combo Points ( UNIT_AURA Tracking)
        comboSpells.args[tostring(spec) .. "," .. tostring(index)] = {
          order = offset,
          type = 'toggle',
          name = GetSpellInfo(entry.id),
          desc = "Unit to track: |cffFF0000" .. entry.unit .. "|r\nSpell ID: |cffFF0000" .. entry.id .. "|r",
          get = getCP_2,
          set = setCP_2,
        }
      else
        -- Special Combo Point ( Unit Power )
        comboSpells.args[tostring(spec) .. "," .. tostring(index)] = {
          order = offset,
          type = 'toggle',
          name = index,
          desc = "Unit Power",
          get = getCP_2,
          set = setCP_2,
        }
      end
      
      offset = offset + 1
    end
  end
  
  addon.options.args["Frames"].args["class"].args["tracker"] = comboSpells
  
  x.LOADED_COMBO_POINTS_OPTIONS = true
  
  x:UpdateComboTracker()
end

function x:UpdateComboTracker()
  local myClass, mySpec = x.player.class, x.player.spec
  x.TrackingEntry = nil
  
  if not mySpec or mySpec < 1 then return end  -- under Level 10 probably or not spec'd, I don't know what to do :P

  for i, entry in pairs(x.db.profile.spells.combo[myClass][mySpec]) do
    if type(entry) == "table" and entry.enabled then
      x.TrackingEntry = entry
    end
  end
  
  x:QuickClassFrameUpdate()
end

-- Get and set methods for the spell filter
local function getSF(info) return x.db.profile.spellFilter[info[#info-2]][info[#info]] end
local function setSF(info, value) x.db.profile.spellFilter[info[#info-2]][info[#info]] = value end

-- Update the Buff, Debuff and Spell filter list
function x:UpdateAuraSpellFilter(specific)
  local i = 10
  
  if not specific or specific == "buffs" then
    -- Redo all the list
    addon.options.args.spellFilter.args.listBuffs.args.list = {
      name = "Filtered Buffs |cff798BDD(Uncheck to Disable)|r",
      type = 'group',
      guiInline = true,
      order = 11,
      args = { },
    }
  
    local buffs = addon.options.args.spellFilter.args.listBuffs.args.list.args
    local updated = false
    
    -- Update buffs
    for name in pairs(x.db.profile.spellFilter.listBuffs) do
      updated = true
      buffs[name] = {
        order = i,
        name = name,
        type = 'toggle',
        get = getSF,
        set = setSF,
      }
    end
    
    if not updated then
      buffs["noSpells"] = {
        order = 1,
        name = "No items have been added to this list yet.",
        type = 'description',
      }
    end
  end
  
  i = 10
  
  -- Update debuffs
  if not specific or specific == "debuffs" then
    addon.options.args.spellFilter.args.listDebuffs.args.list = {
      name = "Filtered Debuffs |cff798BDD(Uncheck to Disable)|r",
      type = 'group',
      guiInline = true,
      order = 11,
      args = { },
    }
  
    local debuffs = addon.options.args.spellFilter.args.listDebuffs.args.list.args
    local updated = false
    
    for name in pairs(x.db.profile.spellFilter.listDebuffs) do
      updated = true
      debuffs[name] = {
        order = i,
        name = name,
        type = 'toggle',
        get = getSF,
        set = setSF,
      }
    end
    
    if not updated then
      debuffs["noSpells"] = {
        order = 1,
        name = "No items have been added to this list yet.",
        type = 'description',
      }
    end
  end
  
  i = 10
  
  -- Update spells
  if not specific or specific == "spells" then
    addon.options.args.spellFilter.args.listSpells.args.list = {
      name = "Filtered Spells |cff798BDD(Uncheck to Disable)|r",
      type = 'group',
      guiInline = true,
      order = 11,
      args = { },
    }
  
    local spells = addon.options.args.spellFilter.args.listSpells.args.list.args
    local updated = false
    
    for id in pairs(x.db.profile.spellFilter.listSpells) do
      local spellID = tonumber(string_match(id, "%d+"))
    
      updated = true
      spells[id] = {
        order = i,
        name = GetSpellInfo(spellID),
        desc = "|cffFF0000ID|r |cff798BDD" .. id .. "|r\n",
        type = 'toggle',
        get = getSF,
        set = setSF,
      }
    end
    
    if not updated then
      spells["noSpells"] = {
        order = 1,
        name = "No items have been added to this list yet.",
        type = 'description',
      }
    end
  end
  
end

-- Add and remove Buffs, debuffs, and spells from the filter
function x:AddFilteredSpell(category, name)
  if category == "listBuffs" then
    x.db.profile.spellFilter.listBuffs[name] = true
    x:UpdateAuraSpellFilter("buffs")
  elseif category == "listDebuffs" then
    x.db.profile.spellFilter.listDebuffs[name] = true
    x:UpdateAuraSpellFilter("debuffs")
  elseif category == "listSpells" then
    local spellID = tonumber(string_match(name, "%d+"))
    if spellID and GetSpellInfo(spellID) then
      x.db.profile.spellFilter.listSpells[name] = true
      x:UpdateAuraSpellFilter("spells")
    else
      print("|cffFF0000x|r|cffFFFF00CT+|r  Could not add invalid Spell ID: |cff798BDD" .. name .. "|r")
    end
  else
    print("|cffFF0000x|r|cffFFFF00CT+|r  |cffFF0000Error:|r Unknown filter type '" .. category .. "'!")
  end
end

function x:RemoveFilteredSpell(category, name)
  if category == "listBuffs" then
    x.db.profile.spellFilter.listBuffs[name] = nil
    x:UpdateAuraSpellFilter("buffs")
  elseif category == "listDebuffs" then
    x.db.profile.spellFilter.listDebuffs[name] = nil
    x:UpdateAuraSpellFilter("debuffs")
  elseif category == "listSpells" then
    local spellID = tonumber(string_match(name, "%d+"))
    if spellID and GetSpellInfo(spellID) then
      x.db.profile.spellFilter.listSpells[name] = nil
      x:UpdateAuraSpellFilter("spells")
    else
      print("|cffFF0000x|r|cffFFFF00CT+|r  Could not remove invalid Spell ID: |cff798BDD" .. name .. "|r")
    end
    x:UpdateAuraSpellFilter("spells")
  else
    print("|cffFF0000x|r|cffFFFF00CT+|r  |cffFF0000Error:|r Unknown filter type '" .. category .. "'!")
  end
end

-- Unused for now
function x:OnEnable() end
function x:OnDisable() end

-- This allows us to create our config dialog
local AC = LibStub('AceConfig-3.0')
local ACD = LibStub('AceConfigDialog-3.0')
local ACR = LibStub('AceConfigRegistry-3.0')

-- Register the Options
ACD:SetDefaultSize(AddonName, 800, 550)
AC:RegisterOptionsTable(AddonName, addon.options)
AC:RegisterOptionsTable(AddonName.."Blizzard", x.blizzardOptions)
ACD:AddToBlizOptions(AddonName.."Blizzard", "|cffFF0000x|rCT+")

-- Register Slash Commands
x:RegisterChatCommand('xct', 'OpenxCTCommand')

-- Process the slash command ('input' contains whatever follows the slash command)
function x:OpenxCTCommand(input)
  if string_match(string_lower(input), 'lock') then
    if x.configuring then
      x:SaveAllFrames()
      x.EndConfigMode()
      print("|cffFF0000x|r|cffFFFF00CT+|r  Frames have been saved. Please fasten your seat belts.")
    else
      x.ToggleConfigMode()
      
      print("|cffFF0000x|r|cffFFFF00CT+|r  You are now free to move about the cabin.")
      print("      |cffFF0000/xct lock|r      - Saves your frames")
      print("      |cffFF0000/xct cancel|r  - Cancels all your recent frame movements")
    end
    
    -- return before you can do anything else
    return
  end
  
  if string_match(string_lower(input),'cancel') then
    if x.configuring then
      x:UpdateFrames();
      x.EndConfigMode()
      print("|cffFF0000x|r|cffFFFF00CT+|r  canceled frame move.")
    else
      print("|cffFF0000x|r|cffFFFF00CT+|r  There is nothing to cancel.")
    end
    return
  end
  
  if string_lower(input) == 'help' then
    print("|cffFF0000x|r|cffFFFF00CT+|r  Commands:")
    print("      |cffFF0000/xct lock|r - Locks and unlocks the frame movers.")
    return
  end
  
  if string_match(string_lower(input), 'track %w+') then
    local unit = string_match(string_lower(input), '%s(%w+)')
    
    local name = UnitName(unit)
    
    if not name then
      x.player.unit = ""
    else
      x.player.unit = "custom"
      CombatTextSetActiveUnit(unit)
    end
    
    x:UpdatePlayer()
    print("|cffFF0000x|r|cffFFFF00CT+|r Tracking Unit:", name or "default")
    
    return
  end
  
  -- Open/Close the config menu
  local mode = 'Close'
  if not ACD.OpenFrames[AddonName] then
    mode = 'Open'
  end
  
  if not x.configuring then
    ACD[mode](ACD, AddonName)
  end
end

-- Register Slash Commands
x:RegisterChatCommand('track', 'TrackxCTCommand')
function x:TrackxCTCommand(input)
  local name = UnitName("target")
    
  if not name then
    x.player.unit = ""
  else
    x.player.unit = "custom"
    CombatTextSetActiveUnit("target")
  end
  
  x:UpdatePlayer()
  print("|cffFF0000x|r|cffFFFF00CT+|r Tracking Unit:", name or "default")
end
