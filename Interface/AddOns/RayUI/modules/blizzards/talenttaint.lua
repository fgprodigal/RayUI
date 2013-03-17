local R, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local B = R:GetModule("Blizzards")

B.BlizzardStaticPopupDialogs = {
	["CONFIRM_OVERWRITE_EQUIPMENT_SET"] = true,
	["CONFIRM_SAVE_EQUIPMENT_SET"] = true,
	["ERROR_CINEMATIC"] = true,
	["ERR_SOR_STARTING_EXPERIENCE_INCOMPLETE"] = true,
	["CONFIRM_DELETE_EQUIPMENT_SET"] = true,
	["CONFIRM_REMOVE_GLYPH"] = true,
	["CONFIRM_GLYPH_PLACEMENT"] = true,
	["CONFIRM_RESET_VIDEO_SETTINGS"] = true,
	["CONFIRM_RESET_AUDIO_SETTINGS"] = true,
	["CONFIRM_RESET_INTERFACE_SETTINGS"] = true,
	["MAC_OPEN_UNIVERSAL_ACCESS"] = true,
	["CONFIRM_PURCHASE_TOKEN_ITEM"] = true,
	["CONFIRM_REFUND_TOKEN_ITEM"] = true,
	["CONFIRM_REFUND_MAX_HONOR"] = true,
	["CONFIRM_REFUND_MAX_ARENA_POINTS"] = true,
	["CONFIRM_REFUND_MAX_HONOR_AND_ARENA"] = true,
	["CONFIRM_HIGH_COST_ITEM"] = true,
	["CONFIRM_COMPLETE_EXPENSIVE_QUEST"] = true,
	["CONFIRM_ACCEPT_PVP_QUEST"] = true,
	["USE_GUILDBANK_REPAIR"] = true,
	["GUILDBANK_WITHDRAW"] = true,
	["GUILDBANK_DEPOSIT"] = true,
	["CONFIRM_BUY_GUILDBANK_TAB"] = true,
	["TOO_MANY_LUA_ERRORS"] = true,
	["CONFIRM_ACCEPT_SOCKETS"] = true,
	["TAKE_GM_SURVEY"] = true,
	["CONFIRM_RESET_INSTANCES"] = true,
	["CONFIRM_RESET_CHALLENGE_MODE"] = true,
	["CONFIRM_GUILD_DISBAND"] = true,
	["CONFIRM_BUY_BANK_SLOT"] = true,
	["MACRO_ACTION_FORBIDDEN"] = true,
	["ADDON_ACTION_FORBIDDEN"] = true,
	["CONFIRM_LOOT_DISTRIBUTION"] = true,
	["CONFIRM_BATTLEFIELD_ENTRY"] = true,
	["BFMGR_CONFIRM_WORLD_PVP_QUEUED"] = true,
	["BFMGR_CONFIRM_WORLD_PVP_QUEUED_WARMUP"] = true,
	["BFMGR_DENY_WORLD_PVP_QUEUED"] = true,
	["BFMGR_INVITED_TO_QUEUE"] = true,
	["BFMGR_INVITED_TO_QUEUE_WARMUP"] = true,
	["BFMGR_INVITED_TO_ENTER"] = true,
	["BFMGR_EJECT_PENDING"] = true,
	["BFMGR_EJECT_PENDING_REMOTE"] = true,
	["BFMGR_PLAYER_EXITED_BATTLE"] = true,
	["BFMGR_PLAYER_LOW_LEVEL"] = true,
	["CONFIRM_GUILD_LEAVE"] = true,
	["CONFIRM_GUILD_PROMOTE"] = true,
	["RENAME_GUILD"] = true,
	["RENAME_ARENA_TEAM"] = true,
	["CONFIRM_TEAM_LEAVE"] = true,
	["CONFIRM_TEAM_PROMOTE"] = true,
	["CONFIRM_TEAM_KICK"] = true,
	["HELP_TICKET_QUEUE_DISABLED"] = true,
	["CLIENT_RESTART_ALERT"] = true,
	["CLIENT_LOGOUT_ALERT"] = true,
	["COD_ALERT"] = true,
	["COD_CONFIRMATION"] = true,
	["COD_CONFIRMATION_AUTO_LOOT"] = true,
	["DELETE_MAIL"] = true,
	["DELETE_MONEY"] = true,
	["SEND_MONEY"] = true,
	["CONFIRM_REPORT_SPAM_CHAT"] = true,
	["CONFIRM_REPORT_BATTLEPET_NAME"] = true,
	["CONFIRM_REPORT_PET_NAME"] = true,
	["CONFIRM_REPORT_BAD_LANGUAGE_CHAT"] = true,
	["CONFIRM_REPORT_SPAM_MAIL"] = true,
	["JOIN_CHANNEL"] = true,
	["CHANNEL_INVITE"] = true,
	["CHANNEL_PASSWORD"] = true,
	["NAME_CHAT"] = true,
	["RESET_CHAT"] = true,
	["HELP_TICKET_ABANDON_CONFIRM"] = true,
	["HELP_TICKET"] = true,
	["GM_RESPONSE_NEED_MORE_HELP"] = true,
	["GM_RESPONSE_RESOLVE_CONFIRM"] = true,
	["GM_RESPONSE_MUST_RESOLVE_RESPONSE"] = true,
	["PETRENAMECONFIRM"] = true,
	["DEATH"] = true,
	["RESURRECT"] = true,
	["RESURRECT_NO_SICKNESS"] = true,
	["RESURRECT_NO_TIMER"] = true,
	["SKINNED"] = true,
	["SKINNED_REPOP"] = true,
	["TRADE"] = true,
	["PARTY_INVITE"] = true,
	["PARTY_INVITE_XREALM"] = true,
	["CHAT_CHANNEL_INVITE"] = true,
	["LEVEL_GRANT_PROPOSED"] = true,
	["BN_BLOCK_FAILED_TOO_MANY_RID"] = true,
	["BN_BLOCK_FAILED_TOO_MANY_CID"] = true,
	["CHAT_CHANNEL_PASSWORD"] = true,
	["ARENA_TEAM_INVITE"] = true,
	["CAMP"] = true,
	["QUIT"] = true,
	["LOOT_BIND"] = true,
	["EQUIP_BIND"] = true,
	["AUTOEQUIP_BIND"] = true,
	["USE_BIND"] = true,
	["CONFIM_BEFORE_USE"] = true,
	["DELETE_ITEM"] = true,
	["DELETE_GOOD_ITEM"] = true,
	["QUEST_ACCEPT"] = true,
	["QUEST_ACCEPT_LOG_FULL"] = true,
	["ABANDON_PET"] = true,
	["ABANDON_QUEST"] = true,
	["ABANDON_QUEST_WITH_ITEMS"] = true,
	["ADD_FRIEND"] = true,
	["SET_FRIENDNOTE"] = true,
	["SET_BNFRIENDNOTE"] = true,
	["ADD_IGNORE"] = true,
	["ADD_MUTE"] = true,
	["ADD_TEAMMEMBER"] = true,
	["ADD_GUILDMEMBER"] = true,
	["ADD_RAIDMEMBER"] = true,
	["CONVERT_TO_RAID"] = true,
	["REMOVE_GUILDMEMBER"] = true,
	["SET_GUILDPLAYERNOTE"] = true,
	["SET_GUILDOFFICERNOTE"] = true,
	["RENAME_PET"] = true,
	["DUEL_REQUESTED"] = true,
	["DUEL_OUTOFBOUNDS"] = true,
	["PET_BATTLE_PVP_DUEL_REQUESTED"] = true,
	["PET_BATTLE_QUEUE_PROPOSE_MATCH"] = true,
	["UNLEARN_SKILL"] = true,
	["UNLEARN_SPECIALIZATION"] = true,
	["XP_LOSS"] = true,
	["XP_LOSS_NO_DURABILITY"] = true,
	["XP_LOSS_NO_SICKNESS"] = true,
	["XP_LOSS_NO_SICKNESS_NO_DURABILITY"] = true,
	["RECOVER_CORPSE"] = true,
	["RECOVER_CORPSE_INSTANCE"] = true,
	["AREA_SPIRIT_HEAL"] = true,
	["BIND_ENCHANT"] = true,
	["REPLACE_ENCHANT"] = true,
	["TRADE_REPLACE_ENCHANT"] = true,
	["TRADE_POTENTIAL_BIND_ENCHANT"] = true,
	["END_BOUND_TRADEABLE"] = true,
	["INSTANCE_BOOT"] = true,
	["INSTANCE_LOCK"] = true,
	["CONFIRM_TALENT_WIPE"] = true,
	["CONFIRM_BINDER"] = true,
	["CONFIRM_SUMMON"] = true,
	["BILLING_NAG"] = true,
	["IGR_BILLING_NAG"] = true,
	["CONFIRM_LOOT_ROLL"] = true,
	["GOSSIP_CONFIRM"] = true,
	["GOSSIP_ENTER_CODE"] = true,
	["CREATE_COMBAT_FILTER"] = true,
	["COPY_COMBAT_FILTER"] = true,
	["CONFIRM_COMBAT_FILTER_DELETE"] = true,
	["CONFIRM_COMBAT_FILTER_DEFAULTS"] = true,
	["WOW_MOUSE_NOT_FOUND"] = true,
	["CONFIRM_TEAM_DISBAND"] = true,
	["CONFIRM_BUY_STABLE_SLOT"] = true,
	["TALENTS_INVOLUNTARILY_RESET"] = true,
	["TALENTS_INVOLUNTARILY_RESET_PET"] = true,
	["VOTE_BOOT_PLAYER"] = true,
	["VOTE_BOOT_REASON_REQUIRED"] = true,
	["LAG_SUCCESS"] = true,
	["LFG_OFFER_CONTINUE"] = true,
	["CONFIRM_MAIL_ITEM_UNREFUNDABLE"] = true,
	["AUCTION_HOUSE_DISABLED"] = true,
	["CONFIRM_BLOCK_INVITES"] = true,
	["BATTLENET_UNAVAILABLE"] = true,
	["CONFIRM_BNET_REPORT"] = true,
	["CONFIRM_REMOVE_FRIEND"] = true,
	["PICKUP_MONEY"] = true,
	["CONFIRM_GUILD_CHARTER_SIGNATURE"] = true,
	["CONFIRM_GUILD_CHARTER_PURCHASE"] = true,
	["GUILD_DEMOTE_CONFIRM"] = true,
	["GUILD_PROMOTE_CONFIRM"] = true,
	["CONFIRM_RANK_AUTHENTICATOR_REMOVE"] = true,
	["VOID_DEPOSIT_CONFIRM"] = true,
	["TRANSMOGRIFY_BIND_CONFIRM"] = true,
	["GUILD_IMPEACH"] = true,
	["SPELL_CONFIRMATION_PROMPT" ] = true,
	["CONFIRM_LAUNCH_URL"] = true,

	["BUYOUT_AUCTION"] = true,
	["BID_AUCTION"] = true,
	["CANCEL_AUCTION"] = true,

	["CONFIRM_DELETING_CHARACTER_SPECIFIC_BINDINGS"] = true,
	["CONFIRM_LOSE_BINDING_CHANGES"] = true,

	["BID_BLACKMARKET"] = true,

	["CALENDAR_DELETE_EVENT"] = true,
	["CALENDAR_ERROR"] = true,

	["PET_BATTLE_FORFEIT"] = true,

	["BATTLE_PET_RENAM"] = true,
	["BATTLE_PET_PUT_IN_CAGE"] = true,
	["BATTLE_PET_RELEASE"] = true,

	["CONFIRM_LEARN_TALENTS"] = true,
	["CONFIRM_REMOVE_TALEN"] = true,
	["CONFIRM_UNLEARN_AND_SWITCH_TALENT"] = true,
	["CONFIRM_LEARN_SPEC"] = true,
	["CONFIRM_EXIT_WITH_UNSPENT_TALENT_POINTS"] = true,

	["CONFIRM_PROFESSION"] = true,
}

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
			R:Print("你的插件調用了UIFrameFlash，導致你可能無法切換天賦，請修改對應代碼。")
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