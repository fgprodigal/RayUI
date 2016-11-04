local R, L, P, G = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, GlobalDB
local IF = R:GetModule("InfoBar")
local LibQTip = LibStub("LibQTip-1.0")

--Cache global variables
--Lua functions
local ipairs, select, type, unpack = ipairs, select, type, unpack
local wipe = table.wipe
local string = string
local tonumber = tonumber
local tinsert = table.insert

--WoW API / Variables
local IsAltKeyDown = IsAltKeyDown
local BNInviteFriend = BNInviteFriend
local InviteUnit = InviteUnit
local ChatFrame_SendSmartTell = ChatFrame_SendSmartTell
local ChatFrame_SendTell = ChatFrame_SendTell
local GetNumFriends = GetNumFriends
local GetFriendInfo = GetFriendInfo
local UnitFactionGroup = UnitFactionGroup
local BNGetNumFriends = BNGetNumFriends
local BNGetFriendInfo = BNGetFriendInfo
local BNet_GetClientTexture = BNet_GetClientTexture
local BNGetGameAccountInfo = BNGetGameAccountInfo
local GetRealmName = GetRealmName
local ToggleFriendsFrame = ToggleFriendsFrame
local InCombatLockdown = InCombatLockdown
local ShowFriends = ShowFriends
local GetRelativeDifficultyColor = GetRelativeDifficultyColor
local UnitLevel = UnitLevel

--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: DEFAULT_CHAT_FRAME, FRIENDS_BNET_NAME_COLOR, FRIENDS_TEXTURE_AFK, FRIENDS_TEXTURE_DND
-- GLOBALS: FRIENDS_TEXTURE_ONLINE, FACTION_HORDE, FACTION_ALLIANCE, NAME, LEVEL_ABBR
-- GLOBALS: ZONE, FACTION, FRIENDS, GAME, RayUI_InfobarTooltipFont, BATTLENET_FRIEND

local FriendsTabletData = {}
IF.FriendsTabletDataNames = {}
local FriendsOnline = 0
local displayString = string.join("", "%s: ", "", "%d|r")
local NUM_TOOLTIP_COLUMNS = 6
local Tooltip
local FACTION_ICON_ALLIANCE = " |TInterface\\COMMON\\icon-alliance:14:14:0:0:64:64:10:54:10:54|t "
local FACTION_ICON_HORDE = " |TInterface\\COMMON\\icon-horde:14:14:0:0:64:64:10:54:10:54|t "

local ClassLookup = {}
for k, v in pairs(LOCALIZED_CLASS_NAMES_MALE) do
    ClassLookup[v] = k
end
for k, v in pairs(LOCALIZED_CLASS_NAMES_FEMALE) do
    ClassLookup[v] = k
end

local function Tooltip_OnRelease(self)
    Tooltip:SetFrameStrata("TOOLTIP")
    Tooltip = nil
end

local function GetFactionIcon(faction)
    if faction == "Horde" then
        return FACTION_ICON_HORDE
    elseif faction == "Alliance" then
        return FACTION_ICON_ALLIANCE
    else
        return ""
    end
end

local function ColorPlayerLevel(level)
    if type(level) ~= "number" then
        return level
    end
    local color = GetRelativeDifficultyColor(UnitLevel("player"), level)
    return ("|cff%02x%02x%02x%d|r"):format(color.r * 255, color.g * 255, color.b * 255, level)
end

local function Friend_OnMouseUp(tooltipCell, playerEntry)
    if not playerEntry.name then return end
    if IsAltKeyDown() then
        if playerEntry.toonid then
            BNInviteFriend(playerEntry.toonid)
        elseif playerEntry.iname == "" then
            InviteUnit(playerEntry.name)
        else
            InviteUnit(playerEntry.iname)
        end
    else
        if playerEntry.toonid then
            ChatFrame_SendSmartTell(playerEntry.name, DEFAULT_CHAT_FRAME)
        else
            ChatFrame_SendTell(playerEntry.name, DEFAULT_CHAT_FRAME)
        end
    end
end

local function RenderTooltip(anchorFrame)
    local paddingLeft, paddingRight = 5, 5
    if not Tooltip then
        Tooltip = LibQTip:Acquire("RayUI_InfobarFriendTooltip", NUM_TOOLTIP_COLUMNS, "LEFT", "LEFT", "LEFT", "LEFT", "LEFT", "LEFT")
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

    local titleLine = Tooltip:AddLine()
    Tooltip:SetCell(titleLine, 1, FRIENDS, RayUI_InfobarTooltipFont, "CENTER", NUM_TOOLTIP_COLUMNS)
    Tooltip:AddLine("")

    local headerLine = Tooltip:AddLine()
    Tooltip:SetCell(headerLine, 1, GAME, RayUI_InfobarTooltipFont, nil, nil, nil, paddingLeft, paddingRight)
    Tooltip:SetCell(headerLine, 2, BATTLENET_FRIEND, RayUI_InfobarTooltipFont, nil, nil, nil, paddingLeft + 20, paddingRight)
    Tooltip:SetCell(headerLine, 3, LEVEL_ABBR, RayUI_InfobarTooltipFont, nil, nil, nil, paddingLeft, paddingRight)
    Tooltip:SetCell(headerLine, 4, NAME, RayUI_InfobarTooltipFont, nil, nil, nil, paddingLeft, paddingRight)
    Tooltip:SetCell(headerLine, 5, ZONE, RayUI_InfobarTooltipFont, nil, nil, nil, paddingLeft, paddingRight)
    Tooltip:SetCell(headerLine, 6, FACTION, RayUI_InfobarTooltipFont, nil, nil, nil, paddingLeft, paddingRight)
    Tooltip:SetLineTextColor(headerLine, 0.9, 0.8, 0.7)
    Tooltip:AddSeparator(1, 1, 1, 1, 0.8)

    for _, val in ipairs(FriendsTabletData) do
        local line = Tooltip:AddLine()
        local cname, level, zone, faction, clientIcon, presenceName, note, name, toonid, showPresenceName = unpack(val)
        Tooltip:SetCell(line, 1, clientIcon, RayUI_InfobarTooltipFont, nil, nil, nil, paddingLeft, paddingRight)
        Tooltip:SetCell(line, 2, showPresenceName, RayUI_InfobarTooltipFont, nil, nil, nil, paddingLeft, paddingRight)
        Tooltip:SetCell(line, 3, level, RayUI_InfobarTooltipFont, nil, nil, nil, paddingLeft, paddingRight)
        Tooltip:SetCell(line, 4, cname, RayUI_InfobarTooltipFont, nil, nil, nil, paddingLeft, paddingRight)
        Tooltip:SetCell(line, 5, zone, RayUI_InfobarTooltipFont, nil, nil, nil, paddingLeft, paddingRight)
        Tooltip:SetCell(line, 6, faction, RayUI_InfobarTooltipFont, nil, nil, nil, paddingLeft, paddingRight)
        local playerEntry = {
            name = presenceName,
            iname = name,
            toonid = toonid,
        }
        Tooltip:SetLineScript(line, "OnMouseUp", Friend_OnMouseUp, playerEntry)
    end

    Tooltip:Show()
    Tooltip:AddLine("")
    Tooltip:UpdateScrolling()
end

local function Friends_BuildTablet()
    local curFriendsOnline = 0
    wipe(FriendsTabletData)
    wipe(IF.FriendsTabletDataNames)

    -- Standard Friends
    for i = 1, GetNumFriends() do
        local name, lvl, class, area, online, status, note = GetFriendInfo(i)
        if online then
            if ( not FriendsTabletData or FriendsTabletData == nil ) then FriendsTabletData = {} end
            if ( not IF.FriendsTabletDataNames or IF.FriendsTabletDataNames == nil ) then IF.FriendsTabletDataNames = {} end

            curFriendsOnline = curFriendsOnline + 1

            local r, g, b = R.colors.class[ClassLookup[class]].r, R.colors.class[ClassLookup[class]].g, R.colors.class[ClassLookup[class]].b
            -- Name
            local cname
            if ( status == "" and name ) then
                cname = string.format("|cff%02x%02x%02x%s|r", r * 255, g * 255, b * 255, name)
            elseif ( name ) then
                cname = string.format("%s |cff%02x%02x%02x%s|r", status, r * 255, g * 255, b * 255, name)
            end

            -- Class
            class = string.format("|cff%02x%02x%02x%s|r", r * 255, g * 255, b * 255, class)

            -- Add Friend to list
            local faction = UnitFactionGroup("player")
            tinsert(FriendsTabletData, { cname, ColorPlayerLevel(tonumber(lvl)), area, GetFactionIcon(faction), " |T"..BNet_GetClientTexture("WoW")..":14:14:0:0:64:64:10:54:10:54|t ", name, note, "", "" })
            if name then
                IF.FriendsTabletDataNames[name] = true
            end
        end
    end

    -- Battle.net Friends
    for t = 1, BNGetNumFriends() do
        local presenceID, presenceName, BattleTag, isBattleTagPresence, toonName, toonID, client, isOnline, lastOnline, isAFK, isDND, broadcast, note = BNGetFriendInfo(t)
        local clientIcon = " |T"..BNet_GetClientTexture(client)..":14:14:0:0:64:64:10:54:10:54|t "
        local status

        -- WoW friends
        if isOnline then
            if ( not FriendsTabletData or FriendsTabletData == nil ) then FriendsTabletData = {} end
            if ( not IF.FriendsTabletDataNames or IF.FriendsTabletDataNames == nil ) then IF.FriendsTabletDataNames = {} end

            local _,name, _, realmName, _, faction, race, class, guild, area, lvl = BNGetGameAccountInfo(toonID)
            curFriendsOnline = curFriendsOnline + 1

            if (realmName == R.myrealm) then
                IF.FriendsTabletDataNames[toonName] = true
            end

            local r, g, b = FRIENDS_BNET_NAME_COLOR.r, FRIENDS_BNET_NAME_COLOR.g, FRIENDS_BNET_NAME_COLOR.b
            if class and ClassLookup[class] then
                r, g, b = R.colors.class[ClassLookup[class]].r, R.colors.class[ClassLookup[class]].g, R.colors.class[ClassLookup[class]].b
            end
            -- Name
            local cname
            if ( realmName == GetRealmName() ) then
                -- On My Realm
                cname = string.format(
                    "|cff%02x%02x%02x%s|r",
                    r * 255, g * 255, b * 255,
                    name
                )
            else
                -- On Another Realm
                if realmName and realmName ~= "" then
                    cname = string.format(
                        "|cff%02x%02x%02x%s|r|cffcccccc-%s",
                        r * 255, g * 255, b * 255,
                        name,
                        realmName
                    )
                elseif name and name ~= "" then
                    cname = string.format(
                        " |cffcccccc(|r|cff%02x%02x%02x%s|r|cffcccccc)|r",
                        r * 255, g * 255, b * 255,
                        name
                    )
                end
            end

            -- Class
            class = string.format("|cff%02x%02x%02x%s|r", r * 255, g * 255, b * 255, class)
            if isAFK then
                status = FRIENDS_TEXTURE_AFK
            elseif isDND then
                status = FRIENDS_TEXTURE_DND
            else
                status = FRIENDS_TEXTURE_ONLINE
            end
            local showPresenceName = " |T"..status..":14:14:|t "..string.format(
                "|cff%02x%02x%02x%s|r",
                FRIENDS_BNET_NAME_COLOR.r * 255, FRIENDS_BNET_NAME_COLOR.g * 255, FRIENDS_BNET_NAME_COLOR.b * 255,
                presenceName
            )

            -- Add Friend to list
            tinsert(FriendsTabletData, { cname, ColorPlayerLevel(tonumber(lvl)), area, GetFactionIcon(faction), clientIcon, presenceName, note, name, toonID, showPresenceName })
        end
    end

    -- OnEnter
    FriendsOnline = curFriendsOnline
end

local function Social_OnClick(self)
    ToggleFriendsFrame(1)
end

local function Social_OnEvent(self)
    local numBNetOnline = select(2, BNGetNumFriends())
    local numWoWOnline = select(2, GetNumFriends())

    if Tooltip and Tooltip:IsShown() then
        RenderTooltip(self)
    end
    self:SetText(FRIENDS..": "..numBNetOnline + numWoWOnline)
end

local function Social_OnEnter(self)
    local totalFriends, onlineFriends = GetNumFriends()
    local totalBN, numBNetOnline = BNGetNumFriends()
    if onlineFriends + numBNetOnline == 0 then return end

    ShowFriends()
    Friends_BuildTablet()
    RenderTooltip(self)
end

do -- Initialize
    local info = {}

    info.title = FRIENDS
    info.icon = "Interface\\Icons\\achievement_guildperk_everybodysfriend"
    info.clickFunc = Social_OnClick
    info.events = { "PLAYER_ENTERING_WORLD", "BN_FRIEND_ACCOUNT_ONLINE", "BN_FRIEND_ACCOUNT_OFFLINE", "BN_FRIEND_INFO_CHANGED", "BN_FRIEND_TOON_ONLINE",
        "BN_FRIEND_TOON_OFFLINE", "BN_TOON_NAME_UPDATED", "FRIENDLIST_UPDATE", "CHAT_MSG_SYSTEM" }
    info.eventFunc = Social_OnEvent
    info.initFunc = Social_OnEvent
    info.tooltipFunc = Social_OnEnter

    IF:RegisterInfoBarType("Friends", info)
end
