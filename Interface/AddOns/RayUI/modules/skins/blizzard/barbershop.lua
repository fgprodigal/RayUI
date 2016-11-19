local R, L, P, G = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, GlobalDB
local S = R:GetModule("Skins")

local function LoadSkin()
    local BarberShopFrame = BarberShopFrame
    for i = 1, BarberShopFrame:GetNumRegions() do
        local region = select(i, BarberShopFrame:GetRegions())
        region:Hide()
    end
    S:SetBD(BarberShopFrame, 44, -75, -40, 44)
    S:SetBD(BarberShopAltFormFrame, 0, 0, 2, -2)

    for i = 1, #BarberShopFrame.Selector do
        local prevBtn, nextBtn = BarberShopFrame.Selector[i]:GetChildren()
        S:ReskinArrow(prevBtn, "left")
        S:ReskinArrow(nextBtn, "right")
    end

    BarberShopFrameMoneyFrame:GetRegions():Hide()
    S:Reskin(BarberShopFrameOkayButton)
    S:Reskin(BarberShopFrameCancelButton)
    S:Reskin(BarberShopFrameResetButton)

    BarberShopAltFormFrame:ClearAllPoints()
    BarberShopAltFormFrame:SetPoint("BOTTOM", BarberShopFrame, "TOP", 0, -74)
    BarberShopAltFormFrameBackground:Hide()
    BarberShopAltFormFrameBorder:Hide()

    -- [[ Banner frame ]]

    BarberShopBannerFrameBGTexture:Hide()

    S:SetBD(BarberShopBannerFrame, 25, -80, -20, 75)
end

S:AddCallbackForAddon("Blizzard_BarbershopUI", "Barbershop", LoadSkin)
