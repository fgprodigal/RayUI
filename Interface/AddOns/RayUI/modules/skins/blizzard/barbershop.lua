local R, L, P = unpack(select(2, ...)) --Inport: Engine, Locales, ProfileDB
local S = R:GetModule("Skins")

local function LoadSkin()
	S:SetBD(BarberShopFrame, 44, -75, -40, 44)
	BarberShopFrameBackground:Hide()
	BarberShopFrameMoneyFrame:GetRegions():Hide()
	S:Reskin(BarberShopFrameOkayButton)
	S:Reskin(BarberShopFrameCancelButton)
	S:Reskin(BarberShopFrameResetButton)
	S:ReskinArrow(BarberShopFrameSelector1Prev, "left")
	S:ReskinArrow(BarberShopFrameSelector1Next, "right")
	S:ReskinArrow(BarberShopFrameSelector2Prev, "left")
	S:ReskinArrow(BarberShopFrameSelector2Next, "right")
	S:ReskinArrow(BarberShopFrameSelector3Prev, "left")
	S:ReskinArrow(BarberShopFrameSelector3Next, "right")
	S:ReskinArrow(BarberShopFrameSelector4Prev, "left")
	S:ReskinArrow(BarberShopFrameSelector4Next, "right")
end

S:RegisterSkin("Blizzard_BarbershopUI", LoadSkin)