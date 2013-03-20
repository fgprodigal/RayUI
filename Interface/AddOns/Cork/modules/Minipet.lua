
local myname, Cork = ...

local IconLine = Cork.IconLine("Interface\\Icons\\INV_Box_PetCarrier_01", 'Minipet')
local ldb, ae = LibStub:GetLibrary("LibDataBroker-1.1"), LibStub("AceEvent-3.0")

Cork.defaultspc["Minipet-enabled"] = false

local dataobj = ldb:NewDataObject("Cork Minipet", {
	type = "cork",
	priority = 8,
	tiptext = "Warn when you don't have a minipet summoned."
})

function dataobj:Scan()
	if Cork.dbpc["Minipet-enabled"] and not C_PetJournal.GetSummonedPetGUID() then
		dataobj.player = IconLine
		return
	end

	dataobj.player = nil
end

ae.RegisterEvent("Cork Minipet", "COMPANION_UPDATE", dataobj.Scan)

function dataobj:CorkIt(frame)
	if self.player then
		local macro = math.random(4) == 1 and '/randompet' or '/randomfavoritepet'
		return frame:SetManyAttributes("type1", "macro", "macrotext1", macro)
	end
end
