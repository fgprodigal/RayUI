local R, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local

local positions = {
    player_buff_icon = { "BOTTOMRIGHT", "RayUF_player", "TOPRIGHT", 0, 80 },	-- "玩家buff&debuff"
    target_buff_icon = { "BOTTOMLEFT", "RayUF_target", "TOPLEFT", 0, 80 },	-- "目标buff&debuff"
    player_proc_icon = { "BOTTOMRIGHT", "RayUF_player", "TOPRIGHT", 0, 33 },	-- "玩家重要buff&debuff"
    target_proc_icon = { "BOTTOMLEFT", "RayUF_target", "TOPLEFT", 0, 33 },	-- "目标重要buff&debuff"
    focus_buff_icon = { "BOTTOMLEFT", "RayUF_focus", "TOPLEFT", 0, 10 },	-- "焦点buff&debuff"
    cd_icon = function() return R:IsDeveloper() and { "TOPLEFT", "RayUIActionBar1", "BOTTOMLEFT", 0, -6 } or { "TOPLEFT", "RayUIActionBar3", "BOTTOMRIGHT", -28, -6 } end,	-- "cd"
    player_special_icon = { "TOPRIGHT", "RayUF_player", "BOTTOMRIGHT", 0, -9 }, -- "玩家特殊buff&debuff"
    pve_player_icon = { "BOTTOM", UIParent, "BOTTOM", -35, 350 }, -- "PVE/PVP玩家buff&debuff"
    pve_target_icon = { "BOTTOM", UIParent, "BOTTOM", 35, 350 }, -- "PVE/PVP目标buff&debuff"
}

R["Watcher"] = {
    ["filters"] = {
        ["DRUID"] = {
            {
                name = "玩家buff&debuff",
                direction = "LEFT",
                setpoint = positions.player_buff_icon,
                size = 28,

                --生命之花
                { spellID = 33763, unitId = "player", caster = "player", filter = "BUFF" },
                --回春術
                { spellID = 774, unitId = "player", caster = "player", filter = "BUFF" },
                --癒合
                { spellID = 8936, unitId = "player", caster = "player", filter = "BUFF" },
                --共生
                { spellID = 100977, unitId = "player", caster = "player", filter = "BUFF" },
            },
            {
                name = "目标buff&debuff",
                direction = "RIGHT",
                setpoint = positions.target_buff_icon,
                size = 28,

                --生命之花
                { spellID = 33763, unitId = "target", caster = "player", filter = "BUFF" },
                --回春術
                { spellID = 774, unitId = "target", caster = "player", filter = "BUFF" },
                --癒合
                { spellID = 8936, unitId = "target", caster = "player", filter = "BUFF" },
                --精靈群襲
                { spellID = 102355, unitId = "target", caster = "all", filter = "DEBUFF" },
                --破甲
                { spellID = 113746, unitId = "target", caster = "all", filter = "DEBUFF" },
            },
            {
                name = "玩家重要buff&debuff",
                direction = "LEFT",
                setpoint = positions.player_proc_icon,
                size = 38,

                --蝕星蔽月(月蝕)
                { spellID = 48518, unitId = "player", caster = "player", filter = "BUFF" },
                --蝕星蔽月(日蝕)
                { spellID = 48517, unitId = "player", caster = "player", filter = "BUFF" },
                --流星
                { spellID = 93400, unitId = "player", caster = "player", filter = "BUFF" },
                --兇蠻咆哮
                { spellID = 52610, unitId = "player", caster = "player", filter = "BUFF" },
                { spellID = 127538, unitId = "player", caster = "player", filter = "BUFF" },
                --求生本能
                { spellID = 61336, unitId = "player", caster = "player", filter = "BUFF" },
                --節能施法
                { spellID = 16870, unitId = "player", caster = "player", filter = "BUFF" },
                --啟動
                { spellID = 29166, unitId = "player", caster = "all", filter = "BUFF" },
                --樹皮術
                { spellID = 22812, unitId = "player", caster = "player", filter = "BUFF" },
                --狂暴
                { spellID = 106951, unitId = "player", caster = "player", filter = "BUFF" },
                --狂暴恢復
                { spellID = 22842, unitId = "player", caster = "player", filter = "BUFF" },
                --猛獸迅捷
                { spellID = 69369, unitId = "player", caster = "player", filter = "BUFF" },
                --塞納留斯之夢
                { spellID = 108381, unitId = "player", caster = "player", filter = "BUFF" },
                { spellID = 108382, unitId = "player", caster = "player", filter = "BUFF" },
                --自然戒備
                { spellID = 124974, unitId = "player", caster = "player", filter = "BUFF" },
                --森林之魂
                { spellID = 114108, unitId = "player", caster = "player", filter = "BUFF" },
                --星殞術
                { spellID = 48505, unitId = "player", caster = "player", filter = "BUFF" },
                --星穹大連線
                { spellID = 112071, unitId = "player", caster = "player", filter = "BUFF" },
                --化身
                { spellID = 117679, unitId = "player", caster = "player", filter = "BUFF" },
                --野性之心
                { spellID = 108294, unitId = "player", caster = "player", filter = "BUFF" },
            },
            {
                name = "目标重要buff&debuff",
                direction = "RIGHT",
                setpoint = positions.target_proc_icon,
                size = 38,

                --休眠
                { spellID = 2637, unitId = "target", caster = "all", filter = "DEBUFF" },
                --糾纏根鬚
                { spellID = 339, unitId = "target", caster = "all", filter = "DEBUFF" },
                --颶風術
                { spellID = 33786, unitId = "target", caster = "all", filter = "DEBUFF" },
                --月火術
                { spellID = 8921, unitId = "target", caster = "player", filter = "DEBUFF" },
                --日炎術
                { spellID = 93402, unitId = "target", caster = "player", filter = "DEBUFF" },
                --蟲群
                { spellID = 5570, unitId = "target", caster = "player", filter = "DEBUFF" },
                --掃擊
                { spellID = 1822, unitId = "target", caster = "player", filter = "DEBUFF" },
                --撕扯
                { spellID = 1079, unitId = "target", caster = "player", filter = "DEBUFF" },
                --割裂
                { spellID = 33745, unitId = "target", caster = "player", filter = "DEBUFF" },
                --血襲
                { spellID = 9007, unitId = "target", caster = "player", filter = "DEBUFF" },
                --痛擊
                { spellID = 106830, unitId = "target", caster = "player", filter = "DEBUFF" },
                --傷殘術
                { spellID = 22570, unitId = "target", caster = "player", filter = "DEBUFF" },
            },
            {
                name = "焦点buff&debuff",
                direction = "UP",
                setpoint = positions.focus_buff_icon,
                size = 24,
                mode = "BAR",
                iconSide = "LEFT",
                barWidth = 170,

                --休眠
                { spellID = 2637, unitId = "focus", caster = "all", filter = "DEBUFF" },
                --糾纏根鬚
                { spellID = 339, unitId = "focus", caster = "all", filter = "DEBUFF" },
                --颶風術
                { spellID = 33786, unitId = "focus", caster = "all", filter = "DEBUFF" },
            },
            {
                name = "CD",
                iconSide = "LEFT",
                size = 28,
                barWidth = 170,
                direction = function() return R:IsDeveloper() and "RIGHT" or "DOWN" end,
                mode = function() return R:IsDeveloper() and "ICON" or "BAR" end,
                setpoint = positions.cd_icon,

                --狂暴
                { spellID = 50334, filter = "CD" },
                --狂暴恢復
                { spellID = 22842, filter = "CD" },
                --狂怒
                { spellID = 5229, filter = "CD" },
                --啟動
                { spellID = 29166, filter = "CD" },
                --複生
                { spellID = 20484, filter = "CD" },
                --樹皮術
                { spellID = 22812, filter = "CD" },
                --寧靜
                { spellID = 740, filter = "CD" },
                --化身
                { spellID = 106731, filter = "CD" },
                --自然戒備
                { spellID = 124974, filter = "CD" },
                --星穹大連線
                { spellID = 112071, filter = "CD" },

                -- 物品
				-- 手套
				{slotID = 10, filter = "CD" },
				-- 腰带
				{slotID = 6, filter = "CD" },
				-- 披风
				{slotID = 15, filter = "CD" },
				-- 饰品
				{slotID = 13, filter = "CD" },
				{slotID = 14, filter = "CD" },
            },
        },
        ["HUNTER"] = {
            {
                name = "玩家buff&debuff",
                direction = "LEFT",
                setpoint = positions.player_buff_icon,
                size = 28,

                --狙擊訓練
                { spellID = 64420, unitId = "player", caster = "player", filter = "BUFF" },
                --射擊!
                { spellID = 82926, unitId = "player", caster = "player", filter = "BUFF" },
            },
            {
                name = "目标buff&debuff",
                direction = "RIGHT",
                setpoint = positions.target_buff_icon,
                size = 28,

                --獵人印記
                { spellID = 1130, unitId = "target", caster = "all", filter = "DEBUFF" },
            },
            {
                name = "玩家重要buff&debuff",
                direction = "LEFT",
                setpoint = positions.player_proc_icon,
                size = 38,

                --誤導
                { spellID = 34477, unitId = "player", caster = "player", filter = "BUFF" },
                { spellID = 35079, unitId = "player", caster = "player", filter = "BUFF" },
                --蓄勢待發
                { spellID = 56453, unitId = "player", caster = "player", filter = "BUFF" },
                --快速射擊
                { spellID = 6150, unitId = "player", caster = "player", filter = "BUFF" },
                --戰術大師
                { spellID = 34837, unitId = "player", caster = "player", filter = "BUFF" },
                --強化穩固射擊
                { spellID = 53224, unitId = "player", caster = "player", filter = "BUFF" },
                --急速射擊
                { spellID = 3045, unitId = "player", caster = "player", filter = "BUFF" },
                --治療寵物
                { spellID = 136, unitId = "pet", caster = "player", filter = "BUFF" },
                --強化穩固射擊
                { spellID = 53220, unitId = "player", caster = "player", filter = "BUFF" },
                --連環火網
                { spellID = 82921, unitId = "player", caster = "player", filter = "BUFF" },
                --準備、就緒、瞄準……
                { spellID = 82925, unitId = "player", caster = "player", filter = "BUFF" },
                --狂亂效果
                { spellID = 19615, unitId = "pet", caster = "pet", filter = "BUFF" },
                --獸心
                { spellID = 34471, unitId = "player", caster = "player", filter = "BUFF" },
                --獵殺快感
                { spellID = 34720, unitId = "player", caster = "player", filter = "BUFF" },
                --4T13
                { spellID = 105919, unitId = "player", caster = "player", filter = "BUFF" },
                --擊殺命令
                { spellID = 34026, filter = "CD" },
                --爆裂射擊
                { spellID = 53301, filter = "CD" },
            },
            {
                name = "目标重要buff&debuff",
                direction = "RIGHT",
                setpoint = positions.target_proc_icon,
                size = 38,

                --翼龍釘刺
                { spellID = 19386, unitId = "target", caster = "all", filter = "DEBUFF" },
                --沉默射擊
                { spellID = 34490, unitId = "target", caster = "all", filter = "DEBUFF" },
                --毒蛇釘刺
                { spellID = 118253, unitId = "target", caster = "player", filter = "DEBUFF" },
                --寡婦毒液
                { spellID = 82654, unitId = "target", caster = "all", filter = "DEBUFF" },
                --黑蝕箭
                { spellID = 3674, unitId = "target", caster = "player", filter = "DEBUFF" },
                --爆裂射擊
                { spellID = 53301, unitId = "target", caster = "player", filter = "DEBUFF" },
            },
            {
                name = "焦点buff&debuff",
                direction = "UP",
                setpoint = positions.focus_buff_icon,
                size = 24,
                mode = "BAR",
                iconSide = "LEFT",
                barWidth = 170,

                --翼龍釘刺
                { spellID = 19386, unitId = "focus", caster = "all", filter = "DEBUFF" },
                --沉默射擊
                { spellID = 34490, unitId = "focus", caster = "all", filter = "DEBUFF" },
            },
            {
                name = "CD",
                iconSide = "LEFT",
                size = 28,
                barWidth = 170,
                direction = function() return R:IsDeveloper() and "RIGHT" or "DOWN" end,
                mode = function() return R:IsDeveloper() and "ICON" or "BAR" end,
                setpoint = positions.cd_icon,

                --急速射擊
                { spellID = 3045, filter = "CD" },
                --準備就緒
                { spellID = 23989, filter = "CD" },
                --奧術之流
                { spellID = 25046, filter = "CD" },
                --誤導
                { spellID = 34477, filter = "CD" },
                --偽裝
                { spellID = 51753, filter = "CD" },
                --爆炸陷阱
                { spellID = 13813, filter = "CD" },
                --冰凍陷阱
                { spellID = 1499, filter = "CD" },
                --毒蛇陷阱
                { spellID = 34600, filter = "CD" },
                --翼龍釘刺
                { spellID = 19386, filter = "CD" },
                --主人的召喚
                { spellID = 53271, filter = "CD" },
                --假死
                { spellID = 5384, filter = "CD" },
                --沉默射擊
                { spellID = 34490, filter = "CD" },
                --兇暴野獸
                { spellID = 120679, filter = "CD" },
                --黑鴉獵殺
                { spellID = 131894, filter = "CD" },
                --山貓衝刺
                { spellID = 120697, filter = "CD" },

                -- 物品
				-- 手套
				{slotID = 10, filter = "CD" },
				-- 腰带
				{slotID = 6, filter = "CD" },
				-- 披风
				{slotID = 15, filter = "CD" },
				-- 饰品
				{slotID = 13, filter = "CD" },
				{slotID = 14, filter = "CD" },
            },
        },
        ["MAGE"] = {
            {
                name = "玩家重要buff&debuff",
                direction = "LEFT",
                setpoint = positions.player_proc_icon,
                size = 38,

				--冰霜之指
				{ spellID = 44544, unitId = "player", caster = "player", filter = "BUFF" },
				--焦炎之痕
				{ spellID = 48108, unitId = "player", caster = "player", filter = "BUFF" },
				--飛彈彈幕
				{ spellID = 79683, unitId = "player", caster = "player", filter = "BUFF" },
				--秘法強化
				{ spellID = 12042, unitId = "player", caster = "player", filter = "BUFF" },
				--秘法衝擊
				{ spellID = 36032, unitId = "player", caster = "player", filter = "DEBUFF" },
				--寒冰護體
				{ spellID = 11426, unitId = "player", caster = "player", filter = "BUFF" },
				--腦部凍結
				{ spellID = 57761, unitId = "player", caster = "player", filter = "BUFF" },
				--升溫
				{ spellID = 48107, unitId = "player", caster = "player", filter = "BUFF" },
				--咒法結界
				{ spellID = 1463, unitId = "player", caster = "player", filter = "BUFF" },
				--塑能師之能
				{ spellID = 116257, unitId = "player", caster = "player", filter = "BUFF" },
				--力之符文
				{ spellID = 116014, unitId = "player", caster = "player", filter = "BUFF" },
				--咒法轉移
				{ spellID = 116267, unitId = "player", caster = "player", filter = "BUFF" },
				--冰寒脈動
				{ spellID = 12472, unitId = "player", caster = "player", filter = "BUFF" },
				--氣定神閒
				{ spellID = 12043, unitId = "player", caster = "player", filter = "BUFF" },
				--時光倒轉
				{ spellID = 110909, unitId = "player", caster = "player", filter = "BUFF" },
				-- 燒灼
				{ spellID = 87023, unitId = "player", caster = "player", filter = "DEBUFF" },
                --冰霜炸彈
                { spellID = 112948, filter = "CD" },

            },
            {
                name = "目标重要buff&debuff",
                direction = "RIGHT",
                setpoint = positions.target_proc_icon,
                size = 38,

                --變形術
                { spellID = 118, unitId = "target", caster = "all", filter = "DEBUFF" },
                --龍之吐息
                { spellID = 31661, unitId = "target", caster = "all", filter = "DEBUFF" },
                --衝擊波
                { spellID = 11113, unitId = "target", caster = "all", filter = "DEBUFF" },
                --減速術
                { spellID = 31589, unitId = "target", caster = "player", filter = "DEBUFF" },
                --燃火
                { spellID = 83853, unitId = "target", caster = "player", filter = "DEBUFF" },
                --點燃
                { spellID = 12654, unitId = "target", caster = "player", filter = "DEBUFF" },
                --活體爆彈
                { spellID = 44457, unitId = "target", caster = "player", filter = "DEBUFF" },
                --炎爆術
                { spellID = 11366, unitId = "target", caster = "player", filter = "DEBUFF" },
                --極度冰凍
                { spellID = 44572, unitId = "target", caster = "all", filter = "DEBUFF" },
                --冰霜爆彈
                { spellID = 112948, unitId = "target", caster = "player", filter = "DEBUFF" },
                --虛空暴雨
                { spellID = 114923, unitId = "target", caster = "player", filter = "DEBUFF" },
                --寒冰箭
                { spellID = 16, unitId = "target", caster = "player", filter = "DEBUFF" },
            },
            {
                name = "焦点buff&debuff",
                direction = "UP",
                setpoint = positions.focus_buff_icon,
                size = 24,
                mode = "BAR",
                iconSide = "LEFT",
                barWidth = 170,

                --變形術
                { spellID = 118, unitId = "focus", caster = "all", filter = "DEBUFF" },
                --活體爆彈
                { spellID = 44457, unitId = "focus", caster = "player", filter = "DEBUFF" },
            },
            {
                name = "CD",
                iconSide = "LEFT",
                size = 28,
                barWidth = 170,
                direction = function() return R:IsDeveloper() and "RIGHT" or "DOWN" end,
                mode = function() return R:IsDeveloper() and "ICON" or "BAR" end,
                setpoint = positions.cd_icon,

                --镜像术
                { spellID = 55342, filter = "CD" },
                --隐形术
                { spellID = 66, filter = "CD" },
                --燃火
                { spellID = 11129, filter = "CD" },
                --唤醒
                { spellID = 12051, filter = "CD" },
                --秘法強化
                { spellID = 12042, filter = "CD" },
                --急速冷卻
                { spellID = 11958, filter = "CD" },
                --極度冰凍
                { spellID = 44572, filter = "CD" },
                --冰寒脈動
                { spellID = 12472, filter = "CD" },
                --寒冰屏障
                { spellID = 45438, filter = "CD" },
                --冰霜之球
                { spellID = 84714, filter = "CD" },

                -- 物品
				-- 手套
				{slotID = 10, filter = "CD" },
				-- 腰带
				{slotID = 6, filter = "CD" },
				-- 披风
				{slotID = 15, filter = "CD" },
				-- 饰品
				{slotID = 13, filter = "CD" },
				{slotID = 14, filter = "CD" },
            },
        },
        ["WARRIOR"] = {
			{
                name = "玩家buff&debuff",
                direction = "LEFT",
                setpoint = positions.player_buff_icon,
                size = 28,

                --勝利
                { spellID = 32216, unitId = "player", caster = "player", filter = "BUFF" },
            },
            {
                name = "玩家重要buff&debuff",
                direction = "LEFT",
                setpoint = positions.player_proc_icon,
                size = 38,

                --驟亡
                { spellID = 52437, unitId = "player", caster = "player", filter = "BUFF" },
                --沉著殺機
                { spellID = 85730, unitId = "player", caster = "player", filter = "BUFF" },
                --狂暴之怒
                { spellID = 18499, unitId = "player", caster = "player", filter = "BUFF" },
                --魯莽
                { spellID = 1719, unitId = "player", caster = "player", filter = "BUFF" },
                --熱血沸騰
                { spellID = 46916, unitId = "player", caster = "player", filter = "BUFF" },
                --劍盾合璧
                { spellID = 50227, unitId = "player", caster = "player", filter = "BUFF" },
                --蓄血
                { spellID = 64568, unitId = "player", caster = "player", filter = "BUFF" },
                --法術反射
                { spellID = 23920, unitId = "player", caster = "player", filter = "BUFF" },
                --勝利衝擊
                { spellID = 34428, unitId = "player", caster = "player", filter = "BUFF" },
                --盾牌格擋
                { spellID = 132404, unitId = "player", caster = "player", filter = "BUFF" },
                --盾墻
                { spellID = 871, unitId = "player", caster = "player", filter = "BUFF" },
                --狂怒恢復
                { spellID = 55694, unitId = "player", caster = "player", filter = "BUFF" },
                --橫掃攻擊
                { spellID = 12328, unitId = "player", caster = "player", filter = "BUFF" },
                --绞肉机
                { spellID = 85739, unitId = "player", caster = "player", filter = "BUFF" },
                --血腥體驗
                { spellID = 125831, unitId = "player", caster = "player", filter = "BUFF" },
                --狂怒之擊!
                { spellID = 131116, unitId = "player", caster = "player", filter = "BUFF" },
                --浴血
                { spellID = 12292, unitId = "player", caster = "player", filter = "BUFF" },
            },
            {
                name = "目标重要buff&debuff",
                direction = "RIGHT",
                setpoint = positions.target_proc_icon,
                size = 38,

                --震盪波
                { spellID = 46968, unitId = "target", caster = "all", filter = "DEBUFF" },
                --斷筋
                { spellID = 1715, unitId = "target", caster = "all", filter = "DEBUFF" },
                --雷霆一擊
                { spellID = 115798, unitId = "target", caster = "player", filter = "DEBUFF" },
                --挫志怒吼
                { spellID = 1160, unitId = "target", caster = "player", filter = "DEBUFF" },
                --破膽怒吼
                { spellID = 5246, unitId = "target", caster = "player", filter = "DEBUFF" },
                --破甲
                { spellID = 113746, unitId = "target", caster = "all", filter = "DEBUFF" },
                --巨人打击
                { spellID = 86346, unitId = "target", caster = "player", filter = "DEBUFF" },
                --感染之傷（德魯伊）
                { spellID = 48484, unitId = "target", caster = "all", filter = "DEBUFF" },
                --挫志咆哮（德魯伊）
                { spellID = 99, unitId = "target", caster = "all", filter = "DEBUFF" },
            },
            {
                name = "CD",
                iconSide = "LEFT",
                size = 28,
                barWidth = 170,
                direction = function() return R:IsDeveloper() and "RIGHT" or "DOWN" end,
                mode = function() return R:IsDeveloper() and "ICON" or "BAR" end,
                setpoint = positions.cd_icon,

                --鲁莽
                { spellID = 1719, filter = "CD" },
                --颅骨战旗
                { spellID = 114207, filter = "CD" },
                --浴血奋战
                { spellID = 12292, filter = "CD" },
                --致命平静
                { spellID = 85730, filter = "CD" },
                --盾墙
                { spellID = 871, filter = "CD" },
                --集结呐喊
                { spellID = 97462, filter = "CD" },
                --破胆怒吼
                { spellID = 5246, filter = "CD" },
                --天神下凡
                { spellID = 107574, filter = "CD" },

                -- 物品
                -- 手套
                { slotID = 10, filter = "CD" },
                -- 腰带
                { slotID = 6, filter = "CD" },
                -- 披风
                { slotID = 15, filter = "CD" },
                -- 饰品
                { slotID = 13, filter = "CD" },
                { slotID = 14, filter = "CD" },
            },
        },
        ["SHAMAN"] = {
            {
                name = "玩家buff&debuff",
                direction = "LEFT",
                setpoint = positions.player_buff_icon,
                size = 28,

                --Earth Shield / Erdschild
                { spellID = 974, unitId = "player", caster = "player", filter = "BUFF" },
                --Riptide / Springflut
                { spellID = 61295, unitId = "player", caster = "player", filter = "BUFF" },
                --Lightning Shield / Blitzschlagschild
                { spellID = 324, unitId = "player", caster = "player", filter = "BUFF" },
                --Water Shield / Wasserschild
                { spellID = 52127, unitId = "player", caster = "player", filter = "BUFF" },

            },
            {
                name = "目标buff&debuff",
                direction = "RIGHT",
                setpoint = positions.target_buff_icon,
                size = 28,

                --Earth Shield / Erdschild
                { spellID = 974, unitId = "target", caster = "player", filter = "BUFF" },
                --Riptide / Springflut
                { spellID = 61295, unitId = "target", caster = "player", filter = "BUFF" },
                --冰凍之力
                { spellID = 63685, unitId = "target", caster = "player", filter = "DEBUFF" },
                --狂怒釋放
                { spellID = 118473, unitId = "target", caster = "player", filter = "BUFF" },

            },
            {
                name = "玩家重要buff&debuff",
                direction = "LEFT",
                setpoint = positions.player_proc_icon,
                size = 38,

                --Maelstorm Weapon / Waffe des Mahlstroms
                { spellID = 53817, unitId = "player", caster = "player", filter = "BUFF" },
                --Shamanistic Rage / Schamanistische Wut
                { spellID = 30823, unitId = "player", caster = "player", filter = "BUFF" },
                --Clearcasting / Freizaubern
                { spellID = 16246, unitId = "player", caster = "player", filter = "BUFF" },
                --靈行者之賜
                { spellID = 79206, unitId = "player", caster = "player", filter = "BUFF" },
                --釋放生命武器
                { spellID = 73685, unitId = "player", caster = "player", filter = "BUFF" },
                --治療之潮
                { spellID = 53390, unitId = "player", caster = "player", filter = "BUFF" },
                --卓越術
                { spellID = 114052, unitId = "player", caster = "player", filter = "BUFF" },
                --星界轉移
                { spellID = 108271, unitId = "player", caster = "player", filter = "BUFF" },

            },
            {
                name = "目标重要buff&debuff",
                direction = "RIGHT",
                setpoint = positions.target_proc_icon,
                size = 38,

                --Hex / Verhexen
                { spellID = 51514, unitId = "target", caster = "all", filter = "DEBUFF" },
                --Bind Elemental / Elementar binden
                { spellID = 76780, unitId = "target", caster = "all", filter = "DEBUFF" },
                --Storm Strike / Sturmschlag
                { spellID = 17364, unitId = "target", caster = "player", filter = "DEBUFF" },
                --Earth Shock / Erdschock
                { spellID = 8042, unitId = "target", caster = "player", filter = "DEBUFF" },
                --Frost Shock / Frostschock
                { spellID = 8056, unitId = "target", caster = "player", filter = "DEBUFF" },
                --Flame Shock / Flammenschock
                { spellID = 8050, unitId = "target", caster = "player", filter = "DEBUFF" },
                --先祖活力
                { spellID = 105284, unitId = "target", caster = "player", filter = "BUFF" },

            },
            {
                name = "焦点buff&debuff",
                direction = "UP",
                setpoint = positions.focus_buff_icon,
                size = 24,
                mode = "BAR",
                iconSide = "LEFT",
                barWidth = 170,

                --Hex / Verhexen
                { spellID = 51514, unitId = "focus", caster = "all", filter = "DEBUFF" },
                --Bind Elemental / Elementar binden
                { spellID = 76780, unitId = "focus", caster = "all", filter = "DEBUFF" },

            },
			{
                name = "CD",
                iconSide = "LEFT",
                size = 28,
                barWidth = 170,
                direction = function() return R:IsDeveloper() and "RIGHT" or "DOWN" end,
                mode = function() return R:IsDeveloper() and "ICON" or "BAR" end,
                setpoint = positions.cd_icon,

                --火元素圖騰
                { spellID = 2894, filter = "CD" },
                --土元素圖騰
                { spellID = 2062, filter = "CD" },

                -- 物品
				-- 手套
				{slotID = 10, filter = "CD" },
				-- 腰带
				{slotID = 6, filter = "CD" },
				-- 披风
				{slotID = 15, filter = "CD" },
				-- 饰品
				{slotID = 13, filter = "CD" },
				{slotID = 14, filter = "CD" },
            },
        },
        ["PALADIN"] = {
            {
                name = "玩家buff&debuff",
                direction = "LEFT",
                setpoint = positions.player_buff_icon,
                size = 28,

                --聖光信標
                { spellID = 53563, unitId = "player", caster = "player", filter = "BUFF" },
                --純潔審判
                { spellID = 53657, unitId = "player", caster = "player", filter = "BUFF" },
				--永恆之火
				{ spellID = 114163, unitId = "player", caster = "player", filter = "BUFF" },
				--無私治療者
				{ spellID = 114250, unitId = "player", caster = "player", filter = "BUFF" },
            },
            {
                name = "目标buff&debuff",
                direction = "RIGHT",
                setpoint = positions.target_buff_icon,
                size = 28,

                --聖光信標
                { spellID = 53563, unitId = "target", caster = "player", filter = "BUFF" },
                --纯净之手
                { spellID = 114039, unitId = "target", caster = "player", filter = "BUFF" },
                --永恒之火
                { spellID = 114163, unitId = "target", caster = "player", filter = "BUFF" },
                --处决审判
                { spellID = 114157, unitId = "target", caster = "player", filter = "BUFF" },
                --圣洁护盾
                { spellID = 20925, unitId = "target", caster = "player", filter = "BUFF" },
				--譴責
				{ spellID = 31803, unitId = "target", caster = "player", filter = "DEBUFF" },
				--弱化攻擊
				{ spellID = 115798, unitId = "target", caster = "all", filter = "DEBUFF" },
            },
            {
                name = "玩家重要buff&debuff",
                direction = "LEFT",
                setpoint = positions.player_proc_icon,
                size = 38,

                --神聖之盾
                { spellID = 20925, unitId = "player", caster = "player", filter = "BUFF" },
                --神圣意志
                { spellID = 90174, unitId = "player", caster = "player", filter = "BUFF" },
                --破晓
                { spellID = 88819, unitId = "player", caster = "player", filter = "BUFF" },
                --神性祈求
                { spellID = 54428, unitId = "player", caster = "player", filter = "BUFF" },
                --神恩術
                { spellID = 31842, unitId = "player", caster = "player", filter = "BUFF" },
                --神圣复仇者
                { spellID = 105809, unitId = "player", caster = "player", filter = "BUFF" },
                --远古能量
                { spellID = 86700, unitId = "player", caster = "player", filter = "BUFF" },
                --異端審問
                { spellID = 84963, unitId = "player", caster = "player", filter = "BUFF" },
                --破曉之光
                { spellID = 88819, unitId = "player", caster = "player", filter = "BUFF" },
                --聖光灌注
                { spellID = 54149, unitId = "player", caster = "player", filter = "BUFF" },
                --聖佑術
                { spellID = 498, unitId = "player", caster = "player", filter = "BUFF" },
                --戰爭藝術
                { spellID = 59578, unitId = "player", caster = "player", filter = "BUFF" },
                --復仇之怒
                { spellID = 31884, unitId = "player", caster = "player", filter = "BUFF" },
                --精通光環
                { spellID = 31821, unitId = "player", caster = "player", filter = "BUFF" },
				--圣盾術
				{ spellID = 642, unitId = "player", caster = "player", filter = "BUFF" },
				--遠古諸王守護者
				{ spellID = 86698, unitId = "player", caster = "player", filter = "BUFF" },
				--忠誠防衛者
				{ spellID = 31850, unitId = "player", caster = "player", filter = "BUFF" },
				--光速
				{ spellID = 85499, unitId = "player", caster = "player", filter = "BUFF" },
				--公正之盾
				{ spellID = 132403, unitId = "player", caster = "player", filter = "BUFF" },
				--榮耀壁壘
				{ spellID = 114637, unitId = "player", caster = "player", filter = "BUFF" },
				--大十字軍
				{ spellID = 85416, unitId = "player", caster = "player", filter = "BUFF" },
				--遠古諸王之光
				{ spellID = 86678, unitId = "player", caster = "all", filter = "BUFF" },
				--道高一丈
				{ spellID = 87173, unitId = "player", caster = "player", filter = "BUFF" },
            },
            {
                name = "目标重要buff&debuff",
                direction = "RIGHT",
                setpoint = positions.target_proc_icon,
                size = 38,

                --制裁之錘
                { spellID = 853, unitId = "target", caster = "all", filter = "DEBUFF" },
                --制裁之拳
                { spellID = 105593, unitId = "target", caster = "all", filter = "DEBUFF" },
				--自律
				{ spellID = 25771, unitId = "target", caster = "all", filter = "DEBUFF" },
				--罪之重擔
				{ spellID = 110300, unitId = "target", caster = "player", filter = "DEBUFF" },
				--公正聖印
				{ spellID = 20170, unitId = "target", caster = "player", filter = "DEBUFF" },
				--問罪
				{ spellID = 2812, unitId = "target", caster = "player", filter = "DEBUFF" },
            },
            {
                name = "焦点buff&debuff",
                direction = "UP",
                setpoint = positions.focus_buff_icon,
                size = 24,
                mode = "BAR",
                iconSide = "LEFT",
                barWidth = 170,

                --制裁之錘
                { spellID = 853, unitId = "focus", caster = "all", filter = "DEBUFF" },
                --制裁之拳
                { spellID = 105593, unitId = "focus", caster = "all", filter = "DEBUFF" },
            },
            {
                name = "CD",
                iconSide = "LEFT",
                size = 28,
                barWidth = 170,
                direction = function() return R:IsDeveloper() and "RIGHT" or "DOWN" end,
                mode = function() return R:IsDeveloper() and "ICON" or "BAR" end,
                setpoint = positions.cd_icon,

                --精通光環
                { spellID = 31821, filter = "CD" },
                --神性祈求
                { spellID = 54428, filter = "CD" },
                --聖佑術
                { spellID = 498, filter = "CD" },

				-- 物品
				-- 手套
				{slotID = 10, filter = "CD" },
				-- 腰带
				{slotID = 6, filter = "CD" },
				-- 披风
				{slotID = 15, filter = "CD" },
				-- 饰品
				{slotID = 13, filter = "CD" },
				{slotID = 14, filter = "CD" },
            },
        },
        ["PRIEST"] = {
            {
                name = "玩家buff&debuff",
                direction = "LEFT",
                setpoint = positions.player_buff_icon,
                size = 28,

                --真言術：盾
                { spellID = 17, unitId = "player", caster = "all", filter = "BUFF" },
                --虚弱靈魂
                { spellID = 6788, unitId = "player", caster = "all", filter = "DEBUFF" },
                --恢复
                { spellID = 139, unitId = "player", caster = "player", filter = "BUFF" },
                --漸隱術
                { spellID = 586, unitId = "player", caster = "player", filter = "BUFF" },
                --防護恐懼結界
                { spellID = 6346, unitId = "player", caster = "all", filter = "BUFF" },
                --心靈意志
                { spellID = 73413, unitId = "player", caster = "player", filter = "BUFF" },
                --大天使
                { spellID = 81700, unitId = "player", caster = "player", filter = "BUFF" },
                --黑天使
                { spellID = 87153, unitId = "player", caster = "player", filter = "BUFF" },
                --預支時間
                { spellID = 59889, unitId = "player", caster = "player", filter = "BUFF" },
            },
            {
                name = "目标buff&debuff",
                direction = "RIGHT",
                setpoint = positions.target_buff_icon,
                size = 28,

                --真言术：盾
                { spellID = 17, unitId = "target", caster = "all", filter = "BUFF" },
                --虚弱灵魂
                { spellID = 6788, unitId = "target", caster = "all", filter = "DEBUFF" },
                --恢复
                { spellID = 139, unitId = "target", caster = "player", filter = "BUFF" },
                --愈合祷言
                { spellID = 41635, unitId = "target", caster = "player", filter = "BUFF" },
                --守护之魂
                { spellID = 47788, unitId = "target", caster = "player", filter = "BUFF" },
                --痛苦镇压
                { spellID = 33206, unitId = "target", caster = "player", filter = "BUFF" },
                --恩典
                { spellID = 77613, unitId = "target", caster = "player", filter = "BUFF" },
            },
            {
                name = "玩家重要buff&debuff",
                direction = "LEFT",
                setpoint = positions.player_proc_icon,
                size = 38,

                --機緣回復
                { spellID = 63735, unitId = "player", caster = "player", filter = "BUFF" },
                --暗影寶珠
                { spellID = 77487, unitId = "player", caster = "player", filter = "BUFF" },
                --佈道
                { spellID = 81661, unitId = "player", caster = "player", filter = "BUFF" },
                --影散
                { spellID = 47585, unitId = "player", caster = "player", filter = "BUFF" },
                --真言術：壁
                { spellID = 81782 , unitId = "player", caster = "all", filter = "BUFF" },
                --2T12效果
                { spellID = 99132,  unitId = "player", caster = "player", filter = "BUFF" },
                --神聖洞察
                { spellID = 123266,  unitId = "player", caster = "player", filter = "BUFF" },
                --心靈鑚刺雕文
                { spellID = 81292,  unitId = "player", caster = "player", filter = "BUFF" },
                --命運無常
                { spellID = 123254,  unitId = "player", caster = "player", filter = "BUFF" },
                --天使之壁
                { spellID = 114214,  unitId = "player", caster = "player", filter = "BUFF" },
                --精神護罩
                { spellID = 109964,  unitId = "player", caster = "player", filter = "BUFF" },
            },
            {
                name = "目标重要buff&debuff",
                direction = "RIGHT",
                setpoint = positions.target_proc_icon,
                size = 38,

                --束縛不死生物
                { spellID = 9484, unitId = "target", caster = "all", filter = "DEBUFF" },
                --心靈尖嘯
                { spellID = 8122, unitId = "target", caster = "all", filter = "DEBUFF" },
                --暗言術:痛
                { spellID = 589, unitId = "target", caster = "player", filter = "DEBUFF" },
                --噬靈瘟疫
                { spellID = 2944, unitId = "target", caster = "player", filter = "DEBUFF" },
                --吸血之觸
                { spellID = 34914, unitId = "target", caster = "player", filter = "DEBUFF" },
                --心靈恐慌
                { spellID = 64044, unitId = "target", caster = "all", filter = "DEBUFF" },
                --心靈恐慌（繳械效果）
                { spellID = 64058, unitId = "target", caster = "all", filter = "DEBUFF" },
                --精神控制
                { spellID = 605, unitId = "target", caster = "all", filter = "DEBUFF" },
                --沉默
                { spellID = 15487, unitId = "target", caster = "all", filter = "DEBUFF" },
            },
            {
                name = "焦点buff&debuff",
                direction = "UP",
                setpoint = positions.focus_buff_icon,
                size = 24,
                mode = "BAR",
                iconSide = "LEFT",
                barWidth = 170,

                --束縛不死生物
                { spellID = 9484, unitId = "focus", caster = "all", filter = "DEBUFF" },
                --心靈尖嘯
                { spellID = 8122, unitId = "focus", caster = "all", filter = "DEBUFF" },
            },
            {
                name = "CD",
                iconSide = "LEFT",
                size = 28,
                barWidth = 170,
                direction = function() return R:IsDeveloper() and "RIGHT" or "DOWN" end,
                mode = function() return R:IsDeveloper() and "ICON" or "BAR" end,
                setpoint = positions.cd_icon,

                --暗影魔
                { spellID = 34433, filter = "CD" },
                --真言術:壁
                { spellID = 62618, filter = "CD" },
                --影散
                { spellID = 47585, filter = "CD" },
                --絕望禱言
                { spellID = 19236, filter = "CD" },
                --大天使
                { spellID = 81700, filter = "CD" },

                -- 物品
				-- 手套
				{slotID = 10, filter = "CD" },
				-- 腰带
				{slotID = 6, filter = "CD" },
				-- 披风
				{slotID = 15, filter = "CD" },
				-- 饰品
				{slotID = 13, filter = "CD" },
				{slotID = 14, filter = "CD" },
            },
        },
        ["WARLOCK"]={
            {
                name = "目标buff&debuff",
                direction = "RIGHT",
                setpoint = positions.target_buff_icon,
                size = 28,

                --元素詛咒
                { spellID = 1490, unitId = "target", caster = "all", filter = "DEBUFF" },
                { spellID = 104225, unitId = "target", caster = "all", filter = "DEBUFF" },
            },
            {
                name = "目标重要buff&debuff",
                setpoint = positions.target_proc_icon,
                direction = "RIGHT",
                mode = "ICON",
                size = 38,

                --恐懼術
                { spellID = 5782, unitId = "target", caster = "player", filter = "DEBUFF" },
                --放逐術
                { spellID = 710, unitId = "target", caster = "player", filter = "DEBUFF" },
                --疲勞詛咒
                { spellID = 18223, unitId = "target", caster = "player", filter = "DEBUFF" },
                --腐蝕術
                { spellID = 172, unitId = "target", caster = "player", filter = "DEBUFF" },
                --獻祭
                { spellID = 348, unitId = "target", caster = "player", filter = "DEBUFF" },
                --痛苦災厄
                { spellID = 980, unitId = "target", caster = "player", filter = "DEBUFF" },
                --末日災厄
                { spellID = 603, unitId = "target", caster = "player", filter = "DEBUFF" },
                --痛苦動盪
                { spellID = 30108, unitId = "target", caster = "player", filter = "DEBUFF" },
                --蝕魂術
                { spellID = 48181, unitId = "target", caster = "player", filter = "DEBUFF" },
                --腐蝕種子
                { spellID = 27243, unitId = "target", caster = "player", filter = "DEBUFF" },
                --恐懼嚎叫
                { spellID = 5484, unitId = "target", caster = "player", filter = "DEBUFF" },
                --死亡纏繞
                { spellID = 6789, unitId = "target", caster = "player", filter = "DEBUFF" },
                --奴役惡魔
                { spellID = 1098, unitId = "pet", caster = "player", filter = "DEBUFF" },
                --惡魔跳躍
                { spellID = 54785, unitId = "target", caster = "player", filter = "DEBUFF" },
                --獻祭
                { spellID = 108686, unitId = "target", caster = "player", filter = "DEBUFF" },
            },
            {
                name = "玩家重要buff&debuff",
                setpoint = positions.player_proc_icon,
                direction = "LEFT",
                size = 38,

                --反衝
                { spellID = 34936, unitId = "player", caster = "player", filter = "BUFF" },
                --夜暮
                { spellID = 17941, unitId = "player", caster = "player", filter = "BUFF" },
                --靈魂炙燃
                { spellID = 74434, unitId = "player", caster = "player", filter = "BUFF" },
                --熔火之心
                { spellID = 122351, unitId = "player", caster = "player", filter = "BUFF" },
                --爆燃
                { spellID = 117828, unitId = "player", caster = "player", filter = "BUFF" },
            },
			 {
                name = "CD",
                iconSide = "LEFT",
                size = 28,
                barWidth = 170,
                direction = function() return R:IsDeveloper() and "RIGHT" or "DOWN" end,
                mode = function() return R:IsDeveloper() and "ICON" or "BAR" end,
                setpoint = positions.cd_icon,

                -- 物品
				-- 手套
				{slotID = 10, filter = "CD" },
				-- 腰带
				{slotID = 6, filter = "CD" },
				-- 披风
				{slotID = 15, filter = "CD" },
				-- 饰品
				{slotID = 13, filter = "CD" },
				{slotID = 14, filter = "CD" },
            },
        },
        ["ROGUE"] = {
            {
                name = "玩家buff&debuff",
                direction = "LEFT",
                setpoint = positions.player_buff_icon,
                size = 28,

                --淺察
                { spellID = 84745, unitId = "player", caster = "player", filter = "BUFF" },
                --中度洞察
                { spellID = 84746, unitId = "player", caster = "player", filter = "BUFF" },
                --深度洞察
                { spellID = 84747, unitId = "player", caster = "player", filter = "BUFF" },
                --預知
                { spellID = 115189, unitId = "player", caster = "player", filter = "BUFF" },
                --手裏劍
                { spellID = 137586, unitId = "player", caster = "player", filter = "BUFF" },
            },
            {
                name = "目标buff&debuff",
                direction = "RIGHT",
                setpoint = positions.target_buff_icon,
                size = 28,

                --致命毒藥
                { spellID = 2818, unitId = "target", caster = "player", filter = "DEBUFF" },
                --麻痺毒藥
                { spellID = 5760, unitId = "target", caster = "player", filter = "DEBUFF" },
                --致殘毒藥
                { spellID = 3409, unitId = "target", caster = "player", filter = "DEBUFF" },
                --吸血毒藥
                { spellID = 112961, unitId = "target", caster = "player", filter = "DEBUFF" },
                --致傷毒藥
                { spellID = 8680, unitId = "target", caster = "player", filter = "DEBUFF" },
                --破甲
                { spellID = 113746, unitId = "target", caster = "all", filter = "DEBUFF" },
            },
            {
                name = "玩家重要buff&debuff",
                direction = "LEFT",
                setpoint = positions.player_proc_icon,
                size = 38,

                --疾跑
                { spellID = 2983, unitId = "player", caster = "player", filter = "BUFF" },
                --暗影披風
                { spellID = 31224, unitId = "player", caster = "player", filter = "BUFF" },
                --能量刺激
                { spellID = 13750, unitId = "player", caster = "player", filter = "BUFF" },
                --閃避
                { spellID = 5277, unitId = "player", caster = "player", filter = "BUFF" },
                --戰鬥就緒
                { spellID = 74001, unitId = "player", caster = "player", filter = "BUFF" },
                --毒化
                { spellID = 32645, unitId = "player", caster = "player", filter = "BUFF" },
                --極限殺戮
                { spellID = 58426, unitId = "player", caster = "player", filter = "BUFF" },
                --切割
                { spellID = 5171, unitId = "player", caster = "player", filter = "BUFF" },
                --偷天換日
                { spellID = 57934, unitId = "player", caster = "player", filter = "BUFF" },
                --偷天換日(傷害之後)
                { spellID = 59628, unitId = "player", caster = "player", filter = "BUFF" },
                --养精蓄锐
                { spellID = 73651, unitId = "player", caster = "player", filter = "BUFF" },
                --剑刃乱舞
                { spellID = 13877, unitId = "player", caster = "player", filter = "BUFF" },
                --佯攻
                { spellID = 1966, unitId = "player", caster = "player", filter = "BUFF" },
                --暗影之舞
                { spellID = 51713, unitId = "player", caster = "player", filter = "BUFF" },
                --敏銳大師
                { spellID = 31665, unitId = "player", caster = "player", filter = "BUFF" },
                --毀滅者之怒
                { spellID = 109949, unitId = "player", caster = "player", filter = "BUFF" },
                --洞悉要害
                { spellID = 121153, unitId = "player", caster = "player", filter = "BUFF" },
                --暗影之刃
                { spellID = 121471, unitId = "player", caster = "player", filter = "BUFF" },
            },
            {
                name = "目标重要buff&debuff",
                direction = "RIGHT",
                setpoint = positions.target_proc_icon,
                size = 38,

                --偷襲
                { spellID = 1833, unitId = "target", caster = "all", filter = "DEBUFF" },
                --腎擊
                { spellID = 408, unitId = "target", caster = "all", filter = "DEBUFF" },
                --致盲
                { spellID = 2094, unitId = "target", caster = "all", filter = "DEBUFF" },
                --悶棍
                { spellID = 6770, unitId = "target", caster = "all", filter = "DEBUFF" },
                --割裂
                { spellID = 1943, unitId = "target", caster = "player", filter = "DEBUFF" },
                --絞喉
                { spellID = 703, unitId = "target", caster = "player", filter = "DEBUFF" },
                --絞喉沉默
                { spellID = 1330, unitId = "target", caster = "player", filter = "DEBUFF" },
                --鑿擊
                { spellID = 1776, unitId = "target", caster = "player", filter = "DEBUFF" },
                --破甲
                { spellID = 8647, unitId = "target", caster = "player", filter = "DEBUFF" },
                --卸除武裝
                { spellID = 51722, unitId = "target", caster = "player", filter = "DEBUFF" },
                --出血
                { spellID = 89775, unitId = "target", caster = "player", filter = "DEBUFF" },
                --赤紅風暴
                { spellID = 122233, unitId = "target", caster = "player", filter = "DEBUFF" },
                --揭底之擊
                { spellID = 84617, unitId = "target", caster = "player", filter = "DEBUFF" },
                --宿怨
                { spellID = 79140, unitId = "target", caster = "player", filter = "DEBUFF" },
                --制裁之錘
                { spellID = 853, unitId = "target", caster = "all", filter = "DEBUFF" },
                --制裁之拳
                { spellID = 105593, unitId = "target", caster = "all", filter = "DEBUFF" },
            },
            {
                name = "焦点buff&debuff",
                direction = "UP",
                setpoint = positions.focus_buff_icon,
                size = 24,
                mode = "BAR",
                iconSide = "LEFT",
                barWidth = 170,

                --致盲
                { spellID = 2094, unitId = "focus", caster = "all", filter = "DEBUFF" },
                --悶棍
                { spellID = 6770, unitId = "focus", caster = "all", filter = "DEBUFF" },
            },
            {
                name = "CD",
                iconSide = "LEFT",
                size = 28,
                barWidth = 170,
                direction = function() return R:IsDeveloper() and "RIGHT" or "DOWN" end,
                mode = function() return R:IsDeveloper() and "ICON" or "BAR" end,
                setpoint = positions.cd_icon,

                --暗影步
                { spellID = 36554, filter = "CD" },
                --预备
                { spellID = 14185, filter = "CD" },
                --疾跑
                { spellID = 2983, filter = "CD" },
                --斗篷
                { spellID = 31224, filter = "CD" },
                --闪避
                { spellID = 5277, filter = "CD" },
                --拆卸
                { spellID = 51722, filter = "CD" },
                --影舞
                { spellID = 51713, filter = "CD" },
                --預謀
                { spellID = 14183, filter = "CD" },
                --致盲
                { spellID = 2094, filter = "CD" },
                --偷天換日
                { spellID = 57934, filter = "CD" },
                --战斗就绪
                { spellID = 74001, filter = "CD" },
                --烟雾弹
                { spellID = 76577, filter = "CD" },
                --消失
                { spellID = 1856, filter = "CD" },
                --转攻
                { spellID = 73981, filter = "CD" },
                --宿怨
                { spellID = 79140, filter = "CD" },
                --狂舞杀戮
                { spellID = 51690, filter = "CD" },
                --能量刺激
                { spellID = 13750, filter = "CD" },
                --暗影之刃
                { spellID = 121471, filter = "CD" },
                --奧術之流
                { spellID = 25046, filter = "CD" },

                -- 物品
				-- 手套
				{slotID = 10, filter = "CD" },
				-- 腰带
				{slotID = 6, filter = "CD" },
				-- 披风
				{slotID = 15, filter = "CD" },
				-- 饰品
				{slotID = 13, filter = "CD" },
				{slotID = 14, filter = "CD" },
            },
        },
        ["DEATHKNIGHT"] = {
            {
                name = "玩家重要buff&debuff",
                direction = "LEFT",
                setpoint = positions.player_proc_icon,
                size = 38,

                --血魄護盾
                { spellID = 77535, unitId = "player", caster = "player", filter = "BUFF" },
                --血魄轉化
                { spellID = 45529, unitId = "player", caster = "player", filter = "BUFF" },
                --血族之裔
                { spellID = 55233, unitId = "player", caster = "player", filter = "BUFF" },
                --穢邪力量
                { spellID = 53365, unitId = "player", caster = "player", filter = "BUFF" },
                --穢邪之力
                { spellID = 67117, unitId = "player", caster = "player", filter = "BUFF" },
                --符文武器幻舞
                { spellID = 49028, unitId = "player", caster = "player", filter = "BUFF" },
                --冰錮堅韌
                { spellID = 48792, unitId = "player", caster = "player", filter = "BUFF" },
                --反魔法護罩
                { spellID = 48707, unitId = "player", caster = "player", filter = "BUFF" },
                --殺戮酷刑
                { spellID = 51124, unitId = "player", caster = "player", filter = "BUFF" },
                --冰封之霧
                { spellID = 59052, unitId = "player", caster = "player", filter = "BUFF" },
                --骸骨之盾
                { spellID = 49222, unitId = "player", caster = "player", filter = "BUFF" },
                --冰霜之柱
                { spellID = 51271, unitId = "player", caster = "player", filter = "BUFF" },
                --血魄充能
                { spellID = 114851, unitId = "player", caster = "player", filter = "BUFF" },
                --黑暗救贖
                { spellID = 101568, unitId = "player", caster = "player", filter = "BUFF" },
                --寶寶能量
                { spellID = 91342, unitId = "pet", caster = "player", filter = "BUFF" },
                --黑暗變身
                { spellID = 63560, unitId = "pet", caster = "player", filter = "BUFF" },
            },
            {
                name = "目标重要buff&debuff",
                direction = "RIGHT",
                setpoint = positions.target_proc_icon,
                size = 38,

                --絞殺
                { spellID = 47476, unitId = "target", caster = "player", filter = "DEBUFF" },
                --血魄瘟疫
                { spellID = 55078, unitId = "target", caster = "player", filter = "DEBUFF" },
                --冰霜熱疫
                { spellID = 55095, unitId = "target", caster = "player", filter = "DEBUFF" },
                --召喚石像鬼
                { spellID = 49206, unitId = "target", caster = "player", filter = "DEBUFF" },
                --死亡凋零
                { spellID = 43265, unitId = "target", caster = "player", filter = "DEBUFF" },
            },
        },
        ["MONK"] = {
			{
				name = "玩家buff&debuff",
				direction = "LEFT",
				setpoint = positions.player_buff_icon,
				size = 28,

				--飄渺絕釀
				{ spellID = 128939, unitId = "player", caster = "player", filter = "BUFF" },
				--虎眼絕釀
				{ spellID = 125195, unitId = "player", caster = "player", filter = "BUFF" },
                --回生迷霧
                { spellID = 119611, unitId = "player", caster = "player", filter = "BUFF" },
                --迷霧繚繞
                { spellID = 132120, unitId = "player", caster = "player", filter = "BUFF" },
                --舒和之霧
                { spellID = 115175, unitId = "player", caster = "player", filter = "BUFF" },
				--酒仙小緩勁
				{ spellID = 124275, unitId = "player", caster = "all", filter = "DEBUFF" },
				--酒仙中緩勁
				{ spellID = 124274, unitId = "player", caster = "all", filter = "DEBUFF" },
				--酒仙大緩勁
				{ spellID = 124273, unitId = "player", caster = "all", filter = "DEBUFF" },
				--法力茶
				{ spellID = 115867, unitId = "player", caster = "player", filter = "BUFF" },
			},
            {
                name = "目标buff&debuff",
                direction = "RIGHT",
                setpoint = positions.target_buff_icon,
                size = 28,

                --回生迷霧
                { spellID = 119611, unitId = "target", caster = "player", filter = "BUFF" },
                --迷霧繚繞
                { spellID = 132120, unitId = "target", caster = "player", filter = "BUFF" },
                --舒和之霧
                { spellID = 115175, unitId = "target", caster = "player", filter = "BUFF" },
            },
            {
                name = "玩家重要buff&debuff",
                direction = "LEFT",
                setpoint = positions.player_proc_icon,
                size = 38,

				--虎掌
				{ spellID = 125359, unitId = "player", caster = "player", filter = "BUFF" },
				--禪心玉
				{ spellID = 124081, unitId = "player", caster = "player", filter = "BUFF" },
				--護身氣勁
				{ spellID = 118636, unitId = "player", caster = "player", filter = "BUFF" },
				--石形絕釀
				{ spellID = 120954, unitId = "player", caster = "player", filter = "BUFF" },
				--醉拳
				{ spellID = 115307, unitId = "player", caster = "player", filter = "BUFF" },
				--護身氣勁
				{ spellID = 115295, unitId = "player", caster = "player", filter = "BUFF" },
				--飄渺絕釀
				{ spellID = 115308, unitId = "player", caster = "player", filter = "BUFF" },
				--繳械傷害提升5%
				{ spellID = 123231, unitId = "player", caster = "player", filter = "BUFF" },
				--繳械坦克提升5%
				{ spellID = 123232, unitId = "player", caster = "player", filter = "BUFF" },
				--繳械治療提升5%
				{ spellID = 123234, unitId = "player", caster = "player", filter = "BUFF" },
				--虎眼絕釀
				{ spellID = 116740, unitId = "player", caster = "player", filter = "BUFF" },
				--乾坤挪移
				{ spellID = 125174, unitId = "player", caster = "player", filter = "BUFF" },
				--蛟龍之誠
				{ spellID = 127722, unitId = "player", caster = "player", filter = "BUFF" },
				--精活迷霧
				{ spellID = 118674, unitId = "player", caster = "player", filter = "BUFF" },
				--連段破:滅寂腿
				{ spellID = 116768, unitId = "player", caster = "player", filter = "BUFF" },
				--連段破:虎掌
				{ spellID = 118864, unitId = "player", caster = "player", filter = "BUFF" },
            },
            {
                name = "目标重要buff&debuff",
                direction = "RIGHT",
                setpoint = positions.target_proc_icon,
                size = 38,

				--弱化攻擊
				{ spellID = 115798, unitId = "target", caster = "player", filter = "DEBUFF" },
				--掃葉腿
				{ spellID = 119381, unitId = "target", caster = "player", filter = "DEBUFF" },
				--天矛鎖喉手
				{ spellID = 116709, unitId = "target", caster = "player", filter = "DEBUFF" },
				--微醺醉氣
				{ spellID = 123727, unitId = "target", caster = "player", filter = "DEBUFF" },
				{ spellID = 116330, unitId = "target", caster = "player", filter = "DEBUFF" },
				--奪刃繩矛
				{ spellID = 117368, unitId = "player", caster = "player", filter = "DEBUFF" },
                --旭日东升踢
                { spellID = 130320, unitId = "target", caster = "player", filter = "DEBUFF" },
            },
            {
                name = "焦点buff&debuff",
                direction = "UP",
                setpoint = positions.focus_buff_icon,
                size = 24,
                mode = "BAR",
                iconSide = "LEFT",
                barWidth = 170,

            },
            {
                name = "CD",
                iconSide = "LEFT",
                size = 28,
                barWidth = 170,
                direction = function() return R:IsDeveloper() and "RIGHT" or "DOWN" end,
                mode = function() return R:IsDeveloper() and "ICON" or "BAR" end,
                setpoint = positions.cd_icon,

				--冥思禪功
				{ spellID = 115176, filter = "CD" },
				-- 乾坤挪移
				{ spellID = 122470, filter = "CD" },
				-- 召喚白虎雪怒
				{ spellID = 123904, filter = "CD" },
				-- 凝神絕釀
				{ spellID = 115288, filter = "CD" },
				-- 石形絕釀
				{ spellID = 115203, filter = "CD" },
				-- 召喚玄牛雕像
				{ spellID = 115315, filter = "CD" },
				-- 移傷氣勁
				{ spellID = 115213, filter = "CD" },
				-- 氣繭護體
				{ spellID = 116849, filter = "CD" },
				-- 五氣歸元
				{ spellID = 115310, filter = "CD" },

                -- 物品
				-- 手套
				{slotID = 10, filter = "CD" },
				-- 腰带
				{slotID = 6, filter = "CD" },
				-- 披风
				{slotID = 15, filter = "CD" },
				-- 饰品
				{slotID = 13, filter = "CD" },
				{slotID = 14, filter = "CD" },
            },
        },
        ["ALL"]={
            {
                name = "玩家特殊buff&debuff",
                direction = "LEFT",
                setpoint = positions.player_special_icon,
                size = 41,

                --飾品
				-- PvP 飾品
				{ spellID = 126697, unitId = "player", caster = "player", filter = "BUFF" },
				-- 暗月卡牌(觸發)
				{ spellID = 128985, unitId = "player", caster = "player", filter = "BUFF", fuzzy = true },
				-- 坦
				-- 影潘之襲的堅定咒符 (躲閃, 使用)
				{ spellID = 138728, unitId = "player", caster = "player", filter = "BUFF" },
				-- 贊達拉之韌 (生命, 使用)
				{ spellID = 126697, unitId = "player", caster = "player", filter = "BUFF" },
				-- 兇殘玲瓏瓶 (精通, 觸發)
				{ spellID = 138864, unitId = "player", caster = "player", filter = "BUFF" },
				-- 夢魘之物 (躲閃, 觸發)
				{ spellID = 126646, unitId = "player", caster = "player", filter = "BUFF" },
				-- 龍血之瓶 (躲閃, 觸發)
				{ spellID = 126533, unitId = "player", caster = "player", filter = "BUFF" },
				-- 翠玉督軍刻像 (精通, 使用)
				{ spellID = 126597, unitId = "player", caster = "player", filter = "BUFF" },
				-- 物理敏捷DPS
				-- 影潘之襲的兇惡咒符 (敏捷, 觸發)
				{ spellID = 138699, unitId = "player", caster = "player", filter = "BUFF" },
				-- 邪惡魂能 (敏捷, 觸發)
				{ spellID = 138938, unitId = "player", caster = "player", filter = "BUFF" },
				-- 嗜血咒符 (急速, 觸發)
				{ spellID = 138895, unitId = "player", caster = "player", filter = "BUFF" },
				-- 重新分配之符文 (轉換, 觸發)
				{ spellID = 139120, unitId = "player", caster = "player", filter = "BUFF" },
				-- 雷納塔基的靈魂符咒 (敏捷, 觸發)
				{ spellID = 138756, unitId = "player", caster = "player", filter = "BUFF" },
				-- 箭翔勳章 (暴擊, 使用)
				{ spellID = 136086, unitId = "player", caster = "player", filter = "BUFF" },
				-- 霧中之懼 (暴擊, 觸發)
				{ spellID = 126649, unitId = "player", caster = "player", filter = "BUFF" },
				-- 翠玉強盜刻像 (急速, 使用)
				{ spellID = 126599, unitId = "player", caster = "player", filter = "BUFF" },
				-- 無垠星辰之瓶 (敏捷, 觸發)
				{ spellID = 126554, unitId = "player", caster = "player", filter = "BUFF" },
				-- PvP飾品 (敏捷, 使用)
				{ spellID = 126690, unitId = "player", caster = "player", filter = "BUFF" },
				-- PvP飾品 (敏捷, 觸發)
				{ spellID = 126707, unitId = "player", caster = "player", filter = "BUFF" },
				-- 物理力量DPS
				-- 影潘之襲的野蠻咒符 (力量, 觸發)
				{ spellID = 138702, unitId = "player", caster = "player", filter = "BUFF" },
				-- 稷坤的傳說之羽 (力量, 觸發)
				{ spellID = 138759, unitId = "player", caster = "player", filter = "BUFF" },
				-- 贊達拉火花 (力量, 觸發)
				{ spellID = 138960, unitId = "player", caster = "player", filter = "BUFF" },
				-- 普莫迪斯的狂怒咒符 (力量, 觸發)
				{ spellID = 138870, unitId = "player", caster = "player", filter = "BUFF" },
				-- 雙妃之凝視 (暴擊, 觸發)
				{ spellID = 139170, unitId = "player", caster = "player", filter = "BUFF" },
				-- 盔碎勳章 (暴擊, 使用)
				{ spellID = 136084, unitId = "player", caster = "player", filter = "BUFF" },
				-- 暗霧漩渦 (急速, 觸發)
				{ spellID = 126657, unitId = "player", caster = "player", filter = "BUFF" },
				-- 雷神的最後命令 (力量, 觸發)
				{ spellID = 126582, unitId = "player", caster = "player", filter = "BUFF" },
				-- 翠玉車駕刻像 (力量, 使用)
				{ spellID = 126599, unitId = "player", caster = "player", filter = "BUFF" },
				-- 鐵肚皮炒鍋 (急速, 使用)
				{ spellID = 129812, unitId = "player", caster = "player", filter = "BUFF" },
				-- PvP飾品 (力量, 使用)
				{ spellID = 126679, unitId = "player", caster = "player", filter = "BUFF" },
				-- PvP飾品 (力量, 觸發)
				{ spellID = 126700, unitId = "player", caster = "player", filter = "BUFF" },
				-- 法系通用
				-- 雷衝勳章 (智力, 使用)
				{ spellID = 136082, unitId = "player", caster = "player", filter = "BUFF" },
				-- 翠玉執政官刻像 (暴擊, 使用)
				{ spellID = 126605, unitId = "player", caster = "player", filter = "BUFF" },
				-- PvP飾品 (法術強度, 使用)
				{ spellID = 126683, unitId = "player", caster = "player", filter = "BUFF" },
				-- PvP飾品 (法術強度, 觸發)
				{ spellID = 126705, unitId = "player", caster = "player", filter = "BUFF" },
				-- 法系DPS
				-- 影潘之襲的烈性咒符 (急速, 觸發)
				{ spellID = 138703, unitId = "player", caster = "player", filter = "BUFF" },
				-- 洽耶的光輝精華 (智力, 觸發)
				{ spellID = 139133, unitId = "player", caster = "player", filter = "BUFF" },
				-- 多頭蛇之息 (智力, 觸發)
				{ spellID = 138898, unitId = "player", caster = "player", filter = "BUFF" },
				-- 烏蘇雷的最後抉擇 (智力, 觸發)
				{ spellID = 138786, unitId = "player", caster = "player", filter = "BUFF" },
				-- 恐懼精華 (急速, 觸發)
				{ spellID = 126659, unitId = "player", caster = "player", filter = "BUFF" },
				-- 宇宙之光 (智力, 觸發)
				{ spellID = 126577, unitId = "player", caster = "player", filter = "BUFF" },
				-- 完美瞄準 (智力, 觸發)
				{ spellID = 138963, unitId = "player", caster = "player", filter = "BUFF" },
				-- 治療
				-- 秦璽的極化徽印 (智力, 觸發)
				{ spellID = 126588, unitId = "player", caster = "player", filter = "BUFF" },

                --專業技能
                -- 神經突觸彈簧
                { spellID = 126734, unitId = "player", caster = "player", filter = "BUFF", fuzzy = true },
				-- 相移指套
				{ spellID = 108788, unitId = "player", caster = "player", filter = "BUFF" },
				-- 硝基推進器
				{ spellID = 54861, unitId = "player", caster = "player", filter = "BUFF" },
				-- 降落傘
				{ spellID = 55001, unitId = "player", caster = "player", filter = "BUFF" },
				-- 生命之血
				{ spellID = 74497, unitId = "player", caster = "player", filter = "BUFF" },
                -- 迅轉偏斜甲
                { spellID = 82176, unitId = "player", caster = "player", filter = "BUFF" },
				-- 光紋
				{ spellID = 125487, unitId = "player", caster = "player", filter = "BUFF" },

                --武器附魔
				--玉魂
				{ spellID = 104993, unitId = "player", caster = "all", filter = "BUFF" },

                --藥水
                --玉蛟
                { spellID = 105702, unitId = "player", caster = "player", filter = "BUFF" },
                --兔妖之咬
                { spellID = 105697, unitId = "player", caster = "player", filter = "BUFF" },
                --魔古之力
                { spellID = 105706, unitId = "player", caster = "player", filter = "BUFF" },
                --卡法加速
                { spellID = 125282, unitId = "player", caster = "player", filter = "BUFF" },

                --特殊buff
                -- 偷天換日
                { spellID = 57933, unitId = "player", caster = "all", filter = "BUFF" },
                -- 注入能量
                { spellID = 10060, unitId = "player", caster = "all", filter = "BUFF" },
                -- 嗜血術
                { spellID = 2825, unitId = "player", caster = "all", filter = "BUFF" },
                -- 英勇氣概
                { spellID = 32182, unitId = "player", caster = "all", filter = "BUFF" },
                -- 時間扭曲
                { spellID = 80353, unitId = "player", caster = "all", filter = "BUFF" },
                -- 上古狂亂
                { spellID = 90355, unitId = "player", caster = "all", filter = "BUFF" },
                -- 振奮咆哮
                { spellID = 97463, unitId = "player", caster = "all", filter = "BUFF" },
                -- 犧牲聖禦
                { spellID = 6940, unitId = "player", caster = "all", filter = "BUFF" },
                -- 保護聖禦
                { spellID = 1022, unitId = "player", caster = "all", filter = "BUFF" },
                -- 守护之魂
                { spellID = 47788, unitId = "player", caster = "all", filter = "BUFF" },
                -- 痛苦镇压
                { spellID = 33206, unitId = "player", caster = "all", filter = "BUFF" },
                -- 血族之裔
                { spellID = 105588, unitId = "player", caster = "all", filter = "BUFF" },
                -- 吸血鬼的拥抱
                { spellID = 15286, unitId = "player", caster = "all", filter = "BUFF" },
                -- 虔誠光環
                { spellID = 31821, unitId = "player", caster = "all", filter = "BUFF" },
                -- 風暴鞭笞圖騰
                { spellID = 120676, unitId = "player", caster = "all", filter = "BUFF" },
                -- 骷髏戰旗
                { spellID = 114206, unitId = "player", caster = "all", filter = "BUFF" },
                -- 時流暫緩
                { spellID = 137590, unitId = "player", caster = "all", filter = "BUFF" },

                --種族天賦
                -- 血之烈怒
                { spellID = 20572, unitId = "player", caster = "player", filter = "BUFF" },
                -- 狂暴
                { spellID = 26297, unitId = "player", caster = "player", filter = "BUFF" },

				--套裝
                { spellID = 138317, unitId = "player", caster = "player", filter = "BUFF" },

            },
            {
                name = "PVE/PVP玩家buff&debuff",
                direction = "UP",
                setpoint = positions.pve_player_icon,
                size = 51,

                --死亡騎士
                -- 啃食
                { spellID = 91800, unitId = "player", caster = "all", filter = "DEBUFF" },
                -- 暴猛痛擊
                { spellID = 91797, unitId = "player", caster = "all", filter = "DEBUFF" },
                -- 窒息術
                { spellID = 108194, unitId = "player", caster = "all", filter = "DEBUFF" },
                -- 冷酷凜冬
                { spellID = 115001, unitId = "player", caster = "all", filter = "DEBUFF" },
                -- 絞殺
                { spellID = 47476, unitId = "player", caster = "all", filter = "DEBUFF" },
                -- 黑暗幻象
                { spellID = 77606, unitId = "player", caster = "all", filter = "DEBUFF" },
                -- 亡域打擊
                { spellID = 73975, unitId = "player", caster = "all", filter = "DEBUFF" },
                -- 冰鍊術
                { spellID = 45524, unitId = "player", caster = "all", filter = "DEBUFF" },
                -- 凍瘡
                { spellID = 50435, unitId = "player", caster = "all", filter = "DEBUFF" },

                --德魯伊
                -- 颶風術
				{ spellID = 33786, unitId = "player", caster = "all", filter = "DEBUFF" },
				-- 休眠
				{ spellID = 2637, unitId = "player", caster = "all", filter = "DEBUFF" },
				-- 破膽咆哮 (共生)
				{ spellID = 113004, unitId = "player", caster = "all", filter = "DEBUFF" },
				-- 猛力重擊
				{ spellID = 5211, unitId = "player", caster = "all", filter = "DEBUFF" },
				-- 熊抱
				{ spellID = 102795, unitId = "player", caster = "all", filter = "DEBUFF" },
				-- 傷殘術
				{ spellID = 22570, unitId = "player", caster = "all", filter = "DEBUFF" },
				-- 突襲
				{ spellID = 9005, unitId = "player", caster = "all", filter = "DEBUFF" },
				-- 掠魂咆哮
				{ spellID = 99, unitId = "player", caster = "all", filter = "DEBUFF" },
				-- 太陽光束
				{ spellID = 78675, unitId = "player", caster = "all", filter = "DEBUFF" },
				-- 精靈沉默
				{ spellID = 114238, unitId = "player", caster = "all", filter = "DEBUFF" },
				-- 糾纏根鬚
				{ spellID = 339, unitId = "player", caster = "all", filter = "DEBUFF" },
				-- 無法移動
				{ spellID = 45334, unitId = "player", caster = "all", filter = "DEBUFF" },
				-- 感染之傷
				{ spellID = 58180, unitId = "player", caster = "all", filter = "DEBUFF" },
				-- 颱風
				{ spellID = 61391, unitId = "player", caster = "all", filter = "DEBUFF" },

                --獵人
                -- 豹群守護
				{ spellID = 13159, unitId = "player", caster = "all", filter = "BUFF" },
				-- 脅迫
				{ spellID = 24394, unitId = "player", caster = "all", filter = "DEBUFF" },
				-- 禁錮射擊
				{ spellID = 117526, unitId = "player", caster = "all", filter = "DEBUFF" },
				-- 冰凍陷阱
				{ spellID = 3355, unitId = "player", caster = "all", filter = "DEBUFF" },
				-- 恐嚇野獸
				{ spellID = 1513, unitId = "player", caster = "all", filter = "DEBUFF" },
				-- 驅散射擊
				{ spellID = 19503, unitId = "player", caster = "all", filter = "DEBUFF" },
				-- 翼龍釘刺
				{ spellID = 19386, unitId = "player", caster = "all", filter = "DEBUFF" },
				-- 沉默射擊
				{ spellID = 34490, unitId = "player", caster = "all", filter = "DEBUFF" },
				-- 險裡逃生
				{ spellID = 136634, unitId = "player", caster = "all", filter = "DEBUFF" },
				-- 誘捕
				{ spellID = 19185, unitId = "player", caster = "all", filter = "DEBUFF" },
				-- 震盪射擊
				{ spellID = 5116, unitId = "player", caster = "all", filter = "DEBUFF" },
				-- 震盪轟擊
				{ spellID = 35101, unitId = "player", caster = "all", filter = "DEBUFF" },
				-- 凍痕
				{ spellID = 61394, unitId = "player", caster = "all", filter = "DEBUFF" },
				-- 寒冰陷阱
				{ spellID = 135382, unitId = "player", caster = "all", filter = "DEBUFF" },
				-- 壞風度 (猴子)
				{ spellID = 90337, unitId = "player", caster = "all", filter = "DEBUFF" },
				-- 催眠曲 (鶴)
				{ spellID = 126246, unitId = "player", caster = "all", filter = "DEBUFF" },
				-- 蛛網纏繞 (岩蛛)
				{ spellID = 96201, unitId = "player", caster = "all", filter = "DEBUFF" },
				-- 噴灑毒網 (奇特異種蟲)
				{ spellID = 54706, unitId = "player", caster = "all", filter = "DEBUFF" },
				-- 蛛網 (蜘蛛)
				{ spellID = 4167, unitId = "player", caster = "all", filter = "DEBUFF" },
				-- 釘刺 (螃蟹)
				{ spellID = 50245, unitId = "player", caster = "all", filter = "DEBUFF" },
				-- 虛空震擊 (虛空鰭刺)
				{ spellID = 44957, unitId = "player", caster = "all", filter = "DEBUFF" },
				-- 奪械 (蠍子)
				{ spellID = 50541, unitId = "player", caster = "all", filter = "DEBUFF" },
				-- 霜雷之息 (奇特奇美拉)
				{ spellID = 54644, unitId = "player", caster = "all", filter = "DEBUFF" },
				-- 腳踝粉碎 (鱷魚)
				{ spellID = 50433, unitId = "player", caster = "all", filter = "DEBUFF" },
				-- 時間扭曲 (扭曲巡者)
				{ spellID = 35346, unitId = "player", caster = "all", filter = "DEBUFF" },
				-- 釘刺 (黃蜂)
				{ spellID = 56626, unitId = "player", caster = "all", filter = "DEBUFF" },
				-- 音波衝擊 (蝙蝠)
				{ spellID = 50519, unitId = "player", caster = "all", filter = "DEBUFF" },
				-- 麻痺刺針 (豪豬)
				{ spellID = 126355, unitId = "player", caster = "all", filter = "DEBUFF" },
				-- 石化凝視 (石化蜥蜴)
				{ spellID = 126423, unitId = "player", caster = "all", filter = "DEBUFF" },

				--法師
				-- 極度冰凍
				{ spellID = 44572, unitId = "player", caster = "all", filter = "DEBUFF" },
				-- 變形術
				{ spellID = 118, unitId = "player", caster = "all", filter = "DEBUFF" },
				-- 霜之環
				{ spellID = 82691, unitId = "player", caster = "all", filter = "DEBUFF" },
				-- 龍之吐息
				{ spellID = 31661, unitId = "player", caster = "all", filter = "DEBUFF" },
				-- 燃火衝擊
				{ spellID = 118271, unitId = "player", caster = "all", filter = "DEBUFF" },
				-- 霜顎
				{ spellID = 102051, unitId = "player", caster = "all", filter = "DEBUFF" },
				-- 沉默 - 強化法術反制
				{ spellID = 55021, unitId = "player", caster = "all", filter = "DEBUFF" },
				-- 冰凍術 (水元素)
				{ spellID = 33395, unitId = "player", caster = "all", filter = "DEBUFF" },
				-- 冰霜新星
				{ spellID = 122, unitId = "player", caster = "all", filter = "DEBUFF" },
				-- 寒冰結界
				{ spellID = 111340, unitId = "player", caster = "all", filter = "DEBUFF" },
				-- 冰錐術
				{ spellID = 120, unitId = "player", caster = "all", filter = "DEBUFF" },
				-- 減速術
				{ spellID = 31589, unitId = "player", caster = "all", filter = "DEBUFF" },
				-- 寒冰箭
				{ spellID = 116, unitId = "player", caster = "all", filter = "DEBUFF" },
				-- 霜火箭
				{ spellID = 44614, unitId = "player", caster = "all", filter = "DEBUFF" },
				-- 冰凍
				{ spellID = 7321, unitId = "player", caster = "all", filter = "DEBUFF" },

				--武僧
				-- 點穴
				{ spellID = 115078, unitId = "player", caster = "all", filter = "DEBUFF" },
				-- 掃葉腿
				{ spellID = 119381, unitId = "player", caster = "all", filter = "DEBUFF" },
				-- 狂拳連打
				{ spellID = 120086, unitId = "player", caster = "all", filter = "DEBUFF" },
				-- 天引躍擊
				{ spellID = 122242, unitId = "player", caster = "all", filter = "DEBUFF" },
				-- 鐵牛衝鋒波
				{ spellID = 119392, unitId = "player", caster = "all", filter = "DEBUFF" },
				-- 傷筋斷骨
				{ spellID = 116706, unitId = "player", caster = "all", filter = "DEBUFF" },
				-- 天矛鎖喉手
				{ spellID = 116709, unitId = "player", caster = "all", filter = "DEBUFF" },
				-- 奪刃繩矛
				{ spellID = 117368, unitId = "player", caster = "all", filter = "DEBUFF" },

				--聖騎士
				-- 制裁之錘
				{ spellID = 853, unitId = "player", caster = "all", filter = "DEBUFF" },
				-- 制裁之拳
				{ spellID = 105593, unitId = "player", caster = "all", filter = "DEBUFF" },
				-- 懺悔
				{ spellID = 20066, unitId = "player", caster = "all", filter = "DEBUFF" },
				-- 盲目之光
				{ spellID = 105421, unitId = "player", caster = "all", filter = "DEBUFF" },
				-- 復仇之盾
				{ spellID = 31935, unitId = "player", caster = "all", filter = "DEBUFF" },
				-- 暈眩 - 復仇之盾
				{ spellID = 63529, unitId = "player", caster = "all", filter = "DEBUFF" },
				-- 公正聖印
				{ spellID = 20170, unitId = "player", caster = "all", filter = "DEBUFF" },
				-- 罪之重擔
				{ spellID = 110300, unitId = "player", caster = "all", filter = "DEBUFF" },
				-- 問罪
				{ spellID = 2812, unitId = "player", caster = "all", filter = "DEBUFF" },

				--牧師
				-- 支配心智
				{ spellID = 605, unitId = "player", caster = "all", filter = "DEBUFF" },
				-- 心靈尖嘯
				{ spellID = 8122, unitId = "player", caster = "all", filter = "DEBUFF" },
				-- 心靈恐懼
				{ spellID = 113792, unitId = "player", caster = "all", filter = "DEBUFF" },
				-- 心靈恐慌
				{ spellID = 64044, unitId = "player", caster = "all", filter = "DEBUFF" },
				-- 罪與罰
				{ spellID = 87204, unitId = "player", caster = "all", filter = "DEBUFF" },
				-- 沉默
				{ spellID = 15487, unitId = "player", caster = "all", filter = "DEBUFF" },
				-- 虛無觸鬚之握
				{ spellID = 114404, unitId = "player", caster = "all", filter = "DEBUFF" },
				-- 心靈震爆雕紋
				{ spellID = 87194, unitId = "player", caster = "all", filter = "DEBUFF" },
				-- 精神鞭笞
				{ spellID = 15407, unitId = "player", caster = "all", filter = "DEBUFF" },

				--盜賊
				-- 腎擊
				{ spellID = 408, unitId = "player", caster = "all", filter = "DEBUFF" },
				-- 偷襲
				{ spellID = 1833, unitId = "player", caster = "all", filter = "DEBUFF" },
				-- 悶棍
				{ spellID = 6770, unitId = "player", caster = "all", filter = "DEBUFF" },
				-- 致盲
				{ spellID = 2094, unitId = "player", caster = "all", filter = "DEBUFF" },
				-- 鑿擊
				{ spellID = 1776, unitId = "player", caster = "all", filter = "DEBUFF" },
				-- 絞喉 - 沉默
				{ spellID = 1330, unitId = "player", caster = "all", filter = "DEBUFF" },
				-- 卸除武裝
				{ spellID = 51722, unitId = "player", caster = "all", filter = "DEBUFF" },
				-- 煙霧彈
				{ spellID = 76577, unitId = "player", caster = "all", filter = "DEBUFF" },
				-- 擲殺
				{ spellID = 26679, unitId = "player", caster = "all", filter = "DEBUFF" },
				-- 致殘毒藥
				{ spellID = 3409, unitId = "player", caster = "all", filter = "DEBUFF" },
				-- 麻痺毒藥
				{ spellID = 5760, unitId = "player", caster = "all", filter = "DEBUFF" },

				--薩滿
				-- 妖術
				{ spellID = 51514, unitId = "player", caster = "all", filter = "DEBUFF" },
				-- 靜電衝擊
				{ spellID = 118905, unitId = "player", caster = "all", filter = "DEBUFF" },
				-- 粉碎
				{ spellID = 118345, unitId = "player", caster = "all", filter = "DEBUFF" },
				-- 地震術
				{ spellID = 77505, unitId = "player", caster = "all", filter = "DEBUFF" },
				-- 陷地
				{ spellID = 64695, unitId = "player", caster = "all", filter = "DEBUFF" },
				-- 地縛術
				{ spellID = 3600, unitId = "player", caster = "all", filter = "DEBUFF" },
				-- 冰霜震擊
				{ spellID = 8056, unitId = "player", caster = "all", filter = "DEBUFF" },
				-- 冰封攻擊
				{ spellID = 8034, unitId = "player", caster = "all", filter = "DEBUFF" },
				-- 雷霆風暴
				{ spellID = 51490, unitId = "player", caster = "all", filter = "DEBUFF" },

				--術士
				-- 暗影之怒
				{ spellID = 30283, unitId = "player", caster = "all", filter = "DEBUFF" },
				-- 投擲利斧 (惡魔守衛)
				{ spellID = 89766, unitId = "player", caster = "all", filter = "DEBUFF" },
				-- 恐懼術
				{ spellID = 118699, unitId = "player", caster = "all", filter = "DEBUFF" },
				-- 恐懼嚎叫
				{ spellID = 5484, unitId = "player", caster = "all", filter = "DEBUFF" },
				-- 血性恐懼
				{ spellID = 137143, unitId = "player", caster = "all", filter = "DEBUFF" },
				-- 死影纏繞
				{ spellID = 6789, unitId = "player", caster = "all", filter = "DEBUFF" },
				-- 催眠術
				{ spellID = 104045, unitId = "player", caster = "all", filter = "DEBUFF" },
				-- 誘惑 (魅魔)
				{ spellID = 6358, unitId = "player", caster = "all", filter = "DEBUFF" },
				-- 迷惑 (Shivarra)
				{ spellID = 115268, unitId = "player", caster = "all", filter = "DEBUFF" },
				-- 痛苦動盪
				{ spellID = 31117, unitId = "player", caster = "all", filter = "DEBUFF" },
				-- 法術封鎖 (地獄犬)
				{ spellID = 24259, unitId = "player", caster = "all", filter = "DEBUFF" },
				-- 目光衝擊 (Observer)
				{ spellID = 115782, unitId = "player", caster = "all", filter = "DEBUFF" },
				-- 疲勞詛咒
				{ spellID = 18223, unitId = "player", caster = "all", filter = "DEBUFF" },
				-- 焚燒
				{ spellID = 17962, unitId = "player", caster = "all", filter = "DEBUFF" },
				-- 暗影之焰
				{ spellID = 47960, unitId = "player", caster = "all", filter = "DEBUFF" },

				--戰士
				-- 暴風怒擲
				{ spellID = 132169, unitId = "player", caster = "all", filter = "DEBUFF" },
				-- 震懾波
				{ spellID = 132168, unitId = "player", caster = "all", filter = "DEBUFF" },
				-- 戰爭使者
				{ spellID = 105771, unitId = "player", caster = "all", filter = "DEBUFF" },
				-- 破膽怒吼
				{ spellID = 20511, unitId = "player", caster = "all", filter = "DEBUFF" },
				-- 繳械
				{ spellID = 676, unitId = "player", caster = "all", filter = "DEBUFF" },
				-- 震地怒吼
				{ spellID = 107566, unitId = "player", caster = "all", filter = "DEBUFF" },
				-- 斷筋
				{ spellID = 1715, unitId = "player", caster = "all", filter = "DEBUFF" },
				-- 刺耳怒吼
				{ spellID = 12323, unitId = "player", caster = "all", filter = "DEBUFF" },
				-- 巨像碎擊
				{ spellID = 86346, unitId = "player", caster = "all", filter = "DEBUFF" },
				-- 衝鋒昏迷
				{ spellID = 7922, unitId = "player", caster = "all", filter = "DEBUFF" },

                --種族天賦
                -- 戰爭踐踏
                { spellID = 20549, unitId = "player", caster = "all", filter = "DEBUFF" },
				-- 震動掌
				{ spellID = 107079, unitId = "player", caster = "all", filter = "DEBUFF" },
				-- 奧流之術
				{ spellID = 28730, unitId = "player", caster = "all", filter = "DEBUFF" },

                --副本
				--雷霆王座
				-- 电离反应
				{ spellID = 138732, unitId = "player", caster = "all", filter = "DEBUFF", fuzzy = true },
				-- 聚能閃電
				{ spellID = 137422, unitId = "player", caster = "all", filter = "DEBUFF", fuzzy = true },
				-- 魂靈標記
				{ spellID = 137359, unitId = "player", caster = "all", filter = "DEBUFF", fuzzy = true },
				-- 霜寒刺骨
				{ spellID = 136922, unitId = "player", caster = "all", filter = "DEBUFF", fuzzy = true },
				-- 幽暗之魂
				{ spellID = 137650, unitId = "player", caster = "all", filter = "DEBUFF", fuzzy = true },
				-- 寒冰洪流
				{ spellID = 139857, unitId = "player", caster = "all", filter = "DEBUFF", fuzzy = true },
				-- 燼火
				{ spellID = 134391, unitId = "player", caster = "all", filter = "DEBUFF", fuzzy = true },
				-- 飛行
				{ spellID = 133755, unitId = "player", caster = "all", filter = "BUFF", fuzzy = true },
				-- 主要營養
				{ spellID = 140741, unitId = "player", caster = "all", filter = "BUFF", fuzzy = true },
				-- 靜電震擊
				{ spellID = 135695, unitId = "player", caster = "all", filter = "DEBUFF", fuzzy = true },
				-- 動盪生命
				{ spellID = 138297, unitId = "player", caster = "all", filter = "DEBUFF", fuzzy = true },

                --魔古山寶庫
                --石衛士
                -- 碧玉鎖鏈
                { spellID = 130395, unitId = "player", caster = "all", filter = "DEBUFF", fuzzy = true },

                --馮
                --烈焰星火
                { spellID = 116784, unitId = "player", caster = "all", filter = "DEBUFF", fuzzy = true },
                -- 秘法共鳴
                { spellID = 116417, unitId = "player", caster = "all", filter = "DEBUFF", fuzzy = true },
                -- 無效屏障
                { spellID = 115856, unitId = "player", caster = "all", filter = "BUFF", fuzzy = true },

				--卡拉賈
                -- 靈魂經絡
                { spellID = 117549, unitId = "player", caster = "all", filter = "BUFF", fuzzy = true },

                --恐懼之心
                --刀鋒領主塔亞克
				-- 無形打擊
                { spellID = 123017, unitId = "player", caster = "all", filter = "DEBUFF", fuzzy = true },

                --加拉隆
				-- 費洛蒙
                { spellID = 122835, unitId = "player", caster = "all", filter = "DEBUFF", fuzzy = true },

                --風領主瑪爾加拉克
				-- 琥珀監獄
                { spellID = 121885, unitId = "player", caster = "all", filter = "DEBUFF", fuzzy = true },

                --豐泉臺
                --恐懼之煞
                -- 無畏
                { spellID = 118977, unitId = "player", caster = "all", filter = "BUFF", fuzzy = true },

                --其他
                -- 火箭燃料漏油
                { spellID = 94794, unitId = "player", caster = "all", filter = "DEBUFF" },
            },
            {
                name = "PVE/PVP目标buff&debuff",
                direction = "UP",
                setpoint = positions.pve_target_icon,
                size = 51,

                --啟動
                { spellID = 29166, unitId = "target", caster = "all", filter = "BUFF" },
                --法術反射
                { spellID = 23920, unitId = "target", caster = "all", filter = "BUFF" },
                --精通光環
                { spellID = 31821, unitId = "target", caster = "all", filter = "BUFF" },
                --寒冰屏障
                { spellID = 45438, unitId = "target", caster = "all", filter = "BUFF" },
                --暗影披風
                { spellID = 31224, unitId = "target", caster = "all", filter = "BUFF" },
                --聖盾術
                { spellID = 642, unitId = "target", caster = "all", filter = "BUFF" },
                --威懾
                { spellID = 19263, unitId = "target", caster = "all", filter = "BUFF" },
                --反魔法護罩
                { spellID = 48707, unitId = "target", caster = "all", filter = "BUFF" },
                --巫妖之軀
                { spellID = 49039, unitId = "target", caster = "all", filter = "BUFF" },
                --自由聖禦
                { spellID = 1044, unitId = "target", caster = "all", filter = "BUFF" },
                --犧牲聖禦
                { spellID = 6940, unitId = "target", caster = "all", filter = "BUFF" },
                --根基圖騰效果
                { spellID = 8178, unitId = "target", caster = "all", filter = "BUFF" },
                --保護聖禦
                { spellID = 1022, unitId= "target", caster = "all", filter = "BUFF" },
            },
        },
    }
}
