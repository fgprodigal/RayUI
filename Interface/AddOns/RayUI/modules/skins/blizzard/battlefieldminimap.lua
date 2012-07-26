local R, L, P = unpack(select(2, ...)) --Inport: Engine, Locales, ProfileDB
local S = R:GetModule("Skins")

local function LoadSkin()
	S:SetBD(BattlefieldMinimap, -1, 1, -5, 3)
	BattlefieldMinimapCorner:Hide()
	BattlefieldMinimapBackground:Hide()
	BattlefieldMinimapCloseButton:Hide()
end

S:RegisterSkin("Blizzard_BattlefieldMinimap", LoadSkin)