local R, L, P, G = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, GlobalDB
local IF = R:GetModule("InfoBar")

--Cache global variables
--Lua functions
local pairs, math = pairs, math
local tostring = tostring

--WoW API / Variables
local CreateFrame = CreateFrame
local GetInventoryItemDurability = GetInventoryItemDurability
local ToggleCharacter = ToggleCharacter

--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: GameTooltip, DURABILITY

local slots = {
    [ 1] = HEADSLOT,
    [ 3] = SHOULDERSLOT,
    [ 5] = CHESTSLOT,
    [ 6] = WAISTSLOT,
    [ 7] = LEGSSLOT,
    [ 8] = FEETSLOT,
    [ 9] = WRISTSLOT,
    [10] = HANDSSLOT,
    [16] = MAINHANDSLOT,
    [17] = SECONDARYHANDSLOT,
}

local function Durability_OnEvent(self)
    local durability, maxDurability, perc = 0, 0, 0

    for slot, type in pairs(slots) do
        local dur, maxDur = GetInventoryItemDurability(slot)

        if dur and maxDur then
            durability = durability + dur
            maxDurability = maxDurability + maxDur
        end
    end

    if durability > 0 and maxDurability > 0 then
        perc = math.floor(durability * 100 / maxDurability)
    end

    if perc >= 70 then
        perc = tostring("|cFF00FF00"..perc.."%|r")
    elseif perc >= 25 then
        perc = tostring("|cFFFFFF00"..perc.."%|r")
    else
        perc = tostring("|cFFFF0000"..perc.."%|r")
    end

    self:SetText(perc.." "..DURABILITY)
end

local function Durability_OnEnter(self)
    GameTooltip:SetOwner(self, "ANCHOR_TOP",0,0)
    GameTooltip:AddLine(DURABILITY,1,1,1)
    GameTooltip:SetPrevLineJustify("CENTER")
    GameTooltip:AddDivider()

    local numEq = 0

    for slot, type in pairs(slots) do
        local dur, maxDur = GetInventoryItemDurability(slot)
        local perc;

        if dur then
            perc = math.floor(dur*100/maxDur)
            numEq = numEq + 1
        end

        if perc then
            if perc >= 70 then
                perc = tostring("|cFF00FF00"..perc.."|r %")
            elseif perc >= 25 then
                perc = tostring("|cFFFFFF00"..perc.."|r %")
            elseif perc > 0 then
                perc = tostring("|cFFFF0000"..perc.."|r %")
            end

            GameTooltip:AddDoubleLine(type, perc, 1,1,1, 1,1,1)
        end
    end

    if numEq == 0 then
        GameTooltip:ClearLines()
    end

    GameTooltip:Show()
end

local function Durability_OnClick(self)
    ToggleCharacter("PaperDollFrame")
end

do -- Initialize
    local info = {}

    info.title = DURABILITY
    info.icon = "Interface\\Icons\\trade_blacksmithing"
    info.clickFunc = Durability_OnClick
    info.events = { "PLAYER_ENTERING_WORLD", "UPDATE_INVENTORY_DURABILITY", "MERCHANT_SHOW" }
    info.eventFunc = Durability_OnEvent
    info.initFunc = Durability_OnEvent
    info.tooltipFunc = Durability_OnEnter

    IF:RegisterInfoBarType("Durability", info)
end
