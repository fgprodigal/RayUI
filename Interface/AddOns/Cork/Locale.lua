
local myname, ns = ...


ns.classnames = {
	["WARLOCK"] = "Warlock",
	["WARRIOR"] = "Warrior",
	["HUNTER"] = "Hunter",
	["MAGE"] = "Mage",
	["PRIEST"] = "Priest",
	["DRUID"] = "Druid",
	["PALADIN"] = "Paladin",
	["SHAMAN"] = "Shaman",
	["ROGUE"] = "Rogue",
	["DEATHKNIGHT"] = "Death Knight",
	["MONK"] = "Monk",
}

ns.colors = {}
for token in pairs(ns.classnames) do
	local c = RAID_CLASS_COLORS[token]
	ns.colors[token] = string.format("%02x%02x%02x", c.r*255, c.g*255, c.b*255)
end
