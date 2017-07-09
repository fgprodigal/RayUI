----------------------------------------------------------
-- Load RayUI Environment
----------------------------------------------------------
RayUI:LoadEnv("UnitFrames")


local UF = _UnitFrames
local oUF = RayUF or oUF


function UF:Construct_PetFrame(frame, unit)
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
    frame.Fader = self:Construct_Fader(frame)

    self:EnableHealPredictionAndAbsorb(frame)

    frame.Health.value:Point("TOPRIGHT", frame.Health, "TOPRIGHT", -8, -2)
    frame.Power.value:Point("BOTTOMRIGHT", frame.Health, "BOTTOMRIGHT", -8, 2)

    if self.db.healthColorClass then
        frame:Tag(frame.Name, "[RayUF:name]")
    else
        frame:Tag(frame.Name, "[RayUF:color][RayUF:name]")
    end

    if self.db.showPortrait then
        frame.Portrait = self:Construct_Portrait(frame)
    end

    frame.Debuffs = self:Construct_Debuffs(frame)
    frame.Debuffs["growth-x"] = "LEFT"
    frame.Debuffs["growth-y"] = "UP"
    frame.Debuffs.initialAnchor = "BOTTOMRIGHT"
    frame.Debuffs.num = 5
    frame.Debuffs:Point("BOTTOMRIGHT", frame, "TOPRIGHT", 0, 8)

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

        frame.Auras:Point("BOTTOMRIGHT", frame, "TOPRIGHT", 0, 30)
        R:CreateMover(frame.Auras, "PetSmartAuraMover", L["宠物法术监视"], true, nil, "ALL,GENERAL,RAID")
    end
end

tinsert(_UnitsToLoad, "pet")
