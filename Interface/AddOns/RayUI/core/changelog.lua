----------------------------------------------------------
-- Load RayUI Environment
----------------------------------------------------------
RayUI:LoadEnv()


local CL = R:NewModule("Changelog", "AceTimer-3.0")
R.Changelog = CL

local ver = 1
local ChangeLogData = {
	"更新记录:",
		"· 改进的法术监视，可以通过shift+鼠标右键点击buff/debuff图标设置监视/不监视特定技能",
        "· 姓名板加入职业能量条",
	" ",
	"提示:",
        "· 新加入的两个功能均可以在设置界面中关闭",
}

local function ModifiedString(string)
	local count = string.find(string, ":")
	local newString = string
	if count then
		local prefix = string.sub(string, 0, count)
		local suffix = string.sub(string, count + 1)
		local subHeader = string.find(string, "•")
		if subHeader then newString = tostring("|cFFFFFF00".. prefix .. "|r" .. suffix) else newString = tostring("|cffff7d0a" .. prefix .. "|r" .. suffix) end
	end
	for pattern in gmatch(string, "('.*')") do newString = newString:gsub(pattern, "|cFFFF8800" .. pattern:gsub("'", "") .. "|r") end
	return newString
end

local function GetChangeLogInfo(i)
	for line, info in pairs(ChangeLogData) do
		if line == i then return info end
	end
end

function CL:CreateChangelog()
	local frame = CreateFrame("Frame", "RayUIChangeLog", R.UIParent)
    frame:SetFrameStrata("FULLSCREEN_DIALOG")
	frame:SetPoint("CENTER", -50, 0)
	frame:SetSize(445, 245)
	frame:SetTemplate("Transparent")
	frame:SetMovable(true)
	frame:EnableMouse(true)
	frame:RegisterForDrag("LeftButton")
	frame:SetScript("OnDragStart", frame.StartMoving)
	frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
	frame:SetClampedToScreen(true)
	local icon = CreateFrame("Frame", nil, frame)
	icon:SetPoint("BOTTOMLEFT", frame, "TOPLEFT", 0, 3)
	icon:SetSize(20, 20)
	icon:SetTemplate("Transparent")
	icon.bg = icon:CreateTexture(nil, "ARTWORK")
	icon.bg:Point("TOPLEFT", 2, -2)
	icon.bg:Point("BOTTOMRIGHT", -2, 2)
	icon.bg:SetTexture(R.logo)
	local title = CreateFrame("Frame", nil, frame)
	title:SetPoint("LEFT", icon, "RIGHT", 3, 0)
	title:SetSize(422, 20)
	title:SetTemplate("Transparent")
	title.text = title:CreateFontString(nil, "OVERLAY")
	title.text:SetPoint("CENTER", title, 0, -1)
	title.text:SetFont(R["media"].font, 13)
	title.text:SetText("|cff7aa6d6Ray|r|cffff0000U|r|cff7aa6d6I|r - 更新记录")
	local close = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
	close:Point("BOTTOM", frame, "BOTTOM", 0, 10)
    close:SetText(CLOSE)
	close:SetSize(80, 20)
	close:SetScript("OnClick", function()
        R.global.ChangeLog = ver
        frame:Hide()
    end)
    close:Disable()
    frame.close = close
	R.Skins:Reskin(close)
    local countdown = close:CreateFontString(nil, "OVERLAY")
	countdown:SetPoint("LEFT", close.Text, "RIGHT", 3, 0)
	countdown:SetFont(R["media"].font, 12)
    countdown:SetTextColor(DISABLED_FONT_COLOR:GetRGB())
    frame.countdown = countdown
	local prev
	for i = 1, #ChangeLogData do
		local text = frame:CreateFontString(nil, "OVERLAY")
		text:SetPoint("TOP", prev or frame, prev and "BOTTOM" or "TOP", 0, prev and -5 or -10)
        text:SetPoint("LEFT", 5, 0)
        text:SetPoint("RIGHT", -5, 0)
		if i <= #ChangeLogData then
			local string = ModifiedString(GetChangeLogInfo(i))
			text:SetFont(R["media"].font, 13)
			text:SetText(string)
            text:SetJustifyH("LEFT")
            text:SetSpacing(5)
            text:SetWordWrap(true)
		end
		prev = text
	end
    frame:Hide()
end

function CL:CountDown()
    self.time = self.time - 1
    if self.time == 0 then
        RayUIChangeLog.countdown:SetText("")
        RayUIChangeLog.close:Enable()
        self:CancelAllTimers()
    else
        RayUIChangeLog.countdown:SetText(string.format("(%s)", self.time))
    end
end

function CL:ToggleChangeLog()
    if not RayUIChangeLog then
    	self:CreateChangelog()
    end
	PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF)

    local fadeInfo = {}
    fadeInfo.mode = "IN"
    fadeInfo.timeToFade = 0.5
    fadeInfo.startAlpha = 0
    fadeInfo.endAlpha = 1
    R:UIFrameFade(RayUIChangeLog, fadeInfo)
    R:Slide(RayUIChangeLog, "RIGHT", 50, 150)

    self.time = 6
    self:CancelAllTimers()
    CL:CountDown()
    self:ScheduleRepeatingTimer("CountDown", 1)
end

function CL:CheckVersion()
	if R.global.ChangeLog ~= ver then
		CL:ToggleChangeLog()
	end
end
