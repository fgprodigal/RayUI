local R, L, P, G = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, GlobalDB
local M = R:GetModule("Misc")
local mod = M:NewModule("Durability", "AceEvent-3.0")

--Cache global variables
--Lua functions
local _G = _G
local assert, pairs, math, string, rawget = assert, pairs, math, string, rawget

--WoW API / Variables
local CreateFrame = CreateFrame
local GetInventoryItemDurability = GetInventoryItemDurability

local SLOTIDS = {}
for _, slot in pairs({"Head", "Shoulder", "Chest", "Waist", "Legs", "Feet", "Wrist", "Hands", "MainHand", "SecondaryHand"}) do SLOTIDS[slot] = GetInventorySlotInfo(slot .. "Slot") end
local frame = CreateFrame("Frame", nil, CharacterFrame)

local function RYGColorGradient(perc)
    local relperc = perc*2 % 1
    if perc <= 0 then return 1, 0, 0
    elseif perc < 0.5 then return 1, relperc, 0
    elseif perc == 0.5 then return 1, 1, 0
    elseif perc < 1.0 then return 1 - relperc, 1, 0
    else return 0, 1, 0 end
end

local fontstrings = setmetatable({}, {
        __index = function(t,i)
            local gslot = _G["Character"..i.."Slot"]
            assert(gslot, "Character"..i.."Slot does not exist")

            local fstr = gslot:CreateFontString(nil, "OVERLAY")
            fstr:SetFont(R["media"].pxfont, R.mult*10, "OUTLINE,MONOCHROME")
            fstr:SetShadowColor(0, 0, 0)
            fstr:SetShadowOffset(R.mult, -R.mult)
            fstr:SetPoint("CENTER", gslot, "BOTTOM", 1, 8)
            t[i] = fstr
            return fstr
        end,
    })

function mod:UpdateDurability()
    local min = 1
    for slot, id in pairs(SLOTIDS) do
        local v1, v2 = GetInventoryItemDurability(id)

        if v1 and v2 and v2 ~= 0 then
            min = math.min(v1/v2, min)
            local str = fontstrings[slot]
            str:SetTextColor(RYGColorGradient(v1/v2))
            str:SetText(string.format("%d%%", v1/v2*100))
        else
            local str = rawget(fontstrings, slot)
            if str then str:SetText(nil) end
        end
    end

    local r, g, b = RYGColorGradient(min)
end

function mod:Initialize()
    self:RegisterEvent("ADDON_LOADED", "UpdateDurability")
    self:RegisterEvent("UPDATE_INVENTORY_DURABILITY", "UpdateDurability")
end

M:RegisterMiscModule(mod:GetName())
