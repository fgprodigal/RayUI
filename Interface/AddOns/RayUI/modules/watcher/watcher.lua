local R, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local RW = R:NewModule("Watcher", "AceEvent-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")

RW.modName = L["法术监视"]

local colors = R.colors.class
RW.modules = {}

local defaults = {}
local watcherPrototype = {}
local _G, UnitBuff, UnitDebuff = _G, UnitBuff, UnitDebuff
local BUFF_FLASH_TIME_ON = 0.75
local BUFF_FLASH_TIME_OFF = 0.75
local BUFF_MIN_ALPHA = 0.2

function watcherPrototype:OnEnable()
		if self.parent then
			self.parent:Show()
		end
		self:Update()
end

function watcherPrototype:OnDisable()
	if self.parent then
		self.parent:Hide()
	end
end

function RW:UpdateAlpha(elapsed)
	self.BuffFrameFlashTime = self.BuffFrameFlashTime - elapsed
	if ( self.BuffFrameFlashTime < 0 ) then
		local overtime = -self.BuffFrameFlashTime
		if ( self.BuffFrameFlashState == 0 ) then
			self.BuffFrameFlashState = 1
			self.BuffFrameFlashTime = BUFF_FLASH_TIME_ON
		else
			self.BuffFrameFlashState = 0
			self.BuffFrameFlashTime = BUFF_FLASH_TIME_OFF
		end
		if ( overtime < self.BuffFrameFlashTime ) then
			self.BuffFrameFlashTime = self.BuffFrameFlashTime - overtime
		end
	end

	if ( self.BuffFrameFlashState == 1 ) then
		self.BuffAlphaValue = (BUFF_FLASH_TIME_ON - self.BuffFrameFlashTime) / BUFF_FLASH_TIME_ON
	else
		self.BuffAlphaValue = self.BuffFrameFlashTime / BUFF_FLASH_TIME_ON
	end
	self.BuffAlphaValue = (self.BuffAlphaValue * (1 - BUFF_MIN_ALPHA)) + BUFF_MIN_ALPHA
end

local function Flash(self)
	local time = self.start + self.duration - GetTime()

	if time >0 and time < 5 then
		self:SetAlpha(RW.AlphaFrame.BuffAlphaValue)
	else
		self:SetAlpha(1)
	end
end

function watcherPrototype:CreateButton(mode)
	local button=CreateFrame("Button", nil, self.parent)
	button:CreateShadow("Background")
	button:StyleButton(true)
	button:SetPushedTexture(nil)
	button:SetSize(self.size, self.size)
	self.parent:SetSize(self.size, self.size)
	button.icon = button:CreateTexture(nil, "BORDER")
	button.icon:SetAllPoints()
    button.icon:SetTexCoord(.08, .92, .08, .92)
	button:SetScript("OnEnter", function(self)
			GameTooltip:SetOwner(self, "ANCHOR_TOP")
			if not RW.testing then
				if self.filter == "BUFF" then
					GameTooltip:SetUnitAura(self.unitID, self.index, "HELPFUL")
				elseif self.filter == "DEBUFF" then
					GameTooltip:SetUnitAura(self.unitID, self.index, "HARMFUL")
				elseif self.filter == "itemCD" then
					GameTooltip:SetHyperlink(select(2,GetItemInfo(self.spellID)))
				elseif self.filter == "slotCD" then
					GameTooltip:SetInventoryItem("player", self.spellID)
				else
					GameTooltip:SetSpellByID(self.spellID)
				end
			else
				GameTooltip:SetSpellByID(self.spellID)
			end
			GameTooltip:Show()
		end)
	button:SetScript("OnLeave", GameTooltip_Hide)
	if mode=="BAR" then
		button.statusbar = CreateFrame("StatusBar", nil, button)
		button.statusbar:SetFrameStrata("BACKGROUND")
		button.statusbar:CreateShadow("Background")
		button.statusbar:SetWidth(self.barwidth - 6)
		button.statusbar:SetHeight(5)
		button.statusbar:SetStatusBarTexture(R["media"].normal)
		button.statusbar:SetStatusBarColor(colors[R.myclass].r, colors[R.myclass].g, colors[R.myclass].b, 1)
		if ( self.iconside == "RIGHT" ) then
			button.statusbar:SetPoint("BOTTOMRIGHT", button, "BOTTOMLEFT", -5, 0)
		else
			button.statusbar:SetPoint("BOTTOMLEFT", button, "BOTTOMRIGHT", 5, 0)
		end
		button.statusbar:SetMinMaxValues(0, 1)
		button.statusbar:SetValue(1)
		local spark = button.statusbar:CreateTexture(nil, "OVERLAY")
		spark:SetTexture[[Interface\CastingBar\UI-CastingBar-Spark]]
		spark:SetBlendMode("ADD")
		spark:SetAlpha(.8)
		spark:SetPoint("TOPLEFT", button.statusbar:GetStatusBarTexture(), "TOPRIGHT", -10, 13)
		spark:SetPoint("BOTTOMRIGHT", button.statusbar:GetStatusBarTexture(), "BOTTOMRIGHT", 10, -13)
		button.time = button:CreateFontString(nil, "OVERLAY")
		button.time:SetFont(R["media"].font, R["media"].fontsize, R["media"].fontflag)
		button.time:SetPoint("BOTTOMRIGHT", button.statusbar, "TOPRIGHT", 0, 2)
		button.time:SetText("60")
		button.name = button:CreateFontString(nil, "OVERLAY")
		button.name:SetFont(R["media"].font, R["media"].fontsize, R["media"].fontflag)
		button.name:SetPoint("BOTTOMLEFT", button.statusbar, "TOPLEFT", 0, 2)
		button.name:SetText("技能名称")
		button.mode = "BAR"
	else
		button.cooldown = CreateFrame("Cooldown", nil, button, "CooldownFrameTemplate")
		button.cooldown:SetAllPoints(button.icon)
		button.cooldown:SetReverse()
		button.cooldown:SetFrameLevel(2)
		button.cooldown:SetHideCountdownNumbers(true)
		button.cooldown.SetHideCountdownNumbers = R.dummy
		button.mode = "ICON"
	end
	local textFrame = CreateFrame("Frame", nil, button)
	textFrame:SetAllPoints()
	textFrame:SetFrameLevel(button:GetFrameLevel() + 1)
	button.count = textFrame:CreateFontString(nil, "OVERLAY")
	button.count:SetFont(R["media"].font, R["media"].fontsize * (R:Round(self.size) / 30), R["media"].fontflag)
	button.count:SetPoint("BOTTOMRIGHT", button , "BOTTOMRIGHT", 4, -4)
	button.count:SetJustifyH("RIGHT")

	button.value = textFrame:CreateFontString(nil, "OVERLAY")
	button.value:SetFont(R["media"].font, ( R["media"].fontsize - 3 ) * (R:Round(self.size) / 30), R["media"].fontflag)
	button.value:SetPoint("CENTER", button , "TOP", 0, 1)
	button.value:SetJustifyH("RIGHT")

	button.owner = self
	return button
end

function watcherPrototype:UpdateButton(button, index, icon, count, duration, expires, spellID, unitID, filter, value)
	button.icon:SetTexture(icon)
	button.count:SetText(count > 1 and count or "")
	button.value:SetText((value and value > 1) and value or "")
	if button.cooldown then
		if filter:find("CD") then
			button.cooldown:SetReverse(false)
			CooldownFrame_SetTimer(button.cooldown, expires, duration, 1)
		else
			button.cooldown:SetReverse(true)
			CooldownFrame_SetTimer(button.cooldown, expires - duration, duration, 1)
		end
	end
	if filter:find("CD") then
		button.start = expires
		button.duration = duration
	else
		button.start = expires - duration
		button.duration = duration
	end
	button.index = index
	button.filter = filter
	button.unitID = unitID
	button.spellID = spellID
	if filter == "itemCD" then
		button.spn = GetItemInfo(spellID)
	elseif filter == "slotCD" then
		local slotLink = GetInventoryItemLink("player", spellID)
		button.spn = GetItemInfo(slotLink)
	else
		button.spn = GetSpellInfo(spellID)
	end
	if not button:IsShown() then
		button:Show()
	end
end

local function OnUpdate(self, elapsed)
	if self.spellID then
		if self.filter == "BUFF" or self.filter == "DEBUFF" then
			local _, _, _, _, _, duration, expires = (self.filter == "BUFF" and UnitBuff or UnitDebuff)(self.unitID, self.index)
			if not duration then
				self.owner:Update()
			end
			if duration == 0 then
				self.statusbar:SetMinMaxValues(0, 1)
				self.time:SetText("")
				self.name:SetText(self.spn)
				self.statusbar:SetValue(1)
			else
				self.statusbar:SetMinMaxValues(0, duration)
				local time = expires - GetTime()
				self.statusbar:SetValue(time)
				self.name:SetText(self.spn)
				if time <= 60 then
					self.time:SetFormattedText("%.1f", time)
				else
					self.time:SetFormattedText("%d:%.2d", time/60, time%60)
				end
			end
		elseif self.filter == "CD" or self.filter == "itemCD" or self.filter == "slotCD" then
			local start, duration
			if self.filter == "slotCD" then
				start, duration = GetInventoryItemCooldown("player", self.spellID)
			elseif self.filter == "CD" then
				start, duration = GetSpellCooldown(self.spellID)
			elseif self.filter == "itemCD" then
				start, duration = GetItemCooldown(self.spellID)
			end
			if self.mode == "BAR" then
				self.statusbar:SetMinMaxValues(0, duration)
				local time = start + duration - GetTime()
				self.statusbar:SetValue(time)
				if time <= 60 then
					self.time:SetFormattedText("%.1f", time)
				else
					self.time:SetFormattedText("%d:%.2d", time/60, time%60)
				end
				self.name:SetText(self.spn)
			end
			if start == 0 then
				self:SetScript("OnUpdate", nil)
				self.owner:Update()
			end
		end
		Flash(self)
	end
end

function watcherPrototype:CheckAura()
	if self.BUFF then
		for unitID in pairs(self.BUFF.unitIDs) do
			local index = 1
			while UnitBuff(unitID, index) and not ( index > 40 ) do
				local spellName, _, icon, count, _, duration, expires, caster, _, _, spellID, _, _, _, value = UnitBuff(unitID,index)
				if (self.BUFF[spellID] and self.BUFF[spellID].unitID == unitID and ( caster == self.BUFF[spellID].caster or self.BUFF[spellID].caster:lower() == "all" )) or
					(self.BUFF[spellName] and self.BUFF[spellName].unitID == unitID and ( caster == self.BUFF[spellName].caster or self.BUFF[spellName].caster:lower() == "all" )) then
					if not self.button[self.current] then
						self.button[self.current] = self:CreateButton(self.mode)
						self:SetPosition(self.current)
					end
					self:UpdateButton(self.button[self.current], index, icon, count, duration, expires, spellID, unitID, "BUFF", value)
					if self.mode == "BAR" then
						self.button[self.current]:SetScript("OnUpdate", OnUpdate)
					else
						self.button[self.current]:SetScript("OnUpdate", Flash)
					end
					self.current = self.current + 1
				end
				index = index + 1
			end
        end
	end
	if self.DEBUFF then
		for unitID in pairs(self.DEBUFF.unitIDs) do
			local index = 1
			while UnitDebuff(unitID, index) and not ( index > 1024 ) do
				local spellName, _, icon, count, _, duration, expires, caster, _, _, spellID, _, _, _, value = UnitDebuff(unitID,index)
				if (self.DEBUFF[spellID] and self.DEBUFF[spellID].unitID == unitID and ( caster == self.DEBUFF[spellID].caster or self.DEBUFF[spellID].caster:lower() == "all" )) or
					(self.DEBUFF[spellName] and self.DEBUFF[spellName].unitID == unitID and ( caster == self.DEBUFF[spellName].caster or self.DEBUFF[spellName].caster:lower() == "all" )) then
					if not self.button[self.current] then
						self.button[self.current] = self:CreateButton(self.mode)
						self:SetPosition(self.current)
					end
					self:UpdateButton(self.button[self.current], index, icon, count, duration, expires, spellID, unitID, "DEBUFF", value)
					if self.mode == "BAR" then
						self.button[self.current]:SetScript("OnUpdate", OnUpdate)
					else
						self.button[self.current]:SetScript("OnUpdate", Flash)
					end
					self.current = self.current + 1
				end
				index = index + 1
			end
		end
	end
end

function watcherPrototype:CheckCooldown()
	if self.CD then
		for spellID in pairs(self.CD) do
			if type(spellID) == "number" and self.CD[spellID] then
				local start, duration = GetSpellCooldown(spellID)
				local _, _, icon = GetSpellInfo(spellID)
				if start ~= 0 and duration > 2.9 then
					if not self.button[self.current] then
						self.button[self.current] = self:CreateButton(self.mode)
						self:SetPosition(self.current)
					end
					self:UpdateButton(self.button[self.current], nil, icon, 0, duration, start, spellID, nil, "CD")
					self.button[self.current]:SetScript("OnUpdate", OnUpdate)
					self.current = self.current + 1
				end
			end
		end
	end
	if self.itemCD then
		for itemID in pairs(self.itemCD) do
			if type(itemID) == "number" and self.itemCD[itemID] then
				local start, duration = GetItemCooldown(itemID)
				local _, _, _, _, _, _, _, _, _, icon = GetItemInfo(itemID)
				if start ~= 0 and duration > 2.9 then
					if not self.button[self.current] then
						self.button[self.current] = self:CreateButton(self.mode)
						self:SetPosition(self.current)
					end
					self:UpdateButton(self.button[self.current], nil, icon, 0, duration, start, itemID, nil, "itemCD")
					self.button[self.current]:SetScript("OnUpdate", OnUpdate)
					self.current = self.current + 1
				end
			end
		end
	end
	if self.slotCD then
		for slotID in pairs(self.slotCD) do
			if type(slotID) == "number" and self.slotCD[slotID] then
				local slotLink = GetInventoryItemLink("player", slotID)
				if slotLink then
					local _, _, _, _, _, _, _, _, _, icon = GetItemInfo(slotLink)
					local start, duration = GetInventoryItemCooldown("player", slotID)
					if start ~= 0 and duration > 2.9 then
						if not self.button[self.current] then
							self.button[self.current] = self:CreateButton(self.mode)
							self:SetPosition(self.current)
						end
						self:UpdateButton(self.button[self.current], nil, icon, 0, duration, start, slotID, nil, "slotCD")
						self.button[self.current]:SetScript("OnUpdate", OnUpdate)
						self.current = self.current + 1
					end
				end
			end
		end
	end
end

function watcherPrototype:Update()
	self.current = 1
	for i = 1, #self.button do
		if self.button[i]:IsShown() then
			self.button[i]:Hide()
		end
	end
	self:CheckAura()
	self:CheckCooldown()
end

function watcherPrototype:SetPosition(num)
	if not self.button[num] then return end
	if num == 1 then 
		self.button[num]:ClearAllPoints()
		self.button[num]:SetPoint("CENTER", self.parent, "CENTER", 0, 0)
	elseif self.direction == "LEFT" then
		self.button[num]:ClearAllPoints()
		self.button[num]:SetPoint("RIGHT", self.button[num-1], "LEFT", -6, 0)
	elseif self.direction == "RIGHT" then
		self.button[num]:ClearAllPoints()
		self.button[num]:SetPoint("LEFT", self.button[num-1], "RIGHT", 6, 0)
	elseif self.direction == "DOWN" then
		self.button[num]:ClearAllPoints()
		self.button[num]:SetPoint("TOP", self.button[num-1], "BOTTOM", 0, -6)
	else
		self.button[num]:ClearAllPoints()
		self.button[num]:SetPoint("BOTTOM", self.button[num-1], "TOP", 0, 6)
	end
end

function watcherPrototype:OnEvent(event, unit)
	if event == "PLAYER_ENTERING_WORLD" then
		self.holder:SetPoint(unpack(self.setpoint))
		self.parent:SetAllPoints(self.holder)
		R:CreateMover(self.holder, self.name.."Holder", self.name, true)
		self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	end
	local needUpdate
	if self.BUFF and unit and self.BUFF.unitIDs[unit] then
		needUpdate = true
	end
	if self.DEBUFF and unit and self.DEBUFF.unitIDs[unit] then
		needUpdate = true
	end
	if needUpdate or not unit then
		self:Update()
	end
end

function RW:Initialize()
	SpellActivationOverlayFrame:SetFrameStrata("BACKGROUND")
	SpellActivationOverlayFrame:SetFrameLevel(0)
	if type(R["Watcher"]["filters"][R.myclass]) == "table" then
		for _, t in ipairs(R["Watcher"]["filters"][R.myclass]) do
			self:NewWatcher(t)
		end
	end
	if type(R["Watcher"]["filters"]["ALL"]) == "table" then
		for _, t in ipairs(R["Watcher"]["filters"]["ALL"]) do
			self:NewWatcher(t)
		end
	end
	wipe(R["Watcher"]["filters"])
	self.AlphaFrame = CreateFrame("Frame")
	self.AlphaFrame.BuffAlphaValue = 1
	self.AlphaFrame.BuffFrameFlashState = 1
	self.AlphaFrame.BuffFrameFlashTime = 0
	self.AlphaFrame:SetScript("OnUpdate", self.UpdateAlpha)
end

function RW:NewWatcher(data)
	local name, module
	for i, v in pairs(data) do
		if type(v) ~= "table" then
			if i:lower()=="name" then
				name = v
			end
		end
	end
	if name then
		module = self:NewModule(name, "AceEvent-3.0")
	else
		error("can't find argument 'name'")
		return
	end
	local function search(k, plist)
		for i=1, table.getn(plist) do
		   local v = plist[i][k]
		   if v then return v end
		end
	end
	local function createClass(...)
		local c = {}
		local arg = {...}
		setmetatable(c, {__index = function (t, k)
			return search(k, arg)
		end})
		c.__index = c
		function c:new (o)
			o = o or {}
			setmetatable(o, c)
			return o
		end
		return c
	end
	local oldmeta = getmetatable(module)
	module = setmetatable(module, { __index = createClass(oldmeta, watcherPrototype) })
	module.button = {}

	for i,v in pairs(data) do
		if type(v) == "function" then
			v = v()
		end
		if type(v) ~= "table" or (type(v) == "table" and type(i) ~= "number") then
			module[i:lower()] = v
		elseif type(v) == "table" then
			if (v.spellID or v.itemID or v.slotID) and v.filter then
				local spellName
				if v.fuzzy and (v.filter == "BUFF" or v.filter == "DEBUFF") then spellName = GetSpellInfo(v.spellID) end
				if v.filter == "CD" and v.slotID then v.filter = "slotCD" end
				if v.filter == "CD" and v.itemID then v.filter = "itemCD" end
				module[v.filter] = module[v.filter] or {}
				module[v.filter][spellName or v.spellID or v.itemID or v.slotID] = module[v.filter][spellName or v.spellID or v.itemID or v.slotID] or {}
				for ii,vv in pairs(v) do
					if ii ~= "filter" and ii ~= "spellID" and ii ~= "itemID" and ii ~= "slotID" and v.filter ~= "CD" and v.filter ~= "itemCD" and v.filter ~= "slotCD" then
						ii = ii == "unitId" and "unitID" or ii
						module[v.filter][spellName or v.spellID or v.itemID][ii] = vv
						if spellName then
							module[v.filter][spellName]["spellID"] = v.spellID
							module[v.filter][spellName]["fuzzy"] = true
						end
					end
					if (ii == "unitId" or ii == "unitID") and (v.filter == "BUFF" or v.filter == "DEBUFF") then
						module[v.filter]["unitIDs"] = module[v.filter]["unitIDs"] or {}
						module[v.filter]["unitIDs"][vv] = true
					end
				end
			end
		end
	end

	module.holder = CreateFrame("Frame", nil, UIParent)
	module.holder:SetSize(module.size, module.size)
	module.parent = CreateFrame("Frame", module.name, UIParent)
	module.parent:SetAllPoints(holder)

	module:RegisterEvent("PLAYER_ENTERING_WORLD", "OnEvent")
	if module.BUFF or module.DEBUFF then
		module:RegisterEvent("UNIT_AURA", "OnEvent")
		module:RegisterEvent("PLAYER_TARGET_CHANGED", "OnEvent")
		module:RegisterEvent("PLAYER_FOCUS_CHANGED", "OnEvent")
	end
	if module.CD or module.itemCD then
		module:RegisterEvent("SPELL_UPDATE_COOLDOWN", "OnEvent")
		module:RegisterEvent("SPELL_UPDATE_USABLE", "OnEvent")
	end
	RW.modules[module.name] = module
end

R:RegisterModule(RW:GetName())
