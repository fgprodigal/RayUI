local L = LibStub("AceLocale-3.0"):GetLocale("Multishot")
local dataDefaults = { levelup = false, achievement = true, party = false, raid = false, rares = true, repchange = false, delay1 = 1.2,  delay2 = 2, debug = false, trade = false, firstkill = false, close = false, uihide = false, played = false, charpane = false, guildlevelup = true, guildachievement = true, history = {} }
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
    repchange = {
      order = 5,
      type = "toggle",
      name = L["repchange"],
      get = function() return MultishotConfig.repchange end,
      set = function(_,v) MultishotConfig.repchange = v end },
    trade = {
      order = 6,
      type = "toggle",
      name = L["trade"],
      get = function() return MultishotConfig.trade end,
      set = function(_,v) MultishotConfig.trade = v end },
    header1 = {
      order = 7,
      type = "header",
      name = L["bosskillshots"] },
    party = {
      order = 8,
      type = "toggle",
      name = L["bosskillsparty"],
      get = function() return MultishotConfig.party end, 
      set = function(_,v) MultishotConfig.party = v end },
    rares = {
      order = 9,
      type = "toggle",
      name = L["rarekills"],
      get = function() return MultishotConfig.rares end, 
      set = function(_,v) MultishotConfig.rares = v end },
    raid = {
      order = 10,
      type = "toggle",
      name = L["bosskillsraid"],
      get = function() return MultishotConfig.raid end,
      set = function(_,v) MultishotConfig.raid = v end },
    firstkills = {
      order = 11,
      type = "toggle",
      name = L["firstkills"],
      get = function() return MultishotConfig.firstkill end, 
      set = function(_,v) MultishotConfig.firstkill = v end },
    header2 = {
      order = 12,
      type = "header",
      name = L["delay"] },
    delay1 = {
      order = 13,
      type = "range",
      name = L["delayother"],
      min = .1, max = 10, step = .1,
      get = function() return MultishotConfig.delay1 end,
      set = function(_,v) MultishotConfig.delay1 = v end },
    delay2 = {
      order = 14,
      type = "range",
      name = L["delaykill"],
      min = .1, max = 10, step = .1,
      get = function() return MultishotConfig.delay2 end, 
      set = function(_,v) MultishotConfig.delay2 = v end },
    header3 = {
      order = 15,
      type = "header",
      name = L["capture"] },
    format = {
      order = 16,
      type = "select",
      name = L["format"],
      values = {["jpeg"] = L["jpeg"], ["png"] = L["png"], ["tga"] = L["tga"]},
      get = function() return GetCVar("screenshotFormat") end, 
      set = function(_,v)SetCVar("screenshotFormat", v) end },
    quality = {
      order = 17,
      type = "range",
      name = L["quality"],
      min = 0, max = 10, step = 1,
      get = function() return tonumber(GetCVar("screenshotQuality")) end, 
      set = function(_,v) SetCVar("screenshotQuality", v) end },
    close = {
      order = 18,
      type = "toggle",
      name = L["close"],
      get = function() return MultishotConfig.close end, 
      set = function(_,v) MultishotConfig.close = v end },
    uihide = {
      order = 19,
      type = "toggle",
      name = L["uihide"],
      get = function() return MultishotConfig.uihide end, 
      set = function(_,v) MultishotConfig.uihide = v end },
    played = {
      order = 20,
      type = "toggle",
      name = L["played"],
      get = function() return MultishotConfig.played end, 
      set = function(_,v) MultishotConfig.played = v end },
    charpane = {
      order = 21,
      type = "toggle",
      name = L["charpane"],
      get = function() return MultishotConfig.charpane end, 
      set = function(_,v) MultishotConfig.charpane = v end },
    header4 = {
      order = 22,
      type = "header",
      name = L["various"] },
    debug = {
      order = 23,
      type = "toggle",
      name = L["debug"],
      get = function() return MultishotConfig.debug end, 
      set = function(_,v) MultishotConfig.debug = v end },
    reset = {
      order = 24,
      type = "execute",
      name = L["reset"],
      func = function() MultishotConfig.history = {} end },
} }

function Multishot:OnInitialize()
  LibStub("AceConfig-3.0"):RegisterOptionsTable("Multishot", dataOptions)
  Multishot.PrefPane = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("Multishot")
  setmetatable(MultishotConfig, {__index = dataDefaults})
  MultishotConfig.history = MultishotConfig.history
end