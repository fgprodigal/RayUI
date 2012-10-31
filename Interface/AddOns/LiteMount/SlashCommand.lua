--[[----------------------------------------------------------------------------

  LiteMount/SlashCommand.lua

  Chat slash command (/litemount or /lmt) and macro maintenance.

  Copyright 2011,2012 Mike Battersby

----------------------------------------------------------------------------]]--

local MacroName = "LiteMount"
local MacroText = [[
# Auto-created by LiteMount addon, it is safe to delete or edit this macro.
# To re-create it run "/litemount macro"
/click [nobtn:2] LiteMount
/click [btn:2] LiteMount RightButton
]]

local function CreateOrUpdateMacro()
    local index = GetMacroIndexByName(MacroName)
    if index == 0 then
        index = CreateMacro(MacroName, "ABILITY_MOUNT_MECHASTRIDER", MacroText)
    else
        EditMacro(index, nil, nil, MacroText)
    end
    return index
end

local LOCALIZED_MACRO_WORD = strlower(MACRO)

function LiteMount_SlashCommandFunc(argstr)


    local args = { strsplit(" ", argstr) }

    for _,arg in ipairs(args) do
        arg = strlower(arg)
        if arg == "macro" or arg == LOCALIZED_MACRO_WORD then
            local i = CreateOrUpdateMacro()
            if i then PickupMacro(i) end
            return
        end
    end

    return LiteMount_OpenOptionsPanel()
end

