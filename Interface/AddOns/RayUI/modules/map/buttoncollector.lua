local R, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local MM = R:GetModule("MiniMap")
local MBCF
local buttons = {}

function MM:PositionButtonCollector(self, screenQuadrant)
	local line = math.ceil(Minimap:GetWidth() / 20)
	-- MBCF.bg:SetColorTexture(0, 0, 0, 1)
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
		local name = btn:GetName()
		local type = btn:GetObjectType()
		if not name or not type then return end
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

			do	-- fix fuck up buttons
				if btn == BattlegroundTargets_MinimapButton then
					local pushed = btn:GetPushedTexture()
					pushed:SetSize(mmbSize,mmbSize)
					pushed:SetTexCoord(0,1,0,1)
					pushed:ClearAllPoints()
					pushed:SetPoint("CENTER")
				end
				if btn == BagSync_MinimapButton then
					btn.texture = bgMinimapButtonTexture
					btn.texture:SetTexture("Interface\\Icons\\inv_misc_bag_10_green")
				end
			end

			do	-- setup highlight
				local type = btn:GetObjectType()

				if type == "Button" then
					local highlight = btn:GetHighlightTexture()

					if highlight then
						highlight:ClearAllPoints()
						highlight:SetPoint("TOPLEFT")
						highlight:SetPoint("BOTTOMRIGHT")
						highlight:SetColorTexture(1,1,1,0.25)
					end
				end

				if type == "Frame" then
					if not btn.highlight then
						btn.highlight = btn:CreateTexture(nil,"OVERLAY")
						btn.highlight:SetColorTexture(1,1,1,0.25)
						btn.highlight:SetPoint("TOPLEFT")
						btn.highlight:SetPoint("BOTTOMRIGHT")
						btn.highlight:Hide()
						
						btn:HookScript("OnEnter",function(self)
							print(1)
							self.highlight:Show()
						end)
						btn:HookScript("OnLeave",function(self)
							self.highlight:Hide()
						end)
					end
				end
			end

			do	-- setup icon
				local icon = btn.icon or btn.Icon or btn.texture or _G[btn:GetName().."Icon"] or _G[btn:GetName().."_Icon"] or btn:GetNormalTexture()
				
				if icon then
					btn:HookScript("OnMouseDown", function()
						icon:SetTexCoord(0,1,0,1)
					end)
					btn:HookScript("OnMouseUp", function()
						icon:SetTexCoord(0.05,0.95,0.05,0.95)
					end)

					icon:SetTexCoord(0.05,0.95,0.05,0.95)
					icon:ClearAllPoints()
					icon:SetPoint("TOPLEFT")
					icon:SetPoint("BOTTOMRIGHT")
					icon.ClearAllPoints = function() end
					icon.SetPoint = function() end
				end
			end

			for _, region in pairs({btn:GetRegions()}) do
				if region:GetObjectType() == "Texture" then
					local file = tostring(region:GetTexture())

					if file and (file:find("Border") or file:find("Background") or file:find("AlphaMask")) then
						region:SetTexture("")
					end
				end
			end
			btn:Size(20,20)
			btn:CreateShadow("Background")

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
