local R, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local MM = R:GetModule("MiniMap")
local MBCF
local buttons = {}

function MM:PositionButtonCollector(self, screenQuadrant)
	local line = math.ceil(Minimap:GetWidth() / 20)
	-- MBCF.bg:SetTexture(0, 0, 0, 1)
	-- MBCF:SetAlpha(0)
	MBCF:ClearAllPoints()
	screenQuadrant = screenQuadrant or R:GetScreenQuadrant(self)
	for i =1, #buttons do
		buttons[i]:ClearAllPoints()
		if i == 1 then
			buttons[i]:SetPoint("TOP", MBCF, "TOP", 0, 0)
		elseif i%line == 1 then
			if strfind(screenQuadrant, "RIGHT") then
				buttons[i]:SetPoint("TOPRIGHT", buttons[i-line], "TOPLEFT", -5, 0)
			else
				buttons[i]:SetPoint("TOPLEFT", buttons[i-line], "TOPRIGHT", 5, 0)
			end
		else
			buttons[i]:SetPoint("TOP", buttons[i-1], "BOTTOM", 0, -5)
		end
		buttons[i].ClearAllPoints = R.dummy
		buttons[i].SetPoint = R.dummy
	end
	if strfind(screenQuadrant, "RIGHT") then
		MBCF:SetPoint("TOPRIGHT", Minimap, "TOPLEFT", -5, 0)
	else
		MBCF:SetPoint("TOPLEFT", Minimap, "TOPRIGHT", 5, 0)
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
	-- MBCF.bg = MBCF:CreateTexture(nil, "BACKGROUND")
	-- MBCF.bg:SetAllPoints(MBCF)
	-- MBCF.bg:SetGradientAlpha("VERTICAL", 0, 0, 0, 0, 0, 0, 0, .6)

	function SetMinimapButton(btn)
		if btn == nil or btn:GetName() == nil or btn:GetObjectType() ~= "Button" or btn:GetNumRegions() < 3 then return end
		local name = btn:GetName()
		if BlackList[name] then return end
		btn:SetParent("MinimapButtonCollectFrame")
		btn:SetPushedTexture(nil)
		btn:SetHighlightTexture(nil)
		btn:SetDisabledTexture(nil)
		if not btn.isStyled then
			btn.preset = {}
			btn.preset.Width, btn.preset.Height = btn:GetSize()
			btn.preset.Point, btn.preset.relativeTo, btn.preset.relativePoint, btn.preset.xOfs, btn.preset.yOfs = btn:GetPoint()
			btn.preset.Parent = btn:GetParent()
			btn.preset.FrameStrata = btn:GetFrameStrata()
			btn.preset.FrameLevel = btn:GetFrameLevel()
			btn.preset.Scale = btn:GetScale()
			if btn:HasScript("OnDragStart") then 
				btn.preset.DragStart = btn:GetScript("OnDragStart")
			end 
			if btn:HasScript("OnDragEnd") then 
				btn.preset.DragEnd = btn:GetScript("OnDragEnd")
			end
			for i = 1, btn:GetNumRegions() do 
				local frame = select(i, btn:GetRegions())
				if frame:GetObjectType() == "Texture" then 
					local iconFile = frame:GetTexture()
					if(iconFile ~= nil and (iconFile:find("Border") or iconFile:find("Background") or iconFile:find("AlphaMask"))) then 
						frame:SetTexture(0,0,0,0)
					else
						frame:ClearAllPoints()
						frame:SetAllPoints()
						frame:SetTexCoord(0.1, 0.9, 0.1, 0.9 )
						frame:SetDrawLayer("ARTWORK")
					end 
				end 
			end

			btn:Size(20,20)
			btn:CreateShadow("Background")

			if(name == "DBMMinimapButton") then
				btn.Hide = R.dummy
				btn:Show()
				btn:SetNormalTexture("Interface\\Icons\\INV_Helmet_87")
			end 

			if(name == "SmartBuff_MiniMapButton") then 
				btn:SetNormalTexture(select(3, GetSpellInfo(12051)))
			end

			btn.isStyled = true

			tinsert(buttons, btn)
		end
	end
	
	local MinimapButtonCollect = CreateFrame("Frame")
	MinimapButtonCollect:RegisterEvent("PLAYER_ENTERING_WORLD")
	MinimapButtonCollect:SetScript("OnEvent", function(self)
		for i, child in ipairs({Minimap:GetChildren()}) do
			SetMinimapButton(child)
		end

		-- SetMinimapButton(BagSync_MinimapButton)

		if #buttons == 0 then 
			MBCF:Hide() 
		else
			-- for _, child in ipairs(buttons) do
				-- child:HookScript("OnEnter", function()
					-- UIFrameFadeIn(MBCF, .5, MBCF:GetAlpha(), 1)
				-- end)
				-- child:HookScript("OnLeave", function()
					-- UIFrameFadeOut(MBCF, .5, MBCF:GetAlpha(), 0)
				-- end)
			-- end
		end
		MM:PositionButtonCollector(Minimap)
	end)

	-- MBCF:SetScript("OnEnter", function(self)
		-- UIFrameFadeIn(self, .5, self:GetAlpha(), 1)
	-- end)

	-- Minimap:HookScript("OnEnter", function()
		-- UIFrameFadeIn(MBCF, .5, MBCF:GetAlpha(), 1)
	-- end)

	-- MBCF:SetScript("OnLeave", function(self)
		-- UIFrameFadeOut(self, .5, self:GetAlpha(), 0)
	-- end)

	-- Minimap:HookScript("OnLeave", function()
		-- UIFrameFadeOut(MBCF, .5, MBCF:GetAlpha(), 0)
	-- end)
end
