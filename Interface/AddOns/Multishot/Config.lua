local L = LibStub("AceLocale-3.0"):GetLocale("Multishot")

local GetFonts = function()
	local fonts = {}
	fonts[STANDARD_TEXT_FONT] = "Standard"
	fonts[(NumberFontNormal:GetFont())] = "NumberFontNormal"
	fonts[(NumberFontNormalHuge:GetFont())] = "NumberFontNormalHuge"
	fonts[(ItemTextFontNormal:GetFont())] = "ItemTextFontNormal"

	local LSM3 = LSM3 or LibStub("LibSharedMedia-3.0")
	if LSM3 then
		for index, fontName in pairs(LSM3:List("font")) do
			fonts[LSM3:Fetch("font", fontName)] = fontName
		end
	end
	return fonts
end

local GetFontSizes = function()
	local sizes = {}
	for k,v in ipairs(CHAT_FONT_HEIGHTS) do
		sizes[v] = v
	end
	return sizes
end

local GetDifficulties = function()
	local diffs,id = {[0]=_G.NONE}, 1
	
	for i=1,20 do
		local name = GetDifficultyInfo(i)
		if name and name ~= "" then
			diffs[i] = name
		end
	end
	--[[local name = GetDifficultyInfo(id) -- 5.3,5.4 have gaps in the ids
	while (name and name ~= "") do
		diffs[id] = name
		id = id+1
		name = GetDifficultyInfo(id)
	end]]
	return diffs
end
local getDiffDefaults = function()
	local defaults,id = {[0]=true}, 1
	for i=1,20 do
		local name = GetDifficultyInfo(i)
		if name and name ~= "" then
			defaults[i] = true
		end
	end
	--[[local name = GetDifficultyInfo(id)
	while (name and name ~= "") do
		defaults[id] = true
		id = id+1
		name = GetDifficultyInfo(id)
	end]]
	return defaults
end

local dataDefaults = { 
	levelup = true,
	achievement = true,
	groupstatus = {["1solo"]=true,["2party"]=true,["3raid"]=true},
	rares = true, 
	repchange = true, 
	delay1 = 1.2,  
	delay2 = 2, 
	debug = false, 
	trade = true, 
	firstkill = false, 
	difficulty = getDiffDefaults(),
	close = false, 
	uihide = false, 
	played = false, 
	charpane = false, 
	guildlevelup = true, 
	guildachievement = true, 
	challengemode = true,
	battleground = true,
	arena = true,
	history = {}, 
	delay3 = 20, 
	timeLineEnable = false, 
	garissonbuild = true,
	watermark = false, 
	watermarkformat = "$n($l) $c $b$z - $d$b$r", 
	watermarkanchor = "TOP",
	watermarkfont = STANDARD_TEXT_FONT,
	watermarkfontsize = CHAT_FONT_HEIGHTS[3],
}

local dataOptions = {
  type = "group",
  name = "Multishot",
  args = {
    intro = {
      order = 0,
      type = "description",
      name = L["intro"] .. ":\n" },
    levelups = {
      order = 1, 
      type = "toggle",
      name = L["levelups"],
      get = function() return MultishotConfig.levelup end,
      set = function(_,v) MultishotConfig.levelup = v end },
    guildlevelups = {
      order = 2, 
      type = "toggle",
      name = L["guildlevelups"],
      get = function() return MultishotConfig.guildlevelup end,
      set = function(_,v) MultishotConfig.guildlevelup = v end },
    achievements = {
      order = 3,
      type = "toggle",
      name = L["achievements"],
      get = function() return MultishotConfig.achievement end,
      set = function(_,v) MultishotConfig.achievement = v end },
    guildachievements = {
      order = 4,
      type = "toggle",
      name = L["guildachievements"],
      get = function() return MultishotConfig.guildachievement end,
      set = function(_,v) MultishotConfig.guildachievement = v end },
    challengemode = {
		  order = 5,
		  type = "toggle",
		  name = L["challengemode"],
		  get = function() return MultishotConfig.challengemode end,
		  set = function(_,v) MultishotConfig.challengemode = v end },
    battleground = {
      order = 6,
      type = "toggle",
      name = L["battleground"],
      get = function() return MultishotConfig.battleground end,
      set = function(_,v) MultishotConfig.battleground = v end },
    arena = {
      order = 7,
      type = "toggle",
      name = L["arena"],
      get = function() return MultishotConfig.arena end,
      set = function(_,v) MultishotConfig.arena = v end },
    repchange = {
      order = 8,
      type = "toggle",
      name = L["repchange"],
      get = function() return MultishotConfig.repchange end,
      set = function(_,v) MultishotConfig.repchange = v end },
    trade = {
      order = 9,
      type = "toggle",
      name = L["trade"],
      get = function() return MultishotConfig.trade end,
      set = function(_,v) MultishotConfig.trade = v end },
    garissonbuild = {
    	order = 10,
    	type = "toggle",
    	name = L["garissonbuild"],
    	get = function() return MultishotConfig.garissonbuild end,
    	set = function(_,v) MultishotConfig.garissonbuild = v end },    
    header1 = {
      order = 11,
      type = "header",
      name = L["bosskillshots"] },
    firstkills = {
      order = 12,
      type = "toggle",
      name = L["firstkills"],
      get = function() return MultishotConfig.firstkill end, 
      set = function(_,v) MultishotConfig.firstkill = v end },
    rares = {
      order = 13,
      type = "toggle",
      name = L["rarekills"],
      get = function() return MultishotConfig.rares end, 
      set = function(_,v) MultishotConfig.rares = v end },
    groupstatus = {
      order = 14,
      type = "multiselect",
      name = L["groupstatus"],
      values = {["1solo"]=L["bosskillssolo"],["2party"]=L["bosskillsparty"],["3raid"]=L["bosskillsraid"]},
      get = function(_,k) return MultishotConfig.groupstatus[k] end,
      set = function(_,k,v) MultishotConfig.groupstatus[k] = v end },
    difficulty = {
      order = 15,
      type = "multiselect",
      name = L["instancedifficulty"],
      values = GetDifficulties,
      get = function(_,k) return MultishotConfig.difficulty[k] end,
      set = function(_,k,v) MultishotConfig.difficulty[k] = v end },
    header2 = {
      order = 16,
      type = "header",
      name = L["timeline"] },
		timeline = {
      order = 17,
      type = "toggle",
      name = L["timeLineEnable"],
      width = "double",
      get = function() return MultishotConfig.timeLineEnable end, 
      set = function(_,v) 
      	MultishotConfig.timeLineEnable = v
      	Multishot:TimeLineConfig(v)
      end },
		delay3 = {
      order = 18,
      type = "range",
      name = L["delayTimeline"],
      min = 5, max = 60, step = 5,
      get = function() return MultishotConfig.delay3 end, 
      set = function(_,v) MultishotConfig.delay3 = v end },
    header3 = {
      order = 19,
      type = "header",
      name = L["delay"] },
    delay1 = {
      order = 20,
      type = "range",
      name = L["delayother"],
      min = .1, max = 10, step = .1,
      get = function() return MultishotConfig.delay1 end,
      set = function(_,v) MultishotConfig.delay1 = v end },
    delay2 = {
      order = 21,
      type = "range",
      name = L["delaykill"],
      min = .1, max = 10, step = .1,
      get = function() return MultishotConfig.delay2 end, 
      set = function(_,v) MultishotConfig.delay2 = v end },
    header4 = {
      order = 22,
      type = "header",
      name = L["capture"] },
    format = {
      order = 23,
      type = "select",
      name = L["format"],
      values = {["jpeg"] = L["jpeg"], ["png"] = L["png"], ["tga"] = L["tga"]},
      get = function() return GetCVar("screenshotFormat") end, 
      set = function(_,v)SetCVar("screenshotFormat", v) end },
    quality = {
      order = 24,
      type = "range",
      name = L["quality"],
      min = 0, max = 10, step = 1,
      get = function() return tonumber(GetCVar("screenshotQuality")) end, 
      set = function(_,v) SetCVar("screenshotQuality", v) end },
    close = {
      order = 25,
      type = "toggle",
      name = L["close"],
      get = function() return MultishotConfig.close end, 
      set = function(_,v) MultishotConfig.close = v end },
    uihide = {
      order = 26,
      type = "toggle",
      name = L["uihide"],
      get = function() return MultishotConfig.uihide end, 
      set = function(_,v) MultishotConfig.uihide = v end },
    played = {
      order = 27,
      type = "toggle",
      name = L["played"],
      get = function() return MultishotConfig.played end, 
      set = function(_,v) MultishotConfig.played = v end },
    charpane = {
      order = 28,
      type = "toggle",
      name = L["charpane"],
      get = function() return MultishotConfig.charpane end, 
      set = function(_,v) MultishotConfig.charpane = v end },
    watermark = {
      order = 29,
      type = "toggle",
      name = L["watermark"],
      get = function() return MultishotConfig.watermark end,
      set = function(_,v) MultishotConfig.watermark = v end },
    watermarkformat = {
      order = 30,
      type = "input",
      name = L["watermarkformat"],
      desc = L["set the format for watermark text"].."\n"..L["watermarkformattext"], -- "\n$n = name\n$c = class\n$l = level\n$z = zone\n$r = realm\n$d = date\n$b = line change"
      usage = L["clear the text and press Enter to restore defaults."],
      get = function() return MultishotConfig.watermarkformat end,
      set = function(_,v)
    		print(tostring(v))
    		if v == "" or not (v):find("[%w%p]+") or (v):find("\\n") then -- or (v):find("$[^nclzrdb]")
    			v = "$n($l) $c $b$z - $d$b$r"
    		end
    		MultishotConfig.watermarkformat = v
      end	},
    watermarkanchor = {
      order = 31,
      type = "select",
      name = L["watermarkanchor"],
      values = {["TOP"] = L["TOP"], ["TOPLEFT"] = L["TOPLEFT"], ["TOPRIGHT"] = L["TOPRIGHT"], ["BOTTOMLEFT"] = L["BOTTOMLEFT"], ["BOTTOMRIGHT"] = L["BOTTOMRIGHT"]}, -- add to localization
      get = function() return MultishotConfig.watermarkanchor end,
      set = function(_,v) MultishotConfig.watermarkanchor = v end },
    watermarkfont = {
      order = 32,
      type = "select",
      name = L["watermarkfont"],
      values = GetFonts,
      get = function() return MultishotConfig.watermarkfont end,
      set = function(_,v) MultishotConfig.watermarkfont = v end },
    watermarkfontsize = {
      order = 33,
      type = "select",
      name = L["watermarkfontsize"],
      values = GetFontSizes,
      get = function() return MultishotConfig.watermarkfontsize end,
      set = function(_,v) MultishotConfig.watermarkfontsize = v end },
    watermarktest = {
      order = 34,
      type = "execute",
      name = L["Test"],
      desc = L["watermarktest"],
      func = function() Multishot.test_watermark = not Multishot.test_watermark; Multishot:RefreshWatermark(Multishot.test_watermark) end  },
    header5 = {
      order = 35,
      type = "header",
      name = L["various"] },
    debug = {
      order = 36,
      type = "toggle",
      name = L["debug"],
      get = function() return MultishotConfig.debug end, 
      set = function(_,v) MultishotConfig.debug = v end },
    reset = {
      order = 37,
      type = "execute",
      name = L["reset"],
      func = function() MultishotConfig.history = {} end },
  }
}

function Multishot:TimeLineConfig(enable)
	if enable then 
  	Multishot.timeLineTimer = Multishot:ScheduleRepeatingTimer("TimeLineProgress",5) 
  else 
  	if Multishot.timeLineTimer then
  		Multishot:CancelTimer(Multishot.timeLineTimer)
		end
	end
end

function Multishot:OnInitialize()
  LibStub("AceConfig-3.0"):RegisterOptionsTable("Multishot", dataOptions)
  Multishot.PrefPane = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("Multishot")
  setmetatable(MultishotConfig, {__index = dataDefaults})
  MultishotConfig.history = MultishotConfig.history
  MultishotConfig.difficulty = MultishotConfig.difficulty
  MultishotConfig.groupstatus = MultishotConfig.groupstatus
end