----------------------------------------------------------
-- Load RayUI Environment
----------------------------------------------------------
_LoadRayUIEnv_()


local S = R:GetModule("Skins")

local function LoadSkin()
	S:SetBD(BattlefieldMinimap, -1, 1, -5, 3)
	BattlefieldMinimapCorner:Hide()
	BattlefieldMinimapBackground:Hide()
	BattlefieldMinimapCloseButton:Hide()
end

S:AddCallbackForAddon("Blizzard_BattlefieldMinimap", "BattlefieldMinimap", LoadSkin)