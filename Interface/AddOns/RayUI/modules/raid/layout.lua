local R, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local RA = R:GetModule("Raid")
local UF = R:GetModule("UnitFrames")

local oUF = RayUF or oUF

local backdrop, border, border2, glowBorder
RA._Objects = {}

local colors = RayUF.colors

function RA:Hex(r, g, b)
	if(type(r) == "table") then
		if(r.r) then r, g, b = r.r, r.g, r.b else r, g, b = unpack(r) end
	end
	return ("|cff%02x%02x%02x"):format(r * 255, g * 255, b * 255)
end

-- Unit Menu
local dropdown = CreateFrame("Frame", "RayUFRaidDropDown", UIParent, "UIDropDownMenuTemplate")

local function menu(self)
	dropdown:SetParent(self)
	return ToggleDropDownMenu(1, nil, dropdown, "cursor", 0, 0)
end

local init = function(self)
	if RA.db.hidemenu and InCombatLockdown() then
		return
	end

	local unit = self:GetParent().unit
	local menu, name, id

	if(not unit) then
		return
	end

	if(UnitIsUnit(unit, "player")) then
		menu = "SELF"
	elseif(UnitIsUnit(unit, "vehicle")) then
		menu = "VEHICLE"
	elseif(UnitIsUnit(unit, "pet")) then
		menu = "PET"
	elseif(UnitIsPlayer(unit)) then
		id = UnitInRaid(unit)
		if(id) then
			menu = "RAID_PLAYER"
			name = GetRaidRosterInfo(id)
		elseif(UnitInParty(unit)) then
			menu = "PARTY"
		else
			menu = "PLAYER"
		end
	else
		menu = "TARGET"
		name = RAID_TARGET_ICON
	end

	if(menu) then
		UnitPopup_ShowMenu(self, menu, unit, name, id)
	end
end

local function ColorGradient(perc, color1, color2, color3)
	local r1,g1,b1 = 1, 0, 0
	local r2,g2,b2 = .85, .8, .45
	local r3,g3,b3 = .12, .12, .12

	if perc >= 1 then
		return r3, g3, b3
	elseif perc <= 0 then
		return r1, g1, b1
	end

	local segment, relperc = math.modf(perc*(3-1))
	local offset = (segment*3)+1

	-- < 50% > 0%
	if(offset == 1) then
		return r1 + (r2-r1)*relperc, g1 + (g2-g1)*relperc, b1 + (b2-b1)*relperc
	end
	-- < 99% > 50%
	return r2 + (r3-r2)*relperc, g2 + (g3-g2)*relperc, b2 + (b3-b2)*relperc
end

-- Show Target Border
local function ChangedTarget(self)
	if UnitIsUnit("target", self.unit) then
		self.TargetBorder:Show()
	else
		self.TargetBorder:Hide()
	end
end

-- Show Focus Border
local function FocusTarget(self)
	if UnitIsUnit("focus", self.unit) then
		self.FocusHighlight:Show()
	else
		self.FocusHighlight:Hide()
	end
end

local function updateThreat(self, event, unit)
	if(unit ~= self.unit) then return end

	local status = UnitThreatSituation(unit)

	if(status and status > 1) then
		local r, g, b = GetThreatStatusColor(status)
		self.Threat:SetBackdropBorderColor(r, g, b, 1)
	else
		if R.global.general.theme == "Shadow" then
			self.Threat:SetBackdropBorderColor(0, 0, 0, 1)
		else
			self.Threat:SetBackdropBorderColor(0, 0, 0, 0)
		end
	end
	self.Threat:Show()
end

oUF.Tags.Methods["RayUFRaid:name"] = function(u, r)
local name = UnitName(u)
local _, class = UnitClass(u)
local unitReaction = UnitReaction(u, "player")
local colorString

if (UnitIsPlayer(u)) then
	local class = RayUF.colors.class[class]
	if not class then return "" end
	colorString = R:RGBToHex(class[1], class[2], class[3])
elseif (unitReaction) then
	local reaction = RayUF["colors"].reaction[unitReaction]
	colorString = R:RGBToHex(reaction[1], reaction[2], reaction[3])
else
	colorString = "|cFFC2C2C2"
end

return colorString..R:ShortenString(name, 8)
end
oUF.Tags.Events["RayUFRaid:name"] = "UNIT_NAME_UPDATE"

RA.colorCache = {}
RA.debuffColor = {} -- hex debuff colors for tags

local function PostHealth(hp, unit)
	local curhealth, maxhealth
	local self = hp.__owner
	local name = UnitName(unit)

	if self.isForced then
		maxhealth = UnitHealthMax(unit)
		curhealth = math.random(1, maxhealth)
		hp:SetValue(curhealth)
	end

	local suffix = self:GetAttribute"unitsuffix"
	if suffix == "pet" or unit == "vehicle" or unit == "pet" then
		return
	end

	if UF.db.healthColorClass then
		hp.colorClass=true
		hp.bg.multiplier = .2
	else
		if not curhealth then
			curhealth, maxhealth = UnitHealth(unit), UnitHealthMax(unit)
		end
		local r, g, b
		if UF.db.smoothColor then
			r,g,b = ColorGradient(curhealth/maxhealth)
		else
			r,g,b = .12, .12, .12, 1
		end

		if(b) then
			hp:SetStatusBarColor(r, g, b, 1)
		end
		if UF.db.smoothColor then
			if UnitIsDeadOrGhost(unit) or (not UnitIsConnected(unit)) then
				hp:SetStatusBarColor(.5, .5, .5)
				hp.bg:SetVertexColor(.5, .5, .5)
			else
				hp.bg:SetVertexColor(r*.25, g*.25, b*.25)
			end
		end
	end

	if not self:IsElementEnabled("ReadyCheck") then
		self:EnableElement("ReadyCheck")
	end
end

function RA:UpdateHealth(hp)
	hp:SetStatusBarTexture(R["media"].normal)
	hp:SetOrientation("HORIZONTAL")
	hp.bg:SetTexture(R["media"].normal)
	hp.freebSmooth = UF.db.smooth
	hp.colorReaction = nil	
	hp.colorClass = nil
	if UF.db.healthColorClass then
		hp.colorReaction = true	
		hp.colorClass = true
		hp.bg.multiplier = .2
	elseif not UF.db.smoothColor then
		hp.colorReaction = true	
		hp.colorClass = true
		hp.bg.multiplier = .8
	else
		hp:SetStatusBarColor(.12, .12, .12)
		hp.bg:SetVertexColor(.33, .33, .33)
	end

	hp:ClearAllPoints()
	hp:SetPoint"TOP"
	hp:SetPoint"LEFT"
	hp:SetPoint"RIGHT"
end

local function PostPower(power, unit)
	local self = power.__owner
	local _, ptype = UnitPowerType(unit)
	local _, class = UnitClass(unit)

	power:Height(RA.db.height*RA.db.powerbarsize)
	-- self.Health:SetHeight((1 - RA.db.powerbarsize)*self:GetHeight()-1)
	self.Health:Point("BOTTOM", self.Power, "TOP", 0, 1)

	local perc = oUF.Tags.Methods["perpp"](unit)
	-- This kinda conflicts with the threat module, but I don't really care

	if self.isForced then
		local max = UnitPowerMax(unit)
		local min = math.random(1, max)
		local type = math.random(0, 4)
		power:SetValue(min)
		perc = math.floor(min/max*100+.5)
	end

	if (perc < 10 and UnitIsConnected(unit) and ptype == "MANA" and not UnitIsDeadOrGhost(unit)) then
		self.Threat:SetBackdropBorderColor(0, 0, 1, 1)
	else
		-- pass the coloring back to the threat func
		updateThreat(self, nil, unit)
	end

	if UF.db.powerColorClass then
		power.colorClass=true
		power.bg.multiplier = .2
	else
		power.colorPower=true
		power.bg.multiplier = .2
	end
end

function RA:UpdatePower(power)
	power:Show()
	power.PostUpdate = PostPower
	power:SetStatusBarTexture(R["media"].normal)
	power:SetOrientation("HORIZONTAL")
	power.bg:SetTexture(R["media"].normal)
	power.colorClass = nil
	power.colorReaction = nil	
	power.colorPower = nil
	if UF.db.powerColorClass then
		power.colorReaction = true	
		power.colorClass = true
		power.bg.multiplier = .2
	else
		power.colorPower = true
		power.colorReaction = true
		power:SetStatusBarColor(.12, .12, .12)
		power.bg:SetVertexColor(.12, .12, .12)
	end

	power:ClearAllPoints()
	power:SetPoint"LEFT"
	power:SetPoint"RIGHT"
	power:SetPoint"BOTTOM"
end

-- Show Mouseover highlight
local function OnEnter(self)
	if RA.db.tooltip then
		UnitFrame_OnEnter(self)
	else
		GameTooltip:Hide()
	end

	if RA.db.highlight then
		self.Highlight:Show()
	end

	if RA.db.arrow and RA.db.arrowmouseover then
		RA:arrow(self, self.unit)
	end
end

local function OnLeave(self)
	if RA.db.tooltip then
		UnitFrame_OnLeave(self)
	end
	self.Highlight:Hide()

	if(self.freebarrow and self.freebarrow:IsShown()) and RA.db.arrowmouseover then
		self.freebarrow:Hide()
	end
end


local counterOffsets = {
	["TOPLEFT"] = {9, 0},
	["TOPRIGHT"] = {-7, 0},
	["BOTTOMLEFT"] = {9, 0},
	["BOTTOMRIGHT"] = {-7, 0},
	["LEFT"] = {9, 0},
	["RIGHT"] = {-7, 0},
	["TOP"] = {0, 0},
	["BOTTOM"] = {0, 0},
}

local function UpdateAuraWatch(frame)
	local buffs = {}
	local auras = frame.AuraWatch
	auras:Show()
	
	if not R.global["Raid"].AuraWatch[R.myclass] then R.global["Raid"].AuraWatch[R.myclass] = {} end
	
	if frame.unit == "pet" and R.global["Raid"].AuraWatch.PET then
		for _, value in pairs(R.global["Raid"].AuraWatch.PET) do
			tinsert(buffs, value)
		end	
	else
		for _, value in pairs(R.global["Raid"].AuraWatch[R.myclass]) do
			tinsert(buffs, value)
		end	
	end

	if auras.icons then
		for spell in pairs(auras.icons) do
			local matchFound = false
			for _, spell2 in pairs(buffs) do
				if spell2["id"] then
					if spell2["id"] == spell then
						matchFound = true
					end
				end
			end
			
			if not matchFound then
				auras.icons[spell]:Hide()
				auras.icons[spell] = nil
			end
		end
	end
	
	for _, spell in pairs(buffs) do
		local icon
		if spell["id"] then
			local name, _, image = GetSpellInfo(spell["id"])
			if name then
				if not auras.icons[spell.id] then
					icon = CreateFrame("Frame", nil, auras)
				else
					icon = auras.icons[spell.id]
				end
				icon.name = name
				icon.image = image
				icon.spellID = spell["id"]
				icon.anyUnit = spell["anyUnit"]
				icon.onlyShowMissing = spell["onlyShowMissing"]
				if spell["onlyShowMissing"] then
					icon.presentAlpha = 0
					icon.missingAlpha = 1
				else
					icon.presentAlpha = 1
					icon.missingAlpha = 0
				end		
				icon:Width(RA.db.indicatorsize)
				icon:Height(RA.db.indicatorsize)
				icon:ClearAllPoints()
				icon:SetPoint(spell["point"], 0, 0);

				if not icon.icon then
					icon.icon = icon:CreateTexture(nil, "BORDER");
					icon.icon:SetAllPoints(icon);
				end
				
				icon.icon:SetTexture(R["media"].blank);

				if (spell["color"]) then
					icon.icon:SetVertexColor(spell["color"].r, spell["color"].g, spell["color"].b);
				else
					icon.icon:SetVertexColor(0.8, 0.8, 0.8);
				end			
				
				if not icon.cd then
					icon.cd = CreateFrame("Cooldown", nil, icon, "CooldownFrameTemplate")
					icon.cd:SetAllPoints(icon)
					icon.cd:SetReverse(true)
					icon.cd:SetFrameLevel(icon:GetFrameLevel())
				end
				
				if not icon.border then
					icon.border = icon:CreateTexture(nil, "BACKGROUND")
					icon.border:SetOutside(icon, 1, 1)
					icon.border:SetTexture(R["media"].blank)
					icon.border:SetVertexColor(0, 0, 0)
				end
				
				if not icon.count then
					icon.count = icon:CreateFontString(nil, "OVERLAY")
					icon.count:Point("CENTER", unpack(counterOffsets[spell["point"]]))
				end
				icon.count:SetFont(R["media"].font, RA.db.indicatorsize + 4, "THINOUTLINE")
				--icon.count:SetFont(R["media"].pxfont, R.mult*10, "OUTLINE,MONOCHROME")
				
				if spell["enabled"] then
					auras.icons[spell.id] = icon
					if auras.watched then
						auras.watched[spell.id] = icon
					end
				else	
					auras.icons[spell.id] = nil
					if auras.watched then
						auras.watched[spell.id] = nil
					end
					icon:Hide()
					icon = nil
				end
			end
		end
	end
	
	if frame.AuraWatch.Update then
		frame.AuraWatch.Update(frame)
	end

	buffs = nil
end

local function style(self)
	self.menu = menu

	self.BG = CreateFrame("Frame", nil, self)
	self.BG:SetFrameStrata("BACKGROUND")
	self.BG:SetPoint("TOPLEFT", self, "TOPLEFT")
	self.BG:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT")
	self.BG:SetFrameLevel(3)
	self.BG:SetBackdrop(backdrop)
	self.BG:SetBackdropColor(0, 0, 0)

	-- Mouseover script
	self:SetScript("OnEnter", OnEnter)
	self:SetScript("OnLeave", OnLeave)
	self:RegisterForClicks("AnyUp")

	self.Health = CreateFrame("StatusBar", nil, self)
	self.Health:SetFrameStrata("LOW")
	self.Health.frequentUpdates = true

	self.Health.bg = self.Health:CreateTexture(nil, "BORDER")
	self.Health.bg:SetAllPoints(self.Health)

	self.Health.PostUpdate = PostHealth
	RA:UpdateHealth(self.Health)

	-- Threat
	local threat = CreateFrame("Frame", nil, self)
	threat:SetFrameStrata("BACKGROUND")
	threat:Point("TOPLEFT", self, "TOPLEFT", -5, 5)
	threat:Point("BOTTOMRIGHT", self, "BOTTOMRIGHT", 5, -5)
	threat:SetFrameLevel(0)
	threat:SetBackdrop(glowBorder)
	threat:SetBackdropColor(0, 0, 0, 0)
	if R.global.general.theme == "Shadow" then
		threat:SetBackdropBorderColor(0, 0, 0, 1)
	else
		threat:SetBackdropBorderColor(0, 0, 0, 0)
	end
	threat.Override = updateThreat
	self.Threat = threat

	-- Name
	local name = self:CreateFontString(nil, "ARTKWORK")
	name:SetPoint("CENTER", self.Health, 0, 2)
	name:SetJustifyH("CENTER")
	name:SetFont(R["media"].font, R["media"].fontsize, R["media"].fontflag)
	name:SetWidth(RA.db.width)
	name.overrideUnit = true
	self.Name = name
	self:Tag(self.Name, "[RayUFRaid:name]")

	-- Name
	local healtext = self:CreateFontString(nil, "ARTKWORK")
	healtext:SetPoint("BOTTOM", self.Health)
	healtext:SetShadowOffset(1.25, -1.25)
	healtext:SetFont(R["media"].font, R["media"].fontsize - 2, R["media"].fontflag)
	healtext:SetWidth(RA.db.width)
	healtext:SetText("123")
	self.Healtext = healtext
	self:Tag(healtext, "[RayUIRaid:def]")

	-- Power
	self.Power = CreateFrame("StatusBar", nil, self)
	self.Power:SetFrameStrata("LOW")
	self.Power.bg = self.Power:CreateTexture(nil, "BORDER")
	self.Power.bg:SetAllPoints(self.Power)
	self.Power.frequentUpdates = false
	RA:UpdatePower(self.Power)

	-- Highlight tex
	local hl = self.Health:CreateTexture(nil, "OVERLAY")
	hl:SetAllPoints(self)
	hl:SetTexture(R["media"].blank)
	hl:SetVertexColor(1,1,1,.1)
	hl:SetBlendMode("ADD")
	hl:Hide()
	self.Highlight = hl

	-- Target tex
	local tBorder = CreateFrame("Frame", nil, self)
	tBorder:SetFrameStrata("BACKGROUND")
	tBorder:SetPoint("TOPLEFT", self, "TOPLEFT")
	tBorder:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT")
	tBorder:SetBackdrop(border)
	tBorder:SetBackdropColor(.8, .8, .8, 1)
	tBorder:SetFrameLevel(2)
	tBorder:Hide()
	self.TargetBorder = tBorder

	-- Focus tex
	local fBorder = CreateFrame("Frame", nil, self)
	fBorder:SetFrameStrata("BACKGROUND")
	fBorder:SetPoint("TOPLEFT", self, "TOPLEFT")
	fBorder:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT")
	fBorder:SetBackdrop(border)
	fBorder:SetBackdropColor(.6, .8, 0, 1)
	fBorder:SetFrameLevel(2)
	fBorder:Hide()
	self.FocusHighlight = fBorder

	-- Raid Icons
	local ricon = self.Health:CreateTexture(nil, "OVERLAY")
	ricon:SetPoint("TOP", self, 0, 5)
	ricon:SetSize(RA.db.leadersize+2, RA.db.leadersize+2)
	ricon:SetTexture("Interface\\AddOns\\RayUI\\media\\raidicons.blp")
	self.RaidIcon = ricon

	-- Leader Icon
	self.Leader = self.Health:CreateTexture(nil, "OVERLAY")
	self.Leader:SetPoint("TOPLEFT", self, 0, 8)
	self.Leader:SetSize(RA.db.leadersize, RA.db.leadersize)

	-- Assistant Icon
	self.Assistant = self.Health:CreateTexture(nil, "OVERLAY")
	self.Assistant:SetPoint("TOPLEFT", self, 0, 8)
	self.Assistant:SetSize(RA.db.leadersize, RA.db.leadersize)

	local masterlooter = self.Health:CreateTexture(nil, "OVERLAY")
	masterlooter:SetSize(RA.db.leadersize, RA.db.leadersize)
	masterlooter:SetPoint("LEFT", self.Leader, "RIGHT")
	self.MasterLooter = masterlooter

	-- Role Icon
	if RA.db.roleicon then
		self.LFDRole = self.Health:CreateTexture(nil, "OVERLAY")
		self.LFDRole:SetSize(RA.db.leadersize, RA.db.leadersize)
		self.LFDRole:SetPoint("RIGHT", self, "LEFT", RA.db.leadersize/2, 0)
		self.LFDRole:SetTexture("Interface\\AddOns\\RayUI\\media\\lfd_role")
	end

	self.freebIndicators = true
	self.freebAfk = true

	self.ResurrectIcon = self.Health:CreateTexture(nil, "OVERLAY")
	self.ResurrectIcon:SetPoint("TOP", self, 0, -2)
	self.ResurrectIcon:SetSize(16, 16)

	-- Range
	local range = {
		insideAlpha = 1,
		outsideAlpha = RA.db.outsideRange,
	}

	self.freebRange = RA.db.arrow and range
	self.Range = range

	-- ReadyCheck
	self.ReadyCheck = self.Health:CreateTexture(nil, "OVERLAY")
	self.ReadyCheck:SetPoint("BOTTOM", self)
	self.ReadyCheck:SetSize(RA.db.leadersize + 4, RA.db.leadersize+ 4)

	-- Auras
	self.RaidDebuffs = CreateFrame("Frame", nil, self)
	self.RaidDebuffs:SetFrameLevel(10)
	self.RaidDebuffs:SetPoint("BOTTOM", self)
	self.RaidDebuffs:CreateShadow("Background")
	self.RaidDebuffs:Size(RA.db.aurasize, RA.db.aurasize-4)
	
	self.RaidDebuffs.icon = self.RaidDebuffs:CreateTexture(nil, "OVERLAY")
	self.RaidDebuffs.icon:SetTexCoord(.08, .92, .28, .72)
	self.RaidDebuffs.icon:SetInside(nil, 1, 1)
	
	self.RaidDebuffs.count = self.RaidDebuffs:CreateFontString(nil, "OVERLAY")
	self.RaidDebuffs.count:SetFont(R["media"].font, 12, "OUTLINE")
	self.RaidDebuffs.count:SetJustifyH("RIGHT")
	self.RaidDebuffs.count:SetPoint("BOTTOMRIGHT", 4, -2)
	
	self.RaidDebuffs.time = self.RaidDebuffs:CreateFontString(nil, "OVERLAY")
	self.RaidDebuffs.time:SetFont(R["media"].font, 12, "OUTLINE")
	self.RaidDebuffs.time:SetJustifyH("CENTER")
	self.RaidDebuffs.time:SetPoint("CENTER", 1, 0)
	self.RaidDebuffs.time:SetTextColor(1, .9, 0)

	local auraWatch = CreateFrame("Frame", nil, self)
	auraWatch:SetFrameLevel(self:GetFrameLevel() + 25)
	auraWatch:SetInside(self.Health)
	auraWatch.presentAlpha = 1
	auraWatch.missingAlpha = 0
	auraWatch.strictMatching = true
	auraWatch.icons = {}
	self.AuraWatch = auraWatch
	UpdateAuraWatch(self)

	-- Heal Prediction
	UF:EnableHealPredictionAndAbsorb(self)

	-- Add events
	self:RegisterEvent("PLAYER_FOCUS_CHANGED", FocusTarget)
	self:RegisterEvent("GROUP_ROSTER_UPDATE", FocusTarget)
	self:RegisterEvent("PLAYER_TARGET_CHANGED", ChangedTarget)
	self:RegisterEvent("GROUP_ROSTER_UPDATE", ChangedTarget)

	table.insert(RA._Objects, self)
end

function RA:Colors()
	for class, color in next, colors.class do
		RA.colorCache[class] = RA:Hex(color)
	end

	for dtype, color in next, DebuffTypeColor do
		RA.debuffColor[dtype] = RA:Hex(color)
	end
end

function RA:UpdateVisibility()
	for header, func in pairs(self.headers) do
		func(header)
	end
end

function RA:Raid15SmartVisibility(event)
	local inInstance, instanceType = IsInInstance()
	local _, _, _, _, maxPlayers, _, _, _, instanceGroupSize = GetInstanceInfo()
	if event == "PLAYER_REGEN_ENABLED" then self:UnregisterEvent("PLAYER_REGEN_ENABLED") end
	if not InCombatLockdown() then
		self:SetAttribute("showPlayer", RA.db.showplayerinparty)
		self:SetAttribute("showSolo", RA.db.showwhensolo)
		self:SetAttribute("showRaid", true)
		self:SetAttribute("showParty", true)
		if ( inInstance and instanceType == "raid" and instanceGroupSize > 15 ) or RA.db.alwaysshow40 then
			RegisterAttributeDriver(self, "state-visibility", "hide")
			self:SetAttribute("showRaid", false)
			self:SetAttribute("showParty", false)
		elseif inInstance and instanceType == "raid" and instanceGroupSize <= 15 and not RA.db.showwhensolo then
			RegisterAttributeDriver(self, "state-visibility", "[group:party,nogroup:raid][group:raid] show;hide")
			self:SetAttribute("showRaid", true)
			self:SetAttribute("showParty", true)
		else
			RegisterAttributeDriver(self, "state-visibility", "[@raid16,exists] hide;show")
			self:SetAttribute("showRaid", true)
			self:SetAttribute("showParty", true)
		end
	else
		self:RegisterEvent("PLAYER_REGEN_ENABLED")
		return
	end
end

function RA:Raid25SmartVisibility(event)
	local inInstance, instanceType = IsInInstance()
	local _, _, _, _, maxPlayers, _, _, _, instanceGroupSize = GetInstanceInfo()
	if event == "PLAYER_REGEN_ENABLED" then self:UnregisterEvent("PLAYER_REGEN_ENABLED") end
	if not InCombatLockdown() then
		self:SetAttribute("showPlayer", RA.db.showplayerinparty)
		self:SetAttribute("showSolo", RA.db.showwhensolo)
		self:SetAttribute("showRaid", true)
		self:SetAttribute("showParty", true)
		if inInstance and instanceType == "raid" and instanceGroupSize <= 15 and not RA.db.alwaysshow40 then
			RegisterAttributeDriver(self, "state-visibility", "hide")
			self:SetAttribute("showRaid", false)
			self:SetAttribute("showParty", false)
		elseif ( inInstance and instanceType == "raid" and instanceGroupSize > 15 ) or RA.db.alwaysshow40 then
			if RA.db.showwhensolo then
				RegisterAttributeDriver(self, "state-visibility", "show")
			else
				RegisterAttributeDriver(self, "state-visibility", "[group:party,nogroup:raid][group:raid] show;hide")
			end
			self:SetAttribute("showRaid", true)
			self:SetAttribute("showParty", true)
		else
			RegisterAttributeDriver(self, "state-visibility", "[@raid16,noexists] hide;show")
			self:SetAttribute("showRaid", true)
			self:SetAttribute("showParty", true)
		end
	else
		self:RegisterEvent("PLAYER_REGEN_ENABLED")
		return
	end
end

function RA:Raid40SmartVisibility(event)
	local inInstance, instanceType = IsInInstance()
	local _, _, _, _, maxPlayers = GetInstanceInfo()
	if event == "PLAYER_REGEN_ENABLED" then self:UnregisterEvent("PLAYER_REGEN_ENABLED") end
	if not InCombatLockdown() then
		self:SetAttribute("showPlayer", RA.db.showplayerinparty)
		self:SetAttribute("showSolo", RA.db.showwhensolo)
		self:SetAttribute("showRaid", true)
		self:SetAttribute("showParty", true)
		if ( inInstance and (instanceType == "pvp" and maxPlayers == 40) or (instanceType == "raid" and maxPlayers == 30)) or RA.db.alwaysshow40 then
			RegisterAttributeDriver(self, "state-visibility", "[group:party,nogroup:raid][group:raid] show;hide")
		elseif inInstance then
			RegisterAttributeDriver(self, "state-visibility", "hide")
		else
			RegisterAttributeDriver(self, "state-visibility", "[@raid26,exists] show;hide")
		end
	else
		self:RegisterEvent("PLAYER_REGEN_ENABLED")
		return
	end
end

local pos, posRel, colX, colY
function RA:SpawnHeader(name, group, layout)
	local horiz, grow = RA.db.horizontal, RA.db.growth
	local width, height = RA.db.width, RA.db.height
	local visibility = "custom [@raid16,noexists] hide;show"

	if layout == 15 then
		width, height = RA.db.bigwidth, RA.db.bigheight
		visibility = "custom [@raid16,exists] hide;show"
	end

	local point, growth, xoff, yoff
	if horiz then
		point = "LEFT"
		xoff = RA.db.spacing
		yoff = 0
		if grow == "UP" then
			growth = "BOTTOM"
			pos = "BOTTOMLEFT"
			posRel = "TOPLEFT"
			colY = RA.db.spacing
		else
			growth = "TOP"
			pos = "TOPLEFT"
			posRel = "BOTTOMLEFT"
			colY = -RA.db.spacing
		end
	else
		point = "TOP"
		xoff = 0
		yoff = -RA.db.spacing
		if grow == "RIGHT" then
			growth = "LEFT"
			pos = "TOPLEFT"
			posRel = "TOPRIGHT"
			colX = RA.db.spacing
		else
			growth = "RIGHT"
			pos = "TOPRIGHT"
			posRel = "TOPLEFT"
			colX = -RA.db.spacing
		end
	end

	local header = oUF:SpawnHeader(name, nil, "raid",
	"oUF-initialConfigFunction", ([[self:SetWidth(%d); self:SetHeight(%d);]]):format(R:Scale(width), R:Scale(height)), 
	"xOffset", xoff,
	"yOffset", yoff,
	"point", point,
	"sortMethod", "INDEX",
	"groupFilter", group,
	"groupingOrder", "1,2,3,4,5,6,7,8",
	"groupBy", "GROUP",
	"maxColumns", 1,
	"unitsPerColumn", 5,
	"columnSpacing", RA.db.spacing,
	"columnAnchorPoint", growth)

	RegisterAttributeDriver(header, "state-visibility", "show")
	if RA.db.horizontal then
		header:SetAttribute("minHeight", R:Scale(height))
		header:SetAttribute("minWidth", R:Scale(width)*5 + R:Scale(RA.db.spacing)*4)
	else
		header:SetAttribute("minHeight", R:Scale(height)*5 + R:Scale(RA.db.spacing)*4)
		header:SetAttribute("minWidth", R:Scale(width))
	end
	RegisterAttributeDriver(header, "state-visibility", "hide")	

	header:RegisterEvent("PLAYER_ENTERING_WORLD")
	header:RegisterEvent("ZONE_CHANGED_NEW_AREA")
	header:RegisterEvent("INSTANCE_GROUP_SIZE_CHANGED")

	header:HookScript("OnEvent", RA["Raid"..layout.."SmartVisibility"])
	self.headers[header] = RA["Raid"..layout.."SmartVisibility"]

	return header
end

function RA:SpawnRaid()
	self.headers = {}
	UIDropDownMenu_Initialize(dropdown, init, "MENU")
	backdrop = {
		bgFile = R["media"].blank,
		insets = {top = -R.mult, left = -R.mult, bottom = -R.mult, right = -R.mult},
	}
	border = {
		bgFile = R["media"].blank,
		insets = {top = -R:Scale(2), left = -R:Scale(2), bottom = -R:Scale(2), right = -R:Scale(2)},
	}
	glowBorder = {
		bgFile = R["media"].blank,
		edgeFile = R["media"].glow, edgeSize = R:Scale(5),
		insets = {left = R:Scale(3), right = R:Scale(3), top = R:Scale(3), bottom = R:Scale(3)}
	}
	oUF:RegisterStyle("RayUFRaid", style)
	oUF:SetActiveStyle("RayUFRaid")
	RA:Colors()
	local raid15 = {}
	for i=1, 3 do
		local group = self:SpawnHeader("RayUFRaid15_"..i, i, 15)
		if i == 1 then
			group:Point("TOPLEFT", UIParent, "BOTTOMRIGHT", - RA.db.width*1.3*3 -  RA.db.spacing*2 - 50, 461)
		else
			group:Point(pos, raid15[i-1], posRel, colX or 0, colY or 0)
		end
		raid15[i] = group
		group:Show()
		R:CreateMover(group, group:GetName().."Mover", "Raid1-15 Group"..i, nil, nil, "ALL,RAID15", true)
		RA.Raid15SmartVisibility(group)
	end
	local raid25 = {}
	for i=1, 5 do
		local group = self:SpawnHeader("RayUFRaid25_"..i, i, 25)
		if i == 1 then
			group:Point("TOPLEFT", UIParent, "BOTTOMRIGHT", - RA.db.width*5 -  RA.db.spacing*4 - 50, 422)
		else
			group:Point(pos, raid25[i-1], posRel, colX or 0, colY or 0)
		end
		raid25[i] = group
		group:Show()
		R:CreateMover(group, group:GetName().."Mover", "Raid1-25 Group"..i, nil, nil, "ALL,RAID25,RAID40", true)
		RA.Raid25SmartVisibility(group)
	end
	if RA.db.raid40 then
		local raid40 = {}
		for i=6, 8 do
			local group = self:SpawnHeader("RayUFRaid40_"..i, i, 40)
			if i == 6 then
				group:Point("TOPLEFT", raid25[3], "TOPLEFT", 0, RA.db.height * 5 + RA.db.spacing*5 )
			else
				group:Point(pos, raid40[i-1], posRel, colX or 0, colY or 0)
			end
			raid40[i] = group
			group:Show()
			R:CreateMover(group, group:GetName().."Mover", "Raid1-40 Group"..i, nil, nil, "ALL,RAID40", true)
			RA.Raid40SmartVisibility(group)
		end
	end
end
