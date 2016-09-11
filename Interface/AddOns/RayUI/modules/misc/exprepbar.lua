local R, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local M = R:GetModule("Misc")

local function AddPerks()
	if not IsAddOnLoaded("Blizzard_ArtifactUI") then LoadAddOn("Blizzard_ArtifactUI") end
	local forceHide, header
	
	if not ArtifactFrame:IsShown() then
		forceHide = true
		SocketInventoryItem(16)
	end
	
	for i, powerID in ipairs(C_ArtifactUI.GetPowers()) do
		--local spellID, cost, currentRank, maxRank, bonusRanks, x, y, prereqsMet, isStart, isGoldMedal, isFinal = C_ArtifactUI.GetPowerInfo(powerID)
		local spellID, _, rank, maxRank, bonus = C_ArtifactUI.GetPowerInfo(powerID)
		local isStart = select(9, C_ArtifactUI.GetPowerInfo(powerID))
		local r,g,b = 1,1,1
		
		if bonus > 0 then
			r,g,b = 0.4,1,0
		end
		
		if rank > 0 and not isStart then
			if not header then
				header = true
				GameTooltip:AddDivider()
			end
			
			GameTooltip:AddDoubleLine(GetSpellInfo(spellID), rank.."/"..maxRank, 1,1,1, r,g,b)
		end
	end	
	
	if ArtifactFrame:IsShown() and forceHide then
		HideUIPanel(ArtifactFrame)
	end
end

local function Bar_OnShow(self)
	self:SetPoint("TOPLEFT", self.anchorFrame, "BOTTOMLEFT", 0, -4)
	self:SetPoint("TOPRIGHT", self.anchorFrame, "BOTTOMRIGHT", 0, -4)
end

local function Bar_OnHide(self)
	self:SetPoint("TOPLEFT", self.anchorFrame, "BOTTOMLEFT", 0, self.height)
	self:SetPoint("TOPRIGHT", self.anchorFrame, "BOTTOMRIGHT", 0, self.height)
end

local function CreateBar(name, anchorFrame, height)
	local bar = CreateFrame("StatusBar", name, UIParent)
	bar:CreateShadow("Background")
	bar:SetFrameLevel(3)
	bar.shadow:SetFrameLevel(1)
	bar:SetHeight(height)
	bar.height = height
	bar:SetStatusBarTexture(R.media.normal)
	bar.anchorFrame = anchorFrame
	R:SmoothBar(bar)
	bar:SetScript("OnShow", Bar_OnShow)
	bar:SetScript("OnHide", Bar_OnHide)
	Bar_OnShow(bar)
	return bar
end

local function LoadFunc()
	local xpBar = CreateBar("RayUIExpBar", Minimap, 8)
	xpBar:SetStatusBarColor(.5, 0, .75)

	local restedxpBar = CreateFrame("StatusBar", nil, xpBar)
	restedxpBar:SetAllPoints()
	restedxpBar:SetStatusBarTexture(R.media.normal)
	restedxpBar:SetStatusBarColor(0, .4, .8)
	restedxpBar:SetFrameLevel(2)

	local repBar = CreateBar("RayUIRepBar", xpBar, 8)

	local artiBar = CreateBar("RayUIArtiBar", repBar, 8)
	artiBar:SetStatusBarColor(.901, .8, .601)

	-- Update function
	local function updateExp(self)
		local XP, maxXP = UnitXP("player"), UnitXPMax("player")
		local restXP = GetXPExhaustion()
		local maxLevel = MAX_PLAYER_LEVEL_TABLE[GetExpansionLevel()]

		if UnitLevel("player") == maxLevel then
			self:Hide()
			restedxpBar:Hide()
		else
			self:SetMinMaxValues(min(0, XP), maxXP)
			self:SetValue(XP)

			if restXP then
				restedxpBar:Show()
				restedxpBar:SetMinMaxValues(min(0, XP), maxXP)
				restedxpBar:SetValue(XP+restXP)
			else
				restedxpBar:Hide()
			end
			self:Show()
		end
	end

	local function updateRep(self)
		if GetWatchedFactionInfo() then
			local name, rank, minRep, maxRep, value, factionID = GetWatchedFactionInfo()
			local friendID, friendRep, friendMaxRep, friendName, friendText, friendTexture, friendTextLevel, friendThreshold, nextFriendThreshold = GetFriendshipReputation(factionID)
			self:SetMinMaxValues(minRep, maxRep)
			self:SetValue(value)
			if friendID then
				rank = 8
			end
			self:SetStatusBarColor(unpack(RayUF["colors"].reaction[rank]))
			self:Show()
		else
			self:Hide()
		end
	end

	local function updateArti(self)
		local itemID, altItemID, name, icon, totalXP, pointsSpent, quality, artifactAppearanceID, appearanceModID, itemAppearanceID, altItemAppearanceID, altOnTop = C_ArtifactUI.GetEquippedArtifactInfo()
		local numPointsAvailableToSpend, xp, xpForNextPoint = MainMenuBar_GetNumArtifactTraitsPurchasableFromXP(pointsSpent, totalXP)
		self:SetMinMaxValues(0, xpForNextPoint)
		self:SetValue(xp)
	end

	xpBar:SetScript("OnEvent", updateExp)
	xpBar:RegisterEvent("PLAYER_LEVEL_UP")
	xpBar:RegisterEvent("PLAYER_XP_UPDATE")
	xpBar:RegisterEvent("UPDATE_EXHAUSTION")
	xpBar:RegisterEvent("UPDATE_EXPANSION_LEVEL")
	updateExp(xpBar)

	repBar:SetScript("OnEvent", updateRep)
	repBar:RegisterEvent("CHAT_MSG_COMBAT_FACTION_CHANGE")
	repBar:RegisterEvent("UPDATE_FACTION")
	repBar:RegisterEvent("PLAYER_ENTERING_WORLD")
	updateRep(repBar)

	artiBar:SetScript("OnEvent", updateArti)
	artiBar:RegisterEvent("ARTIFACT_XP_UPDATE")
	artiBar:RegisterEvent("UNIT_INVENTORY_CHANGED")
	updateArti(artiBar)

	-- Mouse events
	xpBar:SetScript("OnEnter", function(self)
		local min, max = UnitXP("player"), UnitXPMax("player")
		local rest = GetXPExhaustion()

		GameTooltip:SetOwner(self, "ANCHOR_BOTTOM", 0, -5)
		GameTooltip:AddDoubleLine(XP, format("%s/%s (%d%%)", min, max, min / max * 100), NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)
		GameTooltip:AddDoubleLine(L["剩余"], format("%d (%d%%)", max - min, (max - min) / max * 100), NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)
		if rest then
			GameTooltip:AddDoubleLine(L["双倍"], format("%d (%d%%)", rest, rest / max * 100), 0, .56, 1, HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)
		end
		GameTooltip:Show()
	end)

	xpBar:SetScript("OnLeave", function()
		GameTooltip:Hide()
	end)

	repBar:SetScript("OnEnter", function(self)
		local name, rank, start, cap, value, factionID = GetWatchedFactionInfo()
		local friendID, friendRep, friendMaxRep, friendName, friendText, friendTexture, friendTextLevel, friendThreshold, nextFriendThreshold = GetFriendshipReputation(factionID)
		GameTooltip:SetOwner(self, "ANCHOR_BOTTOM", 0, -5)
		GameTooltip:ClearLines()		
		GameTooltip:AddDoubleLine(REPUTATION, name, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)
		if friendID then
			rank = 8
			GameTooltip:AddDoubleLine(STANDING, friendTextLevel, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, RayUF["colors"].reaction[rank][1], RayUF["colors"].reaction[rank][2], RayUF["colors"].reaction[rank][3])
		else
			GameTooltip:AddDoubleLine(STANDING, _G["FACTION_STANDING_LABEL"..rank], NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, RayUF["colors"].reaction[rank][1], RayUF["colors"].reaction[rank][2], RayUF["colors"].reaction[rank][3])
		end
		GameTooltip:AddDoubleLine(REPUTATION, string.format("%s/%s (%d%%)", value-start, cap-start, (value-start)/(cap-start)*100), NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, 1, 1, 1)
		GameTooltip:AddDoubleLine(L["剩余"], string.format("%s", cap-value), NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, 1, 1, 1)
		GameTooltip:Show()
	end)

	repBar:SetScript("OnLeave", function()
		GameTooltip:Hide()
	end)

	repBar:SetScript("OnMouseUp", function(self)
		GameTooltip:Hide()
		ToggleCharacter("ReputationFrame")
	end)

	artiBar:SetScript("OnEnter", function(self)
		if HasArtifactEquipped() then
			local title,r,g,b = select(2, C_ArtifactUI.GetEquippedArtifactArtInfo())
			local name, icon, totalXP, pointsSpent = select(3, C_ArtifactUI.GetEquippedArtifactInfo())
			local points, xp, xpMax = MainMenuBar_GetNumArtifactTraitsPurchasableFromXP(pointsSpent, totalXP)

			GameTooltip:SetOwner(self, "ANCHOR_BOTTOM", 0, -5)
			GameTooltip:AddLine(title,r,g,b,false)
			GameTooltip:SetPrevLineJustify("CENTER")
			GameTooltip:AddDivider()
			GameTooltip:AddLine(ARTIFACT_POWER_TOOLTIP_TITLE:format(BreakUpLargeNumbers(ArtifactWatchBar.totalXP), BreakUpLargeNumbers(ArtifactWatchBar.xp), BreakUpLargeNumbers(ArtifactWatchBar.xpForNextPoint)), 1, 1, 1)
			if ArtifactWatchBar.numPointsAvailableToSpend > 0 then
				GameTooltip:AddLine(" ")
				GameTooltip:AddLine(ARTIFACT_POWER_TOOLTIP_BODY:format(ArtifactWatchBar.numPointsAvailableToSpend), 0, 1, 0, true)
			end

			AddPerks()

			GameTooltip:Show()
		end
	end)

	artiBar:SetScript("OnLeave", function()
		GameTooltip:Hide()
	end)

	artiBar:SetScript("OnMouseUp", function(self)
		if not ArtifactFrame or not ArtifactFrame:IsShown() then
			ShowUIPanel(SocketInventoryItem(16))
		elseif ArtifactFrame and ArtifactFrame:IsShown() then
			HideUIPanel(ArtifactFrame)
		end
	end)
end

M:RegisterMiscModule("Exprepbar", LoadFunc)