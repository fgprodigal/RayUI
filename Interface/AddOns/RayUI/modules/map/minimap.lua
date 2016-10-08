﻿local R, L, P, G = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, GlobalDB
local MM = R:NewModule("MiniMap", "AceEvent-3.0", "AceHook-3.0")

--Cache global variables
--Lua functions
local _G = _G
local select, unpack, pairs, string, math = select, unpack, pairs, string, math
local strfind, gsub = string.find, string.gsub
local floor = math.floor
local sqrt = math.sqrt

--WoW API / Variables
local CreateFrame = CreateFrame
local GetWorldPVPAreaInfo = GetWorldPVPAreaInfo
local GameTime_UpdateTooltip = GameTime_UpdateTooltip
local GetMinimapShape = GetMinimapShape
local UIFrameFadeIn = UIFrameFadeIn
local UIFrameFadeOut = UIFrameFadeOut
local CalendarGetNumPendingInvites = CalendarGetNumPendingInvites
local ToggleCharacter = ToggleCharacter
local ShowUIPanel = ShowUIPanel
local HideUIPanel = HideUIPanel
local TalentFrame_LoadUI = TalentFrame_LoadUI
local ToggleAchievementFrame = ToggleAchievementFrame
local ToggleFriendsFrame = ToggleFriendsFrame
local IsInGuild = IsInGuild
local GuildFrame_LoadUI = GuildFrame_LoadUI
local GuildFrame_Toggle = GuildFrame_Toggle
local LookingForGuildFrame_LoadUI = LookingForGuildFrame_LoadUI
local LookingForGuildFrame_Toggle = LookingForGuildFrame_Toggle
local EncounterJournal_LoadUI = EncounterJournal_LoadUI
local ToggleFrame = ToggleFrame
local IsAddOnLoaded = IsAddOnLoaded
local LoadAddOn = LoadAddOn
local ToggleCollectionsJournal = ToggleCollectionsJournal
local PVEFrame_ToggleFrame = PVEFrame_ToggleFrame
local ToggleHelpFrame = ToggleHelpFrame
local GarrisonLandingPageMinimapButton_OnClick = GarrisonLandingPageMinimapButton_OnClick
local Calendar_Toggle = Calendar_Toggle
local IsShiftKeyDown = IsShiftKeyDown
local ToggleDropDownMenu = ToggleDropDownMenu
local EasyMenu = EasyMenu
local GetCursorPosition = GetCursorPosition
local Minimap_SetPing = Minimap_SetPing
local TimeManager_Toggle = TimeManager_Toggle
local Minimap_ZoomIn = Minimap_ZoomIn
local Minimap_ZoomOut = Minimap_ZoomOut

--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: GameTooltip, Minimap, HIGHLIGHT_FONT_COLOR, NORMAL_FONT_COLOR, TimeManagerClockButton, Settings
-- GLOBALS: TIMEMANAGER_ALARM_TOOLTIP_TURN_OFF, GAMETIME_TOOLTIP_TOGGLE_CLOCK, GarrisonLandingPageMinimapButton
-- GLOBALS: MinimapCluster, MiniMapTrackingBackground, MiniMapTrackingButton, MiniMapTracking, MiniMapInstanceDifficulty
-- GLOBALS: GuildInstanceDifficulty, MiniMapChallengeMode, MiniMapMailFrame, MiniMapMailIcon, GameTimeCalendarInvitesTexture
-- GLOBALS: FeedbackUIButton, StreamingIcon, MinimapZoneText, DropDownList1, LFGDungeonReadyStatus, HelpOpenTicketButton
-- GLOBALS: CHARACTER_BUTTON, SPELLBOOK_ABILITIES_BUTTON, TALENTS_BUTTON, ACHIEVEMENT_BUTTON, SOCIAL_BUTTON
-- GLOBALS: LookingForGuildFrame, StopwatchFrame, ACHIEVEMENTS_GUILD_TAB, ENCOUNTER_JOURNAL, COLLECTIONS
-- GLOBALS: LFG_TITLE, RAID_FINDER, BLIZZARD_STORE, HELP_BUTTON, GARRISON_LANDING_PAGE_TITLE, CALENDAR, LOOT_ROLLS
-- GLOBALS: SpellBookFrame, PlayerTalentFrame, GuildFrame, EncounterJournal, RaidFinderFrame, StoreMicroButton
-- GLOBALS: CalendarFrame, LootHistoryFrame, MiniMapTrackingDropDown, BlizzardStopwatchOptions

MM.modName = L["小地图"]

local function ConvertSecondstoTime(value)
	local hours, minutes, seconds
	hours = floor(value / 3600)
	minutes = floor((value - (hours * 3600)) / 60)
	seconds = floor(value - ((hours * 3600) + (minutes * 60)))

	if ( hours > 0 ) then
		return string.format("%d:%02d:%02d", hours, minutes, seconds)
	else
		return string.format("%02d:%02d", minutes, seconds)
	end
end

local function GameTooltip_AddPVPTimer()
	local _, _, _, _, WGTime = GetWorldPVPAreaInfo(1)
	local _, _, _, _, TBTime = GetWorldPVPAreaInfo(2)

	GameTooltip:AddLine(L["PVP信息"], HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)
	-- Wintergrasp
	if ( WGTime and WGTime > 0 ) then
		GameTooltip:AddDoubleLine(L["下一场冬拥湖:"], string.format("%s", ConvertSecondstoTime(WGTime)), NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)
	else
		GameTooltip:AddLine(L["冬拥湖不可用"], NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
	end
	-- Tol Barad
	if ( TBTime and TBTime > 0 ) then
		GameTooltip:AddDoubleLine(L["下一场托尔巴拉德:"], string.format("%s", ConvertSecondstoTime(TBTime)), NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)
	else
		GameTooltip:AddLine(L["托尔巴拉德不可用"], NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
	end
	GameTooltip:AddLine(" ")
end

function MM:TimeManagerClockButton_UpdateTooltip()
	GameTooltip:SetOwner(Minimap, "ANCHOR_BOTTOMRIGHT", 5, 142)
	GameTooltip:ClearLines()

	if ( TimeManagerClockButton.alarmFiring ) then
		if ( gsub(Settings.alarmMessage, "%s", "") ~= "" ) then
			GameTooltip:AddLine(Settings.alarmMessage, HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b, 1)
			GameTooltip:AddLine(" ")
		end
		GameTooltip_AddPVPTimer()
		GameTooltip:AddLine(TIMEMANAGER_ALARM_TOOLTIP_TURN_OFF)
	else
		GameTime_UpdateTooltip()
		GameTooltip:AddLine(" ")
		GameTooltip_AddPVPTimer()
		GameTooltip:AddLine(GAMETIME_TOOLTIP_TOGGLE_CLOCK)
	end
	GameTooltip:Show()
end

local function PositionGarrisonButton(self, screenQuadrant)
	GarrisonLandingPageMinimapButton:SetScale(0.7)
	screenQuadrant = screenQuadrant or R:GetScreenQuadrant(self)
	if strfind(screenQuadrant, "RIGHT") then
		GarrisonLandingPageMinimapButton:ClearAllPoints()
		GarrisonLandingPageMinimapButton:SetPoint("TOPLEFT", Minimap, "TOPLEFT", -100, 10)
	else
		GarrisonLandingPageMinimapButton:ClearAllPoints()
		GarrisonLandingPageMinimapButton:SetPoint("TOPRIGHT", Minimap, "TOPRIGHT", 100, 10)
	end
end

function MM:SkinMiniMap()
	local frames = {
		"GameTimeFrame",
		"MinimapBorderTop",
		"MinimapNorthTag",
		"MinimapBorder",
		"MinimapZoneTextButton",
		"MinimapZoomOut",
		"MinimapZoomIn",
		"MiniMapVoiceChatFrame",
		"MiniMapWorldMapButton",
		"MiniMapMailBorder",
	}
	for i in pairs(frames) do
		_G[frames[i]]:Kill()
	end
	Minimap:Size(175, 175)
	Minimap:CreateShadow("Background")
	Minimap:SetPlayerTexture("Interface\\AddOns\\RayUI\\media\\MinimapArrow")
	MinimapCluster:EnableMouse(false)
	MiniMapTrackingBackground:SetAlpha(0)
	MiniMapTrackingButton:SetAlpha(0)
	MiniMapTracking:Hide()
	MiniMapInstanceDifficulty:ClearAllPoints()
	MiniMapInstanceDifficulty:SetPoint("TOPRIGHT", Minimap, "TOPRIGHT", 2, 2)
	MiniMapInstanceDifficulty:SetScale(0.75)
	MiniMapInstanceDifficulty:SetFrameStrata("LOW")
	GuildInstanceDifficulty:ClearAllPoints()
	GuildInstanceDifficulty:SetPoint("TOPRIGHT", Minimap, "TOPRIGHT", 2, 2)
	GuildInstanceDifficulty:SetScale(0.75)
	GuildInstanceDifficulty:SetFrameStrata("LOW")
	MiniMapChallengeMode:SetParent(MinimapCluster)
	MiniMapChallengeMode:ClearAllPoints()
	MiniMapChallengeMode:SetPoint("TOPRIGHT", Minimap, "TOPRIGHT", -2, -2)
	MiniMapChallengeMode:SetScale(0.75)
	MiniMapChallengeMode:SetFrameStrata("LOW")
	MiniMapMailFrame:ClearAllPoints()
	MiniMapMailFrame:SetPoint("BOTTOMRIGHT", Minimap, "BOTTOMRIGHT", 2, -6)
	MiniMapMailIcon:SetTexture("Interface\\AddOns\\RayUI\\media\\mail")
	GameTimeCalendarInvitesTexture:ClearAllPoints()
	GameTimeCalendarInvitesTexture:SetParent(Minimap)
	GameTimeCalendarInvitesTexture:SetPoint("TOPRIGHT")
	if FeedbackUIButton then
		FeedbackUIButton:ClearAllPoints()
		FeedbackUIButton:SetPoint("TOPLEFT", Minimap, "TOPLEFT", 6, -6)
		FeedbackUIButton:SetScale(0.8)
	end
	if StreamingIcon then
		StreamingIcon:ClearAllPoints()
		StreamingIcon:SetPoint("TOPRIGHT", Minimap, "TOPRIGHT", 8, 8)
		StreamingIcon:SetScale(0.8)
	end
	function GetMinimapShape()
		return "SQUARE"
	end
	Minimap:SetMaskTexture("Interface\\Buttons\\WHITE8X8")
	local zoneTextFrame = CreateFrame("Frame", nil, R.UIParent)
	zoneTextFrame:SetPoint("TOPLEFT", Minimap, "TOPLEFT", 0, 10)
	zoneTextFrame:SetPoint("TOPRIGHT", Minimap, "TOPRIGHT", 0, 10)
	zoneTextFrame:SetHeight(19)
	zoneTextFrame:SetAlpha(0)
	MinimapZoneText:SetParent(zoneTextFrame)
	MinimapZoneText:ClearAllPoints()
	MinimapZoneText:SetPoint("LEFT", 2, 1)
	MinimapZoneText:SetPoint("RIGHT", -2, 1)
	MinimapZoneText:SetFont(R["media"].font, R["media"].fontsize, R["media"].fontflag)
	Minimap:HookScript("OnEnter", function(self)
		UIFrameFadeIn(zoneTextFrame, 0.3, 0, 1)
	end)
	Minimap:HookScript("OnLeave", function(self)
		UIFrameFadeOut(zoneTextFrame, 0.3, 1, 0)
	end)
	DropDownList1:SetClampedToScreen(true)
	LFGDungeonReadyStatus:SetClampedToScreen(true)
	HelpOpenTicketButton:SetParent(Minimap)
	HelpOpenTicketButton:ClearAllPoints()
	HelpOpenTicketButton:SetPoint("BOTTOMRIGHT", Minimap, "BOTTOMRIGHT")
end

function MM:CheckMail()
	local inv = CalendarGetNumPendingInvites()
	local mail = MiniMapMailFrame:IsShown() and true or false
	if inv > 0 and mail then -- New invites and mail
		Minimap.shadow:SetBackdropBorderColor(1, .5, 0)
        R:GetModule("Skins"):CreatePulse(Minimap.shadow, 1, 1)
	elseif inv > 0 and not mail then -- New invites and no mail
		Minimap.shadow:SetBackdropBorderColor(1, 30/255, 60/255)
        R:GetModule("Skins"):CreatePulse(Minimap.shadow, 1, 1)
	elseif inv==0 and mail then -- No invites and new mail
		Minimap.shadow:SetBackdropBorderColor(.5, 1, 1)
        R:GetModule("Skins"):CreatePulse(Minimap.shadow, 1, 1)
	else -- None of the above
        Minimap.shadow:SetScript("OnUpdate", nil)
		if R.global.general.theme == "Shadow" then
			Minimap.shadow:SetAlpha(1)
		else
			Minimap.shadow:SetAlpha(0)
        end
		Minimap.shadow:SetBackdropBorderColor(unpack(R["media"].bordercolor))
	end
end

function MM:CreateMenu()
	local menuFrame = CreateFrame("Frame", "RayUI_MinimapRightClickMenu", R.UIParent, "UIDropDownMenuTemplate")
	local menuList = {
		{text = CHARACTER_BUTTON, notCheckable = true,
		func = function() ToggleCharacter("PaperDollFrame") end},
		{text = SPELLBOOK_ABILITIES_BUTTON, notCheckable = true,
		func = function() if not SpellBookFrame:IsShown() then ShowUIPanel(SpellBookFrame) else HideUIPanel(SpellBookFrame) end end},
		{text = TALENTS_BUTTON, notCheckable = true,
		func = function()
			if not PlayerTalentFrame then
				TalentFrame_LoadUI()
			end

			if not PlayerTalentFrame:IsShown() then
				ShowUIPanel(PlayerTalentFrame)
			else
				HideUIPanel(PlayerTalentFrame)
			end
		end},
		{text = ACHIEVEMENT_BUTTON, notCheckable = true,
		func = function() ToggleAchievementFrame() end},
		{text = SOCIAL_BUTTON, notCheckable = true,
		func = function() ToggleFriendsFrame() end},
		{text = ACHIEVEMENTS_GUILD_TAB, notCheckable = true,
		func = function() ToggleGuildFrame() end},
		{text = ENCOUNTER_JOURNAL, notCheckable = true,
		func = function() if not IsAddOnLoaded("Blizzard_EncounterJournal") then EncounterJournal_LoadUI() end ToggleFrame(EncounterJournal) end},
		{text = COLLECTIONS, notCheckable = true,
		func = function()
			ToggleCollectionsJournal();
		end},
		{text = LFG_TITLE, notCheckable = true,
		func = function() PVEFrame_ToggleFrame() end},
		{text = RAID_FINDER, notCheckable = true,
		func = function() PVEFrame_ToggleFrame("GroupFinderFrame", RaidFinderFrame) end},
		{text = BLIZZARD_STORE, notCheckable = true,
		func = function() StoreMicroButton:Click() end},
		{text = HELP_BUTTON, notCheckable = true,
		func = function() ToggleHelpFrame() end},
		{text = GARRISON_LANDING_PAGE_TITLE, notCheckable = true,
		func = function() GarrisonLandingPageMinimapButton_OnClick() end},
		{text = CALENDAR, notCheckable = true,
		func = function() GameTimeFrame:Click() end},
		{text = LOOT_ROLLS, notCheckable = true,
		func = function() ToggleFrame(LootHistoryFrame) end},
	}
	Minimap:SetScript("OnMouseUp", function(_, btn)
		if( btn == "RightButton" and not IsShiftKeyDown() ) then
			ToggleDropDownMenu(1, nil, MiniMapTrackingDropDown, "cursor", 0, 0)
		elseif(btn == "MiddleButton" or ( btn== "RightButton" and IsShiftKeyDown())) then
			EasyMenu(menuList, menuFrame, "cursor", 0, 0, "MENU", 1)
		else
			local x, y = GetCursorPosition()
			x = x / Minimap:GetEffectiveScale()
			y = y / Minimap:GetEffectiveScale()
			local cx, cy = Minimap:GetCenter()
			x = x - cx
			y = y - cy
			if ( sqrt(x * x + y * y) < (Minimap:GetWidth() / 2) ) then
				Minimap:PingLocation(x, y)
			end
			Minimap_SetPing(x, y, 1)
		end
	end)
	self:RegisterEvent("CALENDAR_UPDATE_PENDING_INVITES", "CheckMail")
	self:RegisterEvent("UPDATE_PENDING_MAIL", "CheckMail")
	self:RegisterEvent("PLAYER_ENTERING_WORLD", "CheckMail")
	MM:HookScript(MiniMapMailFrame, "OnHide", "CheckMail")
	MM:HookScript(MiniMapMailFrame, "OnShow", "CheckMail")
	Minimap.shadow:SetBackdrop( {
		edgeFile = R["media"].glow,
        bgFile = R["media"].blank,
		edgeSize = R:Scale(4),
        tile = false,
        tileSize = 0,
		insets = {left = R:Scale(4), right = R:Scale(4), top = R:Scale(4), bottom = R:Scale(4)},
	})
end

function MM:Info()
	return L["|cff7aa6d6Ray|r|cffff0000U|r|cff7aa6d6I|r小地图模块."]
end

local function MinimapPostDrag(self, screenQuadrant)
    MM:PositionButtonCollector(self, screenQuadrant)
    PositionGarrisonButton(self, screenQuadrant)
end

function MM:Initialize()
	if not IsAddOnLoaded("Blizzard_TimeManager") then
		LoadAddOn("Blizzard_TimeManager")
		if ( not BlizzardStopwatchOptions ) then
			BlizzardStopwatchOptions = {}
		end

		if ( BlizzardStopwatchOptions.position ) then
			StopwatchFrame:ClearAllPoints()
			StopwatchFrame:SetPoint("CENTER", R.UIParent, "BOTTOMLEFT", BlizzardStopwatchOptions.position.x, BlizzardStopwatchOptions.position.y)
			StopwatchFrame:SetUserPlaced(true)
		else
			StopwatchFrame:SetPoint("TOPRIGHT", R.UIParent, "TOPRIGHT", -250, -300)
		end
	end
	self:SkinMiniMap()
	self:CreateMenu()
	self:ButtonCollector()
	self:RawHook("TimeManagerClockButton_UpdateTooltip", true)
	Minimap:ClearAllPoints()
	Minimap:Point("TOPLEFT", R.UIParent, "TOPLEFT", 10, -20)
	Minimap:SetFrameLevel(10)
	local clockFrame, clockTime = TimeManagerClockButton:GetRegions()
	clockFrame:Hide()
	clockTime:SetFont(R["media"].font, R["media"].fontsize, R["media"].fontflag)
	clockTime:SetTextColor(1,1,1)
	TimeManagerClockButton:SetPoint("BOTTOM", Minimap, "BOTTOM", 0, -3)
	TimeManagerClockButton:SetScript("OnClick", function(_,btn)
		if btn == "LeftButton" then
			TimeManager_Toggle()
		end
		if btn == "RightButton" then
			if not CalendarFrame then
				LoadAddOn("Blizzard_Calendar")
			end
			Calendar_Toggle()
		end
	end)
	Minimap:EnableMouseWheel(true)
	Minimap:SetScript("OnMouseWheel", function(_, zoom)
		if zoom > 0 then
			Minimap_ZoomIn()
		else
			Minimap_ZoomOut()
		end
	end)
	R:CreateMover(Minimap, "MinimapMover", L["小地图锚点"], true, MinimapPostDrag)
end

R:RegisterModule(MM:GetName())
