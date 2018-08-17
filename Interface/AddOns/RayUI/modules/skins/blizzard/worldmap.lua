----------------------------------------------------------
-- Load RayUI Environment
----------------------------------------------------------
RayUI:LoadEnv("Skins")


local S = _Skins

local function LoadSkin()
    local r, g, b = _r, _g, _b

	local WorldMapFrame = _G["WorldMapFrame"]
	WorldMapFrame:StripTextures()
	WorldMapFrame.BorderFrame:StripTextures()
	WorldMapFrame.BorderFrame:SetFrameStrata(WorldMapFrame:GetFrameStrata())
	WorldMapFrame.NavBar:StripTextures()
	WorldMapFrame.NavBar.overlay:StripTextures()
	WorldMapFrame.NavBar:SetPoint("TOPLEFT", 1, -40)

	S:CreateBD(WorldMapFrame.ScrollContainer)
	S:SetBD(WorldMapFrame)

	-- WorldMapFrameHomeButton:StripTextures()
	-- S:Reskin(WorldMapFrameHomeButton)
	-- WorldMapFrameHomeButton:SetFrameLevel(1)
    -- WorldMapFrameHomeButton.text:FontTemplate()
    S:ReskinNavBar(WorldMapFrame.NavBar)

	-- Quest Frames
	local QuestMapFrame = _G["QuestMapFrame"]
	QuestMapFrame.VerticalSeparator:Hide()

	local QuestScrollFrame = _G["QuestScrollFrame"]
	QuestScrollFrame.DetailFrame:StripTextures()
	QuestScrollFrame.Contents.Separator.Divider:Hide()
	
	S:CreateBD(QuestScrollFrame.DetailFrame, 0)
	QuestScrollFrame.Contents.StoryHeader.Background:SetWidth(251)
	QuestScrollFrame.Contents.StoryHeader.Background:SetPoint("TOP", 0, -9)
	QuestScrollFrame.Contents.StoryHeader.Text:SetPoint("TOPLEFT", 18, -20)
	QuestScrollFrame.Contents.StoryHeader.HighlightTexture:SetAllPoints(QuestScrollFrame.Contents.StoryHeader.Background)
	QuestScrollFrame.Contents.StoryHeader.HighlightTexture:SetAlpha(0)
	S:ReskinScroll(QuestScrollFrameScrollBar)
	QuestScrollFrameScrollBar:SetPoint("TOPLEFT", QuestScrollFrame.DetailFrame, "TOPRIGHT", 1, -16)
	QuestScrollFrameScrollBar:SetPoint("BOTTOMLEFT", QuestScrollFrame.DetailFrame, "BOTTOMRIGHT", 6, 16)

	local QuestMapFrame = _G["QuestMapFrame"]
	S:Reskin(QuestMapFrame.DetailsFrame.BackButton)
	S:Reskin(QuestMapFrame.DetailsFrame.AbandonButton)
	S:Reskin(QuestMapFrame.DetailsFrame.ShareButton)
	S:Reskin(QuestMapFrame.DetailsFrame.TrackButton)
	S:Reskin(QuestMapFrame.DetailsFrame.CompleteQuestFrame.CompleteButton)

    -- R.Tooltip:SetStyle(QuestMapFrame.QuestsFrame.StoryTooltip)
    -- R.Tooltip:SetStyle(QuestScrollFrame.WarCampaignTooltip)

	QuestMapFrame.DetailsFrame.CompleteQuestFrame:StripTextures()

	S:ReskinArrow(WorldMapFrame.SidePanelToggle.CloseButton, "left")
	S:ReskinArrow(WorldMapFrame.SidePanelToggle.OpenButton, "right")

	S:ReskinClose(WorldMapFrameCloseButton)
    S:ReskinMaxMinFrame(WorldMapFrame.BorderFrame.MaximizeMinimizeFrame)
    
    WorldMapFrame.BorderFrame.MaximizeMinimizeFrame:ClearAllPoints()
    WorldMapFrame.BorderFrame.MaximizeMinimizeFrame:SetPoint("RIGHT", WorldMapFrameCloseButton, "LEFT", 5, 0)

	WorldMapFrame.BorderFrame.Tutorial:Kill()

	-- Floor Dropdown
	local function WorldMapFloorNavigationDropDown(Frame)
		S:ReskinWorldMapDropDownMenu(Frame)
	end

	-- Tracking Button
	local function WorldMapTrackingOptionsButton(Button)
		local shadow = Button:GetRegions()
		shadow:Hide()

		Button.Background:Hide()
		Button.IconOverlay:SetAlpha(0)
		Button.Border:Hide()

		local tex = Button:GetHighlightTexture()
		tex:SetTexture([[Interface\Minimap\Tracking\None]], "ADD")
		tex:SetAllPoints(Button.Icon)
	end

	-- Bounty Board
	local function WorldMapBountyBoard(Frame)
		Frame.BountyName:FontTemplate()

		S:ReskinClose(Frame.TutorialBox.CloseButton)
	end

	-- Add a hook to adjust the OverlayFrames
	-- hooksecurefunc(WorldMapFrame, "AddOverlayFrame", S.WorldMapMixin_AddOverlayFrame)

	-- Elements
	WorldMapFloorNavigationDropDown(WorldMapFrame.overlayFrames[1]) -- NavBar handled in ElvUI/modules/skins/misc
	WorldMapTrackingOptionsButton(WorldMapFrame.overlayFrames[2]) -- Buttons
	WorldMapBountyBoard(WorldMapFrame.overlayFrames[3]) -- BountyBoard
end

S:AddCallback("WorldMap", LoadSkin)
