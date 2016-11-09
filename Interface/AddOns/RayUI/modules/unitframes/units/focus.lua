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

--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: RayUF_Player, FOCUS

function UF:Construct_FocusFrame(frame, unit)
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

    frame.Health.value:Point("TOPRIGHT", frame.Health, "TOPRIGHT", -8, -2)
    frame.Power.value:Point("BOTTOMRIGHT", frame.Health, "BOTTOMRIGHT", -8, 2)

    frame.Name:ClearAllPoints()
    frame.Name:Point("BOTTOMLEFT", frame.Health, "BOTTOMLEFT", 8, 3)
    frame.Name:SetJustifyH("LEFT")
    if self.db.healthColorClass then
        frame:Tag(frame.Name, "[RayUF:name] [RayUF:info]")
    else
        frame:Tag(frame.Name, "[RayUF:color][RayUF:name] [RayUF:info]")
    end

    if self.db.showPortrait then
        frame.Portrait = self:Construct_Portrait(frame)
    end

    if self.db.castBar then
        local castbar = self:Construct_CastBar(frame)
        castbar:ClearAllPoints()
        castbar:Point("CENTER", R.UIParent, "CENTER", 0, 100)
        castbar:Width(self.db.units[unit].castbar.width)
        castbar:Height(self.db.units[unit].castbar.height)
        castbar.Iconbg:Size(max(self.db.units[unit].castbar.height, 25))
        if self.db.units[unit].castbar.showicon then
            castbar.Iconbg:Show()
        else
            castbar.Iconbg:Hide()
        end
        castbar.Iconbg:ClearAllPoints()
        if self.db.units[unit].castbar.iconposition == "LEFT" then
            castbar.Iconbg:SetPoint("BOTTOMRIGHT", castbar, "BOTTOMLEFT", -5, 0)
        else
            castbar.Iconbg:SetPoint("BOTTOMLEFT", castbar, "BOTTOMRIGHT", 5, 0)
        end
        castbar.Text:ClearAllPoints()
        castbar.Text:SetPoint("BOTTOMLEFT", castbar, "TOPLEFT", 5, -2)
        castbar.Time:ClearAllPoints()
        castbar.Time:SetPoint("BOTTOMRIGHT", castbar, "TOPRIGHT", -5, -2)

        R:CreateMover(castbar, "FocusCastBarMover", L["焦点"].." "..L["施法条锚点"], true, nil, "ALL,RAID")
        frame.Castbar = castbar
    end

    frame.Debuffs = self:Construct_Debuffs(frame)
    frame.Debuffs["growth-x"] = "LEFT"
    frame.Debuffs["growth-y"] = "UP"
    frame.Debuffs.initialAnchor = "BOTTOMRIGHT"
    frame.Debuffs.num = 7
    frame.Debuffs.CustomFilter = self.CustomFilter
    frame.Debuffs:Point("BOTTOMRIGHT", frame, "TOPRIGHT", 0, 7)

    if self.db.smartAura then
        frame.Auras = self:Construct_SmartAura(frame)
        frame.Auras.size = 30
        frame.Auras["growth-x"] = "LEFT"
        frame.Auras["growth-y"] = "UP"
        frame.Auras.initialAnchor = "BOTTOMRIGHT"
        frame.Auras:Point("BOTTOMRIGHT", frame, "TOPRIGHT", 0, 30)
    end
end

tinsert(UF["unitstoload"], "focus")
