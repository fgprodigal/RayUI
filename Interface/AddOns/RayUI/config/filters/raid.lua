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
		ClassBuff(974, "BOTTOMLEFT", {0.2, 0.7, 0.2}),	 -- Earth Shield
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
