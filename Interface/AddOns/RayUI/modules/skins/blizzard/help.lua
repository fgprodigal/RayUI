local R, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local S = R:GetModule("Skins")

local function LoadSkin()
	S:SetBD(HelpFrame)
	ReportPlayerNameDialog:StripTextures()
	ReportCheatingDialog:StripTextures()
	S:SetBD(ReportPlayerNameDialog)
	S:SetBD(ReportCheatingDialog)
	HelpFrameHeader:Hide()
	HelpFrameLeftInsetBg:Hide()
	select(4, HelpFrameTicket:GetChildren()):Hide()
	HelpFrameKnowledgebaseStoneTex:Hide()
	HelpFrameKnowledgebaseNavBarOverlay:Hide()
	select(5, HelpFrameGM_Response:GetChildren()):Hide()
	select(6, HelpFrameGM_Response:GetChildren()):Hide()
	HelpFrameButton16Selected:SetAlpha(0)
	select(3, HelpFrameReportBug:GetChildren()):Hide()
	select(3, HelpFrameSubmitSuggestion:GetChildren()):Hide()
	HelpFrameKnowledgebaseNavBarHomeButtonLeft:Hide()
	HelpFrameKnowledgebaseTopTileStreaks:Hide()
	HelpFrameKnowledgebaseNavBar:GetRegions():Hide()
	HelpFrameTicketScrollFrameScrollBar:SetPoint("TOPLEFT", HelpFrameTicketScrollFrame, "TOPRIGHT", 1, -16)
	HelpFrameGM_ResponseScrollFrame1ScrollBar:SetPoint("TOPLEFT", HelpFrameGM_ResponseScrollFrame1, "TOPRIGHT", 1, -16)
	HelpFrameGM_ResponseScrollFrame2ScrollBar:SetPoint("TOPLEFT", HelpFrameGM_ResponseScrollFrame2, "TOPRIGHT", 1, -16)
	select(2, HelpFrameCharacterStuckHearthstone:GetRegions()):SetAlpha(0)
	select(3, HelpFrameCharacterStuckHearthstone:GetRegions()):SetAlpha(0)
	local hover = HelpFrameCharacterStuckHearthstone:CreateTexture(nil, "HIGHLIGHT")
	hover:SetTexture(1, 1, 1, 0.3)
	hover:SetAllPoints()
	HelpFrameCharacterStuckHearthstoneIconTexture:SetTexCoord(.08, .92, .08, .92)

	local buttons = {
		"HelpFrameButton1",
		"HelpFrameButton2",
		"HelpFrameButton3",
		"HelpFrameButton4",
		"HelpFrameButton5",
		"HelpFrameButton6",
		"HelpFrameButton16",
		"HelpFrameSubmitSuggestionSubmit",
		"HelpFrameReportBugSubmit",
		"ReportPlayerNameDialogReportButton",
		"ReportPlayerNameDialogCancelButton",
		"ReportCheatingDialogReportButton",
		"ReportCheatingDialogCancelButton",
		"HelpFrameAccountSecurityOpenTicket",
		"HelpFrameCharacterStuckStuck",
		"HelpFrameOpenTicketHelpTopIssues",
		"HelpFrameOpenTicketHelpOpenTicket",
		"HelpFrameKnowledgebaseSearchButton",
		"HelpFrameGM_ResponseNeedMoreHelp",
		"HelpFrameGM_ResponseCancel",
		"GMChatOpenLog",
		"HelpFrameKnowledgebaseNavBarHomeButton",
		"HelpFrameTicketSubmit",
		"HelpFrameTicketCancel",
		"HelpFrameOpenTicketHelpItemRestoration"
	}
	for i = 1, #buttons do
		local button = _G[buttons[i]]
		S:Reskin(button)
	end

	S:ReskinClose(HelpFrameCloseButton)

	local layers = {
		"HelpFrameMainInset",
		"HelpFrame",
		"HelpFrameLeftInset"
	}
	for i = 1, #layers do
		_G[layers[i]]:DisableDrawLayer("BACKGROUND")
		_G[layers[i]]:DisableDrawLayer("BORDER")
	end

	local lightbds = {
		"HelpFrameTicketScrollFrame",
		"HelpFrameReportBugScrollFrame",
		"HelpFrameGM_ResponseScrollFrame1",
		"HelpFrameGM_ResponseScrollFrame2"
	}
	for i = 1, #lightbds do
		S:CreateBD(_G[lightbds[i]], .25)
	end

	local scrollbars = {
		"HelpFrameKnowledgebaseScrollFrameScrollBar",
		"HelpFrameTicketScrollFrameScrollBar",
		"HelpFrameReportBugScrollFrameScrollBar",
		"HelpFrameGM_ResponseScrollFrame1ScrollBar",
		"HelpFrameGM_ResponseScrollFrame2ScrollBar",
		"HelpFrameKnowledgebaseScrollFrame2ScrollBar"
	}
	for i = 1, #scrollbars do
		bar = _G[scrollbars[i]]
		S:ReskinScroll(bar)
	end

	for i = 1, 15 do
		local bu = _G["HelpFrameKnowledgebaseScrollFrameButton"..i]
		bu:DisableDrawLayer("ARTWORK")
		S:CreateBD(bu, 0)

		local tex = bu:CreateTexture(nil, "BACKGROUND")
		tex:SetPoint("TOPLEFT")
		tex:SetPoint("BOTTOMRIGHT")
		tex:SetTexture(R["media"].gloss)
		tex:SetGradientAlpha("VERTICAL", 0, 0, 0, .3, .35, .35, .35, .35)
	end

	S:ReskinInput(HelpFrameKnowledgebaseSearchBox)

	for i = 1, 6 do
		_G["HelpFrameButton"..i.."Selected"]:SetAlpha(0)
	end

	-- Nav Bar
	-- local function navButtonFrameLevel(self)
		-- for i=1, #self.navList do
			-- local navButton = self.navList[i]
			-- local lastNav = self.navList[i-1]
			-- if navButton and lastNav then
				-- navButton:SetFrameLevel(lastNav:GetFrameLevel() - 2)
				-- navButton:ClearAllPoints()
				-- navButton:SetPoint("LEFT", lastNav, "RIGHT", 1, 0)
			-- end
		-- end
	-- end

	-- hooksecurefunc("NavBar_AddButton", function(self, buttonData)
		-- local navButton = self.navList[#self.navList]

		-- if not navButton.skinned then
			-- S:Reskin(navButton)
			-- navButton:GetRegions():SetAlpha(0)
			-- select(2, navButton:GetRegions()):SetAlpha(0)
			-- select(3, navButton:GetRegions()):SetAlpha(0)

			-- navButton.skinned = true

			-- navButton:HookScript("OnClick", function()
				-- navButtonFrameLevel(self)
			-- end)
		-- end

		-- navButtonFrameLevel(self)
	-- end)
end

S:RegisterSkin("RayUI", LoadSkin)