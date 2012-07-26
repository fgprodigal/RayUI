local R, L, P = unpack(select(2, ...)) --Inport: Engine, Locales, ProfileDB
local T = R:NewModule("Tutorial", "AceEvent-3.0")
local ADDON_NAME = ...

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

function T:PLAYER_ENTERING_WORLD()
	if not R.db.RayUIConfigTutorial then
		local tutorial1 = self:CreateTutorialFrame("RayUIConfigTutorial", GameMenuFrame, 220, 100, L["点击进入RayUI控制台。\n请仔细研究每一项设置的作用。"])
		tutorial1:SetPoint("BOTTOM", RayUIConfigButton, "TOP", 0, 15)
	end
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
end

function T:Initialize()
	self:RegisterEvent("PLAYER_ENTERING_WORLD")
end

R:RegisterModule(T:GetName())