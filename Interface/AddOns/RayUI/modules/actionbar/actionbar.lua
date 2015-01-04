--ActionBar from ElvUI
local R, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local AB = R:NewModule("ActionBar", "AceEvent-3.0", "AceHook-3.0", "AceConsole-3.0")
local LAB = LibStub("LibActionButton-1.0")

AB.modName = L["动作条"]
AB["Handled"] = {}
AB["Skinned"] = {}
AB["handledbuttons"] = {}

AB["barDefaults"] = {
	["bar1"] = {
		["page"] = 1,
		["bindButtons"] = "ACTIONBUTTON",
		["conditions"] = format("[vehicleui] %d; [possessbar] %d; [overridebar] %d; [shapeshift] 13; [form,noform] 0; [bar:2] 2; [bar:3] 3; [bar:4] 4; [bar:5] 5; [bar:6] 6;", GetVehicleBarIndex(), GetVehicleBarIndex(), GetOverrideBarIndex()),
		["paging"] = {
			["DRUID"] = "[bonusbar:1,nostealth] 7; [bonusbar:1,stealth] 8; [bonusbar:2] 8; [bonusbar:3] 9; [bonusbar:4] 10;",
			["PRIEST"] = "[bonusbar:1] 7;",
			["ROGUE"] = "[stance:1] 7;  [stance:2] 7; [stance:3] 7;", -- set to "[stance:1] 7; [stance:3] 10;" if you want a shadow dance bar
			["MONK"] = "[bonusbar:1] 7; [bonusbar:2] 8; [bonusbar:3] 9;",
			["WARRIOR"] = "[bonusbar:1] 7; [bonusbar:2] 8;"
		},
		["visibility"] = "[petbattle] hide; show",
	},
	["bar2"] = {
		["page"] = 5,
		["bindButtons"] = "MULTIACTIONBAR2BUTTON",
		["conditions"] = "",
		["paging"] = {},
		["visibility"] = "[vehicleui] hide; [overridebar] hide; [petbattle] hide; show",
	},
	["bar3"] = {
		["page"] = 6,
		["bindButtons"] = "MULTIACTIONBAR1BUTTON",
		["conditions"] = "",
		["paging"] = {},
		["visibility"] = "[vehicleui] hide; [overridebar] hide; [petbattle] hide; show",
	},
	["bar4"] = {
		["page"] = 4,
		["bindButtons"] = "MULTIACTIONBAR4BUTTON",
		["conditions"] = "",
		["paging"] = {},
		["visibility"] = "[vehicleui] hide; [overridebar] hide; [petbattle] hide; show",
	},
	["bar5"] = {
		["page"] = 3,
		["bindButtons"] = "MULTIACTIONBAR3BUTTON",
		["conditions"] = "",
		["paging"] = {},
		["visibility"] = "[vehicleui] hide; [overridebar] hide; [petbattle] hide; show",
	},
}

AB.customExitButton = {
	func = function(button)
		if UnitExists("vehicle") then
			VehicleExit()
		else
			PetDismiss()
		end
	end,
	texture = "Interface\\Icons\\Spell_Shadow_SacrificialShield",
	tooltip = LEAVE_VEHICLE,
}

local function SetCooldownSwipeAlpha(cooldown,alpha)
	cooldown:SetSwipeColor(0,0,0,alpha)
	if alpha == 0 then
		cooldown:SetDrawBling(false)
	else
		cooldown:SetDrawBling(true)
	end
end

local function FixActionButtonCooldown(button)
	if not button then return end
	if not button.cooldown then return end
	local name = button:GetName()
	local cooldown = button.cooldown
	local parent
	if button:GetParent():GetParent() and button:GetParent():GetParent():GetName()=="RayUIActionBarHider" then
		parent = RayUIActionBarHider
		hooksecurefunc(parent, "Show", function(self,alpha)
			cooldown:Show()
			local start, duration, enable, charges, maxCharges
			if button.GetCooldown then
				start, duration, enable, charges, maxCharges = button:GetCooldown()
			elseif button.action and button.action > 0 then
				start, duration, enable, charges, maxCharges = GetActionCooldown(button.action)
			else
				start, duration, enable = GetShapeshiftFormCooldown(button:GetID())
			end
			CooldownFrame_SetTimer(cooldown, start, duration, enable, charges, maxCharges)
		end)
	else
		parent = button:GetParent()
	end
	hooksecurefunc(parent, "SetAlpha", function(self,alpha) SetCooldownSwipeAlpha(cooldown,alpha) end)
end

function AB:GetOptions()
	local options = {
		barscale = {
			order = 5,
			name = L["动作条缩放"],
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
		clickondown = {
			order = 13,
			name = L["按下时生效"],
			type = "toggle"
		},
		CooldownAlphaGroup = {
			order = 14,
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
	local blizzHider = CreateFrame("Frame")
	blizzHider:Hide()

	MultiBarBottomLeft:SetParent(blizzHider)
	MultiBarBottomRight:SetParent(blizzHider)
	MultiBarLeft:SetParent(blizzHider)
	MultiBarRight:SetParent(blizzHider)

	for i=1,12 do
		_G["ActionButton" .. i]:Hide()
		_G["ActionButton" .. i]:UnregisterAllEvents()
		_G["ActionButton" .. i]:SetAttribute("statehidden", true)
	
		_G["MultiBarBottomLeftButton" .. i]:Hide()
		_G["MultiBarBottomLeftButton" .. i]:UnregisterAllEvents()
		_G["MultiBarBottomLeftButton" .. i]:SetAttribute("statehidden", true)

		_G["MultiBarBottomRightButton" .. i]:Hide()
		_G["MultiBarBottomRightButton" .. i]:UnregisterAllEvents()
		_G["MultiBarBottomRightButton" .. i]:SetAttribute("statehidden", true)
		
		_G["MultiBarRightButton" .. i]:Hide()
		_G["MultiBarRightButton" .. i]:UnregisterAllEvents()
		_G["MultiBarRightButton" .. i]:SetAttribute("statehidden", true)
		
		_G["MultiBarLeftButton" .. i]:Hide()
		_G["MultiBarLeftButton" .. i]:UnregisterAllEvents()
		_G["MultiBarLeftButton" .. i]:SetAttribute("statehidden", true)
		
		if _G["VehicleMenuBarActionButton" .. i] then
			_G["VehicleMenuBarActionButton" .. i]:Hide()
			_G["VehicleMenuBarActionButton" .. i]:UnregisterAllEvents()
			_G["VehicleMenuBarActionButton" .. i]:SetAttribute("statehidden", true)
		end
		
		if _G["OverrideActionBarButton"..i] then
			_G["OverrideActionBarButton"..i]:Hide()
			_G["OverrideActionBarButton"..i]:UnregisterAllEvents()
			_G["OverrideActionBarButton"..i]:SetAttribute("statehidden", true)
		end
		
		_G["MultiCastActionButton"..i]:Hide()
		_G["MultiCastActionButton"..i]:UnregisterAllEvents()
		_G["MultiCastActionButton"..i]:SetAttribute("statehidden", true)
	end

	ActionBarController:UnregisterAllEvents()
	ActionBarController:RegisterEvent("UPDATE_EXTRA_ACTIONBAR")

	ActionBarController:UnregisterAllEvents()
	ActionBarController:RegisterEvent('UPDATE_EXTRA_ACTIONBAR')
	
	MainMenuBar:EnableMouse(false)
	MainMenuBar:SetAlpha(0)
	MainMenuExpBar:UnregisterAllEvents()
	MainMenuExpBar:Hide()
	MainMenuExpBar:SetParent(blizzHider)
	
	for i=1, MainMenuBar:GetNumChildren() do
		local child = select(i, MainMenuBar:GetChildren())
		if child then
			child:UnregisterAllEvents()
			child:Hide()
			child:SetParent(blizzHider)
		end
	end

	ReputationWatchBar:UnregisterAllEvents()
	ReputationWatchBar:Hide()
	ReputationWatchBar:SetParent(blizzHider)	

	MainMenuBarArtFrame:UnregisterEvent("ACTIONBAR_PAGE_CHANGED")
	MainMenuBarArtFrame:UnregisterEvent("ADDON_LOADED")
	MainMenuBarArtFrame:Hide()
	MainMenuBarArtFrame:SetParent(blizzHider)

	OverrideActionBar:UnregisterAllEvents()
	OverrideActionBar:Hide()
	OverrideActionBar:SetParent(blizzHider)
	
	MultiCastActionBarFrame:UnregisterAllEvents()
	MultiCastActionBarFrame:Hide()
	MultiCastActionBarFrame:SetParent(blizzHider)

	IconIntroTracker:UnregisterAllEvents()
	IconIntroTracker:Hide()
	IconIntroTracker:SetParent(blizzHider)

	hooksecurefunc("TalentFrame_LoadUI", function()
		PlayerTalentFrame:UnregisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
		TalentMicroButtonAlert:ClearAllPoints()
		TalentMicroButtonAlert:SetPoint("BOTTOM", RayUI_InfoPanel_Talent, "TOP", 0, 30)
	end)

	InterfaceOptionsCombatPanelActionButtonUseKeyDown:SetScale(0.0001)
	InterfaceOptionsCombatPanelActionButtonUseKeyDown:SetAlpha(0)
	InterfaceOptionsActionBarsPanelAlwaysShowActionBars:EnableMouse(false)
	InterfaceOptionsActionBarsPanelLockActionBars:SetScale(0.0001)
	InterfaceOptionsActionBarsPanelAlwaysShowActionBars:SetAlpha(0)
	InterfaceOptionsActionBarsPanelLockActionBars:SetAlpha(0)
	InterfaceOptionsStatusTextPanelXP:SetAlpha(0)
	InterfaceOptionsStatusTextPanelXP:SetScale(0.00001)
	InterfaceOptionsActionBarsPanelBottomRight:SetAlpha(0)
	InterfaceOptionsActionBarsPanelBottomRight:SetScale(0.0001)
	InterfaceOptionsActionBarsPanelBottomLeft:SetAlpha(0)
	InterfaceOptionsActionBarsPanelBottomLeft:SetScale(0.0001)
	InterfaceOptionsActionBarsPanelRightTwo:SetAlpha(0)
	InterfaceOptionsActionBarsPanelRightTwo:SetScale(0.0001)
	InterfaceOptionsActionBarsPanelRight:SetAlpha(0)
	InterfaceOptionsActionBarsPanelRight:SetScale(0.0001)
end

function AB:GetPage(bar, defaultPage, condition)
	local page = self.barDefaults[bar]["paging"][R.myclass]
	if not condition then condition = "" end
	if not page then page = "" end
	if page then
		condition = condition.." "..page
	end
	condition = condition.." "..defaultPage

	return condition
end

function AB:UpdateButtonConfig(bar, buttonName)
	if InCombatLockdown() then self:RegisterEvent("PLAYER_REGEN_ENABLED"); return; end
	if not bar.buttonConfig then bar.buttonConfig = { hideElements = {}, colors = {} } end
	bar.buttonConfig.hideElements.macro = self.db.macroname
	bar.buttonConfig.hideElements.hotkey = self.db.hotkeys
	bar.buttonConfig.showGrid = self.db.showgrid
	bar.buttonConfig.clickOnDown = self.db.clickondown
	bar.buttonConfig.colors.range = { 1, 0.3, 0.1 }
	bar.buttonConfig.colors.mana = { 0.1, 0.3, 1 }
	bar.buttonConfig.colors.hp = { 0.1, 0.3, 1 }
	
	for i, button in pairs(bar.buttons) do
		bar.buttonConfig.keyBoundTarget = format(buttonName.."%d", i)
		button.keyBoundTarget = bar.buttonConfig.keyBoundTarget
		button.postKeybind = AB.UpdateHotkey
		button:SetAttribute("buttonlock", true)
		button:SetAttribute("checkselfcast", true)
		button:SetAttribute("checkfocuscast", true)
		
		button:UpdateConfig(bar.buttonConfig)
	end
end

function AB:CreateBar(id)
	local point, anchor, attachTo, x, y = string.split(",", self["DefaultPosition"]["bar"..id])
	local bar = CreateFrame("Frame", "RayUIActionBar"..id, UIParent, "SecureHandlerStateTemplate")
	bar:Point(point, anchor, attachTo, x, y)
	bar.id = id
	bar.buttons = {}
	bar.bindButtons = self["barDefaults"]["bar"..id].bindButtons
	for i=1, 12 do
		bar.buttons[i] = LAB:CreateButton(i, format(bar:GetName().."Button%d", i), bar, nil)
		bar.buttons[i]:SetState(0, "action", i)
		for k = 1, 14 do
			bar.buttons[i]:SetState(k, "action", (k - 1) * 12 + i)
		end
		
		if i == 12 then
			bar.buttons[i]:SetState(12, "custom", AB.customExitButton)
		end
	end
	self:UpdateButtonConfig(bar, bar.bindButtons)

	if AB["barDefaults"]["bar"..id].conditions:find("[form]") then
		bar:SetAttribute("hasTempBar", true)
	else
		bar:SetAttribute("hasTempBar", false)
	end
	
	bar:SetAttribute("_onstate-page", [[
		if HasTempShapeshiftActionBar() and self:GetAttribute("hasTempBar") then
			newstate = GetTempShapeshiftBarIndex() or newstate
		end	

		if newstate ~= 0 then
			self:SetAttribute("state", newstate)
			control:ChildUpdate("state", newstate)
		else
			local newCondition = self:GetAttribute("newCondition")
			if newCondition then
				newstate = SecureCmdOptionParse(newCondition)
				self:SetAttribute("state", newstate)
				control:ChildUpdate("state", newstate)
			end
		end
	]]);

	self["Handled"]["bar"..id] = bar
	self:UpdatePositionAndSize("bar"..id)
	R:CreateMover(bar, "ActionBar" .. id .. "Mover", L["动作条" .. id .. "锚点"], true, nil, "ALL,ACTIONBARS")
end

function AB:UpdatePositionAndSize(barName)
	local bar = self["Handled"][barName]
	local buttonsPerRow = self.db[barName].buttonsPerRow
	local buttonsize = self.db[barName].buttonsize
	local buttonspacing = self.db[barName].buttonspacing
	local numColumns = ceil(NUM_ACTIONBAR_BUTTONS / buttonsPerRow)

	bar:SetWidth(buttonsize*buttonsPerRow + buttonspacing*(buttonsPerRow - 1))
	bar:SetHeight(buttonsize*numColumns + buttonspacing*(numColumns - 1))

	local page = self:GetPage(barName, self["barDefaults"][barName].page, self["barDefaults"][barName].conditions)
	if AB["barDefaults"]["bar"..bar.id].conditions:find("[form,noform]") then
		bar:SetAttribute("hasTempBar", true)
		
		local newCondition = page
		newCondition = gsub(AB["barDefaults"]["bar"..bar.id].conditions, " %[form,noform%] 0; ", "")
		bar:SetAttribute("newCondition", newCondition)
	else
		bar:SetAttribute("hasTempBar", false)
	end

	bar:Show()
	RegisterStateDriver(bar, "visibility", self.barDefaults[barName].visibility)
	RegisterStateDriver(bar, "page", page)

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
		bar:SetScript("OnEnter", function(self)
			R:UIFrameFadeIn(bar,0.5,bar:GetAlpha(),1)
		end)
		bar:SetScript("OnLeave", function(self)
			R:UIFrameFadeOut(bar,0.5,bar:GetAlpha(),0)
		end)
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
	for i = 1, #bar.buttons do
		button = bar.buttons[i]
		lastButton = bar.buttons[i-1]
		lastColumnButton = bar.buttons[i-buttonsPerRow]
		button:SetSize(buttonsize, buttonsize)
		button:ClearAllPoints()

		if i == 1 then
			button:Point("TOPLEFT", bar, "TOPLEFT", 0, 0)
		elseif (i - 1) % buttonsPerRow == 0 then
			button:Point("TOPLEFT", lastColumnButton, "BOTTOMLEFT", 0, -buttonspacing)
		else
			button:Point("LEFT", lastButton, "RIGHT", buttonspacing, 0)
		end

		if self.db[barName].mouseover then
			if not self.hooks[button] then
				self:HookScript(button, "OnEnter", function()
					R:UIFrameFadeIn(bar,0.5,bar:GetAlpha(),1)
				end)
				self:HookScript(button, "OnLeave", function()
					R:UIFrameFadeOut(bar,0.5,bar:GetAlpha(),0)
				end)
				SetCooldownSwipeAlpha(bar.buttons[i].cooldown, 0)
			end
		else
			if not self.hooks[button] then
				self:Unhook(button, "OnEnter")
				self:Unhook(button, "OnLeave")
			end
			SetCooldownSwipeAlpha(bar.buttons[i].cooldown, 1)
		end

		self:Style(button)
		button:SetCheckedTexture("")
		if(not self.handledbuttons[button]) then
			self.handledbuttons[button] = true
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

function AB:PLAYER_ENTERING_WORLD()
	SetActionBarToggles(true, true, true, true)
end

function AB:ReassignBindings(event)
	self:UnregisterEvent("PLAYER_REGEN_DISABLED")

	if InCombatLockdown() then return end	
	for _, bar in pairs(self["Handled"]) do
		if not bar or not bar.buttons then return end
		
		ClearOverrideBindings(bar)
		for i = 1, #bar.buttons do
			local button = (bar.bindButtons.."%d"):format(i)
			local real_button = (bar:GetName().."Button%d"):format(i)
			for k=1, select('#', GetBindingKey(button)) do
				local key = select(k, GetBindingKey(button))
				if key and key ~= "" then
					SetOverrideBindingClick(bar, false, key, real_button)
				end
			end
		end
	end
end

function AB:RemoveBindings()
	if InCombatLockdown() then return end	
	for _, bar in pairs(self["handledBars"]) do
		if not bar then return end
		
		ClearOverrideBindings(bar)
	end

	self:RegisterEvent("PLAYER_REGEN_DISABLED", "ReassignBindings")
end

function AB:Initialize()
	SetActionBarToggles(1, 1, 1, 1)

	self["DefaultPosition"] = {
		bar1 = "BOTTOM,UIParent,BOTTOM,"..(-3*AB.db.bar1.buttonsize - 3*AB.db.bar1.buttonspacing)..",235",
		bar2 = "BOTTOM,ActionBar1Mover,TOP,0,"..AB.db.bar2.buttonspacing,
		bar3 = "BOTTOMLEFT,ActionBar1Mover,BOTTOMRIGHT,"..AB.db.bar3.buttonspacing..",0",
		bar4 = "LEFT,UIParent,LEFT,15,0",
		bar5 = "RIGHT,UIParent,RIGHT,-15,0",
	}
	for i =1, 5 do
		self:CreateBar(i)
	end

	for button, _ in pairs(self["handledbuttons"]) do
		if button then
			self:StyleFlyout(button)
		else
			self["handledbuttons"][button] = nil
		end
	end
	self:CreateBarPet()
	self:CreateStanceBar()
	self:CreateVehicleExit()
	self:CreateExtraButton()
	self:CreateOverrideBar()
	self:LoadKeyBinder()
	self:EnableAutoHide()
	self:HideBlizz()
	self:CreateCooldown()

	SetCVar("countdownForCooldowns", "0")
	self:SecureHook("PetActionButton_SetHotkeys", "UpdateHotkey")
	self:SecureHook("ActionButton_UpdateFlyout", "StyleFlyout")
	self:SecureHook("StanceBar_Update", "StyleShift")
	self:SecureHook("StanceBar_UpdateState", "StyleShift")
	self:SecureHook("PossessBar_Update", "StylePossess")
	self:SecureHook("PetActionBar_Update", "StylePet")
	self:HookScript(SpellFlyout, "OnShow", "SetupFlyoutButton")

	self:RegisterEvent("PLAYER_ENTERING_WORLD")
	self:RegisterEvent("UPDATE_BINDINGS", "ReassignBindings")
	self:RegisterEvent("PET_BATTLE_CLOSE", "ReassignBindings")
	self:RegisterEvent("PET_BATTLE_OPENING_DONE", "RemoveBindings")
	self:PLAYER_ENTERING_WORLD()

	if C_PetBattles.IsInBattle() then
		self:RemoveBindings()
	else
		self:ReassignBindings()
	end

	self:StylePet()
	self:StyleShift()
	self:StylePossess()
end

function AB:Info()
	return L["|cff7aa6d6Ray|r|cffff0000U|r|cff7aa6d6I|r动作条模块."]
end

function AB:UpdateHotkey(button)
	local hotkey = _G[button:GetName() .. "HotKey"]
	local text = hotkey:GetText()
	if not text then return end

	text = string.gsub(text, "SHIFT%-", "S")
	text = string.gsub(text, "ALT%-", "A")
	text = string.gsub(text, "CTRL%-", "C")
	text = string.gsub(text, "BUTTON", "M")
	text = string.gsub(text, "MOUSEWHEELUP", "MwU")
	text = string.gsub(text, "MOUSEWHEELDOWN", "MwD")
	text = string.gsub(text, "NUMPAD", "NP")
	text = string.gsub(text, "PAGEUP", "PU")
	text = string.gsub(text, "PAGEDOWN", "PD")
	text = string.gsub(text, "SPACE", "SpB")
	text = string.gsub(text, "INSERT", "Ins")
	text = string.gsub(text, "HOME", "Hm")
	text = string.gsub(text, "DELETE", "Del")
	text = string.gsub(text, "NMULTIPLY", "*");
	text = string.gsub(text, "NMINUS", "N-");
	text = string.gsub(text, "NPLUS", "N+");
	text = string.gsub(text, "(s%-)", "S")
	text = string.gsub(text, "(a%-)", "A")
	text = string.gsub(text, "(c%-)", "C")
	text = string.gsub(text, "(Mouse Button )", "M")
	text = string.gsub(text, "(滑鼠按鍵)", "M")
	text = string.gsub(text, "(鼠标按键)", "M")
	text = string.gsub(text, KEY_BUTTON3, "M3")
	text = string.gsub(text, "(Num Pad )", "NP")
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

	hotkey:ClearAllPoints()
	hotkey:Point("TOP", 0, 5)
	hotkey:SetJustifyH("CENTER")
	hotkey:Width(AB.db.buttonsize + 10)
	hotkey:SetFont(R["media"].font, R["media"].fontsize, R["media"].fontflag)
end

function AB:Style(button)
	local name = button:GetName()
	local action = button.action

	if name:match("MultiCast") then return end

	if not button.equipped and not button.style then
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
	elseif not button.style then
		if button.equipped:IsShown() then
			button.equipped:Hide()
		end
	end

	if self["Skinned"][button] then return end

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
		button:CreateShadow("Background")
		if Icon then
			Icon:SetTexCoord(.08, .92, .08, .92)
			Icon:SetAllPoints()
		end
	end	

	if button.style then
		button.style:SetDrawLayer("BACKGROUND", -7)
		button.border:SetFrameLevel(button:GetFrameLevel())
		button.shadow:SetFrameLevel(button:GetFrameLevel())
	end

	if not name:find("OverrideActionBarButton") and not name:find("PetActionButton") then
		FixActionButtonCooldown(button)
	end
	button:StyleButton(true)
	self:UpdateHotkey(button)
	button.FlyoutUpdateFunc = AB.StyleFlyout
	self["Skinned"][button] = true
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

function AB:StylePossess()
	for i=1, NUM_POSSESS_SLOTS do
		local name = "PossessButton"..i
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
		local button = _G["SpellFlyoutButton"..i]
		if button then
			self:Style(_G["SpellFlyoutButton"..i], nil, true)
			_G["SpellFlyoutButton"..i]:StyleButton(true)

			if not AB.hooks[button] then
				AB:HookScript(button, "OnEnter", function(self)
					local bar = self:GetParent():GetParent():GetParent():GetParent()
					local id = bar:GetName():match("RayUIActionBar(%d)")
					if not id then return end
					if AB.db["bar"..id].mouseover then
						R:UIFrameFadeIn(bar,0.5,bar:GetAlpha(),1)
					end
				end)
				AB:HookScript(button, "OnLeave", function(self)
					local bar = self:GetParent():GetParent():GetParent():GetParent()
					local id = bar:GetName():match("RayUIActionBar(%d)")
					if not id then return end
					if AB.db["bar"..id].mouseover then
						R:UIFrameFadeOut(bar,0.5,bar:GetAlpha(),0)
					end
				end)
			end
		end
	end
end

function AB:StyleFlyout(button)
	if not button.FlyoutBorder then return end
	if not LAB.buttonRegistry[button] then return end
	local combat = InCombatLockdown()

	button.FlyoutBorder:SetAlpha(0)
	button.FlyoutBorderShadow:SetAlpha(0)

	SpellFlyoutHorizontalBackground:SetAlpha(0)
	SpellFlyoutVerticalBackground:SetAlpha(0)
	SpellFlyoutBackgroundEnd:SetAlpha(0)

	for i=1, GetNumFlyouts() do
		local x = GetFlyoutID(i)
		local _, _, numSlots, isKnown = GetFlyoutInfo(x)
		if isKnown and numSlots >  buttons then
			buttons = numSlots
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

	local arrowDistance
	if ((SpellFlyout:IsShown() and SpellFlyout:GetParent() == button) or GetMouseFocus() == button) then
		arrowDistance = 5
	else
		arrowDistance = 2
	end

	if button:GetParent() and button:GetParent():GetParent() and button:GetParent():GetParent():GetName() and button:GetParent():GetParent():GetName() == "SpellBookSpellIconsFrame" then 
		return 
	end

	if button:GetParent() then
		local point = R:GetScreenQuadrant(button:GetParent())
		if point == "UNKNOWN" then return end
		
		if strfind(point, "TOP") then
			button.FlyoutArrow:ClearAllPoints()
			button.FlyoutArrow:SetPoint("BOTTOM", button, "BOTTOM", 0, -arrowDistance)
			SetClampedTextureRotation(button.FlyoutArrow, 180)
			if not combat then button:SetAttribute("flyoutDirection", "DOWN") end			
		elseif point == "RIGHT" then
			button.FlyoutArrow:ClearAllPoints()
			button.FlyoutArrow:SetPoint("LEFT", button, "LEFT", -arrowDistance, 0)
			SetClampedTextureRotation(button.FlyoutArrow, 270)
			if not combat then button:SetAttribute("flyoutDirection", "LEFT") end		
		elseif point == "LEFT" then
			button.FlyoutArrow:ClearAllPoints()
			button.FlyoutArrow:SetPoint("RIGHT", button, "RIGHT", arrowDistance, 0)
			SetClampedTextureRotation(button.FlyoutArrow, 90)
			if not combat then button:SetAttribute("flyoutDirection", "RIGHT") end				
		elseif point == "CENTER" or strfind(point, "BOTTOM") then
			button.FlyoutArrow:ClearAllPoints()
			button.FlyoutArrow:SetPoint("TOP", button, "TOP", 0, arrowDistance)
			SetClampedTextureRotation(button.FlyoutArrow, 0)
			if not combat then button:SetAttribute("flyoutDirection", "UP") end
		end
	end
end

R:RegisterModule(AB:GetName())
