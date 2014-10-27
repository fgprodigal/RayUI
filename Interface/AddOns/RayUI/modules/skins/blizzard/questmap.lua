local R, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local S = R:GetModule("Skins")

local function LoadSkin()
	local r, g, b = S["media"].classcolours[R.myclass].r, S["media"].classcolours[R.myclass].g, S["media"].classcolours[R.myclass].b
	local QuestMapFrame = QuestMapFrame

	-- [[ Quest scroll frame ]]

	local QuestScrollFrame = QuestScrollFrame
	local StoryHeader = QuestScrollFrame.Contents.StoryHeader

	QuestMapFrame.VerticalSeparator:Hide()
	QuestScrollFrame.Background:Hide()

	S:CreateBD(QuestScrollFrame.StoryTooltip)
	S:Reskin(QuestScrollFrame.ViewAll)
	S:ReskinScroll(QuestScrollFrame.ScrollBar)

	-- Story header

	StoryHeader.Background:Hide()
	StoryHeader.Shadow:Hide()

	do
		local bg = S:CreateBDFrame(StoryHeader, .25)
		bg:SetPoint("TOPLEFT", 0, -1)
		bg:SetPoint("BOTTOMRIGHT", -4, 0)

		local hl = StoryHeader.HighlightTexture

		-- hl:SetTexture(R["media"].gloss)
		hl:SetVertexColor(r, g, b, .2)
		hl:SetPoint("TOPLEFT", 1, -2)
		hl:SetPoint("BOTTOMRIGHT", -5, 1)
		hl:SetDrawLayer("BACKGROUND")
		hl:Hide()

		StoryHeader:HookScript("OnEnter", function()
			hl:Show()
		end)

		StoryHeader:HookScript("OnLeave", function()
			hl:Hide()
		end)
	end

	-- [[ Quest details ]]

	local DetailsFrame = QuestMapFrame.DetailsFrame
	local RewardsFrame = DetailsFrame.RewardsFrame
	local CompleteQuestFrame = DetailsFrame.CompleteQuestFrame

	DetailsFrame:GetRegions():Hide()
	select(2, DetailsFrame:GetRegions()):Hide()
	select(3, DetailsFrame:GetRegions()):Hide()
	select(6, DetailsFrame.ShareButton:GetRegions()):Hide()
	select(7, DetailsFrame.ShareButton:GetRegions()):Hide()

	S:Reskin(DetailsFrame.BackButton)
	S:Reskin(DetailsFrame.AbandonButton)
	S:Reskin(DetailsFrame.ShareButton)
	S:Reskin(DetailsFrame.TrackButton)

	DetailsFrame.AbandonButton:ClearAllPoints()
	DetailsFrame.AbandonButton:SetPoint("BOTTOMLEFT", DetailsFrame, -1, 0)
	DetailsFrame.AbandonButton:SetWidth(95)

	DetailsFrame.ShareButton:ClearAllPoints()
	DetailsFrame.ShareButton:SetPoint("LEFT", DetailsFrame.AbandonButton, "RIGHT", 1, 0)
	DetailsFrame.ShareButton:SetWidth(94)

	DetailsFrame.TrackButton:ClearAllPoints()
	DetailsFrame.TrackButton:SetPoint("LEFT", DetailsFrame.ShareButton, "RIGHT", 1, 0)
	DetailsFrame.TrackButton:SetWidth(96)

	-- Rewards frame

	RewardsFrame.Background:Hide()
	select(2, RewardsFrame:GetRegions()):Hide()

	-- Scroll frame

	S:ReskinScroll(DetailsFrame.ScrollFrame.ScrollBar)

	-- Complete quest frame
	CompleteQuestFrame:GetRegions():Hide()
	select(2, CompleteQuestFrame:GetRegions()):Hide()
	select(6, CompleteQuestFrame.CompleteButton:GetRegions()):Hide()
	select(7, CompleteQuestFrame.CompleteButton:GetRegions()):Hide()

	S:Reskin(CompleteQuestFrame.CompleteButton)

	-- [[ Quest log popup detail frame ]]

	local QuestLogPopupDetailFrame = QuestLogPopupDetailFrame

	select(18, QuestLogPopupDetailFrame:GetRegions()):Hide()
	QuestLogPopupDetailFramePageBg:Hide()
	QuestLogPopupDetailFrameScrollFrameTop:Hide()
	QuestLogPopupDetailFrameScrollFrameBottom:Hide()
	QuestLogPopupDetailFrameScrollFrameMiddle:Hide()

	S:ReskinPortraitFrame(QuestLogPopupDetailFrame, true)
	S:ReskinScroll(QuestLogPopupDetailFrameScrollFrameScrollBar)
	S:Reskin(QuestLogPopupDetailFrame.AbandonButton)
	S:Reskin(QuestLogPopupDetailFrame.TrackButton)
	S:Reskin(QuestLogPopupDetailFrame.ShareButton)

	-- Show map button

	local ShowMapButton = QuestLogPopupDetailFrame.ShowMapButton

	ShowMapButton.Texture:Hide()
	ShowMapButton.Highlight:SetTexture("")
	ShowMapButton.Highlight:SetTexture("")

	ShowMapButton:SetSize(ShowMapButton.Text:GetStringWidth() + 14, 22)
	ShowMapButton.Text:ClearAllPoints()
	ShowMapButton.Text:SetPoint("CENTER", 1, 0)

	ShowMapButton:ClearAllPoints()
	ShowMapButton:SetPoint("TOPRIGHT", QuestLogPopupDetailFrame, -30, -25)

	S:Reskin(ShowMapButton)

	ShowMapButton:HookScript("OnEnter", function(self)
		self.Text:SetTextColor(GameFontHighlight:GetTextColor())
	end)

	ShowMapButton:HookScript("OnLeave", function(self)
		self.Text:SetTextColor(GameFontNormal:GetTextColor())
	end)

	-- Bottom buttons

	QuestLogPopupDetailFrame.ShareButton:ClearAllPoints()
	QuestLogPopupDetailFrame.ShareButton:SetPoint("LEFT", QuestLogPopupDetailFrame.AbandonButton, "RIGHT", 1, 0)
	QuestLogPopupDetailFrame.ShareButton:SetPoint("RIGHT", QuestLogPopupDetailFrame.TrackButton, "LEFT", -1, 0)
end

S:RegisterSkin("RayUI", LoadSkin)
