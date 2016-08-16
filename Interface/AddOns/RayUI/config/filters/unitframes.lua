local R, L, P, G = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB

local function SpellName(id)
    local name = GetSpellInfo(id)
    if not name then
        R:Print("SpellID is not valid in unitframe aura list: "..id..".")
        return "Unknown"
    else
        return name
    end
end

G.UnitFrames.aurafilters = {}

G.UnitFrames.InvalidSpells = {
    [65148] = true,
}

G.UnitFrames.aurafilters["Blacklist"] = {
    [SpellName(36032)] = true, -- Arcane Charge
    [SpellName(8733)] = true, --Blessing of Blackfathom
    [SpellName(57724)] = true, --Sated
    [SpellName(25771)] = true, --forbearance
    [SpellName(57723)] = true, --Exhaustion
    [SpellName(36032)] = true, --arcane blast
    [SpellName(58539)] = true, --watchers corpse
    [SpellName(26013)] = true, --deserter
    [SpellName(6788)] = true, --weakended soul
    [SpellName(71041)] = true, --dungeon deserter
    [SpellName(41425)] = true, --"Hypothermia"
    [SpellName(55711)] = true, --Weakened Heart
    [SpellName(8326)] = true, --ghost
    [SpellName(23445)] = true, --evil twin
    [SpellName(24755)] = true, --gay homosexual tricked or treated debuff
    [SpellName(25163)] = true, --fucking annoying pet debuff oozeling disgusting aura
    [SpellName(80354)] = true, --timewarp debuff
    -- [SpellName(95223)] = true, --group res debuff		
}

G.UnitFrames.aurafilters["Whitelist"] = {
    [SpellName(2825)] = true, -- Bloodlust
    [SpellName(32182)] = true, -- Heroism	
    [SpellName(80353)] = true, --Time Warp
    [SpellName(90355)] = true, --Ancient Hysteria		
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