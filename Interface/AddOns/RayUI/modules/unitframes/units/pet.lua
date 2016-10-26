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
-- GLOBALS: RayUIPetBar

function UF:Construct_PetFrame(frame, unit)
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

    self:EnableHealPredictionAndAbsorb(frame)

    frame.Health.value:Point("LEFT", frame, "LEFT", 5, 0)
    frame.Health:SetPoint("BOTTOM")

    frame.Name:ClearAllPoints()
    frame.Name:Point("TOP", frame.Health, 0, 7)
    frame.Name:SetJustifyH("CENTER")
    if self.db.healthColorClass then
        frame:Tag(frame.Name, "[RayUF:name]")
    else
        frame:Tag(frame.Name, "[RayUF:color][RayUF:name]")
    end
end

tinsert(UF["unitstoload"], "pet")
