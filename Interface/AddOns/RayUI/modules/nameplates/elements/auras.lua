local R, L, P, G = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, GlobalDB
local mod = R:GetModule('NamePlates')
local LSM = LibStub("LibSharedMedia-3.0")

--Cache global variables
--Lua functions
local select, unpack = select, unpack
local tinsert, tremove = table.insert, table.remove
--WoW API / Variables
local CreateFrame = CreateFrame
local UnitBuff = UnitBuff
local UnitDebuff = UnitDebuff
local BUFF_STACKS_OVERFLOW = BUFF_STACKS_OVERFLOW

local auraCache = {}

function mod:SetAura(aura, index, name, icon, count, duration, expirationTime)
    aura.icon:SetTexture(icon);
    aura.name = name
    if ( count > 1 ) then
        local countText = count;
        if ( count >= 10 ) then
            countText = BUFF_STACKS_OVERFLOW;
        end
        aura.count:Show();
        aura.count:SetText(countText);
    else
        aura.count:Hide();
    end
    aura:SetID(index);
    if ( expirationTime and expirationTime ~= 0 ) then
        local startTime = expirationTime - duration;
        aura.cooldown:SetCooldown(startTime, duration);
        aura.cooldown:Show();
    else
        aura.cooldown:Hide();
    end
    aura:Show();
end

function mod:HideAuraIcons(auras)
    for i=1, #auras.icons do
        auras.icons[i]:Hide()
    end
end

--Allow certain auras with a duration of 0
local durationOverride = {
    [146739] = true, --Absolute Corruption (Warlock)
    [203981] = true, --Soul fragments (Demon Hunter)
}

function mod:UpdateElement_Auras(frame)
    local hasBuffs = false
    local hasDebuffs = false
    local auraFrame
    local name, icon, count, duration, expirationTime, unitCaster, spellId, isBossAura, _

    --Debuffs
    local index = 1
    local frameNum = 1
    local maxAuras = #frame.Debuffs.icons
    --Show both Boss buffs & debuffs in the debuff location
    --First, we go through all the debuffs looking for any boss flagged ones.

    self:HideAuraIcons(frame.Debuffs)
    if mod.db.showauras then
        while ( frameNum <= maxAuras ) do
            name, _, icon, count, _, duration, expirationTime, unitCaster, _, _, spellId, _, isBossAura = UnitDebuff(frame.displayedUnit, index)
            if ( name ) then
                if isBossAura or (unitCaster == mod.playerUnitToken and (duration > 0 or durationOverride[spellId]) and duration <= mod.db.maxDuration ) then
                    auraFrame = frame.Debuffs.icons[frameNum]
                    mod:SetAura(auraFrame, index, name, icon, count, duration, expirationTime)
                    frameNum = frameNum + 1
                    hasDebuffs = true
                end
            else
                break
            end
            index = index + 1
        end
    end

    --Buffs
	index = 1
	frameNum = 1
	maxAuras = #frame.Buffs.icons

    self:HideAuraIcons(frame.Buffs)
    if mod.db.showauras then
        while ( frameNum <= maxAuras ) do
            name, _, icon, count, _, duration, expirationTime, unitCaster, _, _, spellId, _, isBossAura = UnitBuff(frame.displayedUnit, index)
            if ( name ) then
                if isBossAura or (unitCaster == mod.playerUnitToken and (duration > 0 or durationOverride[spellId]) and duration <= mod.db.maxDuration ) then
                    auraFrame = frame.Buffs.icons[frameNum];
                    mod:SetAura(auraFrame, index, name, icon, count, duration, expirationTime)
                    frameNum = frameNum + 1
                    hasDebuffs = true
                end
            else
                break
            end
            index = index + 1;
        end
    end

    local TopLevel = frame.HealthBar
    local TopOffset = select(2, frame.Name:GetFont()) + 5
    if(hasDebuffs) then
        TopOffset = TopOffset + 3
        frame.Debuffs:SetPoint("BOTTOMLEFT", TopLevel, "TOPLEFT", 0, TopOffset)
        frame.Debuffs:SetPoint("BOTTOMRIGHT", TopLevel, "TOPRIGHT", 0, TopOffset)
        TopLevel = frame.Debuffs
        TopOffset = 3
    end

    if(hasBuffs) then
        if(not hasDebuffs) then
            TopOffset = TopOffset + 3
        end
        frame.Buffs:SetPoint("BOTTOMLEFT", TopLevel, "TOPLEFT", 0, TopOffset)
        frame.Buffs:SetPoint("BOTTOMRIGHT", TopLevel, "TOPRIGHT", 0, TopOffset)
        TopLevel = frame.Buffs
        TopOffset = 3
    end

    if (frame.TopLevelFrame ~= TopLevel) then
        frame.TopLevelFrame = TopLevel
        frame.TopOffset = TopOffset
        mod:ConfigureElement_Detection(frame)
    end
end

function mod:CreateAuraIcon(parent)
    local aura = CreateFrame("Frame", nil, parent)
    self:StyleFrame(aura)

    aura.icon = aura:CreateTexture(nil, "OVERLAY")
    aura.icon:SetAllPoints()
    aura.icon:SetTexCoord(.07, 1-.07, .23, 1-.23)

    aura.cooldown = CreateFrame("Cooldown", nil, aura, "CooldownFrameTemplate")
    aura.cooldown:SetAllPoints(aura)
    aura.cooldown:SetReverse(true)
    aura.cooldown.SizeOverride = 12
    -- R:RegisterCooldown(aura.cooldown)

    aura.count = aura:CreateFontString(nil, "OVERLAY")
    aura.count:SetPoint("BOTTOMRIGHT")
    aura.count:SetFont(LSM:Fetch("font", R.global.media.font), R.global.media.fontsize, R.global.media.fontflag)

    return aura
end

function mod:Auras_SizeChanged(width, height)
    local numAuras = #self.icons
    for i=1, numAuras do
        self.icons[i]:SetWidth((width - (mod.mult*numAuras)) / numAuras)
        self.icons[i]:SetHeight((mod.db.iconSize or 18) * (self:GetParent().HealthBar.currentScale or 1))
    end
    self:SetHeight((mod.db.iconSiz or 18) * (self:GetParent().HealthBar.currentScale or 1))
end

function mod:UpdateAuraIcons(auras)
    local maxAuras = mod.db.numAuras
    local numCurrentAuras = #auras.icons
    if numCurrentAuras > maxAuras then
        for i = maxAuras, numCurrentAuras do
            tinsert(auraCache, auras.icons[i])
            auras.icons[i]:Hide()
            auras.icons[i] = nil
        end
    end

    if numCurrentAuras ~= maxAuras then
        self.Auras_SizeChanged(auras, auras:GetWidth(), auras:GetHeight())
    end

    for i=1, maxAuras do
        auras.icons[i] = auras.icons[i] or tremove(auraCache) or mod:CreateAuraIcon(auras)
        auras.icons[i]:SetParent(auras)
        auras.icons[i]:ClearAllPoints()
        auras.icons[i]:Hide()
        auras.icons[i]:SetHeight(mod.iconSize or 18)

        if(auras.side == "LEFT") then
            if(i == 1) then
                auras.icons[i]:SetPoint("BOTTOMLEFT", auras, "BOTTOMLEFT")
            else
                auras.icons[i]:SetPoint("LEFT", auras.icons[i-1], "RIGHT", 3, 0)
            end
        else
            if(i == 1) then
                auras.icons[i]:SetPoint("BOTTOMRIGHT", auras, "BOTTOMRIGHT")
            else
                auras.icons[i]:SetPoint("RIGHT", auras.icons[i-1], "LEFT", -3, 0)
            end
        end
    end
end

function mod:ConstructElement_Auras(frame, side)
    local auras = CreateFrame("FRAME", nil, frame)

    auras:SetScript("OnSizeChanged", mod.Auras_SizeChanged)
    auras:SetHeight(18) -- this really doesn't matter
    auras.side = side
    auras.icons = {}

    return auras
end
