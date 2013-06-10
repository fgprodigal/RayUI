local R, L, P, G = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB

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
		ClassBuff(114039, "BOTTOMRIGHT", {164/255, 105/255, 184/255}), -- Hand of Purity
		ClassBuff(114163, "BOTTOMLEFT", {0, 1, 0}),
		ClassBuff(20925, "TOPLEFT", {0.93, 0.75, 0}), -- Sacred Shield
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
		[930] = {
			-- Throne of Thunder
			--Trash
			[SpellName(138349)] = Defaults(7), -- Static Wound
			[SpellName(137371)] = Defaults(7), -- Thundering Throw

			--Horridon
			[SpellName(136767)] = Defaults(7), --Triple Puncture

			--Council of Elders
			[SpellName(136922)] = Defaults(9), --霜寒刺骨
			[SpellName(137650)] = Defaults(8), --幽暗之魂
			[SpellName(137641)] = Defaults(7), --Soul Fragment
			[SpellName(137359)] = Defaults(7), --Shadowed Loa Spirit Fixate
			[SpellName(137972)] = Defaults(7), --Twisted Fate

			--Tortos
			[SpellName(136753)] = Defaults(7), --Slashing Talons
			[SpellName(137633)] = Defaults(7), --Crystal Shell

			--Megaera
			[SpellName(137731)] = Defaults(7), --Ignite Flesh

			--Ji-Kun
			[SpellName(138309)] = Defaults(7), --Slimed

			--Durumu the Forgotten
			[SpellName(133767)] = Defaults(7), --Serious Wound
			[SpellName(133768)] = Defaults(7), --Arterial Cut

			--Primordius
			[SpellName(136050)] = Defaults(7), --Malformed Blood

			--Dark Animus
			[SpellName(138569)] = Defaults(7), --Explosive Slam

			--Iron Qon
			[SpellName(134691)] = Defaults(7), --Impale
			[SpellName(134647)] = Defaults(7), --Scorched

			--Twin Consorts
			[SpellName(137440)] = Defaults(7), --Icy Shadows
			[SpellName(137408)] = Defaults(7), --Fan of Flames
			[SpellName(137360)] = Defaults(7), --Corrupted Healing

			--Lei Shen
			[SpellName(135000)] = Defaults(7), --Decapitate
			[SpellName(139011)] = Defaults(8), --Decapitate

			--Ra-den

		},
        [897] = {
            -- Heart of Fear
			-- Imperial Vizier Zor'lok
			[SpellName(122761)] = Defaults(7), -- Exhale
			[SpellName(122760)] = Defaults(7), -- Exhale			
			[SpellName(123812)] = Defaults(7), --Pheromones of Zeal
			[SpellName(122740)] = Defaults(7), --Convert (MC)
			[SpellName(122706)] = Defaults(7), --Noise Cancelling (AMZ)
			-- Blade Lord Ta'yak
			[SpellName(123180)] = Defaults(7), -- Wind Step			
			[SpellName(123474)] = Defaults(7), --Overwhelming Assault
			[SpellName(122949)] = Defaults(7), --Unseen Strike
			[SpellName(124783)] = Defaults(7), --Storm Unleashed
			-- Garalon
			[SpellName(123081)] = Defaults(8), --Pungency
			[SpellName(122774)] = Defaults(7), --Crush
			-- [SpellName(123423)] = Defaults(8), --Weak Points
			-- Wind Lord Mel'jarak			
			[SpellName(121881)] = Defaults(8), --Amber Prison
			[SpellName(122055)] = Defaults(7), --Residue
			[SpellName(122064)] = Defaults(7), --Corrosive Resin
			--Amber-Shaper Un'sok
			[SpellName(121949)] = Defaults(7), --Parasitic Growth
			[SpellName(122784)] = Defaults(7), --Reshape Life
			--Grand Empress Shek'zeer
			[SpellName(123707)] = Defaults(7), --Eyes of the Empress
			[SpellName(125390)] = Defaults(7), --Fixate
			[SpellName(123788)] = Defaults(8), --Cry of Terror
			[SpellName(124097)] = Defaults(7), --Sticky Resin
			[SpellName(123184)] = Defaults(8), --Dissonance Field
			[SpellName(124777)] = Defaults(7), --Poison Bomb
			[SpellName(124821)] = Defaults(7), --Poison-Drenched Armor
			[SpellName(124827)] = Defaults(7), --Poison Fumes
			[SpellName(124849)] = Defaults(7), --Consuming Terror
			[SpellName(124863)] = Defaults(7), --Visions of Demise
			[SpellName(124862)] = Defaults(7), --Visions of Demise: Target
			[SpellName(123845)] = Defaults(7), --Heart of Fear: Chosen
			[SpellName(123846)] = Defaults(7), --Heart of Fear: Lure
			[SpellName(125283)] = Defaults(7), --Sha Corruption
        },
        [896] = {
            -- Mogu'shan Vaults
            -- The Stone Guard
			[SpellName(116281)] = Defaults(7), --Cobalt Mine Blast
			-- Feng the Accursed
			[SpellName(116784)] = Defaults(9), --Wildfire Spark
			[SpellName(116374)] = Defaults(7), --Lightning Charge
			[SpellName(116417)] = Defaults(8), --Arcane Resonance
			-- Gara'jal the Spiritbinder
			[SpellName(122151)] = Defaults(8), --Voodoo Doll
			[SpellName(116161)] = Defaults(7), --Crossed Over
			[SpellName(116278)] = Defaults(7), --Soul Sever
			-- The Spirit Kings			
			--Meng the Demented
			[SpellName(117708)] = Defaults(7), --Maddening Shout
			--Subetai the Swift
			[SpellName(118048)] = Defaults(7), --Pillaged
			[SpellName(118047)] = Defaults(7), --Pillage: Target
			[SpellName(118135)] = Defaults(7), --Pinned Down
			[SpellName(118163)] = Defaults(7), --Robbed Blind
			--Zian of the Endless Shadow
			[SpellName(118303)] = Defaults(7), --Undying Shadow: Fixate
			-- Elegon
			[SpellName(117949)] = Defaults(7), --Closed Circuit
			[SpellName(132222)] = Defaults(8), --Destabilizing Energies
			-- Will of the Emperor
			--Jan-xi and Qin-xi
			[SpellName(116835)] = Defaults(7), --Devastating Arc
			[SpellName(132425)] = Defaults(7), --Stomp
			-- Rage
			[SpellName(116525)] = Defaults(7), --Focused Assault (Rage fixate)
			-- Courage
			[SpellName(116778)] = Defaults(7), --Focused Defense (fixate)
			[SpellName(117485)] = Defaults(7), --Impeding Thrust (slow debuff)
			-- Strength
			[SpellName(116550)] = Defaults(7), --Energizing Smash (knock down)
			-- Titan Spark (Heroic)
			[SpellName(116829)] = Defaults(7), --Focused Energy (fixate)
        },
		[886] = {
            -- Terrace of Endless Spring
			-- Protectors of the Endless
			[SpellName(118091)] = Defaults(6), --Defiled Ground
			[SpellName(117519)] = Defaults(6), --Touch of Sha
			[SpellName(111850)] = Defaults(6), --Lightning Prison: Targeted
			[SpellName(117436)] = Defaults(7), --Lightning Prison: Stunned
			[SpellName(118191)] = Defaults(6), --Corrupted Essence
			[SpellName(117986)] = Defaults(7), --Defiled Ground: Stacks
			-- Tsulong
			[SpellName(122768)] = Defaults(7), --Dread Shadows
			[SpellName(122777)] = Defaults(7), --Nightmares (dispellable)
			[SpellName(122752)] = Defaults(7), --Shadow Breath
			[SpellName(122789)] = Defaults(7), --Sunbeam
			[SpellName(123012)] = Defaults(7), --Terrorize: 5% (dispellable)
			[SpellName(123011)] = Defaults(7), --Terrorize: 10% (dispellable)
			[SpellName(123036)] = Defaults(7), --Fright (dispellable)
			[SpellName(122858)] = Defaults(6), --Bathed in Light
			-- Lei Shi
			[SpellName(123121)] = Defaults(7), --Spray
			[SpellName(123705)] = Defaults(7), --Scary Fog
			-- Sha of Fear
			[SpellName(119414)] = Defaults(7), --Breath of Fear
			[SpellName(129147)] = Defaults(7), --Onimous Cackle
			[SpellName(119983)] = Defaults(7), --Dread Spray
			[SpellName(120669)] = Defaults(7), --Naked and Afraid
			[SpellName(75683)] = Defaults(7), --Waterspout

			[SpellName(120629)] = Defaults(7), --Huddle in Terror
			[SpellName(120394)] = Defaults(7), --Eternal Darkness
			[SpellName(129189)] = Defaults(7), --Sha Globe
			[SpellName(119086)] = Defaults(7), --Penetrating Bolt
			[SpellName(119775)] = Defaults(7), --Reaching Attack
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
