local R, L, P = unpack(select(2, ...)) --Inport: Engine, LoRA.dbles, ProfileDB
local RA = R:GetModule("Raid")

local oUF = RayUF or oUF

local spellcache = setmetatable({}, {__index=function(t,v) local a = {GetSpellInfo(v)} if GetSpellInfo(v) then t[v] = a end return a end})
local function GetSpellInfo(a)
    return unpack(spellcache[a])
end

RA.auras = {
    -- Ascending aura timer
    -- Add spells to this list to have the aura time count up from 0
    -- NOTE: This does not show the aura, it needs to be in one of the other list too.
    ascending = {
        -- [GetSpellInfo(92956)] = true, -- Wrack
    },

    -- Any Zone
    debuffs = {
        --[GetSpellInfo(6788)] = 16, -- Weakened Soul
        [GetSpellInfo(39171)] = 9, -- Mortal Strike
        [GetSpellInfo(76622)] = 9, -- Sunder Armor
    },

    buffs = {
        --[GetSpellInfo(871)] = 15, -- Shield Wall
    },

    -- Raid Debuffs
    instances = {
        [824] = {
            ---- Dragon Soul
            -- Morchok
            [GetSpellInfo(103687)] = 7,  -- RA.dbush Armor(擊碎護甲)

            -- Zon'ozz
            [GetSpellInfo(103434)] = 7, -- Disrupting Shadows(崩解之影)

            -- Yor'sahj
            [105171] = 8, -- Deep Corruption(深度腐化)
            [109389] = 8, -- Deep Corruption(深度腐化)
            [GetSpellInfo(105171)] = 7, -- Deep Corruption(深度腐化)
            [GetSpellInfo(104849)] = 9,  -- Void Bolt(虛無箭)

            -- Hagara
            [GetSpellInfo(104451)] = 7,  --寒冰之墓

            -- Ultraxion
            [GetSpellInfo(109075)] = 7, --凋零之光

            -- Blackhorn
            [GetSpellInfo(107567)] = 7,  --蠻橫打擊
            [GetSpellInfo(108043)] = 8,  --破甲攻擊
            [GetSpellInfo(107558)] = 9,  --衰亡

            -- Spine
            [GetSpellInfo(105479)] = 7, --燃燒血漿
            [GetSpellInfo(105490)] = 8,  --熾熱之握
            [GetSpellInfo(106200)] = 9,  --血液腐化:大地
            [GetSpellInfo(106199)] = 10,  --血液腐化:死亡

            -- Madness 
            [GetSpellInfo(105841)] = 7,  --退化咬擊
            [GetSpellInfo(105445)] = 8,  --極熾高熱
            [GetSpellInfo(106444)] = 9,  --刺穿
        },
        [800] = { -- Firelands

            -- Rageface
            [GetSpellInfo(99947)] = 6, -- Face Rage

            --Baleroc
            [GetSpellInfo(99256)] = 5, -- 折磨
            [GetSpellInfo(99257)] = 6, -- 受到折磨
            [GetSpellInfo(99516)] = 7, -- Countdown

            --Majordomo Staghelm
            [GetSpellInfo(98535)] = 5, -- Leaping Flames

            --Burning Orbs
            [GetSpellInfo(98451)] = 6, -- Burning Orb
        },
        [752] = { -- Baradin Hold

            [GetSpellInfo(88954)] = 6, -- Consuming Darkness
        },
    },
}
