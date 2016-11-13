local R, L, P, G = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, GlobalDB

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
    errorsound = "RayUI Error",
    backdropcolor = { .1, .1, .1 },
    backdropfadecolor = { .04, .04, .04, .7 },
    bordercolor = { 0, 0, 0 },
}

G["general"]={
    logo = true,
    theme = "Pixel",
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
    markHealers = true,
    showauras = true,
    numAuras = 4,
    iconSize = 20,
    maxDuration = 120,
    showhealer = true,
    smooth = true,
    fontsize = 12,
    hpHeight = 10,
    hpWidth = 150,
    pbHeight = 3,
    cbHeight = 5,
    targetScale = 1.2,
    displayStyle = "ALL",
    lowHealthThreshold = 0.4,
    showFriendlyCombat = "DISABLED",
    showEnemyCombat = "DISABLED",
    motionType = "OVERLAP", --OVERLAP, STACKED
    friendly_minions = false,
    enemy_minions = false,
    enemy_minors = true,
}

P["Chat"]={
    enable = true,
    height = 140,
    width = 400,
    autohide = true,
    autoshow = true,
    autohidetime = 10,
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
    enable = true,
    powerColorClass = true,
    healthColorClass = false,
    smooth = true,
    smoothColor = true,
    powerheight = 0.08,
    showPortrait = true,
    showHealthValue = false,
    alwaysShowHealth = false,
    aurabar = false,
    castBar = true,
    smartAura = false,
    units = {
        player = {
            defaultPosition = { "BOTTOMRIGHT", R.UIParent, "BOTTOM", -80, 390 },
            width = 220,
            height = 32,
            castbar = {
                showicon = false,
                iconposition = "LEFT",
                width = 350,
                height = 7,
            },
        },
        target = {
            defaultPosition = { "BOTTOMLEFT", R.UIParent, "BOTTOM", 80, 390 },
            width = 220,
            height = 32,
            castbar = {
                showicon = true,
                iconposition = "LEFT",
                width = 220,
                height = 20,
            },
        },
        targettarget = {
            defaultPosition = { "LEFT", "RayUF_Target", "RIGHT", 6, 0 },
            width = 120,
            height = 32,
            castbar = {
                showicon = true,
                iconposition = "LEFT",
                width = 120,
                height = 20,
            },
        },
        focus = {
            defaultPosition = { "BOTTOMRIGHT", "RayUF_Player", "TOPLEFT", -20, 40 },
            width = 170,
            height = 32,
            castbar = {
                showicon = true,
                iconposition = "LEFT",
                width = 250,
                height = 5,
            },
        },
        focustarget = {
            defaultPosition = { "RIGHT", "RayUF_Focus", "LEFT", -6, 1 },
            width = 120,
            height = 32,
        },
        pet = {
            defaultPosition = { "RIGHT", "RayUF_Player", "LEFT", -6, 0 },
            width = 120,
            height = 32,
        },
        arena = {
            enable = true,
            defaultPosition = { "BOTTOMRIGHT", R.UIParent, "BOTTOM", -80, 390 },
            width = 190,
            height = 22,
        },
        boss = {
            enable = true,
            defaultPosition = { "BOTTOMRIGHT", R.UIParent, "BOTTOM", -80, 390 },
            width = 192,
            height = 22,
        },
    },
}

G["Raid"] = {}

P["Raid"]={
    enable = true,
    raid40width = 77,
    raid40height = 30,
    width = 77,
    height = 40,
    petheight = 30,
    petwidth = 77,
    tankheight = 40,
    tankwidth = 77,
    spacing = 5,
    horizontal = true,
    growth = "UP",
    powerbarsize = .1,
    outsideRange = .40,
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
    showlabel = true,
    showTank = false,
    showPets = false,
}

P["ActionBar"]={
    enable = true,
    buttonsize = 28,
    buttonspacing = 6,
    barscale = 1,
    macroname = true,
    itemcount = true,
    hotkeys = true,
    showgrid = true,
    lockActionBars = true,
    movementModifier = "SHIFT",

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
    autoscreenshot = true,
    merchant = true,
    poisons = true,
    quest = true,
    automation = true,
    consolidate = true,
    autoAcceptInvite = true,
    autoInvite = true,
    autoInviteKeywords = "111 123",
    raidcd = false,
    raidcdwidth = 170,
    raidcdgrowth = "UP",
    cooldowns = {
        enable = false,
        size = 25,
        growthx = "LEFT",
        growthy = "UP",
        showbags = true,
        showequip = true,
        showpets = true,
    },
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
    enable = true,
    bagSize = 35,
    bankSize = 35,
    sortInverted = true,
    bagWidth = 10,
    bankWidth = 12,
    itemLevel = true,
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
