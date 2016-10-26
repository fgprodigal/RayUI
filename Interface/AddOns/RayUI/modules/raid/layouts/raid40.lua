local R, L, P, G = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, GlobalDB
local RA = R:GetModule("Raid")
local UF = R:GetModule("UnitFrames")

local oUF = RayUF or oUF

--Cache global variables
--Lua functions
local type, unpack, table = type, unpack, table
local tinsert = table.insert
local upper = string.upper

--WoW API / Variables
local CreateFrame = CreateFrame
local InCombatLockdown = InCombatLockdown
local IsInInstance = IsInInstance
local GetInstanceInfo = GetInstanceInfo
local RegisterStateDriver = RegisterStateDriver
local UnregisterStateDriver = UnregisterStateDriver

--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: RayUF

function RA:FetchRaid40Settings()
    self.groupConfig.raid40 = {
        width = self.db.raid40width,
        height = self.db.raid40height,
        visibility = "[@raid26,exists] show;hide",
        numGroups = 8,
        defaultPosition = { "BOTTOMLEFT", R.UIParent, "BOTTOMLEFT", 15, 235 },
    }
end

function RA:Construct_Raid40Frames()
    self.RaisedElementParent = CreateFrame("Frame", nil, self)
    self.RaisedElementParent:SetFrameLevel(self:GetFrameLevel() + 100)
    self.FrameBorder = RA:Construct_FrameBorder(self)
    self.Health = RA:Construct_HealthBar(self)
    self.Power = RA:Construct_PowerBar(self)
    self.Name = RA:Construct_NameText(self)
    self.Threat = RA:Construct_Threat(self)
    self.Healtext = RA:Construct_HealthText(self)
    self.Highlight = RA:Construct_Highlight(self)
    self.RaidIcon = RA:Construct_RaidIcon(self)
    self.ResurrectIcon = RA:Construct_ResurectionIcon(self)
    self.ReadyCheck = RA:Construct_ReadyCheck(self)
    self.RaidDebuffs = RA:Construct_RaidDebuffs(self)
    self.AuraWatch = RA:Construct_AuraWatch(self)
    self.RaidRoleFramesAnchor = RA:Construct_RaidRoleFrames(self)
    if RA.db.roleicon then
        self.LFDRole = RA:Construct_RoleIcon(self)
    end
    self.RayUFAfk = true
    local range = {
        insideAlpha = 1,
        outsideAlpha = RA.db.outsideRange,
    }
    self.RayUFRange = RA.db.arrow and range
    self.Range = range

    RA:ConfigureAuraWatch(self)
    UF:EnableHealPredictionAndAbsorb(self)

    self:RegisterForClicks("AnyUp")
    self:SetScript("OnEnter", RA.UnitFrame_OnEnter)
    self:SetScript("OnLeave", RA.UnitFrame_OnLeave)
end

function RA:Raid40SmartVisibility(event)
    local inInstance, instanceType = IsInInstance()
    local _, _, _, _, maxPlayers, _, _, mapID, instanceGroupSize = GetInstanceInfo()
    if event == "PLAYER_REGEN_ENABLED" then self:UnregisterEvent("PLAYER_REGEN_ENABLED") end
    if RA.mapIDs[mapID] then
        maxPlayers = RA.mapIDs[mapID]
    end
    if not InCombatLockdown() then
        if(inInstance and (instanceType == "raid" or instanceType == "pvp")) then
            if RA.mapIDs[mapID] then
                maxPlayers = RA.mapIDs[mapID]
            end
            UnregisterStateDriver(self, "visibility")
            if maxPlayers == 40 then
                self:Show()
            else
                self:Hide()
            end
        else
            RegisterStateDriver(self, "visibility", RA.groupConfig.raid40.visibility)
        end
    else
        self:RegisterEvent("PLAYER_REGEN_ENABLED")
        return
    end
end

RA["headerstoload"]["raid40"] = { nil, nil }
