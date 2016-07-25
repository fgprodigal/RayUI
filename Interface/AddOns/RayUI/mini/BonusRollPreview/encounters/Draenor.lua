local _, ns = ...
ns.encounterInfo = ns.encounterInfo or {}
ns.itemBlacklist = ns.itemBlacklist or {}

-- http://www.wowhead.com/spells=0?filter=na=Bonus;cr=84:109:16;crs=1:6:6
for spellID, encounterInfo in next, {
	-- World
	[178847] = {1291, 557, 14}, -- Drov the Ruiner
	[178849] = {1211, 557, 14}, -- Tarina the Ageless
	[178851] = {1262, 557, 14}, -- Rukhmar
	[188985] = {1452, 557, 15}, -- Supreme Lord Kazzak

	-- Highmaul
	[177521] = {1128, 477}, -- Kargath Bladefist
	[177522] = {971, 477}, -- The Butcher
	[177523] = {1195, 477}, -- Tectus
	[177524] = {1196, 477}, -- Brackenspore
	[177525] = {1148, 477}, -- Twin Ogron
	[177526] = {1153, 477}, -- Ko'ragh
	[177528] = {1197, 477}, -- Imperator Mar'gok

	-- Blackrock Foundry
	[177529] = {1161, 457}, -- Gruul
	[177530] = {1202, 457}, -- Oregorger
	[177536] = {1122, 457}, -- Beastlord Darmac
	[177534] = {1123, 457}, -- Flamebender Ka'graz
	[177533] = {1155, 457}, -- Hans'gar and Franzok
	[177537] = {1147, 457}, -- Operator Thogar
	[177531] = {1154, 457}, -- The Blast Furnace
	[177535] = {1162, 457}, -- Kromog
	[177538] = {1203, 457}, -- The Iron Maidens
	[177539] = {959, 457},   -- Blackhand

	-- Hellfire Citadel
	[188972] = {1426, 669}, -- Hellfire Assault
	[188973] = {1425, 669}, -- Iron Reaver
	[188974] = {1392, 669}, -- Kormrok
	[188975] = {1432, 669}, -- Hellfire High Council
	[188976] = {1396, 669}, -- Kilrogg Deadeye
	[188977] = {1372, 669}, -- Gorefiend
	[188978] = {1433, 669}, -- Shadow-Lord Iskar
	[188979] = {1427, 669}, -- Socrethar the Eternal
	[188980] = {1391, 669}, -- Fel Lord Zakuun
	[188981] = {1447, 669}, -- Xhul'horac
	[188982] = {1394, 669}, -- Tyrant Velhari
	[188983] = {1395, 669}, -- Mannoroth
	[188984] = {1438, 669}, -- Archimonde

	-- Auchindoun (Mythic)
	[190154] = {1185, 547, 23}, -- Vigilant Kaathar
	[190155] = {1186, 547, 23}, -- Soulbinder Nyami
	[190156] = {1216, 547, 23}, -- Azzakel
	[190157] = {1225, 547, 23}, -- Teron'gor

	-- Upper Blackrock Spire (Mythic)
	[190168] = {1226, 559, 23}, -- Orebender Gor'ashan
	[190170] = {1227, 559, 23}, -- Kyrak
	[190171] = {1228, 559, 23}, -- Commander Tharbek
	[190172] = {1229, 559, 23}, -- Ragewing the Untamed
	[190173] = {1234, 559, 23}, -- Warlord Zaela

	-- Shadowmoon Burial Grounds (Mythic)
	[190150] = {1139, 537, 23}, -- Sadana Bloodfury
	[190151] = {1168, 537, 23}, -- Nhallish
	[190152] = {1140, 537, 23}, -- Bonemaw
	[190153] = {1160, 537, 23}, -- Ner'zhul

	-- The Everbloom (Mythic)
	[190158] = {1214, 556, 23}, -- Witherbark
	[190159] = {1207, 556, 23}, -- Ancient Protectors
	[190160] = {1208, 556, 23}, -- Archmage Sol
	[190162] = {1209, 556, 23}, -- Xeri'tac
	[190163] = {1210, 556, 23}, -- Yalnu

	-- Grimrail Depot (Mythic)
	[190147] = {1138, 536, 23}, -- Rocketspark and Borka
	[190148] = {1163, 536, 23}, -- Nitrogg Thundertower
	[190149] = {1133, 536, 23}, -- Skylord Tovra

	-- Iron Docks (Mythic)
	[190164] = {1235, 558, 23}, -- Fleshrender Nok'gar
	[190165] = {1236, 558, 23}, -- Grimrail Enforcers
	[190166] = {1237, 558, 23}, -- Oshir
	[190167] = {1238, 558, 23}, -- Skulloc

	-- Skyreach (Mythic)
	[190142] = {965, 476, 23}, -- Ranjit
	[190143] = {966, 476, 23}, -- Araknath
	[190144] = {967, 476, 23}, -- Rukhran
	[190146] = {968, 476, 23}, -- High Sage Viryx

	-- Bloodmaul Slag Mines (Mythic)
	[190138] = {893, 385, 23}, -- Magmolatus
	[190139] = {888, 385, 23}, -- Slave Watcher Crushto
	[190140] = {887, 385, 23}, -- Roltall
	[190141] = {889, 385, 23}, -- Gug'rokk
} do
	ns.encounterInfo[spellID] = encounterInfo
end

for _, itemID in next, {
	-- Mounts
	116771, -- Solar Spirehawk
	116660, -- Ironhoof Destroyer
	123890, -- Felsteel Annihilator
} do
	ns.itemBlacklist[itemID] = true
end