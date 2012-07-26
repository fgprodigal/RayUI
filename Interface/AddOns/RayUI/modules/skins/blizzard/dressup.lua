local R, L, P = unpack(select(2, ...)) --Inport: Engine, Locales, ProfileDB
local S = R:GetModule("Skins")

local function LoadSkin()
	S:SetBD(DressUpFrame, 10, -12, -34, 74)
	DressUpFramePortrait:Hide()
	DressUpBackgroundTopLeft:Hide()
	DressUpBackgroundTopRight:Hide()
	DressUpBackgroundBotLeft:Hide()
	DressUpBackgroundBotRight:Hide()
	for i = 2, 5 do
		select(i, DressUpFrame:GetRegions()):Hide()
	end
	DressUpFrameResetButton:SetPoint("RIGHT", DressUpFrameCancelButton, "LEFT", -1, 0)
	S:Reskin(DressUpFrameCancelButton)
	S:Reskin(DressUpFrameResetButton)
	S:ReskinClose(DressUpFrameCloseButton, "TOPRIGHT", DressUpFrame, "TOPRIGHT", -38, -16)
end

S:RegisterSkin("RayUI", LoadSkin)