local R, L, P = unpack(select(2, ...)) --Inport: Engine, Locales, ProfileDB
local AB = R:NewModule("ActionBar", "AceEvent-3.0", "AceHook-3.0", "AceConsole-3.0")

AB.modName = L["动作条"]
AB["Handled"] = {}

local visibility = "[petbattle][overridebar][vehicleui][possessbar,@vehicle,exists] hide; show"
local actionBarsName = {
    "MainMenuBarArtFrame",
    "MultiBarBottomRight",
    "MultiBarBottomLeft",
    "MultiBarRight",
    "MultiBarLeft"
}
local actionButtonsName = {
    bar1 = "ActionButton",
    bar2 = "MultiBarBottomRightButton",
    bar3 = "MultiBarBottomLeftButton",
    bar4 = "MultiBarRightButton",
    bar5 = "MultiBarLeftButton"
}

function AB:GetOptions()
	local options = {
		barscale = {
			order = 5,
			name = L["动作条缩放"],
			type = "range",
			min = 0.5, max = 1.5, step = 0.01,
			isPercent = true,
		},
		petbarscale = {
			order = 6,
			name = L["宠物动作条缩放"],
			type = "range",
			min = 0.5, max = 1.5, step = 0.01,
			isPercent = true,
		},
		macroname = {
			order = 9,
			name = L["显示宏名称"],
			type = "toggle",
		},
		itemcount = {
			order = 10,
			name = L["显示物品数量"],
			type = "toggle",
		},
		hotkeys = {
			order = 11,
			name = L["显示快捷键"],
			type = "toggle",
		},
		showgrid = {
			order = 12,
			name = L["显示空按键"],
			type = "toggle",
		},
		CooldownAlphaGroup = {
			order = 13,
			type = "group",
			name = L["根据CD淡出"],
			guiInline = true,
			args = {
				cooldownalpha = {
					type = "toggle",
					name = L["启用"],
					order = 1,
				},
				spacer = {
					type = "description",
					name = "",
					desc = "",
					order = 2,
				},
				cdalpha = {
					order = 3,
					name = L["CD时透明度"],
					type = "range",
					min = 0, max = 1, step = 0.05,
					disabled = function() return not self.db.cooldownalpha end,
				},
				readyalpha = {
					order = 4,
					name = L["就绪时透明度"],
					type = "range",
					min = 0, max = 1, step = 0.05,
					disabled = function() return not self.db.cooldownalpha end,
				},
				stancealpha = {
					type = "toggle",
					name = L["姿态条"],
					order = 5,
					disabled = function() return not self.db.cooldownalpha end,
				},
			},
		},
		PetGroup = {
			order = 40,
			type = "group",
			guiInline = false,
			name = L["宠物条"],
            get = function(info) return R.db.ActionBar["barpet"][ info[#info] ] end,
			set = function(info, value) R.db.ActionBar["barpet"][ info[#info] ] = value; AB:UpdatePetBar() end,
			args = {
                enable = {
					order = 1,
					type = "toggle",
					name = L["启用"],
				},
				autohide = {
					type = "toggle",
					name = L["自动隐藏"],
					order = 2,
				},
				mouseover = {
					type = "toggle",
					name = L["鼠标滑过显示"],
					order = 3,
				},
                buttonsize = {
					type = "range",
					name = L["按键大小"],
					min = 15, max = 40, step = 1,
					order = 4,
				},
                buttonspacing = {
					type = "range",
					name = L["按键间距"],
					min = 1, max = 10, step = 1,
					order = 5,
				},
                buttonsPerRow = {
					type = "range",
					name = L["每行按键数"],
					min = 1, max = NUM_PET_ACTION_SLOTS, step = 1,
					order = 6,
				},
			},
		},
		StanceGroup = {
			order = 41,
			type = "group",
			guiInline = false,
			name = L["姿态条"],
			args = {
				stancebarfade = {
					type = "toggle",
					name = L["自动隐藏"],
					order = 1,
				},
				stancebarmouseover = {
					type = "toggle",
					name = L["鼠标滑过显示"],
					order = 2,
				},
			},
		},
	}
    for i = 1, 5 do
        options["Bar"..i.."Group"] = {
			order = 20 + i,
			type = "group",
			name = L["动作条"..i],
			guiInline = false,
            get = function(info) return R.db.ActionBar["bar"..i][ info[#info] ] end,
			set = function(info, value) R.db.ActionBar["bar"..i][ info[#info] ] = value; AB:UpdatePositionAndSize("bar"..i) end,
			args = {
                enable = {
					order = 1,
					type = "toggle",
					name = L["启用"],
				},
				autohide = {
					type = "toggle",
					name = L["自动隐藏"],
					order = 2,
				},
				mouseover = {
					type = "toggle",
					name = L["鼠标滑过显示"],
					order = 3,
				},
                buttonsize = {
					type = "range",
					name = L["按键大小"],
					min = 15, max = 40, step = 1,
					order = 4,
				},
                buttonspacing = {
					type = "range",
					name = L["按键间距"],
					min = 1, max = 10, step = 1,
					order = 5,
				},
                buttonsPerRow = {
					type = "range",
					name = L["每行按键数"],
					min = 1, max = NUM_ACTIONBAR_BUTTONS, step = 1,
					order = 6,
				},
			},
        }
    end
	return options
end

function AB:HideBlizz()
	local blizzHider = CreateFrame("Frame", nil)
	blizzHider:Hide()
	MainMenuBar:SetParent(blizzHider)
	MainMenuBarPageNumber:SetParent(blizzHider)
	ActionBarDownButton:SetParent(blizzHider)
	ActionBarUpButton:SetParent(blizzHider)
	OverrideActionBarExpBar:SetParent(blizzHider)
	OverrideActionBarHealthBar:SetParent(blizzHider)
	OverrideActionBarPowerBar:SetParent(blizzHider)
	OverrideActionBarPitchFrame:SetParent(blizzHider)

    local buttonList = {
        CharacterMicroButton,
        SpellbookMicroButton,
        TalentMicroButton,
        AchievementMicroButton,
        QuestLogMicroButton,
        GuildMicroButton,
        PVPMicroButton,
        LFDMicroButton,
        CompanionsMicroButton,
        EJMicroButton,
        MainMenuMicroButton,
        HelpMicroButton,
        MainMenuBarBackpackButton,
        CharacterBag0Slot,
        CharacterBag1Slot,
        CharacterBag2Slot,
        CharacterBag3Slot,
    }
    for _, button in pairs(buttonList) do
        button:SetParent(blizzHider)
    end
	-----------------------------
	-- HIDE TEXTURES
	-----------------------------

	--remove some the default background textures
	StanceBarLeft:SetTexture(nil)
	StanceBarMiddle:SetTexture(nil)
	StanceBarRight:SetTexture(nil)
	SlidingActionBarTexture0:SetTexture(nil)
	SlidingActionBarTexture1:SetTexture(nil)
	PossessBackground1:SetTexture(nil)
	PossessBackground2:SetTexture(nil)
	MainMenuBarTexture0:SetTexture(nil)
	MainMenuBarTexture1:SetTexture(nil)
	MainMenuBarTexture2:SetTexture(nil)
	MainMenuBarTexture3:SetTexture(nil)
	MainMenuBarLeftEndCap:SetTexture(nil)
	MainMenuBarRightEndCap:SetTexture(nil)
	local textureList =  {
		"_BG",
		"EndCapL",
		"EndCapR",
		"_Border",
		"Divider1",
		"Divider2",
		"Divider3",
		"ExitBG",
		"MicroBGL",
		"MicroBGR",
		"_MicroBGMid",
		"ButtonBGL",
		"ButtonBGR",
		"_ButtonBGMid",
	}
	for _,tex in pairs(textureList) do
		OverrideActionBar[tex]:SetAlpha(0)
	end
	
	hooksecurefunc("TalentFrame_LoadUI", function()
		PlayerTalentFrame:UnregisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
		TalentMicroButtonAlert:ClearAllPoints()
		TalentMicroButtonAlert:SetPoint("BOTTOM", RayUIBottomInfoBar, "TOPLEFT", 30, 30)
	end)
end

function AB:CreateBar(id)
    local point, anchor, attachTo, x, y = string.split(",", self["DefaultPosition"]["bar"..id])
	local bar = CreateFrame("Frame", "RayUIActionBar"..id, UIParent, "SecureHandlerStateTemplate")
    bar:Point(point, anchor, attachTo, x, y)

	_G[actionBarsName[id]]:SetParent(bar)
	
    self["Handled"]["bar"..id] = bar
    self:UpdatePositionAndSize("bar"..id)
	R:CreateMover(bar, "ActionBar"..id.."Mover", L["动作条"..id.."锚点"], true, nil, "ALL,ACTIONBARS")  
end

function AB:UpdatePositionAndSize(barName)
    local bar = self["Handled"][barName]
    local buttonsPerRow = self.db[barName].buttonsPerRow
    local buttonsize = self.db[barName].buttonsize
    local buttonspacing = self.db[barName].buttonspacing
    local numColumns = ceil(NUM_ACTIONBAR_BUTTONS / buttonsPerRow)

	bar:SetWidth(buttonsize*buttonsPerRow + buttonspacing*(buttonsPerRow - 1))
	bar:SetHeight(buttonsize*numColumns + buttonspacing*(numColumns - 1))

    if not self.db.bar2.enable and not self.db.bar3.enable and not ( R.db.movers and R.db.movers.ActionBar1Mover ) then
        local bar = ActionBar1Mover or self["Handled"]["bar1"]
        bar:ClearAllPoints()
        bar:Point("BOTTOM", UIParent, "BOTTOM", 0, 235)
    elseif not ( R.db.movers and R.db.movers.ActionBar1Mover ) then
        local bar = ActionBar1Mover or self["Handled"]["bar1"]
        local point, anchor, attachTo, x, y = string.split(",", self["DefaultPosition"]["bar1"])
        bar:Point(point, anchor, attachTo, x, y)
    end

	if self.db[barName].mouseover then
		self.db[barName].autohide = false
		bar:SetAlpha(0)
		bar:SetScript("OnEnter", function(self) UIFrameFadeIn(bar,0.5,bar:GetAlpha(),1) end)
		bar:SetScript("OnLeave", function(self) UIFrameFadeOut(bar,0.5,bar:GetAlpha(),0) end)  
	else
		bar:SetAlpha(1)
		bar:SetScript("OnEnter", nil)
		bar:SetScript("OnLeave", nil)  
    end

    if self.db[barName].autohide then
        bar:SetParent(RayUIActionBarHider)
    else
        bar:SetParent(UIParent)
    end

    local button, lastButton, lastColumnButton
    for i = 1, NUM_ACTIONBAR_BUTTONS do
		button = _G[actionButtonsName[barName]..i]
		lastButton = _G[actionButtonsName[barName]..(i-1)]
		lastColumnButton = _G[actionButtonsName[barName]..(i-buttonsPerRow)]
		button:SetSize(buttonsize, buttonsize)
		button:ClearAllPoints()

        if i == 1 then
			button:SetPoint("TOPLEFT", bar, "TOPLEFT", 0, 0)
        elseif (i - 1) % buttonsPerRow == 0 then
			button:SetPoint("TOPLEFT", lastColumnButton, "BOTTOMLEFT", 0, -buttonspacing)
        else
			button:SetPoint("LEFT", lastButton, "RIGHT", buttonspacing, 0)
        end

        if self.db[barName].mouseover then
            if not self.hooks[button] then
                self:HookScript(button, "OnEnter", function() UIFrameFadeIn(bar,0.5,bar:GetAlpha(),1) end)
                self:HookScript(button, "OnLeave", function() UIFrameFadeOut(bar,0.5,bar:GetAlpha(),0) end)
            end
        else
            if not self.hooks[button] then
                self:Unhook(button, "OnEnter")
                self:Unhook(button, "OnLeave")
            end
        end
    end

    if self.db[barName].enable then
        bar:Show()
        RegisterStateDriver(bar, "visibility", visibility)
    else
        bar:Hide()
        UnregisterStateDriver(bar, "visibility")
    end
end

function AB:Initialize()
    SetActionBarToggles(1, 1, 1, 1)
    InterfaceOptionsActionBarsPanelBottomRight:Kill()
    InterfaceOptionsActionBarsPanelBottomRight:SetScale(0.0001)
	InterfaceOptionsActionBarsPanelBottomLeft:Kill()
    InterfaceOptionsActionBarsPanelBottomLeft:SetScale(0.0001)
	InterfaceOptionsActionBarsPanelRightTwo:Kill()
    InterfaceOptionsActionBarsPanelRightTwo:SetScale(0.0001)
	InterfaceOptionsActionBarsPanelRight:Kill()
    InterfaceOptionsActionBarsPanelRight:SetScale(0.0001)

    self["DefaultPosition"] = {
        bar1 = "BOTTOM,UIParent,BOTTOM,"..(-3*AB.db.bar1.buttonsize - 3*AB.db.bar1.buttonspacing)..",235",
        bar2 = "BOTTOM,UIParent,BOTTOM,"..(-3*AB.db.bar1.buttonsize - 3*AB.db.bar1.buttonspacing)..","..(235 + AB.db.bar3.buttonsize + AB.db.bar3.buttonspacing),
        bar3 = "BOTTOMLEFT,UIParent,BOTTOM,"..(3*AB.db.bar1.buttonsize + 2.5*AB.db.bar1.buttonspacing + AB.db.bar2.buttonspacing)..",235",
        bar4 = "RIGHT,UIParent,RIGHT,-15,0",
        bar5 = "LEFT,UIParent,LEFT,15,0",
    }
	self:HideBlizz()
	--for i = 1, 5 do
		--self["CreateBar"..i]()
	--end
    for i =1, 5 do
        self:CreateBar(i)
    end
	if self.db.showgrid then
		ActionButton_HideGrid = R.dummy
		for i = 1, NUM_ACTIONBAR_BUTTONS do
			local button = _G[format("ActionButton%d", i)]
			button:SetAttribute("showgrid", 1)
			ActionButton_ShowGrid(button)

			button = _G[format("MultiBarRightButton%d", i)]
			button:SetAttribute("showgrid", 1)
			ActionButton_ShowGrid(button)

			button = _G[format("MultiBarBottomRightButton%d", i)]
			button:SetAttribute("showgrid", 1)
			ActionButton_ShowGrid(button)

			button = _G[format("MultiBarLeftButton%d", i)]
			button:SetAttribute("showgrid", 1)
			ActionButton_ShowGrid(button)

			button = _G[format("MultiBarBottomLeftButton%d", i)]
			button:SetAttribute("showgrid", 1)
			ActionButton_ShowGrid(button)

			button = _G[format("PetActionButton%d", i)]
			if button then
				button:SetAttribute("showgrid", 1)
				ActionButton_ShowGrid(button)
			end
		end
        SetCVar("alwaysShowActionBars", "1")
    end
	self:CreateBarPet()
	self:CreateStanceBar()
	self:CreateVehicleExit()
	self:CreateExtraButton()
	self:CreateOverrideBar()
	self:CreateCooldown()
	self:LoadKeyBinder()
	self:CreateRangeDisplay()
	self:EnableAutoHide()

	--self:SecureHook("ActionButton_ShowOverlayGlow", "UpdateOverlayGlow")
	self:SecureHook("ActionButton_UpdateHotkeys", "UpdateHotkey")
	self:SecureHook("ActionButton_Update", "Style")
	self:SecureHook("ActionButton_UpdateFlyout", "StyleFlyout")
	self:SecureHook("StanceBar_Update", "StyleShift")
	self:SecureHook("StanceBar_UpdateState", "StyleShift")
	self:SecureHook("PetActionBar_Update", "StylePet")
	--self:SecureHook("SetActionBarToggles", "UpdatePosition")
	self:HookScript(SpellFlyout, "OnShow", "SetupFlyoutButton")

	for i = 1, NUM_ACTIONBAR_BUTTONS do
		self:Style(_G["ActionButton"..i])
		self:Style(_G["MultiBarBottomLeftButton"..i])
		self:Style(_G["MultiBarBottomRightButton"..i])
		self:Style(_G["MultiBarRightButton"..i])
		self:Style(_G["MultiBarLeftButton"..i])
	end
end

function AB:Info()
	return L["|cff7aa6d6Ray|r|cffff0000U|r|cff7aa6d6I|r头像模块."]
end

function AB:UpdateHotkey(button, actionButtonType)
	local hotkey = _G[button:GetName() .. "HotKey"]
	local text = hotkey:GetText()

	text = string.gsub(text, "(s%-)", "S")
	text = string.gsub(text, "(a%-)", "A")
	text = string.gsub(text, "(c%-)", "C")
	text = string.gsub(text, "(Mouse Button )", "M")
	text = string.gsub(text, "(滑鼠按鍵)", "M")
	text = string.gsub(text, "(鼠标按键)", "M")
	text = string.gsub(text, KEY_BUTTON3, "M3")
	text = string.gsub(text, "(Num Pad )", "N")
	text = string.gsub(text, KEY_PAGEUP, "PU")
	text = string.gsub(text, KEY_PAGEDOWN, "PD")
	text = string.gsub(text, KEY_SPACE, "SpB")
	text = string.gsub(text, KEY_INSERT, "Ins")
	text = string.gsub(text, KEY_HOME, "Hm")
	text = string.gsub(text, KEY_DELETE, "Del")
	text = string.gsub(text, KEY_MOUSEWHEELUP, "MwU")
	text = string.gsub(text, KEY_MOUSEWHEELDOWN, "MwD")

	if hotkey:GetText() == _G["RANGE_INDICATOR"] then
		hotkey:SetText("")
	else
		hotkey:SetText(text)
	end
end

function AB:Style(button)
	local name = button:GetName()
	local action = button.action

	if name:match("MultiCast") then return end

	if not button.equipped then
		local equipped = button:CreateTexture(nil, "OVERLAY")
		equipped:SetTexture(0, 1, 0, .3)
		equipped:SetAllPoints()
		equipped:Hide()
		button.equipped = equipped
	end

	if action and IsEquippedAction(action) then
		if not button.equipped:IsShown() then
			button.equipped:Show()
		end
	else
		if button.equipped:IsShown() then
			button.equipped:Hide()
		end
	end

	if button.styled then return end

	local Icon = _G[name.."Icon"]
	local Count = _G[name.."Count"]
	local Flash	 = _G[name.."Flash"]
	local HotKey = _G[name.."HotKey"]
	local Border  = _G[name.."Border"]
	local Btname = _G[name.."Name"]
	local Normal  = _G[name.."NormalTexture"]
	local Normal2 = button:GetNormalTexture()
	local Cooldown = _G[name .. "Cooldown"]
	local FloatingBG = _G[name.."FloatingBG"]

	if Cooldown then
		Cooldown:ClearAllPoints()
		Cooldown:SetAllPoints(button)
	end

	if Flash then Flash:SetTexture(nil) end
	if Normal then Normal:SetTexture(nil) Normal:Hide() Normal:SetAlpha(0) end
	if Normal2 then Normal2:SetTexture(nil) Normal2:Hide() Normal2:SetAlpha(0) end
	if Border then Border:SetTexture(nil) end

	if Count then
		Count:ClearAllPoints()
		Count:Point("BOTTOMRIGHT", 2, 0)
		--Count:SetFont(R["media"].pxfont, R.mult*10, "OUTLINE,MONOCHROME")
        Count:SetFont(R["media"].font, R["media"].fontsize, R["media"].fontflag)
	end

	if FloatingBG then
		FloatingBG:Kill()
	end

	if Btname then
		if AB.db.macroname ~= true then
			Btname:SetDrawLayer("HIGHLIGHT")
			Btname:Width(50)
            Btname:SetFont(R["media"].font, R["media"].fontsize, R["media"].fontflag)
            Btname:ClearAllPoints()
            Btname:Point("BOTTOM", 0, -3)
		end
	end

	if not button.shadow then
		if not totem then
			if not flyout and not button.noResize then
				button:SetWidth(AB.db.buttonsize)
				button:SetHeight(AB.db.buttonsize)
			end

			button:CreateShadow("Background")
		end

		if Icon then
			Icon:SetTexCoord(.08, .92, .08, .92)
			Icon:SetAllPoints()
		end
	end

	if HotKey then
		HotKey:ClearAllPoints()
		--HotKey:SetPoint("TOPRIGHT", 0, 0)
		HotKey:Point("TOP", 0, 5)
        HotKey:SetJustifyH("CENTER")
        HotKey:Width(AB.db.buttonsize + 10)
		--HotKey:SetFont(R["media"].pxfont, R.mult*10, "OUTLINE,MONOCHROME")
        HotKey:SetFont(R["media"].font, R["media"].fontsize, R["media"].fontflag)
		if not AB.db.hotkeys == true then
			HotKey:SetText("")
			HotKey:Hide()
			HotKey.Show = R.dummy
		end
	end

	if button.style then
		button.style:SetDrawLayer("BACKGROUND", -7)	
        button.border:SetFrameLevel(button:GetFrameLevel())
        button.shadow:SetFrameLevel(button:GetFrameLevel())
	end

	button:StyleButton(true)

	button.styled = true
end

function AB:StyleShift()
	for i=1, NUM_STANCE_SLOTS do
		local name = "StanceButton"..i
		local button  = _G[name]
		local icon  = _G[name.."Icon"]
		local normal  = _G[name.."NormalTexture"]
		self:Style(button)
	end
end

function AB:StylePet()
	for i=1, NUM_PET_ACTION_SLOTS do
		local name = "PetActionButton"..i
		local button  = _G[name]
		local icon  = _G[name.."Icon"]
		local normal  = _G[name.."NormalTexture2"]
		self:Style(button)
	end
end

local buttons = 0
function AB:SetupFlyoutButton()
	for i=1, buttons do
		if _G["SpellFlyoutButton"..i] then
			self:Style(_G["SpellFlyoutButton"..i], nil, true)
			_G["SpellFlyoutButton"..i]:StyleButton(true)
		end
	end
end

function AB:StyleFlyout(button)
	if not button.FlyoutBorder then return end
	button.FlyoutBorder:SetAlpha(0)
	button.FlyoutBorderShadow:SetAlpha(0)

	SpellFlyoutHorizontalBackground:SetAlpha(0)
	SpellFlyoutVerticalBackground:SetAlpha(0)
	SpellFlyoutBackgroundEnd:SetAlpha(0)

	for i=1, GetNumFlyouts() do
		local x = GetFlyoutID(i)
		local _, _, numSlots, isKnown = GetFlyoutInfo(x)
		if isKnown then
			buttons = numSlots
			break
		end
	end

	--Change arrow direction depending on what bar the button is on
	local arrowDistance
	if ((SpellFlyout and SpellFlyout:IsShown() and SpellFlyout:GetParent() == button) or GetMouseFocus() == button) then
		arrowDistance = 5
	else
		arrowDistance = 2
	end

	if button:GetParent() and button:GetParent():GetParent() and button:GetParent():GetParent():GetName() and button:GetParent():GetParent():GetName() == "SpellBookSpellIconsFrame" then
		return
	end

	if button:GetAttribute("flyoutDirection") ~= nil then
        local layout = "HORIZONTAL"
        if button:GetParent() and button:GetParent():GetParent() then
            if button:GetParent():GetParent():GetHeight() > button:GetParent():GetParent():GetWidth() then
                layout = "VERTICAL"
            end
        end
		local point = R:GetScreenQuadrant(button)

        if layout == "HORIZONTAL" then
            if point:find("TOP") then
                button.FlyoutArrow:ClearAllPoints()
                button.FlyoutArrow:SetPoint("BOTTOM", button, "BOTTOM", 0, -arrowDistance)
                SetClampedTextureRotation(button.FlyoutArrow, 180)
                if not InCombatLockdown() then button:SetAttribute("flyoutDirection", "BOTTOM") end
            else
                button.FlyoutArrow:ClearAllPoints()
                button.FlyoutArrow:SetPoint("TOP", button, "TOP", 0,arrowDistance)
                SetClampedTextureRotation(button.FlyoutArrow, 0)
                if not InCombatLockdown() then button:SetAttribute("flyoutDirection", "TOP") end
            end
        else
            if point:find("LEFT") then
                button.FlyoutArrow:ClearAllPoints()
                button.FlyoutArrow:SetPoint("RIGHT", button, "RIGHT", arrowDistance, 0)
                SetClampedTextureRotation(button.FlyoutArrow, 90)
                if not InCombatLockdown() then button:SetAttribute("flyoutDirection", "RIGHT") end
            else
                button.FlyoutArrow:ClearAllPoints()
                button.FlyoutArrow:SetPoint("LEFT", button, "LEFT", -arrowDistance, 0)
                SetClampedTextureRotation(button.FlyoutArrow, 270)
                if not InCombatLockdown() then button:SetAttribute("flyoutDirection", "LEFT") end
            end
        end
	end
end

function AB:UpdateOverlayGlow(button)
	if button.overlay and button.shadow then
		button.overlay:SetParent(button)
		button.overlay:ClearAllPoints()
		button.overlay:SetAllPoints(button.shadow)
		button.overlay.ants:ClearAllPoints()
		button.overlay.ants:SetPoint("TOPLEFT", button.shadow, "TOPLEFT", -2, 2)
		button.overlay.ants:SetPoint("BOTTOMRIGHT", button.shadow, "BOTTOMRIGHT", 2, -2)
		button.overlay.outerGlow:SetPoint("TOPLEFT", button.shadow, "TOPLEFT", -2, 2)
		button.overlay.outerGlow:SetPoint("BOTTOMRIGHT", button.shadow, "BOTTOMRIGHT", 2, -2)
	end
end

R:RegisterModule(AB:GetName())
