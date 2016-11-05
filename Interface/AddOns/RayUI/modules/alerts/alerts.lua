--AlertSystem from ls: Toasts
local R, L, P, G = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, GlobalDB
local AL = R:NewModule("Alerts", "AceEvent-3.0", "AceHook-3.0", "AceConsole-3.0")

--Cache global variables
--Lua functions
local _G = _G
local math, string, table, tonumber, pairs = math, string, table, tonumber, pairs
local pcall, type, unpack, select = pcall, type, unpack, select

--WoW API / Variables
local Lerp = Lerp
local CreateFrame = CreateFrame
local InCombatLockdown = InCombatLockdown
local SetPortraitToTexture = SetPortraitToTexture
local C_Garrison = C_Garrison
local C_TransmogCollection = C_TransmogCollection
local GetItemInfoInstant = GetItemInfoInstant
local PlaySoundKitID = PlaySoundKitID
local PlaySound = PlaySound
local ShowUIPanel = ShowUIPanel
local Garrison_LoadUI = Garrison_LoadUI
local ShowGarrisonLandingPage = ShowGarrisonLandingPage
local CollectionsJournal_LoadUI = CollectionsJournal_LoadUI
local WardrobeCollectionFrame_OpenTransmogLink = WardrobeCollectionFrame_OpenTransmogLink
local GarrisonFollowerTooltip_Show = GarrisonFollowerTooltip_Show
local BattlePetToolTip_Show = BattlePetToolTip_Show
local IsModifiedClick = IsModifiedClick
local GetCVarBool = GetCVarBool
local GameTooltip_ShowCompareItem = GameTooltip_ShowCompareItem
local C_Timer = C_Timer
local GetMoneyString = GetMoneyString
local GetAchievementInfo = GetAchievementInfo
local AchievementFrame_LoadUI = AchievementFrame_LoadUI
local GetArchaeologyRaceInfoByID = GetArchaeologyRaceInfoByID
local UIParentLoadAddOn = UIParentLoadAddOn
local C_Scenario = C_Scenario
local GetInstanceInfo = GetInstanceInfo
local GetLFGCompletionReward = GetLFGCompletionReward
local UnitLevel = UnitLevel
local GetLFGCompletionRewardItem = GetLFGCompletionRewardItem
local GetItemInfo = GetItemInfo
local UnitFactionGroup = UnitFactionGroup
local GroupLootContainer_RemoveFrame = GroupLootContainer_RemoveFrame
local C_PetJournal = C_PetJournal
local GetCurrencyInfo = GetCurrencyInfo
local C_TradeSkillUI = C_TradeSkillUI
local GetSpellInfo = GetSpellInfo
local GetSpellRank = GetSpellRank
local GetTaskInfo = GetTaskInfo
local GetQuestTagInfo = GetQuestTagInfo
local GetQuestLogRewardMoney = GetQuestLogRewardMoney
local GetQuestLogRewardXP = GetQuestLogRewardXP
local GetNumQuestLogRewardCurrencies = GetNumQuestLogRewardCurrencies
local GetQuestLogRewardCurrencyInfo = GetQuestLogRewardCurrencyInfo
local GetProfessionInfo = GetProfessionInfo
local QuestUtils_IsQuestWorldQuest = QuestUtils_IsQuestWorldQuest
local GetCurrentMapAreaID = GetCurrentMapAreaID
local C_TaskQuest = C_TaskQuest
local HaveQuestData = HaveQuestData
local GetNumQuestLogRewards = GetNumQuestLogRewards
local GetQuestLogRewardInfo = GetQuestLogRewardInfo
local GetCurrencyLink = GetCurrencyLink
local IsUsableItem = IsUsableItem
local GetDetailedItemLevelInfo = GetDetailedItemLevelInfo
local GetInventoryItemLink = GetInventoryItemLink
local GetInventoryItemID = GetInventoryItemID
local CanDualWield = CanDualWield
local hooksecurefunc = hooksecurefunc

--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: GameTooltip, GarrisonShipyardFollowerTooltip, GarrisonFollowerTooltip, AlertFrame, AchievementFrame
-- GLOBALS: GarrisonLandingPage, GarrisonFollowerOptions, CollectionsJournal, LE_FOLLOWER_TYPE_SHIPYARD_6_2
-- GLOBALS: BattlePetTooltip, ShoppingTooltip1, ShoppingTooltip2, YOU_RECEIVED, BONUS_OBJECTIVE_EXPERIENCE_FORMAT
-- GLOBALS: ACHIEVEMENT_PROGRESSED, ACHIEVEMENT_UNLOCKED, ARCHAEOLOGY_DIGSITE_COMPLETE_TOAST_FRAME_TITLE
-- GLOBALS: ArchaeologyFrame, ArcheologyDigsiteProgressBar, LE_FOLLOWER_TYPE_GARRISON_7_0, LE_GARRISON_TYPE_7_0
-- GLOBALS: LE_FOLLOWER_TYPE_GARRISON_6_0, LE_GARRISON_TYPE_6_0, ITEM_QUALITY_COLORS, GARRISON_MISSION_ADDED_TOAST1
-- GLOBALS: GARRISON_MISSION_COMPLETE, LOOTUPGRADEFRAME_QUALITY_TEXTURES, GARRISON_UPDATE, GARRISON_TALENT_ORDER_ADVANCEMENT
-- GLOBALS: DUNGEON_COMPLETED, MAX_PLAYER_LEVEL, SCENARIO_COMPLETED, LFG_SUBTYPEID_HEROIC, LE_SCENARIO_TYPE_LEGION_INVASION
-- GLOBALS: YOU_WON_LABEL, YOU_RECEIVED_LABEL, ITEM_UPGRADED_LABEL, LOOT_ROLL_TYPE_NEED, LOOT_ROLL_TYPE_GREED
-- GLOBALS: LOOT_ROLL_TYPE_DISENCHANT, LEGENDARY_ITEM_LOOT_LABEL, LOOTUPGRADEFRAME_TITLE, GroupLootContainer
-- GLOBALS: BLIZZARD_STORE_PURCHASE_COMPLETE, BonusRollFrame, UPGRADED_RECIPE_LEARNED_TITLE, UIPARENT_MANAGED_FRAME_POSITIONS
-- GLOBALS: NEW_RECIPE_LEARNED_TITLE, SCENARIO_INVASION_COMPLETE, WORLD_QUEST_QUALITY_COLORS, WORLD_QUEST_COMPLETE
-- GLOBALS: LE_QUEST_TAG_TYPE_PVP, LE_QUEST_TAG_TYPE_PET_BATTLE, LE_QUEST_TAG_TYPE_PROFESSION, LE_QUEST_TAG_TYPE_DUNGEON
-- GLOBALS: CURRENCY_GAINED_MULTIPLE, ERR_LEARN_TRANSMOG_S, SLASH_LSADDTOAST1, SlashCmdList, DevTools_Dump
-- GLOBALS: AchievementFrame_SelectAchievement

local INLINE_NEED = "|TInterface\\Buttons\\UI-GroupLoot-Dice-Up:0:0:0:0:32:32:0:32:0:31|t"
local INLINE_GREED = "|TInterface\\Buttons\\UI-GroupLoot-Coin-Up:0:0:0:0:32:32:0:32:0:31|t"
local INLINE_DE = "|TInterface\\Buttons\\UI-GroupLoot-DE-Up:0:0:0:0:32:32:0:32:0:31|t"
local itemToasts = {}
local missonToasts = {}
local followerToasts = {}
local achievementToasts = {}
local abilityToasts = {}
local scenarioToasts = {}
local miscToasts = {}
local activeToasts = {}
local queuedToasts = {}
local textsToAnimate = {}
local toastCounter = 0

local EQUIP_SLOTS = {
    ["INVTYPE_HEAD"] = {_G.INVSLOT_HEAD},
    ["INVTYPE_NECK"] = {_G.INVSLOT_NECK},
    ["INVTYPE_SHOULDER"] = {_G.INVSLOT_SHOULDER},
    ["INVTYPE_CHEST"] = {_G.INVSLOT_CHEST},
    ["INVTYPE_ROBE"] = {_G.INVSLOT_CHEST},
    ["INVTYPE_WAIST"] = {_G.INVSLOT_WAIST},
    ["INVTYPE_LEGS"] = {_G.INVSLOT_LEGS},
    ["INVTYPE_FEET"] = {_G.INVSLOT_FEET},
    ["INVTYPE_WRIST"] = {_G.INVSLOT_WRIST},
    ["INVTYPE_HAND"] = {_G.INVSLOT_HAND},
    ["INVTYPE_FINGER"] = {_G.INVSLOT_FINGER1, _G.INVSLOT_FINGER2},
    ["INVTYPE_TRINKET"] = {_G.INVSLOT_TRINKET1, _G.INVSLOT_TRINKET1},
    ["INVTYPE_CLOAK"] = {_G.INVSLOT_BACK},
    ["INVTYPE_WEAPON"] = {_G.INVSLOT_MAINHAND, _G.INVSLOT_OFFHAND},
    ["INVTYPE_2HWEAPON"] = {_G.INVSLOT_MAINHAND},
    ["INVTYPE_WEAPONMAINHAND"] = {_G.INVSLOT_MAINHAND},
    ["INVTYPE_HOLDABLE"] = {_G.INVSLOT_OFFHAND},
    ["INVTYPE_SHIELD"] = {_G.INVSLOT_OFFHAND},
    ["INVTYPE_WEAPONOFFHAND"] = {_G.INVSLOT_OFFHAND},
    ["INVTYPE_RANGED"] = {_G.INVSLOT_RANGED},
    ["INVTYPE_RANGEDRIGHT"] = {_G.INVSLOT_RANGED},
    ["INVTYPE_RELIC"] = {_G.INVSLOT_RANGED},
    ["INVTYPE_THROWN"] = {_G.INVSLOT_RANGED},
}

local BLACKLISTED_EVENTS = {
    ACHIEVEMENT_EARNED = true,
    CRITERIA_EARNED = true,
    GARRISON_BUILDING_ACTIVATABLE = true,
    GARRISON_FOLLOWER_ADDED = true,
    GARRISON_MISSION_FINISHED = true,
    GARRISON_RANDOM_MISSION_ADDED = true,
    GARRISON_TALENT_COMPLETE = true,
    LFG_COMPLETION_REWARD = true,
    LOOT_ITEM_ROLL_WON = true,
    NEW_RECIPE_LEARNED = true,
    QUEST_LOOT_RECEIVED = true,
    QUEST_TURNED_IN = true,
    SCENARIO_COMPLETED = true,
    SHOW_LOOT_TOAST = true,
    SHOW_LOOT_TOAST_LEGENDARY_LOOTED = true,
    SHOW_LOOT_TOAST_UPGRADE = true,
    SHOW_PVP_FACTION_LOOT_TOAST = true,
    SHOW_RATED_PVP_REWARD_TOAST = true,
    STORE_PRODUCT_DELIVERED = true,
}

------------
-- CONFIG --
------------

local CFG = {
    growth_direction = "UP",
    point = {"CENTER", "RayUIParent", "CENTER", 0, 180},
    max_active_toasts = 6,
    sfx_enabled = true,
    fadeout_delay = 2.8,
    scale = 1,
    colored_names_enabled = true,
    dnd = {
        achievement = false,
        archaeology = false,
        recipe = false,
        garrison_6_0 = false,
        garrison_7_0 = true,
        instance = false, -- dungeon completion
        loot_special = false, -- includes blizz store items
        loot_common = false,
        loot_currency = false,
        world = false, -- world quest, invasion completion
        transmog = false,
    },
    achievement_enabled = true,
    archaeology_enabled = true,
    garrison_6_0_enabled = false,
    garrison_7_0_enabled = true,
    instance_enabled = true,
    loot_special_enabled = true,
    loot_common_enabled = false,
    loot_common_quality_threshold = 1,
    loot_currency_enabled = true,
    recipe_enabled = true,
    world_enabled = true,
    transmog_enabled = true,
}

------------
-- EXPORT --
------------
function AL:SkinToast() end

-- Parameters:
-- toast
-- toastType - types: "item", "mission", "follower", "achievement", "ability", "scenario", "misc"

------------
-- ANCHOR --
------------

local function CalculatePosition(self)
    local selfCenterX, selfCenterY = self:GetCenter()
    local screenWidth = R.UIParent:GetRight()
    local screenHeight = R.UIParent:GetTop()
    local screenCenterX, screenCenterY = R.UIParent:GetCenter()
    local screenLeft = screenWidth / 3
    local screenRight = screenWidth * 2 / 3
    local p, x, y

    if selfCenterY >= screenCenterY then
        p = "TOP"
        y = self:GetTop() - screenHeight
    else
        p = "BOTTOM"
        y = self:GetBottom()
    end

    if selfCenterX >= screenRight then
        p = p.."RIGHT"
        x = self:GetRight() - screenWidth
    elseif selfCenterX <= screenLeft then
        p = p.."LEFT"
        x = self:GetLeft()
    else
        x = selfCenterX - screenCenterX
    end

    return p, p, math.floor(x + 0.5), math.floor(y + 0.5)
end

local function Anchor_OnDragStart(self)
    self:StartMoving()
end

local function Anchor_OnDragStop(self)
    self:StopMovingOrSizing()

    local anchor = "RayUIParent"
    local p, rP, x, y = CalculatePosition(self)

    self:ClearAllPoints()
    self:SetPoint(p, anchor, rP, x, y)

    CFG.point = {p, anchor, rP, x, y}
end

local anchorFrame = CreateFrame("Frame", "LSToastAnchor", R.UIParent)
anchorFrame:SetSize(234, 58)
anchorFrame:SetClampedToScreen(true)
anchorFrame:SetClampRectInsets(-24, 12, 12, -12)
anchorFrame:SetMovable(true)
anchorFrame:SetToplevel(true)
anchorFrame:RegisterForDrag("LeftButton")
anchorFrame:SetScript("OnDragStart", Anchor_OnDragStart)
anchorFrame:SetScript("OnDragStop", Anchor_OnDragStop)

do
    local texture = anchorFrame:CreateTexture(nil, "BACKGROUND")
    texture:SetColorTexture(0.1, 0.1, 0.1, 0.9)
    texture:SetAllPoints()
    texture:Hide()
    anchorFrame.BG = texture

    local text = anchorFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    text:SetAllPoints()
    text:SetJustifyH("CENTER")
    text:SetJustifyV("MIDDLE")
    text:SetText("Toast Anchor")
    text:Hide()
    anchorFrame.Text = text
end

local function Anchor_Enable()
    anchorFrame:EnableMouse(true)
    anchorFrame.BG:Show()
    anchorFrame.Text:Show()
end

local function Anchor_Disable()
    anchorFrame:EnableMouse(false)
    anchorFrame.BG:Hide()
    anchorFrame.Text:Hide()
end

-----------
-- UTILS --
-----------

local function FixItemLink(itemLink)
    itemLink = string.match(itemLink, "|H(.+)|h.+|h")
    local linkTable = {string.split(":", itemLink)}

    if linkTable[1] ~= "item" then
        return itemLink
    end

    if linkTable[12] ~= "" then
        linkTable[12] = ""

        table.remove(linkTable, 15 + (tonumber(linkTable[14]) or 0))
    end

    return table.concat(linkTable, ":")
end

-- XXX: Remove it, when it's implemented by Blizzard
local function IsItemAnUpgrade(itemLink)
    if not IsUsableItem(itemLink) then return false end

    local _, _, _, _, _, _, _, _, itemEquipLoc = GetItemInfo(itemLink)
    local itemLevel = GetDetailedItemLevelInfo(itemLink)
    local slot1, slot2 = unpack(EQUIP_SLOTS[itemEquipLoc] or {})

    if slot1 then
        local itemLinkInSlot1 = GetInventoryItemLink("player", slot1)

        if itemLinkInSlot1 then
            local itemLevelInSlot1 = GetDetailedItemLevelInfo(itemLinkInSlot1)

            if itemLevel > itemLevelInSlot1 then
                return true
            end
        else
            -- XXX: Make sure that slot is empty
            if not GetInventoryItemID("player", slot1) then
                return true
            end
        end
    end

    if slot2 then
        local isSlot2Equippable = itemEquipLoc ~= "INVTYPE_WEAPON" and true or CanDualWield()

        if isSlot2Equippable then
            local itemLinkInSlot2 = GetInventoryItemLink("player", slot2)

            if itemLinkInSlot2 then
                local itemLevelInSlot2 = GetDetailedItemLevelInfo(itemLinkInSlot2)

                if itemLevel > itemLevelInSlot2 then
                    return true
                end
            else
                -- XXX: Make sure that slot is empty
                if not GetInventoryItemID("player", slot2) then
                    return true
                end
            end
        end
    end

    return false
end

--------------------
-- TEXT ANIMATION --
--------------------

local function ProcessAnimatedText()
    for text, targetValue in pairs(textsToAnimate) do
        local newValue

        if text._value >= targetValue then
            newValue = math.floor(Lerp(text._value, targetValue, 0.25))
        else
            newValue = math.ceil(Lerp(text._value, targetValue, 0.25))
        end

        if newValue == targetValue then
            text._value = nil
            textsToAnimate[text] = nil
        end

        text:SetText(newValue)
        text._value = newValue
    end
end

local function SetAnimatedText(self, value)
    self._value = tonumber(self:GetText()) or 1
    textsToAnimate[self] = value
end

C_Timer.NewTicker(0.05, ProcessAnimatedText)

----------
-- MAIN --
----------

local function IsDNDEnabled()
    local counter = 0

    for k in pairs (CFG.dnd) do
        if k then
            counter = counter + 1
        end
    end

    return counter > 0
end

local function HasNonDNDToast()
    for i, queuedToast in pairs(queuedToasts) do
        if not queuedToast.dnd then
            -- XXX: I don't want to ruin non-DND toasts' order, k?
            table.insert(queuedToasts, 1, table.remove(queuedToasts, i))

            return true
        end
    end

    return false
end

local function SpawnToast(toast, isDND)
    if not toast then return end

    if #activeToasts >= CFG.max_active_toasts or (InCombatLockdown() and isDND) then
        if InCombatLockdown() and isDND then
            toast.dnd = true
        end

        table.insert(queuedToasts, toast)

        return false
    end

    if #activeToasts > 0 then
        if CFG.growth_direction == "DOWN" then
            toast:SetPoint("TOP", activeToasts[#activeToasts], "BOTTOM", 0, -4)
        elseif CFG.growth_direction == "UP" then
            toast:SetPoint("BOTTOM", activeToasts[#activeToasts], "TOP", 0, 4)
        elseif CFG.growth_direction == "LEFT" then
            toast:SetPoint("RIGHT", activeToasts[#activeToasts], "LEFT", -8, 0)
        elseif CFG.growth_direction == "RIGHT" then
            toast:SetPoint("LEFT", activeToasts[#activeToasts], "RIGHT", 8, 0)
        end
    else
        toast:SetPoint("TOPLEFT", anchorFrame, "TOPLEFT", 0, 0)
    end

    table.insert(activeToasts, toast)

    AL:SkinToast(toast, toast.type)

    toast:Show()

    return true
end

local function RefreshToasts()
    for i = 1, #activeToasts do
        local activeToast = activeToasts[i]

        activeToast:ClearAllPoints()

        if i == 1 then
            activeToast:SetPoint("TOPLEFT", anchorFrame, "TOPLEFT", 0, 0)
        else
            if CFG.growth_direction == "DOWN" then
                activeToast:SetPoint("TOP", activeToasts[i - 1], "BOTTOM", 0, -4)
            elseif CFG.growth_direction == "UP" then
                activeToast:SetPoint("BOTTOM", activeToasts[i - 1], "TOP", 0, 4)
            elseif CFG.growth_direction == "LEFT" then
                activeToast:SetPoint("RIGHT", activeToasts[i - 1], "LEFT", -8, 0)
            elseif CFG.growth_direction == "RIGHT" then
                activeToast:SetPoint("LEFT", activeToasts[i - 1], "RIGHT", 8, 0)
            end
        end
    end

    local queuedToast = table.remove(queuedToasts, 1)

    if queuedToast then
        if InCombatLockdown() and queuedToast.dnd then
            table.insert(queuedToasts, queuedToast)

            if HasNonDNDToast() then
                RefreshToasts()
            end
        else
            SpawnToast(queuedToast)
        end
    end
end

local function ResetToast(toast)
    toast.id = nil
    toast.dnd = nil
    toast.chat = nil
    toast.link = nil
    toast.itemCount = nil
    toast.soundFile = nil
    toast.usedRewards = nil
    toast:ClearAllPoints()
    toast:Hide()
    toast.BG:SetTexture("Interface\\AddOns\\RayUI\\media\\toast-bg-default")
    toast.Icon:SetPoint("TOPLEFT", 7, -7)
    toast.Icon:SetSize(44, 44)
    toast.Title:SetText("")
    toast.Text:SetText("")
    toast.Text:SetTextColor(1, 1, 1)
    toast.TextBG:SetVertexColor(0, 0, 0)
    toast.AnimIn:Stop()
    toast.AnimOut:Stop()

    if toast.IconBorder then
        toast.IconBorder:Show()
        toast.IconBorder:SetVertexColor(1, 1, 1)
    end

    if toast.Count then
        toast.Count:SetText("")
    end

    if toast.Dragon then
        toast.Dragon:Hide()
    end

    if toast.UpgradeIcon then
        toast.UpgradeIcon:Hide()
    end

    if toast.Level then
        toast.Level:SetText("")
    end

    if toast.Points then
        toast.Points:SetText("")
    end

    if toast.Rank then
        toast.Rank:SetText("")
    end

    if toast.IconText then
        toast.IconText:SetText("")
    end

    if toast.Bonus then
        toast.Bonus:Hide()
    end

    if toast.Heroic then
        toast.Heroic:Hide()
    end

    if toast.Arrows then
        toast.Arrows.Anim:Stop()
    end

    if toast.Reward1 then
        for i = 1, 5 do
            toast["Reward"..i]:Hide()
        end
    end
end

local function RecycleToast(toast)
    for i, activeToast in pairs(activeToasts) do
        if toast == activeToast then
            table.remove(activeToasts, i)

            if toast.type == "item" then
                table.insert(itemToasts, toast)
            elseif toast.type == "mission" then
                table.insert(missonToasts, toast)
            elseif toast.type == "follower" then
                table.insert(followerToasts, toast)
            elseif toast.type == "achievement" then
                table.insert(achievementToasts, toast)
            elseif toast.type == "ability" then
                table.insert(abilityToasts, toast)
            elseif toast.type == "scenario" then
                table.insert(scenarioToasts, toast)
            elseif toast.type == "misc" then
                table.insert(miscToasts, toast)
            end

            ResetToast(toast)
        end
    end

    RefreshToasts()
end

local function GetToastToUpdate(id, toastType)
    for _, toast in pairs(activeToasts) do
        if not toast.chat and toastType == toast.type and (id == toast.id or id == toast.link) then
            return toast, false
        end
    end

    for _, toast in pairs(queuedToasts) do
        if not toast.chat and toastType == toast.type and (id == toast.id or id == toast.link) then
            return toast, true
        end
    end

    return
end

local function UpdateToast(id, toastType, itemLink)
    local toast, isQueued = GetToastToUpdate(id, toastType)

    if toast then
        toast.usedRewards = toast.usedRewards + 1
        local reward = toast["Reward"..toast.usedRewards]

        if reward then
            local _, _, _, _, texture = GetItemInfoInstant(itemLink)
            local isOK = pcall(SetPortraitToTexture, reward.Icon, texture)

            if not isOK then
                SetPortraitToTexture(reward.Icon, "Interface\\Icons\\INV_Box_02")
            end

            reward.item = itemLink
            reward:Show()
        end

        if not isQueued then
            toast.AnimOut:Stop()
            toast.AnimOut:Play()
        end
    end
end

local function ToastButton_OnShow(self)
    local soundFile = self.soundFile

    if CFG.sfx_enabled and soundFile then
        if type(soundFile) == "number" then
            PlaySoundKitID(soundFile)
        elseif type(soundFile) == "string" then
            PlaySound(soundFile)
        end
    end

    self.AnimIn:Play()
    self.AnimOut:Play()
end

local function ToastButton_OnClick(self, button)
    if button == "RightButton" then
        RecycleToast(self)
    elseif button == "LeftButton" then
        if self.id then
            if self.type == "achievement" then
                if not AchievementFrame then
                    AchievementFrame_LoadUI()
                end
                ShowUIPanel(AchievementFrame)
                AchievementFrame_SelectAchievement(self.id)
            elseif self.type == "follower" then
                if not GarrisonLandingPage then
                    Garrison_LoadUI()
                end

                if GarrisonLandingPage then
                    ShowGarrisonLandingPage(GarrisonFollowerOptions[C_Garrison.GetFollowerInfo(self.id).followerTypeID].garrisonType)
                end
            elseif self.type == "misc" then
                if self.link then
                    if string.sub(self.link, 1, 18) == "transmogappearance" then
                        if not CollectionsJournal then
                            CollectionsJournal_LoadUI()
                        end

                        if CollectionsJournal then
                            WardrobeCollectionFrame_OpenTransmogLink(self.link)
                        end
                    end
                end
            end
        end
    end
end

local function ToastButton_OnEnter(self)
    if self.id then
        if self.type == "item" then
            GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT", -2, 2)
            GameTooltip:SetItemByID(self.id)
            GameTooltip:Show()
        elseif self.type == "follower" then
            local isOK, link = pcall(_G.C_Garrison.GetFollowerLink, self.id)

            if not isOK then
                isOK, link = pcall(_G.C_Garrison.GetFollowerLinkByID, self.id)
            end

            if isOK and link then
                local _, garrisonFollowerID, quality, level, itemLevel, ability1, ability2, ability3, ability4, trait1, trait2, trait3, trait4, spec1 = string.split(":", link)
                local followerType = C_Garrison.GetFollowerTypeByID(tonumber(garrisonFollowerID))
                GarrisonFollowerTooltip_Show(tonumber(garrisonFollowerID), false, tonumber(quality), tonumber(level), 0, 0, tonumber(itemLevel), tonumber(spec1), tonumber(ability1), tonumber(ability2), tonumber(ability3), tonumber(ability4), tonumber(trait1), tonumber(trait2), tonumber(trait3), tonumber(trait4))

                if followerType == LE_FOLLOWER_TYPE_SHIPYARD_6_2 then
                    GarrisonShipyardFollowerTooltip:ClearAllPoints()
                    GarrisonShipyardFollowerTooltip:SetPoint("TOPLEFT", self, "BOTTOMRIGHT", -2, 2)
                else
                    GarrisonFollowerTooltip:ClearAllPoints()
                    GarrisonFollowerTooltip:SetPoint("TOPLEFT", self, "BOTTOMRIGHT", -2, 2)
                end
            end
        elseif self.type == "ability" then
            GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT", -2, 2)
            GameTooltip:SetSpellByID(self.id)
            GameTooltip:Show()
        end
    elseif self.link then
        if self.type == "item" then
            if string.find(self.link, "battlepet:") then
                local _, speciesID, level, breedQuality, maxHealth, power, speed = string.split(":", self.link)
                GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT", -2, 2)
                GameTooltip:Show()
                BattlePetToolTip_Show(tonumber(speciesID), tonumber(level), tonumber(breedQuality), tonumber(maxHealth), tonumber(power), tonumber(speed))
            else
                GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT", -2, 2)
                GameTooltip:SetHyperlink(self.link)
                GameTooltip:Show()
            end
        end
    end

    self.AnimOut:Stop()

    AL:RegisterEvent("MODIFIER_STATE_CHANGED")
end

local function ToastButton_OnLeave(self)
    GameTooltip:Hide()
    GarrisonFollowerTooltip:Hide()
    GarrisonShipyardFollowerTooltip:Hide()
    BattlePetTooltip:Hide()

    self.AnimOut:Play()

    AL:UnregisterEvent("MODIFIER_STATE_CHANGED")
end

function AL:MODIFIER_STATE_CHANGED()
    if IsModifiedClick("COMPAREITEMS") or GetCVarBool("alwaysCompareItems") then
        GameTooltip_ShowCompareItem()
    else
        ShoppingTooltip1:Hide()
        ShoppingTooltip2:Hide()
    end
end

local function ToastButtonAnimIn_OnStop(self)
    local frame = self:GetParent()

    if frame.Arrows then
        frame.Arrows.requested = false
    end
end

local function ToastButtonAnimIn_OnFinished(self)
    local frame = self:GetParent()

    if frame.Arrows and frame.Arrows.requested then
        --- XXX: Parent translation anims affect child's translation anims
        C_Timer.After(0.1, function() frame.Arrows.Anim:Play() end)

        frame.Arrows.requested = false
    end
end

local function ToastButtonAnimOut_OnFinished(self)
    RecycleToast(self:GetParent())
end

local function CreateBaseToastButton()
    toastCounter = toastCounter + 1

    local toast = CreateFrame("Button", "LSToast"..toastCounter, R.UIParent)
    toast:RegisterForClicks("LeftButtonUp", "RightButtonUp")
    toast:Hide()
    toast:SetScript("OnShow", ToastButton_OnShow)
    toast:SetScript("OnClick", ToastButton_OnClick)
    toast:SetScript("OnEnter", ToastButton_OnEnter)
    toast:SetScript("OnLeave", ToastButton_OnLeave)
    toast:SetSize(234, 58)
    toast:SetScale(CFG.scale)
    toast:SetFrameStrata("DIALOG")

    local bg = toast:CreateTexture(nil, "BACKGROUND", nil, 0)
    bg:SetPoint("TOPLEFT", 5, -5)
    bg:SetPoint("BOTTOMRIGHT", -5, 5)
    bg:SetTexture("Interface\\AddOns\\RayUI\\media\\toast-bg-default")
    bg:SetTexCoord(1 / 256, 225 / 256, 1 / 64, 49 / 64)
    toast.BG = bg

    local border = toast:CreateTexture(nil, "BACKGROUND", nil, 1)
    border:SetAllPoints()
    border:SetTexture("Interface\\AddOns\\RayUI\\media\\toast-border")
    border:SetTexCoord(1 / 256, 235 / 256, 1 / 64, 59 / 64)
    toast.Border = border

    local icon = toast:CreateTexture(nil, "BACKGROUND", nil, 2)
    icon:SetPoint("TOPLEFT", 7, -7)
    icon:SetSize(44, 44)
    toast.Icon = icon

    local title = toast:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    title:SetPoint("TOPLEFT", 55, -12)
    title:SetWidth(170)
    title:SetJustifyH("CENTER")
    title:SetWordWrap(false)
    title:SetText("Toast Title")
    toast.Title = title

    local text = toast:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
    text:SetPoint("BOTTOMLEFT", 55, 12)
    text:SetWidth(170)
    text:SetJustifyH("CENTER")
    text:SetWordWrap(false)
    text:SetText(toast:GetDebugName())
    toast.Text = text

    local textBG = toast:CreateTexture(nil, "BACKGROUND", nil, 2)
    textBG:SetSize(174, 44)
    textBG:SetPoint("BOTTOMLEFT", 53, 7)
    textBG:SetTexture("Interface\\AddOns\\RayUI\\media\\toast-text-bg")
    textBG:SetTexCoord(1 / 256, 175 / 256, 1 / 64, 45 / 64)
    textBG:SetVertexColor(0, 0, 0)
    toast.TextBG = textBG

    local glow = toast:CreateTexture(nil, "OVERLAY", nil, 2)
    glow:SetSize(310, 148)
    glow:SetPoint("CENTER")
    glow:SetTexture("Interface\\AchievementFrame\\UI-Achievement-Alert-Glow")
    glow:SetTexCoord(0, 0.78125, 0, 0.66796875)
    glow:SetBlendMode("ADD")
    glow:SetAlpha(0)
    toast.Glow = glow

    local shine = toast:CreateTexture(nil, "OVERLAY", nil, 1)
    shine:SetSize(67, 54)
    shine:SetPoint("BOTTOMLEFT", 0, 2)
    shine:SetTexture("Interface\\AchievementFrame\\UI-Achievement-Alert-Glow")
    shine:SetTexCoord(400 / 512, 467 / 512, 11 / 256, 65 / 256)
    shine:SetBlendMode("ADD")
    shine:SetAlpha(0)
    toast.Shine = shine

    local animIn = toast:CreateAnimationGroup()
    animIn:SetScript("OnStop", ToastButtonAnimIn_OnStop)
    animIn:SetScript("OnFinished", ToastButtonAnimIn_OnFinished)
    toast.AnimIn = animIn

    local anim1 = animIn:CreateAnimation("Alpha")
    anim1:SetChildKey("Glow")
    anim1:SetOrder(1)
    anim1:SetFromAlpha(0)
    anim1:SetToAlpha(1)
    anim1:SetDuration(0.2)

    local anim2 = animIn:CreateAnimation("Alpha")
    anim2:SetChildKey("Glow")
    anim2:SetOrder(2)
    anim2:SetFromAlpha(1)
    anim2:SetToAlpha(0)
    anim2:SetDuration(0.5)

    local anim3 = animIn:CreateAnimation("Alpha")
    anim3:SetChildKey("Shine")
    anim3:SetOrder(1)
    anim3:SetFromAlpha(0)
    anim3:SetToAlpha(1)
    anim3:SetDuration(0.2)

    local anim4 = animIn:CreateAnimation("Translation")
    anim4:SetChildKey("Shine")
    anim4:SetOrder(2)
    anim4:SetOffset(168, 0)
    anim4:SetDuration(0.85)

    local anim5 = animIn:CreateAnimation("Alpha")
    anim5:SetChildKey("Shine")
    anim5:SetOrder(2)
    anim5:SetFromAlpha(1)
    anim5:SetToAlpha(0)
    anim5:SetStartDelay(0.35)
    anim5:SetDuration(0.5)

    local animOut = toast:CreateAnimationGroup()
    animOut:SetScript("OnFinished", ToastButtonAnimOut_OnFinished)
    toast.AnimOut = animOut

    anim1 = animOut:CreateAnimation("Alpha")
    anim1:SetOrder(1)
    anim1:SetFromAlpha(1)
    anim1:SetToAlpha(0)
    anim1:SetStartDelay(CFG.fadeout_delay)
    anim1:SetDuration(1.2)
    animOut.Anim1 = anim1

    return toast
end

local ARROW_CFG = {
    [1] = {startDelay1 = 0.9, startDelay2 = 1.2, point = {"TOP", "$parent", "CENTER", 8, 0}},
    [2] = {startDelay1 = 1.0, startDelay2 = 1.3, point = {"CENTER", "$parentArrow1", 16, 0}},
    [3] = {startDelay1 = 1.1, startDelay2 = 1.4, point = {"CENTER", "$parentArrow1", -16, 0}},
    [4] = {startDelay1 = 1.3, startDelay2 = 1.6, point = {"CENTER", "$parentArrow1", 5, 0}},
    [5] = {startDelay1 = 1.5, startDelay2 = 1.8, point = {"CENTER", "$parentArrow1", -12, 0}},
}

local function ShowArrows(self)
    self:GetParent():Show()
end

local function HideArrows(self)
    self:GetParent():Hide()
end

local function CreateUpdateArrowsAnim(parent)
    local frame = CreateFrame("Frame", "$parentUpgradeArrows", parent)
    frame:SetSize(48, 48)
    frame:Hide()

    local ag = frame:CreateAnimationGroup()
    ag:SetScript("OnPlay", ShowArrows)
    ag:SetScript("OnFinished", HideArrows)
    ag:SetScript("OnStop", HideArrows)
    frame.Anim = ag

    for i = 1, 5 do
        frame["Arrow"..i] = frame:CreateTexture("$parentArrow"..i, "ARTWORK", "LootUpgradeFrame_ArrowTemplate")
        frame["Arrow"..i]:ClearAllPoints()
        frame["Arrow"..i]:SetPoint(unpack(ARROW_CFG[i].point))

        local anim = ag:CreateAnimation("Alpha")
        anim:SetChildKey("Arrow"..i)
        anim:SetDuration(0)
        anim:SetOrder(1)
        anim:SetFromAlpha(1)
        anim:SetToAlpha(0)

        anim = ag:CreateAnimation("Alpha")
        anim:SetChildKey("Arrow"..i)
        anim:SetStartDelay(ARROW_CFG[i].startDelay1)
        anim:SetSmoothing("IN")
        anim:SetDuration(0.2)
        anim:SetOrder(2)
        anim:SetFromAlpha(0)
        anim:SetToAlpha(1)

        anim = ag:CreateAnimation("Alpha")
        anim:SetChildKey("Arrow"..i)
        anim:SetStartDelay(ARROW_CFG[i].startDelay2)
        anim:SetSmoothing("OUT")
        anim:SetDuration(0.2)
        anim:SetOrder(2)
        anim:SetFromAlpha(1)
        anim:SetToAlpha(0)

        anim = ag:CreateAnimation("Translation")
        anim:SetChildKey("Arrow"..i)
        anim:SetStartDelay(ARROW_CFG[i].startDelay1)
        anim:SetDuration(0.5)
        anim:SetOrder(2)
        anim:SetOffset(0, 60)

        anim = ag:CreateAnimation("Alpha")
        anim:SetChildKey("Arrow"..i)
        anim:SetDuration(0)
        anim:SetOrder(3)
        anim:SetFromAlpha(1)
        anim:SetToAlpha(0)
    end

    return frame
end

local function Reward_OnEnter(self)
    self:GetParent().AnimOut:Stop()

    GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT")

    if self.item then
        GameTooltip:SetHyperlink(self.item)
    elseif self.xp then
        GameTooltip:AddLine(YOU_RECEIVED)
        GameTooltip:AddLine(string.format(BONUS_OBJECTIVE_EXPERIENCE_FORMAT, self.xp), 1, 1, 1)
    elseif self.money then
        GameTooltip:AddLine(YOU_RECEIVED)
        GameTooltip:AddLine(GetMoneyString(self.money), 1, 1, 1)
    elseif self.item then
        GameTooltip:SetHyperlink(self.item)
    elseif self.currency then
        GameTooltip:SetQuestLogCurrency("reward", self.currency, self:GetParent().id)
    end

    GameTooltip:Show()
end

local function Reward_OnLeave(self)
    self:GetParent().AnimOut:Play()
    GameTooltip:Hide()
end

local function Reward_OnHide(self)
    self.rewardID = nil
    self.currency = nil
    self.money = nil
    self.item = nil
    self.xp = nil
end

local function CreateToastReward(parent, index)
    local reward = CreateFrame("Frame", "$parent"..index, parent)
    reward:SetSize(30, 30)
    reward:SetScript("OnEnter", Reward_OnEnter)
    reward:SetScript("OnLeave", Reward_OnLeave)
    reward:SetScript("OnHide", Reward_OnHide)
    reward:Hide()
    parent["Reward"..index] = reward

    local icon = reward:CreateTexture(nil, "BACKGROUND")
    icon:SetPoint("TOPLEFT", 5, -4)
    icon:SetPoint("BOTTOMRIGHT", -7, 8)
    reward.Icon = icon

    local border = reward:CreateTexture(nil, "BORDER")
    border:SetAllPoints()
    border:SetTexture("Interface\\LFGFrame\\UI-LFG-ICON-REWARDRING")
    border:SetTexCoord(0 / 64, 40 / 64, 0 / 64, 40 / 64)

    return reward
end

local function GetToast(toastType)
    local toast

    if toastType == "item" then
        toast = table.remove(itemToasts, 1)

        if not toast then
            toast = CreateBaseToastButton()

            local arrows = CreateUpdateArrowsAnim(toast)
            arrows:SetPoint("TOPLEFT", -5, 5)
            toast.Arrows = arrows

            local iconBorder = toast:CreateTexture(nil, "ARTWORK", nil, 2)
            iconBorder:SetPoint("TOPLEFT", 7, -7)
            iconBorder:SetSize(44, 44)
            iconBorder:SetTexture("Interface\\AddOns\\RayUI\\media\\toast-icon-border")
            iconBorder:SetTexCoord(1 / 64, 45 / 64, 1 / 64, 45 / 64)
            toast.IconBorder = iconBorder

            local count = toast:CreateFontString(nil, "ARTWORK", "GameFontHighlightOutline")
            count:SetPoint("BOTTOMRIGHT", toast.Icon, "BOTTOMRIGHT", 0, 2)
            count:SetJustifyH("RIGHT")
            count.SetAnimatedText = SetAnimatedText
            toast.Count = count

            local countUpdate = toast:CreateFontString(nil, "ARTWORK", "GameFontHighlightOutline")
            countUpdate:SetPoint("BOTTOMRIGHT", toast.Count, "TOPRIGHT", 0, 2)
            countUpdate:SetJustifyH("RIGHT")
            countUpdate:SetAlpha(0)
            toast.CountUpdate = countUpdate

            local upgradeIcon = toast:CreateTexture(nil, "ARTWORK", nil, 3)
            upgradeIcon:SetAtlas("bags-greenarrow", true)
            upgradeIcon:SetPoint("TOPLEFT", 4, -4)
            upgradeIcon:Hide()
            toast.UpgradeIcon = upgradeIcon

            local ag = toast:CreateAnimationGroup()
            toast.CountUpdateAnim = ag

            local anim1 = ag:CreateAnimation("Alpha")
            anim1:SetChildKey("CountUpdate")
            anim1:SetOrder(1)
            anim1:SetFromAlpha(0)
            anim1:SetToAlpha(1)
            anim1:SetDuration(0.2)

            local anim2 = ag:CreateAnimation("Alpha")
            anim2:SetChildKey("CountUpdate")
            anim2:SetOrder(2)
            anim2:SetFromAlpha(1)
            anim2:SetToAlpha(0)
            anim2:SetStartDelay(0.4)
            anim2:SetDuration(0.8)

            local dragon = toast:CreateTexture(nil, "OVERLAY", nil, 0)
            dragon:SetPoint("TOPLEFT", -23, 13)
            dragon:SetSize(88, 88)
            dragon:SetTexture("Interface\\DialogFrame\\UI-DialogBox-Gold-Dragon")
            dragon:SetVertexColor(250 / 255, 200 / 255, 0 / 255)
            dragon:Hide()
            toast.Dragon = dragon

            toast.type = "item"
        end
    elseif toastType == "mission" then
        toast = table.remove(missonToasts, 1)

        if not toast then
            toast = CreateBaseToastButton()

            local level = toast:CreateFontString(nil, "ARTWORK", "GameFontHighlightOutline")
            level:SetPoint("BOTTOMRIGHT", toast.Icon, "BOTTOMRIGHT", 0, 2)
            level:SetJustifyH("RIGHT")
            toast.Level = level

            toast.type = "mission"
        end
    elseif toastType == "follower" then
        toast = table.remove(followerToasts, 1)

        if not toast then
            toast = CreateBaseToastButton()

            local arrows = CreateUpdateArrowsAnim(toast)
            arrows:SetPoint("TOPLEFT", -5, 5)
            toast.Arrows = arrows

            local level = toast:CreateFontString(nil, "ARTWORK", "GameFontHighlightOutline")
            level:SetPoint("BOTTOMRIGHT", toast.Icon, "BOTTOMRIGHT", 0, 2)
            level:SetJustifyH("RIGHT")
            toast.Level = level

            toast.type = "follower"
        end
    elseif toastType == "achievement" then
        toast = table.remove(achievementToasts, 1)

        if not toast then
            toast = CreateBaseToastButton()

            local iconBorder = toast:CreateTexture(nil, "ARTWORK", nil, 2)
            iconBorder:SetPoint("TOPLEFT", 7, -7)
            iconBorder:SetSize(44, 44)
            iconBorder:SetTexture("Interface\\AddOns\\RayUI\\media\\toast-icon-border")
            iconBorder:SetTexCoord(1 / 64, 45 / 64, 1 / 64, 45 / 64)
            toast.IconBorder = iconBorder

            local points = toast:CreateFontString(nil, "ARTWORK", "GameFontHighlightOutline")
            points:SetPoint("BOTTOMRIGHT", toast.Icon, "BOTTOMRIGHT", 0, 2)
            points:SetJustifyH("RIGHT")
            toast.Points = points

            toast.type = "achievement"
        end
    elseif toastType == "ability" then
        toast = table.remove(abilityToasts, 1)

        if not toast then
            toast = CreateBaseToastButton()

            local iconBorder = toast:CreateTexture(nil, "ARTWORK", nil, 2)
            iconBorder:SetPoint("TOPLEFT", 7, -7)
            iconBorder:SetSize(44, 44)
            iconBorder:SetTexture("Interface\\AddOns\\RayUI\\media\\toast-icon-border")
            iconBorder:SetTexCoord(1 / 64, 45 / 64, 1 / 64, 45 / 64)
            toast.IconBorder = iconBorder

            local rank = toast:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
            rank:SetPoint("BOTTOMRIGHT", toast.Icon, "BOTTOMRIGHT", -2, 2)
            rank:SetJustifyH("RIGHT")
            toast.Rank = rank

            toast.type = "ability"
        end
    elseif toastType == "scenario" then
        toast = table.remove(scenarioToasts, 1)

        if not toast then
            toast = CreateBaseToastButton()

            local iconBorder = toast:CreateTexture(nil, "ARTWORK", nil, 2)
            iconBorder:SetPoint("TOPLEFT", 7, -7)
            iconBorder:SetSize(44, 44)
            iconBorder:SetTexture("Interface\\AddOns\\RayUI\\media\\toast-icon-border")
            iconBorder:SetTexCoord(1 / 64, 45 / 64, 1 / 64, 45 / 64)
            toast.IconBorder = iconBorder

            for i = 1, 5 do
                local reward = CreateToastReward(toast, i)

                if i == 1 then
                    reward:SetPoint("TOPRIGHT", -2, 10)
                else
                    reward:SetPoint("RIGHT", toast["Reward"..(i - 1)], "LEFT", -2 , 0)
                end
            end

            local bonus = toast:CreateTexture(nil, "ARTWORK")
            bonus:SetAtlas("Bonus-ToastBanner", true)
            bonus:SetPoint("TOPRIGHT", -4, 0)
            bonus:Hide()
            toast.Bonus = bonus

            local heroic = toast:CreateTexture(nil, "ARTWORK", nil, 2)
            heroic:SetSize(16, 20)
            heroic:SetTexture("Interface\\LFGFrame\\UI-LFG-ICON-HEROIC")
            heroic:SetTexCoord(0 / 32, 16 / 32, 0 / 32, 20 / 32)
            heroic:SetPoint("BOTTOMRIGHT", toast.Icon, "BOTTOMRIGHT", -2, 0)
            heroic:Hide()
            toast.Heroic = heroic

            toast.type = "scenario"
        end
    elseif toastType == "misc" then
        toast = table.remove(miscToasts, 1)

        if not toast then
            toast = CreateBaseToastButton()

            local iconBorder = toast:CreateTexture(nil, "ARTWORK", nil, 2)
            iconBorder:SetPoint("TOPLEFT", 7, -7)
            iconBorder:SetSize(44, 44)
            iconBorder:SetTexture("Interface\\AddOns\\RayUI\\media\\toast-icon-border")
            iconBorder:SetTexCoord(1 / 64, 45 / 64, 1 / 64, 45 / 64)
            toast.IconBorder = iconBorder

            local text = toast:CreateFontString(nil, "ARTWORK", "GameFontHighlightOutline")
            text:SetPoint("BOTTOMRIGHT", toast.Icon, "BOTTOMRIGHT", 0, 2)
            text:SetJustifyH("RIGHT")
            toast.IconText = text

            toast.type = "misc"
        end
    end

    return toast
end

------------------
-- ANCHOR HIDER --
------------------

function AL:PLAYER_REGEN_DISABLED()
    if anchorFrame:IsMouseEnabled() then
        Anchor_OnDragStop(anchorFrame)
        Anchor_Disable()
    end
end

---------
-- DND --
---------

function AL:PLAYER_REGEN_ENABLED()
    if IsDNDEnabled() and #queuedToasts > 0 then
        for _ = 1, CFG.max_active_toasts - #activeToasts do
            RefreshToasts()
        end
    end
end

-----------------
-- ACHIEVEMENT --
-----------------

local function AchievementToast_SetUp(achievementID, flag, isCriteria)
    local toast = GetToast("achievement")
    local _, name, points, _, _, _, _, _, _, icon = GetAchievementInfo(achievementID)

    if isCriteria then
        toast.Title:SetText(ACHIEVEMENT_PROGRESSED)
        toast.Text:SetText(flag)

        toast.Border:SetVertexColor(1, 1, 1)
        toast.IconBorder:SetVertexColor(1, 1, 1)
        toast.Points:SetText("")
    else
        toast.Title:SetText(ACHIEVEMENT_UNLOCKED)
        toast.Text:SetText(name)

        -- alreadyEarned
        if flag then
            toast.Border:SetVertexColor(1, 1, 1)
            toast.IconBorder:SetVertexColor(1, 1, 1)
            toast.Points:SetText("")
        else
            toast.Border:SetVertexColor(0.9, 0.75, 0.26)
            toast.IconBorder:SetVertexColor(0.9, 0.75, 0.26)
            toast.Points:SetText(points == 0 and "" or points)
        end
    end

    toast.Icon:SetTexture(icon)
    toast.id = achievementID

    SpawnToast(toast, CFG.dnd.achievement)
end

function AL:ACHIEVEMENT_EARNED(...)
    local _, achievementID, alreadyEarned = ...

    AchievementToast_SetUp(achievementID, alreadyEarned, nil)

end

function AL:CRITERIA_EARNED(...)
    local _, achievementID, criteriaString = ...

    AchievementToast_SetUp(achievementID, criteriaString, true)
end

local function EnableAchievementToasts()
    if CFG.achievement_enabled then
        AL:RegisterEvent("ACHIEVEMENT_EARNED")
        AL:RegisterEvent("CRITERIA_EARNED")
    end
end

local function DisableAchievementToasts()
    AL:UnregisterEvent("ACHIEVEMENT_EARNED")
    AL:UnregisterEvent("CRITERIA_EARNED")
end

-----------------
-- ARCHAEOLOGY --
-----------------

function AL:ARTIFACT_DIGSITE_COMPLETE(...)
    local _, researchFieldID = ...
    local raceName, raceTexture = GetArchaeologyRaceInfoByID(researchFieldID)
    local toast = GetToast("misc")

    toast.Border:SetVertexColor(0.9, 0.4, 0.1)
    toast.Title:SetText(ARCHAEOLOGY_DIGSITE_COMPLETE_TOAST_FRAME_TITLE)
    toast.Text:SetText(raceName)
    toast.BG:SetTexture("Interface\\AddOns\\RayUI\\media\\toast-bg-archaeology")
    toast.IconBorder:Hide()
    toast.Icon:SetPoint("TOPLEFT", 7, -3)
    toast.Icon:SetSize(76, 76)
    toast.Icon:SetTexture(raceTexture)
    toast.soundFile = "UI_DigsiteCompletion_Toast"

    SpawnToast(toast, CFG.dnd.archaeology)
end

local function ArcheologyProgressBarAnimOut_OnFinished(self)
    self:GetParent():Hide()
end

local function EnableArchaeologyToasts()
    if not ArchaeologyFrame then
        local hooked = false

        hooksecurefunc("ArchaeologyFrame_LoadUI", function()
                if not hooked then
                    ArcheologyDigsiteProgressBar.AnimOutAndTriggerToast:SetScript("OnFinished", ArcheologyProgressBarAnimOut_OnFinished)

                    hooked = true
                end
            end)
    else
        ArcheologyDigsiteProgressBar.AnimOutAndTriggerToast:SetScript("OnFinished", ArcheologyProgressBarAnimOut_OnFinished)
    end

    if CFG.archaeology_enabled then
        AL:RegisterEvent("ARTIFACT_DIGSITE_COMPLETE")
    end
end

local function DisableArchaeologyToasts()
    AL:UnregisterEvent("ARTIFACT_DIGSITE_COMPLETE")
end

--------------
-- GARRISON --
--------------

local function GetGarrisonTypeByFollowerType(followerType)
    if followerType == LE_FOLLOWER_TYPE_GARRISON_7_0 then
        return LE_GARRISON_TYPE_7_0
    elseif followerType == LE_FOLLOWER_TYPE_GARRISON_6_0 or followerType == LE_FOLLOWER_TYPE_SHIPYARD_6_2 then
        return LE_GARRISON_TYPE_6_0
    end
end

local function GarrisonMissionToast_SetUp(followerType, garrisonType, missionID, isAdded)
    local toast = GetToast("mission")
    local missionInfo = C_Garrison.GetBasicMissionInfo(missionID)
    local color = missionInfo.isRare and ITEM_QUALITY_COLORS[3] or ITEM_QUALITY_COLORS[1]
    local level = missionInfo.iLevel == 0 and missionInfo.level or missionInfo.iLevel

    if isAdded then
        toast.Title:SetText(GARRISON_MISSION_ADDED_TOAST1)
    else
        toast.Title:SetText(GARRISON_MISSION_COMPLETE)
    end

    if CFG.colored_names_enabled then
        toast.Text:SetTextColor(color.r, color.g, color.b)
    end

    toast.Text:SetText(missionInfo.name)
    toast.Level:SetText(level)
    toast.Border:SetVertexColor(color.r, color.g, color.b)
    toast.Icon:SetAtlas(missionInfo.typeAtlas, false)
    toast.soundFile = "UI_Garrison_Toast_MissionComplete"
    toast.id = missionID

    SpawnToast(toast, garrisonType == LE_GARRISON_TYPE_7_0 and CFG.dnd.garrison_7_0 or CFG.dnd.garrison_6_0)
end

function AL:GARRISON_MISSION_FINISHED(...)
    local _, followerType, missionID = ...
    local garrisonType = GetGarrisonTypeByFollowerType(followerType)

    if (garrisonType == LE_GARRISON_TYPE_7_0 and not CFG.garrison_7_0_enabled) or
    (garrisonType == LE_GARRISON_TYPE_6_0 and not CFG.garrison_6_0_enabled) then
        return
    end

    local _, instanceType = GetInstanceInfo()
    local validInstance = false

    if instanceType == "none" or C_Garrison.IsOnGarrisonMap() then
        validInstance = true
    end

    if validInstance then
        GarrisonMissionToast_SetUp(followerType, garrisonType, missionID)
    end
end

function AL:GARRISON_RANDOM_MISSION_ADDED(...)
    local _, followerType, missionID = ...
    local garrisonType = GetGarrisonTypeByFollowerType(followerType)

    if (garrisonType == LE_GARRISON_TYPE_7_0 and not CFG.garrison_7_0_enabled) or
    (garrisonType == LE_GARRISON_TYPE_6_0 and not CFG.garrison_6_0_enabled) then
        return
    end

    GarrisonMissionToast_SetUp(followerType, garrisonType, missionID, true)
end

local function GarrisonFollowerToast_SetUp(followerType, garrisonType, followerID, name, texPrefix, level, quality, isUpgraded)
    local toast = GetToast("follower")
    local followerInfo = C_Garrison.GetFollowerInfo(followerID)
    local followerStrings = GarrisonFollowerOptions[followerType].strings
    local upgradeTexture = LOOTUPGRADEFRAME_QUALITY_TEXTURES[quality] or LOOTUPGRADEFRAME_QUALITY_TEXTURES[2]
    local color = ITEM_QUALITY_COLORS[quality]

    if followerType == LE_FOLLOWER_TYPE_SHIPYARD_6_2 then
        toast.Icon:SetSize(84, 44)
        toast.Icon:SetAtlas(texPrefix.."-List", false)
        toast.Level:SetText("")
    else
        local portrait

        if followerInfo.portraitIconID and followerInfo.portraitIconID ~= 0 then
            portrait = followerInfo.portraitIconID
        else
            portrait = "Interface\\Garrison\\Portraits\\FollowerPortrait_NoPortrait"
        end

        toast.Icon:SetSize(44, 44)
        toast.Icon:SetTexture(portrait)
        toast.Level:SetText(level)
    end

    if isUpgraded then
        toast.Title:SetText(followerStrings.FOLLOWER_ADDED_UPGRADED_TOAST)
        toast.BG:SetTexture("Interface\\AddOns\\RayUI\\media\\toast-bg-upgrade")

        for i = 1, 5 do
            toast.Arrows["Arrow"..i]:SetAtlas(upgradeTexture.arrow, true)
        end

        toast.Arrows.requested = true
    else
        toast.Title:SetText(followerStrings.FOLLOWER_ADDED_TOAST)
    end

    if CFG.colored_names_enabled then
        toast.Text:SetTextColor(color.r, color.g, color.b)
    end

    toast.Text:SetText(name)
    toast.Border:SetVertexColor(color.r, color.g, color.b)
    toast.soundFile = "UI_Garrison_Toast_FollowerGained"
    toast.id = followerID

    SpawnToast(toast, garrisonType == LE_GARRISON_TYPE_7_0 and CFG.dnd.garrison_7_0 or CFG.dnd.garrison_6_0)
end

function AL:GARRISON_FOLLOWER_ADDED(...)
    local _, followerID, name, _, level, quality, isUpgraded, texPrefix, followerType = ...
    local garrisonType = GetGarrisonTypeByFollowerType(followerType)

    if (garrisonType == LE_GARRISON_TYPE_7_0 and not CFG.garrison_7_0_enabled) or
    (garrisonType == LE_GARRISON_TYPE_6_0 and not CFG.garrison_6_0_enabled) then
        return
    end

    GarrisonFollowerToast_SetUp(followerType, garrisonType, followerID, name, texPrefix, level, quality, isUpgraded)
end

function AL:GARRISON_BUILDING_ACTIVATABLE(...)
    local _, buildingName = ...
    local toast = GetToast("misc")

    toast.Title:SetText(GARRISON_UPDATE)
    toast.Text:SetText(buildingName)
    toast.Icon:SetTexture("Interface\\Icons\\Garrison_Build")
    toast.soundFile = "UI_Garrison_Toast_BuildingComplete"

    SpawnToast(toast, CFG.dnd.garrison_6_0)
end

function AL:GARRISON_TALENT_COMPLETE(...)
    local _, garrisonType = ...
    local talentID = C_Garrison.GetCompleteTalent(garrisonType)
    local talent = C_Garrison.GetTalent(talentID)
    local toast = GetToast("misc")

    toast.Title:SetText(GARRISON_TALENT_ORDER_ADVANCEMENT)
    toast.Text:SetText(talent.name)
    toast.Icon:SetTexture(talent.icon)
    toast.soundFile = "UI_OrderHall_Talent_Ready_Toast"

    SpawnToast(toast, CFG.dnd.garrison_7_0)
end

local function EnableGarrisonToasts()
    if CFG.garrison_6_0_enabled or CFG.garrison_7_0_enabled then
        AL:RegisterEvent("GARRISON_FOLLOWER_ADDED")
        AL:RegisterEvent("GARRISON_MISSION_FINISHED")
        AL:RegisterEvent("GARRISON_RANDOM_MISSION_ADDED")

        if CFG.garrison_6_0_enabled then
            AL:RegisterEvent("GARRISON_BUILDING_ACTIVATABLE")
        end

        if CFG.garrison_7_0_enabled then
            AL:RegisterEvent("GARRISON_TALENT_COMPLETE")
        end
    end
end

local function DisableGarrisonToasts()
    if not CFG.garrison_6_0_enabled and not CFG.garrison_7_0_enabled then
        AL:UnregisterEvent("GARRISON_FOLLOWER_ADDED")
        AL:UnregisterEvent("GARRISON_MISSION_FINISHED")
        AL:UnregisterEvent("GARRISON_RANDOM_MISSION_ADDED")
    end

    if not CFG.garrison_6_0_enabled then
        AL:UnregisterEvent("GARRISON_BUILDING_ACTIVATABLE")
    end

    if not CFG.garrison_7_0_enabled then
        AL:UnregisterEvent("GARRISON_TALENT_COMPLETE")
    end
end

--------------
-- INSTANCE --
--------------

local function LFGToast_SetUp(isScenario)
    local toast = GetToast("scenario")
    local name, _, subtypeID, textureFilename, moneyBase, moneyVar, experienceBase, experienceVar, numStrangers, numRewards = GetLFGCompletionReward()
    -- local name, typeID, subtypeID, textureFilename, moneyBase, moneyVar, experienceBase, experienceVar, numStrangers, numRewards =
    -- "The Vortex Pinnacle", 1, 2, "THEVORTEXPINNACLE", 308000, 0, 0, 0, 0, 0
    local money = moneyBase + moneyVar * numStrangers
    local xp = experienceBase + experienceVar * numStrangers
    local title = DUNGEON_COMPLETED
    local usedRewards = 0

    if money > 0 then
        usedRewards = usedRewards + 1
        local reward = toast["Reward"..usedRewards]

        if reward then
            SetPortraitToTexture(reward.Icon, "Interface\\Icons\\inv_misc_coin_02")
            reward.money = money
            reward:Show()
        end
    end

    if xp > 0 and UnitLevel("player") < MAX_PLAYER_LEVEL then
        usedRewards = usedRewards + 1
        local reward = toast["Reward"..usedRewards]

        if reward then
            SetPortraitToTexture(reward.Icon, "Interface\\Icons\\xp_icon")
            reward.xp = xp
            reward:Show()
        end
    end

    for i = 1, numRewards do
        usedRewards = usedRewards + 1
        local reward = toast["Reward"..usedRewards]

        if reward then
            local icon = GetLFGCompletionRewardItem(i)
            local isOK = pcall(SetPortraitToTexture, reward.Icon, icon)

            if not isOK then
                SetPortraitToTexture(reward.Icon, "Interface\\Icons\\INV_Box_02")
            end

            reward.rewardID = i
            reward:Show()

            usedRewards = i
        end
    end

    if isScenario then
        local _, _, _, _, hasBonusStep, isBonusStepComplete = C_Scenario.GetInfo()

        if hasBonusStep and isBonusStepComplete then
            toast.Bonus:Show()
        end

        title = SCENARIO_COMPLETED
    end

    if subtypeID == LFG_SUBTYPEID_HEROIC then
        toast.Heroic:Show()
    end

    toast.Title:SetText(title)
    toast.Text:SetText(name)
    toast.BG:SetTexture("Interface\\AddOns\\RayUI\\media\\toast-bg-dungeon")
    toast.Icon:SetTexture("Interface\\LFGFrame\\LFGIcon-"..textureFilename)
    toast.usedRewards = usedRewards

    if isScenario then
        toast.soundFile = "UI_Scenario_Ending"
    else
        toast.soundFile = "LFG_Rewards"
    end

    SpawnToast(toast, CFG.dnd.instance)
end

function AL:LFG_COMPLETION_REWARD()
    if C_Scenario.IsInScenario() and not C_Scenario.TreatScenarioAsDungeon() then

        if select(10, C_Scenario.GetInfo()) ~= LE_SCENARIO_TYPE_LEGION_INVASION then
            LFGToast_SetUp(true)
        end
    else
        LFGToast_SetUp()
    end
end

local function EnableInstanceToasts()
    if CFG.instance_enabled then
        AL:RegisterEvent("LFG_COMPLETION_REWARD")
    end
end

local function DisableInstanceToasts()
    AL:UnregisterEvent("LFG_COMPLETION_REWARD")
end

----------
-- LOOT --
----------

local function LootWonToast_Setup(itemLink, quantity, rollType, roll, showFaction, isItem, isMoney, lessAwesome, isUpgraded, isPersonal)
    local toast

    if isItem then
        if itemLink then
            toast = GetToast("item")
            itemLink = FixItemLink(itemLink)
            local title = YOU_WON_LABEL
            local name, _, quality, _, _, _, _, _, _, icon = GetItemInfo(itemLink)

            if isPersonal or lessAwesome then
                title = YOU_RECEIVED_LABEL
            end

            if isUpgraded then
                title = ITEM_UPGRADED_LABEL
                local upgradeTexture = LOOTUPGRADEFRAME_QUALITY_TEXTURES[quality or 2]

                for i = 1, 5 do
                    toast.Arrows["Arrow"..i]:SetAtlas(upgradeTexture.arrow, true)
                end

                toast.Arrows.requested = true

                toast.BG:SetTexture("Interface\\AddOns\\RayUI\\media\\toast-bg-upgrade")
            end

            if rollType == LOOT_ROLL_TYPE_NEED then
                title = title.." |cff00ff00"..roll.."|r"..INLINE_NEED
            elseif rollType == LOOT_ROLL_TYPE_GREED then
                title = title.." |cff00ff00"..roll.."|r"..INLINE_GREED
            elseif rollType == LOOT_ROLL_TYPE_DISENCHANT then
                title = title.." |cff00ff00"..roll.."|r"..INLINE_DE
            end

            if showFaction then
                -- local factionGroup = "Horde"
                local factionGroup = UnitFactionGroup("player")

                toast.BG:SetTexture("Interface\\AddOns\\RayUI\\media\\toast-bg-"..factionGroup)
            end

            local color = ITEM_QUALITY_COLORS[quality or 1]

            if CFG.colored_names_enabled then
                toast.Text:SetTextColor(color.r, color.g, color.b)
            end

            toast.Title:SetText(title)
            toast.Text:SetText(name)
            toast.Count:SetText(quantity > 1 and quantity or "")
            toast.Border:SetVertexColor(color.r, color.g, color.b)
            toast.IconBorder:SetVertexColor(color.r, color.g, color.b)
            toast.Icon:SetTexture(icon)
            toast.UpgradeIcon:SetShown(IsItemAnUpgrade(itemLink))
            toast.link = itemLink

            if lessAwesome then
                toast.soundFile = 51402
            elseif isUpgraded then
                toast.soundFile = 51561
            else
                toast.soundFile = 31578
            end
        end
    elseif isMoney then
        toast = GetToast("misc")

        toast.Border:SetVertexColor(0.9, 0.75, 0.26)
        toast.IconBorder:SetVertexColor(0.9, 0.75, 0.26)
        toast.Title:SetText(YOU_WON_LABEL)
        toast.Text:SetText(GetMoneyString(quantity))
        toast.Icon:SetTexture("Interface\\Icons\\INV_Misc_Coin_02")
        toast.soundFile = 31578
    end

    if toast then
        SpawnToast(toast, CFG.dnd.loot_special)
    end
end

local function BonusRollFrame_FinishedFading_Disabled(self)
    local frame = self:GetParent()

    GroupLootContainer_RemoveFrame(GroupLootContainer, frame)
end

local function BonusRollFrame_FinishedFading_Enabled(self)
    local frame = self:GetParent()

    LootWonToast_Setup(frame.rewardLink, frame.rewardQuantity, nil, nil, nil, frame.rewardType == "item", frame.rewardType == "money")
    GroupLootContainer_RemoveFrame(GroupLootContainer, frame)
end

function AL:LOOT_ITEM_ROLL_WON(...)
    local _, itemLink, quantity, rollType, roll, isUpgraded = ...

    LootWonToast_Setup(itemLink, quantity, rollType, roll, nil, true, nil, nil, isUpgraded)
end

function AL:SHOW_LOOT_TOAST(...)
    local _, typeID, itemLink, quantity, _, _, isPersonal, _, lessAwesome, isUpgraded = ...

    LootWonToast_Setup(itemLink, quantity, nil, nil, nil, typeID == "item", typeID == "money", lessAwesome, isUpgraded, isPersonal)
end

function AL:SHOW_LOOT_TOAST_LEGENDARY_LOOTED(...)
    local _, itemLink = ...

    if itemLink then
        local toast = GetToast("item")
        itemLink = FixItemLink(itemLink)
        local name, _, quality, _, _, _, _, _, _, icon = GetItemInfo(itemLink)
        local color = ITEM_QUALITY_COLORS[quality or 1]

        if CFG.colored_names_enabled then
            toast.Text:SetTextColor(color.r, color.g, color.b)
        end

        toast.Title:SetText(LEGENDARY_ITEM_LOOT_LABEL)
        toast.Text:SetText(name)
        toast.BG:SetTexture("Interface\\AddOns\\RayUI\\media\\toast-bg-legendary")
        toast.Border:SetVertexColor(color.r, color.g, color.b)
        toast.IconBorder:SetVertexColor(color.r, color.g, color.b)
        toast.Count:SetText("")
        toast.Icon:SetTexture(icon)
        toast.UpgradeIcon:SetShown(IsItemAnUpgrade(itemLink))
        toast.Dragon:Show()
        toast.soundFile = "UI_LegendaryLoot_Toast"
        toast.link = itemLink

        SpawnToast(toast, CFG.dnd.loot_special)
    end
end

function AL:SHOW_LOOT_TOAST_UPGRADE(...)
    local _, itemLink, quantity = ...

    if itemLink then
        local toast = GetToast("item")
        itemLink = FixItemLink(itemLink)
        local name, _, quality, _, _, _, _, _, _, icon = GetItemInfo(itemLink)
        local upgradeTexture = LOOTUPGRADEFRAME_QUALITY_TEXTURES[quality or 2]
        local color = ITEM_QUALITY_COLORS[quality or 1]

        if CFG.colored_names_enabled then
            toast.Text:SetTextColor(color.r, color.g, color.b)
        end

        toast.Title:SetText(color.hex..string.format(LOOTUPGRADEFRAME_TITLE, _G["ITEM_QUALITY"..quality.."_DESC"]).."|r")
        toast.Text:SetText(name)
        toast.Count:SetText(quantity > 1 and quantity or "")
        toast.BG:SetTexture("Interface\\AddOns\\RayUI\\media\\toast-bg-upgrade")
        toast.Border:SetVertexColor(color.r, color.g, color.b)
        toast.IconBorder:SetVertexColor(color.r, color.g, color.b)
        toast.Icon:SetTexture(icon)
        toast.UpgradeIcon:SetShown(IsItemAnUpgrade(itemLink))
        toast.soundFile = 51561
        toast.link = itemLink

        for i = 1, 5 do
            toast.Arrows["Arrow"..i]:SetAtlas(upgradeTexture.arrow, true)
        end

        toast.Arrows.requested = true

        SpawnToast(toast, CFG.dnd.loot_special)
    end
end

function AL:SHOW_PVP_FACTION_LOOT_TOAST(...)
    local _, typeID, itemLink, quantity, _, _, isPersonal, lessAwesome = ...

    LootWonToast_Setup(itemLink, quantity, nil, nil, true, typeID == "item", typeID == "money", lessAwesome, nil, isPersonal)
end

function AL:SHOW_RATED_PVP_REWARD_TOAST(...)
    local _, typeID, itemLink, quantity, _, _, isPersonal, lessAwesome = ...

    LootWonToast_Setup(itemLink, quantity, nil, nil, true, typeID == "item", typeID == "money", lessAwesome, nil, isPersonal)
end

function AL:STORE_PRODUCT_DELIVERED(...)
    local _, _, icon, _, payloadID = ...
    local name, _, quality = GetItemInfo(payloadID)
    local color = ITEM_QUALITY_COLORS[quality or 4]
    local toast = GetToast("item")

    if CFG.colored_names_enabled then
        toast.Text:SetTextColor(color.r, color.g, color.b)
    end

    toast.Title:SetText(BLIZZARD_STORE_PURCHASE_COMPLETE)
    toast.Text:SetText(name)
    toast.BG:SetTexture("Interface\\AddOns\\RayUI\\media\\toast-bg-store")
    toast.Border:SetVertexColor(color.r, color.g, color.b)
    toast.IconBorder:SetVertexColor(color.r, color.g, color.b)
    toast.Icon:SetTexture(icon)
    toast.soundFile = "UI_igStore_PurchaseDelivered_Toast_01"
    toast.id = payloadID

    SpawnToast(toast, CFG.dnd.loot_special)
end

local function EnableSpecialLootToasts()
    if CFG.loot_special_enabled then
        AL:RegisterEvent("LOOT_ITEM_ROLL_WON")
        AL:RegisterEvent("SHOW_LOOT_TOAST")
        AL:RegisterEvent("SHOW_LOOT_TOAST_LEGENDARY_LOOTED")
        AL:RegisterEvent("SHOW_LOOT_TOAST_UPGRADE")
        AL:RegisterEvent("SHOW_PVP_FACTION_LOOT_TOAST")
        AL:RegisterEvent("SHOW_RATED_PVP_REWARD_TOAST")
        AL:RegisterEvent("STORE_PRODUCT_DELIVERED")

        BonusRollFrame.FinishRollAnim:SetScript("OnFinished", BonusRollFrame_FinishedFading_Enabled)
    else
        BonusRollFrame.FinishRollAnim:SetScript("OnFinished", BonusRollFrame_FinishedFading_Disabled)
    end
end

local function DisableSpecialLootToasts()
    AL:UnregisterEvent("LOOT_ITEM_ROLL_WON")
    AL:UnregisterEvent("SHOW_LOOT_TOAST")
    AL:UnregisterEvent("SHOW_LOOT_TOAST_LEGENDARY_LOOTED")
    AL:UnregisterEvent("SHOW_LOOT_TOAST_UPGRADE")
    AL:UnregisterEvent("SHOW_PVP_FACTION_LOOT_TOAST")
    AL:UnregisterEvent("SHOW_RATED_PVP_REWARD_TOAST")
    AL:UnregisterEvent("STORE_PRODUCT_DELIVERED")

    BonusRollFrame.FinishRollAnim:SetScript("OnFinished", BonusRollFrame_FinishedFading_Disabled)
end

local LOOT_ITEM_PATTERN = (LOOT_ITEM_SELF):gsub("%%s", "(.+)")
local LOOT_ITEM_PUSHED_PATTERN = (LOOT_ITEM_PUSHED_SELF):gsub("%%s", "(.+)")
local LOOT_ITEM_MULTIPLE_PATTERN = (LOOT_ITEM_SELF_MULTIPLE):gsub("%%s", "(.+)"):gsub("%%d", "(%%d+)")
local LOOT_ITEM_PUSHED_MULTIPLE_PATTERN = (LOOT_ITEM_PUSHED_SELF_MULTIPLE):gsub("%%s", "(.+)"):gsub("%%d", "(%%d+)")

local function LootCommonToast_Setup(itemLink, quantity)
    itemLink = FixItemLink(itemLink)

    if not GetToastToUpdate(itemLink, "item") then
        local name, quality, icon, _

        if string.find(itemLink, "battlepet:") then
            local _, speciesID, _, breedQuality = string.split(":", itemLink)
            name, icon = C_PetJournal.GetPetInfoBySpeciesID(speciesID)
            quality = tonumber(breedQuality)
        else
            name, _, quality, _, _, _, _, _, _, icon = GetItemInfo(itemLink)
        end

        if quality >= CFG.loot_common_quality_threshold then
            local toast = GetToast("item")
            local color = ITEM_QUALITY_COLORS[quality or 4]

            if CFG.colored_names_enabled then
                toast.Text:SetTextColor(color.r, color.g, color.b)
            end

            toast.Title:SetText(YOU_RECEIVED_LABEL)
            toast.Text:SetText(name)
            toast.Count:SetText(quantity > 1 and quantity or "")
            toast.Border:SetVertexColor(color.r, color.g, color.b)
            toast.IconBorder:SetVertexColor(color.r, color.g, color.b)
            toast.Icon:SetTexture(icon)
            toast.link = itemLink
            toast.chat = true

            SpawnToast(toast, CFG.dnd.loot_common)
        end
    end
end

function AL:CHAT_MSG_LOOT(event, message)
    local itemLink, quantity = message:match(LOOT_ITEM_MULTIPLE_PATTERN)

    if not itemLink then
        itemLink, quantity = message:match(LOOT_ITEM_PUSHED_MULTIPLE_PATTERN)

        if not itemLink then
            quantity, itemLink = 1, message:match(LOOT_ITEM_PATTERN)

            if not itemLink then
                quantity, itemLink = 1, message:match(LOOT_ITEM_PUSHED_PATTERN)

                if not itemLink then
                    return
                end
            end
        end
    end

    quantity = tonumber(quantity) or 0

    C_Timer.After(0.125, function() LootCommonToast_Setup(itemLink, quantity) end)
end

local function EnableCommonLootToasts()
    if CFG.loot_common_enabled then
        AL:RegisterEvent("CHAT_MSG_LOOT")
    end
end

local function DisableCommonLootToasts()
    AL:UnregisterEvent("CHAT_MSG_LOOT")
end

local CURRENCY_GAINED_PATTERN = (CURRENCY_GAINED):gsub("%%s", "(.+)")
local CURRENCY_GAINED_MULTIPLE_PATTERN = (CURRENCY_GAINED_MULTIPLE):gsub("%%s", "(.+)"):gsub("%%d", "(%%d+)")

function AL:CHAT_MSG_CURRENCY(event, message)
    local itemLink, quantity = message:match(CURRENCY_GAINED_MULTIPLE_PATTERN)

    if not itemLink then
        quantity, itemLink = 1, message:match(CURRENCY_GAINED_PATTERN)

        if not itemLink then
            return
        end
    end

    itemLink = string.match(itemLink, "|H(.+)|h.+|h")
    quantity = tonumber(quantity) or 0

    local toast, isQueued = GetToastToUpdate(itemLink, "item")
    local isUpdated = true

    if not toast then
        toast = GetToast("item")
        isUpdated = false
    end

    if not isUpdated then
        local name, _, icon, _, _, _, _, quality = GetCurrencyInfo(itemLink)
        local color = ITEM_QUALITY_COLORS[quality or 1]

        if CFG.colored_names_enabled then
            toast.Text:SetTextColor(color.r, color.g, color.b)
        end

        toast.Title:SetText(YOU_RECEIVED_LABEL)
        toast.Text:SetText(name)
        toast.Count:SetText(quantity > 1 and quantity or "")
        toast.Border:SetVertexColor(color.r, color.g, color.b)
        toast.IconBorder:SetVertexColor(color.r, color.g, color.b)
        toast.Icon:SetTexture(icon)
        toast.soundFile = 31578
        toast.itemCount = quantity
        toast.link = itemLink

        SpawnToast(toast, CFG.dnd.loot_currency)
    else
        if isQueued then
            toast.itemCount = toast.itemCount + quantity
            toast.Count:SetText(toast.itemCount)
        else
            toast.itemCount = toast.itemCount + quantity
            toast.Count:SetAnimatedText(toast.itemCount)

            toast.CountUpdate:SetText("+"..quantity)
            toast.CountUpdateAnim:Stop()
            toast.CountUpdateAnim:Play()

            toast.AnimOut:Stop()
            toast.AnimOut:Play()
        end
    end
end

local function EnableCurrencyLootToasts()
    if CFG.loot_currency_enabled then
        AL:RegisterEvent("CHAT_MSG_CURRENCY")
    end
end

local function DisableCurrencyLootToasts()
    AL:UnregisterEvent("CHAT_MSG_CURRENCY")
end

------------
-- RECIPE --
------------

function AL:NEW_RECIPE_LEARNED(...)
    local _, recipeID = ...
    local tradeSkillID = C_TradeSkillUI.GetTradeSkillLineForRecipe(recipeID)

    if tradeSkillID then
        local recipeName = GetSpellInfo(recipeID)

        if recipeName then
            local toast = GetToast("ability")
            local rank = GetSpellRank(recipeID)
            local rankTexture = ""

            if rank == 1 then
                rankTexture = "|TInterface\\LootFrame\\toast-star:12:12:0:0:32:32:0:21:0:21|t"
            elseif rank == 2 then
                rankTexture = "|TInterface\\LootFrame\\toast-star-2:12:24:0:0:64:32:0:42:0:21|t"
            elseif rank == 3 then
                rankTexture = "|TInterface\\LootFrame\\toast-star-3:12:36:0:0:64:32:0:64:0:21|t"
            end

            toast.Title:SetText(rank and rank > 1 and UPGRADED_RECIPE_LEARNED_TITLE or NEW_RECIPE_LEARNED_TITLE)
            toast.Text:SetText(recipeName)
            toast.BG:SetTexture("Interface\\AddOns\\RayUI\\media\\toast-bg-recipe")
            toast.Rank:SetText(rankTexture)
            toast.Icon:SetTexture(C_TradeSkillUI.GetTradeSkillTexture(tradeSkillID))
            toast.soundFile = "UI_Professions_NewRecipeLearned_Toast"
            toast.id = recipeID

            SpawnToast(toast, CFG.dnd.recipe)
        end
    end
end

local function EnableRecipeToasts()
    if CFG.recipe_enabled then
        AL:RegisterEvent("NEW_RECIPE_LEARNED")
    end
end

local function DisableRecipeToasts()
    AL:UnregisterEvent("NEW_RECIPE_LEARNED")
end

-----------
-- WORLD --
-----------

local function InvasionToast_SetUp(questID)
    -- XXX: To avoid possible spam
    if GetToastToUpdate(questID, "scenario") then
        return
    end

    local toast = GetToast("scenario")
    local scenarioName, _, _, _, hasBonusStep, isBonusStepComplete, _, xp, money, _, areaName = C_Scenario.GetInfo()
    -- local scenarioName, _, _, _, hasBonusStep, isBonusStepComplete, _, xp, money, _, areaName =
    -- "Invasion: Azshara", 0, 0, 0, false, false, true, 12345, 12345, 4, "Azshara"
    local usedRewards = 0

    if money > 0 then
        usedRewards = usedRewards + 1
        local reward = toast["Reward"..usedRewards]

        if reward then
            SetPortraitToTexture(reward.Icon, "Interface\\Icons\\inv_misc_coin_02")
            reward.money = money
            reward:Show()
        end
    end

    if xp > 0 and UnitLevel("player") < MAX_PLAYER_LEVEL then
        usedRewards = usedRewards + 1
        local reward = toast["Reward"..usedRewards]

        if reward then
            SetPortraitToTexture(reward.Icon, "Interface\\Icons\\xp_icon")
            reward.xp = xp
            reward:Show()
        end
    end

    if hasBonusStep and isBonusStepComplete then
        toast.Bonus:Show()
    end

    toast.Title:SetText(SCENARIO_INVASION_COMPLETE)
    toast.Text:SetText(areaName or scenarioName)
    toast.BG:SetTexture("Interface\\AddOns\\RayUI\\media\\toast-bg-legion")
    toast.Icon:SetTexture("Interface\\Icons\\Ability_Warlock_DemonicPower")
    toast.Border:SetVertexColor(60 / 255, 255 / 255, 38 / 255) -- fel green #3cff26
    toast.IconBorder:SetVertexColor(60 / 255, 255 / 255, 38 / 255) -- fel green #3cff26
    toast.usedRewards = usedRewards
    toast.soundFile = "UI_Scenario_Ending"
    toast.id = questID

    SpawnToast(toast, CFG.dnd.world)
end

local function WorldQuestToast_SetUp(questID)
    -- XXX: To avoid possible spam
    if GetToastToUpdate(questID, "scenario") then
        return
    end

    local toast = GetToast("scenario")
    local _, _, _, taskName = GetTaskInfo(questID)
    local _, _, worldQuestType, rarity, _, tradeskillLineIndex = GetQuestTagInfo(questID)
    local color = WORLD_QUEST_QUALITY_COLORS[rarity] or WORLD_QUEST_QUALITY_COLORS[1]
    local money = GetQuestLogRewardMoney(questID)
    local xp = GetQuestLogRewardXP(questID)
    local usedRewards = 0
    local icon = "Interface\\Icons\\Achievement_Quests_Completed_TwilightHighlands"

    if money > 0 then
        usedRewards = usedRewards + 1
        local reward = toast["Reward"..usedRewards]

        if reward then
            SetPortraitToTexture(reward.Icon, "Interface\\Icons\\inv_misc_coin_02")
            reward.money = money
            reward:Show()
        end
    end

    if xp > 0 and UnitLevel("player") < MAX_PLAYER_LEVEL then
        usedRewards = usedRewards + 1
        local reward = toast["Reward"..usedRewards]

        if reward then
            SetPortraitToTexture(reward.Icon, "Interface\\Icons\\xp_icon")
            reward.xp = xp
            reward:Show()
        end
    end

    for i = 1, GetNumQuestLogRewardCurrencies(questID) do
        usedRewards = usedRewards + 1
        local reward = toast["Reward"..usedRewards]

        if reward then
            local _, texture = GetQuestLogRewardCurrencyInfo(i, questID)
            local isOK = pcall(SetPortraitToTexture, reward.Icon, texture)

            if not isOK then
                SetPortraitToTexture(reward.Icon, "Interface\\Icons\\INV_Box_02")
            end

            reward.currency = i
            reward:Show()
        end
    end

    if worldQuestType == LE_QUEST_TAG_TYPE_PVP then
        icon = "Interface\\Icons\\achievement_arena_2v2_1"
    elseif worldQuestType == LE_QUEST_TAG_TYPE_PET_BATTLE then
        icon = "Interface\\Icons\\INV_Pet_BattlePetTraining"
    elseif worldQuestType == LE_QUEST_TAG_TYPE_PROFESSION and tradeskillLineIndex then
        icon = C_TradeSkillUI.GetTradeSkillTexture(select(7, GetProfessionInfo(tradeskillLineIndex)))
    elseif worldQuestType == LE_QUEST_TAG_TYPE_DUNGEON then
        icon = "Interface\\Icons\\INV_Misc_Bone_Skull_02"
    end

    if CFG.colored_names_enabled then
        toast.Text:SetTextColor(color.r, color.g, color.b)
    end

    toast.Title:SetText(WORLD_QUEST_COMPLETE)
    toast.Text:SetText(taskName)
    toast.BG:SetTexture("Interface\\AddOns\\RayUI\\media\\toast-bg-worldquest")
    toast.Icon:SetTexture(icon)
    toast.Border:SetVertexColor(color.r, color.g, color.b)
    toast.IconBorder:SetVertexColor(color.r, color.g, color.b)
    toast.usedRewards = usedRewards
    toast.soundFile = "UI_WorldQuest_Complete"
    toast.id = questID

    SpawnToast(toast, CFG.dnd.world)
end

function AL:SCENARIO_COMPLETED(...)
    if select(10, C_Scenario.GetInfo()) == LE_SCENARIO_TYPE_LEGION_INVASION then
        local _, questID = ...

        if questID then
            InvasionToast_SetUp(questID)
        end
    end
end

function AL:QUEST_TURNED_IN(...)
    local _, questID = ...

    if QuestUtils_IsQuestWorldQuest(questID) then
        WorldQuestToast_SetUp(questID)
    end
end

function AL:QUEST_LOOT_RECEIVED(...)
    local _, questID, itemLink = ...

    --- XXX: QUEST_LOOT_RECEIVED may fire before QUEST_TURNED_IN
    if QuestUtils_IsQuestWorldQuest(questID) then
        if not GetToastToUpdate(questID, "scenario") then
            WorldQuestToast_SetUp(questID)
        end
    end

    UpdateToast(questID, "scenario", itemLink)
end

local function EnableWorldToasts()
    if CFG.world_enabled then
        AL:RegisterEvent("SCENARIO_COMPLETED")
        AL:RegisterEvent("QUEST_TURNED_IN")
        AL:RegisterEvent("QUEST_LOOT_RECEIVED")
    end
end

local function DisableWorldToasts()
    AL:UnregisterEvent("SCENARIO_COMPLETED")
    AL:UnregisterEvent("QUEST_TURNED_IN")
    AL:UnregisterEvent("QUEST_LOOT_RECEIVED")
end

--------------
-- TRANSMOG --
--------------

local function IsAppearanceKnown(sourceID)
    local data = C_TransmogCollection.GetSourceInfo(sourceID)
    local sources = C_TransmogCollection.GetAppearanceSources(data.appearanceID)

    if sources then
        for i = 1, #sources do
            if sources[i].isCollected and sourceID ~= sources[i].sourceID then
                return true
            end
        end
    else
        return nil
    end

    return false
end

local function TransmogToast_SetUp(sourceID, isAdded)
    local _, _, _, icon, _, _, transmogLink = C_TransmogCollection.GetAppearanceSourceInfo(sourceID)
    local name
    transmogLink, name = string.match(transmogLink, "|H(.+)|h%[(.+)%]|h")

    if not transmogLink then
        return C_Timer.After(0.25, function() TransmogToast_SetUp(sourceID, isAdded) end)
    end

    local toast = GetToast("misc")

    if isAdded then
        toast.Title:SetText("Appearance Added")
    else
        toast.Title:SetText("Appearance Removed")
    end

    toast.Text:SetText(name)
    toast.BG:SetTexture("Interface\\AddOns\\RayUI\\media\\toast-bg-transmog")
    toast.Border:SetVertexColor(1, 128 / 255, 1)
    toast.IconBorder:SetVertexColor(1, 128 / 255, 1)
    toast.Icon:SetTexture(icon)
    toast.soundFile = "UI_DigsiteCompletion_Toast"
    toast.id = sourceID
    toast.link = transmogLink

    SpawnToast(toast, CFG.dnd.transmog)
end

function AL:TRANSMOG_COLLECTION_SOURCE_ADDED(event, sourceID)
    local isKnown = IsAppearanceKnown(sourceID)

    if isKnown == false then
        TransmogToast_SetUp(sourceID, true)
    elseif isKnown == nil then
        C_Timer.After(0.25, function() AL:TRANSMOG_COLLECTION_SOURCE_ADDED("", sourceID) end)
    end
end

function AL:TRANSMOG_COLLECTION_SOURCE_REMOVED(event, sourceID)
    local isKnown = IsAppearanceKnown(sourceID)

    if isKnown == false then
        TransmogToast_SetUp(sourceID)
    elseif isKnown == nil then
        C_Timer.After(0.25, function() AL:TRANSMOG_COLLECTION_SOURCE_REMOVED("", sourceID) end)
    end
end

local function EnableTransmogToasts()
    if CFG.transmog_enabled then
        AL:RegisterEvent("TRANSMOG_COLLECTION_SOURCE_ADDED")
        AL:RegisterEvent("TRANSMOG_COLLECTION_SOURCE_REMOVED")
    end
end

local function DisableTransmogToasts()
    AL:UnregisterEvent("TRANSMOG_COLLECTION_SOURCE_ADDED")
    AL:UnregisterEvent("TRANSMOG_COLLECTION_SOURCE_REMOVED")
end

-----------
-- TESTS --
-----------

local function SpawnTestGarrisonToast()
    -- follower
    local followers = C_Garrison.GetFollowers(LE_FOLLOWER_TYPE_GARRISON_6_0)
    local follower = followers and followers[1]

    if follower then
        GarrisonFollowerToast_SetUp(follower.followerTypeID, LE_GARRISON_TYPE_6_0, follower.followerID, follower.name, nil, follower.level, follower.quality, false)
    end

    -- ship
    followers = C_Garrison.GetFollowers(LE_FOLLOWER_TYPE_SHIPYARD_6_2)
    follower = followers and followers[1]

    if follower then
        GarrisonFollowerToast_SetUp(follower.followerTypeID, LE_GARRISON_TYPE_6_0, follower.followerID, follower.name, follower.texPrefix, follower.level, follower.quality, false)
    end

    -- garrison mission
    local missions = C_Garrison.GetAvailableMissions(LE_FOLLOWER_TYPE_GARRISON_6_0)
    local id = missions and (missions[1] and missions[1].missionID or nil) or nil

    if id then
        GarrisonMissionToast_SetUp(LE_FOLLOWER_TYPE_GARRISON_6_0, LE_GARRISON_TYPE_6_0, id)
    end

    -- shipyard mission
    missions = C_Garrison.GetAvailableMissions(LE_FOLLOWER_TYPE_SHIPYARD_6_2)
    id = missions and (missions[1] and missions[1].missionID or nil) or nil

    if id then
        GarrisonMissionToast_SetUp(LE_FOLLOWER_TYPE_SHIPYARD_6_2, LE_GARRISON_TYPE_6_0, id)
    end

    -- garrison building
    AL:GARRISON_BUILDING_ACTIVATABLE("Storehouse")
end

local function SpawnTestClassHallToast()
    -- champion
    local followers = C_Garrison.GetFollowers(LE_FOLLOWER_TYPE_GARRISON_7_0)
    local follower = followers and followers[1]

    if follower then
        GarrisonFollowerToast_SetUp(follower.followerTypeID, LE_GARRISON_TYPE_7_0, follower.followerID, follower.name, nil, follower.level, follower.quality, false)
    end

    -- order hall mission
    local missions = C_Garrison.GetAvailableMissions(LE_FOLLOWER_TYPE_GARRISON_7_0)
    local id = missions and (missions[1] and missions[1].missionID or nil) or nil

    if id then
        GarrisonMissionToast_SetUp(LE_FOLLOWER_TYPE_GARRISON_7_0, LE_GARRISON_TYPE_7_0, id)
    end
end

local function SpawnTestAchievementToast()
    -- new
    AL:ACHIEVEMENT_EARNED("", 545, false)

    -- already earned
    AL:ACHIEVEMENT_EARNED("", 9828, true)
end

local function SpawnTestRecipeToast()
    AL:NEW_RECIPE_LEARNED("", 7183)
end

local function SpawnTestArchaeologyToast()
    AL:ARTIFACT_DIGSITE_COMPLETE("", 408)
end

local function SpawnTestWorldEventToast()
    -- invasion in Azshara
    local _, link = GetItemInfo(139049)

    if link then
        WorldQuestToast_SetUp(41662)
        UpdateToast(41662, "scenario", link)
    else
        C_Timer.After(0.25, SpawnTestWorldEventToast)
    end
end

local function SpawnTestLootToast()
    -- money
    AL:SHOW_LOOT_TOAST("", "money", nil, 12345678, 0, 2, false, 0, false, false)

    -- legendary
    local _, link = GetItemInfo(132452)

    if link then
        AL:SHOW_LOOT_TOAST_LEGENDARY_LOOTED("", link)
    end

    _, link = GetItemInfo(140715)

    -- faction
    if link then
        AL:SHOW_PVP_FACTION_LOOT_TOAST("", "item", link, 1)
    end

    -- roll won
    if link then
        AL:LOOT_ITEM_ROLL_WON("", link, 1, 1, 58, false)
    end

    _, link = GetItemInfo("|cffa335ee|Hitem:121641::::::::110:70:512:11:2:664:1737:108:::|h[Radiant Charm of Elune]|h|r")

    -- upgrade
    if link then
        AL:SHOW_LOOT_TOAST_UPGRADE("", link, 1)
    end

    -- store
    AL:STORE_PRODUCT_DELIVERED("", 1, 915544, GetItemInfo(105911), 105911)
end

local function SpawnTestCurrencyToast()
    -- currency
    local link, _ = GetCurrencyLink(824)

    if link then
        AL:CHAT_MSG_CURRENCY("", string.format(CURRENCY_GAINED_MULTIPLE, link, math.random(300, 600)))
    end
end

local function SpawnTestTransmogToast()
    local appearance = C_TransmogCollection.GetCategoryAppearances(1) and C_TransmogCollection.GetCategoryAppearances(1)[1]
    local source = C_TransmogCollection.GetAppearanceSources(appearance.visualID) and C_TransmogCollection.GetAppearanceSources(appearance.visualID)[1]

    TransmogToast_SetUp(source.sourceID, true)
    TransmogToast_SetUp(source.sourceID)
end

-------------
-- LOADING --
-------------
local function SpawnTestToast()
    if not DevTools_Dump then
        UIParentLoadAddOn("Blizzard_DebugTools")
    end

    SpawnTestGarrisonToast()

    SpawnTestAchievementToast()

    SpawnTestRecipeToast()

    SpawnTestArchaeologyToast()

    SpawnTestLootToast()

    SpawnTestWorldEventToast()

    SpawnTestTransmogToast()
end

function AL:PostAlertMove()
    AlertFrame:ClearAllPoints()
    AlertFrame:SetPoint("CENTER", R.UIParent, "CENTER", 0, 60)
end

function AL:PLAYER_LOGIN()
    anchorFrame:SetPoint(unpack(CFG.point))
    anchorFrame:SetSize(234 * CFG.scale, 58 * CFG.scale)

    UIPARENT_MANAGED_FRAME_POSITIONS["GroupLootContainer"] = nil
    self:SecureHook(AlertFrame, "UpdateAnchors", "PostAlertMove")
    self:PostAlertMove()
    GroupLootContainer:ClearAllPoints()
    GroupLootContainer:SetPoint("CENTER", R.UIParent, "CENTER", 0, 100)

    EnableAchievementToasts()
    EnableArchaeologyToasts()
    EnableGarrisonToasts()
    EnableInstanceToasts()
    EnableSpecialLootToasts()
    EnableCommonLootToasts()
    EnableCurrencyLootToasts()
    EnableRecipeToasts()
    EnableWorldToasts()
    EnableTransmogToasts()

    for event in pairs(BLACKLISTED_EVENTS) do
        _G.AlertFrame:UnregisterEvent(event)
    end

    AlertFrame:UnregisterAllEvents()
    hooksecurefunc(AlertFrame, "RegisterEvent", function(self, event)
            if event and BLACKLISTED_EVENTS[event] then
                self:UnregisterEvent(event)
            end
        end)

    AL:RegisterEvent("PLAYER_REGEN_DISABLED")
    AL:RegisterEvent("PLAYER_REGEN_ENABLED")
end

function AL:Initialize()
    AL:RegisterEvent("PLAYER_LOGIN")

    SLASH_LSADDTOAST1 = "/testalerts"
    SlashCmdList["LSADDTOAST"] = SpawnTestToast
end

R:RegisterModule(AL:GetName())
