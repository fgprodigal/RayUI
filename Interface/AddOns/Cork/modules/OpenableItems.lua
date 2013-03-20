
local myname, ns = ...


local crates = ns:New("Crates")
crates.Init = ns.InitItemOpener
crates.tiptext = "Warn when you have fished-up crates that need opened."
crates.items = {
	6351, 6352, 6353, 6355, 6356, 6357, 13874, 13875, 20708, 21113, 21150, 21228,
	27513, 27446, 27481, 34863, 35348, 44475, 46007, 67414, 67597, 68798, 68799,
	68800, 68801, 68801, 68803, 68804, 68805, 78930, 88496
}


local clams = ns:New("Clams")
clams.Init = ns.InitItemOpener
clams.tiptext = "Warn when you have clams in your bags that need shucked."
clams.items = {7973, 24476, 5523, 15874, 5524, 32724, 36781, 45909, 52340, 65513}


local bloated = ns:New("Bloated innards")
bloated.Init = ns.InitItemOpener
bloated.tiptext = "Warn when you have bloated innards that need opened."
bloated.items = {67495, 72201}
