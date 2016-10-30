local R, L, P, G = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, GlobalDB
local WM = R:NewModule("WorldMap", "AceEvent-3.0", "AceHook-3.0", "AceTimer-3.0")

--Cache global variables
--Lua functions
local _G = _G
local select, unpack = select, unpack

--WoW API / Variables
local CreateFrame = CreateFrame
local InCombatLockdown = InCombatLockdown
local SetUIPanelAttribute = SetUIPanelAttribute
local IsInInstance = IsInInstance
local GetPlayerMapPosition = GetPlayerMapPosition
local GetCursorPosition = GetCursorPosition

--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: WorldMapFrame, WorldMapFrameSizeUpButton, WorldMapFrameSizeDownButton, CoordsHolder, PLAYER
-- GLOBALS: WorldMapDetailFrame, MOUSE_LABEL, DropDownList1, NumberFontNormal, BlackoutWorld, WorldMapTooltip
-- GLOBALS: WORLDMAP_SETTINGS, WORLDMAP_FULLMAP_SIZE, WORLDMAP_WINDOWED_SIZE, WorldMapCompareTooltip1, WorldMapCompareTooltip2

WM.modName = L["世界地图"]

local function FixTooltip()
    WorldMapTooltip:SetFrameStrata("TOOLTIP")
    WorldMapCompareTooltip1:SetFrameStrata("TOOLTIP")
    WorldMapCompareTooltip2:SetFrameStrata("TOOLTIP")
    if WorldMapTooltip.border then
        WorldMapTooltip.border:SetFrameStrata("DIALOG")
        WorldMapCompareTooltip1.border:SetFrameStrata("DIALOG")
        WorldMapCompareTooltip2.border:SetFrameStrata("DIALOG")
    end
end

function WM:SetLargeWorldMap()
    if InCombatLockdown() then return end

    WorldMapFrame:SetParent(R.UIParent)
    WorldMapFrame:EnableKeyboard(false)
    WorldMapFrame:EnableMouse(true)
    FixTooltip()

    if WorldMapFrame:GetAttribute("UIPanelLayout-area") ~= "center" then
        SetUIPanelAttribute(WorldMapFrame, "area", "center");
    end

    if WorldMapFrame:GetAttribute("UIPanelLayout-allowOtherPanels") ~= true then
        SetUIPanelAttribute(WorldMapFrame, "allowOtherPanels", true)
    end

    WorldMapFrameSizeUpButton:Hide()
    WorldMapFrameSizeDownButton:Show()

    WorldMapFrame:ClearAllPoints()
    WorldMapFrame:SetPoint("CENTER", R.UIParent, "CENTER", 0, 100)
    WorldMapFrame:SetSize(1002, 668)
end

function WM:SetSmallWorldMap()
    if InCombatLockdown() then return; end

    WorldMapFrameSizeUpButton:Show()
    WorldMapFrameSizeDownButton:Hide()
    FixTooltip()

    -- WorldMapFrame:ClearAllPoints()
    -- WorldMapFrame:SetPoint("CENTER", R.UIParent, "CENTER", 0, 100)
end

function WM:PLAYER_REGEN_ENABLED()
    WorldMapFrameSizeDownButton:Enable()
    WorldMapFrameSizeUpButton:Enable()
end

function WM:PLAYER_REGEN_DISABLED()
    WorldMapFrameSizeDownButton:Disable()
    WorldMapFrameSizeUpButton:Disable()
end

function WM:ResetDropDownListPosition(frame)
    DropDownList1:ClearAllPoints()
    DropDownList1:Point("TOPRIGHT", frame, "BOTTOMRIGHT", -17, -4)
end

local inRestrictedArea = false
function WM:PLAYER_ENTERING_WORLD()
    local x = GetPlayerMapPosition("player")
    if not x then
        inRestrictedArea = true
        self:CancelTimer(self.CoordsTimer)
        self.CoordsTimer = nil
        CoordsHolder.playerCoords:SetText("")
        CoordsHolder.mouseCoords:SetText("")
    elseif not self.CoordsTimer then
        inRestrictedArea = false
        self.CoordsTimer = self:ScheduleRepeatingTimer("UpdateCoords", 0.05)
    end
end

function WM:UpdateCoords()
    if not WorldMapFrame:IsShown() then return end
    local inInstance, _ = IsInInstance()
    local x, y = GetPlayerMapPosition("player")

    x = R:Round(100 * x, 2)
    y = R:Round(100 * y, 2)

    if x ~= 0 and y ~= 0 then
        CoordsHolder.playerCoords:SetText(PLAYER..": "..x..", "..y)
    else
        CoordsHolder.playerCoords:SetText(nil)
    end

    local scale = WorldMapDetailFrame:GetEffectiveScale()
    local width = WorldMapDetailFrame:GetWidth()
    local height = WorldMapDetailFrame:GetHeight()
    local centerX, centerY = WorldMapDetailFrame:GetCenter()
    local x, y = GetCursorPosition()
    local adjustedX = (x / scale - (centerX - (width/2))) / width
    local adjustedY = (centerY + (height/2) - y / scale) / height

    if (adjustedX >= 0 and adjustedY >= 0 and adjustedX <= 1 and adjustedY <= 1) then
        adjustedX = R:Round(100 * adjustedX, 2)
        adjustedY = R:Round(100 * adjustedY, 2)
        CoordsHolder.mouseCoords:SetText(MOUSE_LABEL..": "..adjustedX..", "..adjustedY)
    else
        CoordsHolder.mouseCoords:SetText(nil)
    end
end

function WM:Initialize()
    local CoordsHolder = CreateFrame("Frame", "CoordsHolder", WorldMapFrame)
    CoordsHolder:SetFrameLevel(WorldMapDetailFrame:GetFrameLevel() + 1)
    CoordsHolder:SetFrameStrata(WorldMapDetailFrame:GetFrameStrata())
    CoordsHolder.playerCoords = CoordsHolder:CreateFontString(nil, "OVERLAY")
    CoordsHolder.mouseCoords = CoordsHolder:CreateFontString(nil, "OVERLAY")
    CoordsHolder.playerCoords:SetFontObject(NumberFontNormal)
    CoordsHolder.mouseCoords:SetFontObject(NumberFontNormal)
    CoordsHolder.playerCoords:SetText(PLAYER..": 0, 0")
    CoordsHolder.mouseCoords:SetText(MOUSE_LABEL..": 0, 0")
    CoordsHolder.playerCoords:SetPoint("BOTTOMLEFT", WorldMapFrame.UIElementsFrame, "BOTTOMLEFT", 5, 5)
    CoordsHolder.mouseCoords:SetPoint("BOTTOMLEFT", CoordsHolder.playerCoords, "TOPLEFT")

    self.CoordsTimer = self:ScheduleRepeatingTimer("UpdateCoords", 0.05)
    self:RegisterEvent("PLAYER_ENTERING_WORLD")

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
