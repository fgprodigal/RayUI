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
			["enable"] = true;
		},
	},
	HUNTER = {
		["守护"] = { --aspects group
			["spellGroup"] = {
				[5118] = true, -- cheetah
				[20043] = true, -- wild
				[82661] = true, -- fox
				[13165] = true, -- hawk
			},
			["combat"] = true,
			["instance"] = true,
			["personal"] = true,
			["enable"] = true;
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
			["enable"] = true;
		},
	},
	WARLOCK = {
		["护甲"] = { --armors group
			["spellGroup"] = {
				[28176] = true, -- fel armor
				[687] = true, -- demon armor
			},
			["instance"] = true,
			["pvp"] = true,
			["enable"] = true;
		},
	},
	PALADIN = {
		["圣印"] = { --Seals group
			["spellGroup"] = {
				[20154] = true, -- seal of righteousness
				[20164] = true, -- seal of justice
				[20165] = true, -- seal of insight
				[31801] = true, -- seal of truth
			},
			["instance"] = true,
			["pvp"] = true,
			["enable"] = true;
		},
		["正义之怒"] = { -- righteous fury group
			["spellGroup"] = {
				[25780] = true, 
			},
			["role"] = "Tank",
			["instance"] = true,
			["reverseCheck"] = true,
			["talentTreeException"] = 1, --Holy paladins use RF sometimes
			["enable"] = true;
		},
		["光环"] = { -- auras
			["spellGroup"] = {
				[465] = true, --devo
				[7294] = true, --retr
				[19746] = true, -- conc
				[19891] = true, -- resist
			},
			["instance"] = true,
			["personal"] = true,
			["enable"] = true;
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
			["enable"] = true;
		},
		["武器附魔"] = { --check weapons for enchants
			["weaponCheck"] = true,
			["instance"] = true,
			["pvp"] = true,
			["minLevel"] = 10,
			["enable"] = true;
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
			["enable"] = true;
		},
		["战斗怒吼"] = { -- battle Shout group
			["spellGroup"] = {
				[6673] = true, 
			},
			["negateGroup"] = {
				[8076] = true, -- strength of earth
				[57330] = true, -- horn of Winter
				[93435] = true, -- roar of courage (hunter pet)
			},
			["instance"] = true,
			["pvp"] = true,
			["role"] = "Melee",
			["enable"] = true;
		},
	},
	DEATHKNIGHT = {
		["寒冬号角"] = { -- horn of Winter group
			["spellGroup"] = {
				[57330] = true, 
			},
			["negateGroup"] = {
				[8076] = true, -- strength of earth totem
				[6673] = true, -- battle Shout
				[93435] = true, -- roar of courage (hunter pet)
			},
			["instance"] = true,
			["pvp"] = true,
			["enable"] = true;
		},
		["鲜血灵气"] = { -- blood presence group
			["spellGroup"] = {
				[48263] = true, 
			},
			["role"] = "Tank",
			["instance"] = true,
			["reverseCheck"] = true,
			["enable"] = true;
		},
	},
	ROGUE = { 
		["武器附魔"] = { --weapons enchant group
			["weaponCheck"] = true,
			["instance"] = true,
			["pvp"] = true,
			["minLevel"] = 10,
			["enable"] = true;
		},
	},
	DRUID = {
	},
}