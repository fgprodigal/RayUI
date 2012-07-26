local _, ns = ...
local oUF = RayUF or oUF

local function tooltip(self)
	local name, id, min, max, value = GetWatchedFactionInfo()
	GameTooltip:SetOwner(self, 'ANCHOR_TOP', 0, 10)
	GameTooltip:AddLine(string.format('%s (%s)', name, _G['FACTION_STANDING_LABEL'..id]))
	GameTooltip:AddLine(string.format('%d / %d (%d%%)', value - min, max - min, (value - min) / (max - min) * 100))
	GameTooltip:Show()
end

local function update(self, event, unit)
	local bar = self.Reputation
	if(not GetWatchedFactionInfo()) then return bar:Hide() end

	local name, standing, min, max, value = GetWatchedFactionInfo()
	bar:SetMinMaxValues(min, max)
	bar:SetValue(value)
	bar:Show()

	if(bar.Text) then
		if(bar.OverrideText) then
			bar:OverrideText(min, max, value, name, standing)
		else
			bar.Text:SetFormattedText('%d / %d - %s', value - min, max - min, name)
		end
	end

	if(bar.colorStanding) then
		local color = FACTION_BAR_COLORS[standing]
		bar:SetStatusBarColor(color.r, color.g, color.b)
	end

	if(bar.PostUpdate) then bar.PostUpdate(self, event, unit, bar, min, max, value, name, standing) end
end

local function enable(self, unit)
	local bar = self.Reputation
	if(bar and unit == 'player') then
		if(not bar:GetStatusBarTexture()) then
			bar:SetStatusBarTexture([=[Interface\TargetingFrame\UI-StatusBar]=])
		end

		self:RegisterEvent('UPDATE_FACTION', update)

		if(bar.Tooltip) then
			bar:EnableMouse()
			bar:HookScript('OnLeave', GameTooltip_Hide)
			bar:HookScript('OnEnter', tooltip)
		end

		return true
	end
end

local function disable(self)
	if(self.Reputation) then
		self:UnregisterEvent('UPDATE_FACTION', update)
	end
end

oUF:AddElement('Reputation', update, enable, disable)
