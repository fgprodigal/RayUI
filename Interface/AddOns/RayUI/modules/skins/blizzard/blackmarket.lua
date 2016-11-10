local R, L, P, G = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, GlobalDB
local S = R:GetModule("Skins")

local function LoadSkin()
	BlackMarketFrame:StripTextures()
	BlackMarketFrame.Inset:StripTextures()
	BlackMarketFrame.MoneyFrameBorder:StripTextures()

	BlackMarketFrame.HotDeal:StripTextures()
	BlackMarketFrame.HotDeal.Item.IconBorder:Kill()
	BlackMarketFrame.HotDeal.Item.IconTexture:SetTexCoord(.08, .92, .08, .92)
	BlackMarketFrame.HotDeal.Item:StyleButton(true)
	S:CreateBG(BlackMarketFrame.HotDeal.Item)

	local headers = {"ColumnName", "ColumnLevel", "ColumnType", "ColumnDuration", "ColumnHighBidder", "ColumnCurrentBid"}
	for _, header in pairs(headers) do
		local header = BlackMarketFrame[header]
		header.Left:Hide()
		header.Middle:Hide()
		header.Right:Hide()

		local bg = CreateFrame("Frame", nil, header)
		bg:Point("TOPLEFT", 2, 0)
		bg:Point("BOTTOMRIGHT", -1, 0)
		bg:SetFrameLevel(header:GetFrameLevel()-1)
		S:CreateBD(bg, .25)
	end

	S:SetBD(BlackMarketFrame)
	S:CreateBD(BlackMarketFrame.HotDeal, .25)
	S:Reskin(BlackMarketFrame.BidButton)
	S:ReskinClose(BlackMarketFrame.CloseButton)
	S:ReskinInput(BlackMarketBidPriceGold)
	S:ReskinScroll(BlackMarketScrollFrameScrollBar)

    local function UpdateBlackMarketList()
        local scrollFrame = BlackMarketScrollFrame
        local offset = HybridScrollFrame_GetOffset(scrollFrame)
		local buttons = scrollFrame.buttons
        local numButtons = #buttons

		for i = 1, numButtons do
            local index = i + offset
			local bu = buttons[i]

            bu.Item.IconTexture:SetTexCoord(.08, .92, .08, .92)
            if not bu.reskinned then
				bu.Item.IconBorder:Kill()
                bu.Left:Hide()
                bu.Right:Hide()
                select(3, bu:GetRegions()):Hide()

                bu.Item:SetNormalTexture("")
                S:CreateBG(bu.Item)

                local bg = CreateFrame("Frame", nil, bu)
                bg:SetPoint("TOPLEFT")
                bg:SetPoint("BOTTOMRIGHT", 0, 5)
                bg:SetFrameLevel(bu:GetFrameLevel()-1)
                S:CreateBD(bg, 0)

                local tex = bu:CreateTexture(nil, "BACKGROUND")
                tex:SetPoint("TOPLEFT")
                tex:SetPoint("BOTTOMRIGHT", 0, 5)
                tex:SetColorTexture(0, 0, 0, .25)

                bu:SetHighlightTexture(R["media"].gloss)
                local hl = bu:GetHighlightTexture()
                hl:SetVertexColor(r, g, b, .2)
                hl.SetAlpha = R.dummy
                hl:ClearAllPoints()
                hl:Point("TOPLEFT", 0, -1)
                hl:Point("BOTTOMRIGHT", -1, 6)

                bu.Item:StyleButton(true)

                bu.reskinned = true
            end

            local link = select(15, C_BlackMarket.GetItemInfoByIndex(index))
            if link then
                local _, _, quality = GetItemInfo(link)
                local r, g, b = GetItemQualityColor(quality)
                bu.Name:SetTextColor(r, g, b)
            end
		end
    end
	hooksecurefunc(BlackMarketScrollFrame, "update", UpdateBlackMarketList)
	hooksecurefunc("BlackMarketScrollFrame_Update", UpdateBlackMarketList)

	hooksecurefunc("BlackMarketFrame_UpdateHotItem", function()
		local link = select(15, C_BlackMarket.GetHotItem())
		if link then
			local _, _, quality = GetItemInfo(link)
			local r, g, b = GetItemQualityColor(quality)
			BlackMarketFrame.HotDeal.Name:SetTextColor(r, g, b)
		end
	end)
end

S:AddCallbackForAddon("Blizzard_BlackMarketUI", "BlackMarket", LoadSkin)
