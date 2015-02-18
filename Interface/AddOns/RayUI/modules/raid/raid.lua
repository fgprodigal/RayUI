local R, L, P, G = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB
local RA = R:NewModule("Raid", "AceEvent-3.0")

local _, ns = ...
local oUF = RayUF or oUF

RA.modName = L["团队"]

local function RegisterDebuffs()
	SetMapToCurrentZone()
	local _, instanceType = IsInInstance()
	local zone = GetCurrentMapAreaID()
	local ORD = ns.oUF_RaidDebuffs or oUF_RaidDebuffs
	if ORD then
		ORD:ResetDebuffData()

		if instanceType == "party" or instanceType == "raid" then
			if G.Raid.RaidDebuffs.instances[zone] then
				ORD:RegisterDebuffs(G.Raid.RaidDebuffs.instances[zone])
			end
		end
	end
end

function RA:GetOptions()
	local options = {
		size = {
			order = 5,
			type = "group",
			name = L["大小"],
			guiInline = true,
			args = {
				width = {
					order = 1,
					name = L["单位长度"],
					min = 50, max = 150, step = 1,
					type = "range",
				},
				height = {
					order = 2,
					name = L["单位高度"],
					min = 20, max = 50, step = 1,
					type = "range",
				},
				spacer = {
					type = "description",
					name = "",
					desc = "",
					order = 3,
				},
				bigwidth = {
					order = 4,
					name = L["单位长度2"],
					min = 50, max = 150, step = 1,
					type = "range",
				},
				bigheight = {
					order = 5,
					name = L["单位高度2"],
					min = 20, max = 50, step = 1,
					type = "range",
				},
				spacing = {
					order = 6,
					name = L["间距"],
					min = 1, max = 20, step = 1,
					type = "range",
				},
				powerbarsize = {
					order = 7,
					name = L["法力条高度"],
					type = "range",
					min = 0, max = 0.5, step = 0.01,
				},
				outsideRange = {
					order = 8,
					name = L["超出距离透明度"],
					type = "range",
					min = 0, max = 1, step = 0.05,
				},
				aurasize = {
					order = 9,
					name = L["技能图标大小"],
					type = "range",
					min = 20, max = 40, step = 1,
				},
				indicatorsize = {
					order = 10,
					name = L["角标大小"],
					type = "range",
					min = 2, max = 10, step = 1,
				},
				leadersize = {
					order = 11,
					name = L["职责图标大小"],
					type = "range",
					min = 8, max = 20, step = 1,
				},
				symbolsize = {
					order = 12,
					name = L["特殊标志大小"],
					desc = L["特殊标志大小, 如愈合祷言标志"],
					type = "range",
					min = 8, max = 20, step = 1,
				},
			},
		},
		visible = {
			order = 6,
			type = "group",
			name = L["显示"],
			guiInline = true,
			set = function(info, value)
				R.db.Raid[ info[#info] ] = value
				RA:UpdateVisibility()
			end,
			args = {
				showwhensolo = {
					order = 1,
					name = L["solo时显示"],
					type = "toggle",
				},
				showplayerinparty = {
					order = 2,
					name = L["在队伍中显示自己"],
					type = "toggle",
				},
				raid40 = {
					order = 3,
					name = L["显示6~8队"],
					type = "toggle",
				},
				alwaysshow40 = {
					order = 4,
					name = L["始终显示1~8队"],
					type = "toggle",
				}
			},
		},
		direction = {
			order = 7,
			type = "group",
			name = L["排列"],
			guiInline = true,
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
		arrows = {
			order = 8,
			type = "group",
			name = L["箭头"],
			guiInline = true,
			args = {
				arrow = {
					order = 1,
					name = L["箭头方向指示"],
					type = "toggle",
				},
				arrowmouseover = {
					order = 2,
					name = L["鼠标悬停时显示"],
					desc = L["只在鼠标悬停时显示方向指示"],
					type = "toggle",
				},
			},
		},
		predict = {
			order = 9,
			type = "group",
			name = L["预读"],
			guiInline = true,
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
			order = 10,
			type = "group",
			name = L["图标文字"],
			guiInline = true,
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
			order = 11,
			type = "group",
			name = L["其他"],
			guiInline = true,
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
				hidemenu = {
					order = 4,
					name = L["屏蔽右键菜单"],
					type = "toggle",
				},
				autorez = {
					order = 5,
					name = L["快速复活"],
					desc = L["鼠标中键点击快速复活/战复"],
					type = "toggle",
				},
			},
		},
	}
	return options
end

local function HideCompactRaid()
	if InCombatLockdown() then return end
	CompactRaidFrameManager:Kill()
	local compact_raid = CompactRaidFrameManager_GetSetting("IsShown")
	if compact_raid and compact_raid ~= "0" then 
		CompactRaidFrameManager_SetSetting("IsShown", "0")
	end
end

function RA:HideBlizzard()
	hooksecurefunc("CompactRaidFrameManager_UpdateShown", HideCompactRaid)
	CompactRaidFrameManager:HookScript("OnShow", HideCompactRaid)
	CompactRaidFrameContainer:UnregisterAllEvents()
	
	HideCompactRaid()
	hooksecurefunc("CompactUnitFrame_RegisterEvents", CompactUnitFrame_UnregisterEvents)
end

function RA:Initialize()
	for i = 1, 4 do
		local frame = _G["PartyMemberFrame"..i]
		frame:UnregisterAllEvents()
		frame:Kill()

		local health = frame.healthbar
		if(health) then
			health:UnregisterAllEvents()
		end

		local power = frame.manabar
		if(power) then
			power:UnregisterAllEvents()
		end

		local spell = frame.spellbar
		if(spell) then
			spell:UnregisterAllEvents()
		end

		local altpowerbar = frame.powerBarAlt
		if(altpowerbar) then
			altpowerbar:UnregisterAllEvents()
		end
	end
	self:HideBlizzard()
	self:RegisterEvent("GROUP_ROSTER_UPDATE", "HideBlizzard")
	UIParent:UnregisterEvent("GROUP_ROSTER_UPDATE")

	self:SpawnRaid()
	RegisterDebuffs()
	local ORD = ns.oUF_RaidDebuffs or oUF_RaidDebuffs
	if ORD then
		ORD.MatchBySpellName = false
	end

	local event = CreateFrame("Frame")
	event:RegisterEvent("ZONE_CHANGED_NEW_AREA")
	event:RegisterEvent("PLAYER_ENTERING_WORLD")
	event:SetScript("OnEvent", RegisterDebuffs)
end

function RA:Info()
	return L["|cff7aa6d6Ray|r|cffff0000U|r|cff7aa6d6I|r团队模块."]
end

R:RegisterModule(RA:GetName())
