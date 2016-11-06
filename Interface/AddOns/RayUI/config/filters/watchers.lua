local R, L, P, G = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, GlobalDB

local positions = {
    player_buff_icon = { "BOTTOMRIGHT", "RayUF_Player", "TOPRIGHT", 0, 105 }, -- "玩家buff&debuff"
    target_buff_icon = { "BOTTOMLEFT", "RayUF_Target", "TOPLEFT", 0, 105 }, -- "目标buff&debuff"
    player_proc_icon = { "BOTTOMRIGHT", "RayUF_Player", "TOPRIGHT", 0, 60 }, -- "玩家重要buff&debuff"
    target_proc_icon = { "BOTTOMLEFT", "RayUF_Target", "TOPLEFT", 0, 60 }, -- "目标重要buff&debuff"
    focus_buff_icon = { "BOTTOMLEFT", "RayUF_Focus", "TOPLEFT", 0, 10 }, -- "焦点buff&debuff"
    cd_icon = function() return R:IsDeveloper() and { "TOPLEFT", "RayUIActionBar1", "BOTTOMLEFT", 0, -6 } or { "TOPLEFT", "RayUIActionBar3", "BOTTOMRIGHT", -28, -6 } end, -- "cd"
    player_special_icon = { "TOPRIGHT", "RayUF_Player", "BOTTOMRIGHT", 0, -9 }, -- "玩家特殊buff&debuff"
    pve_player_icon = { "BOTTOM", RayUIParent, "BOTTOM", -35, 350 }, -- "PVE/PVP玩家buff&debuff"
    pve_target_icon = { "BOTTOM", RayUIParent, "BOTTOM", 35, 350 }, -- "PVE/PVP目标buff&debuff"
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
                --回春術(萌芽)
                { spellID = 155777, unitId = "target", caster = "player", filter = "BUFF" },
            },
            {
                name = "玩家重要buff&debuff",
                direction = "LEFT",
                setpoint = positions.player_proc_icon,
                size = 38,

                --月光增效
                { spellID = 164547, unitId = "player", caster = "player", filter = "BUFF" },
                --日光增效
                { spellID = 164545, unitId = "player", caster = "player", filter = "BUFF" },
                --兇蠻咆哮
                { spellID = 52610, unitId = "player", caster = "player", filter = "BUFF" },
                --求生本能
                { spellID = 61336, unitId = "player", caster = "player", filter = "BUFF" },
                --節能施法
                { spellID = 135700, unitId = "player", caster = "player", filter = "BUFF" },
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
                --星穹大連線
                { spellID = 194223, unitId = "player", caster = "player", filter = "BUFF" },
                --化身:艾露恩之眷
                { spellID = 102560, unitId = "player", caster = "player", filter = "BUFF" },
                --化身:丛林之王
                { spellID = 102543, unitId = "player", caster = "player", filter = "BUFF" },
                --猛虎之怒
                { spellID = 5217, unitId = "player", caster = "player", filter = "BUFF" },
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
                --化身:乌索克之子
                { spellID = 102558, unitId = "player", caster = "player", filter = "BUFF" },
                --巨熊之力
                { spellID = 159233, unitId = "player", caster = "player", filter = "BUFF" },
                --伊露恩的守護者
                { spellID = 213680, unitId = "player", caster = "player", filter = "BUFF" },
                --鋼鐵毛皮
                { spellID = 192081, unitId = "player", caster = "player", filter = "BUFF" },
                --烏索爾的印記
                { spellID = 192083, unitId = "player", caster = "player", filter = "BUFF" },
                --伊露恩戰士
                { spellID = 202425, unitId = "player", caster = "player", filter = "BUFF" },
                --安希之賜
                { spellID = 202739, unitId = "player", caster = "player", filter = "BUFF" },
                --伊露恩的祝福
                { spellID = 202737, unitId = "player", caster = "player", filter = "BUFF" },
                --化身:生命之树
                { spellID = 117679, unitId = "player", caster = "player", filter = "BUFF" },
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

                --傷殘術
                { spellID = 203123, unitId = "target", caster = "player", filter = "DEBUFF" },
                --斜掠
                { spellID = 155722, unitId = "target", caster = "player", filter = "DEBUFF" },
                --痛击
                { spellID = 77758, unitId = "target", caster = "player", filter = "DEBUFF" },
                --痛击（豹）
                { spellID = 106830, unitId = "target", caster = "player", filter = "DEBUFF" },
                --星光閃焰
                { spellID = 202347, unitId = "target", caster = "player", filter = "DEBUFF" },
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
            },
        },
        ["HUNTER"] = {
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
                --宠物顺劈斩
                { spellID = 118455, unitId = "pet", caster = "player", filter = "BUFF" },
                --連環火網
                { spellID = 82921, unitId = "player", caster = "player", filter = "BUFF" },
                --狂亂效果
                { spellID = 19615, unitId = "pet", caster = "pet", filter = "BUFF" },
                --4T13
                { spellID = 105919, unitId = "player", caster = "player", filter = "BUFF" },
                --稳固集中
                { spellID = 193534, unitId = "player", caster = "player", filter = "BUFF" },

                --野性守護
                { spellID = 193530, unitId = "player", caster = "player", filter = "BUFF" },
                --箭雨
                { spellID = 194386, unitId = "player", caster = "player", filter = "BUFF" },
                --獵豹守護
                { spellID = 186257, unitId = "player", caster = "player", filter = "BUFF" },
                --獵豹守護
                { spellID = 186258, unitId = "player", caster = "player", filter = "BUFF" },
                --標記目標
                { spellID = 223138, unitId = "player", caster = "player", filter = "BUFF" },
                --特技射擊
                { spellID = 227272, unitId = "player", caster = "player", filter = "BUFF" },
                --强擊
                { spellID = 193526, unitId = "player", caster = "player", filter = "BUFF" },
                --摩克納薩爾之道
                { spellID = 201081, unitId = "player", caster = "player", filter = "BUFF" },
                --貓鼬撕咬
                { spellID = 190931, unitId = "player", caster = "player", filter = "BUFF" },

                --擊殺命令
                { spellID = 34026, filter = "CD" },
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
                --黑鸦
                { spellID = 131894, unitId = "target", caster = "player", filter = "DEBUFF" },
                --獵人印記
                { spellID = 185365, unitId = "target", caster = "player", filter = "DEBUFF" },
                --割裂
                { spellID = 185855, unitId = "target", caster = "player", filter = "DEBUFF" },

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
                --爆炸陷阱
                { spellID = 13813, filter = "CD" },
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
                --强擊
                { spellID = 193526, filter = "CD" },
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
                { spellID = 190446, unitId = "player", caster = "player", filter = "BUFF" },
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
                --燃灼
                { spellID = 190319, unitId = "player", caster = "player", filter = "BUFF" },
                --浮冰
                { spellID = 108839, unitId = "player", caster = "player", filter = "BUFF" },
                --秘法加速
                { spellID = 198924, unitId = "player", caster = "player", filter = "BUFF" },
                --冰刺
                { spellID = 199844, unitId = "player", caster = "player", filter = "BUFF" },

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
                --唤醒
                { spellID = 12051, filter = "CD" },
                --秘法強化
                { spellID = 12042, filter = "CD" },
                --急速冷卻
                { spellID = 11958, filter = "CD" },
                --冰寒脈動
                { spellID = 12472, filter = "CD" },
                --寒冰屏障
                { spellID = 45438, filter = "CD" },
                --冰霜之球
                { spellID = 84714, filter = "CD" },
                --燃燒吧
                { spellID = 205029, filter = "CD" },
                --燃灼
                { spellID = 190319, filter = "CD" },
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

                --不屈打擊
                { spellID = 169686, unitId = "player", caster = "player", filter = "BUFF" },
                --驟亡
                { spellID = 52437, unitId = "player", caster = "player", filter = "BUFF" },
                --狂暴之怒
                { spellID = 18499, unitId = "player", caster = "player", filter = "BUFF" },
                --魯莽
                { spellID = 1719, unitId = "player", caster = "player", filter = "BUFF" },
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
                --死亡裁决
                { spellID = 144442, unitId = "player", caster = "player", filter = "BUFF" },
                --最后通牒
                { spellID = 122510, unitId = "player", caster = "player", filter = "BUFF" },
                --剑在人在
                { spellID = 118038, unitId = "player", caster = "player", filter = "BUFF" },
                --復仇
                { spellID = 202574, unitId = "player", caster = "player", filter = "BUFF" },
                --復仇
                { spellID = 202573, unitId = "player", caster = "player", filter = "BUFF" },
                --集中怒氣（防禦）
                { spellID = 204488, unitId = "player", caster = "player", filter = "BUFF" },
                --集中怒氣（武器）
                { spellID = 207982, unitId = "player", caster = "player", filter = "BUFF" },
                --破壞鐵球
                { spellID = 215570, unitId = "player", caster = "player", filter = "BUFF" },
                --激怒
                { spellID = 184362, unitId = "player", caster = "player", filter = "BUFF" },
                --壓制
                { spellID = 60503, unitId = "player", caster = "player", filter = "BUFF" },
                --天神下凡
                { spellID = 107574, unitId = "player", caster = "player", filter = "BUFF" },
                --无视苦痛
                { spellID = 190456, unitId = "player", caster = "player", filter = "BUFF" },
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
                { spellID = 208086, unitId = "target", caster = "player", filter = "DEBUFF" },
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
            },
        },
        ["SHAMAN"] = {
            {
                name = "玩家buff&debuff",
                direction = "LEFT",
                setpoint = positions.player_buff_icon,
                size = 28,

                --治疗之雨
                { spellID = 73920, unitId = "player", caster = "player", filter = "BUFF" },
                -- 石拳（山崩省略）
                { spellID = 218825, unitId = "player", caster = "player", filter = "BUFF" },

            },
            {
                name = "目标buff&debuff",
                direction = "RIGHT",
                setpoint = positions.target_buff_icon,
                size = 28,

                --冰霜震击
                { spellID = 196840, unitId = "target", caster = "player", filter = "DEBUFF" },
                --引雷针
                { spellID = 197209, unitId = "target", caster = "player", filter = "DEBUFF" },
                --陷地图腾(可能不好用)
                { spellID = 64695, unitId = "target", caster = "all", filter = "DEBUFF" },

            },
            {
                name = "玩家重要buff&debuff",
                direction = "LEFT",
                setpoint = positions.player_proc_icon,
                size = 38,

                -- 冰怒
                { spellID = 210714, unitId = "player", caster = "player", filter = "BUFF" },
                -- 熔岩奔腾
                { spellID = 77762, unitId = "player", caster = "player", filter = "BUFF" },
                -- 治療之潮
                { spellID = 53390, unitId = "player", caster = "player", filter = "BUFF" },
                -- 卓越術
                { spellID = 114052, unitId = "player", caster = "player", filter = "BUFF" },
                -- 星界轉移
                { spellID = 108271, unitId = "player", caster = "player", filter = "BUFF" },
                -- 升腾
                { spellID = 114050, unitId = "player", caster = "player", filter = "BUFF" },
                -- 先祖指引
                { spellID = 108281, unitId = "player", caster = "player", filter = "BUFF" },
                -- 元素掌握
                { spellID = 16166, unitId = "player", caster = "player", filter = "BUFF" },
                -- 灵魂行者的恩赐
                { spellID = 79206, unitId = "player", caster = "player", filter = "BUFF" },
                -- 激流
                { spellID = 61295, unitId = "player", caster = "player", filter = "BUFF" },
                -- 火舌
                { spellID = 194084, unitId = "player", caster = "player", filter = "BUFF" },
                -- 风歌
                { spellID = 201898, unitId = "player", caster = "player", filter = "BUFF" },
                -- 风暴使者
                { spellID = 201846, unitId = "player", caster = "player", filter = "BUFF" },
                -- 毁灭之风
                { spellID = 204945, unitId = "player", caster = "player", filter = "BUFF" },
                -- 冰封
                { spellID = 196834, unitId = "player", caster = "player", filter = "BUFF" },
                -- 漩涡之力
                { spellID = 191877, unitId = "player", caster = "player", filter = "BUFF" },
                -- 风暴守护者
                { spellID = 205495, unitId = "player", caster = "player", filter = "BUFF" },
                -- 女王的崛起
                { spellID = 207288, unitId = "player", caster = "player", filter = "BUFF" },

            },
            {
                name = "目标重要buff&debuff",
                direction = "RIGHT",
                setpoint = positions.target_proc_icon,
                size = 38,

                --Hex / Verhexen
                { spellID = 51514, unitId = "target", caster = "all", filter = "DEBUFF" },
                --烈焰震击
                { spellID = 188389, unitId = "target", caster = "player", filter = "DEBUFF" },
                --烈焰震击（治疗）
                { spellID = 188838, unitId = "target", caster = "player", filter = "DEBUFF" },
                --Riptide / Springflut
                { spellID = 61295, unitId = "target", caster = "player", filter = "BUFF" },
                --地震术
                { spellID = 182387, unitId = "target", caster = "player", filter = "DEBUFF" },

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
                -- 烈焰震击
                { spellID = 188389, unitId = "target", caster = "player", filter = "DEBUFF" },
                -- 烈焰震击（治疗）
                { spellID = 188838, unitId = "target", caster = "player", filter = "DEBUFF" },

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
                { spellID = 198067, filter = "CD" },
                --土元素圖騰
                { spellID = 198103, filter = "CD" },
                --升腾
                { spellID = 114050, filter = "CD" },
                --岩浆图腾
                { spellID = 192222, filter = "CD" },
                -- 野性狼魂
                { spellID = 51533, filter = "CD" },
                -- 毁灭之风
                { spellID = 204945, filter = "CD" },
                -- 女王的恩赐
                { spellID = 207778, filter = "CD" },
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
                --永恒之火
                { spellID = 114163, unitId = "target", caster = "player", filter = "BUFF" },

                --虔信信標
                { spellID = 156910, unitId = "target", caster = "player", filter = "BUFF" },
            },
            {
                name = "玩家重要buff&debuff",
                direction = "LEFT",
                setpoint = positions.player_proc_icon,
                size = 38,

                --神恩術
                { spellID = 31842, unitId = "player", caster = "player", filter = "BUFF" },
                --神圣复仇者
                { spellID = 105809, unitId = "player", caster = "player", filter = "BUFF" },
                --聖光灌注
                { spellID = 54149, unitId = "player", caster = "player", filter = "BUFF" },
                --聖佑術
                { spellID = 498, unitId = "player", caster = "player", filter = "BUFF" },
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
                --大十字軍
                { spellID = 85416, unitId = "player", caster = "player", filter = "BUFF" },
                --遠古諸王守護者
                { spellID = 86659, unitId = "player", caster = "all", filter = "BUFF" },

                --十字軍
                { spellID = 224668, unitId = "player", caster = "player", filter = "BUFF" },
                --正義怒火
                { spellID = 209785, unitId = "player", caster = "player", filter = "BUFF" },
                --以眼還眼
                { spellID = 205191, unitId = "player", caster = "player", filter = "BUFF" },
                --神圣意圖
                { spellID = 216413, unitId = "player", caster = "player", filter = "BUFF" },
                --熾熱殉難者
                { spellID = 223316, unitId = "player", caster = "player", filter = "BUFF" },
            },
            {
                name = "目标重要buff&debuff",
                direction = "RIGHT",
                setpoint = positions.target_proc_icon,
                size = 38,

                --制裁之錘
                { spellID = 853, unitId = "target", caster = "all", filter = "DEBUFF" },
                --自律
                { spellID = 25771, unitId = "target", caster = "all", filter = "DEBUFF" },
                --公正聖印
                { spellID = 20170, unitId = "target", caster = "player", filter = "DEBUFF" },

                --審判
                { spellID = 197277, unitId = "target", caster = "player", filter = "DEBUFF" },
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
                --神聖憤怒
                { spellID = 210220, filter = "CD" },
                --聖盾術
                { spellID = 642, filter = "CD" },
                --復仇之怒
                { spellID = 31884, filter = "CD" },
                --復仇之怒（奶騎）
                { spellID = 31842, filter = "CD" },
                --神圣复仇者
                { spellID = 105809, filter = "CD" },
                --遠古諸王守護者
                { spellID = 86659, filter = "CD" },
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

                --身心合一
                { spellID = 65081, unitId = "player", caster = "all", filter = "BUFF" },
                --身心合一（神牧）
                { spellID = 214121, unitId = "player", caster = "all", filter = "BUFF" },
                --天使之羽
                { spellID = 121557, unitId = "player", caster = "all", filter = "BUFF" },
                --幻影術
                { spellID = 114239, unitId = "player", caster = "player", filter = "BUFF" },
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

                --救贖
                { spellID = 194384, unitId = "target", caster = "player", filter = "BUFF" },
            },
            {
                name = "玩家重要buff&debuff",
                direction = "LEFT",
                setpoint = positions.player_proc_icon,
                size = 38,

                --影散
                { spellID = 47585, unitId = "player", caster = "player", filter = "BUFF" },

                --暗影强化(4T16)
                { spellID = 145180, unitId = "player", caster = "player", filter = "BUFF" },
                --鬼魅幻影
                { spellID = 119032, unitId = "player", caster = "player", filter = "BUFF" },
                --光之澎湃
                { spellID = 114255, unitId = "player", caster = "player", filter = "BUFF" },
                --黑暗奔騰
                { spellID = 87160, unitId = "player", caster = "player", filter = "BUFF" },
                --命運無常
                { spellID = 123254, unitId = "player", caster = "player", filter = "BUFF" },
                --注入能量
                { spellID = 10060, unitId = "player", caster = "player", filter = "BUFF" },

                --幽暗洞察
                { spellID = 124430, unitId = "player", caster = "player", filter = "BUFF" },
                --精神護罩
                { spellID = 109964, unitId = "player", caster = "player", filter = "BUFF" },

                --狂喜
                { spellID = 47536, unitId = "player", caster = "player", filter = "BUFF" },
                --希望象徵
                { spellID = 64901, unitId = "player", caster = "player", filter = "BUFF" },
                --神化
                { spellID = 200183, unitId = "player", caster = "player", filter = "BUFF" },
                --聖潔
                { spellID = 197030, unitId = "player", caster = "player", filter = "BUFF" },
                --瘋狂殘念
                { spellID = 197937, unitId = "player", caster = "player", filter = "BUFF" },
                --虛空射綫
                { spellID = 205372, unitId = "player", caster = "player", filter = "BUFF" },
                --虚空形态
                { spellID = 194249, unitId = "player", caster = "player", filter = "BUFF" },
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
                --心靈炸彈
                { spellID = 226943, unitId = "target", caster = "all", filter = "DEBUFF" },
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

                --狂喜
                { spellID = 47536, filter = "CD" },
                --希望象徵
                { spellID = 64901, filter = "CD" },
                --神化
                { spellID = 200183, filter = "CD" },
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
                --爆燃冲刺
                { spellID = 111400, unitId = "player", caster = "player", filter = "BUFF" },
                --魔典：恶魔牺牲
                { spellID = 196099, unitId = "player", caster = "player", filter = "BUFF" },
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

                --灵魂交换
                { spellID = 86211, unitId = "player", caster = "player", filter = "BUFF" },
                --灵魂收割
                { spellID = 196098, unitId = "player", caster = "player", filter = "BUFF" },
                --协同魔典
                { spellID = 171982, unitId = "player", caster = "all", filter = "BUFF" },
                --炽燃之怒(2T16)
                { spellID = 145085, unitId = "player", caster = "player", filter = "BUFF" },
                --爆燃
                { spellID = 117828, unitId = "player", caster = "player", filter = "BUFF" },
                --浩劫
                { spellID = 80240, unitId = "player", caster = "player", filter = "BUFF" },
                --不灭决心
                { spellID = 104773, unitId = "player", caster = "player", filter = "BUFF" },
                --恶魔箭
                { spellID = 157695, unitId = "player", caster = "player", filter = "DEBUFF" },
                --法力分流
                { spellID = 196104, unitId = "player", caster = "player", filter = "BUFF" },
                --暗影启迪
                { spellID = 196606, unitId = "player", caster = "player", filter = "BUFF" },
                --魔性征召
                { spellID = 205146, unitId = "player", caster = "player", filter = "BUFF" },
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
                --生命虹吸
                { spellID = 63106, unitId = "target", caster = "player", filter = "DEBUFF" },
                --诡异魅影
                { spellID = 205179, unitId = "target", caster = "player", filter = "DEBUFF" },
                --暗影烈焰
                { spellID = 205181, unitId = "target", caster = "player", filter = "DEBUFF" },
                --暗影烈焰
                { spellID = 196414, unitId = "target", caster = "player", filter = "DEBUFF" },
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

            },
        },
        ["ROGUE"] = {
            {
                name = "玩家buff&debuff",
                direction = "LEFT",
                setpoint = positions.player_buff_icon,
                size = 28,

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
                --還擊
                { spellID = 199754, unitId = "player", caster = "player", filter = "BUFF" },
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

                --剑刃乱舞
                { spellID = 13877, unitId = "player", caster = "player", filter = "BUFF" },
                --佯攻
                { spellID = 1966, unitId = "player", caster = "player", filter = "BUFF" },
                --暗影之舞
                { spellID = 185422, unitId = "player", caster = "player", filter = "BUFF" },
                --敏銳大師
                { spellID = 31665, unitId = "player", caster = "player", filter = "BUFF" },
                --毀滅者之怒
                { spellID = 109949, unitId = "player", caster = "player", filter = "BUFF" },
                --狂舞殘殺
                { spellID = 51690, unitId = "player", caster = "player", filter = "BUFF" },
                --毒藥師
                { spellID = 145249, unitId = "player", caster = "player", filter = "BUFF" },
                --欺敵
                { spellID = 115192, unitId = "player", caster = "player", filter = "BUFF" },

                --絕對方位
                { spellID = 193359, unitId = "player", caster = "player", filter = "BUFF" },
                --絕地寶藏
                { spellID = 199600, unitId = "player", caster = "player", filter = "BUFF" },
                --大好機會
                { spellID = 195627, unitId = "player", caster = "player", filter = "BUFF" },
                --側舷截擊
                { spellID = 193356, unitId = "player", caster = "player", filter = "BUFF" },
                --黑旗
                { spellID = 199603, unitId = "player", caster = "player", filter = "BUFF" },
                --大亂鬥
                { spellID = 193358, unitId = "player", caster = "player", filter = "BUFF" },
                --兇鯊海域
                { spellID = 193357, unitId = "player", caster = "player", filter = "BUFF" },
                --赤紅藥瓶
                { spellID = 185311, unitId = "player", caster = "player", filter = "BUFF" },
                --死亡徵兆
                { spellID = 212283, unitId = "player", caster = "player", filter = "BUFF" },
                --暗影之刃
                { spellID = 121471, unitId = "player", caster = "player", filter = "BUFF" },
                --矯捷
                { spellID = 193538, unitId = "player", caster = "player", filter = "BUFF" },
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
                --正中眉心
                { spellID = 199804, unitId = "target", caster = "all", filter = "DEBUFF" },
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
                --宿怨
                { spellID = 79140, unitId = "target", caster = "player", filter = "DEBUFF" },
                --出血
                { spellID = 16511, unitId = "target", caster = "player", filter = "DEBUFF" },
                --找尋弱點
                { spellID = 91021, unitId = "target", caster = "player", filter = "DEBUFF" },
                --制裁之錘
                { spellID = 853, unitId = "target", caster = "all", filter = "DEBUFF" },
                --暗影反射
                { spellID = 156745, unitId = "target", caster = "player", filter = "DEBUFF" },
                --夜刃
                { spellID = 195452, unitId = "target", caster = "player", filter = "DEBUFF" },
                --鬼魅攻击
                { spellID = 196937, unitId = "target", caster = "player", filter = "DEBUFF" },
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
                --疾跑
                { spellID = 2983, filter = "CD" },
                --斗篷
                { spellID = 31224, filter = "CD" },
                --闪避
                { spellID = 5277, filter = "CD" },
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
                { spellID = 195181, unitId = "player", caster = "player", filter = "BUFF" },
                --冰霜之柱
                { spellID = 51271, unitId = "player", caster = "player", filter = "BUFF" },
                --血魄之鏡
                { spellID = 206977, unitId = "player", caster = "player", filter = "BUFF" },
                --黑暗救贖
                { spellID = 101568, unitId = "player", caster = "player", filter = "BUFF" },
                --黑暗變身
                { spellID = 63560, unitId = "pet", caster = "player", filter = "BUFF" },

                --滅體抹殺
                { spellID = 207256, unitId = "player", caster = "player", filter = "BUFF" },
                --靈魂收割者（加速）
                { spellID = 215711, unitId = "player", caster = "player", filter = "BUFF" },
                --冰結之爪
                { spellID = 194879, unitId = "player", caster = "player", filter = "BUFF" },

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
                --膿瘡傷口
                { spellID = 194310, unitId = "target", caster = "player", filter = "DEBUFF" },
                --冰霜熱疫
                { spellID = 55095, unitId = "target", caster = "player", filter = "DEBUFF" },
                --召喚石像鬼
                { spellID = 49206, unitId = "target", caster = "player", filter = "DEBUFF" },
                --死亡凋零
                { spellID = 43265, unitId = "target", caster = "player", filter = "DEBUFF" },
                --惡性瘟疫
                { spellID = 191587, unitId = "target", caster = "player", filter = "DEBUFF" },
                --靈魂收割者
                { spellID = 130736, unitId = "target", caster = "player", filter = "DEBUFF" },
                --血魄印記
                { spellID = 206940, unitId = "target", caster = "player", filter = "DEBUFF" },
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

                --滅體抹殺
                { spellID = 207256, filter = "CD" },
                --符文武器
                { spellID = 47568, filter = "CD" },
            },
        },
        ["MONK"] = {
            {
                name = "玩家buff&debuff",
                direction = "LEFT",
                setpoint = positions.player_buff_icon,
                size = 28,

                --回生迷霧
                { spellID = 119611, unitId = "player", caster = "player", filter = "BUFF" },
                --舒和之霧
                { spellID = 115175, unitId = "player", caster = "player", filter = "BUFF" },
                --酒仙小緩勁
                { spellID = 124275, unitId = "player", caster = "all", filter = "DEBUFF" },
                --酒仙中緩勁
                { spellID = 124274, unitId = "player", caster = "all", filter = "DEBUFF" },
                --酒仙大緩勁
                { spellID = 124273, unitId = "player", caster = "all", filter = "DEBUFF" },

            },
            {
                name = "目标buff&debuff",
                direction = "RIGHT",
                setpoint = positions.target_buff_icon,
                size = 28,

                --回生迷霧
                { spellID = 119611, unitId = "target", caster = "player", filter = "BUFF" },
                --舒和之霧
                { spellID = 115175, unitId = "target", caster = "player", filter = "BUFF" },
            },
            {
                name = "玩家重要buff&debuff",
                direction = "LEFT",
                setpoint = positions.player_proc_icon,
                size = 38,

                --禪心玉
                { spellID = 124081, unitId = "player", caster = "player", filter = "BUFF" },
                --石形絕釀
                { spellID = 120954, unitId = "player", caster = "player", filter = "BUFF" },

                --乾坤挪移
                { spellID = 125174, unitId = "player", caster = "player", filter = "BUFF" },
                --禪院教誨
                { spellID = 202090, unitId = "player", caster = "player", filter = "BUFF" },
                --連段破:滅寂腿
                { spellID = 116768, unitId = "player", caster = "player", filter = "BUFF" },

                --连击
                { spellID = 196741, unitId = "player", caster = "player", filter = "BUFF" },
                --风火大地
                { spellID = 137639, unitId = "player", caster = "player", filter = "BUFF" },
                --冰心诀
                { spellID = 152173, unitId = "player", caster = "player", filter = "BUFF" },
                --聚雷茶
                { spellID = 116680, unitId = "player", caster = "player", filter = "BUFF" },
                --生生不息
                { spellID = 197919, unitId = "player", caster = "player", filter = "BUFF" },
                --生生不息
                { spellID = 197916, unitId = "player", caster = "player", filter = "BUFF" },
                --法力茶
                { spellID = 197908, unitId = "player", caster = "player", filter = "BUFF" },
                --金鐘絕釀
                { spellID = 215479, unitId = "player", caster = "player", filter = "BUFF" },

            },
            {
                name = "目标重要buff&debuff",
                direction = "RIGHT",
                setpoint = positions.target_proc_icon,
                size = 38,

                --掃葉腿
                { spellID = 119381, unitId = "target", caster = "player", filter = "DEBUFF" },
                --幽冥掌
                { spellID = 115080, unitId = "target", caster = "player", filter = "DEBUFF" },
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
            },
        },
        ["DEMONHUNTER"] = {
            {
                name = "玩家buff&debuff",
                direction = "LEFT",
                setpoint = positions.player_buff_icon,
                size = 28,

                -- 献祭光环
                { spellID = 178740, unitId = "player", caster = "player", filter = "BUFF" },
                -- 幽灵视觉
                { spellID = 188501, unitId = "player", caster = "player", filter = "BUFF" },
                -- 黑暗
                { spellID = 209426, unitId = "player", caster = "all", filter = "BUFF" },
            },
            {
                name = "目标buff&debuff",
                direction = "RIGHT",
                setpoint = positions.target_buff_icon,
                size = 28,

                -- 烈焰咒符
                { spellID = 204598, unitId = "target", caster = "player", filter = "DEBUFF" },
            },
            {
                name = "玩家重要buff&debuff",
                direction = "LEFT",
                setpoint = positions.player_proc_icon,
                size = 38,

                -- 恶魔变形（浩劫）
                { spellID = 187827, unitId = "player", caster = "player", filter = "BUFF" },
                -- 恶魔变形（复仇）
                { spellID = 162264, unitId = "player", caster = "player", filter = "BUFF" },
                -- 强化结界
                { spellID = 218256, unitId = "player", caster = "player", filter = "BUFF" },
                -- 恶魔尖刺
                { spellID = 203819, unitId = "player", caster = "player", filter = "BUFF" },
                -- 势如破竹
                { spellID = 208628, unitId = "player", caster = "player", filter = "BUFF" },
            },
            {
                name = "目标重要buff&debuff",
                direction = "RIGHT",
                setpoint = positions.target_proc_icon,
                size = 38,

                -- 悲苦咒符
                { spellID = 207685, unitId = "target", caster = "all", filter = "DEBUFF" },
                -- 烈火烙印
                { spellID = 207744, unitId = "target", caster = "player", filter = "DEBUFF" },
                -- 血滴子
                { spellID = 207690, unitId = "target", caster = "player", filter = "DEBUFF" },
            },
            {
                name = "焦点buff&debuff",
                direction = "UP",
                setpoint = positions.focus_buff_icon,
                size = 24,
                mode = "BAR",
                iconSide = "LEFT",
                barWidth = 170,

                -- 悲苦咒符
                { spellID = 207685, unitId = "focus", caster = "all", filter = "DEBUFF" },
            },
            {
                name = "CD",
                iconSide = "LEFT",
                size = 28,
                barWidth = 170,
                direction = function() return R:IsDeveloper() and "RIGHT" or "DOWN" end,
                mode = function() return R:IsDeveloper() and "ICON" or "BAR" end,
                setpoint = positions.cd_icon,

                -- 恶魔变形（浩劫）
                { spellID = 187827, filter = "CD" },
                -- 恶魔变形（复仇）
                { spellID = 191427, filter = "CD" },
                -- 强化结界
                { spellID = 218256, filter = "CD" },
                -- 悲苦符咒
                { spellID = 207684, filter = "CD" },
                -- 烈火烙印
                { spellID = 204021, filter = "CD" },
                -- 幻影打击
                { spellID = 196718, filter = "CD" },
            },
        },
        ["ALL"]={
            {
                name = "玩家特殊buff&debuff",
                direction = "LEFT",
                setpoint = positions.player_special_icon,
                size = 38,

                --專業技能
                -- 硝基推進器
                { spellID = 54861, unitId = "player", caster = "all", filter = "BUFF" },
                -- 降落傘
                { spellID = 55001, unitId = "player", caster = "all", filter = "BUFF" },
                -- 德萊尼煉金石
                { spellID = 60234, unitId = "player", caster = "all", filter = "BUFF" },

                --藥水
                -- Draenic Agility Potion
                { spellID = 156423, unitId = "player", caster = "player", filter = "BUFF" },
                -- Draenic Intellect Potion
                { spellID = 156426, unitId = "player", caster = "player", filter = "BUFF" },
                -- Draenic Strength Potion
                { spellID = 156428, unitId = "player", caster = "player", filter = "BUFF" },
                -- Draenic Armor Potion
                { spellID = 156430, unitId = "player", caster = "player", filter = "BUFF" },

                --特殊buff
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

                --種族天賦
                -- 血之烈怒
                { spellID = 20572, unitId = "player", caster = "player", filter = "BUFF" },
                -- 狂暴
                { spellID = 26297, unitId = "player", caster = "player", filter = "BUFF" },
                -- 石像形态
                { spellID = 65116, unitId = "player", caster = "player", filter = "BUFF" },
                -- 疾步夜行
                { spellID = 68992, unitId = "player", caster = "player", filter = "BUFF" },
                -- 影遁
                { spellID = 58984, unitId = "player", caster = "player", filter = "BUFF" },
                -- 纳鲁的赐福
                { spellID = 28880, unitId = "player", caster = "all", filter = "BUFF" },
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
                -- 絞殺
                { spellID = 47476, unitId = "player", caster = "all", filter = "DEBUFF" },
                -- 黑暗幻象
                { spellID = 77606, unitId = "player", caster = "all", filter = "DEBUFF" },
                -- 冰鍊術
                { spellID = 45524, unitId = "player", caster = "all", filter = "DEBUFF" },

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
                -- 糾纏根鬚
                { spellID = 339, unitId = "player", caster = "all", filter = "DEBUFF" },
                -- 無法移動
                { spellID = 45334, unitId = "player", caster = "all", filter = "DEBUFF" },
                -- 感染之傷
                { spellID = 58180, unitId = "player", caster = "all", filter = "DEBUFF" },
                -- 颱風
                { spellID = 61391, unitId = "player", caster = "all", filter = "DEBUFF" },

                --獵人
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
                -- 霜雷之息 (奇特奇美拉)
                { spellID = 54644, unitId = "player", caster = "all", filter = "DEBUFF" },
                -- 腳踝粉碎 (鱷魚)
                { spellID = 50433, unitId = "player", caster = "all", filter = "DEBUFF" },
                -- 時間扭曲 (扭曲巡者)
                { spellID = 35346, unitId = "player", caster = "all", filter = "DEBUFF" },

                --法師
                -- 變形術
                { spellID = 118, unitId = "player", caster = "all", filter = "DEBUFF" },
                -- 霜之環
                { spellID = 82691, unitId = "player", caster = "all", filter = "DEBUFF" },
                -- 龍之吐息
                { spellID = 31661, unitId = "player", caster = "all", filter = "DEBUFF" },
                -- 冰凍術 (水元素)
                { spellID = 33395, unitId = "player", caster = "all", filter = "DEBUFF" },
                -- 冰霜新星
                { spellID = 122, unitId = "player", caster = "all", filter = "DEBUFF" },
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
                -- 傷筋斷骨
                { spellID = 116706, unitId = "player", caster = "all", filter = "DEBUFF" },

                --聖騎士
                -- 制裁之錘
                { spellID = 853, unitId = "player", caster = "all", filter = "DEBUFF" },
                -- 懺悔
                { spellID = 20066, unitId = "player", caster = "all", filter = "DEBUFF" },
                -- 盲目之光
                { spellID = 105421, unitId = "player", caster = "all", filter = "DEBUFF" },
                -- 復仇之盾
                { spellID = 31935, unitId = "player", caster = "all", filter = "DEBUFF" },

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
                -- 衝鋒昏迷
                { spellID = 7922, unitId = "player", caster = "all", filter = "DEBUFF" },

                --種族天賦
                -- 戰爭踐踏
                { spellID = 20549, unitId = "player", caster = "all", filter = "DEBUFF" },
                -- 震動掌
                { spellID = 107079, unitId = "player", caster = "all", filter = "DEBUFF" },
                -- 奧流之術
                { spellID = 28730, unitId = "player", caster = "all", filter = "DEBUFF" },

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
