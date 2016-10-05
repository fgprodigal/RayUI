local R, L, P, G = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, GlobalDB
local M = R:GetModule("Misc")
local mod = M:NewModule("Mirror", "AceEvent-3.0")

--Cache global variables
--Lua functions
local unpack, next, type, setmetatable = unpack, next, type, setmetatable
local strsplit = string.split

--WoW API / Variables
local CreateFrame = CreateFrame
local GetMirrorTimerProgress = GetMirrorTimerProgress
local GetMirrorTimerInfo = GetMirrorTimerInfo

--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: Stop, MIRRORTIMER_NUMTIMERS, UIParent

---------------------------------------------------------------------
-- original by haste, edited for Elvui :), styled for RayUI
---------------------------------------------------------------------

local settings, _DEFAULTS = {}
local barPool = {}

local function loadPosition(self)
    local pos = settings.position[self.type]
    local p1, frame, p2, x, y = strsplit("#", pos)

    return self:SetPoint(p1, frame, p2, R:Scale(x), R:Scale(y))
end

local function OnUpdate(self, elapsed)
    if(self.paused) then return end

    self:SetValue(GetMirrorTimerProgress(self.type) / 1e3)
end

local function Start(self, value, maxvalue, scale, paused, text)
    if(paused > 0) then
        self.paused = 1
    elseif(self.paused) then
        self.paused = nil
    end

    self.text:SetText(text)

    self:SetMinMaxValues(0, maxvalue / 1e3)
    self:SetValue(value / 1e3)

    if(not self:IsShown()) then self:Show() end
end

function mod:Spawn(type)
    if(barPool[type]) then return barPool[type] end
    local frame = CreateFrame("StatusBar", nil, R.UIParent)

    frame:SetScript("OnUpdate", OnUpdate)

    local r, g, b = unpack(settings.colors[type])

    local bg = frame:CreateTexture(nil, "BACKGROUND")
    bg:SetAllPoints(frame)
    bg:SetTexture(R["media"].blank)
    bg:SetVertexColor(r * .2, g * .2, b * .2)

    local border = CreateFrame("Frame", nil, frame)
    border:SetAllPoints()
    border:CreateShadow("Background")
    border:SetFrameStrata("BACKGROUND")
    border:SetFrameLevel(0)

    local text = frame:CreateFontString(nil, "OVERLAY")
    text:SetFont(R["media"].font, R["media"].fontsize, "THINOUTLINE")

    text:SetJustifyH"CENTER"
    text:SetTextColor(1, 1, 1)

    text:SetPoint("LEFT", frame)
    text:SetPoint("RIGHT", frame)
    text:SetPoint("TOP", frame)
    text:SetPoint("BOTTOM", frame)

    frame:SetSize(settings.width, settings.height)

    frame:SetStatusBarTexture(settings.texture)
    frame:SetStatusBarColor(r, g, b)

    local spark = frame:CreateTexture(nil, "OVERLAY")
    spark:SetTexture[[Interface\CastingBar\UI-CastingBar-Spark]]
    spark:SetBlendMode("ADD")
    spark:SetAlpha(.8)
    spark:Point("TOPLEFT", frame:GetStatusBarTexture(), "TOPRIGHT", -10, 13)
    spark:Point("BOTTOMRIGHT", frame:GetStatusBarTexture(), "BOTTOMRIGHT", 10, -13)

    frame.type = type
    frame.text = text

    frame.Start = Start
    frame.Stop = Stop

    loadPosition(frame)

    barPool[type] = frame
    return frame
end

function mod:PauseAll(val)
    for _, bar in next, barPool do
        bar.paused = val
    end
end

function mod:PLAYER_ENTERING_WORLD()
    for i=1, MIRRORTIMER_NUMTIMERS do
        local type, value, maxvalue, scale, paused, text = GetMirrorTimerInfo(i)
        if(type ~= "UNKNOWN") then
            self:Spawn(type):Start(value, maxvalue, scale, paused, text)
        end
    end
end

function mod:MIRROR_TIMER_START(event, type, value, maxvalue, scale, paused, text)
    return self:Spawn(type):Start(value, maxvalue, scale, paused, text)
end

function mod:MIRROR_TIMER_STOP(event, type)
    return self:Spawn(type):Hide()
end

function mod:MIRROR_TIMER_PAUSE(event, duration)
    return self:PauseAll((duration > 0 and duration) or nil)
end

function mod:Initialize()
    _DEFAULTS = {
        width = R:Scale(220),
        height = R:Scale(18),
        texture = R["media"].normal,
        position = {
            ["BREATH"] = "TOP#RayUIParent#TOP#0#-96",
            ["EXHAUSTION"] = "TOP#RayUIParent#TOP#0#-119",
            ["FEIGNDEATH"] = "TOP#RayUIParent#TOP#0#-142",
        },
        colors = {
            EXHAUSTION = {1, .9, 0},
            BREATH = {95/255, 182/255, 255/255},
            DEATH = {1, .7, 0},
            FEIGNDEATH = {1, .7, 0},
        }
    }

    settings = setmetatable(settings, {__index = _DEFAULTS})
    for k,v in next, settings do
        if(type(v) == "table") then
            settings[k] = setmetatable(settings[k], {__index = _DEFAULTS[k]})
        end
    end

    self:RegisterEvent("PLAYER_ENTERING_WORLD")
    self:RegisterEvent("MIRROR_TIMER_START")
    self:RegisterEvent("MIRROR_TIMER_STOP")
    self:RegisterEvent("MIRROR_TIMER_PAUSE")

    UIParent:UnregisterEvent("MIRROR_TIMER_START")
end

M:RegisterMiscModule(mod:GetName())
