local R, L, P = unpack(select(2, ...)) --Inport: Engine, Locales, ProfileDB
local S = R:GetModule("Skins")

local function SkinFriendsMenuXP()
	if FriendsMenuXPSecure then
		FriendsMenuXPSecureMenuBackdrop:StripTextures()
		FriendsMenuXPSecureMenuBackdrop:SetBackdrop( { 
			edgeFile = R["media"].glow,
			bgFile = R["media"].blank,
			edgeSize = R:Scale(4),
			insets = {left = R:Scale(4), right = R:Scale(4), top = R:Scale(4), bottom = R:Scale(4)},
		})
		FriendsMenuXPSecureMenuBackdrop:SetBackdropColor(0, 0, 0, 0.65)
		FriendsMenuXPSecureMenuBackdrop:SetBackdropBorderColor(0, 0, 0)
	end
end

S:RegisterSkin("RayUI", SkinFriendsMenuXP)