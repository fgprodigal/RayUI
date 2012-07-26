------------------------------------------------------------
-- Data.lua
--
-- Abin
-- 2011/2/20
------------------------------------------------------------

local GetSpellInfo = GetSpellInfo
local IsSpellKnown = IsSpellKnown

local _, addon = ...
addon.CLASS = select(2, UnitClass("player"))
addon.RACE = select(2, UnitRace("player"))
addon.MOUNT_DATA = {}
addon.MOUNT_KEYS = { ground = 1, fly = 1, swim = 1, taq = 1 } -- Mount categories

addon.TRAVEL_CLASSES = {
	DRUID = { aquatic = GetSpellInfo(1066), combat = GetSpellInfo(783) },
	SHAMAN = { combat = GetSpellInfo(2645) },
}

function addon:GetMountData(id)
	return addon.MOUNT_DATA[id]
end

function addon:GetMountName(id)
	local data = self:GetMountData(id)
	return data and data.name
end

function addon:IsClassSpellFinal()
	return not ((addon.CLASS == "DRUID" and not IsSpellKnown(40120)) or (addon.RACE == "Worgen" and not IsSpellKnown(87840)))
end

function addon:CheckSpell(id, key)
	if IsSpellKnown(id) then
		local name = self:GetMountName(id)
		if name then
			self[key][id] = name
			return 1
		end
	end
end

function addon:UpdateClassSpells()
	if addon.CLASS == "DRUID" then
		if not self:CheckSpell(40120, "fly") then
			self:CheckSpell(33943, "fly")
		end

		self:CheckSpell(1066, "swim")
	end

	if addon.RACE == "Worgen" then
		self:CheckSpell(87840, "ground")
	end
end

local function RegisterMount(id, key)
	local name, _, icon = GetSpellInfo(id)
	if name then
		addon.MOUNT_DATA[id] = { id = id, key = key, name = name, icon = icon, link = "Hspell:"..id }
	end
end

RegisterMount(10789, "ground")
RegisterMount(10793, "ground")
RegisterMount(10796, "ground")
RegisterMount(10799, "ground")
RegisterMount(10873, "ground")
RegisterMount(10969, "ground")
RegisterMount(13819, "ground")
RegisterMount(15779, "ground")
RegisterMount(16055, "ground")
RegisterMount(16056, "ground")
RegisterMount(16080, "ground")
RegisterMount(16081, "ground")
RegisterMount(16082, "ground")
RegisterMount(16083, "ground")
RegisterMount(16084, "ground")
RegisterMount(17229, "ground")
RegisterMount(17450, "ground")
RegisterMount(17453, "ground")
RegisterMount(17454, "ground")
RegisterMount(17459, "ground")
RegisterMount(17460, "ground")
RegisterMount(17461, "ground")
RegisterMount(17462, "ground")
RegisterMount(17463, "ground")
RegisterMount(17464, "ground")
RegisterMount(17465, "ground")
RegisterMount(17481, "ground")
RegisterMount(18989, "ground")
RegisterMount(18990, "ground")
RegisterMount(18991, "ground")
RegisterMount(18992, "ground")
RegisterMount(22717, "ground")
RegisterMount(22718, "ground")
RegisterMount(22719, "ground")
RegisterMount(22720, "ground")
RegisterMount(22721, "ground")
RegisterMount(22722, "ground")
RegisterMount(22723, "ground")
RegisterMount(22724, "ground")
RegisterMount(23161, "ground")
RegisterMount(23214, "ground")
RegisterMount(23219, "ground")
RegisterMount(23221, "ground")
RegisterMount(23222, "ground")
RegisterMount(23223, "ground")
RegisterMount(23225, "ground")
RegisterMount(23227, "ground")
RegisterMount(23228, "ground")
RegisterMount(23229, "ground")
RegisterMount(23238, "ground")
RegisterMount(23239, "ground")
RegisterMount(23240, "ground")
RegisterMount(23241, "ground")
RegisterMount(23242, "ground")
RegisterMount(23243, "ground")
RegisterMount(23246, "ground")
RegisterMount(23247, "ground")
RegisterMount(23248, "ground")
RegisterMount(23249, "ground")
RegisterMount(23250, "ground")
RegisterMount(23251, "ground")
RegisterMount(23252, "ground")
RegisterMount(23338, "ground")
RegisterMount(23509, "ground")
RegisterMount(23510, "ground")
RegisterMount(24242, "ground")
RegisterMount(24252, "ground")
RegisterMount(25953, "ground")
RegisterMount(26054, "ground")
RegisterMount(26055, "ground")
RegisterMount(26056, "ground")
RegisterMount(26656, "ground")
RegisterMount(30174, "ground")
RegisterMount(33660, "ground")
RegisterMount(34406, "ground")
RegisterMount(34767, "ground")
RegisterMount(34769, "ground")
RegisterMount(34790, "ground")
RegisterMount(34795, "ground")
RegisterMount(34896, "ground")
RegisterMount(34897, "ground")
RegisterMount(34898, "ground")
RegisterMount(34899, "ground")
RegisterMount(35018, "ground")
RegisterMount(35020, "ground")
RegisterMount(35022, "ground")
RegisterMount(35025, "ground")
RegisterMount(35027, "ground")
RegisterMount(35028, "ground")
RegisterMount(35710, "ground")
RegisterMount(35711, "ground")
RegisterMount(35712, "ground")
RegisterMount(35713, "ground")
RegisterMount(35714, "ground")
RegisterMount(36702, "ground")
RegisterMount(39315, "ground")
RegisterMount(39316, "ground")
RegisterMount(39317, "ground")
RegisterMount(39318, "ground")
RegisterMount(39319, "ground")
RegisterMount(41252, "ground")
RegisterMount(42776, "ground")
RegisterMount(42777, "ground")
RegisterMount(43688, "ground")
RegisterMount(43899, "ground")
RegisterMount(43900, "ground")
RegisterMount(458, "ground")
RegisterMount(46628, "ground")
RegisterMount(470, "ground")
RegisterMount(472, "ground")
RegisterMount(48027, "ground")
RegisterMount(48778, "ground")
RegisterMount(49322, "ground")
RegisterMount(49379, "ground")
RegisterMount(50869, "ground")
RegisterMount(51412, "ground")
RegisterMount(54753, "ground")
RegisterMount(55531, "ground")
RegisterMount(5784, "ground")
RegisterMount(580, "ground")
RegisterMount(58983, "ground")
RegisterMount(59785, "ground")
RegisterMount(59788, "ground")
RegisterMount(59791, "ground")
RegisterMount(59793, "ground")
RegisterMount(59797, "ground")
RegisterMount(59799, "ground")
RegisterMount(60114, "ground")
RegisterMount(60116, "ground")
RegisterMount(60118, "ground")
RegisterMount(60119, "ground")
RegisterMount(60424, "ground")
RegisterMount(61425, "ground")
RegisterMount(61447, "ground")
RegisterMount(61465, "ground")
RegisterMount(61467, "ground")
RegisterMount(61469, "ground")
RegisterMount(61470, "ground")
RegisterMount(63232, "ground")
RegisterMount(63635, "ground")
RegisterMount(63636, "ground")
RegisterMount(63637, "ground")
RegisterMount(63638, "ground")
RegisterMount(63639, "ground")
RegisterMount(63640, "ground")
RegisterMount(63641, "ground")
RegisterMount(63642, "ground")
RegisterMount(63643, "ground")
RegisterMount(64656, "ground")
RegisterMount(64657, "ground")
RegisterMount(64658, "ground")
RegisterMount(64659, "ground")
RegisterMount(64977, "ground")
RegisterMount(65637, "ground")
RegisterMount(65638, "ground")
RegisterMount(65639, "ground")
RegisterMount(65640, "ground")
RegisterMount(65641, "ground")
RegisterMount(65642, "ground")
RegisterMount(65643, "ground")
RegisterMount(65644, "ground")
RegisterMount(65645, "ground")
RegisterMount(65646, "ground")
RegisterMount(65917, "ground")
RegisterMount(66090, "ground")
RegisterMount(66091, "ground")
RegisterMount(6648, "ground")
RegisterMount(6653, "ground")
RegisterMount(6654, "ground")
RegisterMount(66846, "ground")
RegisterMount(66847, "ground")
RegisterMount(66906, "ground")
RegisterMount(67466, "ground")
RegisterMount(6777, "ground")
RegisterMount(68056, "ground")
RegisterMount(68057, "ground")
RegisterMount(68187, "ground")
RegisterMount(68188, "ground")
RegisterMount(6898, "ground")
RegisterMount(6899, "ground")
RegisterMount(73313, "ground")
RegisterMount(74918, "ground")
RegisterMount(8394, "ground")
RegisterMount(8395, "ground")
RegisterMount(88748, "ground") -- Brown Riding Camel
RegisterMount(84751, "ground") -- Fossilized Raptor
RegisterMount(89520, "ground") -- Goblin Mini Hotrod
RegisterMount(87090, "ground") -- Goblin Trike
RegisterMount(87091, "ground") -- Goblin Turbo-Trike
RegisterMount(90621, "ground") -- Golden King
RegisterMount(88750, "ground") -- Grey Riding Camel
RegisterMount(93644, "ground") -- Kor'kron Annihilator
RegisterMount(92231, "ground") -- Spectral Steed
RegisterMount(92232, "ground") -- Spectral Wolf
RegisterMount(73629, "ground") -- Summon Exarch's Elekk
RegisterMount(73630, "ground") -- Summon Great Exarch's Elekk
RegisterMount(69826, "ground") -- Summon Great Sunwalker Kodo
RegisterMount(69820, "ground") -- Summon Sunwalker Kodo
RegisterMount(88749, "ground") -- Tan Riding Camel
RegisterMount(92155, "ground") -- Ultramarine Qiraji Battle Tank
RegisterMount(98204, "ground") -- 祖阿曼熊
RegisterMount(103081, "ground") -- 跳舞熊

RegisterMount(71810, "fly")
RegisterMount(72807, "fly")
RegisterMount(72808, "fly")
RegisterMount(74856, "fly")
RegisterMount(88990, "fly") -- Dark Phoenix
RegisterMount(88335, "fly") -- Drake of the East Wind
RegisterMount(88742, "fly") -- Drake of the North Wind
RegisterMount(88744, "fly") -- Drake of the South Wind
RegisterMount(88741, "fly") -- Drake of the West Wind
RegisterMount(93623, "fly") -- Mottled Drake
RegisterMount(88718, "fly") -- Phosphorescent Stone Drake
RegisterMount(93326, "fly") -- Sandstone Drake
RegisterMount(37015, "fly")
RegisterMount(49193, "fly")
RegisterMount(54729, "fly")
RegisterMount(58615, "fly")
RegisterMount(59567, "fly")
RegisterMount(59568, "fly")
RegisterMount(59569, "fly")
RegisterMount(59570, "fly")
RegisterMount(59571, "fly")
RegisterMount(59650, "fly")
RegisterMount(59961, "fly")
RegisterMount(59976, "fly")
RegisterMount(59996, "fly")
RegisterMount(60002, "fly")
RegisterMount(60021, "fly")
RegisterMount(60024, "fly")
RegisterMount(60025, "fly")
RegisterMount(61229, "fly")
RegisterMount(61230, "fly")
RegisterMount(61294, "fly")
RegisterMount(61996, "fly")
RegisterMount(61997, "fly")
RegisterMount(63796, "fly")
RegisterMount(63844, "fly")
RegisterMount(63956, "fly")
RegisterMount(63963, "fly")
RegisterMount(64927, "fly")
RegisterMount(65439, "fly")
RegisterMount(66087, "fly")
RegisterMount(66088, "fly")
RegisterMount(67336, "fly")
RegisterMount(69395, "fly")
RegisterMount(88746, "fly") -- Vitreous Stone Drake
RegisterMount(88331, "fly") -- Volcanic Stone Drake
RegisterMount(39798, "fly")
RegisterMount(39800, "fly")
RegisterMount(39801, "fly")
RegisterMount(39802, "fly")
RegisterMount(39803, "fly")
RegisterMount(40192, "fly")
RegisterMount(32235, "fly")
RegisterMount(32239, "fly")
RegisterMount(32240, "fly")
RegisterMount(32242, "fly")
RegisterMount(32243, "fly")
RegisterMount(32244, "fly")
RegisterMount(32245, "fly")
RegisterMount(32246, "fly")
RegisterMount(32289, "fly")
RegisterMount(32290, "fly")
RegisterMount(32292, "fly")
RegisterMount(32295, "fly")
RegisterMount(32296, "fly")
RegisterMount(32297, "fly")
RegisterMount(41513, "fly")
RegisterMount(41514, "fly")
RegisterMount(41515, "fly")
RegisterMount(41516, "fly")
RegisterMount(41517, "fly")
RegisterMount(41518, "fly")
RegisterMount(43927, "fly")
RegisterMount(44744, "fly")
RegisterMount(46197, "fly")
RegisterMount(46199, "fly")
RegisterMount(97560, "fly")
RegisterMount(97493, "fly")

RegisterMount(75614, "fly") -- 星穹戰馬
RegisterMount(44151, "both") --  Turbo-Charged fly Machine
RegisterMount(44153, "both") --  fly Machine
RegisterMount(48025, "both")
RegisterMount(61309, "both") -- Magnificent fly Carpet
RegisterMount(61451, "both") -- fly Carpet
RegisterMount(71342, "both")
RegisterMount(72286, "both")
RegisterMount(75596, "both") -- Frosty fly Carpet
RegisterMount(75973, "both")
RegisterMount(110051, "both") -- 守護巨龍之心

RegisterMount(26055, "taq") -- Yellow Qiraji Battle Tank
RegisterMount(25953, "taq") -- Blue Qiraji Battle Tank
RegisterMount(26056, "taq") -- Green Qiraji Battle Tank
RegisterMount(26054, "taq") -- Red Qiraji Battle Tank

RegisterMount(64731, "swim") -- Sea Turtle

RegisterMount(75207, "seahorse") -- Abyssal Seahorse

-- Class special spells
RegisterMount(1066, "swim") -- Autatic Form
RegisterMount(33943, "fly") -- Flight Form
RegisterMount(40120, "fly") -- Swift Flight Form
RegisterMount(87840, "ground") -- Running wild
RegisterMount(783, "combat") -- Travel Form
RegisterMount(2645, "combat") -- Ghost Wolf

do
	local key
	for key in pairs(addon.MOUNT_KEYS) do
		addon[key] = {}
	end
end
