----------------------------------------------------------
-- Load RayUI Environment
----------------------------------------------------------
RayUI:LoadEnv("Raid")


local RA = _Raid

local _, ns = ...
local RayUF = ns.oUF


RayUF.Tags.Methods["RayUFRaid:name"] = function(u, r)
    local name = UnitName(u)
    local _, class = UnitClass(u)
    local unitReaction = UnitReaction(u, "player")
    local colorString

    if name == UNKNOWN and R.myclass == "MONK" and UnitIsUnit(u, "pet") then
		name = UNITNAME_SUMMON_TITLE17:format(UnitName("player"))
	end

    if (UnitIsPlayer(u)) then
        local class = RayUF.colors.class[class]
        if not class then return "" end
        colorString = R:RGBToHex(class[1], class[2], class[3])
    elseif (unitReaction) then
        local reaction = RayUF["colors"].reaction[unitReaction]
        colorString = R:RGBToHex(reaction[1], reaction[2], reaction[3])
    else
        colorString = "|cFFC2C2C2"
    end

    return colorString..R:ShortenString(name, 8)
end
RayUF.Tags.Events["RayUFRaid:name"] = "UNIT_NAME_UPDATE"

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
            local color = _ColorCache[class]

            return color..perc.."%|r"
        end
    elseif RA.db.deficit or RA.db.actual then
        local cur = UnitHealth(u)
        local max = UnitHealthMax(u)
        local per = cur/max

        if per < 0.9 then
            local _, class = UnitClass(u)
            local color = _ColorCache[class]
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
    if name == UNKNOWN and R.myclass == "MONK" and UnitIsUnit(u, "pet") then
		name = UNITNAME_SUMMON_TITLE17:format(UnitName("player"))
	end
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
