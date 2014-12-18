local R, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local M = R:GetModule("Misc")

local function LoadFunc()
	--显示任务等级
	function questlevel()
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
	hooksecurefunc("QuestLogQuests_Update", questlevel)

	if not M.db.quest then return end
    local QuickQuest = CreateFrame("Frame")
    QuickQuest:SetScript("OnEvent", function(self, event, ...) self[event](...) end)

	local DelayHandler
	do
		local currentInfo = {}

		local function TimerCallback()
			DelayHandler(unpack(currentInfo))
		end

		local delayed = true
		function DelayHandler(func, ...)
			if(delayed) then
				delayed = false

				table.wipe(currentInfo)
				table.insert(currentInfo, func)

				for index = 1, select("#", ...) do
					local argument = select(index, ...)
					table.insert(currentInfo, argument)
				end

				C_Timer.After(1, TimerCallback)
			else
				delayed = true
				func(...)
			end
		end
	end

    local atBank, atMail, atMerchant
	local choiceQueue, autoCompleteIndex

	local delayEvent = {
		GOSSIP_SHOW = true,
		GOSSIP_CONFIRM = true,
		QUEST_GREETING = true,
		QUEST_DETAIL = true,
		QUEST_ACCEPT_CONFIRM = true,
		QUEST_PROGRESS = true,
		QUEST_AUTOCOMPLETE = true,
	}

    function QuickQuest:Register(event, func, override)
        self:RegisterEvent(event)
        self[event] = function(...)
            if (override or (not IsShiftKeyDown() and M.db.automation)) then
                if delayEvent[event] then
					DelayHandler(func, ...)
				else
					func(...)
				end
            end
        end
    end

    local function IsTrackingTrivial()
        for index = 1, GetNumTrackingTypes() do
            local name, _, active = GetTrackingInfo(index)
            if(name == MINIMAP_TRACKING_TRIVIAL_QUESTS) then
                return active
            end
        end
    end

	local function GetNPCID()
		return tonumber(string.match(UnitGUID("npc") or "", "Creature%-.-%-.-%-.-%-.-%-(.-)%-"))
	end

	local ignoreQuestNPC = {
		[88570] = true, -- Fate-Twister Tiklal
		[87391] = true, -- Fate-Twister Seress
	}

    QuickQuest:Register("QUEST_GREETING", function()
		local npcID = GetNPCID()
		if(ignoreQuestNPC[npcID]) then
			return
		end

        local active = GetNumActiveQuests()
        if(active > 0) then
            for index = 1, active do
                local _, complete = GetActiveTitle(index)
                if(complete) then
                    SelectActiveQuest(index)
                end
            end
        end

        local available = GetNumAvailableQuests()
        if(available > 0) then
            for index = 1, available do
                if(not IsAvailableQuestTrivial(index) or IsTrackingTrivial()) then
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

		-- Misc NPCs
		[79740] = true, -- Warmaster Zog (Horde)
		[79953] = true, -- Lieutenant Thorn (Alliance)
	}

    QuickQuest:Register("GOSSIP_SHOW", function()
        local active = GetNumGossipActiveQuests()
        if(active > 0) then
            for index = 1, active do
                if(IsGossipQuestCompleted(index)) then
                    SelectGossipActiveQuest(index)
                end
            end
        end

        local available = GetNumGossipAvailableQuests()
        if(available > 0) then
            for index = 1, available do
                if(not IsGossipQuestTrivial(index) or IsTrackingTrivial()) then
                    SelectGossipAvailableQuest(index)
                end
            end
        end

		if(available == 0 and active == 0 and GetNumGossipOptions() == 1) then
			local npcID = GetNPCID()
			if(npcID == 57850) then
				return SelectGossipOption(1)
			end

			local _, instance = GetInstanceInfo()
			if instance ~= "raid" then
				local _, type = GetGossipOptions()
				if type == "gossip" and not ignoreGossipNPC[npcID] then
					SelectGossipOption(1)
					return
				end
			end
		end
    end)

	local ignoredItems = {
        -- Inscription weapons
        [31690] = true, -- Inscribed Tiger Staff
        [31691] = true, -- Inscribed Crane Staff
        [31692] = true, -- Inscribed Serpent Staff

        -- Darkmoon Faire artifacts
        [29443] = true, -- Imbued Crystal
        [29444] = true, -- Monstrous Egg
        [29445] = true, -- Mysterious Grimoire
        [29446] = true, -- Ornate Weapon
        [29451] = true, -- A Treatise on Strategy
        [29456] = true, -- Banner of the Fallen
        [29457] = true, -- Captured Insignia
        [29458] = true, -- Fallen Adventurer's Journal
        [29464] = true, -- Soothsayer's Runes
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

    QuickQuest:Register("QUEST_AUTOCOMPLETE", function(id)
        while(not autoCompleteIndex and GetNumAutoQuestPopUps() > 0) do
			local id, type = GetAutoQuestPopUp(1)
			if(type == "COMPLETE") then
				local index = GetQuestLogIndexByID(id)
				ShowQuestComplete(index)
				autoCompleteIndex = index
			else
				return
			end
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

	local questTip = CreateFrame("GameTooltip", "QuickQuestTip", UIParent, "GameTooltipTemplate")
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
                questTip:SetOwner(UIParent, "ANCHOR_NONE")
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

    QuickQuest:Register("PLAYER_LOGIN", function()
		QuickQuest:Register("BAG_UPDATE", BagUpdate)

		if(GetNumAutoQuestPopUps() > 0) then
			QuickQuest:QUEST_AUTOCOMPLETE()
		end
	end)

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
end

M:RegisterMiscModule("Quest", LoadFunc)