local R, L, P, G = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, GlobalDB
local UF = R:GetModule("UnitFrames")
local oUF = RayUF or oUF

--Cache global variables
--Lua functions
local tinsert = table.insert
local max = math.max

--WoW API / Variables
local CreateFrame = CreateFrame
local UnitIsEnemy = UnitIsEnemy
local UnitIsFriend = UnitIsFriend
local UnitFactionGroup = UnitFactionGroup
local UnitIsPVPFreeForAll = UnitIsPVPFreeForAll
local UnitIsPVP = UnitIsPVP

--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: RayUF_Target

function UF:Construct_TargetTargetFrame(frame, unit)
    frame.mouseovers = {}
    frame.UNIT_WIDTH = self.db.units[unit].width
    frame.UNIT_HEIGHT = self.db.units[unit].height

    frame:Size(frame.UNIT_WIDTH, frame.UNIT_HEIGHT)
    frame.Health = self:Construct_HealthBar(frame, true, true)
    frame.Name = self:Construct_NameText(frame)
    frame.Mouseover = self:Construct_Highlight(frame)
    frame.ThreatHlt = self:Construct_Highlight(frame)
    frame.PvP = self:Construct_PvPIndicator(frame)
    frame.QuestIcon = self:Construct_QuestIcon(frame)
    frame.RaidIcon = self:Construct_RaidIcon(frame)
    frame.Range = {
            insideAlpha = 1,
            outsideAlpha = 0.4
        }

    self:EnableHealPredictionAndAbsorb(frame)

    frame.Health.value:Point("LEFT", frame, "LEFT", 5, 0)
    frame.Health:SetPoint("BOTTOM")

    frame.Name:ClearAllPoints()
    frame.Name:Point("TOP", frame.Health, 0, 12)
    frame.Name:SetJustifyH("CENTER")
    if self.db.healthColorClass then
        frame:Tag(frame.Name, "[RayUF:name]")
    else
        frame:Tag(frame.Name, "[RayUF:color][RayUF:name]")
    end

    frame.Buffs = self:Construct_Buffs(frame)
    frame.Buffs["growth-x"] = "RIGHT"
    frame.Buffs["growth-y"] = "DOWN"
    frame.Buffs.initialAnchor = "TOPLEFT"
    frame.Buffs.num = 5
    frame.Buffs.CustomFilter = function(_, unit) if UnitIsFriend(unit, "player") then return false end return true end
    frame.Buffs:Point("TOPLEFT", frame, "BOTTOMLEFT", 1, -5)

    frame.Debuffs = self:Construct_Debuffs(frame)
    frame.Debuffs["growth-x"] = "RIGHT"
    frame.Debuffs["growth-y"] = "UP"
    frame.Debuffs.initialAnchor = "TOPLEFT"
    frame.Debuffs.num = 5
    frame.Debuffs.CustomFilter = function(_, unit) if UnitIsEnemy(unit, "player") then return false end return true end
    frame.Debuffs:Point("TOPLEFT", frame, "BOTTOMLEFT", 1, -5)
end

tinsert(UF["unitstoload"], "targettarget")
