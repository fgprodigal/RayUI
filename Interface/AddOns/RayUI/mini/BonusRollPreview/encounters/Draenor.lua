local _, ns = ...
ns.encounterIDs = ns.encounterIDs or {}
ns.itemBlacklist = ns.itemBlacklist or {}
ns.continents = ns.continents or {}

-- http://www.wowhead.com/spells=0?filter=na=Bonus;cr=84:109:16;crs=1:6:6
for spellID, encounterID in next, {
	-- World - 557
	[178847] = 1291, -- Drov the Ruiner
	[178849] = 1211, -- Tarina the Ageless
	[178851] = 1262, -- Rukhmar
	[188985] = 1452, -- Supreme Lord Kazzak

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
	[177539] = 959,   -- Blackhand

	-- Hellfire Citadel - 669
	[188972] = 1426, -- Hellfire Assault
	[188973] = 1425, -- Iron Reaver
	[188974] = 1392, -- Kormrok
	[188975] = 1432, -- Hellfire High Council
	[188976] = 1396, -- Kilrogg Deadeye
	[188977] = 1372, -- Gorefiend
	[188978] = 1433, -- Shadow-Lord Iskar
	[188979] = 1427, -- Socrethar the Eternal
	[188980] = 1391, -- Fel Lord Zakuun
	[188981] = 1447, -- Xhul'horac
	[188982] = 1394, -- Tyrant Velhari
	[188983] = 1395, -- Mannoroth
	[188984] = 1438, -- Archimonde

	-- Auchindoun (Mythic) - 547
	[190154] = 1185, -- Vigilant Kaathar
	[190155] = 1186, -- Soulbinder Nyami
	[190156] = 1216, -- Azzakel
	[190157] = 1225, -- Teron'gor

	-- Upper Blackrock Spire (Mythic) - 559
	[190168] = 1226, -- Orebender Gor'ashan
	[190170] = 1227, -- Kyrak
	[190171] = 1228, -- Commander Tharbek
	[190172] = 1229, -- Ragewing the Untamed
	[190173] = 1234, -- Warlord Zaela

	-- Shadowmoon Burial Grounds (Mythic) - 537
	[190150] = 1139, -- Sadana Bloodfury
	[190151] = 1168, -- Nhallish
	[190152] = 1140, -- Bonemaw
	[190153] = 1160, -- Ner'zhul

	-- The Everbloom (Mythic) - 556
	[190158] = 1214, -- Witherbark
	[190159] = 1207, -- Ancient Protectors
	[190160] = 1208, -- Archmage Sol
	[190162] = 1209, -- Xeri'tac
	[190163] = 1210, -- Yalnu

	-- Grimrail Depot (Mythic) - 536
	[190147] = 1138, -- Rocketspark and Borka
	[190148] = 1163, -- Nitrogg Thundertower
	[190149] = 1133, -- Skylord Tovra

	-- Iron Docks (Mythic) - 558
	[190164] = 1235, -- Fleshrender Nok'gar
	[190165] = 1236, -- Grimrail Enforcers
	[190166] = 1237, -- Oshir
	[190167] = 1238, -- Skulloc

	-- Skyreach (Mythic) - 476
	[190142] = 965, -- Ranjit
	[190143] = 966, -- Araknath
	[190144] = 967, -- Rukhran
	[190146] = 968, -- High Sage Viryx

	-- Bloodmaul Slag Mines (Mythic) - 385
	[190138] = 893, -- Magmolatus
	[190139] = 888, -- Slave Watcher Crushto
	[190140] = 887, -- Roltall
	[190141] = 889, -- Gug'rokk
} do
	ns.encounterIDs[spellID] = encounterID
end

for _, itemID in next, {
	-- Mounts
	116771, -- Solar Spirehawk
	116660, -- Ironhoof Destroyer
	123890, -- Felsteel Annihilator
} do
	ns.itemBlacklist[itemID] = true
end

ns.continents[7] = 557
