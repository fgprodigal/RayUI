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
local _, _G, sformat, mfloor, ssub, smatch, sgsub, s_upper, s_lower, string, tinsert, ipairs, pairs, print, tostring, tonumber, select, unpack =
  nil, _G, string.format, math.floor, string.sub, string.match, string.gsub, string.upper, string.lower, string, table.insert, ipairs, pairs, print, tostring, tonumber, select, unpack

--[=====================================================[
 Holds cached spells, buffs, and debuffs
--]=====================================================]
x.spellCache = {
  buffs = { },
  debuffs = { },
  spells = { },
  procs = { },
  items = { },
}

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
    f:RegisterEvent("UNIT_POWER")
    f:RegisterEvent("PLAYER_REGEN_DISABLED")
    f:RegisterEvent("PLAYER_REGEN_ENABLED")
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
 Fast Boolean Lookups
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
local function ShowHealingRealmNames() return x.db.profile.frames["healing"].enableRealmNames end
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
local function ShowLootItems() return x.db.profile.frames["loot"].showItems end
local function ShowLootItemTypes() return x.db.profile.frames["loot"].showItemTypes end
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
local function ShowOverHealing() return x.db.profile.frames["healing"].enableOverHeal end

local function ShowRogueComboPoints() return x.db.profile.spells.combo["ROGUE"][COMBAT_TEXT_SHOW_COMBO_POINTS_TEXT] and x.player.class == "ROGUE" end
local function ShowFeralComboPoints() return x.db.profile.spells.combo["DRUID"][2][COMBAT_TEXT_SHOW_COMBO_POINTS_TEXT] and x.player.class == "DRUID" and x.player.spec == 2 end
local function ShowMonkChi() return x.db.profile.spells.combo["MONK"][CHI] and x.player.class == "MONK" end
local function ShowPaladinHolyPower() return x.db.profile.spells.combo["PALADIN"][HOLY_POWER] and x.player.class == "PALADIN" end
local function ShowPriestShadowOrbs() return x.db.profile.spells.combo["PRIEST"][3][SHADOW_ORBS] and x.player.class == "PRIEST" and x.player.spec == 3 end
local function ShowWarlockSoulShards() return x.db.profile.spells.combo["WARLOCK"][1][SOUL_SHARDS] and x.player.class == "WARLOCK" and x.player.spec == 1 end
local function ShowWarlockDemonicFury() return x.db.profile.spells.combo["WARLOCK"][2][DEMONIC_FURY] and x.player.class == "WARLOCK" and x.player.spec == 2 end
local function ShowWarlockBurningEmbers() return x.db.profile.spells.combo["WARLOCK"][3][BURNING_EMBERS] and x.player.class == "WARLOCK" and x.player.spec == 3 end

local function ClearWhenLeavingCombat() return x.db.profile.frameSettings.clearLeavingCombat end

local function MergeIncomingHealing() return x.db.profile.spells.mergeHealing end
local function MergeMeleeSwings() return x.db.profile.spells.mergeSwings end
local function MergeRangedAttacks() return x.db.profile.spells.mergeRanged end
local function MergeCriticalsWithOutgoing() return x.db.profile.spells.mergeCriticalsWithOutgoing end
local function MergeCriticalsByThemselves() return x.db.profile.spells.mergeCriticalsByThemselves end
local function MergeDontMergeCriticals() return x.db.profile.spells.mergeDontMergeCriticals end
local function MergeDispells() return x.db.profile.spells.mergeDispells end

local function FilterPlayerPower(value) return x.db.profile.spellFilter.filterPowerValue > value end
local function FilterOutgoingDamage(value) return x.db.profile.spellFilter.filterOutgoingDamageValue > value end
local function FilterOutgoingHealing(value) return x.db.profile.spellFilter.filterOutgoingHealingValue > value end
local function FilterIncomingDamage(value) return x.db.profile.spellFilter.filterIncomingDamageValue > value end
local function FilterIncomingHealing(value) return x.db.profile.spellFilter.filterIncomingHealingValue > value end
local function TrackSpells() return x.db.profile.spellFilter.trackSpells end

local function IsBearForm() return GetShapeshiftForm() == 1 and x.player.class == "DRUID" end
local function IsSpellFiltered(spellID)
  local spell = x.db.profile.spellFilter.listSpells[tostring(spellID)]
  if x.db.profile.spellFilter.whitelistSpells then
    return not spell
  end
  return spell
end
local function IsBuffFiltered(name)
  local spell = x.db.profile.spellFilter.listBuffs[name]
  if x.db.profile.spellFilter.whitelistBuffs then
    return not spell
  end
  return spell
end
local function IsDebuffFiltered(name)
  local spell = x.db.profile.spellFilter.listDebuffs[name]
  if x.db.profile.spellFilter.whitelistDebuffs then
    return not spell
  end
  return spell
end
local function IsProcFiltered(name)
  local spell = x.db.profile.spellFilter.listProcs[name]
  if x.db.profile.spellFilter.whitelistProcs then
    return not spell
  end
  return spell
end
local function IsItemFiltered(name)
  local spell = x.db.profile.spellFilter.listItems[name]
  if x.db.profile.spellFilter.whitelistItems then
    return not spell
  end
  return spell
end

local function IsMerged(spellID)
	return ( x.db.profile.spells.enableMerger ) and
		(	-- Check to see if it is a merged spell
			x.db.profile.spells.merge[spellID] and
			x.db.profile.spells.merge[spellID].enabled
		)
		or
		(	-- Check to see if it is a two hand weapon
			addon.merge2h[spellID] and
			x.db.profile.spells.merge[addon.merge2h[spellID]] and
			x.db.profile.spells.merge[addon.merge2h[spellID]].enabled
		)
end

local function UseStandardSpellColors() return not x.db.profile.frames["outgoing"].standardSpellColor end
local function GetCustomSpellColorFromIndex(index)
	if index == 1 then
    return x.LookupColorByName('SpellSchool_Physical')
	elseif index == 2 then
    return x.LookupColorByName('SpellSchool_Holy')
	elseif index == 4 then
    return x.LookupColorByName('SpellSchool_Fire')
	elseif index == 8 then
    return x.LookupColorByName('SpellSchool_Nature')
	elseif index == 16 then
    return x.LookupColorByName('SpellSchool_Frost')
	elseif index == 32 then
    return x.LookupColorByName('SpellSchool_Shadow')
	elseif index == 64 then
    return x.LookupColorByName('SpellSchool_Arcane')
	else
    return x.LookupColorByName('SpellSchool_Physical')
	end
end


--[=====================================================[
 String Formatters
--]=====================================================]
local format_loot = "([^|]*)|cff(%x*)|H([^:]*):(%d+):%d+:(%d+):[-?%d+:]+|h%[?([^%]]*)%]|h|r?%s?x?(%d*)%.?"
local format_pet  = sformat("|cff798BDD[%s]:|r %%s (%%s)", sgsub(BATTLE_PET_CAGE_ITEM_NAME," %%s","")) -- [Caged]: Pet Name (Pet Family)

local format_fade         = "-%s"
local format_gain         = "+%s"
local format_gain_rune    = "%s +%s %s"
local format_resist       = "-%s (%s %s)"
local format_energy       = "+%s %s"
local format_honor        = sgsub(COMBAT_TEXT_HONOR_GAINED, "%%s", "+%%s")
local format_faction_add  = "%s +%s"
local format_faction_sub  = "%s %s"
local format_crit         = "%s%s%s"
local format_dispell      = "%s: %s"
local format_quality      = "ITEM_QUALITY%s_DESC"
local format_remove_realm = "(.*)-.*"

local format_spell_icon   = " |T%s:%d:%d:0:0:64:64:5:59:5:59|t"
local format_loot_icon    = "|T%s:%d:%d:0:0:64:64:5:59:5:59|t"
local format_lewtz        = "%s%s: %s [%s]%s%%s"
local format_lewtz_amount = " |cff798BDDx%s|r"
local format_lewtz_total  = " |cffFFFF00(%s)|r"
local format_lewtz_blind  = "(%s)"
local format_crafted      = (LOOT_ITEM_CREATED_SELF:gsub("%%.*", ""))
local format_looted       = (LOOT_ITEM_SELF:gsub("%%.*", ""))
local format_pushed       = (LOOT_ITEM_PUSHED_SELF:gsub("%%.*", ""))


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
    message = sformat(format_spell_icon, PET_ATTACK_TEXTURE, iconSize, iconSize)
  else
    local icon = GetSpellTexture(spellID)
    if icon then
      message = sformat(format_spell_icon, icon, iconSize, iconSize)
    else
      message = sformat(format_spell_icon, x.BLANK_ICON, iconSize, iconSize)
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
    local comboPoints, outputColor = GetComboPoints(x.player.unit, "target"), "comboPoints"
    if comboPoints == MAX_COMBO_POINTS then outputColor = "comboPointsMax" end
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
      value = UnitPower(x.player.unit, SPELL_POWER_SOUL_SHARDS) / 100
    elseif powertype == "DEMONIC_FURY" and ShowWarlockDemonicFury() then
      value = UnitPower(x.player.unit, SPELL_POWER_DEMONIC_FURY) / 100
    elseif powertype == "BURNING_EMBERS" and ShowWarlockBurningEmbers() then
      value = UnitPower(x.player.unit, SPELL_POWER_BURNING_EMBERS)
    end

    if value then
      if value < 1 then
        if value == 0 then
          x:AddMessage("class", " ", "comboPoints")
        else
          x:AddMessage("class", "0", "comboPoints")
        end
      else
        x:AddMessage("class", mfloor(value), "comboPoints")
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
        x:AddMessage("class", count, "comboPoints")
      else
        x:AddMessage("class", " ", "comboPoints")
      end
        
    -- Fix issue of not reseting when unit disapears (e.g. dismiss pet)
    elseif not UnitExists(entry.unit) then
      x:AddMessage("class", " ", "comboPoints")
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

--[=====================================================[
 Looted Item - Latency Update Adpation
--]=====================================================]
local function LootFrame_OnUpdate(self, elapsed)
  local removeItems = { }
  for i, item in ipairs(self.items) do
    item.t = item.t + elapsed
    
    -- Time to wait before showing a looted item
    if item.t > 0.5 then
      x:AddMessage("loot", sformat(item.message, sformat(format_lewtz_total, GetItemCount(item.id))), {item.r, item.g, item.b})
      removeItems[i] = true
    end
  end
  
  for k in pairs(removeItems) do
    self.items[k] = nil
  end
  
  if #removeItems > 1 then
    local index, newList = 1, { }
    
    -- Rebalance the Lua list
    for _, v in pairs(self.items) do
      newList[index] = v
      index = index + 1
    end
    
    self.items = newList
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
      if FilterIncomingDamage(amount) then return end
      x:AddMessage("damage", sformat(format_fade, x:Abbreviate(amount,"damage")), "damageTaken")
    end,
  ["DAMAGE_CRIT"] = function(amount)
      if FilterIncomingDamage(amount) then return end
      x:AddMessage("damage", sformat(format_fade, x:Abbreviate(amount,"damage")), "damageTakenCritical")
    end,
  ["SPELL_DAMAGE"] = function(amount)
      if FilterIncomingDamage(amount) then return end
      x:AddMessage("damage", sformat(format_fade, x:Abbreviate(amount,"damage")), "spellDamageTaken")
    end,
  ["SPELL_DAMAGE_CRIT"] = function(amount)
      if FilterIncomingDamage(amount) then return end
      x:AddMessage("damage", sformat(format_fade, x:Abbreviate(amount,"damage")), "spellDamageTakenCritical")
    end,
  ["ABSORB_ADDED"] = function(healer_name, amount)
      local message = sformat(format_gain, x:Abbreviate(amount,"healing"))
      
      if not ShowHealingRealmNames() then
        healer_name = smatch(healer_name, format_remove_realm) or healer_name
      end
      
      -- TODO: Add merge shields
      
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
      
      x:AddMessage("healing", message, "shieldTaken")
    end,
  ["HEAL"] = function(healer_name, amount)
      if FilterIncomingHealing(amount) then return end
  
      local message = sformat(format_gain, x:Abbreviate(amount,"healing"))
      
      if not ShowHealingRealmNames() then
        healer_name = smatch(healer_name, format_remove_realm) or healer_name
      end
      
      if MergeIncomingHealing() then
        x:AddSpamMessage("healing", healer_name, amount, "healingTaken", 5)
      else
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
        x:AddMessage("healing", message, "healingTaken")
      end
    end,
  ["HEAL_CRIT"] = function(healer_name, amount)
      if FilterIncomingHealing(amount) then return end
      
      local message = sformat(format_gain, x:Abbreviate(amount,"healing"))
      
      if not ShowHealingRealmNames() then
        healer_name = smatch(healer_name, format_remove_realm) or healer_name
      end
      
      if MergeIncomingHealing() then
        x:AddSpamMessage("healing", healer_name, amount, "healingTaken", 5)
      else
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
        x:AddMessage("healing", message, "healingTakenCritical")
      end
    end,
  ["PERIODIC_HEAL"] = function(healer_name, amount)
      if FilterIncomingHealing(amount) then return end
      
      local message = sformat(format_gain, x:Abbreviate(amount,"healing"))
      
      if not ShowHealingRealmNames() then
        healer_name = smatch(healer_name, format_remove_realm) or healer_name
      end
      
      if MergeIncomingHealing() then
        x:AddSpamMessage("healing", healer_name, amount, "healingTaken", 5)
      else
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
        
        x:AddMessage("healing", message, "healingTakenPeriodic")
      end
    end,
  ["SPELL_ACTIVE"] = function(spellName)
      if TrackSpells() then x.spellCache.procs[spellName] = true end
      if IsProcFiltered(spellName) then return end

      local message = spellName
      
      -- Add Stacks
      local icon, spellStacks = select(3, UnitAura("player", spellName))
      if spellStacks and tonumber(spellStacks) > 1 then
        message = spellName .. " |cffFFFFFFx" .. spellStacks .. "|r"
      end

      -- Add Icons
      if icon and x.db.profile.frames["procs"].iconsEnabled then
        if x.db.profile.frames["procs"].fontJustify == "LEFT" then
          message = sformat(format_spell_icon, icon, iconSize, iconSize) .. "  " .. message
        else
          message = message .. sformat(format_spell_icon, icon, iconSize, iconSize)
        end
      end

      x:AddMessage("procs", message, "spellProc")
    end,
  ["SPELL_CAST"] = function(spellName) if ShowReactives() then x:AddMessage("procs", spellName, "spellReactive") end end,
  
  ["MISS"] = function() if ShowMissTypes() then x:AddMessage("damage", MISS, "missTypeMiss") end end,
  ["DODGE"] = function() if ShowMissTypes() then x:AddMessage("damage", DODGE, "missTypeDodge") end end,
  ["PARRY"] = function() if ShowMissTypes() then x:AddMessage("damage", PARRY, "missTypeParry") end end,
  ["EVADE"] = function() if ShowMissTypes() then x:AddMessage("damage", EVADE, "missTypeEvade") end end,
  ["IMMUNE"] = function() if ShowMissTypes() then x:AddMessage("damage", IMMUNE, "missTypeImmune") end end,
  ["DEFLECT"] = function() if ShowMissTypes() then x:AddMessage("damage", DEFLECT, "missTypeDeflect") end end,
  ["REFLECT"] = function() if ShowMissTypes() then x:AddMessage("damage", REFLECT, "missTypeReflect") end end,
  
  ["SPELL_MISS"] = function() if ShowMissTypes() then x:AddMessage("damage", MISS, "missTypeMiss") end end,
  ["SPELL_DODGE"] = function() if ShowMissTypes() then x:AddMessage("damage", DODGE, "missTypeDodge") end end,
  ["SPELL_PARRY"] = function() if ShowMissTypes() then x:AddMessage("damage", PARRY, "missTypeParry") end end,
  ["SPELL_EVADE"] = function() if ShowMissTypes() then x:AddMessage("damage", EVADE, "missTypeEvade") end end,
  ["SPELL_IMMUNE"] = function() if ShowMissTypes() then x:AddMessage("damage", IMMUNE, "missTypeImmune") end end,
  ["SPELL_DEFLECT"] = function() if ShowMissTypes() then x:AddMessage("damage", DEFLECT, "missTypeDeflect") end end,
  ["SPELL_REFLECT"] = function() if ShowMissTypes() then x:AddMessage("damage", REFLECT, "missTypeReflect") end end,

  ["RESIST"] = function(amount, resisted)
      if resisted then
        if ShowResistances() then
          x:AddMessage("damage", sformat(format_resist, x:Abbreviate(amount,"damage"), RESIST, x:Abbreviate(resisted,"damage")), "resist_generic")
        else
          x:AddMessage("damage", x:Abbreviate(amount,"damage"), "damage")
        end
      elseif ShowResistances() then
        x:AddMessage("damage", RESIST, "missTypeResist")
      end
    end,
  ["BLOCK"] = function(amount, resisted)
      if resisted then
        if ShowResistances() then
          x:AddMessage("damage", sformat(format_resist, x:Abbreviate(amount,"damage"), BLOCK, x:Abbreviate(resisted,"damage")), "resist_generic")
        else
          x:AddMessage("damage", x:Abbreviate(amount,"damage"), "damage")
        end
      elseif ShowResistances() then
        x:AddMessage("damage", BLOCK, "missTypeBlock")
      end
    end,
  ["ABSORB"] = function(amount, resisted)
      if resisted then
        if ShowResistances() then
          x:AddMessage("damage", sformat(format_resist, x:Abbreviate(amount,"damage"), ABSORB, x:Abbreviate(resisted,"damage")), "resist_generic")
        else
          x:AddMessage("damage", x:Abbreviate(amount,"damage"), "damage")
        end
      elseif ShowResistances() then
        x:AddMessage("damage", ABSORB, "missTypeAbsorb")
      end
    end,
  ["SPELL_RESIST"] = function(amount, resisted)
      if resisted then
        if ShowResistances() then
          x:AddMessage("damage", sformat(format_resist, x:Abbreviate(amount,"damage"), RESIST, x:Abbreviate(resisted,"damage")), "resist_spell")
        else
          x:AddMessage("damage", x:Abbreviate(amount,"damage"), "damage")
        end
      elseif ShowResistances() then
        x:AddMessage("damage", RESIST, "missTypeResist")
      end
    end,
  ["SPELL_BLOCK"] = function(amount, resisted)
      if resisted then
        if ShowResistances() then
          x:AddMessage("damage", sformat(format_resist, x:Abbreviate(amount,"damage"), BLOCK, x:Abbreviate(resisted,"damage")), "resist_spell")
        else
          x:AddMessage("damage", x:Abbreviate(amount,"damage"), "damage")
        end
      elseif ShowResistances() then
        x:AddMessage("damage", BLOCK, "missTypeBlock")
      end
    end,
  ["SPELL_ABSORB"] = function(amount, resisted)
      if resisted then
        if ShowResistances() then
          x:AddMessage("damage", sformat(format_resist, x:Abbreviate(amount,"damage"), ABSORB, x:Abbreviate(resisted,"damage")), "resist_spell")
        else
          x:AddMessage("damage", x:Abbreviate(amount,"damage"), "damage")
        end
      elseif ShowResistances() then
        x:AddMessage("damage", ABSORB, "missTypeAbsorb")
      end
    end,
  ["ENERGIZE"] = function(amount, energy_type)
      if not FilterPlayerPower(tonumber(amount)) then
        if energy_type and (energy_type == "MANA" and not IsBearForm()) -- do not show mana in bear form (Leader of the Pack)                                     
            or energy_type == "RAGE" or energy_type == "FOCUS"
            or energy_type == "ENERGY" or energy_type == "RUINIC_POWER"
            or energy_type == "SOUL_SHARDS" or energy_type == "HOLY_POWER" then
          local message, color = x:Abbreviate(amount,"power"), {PowerBarColor[energy_type].r, PowerBarColor[energy_type].g, PowerBarColor[energy_type].b}

          x:AddMessage("power", sformat(format_energy, message, _G[energy_type]), color)
        end
      end
    end,
  ["PERIODIC_ENERGIZE"] = function(amount, energy_type)
      if not FilterPlayerPower(tonumber(amount)) then
        if energy_type and (energy_type == "MANA" and not IsBearForm()) -- do not show mana in bear form (Leader of the Pack)
            or energy_type == "RAGE" or energy_type == "FOCUS"
            or energy_type == "ENERGY" or energy_type == "RUINIC_POWER"
            or energy_type == "SOUL_SHARDS" or energy_type == "HOLY_POWER" then
          local message, color = x:Abbreviate(amount,"power"), {PowerBarColor[energy_type].r, PowerBarColor[energy_type].g, PowerBarColor[energy_type].b}

          x:AddMessage("power", sformat(format_energy, message, _G[energy_type]), color)
        end
      end
    end,

  ["SPELL_AURA_END"] = function(spellname)
      if TrackSpells() then
        x.spellCache.buffs[spellname] = true
      end
      if ShowBuffs() and not IsBuffFiltered(spellname) then
        x:AddMessage('general', sformat(format_fade, spellname), 'buffsFaded')
      end
    end,
  ["SPELL_AURA_START"] = function(spellname)
      if TrackSpells() then
        x.spellCache.buffs[spellname] = true
      end
      if ShowBuffs() and not IsBuffFiltered(spellname) then
        x:AddMessage('general', sformat(format_gain, spellname), 'buffsGained')
      end
    end,
  ["SPELL_AURA_END_HARMFUL"] = function(spellname)
      if TrackSpells() then
        x.spellCache.debuffs[spellname] = true
      end
      if ShowDebuffs() and not IsDebuffFiltered(spellname) then
        x:AddMessage('general', sformat(format_fade, spellname), 'debuffsFaded')
      end
    end,
  ["SPELL_AURA_START_HARMFUL"] = function(spellname)
      if TrackSpells() then
        x.spellCache.debuffs[spellname] = true
      end
      if ShowDebuffs() and not IsDebuffFiltered(spellname) then
        x:AddMessage('general', sformat(format_gain, spellname), 'debuffsGained')
      end
    end,
  
  -- TODO: Create a merger for faction and honor xp
  ["HONOR_GAINED"] = function(amount)
      local num = mfloor(tonumber(amount) or 0)
      if num > 0 and ShowHonor() then
        x:AddMessage('general', sformat(format_honor, HONOR, x:Abbreviate(amount,"general")), 'honorGains')
      end
    end,
  ["FACTION"] = function(faction, amount)
      local num = mfloor(tonumber(amount) or 0)
      if num > 0 and ShowFaction() then
        x:AddMessage('general', sformat(format_faction_add, faction, x:Abbreviate(amount,'general')), 'reputationGain')
      elseif num < 0 and ShowFaction() then
        x:AddMessage('general', sformat(format_faction_sub, faction, x:Abbreviate(amount,'general')), 'reputationLoss')
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
          x:AddMessage('general', HEALTH_LOW, 'lowResourcesHealth')
          x.lowHealth = true
        end
      else
        x.lowHealth = false
      end
    end,
  ["UNIT_POWER"] = function(unit, powerType)
      -- Update for Class Combo Points
      UpdateUnitPower(unit, powerType)
  
      if select(2, UnitPowerType(x.player.unit)) == "MANA" and ShowLowResources() and UnitPower(x.player.unit) / UnitPowerMax(x.player.unit) <= COMBAT_TEXT_LOW_MANA_THRESHOLD then
        if not x.lowMana then
          x:AddMessage('general', MANA_LOW, 'lowResourcesMana')
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
      x.inCombat = false
      x:CombatStateChanged()
      if ClearWhenLeavingCombat() then
        -- only clear frames with icons
        x:Clear('outgoing')
        x:Clear('critical')
        x:Clear('loot')
        x:Clear('power')
      end
      if ShowCombatState() then
        x:AddMessage('general', sformat(format_fade, LEAVING_COMBAT), 'combatLeaving')
      end
    end,
  ["PLAYER_REGEN_DISABLED"] = function()
      x.inCombat = true
      x:CombatStateChanged()
      if ShowCombatState() then
        x:AddMessage('general', sformat(format_gain, ENTERING_COMBAT), 'combatEntering')
      end
    end,
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
      -- Format Loot
      local preMessage, linkColor, linkType, linkID, linkQuality, itemName, amount = select(3, string.find(msg, format_loot))
      
	  if TrackSpells() then
        x.spellCache.items[linkID] = true
      end
	  
	  if IsItemFiltered( linkID ) then return end
	  
      -- Check to see if this is a battle pet
      if linkType == "battlepet" then
        local speciesName, speciesIcon, petType = C_PetJournal.GetPetInfoBySpeciesID(linkID)
        local petTypeName = PET_TYPE_SUFFIX[petType]
        local message = sformat(format_pet, speciesName, petTypeName)
        
        local r, g, b = GetItemQualityColor(linkQuality)
        
        -- Add the message
        x:AddMessage("loot", message, { r, g, b } )
        return
      end
    
      -- Check to see if this is a item
      if linkType == "item" then
        local crafted, looted, pushed = (preMessage == format_crafted), (preMessage == format_looted), (preMessage == format_pushed)
        
        -- Item Quality, See "GetAuctionItemClasses()" For Type and Subtype, Item Icon Texture Location
        local itemQuality, _, _, itemType, itemSubtype, _, _, itemTexture = select(3, GetItemInfo(linkID))
        
        -- Item White-List Filter
        local listed = x.db.profile.spells.items[itemType] and (x.db.profile.spells.items[itemType][itemSubtype] == true)
        
        -- Fix the Amount of a item looted
        amount = tonumber(amount) or 1
        
        -- Only let self looted items go through the "Always Show" filter
        if (listed and looted) or (ShowLootItems() and looted and itemQuality >= GetLootQuality()) or (itemType == "Quest" and ShowLootQuest() and looted) or (crafted and ShowLootCrafted()) then
          local r, g, b = GetItemQualityColor(itemQuality)
          -- "%s%s: %s [%s]%s %%s"
          local message = sformat(format_lewtz,
              ShowLootItemTypes() and itemType or "Item",		-- Item Type
              ShowColorBlindMoney()                     -- Item Quality (Color Blind)
                and sformat(format_lewtz_blind,
                              _G[sformat(format_quality,
                                         itemQuality)]
                           )
                or "",
              ShowLootIcons()                           -- Icon
                and sformat(format_loot_icon,
                            itemTexture,
                            GetLootIconSize(),
                            GetLootIconSize())
                or "",
              itemName,                                 -- Item Name
              sformat(format_lewtz_amount, amount)      -- Amount Looted
            )
            
          -- Purchased/quest items seem to get to your bags faster than looted items
          if ShowTotalItems() then
          
            -- This frame was created to make sure I always display the correct number of an item in your bag
            if not x.lootUpdater then
              x.lootUpdater = CreateFrame("FRAME")
              x.lootUpdater.isRunning = false
              x.lootUpdater.items = { }
            end
            
            if not x.lootUpdater.isRunning then
              x.lootUpdater:SetScript("OnUpdate", LootFrame_OnUpdate)
              x.lootUpdater.isRunning = true
            end
            
            -- Enqueue the item to wait 1 second before showing
            tinsert(x.lootUpdater.items, { id=linkID, message=message, t=0, r=r, g=g, b=b, })
          else
          
            -- Add the message
            x:AddMessage("loot", sformat(message, ""), {r, g, b})
          end
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
        x:AddMessage("procs", name, "spellProc")
      end
    end,
}

--[=====================================================[
 Event handlers - Combat Log Unfiltered Events
--]=====================================================]
x.outgoing_events = {
  ["SPELL_PERIODIC_HEAL"] = function(...)
      if not ShowHealing() or not ShowHots() then return end
      
      local spellID, spellName, spellSchool, amount, overhealing, absorbed, critical = select(12, ...)
      local outputFrame, message, outputColor = "outgoing", amount, "healingOutPeriodic"
      local merged = false

      -- Keep track of spells that go by
      if TrackSpells() then x.spellCache.spells[spellID] = true end

      -- Filter Ougoing Healing
      if FilterOutgoingHealing(amount) then return end
      
      -- Spell Specific Filter
      if IsSpellFiltered(spellID) then return end
      
      -- Check for Overhealing
      if not ShowOverHealing() then
        local realamount = amount - overhealing
        if realamount < 1 then
          return
        end
        message = realamount
      end
      
      -- Check for merge
      if IsMerged(spellID) then
        if not critical or critical and not MergeCriticalsByThemselves() then
          merged = true
          x:AddSpamMessage("outgoing", spellID, message, outputColor)
        end
      end
      
      -- Check for Critical
      if critical then
        if not MergeDontMergeCriticals() and IsMerged(spellID) then
          -- Merge this critical entry
          x:AddSpamMessage("critical", spellID, message, outputColor)
          
          -- We are done, after we check for criticals. We don't need to do anything else.
          return 
        else
          -- Don't merge criticals
          message = sformat(format_crit, x.db.profile.frames["critical"].critPrefix, x:Abbreviate(message, "critical"), x.db.profile.frames["critical"].critPostfix)
          outputFrame = "critical"
        end
      elseif merged then  -- return merged, non-crits
        return
      else
        message = x:Abbreviate(message, "outgoing")
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
    
  ["SPELL_HEAL"] = function(...)
      if not ShowHealing() then return end

      local spellID, spellName, spellSchool, amount, overhealing, absorbed, critical = select(12, ...)
      local outputFrame, message, outputColor = "outgoing", amount, "healingOut"
      local merged = false

      -- Keep track of spells that go by
      if TrackSpells() then x.spellCache.spells[spellID] = true end

      -- Filter Ougoing Healing
      if FilterOutgoingHealing(amount) then return end
      
      -- Spell Specific Filter
      if IsSpellFiltered(spellID) then return end
      
      -- Check for Overhealing
      if not ShowOverHealing() then
        local realamount = amount - overhealing
        if realamount < 1 then
          return
        end
        message = realamount
      end
      
      -- Check for merge
      if IsMerged(spellID) then
        if not critical or critical and not MergeCriticalsByThemselves() then
          merged = true
          x:AddSpamMessage("outgoing", spellID, message, outputColor)
        end
      end

      -- Check for Critical
      if critical then
        outputColor = "healingOutCritical"
        
        if not MergeDontMergeCriticals() and IsMerged(spellID) then
          -- Merge this critical entry
          x:AddSpamMessage("critical", spellID, message, outputColor)
          
          -- We are done, after we check for criticals. We don't need to do anything else.
          return 
        else
          -- Don't merge criticals
          message = sformat(format_crit, x.db.profile.frames["critical"].critPrefix, x:Abbreviate(message, "critical"), x.db.profile.frames["critical"].critPostfix)
          outputFrame = "critical"
        end
      elseif merged then  -- return merged, non-crits
        return
      else
        message = x:Abbreviate(message, "outgoing")
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
    
  ["SWING_DAMAGE"] = function(...)
      if not ShowDamage() then return end
      
      local _, _, _, sourceGUID, _, sourceFlags, _, _, _, _, _,  amount, _, _, _, _, _, critical = ...
      local outputFrame, message, outputColor = "outgoing", x:Abbreviate(amount, "outgoing"), "genericDamage"
      local merged, critMessage = false, nil
      
      -- Filter Outgoing Damage
      if FilterOutgoingDamage(amount) then return end
      
      -- Check for Pet Swings
      local spellID = 6603
      if (sourceGUID == UnitGUID("pet")) or sourceFlags == COMBATLOG_FILTER_MY_VEHICLE then
        if not ShowPetDamage() then return end
        spellID = 0
        critical = nil -- stupid spam fix for hunter pets
      end
      
      -- Check for Critical
      if critical then
        if ShowSwingCrit() then
          outputFrame = "critical"
          if ShowSwingCritPrefix() then
            critMessage = sformat(format_crit, x.db.profile.frames["critical"].critPrefix, x:Abbreviate(amount, "critical"), x.db.profile.frames["critical"].critPostfix)
          end
        end
      end
      
      -- Are we filtering Auto Attacks in the Outgoing frame?
      if outputFrame == "outgoing" and not ShowAutoAttack() then return end;
      
      -- Check for merge
      if MergeMeleeSwings() then
        merged = true
        x:AddSpamMessage("outgoing", spellID, amount, outputColor, 6)
      end
      
      -- Only show non-merged swings
      if merged and not critical then
        return
      end

      -- Add Icons
      if x.db.profile.frames[outputFrame].iconsEnabled then
        if x.db.profile.frames[outputFrame].fontJustify == "LEFT" then
          critMessage = x:GetSpellTextureFormatted(spellID, x.db.profile.frames[outputFrame].iconsSize) .. "  " .. (critMessage or message)
        else
          critMessage = (critMessage or message) .. x:GetSpellTextureFormatted(spellID, x.db.profile.frames[outputFrame].iconsSize)
        end
      end
      
      x:AddMessage(outputFrame, (critMessage or message), outputColor)
    end,
    
  ["RANGE_DAMAGE"] = function(...)
      if not ShowDamage() then return end
      
      local _, _, _, sourceGUID, _, sourceFlags, _, _, _, _, _,  spellID, _, _, amount, _, _, _, _, _, critical = ...
      local outputFrame, message, outputColor = "outgoing", x:Abbreviate(amount, "outgoing"), "genericDamage"
      local merged, critMessage = false, nil
      
      -- Keep track of spells that go by
      if TrackSpells() then x.spellCache.spells[spellID] = true end

      -- Filter Outgoing Damage
      if FilterOutgoingDamage(amount) then return end
      
      -- Spell Specific Filter
      if IsSpellFiltered(spellID) then return end
      
      -- Auto Shot's Spell ID
      local autoShot = (spellID == 75)
      
      -- Check for critical
      if critical then
      
        -- Check if we should display Auto Shot criticals
        if not autoShot or autoShot and ShowSwingCrit() then
          outputFrame = "critical"
        else
          -- Check if we need to merge this attack in the "outgoing" frame
          if autoShot and MergeRangedAttacks() and not MergeCriticalsByThemselves() then
          
            -- Are we filtering Auto Attacks in the Outgoing frame?
            if ShowAutoAttack() then
              -- Send message (amount) to "outgoing"
              x:AddSpamMessage(outputFrame, spellID, amount, outputColor, 6)
            end
            
            -- After the spam merge, there is nothing we need to do
            return
          end
        end
        
        -- Check to see if we should format the Auto Shot critical hit
        if not autoShot or autoShot and ShowSwingCritPrefix() then
          critMessage = sformat(format_crit, x.db.profile.frames["critical"].critPrefix, x:Abbreviate(amount, "critical"), x.db.profile.frames["critical"].critPostfix)
        end
      end
      
      -- Check for Auto Shot critical merge with normal damage
      if outputFrame == "critical" and not MergeCriticalsByThemselves() then
        if not autoShot or autoShot and MergeRangedAttacks() then
          -- If Criticals With Outgoing, then we need to merge again with the critical frame
          merged = MergeDontMergeCriticals()
          
          -- Are we filtering Auto Attacks in the Outgoing frame?
          if ShowAutoAttack() then
            -- Merge with the outgoing damage
            x:AddSpamMessage("outgoing", spellID, amount, outputColor, 6)
          end
        end
      end
      
      -- Are we filtering Auto Attacks in the Outgoing frame?
      if not ShowAutoAttack() and outputFrame == "outgoing" then return end
      
      if not merged and autoShot and MergeRangedAttacks() then
        x:AddSpamMessage(outputFrame, spellID, amount, outputColor, 6)
        return
      end
      
      -- Add Icons
      if x.db.profile.frames[outputFrame].iconsEnabled then
        if x.db.profile.frames[outputFrame].fontJustify == "LEFT" then
          critMessage = x:GetSpellTextureFormatted(spellID, x.db.profile.frames[outputFrame].iconsSize) .. "  " .. (critMessage or message)
        else
          critMessage = (critMessage or message) .. x:GetSpellTextureFormatted(spellID, x.db.profile.frames[outputFrame].iconsSize)
        end
      end
      
      x:AddMessage(outputFrame, (critMessage or message), outputColor)
    end,
    
  ["SPELL_DAMAGE"] = function(...)
      if not ShowDamage() then return end
      
      local _, _, _, sourceGUID, _, sourceFlags, _, destGUID, _, _, _,  spellID, _, spellSchool, amount, _, _, _, _, _, critical = ...
      local outputFrame, message, outputColor = "outgoing", x:Abbreviate(amount, "outgoing"), "genericDamage"
      local merged = false
      
      -- Keep track of spells that go by
      if TrackSpells() then x.spellCache.spells[spellID] = true end

      -- Filter Outgoing Damage
      if FilterOutgoingDamage(amount) then return end
      
      -- Spell Specific Filter
      if IsSpellFiltered(spellID) then return end
      
      -- Get special magic color
      outputColor = GetCustomSpellColorFromIndex(spellSchool)
      
      -- Check for merge
      if IsMerged(spellID) then
        if critical and not MergeCriticalsByThemselves() or not critical then
          merged = true
          x:AddSpamMessage("outgoing", spellID, amount, outputColor)
        end
      end

      -- Check for Critical
      if critical then
        if not MergeDontMergeCriticals() and IsMerged(spellID) then
          -- Merge this critical entry
          x:AddSpamMessage("critical", spellID, amount, outputColor)
          
          -- We are done, after we check for criticals. We don't need to do anything else.
          return 
        else
          -- Don't merge criticals
          message = sformat(format_crit, x.db.profile.frames["critical"].critPrefix, x:Abbreviate(amount, "critical"), x.db.profile.frames["critical"].critPostfix)
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
    end,
    
  ["SPELL_PERIODIC_DAMAGE"] = function(...)
      if not ShowDamage() or not ShowDots() then return end
      
      local _, _, _, sourceGUID, _, sourceFlags, _, _, _, _, _,  spellID, _, spellSchool, amount, _, _, _, _, _, critical = ...
      local outputFrame, message, outputColor = "outgoing", x:Abbreviate(amount, "outgoing"), "genericDamage"
      local merged = false
      
      -- Keep track of spells that go by
      if TrackSpells() then x.spellCache.spells[spellID] = true end

      -- Filter Outgoing Damage
      if FilterOutgoingDamage(amount) then return end
      
      -- Spell Specific Filter
      if IsSpellFiltered(spellID) then return end
      
      -- Get special magic color
      outputColor = GetCustomSpellColorFromIndex(spellSchool)
      
      -- Check for merge
      if IsMerged(spellID) then
        if critical and not MergeCriticalsByThemselves() or not critical then
          merged = true
          x:AddSpamMessage("outgoing", spellID, amount, outputColor)
        end
      end

      -- Check for Critical
      if critical then
        if not MergeDontMergeCriticals() and IsMerged(spellID) then
          -- Merge this critical entry
          x:AddSpamMessage("critical", spellID, amount, outputColor)
          
          -- We are done, after we check for criticals. We don't need to do anything else.
          return 
        else
          -- Don't merge criticals
          message = sformat(format_crit, x.db.profile.frames["critical"].critPrefix, x:Abbreviate(amount, "critical"), x.db.profile.frames["critical"].critPostfix)
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
    end,
    
  ["SWING_MISSED"] = function(...)
      local _, _, _, sourceGUID, _, sourceFlags, _, _, _, _, _,  missType = ...
      local outputFrame, message, outputColor = "outgoing", _G["COMBAT_TEXT_"..missType], "misstypesOut"
      
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
      local outputFrame, message, outputColor = "outgoing", _G[missType], "misstypesOut"
      
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
      local outputFrame, message, outputColor = "outgoing", _G[missType], "misstypesOut"
      
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
  
      local _, _, _, sourceGUID, _, sourceFlags, _, _, _, _, _,   dispelSourceID, dispelSourceName, _,   spellID, spellName, _,  auraType = ...
      local outputFrame, message, outputColor = "general", sformat(format_dispell, XCT_DISPELLED, spellName), "dispellDebuffs"
      
      -- Check for buff or debuff (for color)
      if auraType == "BUFF" then
        outputColor = "dispellBuffs"
      end
      
      -- Add Icons
      if x.db.profile.frames[outputFrame].iconsEnabled then
        if x.db.profile.frames[outputFrame].fontJustify == "LEFT" then
          message = x:GetSpellTextureFormatted(spellID, x.db.profile.frames[outputFrame].iconsSize) .. "  " .. message
        else
          message = message .. x:GetSpellTextureFormatted(spellID, x.db.profile.frames[outputFrame].iconsSize)
        end
      end
      
      if MergeDispells() then
        x:AddSpamMessage("general", spellName, message, outputColor, 0.5)
      else
        x:AddMessage(outputFrame, message, outputColor)
      end
    end,
    
  ["SPELL_STOLEN"] = function(...)
      if not ShowDispells() then return end
      
      local _, _, _, sourceGUID, _, sourceFlags, _, _, _, _, _,   dispelSourceID, dispelSourceName, _,   spellID, spellName, _,  auraType = ...
      local outputFrame, message, outputColor = "general", sformat(format_dispell, XCT_STOLE, spellName), "dispellStolen"
      
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
  
      local _, _, _, sourceGUID, _, sourceFlags, _, _, _, _, _,  target, _, _,  spellID, effect = ...
      local outputFrame, message, outputColor = "general", sformat(format_dispell, INTERRUPTED, effect), "interrupts"
      
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
      local outputFrame, message, outputColor = "general", sformat(format_dispell, XCT_KILLED, name), "killingBlow"
      
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
