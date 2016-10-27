local R, L, P, G = unpack(RayUI) --Import: Engine, Locales, ProfileDB, GlobalDB
local B = R:GetModule("Bags")

R.Options.args.Bags = {
    type = "group",
    name = (B.modName or B:GetName()),
    order = 10,
    get = function(info)
        return R.db.Bags[ info[#info] ]
    end,
    set = function(info, value)
        R.db.Bags[ info[#info] ] = value
        StaticPopup_Show("CFG_RELOAD")
    end,
    args = {
        header = {
            type = "header",
            name = B.modName or B:GetName(),
            order = 1
        },
        description = {
            type = "description",
            name = B:Info() .. "\n\n",
            order = 2
        },
        enable = {
            type = "toggle",
            name = B.toggleLabel or (L["启用"] .. (B.modName or B:GetName())),
            width = "double",
            desc = B.Info and B:Info() or (L["启用"] .. (B.modName or B:GetName())),
            order = 3,
        },
        settingsHeader = {
            type = "header",
            name = L["设置"],
            order = 4,
            hidden = function() return not R.db.Bags.enable end,
        },
        bagSize = {
			order = 5,
			type = "range",
			name = L["背包格大小"],
			min = 15, max = 45, step = 1,
			set = function(info, value) R.db.Bags[ info[#info] ] = value B:Layout() end,
            hidden = function() return not R.db.Bags.enable end,
		},
		sortInverted = {
			order = 8,
			type = "toggle",
			name = L["逆序整理"],
			set = function(info, value) R.db.Bags[ info[#info] ] = value end,
            hidden = function() return not R.db.Bags.enable end,
		},
		bagWidth = {
			order = 6,
			type = "range",
			name = L["背包面板宽度"],
			min = 8, max = 20, step = 1,
			set = function(info, value) R.db.Bags[ info[#info] ] = value B:Layout() end,
            hidden = function() return not R.db.Bags.enable end,
		},
		bankWidth = {
			order = 7,
			type = "range",
			name = L["银行面板宽度"],
			min = 8, max = 20, step = 1,
			set = function(info, value) R.db.Bags[ info[#info] ] = value B:Layout(true) end,
            hidden = function() return not R.db.Bags.enable end,
		},
        itemLevel = {
            order = 9,
			type = "toggle",
			name = L["显示物品等级"],
            hidden = function() return not R.db.Bags.enable end,
        }
    },
}
