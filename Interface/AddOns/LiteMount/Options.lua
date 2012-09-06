--[[----------------------------------------------------------------------------

  LiteMount/Options.lua

  User-settable options.  Theses are queried by different places.

  Copyright 2011,2012 Mike Battersby

----------------------------------------------------------------------------]]--

--[[----------------------------------------------------------------------------

excludedspells is a list of spell ids the player has disabled
    ["excludedspells"] = { spellid1, spellid2, spellid3, ... }
  
flagoverrides is a table of tuples with bits to set and clear.
    ["flagoverrides"] = {
        ["spellid"] = { bits_to_set, bits_to_clear },
        ...
    }

The modified mount flags are then:
    ( flags | bits_to_set ) & !bits_to_clear

The reason to do it this way instead of just storing the xor is that
the default flags might change and we don't want the override to suddenly
go from disabling somthing to enabling it.

----------------------------------------------------------------------------]]--

local Default_LM_OptionsDB = {
    ["excludedspells"] = { },
    ["flagoverrides"]  = { },
    ["macro"]          = { },       -- [1] = macro
    ["combatMacro"]    = { },       -- [1] = macro, [2] == 0/1 enabled
}

LM_Options = { }

function LM_Options:Initialize()

    if not LM_OptionsDB then
        LM_OptionsDB = Default_LM_OptionsDB
    end

    -- Compatibility fixups
    if not LM_OptionsDB.excludedspells then
        local orig = LM_OptionsDB
        LM_OptionsDB = Default_LM_OptionsDB
        LM_OptionsDB.excludedspells = orig
    end

    if not LM_OptionsDB.macro then
        LM_OptionsDB.macro = { }
    end

    if not LM_OptionsDB.combatMacro then
        LM_OptionsDB.combatMacro = { }
    end

    self.db = LM_OptionsDB

end

--[[----------------------------------------------------------------------------
     Excluded Spell stuff.
----------------------------------------------------------------------------]]--

function LM_Options:IsExcludedSpell(id)
    for _,s in ipairs(self.db.excludedspells) do
        if s == id then return true end
    end
end

function LM_Options:AddExcludedSpell(id)
    LM_Debug(string.format("Disabling mount %s (%d).", GetSpellInfo(id), id))
    if not self:IsExcludedSpell(id) then
        table.insert(self.db.excludedspells, id)
        table.sort(self.db.excludedspells)
    end
end

function LM_Options:RemoveExcludedSpell(id)
    LM_Debug(string.format("Enabling mount %s (%d).", GetSpellInfo(id), id))
    for i = 1, #self.db.excludedspells do
        if self.db.excludedspells[i] == id then
            table.remove(self.db.excludedspells, i)
            return
        end
    end
end

function LM_Options:SetExcludedSpells(idlist)
    LM_Debug("Setting complete list of disabled mounts.")
    table.wipe(self.db.excludedspells)
    for _,id in ipairs(idlist) do
        table.insert(self.db.excludedspells, id)
    end
    table.sort(self.db.excludedspells)
end

--[[----------------------------------------------------------------------------
     Mount flag overrides stuff
----------------------------------------------------------------------------]]--

function LM_Options:ApplySpellFlags(id, flags)
    local ov = self.db.flagoverrides[id]

    if not ov then return flags end

    flags = bit.bor(flags, ov[1])
    flags = bit.band(flags, bit.bnot(ov[2]))

    return flags
end

function LM_Options:SetSpellFlagBit(id, origflags, flagbit)
    LM_Debug(string.format("Setting flag bit %d for spell %s (%d).",
                           flagbit, GetSpellInfo(id), id))

    local newflags = self:ApplySpellFlags(id, origflags)
    newflags = bit.bor(newflags, flagbit)
    LM_Options:SetSpellFlags(id, origflags, newflags)
end

function LM_Options:ClearSpellFlagBit(id, origflags, flagbit)
    LM_Debug(string.format("Clearing flag bit %d for spell %s (%d).",
                           flagbit, GetSpellInfo(id), id))

    local newflags = self:ApplySpellFlags(id, origflags)
    newflags = bit.band(newflags, bit.bnot(flagbit))
    LM_Options:SetSpellFlags(id, origflags, newflags)
end

function LM_Options:ResetSpellFlags(id)
    LM_Debug(string.format("Defaulting flags for spell %s (%d).",
                           GetSpellInfo(id), id))

    self.db.flagoverrides[id] = nil
end

function LM_Options:SetSpellFlags(id, origflags, newflags)

    if origflags == newflags then
        self:ResetSpellFlags(id)
        return
    end

    if not self.db.flagoverrides[id] then
        self.db.flagoverrides[id] = { 0, 0 }
    end

    local toset = bit.band(bit.bxor(origflags, newflags), newflags)
    local toclear = bit.band(bit.bxor(origflags, newflags), bit.bnot(newflags))

    self.db.flagoverrides[id][1] = toset
    self.db.flagoverrides[id][2] = toclear
end

--[[----------------------------------------------------------------------------
     Last resort / combat macro stuff
----------------------------------------------------------------------------]]--

function LM_Options:UseMacro()
    return self.db.macro[1] ~= nil
end

function LM_Options:GetMacro()
    return self.db.macro[1]
end

function LM_Options:SetMacro(text)
    LM_Debug("Setting custom macro: " .. (text or "nil"))
    self.db.macro[1] = text
end

function LM_Options:UseCombatMacro()
    return self.db.combatMacro[2] ~= nil
end

function LM_Options:GetCombatMacro()
    return self.db.combatMacro[1]
end

function LM_Options:SetCombatMacro(text)
    LM_Debug("Setting custom combat macro: " .. (text or "nil"))
    self.db.combatMacro[1] = text
end

function LM_Options:EnableCombatMacro()
    LM_Debug("Enabling custom combat macro.")
    self.db.combatMacro[2] = 1
end

function LM_Options:DisableCombatMacro()
    LM_Debug("Disabling custom combat macro.")
    self.db.combatMacro[2] = nil
end
