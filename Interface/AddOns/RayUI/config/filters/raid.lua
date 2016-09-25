local R, L, P, G = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, GlobalDB

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
		[194384] = ClassBuff(194384, "TOPRIGHT", {1, 0, 0.75}, true),        -- Atonement
		[41635] = ClassBuff(41635, "BOTTOMRIGHT", {0.2, 0.7, 0.2}),          -- Prayer of Mending
		[139] = ClassBuff(139, "BOTTOMLEFT", {0.4, 0.7, 0.2}),               -- Renew
		[17] = ClassBuff(17, "TOPLEFT", {0.81, 0.85, 0.1}, true),            -- Power Word: Shield
		[47788] = ClassBuff(47788, "LEFT", {221/255, 117/255, 0}, true),     -- Guardian Spirit
		[33206] = ClassBuff(33206, "LEFT", {227/255, 23/255, 13/255}, true), -- Pain Suppression
	},
	DRUID = {
		[774] = ClassBuff(774, "TOPRIGHT", {0.8, 0.4, 0.8}),      -- Rejuvenation
		[155777] = ClassBuff(155777, "RIGHT", {0.8, 0.4, 0.8}),   -- Germination
		[8936] = ClassBuff(8936, "BOTTOMLEFT", {0.2, 0.8, 0.2}),  -- Regrowth
		[33763] = ClassBuff(33763, "TOPLEFT", {0.4, 0.8, 0.2}),   -- Lifebloom
		[188550] = ClassBuff(188550, "TOPLEFT", {0.4, 0.8, 0.2}), -- Lifebloom T18 4pc
		[48438] = ClassBuff(48438, "BOTTOMRIGHT", {0.8, 0.4, 0}), -- Wild Growth
		[207386] = ClassBuff(207386, "TOP", {0.4, 0.2, 0.8}),     -- Spring Blossoms
		[102352] = ClassBuff(102352, "LEFT", {0.2, 0.8, 0.8}),    -- Cenarion Ward
		[200389] = ClassBuff(200389, "BOTTOM", {1, 1, 0.4}),      -- Cultivation
	},
	PALADIN = {
		[53563] = ClassBuff(53563, "TOPRIGHT", {0.7, 0.3, 0.7}),         -- Beacon of Light
		[156910] = ClassBuff(156910, "TOPRIGHT", {0.7, 0.3, 0.7}),       -- Beacon of Faith
		[1022] = ClassBuff(1022, "BOTTOMRIGHT", {0.2, 0.2, 1}, true),    -- Hand of Protection
		[1044] = ClassBuff(1044, "BOTTOMRIGHT", {0.89, 0.45, 0}, true),  -- Hand of Freedom
		[6940] = ClassBuff(6940, "BOTTOMRIGHT", {0.89, 0.1, 0.1}, true), -- Hand of Sacrifice
		[114163] = ClassBuff(114163, 'BOTTOMLEFT', {0.87, 0.7, 0.03}),   -- Eternal Flame
	},
	SHAMAN = {
		[61295] = ClassBuff(61295, "TOPRIGHT", {0.7, 0.3, 0.7}), -- Riptide
	},
	MONK = {
		[119611] = ClassBuff(119611, "TOPLEFT", {0.8, 0.4, 0.8}),    --Renewing Mist
		[116849] = ClassBuff(116849, "TOPRIGHT", {0.2, 0.8, 0.2}),   -- Life Cocoon
		[124682] = ClassBuff(124682, "BOTTOMLEFT", {0.4, 0.8, 0.2}), -- Enveloping Mist
		[124081] = ClassBuff(124081, "BOTTOMRIGHT", {0.7, 0.4, 0}),  -- Zen Sphere
	},
	ROGUE = {
		[57934] = ClassBuff(57934, "TOPRIGHT", {227/255, 23/255, 13/255}), -- Tricks of the Trade
	},
	WARRIOR = {
		[114030] = ClassBuff(114030, "TOPLEFT", {0.2, 0.2, 1}),          -- Vigilance
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

G.Raid.RaidDebuffs = {
	-- Ascending aura timer
	-- Add spells to this list to have the aura time count up from 0
	-- NOTE: This does not show the aura, it needs to be in one of the other list too.
	ascending = {
		[SpellName(89435)] = Defaults(5),
		[SpellName(89421)] = Defaults(5),
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
				[210279] = Defaults(), -- Creeping Nightmares
				[213162] = Defaults(), -- Nightmare Blast
				[212681] = Defaults(), -- Cleansed Ground
				[210315] = Defaults(), -- Nightmare Brambles
				[211507] = Defaults(), -- Nightmare Javelin
				[211471] = Defaults(), -- Scorned Touch
				[208697] = Defaults(), -- Mind Flay
				[215143] = Defaults(), -- Cursed Blood

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
				[204731] = Defaults(), -- Wasting Dread
				[203110] = Defaults(), -- Slumbering Nightmare
				[207681] = Defaults(), -- Nightmare Bloom
				[205341] = Defaults(), -- Sleeping Fog
				[203770] = Defaults(), -- Defiled Vines
				[203787] = Defaults(), -- Volatile Infection

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
				[SpellName(184369)] = Defaults(5), -- Howling Axe (Target)
				[SpellName(180079)] = Defaults(5), -- Felfire Munitions
			
			-- Iron Reaver
				[SpellName(179897)] = Defaults(5), -- Blitz
				[SpellName(185978)] = Defaults(5), -- Firebomb Vulnerability
				[SpellName(182373)] = Defaults(5), -- Flame Vulnerability
				[SpellName(182280)] = Defaults(5), -- Artillery (Target)
				[SpellName(182074)] = Defaults(5), -- Immolation
				[SpellName(182001)] = Defaults(5), -- Unstable Orb
			
			-- Kormrok
				[SpellName(187819)] = Defaults(5), -- Crush
				[SpellName(181345)] = Defaults(5), -- Foul Crush
			
			-- Hellfire High Council
				[SpellName(184360)] = Defaults(5), -- Fel Rage
				[SpellName(184449)] = Defaults(5), -- Mark of the Necromancer
				[SpellName(185065)] = Defaults(5), -- Mark of the Necromancer
				[SpellName(184450)] = Defaults(5), -- Mark of the Necromancer
				[SpellName(185066)] = Defaults(5), -- Mark of the Necromancer
				[SpellName(184676)] = Defaults(5), -- Mark of the Necromancer
				[SpellName(184652)] = Defaults(5), -- Reap
			
			-- Kilrogg Deadeye
				[SpellName(181488)] = Defaults(5), -- Vision of Death
				[SpellName(188929)] = Defaults(5), -- Heart Seeker (Target)
				[SpellName(180389)] = Defaults(5), -- Heart Seeker (DoT)
			
			-- Gorefiend
				[SpellName(179867)] = Defaults(5), -- Gorefiend's Corruption
				[SpellName(181295)] = Defaults(5), -- Digest
				[SpellName(179977)] = Defaults(5), -- Touch of Doom
				[SpellName(179864)] = Defaults(5), -- Shadow of Death
				[SpellName(179909)] = Defaults(5), -- Shared Fate (self root)
				[SpellName(179908)] = Defaults(5), -- Shared Fate (other players root)
			
			-- Shadow-Lord Iskar
				[SpellName(181957)] = Defaults(5), -- Phantasmal Winds
				[SpellName(182200)] = Defaults(5), -- Fel Chakram
				[SpellName(182178)] = Defaults(5), -- Fel Chakram
				[SpellName(182325)] = Defaults(5), -- Phantasmal Wounds
				[SpellName(185239)] = Defaults(5), -- Radiance of Anzu
				[SpellName(185510)] = Defaults(5), -- Dark Bindings
				[SpellName(182600)] = Defaults(5), -- Fel Fire
				[SpellName(179219)] = Defaults(5), -- Phantasmal Fel Bomb
				[SpellName(181753)] = Defaults(5), -- Fel Bomb
			
			-- Soulbound Construct (Socrethar)
				[SpellName(182038)] = Defaults(5), -- Shattered Defenses
				[SpellName(188666)] = Defaults(5), -- Eternal Hunger (Add fixate, Mythic only)
				[SpellName(189627)] = Defaults(5), -- Volatile Fel Orb (Fixated)
				[SpellName(180415)] = Defaults(5), -- Fel Prison
			
			-- Tyrant Velhari
				[SpellName(185237)] = Defaults(5), -- Touch of Harm
				[SpellName(185238)] = Defaults(5), -- Touch of Harm
				[SpellName(185241)] = Defaults(5), -- Edict of Condemnation
				[SpellName(180526)] = Defaults(5), -- Font of Corruption
			
			-- Fel Lord Zakuun
				[SpellName(181508)] = Defaults(5), -- Seed of Destruction
				[SpellName(181653)] = Defaults(5), -- Fel Crystals (Too Close)
				[SpellName(179428)] = Defaults(5), -- Rumbling Fissure (Soak)
				[SpellName(182008)] = Defaults(5), -- Latent Energy (Cannot soak)
				[SpellName(179407)] = Defaults(5), -- Disembodied (Player in Shadow Realm)
			
			-- Xhul'horac
				[SpellName(188208)] = Defaults(5), -- Ablaze
				[SpellName(186073)] = Defaults(5), -- Felsinged
				[SpellName(186407)] = Defaults(5), -- Fel Surge
				[SpellName(186500)] = Defaults(5), -- Chains of Fel
				[SpellName(186063)] = Defaults(5), -- Wasting Void
				[SpellName(186333)] = Defaults(5), -- Void Surge
			
			-- Mannoroth
				[SpellName(181275)] = Defaults(5), -- Curse of the Legion
				[SpellName(181099)] = Defaults(5), -- Mark of Doom
				[SpellName(181597)] = Defaults(5), -- Mannoroth's Gaze
				[SpellName(182006)] = Defaults(5), -- Empowered Mannoroth's Gaze
				[SpellName(181841)] = Defaults(5), -- Shadowforce
				[SpellName(182088)] = Defaults(5), -- Empowered Shadowforce
			
			-- Archimonde
				[SpellName(184964)] = Defaults(5), -- Shackled Torment
				[SpellName(186123)] = Defaults(5), -- Wrought Chaos
				[SpellName(185014)] = Defaults(5), -- Focused Chaos
				[SpellName(186952)] = Defaults(5), -- Nether Banish
				[SpellName(186961)] = Defaults(5), -- Nether Banish
				[SpellName(189891)] = Defaults(5), -- Nether Tear
				[SpellName(183634)] = Defaults(5), -- Shadowfel Burst
				[SpellName(189895)] = Defaults(5), -- Void Star Fixate
				[SpellName(190049)] = Defaults(5), -- Nether Corruption
		 },
		[988] = { 
			-- 黑石铸造厂 
			--格鲁尔 
			
			[SpellName(155080)] = Defaults(4), -- 煉獄切割 分担组DOT 
			[SpellName(155078)] = Defaults(3), -- 压迫打击 普攻坦克易伤 
			[SpellName(162322)] = Defaults(5), -- 炼狱打击 吃刀坦克易伤 
			[SpellName(155506)] = Defaults(2), -- 石化 

			--奥尔高格 
			
			[SpellName(156203)] = Defaults(5), -- 呕吐黑石 远程躲 
			[SpellName(156374)] = Defaults(5), -- 爆炸裂片 近战躲 
			[SpellName(156297)] = Defaults(3), -- 酸液洪流 副坦克易伤 
			[SpellName(173471)] = Defaults(4), -- 酸液巨口 主坦克DOT 
			[SpellName(155900)] = Defaults(2), -- 翻滚之怒 击倒 

			--爆裂熔炉 
			
			[SpellName(156932)] = Defaults(5), -- 崩裂 
			[SpellName(178279)] = Defaults(4), -- 炸弹 
			[SpellName(155192)] = Defaults(4), -- 炸弹 
			[SpellName(176121)] = Defaults(6), -- 不稳定的火焰 点名八码爆炸 
			[SpellName(155196)] = Defaults(2), -- 锁定 
			[SpellName(155743)] = Defaults(5), -- 熔渣池 
			[SpellName(155240)] = Defaults(3), -- 淬火 坦克易伤 
			[SpellName(155242)] = Defaults(3), -- 高热 三层换坦 
			[SpellName(155225)] = Defaults(5), -- 熔化 点名 
			[SpellName(155223)] = Defaults(5), -- 熔化 

			--汉斯加尔与弗兰佐克 
			
			[SpellName(157139)] = Defaults(3), -- 折脊碎椎 跳跃易伤 
			[SpellName(160838)] = Defaults(2), -- 干扰怒吼 
			[SpellName(160845)] = Defaults(2), -- 干扰怒吼 
			[SpellName(160847)] = Defaults(2), -- 干扰怒吼 
			[SpellName(160848)] = Defaults(2), -- 干扰怒吼 
			[SpellName(155818)] = Defaults(4), -- 灼热燃烧 场地边缘的火 

			--缚火者卡格拉兹 
			
			[SpellName(154952)] = Defaults(3), -- 锁定 
			[SpellName(155074)] = Defaults(1), -- 焦灼吐息 坦克易伤 
			[SpellName(155049)] = Defaults(2), -- 火焰链接 
			[SpellName(154932)] = Defaults(4), -- 熔岩激流 点名分摊 
			[SpellName(155277)] = Defaults(5), -- 炽热光辉 点名AOE 
			[SpellName(155314)] = Defaults(1), -- 岩浆猛击 冲锋火线 
			[SpellName(163284)] = Defaults(2), -- 升腾烈焰 坦克DOT 

			--克罗莫格 
			
			[SpellName(156766)] = Defaults(1), -- 扭曲护甲 坦克易伤 
			[SpellName(157059)] = Defaults(2), -- 纠缠之地符文 
			[SpellName(161839)] = Defaults(3), -- 破碎大地符文 
			[SpellName(161923)] = Defaults(3), -- 破碎大地符文 

			--兽王达玛克
			
			[SpellName(154960)] = Defaults(4), -- 长矛钉刺 
			[SpellName(155061)] = Defaults(1), -- 狂乱撕扯 狼阶段流血 
			[SpellName(162283)] = Defaults(1), -- 狂乱撕扯 BOSS继承的流血 
			[SpellName(154989)] = Defaults(3), -- 炼狱吐息 
			[SpellName(154981)] = Defaults(5), -- 爆燃 秒驱 
			[SpellName(155030)] = Defaults(2), -- 炽燃利齿 龙阶段坦克易伤 
			[SpellName(155236)] = Defaults(2), -- 碾碎护甲 象阶段坦克易伤 
			[SpellName(155499)] = Defaults(3), -- 高热弹片 
			[SpellName(155657)] = Defaults(4), -- 烈焰灌注 
			[SpellName(159044)] = Defaults(1), -- 强震 
			[SpellName(162277)] = Defaults(1), -- 强震 

			--主管索戈尔 
			
			[SpellName(155921)] = Defaults(2), -- 点燃 坦克易伤 
			[SpellName(165195)] = Defaults(4), -- 实验型脉冲手雷 
			[SpellName(156310)] = Defaults(3), -- 熔岩震击 
			[SpellName(159481)] = Defaults(3), -- 延时攻城炸弹 
			[SpellName(164380)] = Defaults(2), -- 燃烧 
			[SpellName(164280)] = Defaults(2), -- 热能冲击 

			--钢铁女武神 
			
			[SpellName(156631)] = Defaults(2), -- 急速射击 
			[SpellName(164271)] = Defaults(3), -- 穿透射击 
			[SpellName(158601)] = Defaults(1), -- 主炮轰击 
			[SpellName(156214)] = Defaults(4), -- 震颤暗影 
			[SpellName(158315)] = Defaults(2), -- 暗影猎杀 
			[SpellName(159724)] = Defaults(3), -- 鲜血仪式 
			[SpellName(158010)] = Defaults(2), -- 浸血觅心者 
			[SpellName(158692)] = Defaults(1), -- 致命投掷 
			[SpellName(158702)] = Defaults(2), -- 锁定 
			[SpellName(158683)] = Defaults(3), -- 堕落之血 

			--Blackhand
			[SpellName(156096)] = Defaults(5), --MARKEDFORDEATH
			[SpellName(156107)] = Defaults(4), --IMPALED
			[SpellName(156047)] = Defaults(2), --SLAGGED
			[SpellName(156401)] = Defaults(4), --MOLTENSLAG
			[SpellName(156404)] = Defaults(3), --BURNED
			[SpellName(158054)] = Defaults(4), --SHATTERINGSMASH 158054 155992 159142
			[SpellName(156888)] = Defaults(5), --OVERHEATED
			[SpellName(157000)] = Defaults(2), --ATTACHSLAGBOMBS
		},
		[994] = { 
            --悬槌堡 
            -- 1 卡加斯 
   
            [SpellName(158986)] = Defaults(2), -- 冲锋 
            [SpellName(159178)] = Defaults(5), -- 迸裂创伤         
            [SpellName(162497)] = Defaults(3), -- 搜寻猎物       
            [SpellName(163130)] = Defaults(3), -- 着火 
   
            -- 2 屠夫 
   
            [SpellName(156151)] = Defaults(3), -- 捶肉槌 
            [SpellName(156147)] = Defaults(5), -- 切肉刀           
            [SpellName(156152)] = Defaults(3), -- 龟裂创伤         
            [SpellName(163046)] = Defaults(4), -- 白鬼硫酸 
   
            -- 3 泰克图斯 

            [SpellName(162346)] = Defaults(4),  -- 晶化弹幕  点名 
            [SpellName(162370)] = Defaults(3), -- 晶化弹幕   踩到 
   
            -- 4  布兰肯斯波 
     
            [SpellName(163242)] = Defaults(5), -- 感染孢子 
            [SpellName(159426)] = Defaults(5), -- 回春孢子 
            [SpellName(163241)] = Defaults(4), -- 溃烂 
            [SpellName(159220)] = Defaults(2),  -- 死疽吐息   
            [SpellName(160179)] = Defaults(2),  -- 蚀脑真菌 
            [SpellName(165223)] = Defaults(6), -- 爆裂灌注 
            [SpellName(163666)] = Defaults(3), -- 脉冲高热 
   
            -- 5  独眼魔双子 
   
            [SpellName(155569)] = Defaults(3), -- 受伤 
            [SpellName(158241)] = Defaults(4), -- 烈焰   
            [SpellName(163372)] = Defaults(4), -- 奥能动荡 
            [SpellName(167200)] = Defaults(3), -- 奥术致伤 
            [SpellName(163297)] = Defaults(3), -- 扭曲奥能 

   
            -- 6 克拉戈 
   
            [SpellName(172813)] = Defaults(5), -- 魔能散射：冰霜 
            [SpellName(162185)] = Defaults(5), -- 魔能散射：火焰 
            [SpellName(162184)] = Defaults(3), -- 魔能散射：暗影 
            [SpellName(162186)] = Defaults(2), -- 魔能散射：奥术 
            [SpellName(161345)] = Defaults(2), -- 压制力场 
            [SpellName(161242)] = Defaults(3), -- 废灵标记 
            [SpellName(172886)] = Defaults(4), -- 废灵璧垒 
            [SpellName(172895)] = Defaults(4), -- 魔能散射：邪能  点名 
            [SpellName(172917)] = Defaults(4), -- 魔能散射：邪能  踩到 
            [SpellName(163472)] = Defaults(2), -- 统御之力 
   
            -- 7 元首 
   
            [SpellName(157763)] = Defaults(3),  -- 锁定         
            [SpellName(159515)] = Defaults(4), -- 狂莽突击         
            [SpellName(156225)] = Defaults(4), -- 烙印       
            [SpellName(164004)] = Defaults(4), -- 烙印：偏移         
            [SpellName(164006)] = Defaults(4), -- 烙印：强固         
            [SpellName(164005)] = Defaults(4), -- 烙印：复制         
            [SpellName(158605)] = Defaults(2), -- 混沌标记         
            [SpellName(164176)] = Defaults(2), -- 混沌标记：偏移           
            [SpellName(164178)] = Defaults(2), -- 混沌标记：强固         
            [SpellName(164191)] = Defaults(2), -- 混沌标记：复制 
   
        }, 
		[953] = {
			--Siege of Orgrimmar
			--Immerseus
			[SpellName(143297)] = Defaults(5), --Sha Splash
			[SpellName(143459)] = Defaults(4), --Sha Residue
			[SpellName(143524)] = Defaults(4), --Purified Residue
			[SpellName(143286)] = Defaults(4), --Seeping Sha
			[SpellName(143413)] = Defaults(3), --Swirl
			[SpellName(143411)] = Defaults(3), --Swirl
			[SpellName(143436)] = Defaults(2), --Corrosive Blast (tanks)
			[SpellName(143579)] = Defaults(3), --Sha Corruption (Heroic Only)

			--Fallen Protectors
			[SpellName(143239)] = Defaults(4), --Noxious Poison
			[SpellName(144176)] = Defaults(2), --Lingering Anguish
			[SpellName(143023)] = Defaults(3), --Corrupted Brew
			[SpellName(143301)] = Defaults(2), --Gouge
			[SpellName(143564)] = Defaults(3), --Meditative Field
			[SpellName(143010)] = Defaults(3), --Corruptive Kick
			[SpellName(143434)] = Defaults(6), --Shadow Word:Bane (Dispell)
			[SpellName(143840)] = Defaults(6), --Mark of Anguish
			[SpellName(143959)] = Defaults(4), --Defiled Ground
			[SpellName(143423)] = Defaults(6), --Sha Sear
			[SpellName(143292)] = Defaults(5), --Fixate
			[SpellName(144176)] = Defaults(5), --Shadow Weakness
			[SpellName(147383)] = Defaults(4), --Debilitation (Heroic Only)

			--Norushen
			[SpellName(146124)] = Defaults(2), --Self Doubt (tanks)
			[SpellName(146324)] = Defaults(4), --Jealousy
			[SpellName(144639)] = Defaults(6), --Corruption
			[SpellName(144850)] = Defaults(5), --Test of Reliance
			[SpellName(145861)] = Defaults(6), --Self-Absorbed (Dispell)
			[SpellName(144851)] = Defaults(2), --Test of Confiidence (tanks)
			[SpellName(146703)] = Defaults(3), --Bottomless Pit
			[SpellName(144514)] = Defaults(6), --Lingering Corruption
			[SpellName(144849)] = Defaults(4), --Test of Serenity

			--Sha of Pride
			[SpellName(144358)] = Defaults(2), --Wounded Pride (tanks)
			[SpellName(144843)] = Defaults(3), --Overcome
			[SpellName(146594)] = Defaults(4), --Gift of the Titans
			[SpellName(144351)] = Defaults(6), --Mark of Arrogance
			[SpellName(144364)] = Defaults(4), --Power of the Titans
			[SpellName(146822)] = Defaults(6), --Projection
			[SpellName(146817)] = Defaults(5), --Aura of Pride
			[SpellName(144774)] = Defaults(2), --Reaching Attacks (tanks)
			[SpellName(144636)] = Defaults(5), --Corrupted Prison
			[SpellName(144574)] = Defaults(6), --Corrupted Prison
			[SpellName(145215)] = Defaults(4), --Banishment (Heroic)
			[SpellName(147207)] = Defaults(4), --Weakened Resolve (Heroic)
			[SpellName(144574)] = Defaults(6), --Corrupted Prison
			[SpellName(144574)] = Defaults(6), --Corrupted Prison

			--Galakras
			[SpellName(146765)] = Defaults(5), --Flame Arrows
			[SpellName(147705)] = Defaults(5), --Poison Cloud
			[SpellName(146902)] = Defaults(2), --Poison Tipped blades

			--Iron Juggernaut
			[SpellName(144467)] = Defaults(2), --Ignite Armor
			[SpellName(144459)] = Defaults(5), --Laser Burn
			[SpellName(144498)] = Defaults(5), --Napalm Oil
			[SpellName(144918)] = Defaults(5), --Cutter Laser
			[SpellName(146325)] = Defaults(6), --Cutter Laser Target

			--Kor'kron Dark Shaman
			[SpellName(144089)] = Defaults(6), --Toxic Mist
			[SpellName(144215)] = Defaults(2), --Froststorm Strike (Tank only)
			[SpellName(143990)] = Defaults(2), --Foul Geyser (Tank only)
			[SpellName(144304)] = Defaults(2), --Rend
			[SpellName(144330)] = Defaults(6), --Iron Prison (Heroic)

			--General Nazgrim
			[SpellName(143638)] = Defaults(6), --Bonecracker
			[SpellName(143480)] = Defaults(5), --Assassin's Mark
			[SpellName(143431)] = Defaults(6), --Magistrike (Dispell)
			[SpellName(143494)] = Defaults(2), --Sundering Blow (Tanks)
			[SpellName(143882)] = Defaults(5), --Hunter's Mark

			--Malkorok
			[SpellName(142990)] = Defaults(2), --Fatal Strike (Tank debuff)
			[SpellName(142913)] = Defaults(6), --Displaced Energy (Dispell)
			[SpellName(142863)] = Defaults(1), --Strong Ancient Barrier
			[SpellName(142864)] = Defaults(1), --Strong Ancient Barrier
			[SpellName(142865)] = Defaults(1), --Strong Ancient Barrier
			[SpellName(143919)] = Defaults(5), --Languish (Heroic)

			--Spoils of Pandaria
			[SpellName(145685)] = Defaults(2), --Unstable Defensive System
			[SpellName(144853)] = Defaults(3), --Carnivorous Bite
			[SpellName(145987)] = Defaults(5), --Set to Blow
			[SpellName(145218)] = Defaults(4), --Harden Flesh
			[SpellName(145230)] = Defaults(1), --Forbidden Magic
			[SpellName(146217)] = Defaults(4), --Keg Toss
			[SpellName(146235)] = Defaults(4), --Breath of Fire
			[SpellName(145523)] = Defaults(4), --Animated Strike
			[SpellName(142983)] = Defaults(6), --Torment (the new Wrack)
			[SpellName(145715)] = Defaults(3), --Blazing Charge
			[SpellName(145747)] = Defaults(5), --Bubbling Amber
			[SpellName(146289)] = Defaults(4), --Mass Paralysis

			--Thok the Bloodthirsty
			[SpellName(143766)] = Defaults(2), --Panic (tanks)
			[SpellName(143773)] = Defaults(2), --Freezing Breath (tanks)
			[SpellName(143452)] = Defaults(1), --Bloodied
			[SpellName(146589)] = Defaults(5), --Skeleton Key (tanks)
			[SpellName(143445)] = Defaults(6), --Fixate
			[SpellName(143791)] = Defaults(5), --Corrosive Blood
			[SpellName(143777)] = Defaults(3), --Frozen Solid (tanks)
			[SpellName(143780)] = Defaults(4), --Acid Breath
			[SpellName(143800)] = Defaults(5), --Icy Blood
			[SpellName(143428)] = Defaults(4), --Tail Lash

			--Siegecrafter Blackfuse
			[SpellName(144236)] = Defaults(4), --Pattern Recognition
			[SpellName(144466)] = Defaults(5), --Magnetic Crush
			[SpellName(143385)] = Defaults(2), --Electrostatic Charge (tank)
			[SpellName(143856)] = Defaults(6), --Superheated

			--Paragons of the Klaxxi
			[SpellName(143617)] = Defaults(5), --Blue Bomb
			[SpellName(143701)] = Defaults(5), --Whirling (stun)
			[SpellName(143702)] = Defaults(5), --Whirling
			[SpellName(142808)] = Defaults(6), --Fiery Edge
			[SpellName(143609)] = Defaults(5), --Yellow Sword
			[SpellName(143610)] = Defaults(5), --Red Drum
			[SpellName(142931)] = Defaults(2), --Exposed Veins
			[SpellName(143619)] = Defaults(5), --Yellow Bomb
			[SpellName(143735)] = Defaults(6), --Caustic Amber
			[SpellName(146452)] = Defaults(5), --Resonating Amber
			[SpellName(142929)] = Defaults(2), --Tenderizing Strikes
			[SpellName(142797)] = Defaults(5), --Noxious Vapors
			[SpellName(143939)] = Defaults(5), --Gouge
			[SpellName(143275)] = Defaults(2), --Hewn
			[SpellName(143768)] = Defaults(2), --Sonic Projection
			[SpellName(142532)] = Defaults(6), --Toxin: Blue
			[SpellName(142534)] = Defaults(6), --Toxin: Yellow
			[SpellName(143279)] = Defaults(2), --Genetic Alteration
			[SpellName(143339)] = Defaults(6), --Injection
			[SpellName(142649)] = Defaults(4), --Devour
			[SpellName(146556)] = Defaults(6), --Pierce
			[SpellName(142671)] = Defaults(6), --Mesmerize
			[SpellName(143979)] = Defaults(2), --Vicious Assault
			[SpellName(143607)] = Defaults(5), --Blue Sword
			[SpellName(143614)] = Defaults(5), --Yellow Drum
			[SpellName(143612)] = Defaults(5), --Blue Drum
			[SpellName(142533)] = Defaults(6), --Toxin: Red
			[SpellName(143615)] = Defaults(5), --Red Bomb
			[SpellName(143974)] = Defaults(2), --Shield Bash (tanks)

			--Garrosh Hellscream
			[SpellName(144582)] = Defaults(4), --Hamstring
			[SpellName(144954)] = Defaults(4), --Realm of Y'Shaarj
			[SpellName(145183)] = Defaults(2), --Gripping Despair (tanks)
			[SpellName(144762)] = Defaults(4), --Desecrated
			[SpellName(145071)] = Defaults(5), --Touch of Y'Sharrj
			[SpellName(148718)] = Defaults(4), --Fire Pit
		},
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
			[SpellName(137341)] = Defaults(8), --Corrupted Healing

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
