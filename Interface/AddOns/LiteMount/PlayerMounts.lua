--[[----------------------------------------------------------------------------

  LiteMount/PlayerMounts.lua

  Information on all your mounts.

  Copyright 2011,2012 Mike Battersby

----------------------------------------------------------------------------]]--

-- We sub-tables so we can wipe() them without losing the methods.
LM_PlayerMounts = {
    ["byName"] = { },
    ["list"] = LM_MountList:New(),
}

function LM_PlayerMounts:Initialize()
    table.wipe(self.byName)
    table.wipe(self.list)
end

function LM_PlayerMounts:AddMount(m)
    if m and not self.byName[m.name] then
        self.byName[m.name] = m
        table.insert(self.list, m)
    end
end

function LM_PlayerMounts:AddCompanionMounts()
    for i = 1,GetNumCompanions("MOUNT") do
        local m = LM_Mount:GetMountByIndex(i)
        self:AddMount(m)
    end
end

function LM_PlayerMounts:AddRacialMounts()
    for _,spellid in ipairs(LM_RACIAL_MOUNT_SPELLS) do
        if LM_MountSpell:IsKnown(spellid) then
            local m = LM_Mount:GetMountBySpell(spellid)
            self:AddMount(m)
        end
    end
end

function LM_PlayerMounts:AddClassMounts()
    for _,spellid in ipairs(LM_CLASS_MOUNT_SPELLS) do
        if LM_MountSpell:IsKnown(spellid) then
            local m = LM_Mount:GetMountBySpell(spellid)
            self:AddMount(m)
        end
    end
end

function LM_PlayerMounts:AddItemMounts()
    for itemid,spellid in pairs(LM_ITEM_MOUNT_ITEMS) do
        if LM_MountItem:HasItem(itemid) then
            local m = LM_Mount:GetMountByItem(itemid, spellid)
            self:AddMount(m)
        end
    end
end

function LM_PlayerMounts:ScanMounts()

    table.wipe(self.byName)
    table.wipe(self.list)

    self:AddCompanionMounts()
    self:AddRacialMounts()
    self:AddClassMounts()
    self:AddItemMounts()

    self.list:Sort()
end

function LM_PlayerMounts:Search(matchfunc)
    return self.list:Search(matchfunc)
end

function LM_PlayerMounts:GetAllMounts()
    local function match() return true end
    return self:Search(match)
end

function LM_PlayerMounts:GetAvailableMounts(flags)
    local function match(m)
        if not m:IsUsable() then return end
        if not m:FlagsSet(flags) then return end
        if m:IsExcluded() then return end
        return 1
    end

    return self:Search(match)
end

function LM_PlayerMounts:GetRandomMount(flags)
    local poss = self:GetAvailableMounts(flags)
    return poss:Random()
end


function LM_PlayerMounts:GetFlyingMount()
    return self:GetRandomMount(LM_FLAG_BIT_FLY)
end

function LM_PlayerMounts:GetWalkingMount()
    return self:GetRandomMount(LM_FLAG_BIT_WALK)
end

function LM_PlayerMounts:GetRunningMount()
    return self:GetRandomMount(LM_FLAG_BIT_RUN)
end

function LM_PlayerMounts:GetAQMount()
    return self:GetRandomMount(LM_FLAG_BIT_AQ)
end

function LM_PlayerMounts:GetVashjirMount()
    return self:GetRandomMount(LM_FLAG_BIT_VASHJIR)
end

function LM_PlayerMounts:GetSwimmingMount()
    return self:GetRandomMount(LM_FLAG_BIT_SWIM)
end

function LM_PlayerMounts:Dump()
    for m in self.list:Iterate() do
        m:Dump()
    end
end
