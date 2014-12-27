local Button = CreateFrame("Button", "ExtraQuestButton", UIParent, "SecureActionButtonTemplate, SecureHandlerStateTemplate, SecureHandlerAttributeTemplate")
RegisterStateDriver(Button, "visible", "[extrabar] hide; show")
local DefaultExtraActionStyle = "Interface\\ExtraButton\\ChampionLight"
Button:SetAttribute("_onattributechanged", [[
	if(name == "item") then
		if(value and not self:IsShown() and not HasExtraActionBar()) then
			self:Show()
		elseif(not value) then
			self:Hide()
			self:ClearBindings()
		end
	elseif(name == "state-visible") then
		if(value == "show") then
			self:CallMethod("Update")
		else
			self:Hide()
			self:ClearBindings()
		end
	end
	if(self:IsShown() and (name == "item" or name == "binding")) then
		self:ClearBindings()
		local key = GetBindingKey("EXTRAACTIONBUTTON1")
		if(key) then
			self:SetBindingClick(1, key, self, "LeftButton")
		end
	end
]])

local function UpdateCooldown(self)
	if(self:IsShown()) then
		local start, duration, enable = GetItemCooldown(self.itemID)
		if(duration > 0) then
			self.Cooldown:SetCooldown(start, duration)
			self.Cooldown:Show()
		else
			self.Cooldown:Hide()
		end
	end
end

Button:RegisterEvent("PLAYER_LOGIN")
Button:SetScript("OnEvent", function(self, event)
	if(event == "BAG_UPDATE_COOLDOWN") then
		UpdateCooldown(self)
	elseif(event == "PLAYER_REGEN_ENABLED") then
		self:SetAttribute("item", self.attribute)
		self:UnregisterEvent(event)
		UpdateCooldown(self)
	elseif(event == "UPDATE_BINDINGS") then
		if(self:IsShown()) then
			self:SetItem()
			self:SetAttribute("binding", GetTime())
		end
	elseif(event == "PLAYER_LOGIN") then
		self:SetPoint("CENTER", ExtraActionButton1)
		self:SetSize(ExtraActionButton1:GetSize())
		self:SetScale(ExtraActionButton1:GetScale())
		self:SetScript("OnLeave", GameTooltip_Hide)
		self:SetAttribute("type", "item")
		self:SetToplevel(true)
		self.updateTimer = 0
		self.rangeTimer = 0
		self:Hide()

		local Icon = self:CreateTexture("$parentIcon", "ARTWORK")
		Icon:SetAllPoints()
		self.Icon = Icon

		local HotKey = self:CreateFontString("$parentHotKey", nil, "NumberFontNormal")
		HotKey:SetPoint("BOTTOMRIGHT", -5, 5)
		self.HotKey = HotKey

		local Cooldown = CreateFrame("Cooldown", "$parentCooldown", self, "CooldownFrameTemplate")
		Cooldown:ClearAllPoints()
		Cooldown:SetPoint("TOPRIGHT", -2, -3)
		Cooldown:SetPoint("BOTTOMLEFT", 2, 1)
		Cooldown:Hide()
		self.Cooldown = Cooldown

		local Artwork = self:CreateTexture("$parentArtwork", "BACKGROUND")
		Artwork:SetPoint("CENTER", -2, 0)
		Artwork:SetSize(256, 128)
		Artwork:SetTexture(GetOverrideBarSkin() or DefaultExtraActionStyle)
		-- Artwork:SetTexture([[Interface\ExtraButton\Smash]])
		self.Artwork = Artwork

		self.Icon:SetTexCoord(.08, .92, .08, .92)
		self:CreateShadow("Background")
		self:StyleButton(true)

		self:RegisterEvent("UPDATE_BINDINGS")
		self:RegisterEvent("UPDATE_EXTRA_ACTIONBAR")
		self:RegisterEvent("BAG_UPDATE_COOLDOWN")
		self:RegisterEvent("BAG_UPDATE_DELAYED")
		self:RegisterEvent("WORLD_MAP_UPDATE")
		self:RegisterEvent("QUEST_LOG_UPDATE")
		self:RegisterEvent("QUEST_POI_UPDATE")
	else
		self:Update()
	end
end)

Button:SetScript("OnEnter", function(self)
	GameTooltip:SetOwner(self, "ANCHOR_LEFT")
	GameTooltip:SetHyperlink(self.itemLink)
end)

-- BUG: IsItemInRange() is broken versus friendly npcs (and possibly others)
Button:SetScript("OnUpdate", function(self, elapsed)
	if(self.rangeTimer > TOOLTIP_UPDATE_TIME) then
		local HotKey = self.HotKey
		local inRange = IsItemInRange(self.itemLink, "target")
		if(HotKey:GetText() == RANGE_INDICATOR) then
			if(inRange == false) then
				HotKey:SetTextColor(1, 0.1, 0.1)
				HotKey:Show()
			elseif(inRange) then
				HotKey:SetTextColor(1, 1, 1)
				HotKey:Show()
			else
				HotKey:Hide()
			end
		else
			if(inRange == false) then
				HotKey:SetTextColor(1, 0.1, 0.1)
			else
				HotKey:SetTextColor(1, 1, 1)
			end
		end

		self.rangeTimer = 0
	else
		self.rangeTimer = self.rangeTimer + elapsed
	end

	if(self.updateTimer > 5) then
		self:Update()
		self.updateTimer = 0
	else
		self.updateTimer = self.updateTimer + elapsed
	end
end)

local zoneWide = {
	[14108] = 541,
	[13998] = 11,
	[25798] = 61, -- quest is bugged, has no zone
	[25799] = 61, -- quest is bugged, has no zone
	[25112] = 161,
	[25111] = 161,
	[24735] = 201,
}

local blacklist = {
	[113191] = true,
	[110799] = true,
	[109164] = true,
}

function Button:SetItem(itemLink, texture)
	if(itemLink) then
		if(itemLink == self.itemLink and self:IsShown()) then
			return
		end

		local itemID, itemName = string.match(itemLink, '|Hitem:(.-):.-|h%[(.+)%]|h')

		self.Icon:SetTexture(texture)
		self.Artwork:SetTexture(GetOverrideBarSkin() or DefaultExtraActionStyle)
		self.itemID = tonumber(itemID)
		self.itemName = itemName
		self.itemLink = itemLink

		if(blacklist[self.itemID]) then
			return
		end
	end

	local HotKey = self.HotKey
	local key = GetBindingKey("EXTRAACTIONBUTTON1")
	if(key) then
		HotKey:SetText(GetBindingText(key, 1))
		HotKey:Show()
	elseif(ItemHasRange(self.itemLink)) then
		HotKey:SetText(RANGE_INDICATOR)
		HotKey:Show()
	else
		HotKey:Hide()
	end

	if(InCombatLockdown()) then
		self.attribute = self.itemName
		self:RegisterEvent("PLAYER_REGEN_ENABLED")
	else
		self:SetAttribute("item", self.itemName)
	end
end

function Button:RemoveItem()
	if(InCombatLockdown()) then
		self.attribute = nil
		self:RegisterEvent("PLAYER_REGEN_ENABLED")
	else
		self:SetAttribute("item", nil)
	end
end

local ticker
function Button:Update()
	local numItems = 0
	local shortestDistance = 62500 -- 250 yards²
	local closestQuestLink, closestQuestTexture

	for index = 1, GetNumQuestWatches() do
		local questID, _, questIndex, _, _, isComplete = GetQuestWatchInfo(index)
		if(questID and QuestHasPOIInfo(questID)) then
			local link, texture, _, showCompleted = GetQuestLogSpecialItemInfo(questIndex)
			if(link) then
				local areaID = zoneWide[questID]
				if(areaID and areaID == GetCurrentMapAreaID()) then
					closestQuestLink = link
					closestQuestTexture = texture
				elseif(not isComplete or (isComplete and showCompleted)) then
					local distanceSq, onContinent = GetDistanceSqToQuest(questIndex)
					if(onContinent and distanceSq < shortestDistance) then
						shortestDistance = distanceSq
						closestQuestLink = link
						closestQuestTexture = texture
					end
				end

				numItems = numItems + 1
			end
		end
	end

	if(closestQuestLink and not HasExtraActionBar()) then
		self:SetItem(closestQuestLink, closestQuestTexture)
	elseif(self:IsShown()) then
		self:RemoveItem()
	end

	if(numItems > 0 and not ticker) then
		ticker = C_Timer.NewTicker(30, function() -- might want to lower this
			Button:Update()
		end)
	elseif(numItems == 0 and ticker) then
		ticker:Cancel()
		ticker = nil
	end
end
