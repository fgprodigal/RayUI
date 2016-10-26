local R, L, P, G = unpack(RayUI) --Import: Engine, Locales, ProfileDB, GlobalDB
local NP = R:GetModule("NamePlates")

R.Options.args.NamePlates = {
    type = "group",
    name = (NP.modName or NP:GetName()),
    order = 6,
    get = function(info)
        return R.db.NamePlates[ info[#info] ]
    end,
    set = function(info, value)
        R.db.NamePlates[ info[#info] ] = value
        StaticPopup_Show("CFG_RELOAD")
    end,
    args = {
        header = {
            type = "header",
            name = NP.modName or NP:GetName(),
            order = 1
        },
        description = {
            type = "description",
            name = NP:Info() .. "\n\n",
            order = 2
        },
        enable = {
            type = "toggle",
            name = NP.toggleLabel or (L["启用"] .. (NP.modName or NP:GetName())),
            width = "double",
            desc = NP.Info and NP:Info() or (L["启用"] .. (NP.modName or NP:GetName())),
            order = 3,
        },
        settingsHeader = {
            type = "header",
            name = L["设置"],
            order = 4,
            hidden = function() return not R.db.NamePlates.enable end,
        },
        motionType = {
            order = 5,
            name = L["姓名板排列方式"],
            type = "select",
            values = {
                ["OVERLAP"] = L["重叠姓名板"],
                ["STACKED"] = L["堆叠姓名板"],
            },
            hidden = function() return not R.db.NamePlates.enable end,
        },
        fontsize = {
            order = 5,
            name = L["字体大小"],
            type = "range",
            min = 8, max = 15, step = 1,
            hidden = function() return not R.db.NamePlates.enable end,
        },
        spacer = {
            type = "description",
            name = "",
            desc = "",
            order = 6,
        },
        hpWidth = {
            order = 7,
            name = L["长度"],
            type = "range",
            min = 100, max = 200, step = 1,
            hidden = function() return not R.db.NamePlates.enable end,
        },
        hpHeight = {
            order = 8,
            name = L["高度"],
            type = "range",
            min = 5, max = 20, step = 1,
            hidden = function() return not R.db.NamePlates.enable end,
        },
        pbHeight = {
            order = 9,
            name = L["能量条高度"],
            type = "range",
            min = 2, max = 20, step = 1,
            hidden = function() return not R.db.NamePlates.enable end,
        },
        cbHeight = {
            order = 10,
            name = L["施法条高度"],
            type = "range",
            min = 2, max = 20, step = 1,
            hidden = function() return not R.db.NamePlates.enable end,
        },
        targetScale = {
            order = 10,
            name = L["目标姓名板缩放"],
            type = "range",
            min = 1, max = 2, step = 0.05,
            isPercent = true,
            hidden = function() return not R.db.NamePlates.enable end,
        },
        markHealers = {
            order = 11,
            name = L["战场中标识治疗"],
            type = "toggle",
            hidden = function() return not R.db.NamePlates.enable end,
        },
        showauras = {
            order = 12,
            name = L["显示增益/减益"],
            type = "toggle",
            hidden = function() return not R.db.NamePlates.enable end,
        },
        numAuras = {
            order = 13,
            name = L["增益/减益数量"],
            type = "range",
            min = 1, max = 8, step = 1,
            hidden = function() return not R.db.NamePlates.enable end,
        },
        iconSize = {
            order = 14,
            name = L["增益/减益图标大小"],
            type = "range",
            min = 15, max = 25, step = 1,
            hidden = function() return not R.db.NamePlates.enable end,
        },
        friendly_minions = {
            order = 15,
            name = L["显示友方仆从"],
            type = "toggle",
            hidden = function() return not R.db.NamePlates.enable end,
        },
        enemy_minions = {
            order = 16,
            name = L["显示敌方仆从"],
            type = "toggle",
            hidden = function() return not R.db.NamePlates.enable end,
        },
        enemy_minors = {
            order = 17,
            name = L["显示敌方杂兵"],
            type = "toggle",
            hidden = function() return not R.db.NamePlates.enable end,
        },
        displayStyle = {
            type = "select",
            order = 18,
            name = L["显示模式"],
            values = {
                ["ALL"] = ALL,
                ["BLIZZARD"] = L["目标, 任务, 战斗"],
                ["TARGET"] = L["仅显示目标"],
            },
            hidden = function() return not R.db.NamePlates.enable end,
        },
        showEnemyCombat = {
            order = 19,
            type = "select",
            name = L["敌对战斗开关"],
            values = {
                ["DISABLED"] = L["禁用"],
                ["TOGGLE_ON"] = L["战斗中显示"],
                ["TOGGLE_OFF"] = L["战斗中隐藏"],
            },
            hidden = function() return not R.db.NamePlates.enable end,
        },
        showFriendlyCombat = {
            order = 20,
            type = "select",
            name = L["友方战斗开关"],
            values = {
                ["DISABLED"] = L["禁用"],
                ["TOGGLE_ON"] = L["战斗中显示"],
                ["TOGGLE_OFF"] = L["战斗中隐藏"],
            },
            hidden = function() return not R.db.NamePlates.enable end,
        },
    },
}
