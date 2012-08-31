Multishot = LibStub("AceAddon-3.0"):NewAddon("Multishot", "AceConsole-3.0", "AceEvent-3.0", "AceTimer-3.0")

MultishotConfig = {}
Multishot.BossID = LibStub("LibBossIDs-1.0").BossIDs
Multishot.RareID = LibStub("LibRareIds-1.0").Data

local isEnabled, isDelayed
local strMatch = string.gsub(FACTION_STANDING_CHANGED, "%%%d?%$?s", "(.+)")
local prefix = "WoWScrnShot_"
local player = (UnitName("player"))
local extension, intAlpha

function Multishot:OnEnable()
  self:RegisterEvent("PLAYER_LEVEL_UP")
  self:RegisterEvent("UNIT_GUILD_LEVEL")
  self:RegisterEvent("ACHIEVEMENT_EARNED")
  self:RegisterEvent("TRADE_ACCEPT_UPDATE")
  self:RegisterEvent("CHAT_MSG_SYSTEM")
  self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
  self:RegisterEvent("PLAYER_REGEN_ENABLED")  
  self:RegisterEvent("SCREENSHOT_FAILED", "Debug")
  local ssformat = GetCVar("screenshotFormat")
  extension = (ssformat == "tga") and ".tga" or (ssformat == "png") and ".png" or ".jpg"
  self:RegisterChatCommand("multishot", function()
    InterfaceOptionsFrame_OpenToCategory(Multishot.PrefPane)
  end)
end

function Multishot:PLAYER_LEVEL_UP(strEvent)
  if MultishotConfig.levelup then self:ScheduleTimer("CustomScreenshot", MultishotConfig.delay1, strEvent) end
end

function Multishot:UNIT_GUILD_LEVEL(strEvent, strUnit)
  if MultishotConfig.guildlevelup and strUnit == "player" then self:ScheduleTimer("CustomScreenshot", MultishotConfig.delay1, strEvent) end
end

function Multishot:ACHIEVEMENT_EARNED(strEvent, intId)
  if MultishotConfig.guildachievement and select(12, GetAchievementInfo(intId)) then self:ScheduleTimer("CustomScreenshot", MultishotConfig.delay1, strEvent) end
  if MultishotConfig.achievement and not select(12, GetAchievementInfo(intId)) then self:ScheduleTimer("CustomScreenshot", MultishotConfig.delay1, strEvent) end
end

function Multishot:TRADE_ACCEPT_UPDATE(strEvent, strPlayer, strTarget)
  if ((strPlayer == 1 and strTarget == 0) or (strPlayer == 0 and strTarget == 1)) and MultishotConfig.trade then
    self:CustomScreenshot(strEvent)
  end
end

function Multishot:CHAT_MSG_SYSTEM(strEvent, strMessage)
  if MultishotConfig.repchange then
    if string.match(strMessage, strMatch) then
      self:ScheduleTimer("CustomScreenshot", MultishotConfig.delay1, strEvent) 
    end
  end
end

function Multishot:TIME_PLAYED_MSG(strEvent, total, thislevel)
	self:ScheduleTimer("CustomScreenshot", MultishotConfig.delay1, strEvent)
	self:UnregisterEvent("TIME_PLAYED_MSG")
end

function Multishot:COMBAT_LOG_EVENT_UNFILTERED(strEvent, ...)
  local strType, _, sourceGuid, _, _, destGuid = select(2, ...) -- 4.1 compat
  local currentId = tonumber("0x" .. string.sub(destGuid, 7, 10))
  if strType == "UNIT_DIED" or strType == "PARTY_KILL" then
    local inInstance, instanceType = IsInInstance()
    if not (sourceGuid == UnitGUID("player") and MultishotConfig.rares and Multishot.RareID[currentId]) and strType == "PARTY_KILL" then return end
    if not ((instanceType == "party" and MultishotConfig.party) or (instanceType == "raid" and MultishotConfig.raid)) then return end
    if not (Multishot_dbWhitelist[currentId] or Multishot.BossID[currentId]) or Multishot_dbBlacklist[currentId] then return end
    if MultishotConfig.firstkill and MultishotConfig.history[UnitName("player") .. currentId] then return end
    MultishotConfig.history[player .. currentId] = true
    if UnitIsDead("player") then
      self:PLAYER_REGEN_ENABLED(strType)
    else
      isDelayed = currentId
    end
  end
end

function Multishot:PLAYER_REGEN_ENABLED(strEvent)
  if isDelayed then 
    self:ScheduleTimer("CustomScreenshot", MultishotConfig.delay2, strEvent .. isDelayed)
    isDelayed = nil
  end
end

function Multishot:SCREENSHOT_SUCCEEDED(strEvent)
	local minus1, now, plus1 = date(nil,time()-1), date(), date(nil,time()+1)
  local filea = prefix..minus1:gsub("[/:]",""):gsub(" ","_")..extension
  local fileb = prefix..now:gsub("[/:]",""):gsub(" ","_")..extension
  local filec = prefix..plus1:gsub("[/:]",""):gsub(" ","_")..extension
  if not MultishotPlayerScreens then MultishotPlayerScreens = {} end
  if not MultishotPlayerScreens[player] then MultishotPlayerScreens[player] = {} end
  tinsert(MultishotPlayerScreens[player], filea)
  tinsert(MultishotPlayerScreens[player], fileb)
  tinsert(MultishotPlayerScreens[player], filec)
  if intAlpha and intAlpha > 0 then
    UIParent:SetAlpha(intAlpha)
    intAlpha = nil
  end
  self:UnregisterEvent("SCREENSHOT_SUCCEEDED")
end

function Multishot:CustomScreenshot(strDebug)
  self:Debug(strDebug)
  self:RegisterEvent("SCREENSHOT_SUCCEEDED")
  if MultishotConfig.charpane then ToggleCharacter("PaperDollFrame") end
  if MultishotConfig.close and strDebug ~= "TRADE_ACCEPT_UPDATE" then CloseAllWindows() end
  if MultishotConfig.played and (strDebug == "PLAYER_LEVEL_UP" or strDebug == "ACHIEVEMENT_EARNED" or strDebug == "CHAT_MSG_SYSTEM") and strDebug ~= "TIME_PLAYED_MSG" then RequestTimePlayed() self:RegisterEvent("TIME_PLAYED_MSG") end
  if MultishotConfig.uihide and (string.find(strDebug, "PLAYER_REGEN_ENABLED") or string.find(strDebug, "UNIT_DIED") or string.find(strDebug, "PARTY_KILL") or string.find(strDebug, "PLAYER_LEVEL_UP")) then
    intAlpha = UIParent:GetAlpha()
    UIParent:SetAlpha(0)
  end
  -- Screenshot()
  TakeScreenshot() -- WorldFrame function that wraps Screenshot() hiding ActionStatus frame ("screen captured" message) 
end

function Multishot:Debug(strMessage)
  if MultishotConfig.debug then self:Print(strMessage) end
end