----------------------------------------------------------
-- Load RayUI Environment
----------------------------------------------------------
RayUI:LoadEnv("Raid")


local RA = _Raid
local UF = R.UnitFrames

local _, ns = ...
local RayUF = ns.oUF

function RA:FetchRaidTankSettings()
    _GroupConfig.raidTank = {
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
    self.Health = RA:Construct_HealthBar(self)
    self.Name = RA:Construct_NameText(self)
    self.ThreatIndicator = RA:Construct_Threat(self)
    self.Highlight = RA:Construct_Highlight(self)
    self.RaidTargetIndicator = RA:Construct_RaidIcon(self)
    self.RaidDebuffs = RA:Construct_RaidDebuffs(self)
    self.AuraWatch = RA:Construct_AuraWatch(self)
    self.AFKtext = RA:Construct_AFKText(self)
    if RA.db.roleicon then
        self.GroupRoleIndicator = RA:Construct_RoleIcon(self)
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

    self:RegisterEvent("PLAYER_TARGET_CHANGED", RA.UpdateTargetBorder)
    self:RegisterEvent("GROUP_ROSTER_UPDATE", RA.UpdateTargetBorder)
end

_HeadersToLoad["raidTank"] = { "MAINTANK", nil }
