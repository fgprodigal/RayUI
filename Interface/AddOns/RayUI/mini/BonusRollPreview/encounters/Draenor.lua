local _, ns = ...
ns.encounterIDs = ns.encounterIDs or {}
ns.continents = ns.continents or {}

-- http://www.wowhead.com/spells=0?filter=na=Bonus;cr=84:109:16;crs=1:6:6
for spellID, encounterID in next, {
	-- World - 557
	[-1] = 1291, -- Drov the Ruiner
	[-1] = 1211, -- Tarina the Ageless
	[-1] = 1262, -- Rukhmar

	-- Highmaul - 477
	[177521] = 1128, -- Kargath Bladefist
	[177522] = 971, -- The Butcher
	[177523] = 1195, -- Tectus
	[177524] = 1196, -- Brackenspore
	[177525] = 1148, -- Twin Ogron
	[177526] = 1153, -- Ko'ragh
	[177528] = 1197, -- Imperator Mar'gok

	-- Blackrock Foundry - 457
	[177529] = 1161, -- Gruul
	[177530] = 1202, -- Oregorger
	[177536] = 1122, -- Beastlord Darmac
	[177534] = 1123, -- Flamebender Ka'graz
	[177533] = 1155, -- Hans'gar and Franzok
	[177537] = 1147, -- Operator Thogar
	[177531] = 1154, -- The Blast Furnace
	[177535] = 1162, -- Kromog
	[177538] = 1203, -- The Iron Maidens
	[177539] = 959   -- Blackhand
} do
	ns.encounterIDs[spellID] = encounterID
end

ns.continents[7] = 557
