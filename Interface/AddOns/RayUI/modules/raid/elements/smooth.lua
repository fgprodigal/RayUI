local R, L, P = unpack(select(2, ...)) --Inport: Engine, Locales, ProfileDB
local RA = R:GetModule("Raid")

local oUF = RayUF or oUF

-- Modified oUF_SmoothUpdate by Xuerian

local min, max, abs = math.min, math.max, abs
local GetFramerate = GetFramerate
local SetValue = CreateFrame("StatusBar").SetValue

local function Smooth(self, value)
    if value == self:GetValue() then
        self.smoothing = nil
    else
        self.smoothing = value
    end
end

local SmoothUpdate = function(self)
    local value = self.smoothing
    if not value then return end

    local limit = 30/GetFramerate()
    local cur = self:GetValue()
    local new = cur + min((value-cur)/3, max(value-cur, limit))

    if new ~= new then
        -- Mad hax to prevent QNAN.
        new = value
    end

    self:SetValue_(new)
    if cur == value or abs(new - value) < 2 then
        self:SetValue_(value)
        self.smoothing = nil
    end
end

local function SmoothBar(bar)
    if bar.freebSmooth then
        bar.SetValue_ = SetValue
        bar.SetValue = Smooth

        bar:SetScript("OnUpdate", SmoothUpdate)
    end 
end

local function Restore(bar)
    if not bar.freebSmooth then
        bar.SetValue = SetValue

        bar:SetScript("OnUpdate", nil)
    end
end

local Enable = function(self)
    if self.Health then
        SmoothBar(self.Health)
    end
end

local Disable = function(self)
    if self.Health then
        Restore(self.Health)
    end
end

oUF:AddElement('freebSmooth', nil, Enable, Disable)
