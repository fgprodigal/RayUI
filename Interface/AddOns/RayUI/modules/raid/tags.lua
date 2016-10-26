local R, L, P, G = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, GlobalDB
local RA = R:GetModule("Raid")

local _, ns = ...
local RayUF = ns.oUF

--Cache global variables
--Lua functions
local floor = math.floor
local format = string.format
local GetTime = GetTime

--WoW API / Variables
local UnitName = UnitName
local UnitIsAFK = UnitIsAFK
local UnitIsDead = UnitIsDead
local UnitIsGhost = UnitIsGhost
local UnitIsConnected = UnitIsConnected
local UnitClass = UnitClass
local UnitHealth = UnitHealth
local UnitHealthMax = UnitHealthMax
local UnitGetIncomingHeals = UnitGetIncomingHeals

--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: ALTERNATE_POWER_INDEX, DEAD

RayUF.Tags.Methods["RayUIRaid:stat"] = function(u)
    if UnitIsAFK(u) then
        return "|cffCFCFCFAFK|r"
    elseif UnitIsDead(u) then
        return "|cffCFCFCF"..DEAD.."|r"
    elseif UnitIsGhost(u) then
        return "|cffCFCFCF"..L["灵魂"].."|r"
    elseif not UnitIsConnected(u) then
        return "|cffCFCFCF"..L["离线"].."|r"
    end

    if RA.db.perc then
        local perc = RayUF.Tags.Methods["perhp"](u)
        if perc < 90 then
            local _, class = UnitClass(u)
            local color = RA.colorCache[class]

            return color..perc.."%|r"
        end
    elseif RA.db.deficit or RA.db.actual then
        local cur = UnitHealth(u)
        local max = UnitHealthMax(u)
        local per = cur/max

        if per < 0.9 then
            local _, class = UnitClass(u)
            local color = RA.colorCache[class]
            if color then
                return color..(RA.db.deficit and "-"..R:ShortValue(max-cur) or R:ShortValue(cur)).."|r"
            end
        end
    end
end
RayUF.Tags.Events["RayUIRaid:stat"] = "UNIT_MAXHEALTH UNIT_HEALTH UNIT_HEALTH_FREQUENT UNIT_CONNECTION PLAYER_FLAGS_CHANGED"

RayUF.Tags.Methods["RayUIRaid:heals"] = function(u)
    local incheal = UnitGetIncomingHeals(u) or 0
    if incheal > 0 then
        return "|cff00FF00"..R:ShortValue(incheal).."|r"
    else
        local def = RayUF.Tags.Methods["RayUIRaid:stat"](u)
        return def
    end
end
RayUF.Tags.Events["RayUIRaid:heals"] = "UNIT_HEAL_PREDICTION "..RayUF.Tags.Events["RayUIRaid:stat"]

RayUF.Tags.Methods["RayUIRaid:othersheals"] = function(u)
    local incheal = UnitGetIncomingHeals(u) or 0
    local player = UnitGetIncomingHeals(u, "player") or 0

    incheal = incheal - player

    if incheal > 0 then
        return "|cff00FF00"..R:ShortValue(incheal).."|r"
    else
        local def = RayUF.Tags.Methods["RayUIRaid:stat"](u)
        return def
    end
end
RayUF.Tags.Events["RayUIRaid:othersheals"] = RayUF.Tags.Events["RayUIRaid:heals"]

local timer = {}

local AfkTime = function(s)
    local minute = 60
    local min = floor(s/minute)
    local sec = floor(s-(min*minute))
    if sec < 10 then sec = "0"..sec end
    if min < 10 then min = "0"..min end
    return min..":"..sec
end

RayUF.Tags.Methods["RayUIRaid:afk"] = function(u)
    local name = UnitName(u)
    if(RA.db.afk and (UnitIsAFK(u) or not UnitIsConnected(u))) then
        if not timer[name] then
            timer[name] = GetTime()
        end
        local time = (GetTime()-timer[name])

        return AfkTime(time)
    elseif timer[name] then
        timer[name] = nil
    end
end
RayUF.Tags.Events["RayUIRaid:afk"] = "PLAYER_FLAGS_CHANGED UNIT_CONNECTION"
