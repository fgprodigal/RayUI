local R, L, P, G = unpack(RayUI) --Import: Engine, Locales, ProfileDB, GlobalDB
local CT = R:GetModule("CombatText")

R.Options.args.CombatText = {
    type = "group",
    name = (CT.modName or CT:GetName()),
    order = 13,
    get = function(info)
        return R.db.CombatText[ info[#info] ]
    end,
    set = function(info, value)
        R.db.CombatText[ info[#info] ] = value
        StaticPopup_Show("CFG_RELOAD")
    end,
    args = {
        header = {
            type = "header",
            name = CT.modName or CT:GetName(),
            order = 1
        },
        description = {
            type = "description",
            name = "\n\n",
            order = 2
        },
        enable = {
            type = "toggle",
            name = CT.toggleLabel or (L["启用"] .. (CT.modName or CT:GetName())),
            width = "double",
            desc = CT.Info and CH:Info() or (L["启用"] .. (CT.modName or CT:GetName())),
            order = 3,
        },
    }
}
