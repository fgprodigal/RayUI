local R, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local IF = R:GetModule("InfoBar")

local questList, mapList = {}, {
	[GetMapNameByID(1015)] = 1015,  -- Aszuna
	[GetMapNameByID(1024)] = 1024,  -- Highmountain
	[GetMapNameByID(1017)] = 1017,  -- Stormheim
	[GetMapNameByID(1033)] = 1033,  -- Suramar
	[GetMapNameByID(1018)] = 1018,  -- Val'sharah
}

local function SortQuest(a,b)
	local an = C_TaskQuest.GetQuestInfoByQuestID(a.questId)
	local at = C_TaskQuest.GetQuestTimeLeftMinutes(a.questId)
	local bn = C_TaskQuest.GetQuestInfoByQuestID(b.questId)
	local bt = C_TaskQuest.GetQuestTimeLeftMinutes(b.questId)

	if at ~= bt then
		return at < bt
	else
		return an < bn
	end
end

local function GetTimerString(value)
	local string;
	
	if value > 60*24 then
		string = format(DAYS_ABBR, math.floor (value / (60*24)))
	elseif value > 60 then
		string = format(HOURS_ABBR, math.floor(value / 60))
	else
		string = format(MINUTES_ABBR, value)
	end
	
	return string
end

local function WorldQuests_OnEnter(self)
	local preMapID = GetCurrentMapAreaID()

	GameTooltip:SetOwner(self, "ANCHOR_TOP")
	
	-- complete list
	if self.isShift then
		local index = 1
		
		for name, mapID in pairs(mapList) do
			local header
			
			SetMapByID(mapID)

			questList = C_TaskQuest.GetQuestsForPlayerByMapID(mapID)
			
			table.sort(questList, SortQuest)

			for i, info in pairs(questList) do
				local questID = info.questId
				local timeOut = C_TaskQuest.GetQuestTimeLeftMinutes(questID)

				if timeOut and timeOut > 0 then
					if not header then
						if index > 1 then
							GameTooltip:AddDivider()
						end
						
						GameTooltip:AddLine(name,1,1,1)
						GameTooltip:SetPrevLineJustify("CENTER")
						GameTooltip:AddDivider()
						
						header = true
					end
				
					local title, faction = C_TaskQuest.GetQuestInfoByQuestID(questID)
					local rarity = select(4, GetQuestTagInfo(questID))
					local color = WORLD_QUEST_QUALITY_COLORS[rarity]
					
					if faction then
						faction = GetFactionInfoByID(faction)
					else
						faction = ""
					end
					
					if color then
						title = R:RGBToHex(color.r,color.g,color.b)..title.."|r"
					end
					
					timeOut = GetTimerString(timeOut)
					
					GameTooltip:AddDoubleLine(title, timeOut, 1,1,1, 1,1,1)
				end
			end
			
			index = index + 1
		end
	end

	-- current zone (default)
	if not self.isShift then
		if not WorldMapFrame:IsShown() then
			SetMapToCurrentZone()
		end
		
		local mapID = GetCurrentMapAreaID()
		local name = GetMapNameByID(mapID)
		
		if mapList[name] then
			questList = C_TaskQuest.GetQuestsForPlayerByMapID(mapID)

			table.sort(questList, SortQuest)
			
			GameTooltip:AddLine(name, 1,1,1)
			GameTooltip:SetPrevLineJustify("CENTER")
			GameTooltip:AddDivider()
				
			for i, info in ipairs(questList) do
				local questID = info.questId
				local timeOut = C_TaskQuest.GetQuestTimeLeftMinutes(questID)

				if timeOut and timeOut > 0 then
					local title, faction = C_TaskQuest.GetQuestInfoByQuestID(questID)
					local rarity = select(4, GetQuestTagInfo(questID))
					local color = WORLD_QUEST_QUALITY_COLORS[rarity]
					
					if faction then
						faction = GetFactionInfoByID(faction)
					else
						faction = ""
					end
					
					if color then
						title = R:RGBToHex(color.r,color.g,color.b)..title.."|r"
					end
					
					timeOut = GetTimerString(timeOut)
					
					GameTooltip:AddDoubleLine(title, timeOut, 1,1,1, 1,1,1)
				end
			end
		else
			--GameTooltip:AddLine("Unable to retrieve world quests for this zone.",1,0,0)
			GameTooltip:AddLine(SPELL_FAILED_INCORRECT_AREA, 1,0,0)
		end
	end
	
	SetMapByID(preMapID)
	
	GameTooltip:AddDivider()
	GameTooltip:AddLine(L["切换"], 1,1,1)	
	GameTooltip:SetPrevLineJustify("CENTER")
	GameTooltip:Show()
end

local function WorldQuests_OnClick(self)
	--[[
	if self.isShift then
		self.isShift = false
	else
		self.isShift = true
	end
	--]]
	GameTooltip_Hide()
	WorldQuests_OnEnter(self)
end

do	-- Initialize
	local info = {}

	info.title = TRACKER_HEADER_WORLD_QUESTS
	info.icon = "Interface\\Icons\\garrison_building_tradingpost"
	info.tooltipFunc = WorldQuests_OnEnter
	info.clickFunc = WorldQuests_OnClick
	
	IF:RegisterInfoBarType("WorldQuests", info)
end