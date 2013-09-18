local R, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local RA = R:GetModule("Raid")

local oUF = RayUF or oUF

local foo = {""}
local spellcache = setmetatable({},
{__index=function(t,id)
	local a = {GetSpellInfo(id)}

	if GetSpellInfo(id) then
	    t[id] = a
	    return a
	end

	--print("Invalid spell ID: ", id)
    t[id] = foo
	return foo
end
})

local function GetSpellInfo(a)
    return unpack(spellcache[a])
end

local GetTime = GetTime

local numberize = function(val)
    if (val >= 1e6) then
        return ("%.1fm"):format(val / 1e6)
    elseif (val >= 1e3) then
        return ("%.1fk"):format(val / 1e3)
    else
        return ("%d"):format(val)
    end
end
RA.numberize = numberize

local x = "M"

local getTime = function(expirationTime)
    local expire = (expirationTime-GetTime())
    local timeleft = numberize(expire)
    if expire > 0.5 then
        return ("|cffffff00"..timeleft.."|r")
    end
end

-- Magic
oUF.Tags.Methods["RayUIRaid:magic"] = function(u)
    local index = 1
    while true do
        local name,_,_,_, dtype = UnitAura(u, index, "HARMFUL")
        if not name then break end

        if dtype == "Magic" then
            return RA.debuffColor[dtype]..x
        end

        index = index+1
    end
end
oUF.Tags.Events["RayUIRaid:magic"] = "UNIT_AURA"

-- Disease
oUF.Tags.Methods["RayUIRaid:disease"] = function(u)
    local index = 1
    while true do
        local name,_,_,_, dtype = UnitAura(u, index, "HARMFUL")
        if not name then break end

        if dtype == "Disease" then
            return RA.debuffColor[dtype]..x
        end

        index = index+1
    end
end
oUF.Tags.Events["RayUIRaid:disease"] = "UNIT_AURA"

-- Curse
oUF.Tags.Methods["RayUIRaid:curse"] = function(u)
    local index = 1
    while true do
        local name,_,_,_, dtype = UnitAura(u, index, "HARMFUL")
        if not name then break end

        if dtype == "Curse" then
            return RA.debuffColor[dtype]..x
        end

        index = index+1
    end
end
oUF.Tags.Events["RayUIRaid:curse"] = "UNIT_AURA"

-- Poison
oUF.Tags.Methods["RayUIRaid:poison"] = function(u)
    local index = 1
    while true do
        local name,_,_,_, dtype = UnitAura(u, index, "HARMFUL")
        if not name then break end

        if dtype == "Poison" then
            return RA.debuffColor[dtype]..x
        end

        index = index+1
    end
end
oUF.Tags.Events["RayUIRaid:poison"] = "UNIT_AURA"

-- Priest
local pomCount = {"i","h","g","f","Z","Y"}
oUF.Tags.Methods["RayUIRaid:pom"] = function(u)
    local name, _,_, c, _,_,_, fromwho = UnitAura(u, GetSpellInfo(33076))
    if name and c > 0 then
        if(fromwho == "player") then
            return "|cff66FFFF"..pomCount[c].."|r"
        else
            return "|cffFFCF7F"..pomCount[c].."|r"
        end
    end
end
oUF.Tags.Events["RayUIRaid:pom"] = "UNIT_AURA"

oUF.Tags.Methods["RayUIRaid:rnw"] = function(u)
    local name, _,_,_,_,_, expirationTime, fromwho = UnitAura(u, GetSpellInfo(139))
    if(fromwho == "player") then
        local spellTimer = GetTime()-expirationTime
        if spellTimer > -2 then
            return "|cffFF0000"..x.."|r"
        elseif spellTimer > -4 then
            return "|cffFF9900"..x.."|r"
        else
            return "|cff33FF33"..x.."|r"
        end
    end
end
oUF.Tags.Events["RayUIRaid:rnw"] = "UNIT_AURA"

oUF.Tags.Methods["RayUIRaid:rnwTime"] = function(u)
    local name, _,_,_,_,_, expirationTime, fromwho = UnitAura(u, GetSpellInfo(139))
    if(fromwho == "player") then return getTime(expirationTime) end
end
oUF.Tags.Events["RayUIRaid:rnwTime"] = "UNIT_AURA"

oUF.Tags.Methods["RayUIRaid:pws"] = function(u) if UnitAura(u, GetSpellInfo(17)) then return "|cff33FF33"..x.."|r" end end
oUF.Tags.Events["RayUIRaid:pws"] = "UNIT_AURA"

oUF.Tags.Methods["RayUIRaid:ws"] = function(u) if UnitDebuff(u, GetSpellInfo(6788)) then return "|cffFF9900"..x.."|r" end end
oUF.Tags.Events["RayUIRaid:ws"] = "UNIT_AURA"

oUF.Tags.Methods["RayUIRaid:fw"] = function(u) if UnitAura(u, GetSpellInfo(6346)) then return "|cff8B4513"..x.."|r" end end
oUF.Tags.Events["RayUIRaid:fw"] = "UNIT_AURA"

oUF.Tags.Methods["RayUIRaid:fort"] = function(u) if not(UnitAura(u, GetSpellInfo(21562)) or UnitAura(u, GetSpellInfo(90364)) or UnitAura(u, GetSpellInfo(469)) or UnitAura(u, GetSpellInfo(109773))) then return "|cff00A1DE"..x.."|r" end end
oUF.Tags.Events["RayUIRaid:fort"] = "UNIT_AURA"

oUF.Tags.Methods["RayUIRaid:pwb"] = function(u) if UnitAura(u, GetSpellInfo(81782)) then return "|cffEEEE00"..x.."|r" end end
oUF.Tags.Events["RayUIRaid:pwb"] = "UNIT_AURA"

-- Druid
local lbCount = { 4, 2, 3}
oUF.Tags.Methods["RayUIRaid:lb"] = function(u)
    local name, _,_, c,_,_, expirationTime, fromwho = UnitAura(u, GetSpellInfo(33763))
    if(fromwho == "player") then
        local spellTimer = GetTime()-expirationTime
        if spellTimer > -2 then
            return "|cffFF0000"..lbCount[c].."|r"
        elseif spellTimer > -4 then
            return "|cffFF9900"..lbCount[c].."|r"
        else
            return "|cffA7FD0A"..lbCount[c].."|r"
        end
    end
end
oUF.Tags.Events["RayUIRaid:lb"] = "UNIT_AURA"

oUF.Tags.Methods["RayUIRaid:rejuv"] = function(u)
    local name, _,_,_,_,_, expirationTime, fromwho = UnitAura(u, GetSpellInfo(774))
    if(fromwho == "player") then
        local spellTimer = GetTime()-expirationTime
        if spellTimer > -2 then
            return "|cffFF0000"..x.."|r"
        elseif spellTimer > -4 then
            return "|cffFF9900"..x.."|r"
        else
            return "|cff33FF33"..x.."|r"
        end
    end
end
oUF.Tags.Events["RayUIRaid:rejuv"] = "UNIT_AURA"

oUF.Tags.Methods["RayUIRaid:rejuvTime"] = function(u)
    local name, _,_,_,_,_, expirationTime, fromwho = UnitAura(u, GetSpellInfo(774))
    if(fromwho == "player") then return getTime(expirationTime) end
end
oUF.Tags.Events["RayUIRaid:rejuvTime"] = "UNIT_AURA"

oUF.Tags.Methods["RayUIRaid:regrow"] = function(u) if UnitAura(u, GetSpellInfo(8936)) then return "|cff00FF10"..x.."|r" end end
oUF.Tags.Events["RayUIRaid:regrow"] = "UNIT_AURA"

oUF.Tags.Methods["RayUIRaid:wg"] = function(u) if UnitAura(u, GetSpellInfo(48438)) then return "|cff33FF33"..x.."|r" end end
oUF.Tags.Events["RayUIRaid:wg"] = "UNIT_AURA"

oUF.Tags.Methods["RayUIRaid:motw"] = function(u) if not(UnitAura(u, GetSpellInfo(20217)) or UnitAura(u,GetSpellInfo(1126))  or UnitAura(u,GetSpellInfo(117666))) then return "|cff00A1DE"..x.."|r" end end
oUF.Tags.Events["RayUIRaid:motw"] = "UNIT_AURA"

-- Warrior
oUF.Tags.Methods["RayUIRaid:stragi"] = function(u) if not(UnitAura(u, GetSpellInfo(6673)) or UnitAura(u, GetSpellInfo(57330)) or UnitAura(u, GetSpellInfo(8076))) then return "|cffFF0000"..x.."|r" end end
oUF.Tags.Events["RayUIRaid:stragi"] = "UNIT_AURA"

oUF.Tags.Methods["RayUIRaid:vigil"] = function(u) if UnitAura(u, GetSpellInfo(50720)) then return "|cff8B4513"..x.."|r" end end
oUF.Tags.Events["RayUIRaid:vigil"] = "UNIT_AURA"

-- Shaman
oUF.Tags.Methods["RayUIRaid:rip"] = function(u)
    local name, _,_,_,_,_,_, fromwho = UnitAura(u, GetSpellInfo(61295))
    if(fromwho == "player") then return "|cff00FEBF"..x.."|r" end
end
oUF.Tags.Events["RayUIRaid:rip"] = "UNIT_AURA"

oUF.Tags.Methods["RayUIRaid:ripTime"] = function(u)
    local name, _,_,_,_,_, expirationTime, fromwho = UnitAura(u, GetSpellInfo(61295))
    if(fromwho == "player") then return getTime(expirationTime) end
end
oUF.Tags.Events["RayUIRaid:ripTime"] = "UNIT_AURA"

local earthCount = {"i","h","g","f","p","q","Z","Z","Y"}
oUF.Tags.Methods["RayUIRaid:earth"] = function(u)
    local c = select(4, UnitAura(u, GetSpellInfo(974))) if c then return "|cffFFCF7F"..earthCount[c].."|r" end
end
oUF.Tags.Events["RayUIRaid:earth"] = "UNIT_AURA"

-- Paladin
oUF.Tags.Methods["RayUIRaid:might"] = function(u) if not(UnitAura(u, GetSpellInfo(19740))) then return "|cffFF0000"..x.."|r" end end
oUF.Tags.Events["RayUIRaid:might"] = "UNIT_AURA"

oUF.Tags.Methods["RayUIRaid:beacon"] = function(u)
    local name, _,_,_,_,_,_, fromwho = UnitAura(u, GetSpellInfo(53563))
    if not name then return end
    if(fromwho == "player") then
        return "|cffFFCC003|r"
    else
        return "|cff996600Y|r" -- other pally's beacon
    end
end
oUF.Tags.Events["RayUIRaid:beacon"] = "UNIT_AURA"

oUF.Tags.Methods["RayUIRaid:forbearance"] = function(u) if UnitDebuff(u, GetSpellInfo(25771)) then return "|cffFF9900"..x.."|r" end end
oUF.Tags.Events["RayUIRaid:forbearance"] = "UNIT_AURA"

-- Warlock
oUF.Tags.Methods["RayUIRaid:di"] = function(u)
	if not ((UnitAura(u, GetSpellInfo(21562)) or UnitAura(u, GetSpellInfo(6307)) or UnitAura(u, GetSpellInfo(469)) or UnitAura(u, GetSpellInfo(109773)))
			and (UnitAura(u, GetSpellInfo(1459)) or UnitAura(u, GetSpellInfo(61316))))
			and not UnitAura(u, GetSpellInfo(109773)) then
			return "|cffCC00FF"..x.."|r"
	end
end
oUF.Tags.Events["RayUIRaid:di"] = "UNIT_AURA"

oUF.Tags.Methods["RayUIRaid:ss"] = function(u)
    local name, _,_,_,_,_,_, fromwho = UnitAura(u, GetSpellInfo(20707))
    if fromwho == "player" then
        return "|cff6600FFY|r"
    elseif name then
        return "|cffCC00FFY|r"
    end
end
oUF.Tags.Events["RayUIRaid:ss"] = "UNIT_AURA"

-- Mage
oUF.Tags.Methods["RayUIRaid:int"] = function(u) if not(UnitAura(u, GetSpellInfo(1459)) or UnitAura(u, GetSpellInfo(61316)) or UnitAura(u, GetSpellInfo(116781))) then return "|cff00A1DE"..x.."|r" end end
oUF.Tags.Events["RayUIRaid:int"] = "UNIT_AURA"

oUF.Tags.Methods["RayUIRaid:fmagic"] = function(u) if UnitAura(u, GetSpellInfo(54648)) then return "|cffCC00FF"..x.."|r" end end
oUF.Tags.Events["RayUIRaid:fmagic"] = "UNIT_AURA"

--Monk
oUF.Tags.Methods["RayUIRaid:rm"] = function(u) if UnitAura(u, GetSpellInfo(115151)) then return "|cff33FF33"..x.."|r" end end
oUF.Tags.Events["RayUIRaid:rm"] = "UNIT_AURA"

RA.classIndicators={
    ["DRUID"] = {
        ["TL"] = "",
        ["TR"] = "[RayUIRaid:motw]",
        ["BL"] = "[RayUIRaid:regrow][RayUIRaid:wg]",
        ["BR"] = "[RayUIRaid:lb]",
        ["Cen"] = "[RayUIRaid:rejuvTime]",
    },
    ["PRIEST"] = {
        ["TL"] = "[RayUIRaid:pws][RayUIRaid:ws]",
        ["TR"] = "[RayUIRaid:fw][RayUIRaid:fort]",
        ["BL"] = "[RayUIRaid:rnw][RayUIRaid:pwb]",
        ["BR"] = "[RayUIRaid:pom]",
        ["Cen"] = "[RayUIRaid:rnwTime]",
    },
    ["PALADIN"] = {
        ["TL"] = "[RayUIRaid:forbearance]",
        ["TR"] = "[RayUIRaid:might][RayUIRaid:motw]",
        ["BL"] = "",
        ["BR"] = "[RayUIRaid:beacon]",
        ["Cen"] = "",
    },
    ["WARLOCK"] = {
        ["TL"] = "",
        ["TR"] = "[RayUIRaid:di]",
        ["BL"] = "",
        ["BR"] = "[RayUIRaid:ss]",
        ["Cen"] = "",
    },
    ["WARRIOR"] = {
        ["TL"] = "[RayUIRaid:vigil]",
        ["TR"] = "[RayUIRaid:stragi][RayUIRaid:fort]",
        ["BL"] = "",
        ["BR"] = "",
        ["Cen"] = "",
    },
    ["DEATHKNIGHT"] = {
        ["TL"] = "",
        ["TR"] = "",
        ["BL"] = "",
        ["BR"] = "",
        ["Cen"] = "",
    },
    ["SHAMAN"] = {
        ["TL"] = "[RayUIRaid:rip]",
        ["TR"] = "",
        ["BL"] = "",
        ["BR"] = "[RayUIRaid:earth]",
        ["Cen"] = "[RayUIRaid:ripTime]",
    },
    ["HUNTER"] = {
        ["TL"] = "",
        ["TR"] = "",
        ["BL"] = "",
        ["BR"] = "",
        ["Cen"] = "",
    },
    ["ROGUE"] = {
        ["TL"] = "",
        ["TR"] = "",
        ["BL"] = "",
        ["BR"] = "",
        ["Cen"] = "",
    },
    ["MONK"] = {
        ["TL"] = "",
        ["TR"] = "[RayUIRaid:motw]",
        ["BL"] = "",
        ["BR"] = "",
        ["Cen"] = "",
    },
    ["MAGE"] = {
        ["TL"] = "",
        ["TR"] = "[RayUIRaid:int]",
        ["BL"] = "",
        ["BR"] = "",
        ["Cen"] = "",
    }
}
