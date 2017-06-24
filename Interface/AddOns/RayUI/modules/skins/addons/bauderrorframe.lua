----------------------------------------------------------
-- Load RayUI Environment
----------------------------------------------------------
RayUI:LoadEnv("Skins")


local S = _Skins

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
