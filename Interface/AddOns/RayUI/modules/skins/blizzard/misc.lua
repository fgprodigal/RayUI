local R, L, P, G = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, GlobalDB
local S = R:GetModule("Skins")

local function LoadSkin()
    local r, g, b = S["media"].classcolours[R.myclass].r, S["media"].classcolours[R.myclass].g, S["media"].classcolours[R.myclass].b
    GameFontBlackMedium:SetTextColor(1, 1, 1)
    InvoiceTextFontNormal:SetTextColor(1, 1, 1)
    InvoiceTextFontSmall:SetTextColor(1, 1, 1)
    AvailableServicesText:SetTextColor(1, 1, 1)
    AvailableServicesText:SetShadowColor(0, 0, 0)

    for i = 1, 4 do
        for j = 1, 3 do
            S:Reskin(_G["StaticPopup"..i.."Button"..j])
        end
        local bu = _G["StaticPopup"..i.."ItemFrame"]
        _G["StaticPopup"..i.."ItemFrameNameFrame"]:Hide()
        _G["StaticPopup"..i.."ItemFrameNormalTexture"]:Hide()
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
        "StaticPopup4MoneyInputFrameGold",
        "StaticPopup4MoneyInputFrameSilver",
        "StaticPopup4MoneyInputFrameCopper",
        "BagItemSearchBox",
        "BankItemSearchBox"
    }
    for i = 1, #inputs do
        local input = _G[inputs[i]]
        S:ReskinInput(input)
    end

    StaticPopup1MoneyInputFrameSilver:SetPoint("LEFT", StaticPopup1MoneyInputFrameGold, "RIGHT", 1, 0)
    StaticPopup1MoneyInputFrameCopper:SetPoint("LEFT", StaticPopup1MoneyInputFrameSilver, "RIGHT", 1, 0)
    StaticPopup2MoneyInputFrameSilver:SetPoint("LEFT", StaticPopup2MoneyInputFrameGold, "RIGHT", 1, 0)
    StaticPopup2MoneyInputFrameCopper:SetPoint("LEFT", StaticPopup2MoneyInputFrameSilver, "RIGHT", 1, 0)
    StaticPopup3MoneyInputFrameSilver:SetPoint("LEFT", StaticPopup3MoneyInputFrameGold, "RIGHT", 1, 0)
    StaticPopup3MoneyInputFrameCopper:SetPoint("LEFT", StaticPopup3MoneyInputFrameSilver, "RIGHT", 1, 0)
    StaticPopup4MoneyInputFrameSilver:SetPoint("LEFT", StaticPopup4MoneyInputFrameGold, "RIGHT", 1, 0)
    StaticPopup4MoneyInputFrameCopper:SetPoint("LEFT", StaticPopup4MoneyInputFrameSilver, "RIGHT", 1, 0)
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
        "InterfaceOptionsSocialPanelTwitterLoginButton",
        "ChatConfigFrameOkayButton",
        "ChatConfigFrameDefaultButton",
        "ChatConfigFrameRedockButton",
        "StackSplitOkayButton",
        "StackSplitCancelButton",
        "GameMenuButtonHelp",
        "GameMenuButtonStore",
        "GameMenuButtonOptions",
        "GameMenuButtonUIOptions",
        "GameMenuButtonKeybindings",
        "GameMenuButtonMacros",
        "GameMenuButtonLogout",
        "GameMenuButtonQuit",
        "GameMenuButtonContinue",
        "GameMenuButtonAddons",
        "GameMenuButtonWhatsNew",
        "ColorPickerOkayButton",
        "ColorPickerCancelButton",
        "GuildInviteFrameJoinButton",
        "GuildInviteFrameDeclineButton",
        "RolePollPopupAcceptButton",
        "GhostFrame",
        "SideDressUpModelResetButton",
        "InterfaceOptionsDisplayPanelResetTutorials",
        "InterfaceOptionsSocialPanelRedockChat"
    }

    for i = 1, #buttons do
        local button = _G[buttons[i]]
        S:Reskin(button)
    end

    S:Reskin(GameMenuFrame.RayUI)

    S:ReskinClose(RolePollPopupCloseButton)
    S:ReskinClose(ItemRefCloseButton)
    S:ReskinClose(FloatingBattlePetTooltip.CloseButton)

    local FrameBDs = {
        "StaticPopup1",
        "StaticPopup2",
        "StaticPopup3",
        "StaticPopup4",
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
        "LFGDungeonReadyDialog",
        "PVPReadyDialog"
    }
    for i = 1, #FrameBDs do
        local FrameBD = _G[FrameBDs[i]]
        S:CreateBD(FrameBD)
        S:CreateSD(FrameBD)
    end

    PVPReadyDialogBackground:Hide()
    PVPReadyDialogBottomArt:Hide()
    PVPReadyDialogFiligree:Hide()

    S:CreateBD(PVPReadyDialog)
    PVPReadyDialog.SetBackdrop = R.dummy
    S:CreateSD(PVPReadyDialog)

    S:Reskin(PVPReadyDialog.enterButton)
    S:Reskin(PVPReadyDialog.leaveButton)
    S:ReskinClose(PVPReadyDialogCloseButton)

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
        "TicketStatusFrameButton",
        "GearManagerDialogPopup",
        "TokenFramePopup",
        "ReputationDetailFrame",
        "RaidInfoFrame",
        "ScrollOfResurrectionSelectionFrame",
        "ScrollOfResurrectionFrame",
        "VoiceChatTalkers",
        "QueueStatusFrame"
    }

    for i = 1, #bds do
        S:CreateBD(_G[bds[i]])
    end

    -- Dropdown lists
    local function SkinDropDownList(level, index)
        for i = 1, UIDROPDOWNMENU_MAXLEVELS do
            local menu = _G["DropDownList"..i.."MenuBackdrop"]
            local backdrop = _G["DropDownList"..i.."Backdrop"]
            if not backdrop.reskinned then
                S:CreateBD(menu)
                S:CreateBD(backdrop)
                S:CreateStripesThin(menu)
                backdrop.reskinned = true
            end
        end
    end
    hooksecurefunc("UIDropDownMenu_InitializeHelper", SkinDropDownList)

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
    line:SetColorTexture(1, 1, 1, .2)

    Display_:SetBackdrop(nil)
    Graphics_:SetBackdrop(nil)
    RaidGraphics_:SetBackdrop(nil)

    GraphicsButton:DisableDrawLayer("BACKGROUND")
    RaidButton:DisableDrawLayer("BACKGROUND")

    local hline = Display_:CreateTexture(nil, "ARTWORK")
    hline:Size(580, 1)
    hline:SetPoint("TOPLEFT", GraphicsButton, "BOTTOMLEFT", 14, -4)
    hline:SetColorTexture(1, 1, 1, .2)

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
        "Display_DisplayModeDropDown",
        "Display_ResolutionDropDown",
        "Display_RefreshDropDown",
        "Display_PrimaryMonitorDropDown",
        "Display_AntiAliasingDropDown",
        "Display_VerticalSyncDropDown",
        "Graphics_TextureResolutionDropDown",
        "Graphics_FilteringDropDown",
        "Graphics_ProjectedTexturesDropDown",
        "Graphics_ShadowsDropDown",
        "Graphics_LiquidDetailDropDown",
        "Graphics_SunshaftsDropDown",
        "Graphics_ParticleDensityDropDown",
        "Graphics_DepthEffectsDropDown",
        "Graphics_SSAODropDown",
        "Graphics_DepthEffectsDropDown",
        "Graphics_LightingQualityDropDown",
        "Graphics_OutlineModeDropDown",
        "RaidGraphics_TextureResolutionDropDown",
        "RaidGraphics_FilteringDropDown",
        "RaidGraphics_ProjectedTexturesDropDown",
        "RaidGraphics_ShadowsDropDown",
        "RaidGraphics_LiquidDetailDropDown",
        "RaidGraphics_SunshaftsDropDown",
        "RaidGraphics_ParticleDensityDropDown",
        "RaidGraphics_SSAODropDown",
        "Advanced_BufferingDropDown",
        "Advanced_LagDropDown",
        "Advanced_HardwareCursorDropDown",
        "Advanced_MultisampleAntiAliasingDropDown",
        "Advanced_MultisampleAlphaTest",
        "Advanced_PostProcessAntiAliasingDropDown",
        "Advanced_ResampleQualityDropDown",
        "Advanced_GraphicsAPIDropDown",
        "Advanced_PhysicsInteractionDropDown",
        "AudioOptionsSoundPanelHardwareDropDown",
        "AudioOptionsSoundPanelSoundChannelsDropDown",
        "AudioOptionsSoundPanelSoundCacheSizeDropDown",
        "AudioOptionsVoicePanelInputDeviceDropDown",
        "AudioOptionsVoicePanelChatModeDropDown",
        "AudioOptionsVoicePanelOutputDeviceDropDown",
        "InterfaceOptionsLanguagesPanelLocaleDropDown",
        "InterfaceOptionsLanguagesPanelAudioLocaleDropDown",
        "InterfaceOptionsControlsPanelAutoLootKeyDropDown",
        "InterfaceOptionsCombatPanelFocusCastKeyDropDown",
        "InterfaceOptionsCombatPanelSelfCastKeyDropDown",
        "InterfaceOptionsDisplayPanelOutlineDropDown",
        "InterfaceOptionsDisplayPanelSelfHighlightDropDown",
        "InterfaceOptionsDisplayPanelDisplayDropDown",
        "InterfaceOptionsDisplayPanelChatBubblesDropDown",
        "InterfaceOptionsSocialPanelChatStyle",
        "InterfaceOptionsSocialPanelTimestamps",
        "InterfaceOptionsSocialPanelWhisperMode",
        "InterfaceOptionsActionBarsPanelPickupActionKeyDropDown",
        "InterfaceOptionsNamesPanelNPCNamesDropDown",
        "InterfaceOptionsNamesPanelUnitNameplatesMotionDropDown",
        "InterfaceOptionsCameraPanelStyleDropDown",
        "InterfaceOptionsMousePanelClickMoveStyleDropDown",
        "InterfaceOptionsAccessibilityPanelColorFilterDropDown",
        "CompactUnitFrameProfilesProfileSelector",
        "CompactUnitFrameProfilesGeneralOptionsFrameSortByDropdown",
        "CompactUnitFrameProfilesGeneralOptionsFrameHealthTextDropdown",
    }
    for i = 1, #dropdowns do
        S:ReskinDropDown(_G[dropdowns[i]])
    end

    local sliders = {
        "Graphics_Quality",
        "Graphics_ViewDistanceSlider",
        "Graphics_EnvironmentalDetailSlider",
        "Graphics_GroundClutterSlider",
        "Advanced_UIScaleSlider",
        "Advanced_MaxFPSSlider",
        "Advanced_MaxFPSBKSlider",
        "Advanced_RenderScaleSlider",
        "Advanced_GammaSlider",
        "AudioOptionsSoundPanelMasterVolume",
        "AudioOptionsSoundPanelSoundVolume",
        "AudioOptionsSoundPanelMusicVolume",
        "AudioOptionsSoundPanelDialogVolume",
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
        "Display_RaidSettingsEnabledCheckBox",
        "Advanced_UseUIScale",
        "Advanced_MaxFPSCheckBox",
        "Advanced_MaxFPSBKCheckBox",
        "Advanced_ShowHDModels",
        "Advanced_DesktopGamma",
        "NetworkOptionsPanelOptimizeSpeed",
        "NetworkOptionsPanelUseIPv6",
        "NetworkOptionsPanelAdvancedCombatLogging",
        "AudioOptionsSoundPanelEnableSound",
        "AudioOptionsSoundPanelSoundEffects",
        "AudioOptionsSoundPanelErrorSpeech",
        "AudioOptionsSoundPanelEmoteSounds",
        "AudioOptionsSoundPanelPetSounds",
        "AudioOptionsSoundPanelMusic",
        "AudioOptionsSoundPanelLoopMusic",
        "AudioOptionsSoundPanelPetBattleMusic",
        "AudioOptionsSoundPanelAmbientSounds",
        "AudioOptionsSoundPanelDialogSounds",
        "AudioOptionsSoundPanelSoundInBG",
        "AudioOptionsSoundPanelReverb",
        "AudioOptionsSoundPanelHRTF",
        "AudioOptionsSoundPanelEnableDSPs",
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
    line:SetColorTexture(1, 1, 1, .2)

    local checkboxes = {
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
        "CompactUnitFrameProfilesGeneralOptionsFrameAutoActivateSpec3",
        "CompactUnitFrameProfilesGeneralOptionsFrameAutoActivateSpec4",
        "CompactUnitFrameProfilesGeneralOptionsFrameAutoActivatePvP",
        "CompactUnitFrameProfilesGeneralOptionsFrameAutoActivatePvE",
        "InterfaceOptionsControlsPanelStickyTargeting",
        "InterfaceOptionsControlsPanelAutoDismount",
        "InterfaceOptionsControlsPanelAutoClearAFK",
        "InterfaceOptionsControlsPanelLootAtMouse",
        "InterfaceOptionsControlsPanelAutoLootCorpse",
        "InterfaceOptionsControlsPanelInteractOnLeftClick",
        "InterfaceOptionsCombatPanelTargetOfTarget",
        "InterfaceOptionsCombatPanelFlashLowHealthWarning",
        "InterfaceOptionsCombatPanelLossOfControl",
        "InterfaceOptionsCombatPanelEnableFloatingCombatText",
        "InterfaceOptionsCombatPanelAutoSelfCast",
        "InterfaceOptionsDisplayPanelRotateMinimap",
        "InterfaceOptionsDisplayPanelAJAlerts",
        "InterfaceOptionsDisplayPanelShowTutorials",
        "InterfaceOptionsSocialPanelProfanityFilter",
        "InterfaceOptionsSocialPanelSpamFilter",
        "InterfaceOptionsSocialPanelGuildMemberAlert",
        "InterfaceOptionsSocialPanelBlockTrades",
        "InterfaceOptionsSocialPanelBlockGuildInvites",
        "InterfaceOptionsSocialPanelBlockChatChannelInvites",
        "InterfaceOptionsSocialPanelShowAccountAchievments",
        "InterfaceOptionsSocialPanelOnlineFriends",
        "InterfaceOptionsSocialPanelOfflineFriends",
        "InterfaceOptionsSocialPanelBroadcasts",
        "InterfaceOptionsSocialPanelFriendRequests",
        "InterfaceOptionsSocialPanelShowToastWindow",
        "InterfaceOptionsSocialPanelEnableTwitter",
        "InterfaceOptionsActionBarsPanelBottomLeft",
        "InterfaceOptionsActionBarsPanelBottomRight",
        "InterfaceOptionsActionBarsPanelRight",
        "InterfaceOptionsActionBarsPanelRightTwo",
        "InterfaceOptionsActionBarsPanelLockActionBars",
        "InterfaceOptionsActionBarsPanelAlwaysShowActionBars",
        "InterfaceOptionsActionBarsPanelCountdownCooldowns",
        "InterfaceOptionsNamesPanelUnitNameplatesEnemyMinus",
        "InterfaceOptionsNamesPanelMyName",
        "InterfaceOptionsNamesPanelNonCombatCreature",
        "InterfaceOptionsNamesPanelFriendlyPlayerNames",
        "InterfaceOptionsNamesPanelFriendlyMinions",
        "InterfaceOptionsNamesPanelEnemyPlayerNames",
        "InterfaceOptionsNamesPanelEnemyMinions",
        "InterfaceOptionsCameraPanelWaterCollision",
        "InterfaceOptionsMousePanelInvertMouse",
        "InterfaceOptionsMousePanelEnableMouseSpeed",
        "InterfaceOptionsMousePanelClickToMove",
        "InterfaceOptionsAccessibilityPanelMovePad",
        "InterfaceOptionsAccessibilityPanelCinematicSubtitles",
        "InterfaceOptionsAccessibilityPanelColorblindMode"
    }
    for i = 1, #checkboxes do
        S:ReskinCheck(_G[checkboxes[i]])
    end

    local sliders = {
        "InterfaceOptionsCombatPanelSpellAlertOpacitySlider",
        "CompactUnitFrameProfilesGeneralOptionsFrameHeightSlider",
        "CompactUnitFrameProfilesGeneralOptionsFrameWidthSlider",
        "InterfaceOptionsCameraPanelFollowSpeedSlider",
        "InterfaceOptionsMousePanelMouseSensitivitySlider",
        "InterfaceOptionsMousePanelMouseLookSpeedSlider",
        "InterfaceOptionsAccessibilityPanelColorblindStrengthSlider"
    }
    for i = 1, #sliders do
        S:ReskinSlider(_G[sliders[i]])
    end

    S:Reskin(CompactUnitFrameProfilesSaveButton)
    S:Reskin(CompactUnitFrameProfilesDeleteButton)
    S:Reskin(CompactUnitFrameProfilesGeneralOptionsFrameResetPositionButton)

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
        "HelpFrameGM_ResponseScrollFrame1",
        "HelpFrameGM_ResponseScrollFrame2",
        "GuildRegistrarFrameEditBox"
    }
    for i = 1, #lightbds do
        S:CreateBD(_G[lightbds[i]], .25)
    end

    S:ReskinClose(BNToastFrameCloseButton)
    ChatConfigFrameDefaultButton:SetWidth(125)
    ChatConfigFrameDefaultButton:SetPoint("TOPLEFT", ChatConfigCategoryFrame, "BOTTOMLEFT", 0, -4)
    ChatConfigFrameRedockButton:SetPoint("TOPLEFT", ChatConfigCategoryFrame, "BOTTOMLEFT", 127, -4)
    ChatConfigFrameOkayButton:SetPoint("TOPRIGHT", ChatConfigBackgroundFrame, "BOTTOMRIGHT", 0, -4)

    TicketStatusFrame:ClearAllPoints()
    TicketStatusFrame:SetPoint("TOP", R.UIParent, "TOP", 0, -20)

    SideDressUpModel:HookScript("OnShow", function(self)
            self:ClearAllPoints()
            self:SetPoint("LEFT", self:GetParent():GetParent(), "RIGHT", 1, 0)
        end)
    SideDressUpModel.bg = CreateFrame("Frame", nil, SideDressUpModel)
    SideDressUpModel.bg:SetPoint("TOPLEFT", 0, 1)
    SideDressUpModel.bg:SetPoint("BOTTOMRIGHT", 1, -1)
    SideDressUpModel.bg:SetFrameLevel(SideDressUpModel:GetFrameLevel()-1)
    S:CreateBD(SideDressUpModel.bg)
    S:Reskin(SideDressUpModelResetButton)
    S:ReskinClose(SideDressUpModelCloseButton)
    select(5, SideDressUpModelCloseButton:GetRegions()):Hide()
    for i = 1, 4 do
        select(i, SideDressUpFrame:GetRegions()):Hide()
    end

    S:ReskinPortraitFrame(AddonList, true)
    S:Reskin(AddonListEnableAllButton)
    S:Reskin(AddonListDisableAllButton)
    S:Reskin(AddonListCancelButton)
    S:Reskin(AddonListOkayButton)
    S:ReskinCheck(AddonListForceLoad)
    S:ReskinDropDown(AddonCharacterDropDown)
    S:ReskinScroll(AddonListScrollFrameScrollBar)

    AddonCharacterDropDown:SetWidth(170)

    for i = 1, MAX_ADDONS_DISPLAYED do
        S:ReskinCheck(_G["AddonListEntry"..i.."Enabled"])
        S:Reskin(_G["AddonListEntry"..i.."Load"])
    end

    -- Navigation Bar
    local function moveNavButtons(self)
        local width = 0
        local collapsedWidth
        local maxWidth = self:GetWidth() - self.widthBuffer

        local lastShown
        local collapsed = false

        for i = #self.navList, 1, -1 do
            local currentWidth = width
            width = width + self.navList[i]:GetWidth()

            if width > maxWidth then
                collapsed = true
                if not collapsedWidth then
                    collapsedWidth = currentWidth
                end
            else
                if lastShown then
                    self.navList[lastShown]:SetPoint("LEFT", self.navList[i], "RIGHT", 1, 0)
                end
                lastShown = i
            end
        end

        if collapsed then
            if collapsedWidth + self.overflowButton:GetWidth() > maxWidth then
                lastShown = lastShown + 1
            end

            if lastShown then
                local lastButton = self.navList[lastShown]

                if lastButton then
                    lastButton:SetPoint("LEFT", self.overflowButton, "RIGHT", 1, 0)
                end
            end
        end
    end

    hooksecurefunc("NavBar_Initialize", S.ReskinNavBar)

    hooksecurefunc("NavBar_AddButton", function(self, buttonData)
            local navButton = self.navList[#self.navList]

            if not navButton.restyled then
                S:Reskin(navButton)

                navButton.arrowUp:SetAlpha(0)
                navButton.arrowDown:SetAlpha(0)

                navButton.selected:SetDrawLayer("BACKGROUND", 1)
                navButton.selected:SetColorTexture(r, g, b, .3)

                navButton:HookScript("OnClick", function()
                        moveNavButtons(self)
                    end)

                -- arrow button

                local arrowButton = navButton.MenuArrowButton

                arrowButton.Art:Hide()

                arrowButton:SetHighlightTexture("")

                local tex = arrowButton:CreateTexture(nil, "ARTWORK")
                tex:SetTexture(S["media"].arrowDown)
                tex:SetSize(8, 8)
                tex:SetPoint("CENTER")
                arrowButton.tex = tex

                local colourArrow, clearArrow = S.colourArrow, S.clearArrow
                arrowButton:SetScript("OnEnter", colourArrow)
                arrowButton:SetScript("OnLeave", clearArrow)

                navButton.restyled = true
            end

            moveNavButtons(self)
        end)

    S:Reskin(SplashFrame.BottomCloseButton)
    S:ReskinClose(SplashFrame.TopCloseButton)

    SplashFrame.TopCloseButton:ClearAllPoints()

    SplashFrame.TopCloseButton:SetPoint("TOPRIGHT", SplashFrame, "TOPRIGHT", -18, -18)
end

S:AddCallback("Misc", LoadSkin)
