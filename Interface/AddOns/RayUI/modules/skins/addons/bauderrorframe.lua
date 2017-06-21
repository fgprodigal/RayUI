----------------------------------------------------------
-- Load RayUI Environment
----------------------------------------------------------
_LoadRayUIEnv_()


local S = R:GetModule("Skins")

local function SkinBaudErrorFrame()
	BaudErrorFrame:StripTextures()
	S:SetBD(BaudErrorFrame)
	S:Reskin(BaudErrorFrameClearButton)
	S:Reskin(BaudErrorFrameCloseButton)
	S:Reskin(BaudErrorFrameReloadUIButton)
	S:ReskinScroll(BaudErrorFrameDetailScrollFrameScrollBar)
	S:ReskinScroll(BaudErrorFrameListScrollBoxScrollBarScrollBar)
end

S:AddCallbackForAddon("!BaudErrorFrame", "BaudErrorFrame", SkinBaudErrorFrame)
