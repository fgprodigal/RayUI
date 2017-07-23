----------------------------------------------------------
-- Load RayUI Environment
----------------------------------------------------------
RayUI:LoadEnv("Raid")


local RA = _Raid
local UF = R.UnitFrames

local _, ns = ...
local RayUF = ns.oUF

function RA:FetchRaidPetsSettings()
    _GroupConfig.raidPets = {
        enable = self.db.showPets,
        width = self.db.petwidth,
        height = self.db.petheight,
        visibility = "[group:raid] show;hide",
        numGroups = 2,
        defaultPosition = { "BOTTOMLEFT", R.UIParent, "BOTTOMLEFT", 15, 685 },
        label = "P",
    }
end

function RA:Construct_RaidPetsFrames()
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
    self.Range = {
        insideAlpha = 1,
        outsideAlpha = RA.db.outsideRange,
    }
    self.Range.Override = UF.UpdateRange

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

function RA:RaidPetsSmartVisibility(event)
    local inInstance, instanceType = IsInInstance()
    if event == "PLAYER_REGEN_ENABLED" then self:UnregisterEvent("PLAYER_REGEN_ENABLED") end
    if not InCombatLockdown() then
        if inInstance and instanceType == "raid" then
            UnregisterStateDriver(self, "state-visibility")
            self:Show()
        else
            RegisterStateDriver(self, "visibility", _GroupConfig.raid.visibility)
        end
    else
        self:RegisterEvent("PLAYER_REGEN_ENABLED")
        return
    end
end

_HeadersToLoad["raidPets"] = { nil, "SecureGroupPetHeaderTemplate" }
