local R, L, P = unpack(select(2, ...)) --Inport: Engine, Locales, ProfileDB
local S = R:GetModule("Skins")

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
				text = string.gsub(text,"|cFF0008E8","|cFF0080FF")
				_G["GossipTitleButton" .. i]:SetText(text)
			end
		end
	end)

	S:SetBD(ItemTextFrame, 16, -8, -28, 62)
	ItemTextFrame:DisableDrawLayer("BORDER")

	ItemTextPageText:SetTextColor(1, 1, 1)
	ItemTextPageText.SetTextColor = R.dummy

	S:ReskinArrow(ItemTextPrevPageButton, "left")
	S:ReskinArrow(ItemTextNextPageButton, "right")
	ItemTextPrevPageButton:GetRegions():Hide()
	ItemTextNextPageButton:GetRegions():Hide()
	ItemTextFrame:GetRegions():Hide()
	ItemTextScrollFrameMiddle:Hide()
	ItemTextScrollFrameTop:Hide()
	ItemTextScrollFrameBottom:Hide()
	ItemTextMaterialTopLeft:SetAlpha(0)
	ItemTextMaterialTopRight:SetAlpha(0)
	ItemTextMaterialBotLeft:SetAlpha(0)
	ItemTextMaterialBotRight:SetAlpha(0)
end

S:RegisterSkin("RayUI", LoadSkin)