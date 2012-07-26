local R, L, P = unpack(select(2, ...)) --Inport: Engine, Locales, ProfileDB
local RW = R:NewModule("Watcher", "AceEvent-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")

RW.modName = L["法术监视"]

local colors = RAID_CLASS_COLORS
RW.modules = {}
RW.GroupName = {}
RW.testing = false

local defaults = {}
local watcherPrototype = {}
local _G, UnitBuff, UnitDebuff, CooldownFrame_SetTimer = _G, UnitBuff, UnitDebuff, CooldownFrame_SetTimer

local function CreatePopup()
	local S = R:GetModule("Skins")
	local f = CreateFrame("Frame", "WatcherMoverPopupWindow", UIParent)
	f:SetFrameStrata("DIALOG")
	f:SetToplevel(true)
	f:EnableMouse(true)
	f:SetClampedToScreen(true)
	f:SetWidth(360)
	f:SetHeight(110)
	f:SetPoint("TOP", 0, -50)
	f:Hide()
	f:SetMovable(true)
	f:RegisterForDrag("LeftButton")
	f:SetScript("OnDragStart", function(self) self:StartMoving() self:SetUserPlaced(false) end)
	f:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
	f:SetScript("OnShow", function() PlaySound("igMainMenuOption") end)
	f:SetScript("OnHide", function() PlaySound("gsTitleOptionExit") end)
	S:SetBD(f)

	local title = f:CreateFontString(nil, "OVERLAY")
	title:SetFontObject(GameFontNormal)
	title:SetShadowOffset(R.mult, -R.mult)
	title:SetShadowColor(0, 0, 0)
	title:SetPoint("TOP", f, "TOP", 0, -10)
	title:SetJustifyH("CENTER")
	title:SetText("RayUI")

	local desc = f:CreateFontString(nil, "ARTWORK")
	desc:SetFontObject("GameFontHighlight")
	desc:SetJustifyV("TOP")
	desc:SetJustifyH("LEFT")
	desc:SetPoint("TOPLEFT", 18, -32)
	desc:SetPoint("BOTTOMRIGHT", -18, 48)
	desc:SetText(L["锚点已解锁，拖动锚点移动位置，完成后点击锁定按钮。"])

	local lock = CreateFrame("Button", "RayUIWatcherLock", f, "OptionsButtonTemplate")
	_G[lock:GetName() .. "Text"]:SetText(L["锁定"])

	lock:SetScript("OnClick", function(self)
		RW:TestMode()
		AceConfigDialog["Open"](AceConfigDialog,"RayUI") 
	end)

	lock:SetPoint("BOTTOMRIGHT", -14, 14)
	S:Reskin(lock)

	f:RegisterEvent("PLAYER_REGEN_DISABLED")
	f:SetScript("OnEvent", function(self)
		if self:IsShown() then
			self:Hide()
		end
	end)
end

function watcherPrototype:OnEnable()
		if self.parent then
			self.parent:Show()
		end
		self:TestMode(RW.testing)
		self:Update()
end

function watcherPrototype:OnDisable()
	if self.parent then
		self.parent:Hide()
	end
end

function watcherPrototype:CreateButton(mode)
	local button=CreateFrame("Button", nil, self.parent)
	button:CreateShadow("Background")
	button:StyleButton(true)
	button:SetPushedTexture(nil)
	button:SetSize(self.size, self.size)
	self.parent:SetSize(self.size, self.size)
	button.icon = button:CreateTexture(nil, "ARTWORK")
	button.icon:SetAllPoints()
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
		button.mode = "ICON"
	end
	button.count = button:CreateFontString(nil, "OVERLAY")
	button.count:SetFont(R["media"].font, R["media"].fontsize * (R:Round(self.size) / 30), R["media"].fontflag)
	button.count:SetPoint("BOTTOMRIGHT", button , "BOTTOMRIGHT", 4, -4)
	button.count:SetJustifyH("RIGHT")
	button.owner = self
	return button
end

function watcherPrototype:UpdateButton(button, index, icon, count, duration, expires, spellID, unitID, filter)
	button.icon:SetTexture(icon)
	button.icon:SetTexCoord(.1, .9, .1, .9)
	button.count:SetText(count > 1 and count or "")
	if button.cooldown then
		if filter == "CD" or filter == "itemCD" or filter == "slotCD" then
			button.cooldown:SetReverse(false)
			CooldownFrame_SetTimer(button.cooldown, expires, duration, 1)
		else
			button.cooldown:SetReverse(true)
			CooldownFrame_SetTimer(button.cooldown, expires - duration, duration, 1)
		end
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
	end
end

function watcherPrototype:CheckAura()
	if self.BUFF then
		for unitID in pairs(self.BUFF.unitIDs) do
			local index = 1
			while UnitBuff(unitID, index) and not ( index > 1024 ) do
				local spellName, _, icon, count, _, duration, expires, caster, _, _, spellID = UnitBuff(unitID,index)
				if (self.BUFF[spellID] and self.BUFF[spellID].unitID == unitID and ( caster == self.BUFF[spellID].caster or self.BUFF[spellID].caster:lower() == "all" )) or
					(self.BUFF[spellName] and self.BUFF[spellName].unitID == unitID and ( caster == self.BUFF[spellName].caster or self.BUFF[spellName].caster:lower() == "all" )) then
					if not self.button[self.current] then
						self.button[self.current] = self:CreateButton(self.mode)
						self:SetPosition(self.current)
					end
					self:UpdateButton(self.button[self.current], index, icon, count, duration, expires, spellID, unitID, "BUFF")
					if self.mode == "BAR" then
						self.button[self.current]:SetScript("OnUpdate", OnUpdate)
					else
						self.button[self.current]:SetScript("OnUpdate", nil)
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
				local spellName, _, icon, count, _, duration, expires, caster, _, _, spellID = UnitDebuff(unitID,index)
				if (self.DEBUFF[spellID] and self.DEBUFF[spellID].unitID == unitID and ( caster == self.DEBUFF[spellID].caster or self.DEBUFF[spellID].caster:lower() == "all" )) or
					(self.DEBUFF[spellName] and self.DEBUFF[spellName].unitID == unitID and ( caster == self.DEBUFF[spellName].caster or self.DEBUFF[spellName].caster:lower() == "all" )) then
					if not self.button[self.current] then
						self.button[self.current] = self:CreateButton(self.mode)
						self:SetPosition(self.current)
					end
					self:UpdateButton(self.button[self.current], index, icon, count, duration, expires, spellID, unitID, "DEBUFF")
					if self.mode == "BAR" then
						self.button[self.current]:SetScript("OnUpdate", OnUpdate)
					else
						self.button[self.current]:SetScript("OnUpdate", nil)
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

function watcherPrototype:ApplyStyle()
	for i =1, #self.button do
		local button = self.button[i]
		if self.mode == "BAR" then
			if not button.statusbar then
				self.barwidth = self.barwidth or 150
				if self.direction == "LEFT" or self.direction == "RIGHT" then
					self.direction = "UP"
				end
				button.statusbar = CreateFrame("StatusBar", nil, button)
				button.statusbar:SetFrameStrata("BACKGROUND")
				local shadow = CreateFrame("Frame", nil, button.statusbar)
				shadow:SetPoint("TOPLEFT", -2, 2)
				shadow:SetPoint("BOTTOMRIGHT", 2, -2)
				shadow:CreateShadow("Background")
				button.statusbar:SetWidth(self.barwidth - 6)
				button.statusbar:SetHeight(5)
				button.statusbar:SetStatusBarTexture(R["media"].normal)
				button.statusbar:SetStatusBarColor(colors[R.myclass].r, colors[R.myclass].g, colors[R.myclass].b, 1)
				if ( self.iconside == "RIGHT" ) then
					button.statusbar:SetPoint("BOTTOMRIGHT", button, "BOTTOMLEFT", -5, 2)
				else
					button.statusbar:SetPoint("BOTTOMLEFT", button, "BOTTOMRIGHT", 5, 2)
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
				button.cooldown:Hide()
				button.cooldown = nil
				button:SetScript("OnUpdate", nil)
			end
		end
		if self.mode == "ICON" then
			if not button.cooldown then
				button.cooldown = CreateFrame("Cooldown", nil, button, "CooldownFrameTemplate")
				button.cooldown:SetAllPoints(button.icon)
				button.cooldown:SetReverse()
				button.mode = "ICON"
				button.statusbar:Hide()
				button.statusbar = nil
				button.time:Hide()
				button.time = nil
				button.name:Hide()
				button.name = nil
				button:SetScript("OnUpdate", nil)
			end
		end
		button:SetSize(self.size, self.size)
		self.parent:SetSize(self.size, self.size)
		if button.mode == "BAR" then
			button.statusbar:SetWidth(self.barwidth)
			button.statusbar:ClearAllPoints()
			if ( self.iconside == "RIGHT" ) then
				button.statusbar:SetPoint("BOTTOMRIGHT", button, "BOTTOMLEFT", -5, 2)
			else
				button.statusbar:SetPoint("BOTTOMLEFT", button, "BOTTOMRIGHT", 5, 2)
			end
		end
		self:SetPosition(i)
		button.mode = self.mode
	end
end

function watcherPrototype:TestMode(arg)
	if not self:IsEnabled() then return end
	if arg == true then
		local num = 1
		self:UnregisterEvent("UNIT_AURA")
		self:UnregisterEvent("PLAYER_TARGET_CHANGED")
		self:UnregisterEvent("SPELL_UPDATE_COOLDOWN")
		for _, subt in pairs({"BUFF", "DEBUFF", "CD", "itemCD"}) do
			for i,v in pairs(self[subt] or {}) do
				if i ~= "unitIDs" then
					if type(i) == "string" then i = self[subt][i].spellID end
					if not self.button[num] then
						self.button[num] = self:CreateButton(self.mode)
						self:SetPosition(num)
					end
					local icon
					if subt == "itemCD" then
						_, _, _, _, _, _, _, _, _, icon = GetItemInfo(i)
					else
						_, _, icon = GetSpellInfo(i)
					end
					if icon then
						self:UpdateButton(self.button[num], 1, icon, 9, 0, 0, i, "player", subt:upper())
					else
						print("|cff7aa6d6Ray|r|cffff0000W|r|cff7aa6d6atcher|r: "..self.name.." "..subt.." ID: "..i.."不存在")
					end
					num = num + 1
				end
			end
		end
		self.moverFrame:Show()
	else
		self:RegisterEvent("UNIT_AURA", "OnEvent")
		self:RegisterEvent("PLAYER_TARGET_CHANGED", "OnEvent")
		self:RegisterEvent("SPELL_UPDATE_COOLDOWN", "OnEvent")
		for _, v in pairs(RW.modules) do
			v:Update()
		end
		self.moverFrame:Hide()
	end
end

function watcherPrototype:OnEvent(event, unit)
	local needUpdate
	if event == "PLAYER_ENTERING_WORLD" then
		self.holder:SetPoint(unpack(self.setpoint))
		self.parent:SetAllPoints(self.holder)
		R:CreateMover(self.holder, self.name.."Holder", self.name, true)
		local _, parent = unpack(self.setpoint)
		if parent then self.parent:SetParent(parent) end
		if self.disabled then self:Disable() end
		self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	end
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
--[[ 	CreatePopup()

	defaults.profile = {}
	defaults.profile.Watcher = {}
	for i,v in pairs(RW.modules) do
		RW.GroupName[i] = i
		defaults.profile.Watcher[i] = defaults.profile.Watcher[i] or {}
		for ii,vv in pairs(v) do
			if type(vv) ~= "table" then
				defaults.profile.Watcher[i][ii] = vv
			end
		end
	end
	local db = LibStub("AceDB-3.0"):New("RayUIData", defaults)
	self.db = db.profile.Watcher
	self.db.GroupSelect = self.db.GroupSelect or next(self.GroupName)
	self.db.idinput = nil
	self.db.filterinput = nil
	self.db.unitidinput = nil
	self.db.casterinput = nil
	self.db.fuzzy = nil
	self:UpdateGroup()

	for group, options in pairs(R.db.Watcher) do
		if self.modules[group] then
			for option, value in pairs(options) do
				if type(value) ~= "table" then
					self.modules[group][option] = value
					self.db[group][option] = value
				end
			end
			if type(options.BUFF) == "table" then
				for id, value in pairs(options.BUFF) do
					self.modules[group]["BUFF"] = self.modules[group]["BUFF"] or {}
					self.modules[group]["BUFF"][id] = value
					self.db[group]["BUFF"] = self.db[group]["BUFF"] or {}
					self.db[group]["BUFF"][id] = value
				end
			end
			if type(options.DEBUFF) == "table" then
				for id, value in pairs(options.DEBUFF or {}) do
					self.modules[group]["DEBUFF"] = self.modules[group]["DEBUFF"] or {}
					self.modules[group]["DEBUFF"][id] = value
					self.db[group]["DEBUFF"] = self.db[group]["DEBUFF"] or {}
					self.db[group]["DEBUFF"][id] = value
				end
			end
			if type(options.CD) == "table" then
				for id, value in pairs(options.CD or {}) do
					self.modules[group]["CD"] = self.modules[group]["CD"] or {}
					self.modules[group]["CD"][id] = value
					self.db[group]["CD"] = self.db[group]["CD"] or {}
					self.db[group]["CD"][id] = value
				end
			end
			if type(options.itemCD) == "table" then
				for id, value in pairs(options.itemCD or {}) do
					self.modules[group]["itemCD"] = self.modules[group]["itemCD"] or {}
					self.modules[group]["itemCD"][id] = value
					self.db[group]["itemCD"] = self.db[group]["itemCD"] or {}
					self.db[group]["itemCD"][id] = value
				end
			end
		end
	end ]]
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
				if v.filter == "itemCD" and v.slotID then v.filter = "slotCD" end
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

	local mover = CreateFrame("Frame", nil, module.parent)
	module.moverFrame = mover
	module.moverFrame.owner = module
	mover:SetAllPoints(module.parent)
	mover:SetFrameStrata("FULLSCREEN_DIALOG")
	mover.mask = mover:CreateTexture(nil, "OVERLAY")
	mover.mask:SetAllPoints(mover)
	mover.mask:SetTexture(0, 1, 0, 0.5)
	mover.text = mover:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	mover.text:SetPoint("CENTER")
	mover.text:SetText(module.name)

	mover:RegisterForDrag("LeftButton")
	mover:SetScript("OnDragStart", function(self) self:GetParent():StartMoving() end)
	mover:SetScript("OnDragStop", function(self) self:GetParent():StopMovingOrSizing() end)

	mover:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_TOP")
		GameTooltip:ClearLines()
		GameTooltip:AddLine(self.owner.name)
		GameTooltip:AddLine("拖拽左键移动", 1, 1, 1)
		GameTooltip:Show()
	end)

	mover:SetScript("OnUpdate", nil)

	mover:Hide()

	if module.BUFF or module.DEBUFF then
		module:RegisterEvent("UNIT_AURA", "OnEvent")
		module:RegisterEvent("PLAYER_TARGET_CHANGED", "OnEvent")
		module:RegisterEvent("PLAYER_FOCUS_CHANGED", "OnEvent")
	end
	if module.CD or module.itemCD then
		module:RegisterEvent("SPELL_UPDATE_COOLDOWN", "OnEvent")
	end
	RW.modules[module.name] = module
	module:RegisterEvent("PLAYER_ENTERING_WORLD", "OnEvent")
end

function RW:TestMode()
	if not RW.testing then
		WatcherMoverPopupWindow:Show()
	else
		WatcherMoverPopupWindow:Hide()
	end
	RW.testing = not RW.testing
	for _, v in pairs(RW.modules) do
		v:TestMode(RW.testing)
	end
end

R:RegisterModule(RW:GetName())