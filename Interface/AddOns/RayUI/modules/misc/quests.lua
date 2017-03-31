local R, L, P, G = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, GlobalDB
local M = R:GetModule("Misc")
local mod = M:NewModule("Quest", "AceEvent-3.0", "AceHook-3.0")

--Cache global variables
--Lua functions
local _G = _G
local string, unpack, select, table, next = string, unpack, select, table, next
local tonumber, pairs = tonumber, pairs
local setmetatable = setmetatable

--WoW API / Variables
local CreateFrame = CreateFrame
local GetNumQuestLogEntries = GetNumQuestLogEntries
local GetQuestLogTitle = GetQuestLogTitle
local QuestLogQuests_GetTitleButton = QuestLogQuests_GetTitleButton
local AcceptQuest = AcceptQuest
local GetNumAutoQuestPopUps = GetNumAutoQuestPopUps
local ChatFrame_AddMessageEventFilter = ChatFrame_AddMessageEventFilter
local C_Timer = C_Timer
local QuestInfoDescriptionText = QuestInfoDescriptionText
local IsShiftKeyDown = IsShiftKeyDown
local GetNumTrackingTypes = GetNumTrackingTypes
local GetTrackingInfo = GetTrackingInfo
local UnitGUID = UnitGUID
local GetNumActiveQuests = GetNumActiveQuests
local GetActiveTitle = GetActiveTitle
local SelectActiveQuest = SelectActiveQuest
local GetNumAvailableQuests = GetNumAvailableQuests
local SelectAvailableQuest = SelectAvailableQuest
local GetGossipActiveQuests = GetGossipActiveQuests
local GetGossipAvailableQuests = GetGossipAvailableQuests
local GetNumGossipActiveQuests = GetNumGossipActiveQuests
local SelectGossipActiveQuest = SelectGossipActiveQuest
local GetNumGossipAvailableQuests = GetNumGossipAvailableQuests
local SelectGossipAvailableQuest = SelectGossipAvailableQuest
local GetNumGossipOptions = GetNumGossipOptions
local SelectGossipOption = SelectGossipOption
local GetInstanceInfo = GetInstanceInfo
local StaticPopup_Hide = StaticPopup_Hide
local QuestGetAutoAccept = QuestGetAutoAccept
local CloseQuest = CloseQuest
local IsQuestCompletable = IsQuestCompletable
local GetNumQuestItems = GetNumQuestItems
local GetQuestItemLink = GetQuestItemLink
local CompleteQuest = CompleteQuest
local GetNumQuestChoices = GetNumQuestChoices
local GetQuestReward = GetQuestReward
local GetItemInfo = GetItemInfo
local GetQuestItemInfo = GetQuestItemInfo
local QuestInfoRewardsFrame = QuestInfoRewardsFrame
local GetAutoQuestPopUp = GetAutoQuestPopUp
local GetQuestLogIndexByID = GetQuestLogIndexByID
local ShowQuestComplete = ShowQuestComplete
local GetContainerNumSlots = GetContainerNumSlots
local GetContainerItemQuestInfo = GetContainerItemQuestInfo
local IsQuestFlaggedCompleted = IsQuestFlaggedCompleted
local UnitLevel = UnitLevel
local UseContainerItem = UseContainerItem
local GetQuestTagInfo = GetQuestTagInfo
local GetAvailableQuestInfo = GetAvailableQuestInfo
local GetNumGroupMembers = GetNumGroupMembers
local QuestIsFromAreaTrigger = QuestIsFromAreaTrigger
local QuickQuestBlacklistDB = QuickQuestBlacklistDB
local GetQuestID = GetQuestID
local AcknowledgeAutoAcceptQuest = AcknowledgeAutoAcceptQuest
local IsQuestIgnored = IsQuestIgnored
local UnitIsDeadOrGhost = UnitIsDeadOrGhost
local ShowQuestOffer = ShowQuestOffer

--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: ENABLE_COLORBLIND_MODE, ITEM_MIN_LEVEL, ERR_QUEST_ALREADY_DONE, ERR_QUEST_FAILED_LOW_LEVEL, QuestFrame_OnEvent
-- GLOBALS: ERR_QUEST_NEED_PREREQS, MINIMAP_TRACKING_TRIVIAL_QUESTS, QuestFrame, MINIMAP_TRACKING_HIDDEN_QUESTS

local function IsTrackingHidden()
	for index = 1, GetNumTrackingTypes() do
		local name, _, active = GetTrackingInfo(index)
		if(name == (MINIMAP_TRACKING_TRIVIAL_QUESTS or MINIMAP_TRACKING_HIDDEN_QUESTS)) then
			return active
		end
	end
end

local function GetAvailableGossipQuestInfo(index)
	local name, level, isTrivial, frequency, isRepeatable, isLegendary, isIgnored = select(((index * 7) - 7) + 1, GetGossipAvailableQuests())
	return name, level, isTrivial, isIgnored, isRepeatable, frequency == 2, frequency == 3, isLegendary
end

local function GetActiveGossipQuestInfo(index)
	local name, level, isTrivial, isComplete, isLegendary, isIgnored = select(((index * 6) - 6) + 1, GetGossipActiveQuests())
	return name, level, isTrivial, isIgnored, isComplete, isLegendary
end

function mod:QuestLogQuests_Update()
    if ENABLE_COLORBLIND_MODE == "1" then return end
    local numEntries, numQuests = GetNumQuestLogEntries()
    local titleIndex = 1

    for i = 1, numEntries do
        local title, level, suggestedGroup, isHeader, isCollapsed, isComplete, frequency, questID, startEvent, displayQuestID, isOnMap, hasLocalPOI, isTask, isStory = GetQuestLogTitle(i)
        local titleButton = QuestLogQuests_GetTitleButton(titleIndex)
        if title and (not isHeader) and titleButton.questID == questID then
            titleButton.Text:SetText("[" .. level .. "] " .. title)
            titleButton.Check:SetPoint("LEFT", titleButton.Text, titleButton.Text:GetWrappedWidth() + 2, 0);
            titleIndex = titleIndex + 1
        end
    end
end
local QuickQuest = CreateFrame("Frame")
QuickQuest:SetScript("OnEvent", function(self, event, ...) self[event](...) end)

local metatable = {
    __call = function(methods, ...)
        for _, method in next, methods do
            method(...)
        end
    end
}

local atBank, atMail, atMerchant
local choiceQueue, autoCompleteIndex

function QuickQuest:Register(event, method, override)
    local newmethod
    if(not override) then
        newmethod = function(...)
            if(not IsShiftKeyDown() and M.db.automation) then
                method(...)
            end
        end
    end

    local methods = self[event]
    if(methods) then
        self[event] = setmetatable({methods, newmethod or method}, metatable)
    else
        self[event] = newmethod or method
        self:RegisterEvent(event)
    end
end

local function GetNPCID()
    return tonumber(string.match(UnitGUID("npc") or "", "Creature%-.-%-.-%-.-%-.-%-(.-)%-"))
end

local ignoreQuestNPC = {
    [88570] = true, -- Fate-Twister Tiklal
    [87391] = true, -- Fate-Twister Seress
    [111243] = true, -- Archmage Lan'dalock
}

local function GetQuestLogQuests(onlyComplete)
    local quests = {}
    for index = 1, GetNumQuestLogEntries() do
        local title, _, _, isHeader, _, isComplete, _, questID = GetQuestLogTitle(index)
        if(not isHeader) then
            if(onlyComplete and isComplete or not onlyComplete) then
                quests[title] = questID
            end
        end
    end

    return quests
end

QuickQuest:Register("QUEST_GREETING", function()
        local npcID = GetNPCID()
        if(ignoreQuestNPC[npcID]) then
            return
        end

        local active = GetNumActiveQuests()
        if(active > 0) then
            local logQuests = GetQuestLogQuests(true)
            for index = 1, active do
                local name, complete = GetActiveTitle(index)
                if(complete) then
                    local questID = logQuests[name]
                    if(not questID) then
                        SelectActiveQuest(index)
                    else
                        local _, _, worldQuest = GetQuestTagInfo(questID)
                        if(not worldQuest) then
                            SelectActiveQuest(index)
                        end
                    end
                end
            end
        end

        local available = GetNumAvailableQuests()
        if(available > 0) then
            for index = 1, available do
                local isTrivial, _, _, _, isIgnored = GetAvailableQuestInfo(index)
                if((not isTrivial and not isIgnored) or IsTrackingHidden()) then
                    SelectAvailableQuest(index)
                end
            end
        end
    end)

-- This should be part of the API, really
local function IsGossipQuestCompleted(index)
    return not not select(((index * 5) - 5) + 4, GetGossipActiveQuests())
end

local function IsGossipQuestTrivial(index)
    return not not select(((index * 6) - 6) + 3, GetGossipAvailableQuests())
end

local ignoreGossipNPC = {
    -- Bodyguards
    [86945] = true, -- Aeda Brightdawn (Horde)
    [86933] = true, -- Vivianne (Horde)
    [86927] = true, -- Delvar Ironfist (Alliance)
    [86934] = true, -- Defender Illona (Alliance)
    [86682] = true, -- Tormmok
    [86964] = true, -- Leorajh
    [86946] = true, -- Talonpriest Ishaal

    -- Sassy Imps
    [95139] = true,
    [95141] = true,
    [95142] = true,
    [95143] = true,
    [95144] = true,
    [95145] = true,
    [95146] = true,
    [95200] = true,
    [95201] = true,

    -- Misc NPCs
    [79740] = true, -- Warmaster Zog (Horde)
    [79953] = true, -- Lieutenant Thorn (Alliance)
    [84268] = true, -- Lieutenant Thorn (Alliance)
    [84511] = true, -- Lieutenant Thorn (Alliance)
    [84684] = true, -- Lieutenant Thorn (Alliance)
}

local rogueClassHallInsignia = {
    [97004] = true, -- "Red" Jack Findle
    [96782] = true, -- Lucian Trias
    [93188] = true, -- Mongar
}

QuickQuest:Register("GOSSIP_SHOW", function()
        local npcID = GetNPCID()
        if(ignoreQuestNPC[npcID]) then
            return
        end

        local active = GetNumGossipActiveQuests()
        if(active > 0) then
            local logQuests = GetQuestLogQuests(true)
            for index = 1, active do
                local name, _, _, _, completed = GetActiveGossipQuestInfo(index)
                if(completed) then
                    local questID = logQuests[name]
                    if(not questID) then
                        SelectGossipActiveQuest(index)
                    else
                        local _, _, worldQuest = GetQuestTagInfo(questID)
                        if(not worldQuest) then
                            SelectGossipActiveQuest(index)
                        end
                    end
                end
            end
        end

        local available = GetNumGossipAvailableQuests()
        if(available > 0) then
            for index = 1, available do
                local _, _, trivial, ignored = GetAvailableGossipQuestInfo(index)
                if((not trivial and not ignored) or IsTrackingHidden()) then
                    SelectGossipAvailableQuest(index)
                elseif(trivial and npcID == 64337) then
                    SelectGossipAvailableQuest(index)
                end
            end
        end

        if(rogueClassHallInsignia[npcID]) then
            return SelectGossipOption(1)
        end

        if(available == 0 and active == 0 and GetNumGossipOptions() == 1) then
            if(npcID == 57850) then
                return SelectGossipOption(1)
            end

            local _, instance = GetInstanceInfo()
            if(instance == "raid") then
                if(GetNumGroupMembers() > 1) then
                    return
                end

                SelectGossipOption(1)
            elseif(instance ~= "raid" and not ignoreGossipNPC[npcID]) then
                SelectGossipOption(1)
            end
        end
    end)

local ignoredItems = {
    [31690] = 79343, -- Inscribed Tiger Staff
    [31691] = 79340, -- Inscribed Crane Staff
    [31692] = 79341, -- Inscribed Serpent Staff

    -- Darkmoon Faire artifacts
    [29443] = 71635, -- Imbued Crystal
    [29444] = 71636, -- Monstrous Egg
    [29445] = 71637, -- Mysterious Grimoire
    [29446] = 71638, -- Ornate Weapon
    [29451] = 71715, -- A Treatise on Strategy
    [29456] = 71951, -- Banner of the Fallen
    [29457] = 71952, -- Captured Insignia
    [29458] = 71953, -- Fallen Adventurer's Journal
    [29464] = 71716, -- Soothsayer's Runes

    -- Tiller Gifts
    ['progress_79264'] = 79264, -- Ruby Shard
    ['progress_79265'] = 79265, -- Blue Feather
    ['progress_79266'] = 79266, -- Jade Cat
    ['progress_79267'] = 79267, -- Lovely Apple
    ['progress_79268'] = 79268, -- Marsh Lily

    -- Garrison scouting missives
    [38180] = 122424, -- Scouting Missive: Broken Precipice
    [38193] = 122423, -- Scouting Missive: Broken Precipice
    [38182] = 122418, -- Scouting Missive: Darktide Roost
    [38196] = 122417, -- Scouting Missive: Darktide Roost
    [38179] = 122400, -- Scouting Missive: Everbloom Wilds
    [38192] = 122404, -- Scouting Missive: Everbloom Wilds
    [38194] = 122420, -- Scouting Missive: Gorian Proving Grounds
    [38202] = 122419, -- Scouting Missive: Gorian Proving Grounds
    [38178] = 122402, -- Scouting Missive: Iron Siegeworks
    [38191] = 122406, -- Scouting Missive: Iron Siegeworks
    [38184] = 122413, -- Scouting Missive: Lost Veil Anzu
    [38198] = 122414, -- Scouting Missive: Lost Veil Anzu
    [38177] = 122403, -- Scouting Missive: Magnarok
    [38190] = 122399, -- Scouting Missive: Magnarok
    [38181] = 122421, -- Scouting Missive: Mok'gol Watchpost
    [38195] = 122422, -- Scouting Missive: Mok'gol Watchpost
    [38185] = 122411, -- Scouting Missive: Pillars of Fate
    [38199] = 122409, -- Scouting Missive: Pillars of Fate
    [38187] = 122412, -- Scouting Missive: Shattrath Harbor
    [38201] = 122410, -- Scouting Missive: Shattrath Harbor
    [38186] = 122408, -- Scouting Missive: Skettis
    [38200] = 122407, -- Scouting Missive: Skettis
    [38183] = 122416, -- Scouting Missive: Socrethar's Rise
    [38197] = 122415, -- Scouting Missive: Socrethar's Rise
    [38176] = 122405, -- Scouting Missive: Stonefury Cliffs
    [38189] = 122401, -- Scouting Missive: Stonefury Cliffs

    -- Misc
    [31664] = 88604, -- Nat's Fishing Journal
}

local darkmoonNPC = {
    [57850] = true, -- Teleportologist Fozlebub
    [55382] = true, -- Darkmoon Faire Mystic Mage (Horde)
    [54334] = true, -- Darkmoon Faire Mystic Mage (Alliance)
}

QuickQuest:Register("GOSSIP_CONFIRM", function(index)
        local npcID = GetNPCID()

        if(npcID and darkmoonNPC[npcID]) then
            SelectGossipOption(index, "", true)
            StaticPopup_Hide("GOSSIP_CONFIRM")
        end
    end)

QuestFrame:UnregisterEvent("QUEST_DETAIL")
QuickQuest:Register("QUEST_DETAIL", function(...)
        if(not QuestGetAutoAccept() and not QuestIsFromAreaTrigger()) then
            QuestFrame_OnEvent(QuestFrame, "QUEST_DETAIL", ...)
        end
    end,
    true)

QuickQuest:Register("QUEST_DETAIL", function(questStartItemID)
        if(QuestGetAutoAccept() or (questStartItemID ~= nil and questStartItemID ~= 0)) then
            AcknowledgeAutoAcceptQuest()
        else
            -- XXX: no way to tell if the quest is trivial
            AcceptQuest()
        end
    end)

local function AttemptAutoComplete(event)
    if(GetNumAutoQuestPopUps() > 0) then
        if(UnitIsDeadOrGhost("player")) then
            QuickQuest:Register("PLAYER_REGEN_ENABLED", AttemptAutoComplete)
            return
        end

        local questID, popUpType = GetAutoQuestPopUp(1)
        if(popUpType == "OFFER") then
            ShowQuestOffer(GetQuestLogIndexByID(questID))
        else
            ShowQuestComplete(GetQuestLogIndexByID(questID))
        end
    else
        C_Timer.After(1, AttemptAutoComplete)
    end

    if(event == "PLAYER_REGEN_ENABLED") then
        QuickQuest:UnregisterEvent("PLAYER_REGEN_ENABLED")
    end
end

QuickQuest:Register("PLAYER_LOGIN", AttemptAutoComplete)
QuickQuest:Register("QUEST_AUTOCOMPLETE", AttemptAutoComplete)
QuickQuest:Register("QUEST_ACCEPT_CONFIRM", AcceptQuest)

QuickQuest:Register("QUEST_ACCEPTED", function(id)
        if(QuestFrame:IsShown() and QuestGetAutoAccept()) then
            CloseQuest()
        end
    end)

local choiceQueue
QuickQuest:Register("QUEST_ITEM_UPDATE", function(...)
        if(choiceQueue and QuickQuest[choiceQueue]) then
            QuickQuest[choiceQueue]()
        end
    end)

QuickQuest:Register("QUEST_PROGRESS", function()
        if(IsQuestCompletable()) then
            local requiredItems = GetNumQuestItems()
            if(requiredItems > 0) then
                for index = 1, requiredItems do
                    local link = GetQuestItemLink("required", index)
                    if(link) then
                        local id = tonumber(string.match(link, "item:(%d+)"))
                        for _, itemID in pairs(ignoredItems) do
                            if(itemID == id) then
                                return
                            end
                        end
                    else
                        choiceQueue = "QUEST_PROGRESS"
                        return
                    end
                end
            end

            CompleteQuest()
        end
    end)

local cashRewards = {
    [45724] = 1e5, -- Champion's Purse
    [64491] = 2e6, -- Royal Reward

    -- Items from the Sixtrigger brothers quest chain in Stormheim
    [138127] = 15, -- Mysterious Coin, 15 copper
    [138129] = 11, -- Swatch of Priceless Silk, 11 copper
    [138131] = 24, -- Magical Sprouting Beans, 24 copper
    [138123] = 15, -- Shiny Gold Nugget, 15 copper
    [138125] = 16, -- Crystal Clear Gemstone, 16 copper
    [138133] = 27, -- Elixir of Endless Wonder, 27 copper
}

QuickQuest:Register("QUEST_COMPLETE", function()
        local choices = GetNumQuestChoices()
        if(choices <= 1) then
            GetQuestReward(1)
        elseif(choices > 1) then
            local bestValue, bestIndex = 0

            for index = 1, choices do
                local link = GetQuestItemLink("choice", index)
                if(link) then
                    local _, _, _, _, _, _, _, _, _, _, value = GetItemInfo(link)
                    value = cashRewards[tonumber(string.match(link, "item:(%d+):"))] or value

                    if(value > bestValue) then
                        bestValue, bestIndex = value, index
                    end
                else
                    choiceQueue = "QUEST_COMPLETE"
                    return GetQuestItemInfo("choice", index)
                end
            end

            if(bestIndex) then
                QuestInfoRewardsFrame.RewardButtons[bestIndex]:Click()
            end
        end
    end)

QuickQuest:Register("QUEST_FINISHED", function()
        choiceQueue = nil
        autoCompleteIndex = nil

        if(GetNumAutoQuestPopUps() > 0) then
            QuickQuest:QUEST_AUTOCOMPLETE()
        end
    end)

QuickQuest:Register("BAG_UPDATE_DELAYED", function()
        if(autoCompleteIndex) then
            ShowQuestComplete(autoCompleteIndex)
            autoCompleteIndex = nil
        end
    end)

QuickQuest:Register("MERCHANT_SHOW", function()
        atMerchant = true
    end)

QuickQuest:Register("MERCHANT_CLOSED", function()
        atMerchant = false
    end)

QuickQuest:Register("BANKFRAME_OPENED", function()
        atBank = true
    end)

QuickQuest:Register("BANKFRAME_CLOSED", function()
        atBank = false
    end)

QuickQuest:Register("GUILDBANKFRAME_OPENED", function()
        atBank = true
    end)

QuickQuest:Register("GUILDBANKFRAME_CLOSED", function()
        atBank = false
    end)

QuickQuest:Register("MAIL_SHOW", function()
        atMail = true
    end)

QuickQuest:Register("MAIL_CLOSED", function()
        atMail = false
    end)

local questTip = CreateFrame("GameTooltip", "QuickQuestTip", R.UIParent, "GameTooltipTemplate")
local questLevel = string.gsub(ITEM_MIN_LEVEL, "%%d", "(%%d+)")

local function GetQuestItemLevel()
    for index = 1, questTip:NumLines() do
        local level = tonumber(string.match(_G["QuickQuestTipTextLeft" .. index]:GetText(), questLevel))
        if(level) then
            return tonumber(level)
        end
    end
end

local function BagUpdate(bag)
    if(atBank or atMail or atMerchant) then return end

    for slot = 1, GetContainerNumSlots(bag) do
        local _, id, active = GetContainerItemQuestInfo(bag, slot)
        if(id and not active and not IsQuestFlaggedCompleted(id) and not ignoredItems[id]) then
            questTip:SetOwner(R.UIParent, "ANCHOR_NONE")
            questTip:ClearLines()
            questTip:SetBagItem(bag, slot)
            questTip:Show()

            local level = GetQuestItemLevel()
            questTip:Hide()
            if(not level or level <= UnitLevel("player")) then
                UseContainerItem(bag, slot)
            end
        end
    end
end

local errors = {
    [ERR_QUEST_ALREADY_DONE] = true,
    [ERR_QUEST_FAILED_LOW_LEVEL] = true,
    [ERR_QUEST_NEED_PREREQS] = true,
}

ChatFrame_AddMessageEventFilter("CHAT_MSG_SYSTEM", function(self, event, message)
        if M.db.automation then
            return errors[message]
        end
    end)

QuestInfoDescriptionText.SetAlphaGradient = function() return false end

function mod:Initialize()
    self:SecureHook("QuestLogQuests_Update")
end

M:RegisterMiscModule(mod:GetName())
