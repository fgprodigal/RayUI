------------------------------------------------------------
-- zhTW.lua
-- 简体中文

-- Abin
-- 2014/10/21
------------------------------------------------------------

if GetLocale() ~= "zhCN" then return end -- Set to "zhCN2" if taking an enUS screenshot...
local _, addon = ...

addon.L = {
	["desc"] = "设置坐骑召唤优先级，并指定功能型坐骑以供快捷召唤。快捷键请到系统“按键设置”界面进行设置。",
	["summon regular mount"] = "召唤普通坐骑",
	["summon passenger mount"] = "召唤载客坐骑",
	["summon vendors mount"] = "召唤商贩坐骑",
	["summon water surface mount"] = "召唤水面坐骑",
	["summon underwater mount"] = "召唤水下坐骑",
	["auto specia forms"] = "自动选择|cff71d5ff[%s]|r、|cff71d5ff[%s]|r、|cff71d5ff[%s]|r。",
	["prefer travel form"] = "德鲁伊飞行/游泳时优先|cff71d5ff[%s]|r。",
	["prefer seahorse"] = "瓦丝琪尔水下优先|cff71d5ff[%s]|r。",
	["prefer dragonwrath"] = "装备|cffff8000[%s]|r时优先使用。",
	["prefer magic broom"] = "万圣节期间优先|cff0070dd[%s]|r。",
	["summon system random mounts otherwise"] = "其它情况下让系统召唤随机坐骑。",
	["enable debug mode"] = "开启调试模式。",
	["draenor fly unlocked"] = "我已解锁德拉诺飞行。",
	["use surface mount if not flyable"] = "禁飞区域优先使用水面坐骑（角色）。",
	["legion fly unlocked"] = "我已解锁破碎群岛飞行。",
}