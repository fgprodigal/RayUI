local R, L, P = unpack(select(2, ...)) --Inport: Engine, Locales, ProfileDB

P["Reminder"] = {}

P["Reminder"]["filters"] = {
	PRIEST = {
		["护甲"] = { --inner fire/will group
			["spellGroup"] = {
				[588] = true, -- inner fire
				[73413] = true, -- inner will
			},
			["instance"] = true,
			["pvp"] = true,
			["enable"] = true,
		},
	},
	HUNTER = {
		["守护"] = { --aspects group
			["spellGroup"] = {
				[82661] = true, -- fox
				[13165] = true, -- hawk
                [109260] = true,
			},
			["combat"] = true,
			["instance"] = true,
			["personal"] = true,
			["enable"] = true,
		},
	},
	MAGE = {
		["护甲"] = { --armors group
			["spellGroup"] = {
				[7302] = true, -- frost armor
				[6117] = true, -- mage armor
				[30482] = true, -- molten armor
			},
			["instance"] = true,
			["pvp"] = true,
			["enable"] = true,
		},
	},
	WARLOCK = {
	},
	PALADIN = {
		["正义之怒"] = { -- righteous fury group
			["spellGroup"] = {
				[25780] = true, 
			},
			["role"] = "Tank",
			["instance"] = true,
			["reverseCheck"] = true,
			["talentTreeException"] = 1, --Holy paladins use RF sometimes
			["enable"] = true,
		},
		["圣印"] = { --check weapons for enchants
			["stanceCheck"] = true,
			["instance"] = true,
			["pvp"] = true,
			["minLevel"] = 3,
			["enable"] = true,
		},
	},
	SHAMAN = {
		["护盾"] = { --shields group
			["spellGroup"] = {
				[52127] = true, -- water shield
				[324] = true, -- lightning shield
			},
			["instance"] = true,
			["pvp"] = true,
			["enable"] = true,
		},
		["武器附魔"] = { --check weapons for enchants
			["weaponCheck"] = true,
			["instance"] = true,
			["pvp"] = true,
			["minLevel"] = 10,
			["enable"] = true,
		},
	},
	WARRIOR = {
		["命令怒吼"] = { -- commanding Shout group
			["spellGroup"] = {
				[469] = true, 
			},
			["negateGroup"] = {
				[6307] = true, -- Blood Pact
				[90364] = true, -- Qiraji Fortitude
				[72590] = true, -- Drums of fortitude
				[21562] = true, -- Fortitude
			},
			["role"] = "Tank",
			["instance"] = true,
			["pvp"] = true,
			["enable"] = true,
		},
		["战斗怒吼"] = { -- battle Shout group
			["spellGroup"] = {
				[6673] = true, 
			},
			["negateGroup"] = {
				[57330] = true, -- horn of Winter
				[93435] = true, -- roar of courage (hunter pet)
			},
			["instance"] = true,
			["pvp"] = true,
			["role"] = "Melee",
			["enable"] = true,
		},
	},
	DEATHKNIGHT = {
		["寒冬号角"] = { -- horn of Winter group
			["spellGroup"] = {
				[57330] = true, 
			},
			["negateGroup"] = {
				[6673] = true, -- battle Shout
				[93435] = true, -- roar of courage (hunter pet)
			},
			["instance"] = true,
			["pvp"] = true,
			["enable"] = true,
		},
		["鲜血灵气"] = { -- blood presence group
			["spellGroup"] = {
				[48263] = true, 
			},
			["role"] = "Tank",
			["instance"] = true,
			["reverseCheck"] = true,
			["enable"] = true,
		},
	},
	ROGUE = { 
		["伤害性毒药"] = {
			["spellGroup"] = {
				[2823] = true, -- 致命毒藥
				[8679] = true, -- 致傷毒藥
			},
			["instance"] = true,
			["pvp"] = true,
			["enable"] = true,
		},
		["非伤害性毒药"] = {
			["spellGroup"] = {
				[108211] = true, -- 吸血毒藥
				[3408] = true, -- 致殘毒藥
				[5761] = true, -- 麻痹毒藥
				[108215] = true, -- 癱瘓毒藥
			},
			["instance"] = true,
			["pvp"] = true,
			["enable"] = true,
		},
	},
	DRUID = {
	},
}
