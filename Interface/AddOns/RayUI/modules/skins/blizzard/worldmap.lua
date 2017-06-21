----------------------------------------------------------
-- Load RayUI Environment
----------------------------------------------------------
_LoadRayUIEnv_()


local S = R:GetModule("Skins")

local function LoadSkin()
    local r, g, b = S["media"].classcolours[R.myclass].r, S["media"].classcolours[R.myclass].g, S["media"].classcolours[R.myclass].b

    local WorldMapFrame = WorldMapFrame
    local BorderFrame = WorldMapFrame.BorderFrame

    WorldMapFrame.UIElementsFrame.CloseQuestPanelButton:GetRegions():Hide()
    WorldMapFrame.UIElementsFrame.OpenQuestPanelButton:GetRegions():Hide()
    BorderFrame.Bg:Hide()
    select(2, BorderFrame:GetRegions()):Hide()
    BorderFrame.portrait:SetTexture("")
    BorderFrame.portraitFrame:SetTexture("")
    for i = 5, 7 do
        select(i, BorderFrame:GetRegions()):SetAlpha(0)
    end
    BorderFrame.TopTileStreaks:SetTexture("")
    for i = 10, 14 do
        select(i, BorderFrame:GetRegions()):Hide()
    end
    BorderFrame.ButtonFrameEdge:Hide()
    BorderFrame.InsetBorderTop:Hide()
    BorderFrame.Inset.Bg:Hide()
    BorderFrame.Inset:DisableDrawLayer("BORDER")

    S:SetBD(BorderFrame, 1, 0, -3, 2)
    S:ReskinClose(BorderFrame.CloseButton)
    S:ReskinArrow(WorldMapFrame.UIElementsFrame.CloseQuestPanelButton, "left")
    S:ReskinArrow(WorldMapFrame.UIElementsFrame.OpenQuestPanelButton, "right")
    S:ReskinDropDown(WorldMapLevelDropDown)
    S:ReskinNavBar(WorldMapFrameNavBar)

    BorderFrame.CloseButton:SetPoint("TOPRIGHT", -9, -6)

    WorldMapLevelDropDown:SetPoint("TOPLEFT", -14, 2)

    -- [[ Size up / down buttons ]]

    for _, buttonName in pairs{"WorldMapFrameSizeUpButton", "WorldMapFrameSizeDownButton"} do
        local button = _G[buttonName]

        button:SetSize(17, 17)
        button:ClearAllPoints()
        button:SetPoint("RIGHT", BorderFrame.CloseButton, "LEFT", -1, 0)

        S:Reskin(button)

        local arrow = button:CreateFontString(nil, "OVERLAY")

        if buttonName == "WorldMapFrameSizeUpButton" then
            arrow:FontTemplate(R["media"].arrowfont, 26 * R.mult, "OUTLINE,MONOCHROME")
            arrow:Point("CENTER", 1, -2)
            arrow:SetText("W")
        else
            arrow:FontTemplate(R["media"].arrowfont, 27 * R.mult, "OUTLINE,MONOCHROME")
            arrow:Point("CENTER", 0, -4)
            arrow:SetText("V")
        end

        button:SetScript("OnEnter", function() arrow:SetTextColor(r, g, b) end)
        button:SetScript("OnLeave", function() arrow:SetTextColor(1, 1, 1) end)
    end

    -- [[ Misc ]]

    WorldMapFrameTutorialButton.Ring:Hide()
    WorldMapFrameTutorialButton:SetPoint("TOPLEFT", WorldMapFrame, "TOPLEFT", -12, 12)

    do
        local topLine = WorldMapFrame.UIElementsFrame:CreateTexture()
        topLine:SetColorTexture(0, 0, 0)
        topLine:SetHeight(1)
        topLine:SetPoint("TOPLEFT", 0, 1)
        topLine:SetPoint("TOPRIGHT", 1, 1)

        local rightLine = WorldMapFrame.UIElementsFrame:CreateTexture()
        rightLine:SetColorTexture(0, 0, 0)
        rightLine:SetWidth(1)
        rightLine:SetPoint("BOTTOMRIGHT", 1, 0)
        rightLine:SetPoint("TOPRIGHT", 1, 1)
    end

    -- [[ Tracking options ]]

    local TrackingOptions = WorldMapFrame.UIElementsFrame.TrackingOptionsButton

    TrackingOptions:GetRegions():Hide()
    TrackingOptions.Background:Hide()
    TrackingOptions.IconOverlay:SetTexture("")
    TrackingOptions.Button.Border:Hide()
end

S:AddCallback("WorldMap", LoadSkin)
