local R, L, P, G = unpack(RayUI) --Import: Engine, Locales, ProfileDB, GlobalDB
local UF = R:GetModule("UnitFrames")

R.Options.args.UnitFrames = {
    type = "group",
    name = (UF.modName or UF:GetName()),
    order = 4,
    get = function(info)
        return R.db.UnitFrames[ info[#info] ]
    end,
    set = function(info, value)
        R.db.UnitFrames[ info[#info] ] = value
        StaticPopup_Show("CFG_RELOAD")
    end,
    args = {
        header = {
            type = "header",
            name = UF.modName or UF:GetName(),
            order = 1
        },
        description = {
            type = "description",
            name = UF:Info() .. "\n\n",
            order = 2
        },
        enable = {
            type = "toggle",
            name = UF.toggleLabel or (L["启用"] .. (UF.modName or UF:GetName())),
            width = "double",
            desc = UF.Info and UF:Info() or (L["启用"] .. (UF.modName or UF:GetName())),
            order = 3,
        },
        settingsHeader = {
            type = "header",
            name = L["设置"],
            order = 4,
            hidden = function() return not R.db.UnitFrames.enable end,
        },
        colors = {
            order = 5,
            type = "group",
            name = L["颜色"],
            guiInline = true,
            hidden = function() return not R.db.UnitFrames.enable end,
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
            hidden = function() return not R.db.UnitFrames.enable end,
            args = {
                castBar = {
                    order = 1,
                    name = L["显示施法条"],
                    type = "toggle",
                },
                showPortrait = {
                    order = 4,
                    name = L["启用3D头像"],
                    type = "toggle",
                },
                showHealthValue = {
                    order = 5,
                    name = L["默认显示血量数值"],
                    desc = L["鼠标悬浮时显示血量百分比"],
                    type = "toggle",
                },
                alwaysShowHealth = {
                    order = 6,
                    name = L["总是显示血量"],
                    type = "toggle",
                }
            },
        },
        playerGroup = {
            order = 40,
            type = "group",
            guiInline = false,
            name = L["玩家"],
            hidden = function() return not R.db.UnitFrames.enable end,
            get = function(info)
                return R.db.UnitFrames.units.player[ info[#info] ]
            end,
            set = function(info, value)
                R.db.UnitFrames.units.player[ info[#info] ] = value
                StaticPopup_Show("CFG_RELOAD")
            end,
            args = {
                header = {
                    type = "header",
                    name = L["玩家"],
                    order = 1
                },
                size = {
                    order = 2,
                    type = "group",
                    name = L["大小"],
                    guiInline = true,
                    args = {
                        width = {
                            order = 1,
                            name = L["长度"],
                            min = 100, max = 350, step = 1,
                            type = "range",
                        },
                        height = {
                            order = 2,
                            name = L["高度"],
                            min = 5, max = 70, step = 1,
                            type = "range",
                        },
                    },
                },
                castbarGroup = {
                    order = 3,
                    type = "group",
                    name = L["施法条"],
                    guiInline = true,
                    get = function(info)
                        return R.db.UnitFrames.units.player.castbar[ info[#info] ]
                    end,
                    set = function(info, value)
                        R.db.UnitFrames.units.player.castbar[ info[#info] ] = value
                        StaticPopup_Show("CFG_RELOAD")
                    end,
                    args = {
                        width = {
                            order = 1,
                            name = L["长度"],
                            min = 100, max = 500, step = 1,
                            type = "range",
                        },
                        height = {
                            order = 2,
                            name = L["高度"],
                            min = 5, max = 70, step = 1,
                            type = "range",
                        },
                        spacer = {
                            type = "description",
                            name = "",
                            desc = "",
                            order = 3,
                        },
                        showicon = {
                            order = 4,
                            name = L["显示图标"],
                            type = "toggle",
                        },
                        iconposition = {
                            order = 5,
                            name = L["图标位置"],
                            type = "select",
                            values = {
                                ["LEFT"] = L["左"],
                                ["RIGHT"] = L["右"],
                            },
                        },
                    },
                },
            },
        },
        targetGroup = {
            order = 41,
            type = "group",
            guiInline = false,
            name = L["目标"],
            hidden = function() return not R.db.UnitFrames.enable end,
            get = function(info)
                return R.db.UnitFrames.units.target[ info[#info] ]
            end,
            set = function(info, value)
                R.db.UnitFrames.units.target[ info[#info] ] = value
                StaticPopup_Show("CFG_RELOAD")
            end,
            args = {
                header = {
                    type = "header",
                    name = L["目标"],
                    order = 1
                },
                size = {
                    order = 2,
                    type = "group",
                    name = L["大小"],
                    guiInline = true,
                    args = {
                        width = {
                            order = 1,
                            name = L["长度"],
                            min = 100, max = 350, step = 1,
                            type = "range",
                        },
                        height = {
                            order = 2,
                            name = L["高度"],
                            min = 5, max = 70, step = 1,
                            type = "range",
                        },
                    },
                },
                castbarGroup = {
                    order = 3,
                    type = "group",
                    name = L["施法条"],
                    guiInline = true,
                    get = function(info)
                        return R.db.UnitFrames.units.target.castbar[ info[#info] ]
                    end,
                    set = function(info, value)
                        R.db.UnitFrames.units.target.castbar[ info[#info] ] = value
                        StaticPopup_Show("CFG_RELOAD")
                    end,
                    args = {
                        width = {
                            order = 1,
                            name = L["长度"],
                            min = 100, max = 500, step = 1,
                            type = "range",
                        },
                        height = {
                            order = 2,
                            name = L["高度"],
                            min = 5, max = 70, step = 1,
                            type = "range",
                        },
                        spacer = {
                            type = "description",
                            name = "",
                            desc = "",
                            order = 3,
                        },
                        showicon = {
                            order = 4,
                            name = L["显示图标"],
                            type = "toggle",
                        },
                        iconposition = {
                            order = 5,
                            name = L["图标位置"],
                            type = "select",
                            values = {
                                ["LEFT"] = L["左"],
                                ["RIGHT"] = L["右"],
                            },
                        },
                    },
                },
            },
        },
        focusGroup = {
            order = 43,
            type = "group",
            guiInline = false,
            name = L["焦点"],
            hidden = function() return not R.db.UnitFrames.enable end,
            get = function(info)
                return R.db.UnitFrames.units.focus[ info[#info] ]
            end,
            set = function(info, value)
                R.db.UnitFrames.units.focus[ info[#info] ] = value
                StaticPopup_Show("CFG_RELOAD")
            end,
            args = {
                header = {
                    type = "header",
                    name = L["焦点"],
                    order = 1
                },
                size = {
                    order = 2,
                    type = "group",
                    name = L["大小"],
                    guiInline = true,
                    args = {
                        width = {
                            order = 1,
                            name = L["长度"],
                            min = 100, max = 350, step = 1,
                            type = "range",
                        },
                        height = {
                            order = 2,
                            name = L["高度"],
                            min = 5, max = 70, step = 1,
                            type = "range",
                        },
                    },
                },
                castbarGroup = {
                    order = 3,
                    type = "group",
                    name = L["施法条"],
                    guiInline = true,
                    get = function(info)
                        return R.db.UnitFrames.units.focus.castbar[ info[#info] ]
                    end,
                    set = function(info, value)
                        R.db.UnitFrames.units.focus.castbar[ info[#info] ] = value
                        StaticPopup_Show("CFG_RELOAD")
                    end,
                    args = {
                        width = {
                            order = 1,
                            name = L["长度"],
                            min = 100, max = 500, step = 1,
                            type = "range",
                        },
                        height = {
                            order = 2,
                            name = L["高度"],
                            min = 5, max = 70, step = 1,
                            type = "range",
                        },
                        spacer = {
                            type = "description",
                            name = "",
                            desc = "",
                            order = 3,
                        },
                        showicon = {
                            order = 4,
                            name = L["显示图标"],
                            type = "toggle",
                        },
                        iconposition = {
                            order = 5,
                            name = L["图标位置"],
                            type = "select",
                            values = {
                                ["LEFT"] = L["左"],
                                ["RIGHT"] = L["右"],
                            },
                        },
                    },
                },
            },
        },
        targettargetGroup = {
            order = 42,
            type = "group",
            guiInline = false,
            name = L["目标的目标"],
            hidden = function() return not R.db.UnitFrames.enable end,
            get = function(info)
                return R.db.UnitFrames.units.targettarget[ info[#info] ]
            end,
            set = function(info, value)
                R.db.UnitFrames.units.targettarget[ info[#info] ] = value
                StaticPopup_Show("CFG_RELOAD")
            end,
            args = {
                header = {
                    type = "header",
                    name = L["目标的目标"],
                    order = 1
                },
                size = {
                    order = 2,
                    type = "group",
                    name = L["大小"],
                    guiInline = true,
                    args = {
                        width = {
                            order = 1,
                            name = L["长度"],
                            min = 100, max = 350, step = 1,
                            type = "range",
                        },
                        height = {
                            order = 2,
                            name = L["高度"],
                            min = 5, max = 70, step = 1,
                            type = "range",
                        },
                    },
                },
            },
        },
        focustargetGroup = {
            order = 44,
            type = "group",
            guiInline = false,
            name = L["焦点的目标"],
            hidden = function() return not R.db.UnitFrames.enable end,
            get = function(info)
                return R.db.UnitFrames.units.focustarget[ info[#info] ]
            end,
            set = function(info, value)
                R.db.UnitFrames.units.focustarget[ info[#info] ] = value
                StaticPopup_Show("CFG_RELOAD")
            end,
            args = {
                header = {
                    type = "header",
                    name = L["焦点的目标"],
                    order = 1
                },
                size = {
                    order = 2,
                    type = "group",
                    name = L["大小"],
                    guiInline = true,
                    args = {
                        width = {
                            order = 1,
                            name = L["长度"],
                            min = 100, max = 350, step = 1,
                            type = "range",
                        },
                        height = {
                            order = 2,
                            name = L["高度"],
                            min = 5, max = 70, step = 1,
                            type = "range",
                        },
                    },
                },
            },
        },
        petGroup = {
            order = 45,
            type = "group",
            guiInline = false,
            name = L["宠物"],
            hidden = function() return not R.db.UnitFrames.enable end,
            get = function(info)
                return R.db.UnitFrames.units.pet[ info[#info] ]
            end,
            set = function(info, value)
                R.db.UnitFrames.units.pet[ info[#info] ] = value
                StaticPopup_Show("CFG_RELOAD")
            end,
            args = {
                header = {
                    type = "header",
                    name = L["宠物"],
                    order = 1
                },
                size = {
                    order = 2,
                    type = "group",
                    name = L["大小"],
                    guiInline = true,
                    args = {
                        width = {
                            order = 1,
                            name = L["长度"],
                            min = 100, max = 350, step = 1,
                            type = "range",
                        },
                        height = {
                            order = 2,
                            name = L["高度"],
                            min = 5, max = 70, step = 1,
                            type = "range",
                        },
                    },
                },
            },
        },
        arenaGroup = {
            order = 46,
            type = "group",
            guiInline = false,
            name = L["竞技场"],
            hidden = function() return not R.db.UnitFrames.enable end,
            get = function(info)
                return R.db.UnitFrames.units.arena[ info[#info] ]
            end,
            set = function(info, value)
                R.db.UnitFrames.units.arena[ info[#info] ] = value
                StaticPopup_Show("CFG_RELOAD")
            end,
            args = {
                header = {
                    type = "header",
                    name = L["竞技场"],
                    order = 1
                },
                enable = {
                    type = "toggle",
                    name = L["启用"],
                    width = "double",
                    order = 2,
                },
                size = {
                    order = 3,
                    type = "group",
                    name = L["大小"],
                    guiInline = true,
                    args = {
                        width = {
                            order = 1,
                            name = L["长度"],
                            min = 100, max = 350, step = 1,
                            type = "range",
                            hidden = function() return not R.db.UnitFrames.units.arena.enable end,
                        },
                        height = {
                            order = 2,
                            name = L["高度"],
                            min = 5, max = 70, step = 1,
                            type = "range",
                            hidden = function() return not R.db.UnitFrames.units.arena.enable end,
                        },
                    },
                },
            },
        },
        bossGroup = {
            order = 47,
            type = "group",
            guiInline = false,
            name = L["首领"],
            hidden = function() return not R.db.UnitFrames.enable end,
            get = function(info)
                return R.db.UnitFrames.units.boss[ info[#info] ]
            end,
            set = function(info, value)
                R.db.UnitFrames.units.boss[ info[#info] ] = value
                StaticPopup_Show("CFG_RELOAD")
            end,
            args = {
                header = {
                    type = "header",
                    name = L["首领"],
                    order = 1
                },
                enable = {
                    type = "toggle",
                    name = L["启用"],
                    width = "double",
                    order = 2,
                },
                size = {
                    order = 3,
                    type = "group",
                    name = L["大小"],
                    guiInline = true,
                    args = {
                        width = {
                            order = 1,
                            name = L["长度"],
                            min = 100, max = 350, step = 1,
                            type = "range",
                            hidden = function() return not R.db.UnitFrames.units.boss.enable end,
                        },
                        height = {
                            order = 2,
                            name = L["高度"],
                            min = 5, max = 70, step = 1,
                            type = "range",
                            hidden = function() return not R.db.UnitFrames.units.boss.enable end,
                        },
                    },
                },
            },
        },
    },
}
