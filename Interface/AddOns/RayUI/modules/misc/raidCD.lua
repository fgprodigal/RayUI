--Raid Utility by Elv22
local R, L, P, G = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB
local M = R:GetModule("Misc")

local filter = COMBATLOG_OBJECT_AFFILIATION_RAID + COMBATLOG_OBJECT_AFFILIATION_PARTY + COMBATLOG_OBJECT_AFFILIATION_MINE
local timer = 0
local bars = {}
local spellEvents = {
    ["SPELL_CAST_SUCCESS"] = true,
    ["SPELL_RESURRECT"] = true,
    ["SPELL_HEAL"] = true,
    ["SPELL_AURA_APPLIED"] = true,
    ["SPELL_AURA_REFRESH"] = true,
}

local function FormatTime(time)
	if time >= 60 then
		return format("%dm%ds", math.floor(time / 60), time % 60)
	else
		return format("%ds", time)
	end
end
 
function M:UpdateRaidCDPositions()
	for i = 1, #bars do
		bars[i]:ClearAllPoints()
		if i == 1 then
			bars[i]:Point("TOPLEFT", RaidCDAnchor, "TOPLEFT", 24, 0)
			bars[i]:Point("BOTTOMRIGHT", RaidCDAnchor, "BOTTOMRIGHT", 0, 0)
		else
            if M.db.raidcdgrowth == "UP" then
                bars[i]:Point("TOPLEFT", bars[i-1], "TOPLEFT", 0, 24)
                bars[i]:Point("BOTTOMRIGHT", bars[i-1], "BOTTOMRIGHT", 0, 24)
            else
                bars[i]:Point("TOPLEFT", bars[i-1], "TOPLEFT", 0, -24)
                bars[i]:Point("BOTTOMRIGHT", bars[i-1], "BOTTOMRIGHT", 0, -24)
            end
		end
		bars[i].id = i
	end
end

local function StopTimer(bar)
	bar:SetScript("OnUpdate", nil)
	bar:Hide()
	tremove(bars, bar.id)
	M:UpdateRaidCDPositions()
end

local function StopAllTimer()
	for i = 1, #bars do
		bars[i]:Hide()
		bars[i]:SetScript("OnUpdate", nil)
	end
	wipe(bars)
end

local function BarUpdate(self, elapsed)
	local curTime = GetTime()
	if self.endTime < curTime then
		StopTimer(self)
		return
	end
	self:SetValue(100 - (curTime - self.startTime) / (self.endTime - self.startTime) * 100)
	self.right:SetText(FormatTime(self.endTime - curTime))
end

local OnEnter = function(self)
	GameTooltip:SetOwner(self, "ANCHOR_TOP")
	--GameTooltip:AddDoubleLine(self.spell, self.right:GetText())
    GameTooltip:SetSpellByID(self.spellId)
	GameTooltip:SetClampedToScreen(true)
	GameTooltip:Show()
end

local OnLeave = function(self)
	GameTooltip:Hide()
end

local OnMouseDown = function(self, button)
	if button == "LeftButton" then
		if ( GetNumGroupMembers() > 0 and IsInRaid() ) then
			SendChatMessage(format("%s: %s", self.left:GetText(), self.right:GetText()), "RAID")
		elseif ( GetNumGroupMembers() > 0 and IsInGroup() ) then
			SendChatMessage(format("%s: %s", self.left:GetText(), self.right:GetText()), "PARTY")
		else
			SendChatMessage(format("%s: %s", self.left:GetText(), self.right:GetText()), "SAY")
		end
	elseif button == "RightButton" then
		StopTimer(self)
	end
end

local function CreateBar()
	local bar = CreateFrame("Statusbar", nil, UIParent)
	bar:SetFrameStrata("LOW")
	bar:Size(M.db.raidcdwidth, 20)
	bar:SetStatusBarTexture(R["media"].normal)
	bar:SetMinMaxValues(0, 100)
    bar:CreateShadow("Background")

	bar.right = bar:CreateFontString(nil, "OVERLAY")
    bar.right:SetFont(R["media"].font, R["media"].fontsize, "OUTLINE")
	bar.right:Point("RIGHT", -1, 1)
	bar.right:SetJustifyH("RIGHT")

	bar.left = bar:CreateFontString(nil, "OVERLAY")
    bar.left:SetFont(R["media"].font, R["media"].fontsize, "OUTLINE")
	bar.left:Point("LEFT", bar, "LEFT", 2, 1)
	bar.left:Point("RIGHT", bar.right, "LEFT", -2, 1)
	bar.left:SetJustifyH("LEFT")

	bar.icon = CreateFrame("Button", nil, bar)
	bar.icon:Size(18, 18)
	bar.icon:Point("RIGHT", bar, "LEFT", -4, 0)
    bar.icon:CreateShadow("Background")

	return bar
end

local function StartTimer(name, spellId)
	for i = 1, #bars do
		if bars[i].spell == GetSpellInfo(spellId) and bars[i].name == name then
            bars[i].endTime = GetTime() + G.Misc.RaidCDs[spellId]
            bars[i].startTime = GetTime()
			return
		end
	end
	local bar = CreateBar()
	local spell, rank, icon = GetSpellInfo(spellId)
	bar.endTime = GetTime() + G.Misc.RaidCDs[spellId]
	bar.startTime = GetTime()
	bar.left:SetText(spell.." - "..R:ShortenString(name, 16))
	bar.right:SetText(FormatTime(G.Misc.RaidCDs[spellId]))
	bar.icon:SetNormalTexture(icon)
	bar.icon:GetNormalTexture():SetTexCoord(.08, .92, .08, .92)
	bar.spell = spell
	bar.spellId = spellId
	bar.name = name
	bar:Show()
	local color = R.colors.class[select(2, UnitClass(name))]
	if color then
		bar:SetStatusBarColor(color.r, color.g, color.b)
	else
		bar:SetStatusBarColor(0.3, 0.7, 0.3)
	end
	bar:SetScript("OnUpdate", BarUpdate)
	bar:EnableMouse(true)
	bar:SetScript("OnEnter", OnEnter)
	bar:SetScript("OnLeave", OnLeave)
	bar:SetScript("OnMouseDown", OnMouseDown)
	bar.id = #bars+1
	bars[#bars+1] = bar
	M:UpdateRaidCDPositions()
end

function M:COMBAT_LOG_EVENT_UNFILTERED(event, ...)
	local timestamp, eventType, _, _, fromplayer, sourceFlags, _, _, toplayer, _, _, spellId = ...
	if bit.band(sourceFlags, filter) == 0 then return end
	if G.Misc.RaidCDs[spellId] and spellEvents[eventType] then
        StartTimer(fromplayer, spellId)
	end
end

function M:ZONE_CHANGED_NEW_AREA()
	if select(2, IsInInstance()) == "arena" then
		StopAllTimer()
	end
end

local bossfight
function M:INSTANCE_ENCOUNTER_ENGAGE_UNIT()
	if not UnitExists("boss1") then return end

	if not bossfight then
		bossfight=true
	end
end

local function checkForWipe()
	local w = true
	local num = GetNumGroupMembers()
	for i = 1, num do
		local name = GetRaidRosterInfo(i)
		if name then
			if UnitAffectingCombat(name) then
				w = false
			end
		end
	end
	if (w and bossfight) then
		bossfight=false
		StopAllTimer()
	end
	if not w then M:ScheduleTimer(checkForWipe, 2) end
end

function M:PLAYER_REGEN_ENABLED()
	checkForWipe()
end

function M:EnableRaidCD()
    M:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
    M:RegisterEvent("ZONE_CHANGED_NEW_AREA")
    M:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT")
    M:RegisterEvent("PLAYER_REGEN_ENABLED")
end

function M:DisableRaidCD()
    M:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
    M:UnregisterEvent("ZONE_CHANGED_NEW_AREA")
    M:UnregisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT")
    M:UnregisterEvent("PLAYER_REGEN_ENABLED")
    StopAllTimer()
end

local function LoadFunc()
	local RaidCDAnchor = CreateFrame("Frame", "RaidCDAnchor", UIParent)
	RaidCDAnchor:Point("BOTTOMLEFT", UIParent, "BOTTOMLEFT", R.db.Chat.width + 25, 30)
	RaidCDAnchor:SetSize(M.db.raidcdwidth + 24, 20)
	R:CreateMover(RaidCDAnchor, "RaidCDMover", L["团队冷却锚点"], true, nil)

    if not M.db.raidcd then return end
    M:EnableRaidCD()
end

M:RegisterMiscModule("RaidCD", LoadFunc)