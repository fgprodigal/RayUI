local R, L, P, G = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, GlobalDB
local M = R:GetModule("Misc")
local mod = M:NewModule("Durability", "AceEvent-3.0")
local LibItemLevel = LibStub:GetLibrary("LibItemLevel-RayUI")

--Cache global variables
--Lua functions
local _G = _G
local pairs, math, string, rawget, select = pairs, math, string, rawget, select

--WoW API / Variables
local CreateFrame = CreateFrame
local GetInventoryItemDurability = GetInventoryItemDurability
local GetInventoryItemLink = GetInventoryItemLink
local GetDetailedItemLevelInfo = GetDetailedItemLevelInfo
local GetItemInfo = GetItemInfo
local GetItemQualityColor = GetItemQualityColor
local GetInventorySlotInfo = GetInventorySlotInfo

--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: LE_ITEM_QUALITY_ARTIFACT, INVSLOT_OFFHAND, INVSLOT_MAINHAND

local SLOTIDS, LEFT_SLOT = {}, {}

local function RYGColorGradient(perc)
    local relperc = perc*2 % 1
    if perc <= 0 then return 1, 0, 0
    elseif perc < 0.5 then return 1, relperc, 0
    elseif perc == 0.5 then return 1, 1, 0
    elseif perc < 1.0 then return 1 - relperc, 1, 0
    else return 0, 1, 0 end
end

local itemLevel = setmetatable({}, {
        __index = function(t,i)
            local gslot = _G["Character"..i.."Slot"]
            if not gslot then return nil end

            local text = gslot:CreateFontString(nil, "OVERLAY")
            text:SetFont(R["media"].font, 12, "THINOUTLINE")
            text:SetShadowColor(0, 0, 0)
            text:SetShadowOffset(R.mult, -R.mult)
            if LEFT_SLOT[SLOTIDS[i]] then
                text:Point("TOPLEFT", gslot, "TOPRIGHT", 3, 0)
            else
                text:Point("TOPRIGHT", gslot, "TOPLEFT", -2, 0)
            end
            t[i] = text
            return text
        end,
    })

local inspectItemLevel = setmetatable({}, {
        __index = function(t,i)
            local gslot = _G["Inspect"..i.."Slot"]
            if not gslot then return nil end

            local text = gslot:CreateFontString(nil, "OVERLAY")
            text:SetFont(R["media"].font, 10, "THINOUTLINE")
            text:SetShadowColor(0, 0, 0)
            text:SetShadowOffset(R.mult, -R.mult)
            if LEFT_SLOT[SLOTIDS[i]] then
                text:Point("TOPLEFT", gslot, "TOPRIGHT", 3, 0)
            else
                text:Point("TOPRIGHT", gslot, "TOPLEFT", -2, 0)
            end
            t[i] = text
            return text
        end,
    })

local durability = setmetatable({}, {
        __index = function(t,i)
            local gslot = _G["Character"..i.."Slot"]
            if not gslot then return nil end

            local text = gslot:CreateFontString(nil, "OVERLAY")
            text:SetFont(R["media"].font, 10, "THINOUTLINE")
            text:SetShadowColor(0, 0, 0)
            text:SetShadowOffset(R.mult, -R.mult)
            if LEFT_SLOT[SLOTIDS[i]] then
                text:Point("TOPLEFT", gslot, "TOPRIGHT", 3, -15)
            else
                text:Point("TOPRIGHT", gslot, "TOPLEFT", -2, -15)
            end
            t[i] = text
            return text
        end,
    })

function mod:UpdateDurability(event)
    local min = 1
    for slot, id in pairs(SLOTIDS) do
        local v1, v2 = GetInventoryItemDurability(id)
        local text = durability[slot]
        text:SetText("")

        if v1 and v2 and v2 ~= 0 then
            min = math.min(v1/v2, min)
            if not text then return end
            text:SetTextColor(RYGColorGradient(v1/v2))
            text:SetText(string.format("%d%%", v1/v2*100))
        end
    end

    local r, g, b = RYGColorGradient(min)
end

function mod:UpdateItemlevel(event)
    local t = itemLevel
    local unit = "player"
    if event == "INSPECT_READY" then
        unit = "target"
        t = inspectItemLevel
    end
    for slot, id in pairs(SLOTIDS) do
        local text = t[slot]
        if not text then return end
        text:SetText("")
        local clink = GetInventoryItemLink(unit, id)
        if clink then
            local _, iLvl = LibItemLevel:GetUnitItemInfo(unit, id)
            local rarity = select(3, GetItemInfo(clink))
            if iLvl and iLvl > 1 and rarity then
                local r, g, b = GetItemQualityColor(rarity)

                text:SetText(iLvl)
                text:SetTextColor(r, g, b)
            end
        end
    end
end

function mod:PLAYER_ENTERING_WORLD()
    self:UpdateDurability()
    self:UpdateItemlevel()
end

function mod:Initialize()
    for _, slot in pairs({"Head","Neck","Shoulder","Shirt","Chest","Waist","Legs","Feet","Wrist","Hands","Finger0","Finger1","Trinket0","Trinket1","Back","MainHand","SecondaryHand","Tabard"}) do
        SLOTIDS[slot] = GetInventorySlotInfo(slot .. "Slot")
    end
    for _, slot in pairs({ 1, 2, 3, 4, 5, 9, 15, 17, 19 }) do
        LEFT_SLOT[slot] = true
    end

    self:RegisterEvent("UPDATE_INVENTORY_DURABILITY", "UpdateDurability")
    self:RegisterEvent("PLAYER_EQUIPMENT_CHANGED", "UpdateItemlevel")
    self:RegisterEvent("PLAYER_ENTERING_WORLD")
    self:RegisterEvent("INSPECT_READY", "UpdateItemlevel")
end

M:RegisterMiscModule(mod:GetName())
