--[[----------------------------------------------------------------------------

  LiteMount/MountList.lua

  Class for a list of LM_Mount mounts.

  Copyright 2011,2012 Mike Battersby

----------------------------------------------------------------------------]]--

--[[----------------------------------------------------------------------------

  A primer reminder for me on LUA metatables and doing OO stuff in
  them.  If you rewrite this from scratch don't make it OO, OK.
  See also: http://www.lua.org/pil/13.html
 
  You can set a "metatable" on a table with
    setmetatable(theTable, theMetaTable)

  Special records in the metatable are used for table access in
  the case that the table key doesn't exist:

    __index = function (table, key) return value end
    __newindex = function (table, key, value) store_value_somehow end

  Also arithmetic and comparison operators: __add __mul __eq __lt __le

  The generic case for metatable "inheritence" is

    baseTable = { whatever }
    childTable = { whateverelse }
    metaTable = { __index = function (t,k) return baseTable[k] end }
    setmetatable(childTable, metaTable)

  This is so common that LUA allows a shortcut where you can set __index
  to be a table instead of a function, and it will do the lookups in
  that table.

    baseTable = { whatever }
    childTable = { whateverelse }
    metaTable = { __index = baseTable }
    setmetatable(childTable, metaTable)

  Then as a further shortcut, instead of requiring a separate metatable
  you can just use the base table itself as the metatable by setting its
  __index record.

    baseTable = { whatever }
    baseTable.__index = baseTable
    setmetatable(childTable, baseTable)

  This is typical class-style OO.

----------------------------------------------------------------------------]]--

LM_MountList = { }
LM_MountList.__index = LM_MountList

function LM_MountList:New(ml)
    local ml = ml or { }
    setmetatable(ml, LM_MountList)
    return ml
end

function LM_MountList:Search(matchfunc)
    local result = LM_MountList:New()

    for m in self:Iterate() do
        if matchfunc(m) then
            table.insert(result, m)
        end
    end

    return result
end

function LM_MountList:Shuffle()
    -- Shuffle, http://forums.wowace.com/showthread.php?t=16628
    for i = #self, 2, -1 do
        local r = math.random(i)
        self[i], self[r] = self[r], self[i]
    end
end

function LM_MountList:Random()
    local n = #self
    if n == 0 then
        return nil
    else
        return self[math.random(n)]
    end
end

function LM_MountList:WeightedRandom()
    local n = #self
    if n == 0 then return nil end

    local weightsum = 0
    for m in self:Iterate() do
        weightsum = weightsum + (m.weight or 10)
    end

    local r = math.random(weightsum)
    local t = 0
    for m in self:Iterate() do
        t = t + (m.weight or 10)
        if t >= r then return m end
    end
end

function LM_MountList:Iterate()
    local i = 0
    local iter = function ()
            i = i + 1
            return self[i]
        end
    return iter
end

function LM_MountList:__add(other)
    local r = LM_MountList:New()
    local seen = { }
    for m in self:Iterate() do
        table.insert(r, m)
        seen[m:Name()] = true
    end
    for m in other:Iterate() do
        if not seen[m:Name()] then
            table.insert(r, m)
        end
    end
    return r
end

function LM_MountList:Sort()
    -- because LM_Mount has __lt metamethod defined we don't need a func
    table.sort(self)
end

function LM_MountList:Map(mapfunc)
    for m in self:Iterate() do
        mapfunc(m)
    end
end

