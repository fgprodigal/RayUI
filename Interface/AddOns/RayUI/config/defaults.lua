local R, L, P, G = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB

G["media"]={
	blank = "RayUI Blank",
	normal = "RayUI Normal",
	glow = "RayUI GlowBorder",
    gloss = "RayUI Gloss",
	font = "RayUI Font",
	dmgfont = "RayUI Combat",
	pxfont = "RayUI Pixel",
	cdfont = "RayUI Roadway",
	fontsize = 12,
	fontflag = "THINOUTLINE",
	warning = "RayUI Warning",
	errorsound = "RayUI Error",
	backdropcolor = { .1, .1, .1 },
	backdropfadecolor = { .04, .04, .04, .7 },
	bordercolor = { 0, 0, 0 },
}

G["general"]={
	uiscale = 0.75,
	logo = true,
	theme = "Shadow",
	numberType = 1
}

P["InfoBar"]={
    autoHide = true,
}

P["WorldMap"]={
	enable = true,
	lock = false,
	scale = 0.8,
	ejbuttonscale = 0.8,
	partymembersize = 25,
}

P["MiniMap"]={
	enable = true,
}

P["NamePlates"]={
	enable = true,
	showdebuff = true,
	combat = false,
	showhealer = true,
	smooth = true,
	fade = false,
    fadeValue = 0.5,
}

P["Chat"]={
	["enable"] = true,
	["height"] = 140,
	["width"] = 400,
	["autohide"] = true,
	["autoshow"] = true,
	["autohidetime"] = 10,
}

P["Tooltip"]={
	enable = true,
	cursor = false,
}

P["Watcher"]={
	enable = true,
}

P["Buff"]={
	enable = true,
}

G["UnitFrames"]={}

P["UnitFrames"]={
	powerColorClass = true,
	healthColorClass = false,
	smooth = true,
	smoothColor = true,
	powerheight = 0.13,
	showBossFrames = true,
	showArenaFrames = true,
	showPortrait = true,
	showHealthValue = false,
	alwaysShowHealth = false,
	separateEnergy = false,
	vengeance = true,
	aurabar = false,
}

G["Raid"] = {}

P["Raid"]={
	enable = true,
    width = 70,
    height = 36,
	bigwidth = 85,
	bigheight = 43,
    spacing = 5,
    showwhensolo = false,
    showplayerinparty = true,
    horizontal = false,
    growth = "RIGHT",
    powerbarsize = .1,
    outsideRange = .40,
    arrow = true,
    arrowmouseover = true,
    healbar = true,
    healoverflow = true,
    healothersonly = false,
    roleicon = true,
    indicatorsize = 7,
    symbolsize = 11,
    leadersize = 12,
    aurasize = 20,
    deficit = false, --缺失生命
    perc = false, --百分比
    actual = false, --当前生命
    afk = true,
    highlight = true,
    dispel = true,
    tooltip = true,
    hidemenu = false,
	autorez = true,
	raid40 = true,
	alwaysshow40 = false,
}

P["ActionBar"]={
	buttonsize   = 28,
	buttonspacing   = 6,
	barscale = 1,
	macroname = true,
	itemcount = true,
	hotkeys = true,
	showgrid = true,

    bar1 = {
        enable = true,
        mouseover = false,
        autohide = true,
        buttonsPerRow = 12,
        buttonsize = 28,
        buttonspacing = 6,
    },

    bar2 = {
        enable = true,
        mouseover = false,
        autohide = true,
        buttonsPerRow = 12,
        buttonsize = 28,
        buttonspacing = 6,
    },

    bar3 = {
        enable = true,
        mouseover = false,
        autohide = true,
        buttonsPerRow = 6,
        buttonsize = 28,
        buttonspacing = 6,
    },

    bar4 = {
        enable = true,
        mouseover = true,
        autohide = false,
        buttonsPerRow = 1,
        buttonsize = 28,
        buttonspacing = 6,
    },

    bar5 = {
        enable = true,
        mouseover = false,
        autohide = false,
        buttonsPerRow = 1,
        buttonsize = 28,
        buttonspacing = 6,
    },

    barpet = {
        enable = true,
        mouseover = false,
        autohide = true,
        buttonsPerRow = 10,
        buttonsize = 23,
        buttonspacing = 6,
    },

	stancebarmouseover = false,
	stancebarfade = false,

	cooldownalpha = false,
	cdalpha = 1,
	readyalpha = 0.3,

	clickondown = true
}

G["Misc"] = {}

P["Misc"]={
	anounce = true,
	auction = true,
	autodez = true,
	autorelease = true,
	merchant = true,
		poisons = true,
	quest = true,
		automation = true,
	reminder = true,
	raidbuffreminder = true,
		raidbuffreminderparty = false,
		raidbuffreminderduration = true,
		consolidate = true,
    autoAcceptInvite = true,
        autoInvite = true,
        autoInviteKeywords = "111 123",
    raidcd = false,
        raidcdwidth = 170,
        raidcdgrowth = "UP",
	totembar = {
		enable = true,
		size = 35,
		growthDirection = "VERTICAL",
		sortDirection = "ASCENDING",
		spacing = 4
	}
}

P["Skins"]={
	enable = true,
	skada = true,
		skadaposition = true,
	dbm = true,
		dbmposition = true,
	ace3 = true,
	acp = true,
	atlasloot = true,
	bigwigs = true,
	nugrunning = true,
	mogit = true,
	numeration = true,
}

P["Bags"]={
	bagSize = 35,
	bankSize = 35,
	sortInverted = true,
	bagWidth = 10,
	bankWidth = 12,
}

P["CooldownFlash"]={
	enable = true,
	fadeInTime = 0.1,
	fadeOutTime = 0.2,
	maxAlpha = 0.8,
	animScale = 1.2,
	iconSize = 80,
	holdTime = 0.3,
	enablePet = false,
	showSpellName = false,
}
