
local myname, Cork = ...
if Cork.MYCLASS ~= "WARLOCK" then return end


-- Grimoire of Sacrifice
local spellname, _, icon = GetSpellInfo(108503)
Cork:GenerateSelfBuffer(spellname, icon)


-- Dark Intent
local spellname, _, icon = GetSpellInfo(109773)
Cork:GenerateRaidBuffer(spellname, icon)


-- Soulstone
local spellname, _, icon = GetSpellInfo(20707)
local dataobj = Cork:GenerateLastBuffedBuffer(spellname, icon)

local wasgrouped
local oldGRU = dataobj.GROUP_ROSTER_UPDATE
function dataobj:GROUP_ROSTER_UPDATE(...)
	local nowgrouped = IsInGroup()
	if wasgrouped and not nowgrouped then
		dataobj.onlyrebuffs = false
		dataobj.lasttarget = nil
	elseif not wasgrouped and nowgrouped then
		dataobj.onlyrebuffs = true
		dataobj.lasttarget = nil
	end

	wasgrouped = nowgrouped

	return oldGRU(self, ...)
end
