local R, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(_, _, name)
	f:UnregisterEvent("ADDON_LOADED")
	f:SetScript("OnEvent", nil)
end)

local function addLine(self,id,isItem)
	for i = 1, self:NumLines() do
		local line = _G["GameTooltipTextLeft"..i]
		if not line then break end
		local text = line:GetText()
		if text and (text:match("FFCA3C3C技能ID") or text:match("FFCA3C3C堆疊數") or text:match("FFCA3C3C已擁有") or text:match("FFCA3C3C物品ID")) then
			return
		end
	end
	self:AddLine(" ")
	if isItem then
		if select(8, GetItemInfo(id)) and select(8, GetItemInfo(id)) >1 then
			self:AddDoubleLine("|cFFCA3C3C堆疊數:|r","|cffffffff"..select(8, GetItemInfo(id)))
		end
		if GetItemCount(id, true) and GetItemCount(id, true) - GetItemCount(id) > 0 then
			self:AddDoubleLine("|cFFCA3C3C已擁有(|r"..R:RGBToHex(50/255, 217/255, 1).."銀行|r".."|cFFCA3C3C):|r","|cffffffff"..GetItemCount(id, true).."(|r"..R:RGBToHex(50/255, 217/255, 1)..GetItemCount(id, true) - GetItemCount(id).."|r|cffffffff)|r")
		elseif GetItemCount(id) > 0 then
			self:AddDoubleLine("|cFFCA3C3C已擁有:|r","|cffffffff"..GetItemCount(id))
		end
		self:AddDoubleLine("|cFFCA3C3C物品ID:|r","|cffffffff"..id)
	else
		self:AddDoubleLine("|cFFCA3C3C技能ID:|r","|cffffffff"..id)
	end
	self:Show()
end

hooksecurefunc(GameTooltip, "SetUnitConsolidatedBuff", function(self, unit, index)
	local name = GetRaidBuffTrayAuraInfo(index)
	local _, _, _, _, _, _, _, caster, _, _, id = UnitAura(unit, name)
	if id then
		self:AddLine(" ")
		if caster then
			self:AddLine(UnitName(caster))
		end
		self:AddDoubleLine("|cFFCA3C3C技能ID:|r","|cffffffff"..id)
		self:Show()
	end	
end)

hooksecurefunc(GameTooltip, "SetUnitAura", function(self,...)
	local id = select(11, UnitAura(...))
	local caster = select (8, UnitAura(...))
	if id then
		self:AddLine(" ")
		if caster ~= nil then
			self:AddLine(UnitName(caster))
		end
		self:AddDoubleLine("|cFFCA3C3C技能ID:|r","|cffffffff"..id)
		self:Show()
	end
end)

GameTooltip:HookScript("OnTooltipSetSpell", function(self)
	local id = select(3,self:GetSpell())
	if id then addLine(self,id) end
end)

-- Item Hooks -----------------------------------------------------------------
hooksecurefunc("SetItemRef", function(link, ...)
	local id = tonumber(link:match("spell:(%d+)"))
	if id then addLine(ItemRefTooltip,id) end
end)

local function attachItemTooltip(self)
	local link = select(2,self:GetItem())
	if not link then return end
	local id = select(3,strfind(link, "^|%x+|Hitem:(%-?%d+):(%d+):(%d+):(%d+):(%d+):(%d+):(%-?%d+):(%-?%d+)"))
	if id then addLine(self,id,true) end
end

GameTooltip:HookScript("OnTooltipSetItem", attachItemTooltip)
ItemRefTooltip:HookScript("OnTooltipSetItem", attachItemTooltip)
ItemRefShoppingTooltip1:HookScript("OnTooltipSetItem", attachItemTooltip)
ItemRefShoppingTooltip2:HookScript("OnTooltipSetItem", attachItemTooltip)
ShoppingTooltip1:HookScript("OnTooltipSetItem", attachItemTooltip)
ShoppingTooltip2:HookScript("OnTooltipSetItem", attachItemTooltip)
