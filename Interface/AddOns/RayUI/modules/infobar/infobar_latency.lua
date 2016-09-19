local R, L, P, G = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, GlobalDB, GlobalDB
local IF = R:GetModule("InfoBar")

local LatencyColor = {
	[1] = "007FFF",	-- Blue
	[2] = "00FF00",	-- Green
	[3] = "FFFF00",	-- Yellow
	[4] = "FF7F00",	-- Orange
	[5] = "FF0000",	-- Red
}

local function GetColorCode(value)
	local index
	
	if value > 250 then
		index = 5
	elseif value > 100 then
		index = 4
	elseif value > 50 then
		index = 3
	elseif value > 25 then
		index = 2
	else
		index = 1
	end
	
	return LatencyColor[index]
end

local function Latency_OnUpdate(self)
	local home, world = select(3, GetNetStats())

	home = tostring("|cFF"..GetColorCode(home)..home.."|r")
	world = tostring("|cFF"..GetColorCode(world)..world.."|r")

	self:SetText(home.." | "..world.." "..MILLISECONDS_ABBR)
end

do	-- Initialize
	local info = {}
	
	
	info.title = L["网络"]
	info.icon = "Interface\\Icons\\spell_frost_stun"
	--info.icon = "Interface\\Icons\\ability_creature_cursed_04"
	info.onUpdate = Latency_OnUpdate
	
	IF:RegisterInfoBarType("Latency", info)
end