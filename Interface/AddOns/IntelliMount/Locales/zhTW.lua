------------------------------------------------------------
-- zhTW.lua
-- 繁體中文

-- Abin
-- 2014/10/21
------------------------------------------------------------

if GetLocale() ~= "zhTW" then return end

local _, addon = ...

addon.L = {
	["desc"] = "設置坐騎召喚優先級，并指定功能型坐騎以供召喚。快捷鍵請到系統“按鍵設置”界面進行設置。",
	["summon regular mount"] = "召喚普通坐騎",
	["summon passenger mount"] = "召喚載客坐騎",
	["summon vendors mount"] = "召喚商販坐騎",
	["summon water strider"] = "召喚踏水黽",
	["tavel or wolf in combat"] = "戰鬥中使用|cff71d5ff[%s]|r或|cff71d5ff[%s]|r。",
	["prefer travel form"] = "德魯伊優先|cff71d5ff[%s]|r。",
	["prefer seahorse"] = "瓦許伊爾水下優先|cff71d5ff[%s]|r。",
	["prefer dragonwrath"] = "裝備|cffff8000[%s]|r時優先使用。",
	["prefer magic broom"] = "萬聖節期間優先|cff0070dd[%s]|r。",
	["summon system random mounts otherwise"] = "其它情況下讓系統召喚隨機坐騎。",
}