local R, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local S = R:GetModule("Skins")

local function LoadSkin()
    TradePlayerEnchantInset:DisableDrawLayer("BORDER")
    TradePlayerItemsInset:DisableDrawLayer("BORDER")
    TradeRecipientEnchantInset:DisableDrawLayer("BORDER")
    TradeRecipientItemsInset:DisableDrawLayer("BORDER")
    TradePlayerInputMoneyInset:DisableDrawLayer("BORDER")
    TradeRecipientMoneyInset:DisableDrawLayer("BORDER")
    TradeRecipientBG:Hide()
    TradePlayerEnchantInsetBg:Hide()
    TradePlayerItemsInsetBg:Hide()
    TradePlayerInputMoneyInsetBg:Hide()
    TradeRecipientEnchantInsetBg:Hide()
    TradeRecipientItemsInsetBg:Hide()
    TradeRecipientMoneyBg:Hide()
    TradeRecipientPortraitFrame:Hide()
    TradeRecipientBotLeftCorner:Hide()
    TradeRecipientLeftBorder:Hide()
	TradeFrameRecipientPortrait:Hide()
	TradeFramePlayerPortrait:Hide()
    S:ReskinPortraitFrame(TradeFrame, true)
	for i = 3, 6 do
		select(i, TradeFrame:GetRegions()):Hide()
	end
	S:Reskin(TradeFrameTradeButton)
	S:Reskin(TradeFrameCancelButton)

	-- Trade Button
	for i = 1,MAX_TRADE_ITEMS do
		for _, j in pairs({"TradePlayerItem", "TradeRecipientItem"}) do
			local tradeItemButton = _G[j..i.."ItemButton"]
			if not tradeItemButton.reskinned then
				_G[j..i.."ItemButtonIconTexture"]:SetTexCoord(0.08, 0.92, 0.08, 0.92)
				_G[j..i.."NameFrame"]:SetTexture(nil)

				if not tradeItemButton.boder then
					local boder = CreateFrame("Frame", nil, tradeItemButton)
					boder:Point("TOPLEFT", 1, -1)
					boder:Point("BOTTOMRIGHT", -1, 1)
					boder:CreateBorder()
					tradeItemButton.boder = boder
				end

				tradeItemButton:StyleButton()
				tradeItemButton:SetNormalTexture("")
				tradeItemButton:SetFrameStrata("HIGH")
				tradeItemButton:SetBackdrop(nil)
				tradeItemButton.reskinned = true
			end
		end
	end
	S:ReskinInput(TradePlayerInputMoneyFrameGold)
	S:ReskinInput(TradePlayerInputMoneyFrameSilver)
	TradePlayerInputMoneyFrameSilver:ClearAllPoints()
	TradePlayerInputMoneyFrameSilver:Point("LEFT", TradePlayerInputMoneyFrameGold, "RIGHT", 1, 0)
	S:ReskinInput(TradePlayerInputMoneyFrameCopper)
	TradePlayerInputMoneyFrameCopper:ClearAllPoints()
	TradePlayerInputMoneyFrameCopper:Point("LEFT", TradePlayerInputMoneyFrameSilver, "RIGHT", 1, 0)

	hooksecurefunc("TradeFrame_UpdatePlayerItem", function(id)
		local link = GetTradePlayerItemLink(id)
		local button = _G["TradePlayerItem"..id.."ItemButton"]
		local icontexture = _G["TradePlayerItem"..id.."ItemButtonIconTexture"]
		local name = _G["TradePlayerItem"..id.."Name"]
		local glow = button.glow
		if(not glow) then
			button.glow = glow
			glow = CreateFrame("Frame", nil, button)
			glow:SetAllPoints()
			glow:CreateBorder()
			button.glow = glow
		end
		button:SetBackdropColor(0, 0, 0, 0)
		icontexture:Point("TOPLEFT", 2, -2)
		icontexture:Point("BOTTOMRIGHT", -2, 2)
		if(link) then
			local r, g, b
			local _, _, quality, _, _, _, _, _, _, texture = GetItemInfo(link)

			if R:IsItemUnusable(link) then
				icontexture:SetVertexColor(RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b)
			else
				icontexture:SetVertexColor(1, 1, 1)
			end
			if quality and quality >1 then
				glow:SetAllPoints()
				glow:SetBackdropBorderColor(GetItemQualityColor(quality))
				button:SetBackdrop({
					bgFile = R["media"].blank,
					insets = { left = -R.mult, right = -R.mult, top = -R.mult, bottom = -R.mult }
				})
				button:SetBackdropColor(0, 0, 0)
				name:SetTextColor(GetItemQualityColor(quality))
			else
				glow:Point("TOPLEFT", 1, -1)
				glow:Point("BOTTOMRIGHT", -1, 1)
				glow:SetBackdropBorderColor(0, 0, 0)
				button:SetBackdropColor(0, 0, 0, 0)
				name:SetTextColor(1, 1, 1)
			end
			glow:Show()
		else
			glow:Hide()
		end
	end)

	hooksecurefunc("TradeFrame_UpdateTargetItem", function(id)
		local link = GetTradeTargetItemLink(id)
		local button = _G["TradeRecipientItem"..id.."ItemButton"]
		local icontexture = _G["TradeRecipientItem"..id.."ItemButtonIconTexture"]
		local name = _G["TradeRecipientItem"..id.."Name"]
		local glow = button.glow
		if(not glow) then
			button.glow = glow
			glow = CreateFrame("Frame", nil, button)
			glow:SetAllPoints()
			glow:CreateBorder()
			button.glow = glow
		end
		button:SetBackdropColor(0, 0, 0, 0)
		icontexture:Point("TOPLEFT", 2, -2)
		icontexture:Point("BOTTOMRIGHT", -2, 2)
		if(link) then
			local r, g, b
			local _, _, quality, _, _, _, _, _, _, texture = GetItemInfo(link)

			if R:IsItemUnusable(link) then
				icontexture:SetVertexColor(RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b)
			else
				icontexture:SetVertexColor(1, 1, 1)
			end
			name:SetTextColor(GetItemQualityColor(quality))
			if quality and quality >1 then
				glow:SetAllPoints()
				glow:SetBackdropBorderColor(GetItemQualityColor(quality))
				button:SetBackdrop({
					bgFile = R["media"].blank,
					insets = { left = -R.mult, right = -R.mult, top = -R.mult, bottom = -R.mult }
				})
				button:SetBackdropColor(0, 0, 0)
			else
				glow:Point("TOPLEFT", 1, -1)
				glow:Point("BOTTOMRIGHT", -1, 1)
				glow:SetBackdropBorderColor(0, 0, 0)
				button:SetBackdropColor(0, 0, 0, 0)
			end
			glow:Show()
		else
			glow:Hide()
		end
	end)
end

S:RegisterSkin("RayUI", LoadSkin)
