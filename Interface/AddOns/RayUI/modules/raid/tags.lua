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

-- 10%耐力
oUF.Tags.Methods["RayUIRaid:fort"] = function(u)
	if not (
		-- 真言術：韌
		UnitAura(u, GetSpellInfo(21562))
		-- 血之契印
		or UnitAura(u, GetSpellInfo(166928))
		-- 命令怒吼
		or UnitAura(u, GetSpellInfo(469))
		-- pet 野性活力
		or UnitAura(u, GetSpellInfo(160003))
		-- pet 鼓舞咆哮
		or UnitAura(u, GetSpellInfo(50256))
		-- pet 堅忍不拔
		or UnitAura(u, GetSpellInfo(160014))
		-- pet 其拉堅韌（獸王）
		or UnitAura(u, GetSpellInfo(90364))
		-- 孤狼：熊之堅韌
		or UnitAura(u, GetSpellInfo(160199))) then
		return "|cff00A1DE"..x.."|r"
	end
end
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

-- 5%屬性
oUF.Tags.Methods["RayUIRaid:motw"] = function(u)
	if not (
		-- 野性印記
		UnitAura(u, GetSpellInfo(1126))
		-- 御傳心法（織霧）
		or UnitAura(u,GetSpellInfo(115921))
		-- 雪怒心法（釀酒、禦風）
		or UnitAura(u,GetSpellInfo(116781)) 
		-- 王者祝福
		or UnitAura(u,GetSpellInfo(20217)) 
		-- pet 狂野怒吼
		or UnitAura(u,GetSpellInfo(159988)) 
		-- pet 金剛的祝福
		or UnitAura(u,GetSpellInfo(160017)) 
		-- pet 岩蛛之擁（獸王）
		or UnitAura(u,GetSpellInfo(90363)) 
		-- pet 大地之力（獸王）
		or UnitAura(u,GetSpellInfo(160077)) 
		-- 孤狼：猿之神力
		or UnitAura(u,GetSpellInfo(160206))) then
		return "|cff00A1DE"..x.."|r"
	end
end
oUF.Tags.Events["RayUIRaid:motw"] = "UNIT_AURA"

-- Warrior
-- 10%攻強
oUF.Tags.Methods["RayUIRaid:stragi"] = function(u)
	if not (
		-- 凜冬號角
		UnitAura(u, GetSpellInfo(57330))
		-- 強擊光環
		or UnitAura(u, GetSpellInfo(19506))
		-- 戰鬥怒吼
		or UnitAura(u, GetSpellInfo(6673))) then
		return "|cffFF0000"..x.."|r"
	end
end
oUF.Tags.Events["RayUIRaid:stragi"] = "UNIT_AURA"

oUF.Tags.Methods["RayUIRaid:vigil"] = function(u) if UnitAura(u, GetSpellInfo(114030)) then return "|cff8B4513"..x.."|r" end end
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
-- 精通
oUF.Tags.Methods["RayUIRaid:might"] = function(u)
	if not (
		-- 墳塚之力
		UnitAura(u, GetSpellInfo(155522))
		-- 梟獸光環
		or UnitAura(u, GetSpellInfo(24907))
		-- 力量祝福
		or UnitAura(u, GetSpellInfo(19740))
		-- 風之優雅
		or UnitAura(u, GetSpellInfo(116956))
		-- pet 激勵咆哮
		or UnitAura(u, GetSpellInfo(93435))
		-- pet 敏銳感官
		or UnitAura(u, GetSpellInfo(160039))
		-- pet 靈獸祝福（獸王）
		or UnitAura(u, GetSpellInfo(128997))
		-- pet 如履平地
		or UnitAura(u, GetSpellInfo(160073))
		-- 孤狼：貓之優雅
		or UnitAura(u, GetSpellInfo(160198))) then
		return "|cffFF0000"..x.."|r"
	end
end
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
-- 黑暗意圖
oUF.Tags.Methods["RayUIRaid:di"] = function(u)
	if not (
		(
			-- 10%法能
			-- 秘法光輝
			UnitAura(u, GetSpellInfo(1459))
			-- 達拉然光輝
			or UnitAura(u, GetSpellInfo(61316))
			-- pet 其拉堅韌（獸王）
			or UnitAura(u, GetSpellInfo(90364))
			-- pet 平靜如水（獸王）
			or UnitAura(u, GetSpellInfo(126309))
			-- pet 蛇之迅捷
			or UnitAura(u, GetSpellInfo(128433))
			-- 孤狼：蛇之靈智
			or UnitAura(u, GetSpellInfo(160205)))
		and (
			-- 5%雙擊
			-- 強風吹拂
			UnitAura(u, GetSpellInfo(166916))
			-- 思維敏捷
			or UnitAura(u, GetSpellInfo(49868))
			-- pet 迅刃靈巧
			or UnitAura(u, GetSpellInfo(113742))
			-- pet 音波集中
			or UnitAura(u, GetSpellInfo(50519))
			-- pet 雙重性
			or UnitAura(u, GetSpellInfo(159736))
			-- pet 雙頭狂咬（獸王）
			or UnitAura(u, GetSpellInfo(58604))
			-- pet 輕巧攻擊
			or UnitAura(u, GetSpellInfo(34889))
			-- pet 野性力量
			or UnitAura(u, GetSpellInfo(57386))
			-- pet 強風吐息
			or UnitAura(u, GetSpellInfo(24844)))
		)
		and not 
			-- 黑暗意圖
			UnitAura(u, GetSpellInfo(109773)) then
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
-- 秘法光輝/達拉然光輝
oUF.Tags.Methods["RayUIRaid:int"] = function(u)
	if not (
		(
			-- 10%法能
			-- 黑暗意圖
			UnitAura(u, GetSpellInfo(109773))
			-- pet 其拉堅韌（獸王）
			or UnitAura(u, GetSpellInfo(90364))
			-- pet 蛇之迅捷
			or UnitAura(u, GetSpellInfo(128433))
			-- 孤狼：蛇之靈智
			or UnitAura(u, GetSpellInfo(160205)))
		and (
			-- 5%爆擊
			-- 獸群領袖
			UnitAura(u, GetSpellInfo(17007))
			-- 雪怒心法
			or UnitAura(u, GetSpellInfo(116781))
			-- pet 恐嚇咆哮（獸王）
			or UnitAura(u, GetSpellInfo(90309))
			-- pet 無懼咆哮（獸王）
			or UnitAura(u, GetSpellInfo(126373))
			-- pet 獸群之力
			or UnitAura(u, GetSpellInfo(160052))
			-- pet 岩蛛之擁（獸王）
			or UnitAura(u, GetSpellInfo(90363))
			-- pet 狂怒之嚎
			or UnitAura(u, GetSpellInfo(24604))
			-- 孤狼：迅猛龍之殘暴
			or UnitAura(u, GetSpellInfo(160200)))
		)
		and not (
			-- 秘法光輝
			UnitAura(u, GetSpellInfo(1459))
			-- 達拉然光輝
			or UnitAura(u, GetSpellInfo(61316))
			-- pet 平靜如水（獸王）
			or UnitAura(u, GetSpellInfo(126309))) then
		return "|cff00A1DE"..x.."|r"
	end
end
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
        ["TR"] = "[RayUIRaid:stragi]",
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
