local R, L, P = unpack(select(2, ...)) --Inport: Engine, Locales, ProfileDB
local AB = R:GetModule("ActionBar")

local _G = _G
local UPDATE_DELAY = 0.15
local ATTACK_BUTTON_FLASH_TIME = ATTACK_BUTTON_FLASH_TIME
local SPELL_POWER_HOLY_POWER = SPELL_POWER_HOLY_POWER
local RANGE_COLORS = {
	normal = {1, 1, 1},
	oor = {1, 0.3, 0.1},
	oom = {0.1, 0.3, 1},
	ooh = {0.45, 0.45, 1},
	holyPowerThreshold = 3
}
local ActionButton_GetPagedID = ActionButton_GetPagedID
local ActionButton_IsFlashing = ActionButton_IsFlashing
local ActionHasRange = ActionHasRange
local IsActionInRange = IsActionInRange
local IsUsableAction = IsUsableAction
local HasAction = HasAction

--stuff for holy power detection
local PLAYER_IS_PALADIN = select(2, UnitClass('player')) == 'PALADIN'
local HAND_OF_LIGHT = GetSpellInfo(90174)
local HOLY_POWER_SPELLS = {
	[85256] = GetSpellInfo(85256), --Templar's Verdict
	[53600] = GetSpellInfo(53600), --Shield of the Righteous
}

local function isHolyPowerAbility(actionId)
	local actionType, id = GetActionInfo(actionId)
	if actionType == 'macro' then
		local macroSpell = GetMacroSpell(id)
		if macroSpell then
			for spellId, spellName in pairs(HOLY_POWER_SPELLS) do
				if macroSpell == spellName then
					return true
				end
			end
		end
	else
		return HOLY_POWER_SPELLS[id]
	end
	return false
end

function AB:CreateRangeDisplay()
	self.colors = RANGE_COLORS
	self.buttonsToUpdate = {}

	hooksecurefunc("ActionButton_OnUpdate", AB.RegisterButtonRange)
	hooksecurefunc("ActionButton_UpdateUsable", AB.OnUpdateButtonUsable)
	hooksecurefunc("ActionButton_Update", AB.OnButtonUpdate)

	local rangeDisplay = CreateFrame("Frame")
	local updater = rangeDisplay:CreateAnimationGroup()
	updater:SetLooping("NONE")
	updater:SetScript("OnFinished", function(self)
		if AB:UpdateRange() then
			AB:Start(UPDATE_DELAY)
		end
	end)

	local a = updater:CreateAnimation("Animation")
	a:SetOrder(1)

	function AB:Start()
		self:Stop()
		a:SetDuration(UPDATE_DELAY)
		updater:Play()
		return self
	end

	function AB:Stop()
		if updater:IsPlaying() then
			updater:Stop()
		end
		return self
	end

	function AB:Active()
		return updater:IsPlaying()
	end
end

function AB:UpdateRange()
	return self:UpdateButtons(UPDATE_DELAY)
end

function AB:ForceColorUpdate()
	for button in pairs(self.buttonsToUpdate) do
		AB.OnUpdateButtonUsable(button)
	end
end

function AB:UpdateActive()
	if next(self.buttonsToUpdate) then
		if not self:Active() then
			self:Start()
		end
	else
		self:Stop()
	end
end

function AB:UpdateButtons(elapsed)
	if next(self.buttonsToUpdate) then
		for button in pairs(self.buttonsToUpdate) do
			self:UpdateButton(button, elapsed)
		end
		return true
	end
	return false
end

function AB:UpdateButton(button, elapsed)
	AB.UpdateButtonUsable(button)
	AB.UpdateFlash(button, elapsed)
end

function AB:UpdateButtonStatus(button)
	local action = ActionButton_GetPagedID(button)
	if button:IsVisible() and action and HasAction(action) and ActionHasRange(action) then
		self.buttonsToUpdate[button] = true
	else
		self.buttonsToUpdate[button] = nil
	end
	self:UpdateActive()
end

function AB.RegisterButtonRange(button)
	button:HookScript('OnShow', AB.OnButtonShow)
	button:HookScript('OnHide', AB.OnButtonHide)
	button:SetScript('OnUpdate', nil)

	AB:UpdateButtonStatus(button)
end

function AB.OnButtonShow(button)
	AB:UpdateButtonStatus(button)
end

function AB.OnButtonHide(button)
	AB:UpdateButtonStatus(button)
end

function AB.OnUpdateButtonUsable(button)
	button.RangeColor = nil
	AB.UpdateButtonUsable(button)
end

function AB.OnButtonUpdate(button)
	 AB:UpdateButtonStatus(button)
end

function AB.UpdateButtonUsable(button)
	local action = ActionButton_GetPagedID(button)
	local isUsable, notEnoughMana = IsUsableAction(action)

	--usable
	if isUsable then
		--but out of range
		if IsActionInRange(action) == 0 then
			AB.SetButtonColor(button, 'oor')
		--a holy power abilty, and we're less than 3 Holy Power
		elseif PLAYER_IS_PALADIN and isHolyPowerAbility(action) and not(UnitPower('player', SPELL_POWER_HOLY_POWER) >= AB:GetHolyPowerThreshold() or UnitBuff('player', HAND_OF_LIGHT)) then
			AB.SetButtonColor(button, 'ooh')
		--in range
		else
			AB.SetButtonColor(button, 'normal')
		end
	--out of mana
	elseif notEnoughMana then
		--a holy power abilty, and we're less than 3 Holy Power
		if PLAYER_IS_PALADIN and isHolyPowerAbility(action) and not(UnitPower('player', SPELL_POWER_HOLY_POWER) >= AB:GetHolyPowerThreshold() or UnitBuff('player', HAND_OF_LIGHT)) then
			AB.SetButtonColor(button, 'ooh')
		else
			AB.SetButtonColor(button, 'oom')
		end
	--unusable
	else
		button.RangeColor = 'unusuable'
	end
end

function AB.SetButtonColor(button, colorType)
	if button.RangeColor ~= colorType then
		button.RangeColor = colorType

		local r, g, b = AB:GetColor(colorType)

		local icon =  _G[button:GetName() .. 'Icon']
		icon:SetVertexColor(r, g, b)
	end
end

function AB.UpdateFlash(button, elapsed)
	if ActionButton_IsFlashing(button) then
		local flashtime = button.flashtime - elapsed

		if flashtime <= 0 then
			local overtime = -flashtime
			if overtime >= ATTACK_BUTTON_FLASH_TIME then
				overtime = 0
			end
			flashtime = ATTACK_BUTTON_FLASH_TIME - overtime

			local flashTexture = _G[button:GetName() .. 'Flash']
			if flashTexture:IsShown() then
				flashTexture:Hide()
			else
				flashTexture:Show()
			end
		end

		button.flashtime = flashtime
	end
end

function AB:Reset()
	self:ForceColorUpdate()
end

function AB:SetColor(index, r, g, b)
	local color = self.colors[index]
	color[1] = r
	color[2] = g
	color[3] = b

	self:ForceColorUpdate()
end

function AB:GetColor(index)
	local color = self.colors[index]
	return color[1], color[2], color[3]
end

function AB:SetHolyPowerThreshold(value)
	self.colors.holyPowerThreshold = value
end

function AB:GetHolyPowerThreshold()
	return self.colors.holyPowerThreshold
end