local addon = select(2, ...)
local collect = {}
addon.collect = collect

local	UnitHealth, UnitHealthMax =
		UnitHealth, UnitHealthMax

local spellName = addon.spellName
local deathlogHealFilter = {
	[spellName[5394]] = true, -- Healing Stream Totem
	[spellName[57774]] = true, -- Judgement of Light
	[spellName[23881]] = true, -- Bloodthirst
	[spellName[15286]] = true, -- Vampiric Embrace
}
local deathlogTrackBuffs = {
	--DEATHKNIGHT
	[spellName[48707]] = true, -- Anti-Magic Shell
	[spellName[48792]] = true, -- Icebound Fortitude
	[spellName[54223]] = true, -- Shadow of Death
	[spellName[55233]] = true, -- Vampiric Blood
	-- DRUID
	[spellName[22812]] = true, -- Barkskin
	[spellName[61336]] = true, -- Survival Instincts
	-- HUNTER
	[spellName[19263]] = true, -- Deterrence
	[spellName[5384]] = true, -- Feign Death
	[spellName[63087]] = true, -- Glyph of Raptor Strike
	-- MAGE
	[spellName[45438]] = true, -- Ice Block
	-- PALADIN
	[spellName[498]] = true, -- Divine Protection
	[spellName[642]] = true, -- Divine Shield
	[spellName[1022]] = true, -- Hand of Protection
	[spellName[1044]] = true, -- Hand of Freedom
	[spellName[1038]] = true, -- Hand of Salvation
	[spellName[6940]] = true, -- Hand of Sacrifice
--	[spellName[19752]] = true, -- Divine Intervention
	--PRIEST
	[spellName[47585]] = true, -- Dispersion
	[spellName[33206]] = true, -- Pain Suppression
	[spellName[47788]] = true, -- Guardian Spirit
	[spellName[27827]] = true, -- Spirit of Redemption
	-- ROGUE
	[spellName[31224]] = true, -- Cloak of Shadows
	[spellName[5277]] = true, -- Evasion
	-- SHAMAN
	[spellName[30823]] = true, -- Shamanistic Rage
	-- WARRIOR
	[spellName[871]] = true, -- Shield Wall
	[spellName[2565]] = true, -- Shield Block
	[spellName[12975]] = true, -- Last Stand
	[spellName[23920]] = true, -- Spell Reflection
}

local deathData = {}
local tblCache = {}
local clearEvts = function(playerID)
	local dd = deathData[playerID]
	if not dd then return end
	for i = dd.first, dd.last do
		local v = dd[i]
		dd[i] = nil
		tinsert(tblCache, table.wipe(v))
	end
	tinsert(tblCache, table.wipe(dd))
	deathData[playerID] = nil
end
local getDeathData = function(guid, timestamp, create)
	local dd = deathData[guid]
	if not dd and not create then
		return
	elseif not dd then
		dd = tremove(tblCache) or {}
		deathData[guid] = dd
	elseif timestamp then
		for i = dd.first, dd.last do
			local v = dd[i]
			if v.t > timestamp-10 then
				break
			end
			dd[i] = nil
			if dd.first < dd.last then
				dd.first = dd.first + 1
			else
				dd.first = nil
				dd.last = nil
			end
			tinsert(tblCache, table.wipe(v))
		end
		if not dd.first and not create then
			tinsert(tblCache, table.wipe(dd))
			deathData[guid] = nil
			return
		end
	end
	return dd
end

local fmtDamage = function(entry)
	local srcName = entry[1]
	local spellId, spellSchool = entry[2], entry[3]
	local amount, overkill = entry[4], entry[5]
	local resisted, blocked, absorbed = entry[6], entry[7], entry[8]
	local critical, glancing, crushing = entry[9], entry[10], entry[11]
	local text = string.format("%s#DT#%s:%i:%i:%s:%s:%s:%s:%s", spellId, srcName or "Unknown", spellSchool, amount, overkill > 0 and overkill or "", resisted or "", blocked or "", absorbed or "", critical and "!" or glancing and "v" or crushing and "^" or "")
	if overkill > 0 then
		return text, spellId, srcName or "Unknown", spellSchool, amount
	end
	return text
end
local fmtMiss = function(entry)
	local srcName = entry[1]
	local spellId, spellSchool = entry[2], entry[3]
	local missType, amountMissed = entry[4], entry[5]
	return string.format("%i#DM#%s:%i:%s:%s", spellId, srcName or "Unknown", spellSchool, missType, amountMissed or "")
end
local fmtHealing = function(entry)
	local srcName = entry[1]
	local spellId = entry[2]
	local amount, overhealing = entry[3], entry[4]
	local critical = entry[5]
	return string.format("%i#HT#%s:%i:%s:%s", spellId, srcName, amount, overhealing > 0 and overhealing or "", critical and "!" or "")
end
local fmtDeBuff = function(entry)
	local spellId = entry[1]
	local auraType = entry[2]
	local amount = entry[3]
	local modifier = entry[4]
	return string.format("%i#A%s#%s:%s", spellId, (auraType == "DEBUFF") and "D" or "B", modifier, amount > 1 and amount or "")
end

local function unitDied(timestamp, playerID, playerName)
	local class = addon:GetUnitClass(playerID)
	if not class or class == "PET" then return end
	if class == "HUNTER" and UnitIsFeignDeath(playerName) then return end
	local _, set = addon:GetSets()
	if not set then return end
	set.changed = true
	
	local deathlog = {
		time = timestamp,
	}
	local _spellId, _srcName, _spellSchool, _amount
	local dd = getDeathData(playerID, timestamp)
	if dd then
		for i = dd.first, dd.last do
			local v = dd[i]
			local text, spellId, srcName, spellSchool, amount = v.f(v)
			if spellId then
				_spellId, _srcName , _spellSchool, _amount = spellId, srcName, spellSchool, amount
			end
			tinsert(deathlog, string.format("%0.1f#%.0f#%s", v.t - timestamp, v.hp, text))
			dd[i] = nil
			tinsert(tblCache, table.wipe(v))
		end
		tinsert(tblCache, table.wipe(dd))
		deathData[playerID] = nil
		tinsert(deathlog, "-0.0#0##X#")
	end
	deathlog[0] = string.format("%s#%s#DEATH#%s:%s:%s:%s", playerName, class, _spellId or "", _srcName or "", _spellSchool or "", _amount or "")
	if set.deathlog then
		tinsert(set.deathlog, deathlog)
		set.deathlog.total = set.deathlog.total + 1
	else
		set.deathlog = { deathlog, total=1 }
	end
end
local function unitRezzed(timestamp, playerID, playerName, spellId, rezzerName)
	local class = addon:GetUnitClass(playerID)
	if not class or class == "PET" then return end
	local _, set = addon:GetSets()
	if not set then return end
	set.changed = true
	
	local deathlog = {
		[0] = string.format("%s#%s#REZZ#%i:%s", playerName, class, spellId, rezzerName),
		time = timestamp,
	}
	if set.deathlog then
		tinsert(set.deathlog, deathlog)
		set.deathlog.total = set.deathlog.total + 1
	else
		set.deathlog = { deathlog, total=1 }
	end
	clearEvts(playerID)
end

local addDeathlogEvent = function(playerID, playerName, fmtFunc, timestamp, ...)
	local class = addon:GetUnitClass(playerID)
	if not class or class == "PET" then return end
	local entry = tremove(tblCache) or {}
	entry.hp = ((UnitHealth(playerName)/UnitHealthMax(playerName)) * 100)
	entry.f = fmtFunc
	entry.t = timestamp
	for i = 1, select("#", ...) do
		entry[i] = select(i, ...)
	end
	local dd = getDeathData(playerID, timestamp, true)
	if not dd.first then
		dd.first = 1
		dd.last = 1
	else
		dd.last = dd.last + 1
	end
	dd[dd.last] = entry
	-- hack for DK "Shadow of Death" ghouling
	if fmtFunc == fmtDeBuff and entry[4] == "+" and entry[1] == 54223 then
		unitDied(timestamp, playerID, playerName)
	end
end

function addon:GUIDsUpdated()
	for playerID, dd in pairs(deathData) do
		if not self.guidToClass[playerID] then
			clearEvts(playerID)
		end
	end
end

---- IMPORTANT ABSORBS CATA CHANGES
---- WORK
-- 17 Power Word: Shield
-- 47753 Divine Aegis
-- 86273 Illuminated Healing
-- 88063 Guarded by the Light
---- WORK DIFFERENT
-- 48707 Anti-Magic Shell
---- NOT WORK
-- 543 Mage Ward
-- 6229 Shadow Ward
-- 47788 Guardian Spirit
-- 62606 Savage Defense
-- 64411 Blessing of Ancient Kings (self)
-- 64413 Protection of Ancient Kings

local NotGuessedAbsorb = {
	[17] = 1, -- Power Word: Shield
	[47753] = 1, -- Divine Aegis
	[86273] = 1, -- Illuminated Healing
	[88063] = 1, -- Guarded by the Light
	[48707] = 2, -- Anti-Magic Shell
}

local function addSpellDetails(u, etype, spellID, amount)
	local event = u[etype]
	if not event then
		event = {
			total=amount,
			spell={},
		}
		u[etype] = event
	else
		event.total = event.total+amount
	end
	
	event.spell[spellID] = (event.spell[spellID] or 0) + amount
end
local function addTargetDetails(u, etype, targetName, amount)
	if not targetName then targetName = "Unknown" end
	local t = u[etype].target
	if not t then
		t = {}
		u[etype].target = t
	end
	
	t[targetName] = (t[targetName] or 0) + amount
end

local function updateTime(u, etype, timestamp)
	local last = u[etype].last
	u[etype].last = timestamp
	if not last then return end
	
	local t = u[etype].time or 0
	local gap = timestamp-last
	if gap < 5 then
		t = t + gap
	else
		t = t + 1
	end
	u[etype].time = t
end

local function EVENT(etype, playerID, targetName, spellID, amount, timestamp)
	if not addon.ids[etype] then return end
	if type(amount) ~= "number" then return end
	local all, atm = addon:GetSets()

	-- Total Set
	all.changed = true
	local u = addon:GetUnit(all, playerID)
	addSpellDetails(u, etype, spellID, amount)
	if timestamp then updateTime(u, etype, timestamp) end

	-- Current Set
	if not atm then return end
	atm.changed = true
	local u = addon:GetUnit(atm, playerID)
	addSpellDetails(u, etype, spellID, amount)
	addTargetDetails(u, etype, targetName, amount)
	if timestamp then updateTime(u, etype, timestamp) end
end

local shields = {}
-- COMBAT LOG EVENTS --
function collect.SPELL_DAMAGE(timestamp, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, spellId, spellName, spellSchool, amount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing)
	local srcFriend = addon.guidToClass[srcGUID]
	local dstFriend = addon.guidToClass[dstGUID]
	if dstFriend then
		if srcFriend then
			EVENT("ff", srcGUID, dstName, spellId, amount)
		elseif srcGUID ~= "Environment" then
			addon:EnterCombatEvent(timestamp, srcGUID, srcName)
		end
		EVENT("dt", dstGUID, srcName, spellId, amount)
		if addon.ids.deathlog then
			addDeathlogEvent(dstGUID, dstName, fmtDamage, timestamp, srcName, spellId, spellSchool, amount, overkill, resisted, blocked, absorbed, critical, glancing, crushing)
		end
	elseif srcFriend then
		addon:EnterCombatEvent(timestamp, dstGUID, dstName)
		EVENT("dd", srcGUID, dstName, spellId, amount, timestamp)
	end
end
collect.SPELL_PERIODIC_DAMAGE = collect.SPELL_DAMAGE
collect.SPELL_BUILDING_DAMAGE = collect.SPELL_DAMAGE
collect.RANGE_DAMAGE = collect.SPELL_DAMAGE
collect.DAMAGE_SPLIT = collect.SPELL_DAMAGE
collect.DAMAGE_SHIELD = collect.SPELL_DAMAGE
function collect.SWING_DAMAGE(timestamp, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, amount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing)
	collect.SPELL_DAMAGE(timestamp, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, 6603, spellName[6603], 0x01, amount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing)
end
function collect.ENVIRONMENTAL_DAMAGE(timestamp, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, environmentalType, amount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing)
	collect.SPELL_DAMAGE(timestamp, "Environment", "Environment", srcFlags, dstGUID, dstName, dstFlags, environmentalType, environmentalType, 0x01, amount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing)
end

function collect.SPELL_MISSED(timestamp, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, spellId, spellName, spellSchool, missType, amountMissed)
	if addon.guidToClass[dstGUID] then
		if addon.ids.deathlog then
			addDeathlogEvent(dstGUID, dstName, fmtMiss, timestamp, srcName, spellId, spellSchool, missType, amountMissed)
		end
	end
end
collect.SPELL_PERIODIC_MISSED = collect.SPELL_MISSED
collect.SPELL_BUILDING_MISSED = collect.SPELL_MISSED
collect.RANGE_MISSED = collect.SPELL_MISSED
collect.DAMAGE_SHIELD_MISSED = collect.SPELL_MISSED
function collect.SWING_MISSED(timestamp, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, missType, amountMissed)
	collect.SPELL_MISSED(timestamp, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, 6603, spellName[6603], 0x01, missType, amountMissed)
end

function collect.SPELL_HEAL(timestamp, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, spellId, spellName, spellSchool, amount, overhealing, absorbed, critical)
	if addon.guidToClass[srcGUID] then
		if overhealing > 0 then
			EVENT("oh", srcGUID, dstName, spellId, overhealing)
		end
		EVENT("hd", srcGUID, dstName, spellId, amount - overhealing, timestamp)
	end
	if addon.guidToClass[dstGUID] then
		EVENT("ht", dstGUID, srcName, spellId, amount - overhealing, timestamp)
	end
	if addon.ids.deathlog and addon.guidToClass[dstGUID] and not deathlogHealFilter[spellName] then
		addDeathlogEvent(dstGUID, dstName, fmtHealing, timestamp, srcName, spellId, amount, overhealing, critical)
	end
end
collect.SPELL_PERIODIC_HEAL = collect.SPELL_HEAL

function collect.SPELL_DISPEL(timestamp, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, spellId, spellName, spellSchool, extraSpellID, extraSpellName, extraSchool, auraType)
	if addon.guidToClass[srcGUID] then
		EVENT("dp", srcGUID, dstName, extraSpellID, 1)
	end
end
collect.SPELL_PERIODIC_DISPEL = collect.SPELL_DISPEL

function collect.SPELL_INTERRUPT(timestamp, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, spellId, spellName, spellSchool, extraSpellID, extraSpellName, extraSchool)
	if addon.guidToClass[srcGUID] then
		EVENT("ir", srcGUID, dstName, extraSpellID, 1)
	end
end

function collect.SPELL_ENERGIZE(timestamp, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, spellId, spellName, spellSchool, amount, powerType)
	if addon.guidToClass[dstGUID] then
		EVENT("pg", dstGUID, srcName, spellId, amount)
	end
end
collect.SPELL_PERIODIC_ENERGIZE = collect.SPELL_ENERGIZE

function collect.SPELL_AURA_APPLIED(timestamp, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, spellId, spellName, spellSchool, auraType, ...)
	if addon.ids.deathlog and addon.guidToClass[dstGUID] and (auraType == "DEBUFF" or deathlogTrackBuffs[spellName]) then
		addDeathlogEvent(dstGUID, dstName, fmtDeBuff, timestamp, spellId, auraType, 1, "+")
	end
	local amount = select(NotGuessedAbsorb[spellId] or 1, ...)
	if amount and addon.ids.ga and addon.guidToClass[srcGUID] then
		shields[dstGUID] = shields[dstGUID] or {}
		shields[dstGUID][spellId] = shields[dstGUID][spellId] or {}
		shields[dstGUID][spellId][srcGUID] = amount
	end
end
function collect.SPELL_AURA_REFRESH(timestamp, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, spellId, spellName, spellSchool, auraType, ...)
	local amount = select(NotGuessedAbsorb[spellId] or 1, ...)
	if amount and addon.ids.ga and addon.guidToClass[srcGUID] then
		if shields[dstGUID] and shields[dstGUID][spellId] and shields[dstGUID][spellId][srcGUID] then
			local absorb = shields[dstGUID][spellId][srcGUID] - amount
			if absorb > 0 then
				EVENT("ga", srcGUID, dstName, spellId, absorb)
			end
			shields[dstGUID][spellId][srcGUID] = amount
		end
	end
end
function collect.SPELL_AURA_REMOVED(timestamp, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, spellId, spellName, spellSchool, auraType, ...)
	if addon.ids.deathlog and addon.guidToClass[dstGUID] and (auraType == "DEBUFF" or deathlogTrackBuffs[spellName]) then
		addDeathlogEvent(dstGUID, dstName, fmtDeBuff, timestamp, spellId, auraType, 1, "-")
	end
	local amount = select(NotGuessedAbsorb[spellId] or 1, ...)
	if amount and addon.ids.ga and addon.guidToClass[srcGUID] then
		if shields[dstGUID] and shields[dstGUID][spellId] and shields[dstGUID][spellId][srcGUID] then
			local absorb = shields[dstGUID][spellId][srcGUID] - amount
			if absorb > 0 then
				EVENT("ga", srcGUID, dstName, spellId, absorb)
			end
			shields[dstGUID][spellId][srcGUID] = nil
		end
	end
end
function collect.SPELL_AURA_APPLIED_DOSE(timestamp, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, spellId, spellName, spellSchool, auraType, amount)
	if addon.ids.deathlog and addon.guidToClass[dstGUID] and (auraType == "DEBUFF" or deathlogTrackBuffs[spellName]) then
		addDeathlogEvent(dstGUID, dstName, fmtDeBuff, timestamp, spellId, auraType, amount or 1, "+")
	end
end
collect.SPELL_AURA_REMOVED_DOSE = collect.SPELL_AURA_APPLIED_DOSE

function collect.UNIT_DIED(timestamp, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags)
	if addon.ids.deathlog and addon.guidToClass[dstGUID] then
		unitDied(timestamp, dstGUID, dstName)
	end
end

function collect.SPELL_RESURRECT(timestamp, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, spellId, spellName, spellSchool)
	if addon.ids.deathlog and addon.guidToClass[dstGUID] then
		unitRezzed(timestamp, dstGUID, dstName, spellId, srcName)
	end
end

function collect:RemoveUnneededEvents()
	if not addon.ids.deathlog and not addon.ids.ga then
		collect.SPELL_AURA_APPLIED = nil
		collect.SPELL_AURA_REFRESH = nil
		collect.SPELL_AURA_REMOVED = nil
	end

	if not addon.ids.hd and not addon.ids.oh and not addon.ids.ht and not addon.ids.deathlog then
		collect.SPELL_HEAL = nil
		collect.SPELL_PERIODIC_HEAL = nil
	end

	if not addon.ids.dp then
		collect.SPELL_DISPEL = nil
		collect.SPELL_PERIODIC_DISPEL = nil
	end
	
	if not addon.ids.ir then
		collect.SPELL_INTERRUPT = nil
	end
	
	if not addon.ids.pg then
		collect.SPELL_ENERGIZE = nil
		collect.SPELL_PERIODIC_ENERGIZE = nil
	end

	if not addon.ids.deathlog then
		collect.SPELL_MISSED = nil
		collect.SPELL_PERIODIC_MISSED = nil
		collect.SPELL_BUILDING_MISSED = nil
		collect.RANGE_MISSED = nil
		collect.DAMAGE_SHIELD_MISSED = nil
		collect.SWING_MISSED = nil

		collect.SPELL_AURA_APPLIED_DOSE = nil
		collect.SPELL_AURA_REMOVED_DOSE = nil

		collect.UNIT_DIED = nil
		collect.SPELL_RESURRECT = nil
	end
end