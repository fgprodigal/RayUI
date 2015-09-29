
local _, ns = ...
ns.encounterIDs = ns.encounterIDs or {}
ns.itemBlacklist = ns.itemBlacklist or {}
ns.continents = ns.continents or {}

-- http://www.wowhead.com/spells=0?filter=na=Bonus;cr=84:109:16;crs=1:6:5
for spellID, encounterID in next, {
	-- World - 322
	[132205] = 691, -- Sha of Anger
	[132206] = 725, -- Salyis' Warband (Galleon)
	[136381] = 814, -- Nalak, The Storm God
	[137554] = 826, -- Oondasta
	[148317] = 857, -- Celestials (also encounterIDs 858, 859 and 860)
	[148316] = 861, -- Ordos, Fire-God of the Yaungol

	-- Mogu'Shan Vaults - 317
	[125144] = 679, -- The Stone Guard
	[132189] = 689, -- Feng the Accursed
	[132190] = 682, -- Gara'jal the Spiritbinder
	[132191] = 687, -- The Spirit Kings
	[132192] = 726, -- Elegon
	[132193] = 677, -- Will of the Emperor

	-- Heart of Fear - 330
	[132194] = 745, -- Imperial Vizier Zor'lok
	[132195] = 744, -- Blade Lord Tay'ak
	[132196] = 713, -- Garalon
	[132197] = 741, -- Wind Lord Mel'jarak
	[132198] = 737, -- Amber-Shaper Un'sok
	[132199] = 743, -- Grand Empress Shek'zeer

	-- Terrace of Endless Spring - 320
	[132200] = 683, -- Protectors of the Endless
	[132204] = 683, -- Protectors of the Endless (Elite)
	[132201] = 742, -- Tsulong
	[132202] = 729, -- Lei Shi
	[132203] = 709, -- Sha of Fear

	-- Throne of Thunder - 362
	[139674] = 827, -- Jin'rokh the Breaker
	[139677] = 819, -- Horridon
	[139679] = 816, -- Council of Elders
	[139680] = 825, -- Tortos
	[139682] = 821, -- Magaera
	[139684] = 828, -- Ji'kun, the Ancient Mother
	[139686] = 818, -- Durumu the Forgotten
	[139687] = 820, -- Primordious
	[139688] = 824, -- Dark Animus
	[139689] = 817, -- Iron Qon
	[139690] = 829, -- Twin Consorts (Empyreal Queens)
	[139691] = 832, -- Lei Shen, The Thunder King
	[139692] = 831, -- Ra-den

	-- Siege of Orgrimmar - 369
	[145909] = 852, -- Immerseus
	[145910] = 849, -- The Fallen Protectors
	[145911] = 866, -- Norushen
	[145912] = 867, -- Sha of Pride
	[145914] = 864, -- Iron Juggernaut
	[145915] = 856, -- Kor'kron Dark Shaman
	[145916] = 850, -- General Nazgrim
	[145917] = 846, -- Malkorok
	[145919] = 870, -- Spoils of Pandaria
	[145920] = 851, -- Thok the Bloodthirsty
	[145918] = 865, -- Siegecrafter Blackfuse
	[145921] = 853, -- Paragons of the Klaxxi
	[145922] = 869  -- Garrosh Hellscream
} do
	ns.encounterIDs[spellID] = encounterID
end

-- Galakras has two IDs, pick whatever the client uses
local Handler = CreateFrame('Frame')
Handler:RegisterEvent('PLAYER_LOGIN')
Handler:SetScript('OnEvent', function()
	EJ_SelectInstance(369)
	ns.encounterIDs[145913] = (select(3, EJ_GetEncounterInfoByIndex(5)))
end)

for _, itemID in next, {
	-- Mounts
	87777, -- Reins of the Astral Cloud Serpent
	93666, -- Spawn of Horridon
	95059, -- Cluth of Ji-Kun
	104253, -- Kor'kron Juggernaut

	-- Garrosh Heirlooms (Normal, Heroic, Mythic)
	105674, 104409, 105687, -- Hellscream's Barrier
	105672, 104404, 105685, -- Hellscream's Cleaver
	105679, 104405, 105692, -- Hellscream's Decapitator
	105678, 104401, 105691, -- Hellscream's Doomblade
	105673, 104403, 105686, -- Hellscream's Pig Sticker
	105671, 104400, 105684, -- Hellscream's Razor
	105680, 104407, 105693, -- Hellscream's Shield Wall
	105676, 104408, 105689, -- Hellscream's Tome of Destruction
	105677, 104406, 105690, -- Hellscream's War Staff
	105670, 104399, 105683, -- Hellscream's Warbow
	105675, 104402, 105688, -- Hellscream's Warmace
} do
	ns.itemBlacklist[itemID] = true
end

ns.continents[6] = 322
