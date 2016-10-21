------------------------------------------------------------
-- UtilityMounts.lua
--
-- Abin
-- 2014/10/21
------------------------------------------------------------

local GetSpellInfo = GetSpellInfo
local wipe = wipe
local ipairs = ipairs
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
	{ id = 118089, surface = 1 },
	{ id = 127271, surface = 1 },
	{ id = 64731, underwater = 1 },
	{ id = 30174, underwater = 1 },
	{ id = 98718, underwater = 1 },
}

if addon.class == "WARLOCK" then
	tinsert(utilityMounts, { id = 5784, surface = 1 })
	tinsert(utilityMounts, { id = 23161, surface = 1 })
end

local LEARNED_MOUNTS = {}

do
	local _, data
	for _, data in ipairs(utilityMounts) do
		data.name, _, data.icon = GetSpellInfo(data.id)
	end

	sort(utilityMounts, function(a, b) return (a.name or "") < (b.name or "") end) -- Sort the table by mount names
end

addon:RegisterDebugAttr("surfaceMount")

function addon:UpdateUtilityMounts()
	wipe(LEARNED_MOUNTS)
	local count = GetNumMounts()
	local i
	for i = 1, count do
		local name, _, _, _, _, _, _, _, _, hideOnChar, isCollected = C_MountJournal.GetDisplayedMountInfo(i)
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

addon:RegisterEventCallback("OnInitialize", function(db)
	-- Transfer old version data to new one
	if addon.db.waterStrider then
		addon.db.surfaceMount = addon.db.waterStrider
		addon.db.waterStrider = nil
	end

	if addon.db.surfaceMount and not addon.db.warlockSurfaceMount then
		addon.db.warlockSurfaceMount = addon.db.surfaceMount
	end

	if addon.class == "WARLOCK" then
		addon:SetAttribute("surfaceMount", addon.db.warlockSurfaceMount)
	else
		addon:SetAttribute("surfaceMount", addon.db.surfaceMount)
	end
end)

addon:RegisterOptionCallback("surfaceIfNotFlable", function(value)
	addon:SetAttribute("surfaceIfNotFlable", value)
end)