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
        settingsHeader = {
            type = "header",
            name = L["设置"],
            order = 4
        },
        barscale = {
            order = 5,
            name = L["动作条缩放"],
            type = "range",
            min = 0.5, max = 1.5, step = 0.01,
            isPercent = true,
        },
        macroname = {
            order = 9,
            name = L["显示宏名称"],
            type = "toggle",
        },
        itemcount = {
            order = 10,
            name = L["显示物品数量"],
            type = "toggle",
        },
        hotkeys = {
            order = 11,
            name = L["显示快捷键"],
            type = "toggle",
        },
        showgrid = {
            order = 12,
            name = L["显示空按键"],
            type = "toggle",
        },
        clickondown = {
            order = 13,
            name = L["按下时生效"],
            type = "toggle"
        },
        CooldownAlphaGroup = {
            order = 14,
            type = "group",
            name = L["根据CD淡出"],
            guiInline = true,
            args = {
                cooldownalpha = {
                    type = "toggle",
                    name = L["启用"],
                    order = 1,
                },
                spacer = {
                    type = "description",
                    name = "",
                    desc = "",
                    order = 2,
                },
                cdalpha = {
                    order = 3,
                    name = L["CD时透明度"],
                    type = "range",
                    min = 0, max = 1, step = 0.05,
                    disabled = function() return not AB.db.cooldownalpha end,
                },
                readyalpha = {
                    order = 4,
                    name = L["就绪时透明度"],
                    type = "range",
                    min = 0, max = 1, step = 0.05,
                    disabled = function() return not AB.db.cooldownalpha end,
                },
            },
        },
        PetGroup = {
            order = 40,
            type = "group",
            guiInline = false,
            name = L["宠物条"],
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
        get = function(info) return R.db.ActionBar["bar"..i][ info[#info] ] end,
        set = function(info, value) R.db.ActionBar["bar"..i][ info[#info] ] = value; AB:UpdatePositionAndSize("bar"..i) end,
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
                min = 1, max = NUM_ACTIONBAR_BUTTONS, step = 1,
                order = 6,
            },
        },
    }
end
