local _, ns = ...
ns.encounterInfo = ns.encounterInfo or {}
ns.itemBlacklist = ns.itemBlacklist or {}

-- http://www.wowhead.com/spells/uncategorized/name:Bonus?filter=84:109:16;1:6:7;::
for spellID, encounterInfo in next, {
    --- World
	-- BrokenIsles
    [227128] = {1790, 822, 14}, -- Ana-Mouz
    [227129] = {1774, 822, 14}, -- Calamir
    [227130] = {1789, 822, 14}, -- Drugon the Frostblood
    [227131] = {1795, 822, 14}, -- Flotsam
    [227132] = {1770, 822, 14}, -- Humongris
    [227133] = {1769, 822, 14}, -- Levantus
    [227134] = {1783, 822, 14}, -- Na'zak the Fiend
    [227135] = {1749, 822, 14}, -- Nithogg
    [227136] = {1763, 822, 14}, -- Shar'thos
    [227137] = {1756, 822, 14}, -- The Soultakers
    [227138] = {1796, 822, 14}, -- Withered J'im
	-- Broken Shore
    [242969] = {1956, 822, 14}, -- Apocron
    [242970] = {1883, 822, 14}, -- Brutallus
    [242971] = {1884, 822, 14}, -- Malificus
    [242972] = {1885, 822, 14}, -- Si'vash
	-- Invasion Points
	[254441] = {2010, 959, 14}, -- Matron Folnuna
	[254437] = {2011, 959, 14}, -- Mistress Alluradel
	[254435] = {2012, 959, 14}, -- Inquisitor Meto
	[254443] = {2013, 959, 14}, -- Occularus
	[254446] = {2014, 959, 14}, -- Sotanathor
	[254439] = {2015, 959, 14}, -- Pit Lord Vilemus

    --- Raids
    -- The Emerald Nightmare
    [221046] = {1703, 768, nil, 14}, -- Nythendra
    [221047] = {1738, 768, nil, 14}, -- Il'gynoth, Heart of Corruption
    [221048] = {1744, 768, nil, 14}, -- Elerethe Renferal
    [221049] = {1667, 768, nil, 14}, -- Ursoc
    [221050] = {1704, 768, nil, 14}, -- Dragons of Nightmare
    [221052] = {1750, 768, nil, 14}, -- Cenarius
    [221053] = {1726, 768, nil, 14}, -- Xavius

    -- Trial of Valor
    [232466] = {1819, 861, nil, 14}, -- Odyn
    [232467] = {1830, 861, nil, 14}, -- Guarm
    [232468] = {1829, 861, nil, 14}, -- Helya

    -- The Nighthold
    [232436] = {1706, 786, nil, 14}, -- Skorpyron
    [232437] = {1725, 786, nil, 14}, -- Chronomatic Anomaly
    [232438] = {1731, 786, nil, 14}, -- Trilliax
    [232439] = {1751, 786, nil, 14}, -- Spellblade Aluriel
    [232440] = {1762, 786, nil, 14}, -- Tichondrius
    [232441] = {1713, 786, nil, 14}, -- Krosus
    [232442] = {1761, 786, nil, 14}, -- High Botanist Tel'arn
    [232443] = {1732, 786, nil, 14}, -- Star Augur Etraeus
    -- Grand Magistrix Elisande needs special handling
    [232445] = {1737, 786, nil, 14}, -- Gul'dan

    -- Tomb of Sargeras
    [240655] = {1862, 875, nil, 14}, -- Goroth
    [240656] = {1867, 875, nil, 14}, -- Demonic Inquisition
    [240657] = {1856, 875, nil, 14}, -- Harjatan
    [240658] = {1861, 875, nil, 14}, -- Mistress Sassz'ine
    [240659] = {1903, 875, nil, 14}, -- Sisters of the Moon
    [240660] = {1896, 875, nil, 14}, -- The Desolate Host
    [240661] = {1897, 875, nil, 14}, -- Maiden of Vigilance
    [240662] = {1873, 875, nil, 14}, -- Fallen Avatar
    [240663] = {1898, 875, nil, 14}, -- Kil'jaeden
	
	-- Antorus, the Burning Throne
	[250588] = {1992, 946, nil, 14}, -- Garothi Worldbreaker
	[250598] = {1987, 946, nil, 14}, -- Felhounds of Sargeras
	[250600] = {1997, 946, nil, 14}, -- Antoran High Command
	[250601] = {1985, 946, nil, 14}, -- Portal Keeper Hasabel
	[250602] = {2025, 946, nil, 14}, -- Eonar the Life-Binder
	[250603] = {2009, 946, nil, 14}, -- Imonar the Soulhunter
	[250604] = {2004, 946, nil, 14}, -- Kin'garoth
	[250605] = {1983, 946, nil, 14}, -- Varimathras
	[250606] = {1986, 946, nil, 14}, -- The Coven of Shivarra
	[250607] = {1984, 946, nil, 14}, -- Aggramar
	[250608] = {2031, 946, nil, 14}, -- Argus the Unmaker

    --- Dungeons
    -- Return to Karazhan (Mythic)
    [232102] = {1820, 860, 23}, -- Opera Hall: Wikket
    [232103] = {1826, 860, 23}, -- Opera Hall: Westfall Story
    [232104] = {1827, 860, 23}, -- Opera Hall: Beautiful Beast
    [232101] = {1825, 860, 23}, -- Maiden of Virtue
    [232099] = {1835, 860, 23}, -- Attumen the Huntsman
    [232100] = {1837, 860, 23}, -- Moroes
    [232105] = {1836, 860, 23}, -- The Curator
    [232106] = {1817, 860, 23}, -- Shade of Medivh
    [232107] = {1818, 860, 23}, -- Mana Devourer
    [232108] = {1838, 860, 23}, -- Viz'aduum the Watcher

    -- Assault on Violet Hold (Mythic)
    [226656] = {1693, 777, 23}, -- Festerface
    [226657] = {1694, 777, 23}, -- Shivermaw
    [226658] = {1702, 777, 23}, -- Blood-Princess Thal'ena
    [226659] = {1686, 777, 23}, -- Mindflayer Kaahrj
    [226660] = {1688, 777, 23}, -- Millificent Manastorm
    [226661] = {1696, 777, 23}, -- Anub'esset
    [226662] = {1711, 777, 23}, -- Sael'orn
    [226663] = {1697, 777, 23}, -- Fel Lord Betrug

    -- Black Rook Hold (Mythic)
    [226595] = {1518, 740, 23}, -- The Amalgam of Souls
    [226599] = {1653, 740, 23}, -- Illysanna Ravencrest
    [226600] = {1664, 740, 23}, -- Smashspite the Hateful
    [226603] = {1672, 740, 23}, -- Lord Kur'talos Ravencrest

    -- Court of Stars (Mythic)
    [226605] = {1718, 800, 23}, -- Patrol Captain Gerdo
    [226607] = {1719, 800, 23}, -- Talixae Flamewreath
    [226608] = {1720, 800, 23}, -- Advisor Melandrus

    -- Darkheart Thicket (Mythic)
    [226610] = {1654, 762, 23}, -- Archdruid Glaidalis
    [226611] = {1655, 762, 23}, -- Oakheart
    [226613] = {1656, 762, 23}, -- Dresaron
    [226615] = {1657, 762, 23}, -- Shade of Xavius

    -- Eye of Azshara (Mythic)
    [226618] = {1480, 716, 23}, -- Warlord Parjesh
    [226619] = {1490, 716, 23}, -- Lady Hatecoil
    [226621] = {1491, 716, 23}, -- King Deepbeard
    [226622] = {1479, 716, 23}, -- Serpentrix
    [226624] = {1492, 716, 23}, -- Wrath of Azshara

    -- Halls of Valor (Mythic)
    [226636] = {1485, 721, 23}, -- Hymdall
    [226626] = {1486, 721, 23}, -- Hyrja
    [226627] = {1487, 721, 23}, -- Fenryr
    [226629] = {1488, 721, 23}, -- God-King Skovald
    [226625] = {1489, 721, 23}, -- Odyn

    -- Maw of Souls (Mythic)
    [226637] = {1502, 727, 23}, -- Ymiron, the Fallen King
    [226638] = {1512, 727, 23}, -- Harbaron
    [226639] = {1663, 727, 23}, -- Helya

    -- Neltharion's Lair (Mythic)
    [226640] = {1662, 767, 23}, -- Rokmora
    [226641] = {1665, 767, 23}, -- Ularogg Cragshaper
    [226642] = {1673, 767, 23}, -- Naraxas
    [226643] = {1687, 767, 23}, -- Dargul the Underking

    -- The Arcway (Mythic)
    [226644] = {1497, 726, 23}, -- Ivanyr
    [226645] = {1498, 726, 23}, -- Corstilax
    [226646] = {1499, 726, 23}, -- General Xakal
    [226647] = {1500, 726, 23}, -- Nal'tira
    [226648] = {1501, 726, 23}, -- Advisor Vandros

    -- Vault of the Wardens (Mythic)
    [226649] = {1467, 707, 23}, -- Tirathon Saltheril
    [226652] = {1695, 707, 23}, -- Inquisitor Tormentorum
    [226653] = {1468, 707, 23}, -- Ash'golm
    [226654] = {1469, 707, 23}, -- Glazer
    [226655] = {1470, 707, 23}, -- Cordana Felsong

    -- Cathedral of Eternal Night (Mythic)
    [244782] = {1905, 900, 23}, -- Agronox
    [244783] = {1906, 900, 23}, -- Thrashbite the Scornful
    [244784] = {1904, 900, 23}, -- Domatrax
    [244786] = {1878, 900, 23}, -- Mephistroth
	
    -- Seat of the Triumvirate (Mythic)
    [247488] = {1979, 945, 13}, -- Zuraal the Ascended
    [247489] = {1980, 945, 13}, -- Saprish
    [247490] = {1981, 945, 13}, -- Viceroy Nezhar
    [247491] = {1982, 945, 13}, -- L'ura
	
} do
    ns.encounterInfo[spellID] = encounterInfo
end

for _, itemID in next, {
    -- Mounts
} do
    ns.itemBlacklist[itemID] = true
end
