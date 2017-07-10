----------------------------------------------------------
-- Load RayUI Environment
----------------------------------------------------------
RayUI:LoadEnv("Raid")


local RA = _Raid
local UF = R.UnitFrames

local _, ns = ...
local RayUF = ns.oUF

function RA:FetchRaidSettings()
    _GroupConfig.raid = {
        enable = true,
        width = self.db.width,
        height = self.db.height,
        visibility = "[nogroup:party,nogroup:raid] hide;show",
        numGroups = 8,
        defaultPosition = { "BOTTOMLEFT", R.UIParent, "BOTTOMLEFT", 15, 235 },
    }
end

function RA:Construct_RaidFrames()
    self.RaisedElementParent = CreateFrame("Frame", nil, self)
    self.RaisedElementParent:SetFrameLevel(self:GetFrameLevel() + 100)
    self.Health = RA:Construct_HealthBar(self)
    self.Power = RA:Construct_PowerBar(self)
    self.Name = RA:Construct_NameText(self)
    self.ThreatIndicator = RA:Construct_Threat(self)
    self.Healtext = RA:Construct_HealText(self)
    self.Highlight = RA:Construct_Highlight(self)
    self.RaidTargetIndicator = RA:Construct_RaidIcon(self)
    self.ResurrectIndicator = RA:Construct_ResurectionIcon(self)
    self.ReadyCheckIndicator = RA:Construct_ReadyCheck(self)
    self.RaidDebuffs = RA:Construct_RaidDebuffs(self)
    self.AuraWatch = RA:Construct_AuraWatch(self)
    self.RaidRoleFramesAnchor = RA:Construct_RaidRoleFrames(self)
    if RA.db.roleicon then
        self.GroupRoleIndicator = RA:Construct_RoleIcon(self)
    end
    self.AFKtext = RA:Construct_AFKText(self)
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

function RA:RaidSmartVisibility(event)
    RegisterStateDriver(self, "visibility", _GroupConfig.raid.visibility)
end

_HeadersToLoad["raid"] = { nil, nil }
