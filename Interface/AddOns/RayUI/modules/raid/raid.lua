local R, L, P, G = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, GlobalDB
local RA = R:NewModule("Raid", "AceEvent-3.0")

local _, ns = ...
local oUF = RayUF or oUF

--Cache global variables
--Lua functions
local _G = _G

--WoW API / Variables
local CreateFrame = CreateFrame
local SetMapToCurrentZone = SetMapToCurrentZone
local IsInInstance = IsInInstance
local GetCurrentMapAreaID = GetCurrentMapAreaID
local InCombatLockdown = InCombatLockdown
local CompactRaidFrameManager_GetSetting = CompactRaidFrameManager_GetSetting
local CompactRaidFrameManager_SetSetting = CompactRaidFrameManager_SetSetting
local CompactUnitFrame_UnregisterEvents = CompactUnitFrame_UnregisterEvents
local hooksecurefunc = hooksecurefunc

--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: UIParent, oUF_RaidDebuffs, CompactRaidFrameManager, CompactRaidFrameContainer

RA.modName = L["团队"]

local function RegisterDebuffs()
    SetMapToCurrentZone()
    local _, instanceType = IsInInstance()
    local zone = GetCurrentMapAreaID()
    local ORD = ns.oUF_RaidDebuffs or oUF_RaidDebuffs
    if ORD then
        ORD:ResetDebuffData()

        if instanceType == "party" or instanceType == "raid" then
            if G.Raid.RaidDebuffs.instances[zone] then
                ORD:RegisterDebuffs(G.Raid.RaidDebuffs.instances[zone])
            end
        end
    end
end

local function HideCompactRaid()
    if InCombatLockdown() then return end
    CompactRaidFrameManager:Kill()
    local compact_raid = CompactRaidFrameManager_GetSetting("IsShown")
    if compact_raid and compact_raid ~= "0" then
        CompactRaidFrameManager_SetSetting("IsShown", "0")
    end
end

function RA:HideBlizzard()
    hooksecurefunc("CompactRaidFrameManager_UpdateShown", HideCompactRaid)
    CompactRaidFrameManager:HookScript("OnShow", HideCompactRaid)
    CompactRaidFrameContainer:UnregisterAllEvents()

    HideCompactRaid()
    hooksecurefunc("CompactUnitFrame_RegisterEvents", CompactUnitFrame_UnregisterEvents)
end

function RA:Initialize()
    for i = 1, 4 do
        local frame = _G["PartyMemberFrame"..i]
        frame:UnregisterAllEvents()
        frame:Kill()

        local health = frame.healthbar
        if(health) then
            health:UnregisterAllEvents()
        end

        local power = frame.manabar
        if(power) then
            power:UnregisterAllEvents()
        end

        local spell = frame.spellbar
        if(spell) then
            spell:UnregisterAllEvents()
        end

        local altpowerbar = frame.powerBarAlt
        if(altpowerbar) then
            altpowerbar:UnregisterAllEvents()
        end
    end
    self:HideBlizzard()
    self:RegisterEvent("GROUP_ROSTER_UPDATE", "HideBlizzard")
    UIParent:UnregisterEvent("GROUP_ROSTER_UPDATE")

    self:SpawnRaid()
    RegisterDebuffs()
    local ORD = ns.oUF_RaidDebuffs or oUF_RaidDebuffs
    if ORD then
        ORD.MatchBySpellName = false
    end

    local event = CreateFrame("Frame")
    event:RegisterEvent("ZONE_CHANGED_NEW_AREA")
    event:RegisterEvent("PLAYER_ENTERING_WORLD")
    event:SetScript("OnEvent", RegisterDebuffs)
end

function RA:Info()
    return L["|cff7aa6d6Ray|r|cffff0000U|r|cff7aa6d6I|r团队模块."]
end

R:RegisterModule(RA:GetName())
