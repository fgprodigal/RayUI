----------------------------------------------------------
-- Load RayUI Environment
----------------------------------------------------------
RayUI:LoadEnv("Skins")


local S = _Skins

local function LoadSkin()
	S:Reskin(RaidFrameRaidInfoButton)
	S:Reskin(RaidFrameConvertToRaidButton)
	S:Reskin(RaidInfoExtendButton)
	S:Reskin(RaidInfoCancelButton)
	S:ReskinClose(RaidInfoCloseButton)
	S:ReskinScroll(RaidInfoScrollFrameScrollBar)
	S:ReskinCheck(RaidFrameAllAssistCheckButton)
	RaidInfoInstanceLabel:DisableDrawLayer("BACKGROUND")
	RaidInfoIDLabel:DisableDrawLayer("BACKGROUND")
	RaidInfoDetailFooter:Hide()
	RaidInfoDetailHeader:Hide()
	RaidInfoDetailCorner:Hide()
	RaidInfoFrameHeader:Hide()
	RaidInfoFrame:SetPoint("TOPLEFT", RaidFrame, "TOPRIGHT", 1, -28)
end

S:AddCallback("RaidInfo", LoadSkin)