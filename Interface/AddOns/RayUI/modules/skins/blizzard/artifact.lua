local R, L, P, G = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, GlobalDB, GlobalDB
local S = R:GetModule("Skins")

local function LoadSkin()
	ArtifactFrame:StripTextures()
	S:CreateBD(ArtifactFrame)
	ArtifactFrame.BorderFrame:StripTextures()
	S:ReskinClose(ArtifactFrame.CloseButton)
	
	for i = 1, 2 do
		S:CreateTab(_G["ArtifactFrameTab" .. i])
	end
	
	ArtifactFrameTab1:ClearAllPoints()
	ArtifactFrameTab1:SetPoint("TOPLEFT", ArtifactFrame, "BOTTOMLEFT", 0, 0)
end

S:RegisterSkin("Blizzard_ArtifactUI", LoadSkin)