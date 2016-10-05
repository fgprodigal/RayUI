local R, L, P, G = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, GlobalDB
local M = R:GetModule("Misc")
local mod = M:NewModule("Merchant", "AceEvent-3.0", "AceHook-3.0")

--Cache global variables
--Lua functions
local select, math = select, math

--WoW API / Variables
local GetContainerNumSlots = GetContainerNumSlots
local GetContainerItemLink = GetContainerItemLink
local GetItemInfo = GetItemInfo
local GetContainerItemInfo = GetContainerItemInfo
local UseContainerItem = UseContainerItem
local PickupMerchantItem = PickupMerchantItem
local IsShiftKeyDown = IsShiftKeyDown
local CanMerchantRepair = CanMerchantRepair
local GetRepairAllCost = GetRepairAllCost
local IsInGuild = IsInGuild
local CanGuildBankRepair = CanGuildBankRepair
local GetGuildBankWithdrawMoney = GetGuildBankWithdrawMoney
local GetGuildBankMoney = GetGuildBankMoney
local RepairAllItems = RepairAllItems
local GetMoney = GetMoney
local IsAltKeyDown = IsAltKeyDown
local GetMerchantItemLink = GetMerchantItemLink
local BuyMerchantItem = BuyMerchantItem
local GetMerchantItemMaxStack = GetMerchantItemMaxStack

--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: DEFAULT_CHAT_FRAME

function mod:MERCHANT_SHOW()
    local c = 0
    for b=0,4 do
        for s=1,GetContainerNumSlots(b) do
            local l = GetContainerItemLink(b, s)
            if l and select(11, GetItemInfo(l)) then
                local p = select(11, GetItemInfo(l))*select(2, GetContainerItemInfo(b, s))
                if select(3, GetItemInfo(l))==0 and p>0 then
                    UseContainerItem(b, s)
                    PickupMerchantItem()
                    c = c+p
                end
            end
        end
    end
    if c>0 then
        local g, s, c = math.floor(c/10000) or 0, math.floor((c%10000)/100) or 0, c%100
        DEFAULT_CHAT_FRAME:AddMessage(L["您背包内的粗糙物品已被自动卖出, 您赚取了"].." |cffffffff"..g.."|cffffd700g|r".." |cffffffff"..s.."|cffc7c7cfs|r".." |cffffffff"..c.."|cffeda55fc|r.",255,255,0)
    end
    if not IsShiftKeyDown() then
        if CanMerchantRepair() then
            local cost, possible = GetRepairAllCost()
            if cost>0 then
                if possible then
                    local c = cost%100
                    local s = math.floor((cost%10000)/100) or 0
                    local g = math.floor(cost/10000) or 0
                    if IsInGuild() and CanGuildBankRepair() and ((GetGuildBankWithdrawMoney() >= cost) or (GetGuildBankWithdrawMoney() == -1)) and (GetGuildBankMoney() >= cost) then
                        RepairAllItems(1)
                        DEFAULT_CHAT_FRAME:AddMessage(L["您的装备已使用公会修理, 花费了"].." |cffffffff"..g.."|cffffd700g|r".." |cffffffff"..s.."|cffc7c7cfs|r".." |cffffffff"..c.."|cffeda55fc|r.",255,255,0)
                    elseif GetMoney() >= cost then
                        RepairAllItems()
                        DEFAULT_CHAT_FRAME:AddMessage(L["您的装备已修理, 花费了"].." |cffffffff"..g.."|cffffd700g|r".." |cffffffff"..s.."|cffc7c7cfs|r".." |cffffffff"..c.."|cffeda55fc|r.",255,255,0)
                    else
                        DEFAULT_CHAT_FRAME:AddMessage(L["您没有足够的金钱来修理!"],255,0,0)
                        return
                    end
                end
            end
        end
    end
end

function mod:MerchantItemButton_OnModifiedClick(button, ...)
    if ( IsAltKeyDown() ) then
        local itemLink = GetMerchantItemLink(button:GetID())
        if not itemLink then return end
        local maxStack = select(8, GetItemInfo(itemLink))
        if ( maxStack and maxStack > 1 ) then
            BuyMerchantItem(button:GetID(), GetMerchantItemMaxStack(button:GetID()))
        end
    end
    self.hooks.MerchantItemButton_OnModifiedClick(button, ...)
end

function mod:Initialize()
    if not M.db.merchant then return end
    self:RegisterEvent("MERCHANT_SHOW")
    self:RawHook("MerchantItemButton_OnModifiedClick", true)
end

M:RegisterMiscModule(mod:GetName())
