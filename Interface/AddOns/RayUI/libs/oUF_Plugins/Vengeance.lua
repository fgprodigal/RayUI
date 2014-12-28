local _, ns = ...
local oUF = RayUF or oUF

local vengeance = GetSpellInfo(158300)
-- local vengeance = GetSpellInfo(76691)

local function valueChanged(self, event, unit)
	local R, L = unpack(RayUI)
	if unit ~= "player" then return end
	local bar = self.Vengeance

	if R.Role ~= "Tank" then
		bar:Hide()
		return
	end

	local name = UnitAura("player", vengeance, nil, "PLAYER|HELPFUL")

	if name then
		local value = select(15, UnitAura("player", vengeance, nil, "PLAYER|HELPFUL")) or -1
		if value > 0 then
			if value > bar.max then bar.max = value end
			if value == bar.value then return end

			bar:SetMinMaxValues(0, bar.max)
			bar:SetValue(value)
			bar.value = value
			bar:Show()

			if bar.Text then
				bar.Text:SetText(value)
			end
		else
			bar:Hide()
			bar.value = 0
		end
	elseif bar.showInfight and InCombatLockdown() then
		bar:Show()
		bar:SetMinMaxValues(0, 1)
		bar:SetValue(0)
		bar.value = 0
	else
		bar:Hide()
		bar.value = 0
	end
end

local function Enable(self, unit)
	local bar = self.Vengeance

	if bar and unit == "player" then
		bar.max = 100
		bar.value = 0
		self:RegisterEvent("UNIT_AURA", valueChanged)

		bar:Hide()
		bar:SetScript("OnEnter", function(self)
			GameTooltip:ClearLines()
			GameTooltip:SetOwner(self, "ANCHOR_TOP", 0, 5)
			if self.value > 0 then
				GameTooltip:SetUnitBuff("player", vengeance)
			end
			GameTooltip:Show()
		end)
		bar:SetScript("OnLeave", function(self)
			GameTooltip:Hide()
		end)
		return true
	end
end

local function Disable(self)
	local bar = self.Vengeance

	if bar then
		self:UnregisterEvent("UNIT_AURA", valueChanged)
	end
end

oUF:AddElement("Vengeance", nil, Enable, Disable)
