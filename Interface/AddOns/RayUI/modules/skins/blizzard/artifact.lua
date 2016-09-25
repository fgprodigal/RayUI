local R, L, P, G = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, GlobalDB
local S = R:GetModule("Skins")

local function LoadSkin()
	S:SetBD(ArtifactFrame)
	ArtifactFrame.Background:Hide()
	ArtifactFrame.PerksTab.HeaderBackground:Hide()
	ArtifactFrame.PerksTab.BackgroundBackShadow:Hide()
	ArtifactFrame.PerksTab.BackgroundBack:Hide()
	ArtifactFrame.PerksTab.TitleContainer.Background:SetAlpha(0)
	ArtifactFrame.PerksTab.Model.BackgroundFront:Hide()
	ArtifactFrame.PerksTab.Model:SetAlpha(.2)
	ArtifactFrame.PerksTab.AltModel:SetAlpha(.2)
	ArtifactFrame.BorderFrame:Hide()
	ArtifactFrame.ForgeBadgeFrame.ForgeClassBadgeIcon:Hide()
	ArtifactFrame.ForgeBadgeFrame.ForgeLevelBackground:ClearAllPoints()
	ArtifactFrame.ForgeBadgeFrame.ForgeLevelBackground:SetPoint("TOPLEFT", ArtifactFrame, "TOPLEFT", 5, -5 )
	ArtifactFrame.AppearancesTab.Background:Hide()

	S:ReskinClose(ArtifactFrame.CloseButton)

	for i = 1, 2 do
		S:CreateTab(_G["ArtifactFrameTab"..i])
	end
	ArtifactFrameTab1:SetPoint("TOPLEFT", ArtifactFrame, "BOTTOMLEFT", 20, 3)
	
	ArtifactFrame.AppearancesTab:HookScript("OnShow", function()
		for i = 1, 20 do
			local bu = select(i, ArtifactFrame.AppearancesTab:GetChildren())
			if bu then
				bu.Background:Hide()
				if bu:GetWidth() > 400 then
					S:CreateGradient(bu)
					S:CreateBD(bu, 0)
					bu.Name:SetTextColor(1, 1, 1)
				else
					bu.Border:SetAlpha(0)
					bu.HighlightTexture:Hide()
					bu.Selected:SetAlpha(0)
					bu.Selected.SetAlpha = R.dummy
				end
			end
		end
	end)
	 
	hooksecurefunc(ArtifactFrame.AppearancesTab, "Refresh", function()
		for i = 1, 20 do
			local bu = select(i, ArtifactFrame.AppearancesTab:GetChildren())
			if bu and bu.bg then
				if bu.Selected:IsShown() then
					bu.bg:SetBackdropBorderColor(1, 1, 0)
				else
					bu.bg:SetBackdropBorderColor(0, 0, 0)
				end
			end
		end
	end)
	
	S:CreateTab(ArtifactFrame.PerksTabButton)
	S:CreateTab(ArtifactFrame.AppearancesTabButton)
	
	ArtifactFrame.PerksTabButton:ClearAllPoints()
	ArtifactFrame.PerksTabButton:SetPoint("TOPLEFT", ArtifactFrame, "BOTTOMLEFT", 11, 2)
end

S:AddCallbackForAddon("Blizzard_ArtifactUI", "Artifact", LoadSkin)
