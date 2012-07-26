local R, L, P = unpack(select(2, ...)) --Inport: Engine, Locales, ProfileDB

P["media"]={
	blank = "RayUI Blank",
	normal = "RayUI Normal",
	glow = "RayUI GlowBorder",
	font = "RayUI Font",
	dmgfont = "RayUI Combat",
	pxfont = "RayUI Pixel",
	cdfont = "RayUI Roadway",
	fontsize = 12,
	fontflag = "THINOUTLINE",
	warning = "RayUI Warning",
	errorsound = "RayUI Error",
	backdropcolor = { .05, .05, .05, .9},
	bordercolor = {0, 0, 0, 1},
}

P["general"]={
	uiscale = 0.75,
	logo = true,
}

P["WorldMap"]={
	enable = true,
	lock = false,
	scale = 0.8,
	ejbuttonscale = 0.6,
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
}

P["Bag"]={
	enable = true,
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

P["CooldownFlash"]={
	enable = true,
}

P["UnitFrames"]={
	powerColorClass = true,
	healthColorClass = false,
	smooth = true,
	smoothColor = true,
	powerheight = 0.13,
	showParty = true,
	showBossFrames = true,
	showArenaFrames = true,
	separateEnergy = false,
	vengeance = true,
}

P["Raid"]={
	enable = true,
    width = 65,
    height = 30,
    spacing = 8,
    showwhensolo = false,
    showplayerinparty = true,
    showgridwhenparty = false,
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
    indicatorsize = 5,
    symbolsize = 11,
    leadersize = 12,
    aurasize = 18,
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
}

P["ActionBar"]={
	buttonsize   = 28,
	buttonspacing   = 6,
	barscale = 1,
	petbarscale = 0.9,
	macroname = false,
	itemcount = true,
	hotkeys = true,
	showgrid = true,

	bar1fade = true,

	bar2mouseover = false,
	bar2fade = true,

	bar3mouseover = false,
	bar3fade = true,

	bar4mouseover = false,
	bar4fade = false,

	bar5mouseover = true,
	bar5fade = true,

	stancebarmouseover = false,
	stancebarfade = false,

	petbarmouseover = false,
	petbarfade = true,

	cooldownalpha = false,
	cdalpha = 1,
	readyalpha = 0.3,
	stancealpha = false,
}

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
	gladius = true,
}