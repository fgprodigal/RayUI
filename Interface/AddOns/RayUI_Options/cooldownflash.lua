local R, L, P, G = unpack(RayUI) --Import: Engine, Locales, ProfileDB, GlobalDB
local CF = R:GetModule("CooldownFlash")

R.Options.args.CooldownFlash = {
    type = "group",
    name = (CF.modName or CF:GetName()),
    order = 7,
    get = function(info)
        return R.db.CooldownFlash[ info[#info] ]
    end,
    set = function(info, value)
        R.db.CooldownFlash[ info[#info] ] = value
        StaticPopup_Show("CFG_RELOAD")
    end,
    args = {
        header = {
            type = "header",
            name = CF.modName or CF:GetName(),
            order = 1
        },
        description = {
            type = "description",
            name = CF:Info() .. "\n\n",
            order = 2
        },
        toggle = {
            type = "toggle",
            name = CF.toggleLabel or (L["启用"] .. (CF.modName or CF:GetName())),
            width = "double",
            desc = CF.Info and CF:Info() or (L["启用"] .. (CF.modName or CF:GetName())),
            order = 3,
            get = function()
                return R.db.CooldownFlash.enable ~= false or false
            end,
            set = function(info, v)
                CF.db.enable = v
                if v then
                    CF:EnableCooldownFlash()
                else
                    CF:DisableCooldownFlash()
                end
            end,
        },
        settingsHeader = {
            type = "header",
            name = L["设置"],
            order = 4,
            hidden = function() return not R.db.CooldownFlash.enable end,
        },
        iconSize = {
            order = 5,
            name = L["图标大小"],
            type = "range",
            min = 30, max = 125, step = 1,
            set = function(info, value) R.db.CooldownFlash[ info[#info] ] = value; CF.DCP:SetSize(value, value) end,
            hidden = function() return not R.db.CooldownFlash.enable end,
        },
        fadeInTime = {
            order = 6,
            name = L["淡入时间"],
            type = "range",
            min = 0, max = 2.5, step = 0.1,
            hidden = function() return not R.db.CooldownFlash.enable end,
        },
        fadeOutTime = {
            order = 7,
            name = L["淡出时间"],
            type = "range",
            min = 0, max = 2.5, step = 0.1,
            hidden = function() return not R.db.CooldownFlash.enable end,
        },
        maxAlpha = {
            order = 8,
            name = L["最大透明度"],
            type = "range",
            min = 0, max = 1, step = 0.05,
            isPercent = true,
            hidden = function() return not R.db.CooldownFlash.enable end,
        },
        holdTime = {
            order = 9,
            name = L["持续时间"],
            type = "range",
            min = 0, max = 2.5, step = 0.1,
            hidden = function() return not R.db.CooldownFlash.enable end,
        },
        animScale = {
            order = 10,
            name = L["动画大小"],
            type = "range",
            min = 0, max = 2, step = 0.1,
            hidden = function() return not R.db.CooldownFlash.enable end,
        },
        showSpellName = {
            order = 11,
            name = L["显示法术名称"],
            type = "toggle",
            hidden = function() return not R.db.CooldownFlash.enable end,
        },
        enablePet = {
            order = 12,
            name = L["监视宠物技能"],
            type = "toggle",
            get = function(info) return R.db.CooldownFlash[ info[#info] ] end,
            set = function(info, value)
                R.db.CooldownFlash[ info[#info] ] = value
                if value then
                    CF.DCP:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
                else
                    CF.DCP:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
                end
            end,
            hidden = function() return not R.db.CooldownFlash.enable end,
        },
        test = {
            order = 20,
            name = L["测试"],
            type = "execute",
            func = function()
                CF:TestMode()
            end,
            hidden = function() return not R.db.CooldownFlash.enable end,
        }
    },
}
