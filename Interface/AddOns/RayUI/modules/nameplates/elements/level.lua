local R, L, P, G = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, GlobalDB
local mod = R:GetModule('NamePlates')
local LSM = LibStub("LibSharedMedia-3.0")

--Cache global variables
--Lua functions
local strfind = string.find

--WoW API / Variables
local GetCreatureDifficultyColor = GetCreatureDifficultyColor
local UnitLevel = UnitLevel
local UnitClassification = UnitClassification

function mod:UpdateElement_Level(frame)
    if frame.UnitType ~= "ENEMY_PLAYER" and frame.UnitType ~= "ENEMY_NPC" then frame.Level:SetText() return end
    local level = UnitLevel(frame.displayedUnit)
    local c = UnitClassification(frame.displayedUnit)

    local r, g, b
    if(level == -1 or not level) then
        level = '??'
        r, g, b = 0.9, 0, 0
    else
        local color = GetCreatureDifficultyColor(level)
        if strfind(c, "rare") then level = level .. "r" end
        if strfind(c, "elite") then level = level .. "+" end
        r, g, b = color.r, color.g, color.b
    end

    if(frame.UnitType ~= "FRIENDLY_NPC" or frame.isTarget) then
        frame.Level:SetText(level)
    else
        frame.Level:SetFormattedText(" [%s]", level)
    end
    frame.Level:SetTextColor(r, g, b)
end

function mod:ConfigureElement_Level(frame)
    local level = frame.Level

    level:ClearAllPoints()

    if(frame.UnitType ~= "FRIENDLY_NPC" or frame.isTarget) then
        level:SetJustifyH("RIGHT")
        level:SetPoint("BOTTOMRIGHT", frame.HealthBar, "TOPRIGHT", 0, 2)
    else
        level:SetPoint("LEFT", frame.Name, "RIGHT")
        level:SetJustifyH("LEFT")
    end
    level:SetFont(LSM:Fetch("font", R.global.media.font), self.db.fontsize, "OUTLINE")
end

function mod:ConstructElement_Level(frame)
    return frame:CreateFontString(nil, "OVERLAY")
end
