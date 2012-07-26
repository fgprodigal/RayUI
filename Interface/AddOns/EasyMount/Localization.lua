------------------------------------------------------------
-- Localization.lua
--
-- Abin
-- 2011/2/20
------------------------------------------------------------

local _, addon = ...

addon.L = {
	["mount"] = "Mount",
	["force ground mount"] = "Force ground mount",
	["ground"] = "Ground",
	["fly"] = "Fly",
	["swim"] = "Swim",
	["taq"] = "Ahn'Qiraj",
	["desc"] = "Select your prefered mounts, it summons a random one if multiple mounts are selected.",
}

if GetLocale() == "zhCN" then
	addon.L = {
		["mount"] = "坐骑",
		["force ground mount"] = "使用地面坐骑",
		["ground"] = "地面",
		["fly"] = "飞行",
		["swim"] = "游泳",
		["taq"] = "安其拉",
		["desc"] = "选择你希望使用的坐骑，如果选择了多个坐骑则从中随机召唤。",
	}

elseif GetLocale() == "zhTW" then
	addon.L = {
		["mount"] = "坐騎",
		["force ground mount"] = "使用地面坐騎",
		["ground"] = "地面",
		["fly"] = "飛行",
		["swim"] = "游泳",
		["taq"] = "安其拉",
		["desc"] = "選擇你希望使用的坐騎，如果選擇了多個坐騎則從中隨機召喚。",
	}
end