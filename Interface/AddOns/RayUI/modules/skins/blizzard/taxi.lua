local R, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local S = R:GetModule("Skins")

local function LoadSkin()
    TaxiFrame:DisableDrawLayer("BORDER")
    TaxiFrame:DisableDrawLayer("OVERLAY")
    TaxiFrame.Bg:Hide()
    TaxiFrame.TitleBg:Hide()
    TaxiFrame.TopTileStreaks:Hide()

    S:SetBD(TaxiFrame, 3, -23, -5, 3)
    S:ReskinClose(TaxiFrame.CloseButton, "TOPRIGHT", TaxiRouteMap, "TOPRIGHT", -4, -4)
end

S:RegisterSkin("RayUI", LoadSkin)
