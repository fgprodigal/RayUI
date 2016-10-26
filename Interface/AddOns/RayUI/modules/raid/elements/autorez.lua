local R, L, P, G = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, GlobalDB
local RA = R:GetModule("Raid")

local _, ns = ...
local RayUF = ns.oUF

--Cache global variables
--Lua functions
--WoW API / Variables
local GetSpellInfo = GetSpellInfo
local UnitClass = UnitClass
local IsAddOnLoaded = IsAddOnLoaded

local classList = {
    ["DRUID"] = {
        combat = GetSpellInfo(20484), -- Rebirth
        ooc = GetSpellInfo(50769), -- Revive
    },

    ["WARLOCK"] = {
        combat = GetSpellInfo(20707), -- Soulstone
        ooc = GetSpellInfo(20707), -- Soulstone
    },

    ["PRIEST"] = {
        ooc = GetSpellInfo(2006), -- Resurrection
    },

    ["SHAMAN"] = {
        ooc = GetSpellInfo(2008), -- Ancestral Spirit
    },

    ["PALADIN"] = {
        ooc = GetSpellInfo(7328), -- Redemption
    },

    ["DEATHKNIGHT"] = {
        combat = GetSpellInfo(61999), -- Raise Ally
    },

    ["MONK"] = {
        ooc = GetSpellInfo(115178), -- Resuscitate
    },
}

local body = ""
local function macroBody(class)
    local combatspell = classList[class].combat
    local oocspell = classList[class].ooc

    body = "/stopmacro [nodead,@mouseover]\n"
    if combatspell then
        body = body .. "/cast [combat,help,dead,@mouseover] " .. combatspell .. "; "

        if oocspell then
            body = body .. "[help,dead,@mouseover] " .. oocspell .. "; "
        end
    elseif oocspell then
        body = body .. "/cast [help,dead,@mouseover] " .. oocspell .. "; "
    end

    return body
end

local function macroBody2()
    return "/stopmacro [dead,@mouseover]\n/cast [help,nodead,@mouseover]"..GetSpellInfo(53563)
end

local function macroBody3()
    return "/stopmacro [dead,@mouseover]\n/cast [help,nodead,@mouseover]"..GetSpellInfo(6940)
end

local Enable = function(self)
    local _, class = UnitClass("player")
    if not class or not RA.db.autorez then return end

    if classList[class] and not IsAddOnLoaded("Clique") then
        self:SetAttribute("type3", "macro")
        self:SetAttribute("macrotext3", macroBody(class))
        if R.myname == "Divineseraph" and R.myclass =="PALADIN" then
            self:SetAttribute("alt-type3", "macro")
            self:SetAttribute("alt-macrotext3", macroBody2())
            self:SetAttribute("ctrl-type3", "macro")
            self:SetAttribute("ctrl-macrotext3", macroBody3())
        end
    end
end

local Disable = function(self)
    if RA.db.autorez then return end

    self:SetAttribute("*type3", nil)
end

RayUF:AddElement("RayUFAutoRez", nil, Enable, Disable)
