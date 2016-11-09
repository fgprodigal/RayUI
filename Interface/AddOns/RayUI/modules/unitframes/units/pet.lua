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
-- GLOBALS: RayUIPetBar

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
    frame.ThreatHlt = self:Construct_Highlight(frame)
    frame.PvP = self:Construct_PvPIndicator(frame)
    frame.QuestIcon = self:Construct_QuestIcon(frame)
    frame.RaidIcon = self:Construct_RaidIcon(frame)
    frame.Threat = self:Construct_Threat(frame)
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
end

tinsert(UF["unitstoload"], "pet")
