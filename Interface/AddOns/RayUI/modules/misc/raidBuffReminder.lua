local R, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local M = R:GetModule("Misc")

local function LoadFunc()
	if not M.db.raidbuffreminder then return end

	-- local bsize = (Minimap:GetWidth() +3) / 8 - 3
	local bsize = 30
	local ignoreIcons = {}

	local DefaultIcons = {
		[1] = "Interface\\Icons\\Spell_Magic_GreaterBlessingofKings", -- Stats
		[2] = "Interface\\Icons\\Spell_Holy_WordFortitude", -- Stamina
		[3] = "Interface\\Icons\\INV_Misc_Horn_02", --Attack Power
		[4] = "Interface\\Icons\\INV_Helmet_08", --Haste
		[5] = "Interface\\Icons\\Spell_Holy_MagicalSentry", --Spell Power
		[6] = "Interface\\Icons\\ability_monk_prideofthetiger", -- Critical Strike
		[7] = "Interface\\Icons\\Spell_Holy_GreaterBlessingofKings", --Mastery
		[8] = "Interface\\ICONS\\spell_warlock_focusshadow", --Multistrike
		[9] = "Interface\\Icons\\Spell_Holy_MindVision" --Versatility
	}

	local Food = {
		[104273] = true, --250 Agility
		[104274] = true, --275 Agility
		[104275] = true, --300 Agility

		[104267] = true, -- 250 Strength
		[104271] = true, -- 275 Strength
		[104272] = true, -- 300 Strength

		[104264] = true, -- 250 Intellect
		[104276] = true, -- 275 Intellect
		[104277] = true, -- 300 Intellect

		[104277] = true, -- 250 Spirit
		[104279] = true, -- 275 Spirit
		[104280] = true, -- 300 Spirit

		[104281] = true, -- 375 Stamina
		[104282] = true, -- 415 Stamina
		[104283] = true, -- 450 Stamina

		["DEFAULT"] = 104275
	}

	local Flask = {
		[105689.] = true, --Flask of Spring Blossoms
		[105691.] = true, --Flask of the Warm Sun
		[105693.] = true, --Flask of Falling Leaves
		[105694.] = true, --Flask of the Earth
		[105696.] = true, --Flask of Winter's Bite
		["DEFAULT"] = 105689
	}

	local IndexTable = {
		[1] = Flask,
		[2] = Food,
		[3] = Stats,
		[4] = Stamina,
		[5] = AttackPower,
		[6] = AttackSpeed,
		[7] = CriticalStrike,
		[8] = Mastery,
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

				local spn, _, _, _, _, _, _, _, _, _, spellID = UnitAura("player", spellName)
				local food = true

				if filter == Food then
					if spell ~= spellID then food = false end
				end

				if spn and food then
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
			self.timerbar:SetValue(self.expiration)
		else
			self.timerbar:SetValue(select(2,self.timerbar:GetMinMaxValues()))
		end
	end

	local function UpdateReminder(event, unit)
		if (event == "UNIT_AURA" and unit ~= "player") then return end
		local frame = RaidBuffReminder
		
		wipe(ignoreIcons)
		if R.Role == "Caster" then
			ignoreIcons[3] = 2
		else
			ignoreIcons[5] = 4
		end

		for i = 1, NUM_LE_RAID_BUFF_TYPES do
			local button = frame["spell"..i]
			button.t:SetAlpha(1)
			button:ClearAllPoints()

			if i == 1 then
				button:SetPoint("LEFT", frame, "LEFT", 0, 0)
			else
				local index = ignoreIcons[i - 1] or (i - 1)
				button:SetPoint("LEFT", frame["spell"..index], "RIGHT", 8, 0)
			end

			if(ignoreIcons[i]) then
				button:Hide()
			else
				button:Show()
			end
		end
		
		if M.db.raidbuffreminderparty and GetNumGroupMembers() == 0 then
			return frame:Hide()
		elseif M.db.raidbuffreminderparty and GetNumGroupMembers() > 0 then
			frame:Show()
		end

		for i = 1, NUM_LE_RAID_BUFF_TYPES do
			local spellName, rank, texture, duration, expirationTime, spellId, slot = GetRaidBuffTrayAuraInfo(i)
			local button = frame["spell"..i]
			
			if(spellName) then
				button.expiration = expirationTime - GetTime()
				button.duration = duration
				button.t:SetTexture(texture)

				if duration == 0 and expirationTime == 0 then
					button.t:SetDesaturated(false)
					button.timerbar:SetMinMaxValues(0, 1)
					button.timerbar:SetValue(1)
					button.timerbar:Show()
					button:SetScript("OnUpdate", nil)
				else
					button.t:SetDesaturated(false)
					if M.db.raidbuffreminderduration == true then
						button.timerbar:SetMinMaxValues(0, duration)
						button.timerbar:SetValue(0)
						button.timerbar:Show()
						button:SetScript("OnUpdate", UpdateRaidBuffReminderTime)
					end
				end
				button.hasBuff = true
			else
				button.t:SetTexture(DefaultIcons[i])
				button.t:SetDesaturated(true)
				button.timerbar:Hide()
				button.hasBuff = nil
				button:SetScript("OnUpdate", nil)
			end
		end
	end

	local function Button_OnEnter(self)
		GameTooltip:Hide()
		GameTooltip:SetOwner(self, "ANCHOR_BOTTOMLEFT", -5, -5)
		GameTooltip:ClearLines()
		
		local id = self:GetID()
		if(self.hasBuff) then
			GameTooltip:SetUnitConsolidatedBuff("player", id)
		else
			GameTooltip:AddLine(_G[("RAID_BUFF_%d"):format(id)])
		end
		
		GameTooltip:Show()
	end

	local function ConsolidatedBuffsTooltip_OnEnter(self)
		GameTooltip:Hide()
		GameTooltip:SetOwner(self, "ANCHOR_BOTTOMLEFT", -5, -5)
		GameTooltip:ClearLines()

		local id = self:GetParent():GetID() - 2

		if IsModifierKeyDown() and self:GetParent().hasBuff then
			if (id == 5 or id == 6) and R.Role ~= "Caster" then
				id = id + 2
			elseif (id == 3 or id == 4) and R.Role == "Caster" then
				id = id + 2
			end
			GameTooltip:SetUnitConsolidatedBuff("player", id)
		else
			IndexTable[7] = CriticalStrike
			IndexTable[8] = Mastery

			if (id == 3 or id == 4) and R.Role == "Caster" then
				IndexTable[5] = SpellPower
				IndexTable[6] = SpellHaste

				GameTooltip:AddLine(_G["RAID_BUFF_"..id+2])
			elseif id >= 5 then
				GameTooltip:AddLine(_G["RAID_BUFF_"..id+2])
			else
				if R.Role ~= "Caster" then
					IndexTable[5] = AttackPower
					IndexTable[6] = AttackSpeed
				end

				GameTooltip:AddLine(_G["RAID_BUFF_"..id])
			end

			GameTooltip:AddLine(" ")
			for spellID, buffProvider in pairs(IndexTable[id+2]) do
				if spellID ~= "DEFAULT" then
					local spellName = GetSpellInfo(spellID)
					local color = R.colors.class[buffProvider]

					if self:GetParent().hasBuff == spellName then
						GameTooltip:AddLine(spellName.." - "..ACTIVE_PETS, color.r, color.g, color.b)
					else
						GameTooltip:AddLine(spellName, color.r, color.g, color.b)
					end
				end
			end
		end

		GameTooltip:Show()
	end

	local function CreateButton(relativeTo, isFirst)
		local button = CreateFrame("Frame", nil, RaidBuffReminder)
		button:CreateShadow("Background")
		button:SetSize(bsize, bsize)
		if isFirst then
			button:SetPoint("LEFT", relativeTo, "LEFT", 0, 0)
		else
			button:SetPoint("LEFT", relativeTo, "RIGHT", 8, 0)
		end

		button.t = button:CreateTexture(nil, "OVERLAY")
		button.t:SetTexCoord(.08, .92, .08, .92)
		button.t:SetAllPoints()
		button.t:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark")

		-- button.highlight = button:CreateTexture(nil, "HIGHLIGHT")
		-- button.highlight:SetTexture(1,1,1,0.45)
		-- button.highlight:SetAllPoints(button.t)

		button.cd = CreateFrame("Cooldown", nil, button, "CooldownFrameTemplate")
		button.cd:SetAllPoints()
		button.cd.noOCC = true

		button.timer = button.cd:CreateFontString(nil, "OVERLAY")
		button.timer:Point("CENTER", 1, 0)
		button.timer:SetFont(R["media"].font, 11, "OUTLINE")
		button.timer:SetShadowOffset(R.mult, -R.mult)
		button.timer:SetShadowColor(0, 0, 0)

		button.timerbar = CreateFrame("StatusBar", nil, button)
		button.timerbar:SetStatusBarTexture(R["media"].normal)
		button.timerbar:SetStatusBarColor(unpack(RayUF.colors.class[R.myclass]))
		button.timerbar:Point("TOPLEFT", button, "TOPLEFT", 0, 6)
		button.timerbar:Point("BOTTOMRIGHT", button, "TOPRIGHT", 0, 1)
		button.timerbar:CreateShadow("Background")
		button.timerbar:Hide()

		return button
	end

	local frame = CreateFrame("Frame", "RaidBuffReminder", Minimap)
	frame:SetSize((bsize + 8)*8 - 8, bsize)
	frame:Point("TOPRIGHT", UIParent, "TOPRIGHT", -14, -15)

	for i = 1, NUM_LE_RAID_BUFF_TYPES do
		if i == 1 then
			frame["spell"..i] = CreateButton(frame, true)
		else
			frame["spell"..i] = CreateButton(frame["spell"..i-1])
		end
		frame["spell"..i]:SetID(i)
		frame["spell"..i]:SetScript("OnEnter", Button_OnEnter)
		frame["spell"..i]:SetScript("OnLeave", GameTooltip_Hide)
	end

	R:CreateMover(frame, "RaidBuffReminderMover", L["团队buff提醒锚点"], true)
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