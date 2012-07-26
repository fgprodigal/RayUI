local R, L, P = unpack(select(2, ...)) --Inport: Engine, Locales, ProfileDB
local S = R:GetModule("Skins")

local function LoadSkin()
	S:SetBD(PetitionFrame, 6, -15, -26, 64)
	PetitionFramePortrait:Hide()
	PetitionFrameCharterTitle:SetTextColor(1, 1, 1)
	PetitionFrameCharterTitle:SetShadowColor(0, 0, 0)
	PetitionFrameMasterTitle:SetTextColor(1, 1, 1)
	PetitionFrameMasterTitle:SetShadowColor(0, 0, 0)
	PetitionFrameMemberTitle:SetTextColor(1, 1, 1)
	PetitionFrameMemberTitle:SetShadowColor(0, 0, 0)
	for i = 2, 5 do
		select(i, PetitionFrame:GetRegions()):Hide()
	end
	S:Reskin(PetitionFrameSignButton)
	S:Reskin(PetitionFrameRequestButton)
	S:Reskin(PetitionFrameRenameButton)
	S:Reskin(PetitionFrameCancelButton)
	S:ReskinClose(PetitionFrameCloseButton, "TOPRIGHT", PetitionFrame, "TOPRIGHT", -30, -20)
end

S:RegisterSkin("RayUI", LoadSkin)