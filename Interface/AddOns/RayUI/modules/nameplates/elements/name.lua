local R, L, P, G = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, GlobalDB
local mod = R:GetModule('NamePlates')
local LSM = LibStub("LibSharedMedia-3.0")

--Cache global variables
--Lua functions
local unpack = unpack

--WoW API / Variables
local UnitClass = UnitClass
local UnitName = UnitName
local UnitReaction = UnitReaction
local CUSTOM_CLASS_COLORS = CUSTOM_CLASS_COLORS
local RAID_CLASS_COLORS = RAID_CLASS_COLORS

--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: RayUF

function mod:UpdateElement_Name(frame)
    local name, realm = UnitName(frame.displayedUnit)
    if not name then return end

    frame.Name:SetText(name)

    if(frame.UnitType == "FRIENDLY_PLAYER" or frame.UnitType == "ENEMY_PLAYER") then
        local _, class = UnitClass(frame.displayedUnit)
        local color = RAID_CLASS_COLORS[class]
        if(class and color) then
            frame.Name:SetTextColor(color.r, color.g, color.b)
        end
    elseif frame.UnitType == "FRIENDLY_NPC" then
        local reactionType = UnitReaction(frame.unit, "player")
        local r, g, b
        if(reactionType == 4) then
            r, g, b = unpack(RayUF.colors.reaction[4])
        elseif(reactionType > 4) then
            r, g, b = unpack(RayUF.colors.reaction[5])
        else
            r, g, b = unpack(RayUF.colors.reaction[1])
        end

        frame.Name:SetTextColor(r, g, b)
    else
        frame.Name:SetTextColor(1, 1, 1)
    end
end

function mod:ConfigureElement_Name(frame)
    local name = frame.Name

    name:SetJustifyH("LEFT")
    name:ClearAllPoints()
    if(frame.UnitType ~= "FRIENDLY_NPC" or frame.isTarget) then
        name:SetJustifyH("LEFT")
        name:SetPoint("BOTTOMLEFT", frame.HealthBar, "TOPLEFT", 0, 2)
        name:SetPoint("BOTTOMRIGHT", frame.Level, "BOTTOMLEFT")
    else
        name:SetJustifyH("CENTER")
        name:SetPoint("TOP", frame, "CENTER")
    end

    name:SetFont(LSM:Fetch("font", R.global.media.font), self.db.fontsize, "OUTLINE")
end

function mod:ConstructElement_Name(frame)
    local name = frame:CreateFontString(nil, "OVERLAY")
    name:SetWordWrap(false)

    return name
end
