local R, L, P = unpack(select(2, ...)) --Inport: Engine, Locales, ProfileDB
local S = R:GetModule("Skins")

local function LoadSkin()
	S:SetBD(TaxiFrame, 3, -23, -5, 3)
	TaxiFrame:DisableDrawLayer("BORDER")
	TaxiFrame:DisableDrawLayer("OVERLAY")
end

S:RegisterSkin("RayUI", LoadSkin)