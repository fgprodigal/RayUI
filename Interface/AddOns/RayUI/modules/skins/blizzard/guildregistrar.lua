local R, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local S = R:GetModule("Skins")

local function LoadSkin()
    GuildRegistrarFrameTop:Hide()
    GuildRegistrarFrameBottom:Hide()
    GuildRegistrarFrameMiddle:Hide()
    select(19, GuildRegistrarFrame:GetRegions()):Hide()
    select(6, GuildRegistrarFrameEditBox:GetRegions()):Hide()
    select(7, GuildRegistrarFrameEditBox:GetRegions()):Hide()

    GuildRegistrarFrameEditBox:SetHeight(20)

    S:ReskinPortraitFrame(GuildRegistrarFrame, true)
    S:CreateBD(GuildRegistrarFrameEditBox, .25)
    S:Reskin(GuildRegistrarFrameGoodbyeButton)
    S:Reskin(GuildRegistrarFramePurchaseButton)
    S:Reskin(GuildRegistrarFrameCancelButton)
end

S:RegisterSkin("RayUI", LoadSkin)
