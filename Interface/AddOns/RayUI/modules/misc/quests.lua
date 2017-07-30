----------------------------------------------------------
-- Load RayUI Environment
----------------------------------------------------------
RayUI:LoadEnv("Misc")


local M = _Misc
local mod = M:NewModule("Quest", "AceEvent-3.0", "AceHook-3.0")


function mod:ObjectiveTracker_Update()
    local tracker = ObjectiveTrackerFrame
    if ( not tracker.initialized )then
        return
    end

    for i = 1, #tracker.MODULES do
        for id,block in pairs( tracker.MODULES[i].Header.module.usedBlocks) do
            if block.id and block.HeaderText and block.HeaderText:GetText() and (not string.find(block.HeaderText:GetText(), "^%[.*%].*")) then
                local questLogIndex = GetQuestLogIndexByID(block.id)
                local title, level, suggestedGroup, isHeader, isCollapsed, isComplete, frequency, questID,
                startEvent, displayQuestID, isOnMap, hasLocalPOI, isTask, isStory = GetQuestLogTitle(questLogIndex)
                if ( questLogIndex ~= 0 and title and title ~= "" ) then
                    local questTypeIndex = GetQuestLogQuestType(questLogIndex)
                    local dailyMod = (frequency == LE_QUEST_FREQUENCY_DAILY or frequency == LE_QUEST_FREQUENCY_WEEKLY) and "\*" or ""

                    local h = block.height - block.HeaderText:GetHeight()
                    block.HeaderText:SetText(string.format("[%d%s] %s", level, dailyMod, title))
                    block.height = h + block.HeaderText:GetHeight()
                    block:SetHeight(block.height)
                end
            end
        end
    end
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
    self:SecureHook("ObjectiveTracker_Update")
end

M:RegisterMiscModule(mod:GetName())

if not R:IsDeveloper() then return end

local QuickQuest = CreateFrame("Frame")
QuickQuest:SetScript("OnEvent", function(self, event, ...) self[event](...) end)

local choiceQueue

function QuickQuest:Register(event, method)
    self:RegisterEvent(event)
    self[event] = function(...)
        if M.db.automation then
            if not IsShiftKeyDown() then
                method(...)
            end
        else
            if IsShiftKeyDown() then
                method(...)
            end
        end
    end
end

local function GetNPCID()
    return tonumber(string.match(UnitGUID("npc") or "", "Creature%-.-%-.-%-.-%-.-%-(.-)%-"))
end

local function IsTrackingHidden()
    for index = 1, GetNumTrackingTypes() do
        local name, _, active = GetTrackingInfo(index)
        if(name == (MINIMAP_TRACKING_TRIVIAL_QUESTS or MINIMAP_TRACKING_HIDDEN_QUESTS)) then
            return active
        end
    end
end

local ignoreQuestNPC = {
    [88570] = true, -- Fate-Twister Tiklal
    [87391] = true, -- Fate-Twister Seress
    [111243] = true, -- Archmage Lan'dalock
    [108868] = true, -- Hunter's order hall
    [101462] = true, -- Reaves
    [43929] = true, -- 4000
    [106655] = true, -- Legendary Item Upgrade
    [14847] = true, -- DarkMoon
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

local function GetAvailableGossipQuestInfo(index)
    local name, level, isTrivial, frequency, isRepeatable, isLegendary, isIgnored = select(((index * 7) - 7) + 1, GetGossipAvailableQuests())
    return name, level, isTrivial, isIgnored, isRepeatable, frequency == 2, frequency == 3, isLegendary
end

local function GetActiveGossipQuestInfo(index)
    local name, level, isTrivial, isComplete, isLegendary, isIgnored = select(((index * 6) - 6) + 1, GetGossipActiveQuests())
    return name, level, isTrivial, isIgnored, isComplete, isLegendary
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
    [117871] = true, -- War Councilor Victoria (Class Challenges @ Broken Shore)
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

            local _, instance, _, _, _, _, _, mapID = GetInstanceInfo()
            if(instance ~= "raid" and not ignoreGossipNPC[npcID] and not (instance == "scenario" and mapID == 1626)) then
                local _, type = GetGossipOptions()
                if type == "gossip" then
                    SelectGossipOption(1)
                    return
                end
            end
        end
    end)

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

QuickQuest:Register("QUEST_DETAIL", function()
        if(not QuestGetAutoAccept()) then
            AcceptQuest()
        end
    end)

QuickQuest:Register("QUEST_ACCEPT_CONFIRM", AcceptQuest)

QuickQuest:Register("QUEST_ACCEPTED", function(id)
        if(QuestFrame:IsShown() and QuestGetAutoAccept()) then
            CloseQuest()
        end
    end)

QuickQuest:Register("QUEST_ITEM_UPDATE", function()
        if(choiceQueue and QuickQuest[choiceQueue]) then
            QuickQuest[choiceQueue]()
        end
    end)

local ignoredItems = {
    -- Inscription weapons
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
    ["progress_79264"] = 79264, -- Ruby Shard
    ["progress_79265"] = 79265, -- Blue Feather
    ["progress_79266"] = 79266, -- Jade Cat
    ["progress_79267"] = 79267, -- Lovely Apple
    ["progress_79268"] = 79268, -- Marsh Lily

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

QuickQuest:Register("QUEST_PROGRESS", function()
        if(IsQuestCompletable()) then
            local _, _, worldQuest = GetQuestTagInfo(GetQuestID())
            if worldQuest then return end

            local requiredItems = GetNumQuestItems()
            if(requiredItems > 0) then
                for index = 1, requiredItems do
                    local link = GetQuestItemLink("required", index)
                    if(link) then
                        local id = GetItemInfoFromHyperlink(link)
                        for _, itemID in next, ignoredItems do
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
        -- Blingtron 6000 only!
        local npcID = GetNPCID()
        if npcID == 43929 or npcID == 77789 then return end

        local choices = GetNumQuestChoices()
        if(choices <= 1) then
            GetQuestReward(1)
        elseif(choices > 1) then
            local bestValue, bestIndex = 0

            for index = 1, choices do
                local link = GetQuestItemLink("choice", index)
                if(link) then
                    local _, _, _, _, _, _, _, _, _, _, value = GetItemInfo(link)
                    value = cashRewards[(GetItemInfoFromHyperlink(link))] or value

                    if(value > bestValue) then
                        bestValue, bestIndex = value, index
                    end
                else
                    choiceQueue = "QUEST_COMPLETE"
                    return GetQuestItemInfo("choice", index)
                end
            end

            if(bestIndex) then
                QuestInfoItem_OnClick(QuestInfoRewardsFrame.RewardButtons[bestIndex])
            end
        end
    end)

local function AttemptAutoComplete(event)
    if(GetNumAutoQuestPopUps() > 0) then
        if(UnitIsDeadOrGhost("player")) then
            QuickQuest:Register("PLAYER_REGEN_ENABLED", AttemptAutoComplete)
            return
        end

        local questID, popUpType = GetAutoQuestPopUp(1)
        local _, _, worldQuest = GetQuestTagInfo(questID)
        if not worldQuest then
            if(popUpType == "OFFER") then
                ShowQuestOffer(GetQuestLogIndexByID(questID))
            else
                ShowQuestComplete(GetQuestLogIndexByID(questID))
            end
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
