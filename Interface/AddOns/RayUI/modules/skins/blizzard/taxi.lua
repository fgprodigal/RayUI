local R, L, P = unpack(select(2, ...)) --Inport: Engine, Locales, ProfileDB
local S = R:GetModule("Skins")

local function LoadSkin()
    TaxiFrame:DisableDrawLayer("BORDER")
    TaxiFrame:DisableDrawLayer("OVERLAY")
    TaxiFrame.Bg:Hide()
    TaxiFrame.TitleBg:Hide()

    S:SetBD(TaxiFrame, 3, -23, -5, 3)
    S:ReskinClose(TaxiFrame.CloseButton, "TOPRIGHT", TaxiRouteMap, "TOPRIGHT", -4, -4)
end

S:RegisterSkin("RayUI", LoadSkin)
