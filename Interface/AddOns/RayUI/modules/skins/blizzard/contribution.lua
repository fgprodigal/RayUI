local R, L, P, G = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, GlobalDB
local S = R:GetModule("Skins")

local function LoadSkin()
    local r, g, b = S["media"].classcolours[R.myclass].r, S["media"].classcolours[R.myclass].g, S["media"].classcolours[R.myclass].b

    local frame = ContributionCollectionFrame
	S:SetBD(frame)
	S:ReskinClose(frame.CloseButton)
	frame.CloseButton.CloseButtonBackground:Hide()
	frame.Background:Hide()

	hooksecurefunc(ContributionMixin, "SetupContributeButton", function(self)
		if not self.styled then
			S:Reskin(self.ContributeButton)

			self.styled = true
		end

        local statusBar = self.Status
		if statusBar and not statusBar.isSkinned then
			statusBar:StripTextures()
            local bg = CreateFrame("Frame", nil, statusBar)
            bg:SetPoint("TOPLEFT", 0, 1)
            bg:SetPoint("BOTTOMRIGHT", 0, -1)
            bg:SetFrameLevel(statusBar:GetFrameLevel()-1)
            S:CreateBD(bg, .3)

			statusBar.isSkinned = true
		end
	end)

	hooksecurefunc(ContributionMixin, "FindOrAcquireReward", function(self, rewardID)
		local reward = self.rewards[rewardID]
		if not reward.styled then
			reward.RewardName:SetTextColor(1, 1, 1)
			reward.Icon:SetTexCoord(.08, .92, .08, .92)
			reward.Border:Hide()
			S:CreateBG(reward.Icon)

			reward.styled = true
		end
	end)

    -- Tooltip
    for _, tooltip in pairs({ContributionBuffTooltip, ContributionTooltip}) do
        tooltip:StripTextures()
        tooltip:CreateShadow("Background")
        if tooltip.Icon then
            S:ReskinIcon(tooltip.Icon)
        end
        if tooltip.ItemTooltip then
		    tooltip.ItemTooltip.IconBorder:Kill()
            S:ReskinIcon(tooltip.ItemTooltip.Icon)
        end
	end
end

S:AddCallbackForAddon("Blizzard_Contribution", "Contribution", LoadSkin)
