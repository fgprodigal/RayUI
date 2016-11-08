local R, L, P, G = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, GlobalDB
local UF = R:GetModule("UnitFrames")
local oUF = RayUF or oUF

--Cache global variables
--Lua functions
local tinsert = table.insert
local max, ceil = math.max, math.ceil
local gsub = string.gsub

--WoW API / Variables
local CreateFrame = CreateFrame
local UnitIsEnemy = UnitIsEnemy
local UnitIsFriend = UnitIsFriend
local UnitFactionGroup = UnitFactionGroup
local UnitIsPVPFreeForAll = UnitIsPVPFreeForAll
local UnitIsPVP = UnitIsPVP

function UF:Construct_BossFrame(frame, unit)
    local unitGroup = gsub(unit, "%d", "")
    frame.mouseovers = {}
    frame.UNIT_WIDTH = self.db.units[unitGroup].width
    frame.UNIT_HEIGHT = self.db.units[unitGroup].height
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
    frame.QuestIcon = self:Construct_QuestIcon(frame)
    frame.RaidIcon = self:Construct_RaidIcon(frame)

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
        castbar:SetAllPoints(frame)
        castbar.Iconbg:ClearAllPoints()
        castbar.Iconbg:Point("RIGHT", frame, "LEFT", -2, 1)
        castbar.Text:ClearAllPoints()
        castbar.Text:Point("LEFT", frame.Health, "LEFT", 2, 0)
        castbar.Time:ClearAllPoints()
        castbar.Time:Point("RIGHT", frame.Health, "RIGHT", -2, 0)

        frame.Castbar = castbar
    end

    frame.Debuffs = self:Construct_Debuffs(frame)
    frame.Debuffs["growth-x"] = "RIGHT"
    frame.Debuffs["growth-y"] = "UP"
    frame.Debuffs.initialAnchor = "BOTTOMLEFT"
    frame.Debuffs.onlyShowPlayer = true
    frame.Debuffs:Point("BOTTOMLEFT", frame, "TOPLEFT", 1, 2)
end
