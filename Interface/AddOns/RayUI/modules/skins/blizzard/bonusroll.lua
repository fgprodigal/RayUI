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
	BonusRollFrame.BlackBackgroundHoist:Kill()
	BonusRollFrame.PromptFrame.Timer.Bar:SetTexture(S["media"].backdrop)
	-- BonusRollFrame.PromptFrame.Timer.Bar:SetVertexColor(1, 1, 1)
	BonusRollFrame.PromptFrame.Timer.border = CreateFrame("Frame", nil, BonusRollFrame.PromptFrame.Timer)
	BonusRollFrame.PromptFrame.Timer.border:SetFrameLevel(BonusRollFrame.PromptFrame.Timer:GetFrameLevel() - 1)
	BonusRollFrame.PromptFrame.Timer.border:SetOutside(BonusRollFrame.PromptFrame.Timer, 1, 1)
	S:CreateBD(BonusRollFrame.PromptFrame.Timer.border)

	BonusRollMoneyWonFrame:SetAlpha(1)
	BonusRollMoneyWonFrame.SetAlpha = R.dummy

	if not BonusRollMoneyWonFrame.bg then
		BonusRollMoneyWonFrame.bg = CreateFrame("Frame", nil, BonusRollMoneyWonFrame)
		BonusRollMoneyWonFrame.bg:SetPoint("TOPLEFT", BonusRollMoneyWonFrame, "TOPLEFT", 8, -8)
		BonusRollMoneyWonFrame.bg:SetPoint("BOTTOMRIGHT", BonusRollMoneyWonFrame, "BOTTOMRIGHT", -6, 8)
		BonusRollMoneyWonFrame.bg:SetFrameLevel(BonusRollMoneyWonFrame:GetFrameLevel()-1)

		-- Icon border
		if not BonusRollMoneyWonFrame.Icon.b then
			BonusRollMoneyWonFrame.Icon.b = S:CreateBG(BonusRollMoneyWonFrame.Icon)
		end

		BonusRollMoneyWonFrame:HookScript("OnEnter", function()
			S:CreateBD(BonusRollMoneyWonFrame.bg)
		end)

		BonusRollMoneyWonFrame.animIn:HookScript("OnFinished", function()
			S:CreateBD(BonusRollMoneyWonFrame.bg)
		end)
	end
	BonusRollMoneyWonFrame.Background:Kill()
	BonusRollMoneyWonFrame.Icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	BonusRollMoneyWonFrame.IconBorder:Kill()
end

S:RegisterSkin("RayUI", LoadSkin)