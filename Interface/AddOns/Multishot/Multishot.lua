Multishot = LibStub("AceAddon-3.0"):NewAddon("Multishot", "AceConsole-3.0", "AceEvent-3.0", "AceTimer-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("Multishot")

MultishotConfig = {}
Multishot.BossID = LibStub("LibBossIDs-1.0").BossIDs
Multishot.RareID = LibStub("LibRareIds-1.0").Data

local isEnabled, isDelayed
local strMatch = string.gsub(FACTION_STANDING_CHANGED, "%%%d?%$?s", "(.+)")
local prefix = "WoWScrnShot_"
local player = (UnitName("player"))
local class = (UnitClass("player"))
local realm = GetRealmName()
local extension, intAlpha, minimapStatus
local timeLineStart, timeLineElapsed

function Multishot:OnEnable()
  self:RegisterEvent("PLAYER_LEVEL_UP")
  self:RegisterEvent("UNIT_GUILD_LEVEL")
  self:RegisterEvent("ACHIEVEMENT_EARNED")
  self:RegisterEvent("CHALLENGE_MODE_COMPLETED")
  self:RegisterEvent("UPDATE_BATTLEFIELD_STATUS")
  self:RegisterEvent("TRADE_ACCEPT_UPDATE")
  self:RegisterEvent("CHAT_MSG_SYSTEM")
  self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
  self:RegisterEvent("PLAYER_REGEN_ENABLED")
  self:RegisterEvent("GARISSON_BUILDING_ACTIVATED")
  self:RegisterEvent("SCREENSHOT_FAILED", "Debug")
  if MultishotConfig.timeLineEnable then
  	self.timeLineTimer = self:ScheduleRepeatingTimer("TimeLineProgress",5)
  	timeLineStart, timeLineElapsed = GetTime(), 0
  end
  local ssformat = GetCVar("screenshotFormat")
  extension = (ssformat == "tga") and ".tga" or (ssformat == "png") and ".png" or ".jpg"
  Multishot.watermarkFrame = Multishot.watermarkFrame or Multishot:CreateWatermark()
    
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

function Multishot:CHALLENGE_MODE_COMPLETED(strEvent)
	if not MultishotConfig.challengemode then return end
	local mapID, medal, completionTime, moneyAmount, numRewards = GetChallengeModeCompletionInfo()
	if (medal) and CHALLENGE_MEDAL_TEXTURES[medal] then -- only take screenshot for bronze and up for now
		self:ScheduleTimer("CustomScreenshot", MultishotConfig.delay1, strEvent)
	end
end

function Multishot:UPDATE_BATTLEFIELD_STATUS(strEvent)
	if not MultishotConfig.arena or MultishotConfig.battleground then return end
	local winner = GetBattlefieldWinner()
	if not winner then return end
	local isArena, registered = IsActiveBattlefieldArena()
	if (isArena) and not MultishotConfig.arena then return end
	if isArena then
		if IsInArenaTeam() then
			if not PLAYER_FACTION_GROUP[winner] then -- draw, get our screenshot and bail
				self:ScheduleTimer("CustomScreenshot", MultishotConfig.delay1, strEvent)
				return
			end
			local playerTeamId
			for i=1, GetNumBattlefieldScores() do
				local name, _, _, _, _, teamId = GetBattlefieldScore(i)
				if name == player then
					playerTeamId = teamId
					break
				end
			end
			if playerTeamId and playerTeamId == winner then
				self:ScheduleTimer("CustomScreenshot", MultishotConfig.delay1, strEvent)
			end
		end
	else
		if PLAYER_FACTION_GROUP[winner] == GetPlayerFactionGroup() then
			self:ScheduleTimer("CustomScreenshot", MultishotConfig.delay1, strEvent)
		end
	end
end

function Multishot:CHAT_MSG_SYSTEM(strEvent, strMessage)
  if MultishotConfig.repchange then
    if string.match(strMessage, strMatch) then
      self:ScheduleTimer("CustomScreenshot", MultishotConfig.delay1, strEvent) 
    end
  end
end

function Multishot:CHAT_MSG_MONSTER_SAY(strEvent, strBuilding, arg2, arg3, arg4, strPlayer)
	if MultishotConfig.timeLineEnable then timeLineStart,timeLineElapsed = GetTime(),0 end
	TakeScreenshot()
	self:UnregisterEvent("CHAT_MSG_MONSTER_SAY")
end

function Multishot:TIME_PLAYED_MSG(strEvent, total, thislevel)
	if MultishotConfig.timeLineEnable then timeLineStart,timeLineElapsed = GetTime(),0 end
  TakeScreenshot()
  self:UnregisterEvent("TIME_PLAYED_MSG")
end

function Multishot:GARISSON_BUILDING_ACTIVATED(strEvent, arg1, arg2)
	if MultishotConfig.garissonbuild then
		self:RegisterEvent("CHAT_MSG_MONSTER_SAY")
	end
end

function Multishot:COMBAT_LOG_EVENT_UNFILTERED(strEvent, ...)
  local strType, _, sourceGuid, _, _, _, destGuid = select(2, ...) -- 4.1 compat, 4.2 compat
  local currentId = destGuid and tonumber(destGuid:sub(-16, -12)) -- 6.x
  if strType == "UNIT_DIED" or strType == "PARTY_KILL" then
    local solo, inParty, inRaid
    if IsInRaid() then inRaid = true elseif IsInGroup() then inParty = true else solo = true end
    local _,_,difficultyID = GetInstanceInfo()
    if not (sourceGuid == UnitGUID("player") and MultishotConfig.rares and Multishot.RareID[currentId]) and strType == "PARTY_KILL" then return end
    if not ((solo and MultishotConfig.groupstatus["1solo"]) or (inParty and MultishotConfig.groupstatus["2party"]) or (inRaid and MultishotConfig.groupstatus["3raid"])) then return end
    if difficultyID and not MultishotConfig.difficulty[difficultyID] then return end
    if not (Multishot_dbWhitelist[currentId] or Multishot.BossID[currentId] or Multishot.RareID[currentId]) or Multishot_dbBlacklist[currentId] then return end
    if MultishotConfig.firstkill and MultishotConfig.history[UnitName("player") .. currentId] then return end
    MultishotConfig.history[player .. currentId] = true
    isDelayed = currentId
    if UnitIsDead("player") then
      self:PLAYER_REGEN_ENABLED(strType)
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
  self:UIToggle(true)
  self:RefreshWatermark(false)
  self:UnregisterEvent("SCREENSHOT_SUCCEEDED")
end

function Multishot:RefreshWatermark(show)
	if not show then Multishot.watermarkFrame:Hide() return end

	local anchor = MultishotConfig.watermarkanchor
	Multishot.watermarkFrame:ClearAllPoints()
	Multishot.watermarkFrame:SetPoint(anchor)

	Multishot.watermarkFrame.Text:ClearAllPoints()
	Multishot.watermarkFrame.Text:SetPoint("CENTER",Multishot.watermarkFrame,"CENTER")
	Multishot.watermarkFrame.Text:SetJustifyH("CENTER")
	
	local text = MultishotConfig.watermarkformat
	local level = UnitLevel("player")
	local zone = GetRealZoneText()
	local tdate = date()

	text = text:gsub("$n", player)
	text = text:gsub("$l", level)
	text = text:gsub("$c", class)
	text = text:gsub("$z", zone)
	text = text:gsub("$r", realm)
	text = text:gsub("$d", tdate)
	text = text:gsub("$b","\n" )
	
	Multishot.watermarkFrame.Text:SetFont(MultishotConfig.watermarkfont, MultishotConfig.watermarkfontsize, "OUTLINE")
	Multishot.watermarkFrame.Text:SetFormattedText("%s%s%s",YELLOW_FONT_COLOR_CODE,text,FONT_COLOR_CODE_CLOSE)
	
	Multishot.watermarkFrame:Show()
end

function Multishot:CreateWatermark()
	local f = CreateFrame("Frame", "MultishotWatermark", WorldFrame)
	f:SetFrameStrata("TOOLTIP")
	f:SetFrameLevel(0)
	f:SetWidth(350)
	f:SetHeight(100)
	
	f.Text = f:CreateFontString(nil, "OVERLAY")
	f.Text:SetShadowOffset(1, -1)
	
	return f
end

function Multishot:TimeLineProgress()
	local now = GetTime()
	timeLineStart = timeLineStart or now
	timeLineElapsed = timeLineElapsed or 0
	if UnitIsAFK("player") then
		timeLineStart = now - timeLineElapsed
	else
		timeLineElapsed = now - timeLineStart
	end
	if timeLineElapsed >= (MultishotConfig.delay3 * 60) then
		self:ScheduleTimer("CustomScreenshot", 0.2, L["timeline"])
	end
end

function Multishot:CustomScreenshot(strDebug)
  self:Debug(strDebug)
  self:RegisterEvent("SCREENSHOT_SUCCEEDED")
  if MultishotConfig.charpane and not PaperDollFrame:IsVisible() then 
  	ToggleCharacter("PaperDollFrame")
  	if not PaperDollFrame:IsVisible() then
  		self:ScheduleTimer("CustomScreenshot", 0.2, "RETRY")
  	end
  end
  if MultishotConfig.close and strDebug ~= "TRADE_ACCEPT_UPDATE" then CloseAllWindows() end
  if MultishotConfig.uihide and 
  (string.find(strDebug, "PLAYER_REGEN_ENABLED") 
  or string.find(strDebug, "UNIT_DIED") 
  or string.find(strDebug, "PARTY_KILL")
  or string.find(strDebug, "CHALLENGE_MODE_COMPLETED") 
  or string.find(strDebug, "PLAYER_LEVEL_UP") 
  or string.find(strDebug, L["timeline"])
  or string.find(strDebug, KEY_BINDING)) then
    self:UIToggle()
  end
  if MultishotConfig.watermark then self:RefreshWatermark(true) end
  if MultishotConfig.played and (strDebug == "PLAYER_LEVEL_UP" or strDebug == "ACHIEVEMENT_EARNED" or strDebug == "CHAT_MSG_SYSTEM" or strDebug == "CHAT_MSG_MONSTER_SAY" or strDebug == KEY_BINDING) and strDebug ~= "TIME_PLAYED_MSG" then self:RegisterEvent("TIME_PLAYED_MSG") RequestTimePlayed() return end
  if MultishotConfig.timeLineEnable then timeLineStart,timeLineElapsed = GetTime(),0 end
  TakeScreenshot()
end

function Multishot:UIToggle(show)
	if not show then
		intAlpha = UIParent:GetAlpha()
 		minimapStatus = Minimap:IsShown()
-- 		if minimapStatus then Minimap:Hide() end -- taints if called in combat
		UIParent:SetAlpha(0)
	else
		if intAlpha and intAlpha > 0 then
			UIParent:SetAlpha(intAlpha)
			intAlpha = nil
		else
			UIParent:SetAlpha(1)
		end
-- 		if minimapStatus then Minimap:Show() end
	end
end

function Multishot:Debug(strMessage)
	if strMessage == "SCREENSHOT_FAILED" then
		self:UIToggle(true)
		self:RefreshWatermark(false)
	end
  if MultishotConfig.debug then self:Print(strMessage) end
end

BINDING_HEADER_MULTISHOT = "Multishot"
BINDING_NAME_MULTISHOTSCREENSHOT = L["Custom screenshot"]

--[[
Notes
SetUIVisibility(visible)
]]