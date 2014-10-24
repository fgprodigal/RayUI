-- Notification from FreeUI
local R, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local NF = R:NewModule("Notification", "AceEvent-3.0", "AceHook-3.0")

local f
local playSounds = true
local animations = true
local timeShown = 5
local bannerWidth = 400
local interval = 0.1

-- Banner show/hide animations

local bannerShown = false

local function hideBanner()
	if animations then
		local scale
		f:SetScript("OnUpdate", function(self)
			scale = self:GetScale() - interval
			if scale <= 0.1 then
				self:SetScript("OnUpdate", nil)
				self:Hide()
				bannerShown = false
				return
			end
			self:SetScale(scale)
			self:SetAlpha(scale)
		end)
	else
		f:Hide()
		f:SetScale(0.1)
		f:SetAlpha(0.1)
		-- f.button:Hide()
		bannerShown = false
	end
end

local function fadeTimer()
	local last = 0
	f:SetScript("OnUpdate", function(self, elapsed)
		local width = f:GetWidth()
		if width > bannerWidth then
			self:SetWidth(width - (interval*100))
		end
		last = last + elapsed
		if last >= timeShown then
			self:SetWidth(bannerWidth)
			self:SetScript("OnUpdate", nil)
			hideBanner()
		end
	end)
end

local function showBanner()
	bannerShown = true
	if animations then
		f:Show()
		local scale
		f:SetScript("OnUpdate", function(self)
			scale = self:GetScale() + interval
			self:SetScale(scale)
			self:SetAlpha(scale)
			if scale >= 1 then
				self:SetScale(1)
				self:SetScript("OnUpdate", nil)
				fadeTimer()
			end
		end)
	else
		f:SetScale(1)
		f:SetAlpha(1)
		f:Show()
		fadeTimer()
	end
end

-- Display a notification

local function display(name, message, clickFunc, texture, ...)
	if type(clickFunc) == "function" then
		f.clickFunc = clickFunc
	else
		f.clickFunc = nil
	end

	if type(texture) == "string" then
		f.icon:SetTexture(texture)

		if ... then
			f.icon:SetTexCoord(...)
		else
			f.icon:SetTexCoord(.08, .92, .08, .92)
		end
	else
		f.icon:SetTexture("Interface\\Icons\\achievement_general")
		f.icon:SetTexCoord(.08, .92, .08, .92)
	end

	f.title:SetText(name)
	f.text:SetText(message)

	showBanner()

	if playSounds then
		-- PlaySoundFile("Interface\\AddOns\\RayUI\\")
	end
end

-- Handle incoming notifications

local handler = CreateFrame("Frame")
local incoming = {}
local processing = false

local function handleIncoming()
	processing = true
	local i = 1

	handler:SetScript("OnUpdate", function(self)
		if incoming[i] == nil then
			self:SetScript("OnUpdate", nil)
			incoming = {}
			processing = false
			return
		else
			if not bannerShown then
				display(unpack(incoming[i]))
				i = i + 1
			end
		end
	end)
end

handler:SetScript("OnEvent", function(self, _, unit)
	if unit == "player" and not UnitIsAFK("player") then
		handleIncoming()
		self:UnregisterEvent("PLAYER_FLAGS_CHANGED")
	end
end)

-- The API show function

function NF:Show(name, message, clickFunc, texture, ...)
	if UnitIsAFK("player") then
		tinsert(incoming, {name, message, clickFunc, texture, ...})
		handler:RegisterEvent("PLAYER_FLAGS_CHANGED")
	elseif bannerShown or #incoming ~= 0 then
		tinsert(incoming, {name, message, clickFunc, texture, ...})
		if not processing then
			handleIncoming()
		end
	else
		display(name, message, clickFunc, texture, ...)
	end
end

local function expand(self)
	local width = self:GetWidth()

	if f.text:IsTruncated() and width < (GetScreenWidth() / 1.5) then
		self:SetWidth(width+(interval*100))
	else
		self:SetScript("OnUpdate", nil)
	end
end

-- Test function

local function testCallback()
	print("Banner clicked!")
end

SlashCmdList.TESTNOTIFICATION = function(b)
	NF:Show("RayUI", "This is an example of a notification.", testCallback, b == "true" and "INTERFACE\\ICONS\\SPELL_FROST_ARCTICWINDS" or nil, .08, .92, .08, .92)
end
SLASH_TESTNOTIFICATION1 = "/testnotification"

function NF:Initialize()
	local S = R:GetModule("Skins")
	f = CreateFrame("Frame", "RayUINotifications", UIParent)
	f:SetFrameStrata("FULLSCREEN_DIALOG")
	f:SetSize(bannerWidth, 50)
	f:SetPoint("TOP", UIParent, "TOP")
	f:Hide()
	f:SetAlpha(0.1)
	f:SetScale(0.1)
	S:CreateBD(f)

	local icon = f:CreateTexture(nil, "OVERLAY")
	icon:SetSize(32, 32)
	icon:SetPoint("LEFT", f, "LEFT", 9, 0)
	S:CreateBG(icon)
	f.icon = icon

	local sep = f:CreateTexture(nil, "BACKGROUND")
	sep:SetSize(1, 50)
	sep:SetPoint("LEFT", icon, "RIGHT", 9, 0)
	sep:SetTexture(0, 0, 0)

	local title = f:CreateFontString(nil, "OVERLAY")
	title:SetFont(R["media"].font, 14)
	title:SetShadowOffset(1, -1)
	title:SetPoint("TOPLEFT", sep, "TOPRIGHT", 9, -9)
	title:SetPoint("RIGHT", f, -9, 0)
	title:SetJustifyH("LEFT")
	f.title = title

	local text = f:CreateFontString(nil, "OVERLAY")
	text:SetFont(R["media"].font, 12)
	text:SetShadowOffset(1, -1)
	text:SetPoint("BOTTOMLEFT", sep, "BOTTOMRIGHT", 9, 9)
	text:SetPoint("RIGHT", f, -9, 0)
	text:SetJustifyH("LEFT")
	f.text = text

	-- local button = CreateFrame("Button", nil, f, "SecureActionButtonTemplate")
	-- button:SetAllPoints(f)
	-- button:SetAttribute("type", "macro")
	-- button:SetAttribute("macrotext", "/run print(1)")
	-- button:Hide()
	-- f.button = button

	f:SetScript("OnEnter", function(self)
		self:SetScript("OnUpdate", nil)
		self:SetScale(1)
		self:SetAlpha(1)
		self:SetScript("OnUpdate", expand)
	end)

	f:SetScript("OnLeave", fadeTimer)

	f:SetScript("OnMouseUp", function(self, button)
		self:SetScript("OnUpdate", nil)
		self:Hide()
		self:SetScale(0.1)
		self:SetAlpha(0.1)
		bannerShown = false
		-- right click just hides the banner
		if button ~= "RightButton" and f.clickFunc then
			f.clickFunc()
		end

		-- dismiss all
		if IsShiftKeyDown() then
			handler:SetScript("OnUpdate", nil)
			incoming = {}
			processing = false
		end
	end)

	self:RegisterEvent("UPDATE_PENDING_MAIL")
	self:RegisterEvent("PLAYER_REGEN_ENABLED")
	self:RegisterEvent("CALENDAR_UPDATE_PENDING_INVITES")
	self:RegisterEvent("CALENDAR_UPDATE_GUILD_EVENTS")
	self:RegisterEvent("PLAYER_ENTERING_WORLD")
	self:RegisterEvent("VIGNETTE_ADDED")
	self:RegisterEvent("RESURRECT_REQUEST")
end

local hasMail = false
function NF:UPDATE_PENDING_MAIL()
	local newMail = HasNewMail()
	if hasMail ~= newMail then
		hasMail = newMail
		if hasMail then
			self:Show(MAIL_LABEL, HAVE_MAIL, nil, "Interface\\Icons\\inv_letter_15", .08, .92, .08, .92)
		end
	end
end

local showRepair = true

local Slots = {
	[1] = {1, INVTYPE_HEAD, 1000},
	[2] = {3, INVTYPE_SHOULDER, 1000},
	[3] = {5, INVTYPE_ROBE, 1000},
	[4] = {6, INVTYPE_WAIST, 1000},
	[5] = {9, INVTYPE_WRIST, 1000},
	[6] = {10, INVTYPE_HAND, 1000},
	[7] = {7, INVTYPE_LEGS, 1000},
	[8] = {8, INVTYPE_FEET, 1000},
	[9] = {16, INVTYPE_WEAPONMAINHAND, 1000},
	[10] = {17, INVTYPE_WEAPONOFFHAND, 1000},
	[11] = {18, INVTYPE_RANGED, 1000}
}

local function ResetRepairNotification()
	showRepair = true
end

function NF:PLAYER_REGEN_ENABLED()
	local current, max

	for i = 1, 11 do
		if GetInventoryItemLink("player", Slots[i][1]) ~= nil then
			current, max = GetInventoryItemDurability(Slots[i][1])
			if current then 
				Slots[i][3] = current/max
			end
		end
	end
	table.sort(Slots, function(a, b) return a[3] < b[3] end)
	local value = floor(Slots[1][3]*100)

	if showRepair and value < 20 then
		showRepair = false
		R:Delay(30, ResetRepairNotification)
		self:Show(MINIMAP_TRACKING_REPAIR, format(L["你的%s栏位需要修理, 当前耐久为%d."],Slots[1][2],value))
	end
end

local numInvites = 0 
local function GetGuildInvites()
	local numGuildInvites = 0
	local _, currentMonth = CalendarGetDate()

	for i = 1, CalendarGetNumGuildEvents() do
		local month, day = CalendarGetGuildEventInfo(i)
		local monthOffset = month - currentMonth
		local numDayEvents = CalendarGetNumDayEvents(monthOffset, day)

		for i = 1, numDayEvents do
			local _, _, _, _, _, _, _, _, inviteStatus = CalendarGetDayEvent(monthOffset, day, i)
			if inviteStatus == 8 then
				numGuildInvites = numGuildInvites + 1
			end
		end
	end

	return numGuildInvites
end

local function toggleCalendar()
	if not CalendarFrame then LoadAddOn("Blizzard_Calendar") end
	Calendar_Toggle()
end

local function alertEvents()
	if CalendarFrame and CalendarFrame:IsShown() then return end
	local num = CalendarGetNumPendingInvites()
	if num ~= numInvites then
		if num > 1 then
			NF:Show(CALENDAR, format(L["你有%s个未处理的活动邀请."], num), toggleCalendar)
		elseif num > 0 then
			NF:Show(CALENDAR, format(L["你有%s个未处理的活动邀请."], 1), toggleCalendar)
		end
		numInvites = num
	end
end

local function alertGuildEvents()
	if CalendarFrame and CalendarFrame:IsShown() then return end
	local num = GetGuildInvites()
	if num > 1 then
		NF:Show(CALENDAR, format(L["你有%s个未处理的公会活动邀请."], num), toggleCalendar)
	elseif num > 0 then
		NF:Show(CALENDAR, format(L["你有%s个未处理的公会活动邀请."], 1), toggleCalendar)
	end
end

function NF:CALENDAR_UPDATE_PENDING_INVITES()
	alertEvents()
	alertGuildEvents()
end

function NF:CALENDAR_UPDATE_GUILD_EVENTS()
	alertGuildEvents()
end

function NF:PLAYER_ENTERING_WORLD()
	-- self:UPDATE_PENDING_MAIL()
	alertEvents()
	alertGuildEvents()
	local day = select(3, CalendarGetDate())
	local numDayEvents = CalendarGetNumDayEvents(0, day)
	for i = 1, numDayEvents do
		local title, hour, minute, calendarType, sequenceType, eventType, texture, modStatus, inviteStatus, invitedBy, difficulty, inviteType = CalendarGetDayEvent(0, day, i)
		if calendarType == "HOLIDAY" and ( sequenceType == "END" or sequenceType == "" ) then
			self:Show(CALENDAR, format(L["活动\"%s\"今天结束."], title), toggleCalendar)
		end
	end
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
end

function NF:VIGNETTE_ADDED(event, vignetteInstanceID)
	local names = ""

	local numVignettes = C_Vignettes.GetNumVignettes()
	for i=1, numVignettes do
		local vigInstanceGUID= C_Vignettes.GetVignetteGUID(i)
		local ofsX, ofsY, name = C_Vignettes. GetVignetteInfoFromInstanceID(vigInstanceGUID)
		names = names..name.."  "
	end
	PlaySoundFile("Sound\\Spells\\PVPFlagTaken.wav")
	self:Show("发现稀有", names)
end

function NF:RESURRECT_REQUEST(name)
	PlaySound("ReadyCheck")
end
R:RegisterModule(NF:GetName())
