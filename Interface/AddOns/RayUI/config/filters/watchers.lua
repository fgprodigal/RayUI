local R, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local

local positions = {
    player_buff_icon    = { "BOTTOMRIGHT", "RayUF_player", "TOPRIGHT", 0, 80 },	-- "玩家buff&debuff"
    target_buff_icon    = { "BOTTOMLEFT", "RayUF_target", "TOPLEFT", 0, 80 },	-- "目标buff&debuff"
    player_proc_icon    = { "BOTTOMRIGHT", "RayUF_player", "TOPRIGHT", 0, 33 },	-- "玩家重要buff&debuff"
    target_proc_icon    = { "BOTTOMLEFT", "RayUF_target", "TOPLEFT", 0, 33 },	-- "目标重要buff&debuff"
    focus_buff_icon     = { "BOTTOMLEFT", "RayUF_focus", "TOPLEFT", 0, 10 },	-- "焦点buff&debuff"
    cd_icon             = function() return R:IsDeveloper() and { "TOPLEFT", "RayUIActionBar1", "BOTTOMLEFT", 0, -6 } or { "TOPLEFT", "RayUIActionBar3", "BOTTOMRIGHT", -28, -6 } end,	-- "cd"
    player_special_icon = { "TOPRIGHT", "RayUF_player", "BOTTOMRIGHT", 0, -9 }, -- "玩家特殊buff&debuff"
    pve_player_icon     = { "BOTTOM", UIParent, "BOTTOM", -35, 350 }, -- "PVE/PVP玩家buff&debuff"
    pve_target_icon     = { "BOTTOM", UIParent, "BOTTOM", 35, 350 }, -- "PVE/PVP目标buff&debuff"
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
                --回春術(萌芽)
                { spellID = 155777, unitId = "player", caster = "player", filter = "BUFF" },
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
                --回春術(萌芽)
                { spellID = 155777, unitId = "target", caster = "player", filter = "BUFF" },
            },
            {
                name = "玩家重要buff&debuff",
                direction = "LEFT",
                setpoint = positions.player_proc_icon,
                size = 38,

                --日之巅
                { spellID = 171744, unitId = "player", caster = "player", filter = "BUFF" },
                --月之巅
                { spellID = 171743, unitId = "player", caster = "player", filter = "BUFF" },
                --月光增效
                { spellID = 164547, unitId = "player", caster = "player", filter = "BUFF" },
                --日光增效
                { spellID = 164545, unitId = "player", caster = "player", filter = "BUFF" },
                --流星
                { spellID = 93400, unitId = "player", caster = "player", filter = "BUFF" },
                --兇蠻咆哮
                { spellID = 52610, unitId = "player", caster = "player", filter = "BUFF" },
                --求生本能
                { spellID = 61336, unitId = "player", caster = "player", filter = "BUFF" },
                --節能施法
                { spellID = 16870, unitId = "player", caster = "player", filter = "BUFF" },
                --樹皮術
                { spellID = 22812, unitId = "player", caster = "player", filter = "BUFF" },
                --狂暴
                { spellID = 106951, unitId = "player", caster = "player", filter = "BUFF" },
                --狂暴恢復
                { spellID = 22842, unitId = "player", caster = "player", filter = "BUFF" },
                --猛獸迅捷
                { spellID = 69369, unitId = "player", caster = "player", filter = "BUFF" },
                --自然戒備
                { spellID = 124974, unitId = "player", caster = "player", filter = "BUFF" },
                --森林之魂
                { spellID = 114108, unitId = "player", caster = "player", filter = "BUFF" },
                --星殞術
                { spellID = 48505, unitId = "player", caster = "player", filter = "BUFF" },
                --星穹大連線
                { spellID = 112071, unitId = "player", caster = "player", filter = "BUFF" },
                --化身:艾露恩之眷
                { spellID = 117679, unitId = "player", caster = "player", filter = "BUFF" },
                --野性之心
                { spellID = 108294, unitId = "player", caster = "player", filter = "BUFF" },
                --化身:丛林之王
                { spellID = 102543, unitId = "player", caster = "player", filter = "BUFF" },
                --猛虎之怒
                { spellID = 5217, unitId = "player", caster = "player", filter = "BUFF" },
                --野蛮咆哮雕文
                { spellID = 174544, unitId = "player", caster = "player", filter = "BUFF" },
                --血腥爪击
                { spellID = 145152, unitId = "player", caster = "player", filter = "BUFF" },
                --粉碎
                { spellID = 158792, unitId = "player", caster = "player", filter = "BUFF" },
                --鬃毛倒竖
                { spellID = 155835, unitId = "player", caster = "player", filter = "BUFF" },
                --塞纳里奥结界
                { spellID = 102351, unitId = "player", caster = "player", filter = "BUFF" },
                --塞纳里奥结界:触发
                { spellID = 102352, unitId = "player", caster = "player", filter = "BUFF" },
                --狂暴:熊形态
                { spellID = 50334, unitId = "player", caster = "player", filter = "BUFF" },
                --化身:乌索克之子
                { spellID = 102558, unitId = "player", caster = "player", filter = "BUFF" },
                --巨熊之力
                { spellID = 159233, unitId = "player", caster = "player", filter = "BUFF" },
                --尖牙与利爪
                { spellID = 135286, unitId = "player", caster = "player", filter = "BUFF" },
                --野蛮防御
                { spellID = 132402, unitId = "player", caster = "player", filter = "BUFF" },
            },
            {
                name = "目标重要buff&debuff",
                direction = "RIGHT",
                setpoint = positions.target_proc_icon,
                size = 38,

                --糾纏根鬚
                { spellID = 339, unitId = "target", caster = "all", filter = "DEBUFF" },
                --颶風術
                { spellID = 33786, unitId = "target", caster = "all", filter = "DEBUFF" },
                --月火術
                { spellID = 164812, unitId = "target", caster = "player", filter = "DEBUFF" },
                --日炎術
                { spellID = 164815, unitId = "target", caster = "player", filter = "DEBUFF" },
                --掃擊
                { spellID = 1822, unitId = "target", caster = "player", filter = "DEBUFF" },
                --撕扯
                { spellID = 1079, unitId = "target", caster = "player", filter = "DEBUFF" },
                --割裂
                { spellID = 33745, unitId = "target", caster = "player", filter = "DEBUFF" },
                --痛擊
                { spellID = 106830, unitId = "target", caster = "player", filter = "DEBUFF" },
                --傷殘術
                { spellID = 22570, unitId = "target", caster = "player", filter = "DEBUFF" },
                --斜掠
                { spellID = 155722, unitId = "target", caster = "player", filter = "DEBUFF" },
                --痛击
                { spellID = 77758, unitId = "target", caster = "player", filter = "DEBUFF" },
            },
            {
                name = "焦点buff&debuff",
                direction = "UP",
                setpoint = positions.focus_buff_icon,
                size = 24,
                mode = "BAR",
                iconSide = "LEFT",
                barWidth = 170,

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
                --複生
                { spellID = 20484, filter = "CD" },
                --樹皮術
                { spellID = 22812, filter = "CD" },
                --寧靜
                { spellID = 740, filter = "CD" },
                --自然戒備
                { spellID = 124974, filter = "CD" },
                --星穹大連線
                { spellID = 112071, filter = "CD" },
                --野性位移
                { spellID = 102280, filter = "CD" },
                --化身:艾露恩之眷
                { spellID = 102560, filter = "CD" },
                --狂奔怒吼
                { spellID = 106898, filter = "CD" },
                --急奔
                { spellID = 1850, filter = "CD" },
                --日光术
                { spellID = 78675, filter = "CD" },
                --猛虎之怒
                { spellID = 5217, filter = "CD" },
                --影遁
                { spellID = 58984, filter = "CD" },

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
                --狙击训练
                { spellID = 168811, unitId = "player", caster = "player", filter = "BUFF" },
				--狙击训练；最近移动
                { spellID = 168809, unitId = "player", caster = "player", filter = "BUFF" },

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
                --快速射擊
                { spellID = 6150, unitId = "player", caster = "player", filter = "BUFF" },
                --戰術大師
                { spellID = 34837, unitId = "player", caster = "player", filter = "BUFF" },
                --急速射擊
                { spellID = 3045, unitId = "player", caster = "player", filter = "BUFF" },
                --治療寵物
                { spellID = 136, unitId = "pet", caster = "player", filter = "BUFF" },
                --連環火網
                { spellID = 82921, unitId = "player", caster = "player", filter = "BUFF" },
                --狂亂效果
                { spellID = 19615, unitId = "pet", caster = "pet", filter = "BUFF" },
                --獵殺快感
                { spellID = 34720, unitId = "player", caster = "player", filter = "BUFF" },
                --4T13
                { spellID = 105919, unitId = "player", caster = "player", filter = "BUFF" },
                --稳固集中
                { spellID = 177668, unitId = "player", caster = "player", filter = "BUFF" },
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
                --毒蛇釘刺
                { spellID = 118253, unitId = "target", caster = "player", filter = "DEBUFF" },
                --黑蝕箭
                { spellID = 3674, unitId = "target", caster = "player", filter = "DEBUFF" },
                --爆裂射擊
                { spellID = 53301, unitId = "target", caster = "player", filter = "DEBUFF" },
                --黑鸦
                { spellID = 131894, unitId = "target", caster = "player", filter = "DEBUFF" },
                
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
                name = "玩家buff&debuff",
                direction = "LEFT",
                setpoint = positions.player_buff_icon,
                size = 28,

            },
            {
                name = "目标buff&debuff",
                direction = "RIGHT",
                setpoint = positions.target_buff_icon,
                size = 28,

            },
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
                --時光護盾
                { spellID = 115610, unitId = "player", caster = "player", filter = "BUFF" },
                --燒灼
                { spellID = 87023, unitId = "player", caster = "player", filter = "DEBUFF" },
                --強效隱形
                { spellID = 113862, unitId = "player", caster = "player", filter = "BUFF" },
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
                --嗜血
                { spellID = 23881, filter = "CD" },
                --巨人打击
                { spellID = 86346, filter = "CD" },
            },
            {
                name = "目标buff&debuff",
                direction = "RIGHT",
                setpoint = positions.target_buff_icon,
                size = 28,

            },
            {
                name = "玩家重要buff&debuff",
                direction = "LEFT",
                setpoint = positions.player_proc_icon,
                size = 38,

                --驟亡
                { spellID = 52437, unitId = "player", caster = "player", filter = "BUFF" },
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
                --狂怒之擊!
                { spellID = 131116, unitId = "player", caster = "player", filter = "BUFF" },
                --浴血
                { spellID = 12292, unitId = "player", caster = "player", filter = "BUFF" },
                --怒击！
                { spellID = 131116, unitId = "player", caster = "player", filter = "BUFF" },
                --剑刃风暴
                { spellID = 46924, unitId = "player", caster = "player", filter = "BUFF" },
                --激怒
                { spellID = 12880, unitId = "player", caster = "player", filter = "BUFF" },
                --死亡裁决
                { spellID = 144442, unitId = "player", caster = "player", filter = "BUFF" },
                --盾牌屏障
                { spellID = 112048, unitId = "player", caster = "player", filter = "BUFF" },
                --最后通牒
                { spellID = 122510, unitId = "player", caster = "player", filter = "BUFF" },
                --剑在人在
                { spellID = 118038, unitId = "player", caster = "player", filter = "BUFF" },
                --盾牌冲锋
                { spellID = 156321, unitId = "player", caster = "player", filter = "BUFF" },
                --盾牌冲锋
                { spellID = 169667, unitId = "player", caster = "player", filter = "BUFF" },
            },
            {
                name = "目标重要buff&debuff",
                direction = "RIGHT",
                setpoint = positions.target_proc_icon,
                size = 38,

                --撕裂
                { spellID = 772, unitId = "target", caster = "player", filter = "DEBUFF" },
                --震盪波
                { spellID = 46968, unitId = "target", caster = "all", filter = "DEBUFF" },
                --斷筋
                { spellID = 1715, unitId = "target", caster = "all", filter = "DEBUFF" },
                --挫志怒吼
                { spellID = 1160, unitId = "target", caster = "player", filter = "DEBUFF" },
                --破膽怒吼
                { spellID = 5246, unitId = "target", caster = "player", filter = "DEBUFF" },
                --巨人打击
                { spellID = 167105, unitId = "target", caster = "player", filter = "DEBUFF" },
                --感染之傷(德魯伊)
                { spellID = 48484, unitId = "target", caster = "all", filter = "DEBUFF" },
                --挫志咆哮(德魯伊)
                { spellID = 99, unitId = "target", caster = "all", filter = "DEBUFF" },
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

                --鲁莽
                { spellID = 1719, filter = "CD" },
                --浴血奋战
                { spellID = 12292, filter = "CD" },
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
                --Lightning Shield / Blitzschlagschild
                { spellID = 324, unitId = "player", caster = "player", filter = "BUFF" },
                --Water Shield / Wasserschild
                { spellID = 52127, unitId = "player", caster = "player", filter = "BUFF" },
                --治疗之雨
                { spellID = 73920, unitId = "player", caster = "player", filter = "BUFF" },

            },
            {
                name = "目标buff&debuff",
                direction = "RIGHT",
                setpoint = positions.target_buff_icon,
                size = 28,

                --Earth Shield / Erdschild
                { spellID = 974, unitId = "target", caster = "player", filter = "BUFF" },
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
                --升腾
                { spellID = 114050, unitId = "player", caster = "player", filter = "BUFF" },
                --元素回响
                { spellID = 159105, unitId = "player", caster = "player", filter = "BUFF" },
                --元素回响
                { spellID = 159101, unitId = "player", caster = "player", filter = "BUFF" },
                --先祖指引
                { spellID = 108281, unitId = "player", caster = "player", filter = "BUFF" },
                --元素掌握
                { spellID = 16166, unitId = "player", caster = "player", filter = "BUFF" },
                --元素融合
                { spellID = 157174, unitId = "player", caster = "player", filter = "BUFF" },
                --火焰释放
                { spellID = 165462, unitId = "player", caster = "player", filter = "BUFF" },
                --Riptide / Springflut
                { spellID = 61295, unitId = "player", caster = "player", filter = "BUFF" },

            },
            {
                name = "目标重要buff&debuff",
                direction = "RIGHT",
                setpoint = positions.target_proc_icon,
                size = 38,

                --Hex / Verhexen
                { spellID = 51514, unitId = "target", caster = "all", filter = "DEBUFF" },
                --Storm Strike / Sturmschlag
                { spellID = 17364, unitId = "target", caster = "player", filter = "DEBUFF" },
                --Frost Shock / Frostschock
                { spellID = 8056, unitId = "target", caster = "player", filter = "DEBUFF" },
                --Flame Shock / Flammenschock
                { spellID = 8050, unitId = "target", caster = "player", filter = "DEBUFF" },
                --Riptide / Springflut
                { spellID = 61295, unitId = "target", caster = "player", filter = "BUFF" },
                --地震术
                { spellID = 61882, unitId = "target", caster = "player", filter = "DEBUFF" },

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
                --神恩術
                { spellID = 31842, unitId = "player", caster = "player", filter = "BUFF" },
                --神圣复仇者
                { spellID = 105809, unitId = "player", caster = "player", filter = "BUFF" },
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
                --預支時間
                { spellID = 59889, unitId = "player", caster = "player", filter = "BUFF" },
                --精神鞭笞雕文
                { spellID = 120587, unitId = "player", caster = "player", filter = "BUFF" },
                --身心合一
                { spellID = 65081, unitId = "player", caster = "all", filter = "BUFF" },
                --天使之羽
                { spellID = 121557, unitId = "player", caster = "all", filter = "BUFF" },
                --幻影術
                { spellID = 114239, unitId = "player", caster = "player", filter = "BUFF" },
                --愈合之语
                { spellID = 155362, unitId = "player", caster = "player", filter = "BUFF" },
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
                --防護恐懼結界
                { spellID = 6346, unitId = "target", caster = "all", filter = "BUFF" },
            },
            {
                name = "玩家重要buff&debuff",
                direction = "LEFT",
                setpoint = positions.player_proc_icon,
                size = 38,

                --機緣回復
                { spellID = 63735, unitId = "player", caster = "player", filter = "BUFF" },
                --佈道
                { spellID = 81661, unitId = "player", caster = "player", filter = "BUFF" },
                --大天使
                { spellID = 81700, unitId = "player", caster = "player", filter = "BUFF" },
                --影散
                { spellID = 47585, unitId = "player", caster = "player", filter = "BUFF" },
                --心靈鑚刺雕文
                { spellID = 81292, unitId = "player", caster = "player", filter = "BUFF" },
                --暗影强化(4T16)
                { spellID = 145180, unitId = "player", caster = "player", filter = "BUFF" },
                --鬼魅幻影
                { spellID = 119032, unitId = "player", caster = "player", filter = "BUFF" },
                --天使之壁
                { spellID = 114214, unitId = "player", caster = "player", filter = "BUFF" },
                --光之澎湃
                { spellID = 114255, unitId = "player", caster = "player", filter = "BUFF" },
                --黑暗奔騰
                { spellID = 87160, unitId = "player", caster = "player", filter = "BUFF" },
                --命運無常
                { spellID = 123254, unitId = "player", caster = "player", filter = "BUFF" },
                --注入能量
                { spellID = 10060, unitId = "player", caster = "player", filter = "BUFF" },
                --神聖洞察
                { spellID = 123267, unitId = "player", caster = "player", filter = "BUFF" },
                --幽暗洞察
                { spellID = 124430, unitId = "player", caster = "player", filter = "BUFF" },
                --精神護罩
                { spellID = 109964, unitId = "player", caster = "player", filter = "BUFF" },
                --暗言术：乱
                { spellID = 132573, unitId = "player", caster = "player", filter = "BUFF" },
                --愈合之语(十层)
                { spellID = 155363, unitId = "player", caster = "player", filter = "BUFF" },
                
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
                --虛無觸鬚
                { spellID = 114404, unitId = "target", caster = "all", filter = "DEBUFF" },
                --支配心智
                { spellID = 605, unitId = "target", caster = "all", filter = "DEBUFF" },
                --暗言術:痛
                { spellID = 589, unitId = "target", caster = "player", filter = "DEBUFF" },
                --吸血之觸
                { spellID = 34914, unitId = "target", caster = "player", filter = "DEBUFF" },
                --噬靈瘟疫
                { spellID = 158831, unitId = "target", caster = "player", filter = "DEBUFF" },
                --心靈恐慌
                { spellID = 64044, unitId = "target", caster = "all", filter = "DEBUFF" },
                --沉默
                { spellID = 15487, unitId = "target", caster = "all", filter = "DEBUFF" },
                --守護聖靈
                { spellID = 47788, unitId = "target", caster = "all", filter = "BUFF" },
                --痛苦鎮壓
                { spellID = 33206, unitId = "target", caster = "all", filter = "BUFF" },
                --意志洞悉
                { spellID = 152118, unitId = "target", caster = "all", filter = "BUFF" },
                --虚空熵能
                { spellID = 155361, unitId = "target", caster = "player", filter = "DEBUFF" },
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
                --虛無觸鬚
                { spellID = 114404, unitId = "focus", caster = "all", filter = "DEBUFF" },
            },
            {
                name = "CD",
                iconSide = "LEFT",
                size = 28,
                barWidth = 170,
                direction = function() return R:IsDeveloper() and "RIGHT" or "DOWN" end,
                mode = function() return R:IsDeveloper() and "ICON" or "BAR" end,
                setpoint = positions.cd_icon,

                --光束泉
                { spellID = 126135, filter = "CD" },
                --神聖禮頌
                { spellID = 64843, filter = "CD" },
                --守護聖靈
                { spellID = 47788, filter = "CD" },
                --真言術:壁
                { spellID = 62618, filter = "CD" },
                --痛苦鎮壓
                { spellID = 33206, filter = "CD" },
                --影散
                { spellID = 47585, filter = "CD" },
                --吸血鬼的擁抱
                { spellID = 15286, filter = "CD" },
                --暗影魔
                { spellID = 34433, filter = "CD" },
                --注入能量
                { spellID = 10060, filter = "CD" },
                --絕望禱言
                { spellID = 19236, filter = "CD" },

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
                name = "玩家buff&debuff",
                direction = "LEFT",
                setpoint = positions.player_buff_icon,
                size = 28,

                --黑暗再生
                { spellID = 108359, unitId = "player", caster = "player", filter = "BUFF" },
                --灵魂榨取
                { spellID = 108366, unitId = "player", caster = "player", filter = "BUFF" },
                --牺牲契约
                { spellID = 108416, unitId = "player", caster = "player", filter = "BUFF" },
                --黑暗交易
                { spellID = 110913, unitId = "player", caster = "player", filter = "BUFF" },
                --猩红恐惧
                { spellID = 111397, unitId = "player", caster = "player", filter = "BUFF" },
                --爆燃冲刺
                { spellID = 111400, unitId = "player", caster = "player", filter = "BUFF" },
                --魔性征召
                { spellID = 114925, unitId = "player", caster = "player", filter = "BUFF" },
                --魔典：恶魔牺牲
                { spellID = 108503, unitId = "player", caster = "player", filter = "BUFF" },
                --恶魔法阵：召唤
                { spellID = 48018, unitId = "player", caster = "player", filter = "BUFF" },
                --灵魂石保存
                { spellID = 20707, unitId = "player", caster = "player", filter = "BUFF" },
            },
            {
                name = "目标buff&debuff",
                direction = "RIGHT",
                setpoint = positions.target_buff_icon,
                size = 28,

            },
            {
                name = "玩家重要buff&debuff",
                setpoint = positions.player_proc_icon,
                direction = "LEFT",
                size = 38,

                --灵魂燃烧
                { spellID = 74434, unitId = "player", caster = "player", filter = "BUFF" },
                --灵魂交换
                { spellID = 86211, unitId = "player", caster = "player", filter = "BUFF" },
                --黑暗灵魂：哀难
                { spellID = 113860, unitId = "player", caster = "player", filter = "BUFF" },
                --熔火之心
                { spellID = 122355, unitId = "player", caster = "player", filter = "BUFF" },
                --恶魔协同
                { spellID = 171982, unitId = "player", caster = "all", filter = "BUFF" },
                --炽燃之怒(2T16)
                { spellID = 145085, unitId = "player", caster = "player", filter = "BUFF" },
                --黑暗灵魂：学识
                { spellID = 113861, unitId = "player", caster = "player", filter = "BUFF" },
                --爆燃
                { spellID = 117828, unitId = "player", caster = "player", filter = "BUFF" },
                --火焰之雨
                { spellID = 104232, unitId = "player", caster = "player", filter = "BUFF" },
                --硫磺烈火
                { spellID = 108683, unitId = "player", caster = "player", filter = "BUFF" },
                --浩劫
                { spellID = 80240, unitId = "player", caster = "player", filter = "BUFF" },
                --黑暗灵魂：易爆
                { spellID = 113858, unitId = "player", caster = "player", filter = "BUFF" },
                --基尔加丹的狡诈
                { spellID = 137587, unitId = "player", caster = "player", filter = "BUFF" },
                --玛诺洛斯的狂怒
                { spellID = 108508, unitId = "player", caster = "player", filter = "BUFF" },
                --不灭决心
                { spellID = 104773, unitId = "player", caster = "player", filter = "BUFF" },
            },
            {
                name = "目标重要buff&debuff",
                setpoint = positions.target_proc_icon,
                direction = "RIGHT",
                mode = "ICON",
                size = 38,

                --恐懼術
                { spellID = 118699, unitId = "target", caster = "player", filter = "DEBUFF" },
                --放逐術
                { spellID = 710, unitId = "target", caster = "player", filter = "DEBUFF" },
                --腐蝕術
                { spellID = 146739, unitId = "target", caster = "player", filter = "DEBUFF" },
                --痛苦災厄
                { spellID = 980, unitId = "target", caster = "player", filter = "DEBUFF" },
                --痛苦動盪
                { spellID = 30108, unitId = "target", caster = "player", filter = "DEBUFF" },
                --蝕魂術
                { spellID = 48181, unitId = "target", caster = "player", filter = "DEBUFF" },
                --腐蝕種子
                { spellID = 27243, unitId = "target", caster = "player", filter = "DEBUFF" },
                --古尔丹之手
                { spellID = 47960, unitId = "target", caster = "player", filter = "DEBUFF" },
                --末日降临
                { spellID = 603, unitId = "target", caster = "player", filter = "DEBUFF" },
                --獻祭
                { spellID = 157736, unitId = "target", caster = "player", filter = "DEBUFF" },
                --浩劫
                { spellID = 80240, unitId = "target", caster = "player", filter = "DEBUFF" },
                --恐懼嚎叫
                { spellID = 5484, unitId = "target", caster = "player", filter = "DEBUFF" },
                --死亡纏繞
                { spellID = 6789, unitId = "target", caster = "player", filter = "DEBUFF" },
                --暗影之怒
                { spellID = 30283, unitId = "target", caster = "player", filter = "DEBUFF" },
                --奴役惡魔
                { spellID = 1098, unitId = "pet", caster = "player", filter = "DEBUFF" },
            },
            {
                name = "焦点buff&debuff",
                direction = "UP",
                setpoint = positions.focus_buff_icon,
                size = 24,
                mode = "BAR",
                iconSide = "LEFT",
                barWidth = 170,

                --恐懼術
                { spellID = 118699, unitId = "focus", caster = "all", filter = "DEBUFF" },
                --放逐術
                { spellID = 710, unitId = "focus", caster = "all", filter = "DEBUFF" },
                --恐懼嚎叫
                { spellID = 5484, unitId = "focus", caster = "all", filter = "DEBUFF" },
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
                --手裏劍
                { spellID = 137586, unitId = "player", caster = "player", filter = "BUFF" },
                --無聲之刃
                { spellID = 145193, unitId = "player", caster = "player", filter = "BUFF" },
            },
            {
                name = "目标buff&debuff",
                direction = "RIGHT",
                setpoint = positions.target_buff_icon,
                size = 28,

                --致命毒藥
                { spellID = 2818, unitId = "target", caster = "player", filter = "DEBUFF" },
                --致殘毒藥
                { spellID = 3409, unitId = "target", caster = "player", filter = "DEBUFF" },
                --吸血毒藥
                { spellID = 112961, unitId = "target", caster = "player", filter = "DEBUFF" },
                --致傷毒藥
                { spellID = 8680, unitId = "target", caster = "player", filter = "DEBUFF" },
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
                --狂舞殘殺
                { spellID = 51690, unitId = "player", caster = "player", filter = "BUFF" },
                --毒藥師
                { spellID = 145249, unitId = "player", caster = "player", filter = "BUFF" },
                --欺敵
                { spellID = 115192, unitId = "player", caster = "player", filter = "BUFF" },
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
                --出血
                { spellID = 89775, unitId = "target", caster = "player", filter = "DEBUFF" },
                --赤紅風暴
                { spellID = 122233, unitId = "target", caster = "player", filter = "DEBUFF" },
                --揭底之擊
                { spellID = 84617, unitId = "target", caster = "player", filter = "DEBUFF" },
                --宿怨
                { spellID = 79140, unitId = "target", caster = "player", filter = "DEBUFF" },
                --出血
                { spellID = 16511, unitId = "target", caster = "player", filter = "DEBUFF" },
                --找尋弱點
                { spellID = 91021, unitId = "target", caster = "player", filter = "DEBUFF" },
                --制裁之錘
                { spellID = 853, unitId = "target", caster = "all", filter = "DEBUFF" },
                --制裁之拳
                { spellID = 105593, unitId = "target", caster = "all", filter = "DEBUFF" },
                --暗影反射
                { spellID = 156745, unitId = "target", caster = "player", filter = "DEBUFF" },
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

                --死亡標記
                { spellID = 137619, filter = "CD" },
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
                --宿怨
                { spellID = 79140, filter = "CD" },
                --狂舞杀戮
                { spellID = 51690, filter = "CD" },
                --能量刺激
                { spellID = 13750, filter = "CD" },
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
                name = "玩家buff&debuff",
                direction = "LEFT",
                setpoint = positions.player_buff_icon,
                size = 28,

            },
            {
                name = "目标buff&debuff",
                direction = "RIGHT",
                setpoint = positions.target_buff_icon,
                size = 28,

            },
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
                { spellID = 81256, unitId = "player", caster = "player", filter = "BUFF" },
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
                --鮮血氣息
                { spellID = 50421, unitId = "player", caster = "player", filter = "BUFF" },
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
                --靈魂收割者
                { spellID = 130736, unitId = "target", caster = "player", filter = "DEBUFF" },
                { spellID = 114866, unitId = "target", caster = "player", filter = "DEBUFF" },
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
                --石形絕釀
                { spellID = 120954, unitId = "player", caster = "player", filter = "BUFF" },
                --醉拳
                { spellID = 115307, unitId = "player", caster = "player", filter = "BUFF" },
                --護身氣勁
                { spellID = 115295, unitId = "player", caster = "player", filter = "BUFF" },
                --飄渺絕釀
                { spellID = 115308, unitId = "player", caster = "player", filter = "BUFF" },
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

                --掃葉腿
                { spellID = 119381, unitId = "target", caster = "player", filter = "DEBUFF" },
                --微醺醉氣
                { spellID = 116330, unitId = "target", caster = "player", filter = "DEBUFF" },
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
                --乾坤挪移
                { spellID = 122470, filter = "CD" },
                --召喚白虎雪怒
                { spellID = 123904, filter = "CD" },
                --凝神絕釀
                { spellID = 115288, filter = "CD" },
                --石形絕釀
                { spellID = 115203, filter = "CD" },
                --召喚玄牛雕像
                { spellID = 115315, filter = "CD" },
                --氣繭護體
                { spellID = 116849, filter = "CD" },
                --五氣歸元
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
                size = 38,

                --飾品
                -- PvP 飾品 (生命上限)
                { spellID = 126697, unitId = "player", caster = "all", filter = "BUFF" },
                -- PvP 飾品 (全能)
                { spellID = 170397, unitId = "player", caster = "all", filter = "BUFF" },

                --錮法索銀指環 
               -- 大法師的白熱光 (智力) 
               { spellID = 177159, unitId = "player", caster = "player", filter = "BUFF" }, 
               -- 大法師的白熱光 (力量) 
               { spellID = 177160, unitId = "player", caster = "player", filter = "BUFF" }, 
               -- 大法師的白熱光 (敏捷) 
               { spellID = 177161, unitId = "player", caster = "player", filter = "BUFF" }, 

               --錮法符文指環 
               -- 大法師的白熱強光 (智力) 
               { spellID = 177176, unitId = "player", caster = "player", filter = "BUFF" }, 
               -- 大法師的白熱強光 (力量) 
               { spellID = 177175, unitId = "player", caster = "player", filter = "BUFF" }, 
               -- 大法師的白熱強光 (敏捷) 
               { spellID = 177172, unitId = "player", caster = "player", filter = "BUFF" },
                -- 暗月卡牌
                -- 玉珑圣物 (智力, 触发)
                { spellID = 128985, unitId = "player", caster = "all", filter = "BUFF" },
                -- 雪怒圣物 (力量, 触发)
                { spellID = 128986, unitId = "player", caster = "all", filter = "BUFF" },
                -- 雪怒圣物 (敏捷, 触发)
                { spellID = 128984, unitId = "player", caster = "all", filter = "BUFF" },
                -- 赤精圣物 (精神, 触发)
                { spellID = 128987, unitId = "player", caster = "all", filter = "BUFF" },
                -- 骑士徽章 (爆击, 触发)
                { spellID = 162917, unitId = "player", caster = "all", filter = "BUFF" },
                -- 战争之颅 (爆击, 触发)
                { spellID = 162915, unitId = "player", caster = "all", filter = "BUFF" },
                -- 睡魔之袋 (爆击, 触发)
                { spellID = 162919, unitId = "player", caster = "all", filter = "BUFF" },
                -- 羽翼沙漏 (精神, 触发)
                { spellID = 162913, unitId = "player", caster = "all", filter = "BUFF" },

                -- 坦
                -- 岩心雕像
                { spellID = 176982, unitId = "player", caster = "all", filter = "BUFF" },
                -- 齐布的愚忠
                { spellID = 176460, unitId = "player", caster = "all", filter = "BUFF" },
                -- 普尔的盲目之眼
                { spellID = 176876, unitId = "player", caster = "all", filter = "BUFF" },
                -- 石化食肉孢子
                { spellID = 165824, unitId = "player", caster = "all", filter = "BUFF" },
                -- 不眠奥术精魂
                { spellID = 177053, unitId = "player", caster = "all", filter = "BUFF" },
                -- 无懈合击石板
                { spellID = 176873, unitId = "player", caster = "all", filter = "BUFF" },
                -- 爆裂熔炉之门
                { spellID = 177056, unitId = "player", caster = "all", filter = "BUFF" },
                -- 重击护符
                { spellID = 177102, unitId = "player", caster = "all", filter = "BUFF" },
                -- 鲁克的不幸护符 (减伤, 使用)
                { spellID = 146343, unitId = "player", caster = "all", filter = "BUFF" },
                -- 砮皂之毅 (躲闪, 使用)
                { spellID = 146344, unitId = "player", caster = "all", filter = "BUFF" },
                -- 季鹍的复苏之风 (生命, 触发)
                { spellID = 138973, unitId = "player", caster = "all", filter = "BUFF" },
                -- 赞达拉之韧 (生命, 使用)
                { spellID = 126697, unitId = "player", caster = "all", filter = "BUFF" },
                -- 嗜血者的精致小瓶 (精通, 触发)
                { spellID = 138864, unitId = "player", caster = "all", filter = "BUFF" },
                -- 影踪突袭营的坚定护符 (躲闪, 使用)
                { spellID = 138728, unitId = "player", caster = "all", filter = "BUFF" },
                -- 梦魇残片 (躲闪, 触发)
                { spellID = 126646, unitId = "player", caster = "all", filter = "BUFF" },
                -- 龙血之瓶 (躲闪, 触发)
                { spellID = 126533, unitId = "player", caster = "all", filter = "BUFF" },
                -- 玉质军阀俑 (精通, 使用)
                { spellID = 126597, unitId = "player", caster = "all", filter = "BUFF" },

                -- 物理敏捷DPS
                -- 黑心执行者勋章
                { spellID = 176984, unitId = "player", caster = "all", filter = "BUFF" },
                -- 双面幸运金币
                { spellID = 177597, unitId = "player", caster = "all", filter = "BUFF" },
                -- 毁灭之鳞
                { spellID = 177038, unitId = "player", caster = "all", filter = "BUFF" },
                -- 多肉龙脊奖章
                { spellID = 177035, unitId = "player", caster = "all", filter = "BUFF" },
                -- 跃动的山脉之心
                { spellID = 176878, unitId = "player", caster = "all", filter = "BUFF" },
                -- 蜂鸣黑铁触发器
                { spellID = 177067, unitId = "player", caster = "all", filter = "BUFF" },
                -- 既定之天命 (敏捷, 触发)
                { spellID = 146308, unitId = "player", caster = "all", filter = "BUFF" },
                -- 哈洛姆的护符 (敏捷, 触发)
                { spellID = 148903, unitId = "player", caster = "all", filter = "BUFF" },
                -- 暴怒之印 (敏捷, 触发)
                { spellID = 148896, unitId = "player", caster = "all", filter = "BUFF" },
                -- 滴答作响的黑色雷管 (敏捷, 触发)
                { spellID = 146310, unitId = "player", caster = "all", filter = "BUFF" },
                -- 雪怒之律 (爆击, 触发)
                { spellID = 146312, unitId = "player", caster = "all", filter = "BUFF" },
                -- 邪恶魂能 (敏捷, 触发)
                { spellID = 138938, unitId = "player", caster = "all", filter = "BUFF" },
                -- 杀戮护符 (急速, 触发)
                { spellID = 138895, unitId = "player", caster = "all", filter = "BUFF" },
                -- 重生符文 (转换, 触发)
                { spellID = 139120, unitId = "player", caster = "all", filter = "BUFF" },
                { spellID = 139121, unitId = "player", caster = "all", filter = "BUFF" },
                { spellID = 139117, unitId = "player", caster = "all", filter = "BUFF" },
                -- 雷纳塔基的灵魂符咒 (敏捷, 触发)
                { spellID = 138756, unitId = "player", caster = "all", filter = "BUFF" },
                -- 影踪突袭营的邪恶护符 (敏捷, 触发)
                { spellID = 138699, unitId = "player", caster = "all", filter = "BUFF" },
                -- 飞箭奖章 (爆击, 使用)
                { spellID = 136086, unitId = "player", caster = "all", filter = "BUFF" },
                -- 萦雾之恐 (爆击, 触发)
                { spellID = 126649, unitId = "player", caster = "all", filter = "BUFF" },
                -- 玉质盗匪俑 (急速, 使用)
                { spellID = 126599, unitId = "player", caster = "all", filter = "BUFF" },
                -- 群星之瓶 (敏捷, 触发)
                { spellID = 126554, unitId = "player", caster = "all", filter = "BUFF" },
                -- PvP飾品 (敏捷, 使用)
                { spellID = 126690, unitId = "player", caster = "all", filter = "BUFF" },
                -- PvP飾品 (敏捷, 觸發)
                { spellID = 126707, unitId = "player", caster = "all", filter = "BUFF" },

                -- 物理力量DPS
                -- 活体火山微粒
                { spellID = 176974, unitId = "player", caster = "all", filter = "BUFF" },
                -- 齐亚诺斯的剑鞘
                { spellID = 177189, unitId = "player", caster = "all", filter = "BUFF" },
                -- 泰克图斯的脉动之心
                { spellID = 177040, unitId = "player", caster = "all", filter = "BUFF" },
                -- 抽搐暗影之瓶
                { spellID = 176874, unitId = "player", caster = "all", filter = "BUFF" },
                -- 尖啸之魂号角
                { spellID = 177042, unitId = "player", caster = "all", filter = "BUFF" },
                -- 熔炉主管的徽记
                { spellID = 177096, unitId = "player", caster = "all", filter = "BUFF" },
                -- 迦拉卡斯的邪恶之眼 (力量, 触发)
                { spellID = 146245, unitId = "player", caster = "all", filter = "BUFF" },
                -- 索克的尾巴尖 (力量, 触发)
                { spellID = 146250, unitId = "player", caster = "all", filter = "BUFF" },
                -- 斯基尔的沁血护符 (力量, 触发)
                { spellID = 146285, unitId = "player", caster = "all", filter = "BUFF" },
                -- 融火之核 (力量, 触发)
                { spellID = 148899, unitId = "player", caster = "all", filter = "BUFF" },
                -- 天神迅捷 (急速, 触发)
                { spellID = 146296, unitId = "player", caster = "all", filter = "BUFF" },
                -- 季鹍的传说之羽 (力量, 触发)
                { spellID = 138759, unitId = "player", caster = "all", filter = "BUFF" },
                -- 赞达拉之火 (力量, 触发)
                { spellID = 138958, unitId = "player", caster = "all", filter = "BUFF" },
                -- 普莫迪斯的狂怒咒符 (力量, 触发)
                { spellID = 138870, unitId = "player", caster = "all", filter = "BUFF" },
                -- 双后的凝视 (爆击, 触发)
                { spellID = 139170, unitId = "player", caster = "all", filter = "BUFF" },
                -- 破盔者奖章 (爆击, 使用)
                { spellID = 136084, unitId = "player", caster = "all", filter = "BUFF" },
                -- 影踪突袭营的野蛮护符 (力量, 触发)
                { spellID = 138702, unitId = "player", caster = "all", filter = "BUFF" },
                -- 黑雾漩涡 (急速, 触发)
                { spellID = 126657, unitId = "player", caster = "all", filter = "BUFF" },
                -- 雷神的遗诏 (力量, 触发)
                { spellID = 126582, unitId = "player", caster = "all", filter = "BUFF" },
                -- 玉质御者俑 (力量, 使用)
                { spellID = 126599, unitId = "player", caster = "all", filter = "BUFF" },
                -- 铁腹炒锅 (急速, 使用)
                { spellID = 129812, unitId = "player", caster = "all", filter = "BUFF" },
                -- PvP飾品 (力量, 使用)
                { spellID = 126679, unitId = "player", caster = "all", filter = "BUFF" },
                -- PvP飾品 (力量, 觸發)
                { spellID = 126700, unitId = "player", caster = "all", filter = "BUFF" },

                -- 法系通用
                -- 科普兰的清醒
                { spellID = 177594, unitId = "player", caster = "all", filter = "BUFF" },
                -- 雷衝勳章 (智力, 使用)
                { spellID = 136082, unitId = "player", caster = "all", filter = "BUFF" },
                -- 翠玉執政官刻像 (暴擊, 使用)
                { spellID = 126605, unitId = "player", caster = "all", filter = "BUFF" },
                -- PvP飾品 (法術強度, 使用)
                { spellID = 126683, unitId = "player", caster = "all", filter = "BUFF" },
                -- PvP飾品 (法術強度, 觸發)
                { spellID = 126705, unitId = "player", caster = "all", filter = "BUFF" },

                -- 法系DPS
                -- 動亂聚焦水晶
                { spellID = 176882, unitId = "player", caster = "all", filter = "BUFF" },
                -- 狂怒之心护符
                { spellID = 176980, unitId = "player", caster = "all", filter = "BUFF" },
                -- 虚无碎片
                { spellID = 176875, unitId = "player", caster = "all", filter = "BUFF" },
                -- 髟鼠蜥人灵魂容器
                { spellID = 177046, unitId = "player", caster = "all", filter = "BUFF" },
                -- 达玛克的无常护符
                { spellID = 177051, unitId = "player", caster = "all", filter = "BUFF" },
                -- 黑铁微型坩埚
                { spellID = 177081, unitId = "player", caster = "all", filter = "BUFF" },
                -- 伊墨苏斯的净化之缚 (智力, 触发)
                { spellID = 146046, unitId = "player", caster = "all", filter = "BUFF" },
                -- 卡德里斯的剧毒图腾 (智力, 触发)
                { spellID = 148906, unitId = "player", caster = "all", filter = "BUFF" },
                -- 亚煞极的黑暗之血 (智力, 触发)
                { spellID = 146184, unitId = "player", caster = "all", filter = "BUFF" },
                -- 狂怒水晶 (智力, 触发)
                { spellID = 148897, unitId = "player", caster = "all", filter = "BUFF" },
                -- 玉珑之噬 (爆击, 触发)
                { spellID = 146218, unitId = "player", caster = "all", filter = "BUFF" },
                -- 雷神的精准之视 (智力, 触发)
                { spellID = 138963, unitId = "player", caster = "all", filter = "BUFF" },
                -- 张叶的辉煌精华 (智力, 触发)
                { spellID = 139133, unitId = "player", caster = "all", filter = "BUFF" },
                -- 九头蛇之息 (智力, 触发)
                { spellID = 138898, unitId = "player", caster = "all", filter = "BUFF" },
                -- 乌苏雷的最终抉择 (智力, 触发)
                { spellID = 138786, unitId = "player", caster = "all", filter = "BUFF" },
                -- 影踪突袭营的烈性咒符 (急速, 触发)
                { spellID = 138703, unitId = "player", caster = "all", filter = "BUFF" },
                -- 惊怖精华 (急速, 触发)
                { spellID = 126659, unitId = "player", caster = "all", filter = "BUFF" },
                -- 宇宙之光 (智力, 触发)
                { spellID = 126577, unitId = "player", caster = "all", filter = "BUFF" },

                -- 治療
                -- 完美的活性蘑菇
                { spellID = 176978, unitId = "player", caster = "all", filter = "BUFF" },
                -- 腐蚀治疗徽章
                { spellID = 176879, unitId = "player", caster = "all", filter = "BUFF" },
                -- 元素师的屏蔽护符
                { spellID = 177063, unitId = "player", caster = "all", filter = "BUFF" },
                -- 铁刺狗玩具
                { spellID = 177060, unitId = "player", caster = "all", filter = "BUFF" },
                -- 自动修复灭菌器
                { spellID = 177086, unitId = "player", caster = "all", filter = "BUFF" },
                -- 傲慢之棱光囚笼 (智力, 触发)
                { spellID = 146314, unitId = "player", caster = "all", filter = "BUFF" },
                -- 纳兹戈林的抛光勋章 (智力, 触发)
                { spellID = 148908, unitId = "player", caster = "all", filter = "BUFF" },
                -- 索克的酸蚀之牙 (智力, 触发)
                { spellID = 148911, unitId = "player", caster = "all", filter = "BUFF" },
                -- 间歇性变异平衡器 (精神, 触发)
                { spellID = 146317, unitId = "player", caster = "all", filter = "BUFF" },
                -- 九头蛇卵的铭文袋 (吸收, 触发)
                { spellID = 140380, unitId = "player", caster = "all", filter = "BUFF" },
                -- 赫利东的垂死之息 (法力, 触发)
                { spellID = 138856, unitId = "player", caster = "all", filter = "BUFF" },
                -- 骄阳之魂 (精神, 触发)
                { spellID = 126640, unitId = "player", caster = "all", filter = "BUFF" },
                -- 秦希的偏振之印 (智力, 触发)
                { spellID = 126588, unitId = "player", caster = "all", filter = "BUFF" },

                --專業技能
                -- 神經突觸彈簧
                { spellID = 126734, unitId = "player", caster = "player", filter = "BUFF", fuzzy = true },
                -- 硝基推進器
                { spellID = 54861, unitId = "player", caster = "all", filter = "BUFF" },
                -- 降落傘
                { spellID = 55001, unitId = "player", caster = "all", filter = "BUFF" },
                -- 德萊尼煉金石
                { spellID = 60234, unitId = "player", caster = "all", filter = "BUFF" },

                --武器附魔
                -- 涓咏
                { spellID = 116660, unitId = "player", caster = "all", filter = "BUFF" },
                -- 玉魂
                { spellID = 104993, unitId = "player", caster = "all", filter = "BUFF" },
                -- 钢铁之舞
                { spellID = 120032, unitId = "player", caster = "all", filter = "BUFF" },
                -- 爆裂领主的毁灭瞄准镜
                { spellID = 109085, unitId = "player", caster = "all", filter = "BUFF" },
                -- 雷神之印
                { spellID = 159234, unitId = "player", caster = "all", filter = "BUFF" },
                -- 战歌之印
                { spellID = 159675, unitId = "player", caster = "all", filter = "BUFF" },
                -- 血环之印
                { spellID = 173322, unitId = "player", caster = "all", filter = "BUFF" },
                -- 霜狼之印
                { spellID = 159676, unitId = "player", caster = "all", filter = "BUFF" },
                -- 影月之印
                { spellID = 159678, unitId = "player", caster = "all", filter = "BUFF" },
                -- 黑石之印
                { spellID = 159679, unitId = "player", caster = "all", filter = "BUFF" },

                --藥水
                -- Draenic Agility Potion
                { spellID = 156423, unitId = "player", caster = "player", filter = "BUFF" },
                -- Draenic Intellect Potion
                { spellID = 156426, unitId = "player", caster = "player", filter = "BUFF" },
                -- Draenic Strength Potion
                { spellID = 156428, unitId = "player", caster = "player", filter = "BUFF" },
                -- Draenic Armor Potion
                { spellID = 156430, unitId = "player", caster = "player", filter = "BUFF" },
                -- 玉蛟
                { spellID = 105702, unitId = "player", caster = "player", filter = "BUFF" },
                -- 兔妖之咬
                { spellID = 105697, unitId = "player", caster = "player", filter = "BUFF" },
                -- 魔古之力
                { spellID = 105706, unitId = "player", caster = "player", filter = "BUFF" },
                -- 卡法加速
                { spellID = 125282, unitId = "player", caster = "player", filter = "BUFF" },

                --特殊buff
                -- 偷天換日
                { spellID = 57933, unitId = "player", caster = "all", filter = "BUFF" },
                -- 嗜血術
                { spellID = 2825, unitId = "player", caster = "all", filter = "BUFF" },
                -- 英勇氣概
                { spellID = 32182, unitId = "player", caster = "all", filter = "BUFF" },
                -- 時間扭曲
                { spellID = 80353, unitId = "player", caster = "all", filter = "BUFF" },
                -- 上古狂亂
                { spellID = 90355, unitId = "player", caster = "all", filter = "BUFF" },
                -- 警戒
                { spellID = 114030, unitId = "player", caster = "all", filter = "BUFF" },
                -- 群体法术反射
                { spellID = 114028, unitId = "player", caster = "all", filter = "BUFF" },
                -- 振奮咆哮
                { spellID = 97463, unitId = "player", caster = "all", filter = "BUFF" },
                -- 反魔法力场
                { spellID = 145629, unitId = "player", caster = "all", filter = "BUFF" },
                -- 犧牲聖禦
                { spellID = 6940, unitId = "player", caster = "all", filter = "BUFF" },
                -- 保護聖禦
                { spellID = 1022, unitId = "player", caster = "all", filter = "BUFF" },
                -- 虔誠光環
                { spellID = 31821, unitId = "player", caster = "all", filter = "BUFF" },
                -- 守护之魂
                { spellID = 47788, unitId = "player", caster = "all", filter = "BUFF" },
                -- 痛苦镇压
                { spellID = 33206, unitId = "player", caster = "all", filter = "BUFF" },
                -- 真言術：壁
                { spellID = 81782, unitId = "player", caster = "all", filter = "BUFF" },
                -- 吸血鬼的拥抱
                { spellID = 15286, unitId = "player", caster = "all", filter = "BUFF" },
                -- 灵魂链接图腾
                { spellID = 98008, unitId = "player", caster = "all", filter = "BUFF" },
                -- 气茧护体
                { spellID = 116849, unitId = "player", caster = "all", filter = "BUFF" },
                -- 铁木树皮
                { spellID = 102342, unitId = "player", caster = "all", filter = "BUFF" },
                -- 奔窜咆哮
                { spellID = 106898, unitId = "player", caster = "all", filter = "BUFF" },
                -- 灵狐守护
                { spellID = 172106, unitId = "player", caster = "all", filter = "BUFF" },
                -- 魔法增效
                { spellID = 159916, unitId = "player", caster = "all", filter = "BUFF" },

                --橙色多彩
                -- 不屈之源钻 (耐力, 减伤)
                { spellID = 137593, unitId = "player", caster = "all", filter = "BUFF" },
                -- 阴险之源钻 (爆击, 急速)
                { spellID = 137590, unitId = "player", caster = "all", filter = "BUFF" },
                -- 英勇之源钻 (智力, 节能)
                { spellID = 137331, unitId = "player", caster = "all", filter = "BUFF" },
                { spellID = 137247, unitId = "player", caster = "all", filter = "BUFF" },
                { spellID = 137323, unitId = "player", caster = "all", filter = "BUFF" },
                { spellID = 137326, unitId = "player", caster = "all", filter = "BUFF" },
                { spellID = 137288, unitId = "player", caster = "all", filter = "BUFF" },

                --橙色披风 
                -- 赤精之魂 (治疗)
                { spellID = 146200, unitId = "player", caster = "all", filter = "BUFF" },
                -- 雪怒之捷 (物理)
                { spellID = 146194, unitId = "player", caster = "all", filter = "BUFF" },
                -- 玉珑之精 (法系)
                { spellID = 146198, unitId = "player", caster = "all", filter = "BUFF" },
                -- 砮皂之韧 (坦克)
                { spellID = 148010, unitId = "player", caster = "all", filter = "BUFF" },

                --種族天賦
                -- 血之烈怒
                { spellID = 20572, unitId = "player", caster = "player", filter = "BUFF" },
                -- 狂暴
                { spellID = 26297, unitId = "player", caster = "player", filter = "BUFF" },
                -- 石像形态
                { spellID =  65116, unitId = "player", caster = "player", filter = "BUFF" },
                -- 疾步夜行
                { spellID =  68992, unitId = "player", caster = "player", filter = "BUFF" },
                -- 影遁
                { spellID =  58984, unitId = "player", caster = "player", filter = "BUFF" },
                -- 纳鲁的赐福
                { spellID =  28880, unitId = "player", caster = "all", filter = "BUFF" },

                --法師T16, 冰凍意念
                { spellID = 146557, unitId = "player", caster = "all", filter = "BUFF" },
                { spellID = 145252, unitId = "player", caster = "all", filter = "BUFF" },
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
                -- 冰鍊術
                { spellID = 45524, unitId = "player", caster = "all", filter = "DEBUFF" },
                -- 凍瘡
                { spellID = 50435, unitId = "player", caster = "all", filter = "DEBUFF" },

                --德魯伊
                -- 颶風術
                { spellID = 33786, unitId = "player", caster = "all", filter = "DEBUFF" },
                -- 猛力重擊
                { spellID = 5211, unitId = "player", caster = "all", filter = "DEBUFF" },
                -- 傷殘術
                { spellID = 22570, unitId = "player", caster = "all", filter = "DEBUFF" },
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
                -- 翼龍釘刺
                { spellID = 19386, unitId = "player", caster = "all", filter = "DEBUFF" },
                -- 險裡逃生
                { spellID = 136634, unitId = "player", caster = "all", filter = "DEBUFF" },
                -- 震盪射擊
                { spellID = 5116, unitId = "player", caster = "all", filter = "DEBUFF" },
                -- 凍痕
                { spellID = 61394, unitId = "player", caster = "all", filter = "DEBUFF" },
                -- 霜雷之息 (奇特奇美拉)
                { spellID = 54644, unitId = "player", caster = "all", filter = "DEBUFF" },
                -- 腳踝粉碎 (鱷魚)
                { spellID = 50433, unitId = "player", caster = "all", filter = "DEBUFF" },
                -- 時間扭曲 (扭曲巡者)
                { spellID = 35346, unitId = "player", caster = "all", filter = "DEBUFF" },
                -- 音波衝擊 (蝙蝠)
                { spellID = 50519, unitId = "player", caster = "all", filter = "DEBUFF" },

                --法師
                -- 極度冰凍
                { spellID = 44572, unitId = "player", caster = "all", filter = "DEBUFF" },
                -- 變形術
                { spellID = 118, unitId = "player", caster = "all", filter = "DEBUFF" },
                -- 霜之環
                { spellID = 82691, unitId = "player", caster = "all", filter = "DEBUFF" },
                -- 龍之吐息
                { spellID = 31661, unitId = "player", caster = "all", filter = "DEBUFF" },
                -- 霜顎
                { spellID = 102051, unitId = "player", caster = "all", filter = "DEBUFF" },
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
                -- 鐵牛衝鋒波
                { spellID = 119392, unitId = "player", caster = "all", filter = "DEBUFF" },
                -- 傷筋斷骨
                { spellID = 116706, unitId = "player", caster = "all", filter = "DEBUFF" },

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
                -- 烟雾弹
                { spellID = 88611, unitId = "player", caster = "all", filter = "BUFF" },
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
                -- 煙霧彈
                { spellID = 76577, unitId = "player", caster = "all", filter = "DEBUFF" },
                -- 擲殺
                { spellID = 26679, unitId = "player", caster = "all", filter = "DEBUFF" },
                -- 致殘毒藥
                { spellID = 3409, unitId = "player", caster = "all", filter = "DEBUFF" },

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
                -- 誘惑 (魅魔)
                { spellID = 6358, unitId = "player", caster = "all", filter = "DEBUFF" },
                -- 迷惑 (Shivarra)
                { spellID = 115268, unitId = "player", caster = "all", filter = "DEBUFF" },
                -- 痛苦動盪
                { spellID = 31117, unitId = "player", caster = "all", filter = "DEBUFF" },
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
                -- 烈焰星火
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
