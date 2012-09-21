local R, L, P = unpack(select(2, ...)) --Inport: Engine, Locales, ProfileDB
local T = R:NewModule("Tutorial", "AceEvent-3.0")
local ADDON_NAME = ...

T.TutorialList = {
	L["访问 http://rayui.org 反馈问题"],
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
	self:Tutorials()
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
end

function T:OnInitialize()
	R.global.Tutorial = R.global.Tutorial or {}
	self.db = R.global.Tutorial
end

function T:Initialize()
	self:RegisterEvent("PLAYER_ENTERING_WORLD")
end

R:RegisterModule(T:GetName())