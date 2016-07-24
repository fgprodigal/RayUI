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
 [  ©2016. All Rights Reserved.        ]
 [====================================]]

-- Dont do anything for Legion
local build = select(4, GetBuildInfo())


-- Get Addon's name and Blizzard's Addon Stub
local AddonName, addon = ...

local sgsub, ipairs, pairs, type, string_format, table_insert, table_remove, table_sort, print, tostring, tonumber, select, string_lower, collectgarbage, string_match, string_find =
  string.gsub, ipairs, pairs, type, string.format, table.insert, table.remove, table.sort, print, tostring, tonumber, select, string.lower, collectgarbage, string.match, string.find

-- compares a tables values
local function tableCompare(t1, t2)
  local equal = true

  -- nil check
  if not t1 or not t2 then
    if not t1 and not t2 then
      return true
    else
      return false
    end
  end

  for i,v in pairs(t1) do
    if t2[i] ~= v then
      equal = false
      break;
    end
  end
  return equal
end

-- Local Handle to the Engine
local x = addon.engine

-- Profile Updated, need to refresh important stuff
local function RefreshConfig()
  -- Clean up the Profile
  x:CompatibilityLogic(true)

  x:UpdateFrames()
  x:UpdateSpamSpells()
  x:UpdateItemTypes()

  -- Update combat text engine CVars
  x.cvar_update( true )

  collectgarbage()
end

local function ProfileReset()
  -- Clean up the Profile
  x:CompatibilityLogic(false)

  x:UpdateFrames()
  x:UpdateSpamSpells()
  x:UpdateItemTypes()

  collectgarbage()
end

-- Handle Addon Initialized
function x:OnInitialize()
  if xCT or ct and ct.myname and ct.myclass then
    print("|cffFF0000WARNING:|r xCT+ cannot load. Please disable xCT in order to use xCT+.")
    return
  end

  -- Check for new installs
  self.existingProfile = xCTSavedDB and xCTSavedDB.profiles and xCTSavedDB.profiles[UnitName("player").." - "..GetRealmName()] and true

  -- Load the Data Base
  self.db = LibStub('AceDB-3.0'):New('xCTSavedDB', addon.defaults)

  -- Add the profile options to my dialog config
  addon.options.args['Profiles'] = LibStub('AceDBOptions-3.0'):GetOptionsTable(self.db)

  -- Had to pass the explicit method into here, not sure why
  self.db.RegisterCallback(self, 'OnProfileChanged', RefreshConfig)
  self.db.RegisterCallback(self, 'OnProfileCopied', RefreshConfig)
  self.db.RegisterCallback(self, 'OnProfileReset', ProfileReset)

  -- Clean up the Profile
  x:CompatibilityLogic(self.existingProfile)

  -- Perform xCT+ Update
  x:UpdatePlayer()

  -- Delay updating frames until all other addons are loaded!
  --x:UpdateFrames()
  if build < 70000 then
    x:UpdateBlizzardFCT()
  end

  x:UpdateCombatTextEvents(true)
  x:UpdateSpamSpells()
  x:UpdateItemTypes()
  x:UpdateAuraSpellFilter()
  x.GenerateColorOptions()

  -- Update combat text engine CVars
  x.cvar_update()

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

-- Version Compare Helpers... Yeah!
local function VersionToTable( version )
  local major, minor, iteration, releaseMsg = string_match(string_lower(version), "(%d+)%.(%d+)%.(%d+)(.*)")
  major, minor, iteration = tonumber(major) or 0, tonumber(minor) or 0, tonumber(iteration) or 0
  local isAlpha, isBeta =  string_find(releaseMsg, "alpha") and true or false, string_find(releaseMsg, "beta") and true or false
  local t = { }
  t.major = major
  t.minor = minor
  t.iteration = iteration
  t.isAlpha = isAlpha
  t.isBeta = isBeta
  t.isRelease = not (isAlpha or isBeta)

  if not t.isReleased then
    t.devBuild = tonumber(string_match(releaseMsg, "(%d+)")) or 1
  end
  return t
end

local function CompareVersions( a, b )

  -- Compare Major numbers
  if a.major > b.major then
    return 1
  elseif a.major < b.major then
    return -1
  end

  -- Compare Minor numbers
  if a.minor > b.minor then
    return 1
  elseif a.minor < b.minor then
    return -1
  end

  -- Compare Iteration numbers
  if a.iteration > b.iteration then
    return 1
  elseif a.iteration < b.iteration then
    return -1
  end

  -- Compare Beta to Release then Alpha
  if not a.isBeta and b.isBeta then
    if a.isAlpha then
      return -1
    else
      return 1
    end
  elseif a.isBeta and not b.isBeta then
    if b.isAlpha then
      return 1
    else
      return -1
    end
  end

  -- Compare Beta Build Versions
  if a.isBeta and b.isBeta then
    if a.devBuild > b.devBuild then
      return 1
    elseif a.devBuild < b.devBuild then
      return -1
    end
    return 0
  end

  -- Compare Alpha to Release
  if not a.isAlpha and b.isAlpha then
    return 1
  elseif a.isAlpha and not b.isAlpha then
    return -1
  end

  -- Compare Alpha Build Versions
  if a.isAlpha and b.isAlpha then
    if a.devBuild > b.devBuild then
      return 1
    elseif a.devBuild < b.devBuild then
      return -1
    end
    return 0
  end

  return 0
end

-- This function was created as the central location for crappy code
function x:CompatibilityLogic( existing )
    local addonVersionString = GetAddOnMetadata("xCT+", "Version")
    local currentVersion = VersionToTable(addonVersionString)
    local previousVersion = VersionToTable(self.db.profile.dbVersion or "0.0.0")

    -- MegaDamage Change (version 3.3.0)
    if self.db.profile.megaDamage.enableMegaDamage == false then
      self.db.profile.megaDamage.enableMegaDamage = nil
    elseif self.db.profile.megaDamage.enableMegaDamage == true then
      self.db.profile.megaDamage.enableMegaDamage = nil
      self.db.profile.frames.general.megaDamage = true
      self.db.profile.frames.outgoing.megaDamage = true
      self.db.profile.frames.critical.megaDamage = true
      self.db.profile.frames.damage.megaDamage = true
      self.db.profile.frames.healing.megaDamage = true
      self.db.profile.frames.power.megaDamage = true
    end

    -- Updating Spam Merger for 4.0.0 Beta 4 (Requires a reset)
    if CompareVersions( VersionToTable("4.0.0"), previousVersion) > 0
      or CompareVersions( VersionToTable("4.2.3"), previousVersion) > 0 then

      -- Reset merge table
      self.db.profile.spells.merge = {}

      -- Fix Combo Points
      self.db.profile.spells.combo = addon.defaults.profile.spells.combo

      -- Tell the user... i am sooo sorry
      if existing and not x.db.global.dontShowDBCleaning then
        StaticPopup_Show("XCT_PLUS_DB_CLEANUP_1")
      end
    end

    self.db.profile.dbVersion = addonVersionString
end


local getSpellDescription
do
	local Descriptions, description = { }, nil
	local tooltip = CreateFrame('GameTooltip')
	tooltip:SetOwner(WorldFrame, "ANCHOR_NONE")

	-- Add FontStrings to the tooltip
	local LeftStrings, temporaryRight = {}, nil
	for i = 1, 5 do
		LeftStrings[i] = tooltip:CreateFontString()
		temporaryRight = tooltip:CreateFontString()
		LeftStrings[i]:SetFontObject(GameFontNormal)
		temporaryRight:SetFontObject(GameFontNormal)
		tooltip:AddFontStrings(LeftStrings[i], temporaryRight)
	end

	function getSpellDescription(spellID)
		if Descriptions[spellID] then
			return Descriptions[spellID]
		end

		tooltip:SetSpellByID(spellID)

		description = ""
		if LeftStrings[tooltip:NumLines()] then
			description = LeftStrings[ tooltip:NumLines() ]:GetText()
		end

		if description == "" then
			description = "No Description"
		end

		Descriptions[spellID] = description
		return description
	end
end

-- Spammy Spell Get/Set Functions
local function SpamSpellGet(info) return x.db.profile.spells.merge[tonumber(info[#info])].enabled end
local function SpamSpellSet(info, value) x.db.profile.spells.merge[tonumber(info[#info])].enabled = value end

local CLASS_NAMES = {
  ["DEATHKNIGHT"] = {
    [0]   = 0,   -- All Specs
    [250] = 1,   -- Blood
    [251] = 2,   -- Frost
    [252] = 3,   -- Unholy
  },
  ["DEMONHUNTER"] = {
    [0]   = 0,   -- All Specs
    [577] = 1,   -- Havoc
    [581] = 2,   -- Vengeance
  },
  ["DRUID"] = {
    [0]   = 0,   -- All Specs
    [102] = 1,   -- Balance
    [103] = 2,   -- Feral
    [104] = 3,   -- Guardian
    [105] = 4,   -- Restoration
  },
  ["HUNTER"] = {
    [0]   = 0,   -- All Specs
    [253] = 1,   -- Beast Mastery
    [254] = 2,   -- Marksmanship
    [255] = 3,   -- Survival
  },
  ["MAGE"] = {
    [0]  = 0,    -- All Specs
    [62] = 1,    -- Arcane
    [63] = 2,    -- Fire
    [64] = 3,    -- Frost
  },
  ["MONK"] = {
    [0]   = 0,   -- All Specs
    [268] = 1,   -- Brewmaster
    [269] = 2,   -- Windwalker
    [270] = 3,   -- Mistweaver
  },
  ["PALADIN"] = {
    [0]  = 0,    -- All Specs
    [65] = 1,    -- Holy
    [66] = 2,    -- Protection
    [70] = 3,    -- Retribution
  },
  ["PRIEST"] = {
    [0]   = 0,   -- All Specs
    [256] = 1,   -- Discipline
    [257] = 2,   -- Holy
    [258] = 3,   -- Shadow
  },
  ["ROGUE"] = {
    [0]   = 0,   -- All Specs
    [259] = 1,   -- Assassination
    [260] = 2,   -- Combat
    [261] = 3,   -- Subtlety
  },
  ["SHAMAN"] = {
    [0]   = 0,   -- All Specs
    [262] = 1,   -- Elemental
    [263] = 2,   -- Enhancement
    [264] = 3,   -- Restoration
  },
  ["WARLOCK"] = {
    [0]   = 0,   -- All Specs
    [265] = 1,   -- Affliction
    [266] = 2,   -- Demonology
    [267] = 3,   -- Destruction
  },
  ["WARRIOR"] = {
    [0]  = 0,    -- All Specs
    [71] = 1,    -- Arms
    [72] = 2,    -- Fury
    [73] = 3,    -- Protection
  },
}

-- Gets spammy spells from the database and creates options
function x:UpdateSpamSpells()
  -- Update our saved DB
  for id, item in pairs(addon.merges) do
    if not self.db.profile.spells.merge[id] then
      self.db.profile.spells.merge[id] = item
      self.db.profile.spells.merge[id]['enabled'] = true    -- default all to on
    else
    -- update merge setting incase they are outdated
      self.db.profile.spells.merge[id].interval = item.interval
      self.db.profile.spells.merge[id].prep = item.prep
      self.db.profile.spells.merge[id].desc = item.desc
      self.db.profile.spells.merge[id].class = item.class
    end
  end

  local spells = addon.options.args.spells.args.classList.args
  local global = addon.options.args.spells.args.globalList.args

  -- Clear out the old spells
  for class, specs in pairs(CLASS_NAMES) do
    spells[class].args = {}
    for spec, index in pairs(specs) do
      local name, _ = "All Specializations"
      if index ~= 0 then
        _, name = GetSpecializationInfoByID(spec)
      end
      spells[class].args["specHeader"..index] = {
        type = 'header',
        order = index * 2,
        name = name,
      }
    end
  end

  -- Clear out the old spells (global)
  for index in pairs(global) do
    global[index] = nil
  end

  -- Create a list of the categories (to be sorted)
  local categories = {}
  for _, entry in pairs(self.db.profile.spells.merge) do
    if not CLASS_NAMES[entry.class] then
      table.insert(categories, entry.class)
    end
  end

  -- Show Categories in alphabetical order
  table.sort(categories)

  -- Assume less than 1000 entries per category ;)
  local categoryOffsets = {}
  for i, category in pairs(categories) do
    local currentIndex = i * 1000

    -- Create the Category Header
    global[category] = {
      type = 'description',
      order = currentIndex,
      name = "\n"..category,
      fontSize = 'large',
    }
    categoryOffsets[category] = currentIndex + 1
  end

  -- Update the UI
  for spellID, entry in pairs(self.db.profile.spells.merge) do
    local name = GetSpellInfo(spellID)
    if name then

      -- Create a useful description for the spell
      local spellDesc = getSpellDescription(spellID) or "No Description"
      local desc = ""
      if entry.desc and not CLASS_NAMES[entry.class] then
        desc = "|cff9F3ED5" .. entry.desc .. "|r\n\n"
      end
      desc = desc .. spellDesc .. "\n\n|cffFF0000ID|r |cff798BDD" .. spellID .. "|r"
      if entry.interval <= 0.5 then
        desc = desc .. "\n|cffFF0000Interval|r Instant"
      else
        desc = desc .. "\n|cffFF0000Interval|r Merge every |cffFFFF00" .. tostring(entry.interval) .. "|r seconds"
      end

      -- Add the spell to the UI
      if CLASS_NAMES[entry.class] then
        local index = CLASS_NAMES[entry.class][tonumber(entry.desc) or 0]
        spells[entry.class].args[tostring(spellID)] = {
          order = index * 2 + 1,
          type = 'toggle',
          name = name,
          desc = desc,
          get = SpamSpellGet,
          set = SpamSpellSet,
        }
      else
        global[tostring(spellID)] = {
          order = categoryOffsets[entry.class],
          type = 'toggle',
          name = name,
          desc = desc,
          get = SpamSpellGet,
          set = SpamSpellSet,
        }
        categoryOffsets[entry.class] = categoryOffsets[entry.class] + 1
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

-- For Legion - Reimplement legacy GetAuctionItemClasses and GetAuctionItemSubClasses


-- TODO: Figure out how to list all items in Legion
--[[if build >= 70000 then


  function GetAuctionItemClasses()
    local list = {}
    for i, v in pairs(OPEN_FILTER_LIST) do
      if v.type == "category" then
        list[v.categoryIndex] = v.name
      end
    end
    return list
  end

  function GetAuctionItemSubClasses(index)
    local list, found = {}
    for i, v in pairs(OPEN_FILTER_LIST) do
      if v.type == "category" then
        if found then break end
        if v.categoryIndex == index then
          found = 1
        end
      elseif v.type == "subCategory" then
        if found then
          list[v.subCategoryIndex] = v.name
        end
      end
    end
    return list
  end
end]]

x.UpdateItemTypes = function(self)end


--[===[

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

]===]


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
  local myClass, offset = x.player.class, 2

  local comboSpells = {
    order = 100,
    name = "Special Tweaks",
    type = 'group',
    args = {
      specialTweaks = {
        type = 'description',
        order = 0,
        name = "|cff798BDDSpecial Tweaks|r:",
        fontSize = 'large',
      },
      specialTweaksDesc = {
        type = 'description',
        order = 1,
        name = "|cffFFFFFF(Choose one per specialization)|r\n",
        fontSize = 'small',
      },
    },
  }

  -- Add "All Specializations" Entries
  for name in pairs(x.db.profile.spells.combo[myClass]) do
    if not tonumber(name) then
      if not comboSpells.args['allSpecsHeader'] then
        comboSpells.args['allSpecsHeader'] = {
          order = 2,
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

  -- Update procs
  if not specific or specific == "procs" then
    addon.options.args.spellFilter.args.listProcs.args.list = {
      name = "Filtered Procs |cff798BDD(Uncheck to Disable)|r",
      type = 'group',
      guiInline = true,
      order = 11,
      args = { },
    }

    local procs = addon.options.args.spellFilter.args.listProcs.args.list.args
    local updated = false

    for name in pairs(x.db.profile.spellFilter.listProcs) do
      updated = true
      procs[name] = {
        order = i,
        name = name,
        type = 'toggle',
        get = getSF,
        set = setSF,
      }
    end

    if not updated then
      procs["noSpells"] = {
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

  i = 10

  -- Update spells
  if not specific or specific == "items" then
    addon.options.args.spellFilter.args.listItems.args.list = {
      name = "Filtered Items |cff798BDD(Uncheck to Disable)|r",
      type = 'group',
      guiInline = true,
      order = 11,
      args = { },
    }

    local spells = addon.options.args.spellFilter.args.listItems.args.list.args
    local updated = false

    for id in pairs(x.db.profile.spellFilter.listItems) do
      local spellID = tonumber(string_match(id, "%d+"))

	  local name, _, _, _, _, _, _, _, _, texture = GetItemInfo( spellID or id )

	  name = name or "Unknown Item"

      updated = true
      spells[id] = {
        order = i,
        name = string_format("|T%s:%d:%d:0:0:64:64:5:59:5:59|t %s", texture or x.BLANK_ICON, 16, 16, name),
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
function x.AddFilteredSpell(name, category)
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
  elseif category == "listProcs" then
    x.db.profile.spellFilter.listProcs[name] = true
    x:UpdateAuraSpellFilter("procs")
  elseif category == "listItems" then
    x.db.profile.spellFilter.listItems[name] = true
    x:UpdateAuraSpellFilter("items")
  else
    print("|cffFF0000x|r|cffFFFF00CT+|r  |cffFF0000Error:|r Unknown filter type '" .. category .. "'!")
  end
end

function x.RemoveFilteredSpell(name, category)
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
  elseif category == "listProcs" then
    x.db.profile.spellFilter.listProcs[name] = nil
    x:UpdateAuraSpellFilter("procs")
  elseif category == "listItems" then
    x.db.profile.spellFilter.listItems[name] = nil
    x:UpdateAuraSpellFilter("items")
  else
    print("|cffFF0000x|r|cffFFFF00CT+|r  |cffFF0000Error:|r Unknown filter type '" .. category .. "'!")
  end
end

local colorNameDB = { }
function x.LookupColorByName(name)
  if colorNameDB[name] then
    return colorNameDB[name].color
  else
    return
  end
end

local getColorDB = function(info)
  local enabled = string_match(info[#info], "(.*)_enabled")
  local color = string_match(info[#info], "(.*)_color")
  if info[#info-1] == 'fontColors' then
    if enabled then
      return x.db.profile.frames[info[#info-2]].colors[enabled].enabled
    elseif color then
      return unpack(x.db.profile.frames[info[#info-2]].colors[color].color or x.db.profile.frames[info[#info-2]].colors[color].default)
    end
  elseif info[#info-2] == 'fontColors' then
    if enabled then
      return x.db.profile.frames[info[#info-3]].colors[info[#info-1]].colors[enabled].enabled
    elseif color then
      return unpack(x.db.profile.frames[info[#info-3]].colors[info[#info-1]].colors[color].color or x.db.profile.frames[info[#info-3]].colors[info[#info-1]].colors[color].default)
    end
  elseif info[#info-3] == 'fontColors' then
    if enabled then
      return x.db.profile.frames[info[#info-4]].colors[info[#info-2]].colors[info[#info-1]].colors[enabled].enabled
    elseif color then
      return unpack(x.db.profile.frames[info[#info-4]].colors[info[#info-2]].colors[info[#info-1]].colors[color].color or x.db.profile.frames[info[#info-4]].colors[info[#info-2]].colors[info[#info-1]].colors[color].default)
    end
  end
end

local setColorDB = function(info, r, g, b)
  local enabled = string_match(info[#info], "(.*)_enabled")
  local color = string_match(info[#info], "(.*)_color")
  if info[#info-1] == 'fontColors' then
    if enabled then
      x.db.profile.frames[info[#info-2]].colors[enabled].enabled = r
    elseif color then
      x.db.profile.frames[info[#info-2]].colors[color].color = { r, g, b }
    end
  elseif info[#info-2] == 'fontColors' then
    if enabled then
      x.db.profile.frames[info[#info-3]].colors[info[#info-1]].colors[enabled].enabled = r
    elseif color then
      x.db.profile.frames[info[#info-3]].colors[info[#info-1]].colors[color].color = { r, g, b }
    end
  elseif info[#info-3] == 'fontColors' then
    if enabled then
      x.db.profile.frames[info[#info-4]].colors[info[#info-2]].colors[info[#info-1]].colors[enabled].enabled = r
    elseif color then
      x.db.profile.frames[info[#info-4]].colors[info[#info-2]].colors[info[#info-1]].colors[color].color = { r, g, b }
    end
  end
end

local funcColorReset = function(info)
  local color = string_match(info[#info], "(.*)_reset")
  if info[#info-1] == 'fontColors' then
    x.db.profile.frames[info[#info-2]].colors[color].color = x.db.profile.frames[info[#info-2]].colors[color].default
  elseif info[#info-2] == 'fontColors' then
    x.db.profile.frames[info[#info-3]].colors[info[#info-1]].colors[color].color = x.db.profile.frames[info[#info-3]].colors[info[#info-1]].colors[color].default
  elseif info[#info-3] == 'fontColors' then
    x.db.profile.frames[info[#info-4]].colors[info[#info-2]].colors[info[#info-1]].colors[color].color = x.db.profile.frames[info[#info-4]].colors[info[#info-2]].colors[info[#info-1]].colors[color].default
  end
end

local funcColorHidden = function(info)
  local color = string_match(info[#info], "(.*)_color")
  if info[#info-1] == 'fontColors' then
    return not x.db.profile.frames[info[#info-2]].colors[color].enabled
  elseif info[#info-2] == 'fontColors' then
    return not x.db.profile.frames[info[#info-3]].colors[info[#info-1]].colors[color].enabled
  elseif info[#info-3] == 'fontColors' then
    return not x.db.profile.frames[info[#info-4]].colors[info[#info-2]].colors[info[#info-1]].colors[color].enabled
  end
end

local funcColorResetHidden = function(info)
  local color = string_match(info[#info], "(.*)_reset")
  if info[#info-1] == 'fontColors' then
    return not x.db.profile.frames[info[#info-2]].colors[color].enabled or
      tableCompare(x.db.profile.frames[info[#info-2]].colors[color].color, x.db.profile.frames[info[#info-2]].colors[color].default)
  elseif info[#info-2] == 'fontColors' then
    return not x.db.profile.frames[info[#info-3]].colors[info[#info-1]].colors[color].enabled or
      tableCompare(x.db.profile.frames[info[#info-3]].colors[info[#info-1]].colors[color].color, x.db.profile.frames[info[#info-3]].colors[info[#info-1]].colors[color].default)
  elseif info[#info-3] == 'fontColors' then
    return not x.db.profile.frames[info[#info-4]].colors[info[#info-2]].colors[info[#info-1]].colors[color].color or
      tableCompare(x.db.profile.frames[info[#info-4]].colors[info[#info-2]].colors[info[#info-1]].colors[color].color, x.db.profile.frames[info[#info-4]].colors[info[#info-2]].colors[info[#info-1]].colors[color].default)
  end
end

local function GenerateColorOptionsTable_Entry(colorName, settings, options, index)
  -- Clean the DB of any old/removed values
  if not settings.desc then return end

  -- Check for nil colors and set them to the default
  if not settings.color or not unpack(settings.color) then
    -- This needs to be a new table apperently
    settings.color = { unpack(settings.default) }
  end

  -- Cache this color into a quick lookup
  colorNameDB[colorName] = settings
  options[colorName.."_enabled"] = {
    order = index,
    type = 'toggle',
    name = settings.desc,
    get = getColorDB,
    set = setColorDB,
    desc = "Enable a custom color for |cff798BDD"..settings.desc.."|r.",
  }
  options[colorName.."_color"] = {
    order = index + 1,
    type = 'color',
    name = "Color",
    get = getColorDB,
    set = setColorDB,
    desc = "Change the color for |cff798BDD"..settings.desc.."|r.",
    hidden = funcColorHidden,
  }
  options[colorName.."_reset"] = {
    type = 'execute',
    order = index + 2,
    name = "Reset",
    width = 'half',
    func = funcColorReset,
    desc = "Resets |cff798BDD"..settings.desc.."|r back to the default color.",
    hidden = funcColorResetHidden,
  }
  options["spacer"..index] = {
    order = index + 3,
    type = 'description',
    fontSize = 'small',
    width = 'full',
    name = '',
  }
end

local function GenerateColorOptionsTable(colorName, settings, options, index)
  if settings.colors then
    -- Multiple Layers of colors on the inside
    --[[options['spacer'..index] = {
      type = 'description',
      order = index,
      name = '\n',
      fontSize = 'small',
    }]]
    options[colorName] = {
      order = index + 1,
      type = 'group',
      guiInline = true,
      name = settings.desc,
      args = { },
    }
    index = index + 1

    -- Sort the Colors Alphabetical
    local sortedList = { }
    for colorName in pairs(settings.colors) do
      table_insert(sortedList, colorName)
    end

    table_sort(sortedList)

    local currentColorSettings
    for _, currentColorName in ipairs(sortedList) do
      currentColorSettings = settings.colors[currentColorName]
      GenerateColorOptionsTable_Entry(currentColorName, currentColorSettings, options[colorName].args, index)
      index = index + 4
    end
  else
    -- Just this color
    GenerateColorOptionsTable_Entry(colorName, settings, options, index)
    index = index + 4
  end
  return index
end

-- Generate Colors for each Frame
function x.GenerateColorOptions()
  for name, settings in pairs(x.db.profile.frames) do
    local options = addon.options.args.Frames.args[name]
    if settings.colors then
      local index = 1

      -- Sort the Colors Alphabetical
      local sortedList = { }
      for colorName in pairs(settings.colors) do
        table_insert(sortedList, colorName)
      end

      table_sort(sortedList)

      local colorSettings
      -- Do Single Colors First
      for _, colorName in ipairs(sortedList) do
        colorSettings = settings.colors[colorName]
        if not colorSettings.colors then
          index = GenerateColorOptionsTable(colorName, colorSettings, options.args.fontColors.args, index) + 1
        end
      end

      -- Then Do Color Groups with multiple settings
      for _, colorName in ipairs(sortedList) do
        colorSettings = settings.colors[colorName]
        if colorSettings.colors then
          index = GenerateColorOptionsTable(colorName, colorSettings, options.args.fontColors.args, index) + 1
        end
      end
    end
  end
end

-- A helpful set of tips
local tips = {
  "On the left list, under the |cffFFFF00Startup Message|r checkbox, you can click on the |cff798BDD+ Buttons|r (plus) to show more options.",
  "If you want to |cff798BDDCombine Frame Outputs|r, disable one of the frames and use the |cffFFFF00Secondary Frame|r option on that frame.",
  "Only the |cffFFFF00General|r, |cffFF8000Outgoing|r, |cffFFFF00Outgoing (Crits)|r, |cffFF8000Incoming Damage|r and |cffFFFF00Healing|r, and |cffFF8000Class Power|r frames can be abbreviated.",
  "The |cffFFFF00Hide Config in Combat|r option was added to prevent |cffFFFF00xCT+|r from tainting your UI. It is highly recommended left enabled.",
  "|cffFFFF00xCT+|r has several different ways it will merge critical hits. You can check them out in |cffFFFF00Spam Merer|r.",
  "Each frame has a |cffFFFF00Special Tweaks|r section; select a frame and select the drop-down box to find it.",
  "If there is a certain |cff798BDDSpell|r, |cff798BDDBuff|r, or |cff798BDDDebuff|r that you don't want to see, consider adding it to a |cff798BDDFilter|r.",
}

local helpfulList = {}
local function GetNextTip()
  if #helpfulList == 0 then
    local used = {}

    local num
    while #used ~= #tips do
      num = random(1, #tips)
      if not used[num] then
        used[num] = true
        table_insert(helpfulList, tips[num])
      end
    end
  end

  local currentItem = helpfulList[1]
  table_remove(helpfulList, 1)

  return currentItem
end

-- Unused for now
function x:OnEnable() end
function x:OnDisable() end

-- This allows us to create our config dialog
local AceGUI = LibStub("AceGUI-3.0")
local AC = LibStub('AceConfig-3.0')
local ACD = LibStub('AceConfigDialog-3.0')
local ACR = LibStub('AceConfigRegistry-3.0')

-- Register the Options
ACD:SetDefaultSize(AddonName, 803, 560)
AC:RegisterOptionsTable(AddonName, addon.options)


if build < 70000 then
  AC:RegisterOptionsTable(AddonName.."Blizzard", x.blizzardOptions)
  ACD:AddToBlizOptions(AddonName.."Blizzard", "|cffFF0000x|rCT+")
end



-- Register Slash Commands
x:RegisterChatCommand('xct', 'OpenxCTCommand')

-- Close Config when entering combat
local lastConfigState, shownWarning = false, false
function x:CombatStateChanged()
  if x.db.profile.hideConfig then
    if self.inCombat then
      if x.myContainer then
        if x.myContainer:IsShown( ) then
          lastConfigState = true
          x:HideConfigTool()
        end
      end
    else
      if lastConfigState then
        x:ShowConfigTool()
      end
      lastConfigState = false
      shownWarning = false
    end
  end

  for framename, settings in pairs(x.db.profile.frames) do
    if settings.enableScrollable and settings.scrollableInCombat then
      if x.inCombat then
        x:DisableFrameScrolling( framename )
      else
        x:EnableFrameScrolling( framename )
      end
    end
  end
end

-- Force Config Page to refresh
function x:RefreshConfig()
  if ACD.OpenFrames[AddonName] then
    ACR:NotifyChange(AddonName)
  end
end

local helpfulLastUpdate = GetTime()
function x:OnAddonConfigRefreshed()
  if GetTime() - helpfulLastUpdate > 15 then
    helpfulLastUpdate = GetTime()
    addon.options.args.helpfulTip.name = GetNextTip()
    x:RefreshConfig()
  end
end

-- Process the slash command ('input' contains whatever follows the slash command)
function x:OpenxCTCommand(input)
  local lock = string_match(string_lower(input), 'lock')
  local save = string_match(string_lower(input), 'save')
  if lock or save then
    if not x.configuring and save then
      return
    elseif x.configuring then
      x:SaveAllFrames()
      x.EndConfigMode()
      print("|cffFF0000x|r|cffFFFF00CT+|r  Frames have been saved. Please fasten your seat belts.")
      StaticPopup_Hide("XCT_PLUS_CONFIGURING")
    else
      x.ToggleConfigMode()

      print("|cffFF0000x|r|cffFFFF00CT+|r  You are now free to move about the cabin.")
      print("      |cffFF0000/xct lock|r      - Saves your frames.")
      print("      |cffFF0000/xct cancel|r  - Cancels all your recent frame movements.")
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
    print("      |cffFF0000/xct test|r - Attempts to emulate combat.")
    return
  end

  if string_lower(input) == 'test' then
    x.ToggleTestMode(true)
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


  if not x.configuring then
    x:ToggleConfigTool()
  end
end

local function myContainer_OnRelease( self )
  AceGUI:Release(x.myContainer)
  x.myContainer = nil

  x.isConfigToolOpen = false
end

function x:ToggleConfigTool()
  if x.isConfigToolOpen then
    x:HideConfigTool()
  else
    x:ShowConfigTool()
  end
end

function x:ShowConfigTool()
  if x.isConfigToolOpen then return end
  if x.inCombat and x.db.profile.hideConfig then
    if not shownWarning then
      print("|cffFF0000x|r|cffFFFF00CT+|r will open the |cff798BDDConfiguration Tool|r after combat.")
      shownWarning = true
      lastConfigState = true
    end
    return
  end

  x.isConfigToolOpen = true

  if x.myContainer then
    x.myContainer:Hide()
  end

  -- Register my AddOn for Escape keypresses
  x.myContainer = AceGUI:Create("Frame")
  x.myContainer.frame:SetScript('OnHide', function(self)
      x:HideConfigTool()
    end)
  _G["xCT_PlusConfigFrame"] = x.myContainer.frame
  table_insert( UISpecialFrames, "xCT_PlusConfigFrame" )

  -- Properly dispose of this frame
  x.myContainer:SetCallback("OnClose", myContainer_OnRelease)

  -- Last minute settings and SHOW
  x.myContainer.content:GetParent():SetMinResize(803, 300)
  ACD:Open(AddonName, x.myContainer)
end

local function HideConfigTool_OnUpdate( self, e )
  x.waiterHideConfig:SetScript("OnUpdate", nil)
  x.isConfigToolOpen = false

  if x.myContainer then
    x.myContainer:Hide()
  end
end

function x:HideConfigTool( wait )

  -- If the item that is call needs the frame for another unit of time
  if wait then
    if not x.waiterHideConfig then
      x.waiterHideConfig = CreateFrame("FRAME")
    end

    x.waiterHideConfig:SetScript("OnUpdate", HideConfigTool_OnUpdate)
    return
  end

  -- This is if we don't wait
  x.isConfigToolOpen = false

  if x.myContainer then
    x.myContainer:Hide()
  end

  -- MORE!
  GameTooltip:Hide()
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

