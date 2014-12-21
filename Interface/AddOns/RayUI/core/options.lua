local R, L, P, G = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB
local AceConfigDialog = LibStub("AceConfigDialog-3.0")

R.Options = {
	type = "group",
	name = AddOnName,
	args = {
		header = {
			order = 1,
			type = "header",
			name = L["版本"]..string.format(": |cff7aa6d6%s|r",R.version),
			width = "full",
		},
		general = {
			order = 2,
			type = "group",
			name = L["一般"],
			get = function(info)
				return R.global.general[ info[#info] ]
			end,
			set = function(info, value)
				R.global.general[ info[#info] ] = value
				StaticPopup_Show("CFG_RELOAD")
			end,
			args = {
				uiscale = {
					order = 1,
					name = L["UI缩放"],
					desc = L["UI界面缩放"],
					type = "range",
					min = 0.64, max = 1, step = 0.01,
					isPercent = true,
				},
				theme = {
					order = 2,
					type = "toggle",
					name = L["界面风格"],
					type = "select",
					values = {
						["Shadow"] = L["阴影"],
						["Pixel"] = L["1像素"],
					},
				},
				numberType = {
					order = 3,
					type = "toggle",
					name = L["数字单位"],
					type = "select",
					values = {
						[1] = "k,m",
						[2] = FIRST_NUMBER_CAP .. "," .. SECOND_NUMBER_CAP,
					},
					hidden = function()
						return GetLocale()~="zhCN" and GetLocale()~="zhTW"
					end
				},
				spacer = {
					order = 4,
					name = " ",
					desc = " ",
					type = "description",
				},
				ToggleAnchors = {
					order = 5,
					type = "execute",
					name = L["解锁界面元素"],
					desc = L["解锁并移动头像和动作条"],
					func = function()
                        R:ToggleConfigMode()
					end,
				},
                --ResetAllMovers = {
                    --order = 5,
                    --type = "execute",
                    --name = L["重置锚点"],
                    --func = function() StaticPopup_Show("RESETMOVER_CHECK") end,
                --},
				ChoosLayout = {
					order = 6,
					type = "execute",
					name = L["选择布局"],
					desc = L["选择一个预设布局"],
					func = function()
						AceConfigDialog["Close"](AceConfigDialog,"RayUI")
						R:ChooseLayout()
						GameTooltip_Hide()
					end,
				},
				ToggleTutorial = {
					order = 7,
					type = "execute",
					name = L["显示教程"],
					func = function()
						AceConfigDialog["Close"](AceConfigDialog,"RayUI")
						R:GetModule("Tutorial"):ShowTutorial()
						GameTooltip_Hide()
					end,
				},
				TestBossButton = {
					order = 8,
					type = "execute",
					name = L["测试ExtraActionButton"],
					desc = L["显示/隐藏ExtraActionButton"],
					func = function()
                        R:TestBossButton()
					end,
				},
			},
		},
		media = {
			order = 3,
			type = "group",
			name = L["字体材质"],
			get = function(info)
				return R.global.media[ info[#info] ]
			end,
			set = function(info, value)
				R.global.media[ info[#info] ] = value
				StaticPopup_Show("CFG_RELOAD")
			end,
			args = {
				fontGroup = {
					order = 1,
					type = "group",
					name = L["字体"],
					guiInline = true,
					args = {
						font = {
							type = "select", dialogControl = "LSM30_Font",
							order = 1,
							name = L["一般字体"],
							values = AceGUIWidgetLSMlists.font,
							set = function(info, value)
								R.global.media[ info[#info] ] = value
								R:UpdateMedia()
								R:UpdateFontTemplates()
							end,
						},
						fontsize = {
							type = "range",
							order = 2,
							name = L["字体大小"],
							type = "range",
							min = 9, max = 22, step = 1,
							set = function(info, value)
								R.global.media[ info[#info] ] = value
								R:UpdateMedia()
								R:UpdateFontTemplates()
							end,
						},
						dmgfont = {
							type = "select", dialogControl = "LSM30_Font",
							order = 3,
							name = L["伤害字体"],
							values = AceGUIWidgetLSMlists.font,
							set = function(info, value)
								R.global.media[ info[#info] ] = value
								R:UpdateMedia()
								R:UpdateFontTemplates()
							end,
						},
						pxfont = {
							type = "select", dialogControl = "LSM30_Font",
							order = 4,
							name = L["像素字体"],
							values = AceGUIWidgetLSMlists.font,
						},
						cdfont = {
							type = "select", dialogControl = "LSM30_Font",
							order = 5,
							name = L["冷却字体"],
							values = AceGUIWidgetLSMlists.font,
						},
					},
				},
				textureGroup = {
					order = 2,
					type = "group",
					name = L["材质"],
					guiInline = true,
					args = {
						normal = {
							type = "select", dialogControl = "LSM30_Statusbar",
							order = 1,
							name = L["一般材质"],
							values = AceGUIWidgetLSMlists.statusbar,
						},
						blank = {
							type = "select", dialogControl = "LSM30_Statusbar",
							order = 2,
							name = L["空白材质"],
							values = AceGUIWidgetLSMlists.statusbar,
						},
						gloss = {
							type = "select", dialogControl = "LSM30_Statusbar",
							order = 3,
							name = L["玻璃材质"],
							values = AceGUIWidgetLSMlists.statusbar,
						},
						glow = {
							type = "select", dialogControl = "LSM30_Border",
							order = 4,
							name = L["阴影边框"],
							values = AceGUIWidgetLSMlists.border,
						},
					},
				},
				soundGroup = {
					order = 3,
					type = "group",
					name = L["声音"],
					guiInline = true,
					args = {
						warning = {
							type = "select", dialogControl = "LSM30_Sound",
							order = 1,
							name = L["报警声音"],
							values = AceGUIWidgetLSMlists.sound,
						},
					},
				},
				colorGroup = {
					order = 4,
					type = "group",
					name = L["颜色"],
					guiInline = true,
					args = {
						bordercolor = {
							order = 1,
							type = "color",
							hasAlpha = false,
							name = L["边框颜色"],
							get = function(info)
								local t = R.global.media[ info[#info] ]
								return unpack(t)
							end,
							set = function(info, r, g, b)
								R.global.media[ info[#info] ] = {}
								local t = R.global.media[ info[#info] ]
								t[1], t[2], t[3] = r, g, b
                                R:UpdateDemoFrame()
								StaticPopup_Show("CFG_RELOAD")
							end,
						},
						backdropcolor = {
							order = 2,
							type = "color",
							hasAlpha = false,
							name = L["背景颜色"],
							get = function(info)
								local t = R.global.media[ info[#info] ]
								return unpack(t)
							end,
							set = function(info, r, g, b, a)
								R.global.media[ info[#info] ] = {}
								local t = R.global.media[ info[#info] ]
								t[1], t[2], t[3] = r, g, b
                                R:UpdateDemoFrame()
								StaticPopup_Show("CFG_RELOAD")
							end,
						},
						backdropfadecolor = {
							order = 3,
							type = "color",
							hasAlpha = true,
							name = L["透明框架背景颜色"],
							get = function(info)
								local t = R.global.media[ info[#info] ]
								return unpack(t)
							end,
							set = function(info, r, g, b, a)
								R.global.media[ info[#info] ] = {}
								local t = R.global.media[ info[#info] ]
								t[1], t[2], t[3], t[4] = r, g, b, a
                                R:UpdateDemoFrame()
								StaticPopup_Show("CFG_RELOAD")
							end,
						},
                        resetbutton = {
                            type = "execute",
                            order = 5,
                            name = L["恢复默认"],
                            func = function()
                                R.global.media.backdropcolor = G.media.backdropcolor
                                R.global.media.backdropfadecolor = G.media.backdropfadecolor
                                R.global.media.bordercolor = G.media.bordercolor
                                ReloadUI()
                            end,
                        },
					},
				},
			},
		},
	},
}

StaticPopupDialogs["CFG_RELOAD"] = {
	text = L["改变参数需重载应用设置"],
	button1 = ACCEPT,
	button2 = CANCEL,
	OnAccept = function() ReloadUI() end,
	timeout = 0,
	whileDead = 1,
}

StaticPopupDialogs["RESETMOVER_CHECK"] = {
	text = L["是否重置所有锚点?"],
	button1 = ACCEPT,
	button2 = CANCEL,
	OnAccept = function(self)
		R:ResetMovers()
	end,
	timeout = 0,
	whileDead = 1,
}
