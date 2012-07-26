local R, L, P = unpack(select(2, ...)) --Inport: Engine, Locales, ProfileDB
local AB = R:GetModule("ActionBar")

local DAY, HOUR, MINUTE = 86400, 3600, 60 --used for formatting text
local DAYISH, HOURISH, MINUTEISH = 3600 * 23.5, 60 * 59.5, 59.5 --used for formatting text at transition points
local HALFDAYISH, HALFHOURISH, HALFMINUTEISH = DAY/2 + 0.5, HOUR/2 + 0.5, MINUTE/2 + 0.5 --used for calculating next update times
local FONT_SIZE = 20 --the base font size to use at a scale of 1
local MIN_SCALE = 0.5 --the minimum scale we want to show cooldown counts at, anything below this will be hidden
local MIN_DURATION = 2.5 --the minimum duration to show cooldown text for
local EXPIRING_DURATION = 3 --the minimum number of seconds a cooldown must be to use to display in the expiring format
local EXPIRING_FORMAT = R:RGBToHex(1,0,0)..'%.1f|r' --format for timers that are soon to expire
local SECONDS_FORMAT = R:RGBToHex(1,1,0)..'%d|r' --format for timers that have seconds remaining
local MINUTES_FORMAT = R:RGBToHex(1,1,1)..'%dm|r' --format for timers that have minutes remaining
local HOURS_FORMAT = R:RGBToHex(0.4,1,1)..'%dh|r' --format for timers that have hours remaining
local DAYS_FORMAT = R:RGBToHex(0.4,0.4,1)..'%dh|r' --format for timers that have days remaining

local floor = math.floor
local min = math.min
local GetTime = GetTime

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
		return DAYS_FORMAT, days,  days > 1 and (s - (days*DAY - HALFDAYISH)) or (s - DAYISH)
	end
end

function AB:Cooldown_StopTimer(cd)
	cd.enabled = nil
	cd:Hide()
end

function AB:Timer_ForceUpdate(cd)
	cd.nextUpdate = 0
	cd:Show()
end

function AB:Cooldown_OnSizeChanged(cd, width, height)
	local fontScale = R:Round(width) / 36
	if fontScale == cd.fontScale then
		return
	end

	cd.fontScale = fontScale
	if fontScale < MIN_SCALE then
		cd:Hide()
	else
		cd.text:SetFont(R["media"].cdfont, fontScale * FONT_SIZE, 'OUTLINE')
		cd.text:SetShadowColor(0, 0, 0, 0.5)
		cd.text:SetShadowOffset(2, -2)
		if cd.enabled then
			self:Timer_ForceUpdate(cd)
		end
	end
end

local function Cooldown_OnUpdate(self, elapsed)
	if self.nextUpdate > 0 then
		self.nextUpdate = self.nextUpdate - elapsed
	else
		local remain = self.duration - (GetTime() - self.start)
		if remain > 0.01 then
			if (self.fontScale * self:GetEffectiveScale() / UIParent:GetScale()) < MIN_SCALE then
				self.text:SetText('')
				self.nextUpdate  = 1
			else
				local formatStr, time, nextUpdate = AB:GetTimeText(remain)
				self.text:SetFormattedText(formatStr, time)
				self.nextUpdate = nextUpdate
			end
		else
			AB:Cooldown_StopTimer(self)
		end
	end
end

function AB:CreateCooldownTimer(cd)
	local scaler = CreateFrame("Frame", nil, cd)
	scaler:SetAllPoints(cd)

	local timer = CreateFrame("Frame", nil, scaler); timer:Hide()
	timer:SetAllPoints(scaler)
	timer:SetScript("OnUpdate", Cooldown_OnUpdate)

	local text = timer:CreateFontString(nil, "OVERLAY")
	text:SetPoint("CENTER", 1, 1)
	text:SetJustifyH("CENTER")
	timer.text = text

	self:Cooldown_OnSizeChanged(timer, scaler:GetSize())
	scaler:SetScript("OnSizeChanged", function(cd, ...) AB:Cooldown_OnSizeChanged(timer, ...) end)

	cd.timer = timer
	return timer
end

function AB:OnSetCooldown(cd, start, duration)
	if cd.noOCC then return end
	--start timer
	if start > 0 and duration > MIN_DURATION then
		local timer = cd.timer or self:CreateCooldownTimer(cd)
		timer.start = start
		timer.duration = duration
		timer.enabled = true
		timer.nextUpdate = 0
		if timer.fontScale >= MIN_SCALE then timer:Show() end
	--stop timer
	else
		local timer = cd.timer
		if timer then
			self:Cooldown_StopTimer(timer)
		end
	end
end

local actions, hooked = {}, {}
function AB:RegisterCooldown(button, action, cooldown)
	if not hooked[cooldown] then
		cooldown:HookScript("OnShow", function(self) actions[self] = true end)
		cooldown:HookScript("OnHide", function(self) actions[self] = nil end)
	end
	hooked[cooldown] = action
end

function AB:ACTIONBAR_UPDATE_COOLDOWN()
	for cooldown in pairs(actions) do
        local start, duration = GetActionCooldown(hooked[cooldown])
        self:OnSetCooldown(cooldown, start, duration)
		if AB.db.cooldownalpha then
			self:UpdateCDAlpha(cooldown:GetParent())
		end
    end
end

local function CDStop(frame)
	frame:SetScript("OnUpdate", nil)
	frame:SetAlpha(AB.db.readyalpha)
	local index = frame:GetName():match("MultiCastActionButton(%d)")
	if index then
		_G["MultiCastSlotButton"..index]:SetAlpha(AB.db.readyalpha)
	end
end

local function CDUpdate(frame)
	if frame.StopTime < GetTime() then
		CDStop(frame)
	else
		frame:SetAlpha(AB.db.cdalpha)
		local index = frame:GetName():match("MultiCastActionButton(%d)")
		if index then
			_G["MultiCastSlotButton"..index]:SetAlpha(AB.db.cdalpha)
		end
	end
end

function AB:UpdateCDAlpha(self)
	if not AB.db.stancealpha and self:GetName():find("MultiCast") then return end
	local start, duration, enable = GetActionCooldown(self.action)
	if start>0 and duration > 1.5 then
		self.StopTime = start + duration
		self:SetScript("OnUpdate", CDUpdate)
	else
		CDStop(self)
	end
end

function AB:UpdateShapeshiftCDAlpha()
	for i=1, NUM_SHAPESHIFT_SLOTS do
		button = _G["ShapeshiftButton"..i]
		local start, duration, enable = GetShapeshiftFormCooldown(i)
		if start>0 and duration > 1.5 then
			button.StopTime = start + duration
			button:SetScript("OnUpdate", CDUpdate)
		else
			CDStop(button)
		end
	end
end

function AB:CreateCooldown(event, addon)
	self:RegisterEvent("ACTIONBAR_UPDATE_COOLDOWN")
	self:SecureHook("SetActionUIButton", "RegisterCooldown")
	for i, button in pairs(ActionBarButtonEventsFrame.frames) do
		self:RegisterCooldown(button, button.action, button.cooldown)
	end
	if not self.hooks[cooldown] then
		self:SecureHook(getmetatable(ActionButton1Cooldown).__index, "SetCooldown", "OnSetCooldown")
	end
	if AB.db.cooldownalpha then
		self:SecureHook("ActionButton_UpdateState", "UpdateCDAlpha")
		self:SecureHook("ActionButton_UpdateAction", "UpdateCDAlpha")
	end
	if AB.db.stancealpha then
		self:SecureHook("ActionButton_UpdateAction", "UpdateShapeshiftCDAlpha")
	end
end