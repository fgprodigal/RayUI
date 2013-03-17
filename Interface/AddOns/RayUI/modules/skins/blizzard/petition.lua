local R, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local S = R:GetModule("Skins")

local function LoadSkin()
    select(18, PetitionFrame:GetRegions()):Hide()
    select(19, PetitionFrame:GetRegions()):Hide()
    select(23, PetitionFrame:GetRegions()):Hide()
    select(24, PetitionFrame:GetRegions()):Hide()
    PetitionFrameTop:Hide()
    PetitionFrameBottom:Hide()
    PetitionFrameMiddle:Hide()

    S:ReskinPortraitFrame(PetitionFrame, true)
    S:Reskin(PetitionFrameSignButton)
    S:Reskin(PetitionFrameRequestButton)
    S:Reskin(PetitionFrameRenameButton)
    S:Reskin(PetitionFrameCancelButton)
end

S:RegisterSkin("RayUI", LoadSkin)
