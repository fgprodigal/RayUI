local R, L, P = unpack(select(2, ...)) --Inport: Engine, Locales, ProfileDB
local S = R:GetModule("Skins")

local function LoadSkin()
	S:Reskin(RaidFrameRaidInfoButton)
	RaidFrameRaidInfoButton:SetPoint("LEFT", RaidFrameConvertToRaidButton, "RIGHT", 67, 12)
	S:Reskin(RaidFrameConvertToRaidButton)
	S:Reskin(RaidInfoExtendButton)
	S:Reskin(RaidInfoCancelButton)
	S:ReskinClose(RaidInfoCloseButton)
	S:ReskinScroll(RaidInfoScrollFrameScrollBar)
	RaidFrameConvertToRaidButton:ClearAllPoints()
	RaidFrameConvertToRaidButton:SetPoint("TOPLEFT", RaidFrame, "TOPLEFT", 38, -35)
	RaidInfoInstanceLabel:DisableDrawLayer("BACKGROUND")
	RaidInfoIDLabel:DisableDrawLayer("BACKGROUND")
	RaidInfoDetailFooter:Hide()
	RaidInfoDetailHeader:Hide()
	RaidInfoDetailCorner:Hide()
	RaidInfoFrameHeader:Hide()
	RaidInfoFrame:SetPoint("TOPLEFT", RaidFrame, "TOPRIGHT", 1, -28)
end

S:RegisterSkin("RayUI", LoadSkin)