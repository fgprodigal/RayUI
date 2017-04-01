local R, L, P, G = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, GlobalDB
local S = R:GetModule("Skins")

local function LoadSkin()
	ObliterumForgeFramePortraitFrame:Kill()
	ObliterumForgeFramePortrait:Kill()
	ObliterumForgeFrameTitleBg:Kill()

    ObliterumForgeFrameBg:Kill()
    ObliterumForgeFrameTopBorder:Kill()
	ObliterumForgeFrameTopRightCorner:Kill()
    ObliterumForgeFrameTopTileStreaks:Kill()
    ObliterumForgeFrameBottomBorder:Kill()
    ObliterumForgeFrameLeftBorder:Kill()
    ObliterumForgeFrameRightBorder:Kill()
	ObliterumForgeFrameBtnCornerLeft:Kill()
    ObliterumForgeFrameBtnCornerRight:Kill()
	ObliterumForgeFrameBotLeftCorner:Kill()
	ObliterumForgeFrameBotRightCorner:Kill()

    S:SetBD(ObliterumForgeFrame)
    S:ReskinClose(ObliterumForgeFrameCloseButton)
    S:Reskin(ObliterumForgeFrame.ObliterateButton)
end

S:AddCallbackForAddon('Blizzard_ObliterumUI', "Obliterum", LoadSkin)
