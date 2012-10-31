local R, L, P = unpack(select(2, ...)) --Inport: Engine, Locales, ProfileDB
local M = R:GetModule("Misc")

local function LoadFunc()
	if not M.db.quest then return end

	--显示任务等级
	local function questlevel()
		local buttons = QuestLogScrollFrame.buttons
		local numButtons = #buttons
		local scrollOffset = HybridScrollFrame_GetOffset(QuestLogScrollFrame)
		local numEntries, numQuests = GetNumQuestLogEntries()

		for i = 1, numButtons do
			local questIndex = i + scrollOffset
			local questLogTitle = buttons[i]
			if questIndex <= numEntries then
				local title, level, questTag, suggestedGroup, isHeader, isCollapsed, isComplete, isDaily = GetQuestLogTitle(questIndex)
				if not isHeader then
					questLogTitle:SetText("[" .. level .. "] " .. title)
					QuestLogTitleButton_Resize(questLogTitle)
				end
			end
		end
	end
	hooksecurefunc("QuestLog_Update", questlevel)
	QuestLogScrollFrameScrollBar:HookScript("OnValueChanged", questlevel)

	local QuestLogExpandButtonFrame = CreateFrame("Frame", "QuestLogExpandButtonFrame", QuestLogFrame)
	QuestLogExpandButtonFrame:SetSize(54, 32)
	QuestLogExpandButtonFrame:SetPoint("TOPLEFT", 40, -48)

	local QuestLogCollapseAllButton = CreateFrame("Button", "QuestLogCollapseAllButton", QuestLogExpandButtonFrame, "QuestLogTitleButtonTemplate")
	QuestLogCollapseAllButton:SetSize(40, 22)
	QuestLogCollapseAllButton:SetPoint("TOPLEFT", 0, -2)
	QuestLogCollapseAllButton:SetScript("OnEnter", nil)
	QuestLogCollapseAllButtonNormalText:SetText(L["全部"])
	QuestLogCollapseAllButtonNormalText:SetWidth(0)

	-- AllButton click behavior
	QuestLogCollapseAllButton:SetScript("OnClick", function(self)
		if (self.collapsed) then
			self.collapsed = nil;
			ExpandQuestHeader(0);
		else
			self.collapsed = 1;
			CollapseQuestHeader(0);
		end
	end)

	-- Move QuestLogCount position
	hooksecurefunc("QuestLog_UpdateQuestCount", function(self)
		local dailyQuestsComplete = GetDailyQuestsCompleted();
		local parent = QuestLogCount:GetParent();

		if ( dailyQuestsComplete > 0 ) then
			QuestLogCount:SetPoint("TOPLEFT", parent, "TOPLEFT", 140, -38);
		else
			QuestLogCount:SetPoint("TOPLEFT", parent, "TOPLEFT", 140, -41);
		end
	end)

	-- display + when collapsed all and display - when expanded all
	hooksecurefunc("QuestLog_Update", function(self)
		local numEntries, numQuests = GetNumQuestLogEntries();

		-- Set the expand/collapse all button texture
		local numHeaders = 0;
		local notExpanded = 0;
		-- Somewhat redundant loop, but cleaner than the alternatives
		for i=1, numEntries, 1 do
			local index = i;
			local questLogTitleText, level, questTag, suggestedGroup, isHeader, isCollapsed = GetQuestLogTitle(i);
			if ( questLogTitleText and isHeader ) then
				numHeaders = numHeaders + 1;
				if ( isCollapsed ) then
					notExpanded = notExpanded + 1;
				end
			end
		end
		-- If all headers are not expanded then show collapse button, otherwise show the expand button
		if ( notExpanded ~= numHeaders ) then
			QuestLogCollapseAllButton.collapsed = nil;
			QuestLogCollapseAllButton:SetNormalTexture("Interface\\Buttons\\UI-MinusButton-Up");
		else
			QuestLogCollapseAllButton.collapsed = 1;
			QuestLogCollapseAllButton:SetNormalTexture("Interface\\Buttons\\UI-PlusButton-Up");
		end
	end)

    local Monomyth = CreateFrame("Frame")
    Monomyth:SetScript("OnEvent", function(self, event, ...) self[event](...) end)

    local atBank, atMail

    function Monomyth:Register(event, func, override)
        self:RegisterEvent(event)
        self[event] = function(...)
            if (override or (not IsShiftKeyDown() and M.db.automation)) then
                func(...)
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

    Monomyth:Register("QUEST_GREETING", function()
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

    Monomyth:Register("GOSSIP_SHOW", function()
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

        local _, instance = GetInstanceInfo()
        if(available == 0 and active == 0 and GetNumGossipOptions() == 1 and instance ~= "raid") then
            local _, type = GetGossipOptions()
            if(type == "gossip") then
                SelectGossipOption(1)
                return
            end
        end
    end)

    local darkmoonNPC = {
        [57850] = true, -- Teleportologist Fozlebub
        [55382] = true, -- Darkmoon Faire Mystic Mage (Horde)
        [54334] = true, -- Darkmoon Faire Mystic Mage (Alliance)
    }

    Monomyth:Register("GOSSIP_CONFIRM", function(index)
        local GUID = UnitGUID("target") or ""
        local creatureID = tonumber(string.sub(GUID, -12, -9), 16)

        if(creatureID and darkmoonNPC[creatureID]) then
            SelectGossipOption(index, "", true)
            StaticPopup_Hide("GOSSIP_CONFIRM")
        end
    end)

    QuestFrame:UnregisterEvent("QUEST_DETAIL")
    Monomyth:Register("QUEST_DETAIL", function()
        if(not QuestGetAutoAccept() and not QuestIsFromAreaTrigger()) then
            QuestFrame_OnEvent(QuestFrame, "QUEST_DETAIL")

            if(M.db.automation and not IsShiftKeyDown()) then
                AcceptQuest()
            end
        end
    end, true)

    Monomyth:Register("QUEST_ACCEPT_CONFIRM", AcceptQuest)

    Monomyth:Register("QUEST_ACCEPTED", function(id)
        if(not GetCVarBool("autoQuestWatch")) then return end

        if(not IsQuestWatched(id) and GetNumQuestWatches() < MAX_WATCHABLE_QUESTS) then
            AddQuestWatch(id)
        end
    end)

    Monomyth:Register("QUEST_PROGRESS", function()
        if(IsQuestCompletable()) then
            CompleteQuest()
        end
    end)

    local choiceQueue, choiceFinished
    Monomyth:Register("QUEST_ITEM_UPDATE", function(...)
        if(choiceQueue) then
            Monomyth.QUEST_COMPLETE()
        end
    end)

    Monomyth:Register("QUEST_COMPLETE", function()
        local choices = GetNumQuestChoices()
        if(choices <= 1) then
            GetQuestReward(1)
        elseif(choices > 1) then
            local bestValue, bestIndex = 0

            for index = 1, choices do
                local link = GetQuestItemLink("choice", index)
                if(link) then
                    local _, _, _, _, _, _, _, _, _, _, value = GetItemInfo(link)

                    if(string.match(link, "item:45724:")) then
                        -- Champion's Purse, contains 10 gold
                        value = 1e5
                    end

                    if(value > bestValue) then
                        bestValue, bestIndex = value, index
                    end
                else
                    choiceQueue = true
                    return GetQuestItemInfo("choice", index)
                end
            end

            if(bestIndex) then
                choiceFinished = true
                _G["QuestInfoItem" .. bestIndex]:Click()
            end
        end
    end)

    Monomyth:Register("QUEST_FINISHED", function()
        if(choiceFinished) then
            choiceQueue = false
        end
    end)

    Monomyth:Register("QUEST_AUTOCOMPLETE", function(id)
        local index = GetQuestLogIndexByID(id)
        if(GetQuestLogIsAutoComplete(index)) then
            -- The quest might not be considered complete, investigate later
            ShowQuestComplete(index)
        end
    end)

    Monomyth:Register("MERCHANT_SHOW", function()
        atMerchant = true
    end)

    Monomyth:Register("MERCHANT_CLOSED", function()
        atMerchant = false
    end)

    Monomyth:Register("BANKFRAME_OPENED", function()
        atBank = true
    end)

    Monomyth:Register("BANKFRAME_CLOSED", function()
        atBank = false
    end)

    Monomyth:Register("GUILDBANKFRAME_OPENED", function()
        atBank = true
    end)

    Monomyth:Register("GUILDBANKFRAME_CLOSED", function()
        atBank = false
    end)

    Monomyth:Register("MAIL_SHOW", function()
        atMail = true
    end)

    Monomyth:Register("MAIL_CLOSED", function()
        atMail = false
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

    Monomyth:Register("BAG_UPDATE", function(bag)
        if(atBank or atMail or atMerchant) then return end

        for slot = 1, GetContainerNumSlots(bag) do
            local _, id, active = GetContainerItemQuestInfo(bag, slot)
            if(id and not active and not IsQuestFlaggedCompleted(id) and not ignoredItems[id]) then
                UseContainerItem(bag, slot)
            end
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

    QuestInfoDescriptionText.SetAlphaGradient=function() return false end
end

M:RegisterMiscModule("Quest", LoadFunc)
