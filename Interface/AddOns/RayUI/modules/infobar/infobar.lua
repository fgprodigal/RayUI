local R, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local IF = R:NewModule("InfoBar", "AceEvent-3.0", "AceHook-3.0", "AceConsole-3.0", "AceTimer-3.0")

local bars = {}
IF.InfoBarStatusColor = {{1, 0, 0}, {1, 1, 0}, {0, 0.4, 1}}

local height = 15
local speed = 135

function IF:CreateInfoPanel(name, width)
	local panel = CreateFrame("Frame", name, RayUI_BottomInfoBar)
	panel:SetSize(width, height - 1)
	panel.Text = panel:CreateFontString(nil, "OVERLAY")
	panel.Text:SetJustifyH("LEFT")
	panel.Text:SetJustifyV("CENTER")
	panel.Text:SetFont(R["media"].font, R["media"].fontsize - 1, R["media"].fontflag)
	panel.Text:Point("LEFT", panel, "LEFT", 13, 0)
	panel.Text:SetShadowColor(0, 0, 0, 0.4)
	panel.Text:SetShadowOffset(R.mult, -R.mult)

	local r, g, b = unpack(RayUF.colors.class[R.myclass])
	panel.Indicator = panel:CreateTexture(nil, "OVERLAY")
	panel.Indicator:SetAllPoints()
	panel.Indicator:SetTexture("Interface\\AddOns\\RayUI\\media\\threat")
	panel.Indicator:SetBlendMode("ADD")
	panel.Indicator:SetVertexColor(r, g, b, .6)
	panel.Indicator:Hide()

	panel.Square = panel:CreateTexture(nil, "OVERLAY")
	panel.Square:SetTexture(R.media.blank)
	panel.Square:SetVertexColor(unpack(IF.InfoBarStatusColor[3]))
	panel.Square:SetPoint("LEFT", 5, 0)
	panel.Square:Size(5, 5)
	panel.Square.Bg = panel:CreateTexture(nil, "BORDER")
	panel.Square.Bg:SetTexture(0, 0, 0)
	panel.Square.Bg:SetPoint("LEFT", 4, 0)
	panel.Square.Bg:Size(7, 7)

	panel:SetScript("OnEnter", function(self)
        if not IF.db.autoHide then return end
		IF:CancelTimer(IF.Anim)
		self.Indicator:Show()
	end)
	panel:SetScript("OnLeave", function(self)
        if not IF.db.autoHide then return end
		self.Indicator:Hide()
		IF:ReadyToSlideDown()
	end)

	return panel
end

function IF:ReadyToSlideDown()
    if not self.db.autoHide then return end
	self:CancelTimer(self.Anim)
	self.Anim = self:ScheduleTimer("SlideDown", 3)
end

function IF:SlideDown()
	local bottom = tonumber(R:Round(RayUI_BottomInfoBar:GetBottom()))
	if bottom <= -height then return end
	RayUI_BottomInfoBar:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 0)
	R:Slide(RayUI_BottomInfoBar, "DOWN", height, speed)
end

function IF:SlideUp()
	local bottom = tonumber(R:Round(RayUI_BottomInfoBar:GetBottom()))
	if bottom >= 0 then return end
	RayUI_BottomInfoBar:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, -height)
	R:Slide(RayUI_BottomInfoBar, "UP", height, speed)
end

function IF:CheckAutoHide()
    if not self.db.autoHide then return end
    local x, y = GetCursorPosition()
    if y > height and self:TimeLeft(self.Anim) <= 0 then
        self:ReadyToSlideDown()
    end
end

function IF:Initialize()
	local menuFrame = CreateFrame("Frame", "RayUI_InfobarRightClickMenu", UIParent, "UIDropDownMenuTemplate")
	local menuList = {
		{
            text = L["自动隐藏信息条"],
            checked = function() return self.db.autoHide end,
		    func = function()
                    self.db.autoHide = not self.db.autoHide
                    if not self.db.autoHide then
                        self:CancelTimer(self.Anim)
                        self:SlideUp()
                    else
                        self:SlideDown()
                    end
                end,
        },
	}

	local bottombar = CreateFrame("Frame", "RayUI_BottomInfoBar", UIParent)
	bottombar:SetWidth(UIParent:GetWidth())
	bottombar:SetHeight(height)
	bottombar:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 0)
	bottombar:CreateShadow("Background")

	local trigger = CreateFrame("Frame", nil, UIParent)
	trigger:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", 0, 0)
	trigger:SetPoint("TOPRIGHT", UIParent, "BOTTOMRIGHT", 0, 5)
	trigger:SetScript("OnEnter", function()
		self:SlideUp()
		self:CancelTimer(self.Anim)
	end)

	bottombar:SetScript("OnEnter", function()
		self:CancelTimer(self.Anim)
	end)

	bottombar:SetScript("OnLeave", function()
		self:ReadyToSlideDown()
	end)

	local function PopupMenu(_, btn)
		if btn=="RightButton" then
			EasyMenu(menuList, menuFrame, "cursor", 0, 50, "MENU", 1)
		end
	end

	bottombar:SetScript("OnMouseUp", PopupMenu)
	trigger:SetScript("OnMouseUp", PopupMenu)

	UIParent:HookScript("OnSizeChanged", function(self) bottombar:SetWidth(UIParent:GetWidth()) end)

	self.Anim = self:ScheduleTimer("SlideDown", 10)
	self:ScheduleRepeatingTimer("CheckAutoHide", 1)

	local RayUI_ExpBar = CreateFrame("Frame", "RayUI_ExpBar", UIParent)
	RayUI_ExpBar:CreateShadow("Background")
	RayUI_ExpBar:SetFrameStrata("BACKGROUND")
	RayUI_ExpBar:SetPoint("TOPLEFT", Minimap, "BOTTOMLEFT", 0, -5)
	RayUI_ExpBar:SetPoint("BOTTOMRIGHT", Minimap, "BOTTOMRIGHT", 0, -11)
	self:LoadInfoText()
end

R:RegisterModule(IF:GetName())
