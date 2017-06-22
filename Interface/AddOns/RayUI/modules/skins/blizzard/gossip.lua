----------------------------------------------------------
-- Load RayUI Environment
----------------------------------------------------------
RayUI:LoadEnv("Skins")


local S = _Skins

local function LoadSkin()
	S:SetBD(GossipFrame)

	GossipFrame:DisableDrawLayer("BORDER")
	GossipFrameInset:DisableDrawLayer("BORDER")
	GossipFrameInsetBg:Hide()
	GossipGreetingScrollFrameTop:Hide()
	GossipGreetingScrollFrameBottom:Hide()
	GossipGreetingScrollFrameMiddle:Hide()

	for i = 1, 7 do
		select(i, GossipFrame:GetRegions()):Hide()
	end
	select(19, GossipFrame:GetRegions()):Hide()

	GossipGreetingText:SetTextColor(1, 1, 1)

	S:ReskinScroll(GossipGreetingScrollFrameScrollBar)

	GreetingText:SetTextColor(1, 1, 1)
	GreetingText.SetTextColor = R.dummy

	S:Reskin(GossipFrameGreetingGoodbyeButton)
	S:ReskinClose(GossipFrameCloseButton)
	hooksecurefunc("GossipFrameUpdate", function()
		for i=1, NUMGOSSIPBUTTONS do
			local text = _G["GossipTitleButton" .. i]:GetText()
			if text then
				text = string.gsub(text, "|cff......", "|cffffffff")
				_G["GossipTitleButton" .. i]:SetText(text)
			end
		end
	end)

	ItemTextFrame:StripTextures(true)
	ItemTextScrollFrameScrollBar:StripTextures()
	InboxFrameBg:Hide()
	ItemTextPrevPageButton:GetRegions():Hide()
	ItemTextNextPageButton:GetRegions():Hide()
	ItemTextMaterialTopLeft:SetAlpha(0)
	ItemTextMaterialTopRight:SetAlpha(0)
	ItemTextMaterialBotLeft:SetAlpha(0)
	ItemTextMaterialBotRight:SetAlpha(0)

	S:ReskinPortraitFrame(ItemTextFrame, true)
	S:ReskinScroll(ItemTextScrollFrameScrollBar)
	S:ReskinArrow(ItemTextPrevPageButton, "left")
	S:ReskinArrow(ItemTextNextPageButton, "right")

	ItemTextPageText:SetTextColor(1, 1, 1)
	ItemTextPageText.SetTextColor = R.dummy

    NPCFriendshipStatusBar:GetRegions():Hide()
    NPCFriendshipStatusBarNotch1:SetColorTexture(0, 0, 0)
    NPCFriendshipStatusBarNotch1:Size(1, 16)
    NPCFriendshipStatusBarNotch2:SetColorTexture(0, 0, 0)
    NPCFriendshipStatusBarNotch2:Size(1, 16)
    NPCFriendshipStatusBarNotch3:SetColorTexture(0, 0, 0)
    NPCFriendshipStatusBarNotch3:Size(1, 16)
    NPCFriendshipStatusBarNotch4:SetColorTexture(0, 0, 0)
    NPCFriendshipStatusBarNotch4:Size(1, 16)
    select(7, NPCFriendshipStatusBar:GetRegions()):Hide()

    NPCFriendshipStatusBar.icon:SetPoint("TOPLEFT", -30, 7)
    NPCFriendshipStatusBar.bd = CreateFrame("Frame", nil, NPCFriendshipStatusBar)
    NPCFriendshipStatusBar.bd:SetOutside(nil, 1, 1)
    NPCFriendshipStatusBar.bd:SetFrameLevel(NPCFriendshipStatusBar:GetFrameLevel() - 1)
    S:CreateBD(NPCFriendshipStatusBar.bd, .25)
end

S:AddCallback("Gossip", LoadSkin)
