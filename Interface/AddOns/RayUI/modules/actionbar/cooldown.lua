----------------------------------------------------------
-- Load RayUI Environment
----------------------------------------------------------
RayUI:LoadEnv("ActionBar")

local AB = _ActionBar

local DAY, HOUR, MINUTE = 86400, 3600, 60 --used for formatting text
local DAYISH, HOURISH, MINUTEISH, SOONISH = 3600 * 23.5, 60 * 59.5, 59.5, 5.5 --used for formatting text at transition points
local HALFDAYISH, HALFHOURISH, HALFMINUTEISH = DAY/2 + 0.5, HOUR/2 + 0.5, MINUTE/2 + 0.5 --used for calculating next update times
local FONT_SIZE = 20 --the base font size to use at a scale of 1
local MIN_SCALE = 0.5 --the minimum scale we want to show cooldown counts at, anything below this will be hidden
local MIN_DURATION = 2.5 --the minimum duration to show cooldown text for
local EXPIRING_DURATION = 3.5 --the minimum number of seconds a cooldown must be to use to display in the expiring format
local EXPIRING_FORMAT = R:RGBToHex(1,0,0)..'%.1f|r' --format for timers that are soon to expire
local SECONDS_FORMAT = R:RGBToHex(1,1,0)..'%d|r' --format for timers that have seconds remaining
local MINUTES_FORMAT = R:RGBToHex(1,1,1)..'%dm|r' --format for timers that have minutes remaining
local HOURS_FORMAT = R:RGBToHex(0.4,1,1)..'%dh|r' --format for timers that have hours remaining
local DAYS_FORMAT = R:RGBToHex(0.4,0.4,1)..'%dd|r' --format for timers that have days remaining
local styles = {
    controlled = { scale = 1 },
    charging = { scale = 0.75 },
    soon = { scale = 1.2 },
    seconds = { scale = 1 },
    minutes = { scale = 1 },
    hours = { scale = 0.75 },
}

local Timer = CreateFrame("Frame")
local ScriptUpdater = CreateFrame("Frame")
local Anim = CreateFrame("Frame")
ScriptUpdater.updaters = {}
Anim.instances = {}
Anim.texture = [[Interface\Cooldown\star4]]
Anim.duration = .75
Anim.scale = 5

function AB:GetTimeText(s)
    --format text as seconds when below a minute
    if s < MINUTEISH then
        local seconds = tonumber(R:Round(s))
        if seconds > EXPIRING_DURATION then
            return SECONDS_FORMAT, seconds, s - (seconds - 0.51)
        else
            return EXPIRING_FORMAT, s, 0.051
        end
        --format text as minutes when below an hour
    elseif s < HOURISH then
        local minutes = tonumber(R:Round(s/MINUTE))
        return MINUTES_FORMAT, minutes, minutes > 1 and (s - (minutes*MINUTE - HALFMINUTEISH)) or (s - MINUTEISH)
        --format text as hours when below a day
    elseif s < DAYISH then
        local hours = tonumber(R:Round(s/HOUR))
        return HOURS_FORMAT, hours, hours > 1 and (s - (hours*HOUR - HALFHOURISH)) or (s - HOURISH)
        --format text as days
    else
        local days = tonumber(R:Round(s/DAY))
        return DAYS_FORMAT, days, days > 1 and (s - (days*DAY - HALFDAYISH)) or (s - DAYISH)
    end
end

function ScriptUpdater:Get(frame)
    return self:GetActive(frame) or self:New(frame)
end

function ScriptUpdater:GetActive(frame)
    return self.updaters[frame]
end

function ScriptUpdater:New(frame)
    local updater = setmetatable(CreateFrame("Frame", nil), {__index = ScriptUpdater})
    updater:Hide()
    updater:SetScript("OnUpdate", updater.OnUpdate)
    updater.frame = frame

    self.updaters[frame] = updater
    return updater
end

function ScriptUpdater:OnUpdate(elapsed)
    local delay = self.delay and (self.delay - elapsed) or 0
    if delay > 0 then
        self.delay = delay
    else
        self:OnFinished()
    end
end

function ScriptUpdater:OnFinished()
    self:Cleanup()
    self.frame:UpdateText()
end

function ScriptUpdater:ScheduleUpdate(delay)
    if delay > 0 then
        self.delay = delay
        self:Show()
    else
        self:OnFinished()
    end
end

function ScriptUpdater:CancelUpdate()
    self:Cleanup()
end

function ScriptUpdater:Cleanup()
    self:Hide()
    self.delay = nil
end

function Timer:Start(start, duration, modRate, charges)
    self.start, self.duration = start, duration
    self.controlled = self.cooldown.currentCooldownType == COOLDOWN_TYPE_LOSS_OF_CONTROL
    self.visible = self.cooldown:IsVisible()
    self.finish = start + duration
    self.textStyle = nil
    self.enabled = true

    local parent = self.cooldown:GetParent()
    if parent and parent.GetCharges then charges, maxCharges = parent:GetCharges() end
    charges = charges or 0
    self.charging = charges > 0

    -- hotfix for ChargeCooldowns
    local charge = parent and parent.chargeCooldown
    local chargeTimer = charge and charge.timer
    if chargeTimer and chargeTimer ~= self then
        chargeTimer:Stop()
    end

    self:UpdateShown()
end

function Timer:Stop()
    self.start, self.duration, self.enabled, self.visible, self.textStyle = nil
    self:CancelUpdate()
    self:Hide()
end

function Timer:ScheduleUpdate(delay)
    local updater = ScriptUpdater:Get(self)

    updater:ScheduleUpdate(delay)
end

function Timer:CancelUpdate()
    local updater = ScriptUpdater:GetActive(self)

    if updater then
        updater:CancelUpdate()
    end
end

function Timer:UpdateFontSize(width, height)
    self.abRatio = R:Round(height) / 36

    self:SetSize(width, height)
    self.text:ClearAllPoints()
    self.text:SetPoint("CENTER")

    if self.enabled and self.visible then
        self:UpdateText(true)
    end
end

function Timer:UpdateText(forceStyleUpdate)
    if self.start and self.start > (GetTime() or 0) then
        return self:ScheduleUpdate(self.start - (GetTime() or 0))
    end

    local remain = self:GetRemain()
    if remain > 0 then
        local overallScale = self.abRatio * (self:GetEffectiveScale()/UIParent:GetScale())

        if overallScale < MIN_SCALE then
            self.text:Hide()
            self:ScheduleUpdate(1)
        else
            local style = self:GetTextStyle(remain)
            if (style ~= self.textStyle) or forceStyleUpdate then
                self.textStyle = style
                self:UpdateTextStyle()
            end

            if self.text:GetFont() then
                self.text:SetFormattedText(AB:GetTimeText(remain))
                self.text:Show()
            end

            self:ScheduleUpdate(self:GetNextUpdate(remain))
        end
    else
        if self.duration and self.duration >= MIN_DURATION then
            Anim:Run(self.cooldown)
        end

        self:Stop()
    end
end

function Timer:UpdateTextStyle()
    local style = styles[self.textStyle]
    local font, size, outline = R["media"].cdfont, FONT_SIZE * style.scale * (self.abRatio or 1), "OUTLINE"

    if size > 0 then
        if not self.text:SetFont(font, size, outline) then
            self.text:SetFont(STANDARD_TEXT_FONT, size, outline)
        end
    end

    self.text:SetTextColor(style.r, style.g, style.b, style.a)
end

function Timer:UpdateShown()
    if self:ShouldShow() then
        self:Show()
        self:UpdateText()
    else
        self:Hide()
    end
end

function Timer:GetRemain()
    return self.finish - (GetTime() or 0)
end

function Timer:GetTextStyle(remain)
    if self.controlled then
        return "controlled"
    elseif self.charging then
        return "charging"
    elseif remain < SOONISH then
        return "soon"
    elseif remain < MINUTEISH then
        return "seconds"
    elseif remain < HOURISH then
        return "minutes"
    else
        return "hours"
    end
end

function Timer:GetNextUpdate(remain)
    if remain < EXPIRING_DURATION then
        return 0.051

    elseif remain < MINUTEISH then
        return remain - R:Round(remain) + 0.51

    elseif remain < HOURISH then
        local minutes = R:Round(remain/MINUTE)
        if minutes > 1 then
            return remain - (minutes*MINUTE - HALFMINUTEISH)
        end
        return remain - MINUTEISH + 0.01

    elseif remain < DAYISH then
        local hours = R:Round(remain/HOUR)
        if hours > 1 then
            return remain - (hours*HOUR - HALFHOURISH)
        end
        return remain - HOURISH + 0.01

    else
        local days = R:Round(remain/DAY)
        if days > 1 then
            return remain - (days*DAY - HALFDAYISH)
        end
        return remain - DAYISH + 0.01
    end
end

function Timer:ShouldShow()
    if not (self.enabled and self.visible) or self.cooldown.noOCC then
        return false
    end

    if self.duration < MIN_DURATION then
        return false
    end

    return true
end

function Timer:New(cooldown)
    cooldown:SetHideCountdownNumbers(true)

    local timer = setmetatable(CreateFrame("Frame", nil, cooldown:GetParent()), {__index = Timer})
    timer:SetFrameLevel(cooldown:GetFrameLevel() + 5)
    timer:Hide()

    timer.text = timer:CreateFontString(nil, "OVERLAY")
    timer.cooldown = cooldown

    timer:SetPoint("CENTER", cooldown)
    timer:UpdateFontSize(cooldown:GetSize())
    return timer
end

function AB:Cooldown_OnSizeChanged(width, ...)
    if self.occWidth ~= width then
        self.occWidth = width

        local timer = self.timer
        if timer then
            timer:UpdateFontSize(width, ...)
        end
    end
end

function AB:Cooldown_OnShow()
    local timer = self.timer
    if timer and timer.enabled then
        if timer:GetRemain() > 0 then
            timer.visible = true
            timer:UpdateShown()
        else
            timer:Stop()
        end
    end
end

function AB:Cooldown_OnHide()
    local timer = self.timer
    if timer and timer.enabled then
        timer.visible = nil
        timer:Hide()
    end
end

function AB:Cooldown_Stop(cooldown)
    local timer = cooldown.timer
    if timer and timer.enabled then
        timer:Stop()
    end
end

function AB:Cooldown_CanShow(cooldown, start, duration)
    if not cooldown.noOCC and duration and start and start > 0 then
        if duration >= MIN_DURATION then
            local globalstart, globalduration = GetSpellCooldown(61304)
            return start ~= globalstart or duration ~= globalduration
        end
    end
end

function AB:OnSetCooldown(cooldown, ...)
    cooldown:SetHideCountdownNumbers(true)

    if self:Cooldown_CanShow(cooldown, ...) then
        self:Cooldown_Setup(cooldown)
        cooldown.timer:Start(...)
    else
        self:Cooldown_Stop(cooldown)
    end
end

function AB:Cooldown_Setup(cooldown)
    if not cooldown.timer then
        cooldown:HookScript("OnShow", self.Cooldown_OnShow)
        cooldown:HookScript("OnHide", self.Cooldown_OnHide)
        cooldown:HookScript("OnSizeChanged", self.Cooldown_OnSizeChanged)
        cooldown.timer = Timer:New(cooldown)
    end

    local parent = cooldown:GetParent()
    if parent and (parent.action or parent.slotID) then Anim:Setup(cooldown) end
end

function Anim:Run(cooldown)
    local parent = cooldown:GetParent()
    local charge = parent and parent.chargeCooldown
    local chargeTimer = charge and charge.timer
    if chargeTimer and chargeTimer ~= self then cooldown = parent.cooldown end
    local shine = self.instances[cooldown]
    if shine then
        shine:Start()
    end
end

function Anim:Start()
    if self.animation:IsPlaying() then
        self.animation:Finish()
    end

    self:Show()
    self.animation:Play()
end

function Anim:OnAnimationFinished()
    local parent = self:GetParent()
    if parent:IsShown() then
        parent:Hide()
    end
end

function Anim:OnHide()
    if self.animation:IsPlaying() then
        self.animation:Finish()
    end

    self:Hide()
end

function Anim:Setup(cooldown)
    if self.instances[cooldown] then
        return
    end

    local parent = cooldown:GetParent()
    if parent then
        local shine = setmetatable(CreateFrame("Frame", nil, parent), {__index = Anim})
        shine:Hide()
        shine:SetScript("OnHide", shine.OnHide)
        shine:SetAllPoints(parent)
        shine:SetToplevel(true)
        shine.animation = shine:CreateShineAnimation()

        local icon = shine:CreateTexture(nil, "OVERLAY")
        icon:SetPoint("CENTER")
        icon:SetBlendMode("ADD")
        icon:SetAllPoints(shine)
        icon:SetTexture(self.texture)

        self.instances[cooldown] = shine
        return shine
    end
end

function Anim:CreateShineAnimation()
    local group = self:CreateAnimationGroup()
    group:SetScript("OnFinished", self.OnAnimationFinished)
    group:SetLooping("NONE")

    local initiate = group:CreateAnimation("Alpha")
    initiate:SetFromAlpha(1)
    initiate:SetDuration(0)
    initiate:SetToAlpha(0)
    initiate:SetOrder(0)

    local grow = group:CreateAnimation("Scale")
    grow:SetOrigin("CENTER", 0, 0)
    grow:SetScale(self.scale, self.scale)
    grow:SetDuration(self.duration / 2)
    grow:SetOrder(1)

    local brighten = group:CreateAnimation("Alpha")
    brighten:SetDuration(self.duration / 2)
    brighten:SetFromAlpha(0)
    brighten:SetToAlpha(1)
    brighten:SetOrder(1)

    local shrink = group:CreateAnimation("Scale")
    shrink:SetOrigin("CENTER", 0, 0)
    shrink:SetScale(-self.scale, -self.scale)
    shrink:SetDuration(self.duration / 2)
    shrink:SetOrder(2)

    local fade = group:CreateAnimation("Alpha")
    fade:SetDuration(self.duration / 2)
    fade:SetFromAlpha(1)
    fade:SetToAlpha(0)
    fade:SetOrder(2)

    return group
end

local visible, hooked = {}, {}
function AB:RegisterCooldown(button, action, cooldown)
    cooldown.occAction = action

    if not hooked[cooldown] then
        cooldown:HookScript("OnShow", function(self) visible[self] = true end)
        cooldown:HookScript("OnHide", function(self) visible[self] = nil end)

        self:Cooldown_Setup(cooldown)
        hooked[cooldown] = true
    end
end

function AB:ACTIONBAR_UPDATE_COOLDOWN()
    for cooldown in pairs(visible) do
        local start, duration = GetActionCooldown(cooldown.occAction)
        local charges = GetActionCharges(cooldown.occAction)

        self:OnSetCooldown(cooldown, start, duration, nil, charges)
    end
end

function AB:CreateCooldown()
    R:LockCVar("countdownForCooldowns", 0)

    self:RegisterEvent("ACTIONBAR_UPDATE_COOLDOWN")
    self:SecureHook("SetActionUIButton", "RegisterCooldown")

    if ActionBarButtonEventsFrame.frames then
        for _, button in pairs(ActionBarButtonEventsFrame.frames) do
            self:RegisterCooldown(button, button.action, button.cooldown)
        end
    end

    local _meta = getmetatable(ActionButton1Cooldown).__index
    if not self.hooks[_meta] then
        self:SecureHook(_meta, "SetCooldown", "OnSetCooldown")
    end
end
