local R, L, P = unpack(select(2, ...)) --Inport: Engine, Locales, ProfileDB
local RA = R:GetModule("Raid")

local oUF = RayUF or oUF

local GetTime = GetTime
local floor, fmod = floor, math.fmod
local day, hour, minute = 86400, 3600, 60

local FormatTime = function(s)
    if s >= day then
        return format("%dd", floor(s/day + 0.5))
    elseif s >= hour then
        return format("%dh", floor(s/hour + 0.5))
    elseif s >= minute then
        return format("%dm", floor(s/minute + 0.5))
    end

    return format("%d", fmod(s, minute))
end

local CreateAuraIcon = function(auras)
    local button = CreateFrame("Button", nil, auras)
    button:SetFrameLevel(9)
    button:EnableMouse(false)
    button:SetPoint("BOTTOMLEFT", auras, "BOTTOMLEFT")
    button:SetSize(auras.size, auras.size)

    local icon = button:CreateTexture(nil, "OVERLAY")
    icon:SetAllPoints(button)
    icon:SetTexCoord(.07, .93, .07, .93)

    local font, fontsize = GameFontNormalSmall:GetFont()
    local count = button:CreateFontString(nil, "OVERLAY")
    count:SetFont(font, fontsize, "THINOUTLINE")
    count:SetPoint("LEFT", button, "BOTTOM", 3, 2)

    local border = CreateFrame("Frame", nil, button)
    border:SetFrameLevel(8)
    border:SetOutside(button, 5, 5)
    border:SetBackdrop({
		edgeFile = R["media"].glow,
        bgFile = R["media"].normal,
		edgeSize = R:Scale(4),
		insets = {left = R:Scale(3), right = R:Scale(3), top = R:Scale(3), bottom = R:Scale(3)},
	})
    border:SetBackdropColor(0,0,0,1)
    border:SetBackdropBorderColor(0,0,0,1)
    button.border = border

    local remaining = button:CreateFontString(nil, "OVERLAY")
    remaining:SetPoint("CENTER") 
    remaining:SetFont(font, fontsize, "THINOUTLINE")
    remaining:SetTextColor(1, 1, 0)
    button.remaining = remaining

    button.parent = auras
    button.icon = icon
    button.count = count
    button.cd = cd
    button:Hide()

    return button
end

local dispelClass = {
    PRIEST = { Disease = true, Magic = true },
    SHAMAN = { Curse = true, Magic = true },
    PALADIN = { Poison = true, Disease = true, Magic = true },
    MAGE = { Curse = true, },
    DRUID = { Curse = true, Poison = true, Magic = true },
    MONK = { Poison = true, Disease = true, Magic = true },
}

local dispellist = dispelClass[R.myclass] or {}

local dispelPriority = {
    Magic = 4,
    Curse = 3,
    Poison = 2,
    Disease = 1,
}

local instDebuffs = {}

local delaytimer = 0
local function zoneDelay(self, elapsed)
    delaytimer = delaytimer + elapsed

    if delaytimer < 5 then return end

    if IsInInstance() then
        SetMapToCurrentZone()
        local zone = GetCurrentMapAreaID()

        if RA.auras.instances[zone] then
            instDebuffs = RA.auras.instances[zone]
        end
    else
        instDebuffs = {}
    end

    self:SetScript("OnUpdate", nil)
    delaytimer = 0
end

local getZone = CreateFrame"Frame"
getZone:RegisterEvent"PLAYER_ENTERING_WORLD"
getZone:RegisterEvent"ZONE_CHANGED_NEW_AREA"
getZone:SetScript("OnEvent", function(self, event)
    -- Delay just in case zone data hasn't loaded
    self:SetScript("OnUpdate", zoneDelay)

    if event == "PLAYER_ENTERING_WORLD" then
        self:UnregisterEvent("PLAYER_ENTERING_WORLD")
    end
end)

local CustomFilter = function(icons, ...)
    local _, icon, name, _, _, _, dtype, _, _, caster, spellID = ...

    icon.asc = false
    icon.buff = false
    icon.priority = 0

    if RA.auras.ascending[spellID] or RA.auras.ascending[name] then
        icon.asc = true
    end

    if instDebuffs[spellID] then
        icon.priority = instDebuffs[spellID]
        return true
    elseif RA.auras.debuffs[spellID] then
        icon.priority = RA.auras.debuffs[spellID]
        return true
    elseif RA.auras.buffs[spellID] then
        icon.priority = RA.auras.buffs[spellID]
        icon.buff = true
        return true
    elseif instDebuffs[name] then
        icon.priority = instDebuffs[name]
        return true
    elseif RA.auras.debuffs[name] then
        icon.priority = RA.auras.debuffs[name]
        return true
    elseif RA.auras.buffs[name] then
        icon.priority = RA.auras.buffs[name]
        icon.buff = true
        return true
    elseif RA.db.dispel and dispellist[dtype] then
        icon.priority = dispelPriority[dtype]
        return true
    end
end

local AuraTimerAsc = function(self, elapsed)
    self.elapsed = (self.elapsed or 0) + elapsed

    if self.elapsed < .2 then return end
    self.elapsed = 0

    local timeLeft = self.expires - GetTime()
    if timeLeft <= 0 then
        self.remaining:SetText(nil)
    else
        local duration = self.duration - timeLeft
        self.remaining:SetText(FormatTime(duration))
    end
end

local AuraTimer = function(self, elapsed)
    self.elapsed = (self.elapsed or 0) + elapsed

    if self.elapsed < .2 then return end
    self.elapsed = 0

    local timeLeft = self.expires - GetTime()
    if timeLeft <= 0 then
        self.remaining:SetText(nil)
    else
        self.remaining:SetText(FormatTime(timeLeft))
    end
end

local buffcolor = { r = 0.0, g = 1.0, b = 1.0 }
local updateDebuff = function(icon, texture, count, dtype, duration, expires, buff)
    local color = buff and buffcolor or DebuffTypeColor[dtype] or DebuffTypeColor.none

    icon.border:SetBackdropBorderColor(color.r, color.g, color.b)

    icon.icon:SetTexture(texture)
    icon.count:SetText((count > 1 and count))

    icon.expires = expires
    icon.duration = duration

    if icon.asc then
        icon:SetScript("OnUpdate", AuraTimerAsc)
    else
        icon:SetScript("OnUpdate", AuraTimer)
    end
end

local Update = function(self, event, unit)
    if(self.unit ~= unit) then return end

    local cur
    local hide = true
    local auras = self.freebAuras
    local icon = auras.button

    local index = 1
    while true do
        local name, rank, texture, count, dtype, duration, expires, caster, _, _, spellID = UnitDebuff(unit, index)
        if not name then break end
        
        local show = CustomFilter(auras, unit, icon, name, rank, texture, count, dtype, duration, expires, caster, spellID)

        if(show) then
            if not cur then
                cur = icon.priority
                updateDebuff(icon, texture, count, dtype, duration, expires)
            else
                if icon.priority > cur then
                    updateDebuff(icon, texture, count, dtype, duration, expires)
                end
            end

            icon:Show()
            hide = false
        end

        index = index + 1
    end

    index = 1
    while true do
        local name, rank, texture, count, dtype, duration, expires, caster, _, _, spellID = UnitBuff(unit, index)
        if not name then break end
        
        local show = CustomFilter(auras, unit, icon, name, rank, texture, count, dtype, duration, expires, caster, spellID)

        if(show) and icon.buff then
            if not cur then
                cur = icon.priority
                updateDebuff(icon, texture, count, dtype, duration, expires, true)
            else
                if icon.priority > cur then
                    updateDebuff(icon, texture, count, dtype, duration, expires, true)
                end
            end

            icon:Show()
            hide = false
        end

        index = index + 1
    end

    if hide then
        icon:Hide()
    end
end

local Enable = function(self)
    local auras = self.freebAuras

    if(auras) then
        auras.button = CreateAuraIcon(auras)

        self:RegisterEvent("UNIT_AURA", Update)
        return true
    end
end

local Disable = function(self)
    local auras = self.freebAuras

    if(auras) then
        self:UnregisterEvent("UNIT_AURA", Update)
    end
end

oUF:AddElement('freebAuras', Update, Enable, Disable)
