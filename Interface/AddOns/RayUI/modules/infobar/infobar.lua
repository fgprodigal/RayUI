local R, L, P, G = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, GlobalDB
local IF = R:NewModule("InfoBar", "AceEvent-3.0", "AceHook-3.0", "AceConsole-3.0", "AceTimer-3.0")
local LDB = LibStub:GetLibrary("LibDataBroker-1.1")

--Cache global variables
--Lua functions
local _G = _G
local pairs, type, unpack = pairs, type, unpack
local strlen = string.len

--WoW API / Variables
local CreateFrame = CreateFrame
local GameTooltip_Hide = GameTooltip_Hide
local UnitGUID = UnitGUID
local CreateFont = CreateFont
local IsShiftKeyDown = IsShiftKeyDown
local C_Timer = C_Timer

--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: RayUI_InfoBarButton_OnClick, RayUI_InfoBarButton_OnEnter, RayUI_InfoBarButton_OnLeave
-- GLOBALS: RayUI_InfoBarButton_OnUpdate, RayUI_InfoBarButton_OnEvent, RayUI_InfoBarButton_OnReset
-- GLOBALS: GameTooltip, RayUI_InfoBarMenu, RayUI_InfoBarMenu_OnInit, RayUI_InfoBarMenuButton_OnClick
-- GLOBALS: RayUI_RegisterLDB, RayUF, GameTooltip_SetDefaultAnchor

local maxMenuButtons, infobarTypes, usedInfoBar = 10, {}, {}
local brokerTooltip

local function GetInfoBarList()
    if not R.db["InfoBar"] then
        R.db["InfoBar"] = {}
    end
    if not R.db["InfoBar"]["List"] then
        R.db["InfoBar"]["List"] = {
            "Framerate",
            "Latency",
            "Talent",
            "Durability",
            "Friends",
            "Guild",
            "Memory",
            "Money",
        }
    end
    return R.db["InfoBar"]["List"]
end

local function OpenMenu(infobar)
    local padding, numShown = 20, 0
    local menu = RayUI_InfoBarMenu
    local oldRef = menu.ref

    if oldRef and oldRef ~= infobar and not oldRef.infobarType then
        menu.ref:SetAlpha(0)
    end

    for i = 1, maxMenuButtons do
        local button = menu["Button"..i]
        button:Hide()
    end

    for infobarType, info in pairs(infobarTypes) do
        local isUsed = usedInfoBar[infobarType]

        if not isUsed then
            numShown = numShown + 1

            -- Add InfoBar Button to the menu
            local button = menu["Button"..numShown]

            button.ref = infobar
            button.infobarType = infobarType
            button.info = info
            button:SetNormalTexture(info.icon or "Interface\\Icons\\inv_misc_questionmark")
            button:SetText(info.title)
            button:Show()
        end
    end

    if numShown == 0 then
        padding = padding - 10
    end

    if infobar.infobarType then
        padding = padding + 35
        menu.Clear:Show()
    else
        menu.Clear:Hide()
    end

    menu.ref = infobar
    menu:SetHeight(25 * numShown + padding)
    menu:ClearAllPoints()
    menu:SetPoint("BOTTOM",infobar,"TOP",0,5)
    menu:Show()

    GameTooltip_Hide()
end

local function SetButton(button,index,infobarType,info,isInit)
    button:SetAlpha(1)
    button.isBroker = info.isBroker
    button.title = info.title
    button.infobarType = infobarType
    button.clickFunc = info.clickFunc
    button.onUpdate = info.onUpdate
    button.tooltipFunc = info.tooltipFunc
    button.onLeaveFunc = info.onLeaveFunc
    button.eventFunc = info.eventFunc
    button.registerLDBEvent = info.registerLDBEvent
    button.unregisterLDBEvent = info.unregisterLDBEvent
    button:SetText(info.title)

    usedInfoBar[infobarType] = index

    if type(info.events) == "table" then
        for _, event in pairs(info.events) do
            if event == "UNIT_AURA" or event == "UNIT_RESISTANCES" or event == "UNIT_STATS" or event == "UNIT_ATTACK_POWER"
            or event == "UNIT_RANGED_ATTACK_POWER" or event == "UNIT_TARGET" or event == "UNIT_SPELL_HASTE" then
                button:RegisterUnitEvent(event, "player")
            elseif event == 'COMBAT_LOG_EVENT_UNFILTERED' then
                button:RegisterUnitEvent(event, UnitGUID("player"), UnitGUID("pet"))
            else
                button:RegisterEvent(event)
            end
        end
    end

    if button.registerLDBEvent then
        button:registerLDBEvent()
    end
    -- Save Setting
    if not isInit then
        R.db["InfoBar"]["List"][index] = infobarType
    end

    if info.initFunc then
        info.initFunc(button)
    end

    if info.icon then
        button:SetNormalTexture(info.icon)
        button.Text:SetPoint("TOPLEFT",28,-8)
        button.Highlight:Point("TOPLEFT",28,-8)
        button.Icon:Show()
    else
        button.Text:SetPoint("TOPLEFT",8,-8)
        button.Highlight:Point("TOPLEFT",8,-8)
        button.Icon:Hide()
    end

    button.Highlight:Point("BOTTOMRIGHT",-8,8)
end

function RayUI_InfoBarButton_OnClick(self, button)
    if button == "RightButton" and not IsShiftKeyDown() then
        RayUI_InfoBarButton_OnLeave(self)
        OpenMenu(self)
        return
    end

    if button == "LeftButton" and self.clickFunc then
        self.clickFunc(self, button)
        return
    end

    if button == "RightButton" and IsShiftKeyDown() and self.clickFunc then
        self.clickFunc(self, button)
        return
    end
end

function RayUI_InfoBarButton_OnEnter(self)
    local menu = RayUI_InfoBarMenu

    if self.tooltipFunc and not menu:IsShown() then
        self.tooltipFunc(self)
    elseif not self.infobarType then
        GameTooltip:SetOwner(self, "ANCHOR_TOP")
        GameTooltip:AddLine(L["点击右键选择信息条"],1,1,1)
        GameTooltip:Show()
    end

    if self.infobarType then
        self:SetAlpha(1)
    else
        self:SetAlpha(0.5)
    end
end

function RayUI_InfoBarButton_OnLeave(self)
    local menu = RayUI_InfoBarMenu

    if self.infobarType then
        self:SetAlpha(1)
    elseif menu:IsShown() and menu.ref == self then
        self:SetAlpha(0.5)
    else
        self:SetAlpha(0)
    end

    if self.onLeaveFunc then
        C_Timer.After(0.25, function() self.onLeaveFunc(self) end)
    end

    if brokerTooltip then
        brokerTooltip:Hide()
    end
    GameTooltip_Hide()
end

function RayUI_InfoBarButton_OnUpdate(self, elapsed)
    if self.onUpdate then
        self.update = self.update + elapsed

        while self.update > self.interval do
            self.onUpdate(self)
            self.update = self.update - self.interval
        end
    end
end

function RayUI_InfoBarButton_OnEvent(self, event, ...)
    if self.eventFunc then
        self.eventFunc(self, event, ...)
    end
end

function RayUI_InfoBarButton_OnReset(self,noSave)
    local dataBase = GetInfoBarList()

    if self.infobarType then
        usedInfoBar[self.infobarType] = nil
    end
    if not noSave then
        dataBase[self:GetID()] = nil
    end

    self.infobarType = nil
    self.clickFunc = nil
    self.onUpdate = nil
    self.tooltipFunc = nil
    self.Text:SetPoint("TOPLEFT",8,-8)
    self.Highlight:Point("TOPLEFT",8,-8)
    self.Highlight:Point("BOTTOMRIGHT",-8,8)
    self:SetText("")
    self:SetNormalTexture("")
    self.Icon:Hide()
    self:SetAlpha(0)
    self:UnregisterAllEvents()
    if self.unregisterLDBEvent then self:unregisterLDBEvent() end

    RayUI_InfoBarMenu:Hide()
end

function RayUI_InfoBarMenu_OnInit(self)
    local dataBase = GetInfoBarList()

    RayUI_RegisterLDB()

    for index, infobarType in pairs(dataBase) do
        local button = _G["RayUI_InfoBar"..index]
        local info = infobarTypes[infobarType]

        if info then
            SetButton(button,index,infobarType,info,true)
        end
    end

    self:UnregisterEvent("PLAYER_LOGIN")
end

function RayUI_InfoBarMenuButton_OnClick(self)
    local button, infobarType, info = self.ref, self.infobarType, self.info
    local index = button:GetID()

    -- Free Prev InfoBar
    if button.infobarType then
        usedInfoBar[button.infobarType] = nil
    end

    if button.unregisterLDBEvent then
        button:unregisterLDBEvent()
    end

    SetButton(button,index,infobarType,info)

    RayUI_InfoBarMenu:Hide()
end

function RayUI_RegisterLDB()
    for name, obj in LDB:DataObjectIterator() do
        local info = {}

        local longValue, brokerTitle, brokerValue
        local OnEnter = nil
        local OnLeave = nil
        local curFrame = nil
        if obj.OnTooltipShow then
            function OnEnter(self)
                if brokerValue then
                    brokerTooltip:SetOwner(self, "ANCHOR_TOP", 0, 0)
                    brokerTooltip:AddLine(brokerTitle, 1, 1, 1)
                    brokerTooltip:SetPrevLineJustify("CENTER")
                    brokerTooltip:AddDivider()
                    brokerTooltip:AddLine(brokerValue, 1, 1, 1)
                    brokerTooltip:Show()
                end
                GameTooltip:SetOwner(brokerTooltip, "ANCHOR_TOP", 0, 0)
                obj.OnTooltipShow(GameTooltip)
                GameTooltip:Show()
            end
        end

        if obj.OnEnter then
            function OnEnter(self)
                if brokerValue then
                    brokerTooltip:SetOwner(self, "ANCHOR_TOP", 0, 0)
                    brokerTooltip:AddLine(brokerTitle, 1, 1, 1)
                    brokerTooltip:SetPrevLineJustify("CENTER")
                    brokerTooltip:AddDivider()
                    brokerTooltip:AddLine(brokerValue, 1, 1, 1)
                    brokerTooltip:Show()
                end
                obj.OnEnter(brokerTooltip)
                GameTooltip_Hide()
            end
        end

        if obj.OnLeave then
            function OnLeave(self)
                obj.OnLeave(self)
            end
        end

        local function OnClick(self, button)
            obj.OnClick(self, button)
        end

        local function textUpdate(event, name, key, value, dataobj)
            if value == nil or (strlen(value) >= 3) or value == "n/a" or name == value then
                if strlen(value) > 30 then
                    longValue = true
                    brokerTitle = name
                    brokerValue = value
                    curFrame:SetText(name)
                else
                    longValue = false
                    curFrame:SetText(value ~= "n/a" and value or name)
                end
            else
                curFrame:SetFormattedText("%s: |cffFFFFFF%s|r", name, value)
            end
        end

        local function registerEvent(self)
            curFrame = self
            LDB.RegisterCallback(self,"LibDataBroker_AttributeChanged_"..name.."_text", textUpdate)
            LDB.RegisterCallback(self,"LibDataBroker_AttributeChanged_"..name.."_value", textUpdate)
            LDB.callbacks:Fire("LibDataBroker_AttributeChanged_"..name.."_text", name, nil, obj.text, obj)
        end

        local function unregisterEvent(self)
            curFrame = self
            LDB.UnregisterCallback(self,"LibDataBroker_AttributeChanged_"..name.."_text")
            LDB.UnregisterCallback(self,"LibDataBroker_AttributeChanged_"..name.."_value")
        end

        info.isBroker = true
        info.title = name
        info.icon = obj.icon
        info.clickFunc = OnClick
        info.tooltipFunc = OnEnter
        info.onLeaveFunc = OnLeave
        info.registerLDBEvent = registerEvent
        info.unregisterLDBEvent = unregisterEvent

        IF:RegisterInfoBarType(name, info)
    end
end

function IF:RegisterInfoBarType(infobarType, infobarInfo)
    infobarTypes[infobarType] = infobarInfo
end

function IF:Initialize()
    brokerTooltip = CreateFrame("GameTooltip", "RayUI_InfoBar_BrokerTooltip", R.UIParent, "GameTooltipTemplate")
    local r, g, b = unpack(RayUF.colors.class[R.myclass])
    local font = CreateFont("RayUI_InfoBarFont")
    font:SetFont(R["media"].font, R["media"].fontsize, R["media"].fontflag)
    font:SetTextColor(1, 1, 1)
    font:SetShadowColor(0, 0, 0)
    font:SetShadowOffset(R.mult, -R.mult)

    for i = 1, 8 do
        local infoBar = CreateFrame("Button", "RayUI_InfoBar"..i, R.UIParent, "RayUI_InfoBarButtonTemplate")
        infoBar:SetNormalFontObject(font)
        infoBar:SetSize(140, 35)
        infoBar:SetID(i)
        if i == 1 then
            infoBar:Point("BOTTOMLEFT", R.UIParent, "BOTTOM", -140 * 4 - 6 * 3 - 3, -5)
        else
            infoBar:Point("LEFT", _G["RayUI_InfoBar"..i-1], "RIGHT", 6, 0)
        end
        infoBar.Highlight:SetTexture("Interface\\AddOns\\RayUI\\media\\threat")
        infoBar.Highlight:SetBlendMode("ADD")
        infoBar.Highlight:SetVertexColor(r, g, b, .4)
        infoBar.Background = CreateFrame("Frame", nil, infoBar)
        infoBar.Background:Point("BOTTOMLEFT", 8, 8)
        infoBar.Background:Point("TOPRIGHT", -8, -18)
        infoBar.Background:CreateShadow("Background")
    end

    for i = 1, maxMenuButtons do
        local button = RayUI_InfoBarMenu["Button"..i]
        button:SetNormalFontObject(font)
        button:SetID(i)
        button.Highlight:SetTexture("Interface\\AddOns\\RayUI\\media\\threat")
        button.Highlight:SetBlendMode("ADD")
        button.Highlight:SetVertexColor(r, g, b, .4)
        button.Background = CreateFrame("Frame", nil, button)
        button.Background:SetInside(button, 8, 8)
        button.Background:CreateShadow("Background")

        if i > 1 then button:Point("TOP", RayUI_InfoBarMenu["Button"..i-1], "BOTTOM", 0, 10) end
    end

    local clear = RayUI_InfoBarMenu.Clear
    clear:SetNormalFontObject(font)
    clear:SetText(L["清除"])
    clear.Highlight:SetTexture("Interface\\AddOns\\RayUI\\media\\threat")
    clear.Highlight:SetBlendMode("ADD")
    clear.Highlight:SetVertexColor(r, g, b, .4)
    clear.Background = CreateFrame("Frame", nil, clear)
    clear.Background:SetInside(clear, 8, 8)
    clear.Background:CreateShadow("Background")

    local S = R:GetModule("Skins")
    S:SetBD(RayUI_InfoBarMenu, -10, 0, 10, 0)
    S:ReskinClose(RayUI_InfoBarMenu.Close, "TOPRIGHT", RayUI_InfoBarMenu, "TOPRIGHT", 8, -2)
end

R:RegisterModule(IF:GetName())
