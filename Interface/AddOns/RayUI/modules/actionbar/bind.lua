local R, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local AB = R:GetModule("ActionBar")

local bind = CreateFrame("Frame", "HoverBind", UIParent)

function AB:ActivateBindMode()
	bind.active = true
	StaticPopup_Show("KEYBIND_MODE")
	AB:RegisterEvent("PLAYER_REGEN_DISABLED", "DeactivateBindMode", false)
	if self.OnAutoHideEvent then
		self:OnAutoHideEvent()
	end
end

function AB:DeactivateBindMode(save)
	if save then
		SaveBindings(GetCurrentBindingSet())
		R:Print(L["所有快捷键修改已储存"])
	else
		LoadBindings(GetCurrentBindingSet())
		R:Print(L["这次的快捷键修改已重设为上一次修改"])
	end
	bind.active = false
	self:BindHide()
	self:UnregisterEvent("PLAYER_REGEN_DISABLED")
	StaticPopup_Hide("KEYBIND_MODE")
	if self.OnAutoHideEvent then
		self:OnAutoHideEvent()
	end
end

function AB:BindHide()
	bind:ClearAllPoints()
	bind:Hide()
	GameTooltip:Hide()
end

function AB:BindListener(key)
	if key == "ESCAPE" or key == "RightButton" then
		for i = 1, #bind.button.bindings do
			SetBinding(bind.button.bindings[i])
		end
		R:Print(L["该按键的绑定已全部取消"].." |cff00ff00"..bind.button.name.."|r.")
		self:BindUpdate(bind.button, bind.spellmacro)
		if bind.spellmacro~="MACRO" then GameTooltip:Hide() end
		return
	end

	if key == "LSHIFT"
	or key == "RSHIFT"
	or key == "LCTRL"
	or key == "RCTRL"
	or key == "LALT"
	or key == "RALT"
	or key == "UNKNOWN"
	or key == "LeftButton"
	then return; end

	if key == "MiddleButton" then key = "BUTTON3"; end
	if key == "Button4" then key = "BUTTON4"; end
	if key == "Button5" then key = "BUTTON5"; end

	local alt = IsAltKeyDown() and "ALT-" or ""
	local ctrl = IsControlKeyDown() and "CTRL-" or ""
	local shift = IsShiftKeyDown() and "SHIFT-" or ""

	if not bind.spellmacro or bind.spellmacro == "PET" or bind.spellmacro == "STANCE" then
		SetBinding(alt..ctrl..shift..key, bind.button.bindstring)
	else
		SetBinding(alt..ctrl..shift..key, bind.spellmacro.." "..bind.button.name)
	end
	R:Print(alt..ctrl..shift..key.." |cff00ff00"..L["绑定至"].." |r"..bind.button.name..".")
	self:BindUpdate(bind.button, bind.spellmacro)
	if bind.spellmacro~="MACRO" then GameTooltip:Hide() end
end

function AB:BindUpdate(button, spellmacro)
	if not bind.active or InCombatLockdown() then return; end

	bind.button = button
	bind.spellmacro = spellmacro

	bind:ClearAllPoints()
	bind:SetAllPoints(button)
	bind:Show()

	ShoppingTooltip1:Hide()

	if spellmacro == "SPELL" then
		bind.button.id = SpellBook_GetSpellBookSlot(bind.button)
		bind.button.name = GetSpellBookItemName(bind.button.id, SpellBookFrame.bookType)

		GameTooltip:AddLine("Trigger")
		GameTooltip:Show()
		GameTooltip:SetScript("OnHide", function(tt)
			tt:SetOwner(bind, "ANCHOR_TOP")
			tt:SetPoint("BOTTOM", bind, "TOP", 0, 1)
			tt:AddLine(bind.button.name, 1, 1, 1)
			bind.button.bindings = {GetBindingKey(spellmacro.." "..bind.button.name)}
			if #bind.button.bindings == 0 then
				tt:AddLine(L["未绑定."], .6, .6, .6)
			else
				tt:AddDoubleLine(L["序号"], L["按键"], .6, .6, .6, .6, .6, .6)
				for i = 1, #bind.button.bindings do
					tt:AddDoubleLine(i, bind.button.bindings[i])
				end
			end
			tt:Show()
			tt:SetScript("OnHide", nil)
		end)
	elseif spellmacro == "MACRO" then
		bind.button.id = bind.button:GetID()

		if floor(.5+select(2,MacroFrameTab1Text:GetTextColor())*10)/10==.8 then bind.button.id = bind.button.id + 36; end

		bind.button.name = GetMacroInfo(bind.button.id)

		GameTooltip:SetOwner(bind, "ANCHOR_TOP")
		GameTooltip:SetPoint("BOTTOM", bind, "TOP", 0, 1)
		GameTooltip:AddLine(bind.button.name, 1, 1, 1)

		bind.button.bindings = {GetBindingKey(spellmacro.." "..bind.button.name)}
			if #bind.button.bindings == 0 then
				GameTooltip:AddLine(L["未绑定."], .6, .6, .6)
			else
				GameTooltip:AddDoubleLine(L["序号"], L["按键"], .6, .6, .6, .6, .6, .6)
				for i = 1, #bind.button.bindings do
					GameTooltip:AddDoubleLine(L["序号"]..i, bind.button.bindings[i], 1, 1, 1)
				end
			end
		GameTooltip:Show()
	elseif spellmacro=="STANCE" or spellmacro=="PET" then
		bind.button.id = tonumber(button:GetID())
		bind.button.name = button:GetName()

		if not bind.button.name then return; end

		if not bind.button.id or bind.button.id < 1 or bind.button.id > (spellmacro=="STANCE" and 10 or 12) then
			bind.button.bindstring = "CLICK "..bind.button.name..":LeftButton"
		else
			bind.button.bindstring = (spellmacro=="STANCE" and "SHAPESHIFTBUTTON" or "BONUSACTIONBUTTON")..bind.button.id
		end

		GameTooltip:AddLine("Trigger")
		GameTooltip:Show()
		GameTooltip:SetScript("OnHide", function(tt)
			tt:SetOwner(bind, "ANCHOR_NONE")
			tt:SetPoint("BOTTOM", bind, "TOP", 0, 1)
			tt:AddLine(bind.button.name, 1, 1, 1)
			bind.button.bindings = {GetBindingKey(bind.button.bindstring)}
			if #bind.button.bindings == 0 then
				tt:AddLine(L["未绑定."], .6, .6, .6)
			else
				tt:AddDoubleLine(L["序号"], L["按键"], .6, .6, .6, .6, .6, .6)
				for i = 1, #bind.button.bindings do
					tt:AddDoubleLine(i, bind.button.bindings[i])
				end
			end
			tt:Show()
			tt:SetScript("OnHide", nil)
		end)
	else
		bind.button.action = tonumber(button.action)
		bind.button.name = button:GetName()

		if not bind.button.name then return; end
		if (not bind.button.action or bind.button.action < 1 or bind.button.action > 132) and not (bind.button.keyBoundTarget) then
			bind.button.bindstring = "CLICK "..bind.button.name..":LeftButton"
		elseif bind.button.keyBoundTarget then
			bind.button.bindstring = bind.button.keyBoundTarget
		else
			local modact = 1+(bind.button.action-1)%12
			if bind.button.action < 25 or bind.button.action > 72 then
				bind.button.bindstring = "ACTIONBUTTON"..modact
			elseif bind.button.action < 73 and bind.button.action > 60 then
				bind.button.bindstring = "MULTIACTIONBAR1BUTTON"..modact
			elseif bind.button.action < 61 and bind.button.action > 48 then
				bind.button.bindstring = "MULTIACTIONBAR2BUTTON"..modact
			elseif bind.button.action < 49 and bind.button.action > 36 then
				bind.button.bindstring = "MULTIACTIONBAR4BUTTON"..modact
			elseif bind.button.action < 37 and bind.button.action > 24 then
				bind.button.bindstring = "MULTIACTIONBAR3BUTTON"..modact
			end
		end

		GameTooltip:AddLine("Trigger")
		GameTooltip:Show()
		GameTooltip:SetScript("OnHide", function(tt)
			tt:SetOwner(bind, "ANCHOR_TOP")
			tt:SetPoint("BOTTOM", bind, "TOP", 0, 4)
			tt:AddLine(bind.button.name, 1, 1, 1)
			bind.button.bindings = {GetBindingKey(bind.button.bindstring)}
			if #bind.button.bindings == 0 then
				tt:AddLine(L["未绑定."], .6, .6, .6)
			else
				tt:AddDoubleLine(L["序号"], L["按键"], .6, .6, .6, .6, .6, .6)
				for i = 1, #bind.button.bindings do
					tt:AddDoubleLine(i, bind.button.bindings[i])
				end
			end
			tt:Show()
			tt:SetScript("OnHide", nil)
		end)
	end
end

function AB:RegisterButtonBind(b, override)
	local stance = StanceButton1:GetScript("OnClick")
	local pet = PetActionButton1:GetScript("OnClick")
	local button = ActionButton1:GetScript("OnClick")
	if b.IsProtected and b.GetObjectType and b.GetScript and b:GetObjectType()=="CheckButton" and b:IsProtected() then
		local script = b:GetScript("OnClick")
		if script==button or override then
			b:HookScript("OnEnter", function(b) self:BindUpdate(b); end)
		elseif script==stance then
			b:HookScript("OnEnter", function(b) self:BindUpdate(b, "STANCE"); end)
		elseif script==pet then
			b:HookScript("OnEnter", function(b) self:BindUpdate(b, "PET"); end)
		end
	end
end

local elapsed = 0
function AB:Tooltip_OnUpdate(tooltip, e)
	elapsed = elapsed + e
	if elapsed < .2 then return else elapsed = 0; end
	if (not tooltip.comparing and IsModifiedClick("COMPAREITEMS")) then
		GameTooltip_ShowCompareItem(tooltip)
		tooltip.comparing = true
	elseif ( tooltip.comparing and not IsModifiedClick("COMPAREITEMS")) then
		for _, frame in pairs(tooltip.shoppingTooltips) do
			frame:Hide()
		end
		tooltip.comparing = false
	end
end

function AB:RegisterMacro(addon)
	if addon == "Blizzard_MacroUI" then
		for i=1, 36 do
			local b = _G["MacroButton"..i]
			b:HookScript("OnEnter", function(b) AB:BindUpdate(b, "MACRO") end)
		end
	end
end

function AB:LoadKeyBinder()
	bind:SetFrameStrata("DIALOG")
	bind:SetFrameLevel(99)
	bind:EnableMouse(true)
	bind:EnableKeyboard(true)
	bind:EnableMouseWheel(true)
	bind.texture = bind:CreateTexture()
	bind.texture:SetAllPoints(bind)
	bind.texture:SetTexture(0, 0, 0, .25)
	bind:Hide()

	self:HookScript(GameTooltip, "OnUpdate", "Tooltip_OnUpdate")
	hooksecurefunc(GameTooltip, "Hide", function(tooltip) for _, tt in pairs(tooltip.shoppingTooltips) do tt:Hide(); end end)

	bind:SetScript("OnLeave", function() self:BindHide() end)
	bind:SetScript("OnKeyUp", function(_, key) self:BindListener(key) end)
	bind:SetScript("OnMouseUp", function(_, key) self:BindListener(key) end)
	bind:SetScript("OnMouseWheel", function(_, delta) if delta>0 then self:BindListener("MOUSEWHEELUP") else self:BindListener("MOUSEWHEELDOWN"); end end)

	local b = EnumerateFrames()
	while b do
		self:RegisterButtonBind(b)
		b = EnumerateFrames(b)
	end

	for b, _ in pairs(self["handledbuttons"]) do
		self:RegisterButtonBind(b, true);
	end	

	for i=1, 12 do
		local b = _G["SpellButton"..i]
		b:HookScript("OnEnter", function(b) AB:BindUpdate(b, "SPELL"); end)
	end

	if not IsAddOnLoaded("Blizzard_MacroUI") then
		self:SecureHook("LoadAddOn", "RegisterMacro")
	else
		self:RegisterMacro("Blizzard_MacroUI")
	end

	self:RegisterChatCommand("bindkey", "ActivateBindMode")
	self:RegisterChatCommand("hoverbind", "ActivateBindMode")
	if not IsAddOnLoaded("HealBot") then
		self:RegisterChatCommand("hb", "ActivateBindMode")
	end
end

StaticPopupDialogs["KEYBIND_MODE"] = {
	text = L["将鼠标指向动作列上以绑定快捷键, 您可以按ESC或以右键点击快捷工具栏上任何一格以清除该位置的设定"],
	button1 = L["储存"],
	button2 = L["放弃"],
	OnAccept = function() AB:DeactivateBindMode(true) end,
	OnCancel = function() AB:DeactivateBindMode(false) end,
	timeout = 0,
	whileDead = 1,
	hideOnEscape = false
}
