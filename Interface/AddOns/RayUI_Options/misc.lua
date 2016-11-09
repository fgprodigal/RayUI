local R, L, P, G = unpack(RayUI) --Import: Engine, Locales, ProfileDB, GlobalDB
local M = R:GetModule("Misc")

R.Options.args.Misc = {
    type = "group",
    name = (M.modName or M:GetName()),
    order = 8,
    get = function(info)
        return R.db.Misc[ info[#info] ]
    end,
    set = function(info, value)
        R.db.Misc[ info[#info] ] = value
        StaticPopup_Show("CFG_RELOAD")
    end,
    args = {
        header = {
            type = "header",
            name = M.modName or M:GetName(),
            order = 1
        },
        description = {
            type = "description",
            name = M:Info() .. "\n\n",
            order = 2
        },
        settingsHeader = {
            type = "header",
            name = L["设置"],
            order = 4
        },
        cooldowns = {
            order = 5,
            type = "group",
            name = L["冷却条"],
            guiInline = true,
            get = function(info) return R.db.Misc.cooldowns[ info[#info] ] end,
            set = function(info, value) R.db.Misc.cooldowns[ info[#info] ] = value StaticPopup_Show("CFG_RELOAD") end,
            args = {
                enable = {
                    order = 1,
                    type = "toggle",
                    name = L["启用"],
                },
                spacer = {
                    type = "description",
                    name = "",
                    desc = "",
                    order = 2,
                },
                showpets = {
                    order = 3,
                    type = "toggle",
                    name = L["显示宠物技能冷却"],
                    hidden = function() return not R.db.Misc.cooldowns.enable end,
                },
                showequip = {
                    order = 4,
                    type = "toggle",
                    name = L["显示装备冷却"],
                    hidden = function() return not R.db.Misc.cooldowns.enable end,
                },
                showbags = {
                    order = 5,
                    type = "toggle",
                    name = L["显示物品冷却"],
                    hidden = function() return not R.db.Misc.cooldowns.enable end,
                },
                size = {
                    order = 6,
                    type = "range",
                    name = L["按键大小"],
                    min = 24, max = 60, step = 1,
                    hidden = function() return not R.db.Misc.cooldowns.enable end,
                },
                growthx = {
                    order = 7,
                    type = "select",
                    name = L["横向增长方向"],
                    values = {
                        ["LEFT"] = L["左"],
                        ["RIGHT"] = L["右"],
                    },
                    hidden = function() return not R.db.Misc.cooldowns.enable end,
                },
                growthy = {
                    order = 8,
                    type = "select",
                    name = L["纵向增长方向"],
                    values = {
                        ["UP"] = L["上"],
                        ["DOWN"] = L["下"],
                    },
                    hidden = function() return not R.db.Misc.cooldowns.enable end,
                },
            },
        },
        anouncegroup = {
            order = 6,
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
            order = 7,
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
            order = 8,
            type = "group",
            name = L["自动贪婪"],
            guiInline = true,
            args = {
                autodez = {
                    order = 1,
                    name = L["启用"],
                    desc = L["满级之后自动贪婪/分解绿装"],
                    type = "toggle",
                    set = function(info, value)
                        R.db.Misc.autodez = value
                    end,
                },
            },
        },
        autoreleasegroup = {
            order = 9,
            type = "group",
            name = L["自动释放尸体"],
            guiInline = true,
            args = {
                autorelease = {
                    order = 1,
                    name = L["启用"],
                    desc = L["战场中自动释放尸体"],
                    type = "toggle",
                    set = function(info, value)
                        R.db.Misc.autorelease = value
                    end,
                },
            },
        },
        merchantgroup = {
            order = 10,
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
            },
        },
        questgroup = {
            order = 11,
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
                    set = function(info, value)
                        R.db.Misc.automation = value
                    end,
                },
            },
        },
        autoinvitegroup = {
            order = 13,
            type = "group",
            name = L["自动邀请"],
            guiInline = true,
            set = function(info, value)
                R.db.Misc[ info[#info] ] = value
            end,
            args = {
                autoAcceptInvite = {
                    order = 1,
                    name = L["自动接受邀请"],
                    desc = L["自动接受公会成员、好友及实名好友的组队邀请"],
                    type = "toggle",
                },
                autoInvite = {
                    order = 2,
                    name = L["自动邀请组队"],
                    desc = L["当他人密语自动邀请关键字时会自动邀请他组队"],
                    type = "toggle",
                },
                autoInviteKeywords = {
                    order = 3,
                    name = L["自动邀请关键字"],
                    desc = L["设置自动邀请的关键字，多个关键字用空格分割"],
                    type = "input",
                    disabled = function() return not M.db.autoInvite end,
                },
            },
        },
        totembar = {
            order = 15,
            type = "group",
            name = L["图腾条"],
            guiInline = true,
            get = function(info) return R.db.Misc.totembar[ info[#info] ] end,
            set = function(info, value) R.db.Misc.totembar[ info[#info] ] = value; M:GetModule("TotemBar"):PositionAndSizeTotem() end,
            args = {
                enable = {
                    order = 1,
                    type = "toggle",
                    name = L["启用"],
                    set = function(info, value) R.db.Misc.totembar[ info[#info] ] = value; M:GetModule("TotemBar"):ToggleTotemEnable() end,
                },
                size = {
                    order = 2,
                    type = "range",
                    name = L["按键大小"],
                    min = 24, max = 60, step = 1,
                    hidden = function() return not R.db.Misc.totembar.enable end,
                },
                spacing = {
                    order = 3,
                    type = "range",
                    name = L["按键间距"],
                    min = 1, max = 10, step = 1,
                    hidden = function() return not R.db.Misc.totembar.enable end,
                },
                sortDirection = {
                    order = 4,
                    type = "select",
                    name = L["排序方向"],
                    values = {
                        ["ASCENDING"] = L["正向"],
                        ["DESCENDING"] = L["逆向"],
                    },
                    hidden = function() return not R.db.Misc.totembar.enable end,
                },
                growthDirection = {
                    order = 5,
                    type = "select",
                    name = L["排列方向"],
                    values = {
                        ["VERTICAL"] = L["垂直"],
                        ["HORIZONTAL"] = L["水平"],
                    },
                    hidden = function() return not R.db.Misc.totembar.enable end,
                },
            },
        },
    },
}
