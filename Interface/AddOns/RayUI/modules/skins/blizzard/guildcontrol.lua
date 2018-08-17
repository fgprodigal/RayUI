----------------------------------------------------------
-- Load RayUI Environment
----------------------------------------------------------
RayUI:LoadEnv("Skins")


local S = _Skins

local function LoadSkin()
	S:CreateBD(GuildControlUI)
	S:CreateSD(GuildControlUI)
	S:CreateBD(GuildControlUIRankBankFrameInset, .25)

	for i = 1, 9 do
		select(i, GuildControlUI:GetRegions()):Hide()
	end

	for i = 1, 8 do
		select(i, GuildControlUIRankBankFrameInset:GetRegions()):Hide()
	end

	GuildControlUIRankSettingsFrameOfficerBg:SetAlpha(0)
	GuildControlUIRankSettingsFrameRosterBg:SetAlpha(0)
	GuildControlUIRankSettingsFrameBankBg:SetAlpha(0)
	GuildControlUITopBg:Hide()
	GuildControlUIHbar:Hide()
	GuildControlUIRankBankFrameInsetScrollFrameTop:SetAlpha(0)
	GuildControlUIRankBankFrameInsetScrollFrameBottom:SetAlpha(0)

	do
		local function updateGuildRanks()
			for i = 1, GuildControlGetNumRanks() do
				local rank = _G["GuildControlUIRankOrderFrameRank"..i]
				if not rank.styled then
					rank.upButton.icon:Hide()
					rank.downButton.icon:Hide()
					rank.deleteButton.icon:Hide()

					S:ReskinArrow(rank.upButton, "up")
					S:ReskinArrow(rank.downButton, "down")
					S:ReskinClose(rank.deleteButton)

					S:ReskinInput(rank.nameBox, 20)

					rank.styled = true
				end
			end
		end

		local f = CreateFrame("Frame")
		f:RegisterEvent("GUILD_RANKS_UPDATE")
		f:SetScript("OnEvent", updateGuildRanks)
		hooksecurefunc("GuildControlUI_RankOrder_Update", updateGuildRanks)
	end

	hooksecurefunc("GuildControlUI_BankTabPermissions_Update", function()
		for i = 1, GetNumGuildBankTabs()+1 do
			local tab = "GuildControlBankTab"..i
			local bu = _G[tab]
			if bu and not bu.reskinned then
				_G[tab.."Bg"]:Hide()
				S:CreateBD(bu, .12)
				S:Reskin(_G[tab.."BuyPurchaseButton"])
				S:ReskinInput(_G[tab.."OwnedStackBox"])

				bu.reskinned = true
			end
		end
	end)

	S:Reskin(GuildControlUIRankOrderFrameNewButton)

	S:ReskinClose(GuildControlUICloseButton)
	S:ReskinScroll(GuildControlUIRankBankFrameInsetScrollFrameScrollBar)
	S:ReskinDropDown(GuildControlUINavigationDropDown)
	S:ReskinDropDown(GuildControlUIRankSettingsFrameRankDropDown)
	S:ReskinDropDown(GuildControlUIRankBankFrameRankDropDown)
    S:ReskinInput(GuildControlUIRankSettingsFrameGoldBox, 20)
end

S:AddCallbackForAddon("Blizzard_GuildControlUI", "GuildControl", LoadSkin)