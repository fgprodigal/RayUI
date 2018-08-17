----------------------------------------------------------
-- Load RayUI Environment
----------------------------------------------------------
RayUI:LoadEnv("WorldMap")

local WM = R:NewModule("WorldMap", "AceEvent-3.0", "AceHook-3.0", "AceTimer-3.0")

WM.modName = L["世界地图"]
_WorldMap = WM

local mapRects = {}
local tempVec2D = CreateVector2D(0, 0)
local MOUSE_LABEL = MOUSE_LABEL:gsub("|T.-|t","")

function WM:GetPlayerMapPos(mapID)
	tempVec2D.x, tempVec2D.y = UnitPosition("player")
	if not tempVec2D.x then return end

	local mapRect = mapRects[mapID]
	if not mapRect then
		mapRect = {}
		mapRect[1] = select(2, C_Map.GetWorldPosFromMapPos(mapID, CreateVector2D(0, 0)))
		mapRect[2] = select(2, C_Map.GetWorldPosFromMapPos(mapID, CreateVector2D(1, 1)))
		mapRect[2]:Subtract(mapRect[1])

		mapRects[mapID] = mapRect
	end
	tempVec2D:Subtract(mapRect[1])

	return tempVec2D.y/mapRect[2].y, tempVec2D.x/mapRect[2].x
end

function WM:SetLargeWorldMap(self)
    if InCombatLockdown() then return end
	self:SetScale(1)
end

function WM:SetSmallWorldMap(self)
    if InCombatLockdown() then return end
	self:SetScale(WM.db.scale)
end

function WM:OnFrameSizeChanged()
    _width, _height = _mapBody:GetWidth(), _mapBody:GetHeight()
end

function WM:OnMapChanged(self)
    if self:GetMapID() == C_Map.GetBestMapForUnit("player") then
        _mapID = self:GetMapID()
    else
        _mapID = nil
    end
end

local function CursorCoords()
    local left, top = _mapBody:GetLeft() or 0, _mapBody:GetTop() or 0
    local x, y = GetCursorPosition()
    local cx = (x/_scale - left) / _width
    local cy = (top - y/_scale) / _height
    if cx < 0 or cx > 1 or cy < 0 or cy > 1 then return end
    return cx, cy
end

local function CoordsFormat(owner, none)
    local text = none and ": --,--" or ": %.1f,%.1f"
    return owner..text
end

local function UpdateCoords(self, elapsed)
    self.elapsed = (self.elapsed or 0) + elapsed
    if self.elapsed > .1 then
        local cx, cy = CursorCoords()
        if cx and cy then
            WM.cursorCoords:SetFormattedText(CoordsFormat(MOUSE_LABEL), 100 * cx, 100 * cy)
        else
            WM.cursorCoords:SetText(CoordsFormat(MOUSE_LABEL, true))
        end

        if not _mapID then
            WM.playerCoords:SetText(CoordsFormat(PLAYER, true))
        else
            local x, y = WM:GetPlayerMapPos(_mapID)
            if not x or (x == 0 and y == 0) then
                WM.playerCoords:SetText(CoordsFormat(PLAYER, true))
            else
                WM.playerCoords:SetFormattedText(CoordsFormat(PLAYER), 100 * x, 100 * y)
            end
        end

        self.elapsed = 0
    end
end

function WM:Initialize()
    if not WorldMapFrame.isMaximized then WorldMapFrame:SetScale(self.db.scale) end
    
	self:SecureHook(WorldMapFrame, "Maximize", "SetLargeWorldMap")
	self:SecureHook(WorldMapFrame, "Minimize", "SetSmallWorldMap")

    -- Generate Coords
    local CoordsHolder = CreateFrame("Frame", "CoordsHolder", WorldMapFrame)
    CoordsHolder:SetFrameLevel(WorldMapFrame.BorderFrame:GetFrameLevel() + 1)
    CoordsHolder:SetFrameStrata(WorldMapFrame.BorderFrame:GetFrameStrata())

    self.playerCoords = CoordsHolder:CreateFontString(nil, "OVERLAY")
    self.playerCoords:FontTemplate(nil, nil, "OUTLINE")
	self.playerCoords:SetPoint("BOTTOMLEFT", WorldMapFrame.BorderFrame, 10, 10)
	self.cursorCoords = CoordsHolder:CreateFontString(nil, "OVERLAY")
    self.cursorCoords:FontTemplate(nil, nil, "OUTLINE")
	self.cursorCoords:SetPoint("LEFT", self.playerCoords, "RIGHT", 20, 0)

	_mapBody = WorldMapFrame:GetCanvasContainer()
    _scale, _width, _height = _mapBody:GetEffectiveScale(), _mapBody:GetWidth(), _mapBody:GetHeight()
    
    self:SecureHook(WorldMapFrame, "OnFrameSizeChanged")
    self:SecureHook(WorldMapFrame, "OnMapChanged")

	local CoordsUpdater = CreateFrame("Frame", nil, WorldMapFrame.BorderFrame)
	CoordsUpdater:SetScript("OnUpdate", UpdateCoords)
end

function WM:Info()
    return L["|cff7aa6d6Ray|r|cffff0000U|r|cff7aa6d6I|r世界地图模块."]
end

R:RegisterModule(WM:GetName())
