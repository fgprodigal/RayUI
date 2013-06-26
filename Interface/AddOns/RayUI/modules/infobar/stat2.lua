local R, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local IF = R:GetModule("InfoBar")

local function LoadStatus()
	local infobar = _G["RayUI_ExpBar"]
	local Status = CreateFrame("Frame", nil, infobar)
	Status:EnableMouse(true)
	Status:SetFrameStrata("MEDIUM")
	Status:SetFrameLevel(3)

	local Text  = infobar:CreateFontString(nil, "OVERLAY")
	Text:SetFont(R["media"].font, R["media"].fontsize, R["media"].fontflag)
	Text:SetShadowOffset(1.25, -1.25)
	Text:SetShadowColor(0, 0, 0, 0.4)
	Text:SetPoint("BOTTOMRIGHT", infobar, "TOPRIGHT", -10, -3)
	Status:SetAllPoints(Text)

	local _G = getfenv(0)
	local format = string.format
	local chanceString = "%.2f%%"
	local armorString = ARMOR..": "
	local modifierString = string.join("", "%d (+", chanceString, ")")
	local baseArmor, effectiveArmor, armor, posBuff, negBuff
	local displayNumberString = string.join("", "%s%d|r")
	local displayFloatString = string.join("", "%s%.2f%%|r")

	local function CalculateMitigation(level, effective)
		local mitigation

		if not effective then
			_, effective, _, _, _ = UnitArmor("player")
		end

		if level < 60 then
			mitigation = (effective/(effective + 400 + (85 * level)));
		else
			mitigation = (effective/(effective + (467.5 * level - 22167.5)));
		end
		if mitigation > .75 then
			mitigation = .75
		end
		return mitigation
	end

	local function ShowTooltip(self)
		GameTooltip:SetOwner(self, "ANCHOR_TOP")
		GameTooltip:ClearLines()

		local inInstance, instanceType = IsInInstance()
		if inInstance and instanceType == "pvp" then
			GameTooltip:AddLine(STATS_LABEL)
			local name, killingBlows, honorableKills, deaths = GetBattlefieldScore(self.index)
			GameTooltip:AddDoubleLine(SCORE_KILLING_BLOWS, killingBlows,1,1,1)
			GameTooltip:AddDoubleLine(SCORE_HONORABLE_KILLS:gsub("\n", ""), honorableKills,1,1,1)
			GameTooltip:AddDoubleLine(DEATHS, deaths,1,1,1)
		else
			if R.Role == "Tank" then
				GameTooltip:AddLine(L["等级缓和"]..": ")
				local lv = UnitLevel("player") +3
				for i = 1, 4 do
					GameTooltip:AddDoubleLine(lv,format(chanceString, CalculateMitigation(lv, effectiveArmor) * 100),1,1,1)
					lv = lv - 1
				end
				lv = UnitLevel("target")
				if lv and lv > 0 and (lv > UnitLevel("player") + 3 or lv < UnitLevel("player")) then
					GameTooltip:AddDoubleLine(lv, format(chanceString, CalculateMitigation(lv, effectiveArmor) * 100),1,1,1)
				end
			end
		end
		GameTooltip:Show()
	end

	local function UpdateTank(self)
		baseArmor, effectiveArmor, armor, posBuff, negBuff = UnitArmor("player");

		Text:SetFormattedText(displayNumberString, armorString, effectiveArmor)
		--Setup Tooltip
		self:SetAllPoints(Text)
	end

	local function UpdateCaster(self)
		local spellcrit = GetSpellCritChance(1)

		Text:SetFormattedText(displayFloatString, SPELL_CRIT_CHANCE..": ", spellcrit)
		--Setup Tooltip
		self:SetAllPoints(Text)
	end

	local function UpdateMelee(self)
		local meleecrit = GetCritChance()
		local rangedcrit = GetRangedCritChance()
		local critChance

		if R.myclass == "HUNTER" then    
			critChance = rangedcrit
		else
			critChance = meleecrit
		end

		Text:SetFormattedText(displayFloatString, MELEE_CRIT_CHANCE..": ", critChance)
		--Setup Tooltip
		self:SetAllPoints(Text)
	end

	local function UpdateBattlefieldScore(self)
		for index = 1, GetNumBattlefieldScores() do
			local name, _, _, _, honorGained = GetBattlefieldScore(index)
			if name and name == R.myname then
				Text:SetFormattedText(displayNumberString, SCORE_HONOR_GAINED:gsub("\n", "")..": ", honorGained)
				self.index = index
			end
		end
	end

	local function Update(self, t)
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

-- IF:RegisterInfoText("Status2", LoadStatus)
