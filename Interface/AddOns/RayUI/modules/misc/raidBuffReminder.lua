local R, L, P = unpack(select(2, ...)) --Inport: Engine, Locales, ProfileDB
local M = R:GetModule("Misc")

local function LoadFunc()
	if not M.db.raidbuffreminder then return end

	local SpellBuffs = {
		[1] = {
			94160, --Flask of Flowing Water
			79470, --Flask of the Draconic Mind
			79471, --Flask of the Winds
			79472, --Flask of Titanic Strength
			79638, --Flask of Enhancement-STR
			79639, --Flask of Enhancement-AGI
			79640, --Flask of Enhancement-INT
			92679, --Flask of battle
			79469, --Flask of Steelskin
		},
		[2] = {
			87545, --90 STR
			87546, --90 AGI
			87547, --90 INT
			87548, --90 SPI
			87549, --90 MAST
			87550, --90 HIT
			87551, --90 CRIT
			87552, --90 HASTE
			87554, --90 DODGE
			87555, --90 PARRY
			87635, --90 EXP
			87556, --60 STR
			87557, --60 AGI
			87558, --60 INT
			87559, --60 SPI
			87560, --60 MAST
			87561, --60 HIT
			87562, --60 CRIT
			87563, --60 HASTE
			87564, --60 DODGE
			87634, --60 EXP
			87554, --Seafood Feast
		},
		[3] = {
			1126, -- "Mark of the wild"
			90363, --"Embrace of the Shale Spider"
			20217, --"Greater Blessing of Kings",
		},
		[4] = {
			469, -- Commanding
			6307, -- Blood Pact
			90364, -- Qiraji Fortitude
			72590, -- Drums of fortitude
			21562, -- Fortitude
		},
	}

	local BattleElixir = {
		--Scrolls
		89343, --Agility
		63308, --Armor 
		89347, --Int
		89342, --Spirit
		63306, --Stam
		89346, --Strength

		--Elixirs
		79481, --Hit
		79632, --Haste
		79477, --Crit
		79635, --Mastery
		79474, --Expertise
		79468, --Spirit
	}

	local GuardianElixir = {
		79480, --Armor
		79631, --Resistance+90
	}

	local CasterSpell5Buffs = {
		61316, --"Dalaran Brilliance" (6% SP)
		77747, --"Totemic Wrath" (10% SP)
		1459, --"Arcane Brilliance" (6% SP)
	}

	local MeleeSpell5Buffs = {
		6673, --Battle Shout
		57330, --Horn of Winter
		93435, --Roar of Courage
	}

	local CasterSpell6Buffs = {
		19740, --"Blessing of Might"
	}

	local MeleeSpell6Buffs = {
		19740, --"Blessing of Might" placing it twice because i like the icon better :D code will stop after this one is read, we want this first
		19506, --Trushot
		19740, --"Blessing of Might"
	}

	local CasterLocale1 = L["法力上限Buff"]
	local CasterLocale2 = L["法力恢复Buff"]
	local MeleeLocale1 = L["力量与敏捷Buff"]
	local MeleeLocale2 = L["攻击强度Buff"]

	local function CheckFilterForActiveBuff(filter)
		local spellName, texture
		for _, spell in pairs(filter) do
			spellName, _, texture = GetSpellInfo(spell)
			if UnitAura("player", spellName) then
				return true, texture
			end
		end

		return false, texture
	end

	local function UpdateReminder(event, unit)
		if (M.db.raidbuffreminderparty and GetNumSubgroupMembers() == 0 and GetNumGroupMembers() == 0) then
			if RaidBuffReminder:IsShown() then
				RaidBuffReminder:Hide()
			end
			return
		else
			if not RaidBuffReminder:IsShown() then
				RaidBuffReminder:Show()
			end
		end
		if (event == "UNIT_AURA" and unit ~= "player") then return end
		local frame = RaidBuffReminder

		if R.Role == "Caster" then
			SpellBuffs[5] = CasterSpell5Buffs
			SpellBuffs[6] = CasterSpell6Buffs
			frame.spell5.locale = CasterLocale1
			frame.spell6.locale = CasterLocale2
		else
			SpellBuffs[5] = MeleeSpell5Buffs
			SpellBuffs[6] = MeleeSpell6Buffs
			frame.spell5.locale = MeleeLocale1
			frame.spell6.locale = MeleeLocale2
		end

		local hasFlask, flaskTex = CheckFilterForActiveBuff(SpellBuffs[1])
		if hasFlask then
			frame.spell1.t:SetTexture(flaskTex)
			frame.spell1:SetAlpha(0.2)
		else
			local hasBattle, battleTex = CheckFilterForActiveBuff(BattleElixir)
			local hasGuardian, guardianTex = CheckFilterForActiveBuff(GuardianElixir)

			if (hasBattle and hasGuardian) or not hasGuardian and hasBattle then
				frame.spell1:SetAlpha(1)
				frame.spell1.t:SetTexture(battleTex)
			elseif hasGuardian then
				frame.spell1:SetAlpha(1)
				frame.spell1.t:SetTexture(guardianTex)
			else
				frame.spell1:SetAlpha(1)
				frame.spell1.t:SetTexture(flaskTex)
			end
		end

		for i = 2, 6 do
			local hasBuff, texture = CheckFilterForActiveBuff(SpellBuffs[i])
			frame["spell"..i].t:SetTexture(texture)
			if hasBuff then
				frame["spell"..i]:SetAlpha(0.2)
			else
				frame["spell"..i]:SetAlpha(1)
			end
		end
	end

	local function CreateButton(relativeTo, isFirst, isLast)
		local bsize = ((Minimap:GetWidth() - 6) / 6) - 4
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

		button:SetScript("OnEnter", function(self)
			GameTooltip:SetOwner(RaidBuffReminder, 'ANCHOR_BOTTOM', 0, -10)
			if self.locale and self:GetAlpha() == 1 then
				GameTooltip:AddLine(L["缺少"]..self.locale)
				GameTooltip:Show()
			end
		end)
		button:SetScript("OnLeave", function(self)
			GameTooltip:Hide()
		end)

		return button
	end

	local bsize = ((Minimap:GetWidth() - 6) / 6) - 4
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

	frame.spell1.locale = L["合剂"]
	frame.spell2.locale = L["食物Buff"]
	frame.spell3.locale = L["全属性Buff"]
	frame.spell4.locale = L["血量上限Buff"]

	frame:Show()
	frame:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
	frame:RegisterEvent("UNIT_INVENTORY_CHANGED")
	frame:RegisterEvent("UNIT_AURA")
	frame:RegisterEvent("PLAYER_REGEN_ENABLED")
	frame:RegisterEvent("PLAYER_REGEN_DISABLED")
	frame:RegisterEvent("PLAYER_ENTERING_WORLD")
	frame:RegisterEvent("UPDATE_BONUS_ACTIONBAR")
	frame:RegisterEvent("CHARACTER_POINTS_CHANGED")
	frame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
	if M.db.raidbuffreminderparty then
		frame:RegisterEvent("PARTY_MEMBERS_CHANGED")
	end
	frame:SetScript("OnEvent", UpdateReminder)
	UpdateReminder()
end

M:RegisterMiscModule("RaidBuffReminder", LoadFunc)