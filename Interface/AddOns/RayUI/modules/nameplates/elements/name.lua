----------------------------------------------------------
-- Load RayUI Environment
----------------------------------------------------------
RayUI:LoadEnv("NamePlates")

local mod = _NamePlates
local LSM = LibStub("LibSharedMedia-3.0")

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
    elseif not self.db.units[frame.UnitType].healthbar and not frame.isTarget then
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
    if(self.db.units[frame.UnitType].healthbar or frame.isTarget) then
        name:SetJustifyH("CENTER")
        name:SetPoint("BOTTOM", frame.HealthBar, "TOP", 0, 2)
    else
        name:SetJustifyH("CENTER")
        name:SetPoint("TOP", frame, "CENTER")
    end

    name:SetFont(LSM:Fetch("font", R.global.media.font), self.db.fontsize, "OUTLINE")
end

function mod:ConstructElement_Name(frame)
    local name = frame:CreateFontString(nil, "OVERLAY")
    name:SetWordWrap(false)

    local g = frame:CreateTexture(nil,"BACKGROUND",nil,-5)
    g:SetTexture([[Interface\AddOns\RayUI\media\spark.tga]])
    g:SetVertexColor(.3, .7, 1, 1)
    g:Hide()
    g:SetPoint("TOPLEFT", name, -20, 8)
    g:SetPoint("BOTTOMRIGHT", name, 20, -8)

    name.NameOnlyGlow = g

    return name
end
