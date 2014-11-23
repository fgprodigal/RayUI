local R, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local

P["Reminder"] = {}

P["Reminder"]["filters"] = {
	PRIEST = {
		-- ["护甲"] = { --inner fire/will group
			-- ["spellGroup"] = {
				-- [588] = true, -- inner fire
				-- [73413] = true, -- inner will
			-- },
			-- ["instance"] = true,
			-- ["combat"] = true,
			-- ["pvp"] = true,
			-- ["enable"] = true,
			-- ["strictFilter"] = true,
		-- },
	},
	HUNTER = {
		-- ["守护"] = { --aspects group
			-- ["spellGroup"] = {
				-- [13165] = true, -- hawk
                -- [109260] = true,
			-- },
			-- ["instance"] = true,
			-- ["combat"] = true,
			-- ["personal"] = true,
			-- ["enable"] = true,
			-- ["strictFilter"] = true,
		-- },
	},
	MAGE = {
		-- ["护甲"] = { --armors group
			-- ["spellGroup"] = {
				-- [7302] = true, -- frost armor
				-- [6117] = true, -- mage armor
				-- [30482] = true, -- molten armor
			-- },
			-- ["instance"] = true,
			-- ["combat"] = true,
			-- ["pvp"] = true,
			-- ["enable"] = true,
			-- ["strictFilter"] = true,
		-- },
	},
	WARLOCK = {
		["黑暗意图"] = {	-- Dark Intent group
			["spellGroup"] = {
				[109773] = true,	-- Dark Intent
			},
			["negateGroup"] = {
				[1459] = true,	-- Arcane Brilliance
				[61316] = true,	-- Dalaran Brilliance
			},
			["combat"] = true,
			["instance"] = true,
			["pvp"] = true,
			["enable"] = true,
			["strictFilter"] = true,
		},
	},
	PALADIN = {
		["正义之怒"] = { -- righteous fury group
			["spellGroup"] = {
				[25780] = true,
			},
			["role"] = "Tank",
			["instance"] = true,
			["combat"] = true,
			["talentTreeException"] = 1, --Holy paladins use RF sometimes
			["enable"] = true,
		},
		["圣印"] = { --check weapons for enchants
			["stanceCheck"] = true,
			["instance"] = true,
			["combat"] = true,
			["pvp"] = true,
			["minLevel"] = 3,
			["enable"] = true,
			["strictFilter"] = true,
		},
	},
	SHAMAN = {
		["护盾"] = { --shields group
			["spellGroup"] = {
				[52127] = true, -- water shield
				[324] = true, -- lightning shield
			},
			["instance"] = true,
			["combat"] = true,
			["pvp"] = true,
			["enable"] = true,
			["strictFilter"] = true,
		},
		-- ["武器附魔"] = { --check weapons for enchants
			-- ["weaponCheck"] = true,
			-- ["instance"] = true,
			-- ["combat"] = true,
			-- ["pvp"] = true,
			-- ["minLevel"] = 10,
			-- ["enable"] = true,
			-- ["strictFilter"] = true,
		-- },
	},
	WARRIOR = {
		["命令怒吼"] = { -- commanding Shout group
			["spellGroup"] = {
				[469] = true,
			},
			["negateGroup"] = {
				[21562] = true,
				[90364] = true,
				[109773] = true,
				[6673] = true,
			},
			["role"] = "Tank",
			["instance"] = true,
			["combat"] = true,
			["pvp"] = true,
			["enable"] = true,
			["strictFilter"] = true,
		},
		["战斗怒吼"] = { -- battle Shout group
			["spellGroup"] = {
				[6673] = true,
			},
			["negateGroup"] = {
				[57330] = true, -- horn of Winter
				[19506] = true, -- trueshot aura
				[469] = true, -- Commanding Shout
			},
			["instance"] = true,
			["combat"] = true,
			["pvp"] = true,
			["role"] = "Melee",
			["enable"] = true,
			["strictFilter"] = true,
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
			["combat"] = true,
			["pvp"] = true,
			["enable"] = true,
			["strictFilter"] = true,
		},
		["鲜血灵气"] = { -- blood presence group
			["spellGroup"] = {
				[48263] = true,
			},
			["role"] = "Tank",
			["instance"] = true,
			["combat"] = true,
			["enable"] = true,
			["strictFilter"] = true,
		},
	},
	ROGUE = {
		["伤害性毒药"] = {
			["spellGroup"] = {
				[2823] = true, -- 致命毒藥
				[157584] = true, -- 速效毒藥
				[8679] = true, -- 致傷毒藥
			},
			["instance"] = true,
			["combat"] = true,
			["pvp"] = true,
			["enable"] = true,
			["strictFilter"] = true,
		},
		-- ["非伤害性毒药"] = {
			-- ["spellGroup"] = {
				-- [108211] = true, -- 吸血毒藥
				-- [3408] = true, -- 致殘毒藥
				-- [5761] = true, -- 麻痹毒藥
				-- [108215] = true, -- 癱瘓毒藥
			-- },
			-- ["instance"] = true,
			-- ["combat"] = true,
			-- ["pvp"] = true,
			-- ["enable"] = true,
		-- },
	},
	DRUID = {
	},
}
