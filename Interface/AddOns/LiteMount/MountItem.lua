--[[----------------------------------------------------------------------------

  LiteMount/MountItem.lua

  Querying mounting items.

  Copyright 2011,2012 Mike Battersby

----------------------------------------------------------------------------]]--

LM_MountItem = { }

function LM_MountItem:HasItem(itemId)
    if GetItemCount(itemId) > 0 then
        return true
    end
end

function LM_MountItem:IsUsable(itemId)

    local spell = LM_ITEM_MOUNT_ITEMS[itemId]

    -- IsUsableSpell seems to test correctly whether it's indoors etc.
    if spell and not IsUsableSpell(spell) then
        return false
    end

    if IsEquippableItem(itemId) then
        if not IsEquippedItem(itemId) then
            return false
        end
    else
        if GetItemCount(itemId) == 0 then
            return false
        end
    end

    -- Either equipped or non-equippable and in bags
    local start, duration, enable = GetItemCooldown(itemId)
    if duration > 0 and enable == 0 then
        return false
    end

    return true
end

