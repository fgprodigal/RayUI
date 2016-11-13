local R, L, P, G = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, GlobalDB

--Cache global variables
--Lua functions
local unpack = unpack

--WoW API / Variables
local GetSpellInfo = GetSpellInfo

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
    return {["enable"] = true, ["priority"] = priorityOverride or 0, ["stackThreshold"] = 0}
end

G.Raid.AuraWatch = {
    PRIEST = {
        [194384] = ClassBuff(194384, "TOPRIGHT", {1, 0, 0.75}, true), -- Atonement
        [41635] = ClassBuff(41635, "BOTTOMRIGHT", {0.2, 0.7, 0.2}), -- Prayer of Mending
        [139] = ClassBuff(139, "BOTTOMLEFT", {0.4, 0.7, 0.2}), -- Renew
        [17] = ClassBuff(17, "TOPLEFT", {0.81, 0.85, 0.1}, true), -- Power Word: Shield
        [47788] = ClassBuff(47788, "LEFT", {221/255, 117/255, 0}, true), -- Guardian Spirit
        [33206] = ClassBuff(33206, "LEFT", {227/255, 23/255, 13/255}, true), -- Pain Suppression
    },
    DRUID = {
        [774] = ClassBuff(774, "TOPRIGHT", {0.8, 0.4, 0.8}), -- Rejuvenation
        [155777] = ClassBuff(155777, "RIGHT", {0.8, 0.4, 0.8}), -- Germination
        [8936] = ClassBuff(8936, "BOTTOMLEFT", {0.2, 0.8, 0.2}), -- Regrowth
        [33763] = ClassBuff(33763, "TOPLEFT", {0.4, 0.8, 0.2}), -- Lifebloom
        [188550] = ClassBuff(188550, "TOPLEFT", {0.4, 0.8, 0.2}), -- Lifebloom T18 4pc
        [48438] = ClassBuff(48438, "BOTTOMRIGHT", {0.8, 0.4, 0}), -- Wild Growth
        [207386] = ClassBuff(207386, "TOP", {0.4, 0.2, 0.8}), -- Spring Blossoms
        [102352] = ClassBuff(102352, "LEFT", {0.2, 0.8, 0.8}), -- Cenarion Ward
        [200389] = ClassBuff(200389, "BOTTOM", {1, 1, 0.4}), -- Cultivation
    },
    PALADIN = {
        [53563] = ClassBuff(53563, "TOPRIGHT", {0.7, 0.3, 0.7}), -- Beacon of Light
        [156910] = ClassBuff(156910, "TOPRIGHT", {0.7, 0.3, 0.7}), -- Beacon of Faith
        [1022] = ClassBuff(1022, "BOTTOMRIGHT", {0.2, 0.2, 1}, true), -- Hand of Protection
        [1044] = ClassBuff(1044, "BOTTOMRIGHT", {0.89, 0.45, 0}, true), -- Hand of Freedom
        [6940] = ClassBuff(6940, "BOTTOMRIGHT", {0.89, 0.1, 0.1}, true), -- Hand of Sacrifice
        [114163] = ClassBuff(114163, 'BOTTOMLEFT', {0.87, 0.7, 0.03}), -- Eternal Flame
    },
    SHAMAN = {
        [61295] = ClassBuff(61295, "TOPRIGHT", {0.7, 0.3, 0.7}), -- Riptide
    },
    MONK = {
        [119611] = ClassBuff(119611, "TOPLEFT", {0.8, 0.4, 0.8}), --Renewing Mist
        [116849] = ClassBuff(116849, "TOPRIGHT", {0.2, 0.8, 0.2}), -- Life Cocoon
        [124682] = ClassBuff(124682, "BOTTOMLEFT", {0.4, 0.8, 0.2}), -- Enveloping Mist
        [124081] = ClassBuff(124081, "BOTTOMRIGHT", {0.7, 0.4, 0}), -- Zen Sphere
    },
    ROGUE = {
        [57934] = ClassBuff(57934, "TOPRIGHT", {227/255, 23/255, 13/255}), -- Tricks of the Trade
    },
    WARRIOR = {
        [114030] = ClassBuff(114030, "TOPLEFT", {0.2, 0.2, 1}), -- Vigilance
        [3411] = ClassBuff(3411, "TOPRIGHT", {227/255, 23/255, 13/255}), -- Intervene
    },
    PET = {
        [19615] = ClassBuff(19615, 'TOPLEFT', {227/255, 23/255, 13/255}, true), -- Frenzy
        [136] = ClassBuff(136, 'TOPRIGHT', {0.2, 0.8, 0.2}, true) --Mend Pet
    },
    HUNTER = {}, --Keep even if it's an empty table, so a reference to G.unitframe.buffwatch[E.myclass][SomeValue] doesn't trigger error
    DEMONHUNTER = {},
    WARLOCK = {},
    MAGE = {},
    DEATHKNIGHT = {},
}

G.ReverseTimer = {

}

G.Raid.RaidDebuffs = {
    -- Ascending aura timer
    -- Add spells to this list to have the aura time count up from 0
    -- NOTE: This does not show the aura, it needs to be in one of the other list too.
    ascending = {
        [89435] = Defaults(5),
        [89421] = Defaults(5),
    },

    -- Any Zone
    debuffs = {
        [15007] = Defaults(16), -- Resurrection Sickness
        [39171] = Defaults(9), -- Mortal Strike
        [76622] = Defaults(9), -- Sunder Armor
    },

    buffs = {
        --[871] = Defaults(15), -- Shield Wall
    },

    -- Raid Debuffs
    instances = {
        [1114] = {
            -- Trial of Valor
            -- Odyn
            [227959] = Defaults(), -- Storm of Justice
            [227475] = Defaults(), -- Cleansing Flame
            [192044] = Defaults(), -- Expel Light
            [227781] = Defaults(), -- Glowing Fragment
            -- Guarm
            [228228] = Defaults(), -- Flame Lick
            [228248] = Defaults(), -- Frost Lick
            [228253] = Defaults(), -- Shadow Lick
            [227539] = Defaults(), -- Fiery Phlegm
            [227566] = Defaults(), -- Salty Spittle
            [227570] = Defaults(), -- Dark Discharge
            -- Helya
            [227903] = Defaults(), -- Orb of Corruption
            [228058] = Defaults(), -- Orb of Corrosion
            [228054] = Defaults(), -- Taint of the Sea
            [193367] = Defaults(), -- Fetid Rot
            [227982] = Defaults(), -- Bilewater Redox
            [228519] = Defaults(), -- Anchor Slam
            [202476] = Defaults(), -- Rabid
            [232450] = Defaults(), -- Corrupted Axion
        },
        [1094] = {
            -- The Emerald Nightmare
            -- Nythendra
            [204504] = Defaults(), -- Infested
            [205043] = Defaults(), -- Infested mind
            [203096] = Defaults(), -- Rot
            [204463] = Defaults(), -- Volatile Rot
            [203045] = Defaults(), -- Infested Ground
            [203646] = Defaults(), -- Burst of Corruption

            -- Elerethe Renferal
            [210228] = Defaults(), -- Dripping Fangs
            [215307] = Defaults(), -- Web of Pain
            [215300] = Defaults(), -- Web of Pain
            [215460] = Defaults(), -- Necrotic Venom
            [213124] = Defaults(), -- Venomous Pool
            [210850] = Defaults(), -- Twisting Shadows
            [215489] = Defaults(), -- Venomous Pool

            -- Il'gynoth, Heart of the Corruption
            [208929] = Defaults(), -- Spew Corruption
            [210984] = Defaults(), -- Eye of Fate
            [209469] = Defaults(5), -- Touch of Corruption
            [208697] = Defaults(), -- Mind Flay

            -- Ursoc
            [198108] = Defaults(), -- Unbalanced
            [197943] = Defaults(), -- Overwhelm
            [204859] = Defaults(), -- Rend Flesh
            [205611] = Defaults(), -- Miasma
            [198006] = Defaults(), -- Focused Gaze
            [197980] = Defaults(), -- Nightmarish Cacophony

            -- Dragons of Nightmare
            [203102] = Defaults(), -- Mark of Ysondre
            [203121] = Defaults(), -- Mark of Taerar
            [203125] = Defaults(), -- Mark of Emeriss
            [203124] = Defaults(), -- Mark of Lethon
            [204731] = Defaults(5), -- Wasting Dread
            [203110] = Defaults(5), -- Slumbering Nightmare
            [207681] = Defaults(5), -- Nightmare Bloom
            [205341] = Defaults(5), -- Sleeping Fog
            [203770] = Defaults(5), -- Defiled Vines
            [203787] = Defaults(5), -- Volatile Infection

            -- Cenarius
            [210279] = Defaults(), -- Creeping Nightmares
            [213162] = Defaults(), -- Nightmare Blast
            [210315] = Defaults(), -- Nightmare Brambles
            [212681] = Defaults(), -- Cleansed Ground
            [211507] = Defaults(), -- Nightmare Javelin
            [211471] = Defaults(), -- Scorned Touch
            [211612] = Defaults(), -- Replenishing Roots
            [216516] = Defaults(), -- Ancient Dream

            -- Xavius
            [206005] = Defaults(), -- Dream Simulacrum
            [206651] = Defaults(), -- Darkening Soul
            [209158] = Defaults(), -- Blackening Soul
            [211802] = Defaults(), -- Nightmare Blades
            [206109] = Defaults(), -- Awakening to the Nightmare
            [209034] = Defaults(), -- Bonds of Terror
            [210451] = Defaults(), -- Bonds of Terror
            [208431] = Defaults(), -- Corruption: Descent into Madness
            [207409] = Defaults(), -- Madness
            [211634] = Defaults(), -- The Infinite Dark
            [208385] = Defaults(), -- Tainted Discharge
        },
        [1088] = {
            -- The Nighthold
            -- Skorpyron
            [204766] = Defaults(), -- Energy Surge
            [214718] = Defaults(), -- Acidic Fragments
            [211801] = Defaults(), -- Volatile Fragments
            [204284] = Defaults(), -- Broken Shard (Protection)
            [204275] = Defaults(), -- Arcanoslash (Tank)
            [211659] = Defaults(), -- Arcane Tether (Tank debuff)
            [204483] = Defaults(), -- Focused Blast (Stun)

            -- Chronomatic Anomaly
            [206607] = Defaults(), -- Chronometric Particles (Tank stack debuff)
            [206609] = Defaults(), -- Time Release (Heal buff/debuff)
            [205653] = Defaults(), -- Passage of Time
            [225901] = Defaults(), -- Time Bomb
            [207871] = Defaults(), -- Vortex (Mythic)
            [212099] = Defaults(), -- Temporal Charge

            -- Trilliax
            [206488] = Defaults(), -- Arcane Seepage
            [206641] = Defaults(), -- Arcane Spear (Tank)
            [206798] = Defaults(), -- Toxic Slice
            [214672] = Defaults(), -- Annihilation
            [214573] = Defaults(), -- Stuffed
            [214583] = Defaults(), -- Sterilize
            [208910] = Defaults(), -- Arcing Bonds
            [206838] = Defaults(), -- Succulent Feast

            -- Spellblade Aluriel
            [212492] = Defaults(), -- Annihilate (Tank)
            [212494] = Defaults(), -- Annihilated (Main Tank debuff)
            [212587] = Defaults(), -- Mark of Frost
            [212531] = Defaults(), -- Mark of Frost (marked)
            [212530] = Defaults(), -- Replicate: Mark of Frost
            [212647] = Defaults(), -- Frostbitten
            [212736] = Defaults(), -- Pool of Frost
            [213085] = Defaults(), -- Frozen Tempest
            [213621] = Defaults(), -- Entombed in Ice
            [213148] = Defaults(), -- Searing Brand Chosen
            [213181] = Defaults(), -- Searing Brand Stunned
            [213166] = Defaults(), -- Searing Brand
            [213278] = Defaults(), -- Burning Ground
            [213504] = Defaults(), -- Arcane Fog

            -- Tichondrius
            [206480] = Defaults(), -- Carrion Plague
            [215988] = Defaults(), -- Carrion Nightmare
            [208230] = Defaults(), -- Feast of Blood
            [212794] = Defaults(), -- Brand of Argus
            [216685] = Defaults(), -- Flames of Argus
            [206311] = Defaults(), -- Illusionary Night
            [206466] = Defaults(), -- Essence of Night
            [216024] = Defaults(), -- Volatile Wound
            [216027] = Defaults(), -- Nether Zone
            [216039] = Defaults(), -- Fel Storm
            [216726] = Defaults(), -- Ring of Shadows
            [216040] = Defaults(), -- Burning Soul

            -- Krosus
            [206677] = Defaults(), -- Searing Brand
            [205344] = Defaults(), -- Orb of Destruction

            -- High Botanist Tel'arn
            [218503] = Defaults(), -- Recursive Strikes (Tank)
            [219235] = Defaults(), -- Toxic Spores
            [218809] = Defaults(), -- Call of Night
            [218342] = Defaults(), -- Parasitic Fixate
            [218304] = Defaults(), -- Parasitic Fetter
            [218780] = Defaults(), -- Plasma Explosion

            -- Star Augur Etraeus
            [205984] = Defaults(), -- Gravitaional Pull
            [214167] = Defaults(), -- Gravitaional Pull
            [214335] = Defaults(), -- Gravitaional Pull
            [206936] = Defaults(), -- Icy Ejection
            [206388] = Defaults(), -- Felburst
            [206585] = Defaults(), -- Absolute Zero
            [206398] = Defaults(), -- Felflame
            [206589] = Defaults(), -- Chilled
            [205649] = Defaults(), -- Fel Ejection
            [206965] = Defaults(), -- Voidburst
            [206464] = Defaults(), -- Coronal Ejection
            [207143] = Defaults(), -- Void Ejection
            [206603] = Defaults(), -- Frozen Solid
            [207720] = Defaults(), -- Witness the Void
            [216697] = Defaults(), -- Frigid Pulse

            -- Grand Magistrix Elisande
            [209166] = Defaults(), -- Fast Time
            [211887] = Defaults(), -- Ablated
            [209615] = Defaults(), -- Ablation
            [209244] = Defaults(), -- Delphuric Beam
            [209165] = Defaults(), -- Slow Time
            [209598] = Defaults(), -- Conflexive Burst
            [209433] = Defaults(), -- Spanning Singularity
            [209973] = Defaults(), -- Ablating Explosion
            [209549] = Defaults(), -- Lingering Burn
            [211261] = Defaults(), -- Permaliative Torment
            [208659] = Defaults(), -- Arcanetic Ring

            -- Gul'dan
            [210339] = Defaults(), -- Time Dilation
            [180079] = Defaults(), -- Felfire Munitions
            [206875] = Defaults(), -- Fel Obelisk (Tank)
            [206840] = Defaults(), -- Gaze of Vethriz
            [206896] = Defaults(), -- Torn Soul
            [206221] = Defaults(), -- Empowered Bonds of Fel
            [208802] = Defaults(), -- Soul Corrosion
            [212686] = Defaults(), -- Flames of Sargeras
        },
        [1026] = {
            -- Hellfire Citadel

            -- Hellfire Assault
            [184369] = Defaults(5), -- Howling Axe (Target)
            [180079] = Defaults(5), -- Felfire Munitions

            -- Iron Reaver
            [179897] = Defaults(5), -- Blitz
            [185978] = Defaults(5), -- Firebomb Vulnerability
            [182373] = Defaults(5), -- Flame Vulnerability
            [182280] = Defaults(5), -- Artillery (Target)
            [182074] = Defaults(5), -- Immolation
            [182001] = Defaults(5), -- Unstable Orb

            -- Kormrok
            [187819] = Defaults(5), -- Crush
            [181345] = Defaults(5), -- Foul Crush

            -- Hellfire High Council
            [184360] = Defaults(5), -- Fel Rage
            [184449] = Defaults(5), -- Mark of the Necromancer
            [185065] = Defaults(5), -- Mark of the Necromancer
            [184450] = Defaults(5), -- Mark of the Necromancer
            [185066] = Defaults(5), -- Mark of the Necromancer
            [184676] = Defaults(5), -- Mark of the Necromancer
            [184652] = Defaults(5), -- Reap

            -- Kilrogg Deadeye
            [181488] = Defaults(5), -- Vision of Death
            [188929] = Defaults(5), -- Heart Seeker (Target)
            [180389] = Defaults(5), -- Heart Seeker (DoT)

            -- Gorefiend
            [179867] = Defaults(5), -- Gorefiend's Corruption
            [181295] = Defaults(5), -- Digest
            [179977] = Defaults(5), -- Touch of Doom
            [179864] = Defaults(5), -- Shadow of Death
            [179909] = Defaults(5), -- Shared Fate (self root)
            [179908] = Defaults(5), -- Shared Fate (other players root)

            -- Shadow-Lord Iskar
            [181957] = Defaults(5), -- Phantasmal Winds
            [182200] = Defaults(5), -- Fel Chakram
            [182178] = Defaults(5), -- Fel Chakram
            [182325] = Defaults(5), -- Phantasmal Wounds
            [185239] = Defaults(5), -- Radiance of Anzu
            [185510] = Defaults(5), -- Dark Bindings
            [182600] = Defaults(5), -- Fel Fire
            [179219] = Defaults(5), -- Phantasmal Fel Bomb
            [181753] = Defaults(5), -- Fel Bomb

            -- Soulbound Construct (Socrethar)
            [182038] = Defaults(5), -- Shattered Defenses
            [188666] = Defaults(5), -- Eternal Hunger (Add fixate, Mythic only)
            [189627] = Defaults(5), -- Volatile Fel Orb (Fixated)
            [180415] = Defaults(5), -- Fel Prison

            -- Tyrant Velhari
            [185237] = Defaults(5), -- Touch of Harm
            [185238] = Defaults(5), -- Touch of Harm
            [185241] = Defaults(5), -- Edict of Condemnation
            [180526] = Defaults(5), -- Font of Corruption

            -- Fel Lord Zakuun
            [181508] = Defaults(5), -- Seed of Destruction
            [181653] = Defaults(5), -- Fel Crystals (Too Close)
            [179428] = Defaults(5), -- Rumbling Fissure (Soak)
            [182008] = Defaults(5), -- Latent Energy (Cannot soak)
            [179407] = Defaults(5), -- Disembodied (Player in Shadow Realm)

            -- Xhul'horac
            [188208] = Defaults(5), -- Ablaze
            [186073] = Defaults(5), -- Felsinged
            [186407] = Defaults(5), -- Fel Surge
            [186500] = Defaults(5), -- Chains of Fel
            [186063] = Defaults(5), -- Wasting Void
            [186333] = Defaults(5), -- Void Surge

            -- Mannoroth
            [181275] = Defaults(5), -- Curse of the Legion
            [181099] = Defaults(5), -- Mark of Doom
            [181597] = Defaults(5), -- Mannoroth's Gaze
            [182006] = Defaults(5), -- Empowered Mannoroth's Gaze
            [181841] = Defaults(5), -- Shadowforce
            [182088] = Defaults(5), -- Empowered Shadowforce

            -- Archimonde
            [184964] = Defaults(5), -- Shackled Torment
            [186123] = Defaults(5), -- Wrought Chaos
            [185014] = Defaults(5), -- Focused Chaos
            [186952] = Defaults(5), -- Nether Banish
            [186961] = Defaults(5), -- Nether Banish
            [189891] = Defaults(5), -- Nether Tear
            [183634] = Defaults(5), -- Shadowfel Burst
            [189895] = Defaults(5), -- Void Star Fixate
            [190049] = Defaults(5), -- Nether Corruption
        },
        [988] = {
            -- 黑石铸造厂
            --格鲁尔

            [155080] = Defaults(4), -- 煉獄切割 分担组DOT
            [155078] = Defaults(3), -- 压迫打击 普攻坦克易伤
            [162322] = Defaults(5), -- 炼狱打击 吃刀坦克易伤
            [155506] = Defaults(2), -- 石化

            --奥尔高格

            [156203] = Defaults(5), -- 呕吐黑石 远程躲
            [156374] = Defaults(5), -- 爆炸裂片 近战躲
            [156297] = Defaults(3), -- 酸液洪流 副坦克易伤
            [173471] = Defaults(4), -- 酸液巨口 主坦克DOT
            [155900] = Defaults(2), -- 翻滚之怒 击倒

            --爆裂熔炉

            [156932] = Defaults(5), -- 崩裂
            [178279] = Defaults(4), -- 炸弹
            [155192] = Defaults(4), -- 炸弹
            [176121] = Defaults(6), -- 不稳定的火焰 点名八码爆炸
            [155196] = Defaults(2), -- 锁定
            [155743] = Defaults(5), -- 熔渣池
            [155240] = Defaults(3), -- 淬火 坦克易伤
            [155242] = Defaults(3), -- 高热 三层换坦
            [155225] = Defaults(5), -- 熔化 点名
            [155223] = Defaults(5), -- 熔化

            --汉斯加尔与弗兰佐克

            [157139] = Defaults(3), -- 折脊碎椎 跳跃易伤
            [160838] = Defaults(2), -- 干扰怒吼
            [160845] = Defaults(2), -- 干扰怒吼
            [160847] = Defaults(2), -- 干扰怒吼
            [160848] = Defaults(2), -- 干扰怒吼
            [155818] = Defaults(4), -- 灼热燃烧 场地边缘的火

            --缚火者卡格拉兹

            [154952] = Defaults(3), -- 锁定
            [155074] = Defaults(1), -- 焦灼吐息 坦克易伤
            [155049] = Defaults(2), -- 火焰链接
            [154932] = Defaults(4), -- 熔岩激流 点名分摊
            [155277] = Defaults(5), -- 炽热光辉 点名AOE
            [155314] = Defaults(1), -- 岩浆猛击 冲锋火线
            [163284] = Defaults(2), -- 升腾烈焰 坦克DOT

            --克罗莫格

            [156766] = Defaults(1), -- 扭曲护甲 坦克易伤
            [157059] = Defaults(2), -- 纠缠之地符文
            [161839] = Defaults(3), -- 破碎大地符文
            [161923] = Defaults(3), -- 破碎大地符文

            --兽王达玛克

            [154960] = Defaults(4), -- 长矛钉刺
            [155061] = Defaults(1), -- 狂乱撕扯 狼阶段流血
            [162283] = Defaults(1), -- 狂乱撕扯 BOSS继承的流血
            [154989] = Defaults(3), -- 炼狱吐息
            [154981] = Defaults(5), -- 爆燃 秒驱
            [155030] = Defaults(2), -- 炽燃利齿 龙阶段坦克易伤
            [155236] = Defaults(2), -- 碾碎护甲 象阶段坦克易伤
            [155499] = Defaults(3), -- 高热弹片
            [155657] = Defaults(4), -- 烈焰灌注
            [159044] = Defaults(1), -- 强震
            [162277] = Defaults(1), -- 强震

            --主管索戈尔

            [155921] = Defaults(2), -- 点燃 坦克易伤
            [165195] = Defaults(4), -- 实验型脉冲手雷
            [156310] = Defaults(3), -- 熔岩震击
            [159481] = Defaults(3), -- 延时攻城炸弹
            [164380] = Defaults(2), -- 燃烧
            [164280] = Defaults(2), -- 热能冲击

            --钢铁女武神

            [156631] = Defaults(2), -- 急速射击
            [164271] = Defaults(3), -- 穿透射击
            [158601] = Defaults(1), -- 主炮轰击
            [156214] = Defaults(4), -- 震颤暗影
            [158315] = Defaults(2), -- 暗影猎杀
            [159724] = Defaults(3), -- 鲜血仪式
            [158010] = Defaults(2), -- 浸血觅心者
            [158692] = Defaults(1), -- 致命投掷
            [158702] = Defaults(2), -- 锁定
            [158683] = Defaults(3), -- 堕落之血

            --Blackhand
            [156096] = Defaults(5), --MARKEDFORDEATH
            [156107] = Defaults(4), --IMPALED
            [156047] = Defaults(2), --SLAGGED
            [156401] = Defaults(4), --MOLTENSLAG
            [156404] = Defaults(3), --BURNED
            [158054] = Defaults(4), --SHATTERINGSMASH 158054 155992 159142
            [156888] = Defaults(5), --OVERHEATED
            [157000] = Defaults(2), --ATTACHSLAGBOMBS
        },
        [994] = {
            --悬槌堡
            -- 1 卡加斯

            [158986] = Defaults(2), -- 冲锋
            [159178] = Defaults(5), -- 迸裂创伤
            [162497] = Defaults(3), -- 搜寻猎物
            [163130] = Defaults(3), -- 着火

            -- 2 屠夫

            [156151] = Defaults(3), -- 捶肉槌
            [156147] = Defaults(5), -- 切肉刀
            [156152] = Defaults(3), -- 龟裂创伤
            [163046] = Defaults(4), -- 白鬼硫酸

            -- 3 泰克图斯

            [162346] = Defaults(4), -- 晶化弹幕 点名
            [162370] = Defaults(3), -- 晶化弹幕 踩到

            -- 4 布兰肯斯波

            [163242] = Defaults(5), -- 感染孢子
            [159426] = Defaults(5), -- 回春孢子
            [163241] = Defaults(4), -- 溃烂
            [159220] = Defaults(2), -- 死疽吐息
            [160179] = Defaults(2), -- 蚀脑真菌
            [165223] = Defaults(6), -- 爆裂灌注
            [163666] = Defaults(3), -- 脉冲高热

            -- 5 独眼魔双子

            [155569] = Defaults(3), -- 受伤
            [158241] = Defaults(4), -- 烈焰
            [163372] = Defaults(4), -- 奥能动荡
            [167200] = Defaults(3), -- 奥术致伤
            [163297] = Defaults(3), -- 扭曲奥能

            -- 6 克拉戈

            [172813] = Defaults(5), -- 魔能散射：冰霜
            [162185] = Defaults(5), -- 魔能散射：火焰
            [162184] = Defaults(3), -- 魔能散射：暗影
            [162186] = Defaults(2), -- 魔能散射：奥术
            [161345] = Defaults(2), -- 压制力场
            [161242] = Defaults(3), -- 废灵标记
            [172886] = Defaults(4), -- 废灵璧垒
            [172895] = Defaults(4), -- 魔能散射：邪能 点名
            [172917] = Defaults(4), -- 魔能散射：邪能 踩到
            [163472] = Defaults(2), -- 统御之力

            -- 7 元首

            [157763] = Defaults(3), -- 锁定
            [159515] = Defaults(4), -- 狂莽突击
            [156225] = Defaults(4), -- 烙印
            [164004] = Defaults(4), -- 烙印：偏移
            [164006] = Defaults(4), -- 烙印：强固
            [164005] = Defaults(4), -- 烙印：复制
            [158605] = Defaults(2), -- 混沌标记
            [164176] = Defaults(2), -- 混沌标记：偏移
            [164178] = Defaults(2), -- 混沌标记：强固
            [164191] = Defaults(2), -- 混沌标记：复制

        },
        [953] = {
            --Siege of Orgrimmar
            --Immerseus
            [143297] = Defaults(5), --Sha Splash
            [143459] = Defaults(4), --Sha Residue
            [143524] = Defaults(4), --Purified Residue
            [143286] = Defaults(4), --Seeping Sha
            [143413] = Defaults(3), --Swirl
            [143411] = Defaults(3), --Swirl
            [143436] = Defaults(2), --Corrosive Blast (tanks)
            [143579] = Defaults(3), --Sha Corruption (Heroic Only)

            --Fallen Protectors
            [143239] = Defaults(4), --Noxious Poison
            [144176] = Defaults(2), --Lingering Anguish
            [143023] = Defaults(3), --Corrupted Brew
            [143301] = Defaults(2), --Gouge
            [143564] = Defaults(3), --Meditative Field
            [143010] = Defaults(3), --Corruptive Kick
            [143434] = Defaults(6), --Shadow Word:Bane (Dispell)
            [143840] = Defaults(6), --Mark of Anguish
            [143959] = Defaults(4), --Defiled Ground
            [143423] = Defaults(6), --Sha Sear
            [143292] = Defaults(5), --Fixate
            [144176] = Defaults(5), --Shadow Weakness
            [147383] = Defaults(4), --Debilitation (Heroic Only)

            --Norushen
            [146124] = Defaults(2), --Self Doubt (tanks)
            [146324] = Defaults(4), --Jealousy
            [144639] = Defaults(6), --Corruption
            [144850] = Defaults(5), --Test of Reliance
            [145861] = Defaults(6), --Self-Absorbed (Dispell)
            [144851] = Defaults(2), --Test of Confiidence (tanks)
            [146703] = Defaults(3), --Bottomless Pit
            [144514] = Defaults(6), --Lingering Corruption
            [144849] = Defaults(4), --Test of Serenity

            --Sha of Pride
            [144358] = Defaults(2), --Wounded Pride (tanks)
            [144843] = Defaults(3), --Overcome
            [146594] = Defaults(4), --Gift of the Titans
            [144351] = Defaults(6), --Mark of Arrogance
            [144364] = Defaults(4), --Power of the Titans
            [146822] = Defaults(6), --Projection
            [146817] = Defaults(5), --Aura of Pride
            [144774] = Defaults(2), --Reaching Attacks (tanks)
            [144636] = Defaults(5), --Corrupted Prison
            [144574] = Defaults(6), --Corrupted Prison
            [145215] = Defaults(4), --Banishment (Heroic)
            [147207] = Defaults(4), --Weakened Resolve (Heroic)
            [144574] = Defaults(6), --Corrupted Prison
            [144574] = Defaults(6), --Corrupted Prison

            --Galakras
            [146765] = Defaults(5), --Flame Arrows
            [147705] = Defaults(5), --Poison Cloud
            [146902] = Defaults(2), --Poison Tipped blades

            --Iron Juggernaut
            [144467] = Defaults(2), --Ignite Armor
            [144459] = Defaults(5), --Laser Burn
            [144498] = Defaults(5), --Napalm Oil
            [144918] = Defaults(5), --Cutter Laser
            [146325] = Defaults(6), --Cutter Laser Target

            --Kor'kron Dark Shaman
            [144089] = Defaults(6), --Toxic Mist
            [144215] = Defaults(2), --Froststorm Strike (Tank only)
            [143990] = Defaults(2), --Foul Geyser (Tank only)
            [144304] = Defaults(2), --Rend
            [144330] = Defaults(6), --Iron Prison (Heroic)

            --General Nazgrim
            [143638] = Defaults(6), --Bonecracker
            [143480] = Defaults(5), --Assassin's Mark
            [143431] = Defaults(6), --Magistrike (Dispell)
            [143494] = Defaults(2), --Sundering Blow (Tanks)
            [143882] = Defaults(5), --Hunter's Mark

            --Malkorok
            [142990] = Defaults(2), --Fatal Strike (Tank debuff)
            [142913] = Defaults(6), --Displaced Energy (Dispell)
            [142863] = Defaults(1), --Strong Ancient Barrier
            [142864] = Defaults(1), --Strong Ancient Barrier
            [142865] = Defaults(1), --Strong Ancient Barrier
            [143919] = Defaults(5), --Languish (Heroic)

            --Spoils of Pandaria
            [145685] = Defaults(2), --Unstable Defensive System
            [144853] = Defaults(3), --Carnivorous Bite
            [145987] = Defaults(5), --Set to Blow
            [145218] = Defaults(4), --Harden Flesh
            [145230] = Defaults(1), --Forbidden Magic
            [146217] = Defaults(4), --Keg Toss
            [146235] = Defaults(4), --Breath of Fire
            [145523] = Defaults(4), --Animated Strike
            [142983] = Defaults(6), --Torment (the new Wrack)
            [145715] = Defaults(3), --Blazing Charge
            [145747] = Defaults(5), --Bubbling Amber
            [146289] = Defaults(4), --Mass Paralysis

            --Thok the Bloodthirsty
            [143766] = Defaults(2), --Panic (tanks)
            [143773] = Defaults(2), --Freezing Breath (tanks)
            [143452] = Defaults(1), --Bloodied
            [146589] = Defaults(5), --Skeleton Key (tanks)
            [143445] = Defaults(6), --Fixate
            [143791] = Defaults(5), --Corrosive Blood
            [143777] = Defaults(3), --Frozen Solid (tanks)
            [143780] = Defaults(4), --Acid Breath
            [143800] = Defaults(5), --Icy Blood
            [143428] = Defaults(4), --Tail Lash

            --Siegecrafter Blackfuse
            [144236] = Defaults(4), --Pattern Recognition
            [144466] = Defaults(5), --Magnetic Crush
            [143385] = Defaults(2), --Electrostatic Charge (tank)
            [143856] = Defaults(6), --Superheated

            --Paragons of the Klaxxi
            [143617] = Defaults(5), --Blue Bomb
            [143701] = Defaults(5), --Whirling (stun)
            [143702] = Defaults(5), --Whirling
            [142808] = Defaults(6), --Fiery Edge
            [143609] = Defaults(5), --Yellow Sword
            [143610] = Defaults(5), --Red Drum
            [142931] = Defaults(2), --Exposed Veins
            [143619] = Defaults(5), --Yellow Bomb
            [143735] = Defaults(6), --Caustic Amber
            [146452] = Defaults(5), --Resonating Amber
            [142929] = Defaults(2), --Tenderizing Strikes
            [142797] = Defaults(5), --Noxious Vapors
            [143939] = Defaults(5), --Gouge
            [143275] = Defaults(2), --Hewn
            [143768] = Defaults(2), --Sonic Projection
            [142532] = Defaults(6), --Toxin: Blue
            [142534] = Defaults(6), --Toxin: Yellow
            [143279] = Defaults(2), --Genetic Alteration
            [143339] = Defaults(6), --Injection
            [142649] = Defaults(4), --Devour
            [146556] = Defaults(6), --Pierce
            [142671] = Defaults(6), --Mesmerize
            [143979] = Defaults(2), --Vicious Assault
            [143607] = Defaults(5), --Blue Sword
            [143614] = Defaults(5), --Yellow Drum
            [143612] = Defaults(5), --Blue Drum
            [142533] = Defaults(6), --Toxin: Red
            [143615] = Defaults(5), --Red Bomb
            [143974] = Defaults(2), --Shield Bash (tanks)

            --Garrosh Hellscream
            [144582] = Defaults(4), --Hamstring
            [144954] = Defaults(4), --Realm of Y'Shaarj
            [145183] = Defaults(2), --Gripping Despair (tanks)
            [144762] = Defaults(4), --Desecrated
            [145071] = Defaults(5), --Touch of Y'Sharrj
            [148718] = Defaults(4), --Fire Pit
        },
        [930] = {
            -- Throne of Thunder
            --Trash
            [138349] = Defaults(7), -- Static Wound
            [137371] = Defaults(7), -- Thundering Throw

            --Horridon
            [136767] = Defaults(7), --Triple Puncture

            --Council of Elders
            [136922] = Defaults(9), --霜寒刺骨
            [137650] = Defaults(8), --幽暗之魂
            [137641] = Defaults(7), --Soul Fragment
            [137359] = Defaults(7), --Shadowed Loa Spirit Fixate
            [137972] = Defaults(7), --Twisted Fate

            --Tortos
            [136753] = Defaults(7), --Slashing Talons
            [137633] = Defaults(7), --Crystal Shell

            --Megaera
            [137731] = Defaults(7), --Ignite Flesh

            --Ji-Kun
            [138309] = Defaults(7), --Slimed

            --Durumu the Forgotten
            [133767] = Defaults(7), --Serious Wound
            [133768] = Defaults(7), --Arterial Cut

            --Primordius
            [136050] = Defaults(7), --Malformed Blood

            --Dark Animus
            [138569] = Defaults(7), --Explosive Slam

            --Iron Qon
            [134691] = Defaults(7), --Impale
            [134647] = Defaults(7), --Scorched

            --Twin Consorts
            [137440] = Defaults(7), --Icy Shadows
            [137408] = Defaults(7), --Fan of Flames
            [137360] = Defaults(7), --Corrupted Healing
            [137341] = Defaults(8), --Corrupted Healing

            --Lei Shen
            [135000] = Defaults(7), --Decapitate
            [139011] = Defaults(8), --Decapitate

            --Ra-den

        },
        [897] = {
            -- Heart of Fear
            -- Imperial Vizier Zor'lok
            [122761] = Defaults(7), -- Exhale
            [122760] = Defaults(7), -- Exhale
            [123812] = Defaults(7), --Pheromones of Zeal
            [122740] = Defaults(7), --Convert (MC)
            [122706] = Defaults(7), --Noise Cancelling (AMZ)
            -- Blade Lord Ta'yak
            [123180] = Defaults(7), -- Wind Step
            [123474] = Defaults(7), --Overwhelming Assault
            [122949] = Defaults(7), --Unseen Strike
            [124783] = Defaults(7), --Storm Unleashed
            -- Garalon
            [123081] = Defaults(8), --Pungency
            [122774] = Defaults(7), --Crush
            -- [123423] = Defaults(8), --Weak Points
            -- Wind Lord Mel'jarak
            [121881] = Defaults(8), --Amber Prison
            [122055] = Defaults(7), --Residue
            [122064] = Defaults(7), --Corrosive Resin
            --Amber-Shaper Un'sok
            [121949] = Defaults(7), --Parasitic Growth
            [122784] = Defaults(7), --Reshape Life
            --Grand Empress Shek'zeer
            [123707] = Defaults(7), --Eyes of the Empress
            [125390] = Defaults(7), --Fixate
            [123788] = Defaults(8), --Cry of Terror
            [124097] = Defaults(7), --Sticky Resin
            [123184] = Defaults(8), --Dissonance Field
            [124777] = Defaults(7), --Poison Bomb
            [124821] = Defaults(7), --Poison-Drenched Armor
            [124827] = Defaults(7), --Poison Fumes
            [124849] = Defaults(7), --Consuming Terror
            [124863] = Defaults(7), --Visions of Demise
            [124862] = Defaults(7), --Visions of Demise: Target
            [123845] = Defaults(7), --Heart of Fear: Chosen
            [123846] = Defaults(7), --Heart of Fear: Lure
            [125283] = Defaults(7), --Sha Corruption
        },
        [896] = {
            -- Mogu'shan Vaults
            -- The Stone Guard
            [116281] = Defaults(7), --Cobalt Mine Blast
            -- Feng the Accursed
            [116784] = Defaults(9), --Wildfire Spark
            [116374] = Defaults(7), --Lightning Charge
            [116417] = Defaults(8), --Arcane Resonance
            -- Gara'jal the Spiritbinder
            [122151] = Defaults(8), --Voodoo Doll
            [116161] = Defaults(7), --Crossed Over
            [116278] = Defaults(7), --Soul Sever
            -- The Spirit Kings
            --Meng the Demented
            [117708] = Defaults(7), --Maddening Shout
            --Subetai the Swift
            [118048] = Defaults(7), --Pillaged
            [118047] = Defaults(7), --Pillage: Target
            [118135] = Defaults(7), --Pinned Down
            [118163] = Defaults(7), --Robbed Blind
            --Zian of the Endless Shadow
            [118303] = Defaults(7), --Undying Shadow: Fixate
            -- Elegon
            [117949] = Defaults(7), --Closed Circuit
            [132222] = Defaults(8), --Destabilizing Energies
            -- Will of the Emperor
            --Jan-xi and Qin-xi
            [116835] = Defaults(7), --Devastating Arc
            [132425] = Defaults(7), --Stomp
            -- Rage
            [116525] = Defaults(7), --Focused Assault (Rage fixate)
            -- Courage
            [116778] = Defaults(7), --Focused Defense (fixate)
            [117485] = Defaults(7), --Impeding Thrust (slow debuff)
            -- Strength
            [116550] = Defaults(7), --Energizing Smash (knock down)
            -- Titan Spark (Heroic)
            [116829] = Defaults(7), --Focused Energy (fixate)
        },
        [886] = {
            -- Terrace of Endless Spring
            -- Protectors of the Endless
            [118091] = Defaults(6), --Defiled Ground
            [117519] = Defaults(6), --Touch of Sha
            [111850] = Defaults(6), --Lightning Prison: Targeted
            [117436] = Defaults(7), --Lightning Prison: Stunned
            [118191] = Defaults(6), --Corrupted Essence
            [117986] = Defaults(7), --Defiled Ground: Stacks
            -- Tsulong
            [122768] = Defaults(7), --Dread Shadows
            [122777] = Defaults(7), --Nightmares (dispellable)
            [122752] = Defaults(7), --Shadow Breath
            [122789] = Defaults(7), --Sunbeam
            [123012] = Defaults(7), --Terrorize: 5% (dispellable)
            [123011] = Defaults(7), --Terrorize: 10% (dispellable)
            [123036] = Defaults(7), --Fright (dispellable)
            [122858] = Defaults(6), --Bathed in Light
            -- Lei Shi
            [123121] = Defaults(7), --Spray
            [123705] = Defaults(7), --Scary Fog
            -- Sha of Fear
            [119414] = Defaults(7), --Breath of Fear
            [129147] = Defaults(7), --Onimous Cackle
            [119983] = Defaults(7), --Dread Spray
            [120669] = Defaults(7), --Naked and Afraid
            [75683] = Defaults(7), --Waterspout

            [120629] = Defaults(7), --Huddle in Terror
            [120394] = Defaults(7), --Eternal Darkness
            [129189] = Defaults(7), --Sha Globe
            [119086] = Defaults(7), --Penetrating Bolt
            [119775] = Defaults(7), --Reaching Attack
        },
        [824] = {
            -- Dragon Soul
            -- Morchok
            [103687] = Defaults(7), -- RA.dbush Armor(擊碎護甲)

            -- Zon'ozz
            [103434] = Defaults(7), -- Disrupting Shadows(崩解之影)

            -- Yor'sahj
            [105171] = Defaults(8), -- Deep Corruption(深度腐化)
            [109389] = Defaults(8), -- Deep Corruption(深度腐化)
            [105171] = Defaults(7), -- Deep Corruption(深度腐化)
            [104849] = Defaults(9), -- Void Bolt(虛無箭)

            -- Hagara
            [104451] = Defaults(7), --寒冰之墓

            -- Ultraxion
            [109075] = Defaults(7), --凋零之光

            -- Blackhorn
            [107567] = Defaults(7), --蠻橫打擊
            [108043] = Defaults(8), --破甲攻擊
            [107558] = Defaults(9), --衰亡

            -- Spine
            [105479] = Defaults(7), --燃燒血漿
            [105490] = Defaults(8), --熾熱之握
            [106200] = Defaults(9), --血液腐化:大地
            [106199] = Defaults(10), --血液腐化:死亡

            -- Madness
            [105841] = Defaults(7), --退化咬擊
            [105445] = Defaults(8), --極熾高熱
            [106444] = Defaults(9), --刺穿
        },
        [800] = {
            -- Firelands
            -- Rageface
            [99947] = Defaults(6), -- Face Rage

            --Baleroc
            [99256] = Defaults(5), -- 折磨
            [99257] = Defaults(6), -- 受到折磨
            [99516] = Defaults(7), -- Countdown

            --Majordomo Staghelm
            [98535] = Defaults(5), -- Leaping Flames

            --Burning Orbs
            [98451] = Defaults(6), -- Burning Orb
        },
        [752] = {
            -- Baradin Hold
            [88954] = Defaults(6), -- Consuming Darkness
        },
    },
}
