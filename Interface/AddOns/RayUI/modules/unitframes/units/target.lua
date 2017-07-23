----------------------------------------------------------
-- Load RayUI Environment
----------------------------------------------------------
RayUI:LoadEnv("UnitFrames")

local UF = _UnitFrames
local oUF = RayUF or oUF

function UF:Construct_TargetFrame(frame, unit)
    frame.mouseovers = {}
    frame.UNIT_WIDTH = self.db.units[unit].width
    frame.UNIT_HEIGHT = self.db.units[unit].height
    frame.POWER_HEIGHT = ceil(frame.UNIT_HEIGHT * self.db.powerheight)

    frame:Size(frame.UNIT_WIDTH, frame.UNIT_HEIGHT)
    frame.Health = self:Construct_HealthBar(frame, true, true)
    frame.Power = self:Construct_PowerBar(frame, true, true)

    frame.Power:Point("BOTTOMLEFT", frame, "BOTTOMLEFT")
    frame.Power:Point("BOTTOMRIGHT", frame, "BOTTOMRIGHT")
    frame.Power:Height(frame.POWER_HEIGHT)
    frame.Health:Point("TOPLEFT", frame, "TOPLEFT")
    frame.Health:Point("BOTTOMRIGHT", frame.Power, "TOPRIGHT", 0, 1)

    frame.Name = self:Construct_NameText(frame)
    frame.Mouseover = self:Construct_Highlight(frame)
    frame.PvPIndicator = self:Construct_PvPIndicator(frame)
    frame.QuestIndicator = self:Construct_QuestIcon(frame)
    frame.RaidTargetIndicator = self:Construct_RaidIcon(frame)
    frame.ThreatIndicator = self:Construct_Threat(frame)
    frame.Range = {
        insideAlpha = 1,
        outsideAlpha = 0.4
    }
    frame.Range.Override = UF.UpdateRange

    self:EnableHealPredictionAndAbsorb(frame)

    frame.Health.value:Point("TOPLEFT", frame.Health, "TOPLEFT", 8, -2)
    frame.Power.value:Point("BOTTOMLEFT", frame.Health, "BOTTOMLEFT", 8, 2)

    frame.Name:ClearAllPoints()
    frame.Name:Point("BOTTOMRIGHT", frame.Health, "BOTTOMRIGHT", -8, 3)
    frame.Name:SetJustifyH("RIGHT")
    if self.db.healthColorClass then
        frame:Tag(frame.Name, "[RayUF:name] [RayUF:info]")
    else
        frame:Tag(frame.Name, "[RayUF:info] [RayUF:color][RayUF:name]")
    end

    if self.db.showPortrait then
        frame.Portrait = self:Construct_Portrait(frame)
    end

    if self.db.castBar then
        local castbar = self:Construct_CastBar(frame)
        castbar:Width(self.db.units[unit].castbar.width)
        castbar:Height(self.db.units[unit].castbar.height)
        local iconSize = max(self.db.units[unit].castbar.height, 20)
        castbar.Iconbg:Size(iconSize)
        castbar.Text:ClearAllPoints()
        castbar.Text:SetPoint("LEFT", castbar, "LEFT", 5, 0)
        castbar.Time:ClearAllPoints()
        castbar.Time:SetPoint("RIGHT", castbar, "RIGHT", -5, 0)

        castbar:ClearAllPoints()
        castbar.Iconbg:ClearAllPoints()
        if self.db.units[unit].castbar.showicon then
            castbar.Iconbg:Show()
            castbar:Width(self.db.units[unit].castbar.width - iconSize - 5)
            if self.db.units[unit].castbar.iconposition == "LEFT" then
                castbar.Iconbg:SetPoint("BOTTOMRIGHT", castbar, "BOTTOMLEFT", -5, 0)
                castbar:Point("TOPRIGHT", frame, "BOTTOMRIGHT", 0, -6)
            else
                castbar.Iconbg:SetPoint("BOTTOMLEFT", castbar, "BOTTOMRIGHT", 5, 0)
                castbar:Point("TOPLEFT", frame, "BOTTOMLEFT", 0, -6)
            end
        else
            castbar.Iconbg:Hide()
            castbar:Point("TOPRIGHT", frame, "BOTTOMRIGHT", 0, -6)
        end
        frame.Castbar = castbar
    end

    frame.Debuffs = self:Construct_Debuffs(frame)
    frame.Debuffs["growth-x"] = "RIGHT"
    frame.Debuffs["growth-y"] = "UP"
    frame.Debuffs.initialAnchor = "BOTTOMLEFT"
    frame.Debuffs.CustomFilter = self.CustomFilter
    frame.Debuffs:Point("BOTTOMLEFT", frame, "TOPLEFT", 0, 8)

    frame.Buffs = self:Construct_Buffs(frame)
    frame.Buffs["growth-x"] = "RIGHT"
    frame.Buffs["growth-y"] = "UP"
    frame.Buffs.initialAnchor = "BOTTOMLEFT"
    frame.Buffs:Point("BOTTOMLEFT", frame.Debuffs, "TOPLEFT", 0, 4)

    if self.db.units[unit].smartaura.enable then
        frame.Auras = self:Construct_SmartAura(frame)
        frame.Auras.size = self.db.units[unit].smartaura.size
        frame.Auras["growth-x"] = self.db.units[unit].smartaura.growthx
        frame.Auras["growth-y"] = self.db.units[unit].smartaura.growthy

        if frame.Auras["growth-y"] == "UP" then
            frame.Auras.initialAnchor = "BOTTOM"
        else
            frame.Auras.initialAnchor = "TOP"
        end

        if frame.Auras["growth-x"] == "LEFT" then
            frame.Auras.initialAnchor = frame.Auras.initialAnchor.."RIGHT"
        else
            frame.Auras.initialAnchor = frame.Auras.initialAnchor.."LEFT"
        end

        frame.Auras:Point("BOTTOMLEFT", frame, "TOPLEFT", 0, 60)
        R:CreateMover(frame.Auras, "TargetSmartAuraMover", L["目标法术监视"], true, nil, "ALL,GENERAL,RAID")
        frame.Buffs.CustomFilter = self.CustomFilter
    end

    if UF.db.aurabar then
        frame.AuraBars = self:Construct_AuraBarHeader(frame)
        frame.AuraBars:SetPoint("BOTTOMLEFT", frame, "TOPLEFT", 0, 33)
        frame.AuraBars:SetPoint("BOTTOMRIGHT", frame, "TOPRIGHT", 0, 33)
    end

    frame.RangeText = self:Construct_RangeText(frame)
    self:ScheduleRepeatingTimer("RangeDisplayUpdate", 0.25, frame)
end

tinsert(_UnitsToLoad, "target")
