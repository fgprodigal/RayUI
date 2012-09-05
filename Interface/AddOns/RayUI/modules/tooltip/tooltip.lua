local R, L, P = unpack(select(2, ...)) --Inport: Engine, Locales, ProfileDB
local TT = R:NewModule("Tooltip", "AceEvent-3.0", "AceHook-3.0")
local TalentFrame = CreateFrame("Frame", nil)
TalentFrame:Hide()

TT.modName = L["鼠标提示"]

local TALENTS_PREFIX = TALENTS..":|cffffffff "
local NO_TALENTS = NONE..TALENTS
local CACHE_SIZE = 25
local INSPECT_DELAY = 0.2
local INSPECT_FREQ = 2

local cache = {}
local ilvcache = {}
local current = {}
local ilvcurrent = {}

local lastInspectRequest = 0

local function IsInspectFrameOpen()
	return (InspectFrame and InspectFrame:IsShown()) or (Examiner and Examiner:IsShown())
end

function TT:GetOptions()
	local options = {
		cursor = {
			order = 5,
			name = L["跟随鼠标"],
			type = "toggle",
		},
	}
	return options
end

local function GatherTalents(isInspect)
	local spec = isInspect and GetInspectSpecialization(current.unit) or GetSpecialization()
	if (spec) and (spec > 0) then
		if isInspect then
			local _, specName = GetSpecializationInfoByID(spec)
			current.format = specName or "n/a"
		else
			local _, specName = GetSpecializationInfo(spec)
			current.format = specName or "n/a"
		end
	else
		current.format = NO_TALENTS
	end

	if (not isInspect) then
		GameTooltip:AddLine(TALENTS_PREFIX..current.format)
	elseif (GameTooltip:GetUnit()) then
		for i = 2, GameTooltip:NumLines() do
			if ((_G["GameTooltipTextLeft"..i]:GetText() or ""):match("^"..TALENTS_PREFIX)) then
				_G["GameTooltipTextLeft"..i]:SetFormattedText("%s%s",TALENTS_PREFIX,current.format)

				if (not GameTooltip.fadeOut) then
					GameTooltip:Show()
				end
				break
			end
		end
	end

	for i = #cache, 1, -1 do
		if (current.name == cache[i].name) then
			tremove(cache,i)
			break
		end
	end
	if (#cache > CACHE_SIZE) then
		tremove(cache,1)
	end

	if (CACHE_SIZE > 0) then
		cache[#cache + 1] = CopyTable(current)
	end
end

function TT:TalentSetUnit()
	TalentFrame:Hide()
	local _, unit = GameTooltip:GetUnit()
	if (not unit) then
		local mFocus = GetMouseFocus()
		if (mFocus) and (mFocus.unit) then
			unit = mFocus.unit
		end
	end
	if (not unit) or (not UnitIsPlayer(unit)) then
		return
	end
	local level = UnitLevel(unit)
	if (level > 9 or level == -1) then
		wipe(current)
		current.unit = unit
		current.name = UnitName(unit)
		current.guid = UnitGUID(unit)
		if (UnitIsUnit(unit,"player")) then
			GatherTalents()
			return
		end

		local cacheLoaded = false
		for _, entry in ipairs(cache) do
			if (current.name == entry.name) then
				GameTooltip:AddLine(TALENTS_PREFIX..entry.format)
				current.format = entry.format
				cacheLoaded = true
				break
			end
		end

		if (CanInspect(unit)) and (not IsInspectFrameOpen()) then
			local lastInspectTime = (GetTime() - lastInspectRequest)
			TalentFrame.nextUpdate = (lastInspectTime > INSPECT_FREQ) and INSPECT_DELAY or (INSPECT_FREQ - lastInspectTime + INSPECT_DELAY)
			TalentFrame:Show()
			if (not cacheLoaded) then
				GameTooltip:AddLine(TALENTS_PREFIX.."Loading...")
			end
		end
	end
end

TalentFrame:SetScript("OnUpdate", function(self, elapsed)
	self.nextUpdate = (self.nextUpdate or 0 ) - elapsed
	if (self.nextUpdate <= 0) then
		self:Hide()
		if (UnitGUID("mouseover") == current.guid) then
			lastInspectRequest = GetTime()
			TT:RegisterEvent("INSPECT_READY")
			if (InspectFrame) then
				InspectFrame.unit = "player"
			end
			NotifyInspect(current.unit)
		end
	end
end)

function TT:GameTooltip_SetDefaultAnchor(tooltip, parent)
	if self.db.cursor then
		tooltip:SetOwner(parent, "ANCHOR_CURSOR")
	else
		tooltip:ClearAllPoints()
		local mousefocus = GetMouseFocus():GetName()
		if mousefocus and mousefocus:match("RayUFRaid") then
			local parent = _G[mousefocus:match("RayUFRaid%d%d_%d")]
			tooltip:Point("BOTTOMRIGHT", parent, "TOPRIGHT", 0, 23)
		elseif RayUFRaid40_6UnitButton1 and RayUFRaid40_6UnitButton1:IsShown() and (GetScreenWidth() - RayUFRaid40_8:GetRight()) < 250 then
			tooltip:Point("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -50, RayUFRaid40_8:GetBottom() + RayUFRaid40_8:GetHeight() + 30)
		elseif BagsFrame and BagsFrame:IsShown() and (GetScreenWidth() - BagsFrame:GetRight()) < 250 then
			tooltip:Point("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -50, BagsFrame:GetBottom() + BagsFrame:GetHeight() + 30)
		elseif RayUFRaid10_1UnitButton1 and RayUFRaid10_1UnitButton1:IsShown() and (GetScreenWidth() - RayUFRaid10_3:GetRight()) < 250 then
			tooltip:Point("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -50, RayUFRaid10_3:GetBottom() + RayUFRaid10_3:GetHeight() + 30)
		elseif RayUFRaid25_1UnitButton1 and RayUFRaid25_1UnitButton1:IsShown() and (GetScreenWidth() - RayUFRaid25_5:GetRight()) < 250 then
			tooltip:Point("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -50, RayUFRaid25_5:GetBottom() + RayUFRaid25_5:GetHeight() + 30)
		elseif NumerationFrame and NumerationFrame:IsShown() and (GetScreenWidth() - NumerationFrame:GetRight()) < 250 then
			tooltip:Point("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -50, NumerationFrame:GetBottom() + NumerationFrame:GetHeight() + 30)
		else
			tooltip:Point("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -50, 160)
		end
	end
	tooltip.default = 1
end

function TT:GameTooltip_UnitColor(unit)
	local r, g, b = 1, 1, 1
	if UnitPlayerControlled(unit) then
		if UnitCanAttack(unit, "player") then
			if UnitCanAttack("player", unit) then
				r = FACTION_BAR_COLORS[2].r
				g = FACTION_BAR_COLORS[2].g
				b = FACTION_BAR_COLORS[2].b
			end
		elseif UnitCanAttack("player", unit) then
			r = FACTION_BAR_COLORS[4].r
			g = FACTION_BAR_COLORS[4].g
			b = FACTION_BAR_COLORS[4].b
		elseif UnitIsPVP(unit) then
			r = FACTION_BAR_COLORS[6].r
			g = FACTION_BAR_COLORS[6].g
			b = FACTION_BAR_COLORS[6].b
		end
	else
		local reaction = UnitReaction(unit, "player")
		if reaction then
			r = FACTION_BAR_COLORS[reaction].r
			g = FACTION_BAR_COLORS[reaction].g
			b = FACTION_BAR_COLORS[reaction].b
		end
	end
	if UnitIsPlayer(unit) then
		local class = select(2, UnitClass(unit))
		if class then
			r = RAID_CLASS_COLORS[class].r
			g = RAID_CLASS_COLORS[class].g
			b = RAID_CLASS_COLORS[class].b
		end
	end
	return r, g, b
end

function TT:GameTooltip_OnUpdate(tooltip)
	if (tooltip.needRefresh and tooltip:GetAnchorType() == "ANCHOR_CURSOR" and not self.db.cursor) then
		tooltip:SetBackdropColor(0, 0, 0, 0.65)
		tooltip:SetBackdropBorderColor(0, 0, 0)
		tooltip.needRefresh = nil
	end
end

local function GetPlayerScore(unit)
	local unitilvl = 0
	local ilvl, ilvlAdd, equipped = 0, 0, 0
	if (UnitIsPlayer(unit)) then
		for i = 1, 18 do
			if (i ~= 4) then
				local iLink = GetInventoryItemLink(unit, i)
				if (iLink) then
					ilvlAdd = TT:GetItemScore(iLink)
					ilvl = ilvl + ilvlAdd
					equipped = equipped + 1
				end
			end
		end
	end
	-- ClearInspectPlayer()
	return floor(ilvl / equipped)
end

function TT:SetiLV()
	local _, unit = GameTooltip:GetUnit()
	if not (unit) or not (UnitIsPlayer(unit)) or not (CanInspect(unit)) then
		return
	end

	local unitilvl = GetPlayerScore(unit)
	if (unitilvl > 1) then
		local Red, Blue, Green = TT:GetQuality(unitilvl)
		ilvcurrent.format = R:RGBToHex(Red, Green, Blue)..unitilvl
		for i = 2, GameTooltip:NumLines() do
			if ((_G["GameTooltipTextLeft"..i]:GetText() or ""):match("^"..STAT_AVERAGE_ITEM_LEVEL)) then
				_G["GameTooltipTextLeft"..i]:SetText(STAT_AVERAGE_ITEM_LEVEL..": "..R:RGBToHex(Red, Green, Blue)..unitilvl)

				break
			end
		end
	end
	
	for i = #ilvcache, 1, -1 do
		if (ilvcurrent.name == ilvcache[i].name) then
			tremove(ilvcache,i)
			break
		end
	end
	if (#ilvcache > CACHE_SIZE) then
		tremove(ilvcache,1)
	end

	if (CACHE_SIZE > 0) then
		ilvcache[#ilvcache + 1] = CopyTable(ilvcurrent)
	end
end

function TT:GetQuality(ItemScore)
	return R:ColorGradient(ItemScore/450, 0.5, 0.5, 0.5, 1, 0.1, 0.1)
end

function TT:iLVSetUnit()
	local _, unit = GameTooltip:GetUnit()
	local cacheLoaded = false
	if not (unit) or not (UnitIsPlayer(unit)) or not (CanInspect(unit)) then
		return
	end

	wipe(ilvcurrent)
	ilvcurrent.unit = unit
	ilvcurrent.name = UnitName(unit)
	ilvcurrent.guid = UnitGUID(unit)

	for _, entry in ipairs(ilvcache) do
		if (ilvcurrent.name == entry.name and entry.format) then
			GameTooltip:AddLine(STAT_AVERAGE_ITEM_LEVEL..": "..entry.format)
			ilvcurrent.format = entry.format
			cacheLoaded = true
			break
		end
	end
	if UnitIsUnit(unit, "player") then
		local unitilvl = GetPlayerScore("player")
		local Red, Blue, Green = TT:GetQuality(unitilvl)
		GameTooltip:AddLine(STAT_AVERAGE_ITEM_LEVEL..": "..R:RGBToHex(Red, Green, Blue)..unitilvl)
	elseif not cacheLoaded then
		GameTooltip:AddLine(STAT_AVERAGE_ITEM_LEVEL..": |cffffffffLoading...|r")
	end
end

function TT:INSPECT_READY(event, guid)
	self:UnregisterEvent(event)
	if (guid == current.guid) then
		GatherTalents(1)
		self:SetiLV()
	end
end

function TT:INSPECT_ACHIEVEMENT_READY()
    self:UnregisterEvent("INSPECT_ACHIEVEMENT_READY")
    if not self.line then return end
	self.line:SetFont(GameTooltipTextLeft3:GetFont())
    self.line:SetText()

    if GameTooltip:GetUnit() == self.unit then
        local stats, text = {}, ""

        stats.TotalAchievemen = tonumber(GetComparisonAchievementPoints()) or 0
            text = text .. ACHIEVEMENT_POINTS..": |cFFFFFFFF" .. stats.TotalAchievemen

        if text ~= "" then
			self.line:SetFont(GameTooltipTextLeft3:GetFont())
            self.line:SetText(text)
        end
    end

    GameTooltip:Show()

    if not UnitName("mouseover") then
        GameTooltip:FadeOut()
    end

    ClearAchievementComparisonUnit()

    if _G.GearScore then
        _G.GearScore:RegisterEvent("INSPECT_ACHIEVEMENT_READY")
    end

    if Elite then
        Elite:RegisterEvent("INSPECT_ACHIEVEMENT_READY")
    end

    if AchievementFrameComparison then
        AchievementFrameComparison:RegisterEvent("INSPECT_ACHIEVEMENT_READY")
    end

    self:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
end

function TT:MODIFIER_STATE_CHANGED()
    if arg1 == "LCTRL" or arg1 == "RCTRL" then
        if self.line and UnitName("mouseover") == self.unit then
            self:UPDATE_MOUSEOVER_UNIT(true)
        end
    end
end

function TT:PLAYER_ENTERING_WORLD(event)
	local tooltips = {
		GameTooltip,
		FriendsTooltip,
		ItemRefTooltip,
		ItemRefShoppingTooltip1,
		ItemRefShoppingTooltip2,
		ItemRefShoppingTooltip3,
		ShoppingTooltip1,
		ShoppingTooltip2,
		ShoppingTooltip3,
		WorldMapTooltip,
		WorldMapCompareTooltip1,
		WorldMapCompareTooltip2,
		WorldMapCompareTooltip3,
		DropDownList1MenuBackdrop,
		DropDownList2MenuBackdrop,
	}

	for _, tt in pairs(tooltips) do
		tt:SetBackdrop({
			bgFile = [=[Interface\ChatFrame\ChatFrameBackground]=],
			edgeFile = [=[Interface\ChatFrame\ChatFrameBackground]=], edgeSize = R.mult,
			insets = {top = 0, left = 0, bottom = 0, right = 0},
		})
		self:HookScript(tt, "OnShow", "SetStyle")
	end

	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
end

function TT:UPDATE_MOUSEOVER_UNIT(event, refresh)
    if not refresh then
        self.unit, self.line = nil, nil
    end

    if (UnitAffectingCombat("player")) or UnitIsDead("player") or not UnitExists("mouseover")
    or not UnitIsPlayer("mouseover") or not UnitIsConnected("mouseover") or UnitIsDead("mouseover") then
        return
    end

    self.unit = UnitName("mouseover")

    local text = ACHIEVEMENT_POINTS..": |cFFFFFFFFLoading..."

    if refresh then
		self.line:SetFont(GameTooltipTextLeft3:GetFont())
        self.line:SetText(text)
    else
        GameTooltip:AddLine(text)
        self.line = _G["GameTooltipTextLeft" .. GameTooltip:NumLines()]
    end

    GameTooltip:Show()

    if _G.GearScore then
        _G.GearScore:UnregisterEvent("INSPECT_ACHIEVEMENT_READY")
    end

    if Elite then
        Elite:UnregisterEvent("INSPECT_ACHIEVEMENT_READY")
    end

    if AchievementFrameComparison then
        AchievementFrameComparison:UnregisterEvent("INSPECT_ACHIEVEMENT_READY")
    end

    self:UnregisterEvent("UPDATE_MOUSEOVER_UNIT")
    self:RegisterEvent("INSPECT_ACHIEVEMENT_READY")

    SetAchievementComparisonUnit("mouseover")
end

function TT:GetItemScore(iLink)
   local _, _, itemRarity, itemLevel, _, _, _, _, itemEquip = GetItemInfo(iLink)
   if (IsEquippableItem(iLink)) then
      if not   (itemLevel > 1) and (itemRarity > 1) then
      return 0
      end
   end
   return itemLevel
end

function TT:SetStyle(tooltip)
	tooltip:SetBackdropColor(0, 0, 0, 0.65)
	local item
	if tooltip.GetItem then
		item = select(2, tooltip:GetItem())
	end
	if item then
		local quality = select(3, GetItemInfo(item))
		if quality and quality > 1 then
			local r, g, b = GetItemQualityColor(quality)
			tooltip:SetBackdropBorderColor(r, g, b)
		else
			tooltip:SetBackdropBorderColor(0, 0, 0)
		end
	else
		tooltip:SetBackdropBorderColor(0, 0, 0)
	end
	if tooltip.NumLines then
		for index=1, tooltip:NumLines() do
			_G[tooltip:GetName().."TextLeft"..index]:SetShadowOffset(R.mult, -R.mult)
		end
	end
	tooltip.needRefresh = true
end

function TT:Initialize()
	local gcol = {.35, 1, .6}										-- Guild Color
	local pgcol = {1, .12, .8} 									-- Player's Guild Color

	local backdrop = {
		bgFile = [=[Interface\ChatFrame\ChatFrameBackground]=],
		edgeFile = [=[Interface\ChatFrame\ChatFrameBackground]=], edgeSize = R.mult,
		insets = {top = 0, left = 0, bottom = 0, right = 0},
	}

	local types = {
		rare = " R ",
		elite = " + ",
		worldboss = " B ",
		rareelite = " R+ ",
	}

	local hex = function(r, g, b)
		return ("|cff%02x%02x%02x"):format(r * 255, g * 255, b * 255)
	end

	local truncate = function(value)
		if value >= 1e6 then
			return string.format("%.2fm", value / 1e6)
		elseif value >= 1e4 then
			return string.format("%.1fk", value / 1e3)
		else
			return string.format("%.0f", value)
		end
	end

	self:RawHook("GameTooltip_UnitColor", true)

	GameTooltip:HookScript("OnTooltipSetUnit", function(self)
		local unit = select(2, self:GetUnit())
		if unit then
			local unitClassification = types[UnitClassification(unit)] or " "
			local creatureType = UnitCreatureType(unit) or ""
			local unitName = UnitName(unit)
			local unitLevel = UnitLevel(unit)
			local diffColor = unitLevel > 0 and GetQuestDifficultyColor(UnitLevel(unit)) or QuestDifficultyColors["impossible"]
			if unitLevel < 0 then unitLevel = "??" end
			if UnitIsPlayer(unit) then
				local unitRace = UnitRace(unit)
				local unitClass = UnitClass(unit)
				local guild, rank = GetGuildInfo(unit)
				local playerGuild = GetGuildInfo("player")
				GameTooltipStatusBar:SetStatusBarColor(unpack({GameTooltip_UnitColor(unit)}))
				if guild then
					GameTooltipTextLeft2:SetFormattedText("<%s>"..hex(1, 1, 1).." %s|r", guild, rank)
					if IsInGuild() and guild == playerGuild then
						GameTooltipTextLeft2:SetTextColor(pgcol[1], pgcol[2], pgcol[3])
					else
						GameTooltipTextLeft2:SetTextColor(gcol[1], gcol[2], gcol[3])
					end
				end
				for i=2, GameTooltip:NumLines() do
					if _G["GameTooltipTextLeft" .. i]:GetText():find(PLAYER) then
						_G["GameTooltipTextLeft" .. i]:SetText(string.format(hex(diffColor.r, diffColor.g, diffColor.b).."%s|r ", unitLevel) .. unitRace .. " ".. unitClass)
						break
					end
				end
			else
				for i=2, GameTooltip:NumLines() do
					if _G["GameTooltipTextLeft" .. i]:GetText():find(LEVEL) or _G["GameTooltipTextLeft" .. i]:GetText():find(creatureType) then
						_G["GameTooltipTextLeft" .. i]:SetText(string.format(hex(diffColor.r, diffColor.g, diffColor.b).."%s|r", unitLevel) .. unitClassification .. creatureType)
						break
					end
				end
			end
			if UnitIsPVP(unit) then
				for i = 2, GameTooltip:NumLines() do
					if _G["GameTooltipTextLeft"..i]:GetText():find(PVP) then
						_G["GameTooltipTextLeft"..i]:SetText(nil)
						break
					end
				end
			end
			if UnitExists(unit.."target") then
				local r, g, b = GameTooltip_UnitColor(unit.."target")
				if UnitName(unit.."target") == UnitName("player") then
					text = hex(1, 0, 0)..">>你<<|r"
				else
					text = hex(r, g, b)..UnitName(unit.."target").."|r"
				end
				self:AddLine(TARGET..": "..text)
			end
		end

		TT:iLVSetUnit()
		TT:TalentSetUnit()
	end)

	GameTooltipStatusBar.bg = CreateFrame("Frame", nil, GameTooltipStatusBar)
	GameTooltipStatusBar.bg:Point("TOPLEFT", GameTooltipStatusBar, "TOPLEFT", -1, 1)
	GameTooltipStatusBar.bg:Point("BOTTOMRIGHT", GameTooltipStatusBar, "BOTTOMRIGHT", 1, -1)
	GameTooltipStatusBar.bg:SetFrameStrata(GameTooltipStatusBar:GetFrameStrata())
	GameTooltipStatusBar.bg:SetFrameLevel(GameTooltipStatusBar:GetFrameLevel() - 1)
	GameTooltipStatusBar.bg:SetBackdrop(backdrop)
	GameTooltipStatusBar.bg:SetBackdropColor(0, 0, 0, 0.5)
	GameTooltipStatusBar.bg:SetBackdropBorderColor(0, 0, 0, 1)
	GameTooltipStatusBar:SetHeight(8)
	GameTooltipStatusBar:SetStatusBarTexture(R["media"].normal)
	GameTooltipStatusBar:ClearAllPoints()
	GameTooltipStatusBar:SetPoint("TOPLEFT", GameTooltip, "BOTTOMLEFT", 1, -2)
	GameTooltipStatusBar:SetPoint("TOPRIGHT", GameTooltip, "BOTTOMRIGHT", -1, -2)
	GameTooltipStatusBar:HookScript("OnValueChanged", function(self, value)
		if not value then
			return
		end
		local min, max = self:GetMinMaxValues()
		if value < min or value > max then
			return
		end
		local unit  = select(2, GameTooltip:GetUnit())
		if unit then
			if UnitIsPlayer(unit) then
				GameTooltipStatusBar:SetStatusBarColor(unpack({GameTooltip_UnitColor(unit)}))
			end
			min, max = UnitHealth(unit), UnitHealthMax(unit)
			if not self.text then
				self.text = self:CreateFontString(nil, "OVERLAY")
				self.text:SetPoint("CENTER", GameTooltipStatusBar, 0, -4)
				self.text:SetFont(R["media"].font, 12, "THINOUTLINE")
				-- self.text:SetShadowOffset(R.mult, -R.mult)
			end
			self.text:Show()
			local hp = truncate(min).." / "..truncate(max)
			self.text:SetText(hp)
		else
			if self.text then
				self.text:Hide()
			end
		end
	end)

	self:SecureHook("GameTooltip_SetDefaultAnchor")
	self:HookScript(GameTooltip, "OnUpdate", "GameTooltip_OnUpdate")

	GameTooltip:HookScript("OnUpdate", function(self, elapsed)
		if self:GetAnchorType() == "ANCHOR_CURSOR" then
			local x, y = GetCursorPosition()
			local effScale = self:GetEffectiveScale()
			local width = self:GetWidth() or 0
			self:ClearAllPoints()
			self:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", x / effScale - width / 2, y / effScale + 15)
		end
	end)

	self:RegisterEvent("MODIFIER_STATE_CHANGED")
	self:RegisterEvent("INSPECT_ACHIEVEMENT_READY")
	self:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
	self:RegisterEvent("PLAYER_ENTERING_WORLD")

	SetCVar("alwaysCompareItems", 1)
end

function TT:Info()
	return L["|cff7aa6d6Ray|r|cffff0000U|r|cff7aa6d6I|r鼠标提示模块."]
end

R:RegisterModule(TT:GetName())
