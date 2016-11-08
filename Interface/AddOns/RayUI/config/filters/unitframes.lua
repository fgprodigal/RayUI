local R, L, P, G = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, GlobalDB

local function SpellName(id)
    local name = GetSpellInfo(id)
    if not name then
        R:Print("SpellID is not valid in unitframe aura list: "..id..".")
        return "Unknown"
    else
        return name
    end
end

local function Defaults(priorityOverride)
	return {["enable"] = true, ["priority"] = priorityOverride or 0, ["stackThreshold"] = 0}
end

G.UnitFrames.aurafilters = {}

G.UnitFrames.InvalidSpells = {
    [65148] = true,
}

G.UnitFrames.aurafilters["Blacklist"] = {
    [36900] = Defaults(), --Soul Split: Evil!
    [36901] = Defaults(), --Soul Split: Good
    [36893] = Defaults(), --Transporter Malfunction
    [114216] = Defaults(), --Angelic Bulwark
    [97821] = Defaults(), --Void-Touched
    [36032] = Defaults(), -- Arcane Charge
    [8733] = Defaults(), --Blessing of Blackfathom
    [57724] = Defaults(), --Sated
    [25771] = Defaults(), --forbearance
    [57723] = Defaults(), --Exhaustion
    [58539] = Defaults(), --watchers corpse
    [26013] = Defaults(), --deserter
    [71041] = Defaults(), --dungeon deserter
    [41425] = Defaults(), --"Hypothermia"
    [55711] = Defaults(), --Weakened Heart
    [8326] = Defaults(), --ghost
    [23445] = Defaults(), --evil twin
    [24755] = Defaults(), --gay homosexual tricked or treated debuff
    [25163] = Defaults(), --fucking annoying pet debuff oozeling disgusting aura
    [80354] = Defaults(), --timewarp debuff
    [95223] = Defaults(), --group res debuff
    [124275] = Defaults(), -- Stagger
    [124274] = Defaults(), -- Stagger
    [124273] = Defaults(), -- Stagger
    [117870] = Defaults(), -- Touch of The Titans
    [123981] = Defaults(), -- Perdition
    [15007] = Defaults(), -- Ress Sickness
    [113942] = Defaults(), -- Demonic: Gateway
    [89140] = Defaults(), -- Demonic Rebirth: Cooldown
    [95809] = Defaults(), --Insanity debuff (Hunter Pet heroism)
}

G.UnitFrames.aurafilters["Whitelist"] = {
    [31821] = Defaults(),  -- Devotion Aura
    [2825] = Defaults(),   -- Bloodlust
    [32182] = Defaults(),  -- Heroism
    [80353] = Defaults(),  -- Time Warp
    [90355] = Defaults(),  -- Ancient Hysteria
    [47788] = Defaults(),  -- Guardian Spirit
    [33206] = Defaults(),  -- Pain Suppression
    [116849] = Defaults(), -- Life Cocoon
    [22812] = Defaults(),  -- Barkskin
    [192132] = Defaults(), -- Mystic Empowerment: Thunder (Hyrja, Halls of Valor)
    [192133] = Defaults(), -- Mystic Empowerment: Holy (Hyrja, Halls of Valor)
}

G.UnitFrames.ChannelTicks = {
    --Warlock
    [SpellName(689)] = 6, -- "Drain Life"
    [SpellName(198590)] = 6, -- "Drain Soul"
    -- [SpellName(108371)] = 6, -- "Harvest Life"
    [SpellName(5740)] = 4, -- "Rain of Fire"
    [SpellName(755)] = 6, -- Health Funnel
    -- [SpellName(103103)] = 4, --Malefic Grasp
    --Druid
    --Priest
    [SpellName(48045)] = 5, -- "Mind Sear"
    [SpellName(179338)] = 5, -- "Searing insanity"
    [SpellName(64843)] = 4, -- Divine Hymn
    [SpellName(15407)] = 4, -- Mind Flay
    --Mage
    [SpellName(5143)] = 5, -- "Arcane Missiles"
    [SpellName(12051)] = 3, -- "Evocation"
}

local priestTier17 = {115560,115561,115562,115563,115564}
local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
f:SetScript("OnEvent", function(self, event)
        local class = select(2, UnitClass("player"))
        if strlower(class) ~= "priest" then return end

        local penanceTicks = 3
        local equippedPriestTier17 = 0
        for _, item in pairs(priestTier17) do
            if IsEquippedItem(item) then
                equippedPriestTier17 = equippedPriestTier17 + 1
            end
        end
        if equippedPriestTier17 >= 2 then
            penanceTicks = 4
        end
        R.global.UnitFrames.ChannelTicks[SpellName(47540)] = penanceTicks --Penance
    end)

G.UnitFrames.ChannelTicksSize = {
    --Warlock
    [SpellName(689)] = 1, -- "Drain Life"
    [SpellName(198590)] = 1, -- "Drain Soul"
}

--Spells Effected By Haste
G.UnitFrames.HastedChannelTicks = {

}
