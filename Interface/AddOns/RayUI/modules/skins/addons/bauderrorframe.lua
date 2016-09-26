local R, L, P, G = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, GlobalDB
local S = R:GetModule("Skins")

local function SkinBaudErrorFrame()
	S:CreateBD(BaudErrorFrame)
	S:CreateSD(BaudErrorFrame, 1, 4)
	S:Reskin(BaudErrorFrameClearButton)
	S:Reskin(BaudErrorFrameCloseButton)
	S:Reskin(BaudErrorFrameReloadUIButton)
	S:ReskinScroll(BaudErrorFrameDetailScrollFrameScrollBar)
end

S:AddCallbackForAddon("!BaudErrorFrame", "BaudErrorFrame", SkinBaudErrorFrame)