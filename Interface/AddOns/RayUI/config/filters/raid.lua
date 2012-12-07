local R, L, P, G = unpack(select(2, ...)) --Inport: Engine, Locales, ProfileDB

local function ClassBuff(id, point, color, anyUnit, onlyShowMissing)
	local r, g, b = unpack(color)
	return {["enabled"] = true, ["id"] = id, ["point"] = point, ["color"] = {["r"] = r, ["g"] = g, ["b"] = b}, ["anyUnit"] = anyUnit, ["onlyShowMissing"] = onlyShowMissing}
end

local function SpellName(id)
	local name = GetSpellInfo(id)
	if not name then
		R:Print("SpellID is not valid in raid aura list: "..id..".")
		return "Unknown"
	else
		return name
	end
end

local function Defaults(priorityOverride)
	return {["enable"] = true, ["priority"] = priorityOverride or 0}
end

G.Raid.AuraWatch = {
	PRIEST = {
		ClassBuff(6788, "TOPRIGHT", {1, 0, 0}, true),	 -- Weakened Soul
		ClassBuff(41635, "BOTTOMRIGHT", {0.2, 0.7, 0.2}),	 -- Prayer of Mending
		ClassBuff(139, "BOTTOMLEFT", {0.4, 0.7, 0.2}), -- Renew
		ClassBuff(17, "TOPLEFT", {0.81, 0.85, 0.1}, true),	 -- Power Word: Shield
		ClassBuff(123258, "TOPLEFT", {0.81, 0.85, 0.1}, true),	 -- Power Word: Shield Power Insight
		ClassBuff(10060 , "RIGHT", {227/255, 23/255, 13/255}), -- Power Infusion
		ClassBuff(47788, "LEFT", {221/255, 117/255, 0}, true), -- Guardian Spirit
		ClassBuff(33206, "LEFT", {227/255, 23/255, 13/255}, true), -- Pain Suppression		
	},
	DRUID = {
		ClassBuff(774, "TOPRIGHT", {0.8, 0.4, 0.8}),	 -- Rejuvenation
		ClassBuff(8936, "BOTTOMLEFT", {0.2, 0.8, 0.2}),	 -- Regrowth
		ClassBuff(33763, "TOPLEFT", {0.4, 0.8, 0.2}),	 -- Lifebloom
		ClassBuff(48438, "BOTTOMRIGHT", {0.8, 0.4, 0}),	 -- Wild Growth
	},
	PALADIN = {
		ClassBuff(53563, "TOPRIGHT", {0.7, 0.3, 0.7}),	 -- Beacon of Light
		ClassBuff(1022, "BOTTOMRIGHT", {0.2, 0.2, 1}, true),	-- Hand of Protection
		ClassBuff(1044, "BOTTOMRIGHT", {0.89, 0.45, 0}, true),	-- Hand of Freedom
		ClassBuff(1038, "BOTTOMRIGHT", {0.93, 0.75, 0}, true),	-- Hand of Salvation
		ClassBuff(6940, "BOTTOMRIGHT", {0.89, 0.1, 0.1}, true),	-- Hand of Sacrifice
		ClassBuff(20925, 'TOPLEFT', {0.93, 0.75, 0}), -- Sacred Shield
	},
	SHAMAN = {
		ClassBuff(61295, "TOPRIGHT", {0.7, 0.3, 0.7}),	 -- Riptide
		ClassBuff(974, "BOTTOMLEFT", {0.2, 0.7, 0.2}, true),	 -- Earth Shield
		ClassBuff(51945, "BOTTOMRIGHT", {0.7, 0.4, 0}),	 -- Earthliving
	},
	MONK = {
		ClassBuff(119611, "TOPLEFT", {0.8, 0.4, 0.8}),	 --Renewing Mist
		ClassBuff(116849, "TOPRIGHT", {0.2, 0.8, 0.2}),	 -- Life Cocoon
		ClassBuff(132120, "BOTTOMLEFT", {0.4, 0.8, 0.2}), -- Enveloping Mist
		ClassBuff(124081, "BOTTOMRIGHT", {0.7, 0.4, 0}), -- Zen Sphere
	},
	ROGUE = {
		ClassBuff(57933, "TOPRIGHT", {227/255, 23/255, 13/255}), -- Tricks of the Trade
		ClassBuff(57934, "TOPRIGHT", {227/255, 23/255, 13/255}), -- Tricks of the Trade
	},
	MAGE = {
		ClassBuff(111264, "TOPLEFT", {0.2, 0.2, 1}), -- Ice Ward
	},
	WARRIOR = {
		ClassBuff(114030, "TOPLEFT", {0.2, 0.2, 1}), -- Vigilance
		ClassBuff(3411, "TOPRIGHT", {227/255, 23/255, 13/255}), -- Intervene	
		ClassBuff(114029, "TOPRIGHT", {227/255, 23/255, 13/255}), -- Safe Guard
	},
	DEATHKNIGHT = {
		ClassBuff(49016, "TOPRIGHT", {227/255, 23/255, 13/255}), -- Unholy Frenzy	
	},
	PET = {
		ClassBuff(19615, 'TOPLEFT', {227/255, 23/255, 13/255}, true), -- Frenzy
		ClassBuff(136, 'TOPRIGHT', {0.2, 0.8, 0.2}, true) --Mend Pet
	},
}

G.Raid.RaidDebuffs = {
    -- Ascending aura timer
    -- Add spells to this list to have the aura time count up from 0
    -- NOTE: This does not show the aura, it needs to be in one of the other list too.
    ascending = {
		[SpellName(89435)] = Defaults(),
		[SpellName(89421)] = Defaults(),
    },

    -- Any Zone
    debuffs = {
        [SpellName(15007)] = Defaults(16), -- Resurrection Sickness
        [SpellName(39171)] = Defaults(9), -- Mortal Strike
        [SpellName(76622)] = Defaults(9), -- Sunder Armor
    },

    buffs = {
        --[SpellName(871)] = Defaults(15), -- Shield Wall
    },

    -- Raid Debuffs
    instances = {
        [897] = {
            -- Heart of Fear
			-- Imperial Vizier Zor'lok
			[SpellName(122761)] = Defaults(5), -- Exhale
			[SpellName(122760)] = Defaults(5), -- Exhale
			[SpellName(122740)] = Defaults(5), -- Convert
			[SpellName(123812)] = Defaults(5), -- Pheromones of Zeal
			-- Blade Lord Ta'yak
			[SpellName(123180)] = Defaults(5), -- Wind Step
			[SpellName(123474)] = Defaults(5), -- Overwhelming Assault
			-- Garalon
			--[SpellName(122835)] = Defaults(5), -- Pheromones
			[SpellName(123081)] = Defaults(5), -- Pungency
			-- Wind Lord Mel'jarak
			[SpellName(122125)] = Defaults(5), -- Corrosive Resin Pool
			[SpellName(121885)] = Defaults(5), -- Amber Prison
			-- Wind Lord Mel'jarak
			[SpellName(121949)] = Defaults(5), -- Parasitic Growth
			-- Grand Empress Shek'zeer
        },
        [896] = {
            -- Mogu'shan Vaults
            -- The Stone Guard
			[SpellName(116281)] = Defaults(5), -- Cobalt Mine Blast
			-- Feng the Accursed
			[SpellName(116784)] = Defaults(5), -- Wildfire Spark
			[SpellName(116417)] = Defaults(5), -- Arcane Resonance
			[SpellName(116942)] = Defaults(5), -- Flaming Spear
			-- Gara'jal the Spiritbinder
			[SpellName(122151)] = Defaults(5), -- Voodoo Doll
			[SpellName(116161)] = Defaults(5), -- Crossed Over
			-- The Spirit Kings
			[SpellName(117708)] = Defaults(5), -- Maddening Shout
			[SpellName(118303)] = Defaults(6), -- Fixate
			[SpellName(118048)] = Defaults(5), -- Pillaged
			[SpellName(118135)] = Defaults(7), -- Pinned Down
			-- Elegon
			-- [SpellName(117878)] = Defaults(5), -- Overcharged
			[SpellName(117949)] = Defaults(5), -- Closed Circuit
			-- Will of the Emperor
			[SpellName(116835)] = Defaults(5), -- Devastating Arc
			[SpellName(116778)] = Defaults(6), -- Focused Defense
			[SpellName(116525)] = Defaults(6), -- Focused Assault
        },
		[886] = {
            -- Terrace of Endless Spring
			-- Protectors of the Endless
			[SpellName(117436)] = Defaults(5), -- Lightning Prison
			[SpellName(118091)] = Defaults(5), -- Defiled Ground
			[SpellName(117519)] = Defaults(5), -- Touch of Sha
			-- Tsulong
			[SpellName(122752)] = Defaults(5), -- Shadow Breath
			[SpellName(123011)] = Defaults(5), -- Terrorize
			[SpellName(116161)] = Defaults(5), -- Crossed Over
			-- Lei Shi
			[SpellName(123121)] = Defaults(5), -- Spray
			-- Sha of Fear
			[SpellName(119985)] = Defaults(5), -- Dread Spray
			[SpellName(119086)] = Defaults(5), -- Penetrating Bolt
			[SpellName(119775)] = Defaults(5), -- Reaching Attack
        },
        [824] = {
            -- Dragon Soul
            -- Morchok
            [SpellName(103687)] = Defaults(7),  -- RA.dbush Armor(擊碎護甲)

            -- Zon'ozz
            [SpellName(103434)] = Defaults(7), -- Disrupting Shadows(崩解之影)

            -- Yor'sahj
            [105171] = Defaults(8), -- Deep Corruption(深度腐化)
            [109389] = Defaults(8), -- Deep Corruption(深度腐化)
            [SpellName(105171)] = Defaults(7), -- Deep Corruption(深度腐化)
            [SpellName(104849)] = Defaults(9),  -- Void Bolt(虛無箭)

            -- Hagara
            [SpellName(104451)] = Defaults(7),  --寒冰之墓

            -- Ultraxion
            [SpellName(109075)] = Defaults(7), --凋零之光

            -- Blackhorn
            [SpellName(107567)] = Defaults(7),  --蠻橫打擊
            [SpellName(108043)] = Defaults(8),  --破甲攻擊
            [SpellName(107558)] = Defaults(9),  --衰亡

            -- Spine
            [SpellName(105479)] = Defaults(7), --燃燒血漿
            [SpellName(105490)] = Defaults(8),  --熾熱之握
            [SpellName(106200)] = Defaults(9),  --血液腐化:大地
            [SpellName(106199)] = Defaults(10),  --血液腐化:死亡

            -- Madness 
            [SpellName(105841)] = Defaults(7),  --退化咬擊
            [SpellName(105445)] = Defaults(8),  --極熾高熱
            [SpellName(106444)] = Defaults(9),  --刺穿
        },
        [800] = {
			-- Firelands
			-- Rageface
			[SpellName(99947)] = Defaults(6), -- Face Rage

			--Baleroc
			[SpellName(99256)] = Defaults(5), -- 折磨
			[SpellName(99257)] = Defaults(6), -- 受到折磨
			[SpellName(99516)] = Defaults(7), -- Countdown

			--Majordomo Staghelm
			[SpellName(98535)] = Defaults(5), -- Leaping Flames

			--Burning Orbs
			[SpellName(98451)] = Defaults(6), -- Burning Orb
        },
        [752] = {
			-- Baradin Hold
            [SpellName(88954)] = Defaults(6), -- Consuming Darkness
        },
    },
}
