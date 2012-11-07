local R, L, P = unpack(select(2, ...)) --Inport: Engine, LoRA.dbles, ProfileDB
local RA = R:GetModule("Raid")

local oUF = RayUF or oUF

local function SpellName(id)
	local name = GetSpellInfo(id)
	if not name then
		R:Print("SpellID is not valid in raid aura list: "..id..".")
		return "Unknown"
	else
		return name
	end
end

RA.auras = {
    -- Ascending aura timer
    -- Add spells to this list to have the aura time count up from 0
    -- NOTE: This does not show the aura, it needs to be in one of the other list too.
    ascending = {
		[SpellName(89435)] = true,
		[SpellName(89421)] = true,
    },

    -- Any Zone
    debuffs = {
        [SpellName(15007)] = 16, -- Resurrection Sickness
        [SpellName(39171)] = 9, -- Mortal Strike
        [SpellName(76622)] = 9, -- Sunder Armor
    },

    buffs = {
        --[SpellName(871)] = 15, -- Shield Wall
    },

    -- Raid Debuffs
    instances = {
        [897] = {
            -- Heart of Fear
			-- Imperial Vizier Zor'lok
			[SpellName(122761)] = 5, -- Exhale
			[SpellName(122760)] = 5, -- Exhale
			[SpellName(122740)] = 5, -- Convert
			[SpellName(123812)] = 5, -- Pheromones of Zeal
			-- Blade Lord Ta'yak
			[SpellName(123180)] = 5, -- Wind Step
			[SpellName(123474)] = 5, -- Overwhelming Assault
			-- Garalon
			[SpellName(122835)] = 5, -- Pheromones
			[SpellName(123081)] = 6, -- Pungency
			-- Wind Lord Mel'jarak
			[SpellName(122125)] = 5, -- Corrosive Resin Pool
			[SpellName(121885)] = 5, -- Amber Prison
			-- Wind Lord Mel'jarak
			[SpellName(121949)] = 5, -- Parasitic Growth
			-- Grand Empress Shek'zeer
        },
        [896] = {
            -- Mogu'shan Vaults
            -- The Stone Guard
			[SpellName(116281)] = 5, -- Cobalt Mine Blast
			-- Feng the Accursed
			[SpellName(116784)] = 5, -- Wildfire Spark
			[SpellName(116417)] = 5, -- Arcane Resonance
			[SpellName(116942)] = 5, -- Flaming Spear
			-- Gara'jal the Spiritbinder
			[SpellName(122151)] = 5, -- Voodoo Doll
			[SpellName(116161)] = 5, -- Crossed Over
			-- The Spirit Kings
			[SpellName(117708)] = 5, -- Maddening Shout
			[SpellName(118303)] = 6, -- Fixate
			[SpellName(118048)] = 5, -- Pillaged
			[SpellName(118135)] = 7, -- Pinned Down
			-- Elegon
			-- [SpellName(117878)] = 5, -- Overcharged
			[SpellName(117949)] = 5, -- Closed Circuit
			-- Will of the Emperor
			[SpellName(116835)] = 5, -- Devastating Arc
			[SpellName(116778)] = 6, -- Focused Defense
			[SpellName(116525)] = 6, -- Focused Assault
        },
		[886] = {
            -- Terrace of Endless Spring
			-- Protectors of the Endless
			[SpellName(117436)] = 5, -- Lightning Prison
			[SpellName(118091)] = 5, -- Defiled Ground
			[SpellName(117519)] = 5, -- Touch of Sha
			-- Tsulong
			[SpellName(122752)] = 5, -- Shadow Breath
			[SpellName(123011)] = 5, -- Terrorize
			[SpellName(116161)] = 5, -- Crossed Over
			-- Lei Shi
			[SpellName(123121)] = 5, -- Spray
			-- Sha of Fear
			[SpellName(119985)] = 5, -- Dread Spray
			[SpellName(119086)] = 5, -- Penetrating Bolt
			[SpellName(119775)] = 5, -- Reaching Attack
        },
        [824] = {
            -- Dragon Soul
            -- Morchok
            [SpellName(103687)] = 7,  -- RA.dbush Armor(擊碎護甲)

            -- Zon'ozz
            [SpellName(103434)] = 7, -- Disrupting Shadows(崩解之影)

            -- Yor'sahj
            [105171] = 8, -- Deep Corruption(深度腐化)
            [109389] = 8, -- Deep Corruption(深度腐化)
            [SpellName(105171)] = 7, -- Deep Corruption(深度腐化)
            [SpellName(104849)] = 9,  -- Void Bolt(虛無箭)

            -- Hagara
            [SpellName(104451)] = 7,  --寒冰之墓

            -- Ultraxion
            [SpellName(109075)] = 7, --凋零之光

            -- Blackhorn
            [SpellName(107567)] = 7,  --蠻橫打擊
            [SpellName(108043)] = 8,  --破甲攻擊
            [SpellName(107558)] = 9,  --衰亡

            -- Spine
            [SpellName(105479)] = 7, --燃燒血漿
            [SpellName(105490)] = 8,  --熾熱之握
            [SpellName(106200)] = 9,  --血液腐化:大地
            [SpellName(106199)] = 10,  --血液腐化:死亡

            -- Madness 
            [SpellName(105841)] = 7,  --退化咬擊
            [SpellName(105445)] = 8,  --極熾高熱
            [SpellName(106444)] = 9,  --刺穿
        },
        [800] = {
			-- Firelands
			-- Rageface
			[SpellName(99947)] = 6, -- Face Rage

			--Baleroc
			[SpellName(99256)] = 5, -- 折磨
			[SpellName(99257)] = 6, -- 受到折磨
			[SpellName(99516)] = 7, -- Countdown

			--Majordomo Staghelm
			[SpellName(98535)] = 5, -- Leaping Flames

			--Burning Orbs
			[SpellName(98451)] = 6, -- Burning Orb
        },
        [752] = {
			-- Baradin Hold
            [SpellName(88954)] = 6, -- Consuming Darkness
        },
    },
}
