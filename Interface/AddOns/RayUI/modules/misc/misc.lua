local R, L, P = unpack(select(2, ...)) --Inport: Engine, Locales, ProfileDB
local M = R:NewModule("Misc", "AceEvent-3.0")
M.modName = L["小玩意儿"]

M.Modules = {}

function M:GetOptions()
	local options = {
		anouncegroup = {
			order = 5,
			type = "group",
			name = L["通报"],
			guiInline = true,
			args = {
				anounce = {
					order = 1,
					name = L["启用"],
					desc = L["打断通报，打断、驱散、进出战斗文字提示"],
					type = "toggle",
				},
			},
		},
		auctiongroup = {
			order = 6,
			type = "group",
			name = L["拍卖行"],
			guiInline = true,
			args = {
				auction = {
					order = 1,
					name = L["启用"],
					desc = L["Shift + 右键直接一口价，价格上限请在misc/auction.lua里设置"],
					type = "toggle",
				},
			},
		},
		autodezgroup = {
			order = 7,
			type = "group",
			name = L["自动贪婪"],
			guiInline = true,
			args = {
				autodez = {
					order = 1,
					name = L["启用"],
					desc = L["满级之后自动贪婪/分解绿装"],
					type = "toggle",
				},
			},
		},
		autoreleasegroup = {
			order = 8,
			type = "group",
			name = L["自动释放尸体"],
			guiInline = true,
			args = {
				autorelease = {
					order = 1,
					name = L["启用"],
					desc = L["战场中自动释放尸体"],
					type = "toggle",
				},
			},
		},
		merchantgroup = {
			order = 9,
			type = "group",
			name = L["商人"],
			guiInline = true,
			args = {
				merchant = {
					order = 1,
					name = L["启用"],
					desc = L["自动修理、自动卖灰色物品"],
					type = "toggle",
				},
				poisons = {
					order = 2,
					name = L["补购毒药"],
					desc = L["自动补购毒药，数量在misc/merchant.lua里修改"],
					disabled = function() return not (R.myclass == "ROGUE" and M.db.merchant) end,
					type = "toggle",
				},
			},
		},
		questgroup = {
			order = 10,
			type = "group",
			name = L["任务"],
			guiInline = true,
			args = {
				quest = {
					order = 1,
					name = L["启用"],
					desc = L["任务等级，进/出副本自动收起/展开任务追踪，任务面板的展开/收起全部分类按钮"],
					type = "toggle",
				},
				automation = {
					order = 2,
					name = L["自动交接任务"],
					desc = L["自动交接任务，按shift点npc则不自动交接"],
					disabled = function() return not M.db.quest end,
					type = "toggle",
				},
			},
		},
		remindergroup = {
			order = 11,
			type = "group",
			name = L["buff提醒"],
			guiInline = true,
			args = {
				reminder = {
					order = 1,
					name = L["启用"],
					desc = L["缺失重要buff时提醒"],
					type = "toggle",
				},
			},
		},
		raidbuffremindergroup = {
			order = 12,
			type = "group",
			name = L["团队buff提醒"],
			guiInline = true,
			args = {
				raidbuffreminder = {
					order = 1,
					name = L["启用"],
					type = "toggle",
				},
				raidbuffreminderparty = {
					order = 2,
					name = L["单人隐藏团队buff提醒"],
					type = "toggle",
					disabled = function() return not M.db.raidbuffreminder end,
				},
			},
		},
	}
	return options
end

function M:RegisterMiscModule(name, func)
	self.Modules[name] = func
end

function M:Initialize()
	for module, func in pairs(self.Modules) do
		func()
	end
end

function M:Info()
	return L["|cff7aa6d6Ray|r|cffff0000U|r|cff7aa6d6I|r的各种实用便利小功能."]
end

R:RegisterModule(M:GetName())