local n = select(2, ...)
local l = n.locale

-- window settings
n.windowsettings = {
	pos = {"TOPLEFT", 4, -4},
	width = 280,
	maxlines = 9,
	backgroundalpha = 0.6,
	fontshadow = true,
	scrollbar = true,

	titleheight = 16,
	titlealpha = 0.9,
	titlefont = [[Fonts\ARIALN.TTF]],
	titlefontstyle = "NONE",
	titlefontsize = 13,
	titlefontcolor = {1, 1, 1},
	buttonhighlightcolor = {1, .82, 0},

	lineheight = 14,
	linegap = 1,
	linealpha = 1,
	linetexture = [[Interface\Tooltips\UI-Tooltip-Background]],
	linefont = [[Fonts\ARIALN.TTF]],
	linefontstyle = "NONE",
	linefontsize = 11,
	linefontcolor = {1, 1, 1},
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
	-- {
		-- name = l.heal_take_abil,
		-- id = "ht",
		-- view = "Spells",
		-- c = {.25, .5, .85},
	-- },
	-- {
		-- name = SHOW_COMBAT_HEALING,
		-- id = "hd",
		-- c = {.25, .5, .85},
	-- },
	-- {
		-- name = COMBAT_TEXT_ABSORB,
		-- id = "ga",
		-- c = {.25, .5, .85},
	-- },
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