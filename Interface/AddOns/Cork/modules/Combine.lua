
local myname, Cork = ...
local IconLine = Cork.IconLine
local ldb, ae = LibStub:GetLibrary("LibDataBroker-1.1"), LibStub("AceEvent-3.0")

local ITEMS = {[37700] = 10, [37701] = 10, [37702] = 10, [37703] = 10, [37704] = 10, [37705] = 10, [33567] = 5, [34056] = 3, [52718] = 3, [52720] = 3, [52977] = 5}

Cork.defaultspc["Combine-enabled"] = true

local dataobj = ldb:NewDataObject("Cork Combine", {type = "cork", tiptext = "Warn when you have items in your bags that can be condensed like essences and crystalized elements."})

function dataobj:Scan()
	if not Cork.dbpc["Combine-enabled"] or InCombatLockdown() then
		dataobj.player = nil
		return
	end

	for id,threshold in pairs(ITEMS) do
		local count = GetItemCount(id) or 0
		if count >= threshold then
			local itemName, _, _, _, _, _, _, _, _, itemTexture = GetItemInfo(id)
			if itemName then
				dataobj.player = IconLine(itemTexture, itemName.." ("..count..")")
				return
			end
		end
	end
	dataobj.player = nil
end

ae.RegisterEvent("Cork Combine", "BAG_UPDATE", dataobj.Scan)

function dataobj:CorkIt(frame)
	if dataobj.player then
		for id,threshold in pairs(ITEMS) do
			if (GetItemCount(id) or 0) >= threshold then
				return frame:SetManyAttributes("type1", "item", "item1", "item:"..id)
			end
		end
	end
end
