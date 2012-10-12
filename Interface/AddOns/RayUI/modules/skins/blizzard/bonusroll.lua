local R, L, P = unpack(select(2, ...)) --Inport: Engine, Locales, ProfileDB
local S = R:GetModule("Skins")

local function LoadSkin()
	BonusRollFrame:StripTextures()
	S:CreateBD(BonusRollFrame)
	BonusRollFrame.PromptFrame.Icon:SetTexCoord(.08, .92, .08, .92)
	BonusRollFrame.PromptFrame.IconBackdrop = CreateFrame("Frame", nil, BonusRollFrame.PromptFrame)
	BonusRollFrame.PromptFrame.IconBackdrop:SetFrameLevel(BonusRollFrame.PromptFrame.IconBackdrop:GetFrameLevel() - 1)
	BonusRollFrame.PromptFrame.IconBackdrop:SetOutside(BonusRollFrame.PromptFrame.Icon, 1, 1)
	S:CreateBD(BonusRollFrame.PromptFrame.IconBackdrop)
	BonusRollFrame.PromptFrame.Timer.Bar:SetTexture(S["media"].backdrop)
	BonusRollFrame.PromptFrame.Timer.Bar:SetVertexColor(1, 1, 1)
end

S:RegisterSkin("RayUI", LoadSkin)