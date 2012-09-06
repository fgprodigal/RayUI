--[[----------------------------------------------------------------------------

  LiteMount/UIOptionsCombatMacro.lua

  Options frame to plug in to the Blizzard interface menu.

  Copyright 2011,2012 Mike Battersby

----------------------------------------------------------------------------]]--

function LiteMountOptionsCombatMacro_OnLoad(self)

    LiteMount_Frame_AutoLocalize(self)

    self.parent = LiteMountOptions.name
    self.name = MACRO .. " : " .. COMBAT
    self.title:SetText("LiteMount : " .. self.name)

    self.default = function ()
            LM_Options:SetCombatMacro(nil)
            LM_Options:DisableCombatMacro()
        end

    InterfaceOptions_AddCategory(self)
end

function LiteMountOptionsCombatMacro_OnShow(self)
    LiteMountOptions.CurrentOptionsPanel = self
    local m = LM_Options:GetCombatMacro()
    if m then
        LiteMountOptionsCombatMacroEditBox:SetText(m)
    end
end

function LiteMountOptionsCombatMacro_OnHide(self)
    LiteMount:PostClick()
end

function LiteMountOptionsCombatMacro_OnTextChanged(self)
    local m = LiteMountOptionsCombatMacroEditBox:GetText()
    if not m or string.match(m, "^%s*$") then
        LM_Options:SetCombatMacro(nil)
    else
        LM_Options:SetCombatMacro(m)
    end

    local c = string.len(m or "")
    LiteMountOptionsCombatMacroCount:SetText(string.format(MACROFRAME_CHAR_LIMIT, c))
end

