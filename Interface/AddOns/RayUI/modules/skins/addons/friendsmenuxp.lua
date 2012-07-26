local R, L, P = unpack(select(2, ...)) --Inport: Engine, Locales, ProfileDB
local S = R:GetModule("Skins")

local function SkinFriendsMenuXP()
	if FriendsMenuXPSecure then
		FriendsMenuXPSecureMenuBackdrop:StripTextures()
		S:CreateBD(FriendsMenuXPSecureMenuBackdrop)
	end
end

S:RegisterSkin("RayUI", SkinFriendsMenuXP)