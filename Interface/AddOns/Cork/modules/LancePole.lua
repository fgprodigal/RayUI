
local myname, Cork = ...
local IconLine = Cork.IconLine
local ldb, ae = LibStub:GetLibrary("LibDataBroker-1.1"), LibStub("AceEvent-3.0")


local function Test(self, id)
	return self.items[id]
end


local incombat
local function Scan(self, event)
	if event == "PLAYER_REGEN_DISABLED" then incombat = true
	elseif event == "PLAYER_REGEN_ENABLED" then incombat = false end

	local id = GetInventoryItemID("player", self.slot)

	if not Cork.dbpc[self.name.."-enabled"] or not id or not self:Test(id) then
		self.player = nil
		return
	end

	self.player = IconLine(GetItemIcon(id), (GetItemInfo(id)))
end


function Cork:GenerateEquippedWarning(name, slot, ...)
	local dataobj = ldb:NewDataObject("Cork "..name, {
		type  = "cork",
		name  = name,
		slot  = slot,
		Test  = Test,
		Scan  = Scan,
		items = {...},
		tiptext = "Warn when you have a ".. name:lower()..
		          " equipped at a time you probably don't want it.",
	})

	for i=1,select("#", ...) do dataobj.items[select(i, ...)] = true end

	Cork.defaultspc[name.."-enabled"] = true

	ae.RegisterEvent(dataobj, "UNIT_INVENTORY_CHANGED", "Scan")
	ae.RegisterEvent(dataobj, "PLAYER_REGEN_DISABLED", "Scan")
	ae.RegisterEvent(dataobj, "PLAYER_REGEN_ENABLED", "Scan")

	return dataobj
end


local back = GetInventorySlotInfo("BackSlot")
Cork:GenerateEquippedWarning("Teleport cloak", back,
	63206, 63207, 65274, 65360, 83353, 83352)

local mainhand = GetInventorySlotInfo("MainHandSlot")
Cork:GenerateEquippedWarning("Lance", mainhand, 46069, 46106, 46070, 52716)

local poles = Cork:GenerateEquippedWarning("Fishing pole", mainhand,
	6256, 6365, 6366, 6367, 12225, 19022, 19970, -- Classic
	25978, -- BC
	44050, 45858, 45991, 45992, -- Wrath
	46337, 52678, -- Cat
	84660, 84661) -- PANDAS!

function poles:Test(id)
	return Test(self, id) and not incombat
end
