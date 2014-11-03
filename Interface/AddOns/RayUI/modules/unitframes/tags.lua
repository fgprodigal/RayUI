local R, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local

local _, ns = ...
local oUF = RayUF or oUF

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
    local color = GetQuestDifficultyColor(level)

    if level <= 0 then
        level = "??" 
        color.r, color.g, color.b = 1, 0, 0
    end

    if typ=="rareelite" then
        return hex(color)..level.."r+|r"
    elseif typ=="elite" then
        return hex(color)..level.."+|r"
    elseif typ=="rare" then
        return hex(color)..level.."r|r"
    else
        return hex(color)..level.."|r"
    end
end

oUF.Tags.Methods["RayUF:hp"]  = function(u)
		local color
		if UnitIsPlayer(u) then
			local _, class = UnitClass(u)
			color = oUF.colors.class[class]
		elseif UnitIsTapped(u) and not UnitIsTappedByPlayer(u) then
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

    if (UnitIsTapped(u) and not UnitIsTappedByPlayer(u)) then
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
        return oUF.Tags.Methods["RayUF:lvl"](u).."|cffCFCFCF 死亡|r"
    elseif UnitIsGhost(u) then
        return oUF.Tags.Methods["RayUF:lvl"](u).."|cffCFCFCF 靈魂|r"
    elseif not UnitIsConnected(u) then
        return oUF.Tags.Methods["RayUF:lvl"](u).."|cffCFCFCF 離線|r"
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
