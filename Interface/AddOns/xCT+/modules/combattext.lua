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

-- Shorten my handle
local x = addon.engine

-- up values
local _, _G, sformat, mfloor, ssub, sgsub, s_upper, s_lower, string, tinsert, ipairs, pairs, print, tostring, tonumber, select, unpack =
  nil, _G, string.format, math.floor, string.sub, string.gsub, string.upper, string.lower, string, table.insert, ipairs, pairs, print, tostring, tonumber, select, unpack

--[=====================================================[
 Holds player info; use AddOn:UpdatePlayer()
--]=====================================================]
x.player = {
  unit = "player",
  guid = nil, -- dont get the guid until we load
  class = "unknown",
  name = "unknown",
  spec = -1,
}

--[=====================================================[
 AddOn:UpdatePlayer()
    Updates important information about the player we
  need inorder to correctly show combat text events.
--]=====================================================]
function x:UpdatePlayer()
  -- Set the Player's Current Playing Unit
  if x.player.unit == "custom" then
    --CombatTextSetActiveUnit(x.player.customUnit)
  else
    if UnitHasVehicleUI("player") then
      x.player.unit = "vehicle"
    else
      x.player.unit = "player"
    end
    CombatTextSetActiveUnit(x.player.unit)
  end

  -- Set Player's Information
  x.player.name   = UnitName("player")
  x.player.class  = select(2, UnitClass("player"))
  x.player.guid   = UnitGUID("player")
  
  local activeTalentGroup = GetActiveSpecGroup(false, false)
  x.player.spec = GetSpecialization(false, false, activeTalentGroup)
end

--[=====================================================[
 AddOn:UpdateCombatTextEvents(
    enable,     [BOOL] - True tp enable the events, false to disable them
  )
    Registers or updates the combat text event frame
--]=====================================================]
function x:UpdateCombatTextEvents(enable)
  local f = nil
  if x.combatEvents then
    x.combatEvents:UnregisterAllEvents()
    f = x.combatEvents
  else
    f = CreateFrame("FRAME")
  end
  
  if enable then
    -- Enabled Combat Text
    f:RegisterEvent("COMBAT_TEXT_UPDATE")
    f:RegisterEvent("UNIT_HEALTH")
    f:RegisterEvent("UNIT_MANA")
    -- f:RegisterEvent("PLAYER_REGEN_DISABLED")
    -- f:RegisterEvent("PLAYER_REGEN_ENABLED")
    f:RegisterEvent("UNIT_ENTERED_VEHICLE")
    f:RegisterEvent("UNIT_EXITING_VEHICLE")
    f:RegisterEvent("PLAYER_ENTERING_WORLD")
    f:RegisterEvent("PLAYER_TARGET_CHANGED")
    f:RegisterEvent("SPELL_ACTIVATION_OVERLAY_GLOW_SHOW")
    
    -- if runes
    f:RegisterEvent("RUNE_POWER_UPDATE")
    
    -- if loot
    f:RegisterEvent("CHAT_MSG_LOOT")
    f:RegisterEvent("CHAT_MSG_MONEY")
    
    -- damage and healing
    f:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
    
    -- Class combo points
    f:RegisterEvent("UNIT_POWER") -- monk
    f:RegisterEvent("UNIT_AURA")
    f:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
    f:RegisterEvent("UNIT_COMBO_POINTS")
    f:RegisterEvent("PLAYER_TARGET_CHANGED")

    x.combatEvents = f
    f:SetScript("OnEvent", x.OnCombatTextEvent)
  else
    -- Disabled Combat Text
    f:SetScript("OnEvent", nil)
  end
end

--[=====================================================[
 Fast Boolian Lookups
--]=====================================================]
local function ShowMissTypes() return COMBAT_TEXT_SHOW_DODGE_PARRY_MISS == "1" end
local function ShowResistances() return COMBAT_TEXT_SHOW_RESISTANCES == "1" end
local function ShowHonor() return COMBAT_TEXT_SHOW_HONOR_GAINED == "1" end
local function ShowFaction() return COMBAT_TEXT_SHOW_REPUTATION == "1" end
local function ShowReactives() return COMBAT_TEXT_SHOW_REACTIVES == "1" end
local function ShowLowResources() return COMBAT_TEXT_SHOW_LOW_HEALTH_MANA == "1" end
local function ShowCombatState() return COMBAT_TEXT_SHOW_COMBAT_STATE == "1" end
local function ShowFriendlyNames() return COMBAT_TEXT_SHOW_FRIENDLY_NAMES == "1" end
local function ShowColoredFriendlyNames() return x.db.profile.frames["healing"].enableClassNames end
local function ShowDamage() return x.db.profile.frames["outgoing"].enableOutDmg end
local function ShowHealing() return x.db.profile.frames["outgoing"].enableOutHeal end
local function ShowPetDamage() return x.db.profile.frames["outgoing"].enablePetDmg end
local function ShowAutoAttack() return x.db.profile.frames["outgoing"].enableAutoAttack end
local function ShowDots() return x.db.profile.frames["outgoing"].enableDotDmg end
local function ShowHots() return x.db.profile.frames["outgoing"].enableHots end
local function ShowImmunes() return x.db.profile.frames["outgoing"].enableImmunes end -- outgoing immunes
local function ShowMisses() return x.db.profile.frames["outgoing"].enableMisses end -- outgoing misses
local function ShowSwingCrit() return x.db.profile.frames["critical"].showSwing end
local function ShowSwingCritPrefix() return x.db.profile.frames["critical"].prefixSwing end
local function ShowSwingRedirected() return x.db.profile.frames["critical"].redirectSwing end
local function ShowLootItems() return x.db.profile.frames["loot"].showItems end
local function ShowLootMoney() return x.db.profile.frames["loot"].showMoney end
local function ShowTotalItems() return x.db.profile.frames["loot"].showItemTotal end
local function ShowLootCrafted() return x.db.profile.frames["loot"].showCrafted end
local function ShowLootQuest() return x.db.profile.frames["loot"].showQuest end
local function ShowColorBlindMoney() return x.db.profile.frames["loot"].colorBlindMoney end
local function GetLootQuality() return x.db.profile.frames["loot"].filterItemQuality end
local function ShowLootIcons() return x.db.profile.frames["loot"].iconsEnabled end
local function GetLootIconSize() return x.db.profile.frames["loot"].iconsSize end
local function ShowInterrupts() return x.db.profile.frames["general"].showInterrupts end
local function ShowDispells() return x.db.profile.frames["general"].showDispells end
local function ShowPartyKill() return x.db.profile.frames["general"].showPartyKills end
local function ShowBuffs() return x.db.profile.frames["general"].showBuffs end
local function ShowDebuffs() return x.db.profile.frames["general"].showDebuffs end

local function ShowRogueComboPoints() return x.db.profile.spells.combo["ROGUE"][COMBAT_TEXT_SHOW_COMBO_POINTS_TEXT] and x.player.class == "ROGUE" end
local function ShowFeralComboPoints() return x.db.profile.spells.combo["DRUID"][2][COMBAT_TEXT_SHOW_COMBO_POINTS_TEXT] and x.player.class == "DRUID" and x.player.spec == 2 end
local function ShowMonkChi() return x.db.profile.spells.combo["MONK"][CHI] and x.player.class == "MONK" end
local function ShowPaladinHolyPower() return x.db.profile.spells.combo["PALADIN"][HOLY_POWER] and x.player.class == "PALADIN" end
local function ShowPriestShadowOrbs() return x.db.profile.spells.combo["PRIEST"][3][SHADOW_ORBS] and x.player.class == "PRIEST" and x.player.spec == 3 end
local function ShowWarlockSoulShards() return x.db.profile.spells.combo["WARLOCK"][1][SOUL_SHARDS_POWER] and x.player.class == "WARLOCK" and x.player.spec == 1 end
local function ShowWarlockDemonicFury() return x.db.profile.spells.combo["WARLOCK"][2][DEMONIC_FURY] and x.player.class == "WARLOCK" and x.player.spec == 2 end
local function ShowWarlockBurningEmbers() return x.db.profile.spells.combo["WARLOCK"][3][BURNING_EMBERS_POWER] and x.player.class == "WARLOCK" and x.player.spec == 3 end

local function ClearWhenLeavingCombat() return x.db.profile.frameSettings.clearLeavingCombat end
local function ShowAbbrivatedDamage() return x.db.profile.megaDamage.enableMegaDamage end

local function MergeMeleeSwings() return x.db.profile.spells.mergeSwings end
local function MergeRangedAttacks() return x.db.profile.spells.mergeRanged end
local function MergeCriticalsWithOutgoing() return x.db.profile.spells.mergeCriticalsWithOutgoing end
local function MergeCriticalsByThemselves() return x.db.profile.spells.mergeCriticalsByThemselves end
local function MergeDontMergeCriticals() return x.db.profile.spells.mergeDontMergeCriticals end

local function IsBearForm() return GetShapeshiftForm() == 1 and x.player.class == "DRUID" end

--[=====================================================[
 String Formatters
--]=====================================================]
local format_loot = "([^|]*)|cff(%x*)|H[^:]*:(%d+):[-?%d+:]+|h%[?([^%]]*)%]|h|r?%s?x?(%d*)%.?"
local format_fade = "-%s"
local format_gain = "+%s"
local format_gain_rune = "%s +%s %s"
local format_resist = "-%s (%s %s)"
local format_energy = "+%s %s"
local format_honor = sgsub(COMBAT_TEXT_HONOR_GAINED, "%%s", "+%%s")
local format_faction_add = "%s +%s"
local format_faction_sub = "%s %s"
local format_crit = "%s%s%s"
local format_dispell = "%s: %s"

--[=====================================================[
 Capitalize Locals
--]=====================================================]
local XCT_STOLE = string.upper(string.sub(ACTION_SPELL_STOLEN, 1, 1))..string.sub(ACTION_SPELL_STOLEN, 2)
local XCT_KILLED = string.upper(string.sub(ACTION_PARTY_KILL, 1, 1))..string.sub(ACTION_PARTY_KILL, 2)
local XCT_DISPELLED = string.upper(string.sub(ACTION_SPELL_DISPEL, 1, 1))..string.sub(ACTION_SPELL_DISPEL, 2)

--[=====================================================[
 Flag value for special pets and vehicles
--]=====================================================]
local COMBATLOG_FILTER_MY_VEHICLE = bit.bor( COMBATLOG_OBJECT_AFFILIATION_MINE,
  COMBATLOG_OBJECT_REACTION_FRIENDLY, COMBATLOG_OBJECT_CONTROL_PLAYER, COMBATLOG_OBJECT_TYPE_GUARDIAN )

--[=====================================================[
 AddOn:OnCombatTextEvent(
    event,     [string] - Name of the event
    ...,       [multiple] - args from the combat event
  )
    This is the event handler and will act like a
  switchboard the send the events to where they need
  to go.
--]=====================================================]
function x.OnCombatTextEvent(self, event, ...)
  if event == "COMBAT_LOG_EVENT_UNFILTERED" then
    local timestamp, eventType, hideCaster, sourceGUID, sourceName, sourceFlags, srcFlags2, destGUID, destName, destFlags, destFlags2 = select(1, ...)
    if sourceGUID == x.player.guid or ( sourceGUID == UnitGUID("pet") and ShowPetDamage() ) or sourceFlags == COMBATLOG_FILTER_MY_VEHICLE then
      if x.outgoing_events[eventType] then
        x.outgoing_events[eventType](...)
      end
    end
  elseif event == "COMBAT_TEXT_UPDATE" then
    local subevent, arg2, arg3 = ...
    if x.combat_events[subevent] then
      x.combat_events[subevent](arg2, arg3)
    end
  else
    if x.events[event] then
      x.events[event](...)
    end
  end
end

--[=====================================================[
 AddOn:GetSpellTextureFormatted(
    spellID,     [number] - The spell ID you want the icon for
    iconSize,    [number] - The format size of the icon
  )
  Returns:
   message,     [string] - the message contains the formatted icon

    Formats an icon quickly for use when outputing to
  a combat text frame.
--]=====================================================]
function x:GetSpellTextureFormatted(spellID, iconSize)
  local message = ""

  if spellID == 0 then
    message = " \124T"..PET_ATTACK_TEXTURE..":"..iconSize..":"..iconSize..":0:0:64:64:5:59:5:59\124t"
  else
    local icon = GetSpellTexture(spellID)
    if icon then
      message = " \124T"..icon..":"..iconSize..":"..iconSize..":0:0:64:64:5:59:5:59\124t"
    else
      message = " \124T"..x.BLANK_ICON..":"..iconSize..":"..iconSize..":0:0:64:64:5:59:5:59\124t"
    end
  end
  
  if x.db.profile.spells.enableMergerDebug then
    message = message .. " |cffFFFFFF[|cffFF0000ID:|r|cffFFFF00" .. spellID .. "|r]|r"
  end
  
  return message
end

--[=====================================================[
 Combo Points - Rogues / Feral
--]=====================================================]
local function UpdateComboPoints()
  if ShowRogueComboPoints() or ShowFeralComboPoints() then
    local comboPoints, outputColor = GetComboPoints(x.player.unit, "target"), "combo_points"
    if comboPoints == MAX_COMBO_POINTS then outputColor = "combo_points_max" end
    if comboPoints > 0 then
      x.cpUpdated = true
      x:AddMessage("class", comboPoints, outputColor)
    elseif x.cpUpdated then
      x.cpUpdated = false
      x:AddMessage("class", " ", outputColor)
    end
  end
end

--[=====================================================[
  Combo Points - Class Power Types
--]=====================================================]
local function UpdateUnitPower(unit, powertype)
  if unit == x.player.unit then
    local value

    if powertype == "CHI" and ShowMonkChi() then
      value = UnitPower(x.player.unit, SPELL_POWER_CHI)
    elseif powertype == "HOLY_POWER" and ShowPaladinHolyPower() then
      value = UnitPower(x.player.unit, SPELL_POWER_HOLY_POWER)
    elseif powertype == "SHADOW_ORBS" and ShowPriestShadowOrbs() then
      value = UnitPower(x.player.unit, SPELL_POWER_SHADOW_ORBS)
    elseif powertype == "SOUL_SHARDS" and ShowWarlockSoulShards() then
      value = UnitPower(x.player.unit, SPELL_POWER_SOUL_SHARDS)
    elseif powertype == "DEMONIC_FURY" and ShowWarlockDemonicFury() then
      value = mfloor(UnitPower(x.player.unit, SPELL_POWER_DEMONIC_FURY) / 100)
    elseif powertype == "BURNING_EMBERS" and ShowWarlockBurningEmbers() then
      value = UnitPower(x.player.unit, SPELL_POWER_BURNING_EMBERS) / 10
    end

    if value then
      if value < 1 then
        if value == 0 then
          x:AddMessage("class", " ", "combo_points")
        else
          x:AddMessage("class", "0", "combo_points")
        end
      else
        x:AddMessage("class", mfloor(value), "combo_points")
      end
    end
  end
end

--[=====================================================[
 Combo Points - Class Aura Types
--]=====================================================]
local function UpdateAuraTracking(unit)
  local entry = x.TrackingEntry
  
  if entry then
    if unit == entry.unit then
      local i, name, _, icon, count, _, _, _, _, _, _, spellId = 1, UnitBuff(entry.unit, 1)
      
      while name do
        if entry.id == spellId then
          break
        end
        i = i + 1;
        name, _, icon, count, _, _, _, _, _, _, spellId = UnitBuff(entry.unit, i)
      end
      
      if name and count > 0 then
        x:AddMessage("class", count, "combo_points")
      else
        x:AddMessage("class", " ", "combo_points")
      end
        
    -- Fix issue of not reseting when unit disapears (e.g. dismiss pet)
    elseif not UnitExists(entry.unit) then
      x:AddMessage("class", " ", "combo_points")
    end
  end
end

function x:QuickClassFrameUpdate()
  local entry = x.TrackingEntry
  if entry and UnitExists(entry.unit) then
    -- Update Buffs
    UpdateAuraTracking(entry.unit)
    
    -- Update Unit's Power
    if ShowMonkChi() then
      UpdateUnitPower(entry.unit, "LIGHT_FORCE")
    elseif ShowPaladinHolyPower() then
      UpdateUnitPower(entry.unit, "HOLY_POWER")
    elseif ShowPriestShadowOrbs() then
      UpdateUnitPower(entry.unit, "SHADOW_ORBS")
    elseif ShowWarlockSoulShards() then
      UpdateUnitPower(entry.unit, "SOUL_SHARDS")
    elseif ShowWarlockDemonicFury() then
      UpdateUnitPower(entry.unit, "DEMONIC_FURY")
    elseif ShowWarlockBurningEmbers() then
      UpdateUnitPower(entry.unit, "BURNING_EMBERS")
    end
  else
    -- Update Combo Points
    UpdateComboPoints()
  end
end


-- This frame was created to make sure I always display the correct number of an item in your bag
local function LootFrame_OnUpdate(self, elapsed)
  local removeItems = { }
  for i, item in ipairs(self.items) do
    item.t = item.t + elapsed
    
    -- Time to wait before showing a looted item
    if item.t > 0.5 then
      local s = item.message
      s = s.."  |cffFFFFFF(x"..(GetItemCount(item.id)).. ")|r"
      x:AddMessage("loot", s, {item.r, item.g, item.b})
      
      removeItems[i] = true
    end
    
  end
  
  for k in pairs(removeItems) do
    self.items[k] = nil
  end
  
  if #self.items < 1 then
    self:SetScript("OnUpdate", nil)
    self.isRunning = false
  end
end

--[=====================================================[
 Event handlers - Combat Text Events
--]=====================================================]
x.combat_events = {
  ["DAMAGE"] = function(amount)
      local message = amount
      
      -- Abbrivate the message
      if ShowAbbrivatedDamage() then
        if (amount >= 1000000) then
          message = tostring(mfloor((amount + 500000) / 1000000)) .. x.db.profile.megaDamage.millionSymbol
        elseif (amount >= 1000) then
          message = tostring(mfloor((amount + 500) / 1000)) .. x.db.profile.megaDamage.thousandSymbol
        end
      end
      
      x:AddMessage("damage", sformat(format_fade, message), "damage")
    end,
  ["DAMAGE_CRIT"] = function(amount)
      local message = amount
      
      -- Abbrivate the message
      if ShowAbbrivatedDamage() then
        if (amount >= 1000000) then
          message = tostring(mfloor((amount + 500000) / 1000000)) .. x.db.profile.megaDamage.millionSymbol
        elseif (amount >= 1000) then
          message = tostring(mfloor((amount + 500) / 1000)) .. x.db.profile.megaDamage.thousandSymbol
        end
      end
      
      x:AddMessage("damage", sformat(format_fade, message), "damage_crit")
    end,
  ["SPELL_DAMAGE"] = function(amount)
      local message = amount
      
      -- Abbrivate the message
      if ShowAbbrivatedDamage() then
        if (amount >= 1000000) then
          message = tostring(mfloor((amount + 500000) / 1000000)) .. x.db.profile.megaDamage.millionSymbol
        elseif (amount >= 1000) then
          message = tostring(mfloor((amount + 500) / 1000)) .. x.db.profile.megaDamage.thousandSymbol
        end
      end
      
      x:AddMessage("damage", sformat(format_fade, message), "spell_damage")
    end,
  ["SPELL_DAMAGE_CRIT"] = function(amount)
      local message = amount
      
      -- Abbrivate the message
      if ShowAbbrivatedDamage() then
        if (amount >= 1000000) then
          message = tostring(mfloor((amount + 500000) / 1000000)) .. x.db.profile.megaDamage.millionSymbol
        elseif (amount >= 1000) then
          message = tostring(mfloor((amount + 500) / 1000)) .. x.db.profile.megaDamage.thousandSymbol
        end
      end
      
      x:AddMessage("damage", sformat(format_fade, message), "spell_damage_crit")
    end,
  
  -- TODO: Add thresholds
  ["HEAL"] = function(healer_name, amount)
      local message = amount
  
      -- Abbrivate the message
      if ShowAbbrivatedDamage() then
        if (amount >= 1000000) then
          message = tostring(mfloor((amount + 500000) / 1000000)) .. x.db.profile.megaDamage.millionSymbol
        elseif (amount >= 1000) then
          message = tostring(mfloor((amount + 500) / 1000)) .. x.db.profile.megaDamage.thousandSymbol
        end
      end
      
      message = sformat(format_gain, message)
      
      if ShowFriendlyNames() and healer_name then
        if ShowColoredFriendlyNames() then
          local _, class = UnitClass(healer_name)
          if (class) then
            healer_name = sformat("|c%s%s|r", RAID_CLASS_COLORS[class].colorStr, healer_name)
          end
        end
      
        if x.db.profile.frames["healing"].fontJustify == "LEFT" then
          message = message .. " " .. healer_name
        else
          message = healer_name .. " " .. message
        end
      end
      x:AddMessage("healing", message, "heal")
    end,
  ["HEAL_CRIT"] = function(healer_name, amount)
      local message = amount
  
      -- Abbrivate the message
      if ShowAbbrivatedDamage() then
        if (amount >= 1000000) then
          message = tostring(mfloor((amount + 500000) / 1000000)) .. x.db.profile.megaDamage.millionSymbol
        elseif (amount >= 1000) then
          message = tostring(mfloor((amount + 500) / 1000)) .. x.db.profile.megaDamage.thousandSymbol
        end
      end
      
      message = sformat(format_gain, message)
      
      if ShowFriendlyNames() and healer_name then
        if ShowColoredFriendlyNames() then
          local _, class = UnitClass(healer_name)
          if (class) then
            healer_name = sformat("|c%s%s|r", RAID_CLASS_COLORS[class].colorStr, healer_name)
          end
        end
      
        if x.db.profile.frames["healing"].fontJustify == "LEFT" then
          message = message .. " " .. healer_name
        else
          message = healer_name .. " " .. message
        end
      end
      x:AddMessage("healing", message, "heal_crit")
    end,
  ["PERIODIC_HEAL"] = function(healer_name, amount)
      local message = amount
  
      -- Abbrivate the message
      if ShowAbbrivatedDamage() then
        if (amount >= 1000000) then
          message = tostring(mfloor((amount + 500000) / 1000000)) .. x.db.profile.megaDamage.millionSymbol
        elseif (amount >= 1000) then
          message = tostring(mfloor((amount + 500) / 1000)) .. x.db.profile.megaDamage.thousandSymbol
        end
      end
      
      message = sformat(format_gain, message)
      
      if ShowFriendlyNames() and healer_name then
        if ShowColoredFriendlyNames() then
          local _, class = UnitClass(healer_name)
          if (class) then
            healer_name = sformat("|c%s%s|r", RAID_CLASS_COLORS[class].colorStr, healer_name)
          end
        end
      
        if x.db.profile.frames["healing"].fontJustify == "LEFT" then
          message = message .. " " .. healer_name
        else
          message = healer_name .. " " .. message
        end
      end
      x:AddMessage("healing", message, "heal_peri")
    end,
  
  -- TODO: Add filter?
  ["SPELL_ACTIVE"] = function(spell_name)
      local spellStacks = select(4, UnitAura("player", spell_name))
      if spellStacks and tonumber(spellStacks) > 1 then
        spell_name = spell_name .. " |cffFFFFFFx" .. spellStacks .. "|r"
      end
      x:AddMessage("procs", spell_name, "spell_cast")
    end,
    
  ["SPELL_CAST"] = function(spellname) if ShowReactives() then x:AddMessage("procs", spellname, "spell_reactive") end end,
  
  ["MISS"] = function() if ShowMissTypes() then x:AddMessage("damage", MISS, "misstype_generic") end end,
  ["DODGE"] = function() if ShowMissTypes() then x:AddMessage("damage", DODGE, "misstype_generic") end end,
  ["PARRY"] = function() if ShowMissTypes() then x:AddMessage("damage", PARRY, "misstype_generic") end end,
  ["EVADE"] = function() if ShowMissTypes() then x:AddMessage("damage", EVADE, "misstype_generic") end end,
  ["IMMUNE"] = function() if ShowMissTypes() then x:AddMessage("damage", IMMUNE, "misstype_generic") end end,
  ["DEFLECT"] = function() if ShowMissTypes() then x:AddMessage("damage", DEFLECT, "misstype_generic") end end,
  ["REFLECT"] = function() if ShowMissTypes() then x:AddMessage("damage", REFLECT, "misstype_generic") end end,
  
  ["SPELL_MISS"] = function() if ShowMissTypes() then x:AddMessage("damage", MISS, "misstype_generic") end end,
  ["SPELL_DODGE"] = function() if ShowMissTypes() then x:AddMessage("damage", DODGE, "misstype_generic") end end,
  ["SPELL_PARRY"] = function() if ShowMissTypes() then x:AddMessage("damage", PARRY, "misstype_generic") end end,
  ["SPELL_EVADE"] = function() if ShowMissTypes() then x:AddMessage("damage", EVADE, "misstype_generic") end end,
  ["SPELL_IMMUNE"] = function() if ShowMissTypes() then x:AddMessage("damage", IMMUNE, "misstype_generic") end end,
  ["SPELL_DEFLECT"] = function() if ShowMissTypes() then x:AddMessage("damage", DEFLECT, "misstype_generic") end end,
  ["SPELL_REFLECT"] = function() if ShowMissTypes() then x:AddMessage("damage", REFLECT, "misstype_generic") end end,

  ["RESIST"] = function(amount, resisted)
      if resisted then
        if ShowResistances() then
          x:AddMessage("damage", sformat(format_resist, amount, RESIST, resisted), "resist_generic")
        else
          x:AddMessage("damage", amount, "damage")
        end
      elseif ShowResistances() then
        x:AddMessage("damage", RESIST, "misstype_generic")
      end
    end,
  ["BLOCK"] = function(amount, resisted)
      if resisted then
        if ShowResistances() then
          x:AddMessage("damage", sformat(format_resist, amount, BLOCK, resisted), "resist_generic")
        else
          x:AddMessage("damage", amount, "damage")
        end
      elseif ShowResistances() then
        x:AddMessage("damage", BLOCK, "misstype_generic")
      end
    end,
  ["ABSORB"] = function(amount, resisted)
      if resisted then
        if ShowResistances() then
          x:AddMessage("damage", sformat(format_resist, amount, ABSORB, resisted), "resist_generic")
        else
          x:AddMessage("damage", amount, "damage")
        end
      elseif ShowResistances() then
        x:AddMessage("damage", ABSORB, "misstype_generic")
      end
    end,
  ["SPELL_RESIST"] = function(amount, resisted)
      if resisted then
        if ShowResistances() then
          x:AddMessage("damage", sformat(format_resist, amount, RESIST, resisted), "resist_spell")
        else
          x:AddMessage("damage", amount, "damage")
        end
      elseif ShowResistances() then
        x:AddMessage("damage", RESIST, "misstype_generic")
      end
    end,
  ["SPELL_BLOCK"] = function(amount, resisted)
      if resisted then
        if ShowResistances() then
          x:AddMessage("damage", sformat(format_resist, amount, BLOCK, resisted), "resist_spell")
        else
          x:AddMessage("damage", amount, "damage")
        end
      elseif ShowResistances() then
        x:AddMessage("damage", BLOCK, "misstype_generic")
      end
    end,
  ["SPELL_ABSORB"] = function(amount, resisted)
      if resisted then
        if ShowResistances() then
          x:AddMessage("damage", sformat(format_resist, amount, ABSORB, resisted), "resist_spell")
        else
          x:AddMessage("damage", amount, "damage")
        end
      elseif ShowResistances() then
        x:AddMessage("damage", ABSORB, "misstype_generic")
      end
    end,
  ["ENERGIZE"] = function(amount, energy_type)
      if amount > 0 then
        if energy_type and (energy_type == "MANA" and not IsBearForm()) -- do not show mana in bear form (Leader of the Pack)                                     
            or energy_type == "RAGE" or energy_type == "FOCUS"
            or energy_type == "ENERGY" or energy_type == "RUINIC_POWER"
            or energy_type == "SOUL_SHARDS" or energy_type == "HOLY_POWER" then
          local message, color = amount, {PowerBarColor[energy_type].r, PowerBarColor[energy_type].g, PowerBarColor[energy_type].b}
          
          -- Abbrivate the message
          if ShowAbbrivatedDamage() then
            if (amount >= 1000000) then
              message = tostring(mfloor((amount + 500000) / 1000000)) .. x.db.profile.megaDamage.millionSymbol
            elseif (amount >= 1000) then
              message = tostring(mfloor((amount + 500) / 1000)) .. x.db.profile.megaDamage.thousandSymbol
            end
          end

          x:AddMessage("power", sformat(format_energy, message, _G[energy_type]), color)
        end
      end
    end,
  ["PERIODIC_ENERGIZE"] = function(amount, energy_type)
      if amount > 0 then
        if energy_type and (energy_type == "MANA" and not IsBearForm()) -- do not show mana in bear form (Leader of the Pack)
            or energy_type == "RAGE" or energy_type == "FOCUS"
            or energy_type == "ENERGY" or energy_type == "RUINIC_POWER"
            or energy_type == "SOUL_SHARDS" or energy_type == "HOLY_POWER" then
          local message, color = amount, {PowerBarColor[energy_type].r, PowerBarColor[energy_type].g, PowerBarColor[energy_type].b}
          
          -- Abbrivate the message
          if ShowAbbrivatedDamage() then
            if (amount >= 1000000) then
              message = tostring(mfloor((amount + 500000) / 1000000)) .. x.db.profile.megaDamage.millionSymbol
            elseif (amount >= 1000) then
              message = tostring(mfloor((amount + 500) / 1000)) .. x.db.profile.megaDamage.thousandSymbol
            end
          end
          
          x:AddMessage("power", sformat(format_energy, amount, _G[energy_type]), color)
        end
      end
    end,

  ["SPELL_AURA_END"] = function(spellname) if ShowBuffs() then x:AddMessage("general", sformat(format_fade, spellname), "aura_end") end end,
  ["SPELL_AURA_START"] = function(spellname) if ShowBuffs() then x:AddMessage("general", sformat(format_gain, spellname), "aura_start") end end,
  ["SPELL_AURA_END_HARMFUL"] = function(spellname) if ShowDebuffs() then x:AddMessage("general", sformat(format_fade, spellname), "aura_end") end end,
  ["SPELL_AURA_START_HARMFUL"] = function(spellname) if ShowDebuffs() then x:AddMessage("general", sformat(format_gain, spellname), "aura_start_harm") end end,
  
  -- TODO: Create a merger for faction and honor xp
  ["HONOR_GAINED"] = function(amount)
      local num = mfloor(tonumber(amount) or 0)
      if num > 0 and ShowHonor() then
        x:AddMessage("general", sformat(format_honor, HONOR, amount), "honor")
      end
    end,
  ["FACTION"] = function(faction, amount)
      local num = mfloor(tonumber(amount) or 0)
      if num > 0 and ShowFaction() then
        x:AddMessage("general", sformat(format_faction_add, faction, amount), "honor")
      elseif num < 0 and ShowFaction() then
        x:AddMessage("general", sformat(format_faction_sub, faction, amount), "faction_sub")
      end
    end,
}

--[=====================================================[
 Event handlers - General Events
--]=====================================================]
x.events = {
  ["UNIT_HEALTH"] = function()
      if ShowLowResources() and UnitHealth(x.player.unit) / UnitHealthMax(x.player.unit) <= COMBAT_TEXT_LOW_HEALTH_THRESHOLD then
        if not x.lowHealth then
          x:AddMessage("general", HEALTH_LOW, "low_health")
          x.lowHealth = true
        end
      else
        x.lowHealth = false
      end
    end,
  ["UNIT_MANA"] = function()
      if select(2, UnitPowerType(x.player.unit)) == "MANA" and ShowLowResources() and UnitPower(x.player.unit) / UnitPowerMax(x.player.unit) <= COMBAT_TEXT_LOW_MANA_THRESHOLD then
        if not x.lowMana then
          x:AddMessage("general", MANA_LOW, "low_mana")
          x.lowMana = true
        end
      else
        x.lowMana = false
      end
    end,
  ["RUNE_POWER_UPDATE"] = function(slot)
      if GetRuneCooldown(slot) ~= 0 then return end
      local runeType = GetRuneType(slot);
      if runeType then
        local message = sformat(format_gain_rune, x.runeIcons[runeType], COMBAT_TEXT_RUNE[runeType], x.runeIcons[runeType])
        --x:AddMessage("power", message, x.runecolors[runeType])
        x:AddSpamMessage("power", runeType, message, x.runecolors[runeType], 1)
      end
    end,
    
  ["PLAYER_REGEN_ENABLED"] = function()
      if ClearWhenLeavingCombat() then
        -- only clear frames with icons
        x:Clear("outgoing")
        x:Clear("critical")
        x:Clear("loot")
        x:Clear("power")
      end
      if ShowCombatState() then
        x:AddMessage("general", sformat(format_fade, LEAVING_COMBAT), "combat_end")
      end
    end,
  ["PLAYER_REGEN_DISABLED"] = function()
      if ShowCombatState() then
        x:AddMessage("general", sformat(format_gain, ENTERING_COMBAT), "combat_begin")
      end
    end,
  ["UNIT_POWER"] = function(unit, powerType) UpdateUnitPower(unit, powerType) end,
  ["UNIT_COMBO_POINTS"] = function() UpdateComboPoints() end,
  ["PLAYER_TARGET_CHANGED"] = function() UpdateComboPoints() end,
  ["UNIT_AURA"] = function(unit) UpdateAuraTracking(unit) end,

  ["UNIT_ENTERED_VEHICLE"] = function(unit) if unit == "player" then x:UpdatePlayer() end end,
  ["UNIT_EXITING_VEHICLE"] = function(unit) if unit == "player" then x:UpdatePlayer() end end,
  ["PLAYER_ENTERING_WORLD"] = function()
      x:UpdatePlayer()
      x:UpdateComboPointOptions()
      x:Clear()
      
      -- Lazy Coding (Clear up messy libraries... yuck!)
      collectgarbage()
    end,
    
  ["ACTIVE_TALENT_GROUP_CHANGED"] = function() x:UpdatePlayer(); x:UpdateComboTracker() end,    -- x:UpdateComboPointOptions(true) end,
  
  ["CHAT_MSG_LOOT"] = function(msg)
    --format_loot
    local pM,iQ,iI,iN,iA = select(3, string.find(msg, format_loot))   -- Pre-Message, ItemColor, ItemID, ItemName, ItemAmount
	if not iI then return end
    local qq,_,_,tt,st,_,_,ic = select(3, GetItemInfo(iI))             -- Item Quality, See "GetAuctionItemClasses()" For Type and Subtype, Item Icon Texture Location
    
    -- Item filter
    local freeTicketToDisneyland = false 
    if x.db.profile.spells.items[tt] and x.db.profile.spells.items[tt][st] == true then
      freeTicketToDisneyland = true
    end
    
    local item       = { }
        item.name    = iN
        item.id      = iI
        item.amount  = tonumber(iA) or 1
        item.quality = qq
        item.type    = tt
        item.icon    = ic
        item.crafted = (pM == LOOT_ITEM_CREATED_SELF:gsub("%%.*", ""))
        item.self    = (pM == LOOT_ITEM_PUSHED_SELF:gsub("%%.*", "") or pM == LOOT_ITEM_SELF:gsub("%%.*", "") or pM == LOOT_ITEM_CREATED_SELF:gsub("%%.*", ""))
    
    -- Only let self looted items go through the "Always Show" filter
    if (freeTicketToDisneyland and item.self) or (ShowLootItems() and item.self and item.quality >= GetLootQuality()) or (item.type == "Quest" and ShowLootQuest() and item.self) or (item.crafted and ShowLootCrafted()) then
      local r, g, b = GetItemQualityColor(item.quality)
      local s = item.type..": ["..item.name.."] "
      
      if ShowColorBlindMoney() then
        s = item.type.." (".. _G["ITEM_QUALITY"..item.quality.."_DESC"] .."): ["..item.name.."] "
      end
      
      -- Add the Texture
      if not ShowLootIcons() then
        s = s .. "\124T" .. item.icon .. ":" .. GetLootIconSize() .. ":" .. GetLootIconSize() .. ":0:0:64:64:5:59:5:59\124t"
      end
  
      -- Amount Looted
      s = s .. " x " .. item.amount
  
      -- Purchased/quest items seem to get to your bags faster than looted items

      -- Total items in bag
      if ShowTotalItems() then
        -- queue the item to wait 1 second before showing
        if not x.lootUpdater then
          x.lootUpdater = CreateFrame("FRAME")
          x.lootUpdater.isRunning = false
          x.lootUpdater.items = { }
        end
        
        if not x.lootUpdater.isRunning then
          x.lootUpdater:SetScript("OnUpdate", LootFrame_OnUpdate)
        end
        
        tinsert(x.lootUpdater.items, {
            id = item.id,
            message = s,
            t = 0,
            r = r,
            g = g,
            b = b,
          })
      else
        -- Add the message
        x:AddMessage("loot", s, {r, g, b})
      end
        
    end
  
  
    end,
  ["CHAT_MSG_MONEY"] = function(msg)
      local g, s, c = tonumber(msg:match(GOLD_AMOUNT:gsub("%%d", "(%%d+)"))), tonumber(msg:match(SILVER_AMOUNT:gsub("%%d", "(%%d+)"))), tonumber(msg:match(COPPER_AMOUNT:gsub("%%d", "(%%d+)")))
      local money, o = (g and g * 10000 or 0) + (s and s * 100 or 0) + (c or 0), MONEY .. ": "
      
      -- TODO: Add a minimum amount of money
      
      if ShowColorBlindMoney() then
        o = o..(g and g.." G " or "")..(s and s.." S " or "")..(c and c.." C " or "")
      else
        o = o..GetCoinTextureString(money).." "
      end
      
      -- This only works on english clients :\
      if msg:find("share") then o = o.."(split)" end
      
      x:AddMessage("loot", o, {1, 1, 0}) -- yellow
    end,
    
    ["SPELL_ACTIVATION_OVERLAY_GLOW_SHOW"] = function(spellID)
        if spellID == 32379 then  -- Shadow Word: Death
          local name = GetSpellInfo(spellID)
          x:AddMessage("procs", name, "spell_cast")
        end
      end,
}

--[=====================================================[
 Event handlers - Combat Log Unfiltered Events
--]=====================================================]
x.outgoing_events = {
  ["SPELL_PERIODIC_HEAL"] = function(...)
      if ShowHealing() and ShowHots() then
        -- output = the output frame; list of incoming args
        local spellID, spellName, spellSchool, amount, overhealing, absorbed, critical = select(12, ...)
        local outputFrame, message, outputColor = "outgoing", amount, "heal_out"
        local merged = false
        
        -- TODO: Add Healing Filter

        -- Check for merge
        if x.db.profile.spells.enableMerger and x.db.profile.spells.merge[spellID] and x.db.profile.spells.merge[spellID].enabled then
          if critical and not MergeCriticalsByThemselves() or not critical then
            merged = true
            x:AddSpamMessage("outgoing", spellID, amount, outputColor)
          end
        end
        
        -- Abbrivate the message
        if ShowAbbrivatedDamage() then
          if (amount >= 1000000) then
            message = tostring(mfloor((amount + 500000) / 1000000)) .. x.db.profile.megaDamage.millionSymbol
          elseif (amount >= 1000) then
            message = tostring(mfloor((amount + 500) / 1000)) .. x.db.profile.megaDamage.thousandSymbol
          end
        end
        
        -- MergeCriticalsWithOutgoing, MergeCriticalsByThemselves, MergeDontMergeCriticals
        
        
        -- Check for Critical
        if critical then
          if not MergeDontMergeCriticals() and x.db.profile.spells.enableMerger and x.db.profile.spells.merge[spellID] and x.db.profile.spells.merge[spellID].enabled then
            -- Merge this critical entry
            x:AddSpamMessage("critical", spellID, amount, outputColor)
            
            -- We are done, after we check for criticals. We don't need to do anything else.
            return 
          else
            -- Don't merge criticals
            message = sformat(format_crit, x.db.profile.frames["critical"].critPrefix, message, x.db.profile.frames["critical"].critPostfix)
            outputFrame = "critical"
          end
        elseif merged then  -- return merged, non-crits
          return
        end
        
        -- Add Icons
        if x.db.profile.frames[outputFrame].iconsEnabled then
          if x.db.profile.frames[outputFrame].fontJustify == "LEFT" then
            message = x:GetSpellTextureFormatted(spellID, x.db.profile.frames[outputFrame].iconsSize) .. "  " .. message
          else
            message = message .. x:GetSpellTextureFormatted(spellID, x.db.profile.frames[outputFrame].iconsSize)
          end
        end
        
        x:AddMessage(outputFrame, message, outputColor)
      end
    end,
  ["SPELL_HEAL"] = function(...)
      if ShowHealing() then
        -- output = the output frame; list of incoming args
        local spellID, spellName, spellSchool, amount, overhealing, absorbed, critical = select(12, ...)
        local outputFrame, message, outputColor = "outgoing", amount, "heal_out"
        local merged = false
        
        -- TODO: Add Healing Filter
        
        -- Check for merge
        if x.db.profile.spells.enableMerger and x.db.profile.spells.merge[spellID] and x.db.profile.spells.merge[spellID].enabled then
          if critical and not MergeCriticalsByThemselves() or not critical then
            merged = true
            x:AddSpamMessage("outgoing", spellID, amount, outputColor)
          end
        end
        
        -- Abbrivate the message
        if ShowAbbrivatedDamage() then
          if (amount >= 1000000) then
            message = tostring(mfloor((amount + 500000) / 1000000)) .. x.db.profile.megaDamage.millionSymbol
          elseif (amount >= 1000) then
            message = tostring(mfloor((amount + 500) / 1000)) .. x.db.profile.megaDamage.thousandSymbol
          end
        end
        
                -- Check for Critical
        if critical then
          if not MergeDontMergeCriticals() and x.db.profile.spells.enableMerger and x.db.profile.spells.merge[spellID] and x.db.profile.spells.merge[spellID].enabled then
            -- Merge this critical entry
            x:AddSpamMessage("critical", spellID, amount, outputColor)
            
            -- We are done, after we check for criticals. We don't need to do anything else.
            return 
          else
            -- Don't merge criticals
            message = sformat(format_crit, x.db.profile.frames["critical"].critPrefix, message, x.db.profile.frames["critical"].critPostfix)
            outputFrame = "critical"
          end
        elseif merged then  -- return merged, non-crits
          return
        end
        
        -- Add Icons
        if x.db.profile.frames[outputFrame].iconsEnabled then
          if x.db.profile.frames[outputFrame].fontJustify == "LEFT" then
            message = x:GetSpellTextureFormatted(spellID, x.db.profile.frames[outputFrame].iconsSize) .. "  " .. message
          else
            message = message .. x:GetSpellTextureFormatted(spellID, x.db.profile.frames[outputFrame].iconsSize)
          end
        end
        
        x:AddMessage(outputFrame, message, outputColor)
      end
    end,
    
  ["SWING_DAMAGE"] = function(...)
      if ShowDamage() then
        local _, _, _, sourceGUID, _, sourceFlags, _, _, _, _, _,  amount, _, _, _, _, _, critical = ...
        local outputFrame, message, outputColor = "outgoing", amount, "out_damage"
        local merged = false
        
        -- Check for Pet Swings
        local spellID = 6603
        if (sourceGUID == UnitGUID("pet")) or sourceFlags == COMBATLOG_FILTER_MY_VEHICLE then
          if not ShowPetDamage() then return end
          spellID = 0
          critical = nil -- stupid spam fix for hunter pets
        end
        
        -- Abbrivate the message
        if ShowAbbrivatedDamage() then
          if (amount >= 1000000) then
            message = tostring(mfloor((amount + 500000) / 1000000)) .. x.db.profile.megaDamage.millionSymbol
          elseif (amount >= 1000) then
            message = tostring(mfloor((amount + 500) / 1000)) .. x.db.profile.megaDamage.thousandSymbol
          end
        end
        
        -- Check for Critical
        if critical then
          
          if not ShowSwingCrit() then return end
          
          if ShowSwingCritPrefix() then
            message = sformat(format_crit, x.db.profile.frames["critical"].critPrefix, message, x.db.profile.frames["critical"].critPostfix)
          end
          
          if not ShowSwingRedirected() then
            outputFrame = "critical"
          end
        end
        
        -- Are we filtering Auto Attacks in the Outgoing frame?
        if outputFrame == "outgoing" and not ShowAutoAttack() then return end;
        
        -- Check for merge
        if MergeMeleeSwings() then
          merged = true
          x:AddSpamMessage("outgoing", spellID, amount, outputColor)
        end
        
        -- Only show non-merged swings
        if merged and not critical then
          return
        end

        -- Add Icons
        if x.db.profile.frames[outputFrame].iconsEnabled then
          if x.db.profile.frames[outputFrame].fontJustify == "LEFT" then
            message = x:GetSpellTextureFormatted(spellID, x.db.profile.frames[outputFrame].iconsSize) .. "  " .. message
          else
            message = message .. x:GetSpellTextureFormatted(spellID, x.db.profile.frames[outputFrame].iconsSize)
          end
        end
        
        x:AddMessage(outputFrame, message, outputColor)
      end
    end,
  ["RANGE_DAMAGE"] = function(...)
      if ShowDamage() then
        local _, _, _, sourceGUID, _, sourceFlags, _, _, _, _, _,  spellID, _, _, amount, _, _, _, _, _, critical = ...
        local outputFrame, message, outputColor = "outgoing", amount, "out_damage"
        local merged = false
        
        -- Auto Shot is spellId == 75
        local autoShot = spellID == 75
        
        -- Abbrivate the message
        if ShowAbbrivatedDamage() then
          if (amount >= 1000000) then
            message = tostring(mfloor((amount + 500000) / 1000000)) .. x.db.profile.megaDamage.millionSymbol
          elseif (amount >= 1000) then
            message = tostring(mfloor((amount + 500) / 1000)) .. x.db.profile.megaDamage.thousandSymbol
          end
        end
        
        -- Check for Critical
        if critical then
          if autoShot and not ShowSwingCrit()then return end
          
          if not autoShot or autoShot and ShowSwingCritPrefix() then
            message = sformat(format_crit, x.db.profile.frames["critical"].critPrefix, message, x.db.profile.frames["critical"].critPostfix)
          end
          
          if not autoShot or not ShowSwingRedirected() and autoShot then
            outputFrame = "critical"
          end
        end
        
        -- Check for merge
        if MergeRangedAttacks() then
          merged = true
          x:AddSpamMessage(outputFrame, spellID, amount, outputColor, 6)
        end
        
        -- Only show non-merged swings
        if merged and not critical then
          return
        end
        
        -- Add Icons
        if x.db.profile.frames[outputFrame].iconsEnabled then
          if x.db.profile.frames[outputFrame].fontJustify == "LEFT" then
            message = x:GetSpellTextureFormatted(spellID, x.db.profile.frames[outputFrame].iconsSize) .. "  " .. message
          else
            message = message .. x:GetSpellTextureFormatted(spellID, x.db.profile.frames[outputFrame].iconsSize)
          end
        end
        
        x:AddMessage(outputFrame, message, outputColor)
      end
    end,
    
  ["SPELL_DAMAGE"] = function(...)
      if ShowDamage() then
        local _, _, _, sourceGUID, _, sourceFlags, _, destGUID, _, _, _,  spellID, _, spellSchool, amount, _, _, _, _, _, critical = ...
        local outputFrame, message, outputColor = "outgoing", amount, "out_damage"
        local merged = false
        
        -- Get special magic color
        if x.damagecolor[spellSchool] then
          outputColor = x.damagecolor[spellSchool]
        else
          outputColor = x.damagecolor[1]
        end
        
        -- Check for merge
        if x.db.profile.spells.enableMerger and x.db.profile.spells.merge[spellID] and x.db.profile.spells.merge[spellID].enabled then
          if critical and not MergeCriticalsByThemselves() or not critical then
            merged = true
            x:AddSpamMessage("outgoing", spellID, amount, outputColor)
          end
        end
        
        -- Abbrivate the Amount
        if ShowAbbrivatedDamage() then
          if (amount >= 1000000) then
            message = tostring(mfloor((amount + 500000) / 1000000)) .. x.db.profile.megaDamage.millionSymbol
          elseif (amount >= 1000) then
            message = tostring(mfloor((amount + 500) / 1000)) .. x.db.profile.megaDamage.thousandSymbol
          end
        end
        
        -- Check for Critical
        if critical then
          if not MergeDontMergeCriticals() and x.db.profile.spells.enableMerger and x.db.profile.spells.merge[spellID] and x.db.profile.spells.merge[spellID].enabled then
            -- Merge this critical entry
            x:AddSpamMessage("critical", spellID, amount, outputColor)
            
            -- We are done, after we check for criticals. We don't need to do anything else.
            return 
          else
            -- Don't merge criticals
            message = sformat(format_crit, x.db.profile.frames["critical"].critPrefix, message, x.db.profile.frames["critical"].critPostfix)
            outputFrame = "critical"
          end
        elseif merged then  -- return merged, non-crits
          return
        end
        
        -- Add Icons
        if x.db.profile.frames[outputFrame].iconsEnabled then
          if x.db.profile.frames[outputFrame].fontJustify == "LEFT" then
            message = x:GetSpellTextureFormatted(spellID, x.db.profile.frames[outputFrame].iconsSize) .. "  " .. message
          else
            message = message .. x:GetSpellTextureFormatted(spellID, x.db.profile.frames[outputFrame].iconsSize)
          end
        end
        
        x:AddMessage(outputFrame, message, outputColor)
      end
    end,
  ["SPELL_PERIODIC_DAMAGE"] = function(...)
      if ShowDamage() then
        local _, _, _, sourceGUID, _, sourceFlags, _, _, _, _, _,  spellID, _, spellSchool, amount, _, _, _, _, _, critical = ...
        local outputFrame, message, outputColor = "outgoing", amount, "out_damage"
        local merged = false
        
        -- Get special magic color
        if x.damagecolor[spellSchool] then
          outputColor = x.damagecolor[spellSchool]
        else
          outputColor = x.damagecolor[1]
        end
        
        -- Check for merge
        if x.db.profile.spells.enableMerger and x.db.profile.spells.merge[spellID] and x.db.profile.spells.merge[spellID].enabled then
          if critical and not MergeCriticalsByThemselves() or not critical then
            merged = true
            x:AddSpamMessage("outgoing", spellID, amount, outputColor)
          end
        end
        
        -- Abbrivate the message
        if ShowAbbrivatedDamage() then
          if (amount >= 1000000) then
            message = tostring(mfloor((amount + 500000) / 1000000)) .. x.db.profile.megaDamage.millionSymbol
          elseif (amount >= 1000) then
            message = tostring(mfloor((amount + 500) / 1000)) .. x.db.profile.megaDamage.thousandSymbol
          end
        end
        
        -- Check for Critical
        if critical then
          if not MergeDontMergeCriticals() and x.db.profile.spells.enableMerger and x.db.profile.spells.merge[spellID] and x.db.profile.spells.merge[spellID].enabled then
            -- Merge this critical entry
            x:AddSpamMessage("critical", spellID, amount, outputColor)
            
            -- We are done, after we check for criticals. We don't need to do anything else.
            return 
          else
            -- Don't merge criticals
            message = sformat(format_crit, x.db.profile.frames["critical"].critPrefix, message, x.db.profile.frames["critical"].critPostfix)
            outputFrame = "critical"
          end
        elseif merged then  -- return merged, non-crits
          return
        end

        -- Add Icons
        if x.db.profile.frames[outputFrame].iconsEnabled then
          if x.db.profile.frames[outputFrame].fontJustify == "LEFT" then
            message = x:GetSpellTextureFormatted(spellID, x.db.profile.frames[outputFrame].iconsSize) .. "  " .. message
          else
            message = message .. x:GetSpellTextureFormatted(spellID, x.db.profile.frames[outputFrame].iconsSize)
          end
        end
        
        x:AddMessage(outputFrame, message, outputColor)
      end
    end,
    
  ["SWING_MISSED"] = function(...)
      local _, _, _, sourceGUID, _, sourceFlags, _, _, _, _, _,  missType = ...
      local outputFrame, message, outputColor = "outgoing", _G["COMBAT_TEXT_"..missType], "out_misstype"
      
      -- Are we filtering Auto Attacks in the Outgoing frame?
      if not ShowAutoAttack() then return end;
      
      if missType == "IMMUNE" and not ShowImmunes() then return end
      if missType ~= "IMMUNE" and not ShowMisses() then return end
      
      -- Check for Pet Swings
      local spellID = 6603
      if (sourceGUID == UnitGUID("pet")) or sourceFlags == COMBATLOG_FILTER_MY_VEHICLE then
        if not ShowPetDamage() then return end
        spellID = PET_ATTACK_TEXTURE
      end
      
      -- Add Icons
      if x.db.profile.frames[outputFrame].iconsEnabled then
        if x.db.profile.frames[outputFrame].fontJustify == "LEFT" then
          message = x:GetSpellTextureFormatted(spellID, x.db.profile.frames[outputFrame].iconsSize) .. "  " .. message
        else
          message = message .. x:GetSpellTextureFormatted(spellID, x.db.profile.frames[outputFrame].iconsSize)
        end
      end
      
      x:AddMessage(outputFrame, message, outputColor)
    end,
  ["SPELL_MISSED"] = function(...)
      local _, _, _, sourceGUID, _, sourceFlags, _, _, _, _, _,  spellID, _, _, missType = ...
      local outputFrame, message, outputColor = "outgoing", _G[missType], "out_misstype"
      
      if missType == "IMMUNE" and not ShowImmunes() then return end
      if missType ~= "IMMUNE" and not ShowMisses() then return end
      
      -- Add Icons
      if x.db.profile.frames[outputFrame].iconsEnabled then
        if x.db.profile.frames[outputFrame].fontJustify == "LEFT" then
          message = x:GetSpellTextureFormatted(spellID, x.db.profile.frames[outputFrame].iconsSize) .. "  " .. message
        else
          message = message .. x:GetSpellTextureFormatted(spellID, x.db.profile.frames[outputFrame].iconsSize)
        end
      end
      
      x:AddMessage(outputFrame, message, outputColor)
    end,
  ["RANGE_MISSED"] = function(...)
      local _, _, _, sourceGUID, _, sourceFlags, _, _, _, _, _,  spellID, _, _, missType = ...
      local outputFrame, message, outputColor = "outgoing", _G[missType], "out_misstype"
      
      if missType == "IMMUNE" and not ShowImmunes() then return end
      if missType ~= "IMMUNE" and not ShowMisses() then return end
      
      -- Add Icons
      if x.db.profile.frames[outputFrame].iconsEnabled then
        if x.db.profile.frames[outputFrame].fontJustify == "LEFT" then
          message = x:GetSpellTextureFormatted(spellID, x.db.profile.frames[outputFrame].iconsSize) .. "  " .. message
        else
          message = message .. x:GetSpellTextureFormatted(spellID, x.db.profile.frames[outputFrame].iconsSize)
        end
      end
      
      x:AddMessage(outputFrame, message, outputColor)
    end,
  ["SPELL_DISPEL"] = function(...)
      if not ShowDispells() then return end
  
      local _, _, _, sourceGUID, _, sourceFlags, _, _, _, _, _,  target, _, _, spellID, effect, _, etype = ...
      local outputFrame, message, outputColor = "general", sformat(format_dispell, XCT_DISPELLED, effect), "dispell_debuff"
      
      -- Check for buff or debuff (for color)
      if etype == "BUFF" then
        outputColor = "dispell_buff"
      end
      
      -- Add Icons
      if x.db.profile.frames[outputFrame].iconsEnabled then
        if x.db.profile.frames[outputFrame].fontJustify == "LEFT" then
          message = x:GetSpellTextureFormatted(spellID, x.db.profile.frames[outputFrame].iconsSize) .. "  " .. message
        else
          message = message .. x:GetSpellTextureFormatted(spellID, x.db.profile.frames[outputFrame].iconsSize)
        end
      end
      
      x:AddMessage(outputFrame, message, outputColor)
    end,
  ["SPELL_STOLEN"] = function(...)
      if not ShowDispells() then return end
      
      local _, _, _, sourceGUID, _, sourceFlags, _, _, _, _, _,  target, _, _, spellID, effect = ...
      local outputFrame, message, outputColor = "general", sformat(format_dispell, XCT_STOLE, effect), "spell_stolen"
      
      -- Add Icons
      if x.db.profile.frames[outputFrame].iconsEnabled then
        if x.db.profile.frames[outputFrame].fontJustify == "LEFT" then
          message = x:GetSpellTextureFormatted(spellID, x.db.profile.frames[outputFrame].iconsSize) .. "  " .. message
        else
          message = message .. x:GetSpellTextureFormatted(spellID, x.db.profile.frames[outputFrame].iconsSize)
        end
      end
      
      x:AddMessage(outputFrame, message, outputColor)
    end,
  ["SPELL_INTERRUPT"] = function(...)
      if not ShowInterrupts() then return end
  
      local _, _, _, sourceGUID, _, sourceFlags, _, _, _, _, _,  target, _, _, spellID, effect = ...
      local outputFrame, message, outputColor = "general", sformat(format_dispell, INTERRUPTED, effect), "spell_interrupt"
      
      -- Add Icons
      if x.db.profile.frames[outputFrame].iconsEnabled then
        if x.db.profile.frames[outputFrame].fontJustify == "LEFT" then
          message = x:GetSpellTextureFormatted(spellID, x.db.profile.frames[outputFrame].iconsSize) .. "  " .. message
        else
          message = message .. x:GetSpellTextureFormatted(spellID, x.db.profile.frames[outputFrame].iconsSize)
        end
      end
      
      x:AddMessage(outputFrame, message, outputColor)
    end,
  ["PARTY_KILL"] = function(...)
      if not ShowPartyKill() then return end
  
      local _, _, _, sourceGUID, _, sourceFlags, _, destGUID, name = ...
      local outputFrame, message, outputColor = "general", sformat(format_dispell, XCT_KILLED, name), "party_kill"
      
      -- Color the text according to class that got killed
      if destGUID then
        local index = select(2, GetPlayerInfoByGUID(destGUID))
        if RAID_CLASS_COLORS[index] then
          outputColor = {RAID_CLASS_COLORS[index].r, RAID_CLASS_COLORS[index].g, RAID_CLASS_COLORS[index].b}
        end
      end
      
      x:AddMessage(outputFrame, message, outputColor)
    end,
}
