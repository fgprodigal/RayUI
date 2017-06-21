----------------------------------------------------------
-- Load RayUI Environment
----------------------------------------------------------
_LoadRayUIEnv_()


local S = R:GetModule("Skins")

local function LoadSkin()	
	TalkingHeadFrame:StripTextures()
	TalkingHeadFrame.MainFrame:StripTextures()
	TalkingHeadFrame.PortraitFrame:StripTextures()
	TalkingHeadFrame.MainFrame.Model.PortraitBg:Hide()
	
	S:ReskinClose(TalkingHeadFrame.MainFrame.CloseButton, "TOPRIGHT", TalkingHeadFrame.MainFrame, "TOPRIGHT", -27, -27)
end

S:AddCallbackForAddon("Blizzard_TalkingHeadUI", "TalkingHead", LoadSkin)