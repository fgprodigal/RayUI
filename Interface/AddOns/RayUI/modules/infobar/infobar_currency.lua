local R, L, P, G = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, GlobalDB
local IF = R:GetModule("InfoBar")

local function Currency_OnClick(self)
	ToggleCharacter("TokenFrame")
end

local function Currency_OnEnter(self)
	local numEntries, spacer = 0
	
	GameTooltip:SetOwner(self, "ANCHOR_TOP")
	
	for index = 1, GetCurrencyListSize() do
		local name, isHeader, _, isUnused, isWatched, count, icon = GetCurrencyListInfo(index)
		
		if not isHeader and not isUnused then
			if not spacer then
				spacer = true
			end
			
			numEntries = numEntries + 1
			
			GameTooltip:AddDoubleLine(name, count.." |T"..icon..":14:14:0:0:64:64:5:59:5:59|t",1,1,1,1,1,1)
		end
	end

	GameTooltip:Show()
end

do	-- Initialize
	local info = {}

	info.title = CURRENCY
	info.icon = "Interface\\Icons\\garrison_building_tradingpost"
	info.clickFunc = Currency_OnClick
	info.tooltipFunc = Currency_OnEnter
	
	IF:RegisterInfoBarType("Currency", info)
end