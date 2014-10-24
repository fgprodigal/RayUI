------------------------------------------------------------
-- ActionButtons.lua
--
-- Abin
-- 2014/10/21
------------------------------------------------------------

local ClearOverrideBindings = ClearOverrideBindings
local GetBindingKey = GetBindingKey
local SetOverrideBindingClick = SetOverrideBindingClick
local InCombatLockdown = InCombatLockdown

local _, addon = ...

local normalButton = CreateFrame("Button", "EasyMountNormalButton", UIParent, "SecureActionButtonTemplate,SecureHandlerMouseUpDownTemplate")
normalButton:SetID(1)
normalButton:SetAttribute("type", "macro")
normalButton:SetAttribute("_onmouseup", [[
	local macro, spell
	local combatShift = self:GetAttribute("combatShift")
	local travelForm = self:GetAttribute("travelForm")
	local seahorse = self:GetAttribute("abyssSeahorse")
	local broom = self:GetAttribute("magicBroom")

	if UnitHasVehicleUI("player") then
		macro = "/script VehicleExit()"
	elseif IsMounted() then
		macro = "/dismount"
	elseif combatShift and PlayerInCombat() then
		spell = combatShift
	elseif travelForm and (IsFlyableArea() or IsSwimming()) then
		spell = travelForm
	elseif seahorse then
		spell = seahorse
	elseif self:GetAttribute("dragonwrath") then
		macro = "/use 16"
	elseif broom then
		spell = broom
	else
		macro = "/script C_MountJournal.Summon(0)"
	end

	self:SetAttribute("macrotext", macro or (spell and "/cast "..spell))
]])

local ABYSS_SEAHORSE = GetSpellInfo(75207)

normalButton:SetScript("OnMouseDown", function(self)
	if not InCombatLockdown() then
		-- Check if Abyss Seahorse is avialable
		if addon.db.seahorseFirst and IsUsableSpell(75207) then
			self:SetAttribute("abyssSeahorse", ABYSS_SEAHORSE)
		else
			self:SetAttribute("abyssSeahorse", nil)
		end
	end
end)

local passengerButton = CreateFrame("Button", "EasyMountPassengerButton", UIParent, "SecureActionButtonTemplate")
passengerButton:SetID(2)
passengerButton:SetAttribute("type", "spell")

local vendorButton = CreateFrame("Button", "EasyMountVendorsButton", UIParent, "SecureActionButtonTemplate")
vendorButton:SetID(3)
vendorButton:SetAttribute("type", "spell")

local waterStriderButton = CreateFrame("Button", "EasyMountWaterStriderButton", UIParent, "SecureActionButtonTemplate")
waterStriderButton:SetID(4)
waterStriderButton:SetAttribute("type", "spell")

local needUpdateBindings, needUpdateAttributes

local function Button_UpdateHotkeys(self)
	ClearOverrideBindings(self)
	local key1, key2 = GetBindingKey("EASYMOUNT_HOTKEY"..self:GetID())
	if key2 then
		SetOverrideBindingClick(self, false, key2, self:GetName())
	end

	if key1 then
		SetOverrideBindingClick(self, false, key1, self:GetName())
	end
end

local function UpdateBindings()
	needUpdateBindings = nil
	Button_UpdateHotkeys(normalButton)
	Button_UpdateHotkeys(passengerButton)
	Button_UpdateHotkeys(vendorButton)
	Button_UpdateHotkeys(waterStriderButton)
end

local function UpdateAttributes()
	needUpdateAttributes = nil

	normalButton:SetAttribute("combatShift", addon.combatShift)
	normalButton:SetAttribute("magicBroom", addon.db.broomFirst and addon.hasBroom)
	normalButton:SetAttribute("travelForm", addon.db.travelFormFirst and addon.hasTravelForm)
	normalButton:SetAttribute("dragonwrath", addon.dragonwrathFirst and addon.dragonwrathEquipped)

	passengerButton:SetAttribute("spell", addon.db.passengerMount)
	vendorButton:SetAttribute("spell", addon.db.vendorMount)
	waterStriderButton:SetAttribute("spell", addon.db.waterStrider)
end

function addon:UpdateBindings()
	if InCombatLockdown() then
		needUpdateBindings = 1
	else
		UpdateBindings()
	end
end

function addon:UpdateAttributes()
	if InCombatLockdown() then
		needUpdateAttributes = 1
	else
		UpdateAttributes()
	end
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("UPDATE_BINDINGS")
frame:RegisterEvent("PLAYER_REGEN_ENABLED")

frame:SetScript("OnEvent", function(self, event)
	if event == "UPDATE_BINDINGS" then
		addon:UpdateBindings()
	elseif event == "PLAYER_REGEN_ENABLED" then
		if needUpdateBindings then
			UpdateBindings()
		elseif needUpdateAttributes then
			UpdateAttributes()
		end
	end
end)