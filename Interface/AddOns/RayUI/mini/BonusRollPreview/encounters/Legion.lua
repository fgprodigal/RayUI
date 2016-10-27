local _, ns = ...
ns.encounterInfo = ns.encounterInfo or {}
ns.itemBlacklist = ns.itemBlacklist or {}

-- http://www.wowhead.com/spells/uncategorized/name:Bonus?filter=84:109:16;1:6:7;::
for spellID, encounterInfo in next, {
	-- World
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

	-- The Emerald Nightmare
	[221046] = {1703, 768}, -- Nythendra
	[221047] = {1738, 768}, -- Il'gynoth, Heart of Corruption
	[221048] = {1744, 768}, -- Elerethe Renferal
	[221049] = {1667, 768}, -- Ursoc
	[221050] = {1704, 768}, -- Dragons of Nightmare
	[221052] = {1750, 768}, -- Cenarius
	[221053] = {1726, 768}, -- Xavius

	-- The Nighthold
	[232436] = {1706, 786}, -- Skorpyron
	[232437] = {1725, 786}, -- Chronomatic Anomaly
	[232438] = {1731, 786}, -- Trilliax
	[232439] = {1751, 786}, -- Spellblade Aluriel
	[232440] = {1762, 786}, -- Tichondrius
	[232441] = {1713, 786}, -- Krosus
	[232442] = {1761, 786}, -- High Botanist Tel'arn
	[232443] = {1732, 786}, -- Star Augur Etraeus
	[232444] = {1743, 786}, -- Grand Magistrix Elisande
	[232445] = {1737, 786}, -- Gul'dan

	-- Trial of Valor
	[232466] = {1819, 861}, -- Odyn
	[232467] = {1830, 861}, -- Guarm
	[232468] = {1829, 861}, -- Helya

	-- Return to Karazhan (Mythic)
	-- [232099] = {1825, 860, 23}, -- Maiden of Virtue
	-- [232100] = {1820, 860, 23}, -- Opera Hall: Wikket
	-- [232101] = {1826, 860, 23}, -- Opera Hall: Westfall Story
	-- [232102] = {1827, 860, 23}, -- Opera Hall: Beautiful Beast
	-- [232103] = {1835, 860, 23}, -- Attumen the Huntsman
	-- [232104] = {1837, 860, 23}, -- Moroes
	-- [232105] = {1836, 860, 23}, -- The Curator
	[232106] = {1817, 860, 23}, -- Shade of Medivh
	[232107] = {1818, 860, 23}, -- Mana Devourer
	[232108] = {1838, 860, 23}, -- Viz'aduum the Watcher
	-- XXX: there is one more ID (232109), hidden boss?

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
} do
	ns.encounterInfo[spellID] = encounterInfo
end

for _, itemID in next, {
	-- Mounts
} do
	ns.itemBlacklist[itemID] = true
end
