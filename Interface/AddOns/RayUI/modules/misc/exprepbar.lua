local R, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local M = R:GetModule("Misc")

local function LoadFunc()
	local backdrop = CreateFrame("Frame", "RayUI_ExpBar", Minimap)
	backdrop:SetPoint("TOPLEFT", Minimap, "BOTTOMLEFT", 10, -5)
	backdrop:SetPoint("BOTTOMRIGHT", Minimap, "BOTTOMRIGHT", -10, -11)
	backdrop:CreateShadow("Background")

	local xpBar = CreateFrame("StatusBar", nil, backdrop)
	xpBar:SetAllPoints()
	xpBar:SetStatusBarTexture(R.media.normal)
	xpBar:SetStatusBarColor(.5, 0, .75)

	local restedxpBar = CreateFrame("StatusBar", nil, backdrop)
	restedxpBar:SetAllPoints()
	restedxpBar:SetStatusBarTexture(R.media.normal)
	restedxpBar:SetStatusBarColor(0, .4, .8)

	local repBar = CreateFrame("StatusBar", nil, backdrop)
	repBar:SetAllPoints()
	repBar:SetStatusBarTexture(R.media.normal)

	local mouseFrame = CreateFrame("Frame", "FreeUIExpBar", backdrop)
	mouseFrame:SetAllPoints(backdrop)
	mouseFrame:EnableMouse(true)

	backdrop:SetFrameLevel(0)
	restedxpBar:SetFrameLevel(1)
	repBar:SetFrameLevel(2)
	xpBar:SetFrameLevel(2)
	mouseFrame:SetFrameLevel(3)

	-- Update function

	local function updateStatus()
		local XP, maxXP = UnitXP("player"), UnitXPMax("player")
		local restXP = GetXPExhaustion()

		if UnitLevel("player") == MAX_PLAYER_LEVEL then
			xpBar:Hide()
			restedxpBar:Hide()
			if not GetWatchedFactionInfo() then
				backdrop:Hide()
			else
				backdrop:Show()
			end
		else
			xpBar:SetMinMaxValues(min(0, XP), maxXP)
			xpBar:SetValue(XP)

			if restXP then
				restedxpBar:Show()
				restedxpBar:SetMinMaxValues(min(0, XP), maxXP)
				restedxpBar:SetValue(XP+restXP)
			else
				restedxpBar:Hide()
			end

			repBar:Hide()
		end

		if GetWatchedFactionInfo() then
			local name, rank, minRep, maxRep, value = GetWatchedFactionInfo()
			repBar:SetMinMaxValues(minRep, maxRep)
			repBar:SetValue(value)
			repBar:SetStatusBarColor(unpack(RayUF["colors"].reaction[rank]))
		end
	end

	local eventFrame = CreateFrame("Frame", nil, UIParent)
	eventFrame:SetScript("OnEvent", updateStatus)
	eventFrame:RegisterEvent("PLAYER_LEVEL_UP")
	eventFrame:RegisterEvent("PLAYER_XP_UPDATE")
	eventFrame:RegisterEvent("UPDATE_EXHAUSTION")
	eventFrame:RegisterEvent("CHAT_MSG_COMBAT_FACTION_CHANGE")
	eventFrame:RegisterEvent("UPDATE_FACTION")
	eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")

	-- Mouse events

	mouseFrame:SetScript("OnEnter", function()
		local min, max = UnitXP("player"), UnitXPMax("player")
		local rest = GetXPExhaustion()

		GameTooltip:SetOwner(mouseFrame, "ANCHOR_BOTTOM", 0, -5)
		GameTooltip:ClearLines()
		if UnitLevel("player") ~= MAX_PLAYER_LEVEL then
			GameTooltip:AddDoubleLine(XP, format("%s/%s (%d%%)", min, max, min / max * 100), NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)
			GameTooltip:AddDoubleLine(L["剩余"], format("%d (%d%%)", max - min, (max - min) / max * 100), NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)
			if rest then
				GameTooltip:AddDoubleLine(L["双倍"], format("%d (%d%%)", rest, rest / max * 100), 0, .56, 1, HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)
			end
		end
		if GetWatchedFactionInfo() then
			local name, rank, start, cap, value = GetWatchedFactionInfo()
			if UnitLevel("player") ~= MAX_PLAYER_LEVEL then GameTooltip:AddLine(" ") end			
			GameTooltip:AddDoubleLine(REPUTATION, name, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)
			GameTooltip:AddDoubleLine(STANDING, _G["FACTION_STANDING_LABEL"..rank], NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, RayUF["colors"].reaction[rank][1], RayUF["colors"].reaction[rank][2], RayUF["colors"].reaction[rank][3])
			GameTooltip:AddDoubleLine(REPUTATION, string.format("%s/%s (%d%%)", value-start, cap-start, (value-start)/(cap-start)*100), r, g, b, 1, 1, 1)
			GameTooltip:AddDoubleLine(L["剩余"], string.format("%s", cap-value), r, g, b, 1, 1, 1)
		end
		GameTooltip:Show()
	end)

	mouseFrame:SetScript("OnLeave", function()
		GameTooltip:Hide()
	end)
end

M:RegisterMiscModule("Exprepbar", LoadFunc)