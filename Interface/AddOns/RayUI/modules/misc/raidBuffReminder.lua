local R, L, P = unpack(select(2, ...)) --Inport: Engine, Locales, ProfileDB
local M = R:GetModule("Misc")

local function LoadFunc()
	if not M.db.raidbuffreminder then return end

	local bsize = ((Minimap:GetWidth() - 6) / 6) - 4

	local Stats = {
		117667, --Legacy of The Emperor
		1126, -- Mark of The Wild
		20217, -- Blessing Of Kings
	}

	local Stamina = {
		469, -- Commanding Shout
		6307, -- Imp. Blood Pact
		21562, -- Power Word: Fortitude
	}

	local AttackPower = {
		19506, -- Trueshot Aura
		6673, -- Battle Shout
		57330, -- Horn of Winter
	}

	local SpellPower = {
		77747, -- Burning Wrath
		109773, -- Dark Intent
		61316, -- Dalaran Brilliance
		1459, -- Arcane Brilliance
	}

	local AttackSpeed = {
		30809, -- Unleashed Rage
		113742, -- Swiftblade"s Cunning
		55610, -- Improved Icy Talons
	}

	local SpellHaste = {
		24907, -- Moonkin Aura
		51470, -- Elemental Oath
		49868, -- Mind Quickening
	}

	local CriticalStrike = {
		19506, -- Trueshot Aura
		1459, -- Arcane Brilliance
		61316, -- Dalaran Brilliance
		24932, -- Leader of The Pact
		116781, -- Legacy of the White Tiger
	}

	local Mastery = {
		116956, --Grace of Air
		19740, -- Blessing of Might
	}

	local IndexTable = {
		[1] = Stats,
		[2] = Stamina,
		[3] = AttackPower,
		[4] = AttackSpeed,
		[5] = CriticalStrike,
		[6] = Mastery,
	}

	local function CheckFilterForActiveBuff(filter)
		local spellName, texture
		for _, spell in pairs(filter) do
			spellName, _, texture = GetSpellInfo(spell)
			
			assert(spellName, spell..": ID is not correct.")
			
			if UnitAura("player", spellName) then
				return spellName, texture
			end
		end

		return false, texture
	end

	local function UpdateReminder(event, unit)
		if (event == "UNIT_AURA" and unit ~= "player") then return end
		local frame = RaidBuffReminder
		
		if event ~= "UNIT_AURA" and not InCombatLockdown() then
			if R.Role == "Caster" then
				ConsolidatedBuffsTooltipBuff3:Hide()
				ConsolidatedBuffsTooltipBuff4:Hide()
				ConsolidatedBuffsTooltipBuff5:Show()
				ConsolidatedBuffsTooltipBuff6:Show()			
			else
				ConsolidatedBuffsTooltipBuff3:Show()
				ConsolidatedBuffsTooltipBuff4:Show()
				ConsolidatedBuffsTooltipBuff5:Hide()
				ConsolidatedBuffsTooltipBuff6:Hide()		
			end
		end
		
		if R.Role == "Caster" then
			IndexTable[3] = SpellPower
			IndexTable[4] = SpellHaste
		else
			IndexTable[3] = AttackPower
			IndexTable[4] = AttackSpeed
		end
		
		
		for i = 1, 6 do
			local hasBuff, texture = CheckFilterForActiveBuff(IndexTable[i])
			frame["spell"..i].t:SetTexture(texture)
			if hasBuff then
				frame["spell"..i]:SetAlpha(0.2)
				frame["spell"..i].hasBuff = hasBuff
			else
				frame["spell"..i]:SetAlpha(1)
				frame["spell"..i].hasBuff = nil
			end
		end
	end

	local function Button_OnEnter(self)
		GameTooltip:Hide()
		GameTooltip:SetOwner(RaidBuffReminder, "ANCHOR_BOTTOM", 0, -10)
		GameTooltip:ClearLines()
		
		local id = self:GetParent():GetID()
		
		if (id == 3 or id == 4) and R.Role == "Caster" then
			IndexTable[3] = SpellPower
			IndexTable[4] = SpellHaste
			
			GameTooltip:AddLine(_G["RAID_BUFF_"..id+2])
		elseif id >= 5 then
			GameTooltip:AddLine(_G["RAID_BUFF_"..id+2])
		else
			if R.Role ~= "Caster" then
				IndexTable[3] = AttackPower
				IndexTable[4] = AttackSpeed
			end
			
			GameTooltip:AddLine(_G["RAID_BUFF_"..id])
		end

		GameTooltip:AddLine(" ")
		for _, spellID in pairs(IndexTable[id]) do
			local spellName = GetSpellInfo(spellID)
			if self:GetParent().hasBuff == spellName then
				GameTooltip:AddLine(spellName, 0, 1, 0)
			else
				GameTooltip:AddLine(spellName, .5, .5, .5)
			end
		end

		GameTooltip:Show()
	end

	local function Button_OnLeave(self)
		GameTooltip:Hide()
	end

	local function CreateButton(relativeTo, isFirst, isLast)
		local button = CreateFrame("Frame", nil, RaidBuffReminder)
		button:CreateShadow("Background")
		button:SetSize(bsize, bsize)
		if isFirst then
			button:SetPoint("LEFT", relativeTo, "LEFT", 0, 0)
		else
			button:SetPoint("LEFT", relativeTo, "RIGHT", 6, 0)
		end

		if isLast then
			button:SetPoint("RIGHT", RaidBuffReminder, "RIGHT", 0, 0)
		end

		button.t = button:CreateTexture(nil, "OVERLAY")
		button.t:SetTexCoord(.08, .92, .08, .92)
		button.t:SetAllPoints()
		button.t:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark")
		
		return button
	end

	local frame = CreateFrame("Frame", "RaidBuffReminder", Minimap)
	frame:SetHeight(bsize)
	frame:Point("TOPLEFT", Minimap, "BOTTOMLEFT", 0, -6)
	frame:Point("TOPRIGHT", Minimap, "BOTTOMRIGHT", 0, -6)

	frame.spell1 = CreateButton(frame, true)
	frame.spell2 = CreateButton(frame.spell1)
	frame.spell3 = CreateButton(frame.spell2)
	frame.spell4 = CreateButton(frame.spell3)
	frame.spell5 = CreateButton(frame.spell4)
	frame.spell6 = CreateButton(frame.spell5, nil, true)

	for i=1, NUM_LE_RAID_BUFF_TYPES do
		local id = i
		if i > 4 then
			id = i - 2
		end
		
		frame["spell"..id]:SetID(id)
		
		--This is so hackish its funny.. 
		--Have to do this to be able to right click a consolidated buff icon in combat and remove the aura.
		_G["ConsolidatedBuffsTooltipBuff"..i]:ClearAllPoints()
		_G["ConsolidatedBuffsTooltipBuff"..i]:SetAllPoints(frame["spell"..id])
		_G["ConsolidatedBuffsTooltipBuff"..i]:SetParent(frame["spell"..id])
		_G["ConsolidatedBuffsTooltipBuff"..i]:SetAlpha(0)
		_G["ConsolidatedBuffsTooltipBuff"..i]:SetScript("OnEnter", Button_OnEnter)
		_G["ConsolidatedBuffsTooltipBuff"..i]:SetScript("OnLeave", Button_OnLeave)		
	end
	
	RaidBuffReminder:Show()
	BuffFrame:RegisterEvent("UNIT_AURA")
	frame:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
	frame:RegisterEvent("UNIT_INVENTORY_CHANGED")
	frame:RegisterUnitEvent("UNIT_AURA", "player")
	frame:RegisterEvent("PLAYER_REGEN_ENABLED")
	frame:RegisterEvent("PLAYER_REGEN_DISABLED")
	frame:RegisterEvent("PLAYER_ENTERING_WORLD")
	frame:RegisterEvent("UPDATE_BONUS_ACTIONBAR")
	frame:RegisterEvent("CHARACTER_POINTS_CHANGED")
	frame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
	frame:SetScript("OnEvent", UpdateReminder)
	UpdateReminder()
end

M:RegisterMiscModule("RaidBuffReminder", LoadFunc)