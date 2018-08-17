-- Notification from FreeUI
----------------------------------------------------------
-- Load RayUI Environment
----------------------------------------------------------
RayUI:LoadEnv("Notification")


local NF = R:NewModule("Notification", "AceEvent-3.0", "AceHook-3.0")
local S = R.Skins
_Notification = NF


local bannerWidth = 300
local max_active_toasts = 3
local fadeout_delay = 5
local toasts = {}
local activeToasts = {}
local queuedToasts = {}
local anchorFrame

function NF:SpawnToast(toast)
    if not toast then return end

    if #activeToasts >= max_active_toasts then
        table.insert(queuedToasts, toast)

        return false
    end

    if UnitIsAFK("player") then
        table.insert(queuedToasts, toast)
        self:RegisterEvent("PLAYER_FLAGS_CHANGED")

        return false
    end

    local YOffset = 0
    if R:GetScreenQuadrant(anchorFrame):find("TOP") then
        YOffset = -54
    else
        YOffset = 54
    end

    toast:ClearAllPoints()
    if #activeToasts > 0 then
        if R:GetScreenQuadrant(anchorFrame):find("TOP") then
            toast:SetPoint("TOP", activeToasts[#activeToasts], "BOTTOM", 0, -4 - YOffset)
        else
            toast:SetPoint("BOTTOM", activeToasts[#activeToasts], "TOP", 0, 4 - YOffset)
        end
    else
        toast:SetPoint("TOP", anchorFrame, "TOP", 0, 1 - YOffset)
    end

    table.insert(activeToasts, toast)

    toast:Show()
    toast.AnimIn.AnimMove:SetOffset(0, YOffset)
    toast.AnimOut.AnimMove:SetOffset(0, -YOffset)
    toast.AnimIn:Play()
    toast.AnimOut:Play()
    PlaySound(18019)
end

function NF:RefreshToasts()
    for i = 1, #activeToasts do
        local activeToast = activeToasts[i]
        local YOffset, _ = 0
        if activeToast.AnimIn.AnimMove:IsPlaying() then
            _, YOffset = activeToast.AnimIn.AnimMove:GetOffset()
        end
        if activeToast.AnimOut.AnimMove:IsPlaying() then
            _, YOffset = activeToast.AnimOut.AnimMove:GetOffset()
        end

        activeToast:ClearAllPoints()

        if i == 1 then
            activeToast:SetPoint("TOP", anchorFrame, "TOP", 0, 1 - YOffset)
        else
            if R:GetScreenQuadrant(anchorFrame):find("TOP") then
                activeToast:SetPoint("TOP", activeToasts[i - 1], "BOTTOM", 0, -4 - YOffset)
            else
                activeToast:SetPoint("BOTTOM", activeToasts[i - 1], "TOP", 0, 4 - YOffset)
            end
        end
    end

    local queuedToast = table.remove(queuedToasts, 1)

    if queuedToast then
        self:SpawnToast(queuedToast)
    end
end

function NF:HideToast(toast)
    for i, activeToast in pairs(activeToasts) do
        if toast == activeToast then
            table.remove(activeToasts, i)
        end
    end
    table.insert(toasts, toast)
    toast:Hide()
    C_Timer.After(0.1, function() self:RefreshToasts() end)
end

local function ToastButtonAnimOut_OnFinished(self)
    NF:HideToast(self:GetParent())
end

function NF:GetToast()
    local toast = table.remove(toasts, 1)
    if not toast then
        toast = CreateFrame("Frame", nil, R.UIParent)
        toast:SetFrameStrata("FULLSCREEN_DIALOG")
        toast:SetSize(bannerWidth, 50)
        toast:SetPoint("TOP", R.UIParent, "TOP")
        toast:Hide()
        S:CreateBD(toast)

        local icon = toast:CreateTexture(nil, "OVERLAY")
        icon:SetSize(32, 32)
        icon:SetPoint("LEFT", toast, "LEFT", 9, 0)
        S:CreateBG(icon)
        toast.icon = icon

        local sep = toast:CreateTexture(nil, "BACKGROUND")
        sep:SetSize(1, 50)
        sep:SetPoint("LEFT", icon, "RIGHT", 9, 0)
        sep:SetColorTexture(0, 0, 0)

        local title = toast:CreateFontString(nil, "OVERLAY")
        title:SetFont(R["media"].font, 14)
        title:SetShadowOffset(1, -1)
        title:SetPoint("TOPLEFT", sep, "TOPRIGHT", 9, -9)
        title:SetPoint("RIGHT", toast, -9, 0)
        title:SetJustifyH("LEFT")
        toast.title = title

        local text = toast:CreateFontString(nil, "OVERLAY")
        text:SetFont(R["media"].font, 12)
        text:SetShadowOffset(1, -1)
        text:SetPoint("BOTTOMLEFT", sep, "BOTTOMRIGHT", 9, 9)
        text:SetPoint("RIGHT", toast, -9, 0)
        text:SetJustifyH("LEFT")
        toast.text = text

        toast.AnimIn = CreateAnimationGroup(toast)

        local animInAlpha = toast.AnimIn:CreateAnimation("Fade")
        animInAlpha:SetOrder(1)
        animInAlpha:SetChange(1)
        animInAlpha:SetDuration(0.5)
        toast.AnimIn.AnimAlpha = animInAlpha

        local animInMove = toast.AnimIn:CreateAnimation("Move")
        animInMove:SetOrder(1)
        animInMove:SetDuration(0.5)
        animInMove:SetSmoothing("Out")
        animInMove:SetOffset(-bannerWidth, 0)
        toast.AnimIn.AnimMove = animInMove

        toast.AnimOut = CreateAnimationGroup(toast)

        local animOutSleep = toast.AnimOut:CreateAnimation("Sleep")
        animOutSleep:SetOrder(1)
        animOutSleep:SetDuration(fadeout_delay)
        toast.AnimOut.AnimSleep = animOutSleep

        local animOutAlpha = toast.AnimOut:CreateAnimation("Fade")
        animOutAlpha:SetOrder(2)
        animOutAlpha:SetChange(0)
        animOutAlpha:SetDuration(0.5)
        toast.AnimOut.AnimAlpha = animOutAlpha

        local animOutMove = toast.AnimOut:CreateAnimation("Move")
        animOutMove:SetOrder(2)
        animOutMove:SetDuration(0.5)
        animOutMove:SetSmoothing("In")
        animOutMove:SetOffset(bannerWidth, 0)
        toast.AnimOut.AnimMove = animOutMove

        toast.AnimOut.AnimAlpha:SetScript("OnFinished", ToastButtonAnimOut_OnFinished)

        toast:SetScript("OnEnter", function(self)
                self.AnimOut:Stop()
            end)

        toast:SetScript("OnLeave", function(self)
                self.AnimOut:Play()
            end)

        toast:SetScript("OnMouseUp", function(self, button)
                if button == "LeftButton" and self.clickFunc then
                    self.clickFunc()
                end
            end)
    end
    return toast
end

function NF:DisplayToast(name, message, clickFunc, texture, ...)
    local toast = self:GetToast()

    if type(clickFunc) == "function" then
        toast.clickFunc = clickFunc
    else
        toast.clickFunc = nil
    end

    if type(texture) == "string" then
        toast.icon:SetTexture(texture)

        if ... then
            toast.icon:SetTexCoord(...)
        else
            toast.icon:SetTexCoord(.08, .92, .08, .92)
        end
    else
        toast.icon:SetTexture("Interface\\Icons\\achievement_general")
        toast.icon:SetTexCoord(.08, .92, .08, .92)
    end

    toast.title:SetText(name)
    toast.text:SetText(message)

    self:SpawnToast(toast)
end

function NF:PLAYER_FLAGS_CHANGED(event)
    self:UnregisterEvent(event)
    for i = 1, max_active_toasts - #activeToasts do
        self:RefreshToasts()
    end
end

function NF:PLAYER_REGEN_ENABLED()
    for i = 1, max_active_toasts - #activeToasts do
        self:RefreshToasts()
    end
end

-- Test function

local function testCallback()
    R:Print("Banner clicked!")
end

SlashCmdList.TESTNOTIFICATION = function(b)
    NF:DisplayToast("RayUI", "This is an example of a notification.", testCallback, b == "true" and "INTERFACE\\ICONS\\SPELL_FROST_ARCTICWINDS" or nil, .08, .92, .08, .92)
end
_G.SLASH_TESTNOTIFICATION1 = "/testnotification"

function NF:Initialize()
    anchorFrame = CreateFrame("Frame", nil, R.UIParent)
    anchorFrame:SetSize(bannerWidth, 50)
    anchorFrame:SetPoint("TOP", 0, -10)
    R:CreateMover(anchorFrame, "Notification Mover", L["通知锚点"], true, nil, "ALL,GENERAL")

    self:RegisterEvent("UPDATE_PENDING_MAIL")
    self:RegisterEvent("PLAYER_REGEN_ENABLED")
    self:RegisterEvent("CALENDAR_UPDATE_PENDING_INVITES")
    self:RegisterEvent("CALENDAR_UPDATE_GUILD_EVENTS")
    self:RegisterEvent("PLAYER_ENTERING_WORLD")
    self:RegisterEvent("VIGNETTE_MINIMAP_UPDATED")
    self:RegisterEvent("RESURRECT_REQUEST")
    self:RegisterEvent("UPDATE_INVENTORY_DURABILITY")
end

local hasMail = false
function NF:UPDATE_PENDING_MAIL()
    local newMail = HasNewMail()
    if hasMail ~= newMail then
        hasMail = newMail
        if hasMail then
            self:DisplayToast(MAIL_LABEL, HAVE_MAIL, nil, "Interface\\Icons\\inv_letter_15", .08, .92, .08, .92)
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

function NF:UPDATE_INVENTORY_DURABILITY()
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
        self:DisplayToast(MINIMAP_TRACKING_REPAIR, format(L["你的%s栏位需要修理, 当前耐久为%d."],Slots[1][2],value))
    end
end

local numInvites = 0
local function GetGuildInvites()
    local numGuildInvites = 0
    local currentMonth = (C_Calendar.GetDate()).month

    for i = 1, C_Calendar.GetNumGuildEvents() do
        local month, day = C_Calendar.GetGuildEventInfo(i)
        local monthOffset = month - currentMonth
        local numDayEvents = C_Calendar.GetNumDayEvents(monthOffset, day)

        for i = 1, numDayEvents do
            local _, _, _, _, _, _, _, _, inviteStatus = C_Calendar.GetDayEvent(monthOffset, day, i)
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
    local num = C_Calendar.GetNumInvites()
    if num ~= numInvites then
        if num > 1 then
            NF:DisplayToast(CALENDAR, format(L["你有%s个未处理的活动邀请."], num), toggleCalendar)
        elseif num > 0 then
            NF:DisplayToast(CALENDAR, format(L["你有%s个未处理的活动邀请."], 1), toggleCalendar)
        end
        numInvites = num
    end
end

local function alertGuildEvents()
    if CalendarFrame and CalendarFrame:IsShown() then return end
    local num = GetGuildInvites()
    if num > 1 then
        NF:DisplayToast(CALENDAR, format(L["你有%s个未处理的公会活动邀请."], num), toggleCalendar)
    elseif num > 0 then
        NF:DisplayToast(CALENDAR, format(L["你有%s个未处理的公会活动邀请."], 1), toggleCalendar)
    end
end

function NF:CALENDAR_UPDATE_PENDING_INVITES()
    alertEvents()
    alertGuildEvents()
end

function NF:CALENDAR_UPDATE_GUILD_EVENTS()
    alertGuildEvents()
end

local function LoginCheck()
    alertEvents()
    alertGuildEvents()
    local day = (C_Calendar.GetDate()).monthDay
    local numDayEvents = C_Calendar.GetNumDayEvents(0, day)
    local monthInfo = C_Calendar.GetMonthInfo()
    local numDays = monthInfo.numDays
    local hournow, minutenow = GetGameTime()

    -- Today
    for i = 1, numDayEvents do
        local title, hour, minute, calendarType, sequenceType, eventType, texture, modStatus, inviteStatus, invitedBy, difficulty, inviteType = C_Calendar.GetDayEvent(0, day, i)
        if calendarType == "HOLIDAY" and ( sequenceType == "END" or sequenceType == "" ) and hournow < hour then
            NF:DisplayToast(CALENDAR, format(L["活动\"%s\"今天结束."], title), toggleCalendar)
        end
        if calendarType == "HOLIDAY" and sequenceType == "START" and hournow > hour then
            NF:DisplayToast(CALENDAR, format(L["活动\"%s\"今天开始."], title), toggleCalendar)
        end
        if calendarType == "HOLIDAY" and sequenceType == "ONGOING" then
            NF:DisplayToast(CALENDAR, format(L["活动\"%s\"正在进行."], title), toggleCalendar)
        end
    end

    --Tomorrow
    local offset = 0
    if numDays == day then
        offset = 1
        day = 1
    else
        day = day + 1
    end
    numDayEvents = C_Calendar.GetNumDayEvents(offset, day)
    for i = 1, numDayEvents do
        local title, hour, minute, calendarType, sequenceType, eventType, texture, modStatus, inviteStatus, invitedBy, difficulty, inviteType = C_Calendar.GetDayEvent(offset, day, i)
        if calendarType == "HOLIDAY" and ( sequenceType == "END" or sequenceType == "" ) then
            NF:DisplayToast(CALENDAR, format(L["活动\"%s\"明天结束."], title), toggleCalendar)
        end
    end
end

function NF:PLAYER_ENTERING_WORLD()
    C_Timer.After(7, LoginCheck)
    self:UnregisterEvent("PLAYER_ENTERING_WORLD")
end

local isIgnored = {
    [1153] = true,		-- 部落要塞
    [1159] = true,		-- 联盟要塞
    [1803] = true,		-- 涌泉海滩
}

local cache = {}

function NF:VIGNETTE_MINIMAP_UPDATED(event, vignetteInstanceID)
    local instID = select(8, GetInstanceInfo())
    if isIgnored[instID] then return end

    if id and not cache[id] then
        local info = C_VignetteInfo.GetVignetteInfo(id)
        if not info then return end
        local filename, width, height, txLeft, txRight, txTop, txBottom = GetAtlasInfo(info.atlasName)
        if not filename then return end

        local atlasWidth = width/(txRight-txLeft)
        local atlasHeight = height/(txBottom-txTop)

        local tex = string.format("|T%s:%d:%d:0:0:%d:%d:%d:%d:%d:%d|t", filename, 0, 0, atlasWidth, atlasHeight, atlasWidth*txLeft, atlasWidth*txRight, atlasHeight*txTop, atlasHeight*txBottom)

        PlaySoundFile("Sound\\Interface\\PVPFlagTakenMono.ogg", "master")
        self:DisplayToast("发现稀有", name)
        cache[id] = true
    end
end

function NF:RESURRECT_REQUEST(name)
    PlaySound(SOUNDKIT.READY_CHECK)
end
R:RegisterModule(NF:GetName())
