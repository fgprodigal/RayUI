local R, L, P, G = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, GlobalDB
local IF = R:GetModule("InfoBar")

--Cache global variables
--Lua functions
local select, pairs, table, unpack = select, pairs, table, unpack
local string, math = string, math
local floor, mod = math.floor, mod
local format = string.format
local tinsert = table.insert

--WoW API / Variables
local BreakUpLargeNumbers = BreakUpLargeNumbers
local GetMoney = GetMoney
local UnitName = UnitName
local UnitClass = UnitClass
local GetRealmName = GetRealmName
local UnitGUID = UnitGUID
local GetAutoCompleteRealms = GetAutoCompleteRealms
local GetCurrencyListSize = GetCurrencyListSize
local GetCurrencyListInfo = GetCurrencyListInfo
local C_Timer = C_Timer
local GetMouseFocus = GetMouseFocus
local GameTooltip_Hide = GameTooltip_Hide

--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: GOLD_AMOUNT_TEXTURE, COPPER_AMOUNT_TEXTURE, SILVER_AMOUNT_TEXTURE, SECOND_NUMBER_CAP
-- GLOBALS: GOLD_AMOUNT_TEXTURE_STRING, GameTooltip, TOTAL, RayUF, CLASS_ICON_TCOORDS
-- GLOBALS: RETRIEVING_TRADESKILL_INFO, CURRENCY, UNUSED

local session, init

local function GetInfoBarDataBase(serverName)
    R.global["InfoBar"] = R.global["InfoBar"] or {}
    R.global["InfoBar"]["CharInfo"] = R.global["InfoBar"]["CharInfo"] or {}
    R.global["InfoBar"]["CharInfo"][serverName] = R.global["InfoBar"]["CharInfo"][serverName] or {}

    return R.global["InfoBar"]["CharInfo"][serverName]
end

local function GetMoneyString(money)
    local gold = floor(money/10000)
    local silver = floor((money-gold*10000)/100)
    local copper = mod(money,100)
    local goldText, silverText, copperText = format(GOLD_AMOUNT_TEXTURE, gold)
    local string

    if copper > 0 then
        copperText = " "..format(COPPER_AMOUNT_TEXTURE, copper)
    else
        copperText = ""
    end

    if silver > 0 then
        silverText = " "..format(SILVER_AMOUNT_TEXTURE, silver)
    else
        silverText = ""
    end

    if gold >= 10000 then
        string = format(GOLD_AMOUNT_TEXTURE_STRING, R:ShortValue(gold))
    elseif gold >= 100 then
        string = goldText..silverText
    elseif gold > 0 then
        string = goldText..silverText..copperText
    elseif silver > 0 then
        string = silverText..copperText
    else
        string = copperText
    end

    if money == 0 then
        string = format(COPPER_AMOUNT_TEXTURE, 0)
    end

    return string
end

local function SortMoney(a,b)
    if a["Gold"] and b["Gold"] then
        return a["Gold"] > b["Gold"]
    else
        return false
    end
end

local function Money_OnEvent(self)
    self:SetText(GetMoneyString(GetMoney()))
end

local function Money_ForceUpdate(self, update)
    if not init or update then
        local unitID = "player"
        local name, class = UnitName(unitID), select(2, UnitClass(unitID))
        local serverName, entry = GetRealmName(), nil
        local guid, gold = UnitGUID(unitID), GetMoney()
        local dataBase = GetInfoBarDataBase(serverName)

        -- first login
        if not update then
            session, init = gold, true
        end

        -- set entry
        for index, info in pairs(dataBase) do
            if info and info["GUID"] == guid then
                entry = index
                break
            end
        end

        -- save money value
        if entry then
            if dataBase[entry]["Gold"] == gold then
                return
            else
                dataBase[entry]["Gold"] = gold
            end
        else
            local info = {}
            info.Name = name
            info.Server = serverName
            info.Class = class
            info.Gold = gold
            info.GUID = guid
            tinsert(dataBase,info)
        end

    end
    Money_OnEvent(self)
end

local function Money_OnEnter(self)
    GameTooltip:SetOwner(self, "ANCHOR_TOP")

    Money_ForceUpdate(self, true)

    -- All Servers
    if self.isShift then
        local dataBase = R.global["InfoBar"]["CharInfo"]
        local total = 0

        GameTooltip:AddLine(L["全部服务器"],1,1,1)
        GameTooltip:SetPrevLineJustify("CENTER")
        GameTooltip:AddDivider()

        for serverName, serverInfo in pairs(dataBase) do
            local totalPerServer = 0

            for _, charInfo in pairs(serverInfo) do
                totalPerServer = totalPerServer + charInfo["Gold"]
            end

            if totalPerServer > 0 then
                total = total + totalPerServer

                GameTooltip:AddDoubleLine(serverName, GetMoneyString(totalPerServer),1,1,1,1,1,1)
            end
        end

        GameTooltip:AddDivider()
        GameTooltip:AddDoubleLine(TOTAL..":", GetMoneyString(total),1,1,1,1,1,1)
    end

    -- Actual Server + Connected
    if not self.isShift then
        local serverName, realmlist = GetRealmName(), GetAutoCompleteRealms()
        local difference = GetMoney() - session
        local total, numInfo = 0, 0
        local waitForInfo

        table.sort(GetInfoBarDataBase(serverName), SortMoney)

        -- Display all connected realms
        if realmlist then
            local header

            for _, realm in pairs(realmlist) do
                local dataBase = GetInfoBarDataBase(realm)

                if dataBase then
                    if not header then
                        GameTooltip:AddLine(serverName,1,1,1)
                        GameTooltip:SetPrevLineJustify("CENTER")
                        GameTooltip:AddDivider()
                        header = true
                    end

                    for _, info in pairs(dataBase) do
                        local name, class, gold = info.Name, info.Class, info.Gold

                        if gold > 0 then
                            if name then
                                local color = RayUF.colors.class[class]
                                local r,g,b = unpack(color)
                                local path = "Interface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes"
                                local left, right, top, bottom = unpack(CLASS_ICON_TCOORDS[class])
                                local classIcon

                                if left and right and top and bottom then
                                    local inset = 5

                                    left, right, top, bottom = (left*256+inset),(right*256-inset),(top*256+inset),(bottom*256-inset)
                                    classIcon = "|T"..path..":14:14:0:0:256:256:"..left..":"..right..":"..top..":"..bottom.."|t"
                                end

                                if r and g and b then
                                    name = R:RGBToHex(r,g,b)..name.."|r"
                                end

                                if realm == serverName then
                                    -- display update fix
                                    if name == UnitName("player") then
                                        gold = GetMoney()
                                    end

                                    GameTooltip:AddDoubleLine(classIcon.." "..name, GetMoneyString(gold),1,1,1,1,1,1)
                                else
                                    GameTooltip:AddDoubleLine(classIcon.." "..name.." - "..realm, GetMoneyString(gold),1,1,1,1,1,1)
                                end
                            else
                                GameTooltip:AddDoubleLine(RETRIEVING_TRADESKILL_INFO.."...", GetMoneyString(gold),1,1,1,1,1,1)

                                waitForInfo = true
                            end

                            numInfo = numInfo + 1
                            total = total + gold
                        end
                    end
                end
            end
        end

        -- Display only the actual realm
        if not realmlist then
            local dataBase = GetInfoBarDataBase(serverName)

            GameTooltip:AddLine(serverName,1,1,1)
            GameTooltip:SetPrevLineJustify("CENTER")
            GameTooltip:AddDivider()

            for _, info in pairs(dataBase) do
                local name, class, gold = info.Name, info.Class, info.Gold

                if gold > 0 then
                    if name then
                        local color = RayUF.colors.class[class]
                        local r,g,b = unpack(color)
                        local path = "Interface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes"
                        local left, right, top, bottom = unpack(CLASS_ICON_TCOORDS[class])
                        local classIcon

                        if left and right and top and bottom then
                            local inset = 5

                            left, right, top, bottom = (left*256+inset),(right*256-inset),(top*256+inset),(bottom*256-inset)
                            classIcon = "|T"..path..":14:14:0:0:256:256:"..left..":"..right..":"..top..":"..bottom.."|t"
                        end

                        if r and g and b then
                            name = R:RGBToHex(r,g,b)..name.."|r"
                        end

                        -- display update fix
                        if name == UnitName("player") then
                            gold = GetMoney()
                        end

                        GameTooltip:AddDoubleLine(classIcon.." "..name, GetMoneyString(gold),1,1,1,1,1,1)
                    else
                        GameTooltip:AddDoubleLine(RETRIEVING_TRADESKILL_INFO.."...", GetMoneyString(gold),1,1,1,1,1,1)

                        waitForInfo = true
                    end

                    numInfo = numInfo + 1
                    total = total + gold
                end
            end
        end

        -- Total money
        if numInfo > 1 and total > 0 then
            GameTooltip:AddDivider()
            GameTooltip:AddDoubleLine(TOTAL..":", GetMoneyString(total),1,1,1,1,1,1)
        end

        -- Money per session
        if difference ~= 0 then
            local pre,r,g,b

            if difference < 0 then
                difference = difference - difference * 2

                pre,r,g,b = "- ", 1,0,0
            elseif difference > 0 then
                pre,r,g,b = "+ ", 0,1,0
            end

            GameTooltip:AddDivider()
            GameTooltip:AddDoubleLine(L["本次登录:"],pre..GetMoneyString(difference),1,1,1,r,g,b)
        end

        for i=1, GetCurrencyListSize() do
            if i == 1 then
                GameTooltip:AddLine(" ")
                GameTooltip:AddLine(CURRENCY,1,1,1)
                GameTooltip:SetPrevLineJustify("CENTER")
                GameTooltip:AddDivider()
            end
            local name, isHeader, isExpanded, isUnused, isWatched, count, icon, totalMax = GetCurrencyListInfo(i)
            if isHeader and name == UNUSED then break end
            if not isHeader and icon and count>0 then
                if totalMax and totalMax > 100 then
                    totalMax = math.floor(totalMax/100)
                else
                    totalMax = totalMax or 0
                end
                if totalMax > 0 and count == totalMax then
                    GameTooltip:AddDoubleLine(string.format("\124T%s:%d:%d:0:0:64:64:5:59:5:59\124t %s", icon, 24, 24, name), count, nil, nil, nil, 1, 0, 0)
                else
                    GameTooltip:AddDoubleLine(string.format("\124T%s:%d:%d:0:0:64:64:5:59:5:59\124t %s", icon, 24, 24, name), count, nil, nil, nil, 1, 1, 1)
                end
            end
        end

        if waitForInfo then
            C_Timer.After(0.1, function()
                    if GetMouseFocus() == self then
                        Money_OnEnter(self)
                    end
                end)
        end
    end

    GameTooltip:AddDivider()
    GameTooltip:AddLine(L["切换"],1,1,1)
    GameTooltip:Show()
end

local function Money_OnClick(self)
    if self.isShift then
        self.isShift = false
    else
        self.isShift = true
    end

    GameTooltip_Hide()
    Money_OnEnter(self)
end

do -- Initialize
    local info = {}

    info.title = MONEY
    info.icon = "Interface\\Icons\\inv_misc_coin_01"
    info.clickFunc = Money_OnClick
    info.initFunc = Money_ForceUpdate
    info.events = { "PLAYER_ENTERING_WORLD", "PLAYER_MONEY", "SEND_MAIL_MONEY_CHANGED", "SEND_MAIL_COD_CHANGED", "PLAYER_TRADE_MONEY", "TRADE_MONEY_CHANGED" }
    info.eventFunc = Money_OnEvent
    info.tooltipFunc = Money_OnEnter

    IF:RegisterInfoBarType("Money", info)
end
