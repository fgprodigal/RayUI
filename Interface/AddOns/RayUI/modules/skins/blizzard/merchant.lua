local R, L, P = unpack(select(2, ...)) --Inport: Engine, Locales, ProfileDB
local S = R:GetModule("Skins")

local function LoadSkin()
	S:SetBD(MerchantFrame, 10, -10, -34, 61)
	MerchantFramePortrait:Hide()
	MerchantFrameExtraCurrencyTex:Hide()
	S:ReskinArrow(MerchantPrevPageButton, 1)
	S:ReskinArrow(MerchantNextPageButton, 2)
	MerchantPrevPageButton:GetRegions():Hide()
	MerchantNextPageButton:GetRegions():Hide()
	select(2, MerchantPrevPageButton:GetRegions()):Hide()
	select(2, MerchantNextPageButton:GetRegions()):Hide()
	MerchantNameText:SetDrawLayer("ARTWORK")
	MerchantFrame:DisableDrawLayer("BORDER")
	MerchantFrame:DisableDrawLayer("OVERLAY")
	MerchantFrameTab2:SetPoint("LEFT", MerchantFrameTab1, "RIGHT", -15, 0)
	S:CreateTab(MerchantFrameTab1)
	S:CreateTab(MerchantFrameTab2)
	S:ReskinClose(MerchantFrameCloseButton, "TOPRIGHT", MerchantFrame, "TOPRIGHT", -38, -14)

	for i = 1, 12 do
		local button = _G["MerchantItem"..i]
		local bu = _G["MerchantItem"..i.."ItemButton"]
		local ic = _G["MerchantItem"..i.."ItemButtonIconTexture"]
		local mo = _G["MerchantItem"..i.."MoneyFrame"]

		_G["MerchantItem"..i.."SlotTexture"]:Hide()
		_G["MerchantItem"..i.."NameFrame"]:Hide()
		_G["MerchantItem"..i.."Name"]:SetHeight(20)
		local a1, p, a2= bu:GetPoint()
		bu:SetPoint(a1, p, a2, -2, -2)
		bu:SetNormalTexture("")
		bu:SetSize(40, 40)
		bu:StyleButton()
		bu:GetHighlightTexture():Point("TOPLEFT", 1, -1)
		bu:GetHighlightTexture():Point("BOTTOMRIGHT", -1, 1)
		bu:GetPushedTexture():Point("TOPLEFT", 1, -1)
		bu:GetPushedTexture():Point("BOTTOMRIGHT", -1, 1)

		local a3, p2, a4, x, y = mo:GetPoint()
		mo:SetPoint(a3, p2, a4, x, y+2)

		S:CreateBD(bu, 0)

		button.bd = CreateFrame("Frame", nil, button)
		button.bd:SetPoint("TOPLEFT", 39, 0)
		button.bd:SetPoint("BOTTOMRIGHT")
		button.bd:SetFrameLevel(0)
		S:CreateBD(button.bd, .25)

		ic:SetTexCoord(.08, .92, .08, .92)
		ic:ClearAllPoints()
		ic:SetPoint("TOPLEFT", 1, -1)
		ic:SetPoint("BOTTOMRIGHT", -1, 1)
	end

	MerchantBuyBackItemSlotTexture:Hide()
	MerchantBuyBackItemNameFrame:Hide()
	MerchantBuyBackItemItemButton:SetNormalTexture("")
	MerchantBuyBackItemItemButton:StyleButton()
	MerchantBuyBackItemItemButton:GetHighlightTexture():Point("TOPLEFT", 1, -1)
	MerchantBuyBackItemItemButton:GetHighlightTexture():Point("BOTTOMRIGHT", -1, 1)
	MerchantBuyBackItemItemButton:GetPushedTexture():Point("TOPLEFT", 1, -1)
	MerchantBuyBackItemItemButton:GetPushedTexture():Point("BOTTOMRIGHT", -1, 1)
	BuybackFrameTopLeft:SetAlpha(0)
	BuybackFrameTopRight:SetAlpha(0)
	BuybackFrameBotLeft:SetAlpha(0)
	BuybackFrameBotRight:SetAlpha(0)

	S:CreateBD(MerchantBuyBackItemItemButton, 0)
	S:CreateBD(MerchantBuyBackItem, .25)

	MerchantBuyBackItemItemButtonIconTexture:SetTexCoord(.08, .92, .08, .92)
	MerchantBuyBackItemItemButtonIconTexture:ClearAllPoints()
	MerchantBuyBackItemItemButtonIconTexture:SetPoint("TOPLEFT", 1, -1)
	MerchantBuyBackItemItemButtonIconTexture:SetPoint("BOTTOMRIGHT", -1, 1)

	S:CreateBG(MerchantGuildBankRepairButton)
	MerchantGuildBankRepairButtonIcon:SetTexCoord(0.61, 0.82, 0.1, 0.52)
	MerchantGuildBankRepairButton:StyleButton(true)

	S:CreateBG(MerchantRepairAllButton)
	MerchantRepairAllIcon:SetTexCoord(0.34, 0.1, 0.34, 0.535, 0.535, 0.1, 0.535, 0.535)
	MerchantRepairAllButton:StyleButton(true)

	S:CreateBG(MerchantRepairItemButton)
	MerchantRepairItemButton:GetRegions():SetTexCoord(0.04, 0.24, 0.06, 0.5)
	MerchantRepairItemButton:StyleButton(true)

	hooksecurefunc("MerchantFrame_UpdateCurrencies", function()
		for i = 1, MAX_MERCHANT_CURRENCIES do
			local bu = _G["MerchantToken"..i]
			if bu and not bu.reskinned then
				local ic = _G["MerchantToken"..i.."Icon"]
				local co = _G["MerchantToken"..i.."Count"]

				ic:SetTexCoord(.08, .92, .08, .92)
				ic:SetDrawLayer("OVERLAY")
				ic:SetPoint("LEFT", co, "RIGHT", 2, 0)
				co:SetPoint("TOPLEFT", bu, "TOPLEFT", -2, 0)

				S:CreateBG(ic)
				bu.reskinned = true
			end
		end
	end)
end

S:RegisterSkin("RayUI", LoadSkin)