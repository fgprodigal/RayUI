local R, L, P, G = unpack(RayUI) --Import: Engine, Locales, ProfileDB, GlobalDB
local RA = R:GetModule("Raid")
local UF = R:GetModule("UnitFrames")

R.Options.args.Raid = {
    type = "group",
    name = (RA.modName or RA:GetName()),
    order = 5,
    get = function(info)
        return R.db.Raid[ info[#info] ]
    end,
    set = function(info, value)
        R.db.Raid[ info[#info] ] = value
        StaticPopup_Show("CFG_RELOAD")
    end,
    args = {
        header = {
            type = "header",
            name = RA.modName or RA:GetName(),
            order = 1
        },
        description = {
            type = "description",
            name = RA:Info() .. "\n\n",
            order = 2
        },
        enable = {
            type = "toggle",
            name = RA.toggleLabel or (L["启用"] .. (RA.modName or RA:GetName())),
            width = "double",
            desc = RA.Info and RA:Info() or (L["启用"] .. (RA.modName or RA:GetName())),
            order = 3,
        },
        spacer = {
            type = "description",
            name = "",
            desc = "",
            order = 4,
        },
        toggleRaid = {
            order = 5,
            type = "execute",
            name = L["显示团队"],
            func = function()
                UF:ToggleUF("r25")
            end,
            hidden = function() return not R.db.Raid.enable end,
        },
        toggleTank = {
            order = 6,
            type = "execute",
            name = L["显示主坦克框体"],
            func = function()
                UF:ToggleUF("mt")
            end,
            hidden = function() return not R.db.Raid.enable or not R.db.Raid.showTank end,
        },
        toggleRaidPets = {
            order = 6,
            type = "execute",
            name = L["显示团队宠物框体"],
            func = function()
                UF:ToggleUF("rp")
            end,
            hidden = function() return not R.db.Raid.enable or not R.db.Raid.showPets end,
        },
        settingsHeader = {
            type = "header",
            name = L["设置"],
            order = 9,
            hidden = function() return not R.db.Raid.enable end,
        },
        size = {
            order = 10,
            type = "group",
            name = L["大小"],
            guiInline = true,
            hidden = function() return not R.db.Raid.enable end,
            args = {
                width = {
                    order = 4,
                    name = L["单位长度"],
                    min = 50, max = 150, step = 1,
                    type = "range",
                },
                height = {
                    order = 5,
                    name = L["单位高度"],
                    min = 20, max = 70, step = 1,
                    type = "range",
                },
                spacing = {
                    order = 6,
                    name = L["间距"],
                    min = 1, max = 20, step = 1,
                    type = "range",
                },
                showTank = {
                    order = 7,
                    name = L["主坦克框体"],
                    type = "toggle",
                },
                spacer3 = {
                    type = "description",
                    name = "",
                    desc = "",
                    order = 8,
                },
                tankwidth = {
                    order = 9,
                    name = L["主坦克框体长度"],
                    min = 50, max = 150, step = 1,
                    type = "range",
                    hidden = function() return not R.db.Raid.showTank end,
                },
                tankheight = {
                    order = 10,
                    name = L["主坦克框体高度"],
                    min = 20, max = 70, step = 1,
                    type = "range",
                    hidden = function() return not R.db.Raid.showTank end,
                },
                spacer4 = {
                    type = "description",
                    name = "",
                    desc = "",
                    order = 11,
                    hidden = function() return not R.db.Raid.showTank end,
                },
                showPets = {
                    order = 12,
                    name = L["宠物框体"],
                    type = "toggle",
                },
                spacer5 = {
                    type = "description",
                    name = "",
                    desc = "",
                    order = 13,
                },
                petwidth = {
                    order = 14,
                    name = L["宠物框体长度"],
                    min = 50, max = 150, step = 1,
                    type = "range",
                    hidden = function() return not R.db.Raid.showPets end,
                },
                petheight = {
                    order = 15,
                    name = L["宠物框体高度"],
                    min = 20, max = 70, step = 1,
                    type = "range",
                    hidden = function() return not R.db.Raid.showPets end,
                },
                spacer5 = {
                    type = "description",
                    name = "",
                    desc = "",
                    order = 16,
                    hidden = function() return not R.db.Raid.showTank end,
                },
                powerbarsize = {
                    order = 17,
                    name = L["法力条高度"],
                    type = "range",
                    min = 0, max = 0.5, step = 0.01,
                },
                outsideRange = {
                    order = 18,
                    name = L["超出距离透明度"],
                    type = "range",
                    min = 0, max = 1, step = 0.05,
                },
                aurasize = {
                    order = 19,
                    name = L["技能图标大小"],
                    type = "range",
                    min = 20, max = 40, step = 1,
                },
                indicatorsize = {
                    order = 20,
                    name = L["角标大小"],
                    type = "range",
                    min = 2, max = 10, step = 1,
                },
                leadersize = {
                    order = 21,
                    name = L["职责图标大小"],
                    type = "range",
                    min = 8, max = 20, step = 1,
                },
                symbolsize = {
                    order = 22,
                    name = L["特殊标志大小"],
                    desc = L["特殊标志大小, 如愈合祷言标志"],
                    type = "range",
                    min = 8, max = 20, step = 1,
                },
            },
        },
        direction = {
            order = 11,
            type = "group",
            name = L["排列"],
            guiInline = true,
            hidden = function() return not R.db.Raid.enable end,
            args = {
                horizontal = {
                    order = 1,
                    name = L["水平排列"],
                    desc = L["小队成员水平排列"],
                    type = "toggle",
                },
                growth = {
                    order = 2,
                    name = L["小队增长方向"],
                    type = "select",
                    values = {
                        ["UP"] = L["上"],
                        ["DOWN"] = L["下"],
                        ["LEFT"] = L["左"],
                        ["RIGHT"] = L["右"],
                    },
                },
            },
        },
        predict = {
            order = 13,
            type = "group",
            name = L["预读"],
            guiInline = true,
            hidden = function() return not R.db.Raid.enable end,
            args = {
                healbar = {
                    order = 1,
                    name = L["治疗预读"],
                    type = "toggle",
                },
                healoverflow = {
                    order = 2,
                    name = L["显示过量预读"],
                    type = "toggle",
                },
                healothersonly = {
                    order = 3,
                    name = L["只显示他人预读"],
                    type = "toggle",
                },
            },
        },
        icons = {
            order = 14,
            type = "group",
            name = L["图标文字"],
            guiInline = true,
            hidden = function() return not R.db.Raid.enable end,
            args = {
                roleicon = {
                    order = 1,
                    name = L["职责图标"],
                    type = "toggle",
                },
                afk = {
                    order = 2,
                    name = L["AFK文字"],
                    type = "toggle",
                },

                deficit = {
                    order = 3,
                    name = L["缺失生命文字"],
                    type = "toggle",
                },
                actual = {
                    order = 4,
                    name = L["当前生命文字"],
                    type = "toggle",
                },
                perc = {
                    order = 5,
                    name = L["生命值百分比"],
                    type = "toggle",
                },
            },
        },
        others = {
            order = 15,
            type = "group",
            name = L["其他"],
            guiInline = true,
            hidden = function() return not R.db.Raid.enable end,
            args = {
                dispel = {
                    order = 1,
                    name = L["可驱散提示"],
                    type = "toggle",
                },
                highlight = {
                    order = 2,
                    name = L["鼠标悬停高亮"],
                    type = "toggle",
                },
                tooltip = {
                    order = 3,
                    name = L["鼠标提示"],
                    type = "toggle",
                },
                autorez = {
                    order = 5,
                    name = L["快速复活"],
                    desc = L["鼠标中键点击快速复活/战复"],
                    type = "toggle",
                },
                showlabel = {
                    order = 6,
                    name = L["显示小队编号"],
                    type = "toggle",
                },
            },
        },
    },
}
