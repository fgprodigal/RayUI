local _, ns = ...
local oUF = RayUF or oUF

local function Update(self)
	if not self.Fader then return end

	local unit = self.unit

	local _, powerType = UnitPowerType(unit)
	local power = UnitPower(unit)

	if
		(UnitCastingInfo(unit) or UnitChannelInfo(unit)) or
		UnitAffectingCombat(unit) or
		(unit:find('target') and UnitExists(unit)) or
		UnitExists(( unit == "pet" and "player" or unit ) .. 'target') or
		UnitHealth(unit) < UnitHealthMax(unit) or
		((powerType == 'RAGE' or powerType == 'RUNIC_POWER') and power > 0) or
		((powerType ~= 'RAGE' and powerType ~= 'RUNIC_POWER') and power < UnitPowerMax(unit)) or
		GetMouseFocus() == self
	then
	--	if self:GetAlpha() < (self.FadeMaxAlpha or 1) then
			if self.FadeSmooth and (not InCombatLockdown()) then
				UIFrameFadeIn(self, self.FadeSmooth, self:GetAlpha(), self.FadeMaxAlpha or 1)
			else
				self:SetAlpha(self.FadeMaxAlpha or 1)
			end
	--	end
	else
	--	if self:GetAlpha() > (self.FadeMinAlpha or 0.3) then
			if self.FadeSmooth and (not InCombatLockdown()) then
				UIFrameFadeOut(self, self.FadeSmooth, self:GetAlpha(), self.FadeMinAlpha or 0.3)
			else
				self:SetAlpha(self.FadeMinAlpha or 0.3)
			end
	--	end
	end
end

local function ForceUpdate(element)
	return Update(element.__owner)
end

local function Enable(self, unit)
	if
		unit == 'player' or
		unit == 'target' or
		unit == 'targettarget' or
		unit == 'focus' or
		unit == 'pet'
	then
		self:HookScript('OnEnter', Update)
		self:HookScript('OnLeave', Update)
		self:RegisterEvent('PLAYER_REGEN_ENABLED', Update)
		self:RegisterEvent('PLAYER_REGEN_DISABLED', Update)
		self:HookScript('OnShow', Update)
		self:RegisterEvent('UNIT_TARGET', Update)
		self:RegisterEvent('PLAYER_TARGET_CHANGED', Update)
		self:RegisterEvent('PLAYER_ENTERING_WORLD', Update)
		self:RegisterEvent('UNIT_HEALTH', Update)
		self:RegisterEvent('UNIT_HEALTHMAX', Update)
		self:RegisterEvent('UNIT_POWER', Update)
		self:RegisterEvent('UNIT_POWERMAX', Update)

		self:RegisterEvent('UNIT_SPELLCAST_START', Update)
		self:RegisterEvent('UNIT_SPELLCAST_FAILED', Update)
		self:RegisterEvent('UNIT_SPELLCAST_STOP', Update)
		self:RegisterEvent('UNIT_SPELLCAST_INTERRUPTED', Update)
		self:RegisterEvent('UNIT_SPELLCAST_CHANNEL_START', Update)
		self:RegisterEvent('UNIT_SPELLCAST_CHANNEL_INTERRUPTED', Update)
		self:RegisterEvent('UNIT_SPELLCAST_CHANNEL_STOP', Update)

		Update(self)

		return true
	end
end

local function Disable(self, unit)
	if
		unit == 'player' or
		unit == 'target' or
		unit == 'targettarget' or
		unit == 'focus' or
		unit == 'pet'
	then
		self:UnregisterEvent('PLAYER_REGEN_ENABLED', Update)
		self:UnregisterEvent('PLAYER_REGEN_DISABLED', Update)
		self:UnregisterEvent('UNIT_TARGET', Update)
		self:UnregisterEvent('PLAYER_TARGET_CHANGED', Update)
		self:UnregisterEvent('PLAYER_ENTERING_WORLD', Update)
		self:UnregisterEvent('UNIT_HEALTH', Update)
		self:UnregisterEvent('UNIT_HEALTHMAX', Update)
		self:UnregisterEvent('UNIT_POWER', Update)
		self:UnregisterEvent('UNIT_POWERMAX', Update)

		self:UnregisterEvent('UNIT_SPELLCAST_START', Update)
		self:UnregisterEvent('UNIT_SPELLCAST_FAILED', Update)
		self:UnregisterEvent('UNIT_SPELLCAST_STOP', Update)
		self:UnregisterEvent('UNIT_SPELLCAST_INTERRUPTED', Update)
		self:UnregisterEvent('UNIT_SPELLCAST_CHANNEL_START', Update)
		self:UnregisterEvent('UNIT_SPELLCAST_CHANNEL_INTERRUPTED', Update)
		self:UnregisterEvent('UNIT_SPELLCAST_CHANNEL_STOP', Update)
	end
end

oUF:AddElement('Fader', Path, Enable, Disable)
