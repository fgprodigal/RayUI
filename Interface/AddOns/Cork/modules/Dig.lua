
local myname, Cork = ...

local IconLine = Cork.IconLine
local ldb, ae = LibStub:GetLibrary("LibDataBroker-1.1"), LibStub("AceEvent-3.0")

Cork.defaultspc["Archaeology digs-enabled"] = true

local dataobj = ldb:NewDataObject("Cork Archaeology digs", {type = "cork", tiptext = "Warn when there is a digsite available in your current zone."})

function dataobj:Scan()
	if not Cork.dbpc["Archaeology digs-enabled"] then
		dataobj.player = nil
		return
	end

	local digs = ArchaeologyMapUpdateAll()
	if digs > 0 then
		local _, _, icon = GetSpellInfo(80451)
		dataobj.player = IconLine(icon, "Digsites ("..digs..")")
		return
	end
	dataobj.player = nil
end

ae.RegisterEvent("Cork Archaeology digs", "WORLD_MAP_UPDATE", dataobj.Scan)
ae.RegisterEvent("Cork Archaeology digs", "ARTIFACT_DIG_SITE_UPDATED", dataobj.Scan)
