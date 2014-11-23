local R, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local S = R:GetModule("Skins")

local function LoadSkin()
	local r, g, b = S["media"].classcolours[R.myclass].r, S["media"].classcolours[R.myclass].g, S["media"].classcolours[R.myclass].b
	S:ReskinPortraitFrame(QuestFrame, true)

	QuestTitleFont:SetTextColor(1, 1, 1)
	QuestTitleFont:SetShadowColor(0, 0, 0)
	QuestFont:SetTextColor(1, 1, 1)

	hooksecurefunc("QuestFrameProgressItems_Update", function()
		QuestProgressTitleText:SetTextColor(1, 1, 1)
		QuestProgressTitleText:SetShadowColor(0, 0, 0)
		QuestProgressText:SetTextColor(1, 1, 1)
	end)

	QuestFrameDetailPanel:DisableDrawLayer("BACKGROUND")
	QuestFrameProgressPanel:DisableDrawLayer("BACKGROUND")
	QuestFrameRewardPanel:DisableDrawLayer("BACKGROUND")
	QuestFrameGreetingPanel:DisableDrawLayer("BACKGROUND")
	QuestFrameDetailPanel:DisableDrawLayer("BORDER")
	QuestFrameRewardPanel:DisableDrawLayer("BORDER")

	QuestDetailScrollFrameTop:Hide()
	QuestDetailScrollFrameBottom:Hide()
	QuestDetailScrollFrameMiddle:Hide()
	QuestProgressScrollFrameTop:Hide()
	QuestProgressScrollFrameBottom:Hide()
	QuestProgressScrollFrameMiddle:Hide()
	QuestRewardScrollFrameTop:Hide()
	QuestRewardScrollFrameBottom:Hide()
	QuestRewardScrollFrameMiddle:Hide()
	QuestGreetingScrollFrameTop:Hide()
	QuestGreetingScrollFrameBottom:Hide()
	QuestGreetingScrollFrameMiddle:Hide()

	QuestFrameProgressPanelMaterialTopLeft:SetAlpha(0)
	QuestFrameProgressPanelMaterialTopRight:SetAlpha(0)
	QuestFrameProgressPanelMaterialBotLeft:SetAlpha(0)
	QuestFrameProgressPanelMaterialBotRight:SetAlpha(0)

	local line = QuestFrameGreetingPanel:CreateTexture()
	line:SetTexture(1, 1, 1, .2)
	line:SetSize(256, 1)
	line:SetPoint("CENTER", QuestGreetingFrameHorizontalBreak)

	QuestGreetingFrameHorizontalBreak:SetTexture("")

	QuestFrameGreetingPanel:HookScript("OnShow", function()
		line:SetShown(QuestGreetingFrameHorizontalBreak:IsShown())
	end)

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
		line:SetPoint("RIGHT", ic, 1, 0)
		S:CreateBD(line)
	end

	QuestDetailScrollFrame:SetWidth(302) -- else these buttons get cut off

	hooksecurefunc(QuestProgressRequiredMoneyText, "SetTextColor", function(self, r, g, b)
		if r == 0 then
			self:SetTextColor(.8, .8, .8)
		elseif r == .2 then
			self:SetTextColor(1, 1, 1)
		end
	end)

	for _, questButton in pairs({"QuestFrameAcceptButton", "QuestFrameDeclineButton", "QuestFrameCompleteQuestButton", "QuestFrameCompleteButton", "QuestFrameGoodbyeButton", "QuestFrameGreetingGoodbyeButton"}) do
		S:Reskin(_G[questButton])
	end

	S:ReskinScroll(QuestProgressScrollFrameScrollBar)
	S:ReskinScroll(QuestRewardScrollFrameScrollBar)
	S:ReskinScroll(QuestDetailScrollFrameScrollBar)
	S:ReskinScroll(QuestGreetingScrollFrameScrollBar)

	-- Text colour stuff

	TRIVIAL_QUEST_DISPLAY = gsub(TRIVIAL_QUEST_DISPLAY, "cff000000", "cffaaaaaa")
	NORMAL_QUEST_DISPLAY = gsub(NORMAL_QUEST_DISPLAY, "cff000000", "cffffffff")
	QuestProgressRequiredItemsText:SetTextColor(1, 1, 1)
	QuestProgressRequiredItemsText:SetShadowColor(0, 0, 0)
	GreetingText:SetTextColor(1, 1, 1)
	GreetingText.SetTextColor = R.dummy
	AvailableQuestsText:SetTextColor(1, 1, 1)
	AvailableQuestsText.SetTextColor = R.dummy
	AvailableQuestsText:SetShadowColor(0, 0, 0)
	CurrentQuestsText:SetTextColor(1, 1, 1)
	CurrentQuestsText.SetTextColor = R.dummy
	CurrentQuestsText:SetShadowColor(0, 0, 0)

	-- [[ Quest NPC model ]]

	QuestNPCModelShadowOverlay:Hide()
	QuestNPCModelBg:Hide()
	QuestNPCModel:DisableDrawLayer("OVERLAY")
	QuestNPCModelNameText:SetDrawLayer("ARTWORK")
	QuestNPCModelTextFrameBg:Hide()
	QuestNPCModelTextFrame:DisableDrawLayer("OVERLAY")

	local npcbd = CreateFrame("Frame", nil, QuestNPCModel)
	npcbd:SetPoint("TOPLEFT", -1, 1)
	npcbd:SetPoint("RIGHT", 2, 0)
	npcbd:SetPoint("BOTTOM", QuestNPCModelTextScrollFrame)
	npcbd:SetFrameLevel(0)
	S:CreateBD(npcbd)

	local npcLine = CreateFrame("Frame", nil, QuestNPCModel)
	npcLine:SetPoint("BOTTOMLEFT", 0, -1)
	npcLine:SetPoint("BOTTOMRIGHT", 1, -1)
	npcLine:SetHeight(1)
	npcLine:SetFrameLevel(0)
	S:CreateBD(npcLine, 0)

	hooksecurefunc("QuestFrame_ShowQuestPortrait", function(parentFrame, _, _, _, x, y)
		if parentFrame == QuestLogPopupDetailFrame or parentFrame == QuestFrame then
			x = x + 3
		end

		QuestNPCModel:SetPoint("TOPLEFT", parentFrame, "TOPRIGHT", x, y)
	end)

	S:ReskinScroll(QuestNPCModelTextScrollFrameScrollBar)
end

S:RegisterSkin("RayUI", LoadSkin)
