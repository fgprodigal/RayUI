local R, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local S = R:GetModule("Skins")

local function LoadSkin()	
	TalkingHeadFrame:StripTextures()
	TalkingHeadFrame.MainFrame:StripTextures()
	TalkingHeadFrame.PortraitFrame:StripTextures()
	TalkingHeadFrame.MainFrame.Model.PortraitBg:Hide()
	TalkingHeadFrame:CreateShadow("Background")
	
	S:ReskinClose(TalkingHeadFrame.MainFrame.CloseButton)
end

S:RegisterSkin("Blizzard_TalkingHeadUI", LoadSkin)