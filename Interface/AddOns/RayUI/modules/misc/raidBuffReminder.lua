local R, L, P = unpack(select(2, ...)) --Inport: Engine, Locales, ProfileDB
local M = R:GetModule("Misc")

local function LoadFunc()
	if not M.db.raidbuffreminder then return end

	local bsize = ((Minimap:GetWidth() - 6) / 6) - 4

	local Stats = {
		[90363] = "HUNTER", -- Embrace of the Shale Spider
		[117667] = "MONK", --Legacy of The Emperor
		[1126] = "DRUID", -- Mark of The Wild
		[20217] = "PALADIN", -- Blessing Of Kings
		["DEFAULT"] = 20217
	}

	local Stamina = {
		[90364] = "HUNTER", -- Qiraji Fortitude
		[469] = "WARRIOR", -- Commanding Shout
		[6307] = "WARLOCK", -- Imp. Blood Pact
		[21562] = "PRIEST", -- Power Word: Fortitude
		["DEFAULT"] = 21562
	}

	local AttackPower = {
		[19506] = "HUNTER", -- Trueshot Aura
		[6673] = "WARRIOR", -- Battle Shout
		[57330] = "DEATHKNIGHT", -- Horn of Winter
		["DEFAULT"] = 57330
	}

	local SpellPower = {
		[126309] = "HUNTER", -- Still Water
		[77747] = "SHAMAN", -- Burning Wrath
		[109773] = "WARLOCK", -- Dark Intent
		[61316] = "MAGE", -- Dalaran Brilliance
		[1459] = "MAGE", -- Arcane Brilliance
		["DEFAULT"] = 1459
	}

	local AttackSpeed = {
		[128432] = "HUNTER", -- Cackling Howl
		[128433] = "HUNTER", -- Serpent"s Swiftness
		[30809] = "SHAMAN", -- Unleashed Rage
		[113742] = "ROGUE", -- Swiftblade"s Cunning
		[55610] = "DEATHKNIGHT", -- Improved Icy Talons
		["DEFAULT"] = 55610
	}

	local SpellHaste = {
		[24907] = "DRUID", -- Moonkin Aura
		[51470] = "SHAMAN", -- Elemental Oath
		[49868] = "PRIEST", -- Mind Quickening
		["DEFAULT"] = 49868
	}

	local CriticalStrike = {
		[126309] = "HUNTER", -- Still Water
		[24604] = "HUNTER", -- Furious Howl
		[90309] = "HUNTER", -- Terrifying Roar
		[1459] = "MAGE", -- Arcane Brilliance
		[61316] = "MAGE", -- Dalaran Brilliance
		[24932] = "DRUID", -- Leader of The Pact
		[116781] = "MONK", -- Legacy of the White Tiger
		["DEFAULT"] = 116781
	}

	local Mastery = {
		[93435] = "HUNTER", --Roar of Courage
		[128997] = "HUNTER", --Spirit Beast Blessing
		[116956] = "SHAMAN", --Grace of Air
		[19740] = "PALADIN", -- Blessing of Might
		["DEFAULT"] = 19740
	}

	local IndexTable = {
		[1] = Stats,
		[2] = Stamina,
		[3] = AttackPower,
		[4] = AttackSpeed,
		[5] = CriticalStrike,
		[6] = Mastery,
	}

	local function FormatTime(s)
		local day, hour, minute = 86400, 3600, 60
		if s >= day then
			return format("%dd", ceil(s / day))
		elseif s >= hour then
			return format("%dh", ceil(s / hour))
		elseif s >= minute then
			return format("%dm", ceil(s / minute))
		elseif s >= minute then
			return format("%d", s)
		end
		return format("%d", s)
	end

	local function CheckFilterForActiveBuff(filter)
		local spellName, texture
		for spell in pairs(filter) do
			if spell ~= "DEFAULT" then
				local spellName, _, texture = GetSpellInfo(spell)

				assert(spellName, spell..": ID is not correct.")

				if UnitAura("player", spellName) then
					return spellName, texture
				end
			end

			texture =  select(3, GetSpellInfo(filter["DEFAULT"]))
		end

		return false, texture
	end

	local function UpdateRaidBuffReminderTime(self, elapsed)
		if(self.expiration) then
			self.expiration = math.max(self.expiration - elapsed, 0)
			if(self.expiration <= 0) then
				self.timer:SetText("")
			else
				local time = FormatTime(self.expiration)
				if self.expiration <= 86400.5 and self.expiration > 600.5 then
					self.timer:SetText("|cffcccccc"..time.."|r")
				elseif self.expiration <= 600.5 and self.expiration > 60.5 then
					self.timer:SetText("|cffffff00"..time.."|r")
				elseif self.expiration <= 60.5 then
					self.timer:SetText("|cffff0000"..time.."|r")
				end
			end
		end
	end

	local function UpdateReminder(event, unit)
		if (event == "UNIT_AURA" and unit ~= "player") then return end
		local frame = RaidBuffReminder

		if M.db.raidbuffreminderparty and GetNumGroupMembers() == 0 then
			return frame:Hide()
		elseif M.db.raidbuffreminderparty and GetNumGroupMembers() > 0 then
			frame:Show()
		end
		
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
				local spellName, duration, expirationTime, _
				for i=1, 32 do
					spellName, _, _, _, _, duration, expirationTime = UnitBuff("player", i)
					if spellName == hasBuff then
						break;
					end
				end

				frame["spell"..i].expiration = expirationTime - GetTime()
				frame["spell"..i].duration = duration

				if duration == 0 and expirationTime == 0 then
					frame["spell"..i].t:SetAlpha(0.3)
					frame["spell"..i]:SetScript("OnUpdate", nil)
				else
					CooldownFrame_SetTimer(frame["spell"..i].cd, expirationTime - duration, duration, 1)
					frame["spell"..i].t:SetAlpha(0.3)
					if M.db.raidbuffreminderduration == true then
						frame["spell"..i]:SetScript("OnUpdate", UpdateRaidBuffReminderTime)
					end
				end
				frame["spell"..i].hasBuff = hasBuff
			else
				CooldownFrame_SetTimer(frame["spell"..i].cd, 0, 0, 0)
				frame["spell"..i].t:SetAlpha(1)
				frame["spell"..i].hasBuff = nil
				frame["spell"..i]:SetScript("OnUpdate", nil)
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
		for spellID, buffProvider in pairs(IndexTable[id]) do
			if spellID ~= "DEFAULT" then
			local spellName = GetSpellInfo(spellID)
			local color = RAID_CLASS_COLORS[buffProvider]

			if self:GetParent().hasBuff == spellName then
				GameTooltip:AddLine(spellName.." - "..ACTIVE_PETS, color.r, color.g, color.b)
			else
				GameTooltip:AddLine(spellName, color.r, color.g, color.b)
			end
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

		button.cd = CreateFrame("Cooldown", nil, button, "CooldownFrameTemplate")
		button.cd:SetAllPoints()
		button.cd.noOCC = true

		button.timer = button.cd:CreateFontString(nil, "OVERLAY")
		button.timer:Point("CENTER", 1, 0)
		button.timer:SetFont(R["media"].pxfont, R.mult*10, "OUTLINE,MONOCHROME")
		
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
	if M.db.raidbuffreminderparty then
		frame:RegisterEvent("GROUP_ROSTER_UPDATE")
	end
	frame:SetScript("OnEvent", UpdateReminder)
	UpdateReminder()
end

M:RegisterMiscModule("RaidBuffReminder", LoadFunc)