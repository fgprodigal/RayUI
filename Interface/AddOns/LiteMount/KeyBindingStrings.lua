--[[----------------------------------------------------------------------------

  LiteMount/KeyBindingStrings.lua

  Texts for keybindings menu entries.

  Copyright 2011,2012 Mike Battersby

----------------------------------------------------------------------------]]--

local L = LM_Localize

BINDING_HEADER_LITEMOUNT_TITLE = GetAddOnMetadata("LiteMount", "Title")
_G["BINDING_NAME_CLICK LiteMount:LeftButton"] = MOUNT .. " / " .. BINDING_NAME_DISMOUNT
_G["BINDING_NAME_CLICK LiteMount:RightButton"] = L["Non-flying Mount"] .. " / " .. BINDING_NAME_DISMOUNT

