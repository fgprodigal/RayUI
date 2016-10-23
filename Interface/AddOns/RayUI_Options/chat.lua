local R, L, P, G = unpack(RayUI) --Import: Engine, Locales, ProfileDB, GlobalDB
local CH = R:GetModule("Chat")

R.Options.args.Chat = {
    type = "group",
    name = (CH.modName or CH:GetName()),
    order = 11,
    get = function(info)
        return R.db.Chat[ info[#info] ]
    end,
    set = function(info, value)
        R.db.Chat[ info[#info] ] = value
        StaticPopup_Show("CFG_RELOAD")
    end,
    args = {
        header = {
            type = "header",
            name = CH.modName or CH:GetName(),
            order = 1
        },
        description = {
            type = "description",
            name = CH:Info() .. "\n\n",
            order = 2
        },
        settingsHeader = {
            type = "header",
            name = L["设置"],
            order = 4
        },
        width = {
            order = 5,
            name = L["长度"],
            type = "range",
            min = 300, max = 600, step = 1,
        },
        height = {
            order = 6,
            name = L["高度"],
            type = "range",
            min = 100, max = 300, step = 1,
        },
        spacer = {
            order = 7,
            name = " ",
            desc = " ",
            type = "description",
        },
        autohide = {
            order = 8,
            name = L["自动隐藏聊天栏"],
            desc = L["短时间内没有消息则自动隐藏聊天栏"],
            type = "toggle",
        },
        autohidetime = {
            order = 9,
            name = L["自动隐藏时间"],
            desc = L["设置多少秒没有新消息时隐藏"],
            type = "range",
            min = 5, max = 60, step = 1,
            disabled = function() return not CH.db.autohide end,
        },
        autoshow = {
            order = 10,
            name = L["自动显示聊天栏"],
            desc = L["频道内有信消息则自动显示聊天栏，关闭后如有新密语会闪烁提示"],
            type = "toggle",
        },
    },
}
