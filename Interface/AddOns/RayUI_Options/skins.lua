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
        settingsHeader = {
            type = "header",
            name = L["设置"],
            order = 4
        },
        skadagroup = {
			order = 5,
			type = "group",
			name = L["Skada"],
			guiInline = true,
			args = {
				skada = {
					order = 1,
					name = L["启用"],
					type = "toggle",
				},
				skadaposition = {
					order = 2,
					name = L["固定Skada位置"],
					type = "toggle",
					disabled = function() return not S.db.skada end,
				},
			},
		},
		dbmgroup = {
			order = 6,
			type = "group",
			name = L["DBM"],
			guiInline = true,
			args = {
				dbm = {
					order = 1,
					name = L["启用"],
					type = "toggle",
				},
				dbmposition = {
					order = 2,
					name = L["固定DBM位置"],
					type = "toggle",
					disabled = function() return not S.db.dbm end,
				},
			},
		},
		ace3group = {
			order = 7,
			type = "group",
			name = L["ACE3控制台"],
			guiInline = true,
			args = {
				ace3 = {
					order = 1,
					name = L["启用"],
					type = "toggle",
				},
			},
		},
		acpgroup = {
			order = 8,
			type = "group",
			name = L["ACP"],
			guiInline = true,
			args = {
				acp = {
					order = 1,
					name = L["启用"],
					type = "toggle",
				},
			},
		},
		bigwigsgroup = {
			order = 10,
			type = "group",
			name = L["BigWigs"],
			guiInline = true,
			args = {
				bigwigs = {
					order = 1,
					name = L["启用"],
					type = "toggle",
				},
			},
		},
		nugrunninggroup = {
			order = 11,
			type = "group",
			name = "NugRunning",
			guiInline = true,
			args = {
				nugrunning = {
					order = 1,
					name = L["启用"],
					type = "toggle",
				},
			},
		},
		mogitgroup = {
			order = 12,
			type = "group",
			name = "MogIt",
			guiInline = true,
			args = {
				mogit = {
					order = 1,
					name = L["启用"],
					type = "toggle",
				},
			},
		},
		numerationgroup = {
			order = 13,
			type = "group",
			name = "Numeration",
			guiInline = true,
			args = {
				numeration = {
					order = 1,
					name = L["启用"],
					type = "toggle",
				},
			},
		},
    },
}
