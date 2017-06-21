----------------------------------------------------------
-- Load RayUI Environment
----------------------------------------------------------
_LoadRayUIEnv_()


local WM = R:NewModule("WorldMap", "AceEvent-3.0", "AceHook-3.0", "AceTimer-3.0")


WM.modName = L["世界地图"]

local function FixTooltip()
    WorldMapTooltip:SetFrameStrata("TOOLTIP")
    WorldMapCompareTooltip1:SetFrameStrata("TOOLTIP")
    WorldMapCompareTooltip2:SetFrameStrata("TOOLTIP")
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
        RayUI_CoordsHolder.playerCoords:SetText("")
        RayUI_CoordsHolder.mouseCoords:SetText("")
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
        RayUI_CoordsHolder.playerCoords:SetText(PLAYER..": "..string.format("%.2f", x)..", "..string.format("%.2f", y))
    else
        RayUI_CoordsHolder.playerCoords:SetText(nil)
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
        RayUI_CoordsHolder.mouseCoords:SetText(MOUSE_LABEL..": "..string.format("%.2f", adjustedX)..", "..string.format("%.2f", adjustedY))
    else
        RayUI_CoordsHolder.mouseCoords:SetText(nil)
    end
end

function WM:Initialize()
    local CoordsHolder = CreateFrame("Frame", "RayUI_CoordsHolder", WorldMapFrame)
    CoordsHolder:SetPoint("BOTTOMRIGHT", WorldMapFrame.UIElementsFrame, "BOTTOMRIGHT", -30, 5)
    CoordsHolder:SetFrameLevel(WorldMapDetailFrame:GetFrameLevel() + 1)
    CoordsHolder:SetFrameStrata(WorldMapDetailFrame:GetFrameStrata())
    CoordsHolder:Size(150, 5)
    CoordsHolder.playerCoords = CoordsHolder:CreateFontString(nil, "OVERLAY")
    CoordsHolder.playerCoords:SetJustifyH("LEFT")
    CoordsHolder.mouseCoords = CoordsHolder:CreateFontString(nil, "OVERLAY")
    CoordsHolder.mouseCoords:SetJustifyH("LEFT")
    CoordsHolder.playerCoords:SetFontObject(NumberFontNormal)
    CoordsHolder.mouseCoords:SetFontObject(NumberFontNormal)
    CoordsHolder.playerCoords:SetText(PLAYER..": 0, 0")
    CoordsHolder.mouseCoords:SetText(MOUSE_LABEL..": 0, 0")
    CoordsHolder.playerCoords:SetPoint("BOTTOMLEFT", CoordsHolder, "BOTTOMLEFT")
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
