local R, L, P, G = unpack(RayUI) --Import: Engine, Locales, ProfileDB, GlobalDB
local AB = R:GetModule("ActionBar")

R.Options.args.ActionBar = {
    type = "group",
    name = (AB.modName or AB:GetName()),
    order = 3,
    get = function(info)
        return R.db.ActionBar[ info[#info] ]
    end,
    set = function(info, value)
        R.db.ActionBar[ info[#info] ] = value
        StaticPopup_Show("CFG_RELOAD")
    end,
    args = {
        header = {
            type = "header",
            name = AB.modName or AB:GetName(),
            order = 1
        },
        description = {
            type = "description",
            name = AB:Info() .. "\n\n",
            order = 2
        },
        enable = {
            type = "toggle",
            name = AB.toggleLabel or (L["启用"] .. (AB.modName or AB:GetName())),
            width = "double",
            desc = AB.Info and AB:Info() or (L["启用"] .. (AB.modName or AB:GetName())),
            order = 3,
        },
        settingsHeader = {
            type = "header",
            name = L["设置"],
            order = 4,
            hidden = function() return not R.db.ActionBar.enable end,
        },
        barscale = {
            order = 5,
            name = L["动作条缩放"],
            type = "range",
            min = 0.5, max = 1.5, step = 0.01,
            isPercent = true,
            hidden = function() return not R.db.ActionBar.enable end,
        },
        macroname = {
            order = 9,
            name = L["显示宏名称"],
            type = "toggle",
            hidden = function() return not R.db.ActionBar.enable end,
        },
        itemcount = {
            order = 10,
            name = L["显示物品数量"],
            type = "toggle",
            hidden = function() return not R.db.ActionBar.enable end,
        },
        hotkeys = {
            order = 11,
            name = L["显示快捷键"],
            type = "toggle",
            hidden = function() return not R.db.ActionBar.enable end,
        },
        showgrid = {
            order = 12,
            name = L["显示空按键"],
            type = "toggle",
            hidden = function() return not R.db.ActionBar.enable end,
        },
        clickondown = {
            order = 13,
            name = L["按下时生效"],
            type = "toggle",
            hidden = function() return not R.db.ActionBar.enable end,
        },
		lockActionBars = {
			order = 14,
			type = "toggle",
			name = LOCK_ACTIONBAR_TEXT,
            hidden = function() return not R.db.ActionBar.enable end,
		},
        movementModifier = {
			order = 15,
			type = "select",
			name = PICKUP_ACTION_KEY_TEXT,
            hidden = function() return not R.db.ActionBar.enable end,
			disabled = function() return not R.db.ActionBar.lockActionBars end,
			values = {
				["NONE"] = NONE,
				["SHIFT"] = SHIFT_KEY,
				["ALT"] = ALT_KEY,
				["CTRL"] = CTRL_KEY,
			},
		},
        PetGroup = {
            order = 40,
            type = "group",
            guiInline = false,
            name = L["宠物条"],
            hidden = function() return not R.db.ActionBar.enable end,
            get = function(info) return R.db.ActionBar["barpet"][ info[#info] ] end,
            set = function(info, value) R.db.ActionBar["barpet"][ info[#info] ] = value; AB:UpdatePetBar() end,
            args = {
                enable = {
                    order = 1,
                    type = "toggle",
                    name = L["启用"],
                },
                autohide = {
                    type = "toggle",
                    name = L["自动隐藏"],
                    order = 2,
                },
                mouseover = {
                    type = "toggle",
                    name = L["鼠标滑过显示"],
                    order = 3,
                },
                buttonsize = {
                    type = "range",
                    name = L["按键大小"],
                    min = 15, max = 40, step = 1,
                    order = 4,
                },
                buttonspacing = {
                    type = "range",
                    name = L["按键间距"],
                    min = 1, max = 10, step = 1,
                    order = 5,
                },
                buttonsPerRow = {
                    type = "range",
                    name = L["每行按键数"],
                    min = 1, max = NUM_PET_ACTION_SLOTS, step = 1,
                    order = 6,
                },
            },
        },
        StanceGroup = {
            order = 41,
            type = "group",
            guiInline = false,
            name = L["姿态条"],
            hidden = function() return not R.db.ActionBar.enable end,
            args = {
                stancebarfade = {
                    type = "toggle",
                    name = L["自动隐藏"],
                    order = 1,
                },
                stancebarmouseover = {
                    type = "toggle",
                    name = L["鼠标滑过显示"],
                    order = 2,
                },
            },
        },
    },
}

for i = 1, 5 do
    R.Options.args.ActionBar.args["Bar"..i.."Group"] = {
        order = 20 + i,
        type = "group",
        name = L["动作条"..i],
        guiInline = false,
        hidden = function() return not R.db.ActionBar.enable end,
        get = function(info) return R.db.ActionBar["bar"..i][ info[#info] ] end,
        set = function(info, value) R.db.ActionBar["bar"..i][ info[#info] ] = value; AB:UpdatePositionAndSize("bar"..i) end,
        args = {
            header = {
                type = "header",
                name = L["动作条"..i],
                order = 1
            },
            enable = {
                order = 2,
                type = "toggle",
                name = L["启用"],
            },
            autohide = {
                type = "toggle",
                name = L["自动隐藏"],
                order = 3,
            },
            mouseover = {
                type = "toggle",
                name = L["鼠标滑过显示"],
                order = 4,
            },
            buttonsize = {
                type = "range",
                name = L["按键大小"],
                min = 15, max = 40, step = 1,
                order = 5,
            },
            buttonspacing = {
                type = "range",
                name = L["按键间距"],
                min = 1, max = 10, step = 1,
                order = 6,
            },
            buttonsPerRow = {
                type = "range",
                name = L["每行按键数"],
                min = 1, max = NUM_ACTIONBAR_BUTTONS, step = 1,
                order = 7,
            },
        },
    }
end
