local R, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local T = R:NewModule("Tutorial", "AceEvent-3.0")
local ADDON_NAME = ...

T.TutorialList = {
	L["到 https://github.com/fgprodigal/RayUI 创建issue来反馈问题"],
	L["找不到微型菜单? 中键点击小地图试试"],
}

function T:CreateTutorialFrame(name, parent, width, height, text)
	local S = R:GetModule("Skins")
	local frame = CreateFrame("Frame", name, parent, "GlowBoxTemplate")
	frame:SetSize(width, height)
	frame:SetFrameStrata("FULLSCREEN_DIALOG")

	local arrow = CreateFrame("Frame", nil, frame, "GlowBoxArrowTemplate")
	arrow:SetPoint("TOP", frame, "BOTTOM", 0, 4)

	frame.text = frame:CreateFontString(nil, "OVERLAY")
	frame.text:SetJustifyH("CENTER")
	frame.text:SetSize(width - 20, height - 20)
	frame.text:SetFontObject(GameFontHighlightLeft)
	frame.text:SetPoint("CENTER")
	frame.text:SetText(text)
	frame.text:SetSpacing(4)

	local close = CreateFrame("Button", nil, frame, "UIPanelCloseButton")
	close:SetPoint("TOPRIGHT", 6, 6)
	S:ReskinClose(close)

	return frame
end

function T:SetNextTutorial()
	self.db.currentTutorial = self.db.currentTutorial or 0
	self.db.currentTutorial = self.db.currentTutorial + 1

	if self.db.currentTutorial > #T.TutorialList then
		self.db.currentTutorial = 1
	end

	RayUITutorialWindow.desc:SetText(T.TutorialList[self.db.currentTutorial])
end

function T:SetPrevTutorial()
	self.db.currentTutorial = self.db.currentTutorial or 0
	self.db.currentTutorial = self.db.currentTutorial - 1

	if self.db.currentTutorial <= 0 then
		self.db.currentTutorial = #T.TutorialList
	end

	RayUITutorialWindow.desc:SetText(T.TutorialList[self.db.currentTutorial])
end

function T:SpawnTutorialFrame()
	local S = R:GetModule("Skins")

	local f = CreateFrame("Frame", "RayUITutorialWindow", UIParent)
	f:SetFrameStrata("DIALOG")
	f:SetToplevel(true)
	f:EnableMouse(true)
	f:SetMovable(true)
	f:SetClampedToScreen(true)
	f:SetWidth(380)
	f:SetHeight(130)
	S:CreateBD(f)
	f:SetPoint("TOP", 0, -100)
	f:Hide()

	local header = CreateFrame("Button", nil, f)
	S:CreateBD(header)
	header:SetWidth(120); header:SetHeight(25)
	header:SetPoint("CENTER", f, "TOP")
	header:SetFrameLevel(header:GetFrameLevel() + 2)
	header:EnableMouse(true)
	header:RegisterForClicks("AnyUp", "AnyDown")
	header:SetScript("OnMouseDown", function() f:StartMoving() end)
	header:SetScript("OnMouseUp", function() f:StopMovingOrSizing() end)

	local title = header:CreateFontString(nil, "OVERLAY")
	title:SetFontObject(GameFontNormal)
	title:SetPoint("CENTER", header, "CENTER")
	title:SetJustifyH("CENTER")
	title:SetText(L["RayUI提示"])

	local desc = f:CreateFontString("ARTWORK")
	desc:SetFontObject(GameFontHighlight)
	desc:SetJustifyV("TOP")
	desc:SetJustifyH("LEFT")
	desc:SetPoint("TOPLEFT", 18, -32)
	desc:SetPoint("BOTTOMRIGHT", -18, 30)
	f.desc = desc

	f.disableButton = CreateFrame("CheckButton", f:GetName().."DisableButton", f, "OptionsCheckButtonTemplate")
	_G[f.disableButton:GetName() .. "Text"]:SetText(L["不再提示"])
	f.disableButton:SetPoint("BOTTOMLEFT", 10, 10)
	S:ReskinCheck(f.disableButton)
	f.disableButton:SetScript("OnShow", function(self) self:SetChecked(T.db.hideTutorial) end)

	f.disableButton:SetScript("OnClick", function(self) T.db.hideTutorial = self:GetChecked() end)

	f.hideButton = CreateFrame("Button", f:GetName().."HideButton", f, "OptionsButtonTemplate")
	f.hideButton:SetPoint("BOTTOMRIGHT", -10, 10)
	S:Reskin(f.hideButton)
	_G[f.hideButton:GetName() .. "Text"]:SetText(CLOSE)
	f.hideButton:SetScript("OnClick", function(self) self:GetParent():Hide() end)

	f.nextButton = CreateFrame("Button", f:GetName().."NextButton", f, "OptionsButtonTemplate")
	f.nextButton:SetPoint("RIGHT", f.hideButton, "LEFT", -4, 0)
	f.nextButton:Width(20)
	S:Reskin(f.nextButton)
	_G[f.nextButton:GetName() .. "Text"]:SetText(">")
	f.nextButton:SetScript("OnClick", function(self) T:SetNextTutorial() end)

	f.prevButton = CreateFrame("Button", f:GetName().."PrevButton", f, "OptionsButtonTemplate")
	f.prevButton:SetPoint("RIGHT", f.nextButton, "LEFT", -4, 0)
	f.prevButton:Width(20)
	S:Reskin(f.prevButton)
	_G[f.prevButton:GetName() .. "Text"]:SetText("<")
	f.prevButton:SetScript("OnClick", function(self) T:SetPrevTutorial() end)

	return f
end

function T:Tutorials(forceShow)
	if (not forceShow and self.db.hideTutorial) then return end

	local f = RayUITutorialWindow
	if not f then
		f = T:SpawnTutorialFrame()
	end

	f:Show()
	self:SetNextTutorial()
end

function T:PLAYER_ENTERING_WORLD()
	if not self.db.configbutton then
		local tutorial1 = self:CreateTutorialFrame("RayUIConfigTutorial", GameMenuFrame, 220, 100, L["点击进入RayUI控制台。\n请仔细研究每一项设置的作用。"])
		tutorial1:SetPoint("BOTTOM", RayUIConfigButton, "TOP", 0, 15)
	end
	if not self.db.tutorialdone then
		self:InitTutorial()
	end
	if not self.db.tabchannel then
		local tutorial2 = self:CreateTutorialFrame("RayUITabChannelTutorial", ChatFrame1EditBox, 220, 100, L["点击tab键可以快速切换频道。"])
		tutorial2:SetPoint("BOTTOM", ChatFrame1EditBox, "TOP", 0, 15)
	end
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
end

function T:OnInitialize()
	R.global.Tutorial = R.global.Tutorial or {}
	self.db = R.global.Tutorial

	self.db.hideTutorial = nil
end

function T:Initialize()
	self:RegisterEvent("PLAYER_ENTERING_WORLD")
end

local loc = GetLocale()

local ToolTipColors = {"|cFFFF8000", "|cFFFFAE5E", "|cFFFFFFFF", "|cFF909090", "|cFFE0E0E0", "|cFF00D8FF"}
local ButtonTexts, ToolTipStrings, ToolTipTexts

if loc == "zhCN" then
	ButtonTexts = {
		tutorial = "提示教程",
		skip = "跳过",
		finished = "完成",
	}
	ToolTipStrings = {
		config =			ToolTipColors[6].."控制面板中可以配置.|r",
	}
	ToolTipTexts = {
		general =				ToolTipColors[1].."控制面板|r\n\n"..ToolTipColors[3].."ESC系统菜单中点击RayUI设置进入控制面板|r\n\n",
		minimap =			ToolTipColors[1].."小地图|r\n\n"..ToolTipColors[2].."右键点击: |r"..ToolTipColors[3].."显示追踪菜单|r\n"..ToolTipColors[2].."中键点击: |r"..ToolTipColors[3].."系统菜单|r",
		playerframe =		ToolTipColors[1].."玩家头像|r\n\n"..ToolTipColors[4].."显示条件:|r\n"..ToolTipColors[3].."战斗中\n有目标\施法中\n生命值、法力值不满时|r\n\n"..ToolTipStrings.config,
		targetframe =		ToolTipColors[1].."目标头像|r\n\n"..ToolTipColors[4].."设置焦点:|r\n"..ToolTipColors[3].."点击头像中间的焦点字样|r",
		focusframes =		ToolTipColors[1].."焦点头像|r\n\n"..ToolTipColors[4].."取消焦点:|r\n"..ToolTipColors[3].."点击头像中间的取消焦点字样|r",
		actionbars =		ToolTipColors[1].."主要动作条|r\n\n"..ToolTipColors[2].."动作条:|r\n"..ToolTipColors[3].."动作条 1, 2, 3|r\n\n"..ToolTipColors[4].."显示条件:|r\n"..ToolTipColors[3].."战斗中\n有目标\n载具上\n法术书和宏界面打开时|r\n\n"..ToolTipStrings.config,
		chatframe =		ToolTipColors[1].."聊天框|r\n\n"..ToolTipColors[2].."自动隐藏:|r\n"..ToolTipColors[3].."长时间没有消息接受时会自动隐藏，隐藏后点击左侧按钮滑出聊天栏|r\n\n"..ToolTipStrings.config,
	}
else
	ButtonTexts = {
		tutorial = "提示教程",
		skip = "跳過",
		finished = "完成",
	}
	ToolTipStrings = {
		config =			ToolTipColors[6].."控制台中可以配置.|r",
	}
	ToolTipTexts = {
		general =				ToolTipColors[1].."控制台|r\n\n"..ToolTipColors[3].."ESC系統菜單中點擊RayUI設定進入控制台|r\n\n",
		minimap =			ToolTipColors[1].."小地圖|r\n\n"..ToolTipColors[2].."右鍵點擊: |r"..ToolTipColors[3].."顯示追蹤菜單|r\n"..ToolTipColors[2].."中鍵點擊: |r"..ToolTipColors[3].."系統菜單|r",
		playerframe =		ToolTipColors[1].."玩家頭像|r\n\n"..ToolTipColors[4].."顯示條件:|r\n"..ToolTipColors[3].."戰鬥中\n有目標\施法中\n生命值、法力值不滿時|r\n\n"..ToolTipStrings.config,
		targetframe =		ToolTipColors[1].."目標頭像|r\n\n"..ToolTipColors[4].."設置焦點:|r\n"..ToolTipColors[3].."點擊頭像中間的焦點字樣|r",
		focusframes =		ToolTipColors[1].."焦點頭像|r\n\n"..ToolTipColors[4].."取消焦點:|r\n"..ToolTipColors[3].."點擊頭像中間的取消焦點字樣|r",
		actionbars =		ToolTipColors[1].."主要動作條|r\n\n"..ToolTipColors[2].."動作條:|r\n"..ToolTipColors[3].."動作條 1, 2, 3|r\n\n"..ToolTipColors[4].."顯示條件:|r\n"..ToolTipColors[3].."戰鬥中\n有目標\n載具上\n法術書和巨集界面打開時|r\n\n"..ToolTipStrings.config,
		chatframe =		ToolTipColors[1].."聊天框|r\n\n"..ToolTipColors[2].."自動隱藏:|r\n"..ToolTipColors[3].."長時間沒有消息接受時會自動隱藏，隱藏后點擊左側按鈕滑出聊天欄|r\n\n"..ToolTipStrings.config,
	}
end


local rTB
RayUI_HelpPlate = {
	[1] = {	--buffs
		ButtonAnchor = "CENTER",
		ButtonPos = { x = 0, y = -50 },
		ToolTipDir = "UP",
		ToolTipText = ToolTipTexts.general,
	},
	[2] = {	--minimap
		ButtonAnchor = "RIGHT",
		Parent = "Minimap",
		ButtonPos = { x = 0, y = 0 },
		ToolTipDir = "RIGHT",
		ToolTipText = ToolTipTexts.minimap,
	},
	[3] = {	--playerframe
		ButtonAnchor = "CENTER",
		Parent = "RayUF_player",
		ButtonPos = { x = 0, y = 0 },
		ToolTipDir = "UP",
		ToolTipText = ToolTipTexts.playerframe,
	},
	[4] = {	--targetframe
		ButtonAnchor = "CENTER",
		Parent = "RayUF_target",
		ButtonPos = { x = 0, y = 0 },
		ToolTipDir = "UP",
		ToolTipText = ToolTipTexts.targetframe,
	},
	[5] = {	--focusframes
		ButtonAnchor = "CENTER",
		Parent = "RayUF_focus",
		ButtonPos = { x = 0, y = 0 },
		ToolTipDir = "UP",
		ToolTipText = ToolTipTexts.focusframes,
	},
	[6] = {	--actionbars
		ButtonAnchor = "CENTER",
		Parent = "RayUIActionBar1",
		ButtonPos = { x = 0, y = 0 },
		ToolTipDir = "UP",
		ToolTipText = ToolTipTexts.actionbars,
	},
	[7] = {--chatframe
		ButtonAnchor = "BOTTOMLEFT",
		ButtonPos = { x = 200, y = 70 },
		ToolTipDir = "UP",
		ToolTipText = ToolTipTexts.chatframe,
	},
}

local HP_CP
function RayUITutorial_HelpPlate_AnimateOnFinished(self)
	-- Hide the parent button
	self.parent:Hide()
	self:SetScript("OnFinished", nil)

	for i = 1, #HELP_PLATE_BUTTONS do
		local button = HELP_PLATE_BUTTONS[i]
		if ( button:IsShown() ) then
			return
		end
	end

	-- Hide everything
	for i = 1, #HELP_PLATE_BUTTONS do
		local button = HELP_PLATE_BUTTONS[i]
		button.box:Hide()
		button.boxHighlight:Hide()
	end

	HP_CP = nil
	HelpPlate:Hide()
end

function RayUITutorial_HelpPlate_Hide()
    if ( HP_CP ) then
        for i = 1, #HELP_PLATE_BUTTONS do
            local button = HELP_PLATE_BUTTONS[i]
            button.tooltipDir = "RIGHT"
            if ( button:IsShown() ) then
                if ( button.animGroup_Show:IsPlaying() ) then
                    button.animGroup_Show:Stop()
                end
                button.animGroup_Show:SetScript("OnFinished", RayUITutorial_HelpPlate_AnimateOnFinished)
                button.animGroup_Show.translate:SetDuration(0.3)
                button.animGroup_Show.alpha:SetDuration(0.3)
                button.animGroup_Show:Play()
            end
        end
    end
end

local function RayUITutorial_HelpPlate_Show( self, parent, mainHelpButton )
	if ( HP_CP ) then
		RayUITutorial_HelpPlate_Hide()
	end

	HP_CP = self
	HP_CP.mainHelpButton = mainHelpButton
	for i = 1, #self do
		local button = HelpPlate_GetButton()
		button:ClearAllPoints()
		button:SetPoint( self[i].ButtonAnchor, self[i].Parent or HelpPlate, self[i].ButtonAnchor, self[i].ButtonPos.x, self[i].ButtonPos.y )
		button.tooltipDir = self[i].ToolTipDir
		button.toolTipText = self[i].ToolTipText
		button.viewed = false
		button:Show()
		button.BigI:Show()
		button.Ring:Show()
		button.Pulse:Play()
	end
	HelpPlate:SetPoint( "CENTER", parent, "CENTER", 0, 0 )
	HelpPlate:SetSize( UIParent:GetWidth(), UIParent:GetHeight() )
	HelpPlate.userToggled = true
	HelpPlate:Show()
end

function RayUIShowTutorial_Stage1()
	local helpPlate = RayUI_HelpPlate
	if ( helpPlate and not HelpPlate_IsShowing(helpPlate) ) then
		RayUITutorial_HelpPlate_Show( helpPlate, UIParent, rTB )
	end

	HelpPlate:EnableMouse(false)
end

local function createTextButton(name, parent)
	local btn = CreateFrame("Button", name, parent, "SecureActionButtonTemplate")
	btn:SetNormalFontObject(NumberFontNormal)
	btn:SetFrameStrata("DIALOG")
	btn:SetFrameLevel(50)
	btn:SetSize(110, 50)
	return btn
end

function T:InitTutorial()
	-- MainHelpPlateButton
	rTB = CreateFrame("Button", "RayUITutorialButton", UIParent, "MainHelpPlateButton")
	rTB:SetPoint("CENTER", UIParent, "CENTER", 0, -38)
	rTB:Hide()

	-- Dark BG
	local tBG = CreateFrame("Frame", "RayUITutorialBG", UIParent)
	tBG:SetParent(UIParent)
	tBG:SetPoint("CENTER", UIParent, "CENTER")
	tBG:SetFrameStrata("BACKGROUND")
	tBG:SetFrameLevel(0)
	tBG:SetWidth(UIParent:GetWidth() + 2000)
	tBG:SetHeight(UIParent:GetHeight() + 2000)
	tBG:SetBackdrop({
		bgFile = R["media"].blank,
	})
	tBG:SetBackdropColor(0, 0, 0, 0.4)

	-- Buttons
	local btnOpen = createTextButton("RayUITutorialButtonOpen", UIParent)
	btnOpen:SetPoint("CENTER", parent, "CENTER", 0, 0)
	btnOpen:SetText(ButtonTexts.tutorial)
	btnOpen:SetAttribute("type", "macro")
	btnOpen:SetAttribute("macrotext", "/testuf r25\n/tar "..R.myname.."\n/focus\n/run RayUIShowTutorial_Stage1()\n/run RayUITutorialButtonClose:Show()\n/run RayUITutorialButtonOpen:Hide()")

	-- local btnSkip = createTextButton("RayUITutorialButtonSkip", UIParent)
	-- btnSkip:SetPoint("CENTER", parent, "CENTER", 0, -54)
	-- btnSkip:SetText(ButtonTexts.skip)
	-- btnSkip:RegisterForClicks("LeftButtonUp")
	-- btnSkip:SetScript("OnClick", function()
		-- rTB:Hide()
		-- btnOpen:Hide()
		-- btnSkip:Hide()
		-- tBG:Hide()
		-- R.global.Tutorial.tutorialdone = true
	-- end)

	local btnClose = createTextButton("RayUITutorialButtonClose", HelpPlate)
	btnClose:SetPoint("CENTER", parent, "CENTER", 0, 0)
	btnClose:SetText(ButtonTexts.finished)
	btnClose:SetAttribute("type", "macro")
	btnClose:SetAttribute("macrotext", "/testuf r25\n/clearfocus\n/cleartarget\n/run RayUITutorial_HelpPlate_Hide()\n/run RayUITutorialButtonClose:Hide()\n/run UIFrameFadeOut(RayUITutorialBG, 0.3, 0.5, 0)\n/run RayUI[1].global.Tutorial.tutorialdone = true")
	btnClose:Hide()

	-- Skin Buttons
	R:GetModule("Skins"):Reskin(btnOpen)
	R:GetModule("Skins"):Reskin(btnClose)
end

function T:ShowTutorial()
	if RayUITutorialButton then
		RayUITutorialButtonOpen:Show()
		RayUITutorialBG:SetAlpha(1)
		RayUITutorialBG:Show()
	else
		T:InitTutorial()
	end
end

R:RegisterModule(T:GetName())
