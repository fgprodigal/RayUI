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

function RA:FetchRaidTankSettings()
    self.groupConfig.raidTank = {
        enable = self.db.showTank,
        width = self.db.tankwidth,
        height = self.db.tankheight,
        visibility = "[@raid1,exists] show;hide",
        defaultPosition = { "BOTTOMLEFT", R.UIParent, "BOTTOMLEFT", 15, 635 },
        label = "T",
    }
end

function RA:Construct_RaidTankFrames()
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
    self.AFKtext = RA:Construct_AFKText(self)
    if RA.db.roleicon then
        self.LFDRole = RA:Construct_RoleIcon(self)
    end
    self.Range = {
        insideAlpha = 1,
        outsideAlpha = RA.db.outsideRange,
    }

    RA:ConfigureAuraWatch(self)
    UF:EnableHealPredictionAndAbsorb(self)

    self:RegisterForClicks("AnyUp")
    self:SetScript("OnEnter", RA.UnitFrame_OnEnter)
    self:SetScript("OnLeave", RA.UnitFrame_OnLeave)
    RA:SecureHook(self, "UpdateAllElements", RA.UnitFrame_OnShow)
    self:SetScript("OnHide", RA.UnitFrame_OnHide)
end

RA["headerstoload"]["raidTank"] = { "MAINTANK", nil }
