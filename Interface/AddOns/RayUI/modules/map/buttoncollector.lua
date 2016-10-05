local R, L, P, G = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, GlobalDB
local MM = R:GetModule("MiniMap")

--Cache global variables
--Lua functions
local select, unpack, pairs, string, math = select, unpack, pairs, string, math
local tinsert = table.insert
local strfind = string.find

--WoW API / Variables
local CreateFrame = CreateFrame

--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: VendomaticButton, VendomaticButtonIcon, Minimap, BaudErrorFrameMinimapButton

local MBCF
local buttons = {}

local AcceptedFrames = {
	"BagSync_MinimapButton",
	"VendomaticButtonFrame",
	"MiniMapMailFrame",
}
local TexCoords = { .1, .9, .1, .9 }
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

local function SetMinimapButton(btn)
	if (not btn or btn.isSkinned) then return end
	local name = btn:GetName()
	if BlackList[name] then return end
	btn:SetParent("MinimapButtonCollectFrame")
	if not name == "GarrisonLandingPageMinimapButton" then
		btn:SetPushedTexture(nil)
		btn:SetHighlightTexture(nil)
		btn:SetDisabledTexture(nil)
	end

	for i = 1, btn:GetNumRegions() do
		local region = select(i, btn:GetRegions())
		if region:GetObjectType() == "Texture" then
			local texture = region:GetTexture()

			if texture and (strfind(texture, "Border") or strfind(texture, "Background") or strfind(texture, "AlphaMask") or strfind(texture, "Highlight")) then
				region:SetTexture(nil)
				if name == "MiniMapTrackingButton" then
					region:SetTexture("Interface\\Minimap\\Tracking\\None")
					region:ClearAllPoints()
					region:SetAllPoints()
				end
			else
				if name == "BagSync_MinimapButton" then region:SetTexture("Interface\\AddOns\\BagSync\\media\\icon") end
				if name == "DBMMinimapButton" then region:SetTexture("Interface\\Icons\\INV_Helmet_87") end
				if name == "MiniMapMailFrame" then
					region:ClearAllPoints()
					region:SetPoint("CENTER", btn)
				end
				if not (name == "MiniMapMailFrame" or name == "SmartBuff_MiniMapButton") then
					region:ClearAllPoints()
					region:SetAllPoints()
					region:SetTexCoord(unpack(TexCoords))
					btn:HookScript("OnLeave", function(self) region:SetTexCoord(unpack(TexCoords)) end)
				end
				region:SetDrawLayer("ARTWORK")
				region.SetPoint = function() return end
			end
		end
	end

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
					self.highlight:Show()
				end)
				btn:HookScript("OnLeave",function(self)
					self.highlight:Hide()
				end)
			end
		end
	end

	if name == "SmartBuff_MiniMapButton" then
		btn:SetNormalTexture("Interface\\Icons\\Spell_Nature_Purge")
		btn:GetNormalTexture():SetTexCoord(unpack(TexCoords))
		btn.SetNormalTexture = function() end
		btn:SetDisabledTexture("Interface\\Icons\\Spell_Nature_Purge")
		btn:GetDisabledTexture():SetTexCoord(unpack(TexCoords))
		btn.SetDisabledTexture = function() end
	elseif name == "VendomaticButtonFrame" then
		VendomaticButton:StripTextures()
		VendomaticButton:SetAllPoints()
		VendomaticButtonIcon:SetTexture("Interface\\Icons\\INV_Misc_Rabbit_2")
		VendomaticButtonIcon:SetTexCoord(unpack(TexCoords))
	end
	btn:Size(23,23)
	btn:CreateShadow("Background")
	if btn:GetName() ~= "BaudErrorFrameMinimapButton" then
		tinsert(buttons, btn)
	else
		btn.shadow:SetBackdropColor(0.8, 0.2, 0.2, 0.4)
		R:GetModule("Skins"):CreatePulse(btn.shadow, 1, 1)
	end
	btn.isSkinned = true
end

local function GrabMinimapButtons()
	for i = 1, Minimap:GetNumChildren() do
		local object = select(i, Minimap:GetChildren())
		if object then
			if object:IsObjectType("Button") and object:GetName() then
				SetMinimapButton(object)
			end
			for _, frame in pairs(AcceptedFrames) do
				if object:IsObjectType("Frame") and object:GetName() == frame then
					SetMinimapButton(object)
				end
			end
		end
	end
end

function MM:PositionButtonCollector(self, screenQuadrant)
	local line = math.ceil(Minimap:GetWidth() / 20)
	-- MBCF.bg:SetColorTexture(0, 0, 0, 1)
	-- MBCF:SetAlpha(0)
	MBCF:ClearAllPoints()
	screenQuadrant = screenQuadrant or R:GetScreenQuadrant(self)
	if BaudErrorFrameMinimapButton then
		BaudErrorFrameMinimapButton:SetFrameStrata("DIALOG")
		BaudErrorFrameMinimapButton:ClearAllPoints()
		BaudErrorFrameMinimapButton:SetPoint("RIGHT", Minimap, "RIGHT", -2, 0)
		BaudErrorFrameMinimapButton.ClearAllPoints = R.dummy
		BaudErrorFrameMinimapButton.SetPoint = R.dummy
	end
	for i =1, #buttons do
		buttons[i]:ClearAllPoints()
		if i == 1 then
			buttons[i]:SetPoint("TOP", MBCF, "TOP", 0, 0)
		elseif i%line == 1 then
			if strfind(screenQuadrant, "RIGHT") then
				buttons[i]:SetPoint("TOPRIGHT", buttons[i-line], "TOPLEFT", -3, 0)
			else
				buttons[i]:SetPoint("TOPLEFT", buttons[i-line], "TOPRIGHT", 3, 0)
			end
		else
			buttons[i]:SetPoint("TOP", buttons[i-1], "BOTTOM", 0, -3)
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
	MBCF = CreateFrame("Frame", "MinimapButtonCollectFrame", R.UIParent)
	if select(3, Minimap:GetPoint()):upper():find("TOP") then
		MBCF:SetPoint("BOTTOMLEFT", Minimap, "TOPLEFT", 0, 5)
	else
		MBCF:SetPoint("TOPRIGHT", Minimap, "BOTTOMRIGHT", 0, -5)
	end
	MBCF:SetSize(20, 150)
	MBCF:SetFrameStrata("BACKGROUND")
	MBCF:SetFrameLevel(1)

	local MinimapButtonCollect = CreateFrame("Frame")
	MinimapButtonCollect:RegisterEvent("PLAYER_ENTERING_WORLD")
	MinimapButtonCollect:RegisterEvent("ADDON_LOADED")
	MinimapButtonCollect:SetScript("OnEvent", function(self)
		GrabMinimapButtons()
		if #buttons == 0 then
			MBCF:Hide()
		end
		MM:PositionButtonCollector(Minimap)
	end)

	local Time = 0
	MinimapButtonCollect:SetScript("OnUpdate", function(self, elasped)
		Time = Time + elasped
		if Time > 1 then
			GrabMinimapButtons()
			if #buttons == 0 then
				MBCF:Hide()
			end
			MM:PositionButtonCollector(Minimap)
			self:SetScript("OnUpdate", nil)
		end
	end)
end
