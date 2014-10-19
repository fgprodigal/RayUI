local R, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local WM = R:NewModule("WorldMap", "AceEvent-3.0", "AceHook-3.0", "AceTimer-3.0")
WM.modName = L["世界地图"]

function WM:GetOptions()
	local options = {
		-- lock = {
			-- order = 5,
			-- name = L["地图锁定"],
			-- type = "toggle",
		-- },
		-- scale = {
			-- order = 6,
			-- name = L["地图大小"],
			-- type = "range",
			-- min = 0.5, max = 1, step = 0.01,
			-- isPercent = true,
		-- },
		-- ejbuttonscale = {
			-- order = 7,
			-- name = L["Boss头像大小"],
			-- type = "range",
			-- min = 0.6, max = 1, step = 0.01,
			-- isPercent = true,
		-- },
		-- partymembersize = {
			-- order = 8,
			-- name = L["队友标示大小"],
			-- type = "range",
			-- min = 20, max = 30, step = 1,
		-- },
	}
	return options
end

function WM:SetLargeWorldMap()
	if InCombatLockdown() then return end

	WorldMapFrame:SetParent(UIParent)
	WorldMapFrame:EnableKeyboard(false)
	WorldMapFrame:SetScale(1)
	WorldMapFrame:EnableMouse(true)
	
	if WorldMapFrame:GetAttribute("UIPanelLayout-area") ~= "center" then
		SetUIPanelAttribute(WorldMapFrame, "area", "center");
	end
	
	if WorldMapFrame:GetAttribute("UIPanelLayout-allowOtherPanels") ~= true then
		SetUIPanelAttribute(WorldMapFrame, "allowOtherPanels", true)	
	end

	WorldMapFrameSizeUpButton:Hide()
	WorldMapFrameSizeDownButton:Show()	

	WorldMapFrame:ClearAllPoints()
	WorldMapFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 100)
	WorldMapFrame:SetSize(1002, 668)
end

function WM:SetSmallWorldMap()
	if InCombatLockdown() then return; end

	WorldMapFrameSizeUpButton:Show()
	WorldMapFrameSizeDownButton:Hide()	
end

function WM:PLAYER_REGEN_ENABLED()
	WorldMapFrameSizeDownButton:Enable()
	WorldMapFrameSizeUpButton:Enable()	
end

function WM:PLAYER_REGEN_DISABLED()
	WorldMapFrameSizeDownButton:Disable()
	WorldMapFrameSizeUpButton:Disable()
end

function WM:UpdateCoords()
	if(not WorldMapFrame:IsShown()) then return end
	local inInstance, _ = IsInInstance()
	local x, y = GetPlayerMapPosition("player")
	x = R:Round(100 * x, 2)
	y = R:Round(100 * y, 2)
	
	if x ~= 0 and y ~= 0 then
		CoordsHolder.playerCoords:SetText(PLAYER..":   "..x..", "..y)
	else
		CoordsHolder.playerCoords:SetText("")
	end
	
	local scale = WorldMapDetailFrame:GetEffectiveScale()
	local width = WorldMapDetailFrame:GetWidth()
	local height = WorldMapDetailFrame:GetHeight()
	local centerX, centerY = WorldMapDetailFrame:GetCenter()
	local x, y = GetCursorPosition()
	local adjustedX = (x / scale - (centerX - (width/2))) / width
	local adjustedY = (centerY + (height/2) - y / scale) / height	

	if (adjustedX >= 0  and adjustedY >= 0 and adjustedX <= 1 and adjustedY <= 1) then
		adjustedX = R:Round(100 * adjustedX, 2)
		adjustedY = R:Round(100 * adjustedY, 2)
		CoordsHolder.mouseCoords:SetText(MOUSE_LABEL..":   "..adjustedX..", "..adjustedY)
	else
		CoordsHolder.mouseCoords:SetText("")
	end
end

function WM:ResetDropDownListPosition(frame)
	DropDownList1:ClearAllPoints()
	DropDownList1:Point("TOPRIGHT", frame, "BOTTOMRIGHT", -17, -4)
end

function WM:Initialize()
	local CoordsHolder = CreateFrame("Frame", "CoordsHolder", WorldMapFrame)
	CoordsHolder:SetFrameLevel(WorldMapDetailFrame:GetFrameLevel() + 1)
	CoordsHolder:SetFrameStrata(WorldMapDetailFrame:GetFrameStrata())
	CoordsHolder.playerCoords = CoordsHolder:CreateFontString(nil, "OVERLAY")
	CoordsHolder.mouseCoords = CoordsHolder:CreateFontString(nil, "OVERLAY")
	CoordsHolder.playerCoords:SetTextColor(1, 1 ,0)
	CoordsHolder.mouseCoords:SetTextColor(1, 1 ,0)
	CoordsHolder.playerCoords:SetFontObject(NumberFontNormal)
	CoordsHolder.mouseCoords:SetFontObject(NumberFontNormal)
	CoordsHolder.playerCoords:SetPoint("BOTTOMLEFT", WorldMapDetailFrame, "BOTTOMLEFT", 5, 25)
	CoordsHolder.playerCoords:SetText(PLAYER..":   0, 0")
	CoordsHolder.mouseCoords:SetPoint("BOTTOMLEFT", CoordsHolder.playerCoords, "TOPLEFT", 0, 5)
	CoordsHolder.mouseCoords:SetText(MOUSE_LABEL..":   0, 0")
	
	self:ScheduleRepeatingTimer("UpdateCoords", 0.05)

	BlackoutWorld:SetTexture(nil)
	self:SecureHook("WorldMap_ToggleSizeDown", "SetSmallWorldMap")	
	self:SecureHook("WorldMap_ToggleSizeUp", "SetLargeWorldMap")
	self:RegisterEvent("PLAYER_REGEN_ENABLED")
	self:RegisterEvent("PLAYER_REGEN_DISABLED")

	if WORLDMAP_SETTINGS.size == WORLDMAP_FULLMAP_SIZE then
		self:SetLargeWorldMap()
	elseif WORLDMAP_SETTINGS.size == WORLDMAP_WINDOWED_SIZE then
		self:SetSmallWorldMap()
	end
end

function WM:Info()
	return L["|cff7aa6d6Ray|r|cffff0000U|r|cff7aa6d6I|r世界地图模块."]
end

R:RegisterModule(WM:GetName())
