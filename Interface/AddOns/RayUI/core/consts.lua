local R, L, P, G = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, GlobalDB
local AddOnName = ...

R.myclass            = select(2, UnitClass("player"))
R.myname             = UnitName("player")
R.myrealm            = GetRealmName()
R.version            = GetAddOnMetadata(AddOnName, "Version")
BINDING_HEADER_RAYUI = GetAddOnMetadata(AddOnName, "Title")

RayUF.colors.power["MANA"] = { 0, 0.8, 1 }

RayUF["colors"].class = {
	["DEATHKNIGHT"] = { 0.77,	0.12,		0.23 },
	["DEMONHUNTER"] = { 0.64,	0.19,		0.79 },
	["DRUID"]       = { 1,		0.49,		0.04 },
	["HUNTER"]      = { 0.58,	0.86,		0.49 },
	["MAGE"]        = { 0.2,	0.76,		1 },
	["MONK"]        = { 0,		1,			0.59 },
	["PALADIN"]     = { 0.96,	0.55,		0.73 },
	["PRIEST"]      = { 0.8,	0.87,		0.9 },
	["ROGUE"]       = { 1,		0.96,		0.41 },
	["SHAMAN"]      = { 0,	    0.44,		0.87 },
	["WARLOCK"]     = { 0.6,	0.47,		0.85 },
	["WARRIOR"]     = { 0.9,	0.65,		0.45 },
}

RayUF["colors"].reaction = {
	[1] = { 1, 0.2, 0.2 }, -- Hated
	[2] = { 1, 0.2, 0.2 }, -- Hostile
	[3] = { 1, 0.6, 0.2 }, -- Unfriendly
	[4] = { 1, 1, 0.2 }, -- Neutral
	[5] = { 0.2, 1, 0.2 }, -- Friendly
	[6] = { 0.2, 1, 0.2 }, -- Honored
	[7] = { 0.2, 1, 0.2 }, -- Revered
	[8] = { 0.2, 1, 0.2 }, -- Exalted
}

RayUF["colors"].ComboPoints = {
	[1] = { 1, 0, 0 },
	[2] = { 1, 1, 0 },
	[3] = { 0, 1, 0 },
}

R.colors = {
	class = {},
}

for class, color in pairs(RayUF.colors.class) do
	R.colors.class[class] = { r = color[1], g = color[2], b = color[3] }
end

for reaction, color in pairs(RayUF.colors.reaction) do
	FACTION_BAR_COLORS[reaction] = { r = color[1], g = color[2], b = color[3] }
end
