local n = select(2, ...)
local R, L, P = unpack(RayUI)
local LSM = LibStub("LibSharedMedia-3.0")
-- window settings
n.windowsettings = {
	-- pos = { "TOPLEFT", 4, -4 },
	pos = { "BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -15, 30 },
	width = 220,
	maxlines = 7,
	backgroundalpha = 0,
	scrollbar = true,

	titleheight = 16,
	titlealpha = 0,
	titlefont = LSM:Fetch("font", P["media"].font),
	titlefontsize = 13,
	titlefontcolor = {1, .82, 0},
	buttonhighlightcolor = {1, 1, 1},

	lineheight = 16,
	linegap = 2,
	linealpha = 1,
	linetexture = LSM:Fetch("statusbar", P["media"].normal),
	linefont = LSM:Fetch("font", P["media"].font),
	linefontsize = 12,
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
		name = "傷害",
		id = "dd",
		c = {.25, .66, .35},
	},
	{
		name = "傷害目標",
		id = "dd",
		view = "Targets",
		onlyfights = true,
		c = {.25, .66, .35},
	},
	{
		name = "傷害承受: 目標",
		id = "dt",
		view = "Targets",
		onlyfights = true,
		c = {.66, .25, .25},
	},
	{
		name = "傷害承受: 技能",
		id = "dt",
		view = "Spells",
		c = {.66, .25, .25},
	},
	{
		name = "隊友誤傷",
		id = "ff",
		c = {.63, .58, .24},
	},
	{
		name = "治療及吸收",
		id = "hd",
		id2 = "ga",
		c = {.25, .5, .85},
	},
--	{
--		name = "Healing Taken: Abilities",
--		id = "ht",
--		view = "Spells",
--		c = {.25, .5, .85},
--	},
--	{
--		name = "Healing",
--		id = "hd",
--		c = {.25, .5, .85},
--	},
--	{
--		name = "Guessed Absorbs",
--		id = "ga",
--		c = {.25, .5, .85},
--	},
	{
		name = "過量治療",
		id = "oh",
		c = {.25, .5, .85},
	},
	{
		name = "驅散",
		id = "dp",
		c = {.58, .24, .63},
	},
	{
		name = "打斷",
		id = "ir",
		c = {.09, .61, .55},
	},
	{
		name = "法力獲取",
		id = "pg",
		c = {48/255, 113/255, 191/255},
	},
	{
		name = "死亡記錄",
		id = "deathlog",
		view = "Deathlog",
		onlyfights = true,
		c = {.66, .25, .25},
	},
}
