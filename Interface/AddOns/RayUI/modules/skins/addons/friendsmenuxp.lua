local R, L, P, G = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, GlobalDB
local S = R:GetModule("Skins")

local function SkinFriendsMenuXP()
	if FriendsMenuXPSecure then
		FriendsMenuXPSecureMenuBackdrop:StripTextures()
        S:CreateBD(FriendsMenuXPSecureMenuBackdrop)
		S:CreateStripesThin(FriendsMenuXPSecureMenuBackdrop)
	end
	if FriendsMenuXP then
		FriendsMenuXPMenuBackdrop:StripTextures()
        S:CreateBD(FriendsMenuXPMenuBackdrop)
		S:CreateStripesThin(FriendsMenuXPMenuBackdrop)
	end
end

S:AddCallback("FriendsMenuXP", SkinFriendsMenuXP)
