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

local function KnowProfessionSkillLine(needSkillLine, needRank)
    for _,i in ipairs({ GetProfessions() }) do
        if i then
            local _, _, rank, _, _, _, sl = GetProfessionInfo(i)
            if sl == needSkillLine and rank >= needRank then
                return true
            end
        end
    end
    return false
end

function LM_MountSpell:IsUsable(spellId)
    if not IsUsableSpell(spellId) then
        return nil
    end

    local need = LM_PROFESSION_MOUNT_SPELLS[spellId]

    if need and not KnowProfessionSkillLine(need[1], need[2]) then
        return nil
    end

    return true
end
