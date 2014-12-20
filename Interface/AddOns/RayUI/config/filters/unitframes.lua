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
    [SpellName(95223)] = true, --group res debuff		
}

G.UnitFrames.aurafilters["Whitelist"] = {
    [SpellName(2825)] = true, -- Bloodlust
    [SpellName(32182)] = true, -- Heroism	
    [SpellName(80353)] = true, --Time Warp
    [SpellName(90355)] = true, --Ancient Hysteria		
}

G.UnitFrames.ChannelTicks = {
	-- priest
	[SpellName(15407)] = 3, -- mind flay
	[SpellName(129197)] = 3, -- mind flay (insanity)
	[SpellName(32000)] = 5, -- mind sear
	[SpellName(47540)] = 3, -- penance, first tick instant
	[SpellName(64843)] = 4, -- divine hymn

	-- mage
	[SpellName(10)] = 8, -- blizzard
	[SpellName(5143)] = 5, -- arcane missiles
	[SpellName(12051)] = 4, -- evocation

	-- warlock
	[SpellName(689)] = 3, -- drain life
	[SpellName(4629)] = 4, -- rain of fire
	[SpellName(1949)] = 15, -- hellfire
	[SpellName(755)] = 3, -- health funnel
	[SpellName(103103)] = 4, -- malefic grasp

	-- druid
	[SpellName(740)] = 4, -- tranquility
	[SpellName(16914)] = 10, -- hurricane

	-- monk
	[SpellName(101546)] = 3, -- spinning crane kick
	[SpellName(115175)] = 9, -- smoothing mist
}

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:SetScript("OnEvent", function(self)
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")

	local mfTicks = 3
	if string.lower((UnitClass("player"))) == "priest" and IsSpellKnown(157223) then --Enhanced Mind Flay
		mfTicks = 4
	end

	G.UnitFrames.ChannelTicks[SpellName(15407)] = mfTicks -- "Mind Flay"
	G.UnitFrames.ChannelTicks[SpellName(129197)] = mfTicks -- "Mind Flay (Insanity)"
end)