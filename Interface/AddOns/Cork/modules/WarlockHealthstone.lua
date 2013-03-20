
local myname, Cork = ...
if Cork.MYCLASS ~= "WARLOCK" then return end

local myname, Cork = ...
local spellname = GetSpellInfo(6201)
local IconLine = Cork.IconLine(GetItemIcon(5509), spellname)
local ldb, ae = LibStub:GetLibrary("LibDataBroker-1.1"), LibStub("AceEvent-3.0")

local ITEMS = {5509, 5510, 5511, 5512, 9421, 19004, 19005, 19006, 19007, 19008, 19009, 19010, 19011, 19012, 19013, 22103, 22104, 22105, 36889, 36890, 36891, 36892, 36893, 36894}

local dataobj = ldb:NewDataObject("Cork Healthstone", {type = "cork", tiptext = "Warn when you do not have a healthstone in your bags."})

function dataobj:Init()
	Cork.defaultspc["Healthstone-enabled"] = GetSpellInfo(spellname)
end

function dataobj:Scan()
	if not Cork.dbpc["Healthstone-enabled"] or (IsResting() and not Cork.db.debug) then
		dataobj.player = nil
		return
	end

	for _,id in pairs(ITEMS) do
		if (GetItemCount(id) or 0) > 0 then
			dataobj.player = nil
			return
		end
	end
	dataobj.player = IconLine
end

ae.RegisterEvent("Cork Healthstone", "BAG_UPDATE", dataobj.Scan)
ae.RegisterEvent("Cork Healthstone", "PLAYER_UPDATE_RESTING", dataobj.Scan)

function dataobj:CorkIt(frame)
	if dataobj.player then return frame:SetManyAttributes("type1", "spell", "spell", spellname) end
end
