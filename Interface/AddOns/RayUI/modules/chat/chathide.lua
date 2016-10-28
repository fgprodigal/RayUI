local R, L, P, G = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, GlobalDB
local CH = R:GetModule("Chat")

--Cache global variables
--Lua functions
local _G = _G
local select, pairs = select, pairs

--WoW API / Variables
local CreateFrame = CreateFrame
local ChatEdit_ClearChat = ChatEdit_ClearChat
local GetCursorPosition = GetCursorPosition
local InCombatLockdown = InCombatLockdown
local ChatFrame_AddMessageEventFilter = ChatFrame_AddMessageEventFilter

--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: RayUIChatBG, ChatFrame1EditBox, RayUIChatToggle, GameTooltip, ChatTypeInfo

local isMoving = false
local hasNew = false
local timeout = 0
local whentoshow={
    "say", "emote", "text_emote", "yell",
    "monster_emote", "monster_party", "monster_say", "monster_whisper", "monster_yell",
    "party", "party_leader", "party_guide",
    "whisper", "system", "channel",
    "guild", "officer",
    "instance_chat", "instance_chat_leader",
    "raid", "raid_leader", "raid_warning",
    "bn_whisper",
    "bn_inline_toast_broadcast",
}
local channelNumbers = {
    [1] = true,
    [2] = true,
    [3] = true,
    [4] = true,
}
CH.ChatIn = true

function CH:SetUpAnimGroup(self)
    self.anim = self:CreateAnimationGroup("Flash")
    self.anim.fadein = self.anim:CreateAnimation("ALPHA", "FadeIn")
    self.anim.fadein:SetFromAlpha(0)
    self.anim.fadein:SetToAlpha(1)
    self.anim.fadein:SetOrder(2)

    self.anim.fadeout = self.anim:CreateAnimation("ALPHA", "FadeOut")
    self.anim.fadeout:SetFromAlpha(1)
    self.anim.fadeout:SetToAlpha(0)
    self.anim.fadeout:SetOrder(1)
end

function CH:Flash(self, duration)
    if not self.anim then
        CH:SetUpAnimGroup(self)
    end

    self.anim.fadein:SetDuration(duration)
    self.anim.fadeout:SetDuration(duration)
    self.anim:Play()
end

function CH:StopFlash(self)
    if self.anim then
        self.anim:Finish()
    end
end

local on_update = R.simple_move

function CH:MoveOut()
    isMoving = true
    CH.ChatIn = false
    RayUIChatBG:SetPoint("BOTTOMLEFT", R.UIParent, "BOTTOMLEFT", 15, 30)
    local fadeInfo = {}
	fadeInfo.mode = "OUT"
	fadeInfo.timeToFade = 0.5
	fadeInfo.finishedFunc = function()
		if InCombatLockdown() then return end
		RayUIChatBG:Hide()
	end
	fadeInfo.startAlpha = RayUIChatBG:GetAlpha()
	fadeInfo.endAlpha = 0
    R:UIFrameFade(RayUIChatBG, fadeInfo)
    R:Slide(RayUIChatBG, "LEFT", CH.db.width + 15, 195)
    ChatEdit_ClearChat(ChatFrame1EditBox)
end

function CH:MoveIn()
    isMoving = true
    CH.ChatIn = true
    RayUIChatBG:SetPoint("BOTTOMLEFT", R.UIParent, "BOTTOMLEFT", -CH.db.width, 30)
    R:Slide(RayUIChatBG, "RIGHT", CH.db.width + 15, 195)
    RayUIChatBG:Show()
    R:UIFrameFadeIn(RayUIChatBG, .5, RayUIChatBG:GetAlpha(), 1)
end

function CH:ToggleChat()
    timeout = 0
    if CH.ChatIn == true then
        CH:MoveOut()
    else
        CH:MoveIn()
    end
end

function CH:OnEvent(event, ...)
    -- if event == "CHAT_MSG_CHANNEL" and channelNumbers and not channelNumbers[select(8,...)] and not select(9,...):find("TCForwarder") and not select(9,...):find("LFGForwarder") then return end
    if event == "CHAT_MSG_CHANNEL" and (select(1,...):find("^%^LFW_") or select(9,...):find("友团")) then return end
    timeout = 0
    if CH.ChatIn == false then
        if isMoving then
            isMoving = false
            RayUIChatBG:SetScript("OnUpdate", nil)
        end
        RayUIChatBG:Show()
        RayUIChatBG:ClearAllPoints()
        RayUIChatBG:SetPoint("BOTTOMLEFT",R.UIParent,"BOTTOMLEFT",15,30)
        R:UIFrameFadeIn(RayUIChatBG, .7, 0, 1)
        CH.ChatIn = true
        hasNew = false
    end
end

function CH:OnUpdate()
    local x, y = GetCursorPosition()
    local cursor = ( x > RayUIChatBG:GetLeft() and x < RayUIChatBG:GetLeft() + RayUIChatBG:GetWidth() ) and ( y > RayUIChatBG:GetBottom() and y < RayUIChatBG:GetBottom() + RayUIChatBG:GetHeight() )
    timeout = timeout + 1
    if timeout>CH.db.autohidetime and CH.ChatIn == true and not ChatFrame1EditBox:IsShown() and not InCombatLockdown() and not cursor then
        CH:MoveOut()
    end
end

function CH:AutoHide()
    if not self.db.autoshow then
        local function CheckWhisperWindows(self, event)
            local chat = self:GetName()
            if chat == "ChatFrame1" and CH.ChatIn == false then
                if event == "CHAT_MSG_WHISPER" then
                    hasNew = true
                    RayUIChatToggle:SetAlpha(1)
                    RayUIChatToggle.shadow:SetBackdropBorderColor(ChatTypeInfo["WHISPER"].r,ChatTypeInfo["WHISPER"].g,ChatTypeInfo["WHISPER"].b, 1)
                elseif event == "CHAT_MSG_BN_WHISPER" then
                    hasNew = true
                    RayUIChatToggle:SetAlpha(1)
                    RayUIChatToggle.shadow:SetBackdropBorderColor(ChatTypeInfo["BN_WHISPER"].r,ChatTypeInfo["BN_WHISPER"].g,ChatTypeInfo["BN_WHISPER"].b, 1)
                end
                RayUIChatToggle:SetScript("OnUpdate", function(self)
                        if not CH.ChatIn then
                            CH:Flash(self.shadow, 1)
                        else
                            CH:StopFlash(self.shadow)
                            self:SetScript('OnUpdate', nil)
                            self.shadow:SetBackdropBorderColor(R["media"].backdropcolor)
                            self:SetAlpha(0)
                            hasNew = false
                        end
                    end)
            end
        end
        ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", CheckWhisperWindows)
        ChatFrame_AddMessageEventFilter("CHAT_MSG_BN_WHISPER", CheckWhisperWindows)
    else
        for _, event in pairs(whentoshow) do
            if(not event:match("[A-Z]")) then
                event = "CHAT_MSG_"..event:upper()
            end
            self:RegisterEvent(event, "OnEvent")
        end
        self:RegisterEvent("PLAYER_REGEN_DISABLED", "OnEvent")
        self:RegisterEvent("BN_FRIEND_ACCOUNT_ONLINE", "OnEvent")
        self:RegisterEvent("BN_FRIEND_ACCOUNT_OFFLINE", "OnEvent")
        self:RegisterEvent("BN_CUSTOM_MESSAGE_CHANGED", "OnEvent")
        self:RegisterEvent("BN_FRIEND_INVITE_ADDED", "OnEvent")
        self:RegisterEvent("BN_FRIEND_INVITE_LIST_INITIALIZED", "OnEvent")
    end
    local RayUIChatToggle = CreateFrame("Frame", "RayUIChatToggle", R.UIParent)
    RayUIChatToggle:CreatePanel("Default", 15, 140, "BOTTOMLEFT",R.UIParent,"BOTTOMLEFT", 0,30)
    RayUIChatToggle:SetAlpha(0)
    RayUIChatToggle:SetScript("OnEnter",function(self)
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT", 0, 0)
            GameTooltip:ClearLines()
            if CH.ChatIn then
                GameTooltip:AddLine(L["点击隐藏聊天栏"])
            else
                GameTooltip:AddLine(L["点击显示聊天栏"])
            end
            if not hasNew then
                R:UIFrameFadeIn(self, 0.5, self:GetAlpha(), 1)
            else
                GameTooltip:AddLine(L["有新的悄悄话"])
            end
            GameTooltip:Show()
        end)
    RayUIChatToggle:SetScript("OnLeave",function(self)
            if not hasNew then
                R:UIFrameFadeOut(self, 0.5, self:GetAlpha(), 0)
            end
            GameTooltip:Hide()
        end)
    RayUIChatToggle:SetScript("OnMouseDown", function(self, btn)
            if btn == "LeftButton" and not InCombatLockdown() then
                CH:ToggleChat()
            end
        end)
    ChatFrame1EditBox:HookScript("OnShow", function(self)
            timeout = 0
            if CH.ChatIn == false then
                if isMoving then
                    isMoving = false
                    RayUIChatBG:SetScript("OnUpdate", nil)
                end
                RayUIChatBG:Show()
                RayUIChatBG:ClearAllPoints()
                RayUIChatBG:SetPoint("BOTTOMLEFT",R.UIParent,"BOTTOMLEFT",15,30)
                R:UIFrameFadeIn(RayUIChatBG, .7, 0, 1)
                CH.ChatIn = true
                hasNew = false
            end
        end)
    ChatFrame1EditBox:HookScript("OnHide", function(self)
            timeout = 0
        end)
    if self.db.autohide then
        self:ScheduleRepeatingTimer("OnUpdate", 1)
    end
    RayUIChatBG.finish_function = function()
        isMoving = false
    end
end
