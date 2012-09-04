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

	--自动选最贵奖励
	local GreedyQuester = CreateFrame("FRAME", nil, UIParent)
	GreedyQuester:RegisterEvent("QUEST_COMPLETE")
	GreedyQuester:SetScript("OnEvent", function(self)
		self:SetScript("OnUpdate", function(self)
			local _, frame = QuestInfoItemHighlight:GetPoint()
			if (not QuestFrame:IsShown()) or (QuestInfoItemHighlight:IsShown() and frame ~= QuestInfoRewardsFrame and frame:IsShown()) then
				self:SetScript("OnUpdate", nil)
			else
				local max, max_index = 0, 0
				for x=1,GetNumQuestChoices() do 
					local item = GetQuestItemLink("choice", x)
					if item then
						local price = select(11, GetItemInfo(item))
						if price > max then
							max, max_index = price, x
						end
					end
				end
				local button = _G["QuestInfoItem"..max_index]
				if button then button:Click() end
			end
		end)
	end)

	if not M.db.automation then return end
	--自动交接任务, Shift点npc不自动交接
     local idQuestAutomation = CreateFrame('Frame')
     idQuestAutomation.completed_quests = {}
     idQuestAutomation.incomplete_quests = {}

     function idQuestAutomation:canAutomate()
         if IsShiftKeyDown() then
             return false
         else
             return true
         end
     end

     function idQuestAutomation:strip_text(text)
         if not text then return end
         text = text:gsub('|c%x%x%x%x%x%x%x%x(.-)|r','%1')
         text = text:gsub('%[.*%]%s*','')
         text = text:gsub('(.+)%s*%(.+%)', '%1')
         text = text:gsub('(.+) （.+）', '%1')
         text = text:trim()
         return text
     end

     function idQuestAutomation:QUEST_PROGRESS()
         if not self:canAutomate() then return end
         if IsQuestCompletable() then
             CompleteQuest()
         end
     end

     function idQuestAutomation:QUEST_LOG_UPDATE()
         if not self:canAutomate() then return end
         local start_entry = GetQuestLogSelection()
         local num_entries = GetNumQuestLogEntries()

         self.completed_quests = {}
         self.incomplete_quests = {}

         if num_entries > 0 then
             for i = 1, num_entries do
                 SelectQuestLogEntry(i)
                 local title, _, _, _, _, _, is_complete = GetQuestLogTitle(i)
                 local no_objectives = GetNumQuestLeaderBoards(i) == 0
                 if title then
                     if is_complete or no_objectives then
                         self.completed_quests[title] = true
                     else
                         self.incomplete_quests[title] = true
                     end
                 end
             end
         end

         SelectQuestLogEntry(start_entry)
     end

     function idQuestAutomation:GOSSIP_SHOW()
         if not self:canAutomate() then return end

         local button
         local text

         for i = 1, 32 do
             button = _G['GossipTitleButton' .. i]
             if button:IsVisible() then
                 text = self:strip_text(button:GetText())
                 if button.type == 'Available' then
                     button:Click()
                 elseif button.type == 'Active' then
                     if self.completed_quests[text] then
                         button:Click()
                     end
                 end
             end
         end
     end

     function idQuestAutomation:QUEST_GREETING(...)
         if not self:canAutomate() then return end

         local button
         local text

         for i = 1, 32 do
         button = _G['QuestTitleButton' .. i]
             if button:IsVisible() then
                 text = self:strip_text(button:GetText())
                 if self.completed_quests[text] then
                     button:Click()
                 elseif not self.incomplete_quests[text] then
                     button:Click()
                 end
             end
         end
     end

     function idQuestAutomation:QUEST_DETAIL()
         if not self:canAutomate() then return end
         AcceptQuest()
     end

     function idQuestAutomation:QUEST_COMPLETE(event)
         if not self:canAutomate() then return end
         if GetNumQuestChoices() <= 1 then
             GetQuestReward(QuestFrameRewardPanel.itemChoice or 1)
         end
     end

     function idQuestAutomation.onevent(self, event, ...)
         if self[event] then
             self[event](self, ...)
         end
     end

     idQuestAutomation:SetScript('OnEvent', idQuestAutomation.onevent)
     idQuestAutomation:RegisterEvent('GOSSIP_SHOW')
     idQuestAutomation:RegisterEvent('QUEST_COMPLETE')
     idQuestAutomation:RegisterEvent('QUEST_DETAIL')
     idQuestAutomation:RegisterEvent('QUEST_FINISHED')
     idQuestAutomation:RegisterEvent('QUEST_GREETING')
     idQuestAutomation:RegisterEvent('QUEST_LOG_UPDATE')
     idQuestAutomation:RegisterEvent('QUEST_PROGRESS')

     _G.idQuestAutomation = idQuestAutomation

     QuestInfoDescriptionText.SetAlphaGradient=function() return false end
end

M:RegisterMiscModule("Quest", LoadFunc)