local R, L, P = unpack(select(2, ...)) --Inport: Engine, Locales, ProfileDB
local S = R:GetModule("Skins")

local function LoadSkin()
	S:SetBD(BarberShopFrame, 44, -75, -40, 44)
	BarberShopFrameBackground:Hide()
	BarberShopFrameMoneyFrame:GetRegions():Hide()
	S:Reskin(BarberShopFrameOkayButton)
	S:Reskin(BarberShopFrameCancelButton)
	S:Reskin(BarberShopFrameResetButton)
	S:ReskinArrow(BarberShopFrameSelector1Prev, 1)
	S:ReskinArrow(BarberShopFrameSelector1Next, 2)
	S:ReskinArrow(BarberShopFrameSelector2Prev, 1)
	S:ReskinArrow(BarberShopFrameSelector2Next, 2)
	S:ReskinArrow(BarberShopFrameSelector3Prev, 1)
	S:ReskinArrow(BarberShopFrameSelector3Next, 2)
	S:ReskinArrow(BarberShopFrameSelector4Prev, 1)
	S:ReskinArrow(BarberShopFrameSelector4Next, 2)
end

S:RegisterSkin("Blizzard_BarbershopUI", LoadSkin)