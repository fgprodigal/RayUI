----------------------------------------------------------
-- Load RayUI Environment
----------------------------------------------------------
RayUI:LoadEnv("NamePlates")


local mod = _NamePlates

function mod:UpdateElement_Elite(frame)
    local icon = frame.Elite
    local c = UnitClassification(frame.unit)
    if c == "elite" or c == "worldboss" then
        icon:SetTexCoord(0, 0.15, 0.35, 0.63)
        icon:Show()
    elseif c == "rareelite" or c == "rare" then
        icon:SetTexCoord(0, 0.15, 0.63, 0.91)
        icon:Show()
    else
        icon:Hide()
    end
end

function mod:ConfigureElement_Elite(frame)
    local icon = frame.Elite
    local size = 25

    icon:SetSize(size,size)
    icon:ClearAllPoints()

    if frame.HealthBar:IsShown() then
        icon:SetParent(frame.HealthBar)
        icon:SetPoint("RIGHT", frame.HealthBar, "LEFT", 2, 0)
    else
        icon:SetParent(frame)
        icon:SetPoint("RIGHT", frame.Name, "LEFT", 2, 0)
    end
end

function mod:ConstructElement_Elite(frame)
    local icon = frame.HealthBar:CreateTexture(nil, "OVERLAY")
    icon:SetTexture("Interface\\TARGETINGFRAME\\Nameplates")
    icon:Hide()

    return icon
end
