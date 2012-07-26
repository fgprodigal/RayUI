local R, L, P = unpack(select(2, ...)) --Inport: Engine, Locales, ProfileDB
local S = R:GetModule("Skins")

local function LoadSkin()
	S:SetBD(GossipFrame, 6, -15, -26, 64)
	GossipFramePortrait:Hide()
	GossipFrameGreetingPanel:DisableDrawLayer("BACKGROUND")
	GossipFrameGreetingPanel:DisableDrawLayer("ARTWORK")

	GreetingText:SetTextColor(1, 1, 1)
	GreetingText.SetTextColor = R.dummy

	S:Reskin(GossipFrameGreetingGoodbyeButton)
	S:ReskinScroll(GossipGreetingScrollFrameScrollBar)
	S:ReskinClose(GossipFrameCloseButton, "TOPRIGHT", GossipFrame, "TOPRIGHT", -30, -20)
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

	S:ReskinArrow(ItemTextPrevPageButton, 1)
	S:ReskinArrow(ItemTextNextPageButton, 2)
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
	S:ReskinClose(ItemTextCloseButton, "TOPRIGHT", ItemTextFrame, "TOPRIGHT", -32, -12)
end

S:RegisterSkin("RayUI", LoadSkin)