local R, L, P, G = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, GlobalDB
local mod = R:GetModule('NamePlates')
local LSM = LibStub("LibSharedMedia-3.0")

--Cache global variables
--Lua functions
--WoW API / Variables
local CreateFrame = CreateFrame
local UnitHealth = UnitHealth
local UnitHealthMax = UnitHealthMax
local UnitIsUnit = UnitIsUnit

function mod:UpdateElement_Glow(frame)
    if(not frame.HealthBar:IsShown()) then return end
    local r, g, b, shouldShow;
    if ( UnitIsUnit(frame.unit, "target") ) then
        r, g, b = 1, 1, 1
        shouldShow = true
    else
        -- Use color based on the type of unit (neutral, etc.)
        local health, maxHealth = UnitHealth(frame.unit), UnitHealthMax(frame.unit)
        local perc = health/maxHealth
        if perc <= 0.5 then
            if perc <= 0.2 then
                r, g, b = 1, 0, 0
            else
                r, g, b = 1, 1, 0
            end

            shouldShow = true
        end
    end

    if(shouldShow) then
        frame.Glow:Show()
        if ( (r ~= frame.Glow.r or g ~= frame.Glow.g or b ~= frame.Glow.b) ) then
            frame.Glow:SetBackdropBorderColor(r, g, b);
            frame.Glow.r, frame.Glow.g, frame.Glow.b = r, g, b;
        end
        frame.Glow:SetOutside(frame.HealthBar, 2.5 + mod.mult, 2.5 + mod.mult, frame.PowerBar:IsShown() and frame.PowerBar)
    elseif(frame.Glow:IsShown()) then
        frame.Glow:Hide()
    end

end

function mod:ConfigureElement_Glow(frame)
    frame.Glow:SetFrameLevel(0)
    frame.Glow:SetFrameStrata("BACKGROUND")
    frame.Glow:SetOutside(frame.HealthBar, 2.5 + mod.mult, 2.5 + mod.mult, frame.PowerBar:IsShown() and frame.PowerBar)
    frame.Glow:SetBackdrop( {
            edgeFile = LSM:Fetch("border", "RayUI GlowBorder"), edgeSize = R:Scale(3),
            insets = {left = R:Scale(5), right = R:Scale(5), top = R:Scale(5), bottom = R:Scale(5)},
        })
    frame.Glow:SetBackdropBorderColor(0, 0, 0)
    frame.Glow:SetScale(2)
end

function mod:ConstructElement_Glow(frame)
    local f = CreateFrame("Frame", nil, frame)
    f:Hide()
    return f
end
