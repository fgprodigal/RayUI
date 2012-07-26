local R, L, P = unpack(select(2, ...)) --Inport: Engine, Locales, ProfileDB
local S = R:GetModule("Skins")

local function LoadSkin()
	local r, g, b = S["media"].classcolours[R.myclass].r, S["media"].classcolours[R.myclass].g, S["media"].classcolours[R.myclass].b
	S:SetBD(QuestLogFrame, 6, -9, -2, 6)
	S:SetBD(QuestFrame, 6, -15, -26, 64)
	S:SetBD(QuestLogDetailFrame, 6, -9, 0, 0)
	QuestFramePortrait:Hide()

	NORMAL_QUEST_DISPLAY = "|cffffffff%s|r"
	TRIVIAL_QUEST_DISPLAY = string.gsub(TRIVIAL_QUEST_DISPLAY, "|cff000000", "|cffffffff")
	QuestFont:SetTextColor(1, 1, 1)
	QuestProgressRequiredItemsText:SetTextColor(1, 1, 1)
	QuestProgressRequiredItemsText:SetShadowColor(0, 0, 0)
	QuestInfoRewardsHeader:SetShadowColor(0, 0, 0)
	QuestProgressTitleText:SetShadowColor(0, 0, 0)
	QuestInfoTitleHeader:SetShadowColor(0, 0, 0)
	QuestInfoTitleHeader:SetTextColor(1, 1, 1)
	QuestInfoTitleHeader.SetTextColor = R.dummy
	QuestInfoDescriptionHeader:SetTextColor(1, 1, 1)
	QuestInfoDescriptionHeader.SetTextColor = R.dummy
	QuestInfoDescriptionHeader:SetShadowColor(0, 0, 0)
	QuestInfoObjectivesHeader:SetTextColor(1, 1, 1)
	QuestInfoObjectivesHeader.SetTextColor = R.dummy
	QuestInfoObjectivesHeader:SetShadowColor(0, 0, 0)
	QuestInfoRewardsHeader:SetTextColor(1, 1, 1)
	QuestInfoRewardsHeader.SetTextColor = R.dummy
	QuestInfoDescriptionText:SetTextColor(1, 1, 1)
	QuestInfoDescriptionText.SetTextColor = R.dummy
	QuestInfoObjectivesText:SetTextColor(1, 1, 1)
	QuestInfoObjectivesText.SetTextColor = R.dummy
	QuestInfoGroupSize:SetTextColor(1, 1, 1)
	QuestInfoGroupSize.SetTextColor = R.dummy
	QuestInfoRewardText:SetTextColor(1, 1, 1)
	QuestInfoRewardText.SetTextColor = R.dummy
	QuestInfoItemChooseText:SetTextColor(1, 1, 1)
	QuestInfoItemChooseText.SetTextColor = R.dummy
	QuestInfoItemReceiveText:SetTextColor(1, 1, 1)
	QuestInfoItemReceiveText.SetTextColor = R.dummy
	QuestInfoSpellLearnText:SetTextColor(1, 1, 1)
	QuestInfoSpellLearnText.SetTextColor = R.dummy
	QuestInfoXPFrameReceiveText:SetTextColor(1, 1, 1)
	QuestInfoXPFrameReceiveText.SetTextColor = R.dummy
	GossipGreetingText:SetTextColor(1, 1, 1)
	QuestProgressTitleText:SetTextColor(1, 1, 1)
	QuestProgressTitleText.SetTextColor = R.dummy
	QuestProgressText:SetTextColor(1, 1, 1)
	QuestProgressText.SetTextColor = R.dummy
	AvailableQuestsText:SetTextColor(1, 1, 1)
	AvailableQuestsText.SetTextColor = R.dummy
	AvailableQuestsText:SetShadowColor(0, 0, 0)
	QuestInfoSpellObjectiveLearnLabel:SetTextColor(1, 1, 1)
	QuestInfoSpellObjectiveLearnLabel.SetTextColor = R.dummy
	CurrentQuestsText:SetTextColor(1, 1, 1)
	CurrentQuestsText.SetTextColor = R.dummy
	CurrentQuestsText:SetShadowColor(0, 0, 0)
	for i = 1, MAX_OBJECTIVES do
		local objective = _G["QuestInfoObjective"..i]
		objective:SetTextColor(1, 1, 1)
		objective.SetTextColor = R.dummy
	end

	QuestInfoSkillPointFrameIconTexture:SetSize(40, 40)
	QuestInfoSkillPointFrameIconTexture:SetTexCoord(.08, .92, .08, .92)

	local scrollbars = {
		"QuestLogScrollFrameScrollBar",
		"QuestLogDetailScrollFrameScrollBar",
		"QuestProgressScrollFrameScrollBar",
		"QuestRewardScrollFrameScrollBar",
		"QuestDetailScrollFrameScrollBar",
		"QuestGreetingScrollFrameScrollBar",
		"QuestNPCModelTextScrollFrameScrollBar"
	}
	for i = 1, #scrollbars do
		bar = _G[scrollbars[i]]
		S:ReskinScroll(bar)
	end

	local layers = {
		"QuestFrameDetailPanel",
		"QuestFrameProgressPanel",
		"QuestFrameRewardPanel",
		"QuestFrameGreetingPanel",
		"EmptyQuestLogFrame"
	}
	for i = 1, #layers do
		_G[layers[i]]:DisableDrawLayer("BACKGROUND")
	end
	QuestFrameDetailPanel:DisableDrawLayer("BORDER")
	QuestFrameRewardPanel:DisableDrawLayer("BORDER")
	QuestLogDetailFrame:DisableDrawLayer("BORDER")
	QuestLogDetailFrame:DisableDrawLayer("ARTWORK")
	QuestLogDetailFrame:GetRegions():Hide()
	QuestNPCModelShadowOverlay:Hide()
	QuestNPCModelBg:Hide()
	QuestNPCModel:DisableDrawLayer("OVERLAY")
	QuestNPCModelNameText:SetDrawLayer("ARTWORK")
	QuestNPCModelTextFrameBg:Hide()
	QuestNPCModelTextFrame:DisableDrawLayer("OVERLAY")
	QuestNPCModelTextScrollFrameScrollBarThumbTexture.bg:Hide()
	QuestLogDetailTitleText:SetDrawLayer("OVERLAY")
	QuestLogDetailScrollFrameScrollBackgroundTopLeft:SetAlpha(0)
	QuestLogDetailScrollFrameScrollBackgroundBottomRight:SetAlpha(0)
	QuestLogFrameCompleteButton_LeftSeparator:Hide()
	QuestLogFrameCompleteButton_RightSeparator:Hide()
	select(9, QuestFrameGreetingPanel:GetRegions()):Hide()
	QuestInfoItemHighlight:GetRegions():Hide()
	QuestInfoSpellObjectiveFrameNameFrame:Hide()

	QuestLogFrameShowMapButton:StripTextures()
	S:Reskin(QuestLogFrameShowMapButton)
	QuestLogFrameShowMapButton.text:ClearAllPoints()
	QuestLogFrameShowMapButton.text:SetPoint("CENTER")
	QuestLogFrameShowMapButton:Size(QuestLogFrameShowMapButton:GetWidth() - 30, QuestLogFrameShowMapButton:GetHeight(), - 40)

	for i = 1, 9 do
		select(i, QuestLogCount:GetRegions()):Hide()
	end

	for i = 1, 3 do
		select(i, QuestLogFrame:GetRegions()):Hide()
	end

	NPCBD = CreateFrame("Frame", nil, QuestNPCModel)
	NPCBD:Point("TOPLEFT", 0, 1)
	NPCBD:Point("RIGHT", 1, 0)
	NPCBD:SetPoint("BOTTOM", QuestNPCModelTextScrollFrame)
	NPCBD:SetFrameLevel(QuestNPCModel:GetFrameLevel()-1)
	S:CreateBD(NPCBD)

	local line1 = CreateFrame("Frame", nil, QuestNPCModel)
	line1:Point("BOTTOMLEFT", 0, -1)
	line1:Point("BOTTOMRIGHT", 0, -1)
	line1:SetHeight(1)
	line1:SetFrameLevel(QuestNPCModel:GetFrameLevel()-1)
	S:CreateBD(line1, 0)

	local bg = CreateFrame("Frame", nil, QuestInfoSkillPointFrame)
	bg:Point("TOPLEFT", -3, 0)
	bg:Point("BOTTOMRIGHT", -3, 0)
	bg:Lower()
	S:CreateBD(bg, .25)

	QuestInfoSkillPointFrame:StyleButton()
	QuestInfoSkillPointFrame:GetPushedTexture():Point("TOPLEFT", 1, -1)
	QuestInfoSkillPointFrame:GetPushedTexture():Point("BOTTOMRIGHT", -3, 1)
	QuestInfoSkillPointFrame:GetHighlightTexture():Point("TOPLEFT", 1, -1)
	QuestInfoSkillPointFrame:GetHighlightTexture():Point("BOTTOMRIGHT", -3, 1)

	S:CreateBD(QuestLogCount, .25)
	QuestInfoSkillPointFrameNameFrame:Hide()
	QuestInfoSkillPointFrameName:SetParent(bg)
	QuestInfoSkillPointFrameIconTexture:SetParent(bg)
	QuestInfoSkillPointFrameSkillPointBg:SetParent(bg)
	QuestInfoSkillPointFrameSkillPointBgGlow:SetParent(bg)
	QuestInfoSkillPointFramePoints:SetParent(bg)

	local line2 = QuestInfoSkillPointFrame:CreateTexture(nil, "BACKGROUND")
	line2:SetSize(1, 40)
	line2:Point("RIGHT", QuestInfoSkillPointFrameIconTexture, 1, 0)
	line2:SetTexture(S["media"].backdrop)
	line2:SetVertexColor(0, 0, 0)

	local function clearhighlight()
		for i = 1, MAX_NUM_ITEMS do
			_G["QuestInfoItem"..i]:SetBackdropColor(0, 0, 0, .25)
		end
	end

	local function sethighlight(self)
		clearhighlight()

		local _, point = self:GetPoint()
		point:SetBackdropColor(r, g, b, .2)
	end

	hooksecurefunc(QuestInfoItemHighlight, "SetPoint", sethighlight)
	QuestInfoItemHighlight:HookScript("OnShow", sethighlight)
	QuestInfoItemHighlight:HookScript("OnHide", clearhighlight)

	for i = 1, MAX_REQUIRED_ITEMS do
		local bu = _G["QuestProgressItem"..i]
		local ic = _G["QuestProgressItem"..i.."IconTexture"]
		local na = _G["QuestProgressItem"..i.."NameFrame"]
		local co = _G["QuestProgressItem"..i.."Count"]

		ic:SetSize(40, 40)
		ic:SetTexCoord(.08, .92, .08, .92)

		S:CreateBD(bu, .25)

		na:Hide()
		co:SetDrawLayer("OVERLAY")

		local line = CreateFrame("Frame", nil, bu)
		line:SetSize(1, 40)
		line:Point("RIGHT", ic, 1, 0)
		S:CreateBD(line)

		bu:StyleButton()
		bu:GetPushedTexture():Point("TOPLEFT", 1, -1)
		bu:GetPushedTexture():Point("BOTTOMRIGHT", -1, 1)
		bu:GetHighlightTexture():Point("TOPLEFT", 1, -1)
		bu:GetHighlightTexture():Point("BOTTOMRIGHT", -1, 1)
	end

	for i = 1, MAX_NUM_ITEMS do
		local bu = _G["QuestInfoItem"..i]
		local ic = _G["QuestInfoItem"..i.."IconTexture"]
		local na = _G["QuestInfoItem"..i.."NameFrame"]
		local co = _G["QuestInfoItem"..i.."Count"]

		ic:Point("TOPLEFT", 1, -1)
		ic:SetSize(39, 39)
		ic:SetTexCoord(.08, .92, .08, .92)
		ic:SetDrawLayer("OVERLAY")

		S:CreateBD(bu, .25)

		na:Hide()
		co:SetDrawLayer("OVERLAY")

		local line = CreateFrame("Frame", nil, bu)
		line:SetSize(1, 40)
		line:Point("RIGHT", ic, 1, 0)
		S:CreateBD(line)

		bu:StyleButton()
		bu:GetPushedTexture():Point("TOPLEFT", 1, -1)
		bu:GetPushedTexture():Point("BOTTOMRIGHT", -1, 1)
		bu:GetHighlightTexture():Point("TOPLEFT", 1, -1)
		bu:GetHighlightTexture():Point("BOTTOMRIGHT", -1, 1)
	end

	QuestLogFramePushQuestButton:ClearAllPoints()
	QuestLogFramePushQuestButton:Point("LEFT", QuestLogFrameAbandonButton, "RIGHT", 1, 0)
	QuestLogFramePushQuestButton:SetWidth(100)
	QuestLogFrameTrackButton:ClearAllPoints()
	QuestLogFrameTrackButton:Point("LEFT", QuestLogFramePushQuestButton, "RIGHT", 1, 0)

	hooksecurefunc("QuestFrame_ShowQuestPortrait", function(parentFrame, portrait, text, name, x, y)
		local parent = parentFrame:GetName()
		if parent == "QuestLogFrame" or parent == "QuestLogDetailFrame" then
			QuestNPCModel:SetPoint("TOPLEFT", parentFrame, "TOPRIGHT", x+4, y)
		else
			QuestNPCModel:SetPoint("TOPLEFT", parentFrame, "TOPRIGHT", x+8, y)
		end
	end)

	local questlogcontrolpanel = function()
		local parent
		if QuestLogFrame:IsShown() then
			parent = QuestLogFrame
			QuestLogControlPanel:SetPoint("BOTTOMLEFT", parent, "BOTTOMLEFT", 9, 6)
		elseif QuestLogDetailFrame:IsShown() then
			parent = QuestLogDetailFrame
			QuestLogControlPanel:SetPoint("BOTTOMLEFT", parent, "BOTTOMLEFT", 9, 0)
		end
	end
	hooksecurefunc("QuestLogControlPanel_UpdatePosition", questlogcontrolpanel)

	local buttons = {
		"QuestLogFrameAbandonButton",
		"QuestLogFramePushQuestButton",
		"QuestLogFrameTrackButton",
		"QuestLogFrameCancelButton",
		"QuestFrameAcceptButton",
		"QuestFrameDeclineButton",
		"QuestFrameCompleteQuestButton",
		"QuestFrameCompleteButton",
		"QuestFrameGoodbyeButton",
		"QuestFrameGreetingGoodbyeButton",
		"QuestLogFrameCompleteButton"
	}
	for i = 1, #buttons do
	local button = _G[buttons[i]]
		S:Reskin(button)
	end
	S:ReskinClose(QuestLogFrameCloseButton, "TOPRIGHT", QuestLogFrame, "TOPRIGHT", -7, -14)
	S:ReskinClose(QuestLogDetailFrameCloseButton, "TOPRIGHT", QuestLogDetailFrame, "TOPRIGHT", -5, -14)
	S:ReskinClose(QuestFrameCloseButton, "TOPRIGHT", QuestFrame, "TOPRIGHT", -30, -20)

	S:Reskin(WatchFrameCollapseExpandButton)
	local downtex = WatchFrameCollapseExpandButton:CreateTexture(nil, "ARTWORK")
	downtex:SetSize(8, 8)
	downtex:SetPoint("CENTER", 1, 0)
	downtex:SetVertexColor(1, 1, 1)

	if WatchFrame.userCollapsed then
		downtex:SetTexture("Interface\\AddOns\\RayUI\\media\\arrow-down-active")
	else
		downtex:SetTexture("Interface\\AddOns\\RayUI\\media\\arrow-up-active")
	end

	hooksecurefunc("WatchFrame_Collapse", function() downtex:SetTexture("Interface\\AddOns\\RayUI\\media\\arrow-down-active") end)
	hooksecurefunc("WatchFrame_Expand", function() downtex:SetTexture("Interface\\AddOns\\RayUI\\media\\arrow-up-active") end)

	local function updateQuest()
		local numEntries = GetNumQuestLogEntries()

		local buttons = QuestLogScrollFrame.buttons
		local numButtons = #buttons
		local scrollOffset = HybridScrollFrame_GetOffset(QuestLogScrollFrame)
		local questLogTitle, questIndex
		local isHeader, isCollapsed

		for i = 1, numButtons do
			questLogTitle = buttons[i]
			questIndex = i + scrollOffset

			if not questLogTitle.reskinned then
				questLogTitle.reskinned = true

				questLogTitle:SetNormalTexture("")
				questLogTitle.SetNormalTexture = R.dummy
				questLogTitle:SetPushedTexture("")
				questLogTitle:SetHighlightTexture("")
				questLogTitle.SetHighlightTexture = R.dummy

				questLogTitle.bg = CreateFrame("Frame", nil, questLogTitle)
				questLogTitle.bg:Size(13, 13)
				questLogTitle.bg:Point("LEFT", 4, 0)
				questLogTitle.bg:SetFrameLevel(questLogTitle:GetFrameLevel()-1)
				S:CreateBD(questLogTitle.bg, 0)

				questLogTitle.tex = questLogTitle:CreateTexture(nil, "BACKGROUND")
				questLogTitle.tex:SetAllPoints(questLogTitle.bg)
				questLogTitle.tex:SetTexture(S["media"].backdrop)
				questLogTitle.tex:SetGradientAlpha("VERTICAL", 0, 0, 0, .3, .35, .35, .35, .35)

				questLogTitle.minus = questLogTitle:CreateTexture(nil, "OVERLAY")
				questLogTitle.minus:Size(7, 1)
				questLogTitle.minus:SetPoint("CENTER", questLogTitle.bg)
				questLogTitle.minus:SetTexture(S["media"].backdrop)
				questLogTitle.minus:SetVertexColor(1, 1, 1)

				questLogTitle.plus = questLogTitle:CreateTexture(nil, "OVERLAY")
				questLogTitle.plus:Size(1, 7)
				questLogTitle.plus:SetPoint("CENTER", questLogTitle.bg)
				questLogTitle.plus:SetTexture(S["media"].backdrop)
				questLogTitle.plus:SetVertexColor(1, 1, 1)
			end

			if questIndex <= numEntries then
				_, _, _, _, isHeader, isCollapsed = GetQuestLogTitle(questIndex)
				if isHeader then
					questLogTitle.bg:Show()
					questLogTitle.tex:Show()
					questLogTitle.minus:Show()
					if isCollapsed then
						questLogTitle.plus:Show()
					else
						questLogTitle.plus:Hide()
					end
				else
					questLogTitle.bg:Hide()
					questLogTitle.tex:Hide()
					questLogTitle.minus:Hide()
					questLogTitle.plus:Hide()
				end
			end
		end
	end
	-- hooksecurefunc("QuestLog_Update", updateQuest)
	-- QuestLogScrollFrame:HookScript("OnVerticalScroll", updateQuest)
	-- QuestLogScrollFrame:HookScript("OnMouseWheel", updateQuest)
end

S:RegisterSkin("RayUI", LoadSkin)