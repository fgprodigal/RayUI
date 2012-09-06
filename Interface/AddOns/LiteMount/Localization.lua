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
    L["AQ"]      = "安其拉"
    L["Vash"]    = "瓦丝琪尔"
elseif locale == "zhTW" then
    L["Author"]  = "作者"
    L["Non-flying Mount"] = "非飞行坐骑"
    L["Run"]     = "跑"
    L["Fly"]     = "飛"
    L["Swim"]    = "游"
    L["AQ"]      = "安其拉"
    L["Vash"]    = "瓦許伊爾"
end
