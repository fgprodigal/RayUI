local R, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local B = R:GetModule("Blizzards")

local frameFlashManager = CreateFrame("FRAME")

local FLASHFRAMES = {}
local UIFrameFlashTimers = {}
local UIFrameFlashTimerRefCount = {}

local function UICoreFrameFlash_OnUpdate(self, elapsed)
	local frame
	local index = #FLASHFRAMES

	for syncId, timer in pairs(UIFrameFlashTimers) do
		UIFrameFlashTimers[syncId] = timer + elapsed
	end

	while FLASHFRAMES[index] do
		frame = FLASHFRAMES[index]
		frame._flashTimer = frame._flashTimer + elapsed

		if ( (frame._flashTimer > frame._flashDuration) and frame._flashDuration ~= -1 ) then
			UICoreFrameFlashStop(frame)
		else
			local flashTime = frame._flashTimer
			local alpha

			if (frame._syncId) then
				flashTime = UIFrameFlashTimers[frame._syncId]
			end

			flashTime = flashTime%(frame._fadeInTime+frame._fadeOutTime+(frame._flashInHoldTime or 0)+(frame._flashOutHoldTime or 0))
			if (flashTime < frame._fadeInTime) then
				alpha = flashTime/frame._fadeInTime
			elseif (flashTime < frame._fadeInTime+(frame._flashInHoldTime or 0)) then
				alpha = 1
			elseif (flashTime < frame._fadeInTime+(frame._flashInHoldTime or 0)+frame._fadeOutTime) then
				alpha = 1 - ((flashTime - frame._fadeInTime - (frame._flashInHoldTime or 0))/frame._fadeOutTime)
			else
				alpha = 0
			end

			frame:SetAlpha(alpha)
			frame:Show()
		end

		index = index - 1
	end

	if ( #FLASHFRAMES == 0 ) then
		self:SetScript("OnUpdate", nil)
	end
end

local function UICoreFrameFlash(frame, fadeInTime, fadeOutTime, flashDuration, showWhenDone, flashInHoldTime, flashOutHoldTime, syncId)
	if ( frame ) then
		local index = 1
		while FLASHFRAMES[index] do
			if ( FLASHFRAMES[index] == frame ) then
				return
			end
			index = index + 1
		end

		if (syncId) then
			frame._syncId = syncId
			if (UIFrameFlashTimers[syncId] == nil) then
				UIFrameFlashTimers[syncId] = 0
				UIFrameFlashTimerRefCount[syncId] = 0
			end
			UIFrameFlashTimerRefCount[syncId] = UIFrameFlashTimerRefCount[syncId]+1
		else
			frame._syncId = nil
		end

		frame._fadeInTime = fadeInTime
		frame._fadeOutTime = fadeOutTime
		frame._flashDuration = flashDuration
		frame._showWhenDone = showWhenDone
		frame._flashTimer = 0
		frame._flashInHoldTime = flashInHoldTime
		frame._flashOutHoldTime = flashOutHoldTime

		tinsert(FLASHFRAMES, frame)

		frameFlashManager:SetScript("OnUpdate", UICoreFrameFlash_OnUpdate)
	end
end

local function UICoreFrameIsFlashing(frame)
	for index, value in pairs(FLASHFRAMES) do
		if ( value == frame ) then
			return 1
		end
	end
	return nil
end

local function UICoreFrameFlashStop(frame)
	tDeleteItem(FLASHFRAMES, frame)
	frame:SetAlpha(1.0)
	frame._flashTimer = nil
	if (frame._syncId) then
		UIFrameFlashTimerRefCount[frame._syncId] = UIFrameFlashTimerRefCount[frame._syncId]-1
		if (UIFrameFlashTimerRefCount[frame._syncId] == 0) then
			UIFrameFlashTimers[frame._syncId] = nil
			UIFrameFlashTimerRefCount[frame._syncId] = nil
		end
		frame._syncId = nil
	end
	if ( frame._showWhenDone ) then
		frame:Show()
	else
		frame:Hide()
	end
end

local function FCFTab_UpdateAlpha(chatFrame, alerting)
	local chatTab = _G[chatFrame:GetName().."Tab"]
	local mouseOverAlpha, noMouseAlpha
	if ( not chatFrame.isDocked or chatFrame == FCFDock_GetSelectedWindow(GENERAL_CHAT_DOCK) ) then
		mouseOverAlpha = CHAT_FRAME_TAB_SELECTED_MOUSEOVER_ALPHA
		noMouseAlpha = CHAT_FRAME_TAB_SELECTED_NOMOUSE_ALPHA
	else
		if ( alerting ) then
			mouseOverAlpha = CHAT_FRAME_TAB_ALERTING_MOUSEOVER_ALPHA
			noMouseAlpha = CHAT_FRAME_TAB_ALERTING_NOMOUSE_ALPHA
		else
			mouseOverAlpha = CHAT_FRAME_TAB_NORMAL_MOUSEOVER_ALPHA
			noMouseAlpha = CHAT_FRAME_TAB_NORMAL_NOMOUSE_ALPHA
		end
	end

	UIFrameFadeRemoveFrame(chatTab)

	if ( chatFrame.hasBeenFaded ) then
		chatTab:SetAlpha(mouseOverAlpha)
	else
		chatTab:SetAlpha(noMouseAlpha)
	end
end

function B:FCF_StartAlertFlash(chatFrame)
	if ( chatFrame.minFrame ) then
		UICoreFrameFlash(chatFrame.minFrame.glow, 1.0, 1.0, -1, false, 0, 0, nil)
	end

	local chatTab = _G[chatFrame:GetName().."Tab"]
	UICoreFrameFlash(chatTab.glow, 1.0, 1.0, -1, false, 0, 0, nil)
	FCFTab_UpdateAlpha(chatFrame, true)
end

function B:FCF_StopAlertFlash(chatFrame)
	if ( chatFrame.minFrame ) then
		UICoreFrameFlashStop(chatFrame.minFrame.glow)
	end
	local chatTab = _G[chatFrame:GetName().."Tab"]
	UICoreFrameFlashStop(chatTab.glow)
	FCFTab_UpdateAlpha(chatFrame, false)
end

function B:UIFrameFlash(frame, fadeInTime, fadeOutTime, flashDuration, showWhenDone, flashInHoldTime, flashOutHoldTime, syncId)
	if ( frame ) then
		if not issecurevariable(frame, "syncId") or not issecurevariable(frame, "fadeInTime") or not issecurevariable(frame, "flashTimer") then
			-- R:Print("你的插件調用了UIFrameFlash，導致你可能無法切換天賦，請修改對應代碼。")
		end
	end
end

function B:PlayerTalentFrame_Toggle()
	if ( not PlayerTalentFrame:IsShown() ) then
		ShowUIPanel(PlayerTalentFrame)
		TalentMicroButtonAlert:Hide()
	else
		PlayerTalentFrame_Close()
	end
end

function B:ADDON_LOADED(event, addon)
	 if(addon=="Blizzard_TalentUI")then
		self:UnregisterEvent("ADDON_LOADED")
		self:RawHook("PlayerTalentFrame_Toggle", true)
		 for i=1, 10 do
            local tab = _G["PlayerTalentFrameTab"..i]
            if not tab then break end
            tab:SetScript("PreClick", function()
                for index = 1, STATICPOPUP_NUMDIALOGS, 1 do
                    local frame = _G["StaticPopup"..index]
                    if frame:IsShown() and not issecurevariable(frame, "which") --[[ and not self.BlizzardStaticPopupDialogs[frame.which] ]] then
                        local info = StaticPopupDialogs[frame.which]
                        if info and info.OnCancel and issecurevariable(info, "OnCancel") then
                            info.OnCancel()
                        end
                    end
                    frame:Hide()
                    frame.which = nil
                end
            end)
        end
	end
end

function B:TalentTaint()
	self:RegisterEvent("ADDON_LOADED")
	self:RawHook("FCF_StartAlertFlash", true)
	self:SecureHook("UIFrameFlash")
	self:SecureHook("FCF_StopAlertFlash")
end