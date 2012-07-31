local R, L, P = unpack(select(2, ...)) --Inport: Engine, Locales, ProfileDB
local S = R:GetModule("Skins")

local function LoadSkin()
	S:SetBD(TabardFrame, 10, -12, -34, 74)
	TabardFramePortrait:Hide()
	TabardFrame:DisableDrawLayer("BORDER")
	TabardFrame:DisableDrawLayer("ARTWORK")
	TabardCharacterModelRotateRightButton:SetPoint("TOPLEFT", TabardCharacterModelRotateLeftButton, "TOPRIGHT", 1, 0)
	S:Reskin(TabardFrameAcceptButton)
	S:Reskin(TabardFrameCancelButton)
	S:ReskinClose(TabardFrameCloseButton, "TOPRIGHT", TabardFrame, "TOPRIGHT", -38, -16)
	for i = 7, 16 do
		select(i, TabardFrame:GetRegions()):Hide()
	end
	TabardFrameCustomizationBorder:Hide()
	for i = 1, 5 do
		_G["TabardFrameCustomization"..i.."Left"]:Hide()
		_G["TabardFrameCustomization"..i.."Middle"]:Hide()
		_G["TabardFrameCustomization"..i.."Right"]:Hide()
	end
	S:ReskinArrow(TabardCharacterModelRotateLeftButton, "left")
	S:ReskinArrow(TabardCharacterModelRotateRightButton, "right")
	for i = 1, 5 do
		S:ReskinArrow(_G["TabardFrameCustomization"..i.."LeftButton"], "left")
		S:ReskinArrow(_G["TabardFrameCustomization"..i.."RightButton"], "right")
	end
end

S:RegisterSkin("RayUI", LoadSkin)