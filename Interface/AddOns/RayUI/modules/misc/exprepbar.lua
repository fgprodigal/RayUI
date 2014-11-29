local R, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local M = R:GetModule("Misc")

local RepMenuList = {}
local function CacheRepData()
	wipe(RepMenuList)
	for factionIndex = 1, GetNumFactions() do
		local factionName, description, standingID, barMin, barMax, barValue, atWarWith, canToggleAtWar, isHeader, isCollapsed, hasRep, isWatched, isChild, factionID = GetFactionInfo(factionIndex)
		local friendID, friendRep, friendMaxRep, friendName, friendText, friendTexture, friendTextLevel, friendThreshold, nextFriendThreshold = GetFriendshipReputation(factionID)
		if standingID and not isHeader then	
			local fn = function()
				local active = GetWatchedFactionInfo()
				if factionName ~= active then
					SetWatchedFactionIndex(factionIndex)
				end
			end
			if friendID then
				tinsert(RepMenuList, {text = factionName..R:RGBToHex(unpack(RayUF["colors"].reaction[8])).." ("..friendTextLevel..")", func = fn})
			else
				tinsert(RepMenuList, {text = factionName..R:RGBToHex(unpack(RayUF["colors"].reaction[standingID])).." (".._G["FACTION_STANDING_LABEL"..standingID]..")", func = fn})
			end
		end
	end
end

local function LoadFunc()
	local r, g, b
	if CUSTOM_CLASS_COLORS then 
		r, g, b = CUSTOM_CLASS_COLORS[R.myclass].r, CUSTOM_CLASS_COLORS[R.myclass].g, CUSTOM_CLASS_COLORS[R.myclass].b
	else
		local S = R:GetModule("Skins")
		r, g, b = S["media"].classcolours[R.myclass].r, S["media"].classcolours[R.myclass].g, S["media"].classcolours[R.myclass].b
	end

	local xpBar = CreateFrame("StatusBar", nil, Minimap)
	xpBar:SetPoint("TOPLEFT", Minimap, "BOTTOMLEFT", 10, -4)
	xpBar:SetPoint("TOPRIGHT", Minimap, "BOTTOMRIGHT", -10, -4)
	xpBar:CreateShadow("Background")
	xpBar:SetFrameLevel(3)
	xpBar.shadow:SetFrameLevel(1)
	xpBar:SetHeight(8)
	xpBar:SetStatusBarTexture(R.media.normal)
	xpBar:SetStatusBarColor(.5, 0, .75)

	local restedxpBar = CreateFrame("StatusBar", nil, xpBar)
	restedxpBar:SetAllPoints()
	restedxpBar:SetStatusBarTexture(R.media.normal)
	restedxpBar:SetStatusBarColor(0, .4, .8)
	restedxpBar:SetFrameLevel(2)

	local repBar = CreateFrame("StatusBar", nil, Minimap)
	repBar:SetPoint("TOPLEFT", xpBar, "BOTTOMLEFT", 0, -4)
	repBar:SetPoint("TOPRIGHT", xpBar, "BOTTOMRIGHT", 0, -4)
	repBar:SetHeight(8)
	repBar:SetStatusBarTexture(R.media.normal)
	repBar:CreateShadow("Background")
	repBar.MenuFrame = CreateFrame("Frame", nil, UIParent)
	repBar.MenuFrame:CreateShadow("Background")

	-- Update function

	local function updateStatus()
		local XP, maxXP = UnitXP("player"), UnitXPMax("player")
		local restXP = GetXPExhaustion()

		if UnitLevel("player") == MAX_PLAYER_LEVEL then
			repBar:SetPoint("TOPLEFT", Minimap, "BOTTOMLEFT", 10, -4)
			repBar:SetPoint("TOPRIGHT", Minimap, "BOTTOMRIGHT", -10, -4)
			xpBar:Hide()
			restedxpBar:Hide()
		else
			xpBar:SetMinMaxValues(min(0, XP), maxXP)
			xpBar:SetValue(XP)
			repBar:SetPoint("TOPLEFT", xpBar, "BOTTOMLEFT", 0, -4)
			repBar:SetPoint("TOPRIGHT", xpBar, "BOTTOMRIGHT", 0, -4)

			if restXP then
				restedxpBar:Show()
				restedxpBar:SetMinMaxValues(min(0, XP), maxXP)
				restedxpBar:SetValue(XP+restXP)
			else
				restedxpBar:Hide()
			end
			xpBar:Show()
		end

		if GetWatchedFactionInfo() then
			local name, rank, minRep, maxRep, value, factionID = GetWatchedFactionInfo()
			local friendID, friendRep, friendMaxRep, friendName, friendText, friendTexture, friendTextLevel, friendThreshold, nextFriendThreshold = GetFriendshipReputation(factionID)
			repBar:SetMinMaxValues(minRep, maxRep)
			repBar:SetValue(value)
			if friendID then
				rank = 8
			end
			repBar:SetStatusBarColor(unpack(RayUF["colors"].reaction[rank]))
			repBar:Show()
		else
			repBar:Hide()
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

	xpBar:SetScript("OnEnter", function()
		local min, max = UnitXP("player"), UnitXPMax("player")
		local rest = GetXPExhaustion()

		GameTooltip:SetOwner(xpBar, "ANCHOR_BOTTOM", 0, -5)
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

	repBar:SetScript("OnEnter", function()
		local name, rank, start, cap, value, factionID = GetWatchedFactionInfo()
		local friendID, friendRep, friendMaxRep, friendName, friendText, friendTexture, friendTextLevel, friendThreshold, nextFriendThreshold = GetFriendshipReputation(factionID)
		GameTooltip:SetOwner(repBar, "ANCHOR_BOTTOM", 0, -5)
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
		CacheRepData()
		if not repBar.MenuFrame.buttons then
			repBar.MenuFrame.buttons = {}
			repBar.MenuFrame:SetFrameStrata("DIALOG")
			repBar.MenuFrame:SetClampedToScreen(true)
			repBar.MenuFrame:Hide()
		end
		local maxPerColumn = 25
		local cols = 1
		for i=1, #repBar.MenuFrame.buttons do
			repBar.MenuFrame.buttons[i]:Hide()
		end

		for i=1, #RepMenuList do 
			if not repBar.MenuFrame.buttons[i] then
				repBar.MenuFrame.buttons[i] = CreateFrame("Button", nil, repBar.MenuFrame)
				repBar.MenuFrame.buttons[i].hoverTex = repBar.MenuFrame.buttons[i]:CreateTexture(nil, "OVERLAY")
				repBar.MenuFrame.buttons[i].hoverTex:SetAllPoints()
				repBar.MenuFrame.buttons[i].hoverTex:SetTexture([[Interface\QuestFrame\UI-QuestTitleHighlight]])
				repBar.MenuFrame.buttons[i].hoverTex:SetBlendMode("ADD")
				repBar.MenuFrame.buttons[i].hoverTex:Hide()
				repBar.MenuFrame.buttons[i].text = repBar.MenuFrame.buttons[i]:CreateFontString(nil, "BORDER")
				repBar.MenuFrame.buttons[i].text:SetAllPoints()
				repBar.MenuFrame.buttons[i].text:SetFont(R["media"].font,12)
				repBar.MenuFrame.buttons[i].text:SetJustifyH("LEFT")
				repBar.MenuFrame.buttons[i]:SetScript("OnEnter", function(self)
					self.hoverTex:Show()
				end)
				repBar.MenuFrame.buttons[i]:SetScript("OnLeave", function(self)
					self.hoverTex:Hide()
				end)
			end
			repBar.MenuFrame.buttons[i]:Show()
			repBar.MenuFrame.buttons[i]:SetHeight(16)
			repBar.MenuFrame.buttons[i]:SetWidth(135)
			repBar.MenuFrame.buttons[i].text:SetText(RepMenuList[i].text)
			repBar.MenuFrame.buttons[i].func = RepMenuList[i].func
			repBar.MenuFrame.buttons[i]:SetScript("OnClick", function(self)
				self.func()
				repBar.MenuFrame:Hide()
			end)
			if i == 1 then
				repBar.MenuFrame.buttons[i]:SetPoint("TOPLEFT", repBar.MenuFrame, "TOPLEFT", 10, -10)
			elseif((i -1) % maxPerColumn == 0) then
				repBar.MenuFrame.buttons[i]:SetPoint("TOPLEFT", repBar.MenuFrame.buttons[i - maxPerColumn], "TOPRIGHT", 10, 0)
				cols = cols + 1
			else
				repBar.MenuFrame.buttons[i]:SetPoint("TOPLEFT", repBar.MenuFrame.buttons[i - 1], "BOTTOMLEFT")
			end
		end
		local maxHeight = (min(maxPerColumn, #RepMenuList) * 16) + 20
		local maxWidth = (135 * cols) + (10 * cols)
		repBar.MenuFrame:SetSize(maxWidth, maxHeight)    
		repBar.MenuFrame:ClearAllPoints()
		repBar.MenuFrame:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 10, -10)
		ToggleFrame(repBar.MenuFrame)
	end)
end

M:RegisterMiscModule("Exprepbar", LoadFunc)