local R, L, P, G = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, GlobalDB
local UF = R:NewModule("UnitFrames", "AceEvent-3.0", "AceTimer-3.0")
local oUF = RayUF or oUF

UF.modName = L["头像"]

UF.Layouts = {}

UF["classMaxResourceBar"] = {
    ["DEATHKNIGHT"] = 6,
    ["PALADIN"] = 5,
    ["WARLOCK"] = 5,
    ["MONK"] = 6,
    ["MAGE"] = 4,
    ["ROGUE"] = 8,
    ["DRUID"] = 5
}

function UF:Initialize()
    self:LoadUnitFrames()
end

function UF:Info()
    return L["|cff7aa6d6Ray|r|cffff0000U|r|cff7aa6d6I|r头像模块."]
end

R:RegisterModule(UF:GetName())
