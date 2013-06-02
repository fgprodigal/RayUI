local R, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local RA = R:GetModule("Raid")

local oUF = RayUF or oUF

local numberize = RA.numberize
local colorCache = RA.colorCache

oUF.Tags.Methods['RayUIRaid:altpower'] = function(u)
	local cur = UnitPower(u, ALTERNATE_POWER_INDEX)
    if cur > 0 then
	    local max = UnitPowerMax(u, ALTERNATE_POWER_INDEX)
        local per = floor(cur/max*100)

        local tPath, r, g, b = UnitAlternatePowerTextureInfo(u, 2)
    
        if not r then
            r, g, b = 1, 1, 1
        end

        return RA:Hex(r,g,b)..format("%d", per).."|r"
    end
end
oUF.Tags.Events['RayUIRaid:altpower'] = "UNIT_POWER UNIT_MAXPOWER"

oUF.Tags.Methods['RayUIRaid:def'] = function(u)
    if UnitIsAFK(u) then
        return "|cffCFCFCFAFK|r"
    elseif UnitIsDead(u) then
        return "|cffCFCFCFDead|r"
    elseif UnitIsGhost(u) then
        return "|cffCFCFCFGhost|r"
    elseif not UnitIsConnected(u) then
        return "|cffCFCFCFD/C|r"
    end

    if RA.db.perc then
        local perc = oUF.Tags.Methods['perhp'](u)
        if perc < 90 then
            local _, class = UnitClass(u)
            local color = colorCache[class]

            return color..perc.."%|r"
        end
    elseif RA.db.deficit or RA.db.actual then
        local cur = UnitHealth(u)
        local max = UnitHealthMax(u)
        local per = cur/max

        if per < 0.9 then
            local _, class = UnitClass(u)
            local color = colorCache[class]
            if color then
                return color..(RA.db.deficit and "-"..numberize(max-cur) or numberize(cur)).."|r"
            end
        end
    end 
end
oUF.Tags.Events['RayUIRaid:def'] = 'UNIT_MAXHEALTH UNIT_HEALTH UNIT_HEALTH_FREQUENT UNIT_CONNECTION PLAYER_FLAGS_CHANGED '..oUF.Tags.Events['RayUIRaid:altpower']

oUF.Tags.Methods['RayUIRaid:heals'] = function(u)
    local incheal = UnitGetIncomingHeals(u) or 0
    if incheal > 0 then
        return "|cff00FF00"..numberize(incheal).."|r"
    else
        local def = oUF.Tags.Methods['RayUIRaid:def'](u)
        return def
    end
end
oUF.Tags.Events['RayUIRaid:heals'] = 'UNIT_HEAL_PREDICTION '..oUF.Tags.Events['RayUIRaid:def']

oUF.Tags.Methods['RayUIRaid:othersheals'] = function(u)
    local incheal = UnitGetIncomingHeals(u) or 0
    local player = UnitGetIncomingHeals(u, "player") or 0

    incheal = incheal - player

    if incheal > 0 then
        return "|cff00FF00"..numberize(incheal).."|r"
    else
        local def = oUF.Tags.Methods['RayUIRaid:def'](u)
        return def
    end
end
oUF.Tags.Events['RayUIRaid:othersheals'] = oUF.Tags.Events['RayUIRaid:heals']