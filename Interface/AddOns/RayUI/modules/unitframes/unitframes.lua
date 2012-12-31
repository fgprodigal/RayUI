local R, L, P = unpack(select(2, ...)) --Inport: Engine, Locales, ProfileDB
local UF = R:NewModule("UnitFrames", "AceEvent-3.0")
local oUF = RayUF or oUF

UF.modName = L["头像"]

UF.Layouts = {}

function UF:GetOptions()
	local options = {
		colors = {
			order = 5,
			type = "group",
			name = L["颜色"],
			guiInline = true,
			args = {
				healthColorClass = {
					order = 1,
					name = L["生命条按职业着色"],
					type = "toggle",
				},
				powerColorClass = {
					order = 2,
					name = L["法力条按职业着色"],
					type = "toggle",
				},
				smooth = {
					order = 3,
					name = L["平滑变化"],
					type = "toggle",
				},
				smoothColor = {
					order = 4,
					name = L["颜色随血量渐变"],
					type = "toggle",
				},
			},
		},
		visible = {
			order = 6,
			type = "group",
			name = L["显示"],
			guiInline = true,
			args = {
				showBossFrames = {
					order = 1,
					name = L["显示BOSS"],
					type = "toggle",
				},
				showArenaFrames = {
					order = 2,
					name = L["显示竞技场头像"],
					type = "toggle",
				},
				showPortrait = {
					order = 3,
					name = L["启用头像覆盖血条"],
					type = "toggle",
				},
			},
		},
		others = {
			order = 7,
			type = "group",
			name = L["其他"],
			guiInline = true,
			args = {
				separateEnergy = {
					order = 1,
					name = L["独立能量条"],
					type = "toggle",
					disabled = function() return R.myclass ~= "ROGUE" end,
				},
				vengeance = {
					order = 2,
					name = L["坦克复仇条"],
					type = "toggle",
					disabled = function() return R.Role ~= "Tank" end,
				},
			},
		},
	}
	return options
end

function UF:PLAYER_LOGIN(event)
	if IsAddOnLoaded("Gnosis") or IsAddOnLoaded("AzCastBar") or IsAddOnLoaded("Quartz") then
		for _, frame in pairs(oUF.objects) do
			frame:DisableElement("Castbar")
		end
	end
end

function UF:Initialize()
	RayUF["colors"] = setmetatable({
		-- tapped = {tapped.r, tapped.g, tapped.b},
		-- disconnected = {dc.r, dc.g, dc.b},
		-- health = {health.r, health.g, health.b},
		power = setmetatable({
			["MANA"] = {0, 0.8, 1},
			-- ["RAGE"] = {rage.r, rage.g, rage.b},
			-- ["FOCUS"] = {focus.r, focus.g, focus.b},
			-- ["ENERGY"] = {energy.r, energy.g, energy.b},
			-- ["RUNES"] = {0.55, 0.57, 0.61},
			-- ["RUNIC_POWER"] = {runic.r, runic.g, runic.b},
			-- ["AMMOSLOT"] = {0.8, 0.6, 0},
			-- ["FUEL"] = {0, 0.55, 0.5},
			-- ["POWER_TYPE_STEAM"] = {0.55, 0.57, 0.61},
			-- ["POWER_TYPE_PYRITE"] = {0.60, 0.09, 0.17},
		}, {__index = RayUF["colors"].power}),
		runes = setmetatable({
				-- [1] = {.69,.31,.31},
				-- [2] = {.33,.59,.33},
				-- [3] = {.31,.45,.63},
				-- [4] = {.84,.75,.65},
		}, {__index = RayUF["colors"].runes}),
		reaction = setmetatable({
			[1] = {1, 0.2, 0.2}, -- Hated
			[2] = {1, 0.2, 0.2}, -- Hostile
			[3] = {1, 0.6, 0.2}, -- Unfriendly
			[4] = {1, 1, 0.2}, -- Neutral
			[5] = {0.2, 1, 0.2}, -- Friendly
			[6] = {0.2, 1, 0.2}, -- Honored
			[7] = {0.2, 1, 0.2}, -- Revered
			[8] = {0.2, 1, 0.2}, -- Exalted
		}, {__index = RayUF["colors"].reaction}),
		class = setmetatable({
			-- ["DEATHKNIGHT"] = { 0.77, 0.12, 0.23 },
			-- ["DRUID"]       = { 1, 0.49, 0.04 },
			-- ["HUNTER"]      = { 0.58, 0.86, 0.49 },
			-- ["MAGE"]        = { 0, 0.76, 1 },
			-- ["PALADIN"]     = { 1, 0.22, 0.52 },
			-- ["PRIEST"]      = { 0.8, 0.87, .9 },
			-- ["ROGUE"]       = { 1, 0.91, 0.2 },
			-- ["SHAMAN"]      = {  41/255,  79/255, 155/255 },
			-- ["WARLOCK"]     = { 0.6, 0.47, 0.85 },
			-- ["WARRIOR"]     = { 0.9, 0.65, 0.45 },
		}, {__index = RayUF["colors"].class}),

	}, {__index = RayUF["colors"]})

    self:LoadUnitFrames()
	self:RegisterEvent("PLAYER_LOGIN")
end

function UF:Info()
	return L["|cff7aa6d6Ray|r|cffff0000U|r|cff7aa6d6I|r头像模块."]
end

R:RegisterModule(UF:GetName())
