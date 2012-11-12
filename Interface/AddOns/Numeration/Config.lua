local n = select(2, ...)
local R, L, P, G = unpack(RayUI)
local LSM = LibStub("LibSharedMedia-3.0")
local l = n.locale

-- window settings
n.windowsettings = {
	pos = { "BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -15, 30 },
	width = 220,
	maxlines = 7,
	backgroundalpha = 0,
	scrollbar = true,
	fontshadow = false,

	titleheight = 16,
	titlealpha = 0,
	titlefont = LSM:Fetch("font", G["media"].font),
	titlefontsize = 13,
	titlefontcolor = {1, .82, 0},
	titlefontstyle = "OUTLINE",
	buttonhighlightcolor = {1, 1, 1},

	lineheight = 16,
	linegap = 2,
	linealpha = 1,
	linetexture = LSM:Fetch("statusbar", G["media"].normal),
	linefont = LSM:Fetch("font", G["media"].font),
	linefontsize = 12,
	linefontcolor = {1, 1, 1},
	linefontstyle = "OUTLINE",
}

-- core settings
n.coresettings = {
	refreshinterval = 1,
	minfightlength = 15,
	combatseconds = 3,
	shortnumbers = true,
}

-- available types and their order
n.types = {
	{
		name = DAMAGE,
		id = "dd",
		c = {.25, .66, .35},
	},
	{
		name = l.dmg_tar,
		id = "dd",
		view = "Targets",
		onlyfights = true,
		c = {.25, .66, .35},
	},
	{
		name = l.dmg_take_tar,
		id = "dt",
		view = "Targets",
		onlyfights = true,
		c = {.66, .25, .25},
	},
	{
		name = l.dmg_take_abil,
		id = "dt",
		view = "Spells",
		c = {.66, .25, .25},
	},
	{
		name = l.friend_fire,
		id = "ff",
		c = {.63, .58, .24},
	},
	{
		name = SHOW_COMBAT_HEALING.." + "..COMBAT_TEXT_ABSORB,
		id = "hd",
		id2 = "ga",
		c = {.25, .5, .85},
	},
	{
		name = l.heal_take_abil,
		id = "ht",
		view = "Spells",
		c = {.25, .5, .85},
	},
	{
		name = SHOW_COMBAT_HEALING,
		id = "hd",
		c = {.25, .5, .85},
	},
	{
		name = COMBAT_TEXT_ABSORB,
		id = "ga",
		c = {.25, .5, .85},
	},
	{
		name = l.overheal,
		id = "oh",
		c = {.25, .5, .85},
	},
	{
		name = DISPELS,
		id = "dp",
		c = {.58, .24, .63},
	},
	{
		name = INTERRUPTS,
		id = "ir",
		c = {.09, .61, .55},
	},
	{
		name = POWER_GAINS,
		id = "pg",
		c = {.19, .44, .75},
	},
	{
		name = l.death_log,
		id = "deathlog",
		view = "Deathlog",
		onlyfights = true,
		c = {.66, .25, .25},
	},
}