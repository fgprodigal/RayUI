local R, L, P = unpack(select(2, ...)) --Inport: Engine, Locales, ProfileDB
local IF = R:GetModule("InfoBar")

local function LoadCurrency()
	local infobar = _G["RayUITopInfoBar7"]
	local Status = infobar.Status
	infobar.Text:SetText(CURRENCY)
	Status:SetValue(0)

	RayUIData.Class = RayUIData.Class or {}
	RayUIData.Class[R.myrealm] = RayUIData.Class[R.myrealm] or {}
	RayUIData.Class[R.myrealm][R.myname] = R.myclass
	RayUIData.Gold = RayUIData.Gold or {}
	RayUIData.Gold[R.myrealm] = RayUIData.Gold[R.myrealm] or {}

	-- CURRENCY DATA BARS
	local CurrencyData = {}
	local tokens = {
		{61, 250},	 -- Dalaran Jewelcrafter's Token
		{81, 250},	 -- Dalaran Cooking Award
		{241, 250},	 -- Champion Seal
		{361, 200},  -- Illustrious Jewelcrafter's Token
		{390, 3000}, -- Conquest Points
		{391, 2000},  -- Tol Barad Commendation
		{392, 4000}, -- Honor Points
		{395, 4000}, -- Justice Points
		{396, 4000}, -- Valor Points
		{402, 10},	 -- Chef's Award 
		{416, 300}, -- Mark of the World Tree
		{515, 2000}, --Darkmoon Prize Ticket
		{614, 2000}, --Mote of Darkness
		{615, 2000}, --Essence of Corrupted Deathwing
	}

	local function updateCurrency()
		wipe(CurrencyData)
		for i, v in ipairs(tokens) do
			local id, max = unpack(v)
			local name, amount, icon = GetCurrencyInfo(id)
			local newamount

			if name and amount > 0 then
				if id == 396 then
					local _, _, _, _, _, _, ppQuantity = GetLFGDungeonRewardCapBarInfo(301)
					if ppQuantity and ppQuantity >= 1000 then
						newamount = "|cffff0000" .. amount .. "|r"
					else
						newamount = amount
					end
				elseif id == 390 then
					local pointsThisWeek, limitThisWeek = GetPVPRewards()
					if pointsThisWeek and pointsThisWeek >= limitThisWeek then
						newamount = "|cffff0000" .. amount .. "|r"
					else
						newamount = amount
					end
				else
					newamount = (max >0 and amount >= max) and "|cffff0000" .. amount .. "|r" or amount
				end
				name = string.format("\124TInterface\\ICONS\\%s:%d:%d:0:0:64:64:5:59:5:59\124t %s", icon, 24, 24, name)
				CurrencyData[name] = newamount
			end
		end
	end

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
		GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT")
		local total = 0
		local realmlist = RayUIData.Gold[R.myrealm]
		for k, v in pairs(realmlist) do
			total = total + v
		end
		GameTooltip:AddLine(GOLD_AMOUNT:gsub("%%d",""), 0.69, 0.31, 0.31)
		GameTooltip:AddDoubleLine(R.myrealm, formatMoney(total, true), nil, nil, nil, 1, 1, 1)
		GameTooltip:AddLine(" ")
		for k, v in pairs(realmlist) do
			local class = RayUIData.Class[R.myrealm][k]
			if v >= 10000 then
				GameTooltip:AddDoubleLine(k, formatMoney(v, true), RAID_CLASS_COLORS[class].r, RAID_CLASS_COLORS[class].g, RAID_CLASS_COLORS[class].b, 1, 1, 1)
			end
		end
		GameTooltip:AddLine(" ")
		GameTooltip:AddLine(CURRENCY, 0.69, 0.31, 0.31)
		for name, amount in pairs(CurrencyData) do
			GameTooltip:AddDoubleLine(name, amount, nil, nil, nil, 1, 1, 1)
		end
		GameTooltip:Show()
	end

	local function OnEvent(self, event)
		if event == "PLAYER_HONOR_GAIN" then
			updateCurrency()
		else
			local money	= GetMoney()
			infobar.Text:SetText(formatMoney(money))
			self:SetAllPoints(infobar)
			RayUIData.Gold[R.myrealm][R.myname] = money

			local total = 0
			local realmlist = RayUIData.Gold[R.myrealm]
			for k, v in pairs(realmlist) do
				total = total + v
			end
			if total > 0 then
				Status:SetMinMaxValues(0, total)
				Status:SetValue(money)
				Status:SetStatusBarColor(unpack(IF.InfoBarStatusColor[3]))
			end
		end
	end

	Status:RegisterEvent("PLAYER_MONEY")
	Status:RegisterEvent("SEND_MAIL_MONEY_CHANGED")
	Status:RegisterEvent("SEND_MAIL_COD_CHANGED")
	Status:RegisterEvent("PLAYER_TRADE_MONEY")
	Status:RegisterEvent("TRADE_MONEY_CHANGED")
	Status:RegisterEvent("PLAYER_ENTERING_WORLD")
	Status:RegisterEvent("PLAYER_HONOR_GAIN")
	Status:SetScript("OnEnter", ShowCurrency)
	Status:SetScript("OnLeave", GameTooltip_Hide)
	Status:SetScript("OnEvent", OnEvent)

	hooksecurefunc("BackpackTokenFrame_Update", updateCurrency)
end

IF:RegisterInfoText("Currency", LoadCurrency)