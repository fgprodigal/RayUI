local R, L, P, G = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, GlobalDB
local UF = R:GetModule("UnitFrames")
local oUF = RayUF or oUF

--Cache global variables
--Lua functions
local tinsert = table.insert
local max, ceil = math.max, math.ceil

--WoW API / Variables
local CreateFrame = CreateFrame
local UnitIsEnemy = UnitIsEnemy
local UnitIsFriend = UnitIsFriend
local UnitFactionGroup = UnitFactionGroup
local UnitIsPVPFreeForAll = UnitIsPVPFreeForAll
local UnitIsPVP = UnitIsPVP

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
    frame.ThreatHlt = self:Construct_Highlight(frame)
    frame.PvP = self:Construct_PvPIndicator(frame)
    frame.QuestIcon = self:Construct_QuestIcon(frame)
    frame.RaidIcon = self:Construct_RaidIcon(frame)
    frame.Threat = self:Construct_Threat(frame)
    frame.Range = {
        insideAlpha = 1,
        outsideAlpha = 0.4
    }

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
    if self.db.smartAura then
        frame.Buffs.CustomFilter = self.CustomFilter
    end
    frame.Buffs:Point("BOTTOMLEFT", frame.Debuffs, "TOPLEFT", 0, 4)

    if self.db.smartAura then
        frame.Auras = self:Construct_SmartAura(frame)
        frame.Auras["growth-x"] = "RIGHT"
        frame.Auras["growth-y"] = "UP"
        frame.Auras.initialAnchor = "BOTTOMLEFT"
        frame.Auras:Point("BOTTOMLEFT", frame, "TOPLEFT", 0, 60)
    end

    if UF.db.aurabar then
        frame.AuraBars = self:Construct_AuraBarHeader(frame)
        frame.AuraBars:SetPoint("BOTTOMLEFT", frame, "TOPLEFT", 0, 33)
        frame.AuraBars:SetPoint("BOTTOMRIGHT", frame, "TOPRIGHT", 0, 33)
    end

    frame.RangeText = self:Construct_RangeText(frame)
    self:ScheduleRepeatingTimer("RangeDisplayUpdate", 0.25, frame)
end

tinsert(UF["unitstoload"], "target")
