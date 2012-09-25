local R, L, P = unpack(select(2, ...)) --Inport: Engine, Locales, ProfileDB
local IF = R:NewModule("InfoBar", "AceEvent-3.0")

local bars = {}
IF.InfoBarStatusColor = {{1, 0, 0}, {1, 1, 0}, {0, 0.4, 1}}

function IF:CreateInfoBar(name, width, height, p1, rel, p2, x, y, noStatus)
	local bar = CreateFrame("Frame", name, UIParent)
	bar:CreatePanel("Default", width, height, p1, rel, p2, x, y)

	if noStatus then return end
	bar.Status = CreateFrame("StatusBar", name.."Status", bar)
	bar.Status:SetFrameLevel(12)
	bar.Status:SetStatusBarTexture(R["media"].normal)
	bar.Status:SetMinMaxValues(0, 100)
	bar.Status:SetStatusBarColor(unpack(IF.InfoBarStatusColor[3]))
	bar.Status:SetAllPoints()
	bar.Status:SetValue(100)

	bar.Text = bar.Status:CreateFontString(nil, "OVERLAY")
	bar.Text:SetFont(R["media"].font, R["media"].fontsize, R["media"].fontflag)
	bar.Text:Point("CENTER", bar, "CENTER", 0, -4)
	bar.Text:SetShadowColor(0, 0, 0, 0.4)
	bar.Text:SetShadowOffset(R.mult, -R.mult)

	bar:SetAlpha(0)

	tinsert(bars, bar)
end

function IF:Initialize()
	self:CreateInfoBar("RayUIBottomInfoBar", 400, 6, "BOTTOM", UIParent, "BOTTOM", 0, 10, true)
	for i = 1, 7 do
		if i == 1 then
			self:CreateInfoBar("RayUITopInfoBar"..i, 80, 6, "TOPLEFT", UIParent, "TOPLEFT", 10, -10)
		else
			self:CreateInfoBar("RayUITopInfoBar"..i, 80, 6, "LEFT", _G["RayUITopInfoBar"..i-1], "RIGHT", 9, 0)
		end
	end
	for i=1,#bars do
		R:Delay((2+i*0.6),function()
			UIFrameFadeIn(bars[i], 1, 0, 1)
		end)
	end
	self:LoadInfoText()
end

R:RegisterModule(IF:GetName())