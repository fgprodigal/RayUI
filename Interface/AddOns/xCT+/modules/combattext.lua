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

-- Shorten my handle
local x = addon.engine

-- up values
local _, _G, sformat, mfloor, mabs, ssub, smatch, sgsub, s_upper, s_lower, string, tinsert, tremove, ipairs, pairs, print, tostring, tonumber, select, unpack =
  nil, _G, string.format, math.floor, math.abs, string.sub, string.match, string.gsub, string.upper, string.lower, string, table.insert, table.remove, ipairs, pairs, print, tostring, tonumber, select, unpack

--UTF8 Functions
local utf8 = {
  len = string.utf8len,
  sub = string.utf8sub,
  reverse = string.utf8reverse,
  upper = string.utf8upper,
  lower = string.utf8lower
}

local xCP = LibStub and LibStub("xCombatParser-1.0", true)
if not xCP then print("Something went wrong when xCT+ tried to load. Please resintall and inform the author.") end


--[=====================================================[
 Holds cached spells, buffs, and debuffs
--]=====================================================]
x.spellCache = {
  buffs = { },
  debuffs = { },
  spells = { },
  procs = { },
  items = { },
  damage = { },
  healing = { },
}

--[=====================================================[
 A Simple Managed Table Pool
--]=====================================================]
local tpool = { }
local function tnew( )
  if #tpool > 0 then
    local t = tpool[1]
    tremove( tpool, 1 )
    return t
  else
    return { }
  end
end
local function tdel( t )
  tinsert( tpool, t )
end

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
    f:RegisterEvent("UNIT_PET")
    f:RegisterEvent("PLAYER_TARGET_CHANGED")
    f:RegisterEvent("SPELL_ACTIVATION_OVERLAY_GLOW_SHOW")

    -- if runes
    f:RegisterEvent("RUNE_POWER_UPDATE")

    -- if loot
    f:RegisterEvent("CHAT_MSG_LOOT")
    f:RegisterEvent("CHAT_MSG_CURRENCY")
    f:RegisterEvent("CHAT_MSG_MONEY")

    -- damage and healing
    --f:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")

    -- Class combo points
    f:RegisterEvent("UNIT_AURA")
    f:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
    f:RegisterEvent("UNIT_COMBO_POINTS")
    f:RegisterEvent("PLAYER_TARGET_CHANGED")

    x.combatEvents = f
    f:SetScript("OnEvent", x.OnCombatTextEvent)
    
    xCP:RegisterCombat(x.CombatLogEvent)
  else
    -- Disabled Combat Text
    f:SetScript("OnEvent", nil)
    xCP:UnregisterCombat(x.CombatLogEvent)
  end
end

--[=====================================================[
 Fast Boolean Lookups
--]=====================================================]
local function ShowMissTypes() return x.db.profile.frames.damage.showDodgeParryMiss end
local function ShowResistances() return x.db.profile.frames.damage.showDamageReduction end
local function ShowHonor() return x.db.profile.frames.damage.showHonorGains end
local function ShowFaction() return x.db.profile.frames.general.showRepChanges end
local function ShowReactives() return x.db.profile.frames.procs.enabledFrame end
local function ShowLowResources() return x.db.profile.frames.general.showLowManaHealth end
local function ShowCombatState() return x.db.profile.frames.general.showCombatState end
local function ShowFriendlyNames() return x.db.profile.frames["healing"].showFriendlyHealers end
local function ShowColoredFriendlyNames() return x.db.profile.frames["healing"].enableClassNames end
local function ShowHealingRealmNames() return x.db.profile.frames["healing"].enableRealmNames end
local function ShowOnlyMyHeals() return x.db.profile.frames.healing.showOnlyMyHeals end
local function ShowOnlyMyPetsHeals() return x.db.profile.frames.healing.showOnlyPetHeals end
local function ShowDamage() return x.db.profile.frames["outgoing"].enableOutDmg end
local function ShowHealing() return x.db.profile.frames["outgoing"].enableOutHeal end
local function ShowPetDamage() return x.db.profile.frames["outgoing"].enablePetDmg end
local function ShowVehicleDamage() return x.db.profile.frames["outgoing"].enableVehicleDmg end
local function ShowAutoAttack() return x.db.profile.frames["outgoing"].enableAutoAttack end -- Also see ShowSwingCrit
local function ShowDots() return x.db.profile.frames["outgoing"].enableDotDmg end
local function ShowHots() return x.db.profile.frames["outgoing"].enableHots end
local function ShowImmunes() return x.db.profile.frames["outgoing"].enableImmunes end -- outgoing immunes
local function ShowMisses() return x.db.profile.frames["outgoing"].enableMisses end -- outgoing misses
local function ShowSwingCrit() return x.db.profile.frames["critical"].showSwing end
local function ShowSwingCritPrefix() return x.db.profile.frames["critical"].prefixSwing end
local function ShowPetCrits() return x.db.profile.frames["critical"].petCrits end
local function ShowLootItems() return x.db.profile.frames["loot"].showItems end
local function ShowLootItemTypes() return x.db.profile.frames["loot"].showItemTypes end
local function ShowLootMoney() return x.db.profile.frames["loot"].showMoney end
local function ShowLootCurrency() return x.db.profile.frames["loot"].showCurrency end
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
local function ShowEnergyGains() return x.db.profile.frames["power"].showEnergyGains end
local function ShowPeriodicEnergyGains() return x.db.profile.frames["power"].showPeriodicEnergyGains end
local function ShowEnergyTypes() return x.db.profile.frames["power"].showEnergyType end
local function ShowIncomingAutoAttackIcons() return x.db.profile.frames["damage"].iconsEnabledAutoAttack end

-- TODO: Add Combo Point Support
local function ShowRogueComboPoints() return false end -- x.db.profile.spells.combo["ROGUE"][COMBAT_TEXT_SHOW_COMBO_POINTS_TEXT] and x.player.class == "ROGUE" end
local function ShowFeralComboPoints() return false end -- x.db.profile.spells.combo["DRUID"][2][COMBAT_TEXT_SHOW_COMBO_POINTS_TEXT] and x.player.class == "DRUID" and x.player.spec == 2 end
local function ShowMonkChi() return false end -- return x.db.profile.spells.combo["MONK"][CHI] and x.player.class == "MONK" end
local function ShowPaladinHolyPower() return false end -- return x.db.profile.spells.combo["PALADIN"][HOLY_POWER] and x.player.class == "PALADIN" end
local function ShowPriestShadowOrbs() return false end -- return x.db.profile.spells.combo["PRIEST"][3][SHADOW_ORBS] and x.player.class == "PRIEST" and x.player.spec == 3 end
local function ShowWarlockSoulShards() return false end -- return x.db.profile.spells.combo["WARLOCK"][1][SOUL_SHARDS] and x.player.class == "WARLOCK" and x.player.spec == 1 end
local function ShowWarlockDemonicFury() return false end -- return x.db.profile.spells.combo["WARLOCK"][2][DEMONIC_FURY] and x.player.class == "WARLOCK" and x.player.spec == 2 end
local function ShowWarlockBurningEmbers() return false end -- return x.db.profile.spells.combo["WARLOCK"][3][BURNING_EMBERS] and x.player.class == "WARLOCK" and x.player.spec == 3 end

local function ClearWhenLeavingCombat() return x.db.profile.frameSettings.clearLeavingCombat end

local function MergeIncomingHealing() return x.db.profile.spells.mergeHealing end
local function MergeMeleeSwings() return x.db.profile.spells.mergeSwings end
local function MergeRangedAttacks() return x.db.profile.spells.mergeRanged end
local function MergePetAttacks() return x.db.profile.spells.mergePet end
local function MergeCriticalsWithOutgoing() return x.db.profile.spells.mergeCriticalsWithOutgoing end
local function MergeCriticalsByThemselves() return x.db.profile.spells.mergeCriticalsByThemselves end
local function MergeDontMergeCriticals() return x.db.profile.spells.mergeDontMergeCriticals end
local function MergeHideMergedCriticals() return x.db.profile.spells.mergeHideMergedCriticals end
local function MergeDispells() return x.db.profile.spells.mergeDispells end

local function FilterPlayerPower(value) return x.db.profile.spellFilter.filterPowerValue > value end
local function FilterOutgoingDamage(value) return x.db.profile.spellFilter.filterOutgoingDamageValue > value end
local function FilterOutgoingHealing(value) return x.db.profile.spellFilter.filterOutgoingHealingValue > value end
local function FilterIncomingDamage(value) return x.db.profile.spellFilter.filterIncomingDamageValue > value end
local function FilterIncomingHealing(value) return x.db.profile.spellFilter.filterIncomingHealingValue > value end
local function TrackSpells() return x.db.profile.spellFilter.trackSpells end

local function IsResourceDisabled( resource, amount )
  if resource == "ECLIPSE" then
    if amount > 0 then
      return x.db.profile.frames["power"].disableResource_ECLIPSE_positive
    elseif amount < 0 then
      return x.db.profile.frames["power"].disableResource_ECLIPSE_negative
    end
  end
  if x.db.profile.frames["power"]["disableResource_"..resource] ~= nil then
    return x.db.profile.frames["power"]["disableResource_"..resource]
  end
  return true
end

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
  local spell = x.db.profile.spellFilter.listItems[tostring(name)]
  if x.db.profile.spellFilter.whitelistItems then
    return not spell
  end
  return spell
end

local function IsDamageFiltered(name)
  local spell = x.db.profile.spellFilter.listDamage[tostring(name)]
  if x.db.profile.spellFilter.whitelistDamage then
    return not spell
  end
  return spell
end

local function IsHealingFiltered(name)
  local spell = x.db.profile.spellFilter.listHealing[tostring(name)]
  if x.db.profile.spellFilter.whitelistHealing then
    return not spell
  end
  return spell
end

local function IsMerged(spellID)
	local merged = false
	if x.db.profile.spells.enableMerger then
		spellID = addon.merge2h[spellID] or spellID
		local db = x.db.profile.spells.merge[spellID] or addon.defaults.profile.spells.merge[spellID]
		if db and db.enabled then merged = true end
	end
	return merged
end

local function UseStandardSpellColors() return not x.db.profile.frames["outgoing"].standardSpellColor end

--[=====================================================[
 String Formatters
--]=====================================================]
local format_getItemString = "([^|]+)|cff(%x+)|H([^|]+)|h%[([^%]]+)%]|h|r[^%d]*(%d*)"
local format_pet  = sformat("|cff798BDD[%s]:|r %%s (%%s)", sgsub(BATTLE_PET_CAGE_ITEM_NAME,"%s?%%s","")) -- [Caged]: Pet Name (Pet Family)

-- TODO: Remove old loot pattern
--local format_loot = "([^|]*)|cff(%x*)|H([^:]*):(%d+):%d+:(%d+):[-?%d+:]+|h%[?([^%]]*)%]|h|r?%s?x?(%d*)%.?"
-- "You create: |cffa335ee|Hitem:124515::::::::100:254:4:3::530:::|h[Talisman of the Master Tracker]|h|r"
--local msg = "|cff1eff00|Hitem:108840:0:0:0:0:0:0:443688319:90:0:0:0|h[Warlords Intro Zone PH Mail Helm]|h|r"
--local format_loot = "([^|]*)|cff(%x*)|H([^:]*):(%d+):[-?%d+:]+|h%[?([^%]]*)%]|h|r?%s?x?(%d*)%.?"

local format_fade               = "-%s"
local format_gain               = "+%s"
local format_gain_rune          = "%s +%s %s"
local format_resist             = "-%s |c%s(%s %s)|r"
local format_energy             = "+%s %s"
local format_honor              = sgsub(COMBAT_TEXT_HONOR_GAINED, "%%s", "+%%s")
local format_faction_add        = "%s +%s"
local format_faction_sub        = "%s %s"
local format_crit               = "%s%s%s"
local format_dispell            = "%s: %s"
local format_quality            = "ITEM_QUALITY%s_DESC"
local format_remove_realm       = "(.*)-.*"

local format_spell_icon         = " |T%s:%d:%d:0:0:64:64:5:59:5:59|t"
local format_msspell_icon_right = "%s |cff%sx%d|r |T%s:%d:%d:0:0:64:64:5:59:5:59|t"
local format_msspell_icon_left  = " |T%s:%d:%d:0:0:64:64:5:59:5:59|t %s |cff%sx%d|r"
local format_loot_icon          = "|T%s:%d:%d:0:0:64:64:5:59:5:59|t"
local format_lewtz              = "%s%s: %s [%s]%s%%s"
local format_lewtz_amount       = " |cff798BDDx%s|r"
local format_lewtz_total        = " |cffFFFF00(%s)|r"
local format_lewtz_blind        = "(%s)"
local format_crafted            = (LOOT_ITEM_CREATED_SELF:gsub("%%.*", ""))       -- "You create: "
local format_looted             = (LOOT_ITEM_SELF:gsub("%%.*", ""))               -- "You receive loot: "
local format_pushed             = (LOOT_ITEM_PUSHED_SELF:gsub("%%.*", ""))        -- "You receive item: "
local format_strcolor_white     = "ffffff"
local format_currency_single    = (CURRENCY_GAINED:gsub("%%s", "(.+)"))                                 -- "You receive currency: (.+)."
local format_currency_multiple  = (CURRENCY_GAINED_MULTIPLE:gsub("%%s", "(.+)"):gsub("%%d", "(%%d+)"))  -- "You receive currency: (.+) x(%d+)."
local format_currency           = "%s: %s [%s] |cff798BDDx%s|r |cffFFFF00(%s)|r"

--[=====================================================[
 Message Formatters
--]=====================================================]
local xCTFormat = { }

function xCTFormat:SPELL_HEAL( outputFrame, spellID, amount, critical, merged )
  local outputColor, message = "healingOut"

  -- Format Criticals and also abbreviate values
  if critical then
    outputColor = "healingOutCritical"
    message = sformat( format_crit, x.db.profile.frames["critical"].critPrefix,
                                    x:Abbreviate( amount, "critical" ),
                                    x.db.profile.frames["critical"].critPostfix )
  else
    message = x:Abbreviate( amount, outputFrame )
  end

  -- Add Icons
  message = x:GetSpellTextureFormatted( spellID,
                                        message,
       x.db.profile.frames[outputFrame].iconsEnabled and x.db.profile.frames[outputFrame].iconsSize or -1,
       x.db.profile.frames[outputFrame].fontJustify )

  x:AddMessage(outputFrame, message, outputColor)
end

function xCTFormat:SPELL_PERIODIC_HEAL( outputFrame, spellID, amount, critical, merged )
  local outputColor, message = "healingOutPeriodic"

  -- Format Criticals and also abbreviate values
  if critical then
    message = sformat( format_crit, x.db.profile.frames["critical"].critPrefix,
                                    x:Abbreviate( amount, "critical" ),
                                    x.db.profile.frames["critical"].critPostfix )
  else
    message = x:Abbreviate( amount, outputFrame )
  end

  -- Add Icons
  message = x:GetSpellTextureFormatted( spellID,
                                        message,
       x.db.profile.frames[outputFrame].iconsEnabled and x.db.profile.frames[outputFrame].iconsSize or -1,
       x.db.profile.frames[outputFrame].fontJustify )

  x:AddMessage(outputFrame, message, outputColor)
end

function xCTFormat:SWING_DAMAGE( outputFrame, spellID, amount, critical, merged, args )
  local outputColor, message, settings = x.GetSpellSchoolColor(1, critical)

  if critical and ShowSwingCrit() then
    settings = x.db.profile.frames["critical"]
    if ShowSwingCritPrefix() then
      message = sformat( format_crit, x.db.profile.frames["critical"].critPrefix,
                                      x:Abbreviate(amount, "critical"),
                                      x.db.profile.frames["critical"].critPostfix )
    else
      message = x:Abbreviate(amount, "critical")
    end
  else
    settings = x.db.profile.frames["outgoing"]
    message = x:Abbreviate(amount, "outgoing")
  end

  -- Add names
  message = message .. x.formatName(args, settings.names)

  -- Add Icons
  message = x:GetSpellTextureFormatted( spellID,
                                        message,
       x.db.profile.frames[outputFrame].iconsEnabled and x.db.profile.frames[outputFrame].iconsSize or -1,
       x.db.profile.frames[outputFrame].fontJustify )

  x:AddMessage(outputFrame, message, outputColor)
end

function xCTFormat:RANGE_DAMAGE( outputFrame, spellID, amount, critical, merged, autoShot, args )
  local outputColor, message, settings = x.GetSpellSchoolColor(1, critical)

  if critical then
    settings = x.db.profile.frames["critical"]

    -- Check to see if we should format the Auto Shot critical hit
    if not autoShot or autoShot and ShowSwingCritPrefix() then
      message = sformat( format_crit, x.db.profile.frames["critical"].critPrefix,
                                      x:Abbreviate(amount, "critical"),
                                      x.db.profile.frames["critical"].critPostfix )
    else
      message = x:Abbreviate(amount, "critical")
    end
  else
    settings = x.db.profile.frames["outgoing"]
    message = x:Abbreviate(amount, "outgoing")
  end

  -- Add names
  message = message .. x.formatName(args, settings.names)

  -- Add Icons
  message = x:GetSpellTextureFormatted( spellID,
                                        message,
       x.db.profile.frames[outputFrame].iconsEnabled and x.db.profile.frames[outputFrame].iconsSize or -1,
       x.db.profile.frames[outputFrame].fontJustify )

  x:AddMessage(outputFrame, message, outputColor)
end

function xCTFormat:SPELL_DAMAGE( outputFrame, spellID, amount, critical, merged, spellSchool, args )
  local message, settings

  -- Format Criticals and also abbreviate values
  if critical then
    settings = x.db.profile.frames["critical"]
    message = sformat( format_crit, x.db.profile.frames["critical"].critPrefix,
                                    x:Abbreviate( amount, "critical" ),
                                    x.db.profile.frames["critical"].critPostfix )
  else
    settings = x.db.profile.frames["outgoing"]
    message = x:Abbreviate( amount, outputFrame )
  end

  -- Add names
  message = message .. x.formatName(args, settings.names)

  -- Add Icons
  message = x:GetSpellTextureFormatted( spellID,
                                        message,
       x.db.profile.frames[outputFrame].iconsEnabled and x.db.profile.frames[outputFrame].iconsSize or -1,
       x.db.profile.frames[outputFrame].fontJustify )

  x:AddMessage(outputFrame, message, x.GetSpellSchoolColor(spellSchool, critical))
end

function xCTFormat:SPELL_PERIODIC_DAMAGE( outputFrame, spellID, amount, critical, merged, spellSchool, args )
  local message, settigns

  -- Format Criticals and also abbreviate values
  if critical then
    settings = x.db.profile.frames["critical"]
    message = sformat( format_crit, x.db.profile.frames["critical"].critPrefix,
                                    x:Abbreviate( amount, "critical" ),
                                    x.db.profile.frames["critical"].critPostfix )
  else
    settings = x.db.profile.frames["outgoing"]
    message = x:Abbreviate( amount, outputFrame )
  end

  -- Add names
  message = message .. x.formatName(args, settings.names)

  -- Add Icons
  message = x:GetSpellTextureFormatted( spellID,
                                        message,
       x.db.profile.frames[outputFrame].iconsEnabled and x.db.profile.frames[outputFrame].iconsSize or -1,
       x.db.profile.frames[outputFrame].fontJustify )

  x:AddMessage(outputFrame, message, x.GetSpellSchoolColor(spellSchool, critical) )
end


--[=====================================================[
 Capitalize Locales
--]=====================================================]
local unsupportedLocales = { zhCN = true, koKR = true, zhTW = true }

local XCT_STOLE
local XCT_KILLED
local XCT_DISPELLED

if unsupportedLocales[GetLocale()] then
  XCT_STOLE = ACTION_SPELL_STOLEN
  XCT_KILLED = ACTION_PARTY_KILL
  XCT_DISPELLED = ACTION_SPELL_DISPEL
else
  XCT_STOLE = utf8.upper(utf8.sub(ACTION_SPELL_STOLEN, 1, 1))..utf8.sub(ACTION_SPELL_STOLEN, 2)
  XCT_KILLED = utf8.upper(utf8.sub(ACTION_PARTY_KILL, 1, 1))..utf8.sub(ACTION_PARTY_KILL, 2)
  XCT_DISPELLED = utf8.upper(utf8.sub(ACTION_SPELL_DISPEL, 1, 1))..utf8.sub(ACTION_SPELL_DISPEL, 2)
end

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
    message,     [string] - The message that will be used (usually the amount)
    iconSize,    [number] - The format size of the icon
    justify,     [string] - Can be 'LEFT' or 'RIGHT'
    strColor,    [string] - the color to be used or defaults white
    mergeOverride, [bool] - If enable, will format like: "Messsage x12" where 12 is entries
    entries      [number] - The number of entries to use
  )
  Returns:
    message,     [string] - the message contains the formatted icon

    Formats an icon quickly for use when outputing to a combat text frame.
--]=====================================================]
function x:GetSpellTextureFormatted( spellID, message, iconSize, justify, strColor, mergeOverride, entries )
  local icon = x.BLANK_ICON
  strColor = strColor or format_strcolor_white
  if spellID == 0 then
    icon = PET_ATTACK_TEXTURE
  elseif type(spellID) == 'string' then
    icon = spellID
  else
    icon = GetSpellTexture( spellID ) or x.BLANK_ICON
  end

  if iconSize < 1 then
    icon = x.BLANK_ICON
  end

  if mergeOverride then
    if entries > 1 then
      if justify == "LEFT" then
        message = sformat( format_msspell_icon_left, icon, iconSize, iconSize, message, strColor, entries )
      else
        message = sformat( format_msspell_icon_right, message, strColor, entries, icon, iconSize, iconSize )
      end
    else
      if justify == "LEFT" then
        message = sformat( "%s %s", sformat( format_spell_icon, icon, iconSize, iconSize ), message )
      else
        message = sformat( "%s%s", message, sformat( format_spell_icon, icon, iconSize, iconSize ) )
      end
    end
  else

    if justify == "LEFT" then
      message = sformat( "%s %s", sformat( format_spell_icon, icon, iconSize, iconSize ), message )
    else
      message = sformat( "%s%s", message, sformat( format_spell_icon, icon, iconSize, iconSize ) )
    end
  end

  if x.db.profile.spells.enableMergerDebug then
    message = message .. " |cffFFFFFF[|cffFF0000ID:|r|cffFFFF00" .. (spellID or "No ID") .. "|r]|r"
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
    --self.items[k] = nil
    tremove( self.items, k )
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

--[[
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

      if ShowOnlyMyHeals() and healer_name ~= x.player.name then
        if ShowOnlyMyPetsHeals() and healer_name == UnitName("pet") then
          -- If its the pet, then continue
        else
          return
        end
      end

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

      if ShowOnlyMyHeals() and healer_name ~= x.player.name then
        if ShowOnlyMyPetsHeals() and healer_name == UnitName("pet") then
          -- If its the pet, then continue
        else
          return
        end
      end

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

      if ShowOnlyMyHeals() and healer_name ~= x.player.name then
        if ShowOnlyMyPetsHeals() and healer_name == UnitName("pet") then
          -- If its the pet, then continue
        else
          return
        end
      end

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

      if ShowOnlyMyHeals() and healer_name ~= x.player.name then
        if ShowOnlyMyPetsHeals() and healer_name == UnitName("pet") then
          -- If its the pet, then continue
        else
          return
        end
      end

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
  ["PERIODIC_HEAL_CRIT"] = function(healer_name, amount)
      if FilterIncomingHealing(amount) then return end

      if ShowOnlyMyHeals() and healer_name ~= x.player.name then
        if ShowOnlyMyPetsHeals() and healer_name == UnitName("pet") then
          -- If its the pet, then continue
        else
          return
        end
      end

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

        x:AddMessage("healing", message, "healingTakenPeriodicCritical")
      end
    end,
]]


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

--[[
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
          x:AddMessage("damage", sformat(format_resist, x:Abbreviate(amount,"damage"), RESIST, x:Abbreviate(resisted,"damage")), "missTypeResistPartial")
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
          x:AddMessage("damage", sformat(format_resist, x:Abbreviate(amount,"damage"), BLOCK, x:Abbreviate(resisted,"damage")), "missTypeBlockPartial")
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
          x:AddMessage("damage", sformat(format_resist, x:Abbreviate(amount,"damage"), ABSORB, x:Abbreviate(resisted,"damage")), "missTypeAbsorbPartial")
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
          x:AddMessage("damage", sformat(format_resist, x:Abbreviate(amount,"damage"), RESIST, x:Abbreviate(resisted,"damage")), "missTypeResistPartial")
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
          x:AddMessage("damage", sformat(format_resist, x:Abbreviate(amount,"damage"), BLOCK, x:Abbreviate(resisted,"damage")), "missTypeBlockPartial")
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
          x:AddMessage("damage", sformat(format_resist, x:Abbreviate(amount,"damage"), ABSORB, x:Abbreviate(resisted,"damage")), "missTypeAbsorbPartial")
        else
          x:AddMessage("damage", x:Abbreviate(amount,"damage"), "damage")
        end
      elseif ShowResistances() then
        x:AddMessage("damage", ABSORB, "missTypeAbsorb")
      end
    end,
]]


    -- TODO: Do this somewhere else
  ["ENERGIZE"] = function(amount, energy_type)
      --[[if not ShowEnergyGains() then return end
      if not FilterPlayerPower(tonumber(amount)) then
        if energy_type and (energy_type == "MANA" and not IsBearForm()) -- do not show mana in bear form (Leader of the Pack)
            or energy_type == "RAGE" or energy_type == "FOCUS"
            or energy_type == "ENERGY" or energy_type == "RUINIC_POWER"
            or energy_type == "SOUL_SHARDS" or energy_type == "HOLY_POWER" then
          local message, color = x:Abbreviate(amount,"power"), {PowerBarColor[energy_type].r, PowerBarColor[energy_type].g, PowerBarColor[energy_type].b}

          x:AddMessage("power", sformat(format_energy, message, _G[energy_type]), color)
        end
      end]]

      if not ShowEnergyGains() then return end
      if FilterPlayerPower(mabs(tonumber(amount))) then return end
      if IsResourceDisabled( energy_type, amount ) then return end

      local color, message = nil, x:Abbreviate( amount, "power" )
      if energy_type == "ECLIPSE" then
        if amount > 0 then
          color = x.LookupColorByName("color_ECLIPSE_positive")
        elseif amount < 0 then
          color = x.LookupColorByName("color_ECLIPSE_negative")
        end
      else
        color = x.LookupColorByName("color_" .. energy_type )
      end

      -- Default Color will be white
      if not color then
        color = {1,1,1}
      end

      x:AddMessage("power", sformat(format_energy, message, ShowEnergyTypes() and _G[energy_type] or ""), color)
    end,
  ["PERIODIC_ENERGIZE"] = function(amount, energy_type)
      --[[if not ShowPeriodicEnergyGains() then return end
      if not FilterPlayerPower(tonumber(amount)) then
        if energy_type and (energy_type == "MANA" and not IsBearForm()) -- do not show mana in bear form (Leader of the Pack)
            or energy_type == "RAGE" or energy_type == "FOCUS"
            or energy_type == "ENERGY" or energy_type == "RUINIC_POWER"
            or energy_type == "SOUL_SHARDS" or energy_type == "HOLY_POWER" then
          local message, color = x:Abbreviate(amount,"power"), {PowerBarColor[energy_type].r, PowerBarColor[energy_type].g, PowerBarColor[energy_type].b}

          x:AddMessage("power", sformat(format_energy, message, _G[energy_type]), color)
        end
      end]]

      if not ShowPeriodicEnergyGains() then return end
      if FilterPlayerPower(mabs(tonumber(amount))) then return end
      if IsResourceDisabled( energy_type, amount ) then return end

      local color, message = nil, x:Abbreviate( amount, "power" )
      if energy_type == "ECLIPSE" then
        if amount > 0 then
          color = x.LookupColorByName("color_ECLIPSE_positive")
        elseif amount < 0 then
          color = x.LookupColorByName("color_ECLIPSE_negative")
        end
      else
        color = x.LookupColorByName("color_" .. energy_type )
      end

      -- Default Color will be white
      if not color then
        color = {1,1,1}
      end

      x:AddMessage("power", sformat(format_energy, message, ShowEnergyTypes() and _G[energy_type] or ""), color)

    end,


   --[==[
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
		]==]
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
      local message = sformat(format_gain_rune, x.runeIcons[4], COMBAT_TEXT_RUNE_DEATH, x.runeIcons[4])
      x:AddSpamMessage("power", RUNES, message, x.runecolors[4], 1)
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

  ["UNIT_PET"] = function()
      x:UpdatePlayer()
    end,

  ["ACTIVE_TALENT_GROUP_CHANGED"] = function() x:UpdatePlayer(); x:UpdateComboTracker() end,    -- x:UpdateComboPointOptions(true) end,

  ["CHAT_MSG_LOOT"] = function(msg)
      -- Fixing Loot for Legion
      local preMessage, linkColor, itemString, itemName, amount = string.match(msg, format_getItemString)

      -- Decode item string: (linkQuality for pets only)
      local linkType, linkID, _, linkQuality = strsplit(':', itemString)

      -- TODO: Clean up this debug scratch stuff
      --"([^|]*)|cff(%x*)|H([^:]*):(%d+):%d+:(%d+):[-?%d+:]+|h%[?([^%]]*)%]|h|r?%s?x?(%d*)%.?"
      -- "|cff0070dd|Hbattlepet:1343:1:3:158:10:12:BattlePet-0-000002C398CB|h[Bonkers]|h|r" - C_PetJournal.GetPetInfoBySpeciesID(1343)
      -- "|cff9d9d9d|Hbattlepet:467:1:0:140:9:9:BattlePet-0-000002C398C4|h[Dung Beetle]|h|r" - C_PetJournal.GetPetInfoBySpeciesID(467)
      -- GetItemQualityColor(3)

      -- local format_getItemString = "([^|]+)|cff(%x+)|H([^|]+)|h%[([^%]]+)%]|h|r[^%d]*(%d*)"
      -- "|cffffffff|Hitem:119299::::::::100:252::::::|h[드레노어 기계공학의 비밀]|h|r을 만들었습니다."

      if TrackSpells() then
        x.spellCache.items[linkID] = true
      end

      if IsItemFiltered( linkID ) then return end

      -- Check to see if this is a battle pet
      if linkType == "battlepet" then
        -- TODO: Add pet icons!
        local speciesName, speciesIcon, petType = C_PetJournal.GetPetInfoBySpeciesID(linkID)
        local petTypeName = PET_TYPE_SUFFIX[petType]
        local message = sformat(format_pet, speciesName, petTypeName)

        local r, g, b = GetItemQualityColor(linkQuality or 0)

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

            -- Enqueue the item to wait 1 second before showing
            tinsert(x.lootUpdater.items, { id=linkID, message=message, t=0, r=r, g=g, b=b, })

            if not x.lootUpdater.isRunning then
              x.lootUpdater:SetScript("OnUpdate", LootFrame_OnUpdate)
              x.lootUpdater.isRunning = true
            end
          else

            -- Add the message
            x:AddMessage("loot", sformat(message, ""), {r, g, b})
          end
        end
      end
    end,
  ["CHAT_MSG_CURRENCY"] = function(msg)
      if not ShowLootCurrency() then return end
      -- get currency from chat
      local currencyLink, amountGained = msg:match(format_currency_multiple)
      if not currencyLink then
        amountGained, currencyLink = 1, msg:match(format_currency_single)

        if not currencyLink then
          return
        end
      end

      -- get currency info
      local name, amountOwned, texturePath = _G.GetCurrencyInfo(tonumber(currencyLink:match("currency:(%d+)")))

      -- format curency
      -- "%s: %s [%s] |cff798BDDx%s|r |cffFFFF00(%s)|r"
      local message = sformat(format_currency,
        _G.CURRENCY,
        ShowLootIcons()
          and sformat(format_loot_icon,
            texturePath,
            GetLootIconSize(),
            GetLootIconSize())
          or "",
        name,
        amountGained,
        amountOwned
      )

      -- Add the message
      x:AddMessage("loot", message, {1, 1, 1})
    end,
  ["CHAT_MSG_MONEY"] = function(msg)
      if not ShowLootMoney() then return end
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

-- TODO: remove this lol
--[==[
x.outgoing_events = {
  ["SPELL_PERIODIC_HEAL"] = function(...)
      if not ShowHealing() or not ShowHots() then return end

      local spellID, spellName, spellSchool, amount, overhealing, absorbed, critical = select(12, ...)
      local merged, outputFrame, color = false, critical and "critical" or "outgoing", "healingOutPeriodic"

      -- Keep track of spells that go by
      if TrackSpells() then x.spellCache.spells[spellID] = true end

      -- Filter Ougoing Healing Spell or Amount
      if IsSpellFiltered(spellID) or FilterOutgoingHealing(amount) then return end

      -- Filter Overhealing
      if not ShowOverHealing() then
        local realamount = amount - overhealing
        if realamount < 1 then
          return
        end
        amount = realamount
      end

      -- Condensed Critical Merge
      if IsMerged(spellID) then
        merged = true
        if critical then
          if MergeCriticalsByThemselves() then
            x:AddSpamMessage(outputFrame, spellID, amount, color)
            return
          elseif MergeCriticalsWithOutgoing() then
            x:AddSpamMessage("outgoing", spellID, amount, color)
          elseif MergeHideMergedCriticals() then
            x:AddSpamMessage("outgoing", spellID, amount, color)
            return
          end
        else
          x:AddSpamMessage(outputFrame, spellID, amount, color)
          return
        end
      end

      xCTFormat:SPELL_PERIODIC_HEAL( outputFrame, spellID, amount, critical, merged )
    end,

  ["SPELL_HEAL"] = function(...)
      if not ShowHealing() then return end

      local spellID, spellName, spellSchool, amount, overhealing, absorbed, critical = select(12, ...)
      local merged, outputFrame, color = false, critical and "critical" or "outgoing", critical and "healingOutCritical" or "healingOut"

      -- Keep track of spells that go by
      if TrackSpells() then x.spellCache.spells[spellID] = true end

      -- Filter Ougoing Healing Spell or Amount
      if IsSpellFiltered(spellID) or FilterOutgoingHealing(amount) then return end

      -- Filter Overhealing
      if not ShowOverHealing() then
        local realamount = amount - overhealing
        if realamount < 1 then
          return
        end
        amount = realamount
      end

      -- Condensed Critical Merge
      if IsMerged(spellID) then
        merged = true
        if critical then
          if MergeCriticalsByThemselves() then
            x:AddSpamMessage(outputFrame, spellID, amount, color)
            return
          elseif MergeCriticalsWithOutgoing() then
            x:AddSpamMessage("outgoing", spellID, amount, color)
          elseif MergeHideMergedCriticals() then
            x:AddSpamMessage("outgoing", spellID, amount, color)
            return
          end
        else
          x:AddSpamMessage(outputFrame, spellID, amount, color)
          return
        end
      end

      xCTFormat:SPELL_HEAL( outputFrame, spellID, amount, critical, merged )
    end,

  ["SWING_DAMAGE"] = function(...)
      if not ShowDamage() then return end

      local _, _, _, sourceGUID, _, sourceFlags, _, _, _, _, _,  amount, _, _, _, _, _, critical, glancing, crushing, isOffHand = ...
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

      -- Check for Critical Swings
      if critical then
        if ShowSwingCrit() then
          outputFrame = "critical"
        elseif not ShowAutoAttack() then
          return
        end
        -- Dont need to change the ouputFrame if ShowAutoAttack() is true
      else
        if not ShowAutoAttack() then return end
      end

      -- Check to see if we merge swings
      if MergeMeleeSwings() then
        merged = true
        if outputFrame == "critical" then
          if MergeCriticalsByThemselves() then
            x:AddSpamMessage(outputFrame, spellID, amount, outputColor, 6)
            return
          elseif MergeCriticalsWithOutgoing() then
            x:AddSpamMessage("outgoing", spellID, amount, outputColor, 6)
          elseif MergeHideMergedCriticals() then
            x:AddSpamMessage("outgoing", spellID, amount, outputColor, 6)
            return
          end
          -- MergeDontMergeCriticals() don't need to do anything for this one
        else
          x:AddSpamMessage(outputFrame, spellID, amount, outputColor, 6)
          return
        end
      end

      xCTFormat:SWING_DAMAGE( outputFrame, spellID, amount, critical, merged )
    end,

  ["RANGE_DAMAGE"] = function(...)
      if not ShowDamage() then return end

      local _, _, _, sourceGUID, _, sourceFlags, _, _, _, _, _,  spellID, _, _, amount, _, _, _, _, _, critical, glancing, crushing, isOffHand = ...
      local outputFrame, outputColor = "outgoing", "genericDamage"
      local merged = false

      -- Keep track of spells that go by
      if TrackSpells() then x.spellCache.spells[spellID] = true end

      -- Filter Outgoing Damage
      if IsSpellFiltered(spellID) or FilterOutgoingDamage(amount) then return end

      -- Auto Shot's Spell ID
      local autoShot = (spellID == 75)

      -- Check for Critical Auto Attacks
      if critical then
        if ShowSwingCrit() then
          outputFrame = "critical"
        elseif not ShowAutoAttack() then
          return
        end
        -- Dont need to change the ouputFrame if ShowAutoAttack() is true
      else
        if not ShowAutoAttack() then return end
      end

      -- Check to see if we merge swings
      if MergeMeleeSwings() then
        merged = true
        if outputFrame == "critical" then
          if MergeCriticalsByThemselves() then
            x:AddSpamMessage(outputFrame, spellID, amount, outputColor, 6)
            return
          elseif MergeCriticalsWithOutgoing() then
            x:AddSpamMessage("outgoing", spellID, amount, outputColor, 6)
          elseif MergeHideMergedCriticals() then
            x:AddSpamMessage("outgoing", spellID, amount, outputColor, 6)
            return
          end
          -- MergeDontMergeCriticals() don't need to do anything for this one
        else
          x:AddSpamMessage(outputFrame, spellID, amount, outputColor, 6)
          return
        end
      end

      xCTFormat:RANGE_DAMAGE( outputFrame, spellID, amount, critical, merged, autoShot )
    end,

  ["SPELL_DAMAGE"] = function(...)
      if not ShowDamage() then return end

      local timestamp, event, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, spellID, spellName, spellSchool, amount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing, isOffHand = select(1, ...)
      local merged, outputFrame, color = false, critical and "critical" or "outgoing", GetCustomSpellColorFromIndex(spellSchool)

      -- Keep track of spells that go by
      if TrackSpells() then x.spellCache.spells[spellID] = true end

      -- Filters: Specific Spell, or Amount
      if IsSpellFiltered(spellID) or FilterOutgoingDamage(amount) then return end

      -- Condensed Critical Merge
      if IsMerged(spellID) then
        merged = true
        if critical then
          if MergeCriticalsByThemselves() then
            x:AddSpamMessage(outputFrame, spellID, amount, color)
            return
          elseif MergeCriticalsWithOutgoing() then
            x:AddSpamMessage("outgoing", spellID, amount, color)
          elseif MergeHideMergedCriticals() then
            x:AddSpamMessage("outgoing", spellID, amount, color)
            return
          end
        else
          x:AddSpamMessage(outputFrame, spellID, amount, color)
          return
        end
      end

      xCTFormat:SPELL_DAMAGE( outputFrame, spellID, amount, critical, merged, spellSchool )
    end,

  ["SPELL_PERIODIC_DAMAGE"] = function(...)
      if not ShowDamage() or not ShowDots() then return end

      local _, _, _, sourceGUID, _, sourceFlags, _, _, _, _, _,  spellID, _, spellSchool, amount, _, _, _, _, _, critical, glancing, crushing, isOffHand = ...
      local merged, outputFrame, color = false, critical and "critical" or "outgoing", GetCustomSpellColorFromIndex(spellSchool)

      -- Keep track of spells that go by
      if TrackSpells() then x.spellCache.spells[spellID] = true end

      -- Filters: Specific Spell, or Amount
      if IsSpellFiltered(spellID) or FilterOutgoingDamage(amount) then return end

      -- Condensed Critical Merge
      if IsMerged(spellID) then
        merged = true
        if critical then
          if MergeCriticalsByThemselves() then
            x:AddSpamMessage(outputFrame, spellID, amount, color)
            return
          elseif MergeCriticalsWithOutgoing() then
            x:AddSpamMessage("outgoing", spellID, amount, color)
          elseif MergeHideMergedCriticals() then
            x:AddSpamMessage("outgoing", spellID, amount, color)
            return
          end
        else
          x:AddSpamMessage(outputFrame, spellID, amount, color)
          return
        end
      end

      xCTFormat:SPELL_PERIODIC_DAMAGE( outputFrame, spellID, amount, critical, merged, spellSchool )
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
      message = x:GetSpellTextureFormatted( spellID,
                                            message,
           x.db.profile.frames[outputFrame].iconsEnabled and x.db.profile.frames[outputFrame].iconsSize or -1,
           x.db.profile.frames[outputFrame].fontJustify )

      x:AddMessage(outputFrame, message, outputColor)
    end,

  ["SPELL_MISSED"] = function(...)
      local _, _, _, sourceGUID, _, sourceFlags, _, _, _, _, _,  spellID, _, _, missType = ...
      local outputFrame, message, outputColor = "outgoing", _G[missType], "misstypesOut"

      if missType == "IMMUNE" and not ShowImmunes() then return end
      if missType ~= "IMMUNE" and not ShowMisses() then return end

      -- Add Icons
      message = x:GetSpellTextureFormatted( spellID,
                                            message,
           x.db.profile.frames[outputFrame].iconsEnabled and x.db.profile.frames[outputFrame].iconsSize or -1,
           x.db.profile.frames[outputFrame].fontJustify )

      x:AddMessage(outputFrame, message, outputColor)
    end,

  ["RANGE_MISSED"] = function(...)
      local _, _, _, sourceGUID, _, sourceFlags, _, _, _, _, _,  spellID, _, _, missType = ...
      local outputFrame, message, outputColor = "outgoing", _G[missType], "misstypesOut"

      if missType == "IMMUNE" and not ShowImmunes() then return end
      if missType ~= "IMMUNE" and not ShowMisses() then return end

      -- Add Icons
      message = x:GetSpellTextureFormatted( spellID,
                                            message,
           x.db.profile.frames[outputFrame].iconsEnabled and x.db.profile.frames[outputFrame].iconsSize or -1,
           x.db.profile.frames[outputFrame].fontJustify )

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
      message = x:GetSpellTextureFormatted( spellID,
                                            message,
           x.db.profile.frames[outputFrame].iconsEnabled and x.db.profile.frames[outputFrame].iconsSize or -1,
           x.db.profile.frames[outputFrame].fontJustify,
                                            nil,
                                            nil,
                                            true )

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
      message = x:GetSpellTextureFormatted( spellID,
                                            message,
           x.db.profile.frames[outputFrame].iconsEnabled and x.db.profile.frames[outputFrame].iconsSize or -1,
           x.db.profile.frames[outputFrame].fontJustify,
                                            nil,
                                            nil,
                                            true )

      x:AddMessage(outputFrame, message, outputColor)
    end,

  ["SPELL_INTERRUPT"] = function(...)
      if not ShowInterrupts() then return end

      local _, _, _, sourceGUID, _, sourceFlags, _, _, _, _, _,  target, _, _,  spellID, effect = ...
      local outputFrame, message, outputColor = "general", sformat(format_dispell, INTERRUPTED, effect), "interrupts"

      -- Add Icons
      message = x:GetSpellTextureFormatted( spellID,
                                            message,
           x.db.profile.frames[outputFrame].iconsEnabled and x.db.profile.frames[outputFrame].iconsSize or -1,
           x.db.profile.frames[outputFrame].fontJustify,
                                            nil,
                                            nil,
                                            true )

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
]==]

-- =====================================================
--                  Format Name Things
-- =====================================================

-- Changes a color table into a hex string

local function hexNameColor(t)
	if type(t) == "string" then
		return "ff"..t
	elseif not t then
		return "ffFFFFFF"
	elseif t.colorStr then -- Support Blizzard's raid colors
		return t.colorStr
	end
	return sformat("ff%2X%2X%2X", mfloor(t[1]*255+.5), mfloor(t[2]*255+.5), mfloor(t[3]*255+.5))
end

-- Checks the options you provide and outputs the correctly formated name
local function formatNameHelper(name, enableColor, color, enableCustomColor, customColor)
	if enableColor then
		if enableCustomColor then
			return "|c"..hexNameColor(customColor)..name.."|r"
		end
		return "|c"..hexNameColor(color)..name.."|r"
	end
	return "|cffFFFFFF"..name.."|r"
end

-- Format Handlers for name
local CLASS_LOOKUP = {
	[1] = "DEATHKNIGHT",
	[2] = "DEMONHUNTER",
	[4] = "DRUID",
	[8] = "HUNTER",
	[16] = "MAGE",
	[32] = "MONK",
	[64] = "PALADIN",
	[128] = "PRIEST",
	[256] = "ROGUE",
	[512] = "SHAMAN",
	[1024] = "WARLOCK",
	[2048] = "WARRIOR"
}

local formatNameTypes
formatNameTypes = {
	function (args, settings, isSource) -- [1] = Source/Destination Name
		local guid, name, color = isSource and args.sourceGUID or args.destGUID, isSource and args.sourceName or args.destName

		if settings.removeRealmName then
			name = smatch(name, format_remove_realm) or name
		end

		if settings.enableNameColor and not settings.enableCustomNameColor then
			if args.prefix == "ENVIRONMENTAL" then
				color = x.spellColors[args.school or args.spellSchool or 1]
			else
				if smatch(guid, "^Player") then
					local _, class = GetPlayerInfoByGUID(guid)
					color = RAID_CLASS_COLORS[class or 0]
				end
			end
		end

		return formatNameHelper(name,
		               settings.enableNameColor,
		                        color,
		               settings.enableCustomNameColor,
		               settings.customNameColor)
	end,

	function (args, settings, isSource) -- [2] = Spell Name
		local color
			if settings.enableNameColor and not settings.enableCustomNameColor then

			-- NOTE: I don't think we want the spell school of the spell
			--       being cast. We want the spell school of the damage
			--       being done. That said, if you want to change it so
			--       that the spell name matches the type of spell it
			--       is, and not the type of damage it does, change
			--       "args.school" to "args.spellSchool".
			color = x.GetSpellSchoolColor(args.school or args.spellSchool)
		end

		return formatNameHelper(args.spellName,
		                    settings.enableSpellColor,
		                             color,
		                    settings.enableCustomSpellColor,
		                    settings.customSpellColor)
	end,

	function (args, settings, isSource) -- [3] = Source Name - Spell Name
		if args.hideCaster then
			return formatNameTypes[2](args, settings, isSource)
		end

		return formatNameTypes[1](args, settings, isSource) .. " - " .. formatNameTypes[2](args, settings, isSource)
	end,

	function (args, settings, isSource) -- [4] = Spell Name - Source Name
		if args.hideCaster then
			return formatNameTypes[2](args, settings, isSource)
		end

		return formatNameTypes[2](args, settings, isSource) .. " - " .. formatNameTypes[1](args, settings, isSource)
	end
}

-- Check to see if the name needs for be formated, if so, handle all the logistics
function x.formatName(args, settings, isSource)
	-- Event Type helper
	local eventType = settings[isSource and args:GetSourceController() or args:GetDestinationController()]

	-- If we have a valid event type that we can handle
	if eventType and eventType.nameType > 0 then
		return settings.namePrefix .. formatNameTypes[eventType.nameType](args, eventType, isSource) .. settings.namePostfix
	end
	return "" -- Names not supported
end

local missTypeColorLookup = {
	['MISS'] = 'missTypeMiss',
	['DODGE'] = 'missTypeDodge',
	['PARRY'] = 'missTypeParry',
	['EVADE'] = 'missTypeEvade',
	['IMMUNE'] = 'missTypeImmune',
	['DEFLECT'] = 'missTypeDeflect',
	['REFLECT'] = 'missTypeReflect'
}


-- =====================================================
--               The New Combat Handlers
-- =====================================================
local CombatEventHandlers = {
	["ShieldOutgoing"] = function (args)
		local settings, value = x.db.profile.frames['outgoing'], select(17, UnitBuff(args.destName, args.spellName))
		if not value or value <= 0 then return end

		-- Keep track of spells that go by
		if TrackSpells() then x.spellCache.spells[args.spellId] = true end

		-- Filter Ougoing Healing Spell or Amount
		if IsSpellFiltered(args.spellId) or FilterOutgoingHealing(args.amount) then return end

		-- Create the message
		local message = x:Abbreviate(value, 'outgoing')

		message = x:GetSpellTextureFormatted(args.spellId,
			                                   message,
			    x.db.profile.frames['outgoing'].iconsEnabled and x.db.profile.frames['outgoing'].iconsSize or -1,
			    x.db.profile.frames['outgoing'].fontJustify)

		-- Add names
		message = message .. x.formatName(args, settings.names, true)

		x:AddMessage('outgoing', message, 'shieldTaken')
	end,

	["HealingOutgoing"] = function (args)
		local spellID, isHoT, merged = args.spellId, args.prefix == "SPELL_PERIODIC"

		-- Keep track of spells that go by
		if TrackSpells() then x.spellCache.spells[spellID] = true end

		if not ShowHealing() then return end

		-- Check to see if this is a HoT
		if isHoT and not ShowHots() then return end

		-- Filter Ougoing Healing Spell or Amount
		if IsSpellFiltered(spellID) or FilterOutgoingHealing(args.amount) then return end

		-- Filter Overhealing
		local amount = args.amount
		if not ShowOverHealing() then
			amount = amount - args.overhealing
			if amount < 1 then
				return
			end
		end

		-- Figure out which frame and color to output
		local outputFrame, outputColor, critical = "outgoing", "healingOut", args.critical
		if critical then
			outputFrame = "critical"
			outputColor = "healingOutCritical"
		end

		-- HoTs only have one color
		if isHoT then outputColor = "healingOutPeriodic"end

		-- Condensed Critical Merge
		if IsMerged(spellID) then
			merged = true
			if critical then
				if MergeCriticalsByThemselves() then
					x:AddSpamMessage(outputFrame, spellID, amount, outputColor)
					return
				elseif MergeCriticalsWithOutgoing() then
					x:AddSpamMessage("outgoing", spellID, amount, outputColor)
				elseif MergeHideMergedCriticals() then
					x:AddSpamMessage("outgoing", spellID, amount, outputColor)
					return
				end
			else
				x:AddSpamMessage(outputFrame, spellID, amount, outputColor)
				return
			end
		end

		if args.event == "SPELL_PERIODIC_HEAL" then
			xCTFormat:SPELL_PERIODIC_HEAL(outputFrame, spellID, amount, critical, merged)
		elseif args.event == "SPELL_HEAL" then
			xCTFormat:SPELL_HEAL(outputFrame, spellID, amount, critical, merged)
		else
			if UnitName('player') == "Dandraffbal" then
				print("xCT Needs Some Help: unhandled _HEAL event", args.event)
			end
		end
	end,

	["DamageOutgoing"] = function (args)
		local critical, spellID, amount, merged = args.critical, args.spellId, args.amount
		local isEnvironmental, isSwing, isAutoShot, isDoT = args.prefix == "ENVIRONMENTAL", args.prefix == "SWING", spellID == 75, args.prefix == "SPELL_PERIODIC"
		local outputFrame, outputColor = "outgoing", x.GetSpellSchoolColor(args.spellSchool or 1, critical)

		-- Keep track of spells that go by (Don't track Swings or Environmental damage)
		if not isEnvironmental and not isSwing and TrackSpells() then x.spellCache.spells[spellID] = true end

		if not ShowDamage() then return end
		if isSwing and not args:IsSourceMyPet() and not args:IsSourceMyVehicle() and not ShowAutoAttack() then return end

		-- Filter Ougoing Damage Spell or Amount
		if IsSpellFiltered(spellID) or FilterOutgoingDamage(amount) then return end

		-- Check to see if my pet is doing things
		if args:IsSourceMyPet() then
			if not ShowPetDamage() then return end
			if MergePetAttacks() then
				local icon = GetPetIcon() or ""
				x:AddSpamMessage(outputFrame, icon, amount, x.db.profile.spells.mergePetColor, 6)
				return
			end
			if not ShowPetCrits() then
				critical = nil -- stupid spam fix for hunter pets
			end
			if isSwing then
				spellID = 0 -- this will get fixed later
			end
		end

		if args:IsSourceMyVehicle() then
			if not ShowVehicleDamage() then return end
			if not ShowPetCrits() then
				critical = nil -- stupid spam fix for hunter pets
			end
			if isSwing then
				spellID = 0 -- this will get fixed later
			end
		end

		-- Check for Critical Swings
		if critical then
			if (isSwing or isAutoShot) and ShowSwingCrit() then
				outputFrame = "critical"
			elseif not isSwing and not isAutoShot then
				outputFrame = "critical"
			end
		end

		if (isSwing or isAutoShot) and MergeMeleeSwings() then
			merged = true
			if outputFrame == "critical" then
				if MergeCriticalsByThemselves() then
					x:AddSpamMessage(outputFrame, spellID, amount, outputColor, 6)
					return
				elseif MergeCriticalsWithOutgoing() then
					x:AddSpamMessage("outgoing", spellID, amount, outputColor, 6)
				elseif MergeHideMergedCriticals() then
					x:AddSpamMessage("outgoing", spellID, amount, outputColor, 6)
					return
				end
			else
				x:AddSpamMessage(outputFrame, spellID, amount, outputColor, 6)
				return
			end
		elseif not isSwing and not isAutoShot and IsMerged(spellID) then
			merged = true
			if critical then
				if MergeCriticalsByThemselves() then
					x:AddSpamMessage(outputFrame, spellID, amount, outputColor)
					return
				elseif MergeCriticalsWithOutgoing() then
					x:AddSpamMessage("outgoing", spellID, amount, outputColor)
				elseif MergeHideMergedCriticals() then
					x:AddSpamMessage("outgoing", spellID, amount, outputColor)
					return
				end
			else
				x:AddSpamMessage(outputFrame, spellID, amount, outputColor)
				return
			end
		end

		if args.event == "SWING_DAMAGE" then
			xCTFormat:SWING_DAMAGE(outputFrame, spellID, amount, critical, merged, args)

		elseif args.event == "RANGE_DAMAGE" then
			xCTFormat:RANGE_DAMAGE(outputFrame, spellID, amount, critical, merged, isAutoShot, args)

		elseif args.event == "SPELL_DAMAGE" or args.event == "DAMAGE_SHIELD" then
			xCTFormat:SPELL_DAMAGE(outputFrame, spellID, amount, critical, merged, args.spellSchool, args)

		elseif args.event == "SPELL_PERIODIC_DAMAGE" then
			xCTFormat:SPELL_PERIODIC_DAMAGE(outputFrame, spellID, amount, critical, merged, args.spellSchool, args)

		else
			if UnitName('player') == "Dandraffbal" then
				print("xCT Needs Some Help: unhandled _DAMAGE event", args.event)
			end
		end
	end,

	["DamageIncoming"] = function (args)
		local message
		local settings = x.db.profile.frames["damage"]

		-- Keep track of spells that go by
		if args.spellId and TrackSpells() then x.spellCache.damage[args.spellId] = true end


		if IsDamageFiltered(args.spellId or false) then return end

		-- Check for resists
		if ShowResistances() then
			if FilterIncomingDamage(args.amount + (args.resisted or 0) + (args.blocked or 0) + (args.absorbed or 0)) then return end

			local resistedAmount, resistType, color

			-- Check for resists (full and partials)
			if (args.resisted or 0) > 0 then
				resistType, resistedAmount = RESIST, args.amount > 0 and args.resisted
				color = resistedAmount and 'missTypeResist' or 'missTypeResistPartial'
			elseif (args.blocked or 0) > 0 then
				resistType, resistedAmount = BLOCK, args.amount > 0 and args.blocked
				color = resistedAmount and 'missTypeBlock' or 'missTypeBlockPartial'
			elseif (args.absorbed or 0) > 0 then
				resistType, resistedAmount = BLOCK, args.amount > 0 and args.absorbed
				color = resistedAmount and 'missTypeAbsorb' or 'missTypeAbsorbPartial'
			end

			if resistType then
				-- Craft the new message (if is partial)
				if resistedAmount then
					-- format_resist: "-%s |c%s(%s %s)|r"
					color = hexNameColor(x.LookupColorByName(color))
					message = sformat(format_resist, x:Abbreviate(args.amount, 'damage'), color, resistType, x:Abbreviate(resistedAmount, 'damage'))
				else
					-- It was a full resist
					message = resistType	-- TODO: Add an option to still see how much was reisted on a full resist
				end
			end
		else
			if FilterIncomingDamage(args.amount) then return end
		end

		-- If this is not a resist, then lets format it as normal
		if not message then
			-- Format Criticals and also abbreviate values
			if args.critical then
				message = sformat(format_crit, x.db.profile.frames["critical"].critPrefix,
				                               x:Abbreviate(-args.amount, 'damage'),
				                               x.db.profile.frames["critical"].critPostfix)
			else
				message = x:Abbreviate(-args.amount, 'damage')
			end
		end

		-- TODO: Add merge settings

		-- Add names
		message = message .. x.formatName(args, settings.names, true)

		-- Add Icons (Hide Auto Attack icons)
		if args.prefix ~= "SWING" or ShowIncomingAutoAttackIcons() then
			message = x:GetSpellTextureFormatted(args.spellId,
			                                     message,
			       x.db.profile.frames['damage'].iconsEnabled and x.db.profile.frames['damage'].iconsSize or -1,
			       x.db.profile.frames['damage'].fontJustify)
		else
			message = x:GetSpellTextureFormatted(nil,
			                                     message,
			       x.db.profile.frames['damage'].iconsEnabled and x.db.profile.frames['damage'].iconsSize or -1,
			       x.db.profile.frames['damage'].fontJustify)
		end

		-- Output message
		x:AddMessage('damage', message, x.GetSpellSchoolColor(args.spellSchool))
	end,

	["ShieldIncoming"] = function (args)
		local settings, value = x.db.profile.frames['healing'], select(17, UnitBuff("player", args.spellName))
		if not value or value <= 0 then return end

		if TrackSpells() then x.spellCache.healing[args.spellId] = true end

		if IsHealingFiltered(args.spellId) then return end

		-- Create the message
		local message = sformat(format_gain, x:Abbreviate(value, "healing"))

		message = x:GetSpellTextureFormatted(args.spellId,
			                                   message,
			    x.db.profile.frames['healing'].iconsEnabled and x.db.profile.frames['healing'].iconsSize or -1,
			    x.db.profile.frames['healing'].fontJustify)

		-- Add names
		message = message .. x.formatName(args, settings.names, true)

		x:AddMessage('healing', message, 'shieldTaken')
	end,

	["HealingIncoming"] = function (args)
		local amount, isHoT, spellID = args.amount, args.prefix == "SPELL_PERIODIC", args.spellId
		local color = isHoT and "healingTakenPeriodic" or args.critical and "healingTakenCritical" or "healingTaken"
		local settings = x.db.profile.frames["healing"]

		if TrackSpells() then x.spellCache.healing[args.spellId] = true end

		if IsHealingFiltered(args.spellId) then return end

		-- Adjust the amount if the user doesnt want over healing
		if not ShowOverHealing() then
			amount = amount - args.overhealing
		end

		-- Filter out small amounts
		if amount <= 0 or FilterIncomingHealing(amount) then return end

		if ShowOnlyMyHeals() and not args.isPlayer then
			if ShowOnlyMyPetsHeals() and args:IsSourceMyPet() then
				-- If its the pet, then continue
			else
				return
			end
		end

		-- format_gain = "+%s"
		local healer_name, message = args.sourceName, sformat(format_gain, x:Abbreviate(amount,"healing"))

		if MergeIncomingHealing() then
			x:AddSpamMessage("healing", x.formatName(args, settings.names, true), amount, "healingTaken", 5)
		else
			-- Add names
			message = message .. x.formatName(args, settings.names, true)

			-- Add the icon
			message = x:GetSpellTextureFormatted(args.spellId,
			                                          message,
			           x.db.profile.frames['healing'].iconsEnabled and x.db.profile.frames['healing'].iconsSize or -1,
			           x.db.profile.frames['healing'].fontJustify)

			x:AddMessage("healing", message, color)
		end
	end,

	["AuraIncoming"] = function (args)
		-- Some useful information about the event
		local isBuff, isGaining = args.auraType == "BUFF", args.suffix == "_AURA_APPLIED" or args.suffix == "_AURA_APPLIED_DOSE"

		-- Track the aura
		if TrackSpells() then x.spellCache[isBuff and 'buffs' or 'debuffs'][args.spellName]=true end

		-- Check to see if we are filtering this spell's name
		if IsBuffFiltered(args.spellName) then return end

		-- See if we are showing that type of aura
		if isBuff and not ShowBuffs() or not ShowDebuffs() then return end

		-- Begin constructing the event message and color
		local color, message
		if isGaining then
			message = sformat(format_gain, args.spellName)
			color = isBuff and 'buffsGained' or 'debuffsGained'
		else
			message = sformat(format_fade, args.spellName)
			color = isBuff and 'buffsFaded' or 'debuffsFaded'
		end

		-- Add the icon
		message = x:GetSpellTextureFormatted(args.spellId,
		                                          message,
		           x.db.profile.frames['general'].iconsEnabled and x.db.profile.frames['general'].iconsSize or -1,
		           x.db.profile.frames['general'].fontJustify)

		x:AddMessage('general', message, color)
	end,

	["KilledUnit"] = function (args)
		if not ShowPartyKill() then return end

		local color = 'killingBlow'
		if args.destGUID then
			local class = select(2, GetPlayerInfoByGUID(args.destGUID))
			if RAID_CLASS_COLORS[class] then
				color = RAID_CLASS_COLORS[class]
			end
		end

		x:AddMessage('general', sformat(format_dispell, XCT_KILLED, args.destName), color)
	end,

	["InterruptedUnit"] = function (args)
		if not ShowInterrupts() then return end

		-- Create and format the message
		local message = sformat(format_dispell, INTERRUPTED, args.extraSpellName)

		-- Add the icon
		message = x:GetSpellTextureFormatted(args.extraSpellId,
		                                          message,
		           x.db.profile.frames['general'].iconsEnabled and x.db.profile.frames['general'].iconsSize or -1,
		           x.db.profile.frames['general'].fontJustify)

		x:AddMessage('general', message, 'interrupts')
	end,

	["OutgoingMiss"] = function (args)
		local message, spellId = _G["COMBAT_TEXT_"..args.missType], args.spellId

		-- If this is a melee swing, it could also be our pets
		if args.prefix == 'SWING' then
			if not ShowAutoAttack() then return end
			if args:IsSourceMyPet() then
				spellId = PET_ATTACK_TEXTURE
			else
				spellId = 6603
			end
		end

		-- Check for filtered immunes
		if args.missType == "IMMUNE" and not ShowImmunes() then return end
		if args.missType ~= "IMMUNE" and not ShowMisses() then return end

		-- Add Icons
		message = x:GetSpellTextureFormatted(spellId,
		                                     message,
		     x.db.profile.frames['outgoing'].iconsEnabled and x.db.profile.frames['outgoing'].iconsSize or -1,
		     x.db.profile.frames['outgoing'].fontJustify)

		x:AddMessage('outgoing', message, 'misstypesOut')
	end,

	["IncomingMiss"] = function (args)
		if not ShowMissTypes() then return end

		local message = _G["COMBAT_TEXT_"..args.missType]

		-- Add Icons
		message = x:GetSpellTextureFormatted(args.extraSpellId,
		                                          message,
		          x.db.profile.frames['damage'].iconsEnabled and x.db.profile.frames['damage'].iconsSize or -1,
		          x.db.profile.frames['damage'].fontJustify)

		x:AddMessage('damage', message, missTypeColorLookup[args.missType] or 'misstypesOut')
	end,

	["SpellDispel"] = function (args)
		if not ShowDispells() then return end

		local color = args.auraType == 'BUFF' and 'dispellBuffs' or 'dispellDebuffs'
		local message = sformat(format_dispell, XCT_DISPELLED, args.extraSpellName)

		-- Add Icons
		message = x:GetSpellTextureFormatted(args.extraSpellId,
		                                          message,
		           x.db.profile.frames['general'].iconsEnabled and x.db.profile.frames['general'].iconsSize or -1,
		           x.db.profile.frames['general'].fontJustify)

		if MergeDispells() then
			x:AddSpamMessage('general', args.extraSpellName, message, color, 0.5)
		else
			x:AddMessage('general', message, color)
		end
	end,

	["SpellStolen"] = function (args)
		if not ShowDispells() then return end
		local message = sformat(format_dispell, XCT_STOLE, args.extraSpellName)

		-- Add Icons
		message = x:GetSpellTextureFormatted(args.extraSpellId,
		                                          message,
		           x.db.profile.frames['general'].iconsEnabled and x.db.profile.frames['general'].iconsSize or -1,
		           x.db.profile.frames['general'].fontJustify)

		x:AddMessage('general', message, 'dispellStolen')
	end,
}

local BuffsOrDebuffs = {
	["_AURA_APPLIED"] = true,
	["_AURA_REMOVED"] = true,
	["_AURA_APPLIED_DOSE"] = true,
	["_AURA_REMOVED_DOSE"] = true,
	--["_AURA_REFRESH"] = true, -- I dont know how we should support this
}

-- List from: http://www.tukui.org/addons/index.php?act=view&id=236
local AbsorbList = {
	-- All
	[187805] = true, -- Etheralus (WoD Legendary Ring)
	[173260] = true, -- Shield Tronic (Like a health potion from WoD)
	[64413]  = true, -- Val'anyr, Hammer of Ancient Kings (WotLK Legendary Mace)
	[82626]  = true, -- Grounded Plasma Shield (Engineer's Belt Enchant)
	[207472] = true, -- Prydaz, Xavaric's Magnum Opus (Legendary Neck)

	-- Coming Soon (Delicious Cake!) Trinket
	--[231290] = true, -- TODO: Figure out which one is correct
	[225723] = true, -- Both are Delicious Cake! from item:140793

	-- Coming Soon (Royal Dagger Haft, item:140791)
	-- Sooooo I dont think this one is going to be trackable... we will see when i can get some logs!
	--[225720] = true, -- TODO: Figure out which is the real one
	--[229457] = true, -- Sands of Time (From the Royal Dagger Haft tinket) (Its probably this one)
	--[229333] = true, -- Sands of Time (From the Royal Dagger Haft tinket)
	--[225124] = true, -- Sands of Time (From the Royal Dagger Haft tinket)

	-- Coming Soon -- Animated Exoskeleton (Trinket, Item: 140789)
	[225033] = true, -- Living Carapace (Needs to be verified)

	-- Coming Soon -- Infernal Contract (Trinket, Item: 140807)
	[225140] = true, -- Infernal Contract (Needs to be verified)



	-- Legion Trinkets
	[221878] = true, -- Buff: Spirit Fragment        - Trinket[138222]: Vial of Nightmare Fog
	[215248] = true, -- Buff: Shroud of the Naglfar  - Trinket[133645]: Naglfar Fare
	[214366] = true, -- Buff: Crystalline Body       - Trinket[137338]: Shard of Rokmora
	[214423] = true, -- Buff: Stance of the Mountain - Trinket[137344]: Talisman of the Cragshaper
	[214971] = true, -- Buff: Gaseous Bubble         - Trinket[137369]: Giant Ornamental Pearl
	[222479] = true, -- Buff: Shadowy Reflection     - Trinket[138225]: Phantasmal Echo

	-- Death Knight
	[48707] = true,  -- Anti-Magic Shield
	[77535] = true,  -- Blood Shield
	[116888] = true, -- Purgatory
	[219809] = true, -- Tombstone

	-- Demon Hunter
	[227225] = true, -- Soul Barrier

	-- Mage
	[11426] = true,  -- Ice Barrier

	-- Monk
	[116849] = true, -- Life Cocoon

	-- Paladin
	[203538] = true, -- Greater Blessing of Kings
	[185676] = true, -- Protection Paladin T18 - 2 piece
	[184662] = true, -- Shield of Vengeance

	--Priest
	[152118] = true, -- Clarity of Will
	[17] = true,     -- Power Word: Shield

	-- Shaman
	[145378] = true, -- Shaman T16 - 2 piece
	[114893] = true, -- Stone Bulwark

	-- Warlock
	[108416] = true, -- Dark Pact
	[108366] = true, -- Soul Leech

	-- Warrior
	[190456] = true, -- Ignore Pain
	[112048] = true, -- Shield Barrier
}

function x.CombatLogEvent (args)
	-- Is the source someone we care about?
	if args.isPlayer or args:IsSourceMyVehicle() or ShowPetDamage() and args:IsSourceMyPet() then
		if args.suffix == "_HEAL" then
			CombatEventHandlers.HealingOutgoing(args)

		elseif args.suffix == "_DAMAGE" then
			CombatEventHandlers.DamageOutgoing(args)

		elseif args.suffix == '_MISSED' then
			CombatEventHandlers.OutgoingMiss(args)

		elseif args.event == 'PARTY_KILL' then
			CombatEventHandlers.KilledUnit(args)

		elseif args.event == 'SPELL_INTERRUPT' then
			CombatEventHandlers.InterruptedUnit(args)

		elseif args.event == 'SPELL_DISPEL' then
			CombatEventHandlers.SpellDispel(args)

		elseif args.event == 'SPELL_STOLEN' then
			CombatEventHandlers.SpellStolen(args)

		elseif (args.suffix == "_AURA_APPLIED" or args.suffix == "_AURA_REFRESH") and AbsorbList[args.spellId] then
			CombatEventHandlers.ShieldOutgoing(args)

		end
	end

	-- Is the destination someone we care about?
	if args.atPlayer or args:IsDestinationMyVehicle() then
		if args.suffix == "_HEAL" then
			CombatEventHandlers.HealingIncoming(args)

		elseif args.suffix == "_DAMAGE" then
			CombatEventHandlers.DamageIncoming(args)

		elseif args.suffix == "_MISSED" then
			CombatEventHandlers.IncomingMiss(args)

		elseif (args.suffix == "_AURA_APPLIED" or args.suffix == "_AURA_REFRESH") and AbsorbList[args.spellId] then
			CombatEventHandlers.ShieldIncoming(args)
		end
	end

	-- Player Auras
	if args.atPlayer and BuffsOrDebuffs[args.suffix] then
		CombatEventHandlers.AuraIncoming(args)

	end
end

