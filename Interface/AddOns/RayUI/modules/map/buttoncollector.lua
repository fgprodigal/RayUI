local R, L, P = unpack(select(2, ...)) --Inport: Engine, Locales, ProfileDB
local MM = R:GetModule("MiniMap")
local MBCF
local buttons = {}

function MM:PositionButtonCollector(self, screenQuadrant)
    MBCF.bg:SetTexture(0, 0, 0, 1)
    MBCF:SetAlpha(0)
    MBCF:ClearAllPoints()
    screenQuadrant = screenQuadrant or R:GetScreenQuadrant(self)
    for i =1, #buttons do
        buttons[i]:ClearAllPoints()
        buttons[i]:SetPoint("TOP", MinimapButtonCollectFrame, "TOP", 0,  - (i - 1) * 30)
        buttons[i].ClearAllPoints = R.dummy
        buttons[i].SetPoint = R.dummy
    end
    if screenQuadrant:find("RIGHT") then
        MBCF:SetPoint("TOPRIGHT", Minimap, "TOPLEFT", -5, 2)
    else
        MBCF:SetPoint("TOPLEFT", Minimap, "TOPRIGHT", 5, 2)
    end
end

function MM:ButtonCollector()
	local BlackList = { 
		["MiniMapTracking"] = true,
		["MiniMapVoiceChatFrame"] = true,
		["MiniMapWorldMapButton"] = true,
		["MiniMapLFGFrame"] = true,
		["MinimapZoomIn"] = true,
		["MinimapZoomOut"] = true,
		["MiniMapMailFrame"] = true,
		["BattlefieldMinimap"] = true,
		["MinimapBackdrop"] = true,
		["GameTimeFrame"] = true,
		["TimeManagerClockButton"] = true,
		["FeedbackUIButton"] = true,
		["HelpOpenTicketButton"] = true,
		["MiniMapBattlefieldFrame"] = true,
	}

	MBCF = CreateFrame("Frame", "MinimapButtonCollectFrame", UIParent)
	if select(3, Minimap:GetPoint()):upper():find("TOP") then
		MBCF:SetPoint("BOTTOMLEFT", Minimap, "TOPLEFT", 0, 5)
	else
		MBCF:SetPoint("TOPRIGHT", Minimap, "BOTTOMRIGHT", 0, -5)
	end
    MBCF:SetSize(20, 150)
	MBCF:SetFrameStrata("BACKGROUND")
	MBCF:SetFrameLevel(1)
	MBCF.bg = MBCF:CreateTexture(nil, "BACKGROUND")
	MBCF.bg:SetAllPoints(MBCF)
    MBCF.bg:SetGradientAlpha("VERTICAL", 0, 0, 0, 0, 0, 0, 0, .6)


	local MinimapButtonCollect = CreateFrame("Frame")
	MinimapButtonCollect:RegisterEvent("PLAYER_ENTERING_WORLD")
	MinimapButtonCollect:SetScript("OnEvent", function(self)
		for i, child in ipairs({Minimap:GetChildren()}) do
			if child:GetName() and not BlackList[child:GetName()] then
				if child:GetObjectType() == "Button" and child:GetNumRegions() >= 3 then
					child:SetParent("MinimapButtonCollectFrame")
					for j = 1, child:GetNumRegions() do
						local region = select(j, child:GetRegions())
						if region:GetObjectType() == "Texture" then
							local texture = region:GetTexture()
							if texture == "Interface\\Minimap\\MiniMap-TrackingBorder" or texture == "Interface\\Minimap\\UI-Minimap-Background" or texture == "Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight" then
								region:Kill()
							end
						end
					end
					tinsert(buttons, child)
				end
			end
		end
		if #buttons == 0 then 
			MBCF:Hide() 
		else
			for _, child in ipairs(buttons) do
				child:HookScript("OnEnter", function()
					UIFrameFadeIn(MBCF, .5, MBCF:GetAlpha(), 1)
				end)
				child:HookScript("OnLeave", function()
					UIFrameFadeOut(MBCF, .5, MBCF:GetAlpha(), 0)
				end)
			end
		end
		MM:PositionButtonCollector(Minimap)
	end)

	MBCF:SetScript("OnEnter", function(self)
		UIFrameFadeIn(self, .5, self:GetAlpha(), 1)
	end)

	Minimap:HookScript("OnEnter", function()
		UIFrameFadeIn(MBCF, .5, MBCF:GetAlpha(), 1)
	end)

	MBCF:SetScript("OnLeave", function(self)
		UIFrameFadeOut(self, .5, self:GetAlpha(), 0)
	end)

	Minimap:HookScript("OnLeave", function()
		UIFrameFadeOut(MBCF, .5, MBCF:GetAlpha(), 0)
	end)
end
