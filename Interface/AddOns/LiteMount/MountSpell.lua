--[[----------------------------------------------------------------------------

  LiteMount/MountSpell.lua

  Querying mounting spells. Needed because IsSpellKnown() never returns
  true for companion spells.

  Copyright 2011,2012 Mike Battersby

----------------------------------------------------------------------------]]--

LM_MountSpell = { }

-- GetSpellBookItemInfo and IsSpellKnown don't work for companions. The
-- first part of this can probably be replaced with IsSpellKnown() but
-- it's working so I'm leaving it alone.

function LM_MountSpell:IsKnown(spellId)
    local spellname = GetSpellInfo(spellId)

    if spellname and GetSpellBookItemInfo(spellname) then
        return true
    end

    for i = 1, GetNumCompanions("MOUNT") do
        local cs = select(3, GetCompanionInfo("MOUNT", i))
        if cs == spellId then
            return true
        end
    end

    return nil
end

local function KnowProfessionSkillLine(skillLine)
    for _,i in ipairs({ GetProfessions() }) do
        if i and select(7, GetProfessionInfo(i)) == skillLine then
            return true
        end
    end
    return false
end

function LM_MountSpell:IsUsable(spellId)
    if not IsUsableSpell(spellId) then
        return nil
    end

    local sl = LM_PROFESSION_MOUNT_SPELLS[spellId]

    if sl and not KnowProfessionSkillLine(sl) then
        return nil
    end

    return true
end
