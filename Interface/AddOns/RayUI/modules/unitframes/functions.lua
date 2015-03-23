local R, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local RC = LibStub("LibRangeCheck-2.0")
local UF = R:GetModule("UnitFrames")
local oUF = RayUF or oUF

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

function UF:SpawnMenu()
    local unit = self.unit:gsub("(.)", string.upper, 1)
    if self.unit == "targettarget" then return end
    if _G[unit.."FrameDropDown"] then
        ToggleDropDownMenu(1, nil, _G[unit .. "FrameDropDown"], "cursor")
    elseif (self.unit:match("party")) then
        ToggleDropDownMenu(1, nil, _G["PartyMemberFrame" .. self.id .. "DropDown"], "cursor")
    else
        FriendsDropDown.unit = self.unit
        FriendsDropDown.id = self.id
        FriendsDropDown.initialize = RaidFrameDropDown_Initialize
        ToggleDropDownMenu(1, nil, FriendsDropDown, "cursor")
    end
end

function UF:ConstructHealthBar(frame, bg, text)
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
        health.value = frame.textframe:CreateFontString(nil, "OVERLAY")
        health.value:SetFont(R["media"].font, R["media"].fontsize - 1, R["media"].fontflag)
        health.value:SetJustifyH("LEFT")
        health.value:SetParent(frame.textframe)
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

    return health
end

function UF:ConstructPowerBar(frame, bg, text)
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
        local textframe = CreateFrame("Frame", nil, power)
        textframe:SetAllPoints(frame)
        textframe:SetFrameStrata(frame:GetFrameStrata())
        textframe:SetFrameLevel(frame:GetFrameLevel()+5)

        power.value = textframe:CreateFontString(nil, "OVERLAY")
        power.value:SetFont(R["media"].font, R["media"].fontsize - 1, R["media"].fontflag)
        power.value:SetJustifyH("LEFT")
        power.value:SetParent(textframe)
    end

    if self.db.powerColorClass == true then
        power.colorClass = true
        power.colorReaction = true
    else
        power.colorPower = true
    end

    power.colorDisconnected = true
    power.colorTapping = false

    return power
end

function UF:ConstructPortrait(frame)
    local portrait = CreateFrame("PlayerModel", nil, frame)
    portrait:SetFrameStrata("LOW")
    portrait:SetFrameLevel(frame.Health:GetFrameLevel() + 1)
    -- portrait:Point("TOPLEFT", frame.Health, "TOPLEFT", 0, 0)
    -- portrait:Point("BOTTOMRIGHT", frame.Health, "BOTTOMRIGHT", 0, 1)
    portrait:SetInside(frame.Health, 1, 1)
    portrait:SetAlpha(.2)
    portrait.PostUpdate = function(frame)
        if frame:GetModel() and frame:GetModel().find and frame:GetModel():find("worgenmale") then
            frame:SetCamera(1)
        end
        frame:SetCamDistanceScale(1 - 0.01) --Blizzard bug fix
        frame:SetCamDistanceScale(1)
    end
    if frame.unit and frame.unit:find("boss") then
        portrait.PostUpdate = nil
    end

    portrait.overlay = CreateFrame("Frame", nil, frame)
    portrait.overlay:SetFrameLevel(frame:GetFrameLevel() - 5)

    frame.Health.bg:ClearAllPoints()
    frame.Health.bg:Point("BOTTOMLEFT", frame.Health:GetStatusBarTexture(), "BOTTOMRIGHT")
    frame.Health.bg:Point("TOPRIGHT", frame.Health)
    frame.Health.bg:SetParent(portrait.overlay)

    return portrait
end

function UF:ConstructCastBar(frame)
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
    castbar.Icon = castbar:CreateTexture(nil, "OVERLAY")
    castbar.Icon:SetAllPoints(castbar.Iconbg)
    castbar.Icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
    if frame.unit == "player" then
        castbar.SafeZone = castbar:CreateTexture(nil, "OVERLAY")
        castbar.SafeZone:SetDrawLayer("OVERLAY", 5)
        castbar.SafeZone:SetTexture(R["media"].normal)
        castbar.SafeZone:SetVertexColor(1, 0, 0, 0.75)
    end
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
    if numTicks and numTicks <= 0 then return end;
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

        if baseTicks then
            UF:SetCastTicks(self, baseTicks)
        else
            UF:HideTicks(self)
        end
    elseif unit == "player" then
        UF:HideTicks(self)
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
            local color = colors.disconnected
            local power = self.__owner.Power
            if power then
                power:SetValue(0)
                if power.value then
                    power.value:SetText(nil)
                end
            end
            return self.value:SetFormattedText("|cff%02x%02x%02x%s|r", color[1] * 255, color[2] * 255, color[3] * 255, PLAYER_OFFLINE)
        elseif UnitIsDeadOrGhost(unit) then
            local color = colors.disconnected
            local power = self.__owner.Power
            if power then
                power:SetValue(0)
                if power.value then
                    power.value:SetText(nil)
                end
            end
            return self.value:SetFormattedText("|cff%02x%02x%02x%s|r", color[1] * 255, color[2] * 255, color[3] * 255, UnitIsGhost(unit) and GHOST or DEAD)
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
    elseif UnitIsTapped(unit) and not UnitIsTappedByPlayer(unit) then
        color = oUF.colors.tapped
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
            self.value:SetFormattedText("|cff%02x%02x%02x%.1f%%|r", color[1] * 255, color[2] * 255, color[3] * 255,  UnitPower(unit) / UnitPowerMax(unit) * 100)
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

function UF:UpdateThreatStatus(event, unit)
    if self.unit ~= unit and event~="PLAYER_TARGET_CHANGED" then return end
    unit = unit or self.unit
    local s = UnitThreatSituation(unit)
    if s and s > 1 then
        local r, g, b = GetThreatStatusColor(s)
        self.ThreatHlt:Show()
        self.ThreatHlt:SetVertexColor(r, g, b, 0.5)
    else
        self.ThreatHlt:Hide()
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

function UF:ComboDisplay(event, unit)
    if(unit == "pet") then return end

    local cpoints = self.CPoints
    local cp = (UnitHasVehicleUI("player") or UnitHasVehicleUI("vehicle")) and UnitPower("vehicle", 4) or UnitPower("player", 4)

    for i=1, MAX_COMBO_POINTS do
        if(i <= cp) then
            cpoints[i]:SetAlpha(1)
        elseif UF.db.separateEnergy then
            cpoints[i]:SetAlpha(0)
        else
            cpoints[i]:SetAlpha(0.15)
        end
    end

    if cpoints[1]:GetAlpha() == 1 then
        for i=1, MAX_COMBO_POINTS do
            cpoints[i]:Show()
        end

    else
        for i=1, MAX_COMBO_POINTS do
            cpoints[i]:Hide()
        end
    end
end

local  function formatTime(s)
    local day, hour, minute = 86400, 3600, 60
    if s >= day then
        return format("%dd", floor(s/day + 0.5)), s % day
    elseif s >= hour then
        return format("%dh", floor(s/hour + 0.5)), s % hour
    elseif s >= minute then
        return format("%dm", floor(s/minute + 0.5)), s % minute
    elseif s >= minute / 12 then
        return floor(s + 0.5), (s * 100 - floor(s * 100))/100
    end
    -- return format("%.1f", s), (s * 100 - floor(s * 100))/100
    return format("%d", s), (s * 100 - floor(s * 100))/100
end

local function CreateAuraTimer(frame,elapsed)
    frame.elapsed = (frame.elapsed or 0) + elapsed

    if frame.elapsed < .2 then return end
    frame.elapsed = 0

    if frame.expires then
        local timeLeft = frame.expires - GetTime()
        if timeLeft <= 0 then
            return
        else
            frame.remaining:SetText(formatTime(timeLeft))
        end
    end
end

function UF:PostUpdateIcon(unit, icon, index, offset)
    local name, _, _, _, dtype, duration, expirationTime, unitCaster, canStealOrPurge = UnitAura(unit, index, icon.filter)

    local texture = icon.icon
    if icon.isDebuff then
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
    else
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

    if duration and duration > 0 then
        icon.remaining:Show()
    else
        icon.remaining:Hide()
    end

    icon.duration = duration
    icon.expires = expirationTime
    icon:SetScript("OnUpdate", CreateAuraTimer)
end

function UF:PostCreateIcon(button)
    button:SetFrameStrata("BACKGROUND")
    local count = button.count
    count:ClearAllPoints()
    count:Point("CENTER", button, "BOTTOMRIGHT", 0, 5)
    count:SetFontObject(nil)
    count:SetFont(R["media"].font, 13, "THINOUTLINE")
    count:SetTextColor(.8, .8, .8)

    self.disableCooldown = true
    button.icon:SetTexCoord(.1, .9, .1, .9)
    button:CreateShadow()
    button.shadow:SetBackdropColor(0, 0, 0)
    button.overlay:Hide()

    button.remaining = button:CreateFontString(nil, "OVERLAY")
    button.remaining:SetFont(R["media"].font, 13, R["media"].fontflag)
    button.remaining:SetJustifyH("LEFT")
    button.remaining:SetTextColor(0.99, 0.99, 0.99)
    button.remaining:Point("CENTER", 0, 0)

    button:StyleButton(true)
    button:SetPushedTexture(nil)
end

function UF:CustomFilter(unit, icon, name, rank, texture, count, dtype, duration, timeLeft, caster)
    local isPlayer

    if(caster == "player" or caster == "vehicle") then
        isPlayer = true
    end

    if name then
        icon.isPlayer = isPlayer
        icon.owner = caster
    end

    -- if UnitCanAttack(unit, "player") and UnitLevel(unit) == -1 then
    -- if (R.Role == "Melee" and name and UF.PvEMeleeBossDebuffs[name]) or
    -- (R.Role == "Caster" and name and UF.PvECasterBossDebuffs[name]) or
    -- (R.Role == "Tank" and name and UF.PvETankBossDebuffs[name]) or
    -- isPlayer then
    -- return true
    -- else
    -- return false
    -- end
    -- end

    return true
end

function UF:ConstructComboBar(frame)
    -- Combo Bar
    local count = 5
    local bars = CreateFrame("Frame", nil, frame)
    bars:SetSize(200, 5)
    bars:Point("BOTTOM", frame, "TOP", 0, 1)

    bars:SetBackdropBorderColor(0,0,0,0)
    bars:SetBackdropColor(0,0,0,0)

    for i = 1, count do
        bars[i] = CreateFrame("StatusBar", frame:GetName().."_Combo"..i, bars)
        bars[i]:SetHeight(5)
        bars[i]:SetStatusBarTexture(R["media"].normal)
        bars[i]:GetStatusBarTexture():SetHorizTile(false)

        if i == 1 then
            bars[i]:SetPoint("LEFT", bars)
        else
            bars[i]:SetPoint("LEFT", bars[i-1], "RIGHT", 5, 0)
        end
        bars[i]:SetAlpha(0.15)
        bars[i]:SetWidth((200 - (count - 1)*5)/count)
        bars[i].bg = bars[i]:CreateTexture(nil, "BACKGROUND")
        bars[i].bg:SetAllPoints(bars[i])
        bars[i].bg:SetTexture(R["media"].normal)
        bars[i].bg.multiplier = .2

        bars[i]:CreateShadow("Background")
        bars[i].shadow:SetFrameStrata("BACKGROUND")
        bars[i].shadow:SetFrameLevel(0)
    end

    bars[1]:SetStatusBarColor(255/255, 0/255, 0)
    bars[2]:SetStatusBarColor(255/255, 0/255, 0)
    bars[3]:SetStatusBarColor(255/255, 255/255, 0)
    bars[4]:SetStatusBarColor(255/255, 255/255, 0)
    bars[5]:SetStatusBarColor(0, 1, 0)
    bars.Override = self.ComboDisplay

    return bars
end

function UF:ConstructMonkResourceBar(frame)
    local bars = CreateFrame("Frame", nil, frame)
    bars:SetSize(200, 5)
    bars:SetFrameLevel(5)
    bars:Point("BOTTOM", frame, "TOP", 0, 1)
    local count = 6
    bars.number = count

    for i = 1, count do
        bars[i] = CreateFrame("StatusBar", nil, bars)
        bars[i]:SetStatusBarTexture(R["media"].normal)
        bars[i]:SetWidth((200 - (count - 1)*5)/count)
        bars[i]:SetHeight(5)
        bars[i]:GetStatusBarTexture():SetHorizTile(false)

        local color = RayUF.colors.class[R.myclass]
        bars[i]:SetStatusBarColor(unpack(color))

        if i == 1 then
            bars[i]:SetPoint("LEFT", bars, "LEFT", 0, 0)
        else
            bars[i]:SetPoint("LEFT", bars[i-1], "RIGHT", 5, 0)
        end

        bars[i].bg = bars[i]:CreateTexture(nil, "BACKGROUND")
        bars[i].bg:SetAllPoints(bars[i])
        bars[i].bg:SetTexture(R["media"].normal)
        bars[i].bg.multiplier = .2

        bars[i]:CreateShadow("Background")
        bars[i].shadow:SetFrameStrata("BACKGROUND")
        bars[i].shadow:SetFrameLevel(0)
    end

    bars.PostUpdate = UF.UpdateHarmony

    return bars
end

function UF:ConstructDeathKnightResourceBar(frame)
    local bars = CreateFrame("Frame", nil, frame)
    bars:SetSize(200, 5)
    bars:SetFrameLevel(5)
    bars:Point("BOTTOM", frame, "TOP", 0, 1)
    local count = 6

    for i = 1, count do
        bars[i] = CreateFrame("StatusBar", nil, bars)
        bars[i]:SetStatusBarTexture(R["media"].normal)
        bars[i]:SetWidth((200 - (count - 1)*5)/count)
        bars[i]:SetHeight(5)
        bars[i]:GetStatusBarTexture():SetHorizTile(false)

        if i == 1 then
            bars[i]:SetPoint("LEFT", bars, "LEFT", 0, 0)
        else
            bars[i]:SetPoint("LEFT", bars[i-1], "RIGHT", 5, 0)
        end

        bars[i].bg = bars[i]:CreateTexture(nil, "BACKGROUND")
        bars[i].bg:SetAllPoints(bars[i])
        bars[i].bg:SetTexture(R["media"].normal)
        bars[i].bg.multiplier = .2

        bars[i]:CreateShadow("Background")
        bars[i].shadow:SetFrameStrata("BACKGROUND")
        bars[i].shadow:SetFrameLevel(0)
    end

    return bars
end

function UF:ConstructPaladinResourceBar(frame)
    local bars = CreateFrame("Frame", nil, frame)
    bars:SetSize(200, 5)
    bars:SetFrameLevel(5)
    bars:Point("BOTTOM", frame, "TOP", 0, 1)
    local count = 5
    bars.number = count

    for i = 1, count do
        bars[i] = CreateFrame("StatusBar", nil, bars)
        bars[i]:SetStatusBarTexture(R["media"].normal)
        bars[i]:SetWidth((200 - (count - 1)*5)/count)
        bars[i]:SetHeight(5)
        bars[i]:GetStatusBarTexture():SetHorizTile(false)

        local color = RayUF.colors.class[R.myclass]
        bars[i]:SetStatusBarColor(unpack(color))

        if i == 1 then
            bars[i]:SetPoint("LEFT", bars, "LEFT", 0, 0)
        else
            bars[i]:SetPoint("LEFT", bars[i-1], "RIGHT", 5, 0)
        end

        bars[i].bg = bars[i]:CreateTexture(nil, "BACKGROUND")
        bars[i].bg:SetAllPoints(bars[i])
        bars[i].bg:SetTexture(R["media"].normal)
        bars[i].bg.multiplier = .2

        bars[i]:CreateShadow("Background")
        bars[i].shadow:SetFrameStrata("BACKGROUND")
        bars[i].shadow:SetFrameLevel(0)
    end

    bars.PostUpdate = UF.UpdateHolyPower

    return bars
end

function UF:ConstructWarlockResourceBar(frame)
    local bars = CreateFrame("Frame", nil, frame)
    bars:SetSize(200, 5)
    bars:SetFrameLevel(5)
    bars:Point("BOTTOM", frame, "TOP", 0, 1)
    local count = 4

    for i = 1, count do
        bars[i] = CreateFrame("StatusBar", nil, bars)
        bars[i]:SetStatusBarTexture(R["media"].normal)
        bars[i]:SetWidth((200 - (count - 1)*5)/count)
        bars[i]:SetHeight(5)
        bars[i]:GetStatusBarTexture():SetHorizTile(false)

        local color = RayUF.colors.class[R.myclass]
        bars[i]:SetStatusBarColor(unpack(color))

        bars[i].text = bars[i]:CreateFontString(nil, "OVERLAY")
        bars[i].text:SetPoint("CENTER")
        bars[i].text:SetFont(R["media"].font, R["media"].fontsize - 2, R["media"].fontflag)

        if i == 1 then
            bars[i]:SetPoint("LEFT", bars, "LEFT", 0, 0)
        else
            bars[i]:SetPoint("LEFT", bars[i-1], "RIGHT", 5, 0)
        end

        bars[i]:CreateShadow("Background")
        bars[i].shadow:SetFrameStrata("BACKGROUND")
        bars[i].shadow:SetFrameLevel(0)
    end

    bars.PostUpdate = UF.UpdateShardBar

    return bars
end

function UF:ConstructPriestResourceBar(frame)
    local bars = CreateFrame("Frame", nil, frame)
    bars:SetSize(200, 5)
    bars:SetFrameLevel(5)
    bars:Point("BOTTOM", frame, "TOP", 0, 1)
    local count = 5

    for i = 1, count do
        bars[i] = CreateFrame("StatusBar", nil, bars)
        bars[i]:SetStatusBarTexture(R["media"].normal)
        bars[i]:SetWidth((200 - (count - 1)*5)/count)
        bars[i]:SetHeight(5)
        bars[i]:GetStatusBarTexture():SetHorizTile(false)

        local color = RayUF.colors.class[R.myclass]
        bars[i]:SetStatusBarColor(unpack(color))

        if i == 1 then
            bars[i]:SetPoint("LEFT", bars, "LEFT", 0, 0)
        else
            bars[i]:SetPoint("LEFT", bars[i-1], "RIGHT", 5, 0)
        end

        bars[i].bg = bars[i]:CreateTexture(nil, "BACKGROUND")
        bars[i].bg:SetAllPoints(bars[i])
        bars[i].bg:SetTexture(R["media"].normal)
        bars[i].bg.multiplier = .2

        bars[i]:CreateShadow("Background")
        bars[i].shadow:SetFrameStrata("BACKGROUND")
        bars[i].shadow:SetFrameLevel(0)
    end

    bars.PostUpdate = UF.UpdateShadowOrbs

    return bars
end

function UF:ConstructShamanResourceBar(frame)
    local bars = {}
    bars.Destroy = true
    for i = 1, 4 do
        bars[i] = CreateFrame("StatusBar", nil, frame)
        bars[i]:SetStatusBarTexture(R["media"].normal)
        bars[i]:SetWidth(200/4-5)
        bars[i]:SetHeight(5)
        bars[i]:GetStatusBarTexture():SetHorizTile(false)
        bars[i]:SetFrameLevel(5)

        bars[i]:SetBackdrop({bgFile = R["media"].normal})
        bars[i]:SetBackdropColor(0.5, 0.5, 0.5)
        bars[i]:SetMinMaxValues(0, 1)

        bars[i].bg = bars[i]:CreateTexture(nil, "BORDER")
        bars[i].bg:SetAllPoints(bars[i])
        bars[i].bg:SetTexture(R["media"].normal)
        bars[i].bg.multiplier = 0.3

        bars[i]:CreateShadow("Background")
        bars[i].shadow:SetFrameStrata("BACKGROUND")
        bars[i].shadow:SetFrameLevel(0)
    end
    bars[2]:SetPoint("BOTTOM", frame, "TOP", -75,1)
    bars[1]:SetPoint("LEFT", bars[2], "RIGHT", 5, 0)
    bars[3]:SetPoint("LEFT", bars[1], "RIGHT", 5, 0)
    bars[4]:SetPoint("LEFT", bars[3], "RIGHT", 5, 0)

    return bars
end

function UF:ConstructRogueResourceBar(frame)
    local bars = CreateFrame("Frame", nil, frame)
    bars:SetSize(200, 5)
    bars:SetFrameLevel(7)
    bars:Point("BOTTOM", frame, "TOP", 0, -6)
    bars:Hide()
    local count = 5

    for i = 1, count do                  
        bars[i] = CreateFrame("StatusBar", nil, bars)
        bars[i]:SetStatusBarTexture(R["media"].normal)
        bars[i]:SetWidth((200 - (count - 1)*5)/count)
        bars[i]:SetHeight(3)
        bars[i]:GetStatusBarTexture():SetHorizTile(false)
        bars[i]:SetFrameLevel(7)

        if i == 1 then
            bars[i]:SetPoint("LEFT", bars, "LEFT", 0, 0)
        else
            bars[i]:SetPoint("LEFT", bars[i-1], "RIGHT", 5, 0)
        end
        
        bars[i].bg = bars[i]:CreateTexture(nil, "BACKGROUND")
        bars[i].bg:SetAllPoints(bars[i])
        bars[i].bg:SetTexture(R["media"].normal)
        bars[i].bg:SetVertexColor(0, 0, 0)
        bars[i].bg.multiplier = .2

        bars[i]:CreateShadow("Background")
        bars[i].border:SetFrameLevel(7)
        bars[i].shadow:SetFrameStrata("BACKGROUND")
        bars[i].shadow:SetFrameLevel(6)
    end
    bars[1]:SetStatusBarColor(255/255, 0/255, 0)
    bars[2]:SetStatusBarColor(255/255, 0/255, 0)
    bars[3]:SetStatusBarColor(255/255, 255/255, 0)
    bars[4]:SetStatusBarColor(255/255, 255/255, 0)
    bars[5]:SetStatusBarColor(0, 1, 0)
    return bars
end

function UF:ConstructDruidResourceBar(frame)
    local ebar = CreateFrame("Frame", nil, frame)
    ebar:Point("BOTTOM", frame, "TOP", 0, 1)
    ebar:SetSize(200, 5)
    ebar:CreateShadow("Background")
    ebar:SetFrameLevel(5)
    ebar.shadow:SetFrameStrata("BACKGROUND")
    ebar.shadow:SetFrameLevel(0)

    ebar.Spark = ebar:CreateTexture(nil, "OVERLAY")
    ebar.Spark:SetTexture("Interface\\CastingBar\\UI-CastingBar-Spark")
    ebar.Spark:SetBlendMode("ADD")
    ebar.Spark:SetAlpha(0.8)
    ebar.Spark:SetHeight(26)
    ebar.Spark:SetWidth(10)
    ebar.Spark:SetPoint("CENTER", ebar, "CENTER", 0, 0)

    local lbar = CreateFrame("StatusBar", nil, ebar)
    lbar:SetStatusBarTexture(R["media"].normal)
    lbar:SetStatusBarColor(0, .4, 1)
    lbar:SetWidth(0)
    lbar:SetHeight(5)
    lbar:SetFrameLevel(5)
    lbar:GetStatusBarTexture():SetHorizTile(false)
    lbar:SetPoint("RIGHT", ebar, "CENTER", 0, 0)
    ebar.LunarBar = lbar

    local sbar = CreateFrame("StatusBar", nil, ebar)
    sbar:SetStatusBarTexture(R["media"].normal)
    sbar:SetStatusBarColor(1, .6, 0)
    sbar:SetWidth(0)
    sbar:SetHeight(5)
    sbar:SetFrameLevel(5)
    sbar:GetStatusBarTexture():SetHorizTile(false)
    sbar:SetPoint("LEFT", ebar, "CENTER", 0, 0)
    ebar.SolarBar = sbar

    ebar.Text = ebar:CreateFontString(nil, "OVERLAY")
    ebar.Text:SetFont(R["media"].pxfont, R.mult*10, "OUTLINE,MONOCHROME")
    ebar.Text:SetPoint("CENTER", sbar:GetStatusBarTexture(), "LEFT", 0, 1)

    ebar.PostUpdatePower = self.UpdateEclipse
    ebar.PostUnitAura = self.UpdateEclipse

    return ebar
end

function UF:ConstructMageResourceBar(frame)
    local bars = CreateFrame("Frame", nil, frame)
    bars:SetSize(200, 5)
    bars:SetFrameLevel(5)
    bars:Point("BOTTOM", frame, "TOP", 0, 1)
    local count = 2
    bars.number = count

    for i = 1, count do
        bars[i] = CreateFrame("StatusBar", nil, bars)
        bars[i]:SetStatusBarTexture(R["media"].normal)
        bars[i]:SetWidth((200 - (count - 1)*5)/count)
        bars[i]:SetHeight(5)
        bars[i]:GetStatusBarTexture():SetHorizTile(false)

        local color = RayUF.colors.class[R.myclass]
        bars[i]:SetStatusBarColor(unpack(color))

        if i == 1 then
            bars[i]:SetPoint("LEFT", bars, "LEFT", 0, 0)
        else
            bars[i]:SetPoint("LEFT", bars[i-1], "RIGHT", 5, 0)
        end

        bars[i].bg = bars[i]:CreateTexture(nil, "BACKGROUND")
        bars[i].bg:SetAllPoints(bars[i])
        bars[i].bg:SetTexture(R["media"].normal)
        bars[i].bg.multiplier = .2

        bars[i]:CreateShadow("Background")
        bars[i].shadow:SetFrameStrata("BACKGROUND")
        bars[i].shadow:SetFrameLevel(0)
        bars[i].__parent = bars
    end

    bars.Colors = RayUF.colors.class["MAGE"]
    bars.ExpColors = { 1, 0, 0 }
    bars.BgColors = { 0, 0, 0 }

    return bars
end

function UF:EnableHealPredictionAndAbsorb(frame)
	local mhpb = frame:CreateTexture(nil, "BORDER", 5)
	mhpb:SetWidth(1)
	mhpb:SetTexture(R["media"].normal)
	mhpb:SetVertexColor(0, 1, 0.5, 0.25)

	local ohpb = frame:CreateTexture(nil, "BORDER", 5)
	ohpb:SetWidth(1)
	ohpb:SetTexture(R["media"].normal)
	ohpb:SetVertexColor(0, 1, 0, 0.25)

	local abb = frame:CreateTexture(nil, "BORDER", 5)
	abb:SetWidth(1)
	abb:SetTexture(R["media"].normal)
	abb:SetVertexColor(.66, 1, 1, .7)

	local abbo = frame:CreateTexture(nil, "ARTWORK", 1)
	abbo:SetAllPoints(abb)
	abbo:SetTexture("Interface\\RaidFrame\\Shield-Overlay", true, true)
	abbo.tileSize = 32

	local oag = frame:CreateTexture(nil, "ARTWORK", 1)
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

function UF:UpdateEclipse(unit)
    local direction = GetEclipseDirection()
    local power = UnitPower("player", SPELL_POWER_ECLIPSE)
    local maxPower = UnitPowerMax("player", SPELL_POWER_ECLIPSE)
    local absolutePower = math.abs(power/maxPower)*100

    self.Text:ClearAllPoints()
    if power < 0 then
        self.Text:SetTextColor(0, .4, 1)
        self.Text:SetPoint("CENTER", self.LunarBar, "LEFT")
        self.LunarBar:SetPoint("LEFT", self, "CENTER", -absolutePower, 0)
    else
        self.Text:SetTextColor(1, .6, 0)
        self.Text:SetPoint("CENTER", self.SolarBar, "RIGHT")
        self.SolarBar:SetPoint("RIGHT", self, "CENTER", absolutePower, 0)
    end

    if direction == "sun" then
        self.Text:SetText(absolutePower.. ">")
    elseif direction == "moon" then
        self.Text:SetText("<".. absolutePower)
    else
        self.Text:SetText("")
    end

    if self.hasSolarEclipse then
        self.border:SetBackdropBorderColor(1, .6, 0)
        self.shadow:SetBackdropBorderColor(1, .6, 0)
    elseif self.hasLunarEclipse then
        self.border:SetBackdropBorderColor(0, .4, 1)
        self.shadow:SetBackdropBorderColor(0, .4, 1)
    else
        self.border:SetBackdropBorderColor(0, 0, 0)
        self.shadow:SetBackdropBorderColor(0, 0, 0)
    end
end

function UF:UpdateHolyPower()
    local maxHolyPower = UnitPowerMax("player", SPELL_POWER_HOLY_POWER)
    if maxHolyPower < self.number then
        for i = 1, 3 do
            self[i]:SetWidth(185/3)
        end
        self[4]:Hide()
        self[5]:Hide()
        self.number = maxHolyPower
    elseif maxHolyPower > self.number then
        for i = 1, 3 do
            self[i]:SetWidth(180/5)
        end
        self[4]:Show()
        self[5]:Show()
        self.number = maxHolyPower
    end
end

function UF:UpdateHarmony()
    local maxChi = UnitPowerMax("player", SPELL_POWER_CHI)

    for i = 1, 6 do
        if i > maxChi then
            self[i]:Hide()
        else
            self[i]:SetWidth((200 - (maxChi - 1)*5)/maxChi)
        end
    end
end

function UF:UpdateShardBar(spec)
    local maxBars = self.number
    local frame = self:GetParent()
    local spec = GetSpecialization()
    local power = UnitPower("player", SPELL_POWER_DEMONIC_FURY)

    for i = 1, 4 do
        if i > maxBars then
            self[i]:Hide()
        else
            self[i]:SetWidth((200 - (maxBars - 1)*5)/maxBars)
                if spec == SPEC_WARLOCK_DEMONOLOGY then
                    self[i].text:SetText(power)
                else
                    self[i].text:SetText()
                end
        end
    end
end

function UF:UpdateShadowOrbs()
	local totalOrbs = IsSpellKnown(SHADOW_ORB_MINOR_TALENT_ID) and 5 or 3
	for i = 1,totalOrbs do
		self[i]:SetWidth((200 - (totalOrbs - 1)*5)/totalOrbs)
    end
end

function UF:AuraBarFilter(unit, name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, shouldConsolidate, spellID)
    if R.global.UnitFrames.InvalidSpells[spellID] then
        return false
    end
    local returnValue = true
    local returnValueChanged = false
    local isPlayer, isFriend
    local auraType

    if unitCaster == "player" or unitCaster == "vehicle" then isPlayer = true end
    if UnitIsFriend("player", unit) then isFriend = true end
    if isFriend then
        auraType = "HELPFUL"
    else
        auraType = "HARMFUL"
    end

    if isPlayer then
        returnValue = true
    else
        returnValue = false
    end

    if shouldConsolidate == 1 then
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
	local text = frame.textframe:CreateFontString(nil, "OVERLAY")
	text:SetFont(R["media"].pxfont, R.mult*10, "OUTLINE,MONOCHROME")
	-- text:SetFont(R["media"].font, R["media"].fontsize - 2, R["media"].fontflag)
	text:SetJustifyH("RIGHT")
	text:SetParent(frame.textframe)
	text:Point("TOPRIGHT", frame.textframe, "TOPLEFT", -2, 3)
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

    bar:Height(5)
    bar:ClearAllPoints()
    bar:SetPoint("BOTTOMLEFT")
    bar:SetPoint("BOTTOMRIGHT")
    bar:CreateShadow("Background")

    bar:SetStatusBarColor(unpack(RayUF.colors.class[R.myclass]))

    bar.spelltime:FontTemplate(R["media"].font, R["media"].fontsize, "OUTLINE")
    bar.spellname:FontTemplate(R["media"].font, R["media"].fontsize, "OUTLINE")

    bar.spellname:ClearAllPoints()
    bar.spellname:SetPoint("BOTTOMLEFT", bar, "TOPLEFT", 2, 2)
    bar.spellname:SetPoint("BOTTOMRIGHT", bar, "TOPRIGHT", -20, 2)

    bar.spelltime:ClearAllPoints()
    bar.spelltime:SetPoint("BOTTOMRIGHT", bar, "TOPRIGHT", 0, 2)

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
            if not _G["RayUFArena"..i] then return end
            _G["RayUFArena"..i].prepFrame:Hide()
        end
    else
        local numOpps = GetNumArenaOpponentSpecs()

        if numOpps > 0 then
            for i=1, 5 do
                if not _G["RayUFArena"..i] then return end
                local s = GetArenaOpponentSpec(i)
                local _, spec, class, texture = nil, "UNKNOWN", "UNKNOWN", [[INTERFACE\ICONS\INV_MISC_QUESTIONMARK]]

                if s and s > 0 then
                    _, spec, _, texture, _, _, class = GetSpecializationInfoByID(s)
                end

                if (i <= numOpps) then
                    if class and spec then
                        local color = R.colors.class[class]
                        _G["RayUFArena"..i].prepFrame.SpecClass:SetText(spec.."  -  "..LOCALIZED_CLASS_NAMES_MALE[class])
                        _G["RayUFArena"..i].prepFrame.Health:SetStatusBarColor(color.r, color.g, color.b)
                        _G["RayUFArena"..i].prepFrame.Icon:SetTexture(texture)
                        _G["RayUFArena"..i].prepFrame:Show()
                    end
                else
                    _G["RayUFArena"..i].prepFrame:Hide()
                end
            end
        else
            for i=1, 5 do
                if not _G["RayUFArena"..i] then return end
                _G["RayUFArena"..i].prepFrame:Hide()
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
        frame:RegisterForClicks(nil)
        frame:SetID(i)
        frame.TargetBorder:SetAlpha(0)
        frame.FocusHighlight:SetAlpha(0)
        self:ForceShow(frame)
    end
end

function UF:UnshowChildUnits(header, ...)
    header.isForced = nil
    for i=1, select("#", ...) do
        local frame = select(i, ...)
        frame:RegisterForClicks("AnyUp")
        frame.TargetBorder:SetAlpha(1)
        frame.FocusHighlight:SetAlpha(1)
        self:UnforceShow(frame)
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
    header:HookScript("OnAttributeChanged", OnAttributeChanged)
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

        RegisterAttributeDriver(header, "state-visibility", "show")
        OnAttributeChanged(header)

        UF:ShowChildUnits(header, header:GetChildren())
    else
        for func, env in pairs(originalEnvs) do
            setfenv(func, env)
            originalEnvs[func] = nil
        end

        UF:UnshowChildUnits(header, header:GetChildren())
        header:SetAttribute("startingIndex", 1)

        local RA = R:GetModule("Raid")
        if header:GetName():find("RayUFRaid15") then
            RA.Raid15SmartVisibility(header)
        end
        if header:GetName():find("RayUFRaid25") then
            RA.Raid25SmartVisibility(header)
        end
        if header:GetName():find("RayUFRaid40") then
            RA.Raid40SmartVisibility(header)
        end
    end
end

local testuf = TestUF or function() end
local function TestUF(msg)
    if msg == "a" or msg == "arena" then
        for i = 1, 5 do
            local frame = _G["RayUFArena"..i]
            if frame and not frame.isForced then
                UF:ForceShow(frame)
            elseif frame then
                UF:UnforceShow(frame)
            end
        end
    elseif msg == "boss" or msg == "b" then
        for i = 1, MAX_BOSS_FRAMES do
            local frame = _G["RayUFBoss"..i]
            if frame and not frame.isForced then
                UF:ForceShow(frame)
            elseif frame then
                UF:UnforceShow(frame)
            end
        end
    elseif msg == "raid15" or msg == "r15" then
        for i = 1, 30 do
            local header = _G["RayUFRaid15_"..i]
            if header then
                UF:HeaderConfig(header, header.forceShow ~= true or nil)
            end
        end
    elseif msg == "raid25" or msg == "r25" then
        for i = 1, 5 do
            local header = _G["RayUFRaid25_"..i]
            if header then
                UF:HeaderConfig(header, header.forceShow ~= true or nil)
            end
        end
    elseif msg == "raid40" or msg == "r40" then
        local forceShow = RayUFRaid40_6.forceShow
        for i = 6, 8 do
            local header = _G["RayUFRaid40_"..i]
            if header then
                UF:HeaderConfig(header, forceShow ~= true or nil)
            end
        end
        for i = 1, 5 do
            local header = _G["RayUFRaid25_"..i]
            if header then
                UF:HeaderConfig(header, forceShow ~= true or nil)
            end
        end
    end
end

SlashCmdList.TestUF = TestUF
SLASH_TestUF1 = "/testuf"
