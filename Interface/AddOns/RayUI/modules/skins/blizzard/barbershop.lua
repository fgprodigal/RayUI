local R, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local S = R:GetModule("Skins")

local function LoadSkin()
	BarberShopFrame:GetRegions():Hide()
	BarberShopFrameMoneyFrame:GetRegions():Hide()
	BarberShopAltFormFrameBackground:Hide()
	BarberShopAltFormFrameBorder:Hide()

	BarberShopAltFormFrame:ClearAllPoints()
	BarberShopAltFormFrame:SetPoint("BOTTOM", BarberShopFrame, "TOP", 0, -74)

	S:SetBD(BarberShopFrame, 44, -75, -40, 44)
	S:SetBD(BarberShopAltFormFrame, 0, 0, 2, -2)

	S:Reskin(BarberShopFrameOkayButton)
	S:Reskin(BarberShopFrameCancelButton)
	S:Reskin(BarberShopFrameResetButton)

	for i = 1, 5 do
		S:ReskinArrow(_G["BarberShopFrameSelector"..i.."Prev"], "left")
		S:ReskinArrow(_G["BarberShopFrameSelector"..i.."Next"], "right")
	end

	-- [[ Banner frame ]]

	BarberShopBannerFrameBGTexture:Hide()

	S:SetBD(BarberShopBannerFrame, 25, -80, -20, 75)
end

S:RegisterSkin("Blizzard_BarbershopUI", LoadSkin)