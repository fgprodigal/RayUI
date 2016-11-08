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

function UF:Construct_ArenaFrame(frame, unit)
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

    if not frame.prepFrame then
        frame.prepFrame = CreateFrame("Frame", frame:GetName().."PrepFrame", R.UIParent)
        frame.prepFrame:SetFrameStrata("BACKGROUND")
        frame.prepFrame:SetAllPoints(frame)
        frame.prepFrame.Health = CreateFrame("StatusBar", nil, frame.prepFrame)
        frame.prepFrame.Health:SetStatusBarTexture(R["media"].normal)
        frame.prepFrame.Health:SetAllPoints()
        frame.prepFrame.Health:CreateShadow("Background")

        frame.prepFrame.Icon = frame.prepFrame:CreateTexture(nil, "OVERLAY")
        frame.prepFrame.Icon.bg = CreateFrame("Frame", nil, frame.prepFrame)
        frame.prepFrame.Icon.bg:SetHeight(frame.UNIT_HEIGHT)
        frame.prepFrame.Icon.bg:SetWidth(frame.UNIT_HEIGHT)
        frame.prepFrame.Icon.bg:SetPoint("LEFT", frame.prepFrame, "RIGHT", 5, 0)
        frame.prepFrame.Icon.bg:CreateShadow("Background")
        frame.prepFrame.Icon:SetParent(frame.prepFrame.Icon.bg)
        frame.prepFrame.Icon:SetTexCoord(.08, .92, .08, .92)
        frame.prepFrame.Icon:SetAllPoints(frame.prepFrame.Icon.bg)

        frame.prepFrame.SpecClass = frame.prepFrame.Health:CreateFontString(nil, "OVERLAY")
        frame.prepFrame.SpecClass:SetPoint("CENTER")
        frame.prepFrame.SpecClass:SetFont(R["media"].font, 12, R["media"].fontflag)
    end

    local specIcon = CreateFrame("Frame", nil, frame)
    specIcon:SetHeight(frame.UNIT_HEIGHT)
    specIcon:SetWidth(frame.UNIT_HEIGHT)
    specIcon:SetPoint("LEFT", frame, "RIGHT", 5, 0)
    specIcon:CreateShadow("Background")
    frame.PVPSpecIcon = specIcon

    local trinkets = CreateFrame("Frame", nil, frame)
    trinkets:SetHeight(frame.UNIT_HEIGHT)
    trinkets:SetWidth(frame.UNIT_HEIGHT)
    trinkets:SetPoint("LEFT", specIcon, "RIGHT", 5, 0)
    trinkets:CreateShadow("Background")
    trinkets.shadow:SetFrameStrata("BACKGROUND")
    trinkets.trinketUseAnnounce = true
    trinkets.trinketUpAnnounce = true
    frame.Trinket = trinkets
end
