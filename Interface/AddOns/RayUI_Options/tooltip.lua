local R, L, P, G = unpack(RayUI) --Import: Engine, Locales, ProfileDB, GlobalDB
local TT = R:GetModule("Tooltip")

R.Options.args.Tooltip = {
    type = "group",
    name = (TT.modName or TT:GetName()),
    order = 12,
    get = function(info)
        return R.db.Tooltip[ info[#info] ]
    end,
    set = function(info, value)
        R.db.Tooltip[ info[#info] ] = value
        StaticPopup_Show("CFG_RELOAD")
    end,
    args = {
        header = {
            type = "header",
            name = TT.modName or TT:GetName(),
            order = 1
        },
        description = {
            type = "description",
            name = TT:Info() .. "\n\n",
            order = 2
        },
        enable = {
            type = "toggle",
            name = TT.toggleLabel or (L["启用"] .. (TT.modName or TT:GetName())),
            width = "double",
            desc = TT.Info and TT:Info() or (L["启用"] .. (TT.modName or TT:GetName())),
            order = 3,
        },
        settingsHeader = {
            type = "header",
            name = L["设置"],
            order = 4,
            hidden = function() return not R.db.Tooltip.enable end,
        },
        cursor = {
            order = 5,
            name = L["跟随鼠标"],
            type = "toggle",
            hidden = function() return not R.db.Tooltip.enable end,
        },
        hideincombat = {
            order = 6,
            name = L["战斗中隐藏"],
            type = "toggle",
            hidden = function() return not R.db.Tooltip.enable end,
        },
    },
}
