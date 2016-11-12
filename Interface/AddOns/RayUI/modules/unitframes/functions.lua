local R, L, P, G = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, GlobalDB
local RC = LibStub("LibRangeCheck-2.0")
local UF = R:GetModule("UnitFrames")
local oUF = RayUF or oUF

--Cache global variables
--Lua functions
local _G = _G
local select, unpack, tonumber, pairs, ipairs = select, unpack, tonumber, pairs, ipairs
local type, getfenv, setfenv = type, getfenv, setfenv
local math, string = math, string
local abs, floor = math.abs, math.floor
local format = string.format
local tinsert, tsort = table.insert, table.sort
local setmetatable = setmetatable
local GetTime = GetTime

--WoW API / Variables
local CreateFrame = CreateFrame
local GetNetStats = GetNetStats
local UnitIsPlayer = UnitIsPlayer
local UnitIsFriend = UnitIsFriend
local UnitClass = UnitClass
local UnitSpellHaste = UnitSpellHaste
local UnitBuff = UnitBuff
local UnitHealth = UnitHealth
local UnitHealthMax = UnitHealthMax
local UnitIsConnected = UnitIsConnected
local UnitIsDeadOrGhost = UnitIsDeadOrGhost
local UnitIsGhost = UnitIsGhost
local UnitIsEnemy = UnitIsEnemy
local UnitReaction = UnitReaction
local UnitPowerType = UnitPowerType
local UnitPower = UnitPower
local UnitPowerMax = UnitPowerMax
local UnitThreatSituation = UnitThreatSituation
local GetThreatStatusColor = GetThreatStatusColor
local UnitAlternatePowerInfo = UnitAlternatePowerInfo
local UnitHasVehicleUI = UnitHasVehicleUI
local UnitAura = UnitAura
local GetEclipseDirection = GetEclipseDirection
local GetSpecialization = GetSpecialization
local IsSpellKnown = IsSpellKnown
local UnitExists = UnitExists
local UnitIsUnit = UnitIsUnit
local IsShiftKeyDown = IsShiftKeyDown
local GetNumArenaOpponentSpecs = GetNumArenaOpponentSpecs
local GetArenaOpponentSpec = GetArenaOpponentSpec
local GetSpecializationInfoByID = GetSpecializationInfoByID
local UnitName = UnitName
local InCombatLockdown = InCombatLockdown
local UnregisterUnitWatch = UnregisterUnitWatch
local RegisterUnitWatch = RegisterUnitWatch
local RegisterStateDriver = RegisterStateDriver
local UnitFactionGroup = UnitFactionGroup
local UnitIsPVPFreeForAll = UnitIsPVPFreeForAll
local UnitIsPVP = UnitIsPVP

--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: SLASH_TestUF1, FriendsDropDown, INTERRUPT, SPELL_POWER_ECLIPSE, RayUF, PLAYER_OFFLINE
-- GLOBALS: DEAD, MAX_COMBO_POINTS, DebuffTypeColor, SPELL_POWER_HOLY_POWER, SPELL_POWER_CHI
-- GLOBALS: SPELL_POWER_DEMONIC_FURY, SPEC_WARLOCK_DEMONOLOGY, SHADOW_ORB_MINOR_TALENT_ID
-- GLOBALS: LOCALIZED_CLASS_NAMES_MALE, CLASS_SORT_ORDER, RayUFRaid40_6, MAX_BOSS_FRAMES
-- GLOBALS: UnitFrame_OnEnter, UnitFrame_OnLeave, PVP

local function ColorGradient(perc, color1, color2, color3)
    local r1,g1,b1 = 1, 0, 0
    local r2,g2,b2 = .85, .8, .45
    local r3,g3,b3 = .12, .12, .12

    if perc >= 1 then
        return r3, g3, b3
    elseif perc <= 0 then
        return r1, g1, b1
    end

    local segment, relperc = math.modf(perc*(3-1))
    local offset = (segment*3)+1

    -- < 50% > 0%
    if(offset == 1) then
        return r1 + (r2-r1)*relperc, g1 + (g2-g1)*relperc, b1 + (b2-b1)*relperc
    end
    -- < 99% > 50%
    return r2 + (r3-r2)*relperc, g2 + (g3-g2)*relperc, b2 + (b3-b2)*relperc
end

function UF:UnitFrame_OnEnter()
    UnitFrame_OnEnter(self)
    self.Mouseover:Show()
    self.isMouseOver = true
    for _, element in ipairs(self.mouseovers) do
        element:ForceUpdate()
    end
end

function UF:UnitFrame_OnLeave()
    UnitFrame_OnLeave(self)
    self.Mouseover:Hide()
    self.isMouseOver = nil
    for _, element in ipairs(self.mouseovers) do
        element:ForceUpdate()
    end
end

function UF:Construct_HealthBar(frame, bg, text)
    local health = CreateFrame("StatusBar", nil, frame)
    health:SetStatusBarTexture(R["media"].normal)
    health:SetFrameStrata("LOW")
    health.frequentUpdates = true
    health.PostUpdate = UF.PostUpdateHealth

    if self.db.smooth == true then
        health.Smooth = true
    end

    if bg then
        health.bg = health:CreateTexture(nil, "BORDER")
        health.bg:SetAllPoints()
        health.bg:SetTexture(R["media"].normal)
        health.bg:SetVertexColor(.33, .33, .33)
        health.bg.multiplier = .2
    end

    if text then
        health.value = frame.RaisedElementParent:CreateFontString(nil, "OVERLAY")
        health.value:SetFont(R["media"].font, R["media"].fontsize - 1, R["media"].fontflag)
        health.value:SetJustifyH("LEFT")
        health.value:SetParent(frame.RaisedElementParent)
    end

    if self.db.healthColorClass ~= true then
        if self.db.smoothColor == true then
            health:SetStatusBarColor(.1, .1, .1)
        else
            health.colorTapping = true
            health.colorClass = true
            health.colorReaction = true
            health.bg.multiplier = .8
        end
    else
        health.colorTapping = true
        health.colorClass = true
        health.colorReaction = true
    end
    health.colorDisconnected = true
    health:CreateShadow("Background")
    tinsert(frame.mouseovers, health)

    return health
end

function UF:Construct_PowerBar(frame, bg, text)
    local power = CreateFrame("StatusBar", nil, frame)
    power:SetStatusBarTexture(R["media"].normal)
    power.frequentUpdates = true
    power:SetFrameStrata("LOW")
    power.PostUpdate = self.PostUpdatePower

    if self.db.smooth == true then
        power.Smooth = true
    end

    if bg then
        power.bg = power:CreateTexture(nil, "BORDER")
        power.bg:SetAllPoints()
        power.bg:SetTexture(R["media"].normal)
        power.bg.multiplier = 0.2
    end

    if text then
        power.value = frame.RaisedElementParent:CreateFontString(nil, "OVERLAY")
        power.value:SetFont(R["media"].font, R["media"].fontsize - 1, R["media"].fontflag)
        power.value:SetJustifyH("LEFT")
        power.value:SetParent(frame.RaisedElementParent)
    end

    if self.db.powerColorClass == true then
        power.colorClass = true
        power.colorReaction = true
    else
        power.colorPower = true
    end

    power.colorDisconnected = true
    tinsert(frame.mouseovers, power)
    power:CreateShadow("Background")

    return power
end

function UF:Construct_NameText(frame)
    local name = frame.RaisedElementParent:CreateFontString(nil, "OVERLAY")
    name:SetFont(R["media"].font, R["media"].fontsize, R["media"].fontflag)
    name:Point("BOTTOMLEFT", frame.Health, "BOTTOMLEFT", 8, 3)
    name:SetJustifyH("LEFT")
    name:SetWordWrap(false)

    return name
end

function UF:Construct_Fader(frame)
    frame.FadeSmooth = 0.5
    frame.FadeMinAlpha = 0.15
    frame.FadeMaxAlpha = 1
    return true
end

function UF:Construct_Highlight(frame)
    local mouseover = frame.RaisedElementParent:CreateTexture(nil, "OVERLAY")
    mouseover:SetAllPoints(frame)
    mouseover:SetTexture("Interface\\AddOns\\RayUI\\media\\mouseover")
    mouseover:SetVertexColor(1,1,1,.36)
    mouseover:SetBlendMode("ADD")
    mouseover:Hide()

    return mouseover
end

function UF:Construct_Threat(frame)
    local threat = frame.RaisedElementParent:CreateTexture(nil, "OVERLAY")
    threat:SetAllPoints(frame.Health)
    threat:SetTexture("Interface\\AddOns\\RayUI\\media\\threat")
    threat:SetBlendMode("ADD")
    threat:Show()

    return threat
end

function UF:UpdatePvPIndicator(event, unit)
    if(unit ~= self.unit) then return end

    if(self.PvP) then
        local factionGroup = UnitFactionGroup(unit)
        if factionGroup == "Neutral" then
            self.PvP:SetTexture(nil)
            self.PvP:Hide()
        else
            if(UnitIsPVPFreeForAll(unit)) then
                self.PvP:SetTexture[[Interface\TargetingFrame\UI-PVP-FFA]]
                self.PvP:Show()
            elseif(factionGroup and UnitIsPVP(unit)) then
                self.PvP:SetTexture([[Interface\AddOns\RayUI\media\UI-PVP-]]..factionGroup)
                self.PvP:Show()
            else
                self.PvP:Hide()
            end
        end
    end
end

function UF:Construct_PvPIndicator(frame)
    local PvP = frame.RaisedElementParent:CreateTexture(nil, "BORDER")
    PvP:Size(35, 35)
    PvP:Point("TOPRIGHT", frame, 22, 8)
    PvP.Override = UF.UpdatePvPIndicator
    return PvP
end

function UF:Construct_CombatIndicator(frame)
    local Combat = frame.RaisedElementParent:CreateTexture(nil, "OVERLAY")
    Combat:Size(20, 20)
    Combat:ClearAllPoints()
    Combat:Point("LEFT", frame, "LEFT", -10, -5)
    Combat:SetTexture("Interface\\AddOns\\RayUI\\media\\combat")
    Combat:SetVertexColor(0.6, 0, 0)

    return Combat
end

function UF:Construct_RestingIndicator(frame)
    local Resting = frame.RaisedElementParent:CreateFontString(nil, "OVERLAY")
    Resting:SetFont(R["media"].font, 10, R["media"].fontflag)
    Resting:Point("BOTTOM", frame.Combat, "BOTTOM", 0, 25)
    Resting:SetText("zZz")
    Resting:SetTextColor(255/255, 255/255, 255/255, 0.70)

    return Resting
end

function UF:Construct_QuestIcon(frame)
    local QuestIcon = frame.RaisedElementParent:CreateTexture(nil, "BORDER")
    QuestIcon:Size(24, 24)
    QuestIcon:Point("BOTTOMRIGHT", frame, 15, -2)
    QuestIcon:SetTexture("Interface\\AddOns\\RayUI\\media\\quest")
    QuestIcon:SetVertexColor(0.8, 0.8, 0.8)

    return QuestIcon
end

function UF:Construct_RaidIcon(frame)
    local ricon = frame.RaisedElementParent:CreateTexture(nil, "BORDER")
    ricon:Point("BOTTOM", frame, "TOP", 0, -7)
    ricon:Size(24, 24)
    ricon:SetTexture("Interface\\AddOns\\RayUI\\media\\raidicons.blp")

    return ricon
end

function UF:Construct_Portrait(frame)
    local portrait = CreateFrame("PlayerModel", nil, frame)
    portrait:SetFrameStrata("LOW")
    portrait:SetFrameLevel(frame.Health:GetFrameLevel() + 1)
    portrait:SetInside(frame.Health, 1, 1)
    portrait:SetAlpha(.2)
    portrait:SetCamDistanceScale(1)
    if frame.unit and frame.unit:find("boss") then
        portrait.PostUpdate = nil
    end

    portrait.overlay = CreateFrame("Frame", nil, frame)
    portrait.overlay:SetFrameLevel(frame:GetFrameLevel() + 5)

    frame.Health.bg:ClearAllPoints()
    frame.Health.bg:Point("BOTTOMLEFT", frame.Health:GetStatusBarTexture(), "BOTTOMRIGHT")
    frame.Health.bg:Point("TOPRIGHT", frame.Health)
    frame.Health.bg:SetParent(portrait.overlay)

    return portrait
end

function UF:Construct_Debuffs(frame)
    local debuffs = CreateFrame("Frame", frame:GetName().."Debuffs", frame)
    debuffs:SetHeight(20)
    debuffs:SetWidth(frame.UNIT_WIDTH)
    debuffs.spacing = 3.8
    debuffs.size = 20
    debuffs.num = 9
    debuffs.PostCreateIcon = self.PostCreateIcon
    debuffs.PostUpdateIcon = self.PostUpdateIcon

    return debuffs
end

function UF:Construct_Buffs(frame)
    local buffs = CreateFrame("Frame", frame:GetName().."Buffs", frame)
    buffs:SetHeight(20)
    buffs:SetWidth(frame.UNIT_WIDTH)
    buffs.spacing = 3.8
    buffs.size = 20
    buffs.num = 9
    buffs.PostCreateIcon = self.PostCreateIcon
    buffs.PostUpdateIcon = self.PostUpdateIcon

    return buffs
end

function UF:Construct_SmartAura(frame)
    local auras = CreateFrame("Frame", frame:GetName().."SmartAuras", frame)
    auras.isSmartAura = true
    auras:SetHeight(38)
    auras:SetWidth(frame.UNIT_WIDTH * 2)
    auras.spacing = 6
    auras.size = 32
    auras.PreSetPosition = (not frame:GetScript("OnUpdate")) and UF.SortAuras or nil
    auras.PostCreateIcon = self.PostCreateIcon
    auras.PostUpdateIcon = self.PostUpdateIcon
    auras.CustomFilter = self.CustomSmartFilter

    return auras
end

function UF:CustomSmartFilter(unit, icon, name, rank, texture, count, debuffType, duration, expirationTime, unitCaster, isStealable, _, spellID, canApplyAura, isBossDebuff, _, nameplateShowAll, timeMod, value1, value2, value3)
    local returnValue = true
    local isPlayer = unitCaster == "player" or unitCaster == "vehicle"

    icon.isPlayer = isPlayer
    icon.owner = unitCaster
    icon.name = name
    icon.priority = -1

    if isPlayer then
        returnValue = true
    else
        returnValue = false
    end

    if (duration and (duration > 60)) or (duration == 0 or not duration) then
        returnValue = false
    end

    if R.global["UnitFrames"]["aurafilters"]["Blacklist"][spellID] then
        returnValue = false
    end

    if R.global["UnitFrames"]["aurafilters"]["Whitelist"][spellID] then
        icon.priority = R.global["UnitFrames"]["aurafilters"]["Whitelist"][spellID].priority
        returnValue = true
    end

    if R.global["UnitFrames"]["aurafilters"]["TurtleBuffs"][spellID] then
        icon.priority = R.global["UnitFrames"]["aurafilters"]["TurtleBuffs"][spellID].priority
        returnValue = true
    end

    if R.global["UnitFrames"]["aurafilters"]["CCDebuffs"][spellID] then
        icon.priority = R.global["UnitFrames"]["aurafilters"]["CCDebuffs"][spellID].priority
        returnValue = true
    end

    if icon.value then
        icon.value:SetText("")
        if returnValue and value1 and value1 > 0 then
            icon.value:SetText(R:ShortValue(value1))
        end
    end

    return returnValue
end

local function SortAurasByTime(a, b)
    if a and b then
        if a:IsShown() and b:IsShown() then
            local aTime = a.expiration or -1
            local bTime = b.expiration or -1
            return aTime < bTime
        elseif a:IsShown() then
            return true
        end
    end
end

local function SortAurasByPriority(a, b)
    if a and b then
        if a:IsShown() and b:IsShown() then
            if a.isPlayer and not b.isPlayer then
                return true
            elseif not a.isPlayer and b.isPlayer then
                return false
            end

            if (a.priority and b.priority) then
                return a.priority > b.priority
            end
        elseif a:IsShown() then
            return true
        end
    end
end

local function SortAurasByPriorityAndTime(a, b)
    if a and b then
        if a:IsShown() and b:IsShown() then
            if a.isPlayer and not b.isPlayer then
                return true
            elseif not a.isPlayer and b.isPlayer then
                return false
            end
            local aTime = a.expiration or -1
            local bTime = b.expiration or -1
            if (a.priority and b.priority) then
                if a.priority ~= b.priority then
                    return a.priority > b.priority
                else
                    return aTime < bTime
                end
            end
        elseif a:IsShown() then
            return true
        end
    end
end

function UF:SortAuras()
    tsort(self, SortAurasByPriorityAndTime)

    return 1, #self
end

function UF:Construct_CastBar(frame)
    local castbar = CreateFrame("StatusBar", nil, frame)
    castbar:SetStatusBarTexture(R["media"].normal)
    castbar:GetStatusBarTexture():SetDrawLayer("BORDER")
    castbar:GetStatusBarTexture():SetHorizTile(false)
    castbar:GetStatusBarTexture():SetVertTile(false)
    castbar:SetFrameStrata("HIGH")
    castbar:SetHeight(4)

    local spark = castbar:CreateTexture(nil, "OVERLAY")
    spark:SetDrawLayer("OVERLAY", 7)
    spark:SetTexture[[Interface\CastingBar\UI-CastingBar-Spark]]
    spark:SetBlendMode("ADD")
    spark:SetAlpha(.8)
    spark:Point("TOPLEFT", castbar:GetStatusBarTexture(), "TOPRIGHT", -10, 13)
    spark:Point("BOTTOMRIGHT", castbar:GetStatusBarTexture(), "BOTTOMRIGHT", 10, -13)
    castbar.Spark = spark

    castbar:CreateShadow("Background")
    castbar.bg = castbar:CreateTexture(nil, "BACKGROUND")
    castbar.bg:SetTexture(R["media"].normal)
    castbar.bg:SetAllPoints(true)
    castbar.bg:SetVertexColor(.12, .12, .12)
    castbar.Text = castbar:CreateFontString(nil, "OVERLAY")
    castbar.Text:SetFont(R["media"].font, 12, "THINOUTLINE")
    castbar.Text:SetPoint("BOTTOMLEFT", castbar, "TOPLEFT", 5, -2)
    castbar.Time = castbar:CreateFontString(nil, "OVERLAY")
    castbar.Time:SetFont(R["media"].font, 12, "THINOUTLINE")
    castbar.Time:SetJustifyH("RIGHT")
    castbar.Time:SetPoint("BOTTOMRIGHT", castbar, "TOPRIGHT", -5, -2)
    castbar.Iconbg = CreateFrame("Frame", nil ,castbar)
    castbar.Iconbg:SetPoint("BOTTOMRIGHT", castbar, "BOTTOMLEFT", -5, 0)
    castbar.Iconbg:SetSize(20, 20)
    castbar.Iconbg:CreateShadow("Background")
    castbar.Icon = castbar.Iconbg:CreateTexture(nil, "OVERLAY")
    castbar.Icon:SetAllPoints(castbar.Iconbg)
    castbar.Icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
    castbar.PostCastStart = UF.PostCastStart
    castbar.PostChannelStart = UF.PostCastStart
    castbar.PostCastStop = UF.PostCastStop
    castbar.PostChannelStop = UF.PostCastStop
    castbar.PostChannelUpdate = UF.PostChannelUpdate
    castbar.CustomTimeText = UF.CustomCastTimeText
    castbar.CustomDelayText = UF.CustomCastDelayText
    castbar.PostCastInterruptible = UF.PostCastInterruptible
    castbar.PostCastNotInterruptible = UF.PostCastNotInterruptible
    -- castbar.PostCastFailed = UF.PostCastFailed
    castbar.PostCastInterrupted = UF.PostCastFailed

    -- castbar.OnUpdate = UF.OnCastbarUpdate

    return castbar
end

local ticks = {}
function UF:HideTicks(frame)
    for i=1, #ticks do
        ticks[i]:Hide()
    end
    frame.SafeZone:Show()
end

function UF:SetCastTicks(frame, numTicks, extraTick)
    extraTick = extraTick or 0
    UF:HideTicks(frame)
    if numTicks and numTicks <= 0 then return end
    local w = frame:GetWidth()
    local d = w / (numTicks + extraTick)
    local _, _, _, ms = GetNetStats()
    for i = 1, numTicks + extraTick do
        if not ticks[i] then
            ticks[i] = frame:CreateTexture(nil, "OVERLAY", 5)
            ticks[i]:SetTexture(R["media"].normal)
            ticks[i]:SetVertexColor(1, 0, 0, 0.75)
            ticks[i]:Width(1)
            ticks[i]:SetHeight(frame:GetHeight())
        end

        local width
        if(ms ~= 0) then
            local perc = (w / frame.max) * (ms / 1e5)
            if(perc > 1) then perc = 1 end

            width = (w * perc) / (numTicks + extraTick)
        else
            width = 2
        end

        if (d * (i - 1) + width > w) then
            width = w - d * (i - 1)
        end

        ticks[i]:SetWidth(width)
        ticks[i]:ClearAllPoints()
        ticks[i]:SetPoint("LEFT", frame, "LEFT", d * (i - 1), 0)
        ticks[i]:Show()
    end
    frame.SafeZone:Hide()
end

local MageSpellName = GetSpellInfo(5143) --Arcane Missiles
local MageBuffName = GetSpellInfo(166872) --4p T17 bonus proc for arcane

function UF:PostCastStart(unit, name, rank, castid)
    if unit == "vehicle" then unit = "player" end
    local r, g, b
    if UnitIsPlayer(unit) and UnitIsFriend(unit, "player") and R.myname == "夏可醬" then
        r, g, b = 95/255, 182/255, 255/255
    elseif UnitIsPlayer(unit) and UnitIsFriend(unit, "player") then
        r, g, b = unpack(oUF.colors.class[select(2, UnitClass(unit))])
    elseif self.interrupt then
        r, g, b = unpack(oUF.colors.reaction[1])
    else
        r, g, b = unpack(oUF.colors.reaction[5])
    end
    self:SetBackdropColor(r * 1, g * 1, b * 1)
    if unit:find("arena%d") or unit:find("boss%d") then
        self:SetStatusBarColor(r * 1, g * 1, b * 1, .2)
    else
        self:SetStatusBarColor(r * 1, g * 1, b * 1)
    end

    self.unit = unit

    if unit == "player" then
        local unitframe = R.global.UnitFrames
        local baseTicks = unitframe.ChannelTicks[name]

        -- Detect channeling spell and if it's the same as the previously channeled one
        if baseTicks and name == self.prevSpellCast then
            self.chainChannel = true
        elseif baseTicks then
            self.chainChannel = nil
            self.prevSpellCast = name
        end

        if baseTicks and unitframe.ChannelTicksSize[name] and unitframe.HastedChannelTicks[name] then
            local tickIncRate = 1 / baseTicks
            local curHaste = UnitSpellHaste("player") * 0.01
            local firstTickInc = tickIncRate / 2
            local bonusTicks = 0
            if curHaste >= firstTickInc then
                bonusTicks = bonusTicks + 1
            end

            local x = tonumber(R:Round(firstTickInc + tickIncRate, 2))
            while curHaste >= x do
                x = tonumber(R:Round(firstTickInc + (tickIncRate * bonusTicks), 2))
                if curHaste >= x then
                    bonusTicks = bonusTicks + 1
                end
            end

            local baseTickSize = unitframe.ChannelTicksSize[name]
            local hastedTickSize = baseTickSize / (1 + curHaste)
            local extraTick = self.max - hastedTickSize * (baseTicks + bonusTicks)
            local extraTickRatio = extraTick / hastedTickSize

            UF:SetCastTicks(self, baseTicks + bonusTicks, extraTickRatio)
        elseif baseTicks and unitframe.ChannelTicksSize[name] then
            local curHaste = UnitSpellHaste("player") * 0.01
            local baseTickSize = unitframe.ChannelTicksSize[name]
            local hastedTickSize = baseTickSize / (1 + curHaste)
            local extraTick = self.max - hastedTickSize * (baseTicks)
            local extraTickRatio = extraTick / hastedTickSize

            UF:SetCastTicks(self, baseTicks, extraTickRatio)
        elseif baseTicks then
            local hasBuff = UnitBuff("player", MageBuffName)
            if name == MageSpellName and hasBuff then
                baseTicks = baseTicks + 5
            end
            UF:SetCastTicks(self, baseTicks)
        else
            UF:HideTicks(self)
        end
    end
end

function UF:CustomCastTimeText(duration)
    -- self.Time:SetText(("%.1f | %.1f"):format(self.channeling and duration or self.max - duration, self.max))
    if self.channeling then
        self.Time:SetText(("%.1f | %.1f"):format(duration, self.max))
    else
        self.Time:SetText(("%.1f | %.1f"):format(abs(duration - self.max), self.max))
    end
end

function UF:CustomCastDelayText(duration)
    -- self.Time:SetText(("%.1f |cffff0000%s %.1f|r"):format(self.channeling and duration or self.max - duration, self.channeling and "- " or "+", self.delay))
    if self.channeling then
        self.Time:SetText(("%.1f | %.1f |cffff0000%.1f|r"):format(duration, self.max, self.delay))
    else
        self.Time:SetText(("%.1f | %.1f |cffff0000%s %.1f|r"):format(abs(duration - self.max), self.max, "+", self.delay))
    end
end

function UF:PostCastStop(unit, name, castid)
    self.chainChannel = nil
    self.prevSpellCast = nil
end

function UF:PostChannelUpdate(unit, name)
    if not (unit == "player" or unit == "vehicle") then return end

    local unitframe = R.global.UnitFrames
    local baseTicks = unitframe.ChannelTicks[name]

    if baseTicks then
        local extraTick = 0
        if self.chainChannel then
            extraTick = 1
            self.chainChannel = nil
        end

        UF:SetCastTicks(self, baseTicks, extraTick)
    else
        UF:HideTicks(self)
    end
end

function UF:PostCastInterruptible(unit)
    if unit == "vehicle" then unit = "player" end
    if unit ~= "player" then
        local r, g, b
        if UnitIsPlayer(unit) and UnitIsFriend(unit, "player") and R.myname == "夏可" then
            r, g, b = 95/255, 182/255, 255/255
        elseif UnitIsPlayer(unit) and UnitIsFriend(unit, "player") then
            r, g, b = unpack(oUF.colors.class[select(2, UnitClass(unit))])
        else
            r, g, b = unpack(oUF.colors.reaction[6])
        end
        self:SetBackdropColor(r * 1, g * 1, b * 1)
        if unit:find("arena%d") or unit:find("boss%d") then
            self:SetStatusBarColor(r * 1, g * 1, b * 1, .2)
        else
            self:SetStatusBarColor(r * 1, g * 1, b * 1)
        end
    end
end

function UF:PostCastNotInterruptible(unit)
    local r, g, b
    if UnitIsPlayer(unit) and UnitIsFriend(unit, "player") and R.myname == "夏可可" then
        r, g, b = 95/255, 182/255, 255/255
    elseif UnitIsPlayer(unit) and UnitIsFriend(unit, "player") then
        r, g, b = unpack(oUF.colors.class[select(2, UnitClass(unit))])
    else
        r, g, b = unpack(oUF.colors.reaction[5])
    end
    self:SetBackdropColor(r * 1, g * 1, b * 1)
    if unit:find("arena%d") or unit:find("boss%d") then
        self:SetStatusBarColor(r * 1, g * 1, b * 1, .2)
    else
        self:SetStatusBarColor(r * 1, g * 1, b * 1)
    end
end

function UF:PostCastFailed(event, unit, name, rank, castid)
    self:SetStatusBarColor(unpack(oUF.colors.reaction[1]))
    self:SetValue(self.max)
    self:Show()
end

function UF:OnCastbarUpdate(elapsed)
    if(self.casting) then
        self.Spark:Show()
        self:SetAlpha(1)
        local duration = self.duration + elapsed
        if(duration >= self.max) then
            self.casting = nil
            self:Hide()

            if(self.PostCastStop) then self:PostCastStop(self.__owner.unit) end
            return
        end

        if(self.SafeZone) then
            local width = self:GetWidth()
            local _, _, _, ms = GetNetStats()
            local safeZonePercent = (width / self.max) * (ms / 1e5)
            if(safeZonePercent > 1) then safeZonePercent = 1 end
            self.SafeZone:SetWidth(width * safeZonePercent)
        end

        if(self.Time) then
            if(self.delay ~= 0) then
                self:CustomDelayText(duration)
            else
                self:CustomTimeText(duration)
            end
        end

        self.duration = duration
        self:SetValue(duration)

        if(self.Spark) then
            self.Spark:SetPoint("CENTER", self, "LEFT", (duration / self.max) * self:GetWidth(), 0)
            self.Spark:Show()
        end
    elseif(self.channeling) then
        self:SetAlpha(1)
        local duration = self.duration - elapsed

        if(duration <= 0) then
            self.channeling = nil
            self:Hide()

            if(self.PostChannelStop) then self:PostChannelStop(self.__owner.unit) end
            return
        end

        if(self.SafeZone) then
            local width = self:GetWidth()
            local _, _, _, ms = GetNetStats()
            local safeZonePercent = (width / self.max) * (ms / 1e5)
            if(safeZonePercent > 1) then safeZonePercent = 1 end
            self.SafeZone:SetWidth(width * safeZonePercent)
        end

        if(self.Time) then
            if(self.delay ~= 0) then
                self:CustomDelayText(duration)
            else
                self:CustomTimeText(duration)
            end
        end

        self.duration = duration
        self:SetValue(duration)
        if(self.Spark) then
            self.Spark:Show()
            self.Spark:SetPoint("CENTER", self, "LEFT", (duration / self.max) * self:GetWidth(), 0)
        end
    else
        if(self.SafeZone) then
            self.SafeZone:Hide()
        end
        if(self.Spark) then
            self.Spark:Hide()
        end
        local alpha = self:GetAlpha() - 0.02
        if alpha > 0 then
            self:SetAlpha(alpha)
        else
            self:Hide()
        end
        if(self.Time) then
            self.Time:SetText(INTERRUPT)
        end
    end
end

function UF:PostUpdateHealth(unit, cur, max)
    local curhealth, maxhealth = UnitHealth(unit), UnitHealthMax(unit)
    local r, g, b = self:GetStatusBarColor()
    if self:GetParent().isForced then
        curhealth = math.random(1, maxhealth)
        self:SetValue(curhealth)
    end
    if UF.db.smoothColor then
        r,g,b = ColorGradient(curhealth/maxhealth)
    else
        r,g,b = .12, .12, .12
    end
    if not UF.db.healthColorClass then
        if(b) then
            self:SetStatusBarColor(r, g, b, 1)
        elseif not UnitIsConnected(unit) then
            local color = RayUF.colors.disconnected
            local power = self.__owner.Power
            if power then
                power:SetValue(0)
                if power.value then
                    power.value:SetText(nil)
                end
            end
            return self.value:SetFormattedText("|cff%02x%02x%02x%s|r", color[1] * 255, color[2] * 255, color[3] * 255, PLAYER_OFFLINE)
        elseif UnitIsDeadOrGhost(unit) then
            local color = RayUF.colors.disconnected
            local power = self.__owner.Power
            if power then
                power:SetValue(0)
                if power.value then
                    power.value:SetText(nil)
                end
            end
            return self.value:SetFormattedText("|cff%02x%02x%02x%s|r", color[1] * 255, color[2] * 255, color[3] * 255, UnitIsGhost(unit) and L["灵魂"] or DEAD)
        end
        if UF.db.smoothColor then
            if UnitIsDeadOrGhost(unit) or (not UnitIsConnected(unit)) then
                self:SetStatusBarColor(.5, .5, .5)
                self.bg:SetVertexColor(.5, .5, .5)
            else
                self.bg:SetVertexColor(r*.25, g*.25, b*.25)
            end
        end
    end
    local color = {1,1,1}
    if UnitIsPlayer(unit) then
        local _, class = UnitClass(unit)
        if class then
            color = oUF.colors.class[class]
        end
    elseif UnitIsEnemy(unit, "player") then
        color = oUF.colors.reaction[1]
    else
        color = oUF.colors.reaction[UnitReaction(unit, "player") or 5]
    end
    -- 如果是hover状态，总是显示
    if self.__owner.isMouseOver then
        if UF.db.showHealthValue then
            self.value:SetFormattedText("|cff%02x%02x%02x%.1f%%|r", color[1] * 255, color[2] * 255, color[3] * 255, cur / max * 100)
        else
            self.value:SetFormattedText("|cff%02x%02x%02x%s|r", color[1] * 255, color[2] * 255, color[3] * 255, R:ShortValue(cur))
        end
        -- 否则当血量不满或者设置了总是显示时显示
    elseif UF.db.alwaysShowHealth or cur < max then
        if UF.db.showHealthValue then
            self.value:SetFormattedText("|cff%02x%02x%02x%s|r", color[1] * 255, color[2] * 255, color[3] * 255, R:ShortValue(cur))
        else
            self.value:SetFormattedText("|cff%02x%02x%02x%.1f%%|r", color[1] * 255, color[2] * 255, color[3] * 255, cur / max * 100)
        end
    else
        self.value:SetText(nil)
    end
end

function UF:PostUpdatePower(unit, cur, max)
    local shown = self:IsShown()
    if max == 0 then
        if shown then
            self:Hide()
        end
        return
    elseif not shown then
        self:Show()
    end
    if UnitIsDeadOrGhost(unit) then
        self:SetValue(0)
        if self.value then
            self.value:SetText(nil)
        end
        return
    end
    if not self.value then return end
    local _, type = UnitPowerType(unit)
    local color = oUF.colors.power[type] or oUF.colors.power.FUEL
    if self:GetParent().isForced then
        local min = math.random(1, max)
        local type = math.random(0, 4)
        self:SetValue(min)
    end
    if cur < max then
        if self.__owner.isMouseOver then
            self.value:SetFormattedText("%s - |cff%02x%02x%02x%s|r", R:ShortValue(UnitPower(unit)), color[1] * 255, color[2] * 255, color[3] * 255, R:ShortValue(UnitPowerMax(unit)))
        elseif type == "MANA" then
            self.value:SetFormattedText("|cff%02x%02x%02x%.1f%%|r", color[1] * 255, color[2] * 255, color[3] * 255, UnitPower(unit) / UnitPowerMax(unit) * 100)
        elseif cur > 0 then
            self.value:SetFormattedText("|cff%02x%02x%02x%d|r", color[1] * 255, color[2] * 255, color[3] * 255, UnitPower(unit))
        else
            self.value:SetText(nil)
        end
    elseif type == "MANA" and self.__owner.isMouseOver then
        self.value:SetFormattedText("|cff%02x%02x%02x%s|r", color[1] * 255, color[2] * 255, color[3] * 255, R:ShortValue(UnitPowerMax(unit)))
    else
        self.value:SetText(nil)
    end
end

function UF:PostAltUpdate(min, cur, max)
    local perc = math.floor((cur/max)*100)

    if perc < 35 then
        self:SetStatusBarColor(0, 1, 0)
    elseif perc < 70 then
        self:SetStatusBarColor(1, 1, 0)
    else
        self:SetStatusBarColor(1, 0, 0)
    end

    local unit = self:GetParent().unit

    if unit == "player" and self.text then
        local type = select(10, UnitAlternatePowerInfo(unit))

        if perc > 0 then
            self.text:SetText(type..": "..format("%d%%", perc))
        else
            self.text:SetText(type..": 0%")
        end
    elseif unit and unit:find("boss%d") and self.text then
        self.text:SetTextColor(self:GetStatusBarColor())
        -- if not self:GetParent().Power.value:GetText() or self:GetParent().Power.value:GetText() == "" then
        -- self.text:Point("BOTTOMRIGHT", self:GetParent().Health, "BOTTOMRIGHT")
        -- else
        -- self.text:Point("RIGHT", self:GetParent().Power.value.value, "LEFT", 2, E.mult)
        -- end
        if perc > 0 then
            self.text:SetText("|cffD7BEA5[|r"..format("%d%%", perc).."|cffD7BEA5]|r")
        else
            self.text:SetText(nil)
        end
    end
end

function UF:PostUpdateIcon(unit, icon, index, offset)
    local name, _, _, _, dtype, duration, expirationTime, unitCaster, canStealOrPurge = UnitAura(unit, index, icon.filter)

    local texture = icon.icon
    if icon.isDebuff and not self.isSmartAura then
        if icon.owner == "player" or icon.owner == "pet" or icon.owner == "vehicle" or UnitIsFriend("player", unit) then
            local color = DebuffTypeColor[dtype] or DebuffTypeColor.none
            icon.border:SetBackdropBorderColor(color.r * 0.6, color.g * 0.6, color.b * 0.6)
            icon:StyleButton(1)
            texture:Point("TOPLEFT", icon, 1, -1)
            texture:Point("BOTTOMRIGHT", icon, -1, 1)
            texture:SetDesaturated(false)
        else
            icon.border:SetBackdropBorderColor(unpack(R["media"].bordercolor))
            icon:StyleButton(true)
            texture:Point("TOPLEFT", icon)
            texture:Point("BOTTOMRIGHT", icon)
            texture:SetDesaturated(true)
        end
    elseif not self.isSmartAura then
        if (canStealOrPurge or ((R.myclass == "PRIEST" or R.myclass == "SHAMAN" or R.myclass == "MAGE") and dtype == "Magic")) and not UnitIsFriend("player", unit) then
            icon.border:SetBackdropBorderColor(237/255, 234/255, 142/255)
            icon:GetHighlightTexture():StyleButton(1)
            texture:StyleButton(1)
            texture:Point("TOPLEFT", icon, 1, -1)
            texture:Point("BOTTOMRIGHT", icon, -1, 1)
        else
            icon:GetHighlightTexture():StyleButton(true)
            icon.border:SetBackdropBorderColor(unpack(R["media"].bordercolor))
            texture:Point("TOPLEFT", icon)
            texture:Point("BOTTOMRIGHT", icon)
        end
    end

    icon.duration = duration
    icon.expirationTime = expirationTime
    if expirationTime and duration ~= 0 then
        icon.expiration = expirationTime - GetTime()
    end
    if duration == 0 or expirationTime == 0 then
        icon.expiration = nil
    end
end

function UF:PostCreateIcon(button)
    button.RaisedElementParent = CreateFrame("Frame", nil, button)
    button.RaisedElementParent:SetFrameLevel(button:GetFrameLevel() + 100)

    button:SetFrameStrata("BACKGROUND")
    local count = button.count
    count:SetParent(button.RaisedElementParent)
    count:ClearAllPoints()
    count:Point("BOTTOMRIGHT", button , "BOTTOMRIGHT", 4, -4)
    count:SetFontObject(nil)
    count:SetFont(R["media"].font, math.max(R["media"].fontsize * (R:Round(self.size) / 30), 12), R["media"].fontflag)

    button.icon:SetTexCoord(.1, .9, .1, .9)
    button:CreateShadow()
    button.shadow:SetBackdropColor(0, 0, 0)
    button.overlay:Hide()
    button.cd:SetReverse(true)

    if self.isSmartAura then
        button.value = button.RaisedElementParent:CreateFontString(nil, "OVERLAY")
        button.value:SetFont(R["media"].font, ( R["media"].fontsize - 3 ) * (R:Round(self.size) / 30), R["media"].fontflag)
        button.value:SetPoint("CENTER", button , "TOP", 0, 1)
        button.value:SetJustifyH("RIGHT")
    end

    button.pushed = true
    button:StyleButton(true)
end

function UF:CustomFilter(unit, icon, name, rank, texture, count, debuffType, duration, expirationTime, unitCaster, isStealable, _, spellID)
    local isPlayer

    if(unitCaster == "player" or unitCaster == "vehicle") then
        isPlayer = true
    end

    if name then
        icon.isPlayer = isPlayer
        icon.owner = unitCaster
    end

    if UF.db.smartAura then
        return not UF:CustomSmartFilter(unit, icon, name, rank, texture, count, debuffType, duration, expirationTime, unitCaster, isStealable, _, spellID)
    end

    return true
end

function UF:EnableHealPredictionAndAbsorb(frame)
    local mhpb = frame.RaisedElementParent:CreateTexture(nil, "BORDER", 5)
    mhpb:SetWidth(1)
    mhpb:SetTexture(R["media"].normal)
    mhpb:SetVertexColor(0, 1, 0.5, 0.25)

    local ohpb = frame.RaisedElementParent:CreateTexture(nil, "BORDER", 5)
    ohpb:SetWidth(1)
    ohpb:SetTexture(R["media"].normal)
    ohpb:SetVertexColor(0, 1, 0, 0.25)

    local abb = frame.RaisedElementParent:CreateTexture(nil, "BORDER", 5)
    abb:SetWidth(1)
    abb:SetTexture(R["media"].normal)
    abb:SetVertexColor(.66, 1, 1, .7)

    local abbo = frame.RaisedElementParent:CreateTexture(nil, "ARTWORK", 1)
    abbo:SetAllPoints(abb)
    abbo:SetTexture("Interface\\RaidFrame\\Shield-Overlay", true, true)
    abbo.tileSize = 32

    local oag = frame.RaisedElementParent:CreateTexture(nil, "ARTWORK", 1)
    oag:SetWidth(15)
    oag:SetTexture("Interface\\RaidFrame\\Shield-Overshield")
    oag:SetBlendMode("ADD")
    oag:SetPoint("TOPLEFT", frame.Health, "TOPRIGHT", -5, 0)
    oag:SetPoint("BOTTOMLEFT", frame.Health, "BOTTOMRIGHT", -5, 0)

    frame.HealPredictionAndAbsorb = {
        myBar = mhpb,
        otherBar = ohpb,
        absorbBar = abb,
        absorbBarOverlay = abbo,
        overAbsorbGlow = oag,
        maxOverflow = 1,
    }
end

function UF:AuraBarFilter(unit, name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, shouldConsolidate, spellID)
    if R.global.UnitFrames.InvalidSpells[spellID] then
        return false
    end
    local returnValue = true
    local returnValueChanged = false
    local isPlayer, isFriend

    if unitCaster == "player" or unitCaster == "vehicle" then isPlayer = true end
    if UnitIsFriend("player", unit) then isFriend = true end

    if isPlayer then
        returnValue = true
    else
        returnValue = false
    end

    if (duration == 0 or not duration) then
        returnValue = false
    end

    if R.global["UnitFrames"]["aurafilters"]["Blacklist"][name] then
        returnValue = false
    end

    if R.global["UnitFrames"]["aurafilters"]["Whitelist"][name] then
        returnValue = true
    end

    return returnValue
end

local RangeColors = {
    [5] = RayUF.colors.reaction[5],
    [30] = RayUF.colors.reaction[4],
    [35] = RayUF.colors.reaction[3],
    [40] = {1.00, 0.38, 0.08, 1},
    [100] = RayUF.colors.reaction[1],
}

function UF:Construct_RangeText(frame)
    local text = frame.RaisedElementParent:CreateFontString(nil, "OVERLAY")
    text:SetFont(R["media"].pxfont, R.mult*10, "OUTLINE,MONOCHROME")
    text:SetJustifyH("RIGHT")
    text:SetParent(frame.RaisedElementParent)
    text:Point("TOPRIGHT", frame, "TOPLEFT", -2, 3)
    return text
end

function UF:RangeDisplayUpdate(frame)
    if ( not UnitExists("target") ) or ( not frame.RangeText ) then return end

    -- Get range
    local section
    local minRange, maxRange = RC:GetRange("target")

    -- No change? Skip
    if ((minRange == frame.RangeText.lastMinRange) and (maxRange == frame.RangeText.lastMaxRange)) then return end

    frame.RangeText.lastMinRange = minRange
    frame.RangeText.lastMaxRange = maxRange

    -- Get Range section
    if UnitIsUnit("player", "target") then maxRange = nil end
    if minRange > 80 then maxRange = nil end
    if maxRange then
        if maxRange <= 5 then
            section = 5
        elseif maxRange <= 30 then
            section = 30
        elseif maxRange <= 35 then
            section = 35
        elseif maxRange <= 40 then
            section = 40
        else
            section = 100
        end
        frame.RangeText:SetFormattedText("%d", maxRange)
        frame.RangeText:SetTextColor(RangeColors[section][1], RangeColors[section][2], RangeColors[section][3])
    else
        frame.RangeText:SetText("")
    end
end

function UF:Construct_AuraBars()
    local bar = self.statusBar

    bar:ClearAllPoints()
    bar:SetAllPoints()
    bar:CreateShadow("Background")

    bar:SetStatusBarColor(unpack(RayUF.colors.class[R.myclass]))

    bar.spelltime:FontTemplate(R["media"].font, R["media"].fontsize, "OUTLINE")
    bar.spellname:FontTemplate(R["media"].font, R["media"].fontsize, "OUTLINE")

    bar.spellname:ClearAllPoints()
    bar.spellname:SetPoint("LEFT", bar, "LEFT", 2, 0)
    bar.spellname:SetPoint("RIGHT", bar, "RIGHT", -20, 0)

    bar.spelltime:ClearAllPoints()
    bar.spelltime:SetPoint("RIGHT", bar, "RIGHT", 0, 0)

    bar.iconHolder:CreateShadow("Background")
    bar.icon:SetDrawLayer("OVERLAY")

    bar.iconHolder:RegisterForClicks("RightButtonUp")
    bar.iconHolder:SetScript("OnClick", function(self)
            if not IsShiftKeyDown() then return end
            local auraName = self:GetParent().aura.name

            if auraName then
                R.global["UnitFrames"]["aurafilters"]["Blacklist"][auraName] = true
            end
        end)
end

function UF:Construct_AuraBarHeader(frame)
    local auraBar = CreateFrame("Frame", nil, frame)
    auraBar.PostCreateBar = UF.Construct_AuraBars
    auraBar.gap = 4
    auraBar.spacing = 4
    auraBar.spark = true
    auraBar.sort = true
    auraBar.filter = UF.AuraBarFilter
    auraBar.friendlyAuraType = "HELPFUL"
    auraBar.enemyAuraType = "HARMFUL"
    auraBar.auraBarTexture = R["media"].normal
    auraBar.buffColor = RayUF.colors.class[R.myclass]

    return auraBar
end

function UF:UpdatePrep(event)
    if event == "ARENA_OPPONENT_UPDATE" then
        for i=1, 5 do
            if not _G["RayUF_Arena"..i] then return end
            _G["RayUF_Arena"..i].prepFrame:Hide()
        end
    else
        local numOpps = GetNumArenaOpponentSpecs()

        if numOpps > 0 then
            for i=1, 5 do
                if not _G["RayUF_Arena"..i] then return end
                local s = GetArenaOpponentSpec(i)
                local _, spec, class, texture = nil, "UNKNOWN", "UNKNOWN", [[INTERFACE\ICONS\INV_MISC_QUESTIONMARK]]

                if s and s > 0 then
                    _, spec, _, texture, _, _, class = GetSpecializationInfoByID(s)
                end

                if (i <= numOpps) then
                    if class and spec then
                        local color = R.colors.class[class]
                        _G["RayUF_Arena"..i].prepFrame.SpecClass:SetText(spec.." - "..LOCALIZED_CLASS_NAMES_MALE[class])
                        _G["RayUF_Arena"..i].prepFrame.Health:SetStatusBarColor(color.r, color.g, color.b)
                        _G["RayUF_Arena"..i].prepFrame.Icon:SetTexture(texture)
                        _G["RayUF_Arena"..i].prepFrame:Show()
                    end
                else
                    _G["RayUF_Arena"..i].prepFrame:Hide()
                end
            end
        else
            for i=1, 5 do
                if not _G["RayUF_Arena"..i] then return end
                _G["RayUF_Arena"..i].prepFrame:Hide()
            end
        end
    end
end

local attributeBlacklist = {["showplayer"] = true, ["showraid"] = true, ["showparty"] = true, ["showsolo"] = true}
local configEnv
local originalEnvs = {}
local overrideFuncs = {}

local function createConfigEnv()
    if( configEnv ) then return end
    configEnv = setmetatable({
            UnitName = function(unit)
                if unit:find("target") or unit:find("focus") then
                    return UnitName(unit)
                end
                if R.Developer then
                    local max = #R.Developer
                    return R.Developer[math.random(1, max)]
                end
                return "Test Name"
            end,
            UnitClass = function(unit)
                if unit:find("target") or unit:find("focus") then
                    return UnitClass(unit)
                end

                local classToken = CLASS_SORT_ORDER[math.random(1, #(CLASS_SORT_ORDER))]
                return LOCALIZED_CLASS_NAMES_MALE[classToken], classToken
            end,
            }, {
            __index = _G,
            __newindex = function(tbl, key, value) _G[key] = value end,
        })

    overrideFuncs["RayUFRaid:name"] = RayUF.Tags.Methods["RayUFRaid:name"]
end

function UF:ForceShow(frame)
    if InCombatLockdown() then return end
    if not frame.isForced then
        frame.oldUnit = frame.unit
        frame.unit = "player"
        frame.isForced = true
        if frame.Buffs then
            frame.Buffs.forceShow = true
        end
        if frame.Auras then
            frame.Auras.forceShow = true
        end
        if frame.Debuffs then
            frame.Debuffs.forceShow = true
        end
    end
    UnregisterUnitWatch(frame)
    RegisterUnitWatch(frame, true)

    frame:Show()
end

function UF:UnforceShow(frame)
    if InCombatLockdown() then return end
    if not frame.isForced then
        return
    end
    frame.isForced = nil
    if frame.Buffs then
        frame.Buffs.forceShow = nil
    end
    if frame.Auras then
        frame.Auras.forceShow = nil
    end
    if frame.Debuffs then
        frame.Debuffs.forceShow = nil
    end

    UnregisterUnitWatch(frame)
    RegisterUnitWatch(frame)

    frame.unit = frame.oldUnit or frame.unit
end

function UF:ShowChildUnits(header, ...)
    header.isForced = true
    for i=1, select("#", ...) do
        local frame = select(i, ...)
        if frame.RegisterForClicks then
            local rdebuffs = frame.RaidDebuffs
            if rdebuffs then
                rdebuffs.forceShow = true
            end

            frame:RegisterForClicks(nil)
            frame:SetID(i)
            self:ForceShow(frame)
        end
    end
end

function UF:UnshowChildUnits(header, ...)
    header.isForced = nil
    for i=1, select("#", ...) do
        local frame = select(i, ...)
        if frame.RegisterForClicks then
            local rdebuffs = frame.RaidDebuffs
            if rdebuffs then
                rdebuffs.forceShow = nil
            end

            frame:RegisterForClicks("AnyUp")
            self:UnforceShow(frame)
        end
    end
end

local function OnAttributeChanged(self, name)
    if not self.forceShow then return end

    local startingIndex = - 4
    if self:GetAttribute("startingIndex") ~= startingIndex then
        self:SetAttribute("startingIndex", startingIndex)
        UF:ShowChildUnits(self, self:GetChildren())
    end
end

function UF:HeaderConfig(header, configMode)
    if InCombatLockdown() then return end

    createConfigEnv()
    header.forceShow = configMode
    header.forceShowAuras = configMode

    if configMode then
        for _, func in pairs(overrideFuncs) do
            if type(func) == "function" and not originalEnvs[func] then
                originalEnvs[func] = getfenv(func)
                setfenv(func, configEnv)
            end
        end

        for key in pairs(attributeBlacklist) do
            header:SetAttribute(key, nil)
        end

        RegisterStateDriver(header, "visibility", "show")
    else
        for func, env in pairs(originalEnvs) do
            setfenv(func, env)
            originalEnvs[func] = nil
        end

        RegisterStateDriver(header, "visibility", header.visibility)
        if header:GetScript("OnEvent") then
            header:GetScript("OnEvent")(header, "PLAYER_ENTERING_WORLD")
        end
    end

    if header.groups then
        for i=1, #header.groups do
            local group = header.groups[i]

            if group:IsShown() then
                group.forceShow = header.forceShow
                group.forceShowAuras = header.forceShowAuras
                group:HookScript("OnAttributeChanged", OnAttributeChanged)
                if configMode then
                    for key in pairs(attributeBlacklist) do
                        group:SetAttribute(key, nil)
                    end

                    OnAttributeChanged(group)
                else
                    for key in pairs(attributeBlacklist) do
                        group:SetAttribute(key, true)
                    end

                    UF:UnshowChildUnits(group, group:GetChildren())
                    group:SetAttribute("startingIndex", 1)
                end
            end
        end
    else
        local group = header

        if group:IsShown() then
            group.forceShow = header.forceShow
            group.forceShowAuras = header.forceShowAuras
            group:HookScript("OnAttributeChanged", OnAttributeChanged)
            if configMode then
                for key in pairs(attributeBlacklist) do
                    group:SetAttribute(key, nil)
                end

                OnAttributeChanged(group)
            else
                for key in pairs(attributeBlacklist) do
                    group:SetAttribute(key, true)
                end

                UF:UnshowChildUnits(group, group:GetChildren())
                group:SetAttribute("startingIndex", 1)
            end
        end
    end
end

function UF:ToggleUF(msg)
    if msg == "a" or msg == "arena" then
        for i = 1, 5 do
            local frame = _G["RayUF_Arena"..i]
            if frame and not frame.isForced then
                UF:ForceShow(frame)
            elseif frame then
                UF:UnforceShow(frame)
            end
        end
    elseif msg == "boss" or msg == "b" then
        for i = 1, MAX_BOSS_FRAMES do
            local frame = _G["RayUF_Boss"..i]
            if frame and not frame.isForced then
                UF:ForceShow(frame)
            elseif frame then
                UF:UnforceShow(frame)
            end
        end
    elseif msg == "raid25" or msg == "r25" then
        local header = _G["RayUF_Raid"]
        if header then
            UF:HeaderConfig(header, header.forceShow ~= true or nil)
        end
    elseif msg == "raid40" or msg == "r40" then
        local header = _G["RayUF_Raid40"]
        if header then
            UF:HeaderConfig(header, header.forceShow ~= true or nil)
        end
    elseif msg == "maintank" or msg == "mt" then
        local header = _G["RayUF_RaidTank"]
        if header then
            UF:HeaderConfig(header, header.forceShow ~= true or nil)
        end
    elseif msg == "raidpet" or msg == "rp" then
        local header = _G["RayUF_RaidPets"]
        if header then
            UF:HeaderConfig(header, header.forceShow ~= true or nil)
        end
    end
end

SlashCmdList.TestUF = function(...) UF:ToggleUF(...) end
SLASH_TestUF1 = "/testuf"
