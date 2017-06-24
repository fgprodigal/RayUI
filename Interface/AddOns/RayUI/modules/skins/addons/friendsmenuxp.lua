----------------------------------------------------------
-- Load RayUI Environment
----------------------------------------------------------
RayUI:LoadEnv("Skins")


local S = _Skins

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
