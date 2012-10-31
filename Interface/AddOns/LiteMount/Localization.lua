--[[----------------------------------------------------------------------------

  LiteMount/Localization.lua

  LiteMount translations into other languages.

  Copyright 2011,2012 Mike Battersby

----------------------------------------------------------------------------]]--

LM_Localize = setmetatable({ }, {__index=function (t,k) return k end})

local L = LM_Localize

local locale = GetLocale()

-- Default locale is English (enUS or enGB)
L["LM_MACRO_EXP"]   = "This macro will be run if LiteMount is unable to find a usable mount. This might be because you are indoors, or are moving and don't know any instant-cast mounts."

L["LM_COMBAT_MACRO_EXP"]   = "If enabled, this macro will be run instead of the default combat actions if LiteMount is activated while you are combat."

if locale == "deDE" then
    L["Author"]  = "Autor"
elseif locale == "esES" or locale == "esMX" then
    L["Author"]  = "Autor"
    L["Fly"]     = "Volar"
    L["Swim"]    = "Nadar"
    L["Run"]     = "Correr"
elseif locale == "frFR" then
    L["Author"]  = "Auteur"
elseif locale == "koKR" then
    L["Author"]  = "저자"
    L["Vash"]    = "바쉬르"
    L["AQ"]      = "안퀴라즈"
elseif locale == "ptBR" then
    L["Author"]  = "Autor"
elseif locale == "ruRU" then
    L["Author"]  = "Aвтор"
    L["AQ"]      = "АК"
elseif locale == "zhCN" then
    L["Author"]  = "作者"
    L["Non-flying Mount"] = "非飞行坐骑"
    L["Run"]     = "跑"
    L["Fly"]     = "飞"
    L["Swim"]    = "游"
    L["AQ"]      = "AQ"
    L["Vash"]    = "海底"
    L["LM_MACRO_EXP"] = "如果LiteMount不能找到可用的坐骑会用到此宏，这可能是因为你在室内，或者正在移动中，并且不会任何瞬发坐骑。"
    L["LM_COMBAT_MACRO_EXP"] = "如启用，LiteMount被激活并且当你在战斗中，该宏会被运行替代默认战斗动作。"
elseif locale == "zhTW" then
    L["Author"]  = "作者"
    L["Non-flying Mount"] = "非飞行坐骑"
    L["Run"]     = "陸地"
    L["Fly"]     = "飛行"
    L["Swim"]    = "水中"
    L["AQ"]      = "安其拉"
    L["Vash"]    = "瓦許"
    L["LM_MACRO_EXP"] = "此巨集將被運作在如果LiteMount無法找到一個可用的坐騎，這有可能是由於你在室內，或在移動中並且沒有任何可瞬間招換的坐騎。"
    L["LM_COMBAT_MACRO_EXP"] = "如果啟用，此巨集將替代預設的戰鬥行動，如果LiteMount是啟用的而且你在戰鬥中。"
end
