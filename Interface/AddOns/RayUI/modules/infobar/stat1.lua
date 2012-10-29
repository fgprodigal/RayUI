local R, L, P = unpack(select(2, ...)) --Inport: Engine, Locales, ProfileDB
local IF = R:GetModule("InfoBar")

local function LoadStat()
	local infobar = _G["RayUIBottomInfoBar"]
	local Status = CreateFrame("Frame", nil, infobar)
	Status:EnableMouse(true)
	Status:SetFrameStrata("MEDIUM")
	Status:SetFrameLevel(3)

	local Text  = infobar:CreateFontString(nil, "OVERLAY")
	Text:SetFont(R["media"].font, R["media"].fontsize, R["media"].fontflag)
	Text:SetShadowOffset(1.25, -1.25)
	Text:SetShadowColor(0, 0, 0, 0.4)
	Text:SetPoint("BOTTOM", infobar, "TOP", 0, -3)
	Status:SetAllPoints(Text)

	local format = string.format
	local targetlv, playerlv
	local basemisschance, leveldifference, dodge, parry, block
	local chanceString = "%.2f%%"
	local modifierString = string.join("", "%d (+", chanceString, ")")
	local manaRegenString = "%d / %d"
	local displayNumberString = string.join("", "%s%d|r")
	local displayFloatString = string.join("", "%s%.2f%%|r")
	local spellpwr, avoidance, pwr
	local haste, hasteBonus

	local function ShowTooltip(self)
		GameTooltip:SetOwner(self, "ANCHOR_TOP")
		GameTooltip:ClearLines()
		GameTooltip:AddLine(STATS_LABEL)

		local inInstance, instanceType = IsInInstance()
		if inInstance and instanceType == "pvp" then
			local name, _, _, _, _, _, _, _, _, damageDone, healingDone = GetBattlefieldScore(self.index)
			for i = 1, GetNumBattlefieldStats() do
				GameTooltip:AddDoubleLine(GetBattlefieldStatInfo(i):gsub("\n", ""), GetBattlefieldStatData(self.index, i),1,1,1)
			end
			GameTooltip:AddLine(" ")
			if R.isHealer then
				GameTooltip:AddDoubleLine(SCORE_DAMAGE_DONE, damageDone,1,1,1)
			else
				GameTooltip:AddDoubleLine(SCORE_HEALING_DONE, healingDone,1,1,1)
			end
		else
			if R.Role == "Tank" then
				if targetlv > 1 then
					GameTooltip:AddDoubleLine(L["免伤分析"], string.join("", " (", LEVEL, " ", targetlv, ")"))
				elseif targetlv == -1 then
					GameTooltip:AddDoubleLine(L["免伤分析"], string.join("", " (", BOSS, ")"))
				else
					GameTooltip:AddDoubleLine(L["免伤分析"], string.join("", " (", LEVEL, " ", playerlv, ")"))
				end
				GameTooltip:AddLine' '
				GameTooltip:AddDoubleLine(DODGE_CHANCE, format(chanceString, dodge),1,1,1)
				GameTooltip:AddDoubleLine(PARRY_CHANCE, format(chanceString, parry),1,1,1)
				GameTooltip:AddDoubleLine(BLOCK_CHANCE, format(chanceString, block),1,1,1)
				GameTooltip:AddDoubleLine(MISS_CHANCE, format(chanceString, basemisschance),1,1,1)
			elseif R.Role == "Caster" then
				GameTooltip:AddDoubleLine(STAT_HIT_CHANCE, format(modifierString, GetCombatRating(CR_HIT_SPELL), GetCombatRatingBonus(CR_HIT_SPELL)), 1, 1, 1)
				GameTooltip:AddDoubleLine(STAT_HASTE, format(modifierString, GetCombatRating(CR_HASTE_SPELL), GetCombatRatingBonus(CR_HASTE_SPELL)), 1, 1, 1)
				local base, combat = GetManaRegen()
				GameTooltip:AddDoubleLine(MANA_REGEN, format(manaRegenString, base * 5, combat * 5), 1, 1, 1)
			elseif R.Role == "Melee" then
				local hit = R.myclass == "HUNTER" and GetCombatRating(CR_HIT_RANGED) or GetCombatRating(CR_HIT_MELEE)
				local hitBonus = R.myclass == "HUNTER" and GetCombatRatingBonus(CR_HIT_RANGED) or GetCombatRatingBonus(CR_HIT_MELEE)

				GameTooltip:AddDoubleLine(STAT_HIT_CHANCE, format(modifierString, hit, hitBonus), 1, 1, 1)

				--Hunters don't use expertise
				if R.myclass ~= "HUNTER" then
					local expertisePercent, offhandExpertisePercent = GetExpertise()
					expertisePercent = format("%.2f", expertisePercent)
					offhandExpertisePercent = format("%.2f", offhandExpertisePercent)

					local expertisePercentDisplay
					if IsDualWielding() then
						expertisePercentDisplay = expertisePercent.."% / "..offhandExpertisePercent.."%"
					else
						expertisePercentDisplay = expertisePercent.."%"
					end
					GameTooltip:AddDoubleLine(COMBAT_RATING_NAME24, format('%d (+%s)', GetCombatRating(CR_EXPERTISE), expertisePercentDisplay), 1, 1, 1)
				end

				local haste = R.myclass == "HUNTER" and GetCombatRating(CR_HASTE_RANGED) or GetCombatRating(CR_HASTE_MELEE)
				local hasteBonus = R.myclass == "HUNTER" and GetCombatRatingBonus(CR_HASTE_RANGED) or GetCombatRatingBonus(CR_HASTE_MELEE)

				GameTooltip:AddDoubleLine(STAT_HASTE, format(modifierString, haste, hasteBonus), 1, 1, 1)
			end

			local masteryspell
			if GetCombatRating(CR_MASTERY) ~= 0 and GetSpecialization() then
				if R.myclass == "DRUID" then
					if R.Role == "Melee" then
						masteryspell = select(2, GetSpecializationMasterySpells(GetSpecialization()))
					elseif R.Role == "Tank" then
						masteryspell = select(1, GetSpecializationMasterySpells(GetSpecialization()))
					else
						masteryspell = GetSpecializationMasterySpells(GetSpecialization())
					end
				else
					masteryspell = GetSpecializationMasterySpells(GetSpecialization())
				end



				local masteryName, _, _, _, _, _, _, _, _ = GetSpellInfo(masteryspell)
                if masteryName then
                    GameTooltip:AddLine' '
                    GameTooltip:AddDoubleLine(masteryName, format(modifierString, GetCombatRating(CR_MASTERY), GetCombatRatingBonus(CR_MASTERY) * select(2, GetMasteryEffect())), 1, 1, 1)
                end
			end
		end
		GameTooltip:Show()
	end

	local function UpdateTank(self)
		targetlv, playerlv = UnitLevel("target"), UnitLevel("player")

		-- the 5 is for base miss chance
		if targetlv == -1 then
			basemisschance = (5 - (3*.2))
			leveldifference = 3
		elseif targetlv > playerlv then
			basemisschance = (5 - ((targetlv - playerlv)*.2))
			leveldifference = (targetlv - playerlv)
		elseif targetlv < playerlv and targetlv > 0 then
			basemisschance = (5 + ((playerlv - targetlv)*.2))
			leveldifference = (targetlv - playerlv)
		else
			basemisschance = 5
			leveldifference = 0
		end

		if select(2, UnitRace("player")) == "NightElf" then basemisschance = basemisschance + 2 end

		if leveldifference >= 0 then
			dodge = (GetDodgeChance()-leveldifference*.2)
			parry = (GetParryChance()-leveldifference*.2)
			block = (GetBlockChance()-leveldifference*.2)
		else
			dodge = (GetDodgeChance()+abs(leveldifference*.2))
			parry = (GetParryChance()+abs(leveldifference*.2))
			block = (GetBlockChance()+abs(leveldifference*.2))
		end

		if dodge <= 0 then dodge = 0 end
		if parry <= 0 then parry = 0 end
		if block <= 0 then block = 0 end

		if R.myclass == "DRUID" then
			parry = 0
			block = 0
		elseif R.myclass == "DEATHKNIGHT" then
			block = 0
		end
		avoidance = (dodge+parry+block+basemisschance)

		Text:SetFormattedText(displayFloatString, L["免伤"]..": ", avoidance)
		--Setup Tooltip
		self:SetAllPoints(Text)
	end

	local function UpdateCaster(self)
		if GetSpellBonusHealing() > GetSpellBonusDamage(7) then
			spellpwr = GetSpellBonusHealing()
		else
			spellpwr = GetSpellBonusDamage(7)
		end

		Text:SetFormattedText(displayNumberString, STAT_SPELLPOWER..": ", spellpwr)
		--Setup Tooltip
		self:SetAllPoints(Text)
	end

	local function UpdateMelee(self)
		local base, posBuff, negBuff = UnitAttackPower("player");
		local effective = base + posBuff + negBuff;
		local Rbase, RposBuff, RnegBuff = UnitRangedAttackPower("player");
		local Reffective = Rbase + RposBuff + RnegBuff;

		if R.myclass == "HUNTER" then
			pwr = Reffective
		else
			pwr = effective
		end

		Text:SetFormattedText(displayNumberString, STAT_ATTACK_POWER..": ", pwr)
		--Setup Tooltip
		self:SetAllPoints(Text)
	end

	local function UpdateBattlefieldScore(self)
		for index = 1, GetNumBattlefieldScores() do
			local name, _, _, _, _, _, _, _, _, damageDone, healingDone = GetBattlefieldScore(index)
			if name and name == R.myname then
				if R.isHealer then
					Text:SetFormattedText(displayNumberString, SCORE_HEALING_DONE..": ", healingDone)
				else
					Text:SetFormattedText(displayNumberString, SCORE_DAMAGE_DONE..": ", damageDone)
				end
				self.index = index
			end
		end
	end

	local function Update(self)
		local inInstance, instanceType = IsInInstance()
		if inInstance and instanceType == "pvp" then
			RequestBattlefieldScoreData()
			UpdateBattlefieldScore(self)
		else
			if R.Role == "Tank" then 
				UpdateTank(self)
			elseif R.Role == "Caster" then
				UpdateCaster(self)
			elseif R.Role == "Melee" then
				UpdateMelee(self)
			end
		end
	end

	Status:SetScript("OnEnter", function() ShowTooltip(Status) end)
	Status:SetScript("OnLeave", GameTooltip_Hide)
	Status:SetScript("OnMouseDown", function()
		local inInstance, instanceType = IsInInstance()
		if inInstance and instanceType == "pvp" then
			ToggleFrame(WorldStateScoreFrame)
		end
	end)
	Status:RegisterEvent("UNIT_STATS")
	Status:RegisterEvent("UNIT_AURA")
	Status:RegisterEvent("FORGE_MASTER_ITEM_CHANGED")
	Status:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
	Status:RegisterEvent("PLAYER_TALENT_UPDATE")
	Status:RegisterEvent("UNIT_ATTACK_POWER")
	Status:RegisterEvent("UNIT_RANGED_ATTACK_POWER")
	Status:RegisterEvent("UPDATE_BATTLEFIELD_SCORE")
	Status:RegisterEvent("PLAYER_ENTERING_WORLD")
	Status:SetScript("OnEvent", Update)
	Update(Status)
end

IF:RegisterInfoText("Stat1", LoadStat)
