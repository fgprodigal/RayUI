local R, L, P, G = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, GlobalDB

local _, ns = ...
local oUF = RayUF or oUF

--Cache global variables
--Lua functions
local type, unpack, math = type, unpack, math
local format = string.format
local floor = math.floor

--WoW API / Variables
local UnitLevel = UnitLevel
local UnitClassification = UnitClassification
local GetQuestDifficultyColor = GetQuestDifficultyColor
local UnitIsPlayer = UnitIsPlayer
local UnitClass = UnitClass
local UnitIsTapDenied = UnitIsTapDenied
local UnitIsEnemy = UnitIsEnemy
local UnitReaction = UnitReaction
local UnitHealth = UnitHealth
local UnitHealthMax = UnitHealthMax
local UnitPowerType = UnitPowerType
local UnitPower = UnitPower
local UnitPowerMax = UnitPowerMax
local UnitName = UnitName
local UnitIsDead = UnitIsDead
local UnitIsGhost = UnitIsGhost
local UnitIsConnected = UnitIsConnected

--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: ALTERNATE_POWER_INDEX, DEAD, QuestDifficultyColors

local utf8sub = function(string, i, dots)
    local bytes = string:len()
    if (bytes <= i) then
        return string
    else
        local len, pos = 0, 1
        while(pos <= bytes) do
            len = len + 1
            local c = string:byte(pos)
            if c > 240 then
                pos = pos + 4
            elseif c > 225 then
                pos = pos + 3
            elseif c > 192 then
                pos = pos + 2
            else
                pos = pos + 1
            end
            if (len == i) then break end
        end

        if (len == i and pos <= bytes) then
            return string:sub(1, pos - 1)..(dots and "..." or "")
        else
            return string
        end
    end
end

local function hex(r, g, b)
    if not r then return "|cffFFFFFF" end

    if(type(r) == "table") then
        if(r.r) then r, g, b = r.r, r.g, r.b else r, g, b = unpack(r) end
    end
    return ("|cff%02x%02x%02x"):format(r * 255, g * 255, b * 255)
end

oUF.Tags.Methods["RayUF:lvl"] = function(u)
    local level = UnitLevel(u)
    local typ = UnitClassification(u)
    local diffColor = level > 0 and GetQuestDifficultyColor(level) or QuestDifficultyColors["impossible"]

    if level <= 0 then
        level = "??"
    end

    if typ=="rareelite" then
        return hex(diffColor)..level.."r+|r"
    elseif typ=="elite" then
        return hex(diffColor)..level.."+|r"
    elseif typ=="rare" then
        return hex(diffColor)..level.."r|r"
    else
        return hex(diffColor)..level.."|r"
    end
end

oUF.Tags.Methods["RayUF:hp"] = function(u)
    local color
    if UnitIsPlayer(u) then
        local _, class = UnitClass(u)
        color = oUF.colors.class[class]
    elseif UnitIsTapDenied(u) then
        color = oUF.colors.tapped
    elseif UnitIsEnemy(u, "player") then
        color = oUF.colors.reaction[1]
    else
        color = oUF.colors.reaction[UnitReaction(u, "player") or 5]
    end
    local min, max = UnitHealth(u), UnitHealthMax(u)
    -- return R:ShortValue(min).." | "..math.floor(min/max*100+.5).."%"
    return format("|cff%02x%02x%02x%s|r", color[1] * 255, color[2] * 255, color[3] * 255, R:ShortValue(min).." | "..math.floor(min/max*100+.5).."%")
end
oUF.Tags.Events["RayUF:hp"] = "UNIT_HEALTH"

oUF.Tags.Methods["RayUF:pp"] = function(u)
    local _, str = UnitPowerType(u)
    local power = UnitPower(u)

    if str and power > 0 then
        local min, max = UnitPower(u), UnitPowerMax(u)
        return hex(oUF.colors.power[str])..R:ShortValue(min).." | "..math.floor(min/max*100+.5).."%".."|r"
    end
end
oUF.Tags.Events["RayUF:pp"] = "UNIT_POWER"

oUF.Tags.Methods["RayUF:color"] = function(u, r)
    local _, class = UnitClass(u)
    local reaction = UnitReaction(u, "player")

    if UnitIsTapDenied(u) then
        return hex(oUF.colors.tapped)
    elseif (UnitIsPlayer(u)) then
        return hex(oUF.colors.class[class])
    elseif reaction then
        return hex(oUF.colors.reaction[reaction])
    else
        return hex(1, 1, 1)
    end
end
oUF.Tags.Events["RayUF:color"] = "UNIT_REACTION UNIT_HEALTH UNIT_HAPPINESS"

oUF.Tags.Methods["RayUF:name"] = function(u, r)
    local name = UnitName(r or u)
    return name
end
oUF.Tags.Events["RayUF:name"] = "UNIT_NAME_UPDATE"

oUF.Tags.Methods["RayUF:info"] = function(u)
    if UnitIsDead(u) then
        return oUF.Tags.Methods["RayUF:lvl"](u).."|cffCFCFCF "..DEAD.."|r"
    elseif UnitIsGhost(u) then
        return oUF.Tags.Methods["RayUF:lvl"](u).."|cffCFCFCF "..L["灵魂"].."|r"
    elseif not UnitIsConnected(u) then
        return oUF.Tags.Methods["RayUF:lvl"](u).."|cffCFCFCF "..L["离线"].."|r"
    else
        return oUF.Tags.Methods["RayUF:lvl"](u)
    end
end
oUF.Tags.Events["RayUF:info"] = "UNIT_HEALTH"

oUF.Tags.Methods["RayUF:altpower"] = function(u)
    local cur = UnitPower(u, ALTERNATE_POWER_INDEX)
    local max = UnitPowerMax(u, ALTERNATE_POWER_INDEX)
    local per = 0
    if max ~= 0 then
        per = floor(cur/max*100)
    end

    return format("%d", per > 0 and per or 0).."%"
end
oUF.Tags.Events["RayUF:altpower"] = "UNIT_POWER UNIT_MAXPOWER"
