local addon = select(2, ...)
local l = addon.locale
local lib = LibStub:NewLibrary("LibBossIDs", 1)

local BossIDs = {
	-------------------------------------------------------------------------------
	-- Pandaria Raid
	-------------------------------------------------------------------------------
	-- Terrace of Endless Spring
	[60583] = l.prot,	-- Protector Kaolan
	[60585] = l.prot,	-- Elder Regail
	[60586] = l.prot,	-- Elder Asani
	[62442] = true,		-- Tsulong
	[62983] = true,		-- Lei Shi
	[60999] = true,		-- Sha of Fear
	-- Heart of Fear
	[62980] = true,		-- Imperial Vizier Zor'lok
	[62543] = true,		-- Blade Lord Ta'yak
	[63191] = true,		-- Garalon
	[62397] = true,		-- Wind Lord Mel'jarak
	[62511] = true,		-- Amber-Shaper Un'sok
	[62837] = true,		-- Grand Empress Shek'zeer
	-- Mogu'Shan Vault
	[59915] = l.stone,	-- Jasper, Stone Guard
	[60043] = l.stone,	-- Jade, Stone Guard
	[60047] = l.stone,	-- Amethyst, Stone Guard
	[60051] = l.stone,	-- Cobalt, Stone Guard
	[60009] = true,		-- Feng the Accursed
	[60143] = true,		-- Gara'jal the Spiritbinder
	[60701] = l.kings,	-- Zian of the Endless Shadow
	[60708] = l.kings,	-- Qiang the Merciless
	[60709] = l.kings,	-- Subetai the Swift
	[60710] = l.kings,	-- Meng the Demented
	[60410] = true,		-- Elegon
	[60396] = l.will,	-- Emperor's Rage
	[60397] = l.will,	-- Emperor's Strength
	[60399] = l.will,	-- Qin-xi
	[60400] = l.will,	-- Jan-xi
	-- World bosses
	[60491] = true,		-- Sha of Anger
	[62346] = true,		-- Galleon
	-------------------------------------------------------------------------------
	-- Pandaria Dungeon
	-------------------------------------------------------------------------------
	-- Gate of the Setting Sun
	[56906] = true,		-- Saboteur Kip'tilak
	[56589] = true,		-- Striker Ga'dok
	[56636] = true,		-- Commander Ri'mok
	[56877] = true,		-- Raigonn
	-- Mogu'Shan Palace
	[61442] = l.trial,	-- Kuai the Brute
	[61444] = l.trial,	-- Ming the Cunning
	[61445] = l.trial,	-- Haiyan the Unstoppable
	[61243] = true,		-- Gekkan
	[61398] = true,		-- Xin the Weaponmaster
	-- Scarlet Halls
	[59303] = true,		-- Houndmaster Braun
	[58632] = true,		-- Armsmaster Harlan
	[59150] = true,		-- Flameweaver Koegler
	-- Scarlet Monastery
	[59789] = true,		-- Thalnos the Soulrender
	[59223] = true,		-- Brother Korloff
	[60040] = l.inq,	-- Commander Durand
	[3977] = l.inq,		-- High Inquisitor Whitemane
	-- Scholomance
	[58633] = true,		-- Instructor Chillheart
	[59184] = true,		-- Jandice Barov
	[59153] = true,		-- Rattlegore
	[58722] = true,		-- Lilian Voss
	[59080] = true,		-- Darkmaster Gandling
	-- Shado-Pan Monastery
	[56747] = true,		-- Gu Cloudstrike
	[56541] = true,		-- Master Snowdrift
	[56719] = true,		-- Sha of Violence
	[56884] = true,		-- Taran Zhu
	-- Siege of Niuzao Temple
	[61567] = true,		-- Vizier Jin'bak
	[61634] = true,		-- Commander Vo'jak
	[61485] = true,		-- General Pa'valak
	[62205] = true,		-- Wing Leader Ner'onok
	-- Stormstout Brewery
	[56637] = true,		-- Ook-Ook
	[56717] = true,		-- Hoptallus
	[59479] = true,		-- Yan-Zhu the Uncasked
	-- Temple of the Jade Serpent
	[56448] = true,		-- Wise Mari
	[59726] = l.lore,	-- Peril
	[59051] = l.lore,	-- Strife
	[56915] = l.lore,	-- Sun
	[56732] = true,		-- Liu Flameheart
	[56439] = true,		-- Sha of Doubt
	-------------------------------------------------------------------------------
	-- Cataclysm Raid
	-------------------------------------------------------------------------------
	-- Dragon Soul
	[55265] = true,		-- Morchok
	[55308] = true,		-- Warlord Zon'ozz
	[55312] = true,		-- Yor'sahj the Unsleeping
	[55689] = true,		-- Hagara the Stormbinder
	[55294] = true,		-- Ultraxion
	[56855] = l.horn,	-- Twilight Assault Drake
	[56854] = l.horn,	-- Twilight Elite Dreadblade
	[56848] = l.horn,	-- Twilight Elite Slayer
	[53879] = true,		-- Spine of Deathwing
	[56167] = l.mad,	-- Arm Tentacle
	[56846] = l.mad,	-- Arm Tentacle
	[56168] = l.mad,	-- Wing Tentacle
	-- Firelands
	[52558] = true,		-- Lord Rhyolith
	[52498] = true,		-- Beth'tilac
	[52530] = true,		-- Alysrazor
	[53691] = true,		-- Shannox
	[53494] = true,		-- Baleroc
	[52571] = true,		-- Majordomo Staghelm
	[52409] = true,		-- Ragnaros
	-- Blackwing Descent
	[41570] = true,		-- Magmaw
	[42166] = l.omno,	-- Arcanotron
	[42178] = l.omno,	-- Magmatron
	[42179] = l.omno,	-- Electron
	[42180] = l.omno,	-- Toxitron
	[41378] = true,		-- Maloriak
	[41442] = true,		-- Atramedes
	[43296] = true,		-- Chimaeron
	[41376] = true,		-- Nefarian
	-- Throne of the Four Winds
	[45870] = l.wind,	-- Anshal
	[45871] = l.wind,	-- Nezir
	[45872] = l.wind,	-- Rohash
	[46753] = true,		-- Al'Akir
	-- The Bastion of Twilight
	[44600] = true,		-- Halfus Wyrmbreaker
	[45992] = l.drag,	-- Valiona
	[45993] = l.drag,	-- Theralion
	[43686] = l.elem,	-- Ignacious
	[43687] = l.elem,	-- Feludius
	[43324] = true,		-- Cho'gall
	[45213] = true,		-- Sinestra
	-- Baradin Hold
	[47120] = true,		-- Argaloth
	[52363] = true,		-- Occu'thar
	[55869] = true,		-- Alizabal
}

lib.BossIDs = BossIDs