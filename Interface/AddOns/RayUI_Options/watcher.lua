local R, L, P, G = unpack(RayUI) --Import: Engine, Locales, ProfileDB, GlobalDB
local RW = R:GetModule("Watcher")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")

local selectedGroup = nil
local selectedSpell = nil
local selectedBuff = nil
local selectedDebuff = nil
local selectedCooldown = nil
local selectedItemCooldown = nil

local function SaveProfileKey(key, value)
    if not selectedGroup and not selectedSpell then return end
    R.global.Watcher = R.global.Watcher or {}
    R.global.Watcher[selectedGroup] = R.global.Watcher[selectedGroup] or {}
    R.global.Watcher[selectedGroup][selectedSpell.filter] = R.global.Watcher[selectedGroup][selectedSpell.filter] or {}
    R.global.Watcher[selectedGroup][selectedSpell.filter][selectedSpell.spellID] = R.global.Watcher[selectedGroup][selectedSpell.filter][selectedSpell.spellID] or {}
    R.global.Watcher[selectedGroup][selectedSpell.filter][selectedSpell.spellID][key] = value
end

local function UpdateInput(id, filter)
    if not RW.modules[selectedGroup][filter][id] then
        id = select(7,GetSpellInfo(id))
    end
    selectedSpell.isNew = nil
    selectedSpell = RW.modules[selectedGroup][filter][id]
    selectedSpell.spellID = tonumber(id)
    selectedSpell.filter = filter
end

local function UpdateGroup()
    if not selectedGroup then
        R.Options.args.Watcher.args.filterGroup = nil
        return
    end

    R.Options.args.Watcher.args.filterGroup = {
        type = "group",
        name = selectedGroup,
        guiInline = true,
        order = 10,
        hidden = function() return not R.db.Watcher.enable end,
        args = {
            disabled = {
                type = 'toggle',
                name = L["启用该组"],
                order = 7,
                set = function(info, value)
                    RW.modules[selectedGroup].enable = value
                    if RW.modules[selectedGroup].enable then
                        RW.modules[selectedGroup]:Enable()
                    else
                        RW.modules[selectedGroup]:Disable()
                    end
                    R.global.Watcher = R.global.Watcher or {}
                    R.global.Watcher[selectedGroup] = R.global.Watcher[selectedGroup] or {}
                    R.global.Watcher[selectedGroup].enable = value
                end,
                get = function()
                    return RW.modules[selectedGroup].enable
                end,
                disabled = function(info) return not selectedGroup end,
            },
            spacer = {
                type = 'description',
                name = '',
                desc = '',
                order = 8,
            },
            mode = {
                order = 9,
                name = L["模式"],
                set = function(info, value)
                    RW.modules[selectedGroup].mode = value
                    RW.modules[selectedGroup].mode = value
                    RW.modules[selectedGroup]:ApplyStyle()
                    RW.modules[selectedGroup].direction = RW.modules[selectedGroup].direction
                    RW.modules[selectedGroup].barwidth = RW.modules[selectedGroup].barwidth
                end,
                get = function() return (RW.modules[selectedGroup].mode or "ICON") end,
                disabled = function(info) return not RW.modules[selectedGroup].enable end,
                type = "select",
                values = {
                    ["ICON"] = L["图标"],
                    ["BAR"] = L["计时条"],
                },
            },
            direction = {
                order = 11,
                name = L["增长方向"],
                set = function(info, value)
                    RW.modules[selectedGroup].direction = value
                    RW.modules[selectedGroup].direction = value
                    RW.modules[selectedGroup]:ApplyStyle()
                end,
                get = function() return RW.modules[selectedGroup].direction end,
                disabled = function(info) return not RW.modules[selectedGroup].enable end,
                type = "select",
                values = function()
                    if RW.modules[selectedGroup].mode == "BAR" then
                        return {
                            ["UP"] = L["上"],
                            ["DOWN"] = L["下"],
                        }
                    else
                        return {
                            ["UP"] = L["上"],
                            ["DOWN"] = L["下"],
                            ["LEFT"] = L["左"],
                            ["RIGHT"] = L["右"],
                        }
                    end
                end,
            },
            spacer3 = {
                type = 'description',
                name = '',
                desc = '',
                order = 12,
            },
            size = {
                order = 13,
                name = L["图标大小"],
                set = function(info, value)
                    RW.modules[selectedGroup].size = value
                    RW.modules[selectedGroup].size = value
                    RW.modules[selectedGroup]:ApplyStyle()
                end,
                get = function() return RW.modules[selectedGroup].size end,
                disabled = function(info) return not RW.modules[selectedGroup].enable end,
                type = "range",
                min = 20, max = 80, step = 1,
            },
            barWidth = {
                order = 14,
                name = L["计时条长度"],
                set = function(info, value)
                    RW.modules[selectedGroup].barwidth = value
                    RW.modules[selectedGroup].barwidth = value
                    RW.modules[selectedGroup]:ApplyStyle()
                end,
                get = function() return (RW.modules[selectedGroup].barwidth or 150) end,
                hidden = function(info) return RW.modules[selectedGroup].mode ~= "BAR" end,
                type = "range",
                min = 50, max = 300, step = 1,
            },
            iconSide = {
                order = 15,
                name = L["图标位置"],
                set = function(info, value)
                    RW.modules[selectedGroup].iconside = value
                    RW.modules[selectedGroup].iconside = value
                    RW.modules[selectedGroup]:ApplyStyle()
                end,
                get = function() return (RW.modules[selectedGroup].iconside or "LEFT") end,
                hidden = function(info) return RW.modules[selectedGroup].mode ~= "BAR" end,
                type = "select",
                values = {
                    ["LEFT"] = L["左"],
                    ["RIGHT"] = L["右"],
                },
            },
            spacer4 = {
                type = 'description',
                name = '',
                desc = '',
                order = 16,
            },
            buffs = {
                order = 17,
                type = "select",
                name = L["已有增益监视"],
                set = function(info, value)
                    selectedBuff = value
                    selectedDebuff = nil
                    selectedCooldown = nil
                    selectedItemCooldown = nil
                    UpdateInput(value, "BUFF")
                end,
                get = function() return selectedBuff end,
                disabled = function(info) return not RW.modules[selectedGroup].enable end,
                values = {},
            },
            debuffs = {
                order = 18,
                type = "select",
                name = L["已有减益监视"],
                set = function(info, value)
                    selectedBuff = nil
                    selectedDebuff = value
                    selectedCooldown = nil
                    selectedItemCooldown = nil
                    UpdateInput(value, "DEBUFF")
                end,
                get = function() return selectedDebuff end,
                disabled = function(info) return not RW.modules[selectedGroup].enable end,
                values = {},
            },
            cooldowns = {
                order = 19,
                type = "select",
                name = L["已有冷却监视"],
                set = function(info, value)
                    selectedBuff = nil
                    selectedDebuff = nil
                    selectedCooldown = value
                    selectedItemCooldown = nil
                    UpdateInput(value, "CD")
                end,
                get = function() return selectedCooldown end,
                disabled = function(info) return not RW.modules[selectedGroup].enable end,
                values = {},
            },
            itemcooldowns = {
                order = 20,
                type = "select",
                name = L["已有物品冷却监视"],
                set = function(info, value)
                    selectedBuff = nil
                    selectedDebuff = nil
                    selectedCooldown = nil
                    selectedItemCooldown = value
                    UpdateInput(value, "itemCD")
                end,
                get = function() return selectedItemCooldown end,
                disabled = function(info) return not RW.modules[selectedGroup].enable end,
                values = {},
            },
            spacer5 = {
                type = 'description',
                name = '',
                desc = '',
                width = "full",
                order = 21,
            },
            idinput = {
                order = 22,
                type = "input",
                name = L["ID"],
                get = function(info, value) return selectedSpell.spellID and tostring(selectedSpell.spellID) end,
                set = function(info, value)
                    if not GetSpellInfo(value) then value = nil end
                    selectedSpell.spellID = tonumber(value)
                end,
                disabled = function(info) return not RW.modules[selectedGroup].enable end,
                hidden = function() return not selectedSpell.isNew end,
            },
            enable = {
                type = 'toggle',
                name = L["启用"],
                order = 23,
                set = function(info, value)
                    SaveProfileKey("enable", value)
                    if not selectedSpell.isNew then
                        RW.modules[selectedGroup][selectedSpell.filter][selectedSpell.spellID].enable = value
                        RW.modules[selectedGroup]:Update()
                    end
                end,
                get = function()
                    return selectedSpell.enable
                end,
                disabled = function(info) return not selectedGroup end,
                hidden = function(info) return not selectedSpell end,
            },
            spacer6 = {
                type = 'description',
                name = '',
                desc = '',
                order = 24,
            },
            filterinput = {
                order = 25,
                name = L["类型"],
                get = function(info, value) return selectedSpell.filter end,
                set = function(info, value) selectedSpell.filter = value end,
                disabled = function(info) return not RW.modules[selectedGroup].enable end,
                type = "select",
                values = {
                    ["BUFF"] = L["增益"],
                    ["DEBUFF"] = L["减益"],
                    ["CD"] = L["冷却"],
                    ["itemCD"] = L["物品冷却"],
                },
            },
            unitidinput = {
                order = 26,
                type = "select",
                name = L["监视对象"],
                get = function(info, value) return selectedSpell.unitID end,
                set = function(info, value) selectedSpell.unitID = value end,
                disabled = function() return not RW.modules[selectedGroup].enable end,
                hidden = function() return selectedSpell.filter~="BUFF" and selectedSpell.filter~="DEBUFF" end,
                values = {
                    ["player"] = L["玩家"],
                    ["target"] = L["目标"],
                    ["focus"] = L["焦点"],
                    ["pet"] = L["宠物"],
                },
            },
            casterinput = {
                order = 27,
                type = "select",
                name = L["施法者"],
                get = function(info, value) return selectedSpell.caster end,
                set = function(info, value) selectedSpell.caster = value end,
                hidden = function(info) return(selectedSpell.filter~="BUFF" and selectedSpell.filter~="DEBUFF") or not RW.modules[selectedGroup].enable end,
                values = {
                    ["player"] = L["玩家"],
                    ["target"] = L["目标"],
                    ["focus"] = L["焦点"],
                    ["pet"] = L["宠物"],
                    ["all"] = L["任何人"],
                },
            },
            spacer7 = {
                type = 'description',
                name = '',
                desc = '',
                width = "full",
                order = 30,
            },
            addbutton = {
                order = 31,
                type = "execute",
                name = ADD,
                disabled = function(info) return not RW.modules[selectedGroup].enable end,
                func = function()
                    selectedSpell = { isNew = true, enable = true }
                    selectedBuff = nil
                    selectedDebuff = nil
                    selectedCooldown = nil
                    selectedItemCooldown = nil
                end
            },
            savebutton = {
                order = 32,
                type = "execute",
                name = SAVE,
                disabled = function(info)
                    local isOK = false
                    if (selectedSpell.filter == "BUFF" or selectedSpell.filter == "DEBUFF") and selectedSpell.caster and selectedSpell.unitID then
                        isOK = true
                    elseif selectedSpell.filter ~= "BUFF" and selectedSpell.filter ~= "DEBUFF" then
                        isOK = true
                    end
                    return not RW.modules[selectedGroup].enable
                    or not selectedSpell.spellID
                    or not selectedSpell.filter
                    or not isOK
                end,
                func = function()
                    SaveProfileKey("enable", selectedSpell.enable)
                    RW.modules[selectedGroup][selectedSpell.filter] = RW.modules[selectedGroup][selectedSpell.filter] or {}
                    if selectedSpell.filter == "BUFF" or selectedSpell.filter == "DEBUFF" then
                        SaveProfileKey("caster", selectedSpell.caster)
                        SaveProfileKey("unitID", selectedSpell.unitID)
                        RW.modules[selectedGroup][selectedSpell.filter].unitIDs = RW.modules[selectedGroup][selectedSpell.filter].unitIDs or {}
                        RW.modules[selectedGroup][selectedSpell.filter].unitIDs[selectedSpell.unitID] = true
                    end
                    RW.modules[selectedGroup][selectedSpell.filter][selectedSpell.spellID] = {
                        ["enable"] = selectedSpell.enable,
                        ["caster"] = selectedSpell.caster,
                        ["unitID"] = selectedSpell.unitID,
                    }
                    UpdateGroup()
                    selectedBuff = nil
                    selectedDebuff = nil
                    selectedCooldown = nil
                    selectedItemCooldown = nil
                    if selectedSpell.filter == "BUFF" then
                        selectedBuff = selectedSpell.spellID
                    elseif selectedSpell.filter == "DEBUFF" then
                        selectedDebuff = selectedSpell.spellID
                    elseif selectedSpell.filter == "CD" then
                        selectedCooldown = selectedSpell.spellID
                    elseif selectedSpell.filter == "itemCD" then
                        selectedItemCooldown = selectedSpell.spellID
                    end
                    selectedSpell.isNew = false
                    RW.modules[selectedGroup]:Update()
                end,
            },
            deletebutton = {
                order = 33,
                type = "execute",
                name = L["删除"],
                desc = L["从当前分组删除"],
                disabled = function(info) return not RW.modules[selectedGroup].enable or not selectedSpell.spellID end,
                func = function()
                    if RW.modules[selectedGroup].defaultSetting[selectedSpell.filter] and RW.modules[selectedGroup].defaultSetting[selectedSpell.filter][selectedSpell.spellID] then
                        SaveProfileKey("enable", false)
                        RW.modules[selectedGroup][selectedSpell.filter][selectedSpell.spellID].enable = false
                        selectedSpell.enable = false
                        R:Print(L["你不能删除一个内建的法术，已停用此技能。"])
                    else
                        R.global.Watcher[selectedGroup][selectedSpell.filter][selectedSpell.spellID] = nil
                        RW.modules[selectedGroup][selectedSpell.filter][selectedSpell.spellID] = nil
                        selectedSpell = { isNew = true, enable = true }
                        selectedBuff = nil
                        selectedDebuff = nil
                        selectedCooldown = nil
                        selectedItemCooldown = nil
                    end
                    UpdateGroup()
                    RW.modules[selectedGroup]:Update()
                end,
            },
        },
    }

    local buffs = R.Options.args.Watcher.args.filterGroup.args.buffs.values
    local debuffs = R.Options.args.Watcher.args.filterGroup.args.debuffs.values
    local cooldowns = R.Options.args.Watcher.args.filterGroup.args.cooldowns.values
    local itemcooldowns = R.Options.args.Watcher.args.filterGroup.args.itemcooldowns.values
    wipe(buffs)
    wipe(debuffs)
    wipe(cooldowns)
    wipe(itemcooldowns)
    for i in pairs(RW.modules[selectedGroup].BUFF or {}) do
        if i ~= "unitIDs" and RW.modules[selectedGroup].BUFF[i] and next(RW.modules[selectedGroup].BUFF[i]) then
            if GetSpellInfo(i) then
                buffs[i] = GetSpellInfo(i) .. " (" .. i .. ")"
            else
                buffs[i] = tostring(i)
            end
        end
    end
    for i in pairs(RW.modules[selectedGroup].DEBUFF or {}) do
        if i ~= "unitIDs" and RW.modules[selectedGroup].DEBUFF[i] and next(RW.modules[selectedGroup].DEBUFF[i]) then
            if GetSpellInfo(i) then
                debuffs[i] = GetSpellInfo(i) .. " (" .. i .. ")"
            else
                debuffs[i] = tostring(i)
            end
        end
    end
    for i in pairs(RW.modules[selectedGroup].CD or {}) do
        if RW.modules[selectedGroup].CD[i] then
            if GetSpellInfo(i) then
                cooldowns[i] = GetSpellInfo(i) .. " (" .. i .. ")"
            else
                cooldowns[i] = tostring(i)
            end
        end
    end
    for i in pairs(RW.modules[selectedGroup].itemCD or {}) do
        if RW.modules[selectedGroup].itemCD[i] then
            if GetItemInfo(i) then
                itemcooldowns[i] = GetItemInfo(i) .. " (" .. i .. ")"
            else
                itemcooldowns[i] = tostring(i)
            end
        end
    end
    if next(buffs) == nil then
        R.Options.args.Watcher.args.filterGroup.args.buffs.hidden = true
    else
        R.Options.args.Watcher.args.filterGroup.args.buffs.hidden = false
    end
    if next(debuffs) == nil then
        R.Options.args.Watcher.args.filterGroup.args.debuffs.hidden = true
    else
        R.Options.args.Watcher.args.filterGroup.args.debuffs.hidden = false
    end
    if next(cooldowns) == nil then
        R.Options.args.Watcher.args.filterGroup.args.cooldowns.hidden = true
    else
        R.Options.args.Watcher.args.filterGroup.args.cooldowns.hidden = false
    end
    if next(itemcooldowns) == nil then
        R.Options.args.Watcher.args.filterGroup.args.itemcooldowns.hidden = true
    else
        R.Options.args.Watcher.args.filterGroup.args.itemcooldowns.hidden = false
    end
end

R.Options.args.Watcher = {
    type = "group",
    name = (RW.modName or RW:GetName()),
    order = 12,
    args = {
        header = {
            type = "header",
            name = RW.modName or RW:GetName(),
            order = 1
        },
        enable = {
            type = "toggle",
            name = RW.toggleLabel or (L["启用"] .. (RW.modName or RW:GetName())),
            width = "double",
            desc = RW.Info and RW:Info() or (L["启用"] .. (RW.modName or RW:GetName())),
            order = 3,
            get = function()
                return R.db.Watcher.enable
            end,
            set = function(info, value)
                R.db.Watcher.enable = value
                StaticPopup_Show("CFG_RELOAD")
            end,
        },
        settingsHeader = {
            type = "header",
            name = L["设置"],
            order = 4,
            hidden = function() return not R.db.Watcher.enable end,
        },
        GroupSelect = {
            order = 6,
            type = "select",
            name = L["选择一个分组"],
            set = function(info, value)
                if value == "" then
                    selectedGroup = nil
                else
                    selectedGroup = value
                end
                selectedSpell = { isNew = true, enable = true }
                UpdateGroup()
            end,
            get = function(info) return selectedGroup end,
            hidden = function() return not R.db.Watcher.enable end,
            values = function()
                local values = {}
                values[""] = NONE
                for name in pairs(RW.modules) do
                    values[name] = name
                end
                return values
            end,
        },
    },
}
