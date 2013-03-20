
local myname, Cork = ...
local UnitAura = Cork.UnitAura or UnitAura
local ldb, ae = LibStub:GetLibrary("LibDataBroker-1.1"), LibStub("AceEvent-3.0")


local ally = UnitFactionGroup('player') == "Alliance"
local ids = ally and {64399, 64398, 63359} or {64402, 64401, 64400}
local buffname = GetSpellInfo(90633)
local name = "Cork "..buffname
local iconline = Cork.IconLine(GetItemIcon(ids[1]), buffname)
local coolingdown


local dataobj = LibStub:GetLibrary("LibDataBroker-1.1"):NewDataObject(name, {
	type = "cork", tiplink = GetSpellLink(buffname),
	tiplink = "item:"..ids[1],
	priority = 9,
})


local function FindItem()
	for _,id in ipairs(ids) do
		if GetItemCount(id) > 0 then return id end
	end
end


local function HasBuff()
	return UnitAura("player", buffname)
end


local function CooldownFinish()
	coolingdown = false
	dataobj:Scan()
end


function dataobj:Init()
	Cork.defaultspc[buffname.."-enabled"] = false
end


local function Test(unit)
	if coolingdown or not Cork.dbpc[buffname.."-enabled"] or HasBuff() then return end

	local id = FindItem()
	if not id then return end

	local start, duration = GetItemCooldown(id)
	if start > 0 then
		coolingdown = true
		Cork.StartTimer(start + duration, CooldownFinish)
	elseif not (IsResting() and not Cork.db.debug) then
		return iconline
	end
end


function dataobj:Scan() self.custom = Test() end


function dataobj:CorkIt(frame)
	local itemowned = FindItem()
	if self.custom and itemowned then
		return frame:SetManyAttributes("type1", "item", "item1", "item:"..itemowned)
	end
end


ae.RegisterEvent(dataobj, "PLAYER_UPDATE_RESTING", "Scan")
ae.RegisterEvent(name, "UNIT_AURA", function(event, unit)
	if unit == "player" then dataobj.custom = Test() end
end)
