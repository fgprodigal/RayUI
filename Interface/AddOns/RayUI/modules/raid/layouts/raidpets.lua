local R, L, P, G = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, GlobalDB
local RA = R:GetModule("Raid")
local UF = R:GetModule("UnitFrames")

local _, ns = ...
local RayUF = ns.oUF

--Cache global variables
--Lua functions
local type, unpack, table = type, unpack, table

--WoW API / Variables
local CreateFrame = CreateFrame
local InCombatLockdown = InCombatLockdown
local IsInInstance = IsInInstance
local GetInstanceInfo = GetInstanceInfo
local RegisterStateDriver = RegisterStateDriver
local UnregisterStateDriver = UnregisterStateDriver

function RA:FetchRaidPetsSettings()
    self.groupConfig.raidPets = {
		width = self.db.petwidth,
		height = self.db.petheight,
		visibility = "[group:raid] show;hide",
		numGroups = 2,
		defaultPosition = { "BOTTOMLEFT", R.UIParent, "BOTTOMLEFT", 15, 685 },
		label = "P",
    }
end

function RA:Construct_RaidPetsFrames()
    if not RA.db.showPets then return end

    self.RaisedElementParent = CreateFrame("Frame", nil, self)
    self.RaisedElementParent:SetFrameLevel(self:GetFrameLevel() + 100)
    self.FrameBorder = RA:Construct_FrameBorder(self)
    self.Health = RA:Construct_HealthBar(self)
    self.Name = RA:Construct_NameText(self)
    self.Threat = RA:Construct_Threat(self)
    self.Highlight = RA:Construct_Highlight(self)
    self.RaidIcon = RA:Construct_RaidIcon(self)
    self.RaidDebuffs = RA:Construct_RaidDebuffs(self)
    self.AuraWatch = RA:Construct_AuraWatch(self)

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

function RA:RaidPetsSmartVisibility(event)
    local inInstance, instanceType = IsInInstance()
    if event == "PLAYER_REGEN_ENABLED" then self:UnregisterEvent("PLAYER_REGEN_ENABLED") end
    if not InCombatLockdown() then
        if inInstance and instanceType == "raid" then
            UnregisterStateDriver(self, "state-visibility")
            self:Show()
        else
            RegisterStateDriver(self, "visibility", RA.groupConfig.raid.visibility)
        end
    else
        self:RegisterEvent("PLAYER_REGEN_ENABLED")
        return
    end
end

RA["headerstoload"]["raidPets"] = { nil, "SecureGroupPetHeaderTemplate" }
