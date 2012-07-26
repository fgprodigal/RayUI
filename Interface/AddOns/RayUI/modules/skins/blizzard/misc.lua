local R, L, P = unpack(select(2, ...)) --Inport: Engine, Locales, ProfileDB
local S = R:GetModule("Skins")

local function LoadSkin()
	GameFontBlackMedium:SetTextColor(1, 1, 1)
	InvoiceTextFontNormal:SetTextColor(1, 1, 1)
	InvoiceTextFontSmall:SetTextColor(1, 1, 1)
	AvailableServicesText:SetTextColor(1, 1, 1)
	AvailableServicesText:SetShadowColor(0, 0, 0)

	local BlizzardMenuButtons = {
		"Options", 
		"SoundOptions", 
		"UIOptions", 
		"Keybindings", 
		"Macros",
		"Ratings",
		"AddOns", 
		"Logout", 
		"Quit", 
		"Continue", 
		"MacOptions",
		"Help"
	}

	for i = 1, getn(BlizzardMenuButtons) do
		local MenuButtons = _G["GameMenuButton"..BlizzardMenuButtons[i]]
		if MenuButtons then
			local a1,f,a2,xx,yy = MenuButtons:GetPoint()
			MenuButtons:ClearAllPoints()
			MenuButtons:SetPoint(a1,f,a2,xx,yy-1)
			GameMenuFrame:SetHeight(GameMenuFrame:GetHeight()+1)
		end
	end

	for i = 1, 3 do
		for j = 1, 3 do
			S:Reskin(_G["StaticPopup"..i.."Button"..j])
		end
		local bu = _G["StaticPopup"..i.."ItemFrame"]
		_G["StaticPopup"..i.."ItemFrameNameFrame"]:Hide()
		_G["StaticPopup"..i.."ItemFrameIconTexture"]:SetTexCoord(.08, .92, .08, .92)

		bu:StyleButton(true)
		S:CreateBG(bu)

		S:ReskinInput(_G["StaticPopup"..i.."EditBox"], 20)
	end

	local inputs = {
		"StaticPopup1MoneyInputFrameGold",
		"StaticPopup1MoneyInputFrameSilver",
		"StaticPopup1MoneyInputFrameCopper",
		"StaticPopup2MoneyInputFrameGold",
		"StaticPopup2MoneyInputFrameSilver",
		"StaticPopup2MoneyInputFrameCopper",
		"StaticPopup3MoneyInputFrameGold",
		"StaticPopup3MoneyInputFrameSilver",
		"StaticPopup3MoneyInputFrameCopper",
		"BagItemSearchBox",
		"BankItemSearchBox"
	}
	for i = 1, #inputs do
		input = _G[inputs[i]]
		S:ReskinInput(input)
	end

	StaticPopup1MoneyInputFrameSilver:SetPoint("LEFT", StaticPopup1MoneyInputFrameGold, "RIGHT", 1, 0)
	StaticPopup1MoneyInputFrameCopper:SetPoint("LEFT", StaticPopup1MoneyInputFrameSilver, "RIGHT", 1, 0)
	StaticPopup2MoneyInputFrameSilver:SetPoint("LEFT", StaticPopup2MoneyInputFrameGold, "RIGHT", 1, 0)
	StaticPopup2MoneyInputFrameCopper:SetPoint("LEFT", StaticPopup2MoneyInputFrameSilver, "RIGHT", 1, 0)
	StaticPopup3MoneyInputFrameSilver:SetPoint("LEFT", StaticPopup3MoneyInputFrameGold, "RIGHT", 1, 0)
	StaticPopup3MoneyInputFrameCopper:SetPoint("LEFT", StaticPopup3MoneyInputFrameSilver, "RIGHT", 1, 0)
	StackSplitFrame:GetRegions():Hide()

	local buttons = {
		"VideoOptionsFrameOkay",
		"VideoOptionsFrameCancel",
		"VideoOptionsFrameDefaults",
		"VideoOptionsFrameApply",
		"AudioOptionsFrameOkay",
		"AudioOptionsFrameCancel",
		"AudioOptionsFrameDefaults",
		"InterfaceOptionsFrameDefaults",
		"InterfaceOptionsFrameOkay",
		"InterfaceOptionsFrameCancel",
		"ChatConfigFrameOkayButton",
		"ChatConfigFrameDefaultButton",
		"StackSplitOkayButton",
		"StackSplitCancelButton",
		"GameMenuButtonHelp",
		"GameMenuButtonOptions",
		"GameMenuButtonUIOptions",
		"GameMenuButtonKeybindings",
		"GameMenuButtonMacros",
		"GameMenuButtonLogout",
		"GameMenuButtonQuit",
		"GameMenuButtonContinue",
		"GameMenuButtonMacOptions",
		"ColorPickerOkayButton",
		"ColorPickerCancelButton",
		"GuildInviteFrameJoinButton",
		"GuildInviteFrameDeclineButton",
		"RolePollPopupAcceptButton",
		"GhostFrame",
		"InterfaceOptionsHelpPanelResetTutorials"
	}

	for i = 1, #buttons do
		local button = _G[buttons[i]]
		S:Reskin(button)
	end

	S:ReskinClose(RolePollPopupCloseButton)
	S:ReskinClose(ItemRefCloseButton)

	local FrameBDs = {
			"StaticPopup1",
			"StaticPopup2",
			"StaticPopup3",
			"GameMenuFrame",
			"InterfaceOptionsFrame",
			"VideoOptionsFrame",
			"AudioOptionsFrame",
			"ChatConfigFrame",
			"StackSplitFrame",
			"AddFriendFrame",
			"FriendsFriendsFrame",
			"ColorPickerFrame",
			"ReadyCheckFrame",
			"RolePollPopup",
			"GuildInviteFrame",
			"ChannelFrameDaughterFrame",
			"LFDRoleCheckPopup",
			"LFGDungeonReadyStatus",
			"LFGDungeonReadyDialog"
		}
	for i = 1, #FrameBDs do
		FrameBD = _G[FrameBDs[i]]
		S:CreateBD(FrameBD)
		S:CreateSD(FrameBD)
	end

	for i = 1, 10 do
		select(i, GuildInviteFrame:GetRegions()):Hide()
	end

	-- [[ Headers ]]
	local header = {
		"GameMenuFrame",
		"InterfaceOptionsFrame",
		"AudioOptionsFrame",
		"VideoOptionsFrame",
		"ChatConfigFrame",
		"ColorPickerFrame"
	}
	for i = 1, #header do
	local title = _G[header[i].."Header"]
		if title then
			title:SetTexture("")
			title:ClearAllPoints()
			if title == _G["GameMenuFrameHeader"] then
				title:SetPoint("TOP", GameMenuFrame, 0, 7)
			else
				title:SetPoint("TOP", header[i], 0, 0)
			end
		end
	end

	-- [[ Simple backdrops ]]
	local bds = {
		"AutoCompleteBox",
		"BNToastFrame",
		"LFGSearchStatus",
		"TicketStatusFrameButton",
		"GearManagerDialogPopup",
		"TokenFramePopup",
		"ReputationDetailFrame",
		"RaidInfoFrame"
	}

	for i = 1, #bds do
		S:CreateBD(_G[bds[i]])
	end

	-- Skin all DropDownList[i]
	local function SkinDropDownList(level, index)
		for i = 1, UIDROPDOWNMENU_MAXLEVELS do
			local dropdown = _G["DropDownList"..i.."MenuBackdrop"]
			if not dropdown.isSkinned then
				S:CreateBD(dropdown)
				dropdown.isSkinned = true
			end
			dropdown = _G["DropDownList"..i.."Backdrop"]
			if not dropdown.isSkinned then
				S:CreateBD(dropdown)
				dropdown.isSkinned = true
			end
		end
	end
	hooksecurefunc("UIDropDownMenu_CreateFrames", SkinDropDownList)

	-- Ghost frame
	GhostFrameContentsFrameIcon:SetTexCoord(.08, .92, .08, .92)
	GhostFrameLeft:Hide()
	GhostFrameRight:Hide()
	GhostFrameMiddle:Hide()
	for i = 3, 6 do
		select(i, GhostFrame:GetRegions()):Hide()
	end

	local GhostBD = CreateFrame("Frame", nil, GhostFrameContentsFrame)
	GhostBD:SetPoint("TOPLEFT", GhostFrameContentsFrameIcon, -1, 1)
	GhostBD:SetPoint("BOTTOMRIGHT", GhostFrameContentsFrameIcon, 1, -1)
	S:CreateBD(GhostBD, 0)

	-- Option panels
	local line = VideoOptionsFrame:CreateTexture(nil, "ARTWORK")
	line:Size(1, 536)
	line:SetPoint("LEFT", 205, 18)
	line:SetTexture(1, 1, 1, .2)

	S:CreateBD(AudioOptionsSoundPanelPlayback, .25)
	S:CreateBD(AudioOptionsSoundPanelHardware, .25)
	S:CreateBD(AudioOptionsSoundPanelVolume, .25)
	S:CreateBD(AudioOptionsVoicePanelTalking, .25)
	S:CreateBD(AudioOptionsVoicePanelBinding, .25)
	S:CreateBD(AudioOptionsVoicePanelListening, .25)

	AudioOptionsSoundPanelPlaybackTitle:SetPoint("BOTTOMLEFT", AudioOptionsSoundPanelPlayback, "TOPLEFT", 5, 2)
	AudioOptionsSoundPanelHardwareTitle:SetPoint("BOTTOMLEFT", AudioOptionsSoundPanelHardware, "TOPLEFT", 5, 2)
	AudioOptionsSoundPanelVolumeTitle:SetPoint("BOTTOMLEFT", AudioOptionsSoundPanelVolume, "TOPLEFT", 5, 2)
	AudioOptionsVoicePanelTalkingTitle:SetPoint("BOTTOMLEFT", AudioOptionsVoicePanelTalking, "TOPLEFT", 5, 2)
	AudioOptionsVoicePanelListeningTitle:SetPoint("BOTTOMLEFT", AudioOptionsVoicePanelListening, "TOPLEFT", 5, 2)

	local dropdowns = {
		"Graphics_DisplayModeDropDown",
		"Graphics_ResolutionDropDown",
		"Graphics_RefreshDropDown",
		"Graphics_PrimaryMonitorDropDown",
		"Graphics_MultiSampleDropDown",
		"Graphics_VerticalSyncDropDown",
		"Graphics_TextureResolutionDropDown",
		"Graphics_FilteringDropDown",
		"Graphics_ProjectedTexturesDropDown",
		"Graphics_ShadowsDropDown",
		"Graphics_LiquidDetailDropDown",
		"Graphics_SunshaftsDropDown",
		"Graphics_ParticleDensityDropDown",
		"Graphics_ViewDistanceDropDown",
		"Graphics_EnvironmentalDetailDropDown",
		"Graphics_GroundClutterDropDown",
		"Advanced_BufferingDropDown",
		"Advanced_LagDropDown",
		"Advanced_HardwareCursorDropDown",
		"AudioOptionsSoundPanelHardwareDropDown",
		"AudioOptionsSoundPanelSoundChannelsDropDown",
		"AudioOptionsVoicePanelInputDeviceDropDown",
		"AudioOptionsVoicePanelChatModeDropDown",
		"AudioOptionsVoicePanelOutputDeviceDropDown"
		}
	for i = 1, #dropdowns do
		S:ReskinDropDown(_G[dropdowns[i]])
	end

	Graphics_RightQuality:GetRegions():Hide()
	Graphics_RightQuality:DisableDrawLayer("BORDER")

	local sliders = {
		"Graphics_Quality",
		"Advanced_UIScaleSlider",
		"Advanced_MaxFPSSlider",
		"Advanced_MaxFPSBKSlider",
		"Advanced_GammaSlider",
		"AudioOptionsSoundPanelSoundQuality",
		"AudioOptionsSoundPanelMasterVolume",
		"AudioOptionsSoundPanelSoundVolume",
		"AudioOptionsSoundPanelMusicVolume",
		"AudioOptionsSoundPanelAmbienceVolume",
		"AudioOptionsVoicePanelMicrophoneVolume",
		"AudioOptionsVoicePanelSpeakerVolume",
		"AudioOptionsVoicePanelSoundFade",
		"AudioOptionsVoicePanelMusicFade",
		"AudioOptionsVoicePanelAmbienceFade"
	}
	for i = 1, #sliders do
		S:ReskinSlider(_G[sliders[i]])
	end

	Graphics_Quality.SetBackdrop = R.dummy

	local checkboxes = {
		"Advanced_UseUIScale",
		"Advanced_MaxFPSCheckBox",
		"Advanced_MaxFPSBKCheckBox",
		"Advanced_DesktopGamma",
		"NetworkOptionsPanelOptimizeSpeed",
		"NetworkOptionsPanelUseIPv6",
		"AudioOptionsSoundPanelEnableSound",
		"AudioOptionsSoundPanelSoundEffects",
		"AudioOptionsSoundPanelErrorSpeech",
		"AudioOptionsSoundPanelEmoteSounds",
		"AudioOptionsSoundPanelPetSounds",
		"AudioOptionsSoundPanelMusic",
		"AudioOptionsSoundPanelLoopMusic",
		"AudioOptionsSoundPanelAmbientSounds",
		"AudioOptionsSoundPanelSoundInBG",
		"AudioOptionsSoundPanelReverb",
		"AudioOptionsSoundPanelHRTF",
		"AudioOptionsSoundPanelEnableDSPs",
		"AudioOptionsSoundPanelUseHardware",
		"AudioOptionsVoicePanelEnableVoice",
		"AudioOptionsVoicePanelEnableMicrophone",
		"AudioOptionsVoicePanelPushToTalkSound"
	}
	for i = 1, #checkboxes do
		S:ReskinCheck(_G[checkboxes[i]])
	end

	S:Reskin(RecordLoopbackSoundButton)
	S:Reskin(PlayLoopbackSoundButton)
	S:Reskin(AudioOptionsVoicePanelChatMode1KeyBindingButton)

	local line = InterfaceOptionsFrame:CreateTexture(nil, "ARTWORK")
	line:Size(1, 536)
	line:SetPoint("LEFT", 205, 18)
	line:SetTexture(1, 1, 1, .2)

	local checkboxes = {
		"InterfaceOptionsControlsPanelStickyTargeting",
		"InterfaceOptionsControlsPanelAutoDismount",
		"InterfaceOptionsControlsPanelAutoClearAFK",
		"InterfaceOptionsControlsPanelBlockTrades",
		"InterfaceOptionsControlsPanelBlockGuildInvites",
		"InterfaceOptionsControlsPanelLootAtMouse",
		"InterfaceOptionsControlsPanelAutoLootCorpse",
		"InterfaceOptionsControlsPanelInteractOnLeftClick",
		"InterfaceOptionsCombatPanelAttackOnAssist",
		"InterfaceOptionsCombatPanelStopAutoAttack",
		"InterfaceOptionsCombatPanelNameplateClassColors",
		"InterfaceOptionsCombatPanelTargetOfTarget",
		"InterfaceOptionsCombatPanelShowSpellAlerts",
		"InterfaceOptionsCombatPanelReducedLagTolerance",
		"InterfaceOptionsCombatPanelActionButtonUseKeyDown",
		"InterfaceOptionsCombatPanelEnemyCastBarsOnPortrait",
		"InterfaceOptionsCombatPanelEnemyCastBarsOnNameplates",
		"InterfaceOptionsCombatPanelAutoSelfCast",
		"InterfaceOptionsDisplayPanelShowCloak",
		"InterfaceOptionsDisplayPanelShowHelm",
		"InterfaceOptionsDisplayPanelShowAggroPercentage",
		"InterfaceOptionsDisplayPanelPlayAggroSounds",
		"InterfaceOptionsDisplayPanelDetailedLootInfo",
		"InterfaceOptionsDisplayPanelShowSpellPointsAvg",
		"InterfaceOptionsDisplayPanelemphasizeMySpellEffects",
		"InterfaceOptionsDisplayPanelShowFreeBagSpace",
		"InterfaceOptionsDisplayPanelCinematicSubtitles",
		"InterfaceOptionsDisplayPanelRotateMinimap",
		"InterfaceOptionsDisplayPanelScreenEdgeFlash",
		"InterfaceOptionsObjectivesPanelAutoQuestTracking",
		"InterfaceOptionsObjectivesPanelAutoQuestProgress",
		"InterfaceOptionsObjectivesPanelMapQuestDifficulty",
		"InterfaceOptionsObjectivesPanelWatchFrameWidth",
		"InterfaceOptionsSocialPanelProfanityFilter",
		"InterfaceOptionsSocialPanelSpamFilter",
		"InterfaceOptionsSocialPanelChatBubbles",
		"InterfaceOptionsSocialPanelPartyChat",
		"InterfaceOptionsSocialPanelChatHoverDelay",
		"InterfaceOptionsSocialPanelGuildMemberAlert",
		"InterfaceOptionsSocialPanelChatMouseScroll",
		"InterfaceOptionsActionBarsPanelBottomLeft",
		"InterfaceOptionsActionBarsPanelBottomRight",
		"InterfaceOptionsActionBarsPanelRight",
		"InterfaceOptionsActionBarsPanelRightTwo",
		"InterfaceOptionsActionBarsPanelLockActionBars",
		"InterfaceOptionsActionBarsPanelAlwaysShowActionBars",
		"InterfaceOptionsActionBarsPanelSecureAbilityToggle",
		"InterfaceOptionsNamesPanelMyName",
		"InterfaceOptionsNamesPanelFriendlyPlayerNames",
		"InterfaceOptionsNamesPanelFriendlyPets",
		"InterfaceOptionsNamesPanelFriendlyGuardians",
		"InterfaceOptionsNamesPanelFriendlyTotems",
		"InterfaceOptionsNamesPanelUnitNameplatesFriends",
		"InterfaceOptionsNamesPanelUnitNameplatesFriendlyPets",
		"InterfaceOptionsNamesPanelUnitNameplatesFriendlyGuardians",
		"InterfaceOptionsNamesPanelUnitNameplatesFriendlyTotems",
		"InterfaceOptionsNamesPanelGuilds",
		"InterfaceOptionsNamesPanelGuildTitles",
		"InterfaceOptionsNamesPanelTitles",
		"InterfaceOptionsNamesPanelNonCombatCreature",
		"InterfaceOptionsNamesPanelEnemyPlayerNames",
		"InterfaceOptionsNamesPanelEnemyPets",
		"InterfaceOptionsNamesPanelEnemyGuardians",
		"InterfaceOptionsNamesPanelEnemyTotems",
		"InterfaceOptionsNamesPanelUnitNameplatesEnemies",
		"InterfaceOptionsNamesPanelUnitNameplatesEnemyPets",
		"InterfaceOptionsNamesPanelUnitNameplatesEnemyGuardians",
		"InterfaceOptionsNamesPanelUnitNameplatesEnemyTotems",
		"InterfaceOptionsCombatTextPanelTargetDamage",
		"InterfaceOptionsCombatTextPanelPeriodicDamage",
		"InterfaceOptionsCombatTextPanelPetDamage",
		"InterfaceOptionsCombatTextPanelHealing",
		"InterfaceOptionsCombatTextPanelTargetEffects",
		"InterfaceOptionsCombatTextPanelOtherTargetEffects",
		"InterfaceOptionsCombatTextPanelEnableFCT",
		"InterfaceOptionsCombatTextPanelDodgeParryMiss",
		"InterfaceOptionsCombatTextPanelDamageReduction",
		"InterfaceOptionsCombatTextPanelRepChanges",
		"InterfaceOptionsCombatTextPanelReactiveAbilities",
		"InterfaceOptionsCombatTextPanelFriendlyHealerNames",
		"InterfaceOptionsCombatTextPanelCombatState",
		"InterfaceOptionsCombatTextPanelComboPoints",
		"InterfaceOptionsCombatTextPanelLowManaHealth",
		"InterfaceOptionsCombatTextPanelEnergyGains",
		"InterfaceOptionsCombatTextPanelPeriodicEnergyGains",
		"InterfaceOptionsCombatTextPanelHonorGains",
		"InterfaceOptionsCombatTextPanelAuras",
		"InterfaceOptionsStatusTextPanelPlayer",
		"InterfaceOptionsStatusTextPanelPet",
		"InterfaceOptionsStatusTextPanelParty",
		"InterfaceOptionsStatusTextPanelTarget",
		"InterfaceOptionsStatusTextPanelAlternateResource",
		"InterfaceOptionsStatusTextPanelPercentages",
		"InterfaceOptionsStatusTextPanelXP",
		"InterfaceOptionsUnitFramePanelPartyBackground",
		"InterfaceOptionsUnitFramePanelPartyPets",
		"InterfaceOptionsUnitFramePanelArenaEnemyFrames",
		"InterfaceOptionsUnitFramePanelArenaEnemyCastBar",
		"InterfaceOptionsUnitFramePanelArenaEnemyPets",
		"InterfaceOptionsUnitFramePanelFullSizeFocusFrame",
		"CompactUnitFrameProfilesRaidStylePartyFrames",
		"CompactUnitFrameProfilesGeneralOptionsFrameKeepGroupsTogether",
		"CompactUnitFrameProfilesGeneralOptionsFrameHorizontalGroups",
		"CompactUnitFrameProfilesGeneralOptionsFrameDisplayIncomingHeals",
		"CompactUnitFrameProfilesGeneralOptionsFrameDisplayPowerBar",
		"CompactUnitFrameProfilesGeneralOptionsFrameDisplayAggroHighlight",
		"CompactUnitFrameProfilesGeneralOptionsFrameUseClassColors",
		"CompactUnitFrameProfilesGeneralOptionsFrameDisplayPets",
		"CompactUnitFrameProfilesGeneralOptionsFrameDisplayMainTankAndAssist",
		"CompactUnitFrameProfilesGeneralOptionsFrameDisplayBorder",
		"CompactUnitFrameProfilesGeneralOptionsFrameShowDebuffs",
		"CompactUnitFrameProfilesGeneralOptionsFrameDisplayOnlyDispellableDebuffs",
		"CompactUnitFrameProfilesGeneralOptionsFrameAutoActivate2Players",
		"CompactUnitFrameProfilesGeneralOptionsFrameAutoActivate3Players",
		"CompactUnitFrameProfilesGeneralOptionsFrameAutoActivate5Players",
		"CompactUnitFrameProfilesGeneralOptionsFrameAutoActivate10Players",
		"CompactUnitFrameProfilesGeneralOptionsFrameAutoActivate15Players",
		"CompactUnitFrameProfilesGeneralOptionsFrameAutoActivate25Players",
		"CompactUnitFrameProfilesGeneralOptionsFrameAutoActivate40Players",
		"CompactUnitFrameProfilesGeneralOptionsFrameAutoActivateSpec1",
		"CompactUnitFrameProfilesGeneralOptionsFrameAutoActivateSpec2",
		"CompactUnitFrameProfilesGeneralOptionsFrameAutoActivatePvP",
		"CompactUnitFrameProfilesGeneralOptionsFrameAutoActivatePvE",
		"InterfaceOptionsBuffsPanelBuffDurations",
		"InterfaceOptionsBuffsPanelDispellableDebuffs",
		"InterfaceOptionsBuffsPanelCastableBuffs",
		"InterfaceOptionsBuffsPanelConsolidateBuffs",
		"InterfaceOptionsBuffsPanelShowAllEnemyDebuffs",
		"InterfaceOptionsBattlenetPanelOnlineFriends",
		"InterfaceOptionsBattlenetPanelOfflineFriends",
		"InterfaceOptionsBattlenetPanelBroadcasts",
		"InterfaceOptionsBattlenetPanelFriendRequests",
		"InterfaceOptionsBattlenetPanelConversations",
		"InterfaceOptionsBattlenetPanelShowToastWindow",
		"InterfaceOptionsCameraPanelFollowTerrain",
		"InterfaceOptionsCameraPanelHeadBob",
		"InterfaceOptionsCameraPanelWaterCollision",
		"InterfaceOptionsCameraPanelSmartPivot",
		"InterfaceOptionsMousePanelInvertMouse",
		"InterfaceOptionsMousePanelClickToMove",
		"InterfaceOptionsMousePanelWoWMouse",
		"InterfaceOptionsHelpPanelShowTutorials",
		"InterfaceOptionsHelpPanelLoadingScreenTips",
		"InterfaceOptionsHelpPanelEnhancedTooltips",
		"InterfaceOptionsHelpPanelBeginnerTooltips",
		"InterfaceOptionsHelpPanelShowLuaErrors",
		"InterfaceOptionsHelpPanelColorblindMode",
		"InterfaceOptionsHelpPanelMovePad"
	}
	for i = 1, #checkboxes do
		S:ReskinCheck(_G[checkboxes[i]])
	end

	local dropdowns = {
		"InterfaceOptionsControlsPanelAutoLootKeyDropDown",
		"InterfaceOptionsCombatPanelTOTDropDown",
		"InterfaceOptionsCombatPanelFocusCastKeyDropDown",
		"InterfaceOptionsCombatPanelSelfCastKeyDropDown",
		"InterfaceOptionsDisplayPanelAggroWarningDisplay",
		"InterfaceOptionsDisplayPanelWorldPVPObjectiveDisplay",
		"InterfaceOptionsSocialPanelChatStyle",
		"InterfaceOptionsSocialPanelTimestamps",
		"InterfaceOptionsSocialPanelWhisperMode",
		"InterfaceOptionsSocialPanelBnWhisperMode",
		"InterfaceOptionsSocialPanelConversationMode",
		"InterfaceOptionsActionBarsPanelPickupActionKeyDropDown",
		"InterfaceOptionsNamesPanelNPCNamesDropDown",
		"InterfaceOptionsNamesPanelUnitNameplatesMotionDropDown",
		"InterfaceOptionsCombatTextPanelFCTDropDown",
		"CompactUnitFrameProfilesProfileSelector",
		"CompactUnitFrameProfilesGeneralOptionsFrameSortByDropdown",
		"CompactUnitFrameProfilesGeneralOptionsFrameHealthTextDropdown",
		"InterfaceOptionsCameraPanelStyleDropDown",
		"InterfaceOptionsMousePanelClickMoveStyleDropDown",
		"Advanced_GraphicsAPIDropDown"
	}
	for i = 1, #dropdowns do
		S:ReskinDropDown(_G[dropdowns[i]])
	end

	local sliders = {
		"InterfaceOptionsCombatPanelSpellAlertOpacitySlider",
		"InterfaceOptionsCombatPanelMaxSpellStartRecoveryOffset",
		"CompactUnitFrameProfilesGeneralOptionsFrameHeightSlider",
		"CompactUnitFrameProfilesGeneralOptionsFrameWidthSlider",
		"InterfaceOptionsBattlenetPanelToastDurationSlider",
		"InterfaceOptionsCameraPanelMaxDistanceSlider",
		"InterfaceOptionsCameraPanelFollowSpeedSlider",
		"InterfaceOptionsMousePanelMouseSensitivitySlider",
		"InterfaceOptionsMousePanelMouseLookSpeedSlider"
	}
	for i = 1, #sliders do
		S:ReskinSlider(_G[sliders[i]])
	end

	S:Reskin(CompactUnitFrameProfilesSaveButton)
	S:Reskin(CompactUnitFrameProfilesDeleteButton)
	S:Reskin(CompactUnitFrameProfilesGeneralOptionsFrameResetPositionButton)
	S:Reskin(InterfaceOptionsHelpPanelResetTutorials)

	CompactUnitFrameProfilesGeneralOptionsFrameAutoActivateBG:Hide()

	VideoOptionsFrameCategoryFrame:DisableDrawLayer("BACKGROUND")
	InterfaceOptionsFrameCategories:DisableDrawLayer("BACKGROUND")
	InterfaceOptionsFrameAddOns:DisableDrawLayer("BACKGROUND")
	VideoOptionsFramePanelContainer:DisableDrawLayer("BORDER")
	InterfaceOptionsFramePanelContainer:DisableDrawLayer("BORDER")
	InterfaceOptionsFrameTab1TabSpacer:SetAlpha(0)
	for i = 1, 2 do
		_G["InterfaceOptionsFrameTab"..i.."Left"]:SetAlpha(0)
		_G["InterfaceOptionsFrameTab"..i.."Middle"]:SetAlpha(0)
		_G["InterfaceOptionsFrameTab"..i.."Right"]:SetAlpha(0)
		_G["InterfaceOptionsFrameTab"..i.."LeftDisabled"]:SetAlpha(0)
		_G["InterfaceOptionsFrameTab"..i.."MiddleDisabled"]:SetAlpha(0)
		_G["InterfaceOptionsFrameTab"..i.."RightDisabled"]:SetAlpha(0)
		_G["InterfaceOptionsFrameTab2TabSpacer"..i]:SetAlpha(0)
	end
	VideoOptionsFrameOkay:SetPoint("BOTTOMRIGHT", VideoOptionsFrameCancel, "BOTTOMLEFT", -1, 0)
	InterfaceOptionsFrameOkay:SetPoint("BOTTOMRIGHT", InterfaceOptionsFrameCancel, "BOTTOMLEFT", -1, 0)

	local lightbds = {
		"ChatConfigCategoryFrame",
		"ChatConfigBackgroundFrame",
		"ChatConfigChatSettingsLeft",
		"ChatConfigChatSettingsClassColorLegend",
		"ChatConfigChannelSettingsLeft",
		"ChatConfigChannelSettingsClassColorLegend",
		"ChatConfigOtherSettingsCombat",
		"ChatConfigOtherSettingsSystem",
		"ChatConfigOtherSettingsPVP",
		"ChatConfigOtherSettingsCreature",
		"HelpFrameTicketScrollFrame",
		"HelpFrameGM_ResponseScrollFrame1",
		"HelpFrameGM_ResponseScrollFrame2",
		"GuildRegistrarFrameEditBox",
	}
	for i = 1, #lightbds do
		S:CreateBD(_G[lightbds[i]], .25)
	end

	--实名好友弹窗位置
	BNToastFrameCloseButton:SetAlpha(0)
	BNToastFrame:HookScript("OnShow", function(self)
		self:ClearAllPoints()
		if TempEnchant1:IsShown() or TempEnchant2:IsShown() then
			self:SetPoint("TOPLEFT", Minimap, "BOTTOMLEFT", -3, -60)
		elseif RaidBuffReminder and RaidBuffReminder:IsShown() then
			self:SetPoint("TOPLEFT", RaidBuffReminder, "BOTTOMLEFT", -3, -6)
		else
			self:SetPoint("TOPLEFT", Minimap, "BOTTOMLEFT", -3, -6)
		end
	end)

	ChatConfigFrameDefaultButton:SetWidth(125)
	ChatConfigFrameDefaultButton:SetPoint("TOPLEFT", ChatConfigCategoryFrame, "BOTTOMLEFT", 0, -4)
	ChatConfigFrameOkayButton:SetPoint("TOPRIGHT", ChatConfigBackgroundFrame, "BOTTOMRIGHT", 0, -4)

	if IsMacClient() then
		S:CreateBD(MacOptionsFrame)
		MacOptionsFrameHeader:SetTexture("")
		MacOptionsFrameHeader:ClearAllPoints()
		MacOptionsFrameHeader:SetPoint("TOP", MacOptionsFrame, 0, 0)
	 
		S:CreateBD(MacOptionsFrameMovieRecording, .25)
		S:CreateBD(MacOptionsITunesRemote, .25)

		S:Reskin(MacOptionsButtonKeybindings)
		S:Reskin(MacOptionsButtonCompress)
		S:Reskin(MacOptionsFrameCancel)
		S:Reskin(MacOptionsFrameOkay)
		S:Reskin(MacOptionsFrameDefaults)

		S:ReskinDropDown(MacOptionsFrameResolutionDropDown)
		S:ReskinDropDown(MacOptionsFrameFramerateDropDown)
		S:ReskinDropDown(MacOptionsFrameCodecDropDown)
		for i = 1, 10 do
			if _G["MacOptionsFrameCheckButton"..i] then
				S:ReskinCheck(_G["MacOptionsFrameCheckButton"..i])
			end
		end
		S:ReskinSlider(MacOptionsFrameQualitySlider)
	 
		MacOptionsButtonCompress:SetWidth(136)
	 
		MacOptionsFrameCancel:SetWidth(96)
		MacOptionsFrameCancel:SetHeight(22)
		MacOptionsFrameCancel:ClearAllPoints()
		MacOptionsFrameCancel:SetPoint("LEFT", MacOptionsButtonKeybindings, "RIGHT", 107, 0)
	 
		MacOptionsFrameOkay:SetWidth(96)
		MacOptionsFrameOkay:SetHeight(22)
		MacOptionsFrameOkay:ClearAllPoints()
		MacOptionsFrameOkay:SetPoint("LEFT", MacOptionsButtonKeybindings, "RIGHT", 5, 0)
	 
		MacOptionsButtonKeybindings:SetWidth(96)
		MacOptionsButtonKeybindings:SetHeight(22)
		MacOptionsButtonKeybindings:ClearAllPoints()
		MacOptionsButtonKeybindings:SetPoint("LEFT", MacOptionsFrameDefaults, "RIGHT", 5, 0)
	 
		MacOptionsFrameDefaults:SetWidth(96)
		MacOptionsFrameDefaults:SetHeight(22)
	end
end

S:RegisterSkin("RayUI", LoadSkin)
