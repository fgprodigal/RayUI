local R, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local RW = R:GetModule("Watcher")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")
--[[ 
function RW:UpdateGroup()
	local current = RW.db.GroupSelect or next(RW.GroupName)
	RW.db.GroupSelect = current
	local buffs = R.Options.args.Watcher.args.buffs.values
	local debuffs = R.Options.args.Watcher.args.debuffs.values
	local cooldowns = R.Options.args.Watcher.args.cooldowns.values
	local itemcooldowns = R.Options.args.Watcher.args.itemcooldowns.values
	wipe(buffs)
	wipe(debuffs)
	wipe(cooldowns)
	wipe(itemcooldowns)
	for i in pairs(RW.modules[current].BUFF or {}) do
		if i ~= "unitIDs" and RW.modules[current].BUFF[i] and next(RW.modules[current].BUFF[i]) then
			if type(i) == "number" then
				buffs[i] = GetSpellInfo(i) .. " (" .. i .. ")"
			elseif type(i) == "string" then
				buffs[RW.modules[current].BUFF[i].spellID] = i .. " (" .. RW.modules[current].BUFF[i].spellID .. ")"
			end
		end
	end
	for i in pairs(RW.modules[current].DEBUFF or {}) do
		if i ~= "unitIDs" and RW.modules[current].DEBUFF[i] and next(RW.modules[current].DEBUFF[i]) then
			if type(i) == "number" then
				debuffs[i] = GetSpellInfo(i) .. " (" .. i .. ")"
			elseif type(i) == "string" then
				debuffs[RW.modules[current].DEBUFF[i].spellID] = i .. " (" .. RW.modules[current].DEBUFF[i].spellID .. ")"
			end
		end
	end
	for i in pairs(RW.modules[current].CD or {}) do
		if RW.modules[current].CD[i] then
			cooldowns[i] = GetSpellInfo(i) .. " (" .. i .. ")"
		end
	end
	for i in pairs(RW.modules[current].itemCD or {}) do
		if RW.modules[current].itemCD[i] then
			itemcooldowns[i] = GetItemInfo(i) .. " (" .. i .. ")"
		end
	end
	if next(buffs) == nil then
		R.Options.args.Watcher.args.buffs.hidden  = true
	else
		R.Options.args.Watcher.args.buffs.hidden  = false
	end
	if next(debuffs) == nil then
		R.Options.args.Watcher.args.debuffs.hidden  = true
	else
		R.Options.args.Watcher.args.debuffs.hidden  = false
	end
	if next(cooldowns) == nil then
		R.Options.args.Watcher.args.cooldowns.hidden  = true
	else
		R.Options.args.Watcher.args.cooldowns.hidden  = false
	end
	if next(itemcooldowns) == nil then
		R.Options.args.Watcher.args.itemcooldowns.hidden  = true
	else
		R.Options.args.Watcher.args.itemcooldowns.hidden  = false
	end
end

local function UpdateInput(id, filter)
	RW.db.idinput = tostring(id)
	RW.db.filterinput = filter
	local current = RW.db.GroupSelect
	if not RW.modules[current][filter][id] then
		id = GetSpellInfo(id)
	end
	RW.db.unitidinput = RW.modules[current][filter][id].unitID
	RW.db.casterinput = RW.modules[current][filter][id].caster
	RW.db.fuzzy = RW.modules[current][filter][id].fuzzy
end

function RW:GetOptions()
	local options = {
		ToggleAnchors = {
			order = 5,
			type = "execute",
			name = L["解锁界面元素"],
			func = function()
				RW:TestMode()
				AceConfigDialog["Close"](AceConfigDialog,"RayUI") 
				GameTooltip_Hide()
			end,
		},
		GroupSelect = {
			order = 6,
			type = "select",
			name = L["选择一个分组"],
			set = function(info, value)
				RW.db.GroupSelect = value
				RW:UpdateGroup()
			end,
			get = function()
				return RW.db.GroupSelect
			end,
			values = RW.GroupName,
		},
		disabled = {
			type = 'toggle',
			name = L["启用该组"],
			order = 7,
			set = function(info, value)
				RW.db[RW.db.GroupSelect].disabled = not value
				if RW.db[RW.db.GroupSelect].disabled then
					RW.modules[RW.db.GroupSelect]:Disable()
					R:Print(RW.db.GroupSelect.."已禁用")
				else
					RW.modules[RW.db.GroupSelect]:Enable()
					R:Print(RW.db.GroupSelect.."已启用")
				end
			end,
			get = function() return not RW.db[RW.db.GroupSelect].disabled end,
			disabled = function(info) return not RW.db.GroupSelect end,
		},
		spacer = {
			type = 'description',
			name = '',
			desc = '',
			order = 8,
		},
		mode = {
			order = 9,
			name = L["模式"],
			set = function(info, value)
				RW.db[RW.db.GroupSelect].mode = value
				RW.modules[RW.db.GroupSelect].mode = value
				RW.modules[RW.db.GroupSelect]:ApplyStyle()
				RW.db[RW.db.GroupSelect].direction = RW.modules[RW.db.GroupSelect].direction
				RW.db[RW.db.GroupSelect].barwidth = RW.modules[RW.db.GroupSelect].barwidth
			end,
			get = function() return (RW.db[RW.db.GroupSelect].mode or "ICON") end,
			disabled = function(info) return not RW.db.GroupSelect or RW.db[RW.db.GroupSelect].disabled end,
			type = "select",
			width = "half",
			values = {
				["ICON"] = L["图标"],
				["BAR"] = L["计时条"],
			},
		},
		spacer2 = {
			type = 'description',
			name = '',
			desc = '',
			width = "half",
			order = 10,
		},
		direction = {
			order = 11,
			name = L["增长方向"],
			set = function(info, value)
				RW.db[RW.db.GroupSelect].direction = value
				RW.modules[RW.db.GroupSelect].direction = value
				RW.modules[RW.db.GroupSelect]:ApplyStyle()
			end,
			get = function() return RW.db[RW.db.GroupSelect].direction end,
			disabled = function(info) return not RW.db.GroupSelect or RW.db[RW.db.GroupSelect].disabled end,
			width = "half",
			type = "select",
			values = function()
				if RW.db[RW.db.GroupSelect].mode == "BAR" then
					return {
						["UP"] = L["上"],
						["DOWN"] = L["下"],
					}
				else
					return {
						["UP"] = L["上"],
						["DOWN"] = L["下"],
						["LEFT"] = L["左"],
						["RIGHT"] = L["右"],
					}
				end
			end,
		},
		spacer3 = {
			type = 'description',
			name = '',
			desc = '',
			order = 12,
		},
		size = {
			order = 13,
			name = L["图标大小"],
			set = function(info, value)
				RW.db[RW.db.GroupSelect].size = value
				RW.modules[RW.db.GroupSelect].size = value
				RW.modules[RW.db.GroupSelect]:ApplyStyle()
			end,
			get = function() return RW.db[RW.db.GroupSelect].size end,
			disabled = function(info) return not RW.db.GroupSelect or RW.db[RW.db.GroupSelect].disabled end,
			type = "range",
			min = 20, max = 80, step = 1,
		},
		barWidth = {
			order = 14,
			name = L["计时条长度"],
			set = function(info, value)
				RW.db[RW.db.GroupSelect].barwidth = value
				RW.modules[RW.db.GroupSelect].barwidth = value
				RW.modules[RW.db.GroupSelect]:ApplyStyle()
			end,
			get = function() return (RW.db[RW.db.GroupSelect].barwidth or 150) end,
			hidden = function(info) return RW.db[RW.db.GroupSelect].mode ~= "BAR" end,
			type = "range",
			min = 50, max = 300, step = 1,
		},
		iconSide = {
			order = 15,
			name = L["图标位置"],
			set = function(info, value)
				RW.db[RW.db.GroupSelect].iconside = value
				RW.modules[RW.db.GroupSelect].iconside = value
				RW.modules[RW.db.GroupSelect]:ApplyStyle()
			end,
			get = function() return (RW.db[RW.db.GroupSelect].iconside or "LEFT") end,
			hidden = function(info) return RW.db[RW.db.GroupSelect].mode ~= "BAR" end,
			type = "select",
			width = "half",
			values = {
				["LEFT"] = L["左"],
				["RIGHT"] = L["右"],
			},
		},
		spacer4 = {
			type = 'description',
			name = '',
			desc = '',
			order = 16,
		},
		buffs = {
			order = 17,
			type = "select",
			name = L["已有增益监视"],
			set = function(info, value) UpdateInput(value, "BUFF") end,
			disabled = function(info) return not RW.db.GroupSelect or RW.db[RW.db.GroupSelect].disabled end,
			values = {},
		},
		debuffs = {
			order = 18,
			type = "select",
			name = L["已有减益监视"],
			set = function(info, value) UpdateInput(value, "DEBUFF") end,
			disabled = function(info) return not RW.db.GroupSelect or RW.db[RW.db.GroupSelect].disabled end,
			values = {},
		},
		cooldowns = {
			order = 19,
			type = "select",
			name = L["已有冷却监视"],
			set = function(info, value) UpdateInput(value, "CD") end,
			disabled = function(info) return not RW.db.GroupSelect or RW.db[RW.db.GroupSelect].disabled end,
			values = {},
		},
		itemcooldowns = {
			order = 20,
			type = "select",
			name = L["已有物品冷却监视"],
			set = function(info, value) UpdateInput(value, "itemCD") end,
			disabled = function(info) return not RW.db.GroupSelect or RW.db[RW.db.GroupSelect].disabled end,
			values = {},
		},
		spacer5 = {
			type = 'description',
			name = '',
			desc = '',
			width = "full",
			order = 21,
		},
		idinput = {
			order = 22,
			type = "input",
			name = L["ID"],
			get = function(info, value) return RW.db[ info[#info] ] end,
			set = function(info, value) RW.db[ info[#info] ] = value end,
			disabled = function(info) return not RW.db.GroupSelect or RW.db[RW.db.GroupSelect].disabled end,
		},
		filterinput = {
			order = 23,
			name = L["类型"],
			get = function(info, value) return RW.db[ info[#info] ] end,
			set = function(info, value) RW.db[ info[#info] ] = value end,
			disabled = function(info) return not RW.db.GroupSelect or RW.db[RW.db.GroupSelect].disabled end,
			width = "half",
			type = "select",
			values = {
				["BUFF"] = L["增益"],
				["DEBUFF"] = L["减益"],
				["CD"] = L["冷却"],
				["itemCD"] = L["物品冷却"],
			},
		},
		unitidinput = {
			order = 24,
			type = "select",
			name = L["监视对象"],
			get = function(info, value) return RW.db[ info[#info] ] end,
			set = function(info, value) RW.db[ info[#info] ] = value end,
			disabled = function(info) return(RW.db.filterinput~="BUFF" and RW.db.filterinput~="DEBUFF") or RW.db[RW.db.GroupSelect].disabled end,
			width = "half",
			values = {
				["player"] = L["玩家"],
				["target"] = L["目标"],
				["focus"] = L["焦点"],
				["pet"] = L["宠物"],
			},
		},
		casterinput = {
			order = 25,
			type = "select",
			name = L["施法者"],
			get = function(info, value) return RW.db[ info[#info] ] end,
			set = function(info, value) RW.db[ info[#info] ] = value end,
			hidden = function(info) return(RW.db.filterinput~="BUFF" and RW.db.filterinput~="DEBUFF") or RW.db[RW.db.GroupSelect].disabled end,
			width = "half",
			values = {
				["player"] = L["玩家"],
				["target"] = L["目标"],
				["focus"] = L["焦点"],
				["pet"] = L["宠物"],
				["all"] = L["任何人"],
			},
		},
		fuzzy = {
			order = 26,
			type = "toggle",
			name = L["模糊匹配"],
			desc = L["匹配所有相同名字的法术"],
			get = function(info, value) return RW.db[ info[#info] ] end,
			set = function(info, value) RW.db[ info[#info] ] = value end,
			hidden = function(info) return(RW.db.filterinput~="BUFF" and RW.db.filterinput~="DEBUFF") or RW.db[RW.db.GroupSelect].disabled end,
			width = "half",
		},
		spacer7 = {
			type = 'description',
			name = '',
			desc = '',
			width = "full",
			order = 27,
		},
		addbutton = {
			order = 28,
			type = "execute",
			name = L["添加/编辑"],
			desc = L["添加到当前分组或编辑当前列表中已有法术"],
			width = "half",
			disabled = function(info) return (not RW.db.filterinput or not RW.db.idinput) or RW.db[RW.db.GroupSelect].disabled end,
			func = function()
				local id = RW.db.fuzzy and GetSpellInfo(tonumber(RW.db.idinput)) or tonumber(RW.db.idinput)
				RW.db[RW.db.GroupSelect][RW.db.filterinput] = RW.db[RW.db.GroupSelect][RW.db.filterinput] or {}
				RW.modules[RW.db.GroupSelect][RW.db.filterinput] = RW.modules[RW.db.GroupSelect][RW.db.filterinput] or {}
				if RW.db.filterinput == "BUFF" or RW.db.filterinput == "DEBUFF" then
					RW.modules[RW.db.GroupSelect][RW.db.filterinput][tonumber(RW.db.idinput)] = false
					RW.db[RW.db.GroupSelect][RW.db.filterinput][tonumber(RW.db.idinput)] = false
					RW.modules[RW.db.GroupSelect][RW.db.filterinput][GetSpellInfo(tonumber(RW.db.idinput))] = false
					RW.db[RW.db.GroupSelect][RW.db.filterinput][GetSpellInfo(tonumber(RW.db.idinput))] = false
				end
				RW.db[RW.db.GroupSelect][RW.db.filterinput][id] = {
					["caster"] = RW.db.casterinput,
					["unitID"] = RW.db.unitidinput,
					["fuzzy"] = RW.db.fuzzy and true or nil,
					["spellID"] = RW.db.fuzzy and tonumber(RW.db.idinput) or nil,
				}
				RW.modules[RW.db.GroupSelect][RW.db.filterinput][id] = {
					["caster"] = RW.db.casterinput,
					["unitID"] = RW.db.unitidinput,
					["fuzzy"] = RW.db.fuzzy and true or nil,
					["spellID"] = RW.db.fuzzy and tonumber(RW.db.idinput) or nil,
				}
				RW:UpdateGroup()
				if not RW.testing then
					RW.modules[RW.db.GroupSelect]:Update()
				end
			end,
		},
		deletebutton = {
			order = 29,
			type = "execute",
			name = L["删除"],
			desc = L["从当前分组删除"],
			width = "half",
			disabled = function(info) return (not RW.db.idinput or not RW.db.filterinput or not RW.modules[RW.db.GroupSelect][RW.db.filterinput] or (not RW.modules[RW.db.GroupSelect][RW.db.filterinput][tonumber(RW.db.idinput)] and not RW.modules[RW.db.GroupSelect][RW.db.filterinput][GetSpellInfo(tonumber(RW.db.idinput))])) or RW.db[RW.db.GroupSelect].disabled end,
			func = function()
				RW.db[RW.db.GroupSelect][RW.db.filterinput] = RW.db[RW.db.GroupSelect][RW.db.filterinput] or {}
				RW.modules[RW.db.GroupSelect][RW.db.filterinput] = RW.modules[RW.db.GroupSelect][RW.db.filterinput] or {}
				RW.db[RW.db.GroupSelect][RW.db.filterinput][tonumber(RW.db.idinput)] = false
				RW.modules[RW.db.GroupSelect][RW.db.filterinput][tonumber(RW.db.idinput)] = false
				if RW.db.filterinput == "BUFF" or RW.db.filterinput == "DEBUFF" then
					RW.db[RW.db.GroupSelect][RW.db.filterinput][GetSpellInfo(tonumber(RW.db.idinput))] = false
					RW.modules[RW.db.GroupSelect][RW.db.filterinput][GetSpellInfo(tonumber(RW.db.idinput))] = false
				end
				RW:UpdateGroup()
				if not RW.testing then
					RW.modules[RW.db.GroupSelect]:Update()
				end
			end,
		},
	}
	return options
end

function RW:Info()
	return L["|cff7aa6d6Ray|r|cffff0000U|r|cff7aa6d6I|r头像模块."]
end
 ]]