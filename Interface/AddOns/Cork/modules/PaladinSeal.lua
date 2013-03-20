
local myname, Cork = ...
if Cork.MYCLASS ~= "PALADIN" then return end


local myname, Cork = ...
local UnitAura = UnitAura
local SpellCastableOnUnit = Cork.SpellCastableOnUnit
local ldb, ae = LibStub:GetLibrary("LibDataBroker-1.1"), LibStub("AceEvent-3.0")

local spellidlist = {20375, 31892, 53736, 20164, 20165, 21084, 53720, 31801, 20166}

local iconline = Cork.IconLine(select(3, GetSpellInfo(spellidlist[1])), "No seal!")
local buffnames = {}
for _,id in pairs(spellidlist) do buffnames[id] = GetSpellInfo(id) end

local defaults = Cork.defaultspc
defaults["Seal-enabled"] = true

local dataobj = LibStub:GetLibrary("LibDataBroker-1.1"):NewDataObject("Cork Seal", {type = "cork"})

local function Test()
	if Cork.dbpc["Seal-enabled"] then
		for _,buff in pairs(buffnames) do if UnitAura("player", buff) then return end end
		return iconline
	end
end

LibStub("AceEvent-3.0").RegisterEvent("Cork Seal", "UNIT_AURA", function(event, unit) if unit == "player" and InCombatLockdown() then dataobj.player = Test() end end)
LibStub("AceEvent-3.0").RegisterEvent("Cork Seal", "PLAYER_REGEN_DISABLED", function() dataobj.player = Test() end)
LibStub("AceEvent-3.0").RegisterEvent("Cork Seal", "PLAYER_REGEN_ENABLED", function() dataobj.player = nil end)

function dataobj:Scan() self.player = InCombatLockdown() and Test() end
