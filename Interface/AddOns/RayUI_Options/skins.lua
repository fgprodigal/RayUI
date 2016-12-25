local R, L, P, G = unpack(RayUI) --Import: Engine, Locales, ProfileDB, GlobalDB
local S = R:GetModule("Skins")

R.Options.args.Skins = {
    type = "group",
    name = (S.modName or S:GetName()),
    order = 9,
    get = function(info)
        return R.db.Skins[ info[#info] ]
    end,
    set = function(info, value)
        R.db.Skins[ info[#info] ] = value
        StaticPopup_Show("CFG_RELOAD")
    end,
    args = {
        header = {
            type = "header",
            name = S.modName or S:GetName(),
            order = 1
        },
        description = {
            type = "description",
            name = S:Info() .. "\n\n",
            order = 2
        },
        enable = {
            type = "toggle",
            name = S.toggleLabel or (L["启用"] .. (S.modName or S:GetName())),
            width = "double",
            desc = S.Info and S:Info() or (L["启用"] .. (S.modName or S:GetName())),
            order = 3,
        },
        settingsHeader = {
            type = "header",
            name = L["设置"],
            order = 4,
            hidden = function() return not R.db.Skins.enable end,
        },
        skadagroup = {
			order = 5,
			type = "group",
			name = L["Skada"],
			guiInline = true,
            hidden = function() return not R.db.Skins.enable end,
			args = {
				skadaposition = {
					order = 2,
					name = L["固定Skada位置"],
					type = "toggle",
				},
			},
		},
		dbmgroup = {
			order = 6,
			type = "group",
			name = L["DBM"],
			guiInline = true,
            hidden = function() return not R.db.Skins.enable end,
			args = {
				dbmposition = {
					order = 2,
					name = L["固定DBM位置"],
					type = "toggle",
				},
			},
		},
    },
}
