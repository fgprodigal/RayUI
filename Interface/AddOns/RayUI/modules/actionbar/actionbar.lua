local R, L, P = unpack(select(2, ...)) --Inport: Engine, Locales, ProfileDB
local AB = R:NewModule("ActionBar", "AceEvent-3.0", "AceHook-3.0", "AceConsole-3.0")

AB.modName = L["动作条"]

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
		buttonsize = {
			order = 7,
			name = L["按键大小"],
			type = "range",
			min = 20, max = 35, step = 1,
		},
		buttonspacing = {
			order = 8,
			name = L["按键间距"],
			type = "range",
			min = 1, max = 10, step = 1,
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
		Bar1Group = {
			order = 14,
			type = "group",
			name = L["动作条1"],
			guiInline = true,
			args = {
				bar1fade = {
					type = "toggle",
					name = L["自动隐藏"],
					order = 1,
				},
				spacer = {
					type = "description",
					name = "",
					desc = "",
					order = 2,
				},
			},
		},
		Bar2Group = {
			order = 15,
			type = "group",
			guiInline = true,
			name = L["动作条2"],
			args = {
				bar2fade = {
					type = "toggle",
					name = L["自动隐藏"],
					order = 1,
				},
				bar2mouseover = {
					type = "toggle",
					name = L["鼠标滑过显示"],
					order = 2,
				},
			},
		},
		Bar3Group = {
			order = 16,
			type = "group",
			guiInline = true,
			name = L["动作条3"],
			args = {
				bar3fade = {
					type = "toggle",
					name = L["自动隐藏"],
					order = 1,
				},
				bar3mouseover = {
					type = "toggle",
					name = L["鼠标滑过显示"],
					order = 2,
				},
			},
		},
		Bar4Group = {
			order = 17,
			type = "group",
			guiInline = true,
			name = L["动作条4"],
			args = {
				bar4fade = {
					type = "toggle",
					name = L["自动隐藏"],
					order = 1,
				},
				bar4mouseover = {
					type = "toggle",
					name = L["鼠标滑过显示"],
					order = 2,
				},
			},
		},
		Bar5Group = {
			order = 18,
			type = "group",
			guiInline = true,
			name = L["动作条5"],
			args = {
				bar5fade = {
					type = "toggle",
					name = L["自动隐藏"],
					order = 1,
				},
				bar5mouseover = {
					type = "toggle",
					name = L["鼠标滑过显示"],
					order = 2,
				},
			},
		},
		PetGroup = {
			order = 18,
			type = "group",
			guiInline = true,
			name = L["宠物条"],
			args = {
				petbarfade = {
					type = "toggle",
					name = L["自动隐藏"],
					order = 1,
				},
				petbarmouseover = {
					type = "toggle",
					name = L["鼠标滑过显示"],
					order = 2,
				},
			},
		},
		StanceGroup = {
			order = 20,
			type = "group",
			guiInline = true,
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

function AB:Initialize()
	self:HideBlizz()
	for i = 1, 5 do
		AB["CreateBar"..i]()
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

	self:SecureHook("ActionButton_ShowOverlayGlow", "UpdateOverlayGlow")
	self:SecureHook("ActionButton_UpdateHotkeys", "UpdateHotkey")
	self:SecureHook("ActionButton_Update", "Style")
	self:SecureHook("ActionButton_UpdateFlyout", "StyleFlyout")
	self:SecureHook("StanceBar_Update", "StyleShift")
	self:SecureHook("StanceBar_UpdateState", "StyleShift")
	self:SecureHook("PetActionBar_Update", "StylePet")
	self:SecureHook("SetActionBarToggles", "UpdatePosition")
	self:HookScript(SpellFlyout, "OnShow", "SetupFlyoutButton")

	for i = 1, NUM_ACTIONBAR_BUTTONS do
		self:Style(_G["ActionButton"..i])
		self:Style(_G["MultiBarBottomLeftButton"..i])
		self:Style(_G["MultiBarBottomRightButton"..i])
		self:Style(_G["MultiBarRightButton"..i])
		self:Style(_G["MultiBarLeftButton"..i])
	end
end

function AB:UpdatePosition(bar2,bar3)
	if InCombatLockdown() then self.needPosition = true return end
	if bar2 and bar3 then
		RayUIVehicleBar:ClearAllPoints()
		RayUIVehicleBar:SetPoint("TOPLEFT", "RayUIActionBar2", "TOPRIGHT", AB.db.buttonspacing, 0)
		if not ( R.db.movers and R.db.movers.ActionBar1Mover ) then
			ActionBar1Mover:ClearAllPoints()
			ActionBar1Mover:Point("BOTTOM", UIParent, "BOTTOM", -3 * AB.db.buttonsize -3 * AB.db.buttonspacing, 235)
		end
		if RayUIActionBar2 and RayUIActionBar2:GetHeight() < AB.db.buttonsize*2 then
			ActionBar2Mover:SetWidth(AB.db.buttonsize*6+AB.db.buttonspacing*5)
			ActionBar2Mover:SetHeight(AB.db.buttonsize*2+AB.db.buttonspacing)
			RayUIActionBar2:SetWidth(AB.db.buttonsize*6+AB.db.buttonspacing*5)
			RayUIActionBar2:SetHeight(AB.db.buttonsize*2+AB.db.buttonspacing)
			MultiBarBottomLeftButton7:ClearAllPoints()
			MultiBarBottomLeftButton7:SetPoint("BOTTOMLEFT", RayUIActionBar2, 0,0)
			if not ( R.db.movers and R.db.movers.ActionBar2Mover ) then
				ActionBar2Mover:ClearAllPoints()
				ActionBar2Mover:Point("BOTTOMLEFT", ActionBar1Mover, "BOTTOMRIGHT", AB.db.buttonspacing, 0)
				RayUIActionBar2:ClearAllPoints()
				RayUIActionBar2:Point("BOTTOMLEFT", ActionBar1Mover, "BOTTOMRIGHT", AB.db.buttonspacing, 0)
			end
		end
	else
		RayUIVehicleBar:ClearAllPoints()
		RayUIVehicleBar:SetPoint("LEFT", "RayUIActionBar1", "RIGHT", AB.db.buttonspacing, 0)
		if bar2 or bar3 then
			if not ( R.db.movers and R.db.movers.ActionBar1Mover ) then
				ActionBar1Mover:ClearAllPoints()
				ActionBar1Mover:Point("BOTTOM", UIParent, "BOTTOM", 0, 235)
			end
		else
			if not ( R.db.movers and R.db.movers.ActionBar1Mover ) then
				ActionBar1Mover:ClearAllPoints()
				ActionBar1Mover:Point("BOTTOM", UIParent, "BOTTOM", 0, 270)
			end
		end
		if bar2 and not bar3 then
			if RayUIActionBar2 and RayUIActionBar2:GetHeight() > AB.db.buttonsize then
				ActionBar2Mover:SetWidth(AB.db.buttonsize*12+AB.db.buttonspacing*11)
				ActionBar2Mover:SetHeight(AB.db.buttonsize)
				RayUIActionBar2:SetWidth(AB.db.buttonsize*12+AB.db.buttonspacing*11)
				RayUIActionBar2:SetHeight(AB.db.buttonsize)
				MultiBarBottomLeftButton7:ClearAllPoints()
				MultiBarBottomLeftButton7:SetPoint("LEFT", MultiBarBottomLeftButton6, "RIGHT", AB.db.buttonspacing,0)
				if not ( R.db.movers and R.db.movers.ActionBar2Mover ) then
					ActionBar2Mover:ClearAllPoints()
					ActionBar2Mover:Point("BOTTOM", ActionBar1Mover, "TOP", 0, AB.db.buttonspacing)
					RayUIActionBar2:ClearAllPoints()
					RayUIActionBar2:Point("BOTTOM", ActionBar1Mover, "TOP", 0, AB.db.buttonspacing)
				end
			end
		end
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
		Count:SetPoint("BOTTOMRIGHT", 0, R:Scale(2))
		Count:SetFont(R["media"].pxfont, R.mult*10, "OUTLINE,MONOCHROME")
	end

	if FloatingBG then
		FloatingBG:Kill()
	end

	if Btname then
		if AB.db.macroname ~= true then
			Btname:SetDrawLayer("HIGHLIGHT")
			Btname:Width(50)
		end
	end

	if not button.shadow then
		if not totem then
			if not flyout then
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
		HotKey:SetPoint("TOPRIGHT", 0, 0)
		HotKey:SetFont(R["media"].pxfont, R.mult*10, "OUTLINE,MONOCHROME")
		HotKey:SetShadowColor(0, 0, 0, 0.3)
		HotKey.ClearAllPoints = R.dummy
		HotKey.SetPoint = R.dummy
		if not AB.db.hotkeys == true then
			HotKey:SetText("")
			HotKey:Hide()
			HotKey.Show = R.dummy
		end
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
