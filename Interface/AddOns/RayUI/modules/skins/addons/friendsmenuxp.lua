local R, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local S = R:GetModule("Skins")

local function SkinFriendsMenuXP()
	if FriendsMenuXPSecure then
		FriendsMenuXPSecureMenuBackdrop:StripTextures()
        S:CreateBD(FriendsMenuXPSecureMenuBackdrop)
	end
	if FriendsMenuXP then
		FriendsMenuXPMenuBackdrop:StripTextures()
        S:CreateBD(FriendsMenuXPMenuBackdrop)
	end
end

S:RegisterSkin("RayUI", SkinFriendsMenuXP)
