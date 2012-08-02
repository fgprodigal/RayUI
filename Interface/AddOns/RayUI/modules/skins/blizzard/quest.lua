local R, L, P = unpack(select(2, ...)) --Inport: Engine, Locales, ProfileDB
local S = R:GetModule("Skins")

local function LoadSkin()
	local r, g, b = S["media"].classcolours[R.myclass].r, S["media"].classcolours[R.myclass].g, S["media"].classcolours[R.myclass].b
	S:ReskinPortraitFrame(QuestLogFrame, true)
	S:ReskinPortraitFrame(QuestLogDetailFrame, true)
	S:ReskinPortraitFrame(QuestFrame, true)

	S:CreateBD(QuestLogCount, .25)

	QuestFrameDetailPanel:DisableDrawLayer("BACKGROUND")
	QuestFrameProgressPanel:DisableDrawLayer("BACKGROUND")
	QuestFrameRewardPanel:DisableDrawLayer("BACKGROUND")
	QuestFrameGreetingPanel:DisableDrawLayer("BACKGROUND")
	EmptyQuestLogFrame:DisableDrawLayer("BACKGROUND")
	QuestFrameDetailPanel:DisableDrawLayer("BORDER")
	QuestFrameRewardPanel:DisableDrawLayer("BORDER")

	select(18, QuestLogFrame:GetRegions()):Hide()
	select(18, QuestLogDetailFrame:GetRegions()):Hide()

	QuestLogFramePageBg:Hide()
	QuestLogFrameBookBg:Hide()
	QuestLogDetailFramePageBg:Hide()
	QuestLogScrollFrameTop:Hide()
	QuestLogScrollFrameBottom:Hide()
	QuestLogScrollFrameMiddle:Hide()
	QuestLogDetailScrollFrameTop:Hide()
	QuestLogDetailScrollFrameBottom:Hide()
	QuestLogDetailScrollFrameMiddle:Hide()
	QuestDetailScrollFrameTop:Hide()
	QuestDetailScrollFrameBottom:Hide()
	QuestDetailScrollFrameMiddle:Hide()
	QuestProgressScrollFrameTop:Hide()
	QuestProgressScrollFrameBottom:Hide()
	QuestProgressScrollFrameMiddle:Hide()
	QuestRewardScrollFrameTop:Hide()
	QuestRewardScrollFrameBottom:Hide()
	QuestRewardScrollFrameMiddle:Hide()
	QuestDetailLeftBorder:Hide()
	QuestDetailBotLeftCorner:Hide()
	QuestDetailTopLeftCorner:Hide()
	QuestGreetingScrollFrameTop:Hide()
	QuestGreetingScrollFrameMiddle:Hide()
	QuestGreetingScrollFrameBottom:Hide()

	QuestNPCModelShadowOverlay:Hide()
	QuestNPCModelBg:Hide()
	QuestNPCModel:DisableDrawLayer("OVERLAY")
	QuestNPCModelNameText:SetDrawLayer("ARTWORK")
	QuestNPCModelTextFrameBg:Hide()
	QuestNPCModelTextFrame:DisableDrawLayer("OVERLAY")
	QuestLogDetailTitleText:SetDrawLayer("OVERLAY")
	QuestLogFrameCompleteButton_LeftSeparator:Hide()
	QuestLogFrameCompleteButton_RightSeparator:Hide()
	QuestInfoItemHighlight:GetRegions():Hide()
	QuestInfoSpellObjectiveFrameNameFrame:Hide()
	QuestFrameProgressPanelMaterialTopLeft:SetAlpha(0)
	QuestFrameProgressPanelMaterialTopRight:SetAlpha(0)
	QuestFrameProgressPanelMaterialBotLeft:SetAlpha(0)
	QuestFrameProgressPanelMaterialBotRight:SetAlpha(0)

	QuestLogFramePushQuestButton:ClearAllPoints()
	QuestLogFramePushQuestButton:SetPoint("LEFT", QuestLogFrameAbandonButton, "RIGHT", 1, 0)
	QuestLogFramePushQuestButton:SetWidth(100)
	QuestLogFrameTrackButton:ClearAllPoints()
	QuestLogFrameTrackButton:SetPoint("LEFT", QuestLogFramePushQuestButton, "RIGHT", 1, 0)

	local npcbd = CreateFrame("Frame", nil, QuestNPCModel)
	npcbd:SetPoint("TOPLEFT", 0, 1)
	npcbd:SetPoint("RIGHT", 1, 0)
	npcbd:SetPoint("BOTTOM", QuestNPCModelTextScrollFrame)
	npcbd:SetFrameLevel(QuestNPCModel:GetFrameLevel()-1)
	S:CreateBD(npcbd)

	local line = CreateFrame("Frame", nil, QuestNPCModel)
	line:SetPoint("BOTTOMLEFT", 0, -1)
	line:SetPoint("BOTTOMRIGHT", 0, -1)
	line:SetHeight(1)
	line:SetFrameLevel(QuestNPCModel:GetFrameLevel()-1)
	S:CreateBD(line, 0)

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
	CurrentQuestsText:SetShadowColor(0, 0, 0)
	CoreAbilityFont:SetTextColor(1, 1, 1)
	SystemFont_Large:SetTextColor(1, 1, 1)
	for i = 1, MAX_OBJECTIVES do
		local objective = _G["QuestInfoObjective"..i]
		objective:SetTextColor(1, 1, 1)
		objective.SetTextColor = R.dummy
	end

	QuestInfoSkillPointFrameIconTexture:SetSize(40, 40)
	QuestInfoSkillPointFrameIconTexture:SetTexCoord(.08, .92, .08, .92)
	QuestLogDetailFrame:DisableDrawLayer("BORDER")
	QuestLogDetailFrame:DisableDrawLayer("ARTWORK")

	QuestLogFrameShowMapButton:StripTextures()
	S:Reskin(QuestLogFrameShowMapButton)
	QuestLogFrameShowMapButton.text:ClearAllPoints()
	QuestLogFrameShowMapButton.text:SetPoint("CENTER")
	QuestLogFrameShowMapButton:Size(QuestLogFrameShowMapButton:GetWidth() - 30, QuestLogFrameShowMapButton:GetHeight(), - 40)

	for i = 1, 9 do
		select(i, QuestLogCount:GetRegions()):Hide()
	end

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
		ic:SetDrawLayer("OVERLAY")

		S:CreateBD(bu, .25)

		na:Hide()
		co:SetDrawLayer("OVERLAY")

		local line = CreateFrame("Frame", nil, bu)
		line:SetSize(1, 40)
		line:Point("RIGHT", ic, 1, 0)
		S:CreateBD(line)

		bu:StyleButton(1)
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

		bu:StyleButton(1)
	end
	
	hooksecurefunc("QuestFrame_ShowQuestPortrait", function(parentFrame, portrait, text, name, x, y)
		QuestNPCModel:SetPoint("TOPLEFT", parentFrame, "TOPRIGHT", x+6, y)
	end)

	S:ReskinScroll(QuestLogScrollFrameScrollBar)
	S:ReskinScroll(QuestLogDetailScrollFrameScrollBar)
	S:ReskinScroll(QuestProgressScrollFrameScrollBar)
	S:ReskinScroll(QuestRewardScrollFrameScrollBar)
	S:ReskinScroll(QuestDetailScrollFrameScrollBar)
	S:ReskinScroll(QuestGreetingScrollFrameScrollBar)
	S:ReskinScroll(QuestNPCModelTextScrollFrameScrollBar)

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
	S:ReskinClose(QuestLogFrameCloseButton)
	S:ReskinClose(QuestLogDetailFrameCloseButton)
	S:ReskinClose(QuestFrameCloseButton)

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