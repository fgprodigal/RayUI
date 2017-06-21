----------------------------------------------------------
-- Load RayUI Environment
----------------------------------------------------------
_LoadRayUIEnv_()


local mod = R:GetModule('NamePlates')
local LSM = LibStub("LibSharedMedia-3.0")


function mod:UpdateElement_MaxPower(frame)
    local maxValue = UnitPowerMax(frame.displayedUnit, frame.PowerType);
    frame.PowerBar:SetMinMaxValues(0, maxValue);
end

local temp = {1, 1, 1}
function mod:UpdateElement_Power(frame)
    self:UpdateElement_MaxPower(frame)

    local curValue = UnitPower(frame.displayedUnit, frame.PowerType);
    frame.PowerBar:SetValue(curValue);

    local color = RayUF.colors.power[frame.PowerType] or temp

    if(color) then
        frame.PowerBar:SetStatusBarColor(unpack(color))
		R:SetStatusBarGradient(frame.PowerBar)
    end
end

function mod:ConfigureElement_PowerBar(frame)
    local powerBar = frame.PowerBar
    powerBar:SetPoint("TOPLEFT", frame.HealthBar, "BOTTOMLEFT", 0, -1)
    powerBar:SetPoint("TOPRIGHT", frame.HealthBar, "BOTTOMRIGHT", 0, -1)
    powerBar:SetHeight(self.db.pbHeight)
    powerBar:SetStatusBarTexture(LSM:Fetch("statusbar", R.global.media.normal))
end

function mod:ConstructElement_PowerBar(parent)
    local frame = CreateFrame("StatusBar", "$parentPowerBar", parent)
    self:StyleFrame(frame)
    frame:Hide()

    return frame
end
