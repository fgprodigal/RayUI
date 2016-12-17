local R, L, P, G = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, GlobalDB

local AddOn = {}

function AddOn.MikScrollingBattleText()
    MSBTProfiles_SavedVars = MSBTProfiles_SavedVars or {}
    MSBTProfiles_SavedVars.profiles = MSBTProfiles_SavedVars.profiles or {}
    MSBTProfiles_SavedVars.profiles.RayUI = {
        ["critFontName"] = "RayUI Combat",
        ["enableBlizzardDamage"] = true,
        ["creationVersion"] = "5.7.128",
        ["critFontSize"] = 20,
        ["critOutlineIndex"] = 2,
        ["events"] = {
            ["NOTIFICATION_COMBAT_ENTER"] = {
                ["disabled"] = true,
            },
            ["NOTIFICATION_SHADOW_ORBS_CHANGE"] = {
                ["scrollArea"] = "Static",
            },
            ["NOTIFICATION_PET_COOLDOWN"] = {
                ["disabled"] = true,
            },
            ["OUTGOING_SPELL_DOT_CRIT"] = {
                ["scrollArea"] = "Custom1",
            },
            ["NOTIFICATION_ALT_POWER_LOSS"] = {
                ["scrollArea"] = "Static",
            },
            ["NOTIFICATION_POWER_LOSS"] = {
                ["scrollArea"] = "Static",
            },
            ["NOTIFICATION_CHI_CHANGE"] = {
                ["scrollArea"] = "Static",
            },
            ["OUTGOING_HEAL_CRIT"] = {
                ["scrollArea"] = "Custom1",
            },
            ["NOTIFICATION_ALT_POWER_GAIN"] = {
                ["scrollArea"] = "Static",
            },
            ["NOTIFICATION_EXPERIENCE_GAIN"] = {
                ["disabled"] = false,
            },
            ["NOTIFICATION_HOLY_POWER_FULL"] = {
                ["scrollArea"] = "Static",
            },
            ["NOTIFICATION_COMBAT_LEAVE"] = {
                ["disabled"] = true,
            },
            ["NOTIFICATION_HOLY_POWER_CHANGE"] = {
                ["scrollArea"] = "Static",
            },
            ["NOTIFICATION_ITEM_COOLDOWN"] = {
                ["disabled"] = true,
            },
            ["NOTIFICATION_CP_FULL"] = {
                ["disabled"] = true,
            },
            ["OUTGOING_SPELL_DAMAGE_CRIT"] = {
                ["scrollArea"] = "Custom1",
            },
            ["NOTIFICATION_POWER_GAIN"] = {
                ["scrollArea"] = "Static",
            },
            ["NOTIFICATION_SHADOW_ORBS_FULL"] = {
                ["scrollArea"] = "Static",
            },
            ["NOTIFICATION_CP_GAIN"] = {
                ["disabled"] = true,
            },
            ["NOTIFICATION_COOLDOWN"] = {
                ["disabled"] = true,
            },
            ["NOTIFICATION_CHI_FULL"] = {
                ["scrollArea"] = "Static",
            },
            ["OUTGOING_HOT_CRIT"] = {
                ["scrollArea"] = "Custom1",
            },
        },
        ["normalOutlineIndex"] = 2,
        ["enableBlizzardHealing"] = true,
        ["normalFontName"] = "RayUI Combat",
        ["scrollAreas"] = {
            ["Incoming"] = {
                ["stickyDirection"] = "Up",
                ["direction"] = "Up",
                ["offsetX"] = -305,
                ["behavior"] = "MSBT_NORMAL",
                ["stickyBehavior"] = "MSBT_NORMAL",
                ["offsetY"] = -73,
                ["animationStyle"] = "Straight",
                ["stickyAnimationStyle"] = "Static",
            },
            ["Notification"] = {
                ["stickyDirection"] = "Up",
                ["scrollHeight"] = 105,
                ["offsetX"] = -174,
                ["animationSpeed"] = 50,
                ["offsetY"] = 300,
                ["stickyAnimationStyle"] = "Static",
            },
            ["Static"] = {
                ["stickyDirection"] = "Up",
                ["scrollHeight"] = 60,
                ["offsetY"] = -220,
                ["stickyAnimationStyle"] = "Static",
            },
            ["Custom1"] = {
                ["critFontSize"] = 30,
                ["direction"] = "Up",
                ["offsetX"] = -25,
                ["scrollWidth"] = 50,
                ["scrollHeight"] = 100,
                ["offsetY"] = 80,
                ["animationStyle"] = "Straight",
                ["name"] = "爆击",
            },
            ["Outgoing"] = {
                ["stickyDirection"] = "Up",
                ["direction"] = "Up",
                ["offsetX"] = 306,
                ["behavior"] = "MSBT_NORMAL",
                ["stickyBehavior"] = "MSBT_NORMAL",
                ["offsetY"] = -73,
                ["animationStyle"] = "Straight",
                ["stickyAnimationStyle"] = "Static",
            },
        },
        ["normalFontSize"] = 16,
    }

    MSBTProfiles_SavedVarsPerChar = MSBTProfiles_SavedVarsPerChar or {}
    if not MSBTProfiles_SavedVarsPerChar.currentProfileName then
        MSBTProfiles_SavedVarsPerChar.currentProfileName = "RayUI"
        MikSBT.Profiles.SelectProfile("RayUI")
    end
end

AddOn["xCT+"] = function()
    if not xCTSavedDB.RayUI or xCTSavedDB.RayUI ~= 1 then
        xCT_Plus.db:SetProfile("RayUI")
        local profile = xCT_Plus.db.profile
        profile.spells.formatAbbreviate = true

        profile.showStartupText = false
        profile.blizzardFCT.blizzardHeadNumbers = true
        profile.blizzardFCT.enable = true
        profile.blizzardFCT.font = "RayUI Combat"
        profile.blizzardFCT.floatingCombatTextCombatDamage = true
        profile.blizzardFCT.floatingCombatTextCombatHealing = true
        profile.blizzardFCT.floatingCombatTextCombatDamageDirectionalScale = 0

        local frames = profile.frames
        frames.general.Width = 256
        frames.general.font = "RayUI Font"
        frames.general.iconsSize = 18
        frames.general.showInterrupts = false
        frames.general.showDispells = false
        frames.general.showPartyKills = false

        frames.outgoing.X = 382
        frames.outgoing.Y = 58
        frames.outgoing.Width = 128
        frames.outgoing.Height = 260
        frames.outgoing.font = "RayUI Font"
        frames.outgoing.fontSize = 15
        frames.outgoing.iconsSize = 22

        frames.critical.enabledFrame = true
        frames.critical.X = 230
        frames.critical.Y = 70
        frames.critical.Width = 180
        frames.critical.font = "RayUI Font"

        frames.damage.X = -325
        frames.damage.Y = -30
        frames.damage.Width = 190
        frames.damage.Height = 144
        frames.damage.font = "RayUI Font"
        frames.damage.fontSize = 15
        frames.damage.insertText = "bottom"
        frames.damage.names.PLAYER.nameType = 0
        frames.damage.names.PLAYER.NPC = 0
        frames.damage.names.PLAYER.ENVIRONMENT = 0

        frames.healing.X = -415
        frames.healing.Y = 5
        frames.healing.Width = 128
        frames.healing.Height = 260
        frames.healing.font = "RayUI Font"
        frames.healing.fontSize = 15
        frames.healing.names.PLAYER.nameType = 0
        frames.healing.names.PLAYER.NPC = 0
        frames.healing.names.PLAYER.ENVIRONMENT = 0

        frames.class.enabledFrame = false
        frames.procs.enabledFrame = false

        frames.power.X = 0
        frames.power.Y = -95
        frames.power.Width = 180
        frames.power.Height = 128
        frames.power.font = "RayUI Font"
        frames.power.fontSize = 15

        frames.loot.Y = -245
        frames.loot.Width = 325
        frames.loot.font = "RayUI Font"

        xCT_Plus:RefreshConfig()

        xCTSavedDB.RayUI = 1
    end

    xCT_Plus.combatEvents:UnregisterEvent("PLAYER_REGEN_ENABLED")
    xCT_Plus.combatEvents:UnregisterEvent("PLAYER_REGEN_DISABLED")
end

local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:SetScript("OnEvent", function(self, event, addon)
        if event == "PLAYER_ENTERING_WORLD" then
            for addon in pairs(AddOn) do
                if IsAddOnLoaded(addon) then
                    AddOn[addon]()
                    AddOn[addon] = nil
                end
            end
        elseif event == "ADDON_LOADED" then
            if AddOn[addon] then
                AddOn[addon]()
                AddOn[addon] = nil
            end
        end
    end)
