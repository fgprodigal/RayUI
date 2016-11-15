local R, L, P, G = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, GlobalDB
local LSM = LibStub("LibSharedMedia-3.0")

--Cache global variables
--Lua functions
local string = string
local math = math
local tinsert = tinsert
local type = type
local next = next
local pairs = pairs
local collectgarbage = collectgarbage
local pcall = pcall
local error = error
local wipe = wipe
local select = select
local tostring = tostring
local tremove = tremove
local table = table
local floor = floor
local unpack = unpack
local tonumber = tonumber
local geterrorhandler = geterrorhandler
local upper = string.upper
local twipe = table.wipe
local debugprofilestart, debugprofilestop = debugprofilestart, debugprofilestop

--WoW API / Variables
local ReloadUI = ReloadUI
local GetAddOnInfo = GetAddOnInfo
local CreateFrame = CreateFrame
local GetNumAddOns = GetNumAddOns
local DisableAddOn = DisableAddOn
local RequestTimePlayed = RequestTimePlayed
local SetCVar = SetCVar
local InCombatLockdown = InCombatLockdown
local HideUIPanel = HideUIPanel
local GetSpecialization = GetSpecialization
local GetCombatRatingBonus = GetCombatRatingBonus
local GetDodgeChance = GetDodgeChance
local GetParryChance = GetParryChance
local UnitLevel = UnitLevel
local UnitStat = UnitStat
local UnitAttackPower = UnitAttackPower
local GetScreenWidth = GetScreenWidth
local GetScreenHeight = GetScreenHeight
local GetItemInfo = GetItemInfo
local GetFunctionCPUUsage = GetFunctionCPUUsage
local GetCVar = GetCVar
local GetCVarBool = GetCVarBool
local IsAddOnLoaded = IsAddOnLoaded
local DEFAULT_CHAT_FRAME = DEFAULT_CHAT_FRAME
local GameMenuFrame = GameMenuFrame
local GameMenuButtonContinue = GameMenuButtonContinue
local UnitGroupRolesAssigned = UnitGroupRolesAssigned
local GetSpecializationRole = GetSpecializationRole
local ResetCPUUsage = ResetCPUUsage
local GetAddOnCPUUsage = GetAddOnCPUUsage
local UpdateAddOnCPUUsage = UpdateAddOnCPUUsage
local C_Timer = C_Timer

--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: UIParent, LibStub, MAX_PLAYER_LEVEL, ScriptErrorsFrame_OnError, BaudErrorFrameHandler, UISpecialFrames
-- GLOBALS: Advanced_UIScaleSlider, Advanced_UseUIScale, RayUIConfigTutorial, RayUIWarningFrameScrollScrollBar, WorldMapFrame
-- GLOBALS: SLASH_RELOAD1, COMBAT_RATING_RESILIENCE_PLAYER_DAMAGE_TAKEN, FIRST_NUMBER_CAP, SECOND_NUMBER_CAP, RayUISplashScreen

SlashCmdList["RELOAD"] = function() ReloadUI() end
SLASH_RELOAD1 = "/rl"

R["RegisteredModules"] = {}
R.FrameLocks = {}
R.resolution = ({GetScreenResolutions()})[GetCurrentResolution()] or GetCVar("gxWindowedResolution")
R.screenheight = tonumber(string.match(R.resolution, "%d+x(%d+)"))
R.screenwidth = tonumber(string.match(R.resolution, "(%d+)x+%d"))
R.mult = 1

R.HiddenFrame = CreateFrame("Frame")
R.HiddenFrame:Hide()

R.UIParent = CreateFrame("Frame", "RayUIParent", UIParent)
R.UIParent:SetFrameLevel(UIParent:GetFrameLevel())
R.UIParent:SetAllPoints()
R.UIParent.origHeight = R.UIParent:GetHeight()

local AddonNotSupported = {}
local BlackList = {"bigfoot", "duowan", "163ui", "neavo", "sora"}
local demoFrame

function R.dummy()
    return
end

function R:UIScale()
    if not self.global.general.uiscale then
        self.global.general.uiscale = math.max(0.64, math.min(1.15, 768/self.screenheight));
    end
    self.lowversion = false

    if self.screenwidth < 1600 then
        self.lowversion = true
    elseif self.screenwidth >= 3840 or (UIParent:GetWidth() + 1 > self.screenwidth) then
        local width = self.screenwidth
        local height = self.screenheight

        -- because some user enable bezel compensation, we need to find the real width of a single monitor.
        -- I don"t know how it really work, but i"m assuming they add pixel to width to compensate the bezel. :P

        -- HQ resolution
        if width >= 9840 then width = 3280 end -- WQSXGA
        if width >= 7680 and width < 9840 then width = 2560 end -- WQXGA
        if width >= 5760 and width < 7680 then width = 1920 end -- WUXGA & HDTV
        if width >= 5040 and width < 5760 then width = 1680 end -- WSXGA+

        -- adding height condition here to be sure it work with bezel compensation because WSXGA+ and UXGA/HD+ got approx same width
        if width >= 4800 and width < 5760 and height == 900 then width = 1600 end -- UXGA & HD+

        -- low resolution screen
        if width >= 4320 and width < 4800 then width = 1440 end -- WSXGA
        if width >= 4080 and width < 4320 then width = 1360 end -- WXGA
        if width >= 3840 and width < 4080 then width = 1224 end -- SXGA & SXGA (UVGA) & WXGA & HDTV

        if width < 1600 then
            self.lowversion = true
        end

        -- register a constant, we will need it later for launch.lua
        self.eyefinity = width
    end

    if self.lowversion == true then
        self.ResScale = 0.9
    else
        self.ResScale = 1
    end

    self.UIParent:ClearAllPoints()
    self.UIParent:SetAllPoints()
    self.UIParent.origHeight = self.UIParent:GetHeight()
    self.mult = 768/string.match(self.resolution, "%d+x(%d+)")/self.global.general.uiscale

    SetCVar("useUiScale", 1)
    SetCVar("uiScale", self.global.general.uiscale)
    WorldMapFrame.hasTaint = true
end

function R:Scale(x)
    return (self.mult*math.floor(x/self.mult+.5))
end

function R:StringTitle(str)
    return str:gsub("(.)", upper, 1)
end

R.LockedCVars = {}
function R:PLAYER_REGEN_ENABLED(_)
    if(self.CVarUpdate) then
        for cvarName, value in pairs(self.LockedCVars) do
            if(GetCVar(cvarName) ~= value) then
                SetCVar(cvarName, value)
            end
        end
        self.CVarUpdate = nil
    end
end

local function CVAR_UPDATE(cvarName, value)
    if(R.LockedCVars[cvarName] and R.LockedCVars[cvarName] ~= value) then
        if(InCombatLockdown()) then
            R.CVarUpdate = true
            return
        end

        SetCVar(cvarName, R.LockedCVars[cvarName])
    end
end

hooksecurefunc("SetCVar", CVAR_UPDATE)
function R:LockCVar(cvarName, value)
    if(GetCVar(cvarName) ~= value) then
        SetCVar(cvarName, value)
    end
    self.LockedCVars[cvarName] = value
end

function R:RegisterModule(name)
    if self.initialized then
        self:GetModule(name):Initialize()
        tinsert(self["RegisteredModules"], name)
    else
        tinsert(self["RegisteredModules"], name)
    end
end

function R:TableIsEmpty(t)
    if type(t) ~= "table" then
        return true
    else
        return next(t) == nil
    end
end

local function CreateWarningFrame()
    for index in pairs(AddonNotSupported) do
        R:Print(GetAddOnInfo(index))
    end
    local S = R:GetModule("Skins")
    local frame = CreateFrame("Frame", "RayUIWarningFrame", R.UIParent)
    S:SetBD(frame)
    frame:Size(400, 400)
    frame:SetPoint("CENTER", R.UIParent, "CENTER", 0, 0)
    frame:EnableMouse(true)
    frame:SetFrameStrata("DIALOG")

    local titile = frame:CreateFontString(nil, "OVERLAY")
    titile:Point("TOPLEFT", 0, -10)
    titile:Point("TOPRIGHT", 0, -10)
    titile:SetFont(R["media"].font, R["media"].fontsize + 2, R["media"].fontflag)
    titile:SetText("由於一些很複雜的原因, 關閉以下外掛程式後才能正常使用|cff7aa6d6Ray|r|cffff0000U|r|cff7aa6d6I|r:")

    local scrollArea = CreateFrame("ScrollFrame", "RayUIWarningFrameScroll", frame, "UIPanelScrollFrameTemplate")
    scrollArea:Point("TOPLEFT", frame, "TOPLEFT", 8, -40)
    scrollArea:Point("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -30, 50)

    S:ReskinScroll(RayUIWarningFrameScrollScrollBar)

    local messageFrame = CreateFrame("EditBox", nil, frame)
    messageFrame:SetFont(R["media"].font, R["media"].fontsize, R["media"].fontflag)
    messageFrame:EnableMouse(false)
    messageFrame:EnableKeyboard(false)
    messageFrame:SetMultiLine(true)
    messageFrame:SetMaxLetters(99999)
    messageFrame:Size(400, 400)

    scrollArea:SetScrollChild(messageFrame)

    for i in pairs(AddonNotSupported) do
        local name, title, notes, enabled, loadable, reason, security = GetAddOnInfo(i)
        messageFrame:SetText(messageFrame:GetText().."\n"..name)
    end

    local button1 = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
    button1:Size(150, 30)
    button1:Point("BOTTOMLEFT", 10, 10)
    S:Reskin(button1)
    button1:SetText("幫我關掉它們")
    button1:SetScript("OnClick", function()
            for i = 1, GetNumAddOns() do
                if AddonNotSupported[i] then
                    DisableAddOn(i)
                end
            end
            ReloadUI()
        end)

    local button2 = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
    button2:Size(150, 30)
    button2:Point("BOTTOMRIGHT", -10, 10)
    S:Reskin(button2)
    button2:SetText("不，我需要它們")
    button2:SetScript("OnClick", function()
            for i = 1, GetNumAddOns() do
                if GetAddOnInfo(i) == "RayUI" then
                    DisableAddOn(i)
                end
            end
            ReloadUI()
        end)
end

local function CheckAddon()
    for i = 1, GetNumAddOns() do
        local name, title, notes, enabled, loadable, reason, security = GetAddOnInfo(i)
        if enabled then
            for _, word in pairs(BlackList) do
                if (name and name:lower():find(word)) or (title and title:lower():find(word)) then
                    AddonNotSupported[i] = true
                end
            end
        end
    end
    if R:TableIsEmpty(AddonNotSupported) then
        return false
    else
        CreateWarningFrame()
        return true
    end
end

function R:InitializeModules()
    if CheckAddon() then
        return
    else
        for i = 1, #self["RegisteredModules"] do
            local module = self:GetModule(self["RegisteredModules"][i])
            if module.Initialize then
                local _, catch = pcall(module.Initialize, module)
                self:ThrowError(catch)
            end
        end
    end
end

local logo = CreateFrame("Frame", nil, R.UIParent)
logo:SetPoint("CENTER", 0, 150)
logo:SetSize(256, 128)
logo.image = logo:CreateTexture(nil, "OVERLAY")
logo.image:SetAllPoints()
logo.image:SetTexture("Interface\\AddOns\\RayUI\\media\\logo.tga")
logo:Hide()
R.logo = logo

local function CreateSplashScreen()
    local f = CreateFrame("Frame", "RayUISplashScreen", R.UIParent)
    f:Size(300, 150)
    f:SetPoint("CENTER", 0, 100)
    f:SetFrameStrata("TOOLTIP")
    f:SetAlpha(0)

    f.bg = f:CreateTexture(nil, "BACKGROUND")
    f.bg:SetTexture([[Interface\LevelUp\LevelUpTex]])
    f.bg:SetPoint("BOTTOM")
    f.bg:Size(400, 240)
    f.bg:SetTexCoord(0.00195313, 0.63867188, 0.03710938, 0.23828125)
    f.bg:SetVertexColor(1, 1, 1, 0.7)

    f.lineTop = f:CreateTexture(nil, "BACKGROUND")
    f.lineTop:SetDrawLayer("BACKGROUND", 2)
    f.lineTop:SetTexture([[Interface\LevelUp\LevelUpTex]])
    f.lineTop:SetPoint("TOP")
    f.lineTop:Size(418, 7)
    f.lineTop:SetTexCoord(0.00195313, 0.81835938, 0.00195313, 0.01562500)

    f.lineBottom = f:CreateTexture(nil, "BACKGROUND")
    f.lineBottom:SetDrawLayer("BACKGROUND", 2)
    f.lineBottom:SetTexture([[Interface\LevelUp\LevelUpTex]])
    f.lineBottom:SetPoint("BOTTOM")
    f.lineBottom:Size(418, 7)
    f.lineBottom:SetTexCoord(0.00195313, 0.81835938, 0.00195313, 0.01562500)

    f.logo = f:CreateTexture(nil, "OVERLAY")
    f.logo:Size(256, 128)
    f.logo:SetTexture("Interface\\AddOns\\RayUI\\media\\logo.tga")
    f.logo:Point("CENTER", f, "CENTER")

    f.version = f:CreateFontString(nil, "OVERLAY")
    f.version:FontTemplate(nil, 12, nil)
    f.version:Point("TOP", f.logo, "BOTTOM", 90, 20)
    f.version:SetFormattedText("v%s", R.version)
end

local function HideSplashScreen()
    RayUISplashScreen:Hide()
end

local function FadeSplashScreen()
    R:Delay(2, function()
            R:UIFrameFadeOut(RayUISplashScreen, 1, 1, 0)
            RayUISplashScreen.fadeInfo.finishedFunc = HideSplashScreen
        end)
end

local function ShowSplashScreen()
    R:UIFrameFadeIn(RayUISplashScreen, 1, 0, 1)
    RayUISplashScreen.fadeInfo.finishedFunc = FadeSplashScreen
end

function R:PLAYER_ENTERING_WORLD()
    RequestTimePlayed()
    Advanced_UIScaleSlider:Kill()
    Advanced_UseUIScale:Kill()
    DEFAULT_CHAT_FRAME:AddMessage("欢迎使用|cff7aa6d6Ray|r|cffff0000U|r|cff7aa6d6I|r(v"..R.version..")，插件发布网址: |cff8A9DDE[|Hurl:https://github.com/fgprodigal/RayUI|h点击复制|h]|r")
    self:UnregisterEvent("PLAYER_ENTERING_WORLD" )
end

function R:Initialize()
    self:LoadMovers()

    if not self.db.layoutchosen then
        self:ChooseLayout()
    elseif self.global.general.logo then
        CreateSplashScreen()
        C_Timer.After(6, ShowSplashScreen)
    end

    self:RegisterEvent("PLAYER_REGEN_DISABLED")
    self:RegisterEvent("PLAYER_ENTERING_WORLD")
    self:RegisterEvent("PET_BATTLE_CLOSE", "AddNonPetBattleFrames")
	self:RegisterEvent("PET_BATTLE_OPENING_START", "RemoveNonPetBattleFrames")

    self:RegisterChatCommand("RayUI", "OpenConfig")
    self:RegisterChatCommand("RC", "OpenConfig")
    self:RegisterChatCommand("cpuimpact", "GetCPUImpact")
	self:RegisterChatCommand("cpuusage", "GetTopCPUFunc")
	-- args: module, showall, delay, minCalls
	-- Example1: /cpuusage all
	-- Example2: /cpuusage Bags true
	-- Example3: /cpuusage UnitFrames nil 50 25
	-- Note: showall, delay, and minCalls will default if not set
	-- arg1 can be "all" this will scan all registered modules!
    self:RegisterChatCommand("gm", ToggleHelpFrame)

    self:Delay(5, function() collectgarbage("collect") end)
    self:LockCVar("overrideArchive", 0)
    self.initialized = true
end

function R:GetPlayerRole()
    local assignedRole = UnitGroupRolesAssigned("player")
    if ( assignedRole == "NONE" ) then
        local spec = GetSpecialization()
        return GetSpecializationRole(spec)
    end

    return assignedRole
end

local tmp={}
function R:Print(...)
    local n=0
    for i=1, select("#", ...) do
        n=n+1
        tmp[n] = tostring(select(i, ...))
    end
    DEFAULT_CHAT_FRAME:AddMessage("|cff7aa6d6Ray|r|cffff0000U|r|cff7aa6d6I|r: " .. table.concat(tmp," ",1,n) )
end

function R:Debug(...)
    if not R:IsDeveloper() then return end
    local n=0
    for i=1, select("#", ...) do
        n=n+1
        tmp[n] = tostring(select(i, ...))
    end
    DEFAULT_CHAT_FRAME:AddMessage("|cffff0000debug|r: " .. table.concat(tmp," ",1,n) )
end

function R:ColorGradient(perc, ...)
    if perc >= 1 then
        local r, g, b = select(select("#", ...) - 2, ...)
        return r, g, b
    elseif perc <= 0 then
        local r, g, b = ...
        return r, g, b
    end

    local num = select("#", ...) / 3
    local segment, relperc = math.modf(perc*(num-1))
    local r1, g1, b1, r2, g2, b2 = select((segment*3)+1, ...)

    return r1 + (r2-r1)*relperc, g1 + (g2-g1)*relperc, b1 + (b2-b1)*relperc
end

function R:Round(num, idp)
    if(idp and idp > 0) then
        local mult = 10 ^ idp
        return floor(num * mult + 0.5) / mult
    end
    return floor(num + 0.5)
end

local waitTable = {}
local waitFrame
function R:Delay(delay, func, ...)
    if(type(delay)~="number" or type(func)~="function") then
        return false
    end
    if(waitFrame == nil) then
        waitFrame = CreateFrame("Frame","WaitFrame", R.UIParent)
        waitFrame:SetScript("onUpdate",function (self,elapse)
                local count = #waitTable
                local i = 1
                while(i<=count) do
                    local waitRecord = tremove(waitTable,i)
                    local d = tremove(waitRecord,1)
                    local f = tremove(waitRecord,1)
                    local p = tremove(waitRecord,1)
                    if(d>elapse) then
                        tinsert(waitTable,i,{d-elapse,f,p})
                        i = i + 1
                    else
                        count = count - 1
                        f(unpack(p))
                    end
                end
            end)
    end
    tinsert(waitTable,{delay,func,{...}})
    return true
end

function R:RGBToHex(r, g, b)
    r = r <= 1 and r >= 0 and r or 0
    g = g <= 1 and g >= 0 and g or 0
    b = b <= 1 and b >= 0 and b or 0
    return string.format("|cff%02x%02x%02x", r*255, g*255, b*255)
end

function R:ShortValue(v)
    if self.global.general.numberType == 1 then
        if v >= 1e6 or v <= -1e6 then
            return ("%.1fm"):format(v / 1e6):gsub("%.?0+([km])$", "%1")
        elseif v >= 1e3 or v <= -1e3 then
            return ("%.1fk"):format(v / 1e3):gsub("%.?0+([km])$", "%1")
        else
            return v
        end
    else
        if v >= 1e8 or v <= -1e8 then
            return ("%.1f" .. SECOND_NUMBER_CAP):format(v / 1e8):gsub("%.?0+([km])$", "%1")
        elseif v >= 1e4 or v <= -1e4 then
            return ("%.1f" .. FIRST_NUMBER_CAP):format(v / 1e4):gsub("%.?0+([km])$", "%1")
        else
            return v
        end
    end
end

function R:ShortenString(string, numChars, dots)
    local bytes = string:len()
    if (bytes <= numChars) then
        return string
    else
        local len, pos = 0, 1
        while(pos <= bytes) do
            len = len + 1
            local c = string:byte(pos)
            if (c > 0 and c <= 127) then
                pos = pos + 1
            elseif (c >= 192 and c <= 223) then
                pos = pos + 2
            elseif (c >= 224 and c <= 239) then
                pos = pos + 3
                len = len + 1
            elseif (c >= 240 and c <= 247) then
                pos = pos + 4
                len = len + 1
            end
            if (len == numChars) then break end
        end

        if (len == numChars and pos <= bytes) then
            return string:sub(1, pos - 1)..(dots and "..." or "")
        else
            return string
        end
    end
end

function R:GetScreenQuadrant(frame)
    local x, y = frame:GetCenter()
    local screenWidth = GetScreenWidth()
    local screenHeight = GetScreenHeight()
    local point

    if not frame:GetCenter() then
        return "UNKNOWN", frame:GetName()
    end

    if (x > (screenWidth / 4) and x < (screenWidth / 4)*3) and y > (screenHeight / 4)*3 then
        point = "TOP"
    elseif x < (screenWidth / 4) and y > (screenHeight / 4)*3 then
        point = "TOPLEFT"
    elseif x > (screenWidth / 4)*3 and y > (screenHeight / 4)*3 then
        point = "TOPRIGHT"
    elseif (x > (screenWidth / 4) and x < (screenWidth / 4)*3) and y < (screenHeight / 4) then
        point = "BOTTOM"
    elseif x < (screenWidth / 4) and y < (screenHeight / 4) then
        point = "BOTTOMLEFT"
    elseif x > (screenWidth / 4)*3 and y < (screenHeight / 4) then
        point = "BOTTOMRIGHT"
    elseif x < (screenWidth / 4) and (y > (screenHeight / 4) and y < (screenHeight / 4)*3) then
        point = "LEFT"
    elseif x > (screenWidth / 4)*3 and y < (screenHeight / 4)*3 and y > (screenHeight / 4) then
        point = "RIGHT"
    else
        point = "CENTER"
    end

    return point
end

local Unusable

if R.myclass == "DEATHKNIGHT" then
    Unusable = { -- weapon, armor, dual-wield
        {LE_ITEM_WEAPON_BOWS, LE_ITEM_WEAPON_GUNS, LE_ITEM_WEAPON_WARGLAIVE, LE_ITEM_WEAPON_STAFF,LE_ITEM_WEAPON_UNARMED, LE_ITEM_WEAPON_DAGGER, LE_ITEM_WEAPON_THROWN, LE_ITEM_WEAPON_CROSSBOW, LE_ITEM_WEAPON_WAND},
        {LE_ITEM_ARMOR_SHIELD}
    }
elseif R.myclass == "DEMONHUNTER" then
    Unusable = {
        {LE_ITEM_WEAPON_AXE2H, LE_ITEM_WEAPON_BOWS, LE_ITEM_WEAPON_GUNS, LE_ITEM_WEAPON_MACE1H, LE_ITEM_WEAPON_MACE2H, LE_ITEM_WEAPON_POLEARM, LE_ITEM_WEAPON_SWORD2H, LE_ITEM_WEAPON_STAFF, LE_ITEM_WEAPON_THROWN, LE_ITEM_WEAPON_CROSSBOW, LE_ITEM_WEAPON_WAND},
        {LE_ITEM_ARMOR_MAIL, LE_ITEM_ARMOR_PLATE, LE_ITEM_ARMOR_SHIELD}
    }
elseif R.myclass == "DRUID" then
    Unusable = {
        {LE_ITEM_WEAPON_AXE1H, LE_ITEM_WEAPON_AXE2H, LE_ITEM_WEAPON_BOWS, LE_ITEM_WEAPON_GUNS, LE_ITEM_WEAPON_SWORD1H, LE_ITEM_WEAPON_SWORD2H, LE_ITEM_WEAPON_WARGLAIVE, LE_ITEM_WEAPON_THROWN, LE_ITEM_WEAPON_CROSSBOW, LE_ITEM_WEAPON_WAND},
        {LE_ITEM_ARMOR_MAIL, LE_ITEM_ARMOR_PLATE, LE_ITEM_ARMOR_SHIELD},
        true
    }
elseif R.myclass == "HUNTER" then
    Unusable = {
        {LE_ITEM_WEAPON_MACE1H, LE_ITEM_WEAPON_MACE2H, LE_ITEM_WEAPON_WARGLAIVE, LE_ITEM_WEAPON_THROWN, LE_ITEM_WEAPON_WAND},
        {LE_ITEM_ARMOR_PLATE, LE_ITEM_ARMOR_SHIELD}
    }
elseif R.myclass == "MAGE" then
    Unusable = {
        {LE_ITEM_WEAPON_AXE1H, LE_ITEM_WEAPON_AXE2H, LE_ITEM_WEAPON_BOWS, LE_ITEM_WEAPON_GUNS, LE_ITEM_WEAPON_MACE1H, LE_ITEM_WEAPON_MACE2H, LE_ITEM_WEAPON_POLEARM, LE_ITEM_WEAPON_SWORD2H, LE_ITEM_WEAPON_WARGLAIVE, LE_ITEM_WEAPON_UNARMED, LE_ITEM_WEAPON_THROWN, LE_ITEM_WEAPON_CROSSBOW},
        {LE_ITEM_ARMOR_LEATHER, LE_ITEM_ARMOR_MAIL, LE_ITEM_ARMOR_PLATE, LE_ITEM_ARMOR_SHIELD},
        true
    }
elseif R.myclass == "MONK" then
    Unusable = {
        {LE_ITEM_WEAPON_AXE2H, LE_ITEM_WEAPON_BOWS, LE_ITEM_WEAPON_GUNS, LE_ITEM_WEAPON_MACE2H, LE_ITEM_WEAPON_SWORD2H, LE_ITEM_WEAPON_WARGLAIVE, LE_ITEM_WEAPON_DAGGER, LE_ITEM_WEAPON_THROWN, LE_ITEM_WEAPON_CROSSBOW, LE_ITEM_WEAPON_WAND},
        {LE_ITEM_ARMOR_MAIL, LE_ITEM_ARMOR_PLATE, LE_ITEM_ARMOR_SHIELD}
    }
elseif R.myclass == "PALADIN" then
    Unusable = {
        {LE_ITEM_WEAPON_BOWS, LE_ITEM_WEAPON_GUNS, LE_ITEM_WEAPON_WARGLAIVE, LE_ITEM_WEAPON_STAFF, LE_ITEM_WEAPON_UNARMED, LE_ITEM_WEAPON_DAGGER, LE_ITEM_WEAPON_THROWN, LE_ITEM_WEAPON_CROSSBOW, LE_ITEM_WEAPON_WAND},
        {},
        true
    }
elseif R.myclass == "PRIEST" then
    Unusable = {
        {LE_ITEM_WEAPON_AXE1H, LE_ITEM_WEAPON_AXE2H, LE_ITEM_WEAPON_BOWS, LE_ITEM_WEAPON_GUNS, LE_ITEM_WEAPON_MACE2H, LE_ITEM_WEAPON_POLEARM, LE_ITEM_WEAPON_SWORD1H, LE_ITEM_WEAPON_SWORD2H, LE_ITEM_WEAPON_WARGLAIVE, LE_ITEM_WEAPON_UNARMED, LE_ITEM_WEAPON_THROWN, LE_ITEM_WEAPON_CROSSBOW},
        {LE_ITEM_ARMOR_LEATHER, LE_ITEM_ARMOR_MAIL, LE_ITEM_ARMOR_PLATE, LE_ITEM_ARMOR_SHIELD},
        true
    }
elseif R.myclass == "ROGUE" then
    Unusable = {
        {LE_ITEM_WEAPON_AXE2H, LE_ITEM_WEAPON_MACE2H, LE_ITEM_WEAPON_POLEARM, LE_ITEM_WEAPON_SWORD2H, LE_ITEM_WEAPON_WARGLAIVE, LE_ITEM_WEAPON_STAFF, LE_ITEM_WEAPON_WAND},
        {LE_ITEM_ARMOR_MAIL, LE_ITEM_ARMOR_PLATE, LE_ITEM_ARMOR_SHIELD}
    }
elseif R.myclass == "SHAMAN" then
    Unusable = {
        {LE_ITEM_WEAPON_BOWS, LE_ITEM_WEAPON_GUNS, LE_ITEM_WEAPON_POLEARM, LE_ITEM_WEAPON_SWORD1H, LE_ITEM_WEAPON_SWORD2H, LE_ITEM_WEAPON_WARGLAIVE, LE_ITEM_WEAPON_THROWN, LE_ITEM_WEAPON_CROSSBOW, LE_ITEM_WEAPON_WAND},
        {LE_ITEM_ARMOR_PLATEM}
    }
elseif R.myclass == "WARLOCK" then
    Unusable = {
        {LE_ITEM_WEAPON_AXE1H, LE_ITEM_WEAPON_AXE2H, LE_ITEM_WEAPON_BOWS, LE_ITEM_WEAPON_GUNS, LE_ITEM_WEAPON_MACE1H, LE_ITEM_WEAPON_MACE2H, LE_ITEM_WEAPON_POLEARM, LE_ITEM_WEAPON_SWORD2H, LE_ITEM_WEAPON_WARGLAIVE, LE_ITEM_WEAPON_UNARMED, LE_ITEM_WEAPON_THROWN, LE_ITEM_WEAPON_CROSSBOW},
        {LE_ITEM_ARMOR_LEATHER, LE_ITEM_ARMOR_MAIL, LE_ITEM_ARMOR_PLATE, LE_ITEM_ARMOR_SHIELD},
        true
    }
elseif R.myclass == "WARRIOR" then
    Unusable = {{LE_ITEM_WEAPON_WARGLAIVE, LE_ITEM_WEAPON_WAND}, {}}
else
    Unusable = {{}, {}}
end

--[[
LE_ITEM_CLASS_WEAPON 2
LE_ITEM_CLASS_ARMOR 4

LE_ITEM_WEAPON_AXE1H 0
LE_ITEM_WEAPON_AXE2H 1
LE_ITEM_WEAPON_BOWS 2
LE_ITEM_WEAPON_GUNS 3
LE_ITEM_WEAPON_MACE1H 4
LE_ITEM_WEAPON_MACE2H 5
LE_ITEM_WEAPON_POLEARM 6
LE_ITEM_WEAPON_SWORD1H 7
LE_ITEM_WEAPON_SWORD2H 8
LE_ITEM_WEAPON_WARGLAIVE 9 (DH Only?)
LE_ITEM_WEAPON_STAFF 10
LE_ITEM_WEAPON_BEARCLAW 11
LE_ITEM_WEAPON_CATCLAW 12
LE_ITEM_WEAPON_UNARMED 13 (Fist Weapons)
LE_ITEM_WEAPON_GENERIC 14
LE_ITEM_WEAPON_DAGGER 15
LE_ITEM_WEAPON_THROWN 16
Spears? 17 (Not in game)
LE_ITEM_WEAPON_CROSSBOW 18
LE_ITEM_WEAPON_WAND 19
LE_ITEM_WEAPON_FISHINGPOLE 20

LE_ITEM_ARMOR_GENERIC 0
LE_ITEM_ARMOR_CLOTH 1
LE_ITEM_ARMOR_LEATHER 2
LE_ITEM_ARMOR_MAIL 3
LE_ITEM_ARMOR_PLATE 4
LE_ITEM_ARMOR_COSMETIC 5
LE_ITEM_ARMOR_SHIELD 6
LE_ITEM_ARMOR_LIBRAM 7
LE_ITEM_ARMOR_IDOL 8
LE_ITEM_ARMOR_TOTEM 9
LE_ITEM_ARMOR_SIGIL 10
LE_ITEM_ARMOR_RELIC 11
]]

R.unusable = {}
R.cannotDual = Unusable[3]

for i, class in ipairs({LE_ITEM_CLASS_WEAPON, LE_ITEM_CLASS_ARMOR}) do
    local list = {}
    for _, subclass in ipairs(Unusable[i]) do
        list[subclass] = true
    end

    R.unusable[class] = list
end

function R:IsItemUnusable(...)
    if ... then
        local slot, _,_, class, subclass = select(9, GetItemInfo(...))
        return R:IsClassUnusable(class, subclass, slot)
    end
end

function R:IsClassUnusable(class, subclass, slot)
    if class and subclass and R.unusable[class] then
        return slot ~= '' and R.unusable[class][subclass] or slot == "INVTYPE_WEAPONOFFHAND" and R.cannotDual
    end
end

R["media"] = {}
R["texts"] = {}

function R:UpdateFontTemplates()
    for text, _ in pairs(self["texts"]) do
        if text then
            text:FontTemplate(text.font, text.fontSize, text.fontStyle);
        else
            self["texts"][text] = nil;
        end
    end
end

function R:UpdateMedia()
    --Fonts
    self["media"].font = LSM:Fetch("font", self.global["media"].font)
    self["media"].dmgfont = LSM:Fetch("font", self.global["media"].dmgfont)
    self["media"].pxfont = LSM:Fetch("font", self.global["media"].pxfont)
    self["media"].cdfont = LSM:Fetch("font", self.global["media"].cdfont)
    self["media"].fontsize = self.global["media"].fontsize
    self["media"].fontflag = self.global["media"].fontflag

    --Textures
    self["media"].blank = LSM:Fetch("statusbar", self.global["media"].blank)
    self["media"].normal = LSM:Fetch("statusbar", self.global["media"].normal)
    self["media"].gloss = LSM:Fetch("statusbar", self.global["media"].gloss)
    self["media"].glow = LSM:Fetch("border", self.global["media"].glow)

    --Border Color
    self["media"].bordercolor = self.global["media"].bordercolor

    --Backdrop Color
    self["media"].backdropcolor = self.global["media"].backdropcolor
    self["media"].backdropfadecolor = self.global["media"].backdropfadecolor

    --Sound
    self["media"].warning = LSM:Fetch("sound", self.global["media"].warning)
    self["media"].errorsound = LSM:Fetch("sound", self.global["media"].errorsound)

    self:UpdateBlizzardFonts()
end

function R:CreateDemoFrame()
    local S = R:GetModule("Skins")
    demoFrame = CreateFrame("Frame", "RayUIDemoFrame", LibStub("AceConfigDialog-3.0").OpenFrames["RayUI"].frame)
    demoFrame:Size(300, 200)
    demoFrame:Point("LEFT", LibStub("AceConfigDialog-3.0").OpenFrames["RayUI"].frame, "RIGHT", 20, 0)
    demoFrame:SetTemplate("Transparent")
    demoFrame.outBorder = CreateFrame("Frame", nil, demoFrame)
    demoFrame.outBorder:SetOutside(demoFrame, 1, 1)
    demoFrame.outBorder:CreateShadow()
    demoFrame.title = demoFrame:CreateFontString(nil, "OVERLAY")
    demoFrame.title:FontTemplate()
    demoFrame.title:SetText("Demo Frame")
    demoFrame.title:Point("TOPLEFT", 10, -5)
    demoFrame.inlineFrame1 = CreateFrame("Frame", nil, demoFrame)
    demoFrame.inlineFrame1:SetFrameLevel(demoFrame:GetFrameLevel() + 1)
    demoFrame.inlineFrame1:Size(150, 150)
    demoFrame.inlineFrame1:Point("TOPLEFT", 10, -30)
    demoFrame.inlineFrame1:SetTemplate("Transparent")
    demoFrame.button1 = CreateFrame("Button", nil, demoFrame, "UIPanelButtonTemplate")
    demoFrame.button1:Point("BOTTOMLEFT", 30, 40)
    demoFrame.button1:SetText("Test")
    demoFrame.button1:Size(100, 20)
    S:Reskin(demoFrame.button1)
    demoFrame.button2 = CreateFrame("Button", nil, demoFrame, "UIPanelButtonTemplate")
    demoFrame.button2:Point("BOTTOMRIGHT", -10, 10)
    demoFrame.button2:SetText("Close")
    demoFrame.button2:Size(100, 20)
    demoFrame.button2:SetScript("OnClick", function() demoFrame:Hide() end)
    S:Reskin(demoFrame.button2)

    tinsert(UISpecialFrames, demoFrame:GetName())
end

function R:UpdateDemoFrame()
    local borderr, borderg, borderb = unpack(R.global.media.bordercolor)
    local backdropr, backdropg, backdropb = unpack(R.global.media.backdropcolor)
    local backdropfader, backdropfadeg, backdropfadeb, backdropfadea = unpack(R.global.media.backdropfadecolor)
    if not demoFrame then
        self:CreateDemoFrame()
    end
    if not demoFrame:IsShown() then
        demoFrame:Show()
    end
    demoFrame:SetBackdropColor(backdropfader, backdropfadeg, backdropfadeb, backdropfadea)
    demoFrame:SetBackdropBorderColor(borderr, borderg, borderb)
    demoFrame.outBorder.border:SetBackdropBorderColor(borderr, borderg, borderb)
    demoFrame.inlineFrame1:SetBackdropColor(backdropfader, backdropfadeg, backdropfadeb, backdropfadea)
    demoFrame.inlineFrame1:SetBackdropBorderColor(borderr, borderg, borderb)
    demoFrame.button1:SetBackdropColor(backdropfader, backdropfadeg, backdropfadeb, backdropfadea)
    demoFrame.button1:SetBackdropBorderColor(borderr, borderg, borderb)
    demoFrame.button1.backdropTexture:SetVertexColor(backdropr, backdropg, backdropb)
    demoFrame.button2:SetBackdropColor(backdropfader, backdropfadeg, backdropfadeb, backdropfadea)
    demoFrame.button2:SetBackdropBorderColor(borderr, borderg, borderb)
    demoFrame.button2.backdropTexture:SetVertexColor(backdropr, backdropg, backdropb)
end

R.Developer = { "夏琉君", "Myr", "Drayd", "蚊蚊", "Gabrriel", "Manastrom", "Casadora" }

function R:IsDeveloper()
    for _, name in pairs(R.Developer) do
        if name == R.myname then
            return true
        end
    end
    return false
end

function R:ThrowError(err)
    if err and GetCVarBool("scriptErrors") then
        if IsAddOnLoaded("!BugGrabber") then
            geterrorhandler()(err)
        elseif BaudErrorFrameHandler then
            BaudErrorFrameHandler(err)
        else
            ScriptErrorsFrame_OnError(err, false)
        end
    end
end

local CPU_USAGE = {}
local function CompareCPUDiff(showall, minCalls)
    local greatestUsage, greatestCalls, greatestName, newName, newFunc
    local greatestDiff, lastModule, mod, newUsage, calls, differance = 0;

    for name, oldUsage in pairs(CPU_USAGE) do
        newName, newFunc = name:match("^([^:]+):(.+)$")
        if not newFunc then
            R:Print("CPU_USAGE:", name, newFunc)
        else
            if newName ~= lastModule then
                mod = R:GetModule(newName, true) or R
                lastModule = newName
            end
            newUsage, calls = GetFunctionCPUUsage(mod[newFunc], true)
            differance = newUsage - oldUsage
            if showall and calls > minCalls then
                R:Print(calls, name, differance)
            end
            if (differance > greatestDiff) and calls > minCalls then
                greatestName, greatestUsage, greatestCalls, greatestDiff = name, newUsage, calls, differance
            end
        end
    end

    if greatestName then
        R:Print(greatestName.. " had the CPU usage difference of: "..greatestUsage.."ms. And has been called ".. greatestCalls.." times.")
    else
        R:Print('CPU Usage: No CPU Usage differences found.')
    end
end

function R:GetTopCPUFunc(msg)
    local module, showall, delay, minCalls = msg:match("^([^%s]+)%s*([^%s]*)%s*([^%s]*)%s*(.*)$")
    local mod

    module = (module == "nil" and nil) or module
    if not module then
        R:Print('cpuusage: module (arg1) is required! This can be set as "all" too.')
        return
    end
    showall = (showall == "true" and true) or false
    delay = (delay == "nil" and nil) or tonumber(delay) or 5
    minCalls = (minCalls == "nil" and nil) or tonumber(minCalls) or 15

    twipe(CPU_USAGE)
    if module == "all" then
        for _, registeredModule in pairs(self['RegisteredModules']) do
            mod = self:GetModule(registeredModule, true) or self
            for name, func in pairs(mod) do
                if type(mod[name]) == "function" and name ~= "GetModule" then
                    CPU_USAGE[registeredModule..":"..name] = GetFunctionCPUUsage(mod[name], true)
                end
            end
        end
    else
        mod = self:GetModule(module, true) or self
        for name, func in pairs(mod) do
            if type(mod[name]) == "function" and name ~= "GetModule" then
                CPU_USAGE[module..":"..name] = GetFunctionCPUUsage(mod[name], true)
            end
        end
    end

    self:Delay(delay, CompareCPUDiff, showall, minCalls)
    self:Print("Calculating CPU Usage differences (module: "..(module or "?")..", showall: "..tostring(showall)..", minCalls: "..tostring(minCalls)..", delay: "..tostring(delay)..")")
end

local num_frames = 0
local function OnUpdate()
    num_frames = num_frames + 1
end
local cpuf = CreateFrame("Frame")
cpuf:Hide()
cpuf:SetScript("OnUpdate", OnUpdate)

local toggleMode = false
function R:GetCPUImpact()
    if(not toggleMode) then
        ResetCPUUsage()
        num_frames = 0;
        debugprofilestart()
        cpuf:Show()
        toggleMode = true
        self:Print("CPU Impact being calculated, type /cpuimpact to get results when you are ready.")
    else
        cpuf:Hide()
        local ms_passed = debugprofilestop()
        UpdateAddOnCPUUsage()

        self:Print("Consumed "..(GetAddOnCPUUsage("ElvUI") / num_frames).." milliseconds per frame. Each frame took "..(ms_passed / num_frames).." to render.");
        toggleMode = false
    end
end

function R:Debug(...)
    if not R:IsDeveloper() then return end
    self:Print(...)
end

function R:CopyTable(currentTable, defaultTable)
    if type(currentTable) ~= "table" then currentTable = {} end

    if type(defaultTable) == "table" then
        for option, value in pairs(defaultTable) do
            if type(value) == "table" then
                value = self:CopyTable(currentTable[option], value)
            end

            currentTable[option] = value
        end
    end

    return currentTable
end

function R:RemoveNonPetBattleFrames()
	if InCombatLockdown() then return end
	for object, _ in pairs(R.FrameLocks) do
		local obj = _G[object] or object
		obj:SetParent(R.HiddenFrame)
	end

	self:RegisterEvent("PLAYER_REGEN_DISABLED", "AddNonPetBattleFrames")
end

function R:AddNonPetBattleFrames()
	if InCombatLockdown() then return end
	for object, data in pairs(R.FrameLocks) do
		local obj = _G[object] or object
		local parent, strata, level
		if type(data) == "table" then
			parent, strata, level = data.parent, data.strata, data.level
		elseif data == true then
			parent = R.UIParent
		end
		obj:SetParent(parent)
		if strata then
			obj:SetFrameStrata(strata)
		end
        if level then
			obj:SetFrameLevel(level)
            if obj.border then
                obj.border:SetFrameLevel(level-1)
            end
            if obj.shadow then
                obj.shadow:SetFrameLevel(level-2)
            end
		end
	end

	self:UnregisterEvent("PLAYER_REGEN_DISABLED")
end