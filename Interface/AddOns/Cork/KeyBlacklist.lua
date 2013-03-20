
local myname, ns = ...

local keys = {
	"configframe",
	"CorkIt",
	"icon",
	"iconline",
	"Init",
	"GROUP_ROSTER_UPDATE",
	"ignoreplayer",
	"items",
	"lasttarget",
	"name",
	"nobg",
	"oldtest",
	"partyonly",
	"priority",
	"RaidLine",
	"Scan",
	"slot",
	"sortname",
	"spellname",
	"spells",
	"Test",
	"TestWithoutResting",
	"tiplink",
	"tiptext",
	"type",
	"UNIT_AURA",
	"UNIT_INVENTORY_CHANGED",
	"UNIT_PET",
}

ns.keyblist = {}
for i,key in pairs(keys) do ns.keyblist[key] = true end
