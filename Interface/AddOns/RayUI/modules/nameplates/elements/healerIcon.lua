----------------------------------------------------------
-- Load RayUI Environment
----------------------------------------------------------
RayUI:LoadEnv("NamePlates")


local mod = _NamePlates

function mod:UpdateElement_HealerIcon(frame)
    local icon = frame.HealerIcon;
    local name = UnitName(frame.unit)
    icon:ClearAllPoints()
    if(frame.HealthBar:IsShown()) then
        icon:SetPoint("RIGHT", frame.HealthBar, "LEFT", -6, 0)
    else
        icon:SetPoint("BOTTOM", frame.Name, "TOP", 0, 3)
    end
    if _Healers[name] and frame.UnitType == "ENEMY_PLAYER" then
        icon:Show();
    else
        icon:Hide();
    end
end

function mod:ConstructElement_HealerIcon(frame)
    local texture = frame:CreateTexture(nil, "OVERLAY")
    texture:SetPoint("RIGHT", frame.HealthBar, "LEFT", -6, 0)
    texture:SetSize(40, 40)
    texture:SetTexture([[Interface\AddOns\RayUI\media\healer.tga]])
    texture:Hide()

    return texture
end
