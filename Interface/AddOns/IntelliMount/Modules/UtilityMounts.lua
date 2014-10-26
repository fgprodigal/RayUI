------------------------------------------------------------
-- UtilityMounts.lua
--
-- Abin
-- 2014/10/21
------------------------------------------------------------

local ipairs = ipairs
local GetSpellInfo = GetSpellInfo
local wipe = wipe
local UnitBuff = UnitBuff
local GetNumMounts = C_MountJournal.GetNumMounts
local GetMountInfo = C_MountJournal.GetMountInfo

local _, addon = ...

local utilityMounts = {
	{ id = 75973, passenger = 1 },
	{ id = 121820, passenger = 1 },
	{ id = 93326, passenger = 1 },
	{ id = 60424, passenger = 1 },
	{ id = 61425, passenger = 1, vendor = 1 },
	{ id = 122708, passenger = 1, vendor = 1 },
	{ id = 118089, water = 1 },
	{ id = 127271, water = 1 },
}

local LEARNED_MOUNTS = {}

do
	local _, data
	for _, data in ipairs(utilityMounts) do
		data.name, _, data.icon = GetSpellInfo(data.id)
	end
end

function addon:UpdateUtilityMounts()
	wipe(LEARNED_MOUNTS)
	local count = GetNumMounts()
	local i
	for i = 1, count do
		local name, _, _, _, _, _, _, _, _, hideOnChar, isCollected = GetMountInfo(i)
		if name and not hideOnChar and isCollected then
			LEARNED_MOUNTS[name] = 1
		end
	end

	local _, data
	for _, data in ipairs(utilityMounts) do
		data.learned = LEARNED_MOUNTS[data.name]
	end
end

function addon:GetNumUtilityMounts()
	return #utilityMounts
end

function addon:GetUtilityMountData(index)
	return utilityMounts[index]
end

function addon:IsMountLearned(name)
	return LEARNED_MOUNTS[name]
end

local ABYSSAL_SEAHORSE = GetSpellInfo(75207) -- Abyssal Seahorse
local SEA_LEGS = GetSpellInfo(73701) -- The buff which determines whether the player is located in Vashj'ir

function addon:GetAbyssalSeahorse()
	if addon.db.seahorseFirst and IsUsableSpell(75207) and UnitBuff("player", SEA_LEGS) then
		return ABYSSAL_SEAHORSE
	end
end