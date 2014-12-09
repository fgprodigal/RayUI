local R, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local TT = R:NewModule("Tooltip", "AceEvent-3.0", "AceHook-3.0")
local TalentFrame = CreateFrame("Frame", nil)
TalentFrame:Hide()

TT.modName = L["鼠标提示"]

local TALENTS_PREFIX = TALENTS
local NO_TALENTS = NONE..TALENTS
local CACHE_SIZE = 25
local INSPECT_DELAY = 0.2
local INSPECT_FREQ = 2

local talentcache = {}
local ilvcache = {}
local talentcurrent = {}
local ilvcurrent = {}

local lastInspectRequest = 0

local gcol = {.35, 1, .6}										-- Guild Color
local pgcol = {1, .12, .8} 									-- Player's Guild Color

local types = {
	rare = " R ",
	elite = " + ",
	worldboss = " B ",
	rareelite = " R+ ",
}

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
		hideincombat = {
			order = 6,
			name = L["战斗中隐藏"],
			type = "toggle",
		},
	}
	return options
end

local function GatherTalents(isInspect)
	local spec = isInspect and GetInspectSpecialization(talentcurrent.unit) or GetSpecialization()
	if (spec) and (spec > 0) then
		if isInspect then
			local _, specName, _, icon = GetSpecializationInfoByID(spec)
			icon = icon and "|T"..icon..":12:12:0:0:64:64:5:59:5:59|t " or ""
			talentcurrent.format = specName and icon..specName or "n/a"
		else
			local _, specName, _, icon = GetSpecializationInfo(spec)
			icon = icon and "|T"..icon..":12:12:0:0:64:64:5:59:5:59|t " or ""
			talentcurrent.format = specName and icon..specName or "n/a"
		end
	else
		talentcurrent.format = NO_TALENTS
	end

	if (not isInspect) then
		GameTooltip:AddDoubleLine(TALENTS_PREFIX, talentcurrent.format, nil, nil, nil, 1, 1, 1)
	elseif (GameTooltip:GetUnit()) then
		for i = 2, GameTooltip:NumLines() do
			if ((_G["GameTooltipTextLeft"..i]:GetText() or ""):match("^"..TALENTS_PREFIX)) then
				_G["GameTooltipTextRight"..i]:SetText(talentcurrent.format)
				if (not GameTooltip.fadeOut) then
					GameTooltip:Show()
				end
				break
			end
		end
	end

	for i = #talentcache, 1, -1 do
		if (talentcurrent.name == talentcache[i].name) then
			tremove(talentcache,i)
			break
		end
	end
	if (#talentcache > CACHE_SIZE) then
		tremove(talentcache,1)
	end

	if (CACHE_SIZE > 0) then
		talentcache[#talentcache + 1] = CopyTable(talentcurrent)
	end
end

function TT:TalentSetUnit()
	TalentFrame:Hide()
	local GMF = GetMouseFocus()
	local unit = (select(2, GameTooltip:GetUnit())) or (GMF and GMF:GetAttribute("unit"))

	if (not unit) and (UnitExists("mouseover")) then
		unit = "mouseover"
	end
	if (not unit) or (not UnitIsPlayer(unit)) then
		return
	end
	local level = UnitLevel(unit)
	if (level > 9 or level == -1) then
		wipe(talentcurrent)
		talentcurrent.unit = unit
		talentcurrent.name = UnitName(unit)
		talentcurrent.guid = UnitGUID(unit)
		if (UnitIsUnit(unit,"player")) then
			GatherTalents()
			return
		end

		local cacheLoaded = false
		for _, entry in ipairs(talentcache) do
			if (talentcurrent.name == entry.name) then
				GameTooltip:AddDoubleLine(TALENTS_PREFIX, entry.format, nil, nil, nil, 1, 1, 1)
				talentcurrent.format = entry.format
				cacheLoaded = true
				break
			end
		end

		if (CanInspect(unit)) and (not IsInspectFrameOpen()) then
			local lastInspectTime = (GetTime() - lastInspectRequest)
			TalentFrame.nextUpdate = (lastInspectTime > INSPECT_FREQ) and INSPECT_DELAY or (INSPECT_FREQ - lastInspectTime + INSPECT_DELAY)
			TalentFrame:Show()
			if (not cacheLoaded) then
				GameTooltip:AddDoubleLine(TALENTS_PREFIX, "...", nil, nil, nil, 1, 1, 1)
			end
		end
	end
end

TalentFrame:SetScript("OnUpdate", function(self, elapsed)
	self.nextUpdate = (self.nextUpdate or 0 ) - elapsed
	if (self.nextUpdate <= 0) then
		self:Hide()
		if (UnitGUID("mouseover") == talentcurrent.guid) then
			lastInspectRequest = GetTime()
			TT:RegisterEvent("INSPECT_READY")
			if (InspectFrame) then
				InspectFrame.unit = "player"
			end
			NotifyInspect(talentcurrent.unit)
		end
	end
end)

function TT:GameTooltip_SetDefaultAnchor(tooltip, parent)
	if self.db.cursor then
		if parent then
			tooltip:SetOwner(parent, "ANCHOR_CURSOR")
		end
	else
		if parent then
			tooltip:SetOwner(parent, "ANCHOR_NONE")
		end

		local owner
		if tooltip:GetOwner() then
			owner = tooltip:GetOwner():GetName()
		end
		if owner and owner:find("RayUITopInfoBar") then
			return
		end

		tooltip:ClearAllPoints()
		if owner and owner:match("RayUFRaid") then
			local parent = _G[owner:match("RayUFRaid%d%d_%d")]
			if R.db.Raid.horizontal then
				tooltip:Point("TOPRIGHT", parent, "TOPLEFT", -23, 0)
			else
				tooltip:Point("BOTTOMRIGHT", parent, "TOPRIGHT", 0, 23)
			end
		elseif RayUFRaid40_6UnitButton1 and RayUFRaid40_6UnitButton1:IsVisible() and (GetScreenWidth() - RayUFRaid40_8:GetRight()) < 250 then
			tooltip:Point("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -50, RayUFRaid40_8:GetBottom() + RayUFRaid40_8:GetHeight() + 30)
		elseif RayUI_ContainerFrame and RayUI_ContainerFrame:IsVisible() and (GetScreenWidth() - RayUI_ContainerFrame:GetRight()) < 250 then
			-- tooltip:Point("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -50, RayUI_ContainerFrame:GetBottom() + RayUI_ContainerFrame:GetHeight() + 30)
			local parent = RayUI_ContainerFrameItemSets:IsVisible() and RayUI_ContainerFrameItemSets
			or RayUI_ContainerFrameConsumables:IsVisible() and RayUI_ContainerFrameConsumables
			or RayUI_ContainerFrameMain
			if parent:GetBottom() and parent:GetHeight() then
				tooltip:Point("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -50, parent:GetBottom() + parent:GetHeight() + 30)
			end
		elseif RayUFRaid15_1UnitButton1 and RayUFRaid15_1UnitButton1:IsVisible() and (GetScreenWidth() - RayUFRaid15_3:GetRight()) < 250 then
			tooltip:Point("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -50, RayUFRaid15_3:GetBottom() + RayUFRaid15_3:GetHeight() + 30)
		elseif RayUFRaid25_1UnitButton1 and RayUFRaid25_1UnitButton1:IsVisible() and (GetScreenWidth() - RayUFRaid25_5:GetRight()) < 250 then
			tooltip:Point("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -50, RayUFRaid25_5:GetBottom() + RayUFRaid25_5:GetHeight() + 30)
		elseif NumerationFrame and NumerationFrame:IsVisible() and (GetScreenWidth() - NumerationFrame:GetRight()) < 250 then
			tooltip:Point("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -50, NumerationFrame:GetBottom() + NumerationFrame:GetHeight() + 30)
		elseif Skada then
			local windows = Skada:GetWindows()
			if #windows >= 1 and (GetScreenWidth() - windows[1].bargroup:GetRight()) < 250 then
				tooltip:Point("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -50, windows[1].bargroup:GetTop() + 30 + (windows[1].db.enabletitle and windows[1].db.barheight or 0))
			else
				tooltip:Point("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -50, 160)
			end
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
			r = R.colors.class[class].r
			g = R.colors.class[class].g
			b = R.colors.class[class].b
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
					if ilvlAdd then
						ilvl = ilvl + ilvlAdd
					end
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
		local r, g, b  = TT:GetQuality(unitilvl)
		ilvcurrent.format = R:RGBToHex(r, g, b)..unitilvl
		for i = 2, GameTooltip:NumLines() do
			if ((_G["GameTooltipTextLeft"..i]:GetText() or ""):match("^"..STAT_AVERAGE_ITEM_LEVEL)) then
				_G["GameTooltipTextRight"..i]:SetText(R:RGBToHex(r, g, b)..unitilvl)
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
	if ItemScore < 600 then
		return 1, 1, 0.1
	else
		return R:ColorGradient((ItemScore - 600)/100, 1, 1, 0.1, 1, 0.1, 0.1)
	end
end

function TT:iLVSetUnit()
	local GMF = GetMouseFocus()
	local unit = (select(2, GameTooltip:GetUnit())) or (GMF and GMF:GetAttribute("unit"))

	if (not unit) and (UnitExists("mouseover")) then
		unit = "mouseover"
	end
	if not (unit) or not (UnitIsPlayer(unit)) or not (CanInspect(unit)) then
		return
	end

	local cacheLoaded = false
	wipe(ilvcurrent)
	ilvcurrent.unit = unit
	ilvcurrent.name = UnitName(unit)
	ilvcurrent.guid = UnitGUID(unit)

	for _, entry in ipairs(ilvcache) do
		if (ilvcurrent.name == entry.name and entry.format) then
			GameTooltip:AddDoubleLine(STAT_AVERAGE_ITEM_LEVEL, entry.format, nil, nil, nil, 1, 1, 1)
			ilvcurrent.format = entry.format
			cacheLoaded = true
			break
		end
	end
	if UnitIsUnit(unit, "player") then
		local unitilvl = GetPlayerScore("player")
		local r, g, b = TT:GetQuality(unitilvl)
		GameTooltip:AddDoubleLine(STAT_AVERAGE_ITEM_LEVEL, R:RGBToHex(r, g, b)..unitilvl, nil, nil, nil, 1, 1, 1)
	elseif not cacheLoaded then
		GameTooltip:AddDoubleLine(STAT_AVERAGE_ITEM_LEVEL, "...", nil, nil, nil, 1, 1, 1)
	end
end

function TT:INSPECT_READY(event, guid)
	self:UnregisterEvent(event)
	if (guid == talentcurrent.guid) then
		GatherTalents(1)
		self:SetiLV()
	end
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
		ChatMenu,
		EmoteMenu,
		LanguageMenu,
		VoiceMacroMenu,
	}

	for _, tt in pairs(tooltips) do
		self:SetStyle(tt)
		self:HookScript(tt, "OnShow", "SetStyle")
	end

	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
end

function TT:GetItemScore(iLink)
	local _, _, itemRarity, itemLevel, _, _, _, _, itemEquip = GetItemInfo(iLink)
	if (IsEquippableItem(iLink)) then
		if not   (itemLevel > 1) and (itemRarity > 1) then
			return 0
		end
	end
	return R:GetItemUpgradeLevel(iLink)
end

function TT:SetStyle(tooltip)
	if self.db.hideincombat and InCombatLockdown() then
		return tooltip:Hide()
	end
	if not tooltip.styled then
		tooltip:SetBackdrop(nil)
		R:GetModule("Skins"):CreateStripesThin(tooltip)
		tooltip:CreateShadow("Background")
		tooltip.stripesthin:SetInside(tooltip)
		tooltip.border:SetInside(tooltip)
		tooltip.styled=true

		local getBackdrop = function()
			return tooltip.shadow:GetBackdrop()
		end

		local getBackdropColor = function()
			return unpack(R["media"].backdropfadecolor)
		end

		local getBackdropBorderColor = function()
			return 0, 0, 0
		end

		tooltip.GetBackdrop = getBackdrop
		tooltip.GetBackdropColor = getBackdropColor
		tooltip.GetBackdropBorderColor = getBackdropBorderColor
	end
	tooltip:SetBackdropColor(unpack(R["media"].backdropfadecolor))
	local item
	if tooltip.GetItem then
		item = select(2, tooltip:GetItem())
	end
	if item then
		local quality = select(3, GetItemInfo(item))
		if quality and quality > 1 then
			local r, g, b = GetItemQualityColor(quality)
			tooltip.border:SetBackdropBorderColor(r, g, b)
			tooltip.shadow:SetBackdropBorderColor(r, g, b)
		else
			tooltip.border:SetBackdropBorderColor(0, 0, 0)
			tooltip.shadow:SetBackdropBorderColor(0, 0, 0)
		end
	else
		tooltip.border:SetBackdropBorderColor(unpack(R["media"].bordercolor))
		tooltip.shadow:SetBackdropBorderColor(unpack(R["media"].bordercolor))
	end
	-- if tooltip.NumLines then
	-- 	for index=1, tooltip:NumLines() do
	-- 		-- _G[tooltip:GetName().."TextLeft"..index]:SetShadowOffset(R.mult, -R.mult)
	-- 	end
	-- end
	tooltip.needRefresh = true
end

function TT:OnTooltipSetUnit(tooltip)
	local GMF = GetMouseFocus()
	local unit = (select(2, tooltip:GetUnit())) or (GMF and GMF:GetAttribute("unit"))

	if (not unit) and (UnitExists("mouseover")) then
		unit = "mouseover"
	end

	if not unit then tooltip:Hide() return end

	if self.db.hideincombat and InCombatLockdown() then
		return tooltip:Hide()
	end
	local unitClassification = types[UnitClassification(unit)] or " "
	local creatureType = UnitCreatureType(unit) or ""
	local unitName = UnitName(unit)
	local unitLevel = UnitLevel(unit)
	local diffColor = unitLevel > 0 and GetQuestDifficultyColor(UnitLevel(unit)) or QuestDifficultyColors["impossible"]
	if unitLevel < 0 then unitLevel = "??" end
	if UnitExists(unit.."target") then
		local r, g, b = GameTooltip_UnitColor(unit.."target")
		if UnitName(unit.."target") == UnitName("player") then
			text = R:RGBToHex(1, 0, 0)..">>"..YOU.."<<|r"
		else
			text = R:RGBToHex(r, g, b)..UnitName(unit.."target").."|r"
		end
		tooltip:AddDoubleLine(TARGET, text)
	end
	if UnitIsPlayer(unit) then
		local unitRace = UnitRace(unit)
		local unitClass, unitClassEn = UnitClass(unit)
		local guild, rank = GetGuildInfo(unit)
		local playerGuild = GetGuildInfo("player")
		local unitSpec = GetSpecialization()
		GameTooltipStatusBar:SetStatusBarColor(unpack({GameTooltip_UnitColor(unit)}))
		if guild then
			GameTooltipTextLeft2:SetFormattedText("<%s>"..R:RGBToHex(1, 1, 1).." %s|r", guild, rank)
			if IsInGuild() and guild == playerGuild then
				GameTooltipTextLeft2:SetTextColor(pgcol[1], pgcol[2], pgcol[3])
			else
				GameTooltipTextLeft2:SetTextColor(gcol[1], gcol[2], gcol[3])
			end
		end
		for i=2, tooltip:NumLines() do
			if _G["GameTooltipTextLeft" .. i]:GetText():find(("%%(%s%%)"):format(PLAYER)) then
				_G["GameTooltipTextLeft" .. i]:SetText(string.format(R:RGBToHex(diffColor.r, diffColor.g, diffColor.b).."%s|r ", unitLevel) .. unitRace .. " ".. unitClass)
				break
			end
		end
		if UnitFactionGroup(unit) and UnitFactionGroup(unit) ~= "Neutral" then
			GameTooltipTextLeft1:SetText("|TInterface\\Addons\\RayUI\\media\\UI-PVP-"..select(1, UnitFactionGroup(unit))..".blp:16:16:0:0:64:64:5:40:0:35|t "..GameTooltipTextLeft1:GetText())
		end
		if UnitIsAFK(unit) then
			tooltip:AppendText((" %s"):format(("|cffFFFFFF<|r|cffFF3333%s|r|cffFFFFFF>|r"):format(AFK)))
		elseif UnitIsDND(unit) then
			tooltip:AppendText((" %s"):format(("|cffFFFFFF<|r|cffE7E716%s|r|cffFFFFFF>|r"):format(DND)))
		end
		self:iLVSetUnit()
		self:TalentSetUnit()
	elseif ( UnitIsWildBattlePet(unit) or UnitIsBattlePetCompanion(unit) ) then
		local petLevel = UnitBattlePetLevel(unit)
		local petType = _G["BATTLE_PET_DAMAGE_NAME_"..UnitBattlePetType(unit)]
		for i=2, tooltip:NumLines() do
			local text = _G["GameTooltipTextLeft" .. i]:GetText()
			if text:find(LEVEL) then
				_G["GameTooltipTextLeft" .. i]:SetText(petLevel .. unitClassification .. petType)
				break
			end
		end
	else
		for i=2, tooltip:NumLines() do
			local text = _G["GameTooltipTextLeft" .. i]:GetText()
			if text:find(LEVEL) or text:find(creatureType) then
				_G["GameTooltipTextLeft" .. i]:SetText(string.format(R:RGBToHex(diffColor.r, diffColor.g, diffColor.b).."%s|r", unitLevel) .. unitClassification .. creatureType)
				break
			end
		end
	end
	for i = 1, tooltip:NumLines() do
		local line = _G["GameTooltipTextLeft"..i]
		while line and line:GetText() and (line:GetText() == PVP_ENABLED or line:GetText() == FACTION_HORDE or line:GetText() == FACTION_ALLIANCE) do
			line:SetText()
			break
		end
	end
end

function TT:GameTooltip_ShowStatusBar(tooltip, min, max, value, text)
	local statusBar = _G[tooltip:GetName().."StatusBar"..tooltip.shownStatusBars]
	if statusBar and not statusBar.styled then
		statusBar:StripTextures()
		statusBar:SetStatusBarTexture(R["media"].normal)
		statusBar.border = CreateFrame("Frame", nil, statusBar)
		statusBar.border:SetFrameLevel(0)
		statusBar.border:SetOutside(statusBar, 1, 1)
		R:GetModule("Skins"):CreateBD(statusBar.border)
		statusBar.styled=true
	end
end

function TT:Initialize()
	self:RawHook("GameTooltip_UnitColor", true)

	self:HookScript(GameTooltip, "OnTooltipSetUnit")

	GameTooltipStatusBar:CreateShadow("Background")
	GameTooltipStatusBar:SetHeight(8)
	GameTooltipStatusBar:SetStatusBarTexture(R["media"].normal)
	GameTooltipStatusBar:ClearAllPoints()
	GameTooltipStatusBar:SetPoint("TOPLEFT", GameTooltip, "BOTTOMLEFT", 3, -2)
	GameTooltipStatusBar:SetPoint("TOPRIGHT", GameTooltip, "BOTTOMRIGHT", -3, -2)
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
			local hp = R:ShortValue(min).." / "..R:ShortValue(max)
			self.text:SetText(hp)
		else
			if self.text then
				self.text:Hide()
			end
		end
	end)

	self:SecureHook("GameTooltip_SetDefaultAnchor")
	self:SecureHook("GameTooltip_ShowStatusBar")
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
	self:RegisterEvent("PLAYER_ENTERING_WORLD")

	SetCVar("alwaysCompareItems", 1)
end

function TT:Info()
	return L["|cff7aa6d6Ray|r|cffff0000U|r|cff7aa6d6I|r鼠标提示模块."]
end

R:RegisterModule(TT:GetName())
