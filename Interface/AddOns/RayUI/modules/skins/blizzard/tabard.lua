local R, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local S = R:GetModule("Skins")

local function LoadSkin()
	TabardFrameMoneyInset:DisableDrawLayer("BORDER")
    TabardFrameCustomizationBorder:Hide()
    TabardFrameMoneyBg:Hide()
    TabardFrameMoneyInsetBg:Hide()

    for i = 19, 28 do
        select(i, TabardFrame:GetRegions()):Hide()
    end

    for i = 1, 5 do
        _G["TabardFrameCustomization"..i.."Left"]:Hide()
        _G["TabardFrameCustomization"..i.."Middle"]:Hide()
        _G["TabardFrameCustomization"..i.."Right"]:Hide()
        S:ReskinArrow(_G["TabardFrameCustomization"..i.."LeftButton"], "left")
        S:ReskinArrow(_G["TabardFrameCustomization"..i.."RightButton"], "right")
    end

    S:ReskinPortraitFrame(TabardFrame, true)
    S:CreateBD(TabardFrameCostFrame, .25)
    S:Reskin(TabardFrameAcceptButton)
    S:Reskin(TabardFrameCancelButton)
end

S:RegisterSkin("RayUI", LoadSkin)
