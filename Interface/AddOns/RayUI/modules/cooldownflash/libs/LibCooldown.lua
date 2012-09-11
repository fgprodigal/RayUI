local R, L, P = unpack(select(2, ...)) --Inport: Engine, Locales, ProfileDB

local lib = LibStub:NewLibrary("LibCooldown", 1.0)
if not lib then return end

lib.startcalls = {}
lib.stopcalls = {}

function lib:RegisterCallback(event, func)
	assert(type(event)=="string" and type(func)=="function", "Usage: lib:RegisterCallback(event{string}, func{function})")
	if event=="start" then
		tinsert(lib.startcalls, func)
	elseif event=="stop" then
		tinsert(lib.stopcalls, func)
	else
		error("Argument 1 must be a string containing \"start\" or \"stop\"")
	end
end

local addon = CreateFrame("Frame")
local band = bit.band
local petflags = COMBATLOG_OBJECT_TYPE_PET
local mine = COMBATLOG_OBJECT_AFFILIATION_MINE
local spells = {}
local pets = {}
local items = {}
local watched = {}
local internal = {
		[47755] = { duration = 12, eventType = "SPELL_ENERGIZE", sourceFlags = mine, destFlags = mine },
	}
local nextupdate, lastupdate = 0, 0

local function stop(id, class)
	watched[id] = nil

	for _, func in next, lib.stopcalls do
		func(id, class)
	end
end

local function update()
	for id, tab in next, watched do
		local duration = watched[id].dur - lastupdate
		if duration < 0 then
			stop(id, watched[id].class)
		else
			watched[id].dur = duration
			if nextupdate <= 0 or duration < nextupdate then
				nextupdate = duration
			end
		end
	end
	lastupdate = 0

	if nextupdate < 0 then addon:Hide() end
end

local function start(id, starttime, duration, class)
	update()

	watched[id] = {
		["start"] = starttime,
		["dur"] = duration,
		["class"] = class,
	}
	addon:Show()

	for _, func in next, lib.startcalls do
		func(id, duration, class)
	end

	update()
end

local function parsespellbook(spellbook)
	if spellbook == BOOKTYPE_SPELL then
		wipe(spells)
		for i = 1, GetNumSpellTabs() do
			local _, _, offset, numSpells, _ = GetSpellTabInfo(i)
			offset = offset + 1
			local tabEnd = offset + numSpells
			for j = offset, tabEnd - 1 do
				local skilltype, id = GetSpellBookItemInfo(j, spellbook)

				if not id then break end

				name = GetSpellBookItemName(j, spellbook)
				if name and IsSpellKnown(id) and skilltype == "SPELL" and spellbook == BOOKTYPE_SPELL and not IsPassiveSpell(j, spellbook) then
					spells[id] = true
				end
				i = i + 1
				if (id == 88625 or id == 88625 or id == 88625) and (skilltype == "SPELL" and spellbook == BOOKTYPE_SPELL) then
				   spells[88625] = true
				   spells[88684] = true
				   spells[88685] = true
				end
			end
		end
	end
	if spellbook == BOOKTYPE_PET then
		wipe(pets)
		i = 1
		while true do
			skilltype, id = GetSpellBookItemInfo(i, spellbook)
			if not id then break end

			name = GetSpellBookItemName(i, spellbook)
			if name and skilltype == "SPELL" and spellbook == BOOKTYPE_PET and not IsPassiveSpell(i, spellbook) then
				pets[id] = true
			end
			i = i + 1
		end
	end
end

-- events --
function addon:LEARNED_SPELL_IN_TAB()
	parsespellbook(BOOKTYPE_SPELL)
	parsespellbook(BOOKTYPE_PET)
end

function addon:SPELL_UPDATE_COOLDOWN()
	local now = GetTime()

	for id in next, spells do
		local starttime, duration, enabled = GetSpellCooldown(id)

		if starttime == nil then
			watched[id] = nil
		elseif starttime == 0 and watched[id] then
			stop(id, "spell")
		elseif starttime ~= 0 then
			local timeleft = starttime + duration - now

			if enabled == 1 and timeleft > 1.51 then
				if not watched[id] or watched[id].start ~= starttime then
					start(id, starttime, timeleft, "spell")
				end
			elseif enabled == 1 and watched[id] and timeleft <= 0 then
				stop(id, "spell")
			end
		end
	end

	for id in next, pets do
		local starttime, duration, enabled = GetSpellCooldown(id)

		if starttime == nil then
			watched[id] = nil
		elseif starttime == 0 and watched[id] then
			stop(id, "pet")
		elseif starttime ~= 0 then
			local timeleft = starttime + duration - now

			if enabled == 1 and timeleft > 1.51 then
				if not watched[id] or watched[id].start ~= starttime then
					start(id, starttime, timeleft, "pet")
				end
			elseif enabled == 1 and watched[id] and timeleft <= 0 then
				stop(id, "pet")
			end
		end
	end
end

function addon:COMBAT_LOG_EVENT_UNFILTERED(timestamp, eventType, hideCaster, sourceGUID, sourceName, sourceFlags, sourceFlags2, destGUID, destName, destFlags, dstFlags2, spellID, ...)
	local now = GetTime()

	if internal[spellID] and eventType == internal[spellID].eventType then
		if bit.band(sourceFlags, internal[spellID].sourceFlags) == internal[spellID].sourceFlags 
			and bit.band(destFlags, internal[spellID].destFlags) == internal[spellID].destFlags then
			start(spellID, now, internal[spellID].duration, "spell")
		end
	end
end

function addon:BAG_UPDATE_COOLDOWN()
	for id  in next, items do
		local starttime, duration, enabled = GetItemCooldown(id)
		if enabled == 1 and duration > 10 then
			start(id, starttime, duration, "item")
		elseif enabled == 1 and watched[id] and duration <= 0 then
			stop(id, "item")
		end
	end
end

function addon:PLAYER_ENTERING_WORLD()
	addon:LEARNED_SPELL_IN_TAB()
	addon:BAG_UPDATE_COOLDOWN()
	addon:SPELL_UPDATE_COOLDOWN()
end

hooksecurefunc("UseInventoryItem", function(slot)
	local link = GetInventoryItemLink("player", slot) or ""
	local id = string.match(link, ":(%w+).*|h%[(.+)%]|h")
	if id and not items[id] then
		items[id] = true
	end
end)

hooksecurefunc("UseContainerItem", function(bag, slot)
	local link = GetContainerItemLink(bag, slot) or ""
	local id = string.match(link, ":(%w+).*|h%[(.+)%]|h")
	if id and not items[id] then
		items[id] = true
	end
end)

for slot=1, 120 do
	local action, id = GetActionInfo(slot)
	if action == "item" then
		items[id] = true
	end
end

function addon:ACTION_BAR_SLOT_CHANGED(slot)
	local action, id = GetActionInfo(slot)
	if action == "item" then
		items[id] = true
	end
end

local function onupdate(self, elapsed)
	nextupdate = nextupdate - elapsed
	lastupdate = lastupdate + elapsed
	if nextupdate > 0 then return end

	update(self)
end

addon:Hide()
addon:SetScript("OnUpdate", onupdate)
addon:SetScript("OnEvent", function(self, event, ...) self[event](self, ...) end)

addon:RegisterEvent("LEARNED_SPELL_IN_TAB")
addon:RegisterEvent("SPELL_UPDATE_COOLDOWN")
addon:RegisterEvent("BAG_UPDATE_COOLDOWN")
addon:RegisterEvent("PLAYER_ENTERING_WORLD")
addon:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
