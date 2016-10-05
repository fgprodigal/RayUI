local R, L, P, G = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, GlobalDB
local M = R:GetModule("Misc")
local mod = M:NewModule("Auction", "AceEvent-3.0")

--Cache global variables
--Lua functions
local _G = _G

--WoW API / Variables
local IsShiftKeyDown = IsShiftKeyDown
local FauxScrollFrame_GetOffset = FauxScrollFrame_GetOffset
local GetAuctionItemInfo = GetAuctionItemInfo
local PlaceAuctionBid = PlaceAuctionBid
local CancelAuction = CancelAuction

--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: BrowseScrollFrame, AuctionsScrollFrame

local MAX_BUYOUT_PRICE = 10000000

function mod:ADDON_LOADED(event, addon)
    if addon ~= "Blizzard_AuctionUI" then return end
    self:UnregisterEvent("ADDON_LOADED")
    for i = 1, 20 do
        local f = _G["BrowseButton"..i]
        if f then
            f:RegisterForClicks("LeftButtonUp", "RightButtonUp")
            f:HookScript("OnClick", function(self, button)
                    if button == "RightButton" and IsShiftKeyDown() then
                        local index = self:GetID() + FauxScrollFrame_GetOffset(BrowseScrollFrame)
                        local name, _, _, _, _, _, _, _, _, buyoutPrice = GetAuctionItemInfo("list", index)
                        if name then
                            if buyoutPrice < MAX_BUYOUT_PRICE then
                                PlaceAuctionBid("list", index, buyoutPrice)
                            end
                        end
                    end
                end)
        end
    end
    for i = 1, 20 do
        local f = _G["AuctionsButton"..i]
        if f then
            f:RegisterForClicks("LeftButtonUp", "RightButtonUp")
            f:HookScript("OnClick", function(self, button)
                    local index = self:GetID() + FauxScrollFrame_GetOffset(AuctionsScrollFrame)
                    if button == "RightButton" and IsShiftKeyDown() then
                        local name = GetAuctionItemInfo("owner", index)
                        if name then
                            CancelAuction(index)
                        end
                    end
                end)
        end
    end
end

function mod:Initialize()
    if not M.db.auction then return end
    self:RegisterEvent("ADDON_LOADED")
end

M:RegisterMiscModule(mod:GetName())
