local R, L, P = unpack(select(2, ...)) --Inport: Engine, Locales, ProfileDB
local S = R:GetModule("Skins")

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

	GuildControlUIRankSettingsFrameChatBg:SetAlpha(0)
	GuildControlUIRankSettingsFrameRosterBg:SetAlpha(0)
	GuildControlUIRankSettingsFrameInfoBg:SetAlpha(0)
	GuildControlUIRankSettingsFrameBankBg:SetAlpha(0)
	GuildControlUITopBg:Hide()
	GuildControlUIHbar:Hide()
	GuildControlUIRankBankFrameInsetScrollFrameTop:SetAlpha(0)
	GuildControlUIRankBankFrameInsetScrollFrameBottom:SetAlpha(0)

	hooksecurefunc("GuildControlUI_RankOrder_Update", function()
		if not reskinnedranks then
			for i = 1, GuildControlGetNumRanks() do
				S:ReskinInput(_G["GuildControlUIRankOrderFrameRank"..i.."NameEditBox"], 20)
			end
			reskinnedranks = true
		end
	end)

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

S:RegisterSkin("Blizzard_GuildControlUI", LoadSkin)