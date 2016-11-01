local R, L, P, G = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, GlobalDB
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
