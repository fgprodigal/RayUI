
--[[----------------------------------------------------------------------------

  LiteMount/Macro.lua

  Macro maintenance.

  Copyright 2011,2012 Mike Battersby

----------------------------------------------------------------------------]]--

local MacroName = "LiteMount"
local MacroText = [[
# Auto-created by LiteMount addon
/click [nobtn:2] LiteMount
/click [btn:2] LiteMount RightButton
]]

LM_Macro = LM_CreateAutoEventFrame("Button", "LM_Macro")
LM_Macro:RegisterEvent("PLAYER_LOGIN")

function LM_Macro:CreateOrUpdateMacro()
    local index = GetMacroIndexByName(MacroName)
    if index == 0 then
        index = CreateMacro(MacroName, "ABILITY_MOUNT_MECHASTRIDER", MacroText)
    else
        EditMacro(index, nil, nil, MacroText)
    end
end

function LM_Macro:PLAYER_REGEN_ENABLED()
    self:UnregisterEvent("PLAYER_REGEN_ENABLED")
    self:CreateOrUpdateMacro()
end

function LM_Macro:PLAYER_LOGIN()
    if InCombatLockdown() then
        self:RegisterEvent("PLAYER_REGEN_ENABLED")
    else
        self:CreateOrUpdateMacro()
    end
end

