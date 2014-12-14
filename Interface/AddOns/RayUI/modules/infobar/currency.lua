local R, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local IF = R:GetModule("InfoBar")

local function LoadCurrency()
	local infobar = IF:CreateInfoPanel("RayUI_InfoPanel_Currency", 120)
	infobar:SetPoint("TOPRIGHT", 10, 0)
	local db = R.global
	local Profit = 0
	local Spent = 0
	infobar.Text:SetText(CURRENCY)

	local function formatMoney(money, icon)
		local gold = floor(math.abs(money) / 10000)
		local silver = mod(floor(math.abs(money) / 100), 100)
		local copper = mod(floor(math.abs(money)), 100)
		if gold ~= 0 then
			if icon then
				return format(GOLD_AMOUNT_TEXTURE.." "..SILVER_AMOUNT_TEXTURE.." "..COPPER_AMOUNT_TEXTURE, gold, 0, 0, silver, 0, 0, copper, 0, 0)
			else
				return format("%s".."|cffffd700g|r".." %s".."|cffc7c7cfs|r".." %s".."|cffeda55fc|r", gold, silver, copper)
			end
		elseif silver ~= 0 then
			if icon then
				return format(SILVER_AMOUNT_TEXTURE.." "..COPPER_AMOUNT_TEXTURE, silver, 0, 0, copper, 0, 0)
			else
				return format("%s".."|cffc7c7cfs|r".." %s".."|cffeda55fc|r", silver, copper)
			end
		else
			if icon then
				return format(COPPER_AMOUNT_TEXTURE, copper, 0, 0)
			else
				return format("%s".."|cffeda55fc|r", copper)
			end
		end
	end

	local function ShowCurrency(self)
		local total = 0
		local realmlist = db.Gold[R.myrealm]
		for k, v in pairs(realmlist) do
			total = total + v
		end
		GameTooltip:SetOwner(infobar, "ANCHOR_NONE")
		GameTooltip:SetPoint("BOTTOMRIGHT", infobar, "TOPRIGHT", 0, 0)
		GameTooltip:ClearLines()
		GameTooltip:AddLine(GOLD_AMOUNT:gsub("%%d",""), 0.69, 0.31, 0.31)
		GameTooltip:AddLine(" ")
		GameTooltip:AddDoubleLine(R.myrealm, formatMoney(total, true), nil, nil, nil, 1, 1, 1)
		GameTooltip:AddLine(" ")
		GameTooltip:AddLine(L["本次登录:"])
		GameTooltip:AddDoubleLine(L["赚取:"], formatMoney(Profit), nil, nil, nil, 1, 1, 1)
		GameTooltip:AddDoubleLine(L["花费:"], formatMoney(Spent), nil, nil, nil, 1, 1, 1)
		if Profit < Spent then
			GameTooltip:AddDoubleLine(L["赤字:"], formatMoney(Profit-Spent), 1, 0, 0, 1, 1, 1)
		elseif (Profit-Spent)>0 then
			GameTooltip:AddDoubleLine(L["利润:"], formatMoney(Profit-Spent), 0, 1, 0, 1, 1, 1)
		end
		GameTooltip:AddLine(" ")
		for k, v in pairs(realmlist) do
			local r, g, b = NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b
			local class = db.Class[R.myrealm][k]
			if R.colors.class[class] then
				r, g, b = R.colors.class[class].r, R.colors.class[class].g, R.colors.class[class].b
			end
			if v >= 10000 then
				GameTooltip:AddDoubleLine(k, formatMoney(v, true), r, g, b, 1, 1, 1)
			end
		end
		GameTooltip:AddLine(" ")
		GameTooltip:AddLine(CURRENCY, 0.69, 0.31, 0.31)
		for i=1, GetCurrencyListSize() do
			local name, isHeader, isExpanded, isUnused, isWatched, count, icon, totalMax = GetCurrencyListInfo(i)
			if not isHeader and icon and count>0 then
				GameTooltip:AddLine(" ")
				if totalMax and totalMax > 100 then
					totalMax = math.floor(totalMax/100)
				else
					totalMax = totalMax or 0
				end
				if totalMax > 0 and count == totalMax then
					GameTooltip:AddDoubleLine(string.format("\124T%s:%d:%d:0:0:64:64:5:59:5:59\124t %s", icon, 24, 24, name), count, nil, nil, nil, 1, 0, 0)
				else
					GameTooltip:AddDoubleLine(string.format("\124T%s:%d:%d:0:0:64:64:5:59:5:59\124t %s", icon, 24, 24, name), count, nil, nil, nil, 1, 1, 1)
				end
			end
		end
		GameTooltip:Show()
	end

	local function OnEvent(self, event)
		if not IsLoggedIn() then return end
		if event == "PLAYER_HONOR_GAIN" then
			updateCurrency()
		else
			if not db.Class then
				if RayUIData.Class and type(RayUIData.Class) == "table" then
					db.Class = RayUIData.Class
					RayUIData.Class = nil
				else
					db.Class = {}
				end
			end

			if db.Class[R.myrealm] == nil then db.Class[R.myrealm] = {} end
			db.Class[R.myrealm][R.myname] = R.myclass

			if not db.Gold then
				if RayUIData.Gold and type(RayUIData.Gold) == "table" then
					db.Gold = RayUIData.Gold
					RayUIData.Gold = nil
				else
					db.Gold = {}
				end
			end

			if db.Gold[R.myrealm] == nil then db.Gold[R.myrealm] = {} end

			local NewMoney = GetMoney()
			local OldMoney = db.Gold[R.myrealm][R.myname] or NewMoney
			local Change = NewMoney-OldMoney
			if OldMoney>NewMoney then
				Spent = Spent - Change
			else
				Profit = Profit + Change
			end

			infobar.Text:SetText(formatMoney(NewMoney))
			infobar:SetWidth(infobar.Text:GetWidth() + IF.gap*2)
			db.Gold[R.myrealm][R.myname] = NewMoney

			local total = 0
			local realmlist = db.Gold[R.myrealm]
			for k, v in pairs(realmlist) do
				total = total + v
			end
		end
	end

	infobar:RegisterEvent("PLAYER_MONEY")
	infobar:RegisterEvent("SEND_MAIL_MONEY_CHANGED")
	infobar:RegisterEvent("SEND_MAIL_COD_CHANGED")
	infobar:RegisterEvent("PLAYER_TRADE_MONEY")
	infobar:RegisterEvent("TRADE_MONEY_CHANGED")
	infobar:RegisterEvent("PLAYER_ENTERING_WORLD")
	infobar:HookScript("OnEnter", ShowCurrency)
	infobar:HookScript("OnMouseDown", function() ToggleBackpack() end)
	infobar:HookScript("OnLeave", GameTooltip_Hide)
	infobar:HookScript("OnEvent", OnEvent)
end

IF:RegisterInfoText("Currency", LoadCurrency)
