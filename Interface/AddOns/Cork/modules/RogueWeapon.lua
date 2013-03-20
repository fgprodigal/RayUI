
local myname, Cork = ...
if Cork.MYCLASS ~= "ROGUE" then return end

local ae = LibStub("AceEvent-3.0")


local mainhand = GetInventorySlotInfo("MainHandSlot")
local onehandtypes = {
	INVTYPE_WEAPON = true,
	INVTYPE_WEAPONMAINHAND = true,
	INVTYPE_WEAPONOFFHAND = true,
}


local function UNIT_INVENTORY_CHANGED(self, event, unit)
	if unit == 'player' then self:Scan() end
end


local function Test(self, ...)
	local id = GetInventoryItemID('player', mainhand)
	if not id then return end

	local _, _, _, _, _, _, _, _, slot = GetItemInfo(id)
	if not slot or not onehandtypes[slot] then return end

	return self.oldtest(...)
end


-- Damage poisons
local dataobj = Cork:GenerateAdvancedSelfBuffer("Poison - Damage", {2823,8679})
dataobj.oldtest = dataobj.Test
dataobj.Test = Test
dataobj.UNIT_INVENTORY_CHANGED = UNIT_INVENTORY_CHANGED
ae.RegisterEvent(dataobj, "UNIT_INVENTORY_CHANGED")


-- Utility poisons
local dataobj = Cork:GenerateAdvancedSelfBuffer("Poison - Utility", {3408,5761,108211,108215})
dataobj.oldtest = dataobj.Test
dataobj.Test = Test
dataobj.UNIT_INVENTORY_CHANGED = UNIT_INVENTORY_CHANGED
ae.RegisterEvent(dataobj, "UNIT_INVENTORY_CHANGED")
