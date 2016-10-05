local R, L, P, G = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, GlobalDB
local mod = R:GetModule('NamePlates')

--Cache global variables
--Lua functions
--WoW API / Variables
local UnitClassification = UnitClassification

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
        icon:SetPoint("LEFT", frame.HealthBar, "RIGHT", 2, 0)
    else
        icon:SetParent(frame)
        icon:SetPoint("LEFT", frame, "RIGHT", 2, 0)
    end
end

function mod:ConstructElement_Elite(frame)
    local icon = frame.HealthBar:CreateTexture(nil, "OVERLAY")
    icon:SetTexture("Interface\\TARGETINGFRAME\\Nameplates")
    icon:Hide()

    return icon
end
