local R, L, P, G = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, GlobalDB
local IF = R:GetModule("InfoBar")
local LibQTip = LibStub("LibQTip-1.0")

--Cache global variables
--Lua functions
local select, string, ipairs, type, unpack = select, string, ipairs, type, unpack
local math = math
local wipe = table.wipe
local tinsert = table.insert
local strsplit = string.split

--WoW API / Variables
local IsAltKeyDown = IsAltKeyDown
local IsControlKeyDown = IsControlKeyDown
local InviteUnit = InviteUnit
local InviteToGroup = InviteToGroup
local GetNumGuildMembers = GetNumGuildMembers
local GetGuildRosterInfo = GetGuildRosterInfo
local ChatFrame_GetMobileEmbeddedTexture = ChatFrame_GetMobileEmbeddedTexture
local CanViewOfficerNote = CanViewOfficerNote
local IsInGuild = IsInGuild
local GetGuildInfo = GetGuildInfo
local GetGuildRosterMOTD = GetGuildRosterMOTD
local IsAddOnLoaded = IsAddOnLoaded
local LoadAddOn = LoadAddOn
local GuildRoster = GuildRoster
local InCombatLockdown = InCombatLockdown
local HideDropDownMenu = HideDropDownMenu
local GetRelativeDifficultyColor = GetRelativeDifficultyColor
local PlaySound = PlaySound
local CanEditPublicNote = CanEditPublicNote
local SetGuildRosterSelection = SetGuildRosterSelection
local StaticPopup_Show = StaticPopup_Show
local CanEditOfficerNote = CanEditOfficerNote
local CloseDropDownMenus = CloseDropDownMenus
local GuildControlGetNumRanks = GuildControlGetNumRanks
local UnitLevel = UnitLevel

--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: SetItemRef, REMOTE_CHAT, NAME, LEVEL_ABBR, ZONE, RANK, GUILD_OFFICERNOTES_LABEL
-- GLOBALS: GUILD_RANK0_DESC, GuildFrame, ERR_FRIEND_ONLINE_SS, GUILD, LABEL_NOTE, GuildFrame_Toggle
-- GLOBALS: RayUI_InfobarTooltipFont, ChatFrame_SendTell, GREEN_FONT_COLOR_CODE, GuildRoster_ShowMemberDropDown

local GuildMemeberData = {}
local PlayerStatusValToStr = {
    [1] = CHAT_FLAG_AFK,
    [2] = CHAT_FLAG_DND,
}
local displayString = string.join("", GUILD, ": %d|r")
local noGuildString = string.join("", "", L["没有公会"])
local resendRequest = false
local FRIEND_ONLINE
local Tooltip
local NUM_TOOLTIP_COLUMNS
local GuildMemberIndexByName = {}

local function RequestUpdates()
	if IsInGuild() then
		GuildRoster()
	end
end

local function Tooltip_OnRelease(self)
    HideDropDownMenu(1)

    Tooltip:SetFrameStrata("TOOLTIP")
    Tooltip = nil
end

local function ColorPlayerLevel(level)
	if type(level) ~= "number" then
		return level
	end
	local color = GetRelativeDifficultyColor(UnitLevel("player"), level)
	return ("|cff%02x%02x%02x%d|r"):format(color.r * 255, color.g * 255, color.b * 255, level)
end

local function PercentColorGradient(min, max)
	local red_low, green_low, blue_low = 1, 0.10, 0.10
	local red_mid, green_mid, blue_mid = 1, 1, 0
	local red_high, green_high, blue_high = 0.25, 0.75, 0.25
	local percentage = min / max

	if percentage >= 1 then
		return red_high, green_high, blue_high
	elseif percentage <= 0 then
		return red_low, green_low, blue_low
	end
	local integral, fractional = math.modf(percentage * 2)

	if integral == 1 then
		red_low, green_low, blue_low, red_mid, green_mid, blue_mid = red_mid, green_mid, blue_mid, red_high, green_high, blue_high
	end
	return red_low + (red_mid - red_low) * fractional, green_low + (green_mid - green_low) * fractional, blue_low + (blue_mid - blue_low) * fractional
end

local function GuildMember_OnMouseUp(tooltipCell, playerEntry, button)
	if not IsAddOnLoaded("Blizzard_GuildUI") then
		LoadAddOn("Blizzard_GuildUI")
	end

	PlaySound("igMainMenuOptionCheckBoxOn")

	local playerName = playerEntry.Realm == R.myrealm and playerEntry.ToonName or playerEntry.FullToonName

	if button == "LeftButton" then
		if IsAltKeyDown() then
			InviteToGroup(playerName)
		elseif IsControlKeyDown() and CanEditPublicNote() then
			SetGuildRosterSelection(GuildMemberIndexByName[playerName])
			StaticPopup_Show("SET_GUILDPLAYERNOTE")
		else
			ChatFrame_SendTell(playerName)
		end
	elseif button == "RightButton" then
		if IsControlKeyDown() and CanEditOfficerNote() then
			SetGuildRosterSelection(GuildMemberIndexByName[playerName])
			StaticPopup_Show("SET_GUILDOFFICERNOTE")
		else
			Tooltip:SetFrameStrata("DIALOG")
			CloseDropDownMenus()
			GuildRoster_ShowMemberDropDown(playerName, true, playerEntry.IsMobile)
		end
	end
end

local function RenderTooltip(anchorFrame)
    local paddingLeft, paddingRight = 5, 5
    NUM_TOOLTIP_COLUMNS = CanViewOfficerNote() and 6 or 5
    if not Tooltip then
        Tooltip = LibQTip:Acquire("RayUI_InfobarGuildTooltip", NUM_TOOLTIP_COLUMNS, "LEFT", "LEFT", "LEFT", "LEFT", "LEFT", "LEFT")
        Tooltip:SetAutoHideDelay(0.001, anchorFrame)
        Tooltip:SetBackdrop(nil)
        Tooltip:SmartAnchorTo(anchorFrame)
        Tooltip:SetHighlightTexture([[Interface\QuestFrame\UI-QuestTitleHighlight]])
        Tooltip:CreateShadow("Background")
        if not Tooltip.stripesthin then
            R:GetModule("Skins"):CreateStripesThin(Tooltip)
            Tooltip.stripesthin:SetInside(Tooltip, 1, 1)
        end

        Tooltip.OnRelease = Tooltip_OnRelease
    end
    Tooltip:Clear()

    local guildName = GetGuildInfo("player")
    local titleLine = Tooltip:AddLine()
    Tooltip:SetCell(titleLine, 1, guildName, RayUI_InfobarTooltipFont, "CENTER", NUM_TOOLTIP_COLUMNS)
    Tooltip:SetCellTextColor(titleLine, 1, 0.4, 0.78, 1)

    local gmotd = GREEN_FONT_COLOR_CODE..GetGuildRosterMOTD()
    Tooltip:SetCell(Tooltip:AddLine(), 1, gmotd, RayUI_InfobarTooltipFont, "CENTER", NUM_TOOLTIP_COLUMNS)
    Tooltip:AddLine("")

    local headerLine = Tooltip:AddLine()
    Tooltip:SetCell(headerLine, 1, LEVEL_ABBR, RayUI_InfobarTooltipFont, nil, nil, nil, paddingLeft, paddingRight)
    Tooltip:SetCell(headerLine, 2, NAME, RayUI_InfobarTooltipFont, nil, nil, nil, paddingLeft, paddingRight)
    Tooltip:SetCell(headerLine, 3, ZONE, RayUI_InfobarTooltipFont, nil, nil, nil, paddingLeft, paddingRight)
    Tooltip:SetCell(headerLine, 4, RANK, RayUI_InfobarTooltipFont, nil, nil, nil, paddingLeft, paddingRight)
    Tooltip:SetCell(headerLine, 5, LABEL_NOTE, RayUI_InfobarTooltipFont, nil, nil, nil, paddingLeft, paddingRight)
    if CanViewOfficerNote() then
        Tooltip:SetCell(headerLine, 6, GUILD_OFFICERNOTES_LABEL, RayUI_InfobarTooltipFont, nil, nil, nil, paddingLeft, paddingRight)
    end
    Tooltip:SetLineTextColor(headerLine, 0.9, 0.8, 0.7)
    Tooltip:AddSeparator(1, 1, 1, 1, 0.8)

    if #GuildMemeberData <= 50 then
        for _, val in ipairs(GuildMemeberData) do
            local line = Tooltip:AddLine()
            local name, level, zone, rank, label, officerlabel, oriname, class, mobile = unpack(val)
            Tooltip:SetCell(line, 1, level, RayUI_InfobarTooltipFont, nil, nil, nil, paddingLeft, paddingRight)
            Tooltip:SetCell(line, 2, name, RayUI_InfobarTooltipFont, nil, nil, nil, paddingLeft, paddingRight)
            Tooltip:SetCell(line, 3, zone, RayUI_InfobarTooltipFont, nil, nil, nil, paddingLeft, paddingRight)
            Tooltip:SetCell(line, 4, rank, RayUI_InfobarTooltipFont, nil, nil, nil, paddingLeft, paddingRight)
            Tooltip:SetCell(line, 5, label, RayUI_InfobarTooltipFont, nil, nil, nil, paddingLeft, paddingRight)
            if CanViewOfficerNote() then
                Tooltip:SetCell(line, 6, officerlabel, RayUI_InfobarTooltipFont, nil, nil, nil, paddingLeft, paddingRight)
            end
            local toonName, realmName = ("-"):split(oriname)
            local playerEntry = {
                Realm = realmName,
                ToonName = toonName,
                FullToonName = oriname,
                IsMobile = mobile,
            }
            Tooltip:SetLineScript(line, "OnMouseUp", GuildMember_OnMouseUp, playerEntry)
        end
    else
        Tooltip:SetCell(Tooltip:AddLine(), 1, GREEN_FONT_COLOR_CODE..L["在线人数过多, 点击信息条查看"], RayUI_InfobarTooltipFont, "CENTER", NUM_TOOLTIP_COLUMNS)
        Tooltip:AddLine("")
    end

    Tooltip:Show()
    Tooltip:AddLine("")
    Tooltip:UpdateScrolling()
end

local function GenerateGuildData()
    local guildonline = 0
    wipe(GuildMemberIndexByName)
    -- Total Online Guildies
    local numGuildRanks = GuildControlGetNumRanks()
    for i = 1, GetNumGuildMembers() do
        local gPrelist
        local name, rank, rankIndex, lvl, _class, zone, note, offnote, online, status, class, _, _, mobile = GetGuildRosterInfo(i)

        local r, g, b = R.colors.class[class].r, R.colors.class[class].g, R.colors.class[class].b
        -- Player Name
        local cname
        if status == 0 then
            cname = string.format("|cff%02x%02x%02x%s|r", r * 255, g * 255, b * 255, name)
        else
            local curStatus = PlayerStatusValToStr[status] or ""
            cname = string.format("%s |cff%02x%02x%02x%s|r", curStatus, r * 255, g * 255, b * 255, name)
        end

        -- Class Color
        class = string.format("|cff%02x%02x%02x%s|r", r * 255, g * 255, b * 255, class)

        -- Mobile
        if mobile then
            cname = ChatFrame_GetMobileEmbeddedTexture(73/255, 177/255, 73/255)..cname
            zone = REMOTE_CHAT
        end

        local rankr, rankg, rankb = PercentColorGradient(rankIndex, numGuildRanks)
        rank = ("|cff%02x%02x%02x%s|r"):format(rankr * 255, rankg * 255, rankb * 255, rank)

        -- Add to list
        if online or mobile then
            GuildMemeberData[guildonline + 1] = { cname, ColorPlayerLevel(lvl), zone, rank, note, CanViewOfficerNote() and offnote or "", name, class, mobile }
            guildonline = guildonline + 1
        end

        for i = guildonline+1, #GuildMemeberData do
            GuildMemeberData[i] = nil
        end

        local toonName, realmName = ("-"):split(name)
        GuildMemberIndexByName[name] = i
		GuildMemberIndexByName[toonName] = i
    end
end

local eventHandlers = {
    ["CHAT_MSG_SYSTEM"] = function(self, arg1)
        if arg1 and arg1:find(ERR_FRIEND_ONLINE_SS) then
            resendRequest = true
        end
    end,
    ["PLAYER_ENTERING_WORLD"] = function (self, arg1)
        if not GuildFrame and IsInGuild() then
            LoadAddOn("Blizzard_GuildUI")
            GuildRoster()
        end
    end,
    ["GUILD_ROSTER_UPDATE"] = function (self)
        if(resendRequest) then
            resendRequest = false
            return GuildRoster()
        end
    end,
    ["PLAYER_GUILD_UPDATE"] = function (self, arg1)
        GuildRoster()
    end,
    ["GUILD_MOTD"] = function (self, arg1)
    end,
}

local function Guild_OnEvent(self, event, ...)
    if not FRIEND_ONLINE then FRIEND_ONLINE = select(2, strsplit("cff00ffff", ERR_FRIEND_ONLINE_SS, 2)) end

    eventHandlers[event](self, select(1, ...))
    if Tooltip and Tooltip:IsShown() then
        RenderTooltip(self)
    end
    self:SetText(GUILD..": "..select(3, GetNumGuildMembers()))
end

local function Guild_OnEnter(self)
    if not IsInGuild() then return end
    RequestUpdates()
    GenerateGuildData()
    RenderTooltip(self)
end

do -- Initialize
    local info = {}

    info.title = GUILD
    info.icon = "Interface\\Icons\\inv_shirt_guildtabard_01"
    info.clickFunc = Guild_OnClick
    info.events = { "PLAYER_ENTERING_WORLD", "CHAT_MSG_SYSTEM", "GUILD_ROSTER_UPDATE", "PLAYER_GUILD_UPDATE", "GUILD_MOTD" }
    info.onUpdate = RequestUpdates
    info.interval = 30
    info.eventFunc = Guild_OnEvent
    info.tooltipFunc = Guild_OnEnter

    IF:RegisterInfoBarType("Guild", info)
end
