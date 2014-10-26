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

local normalButton = CreateFrame("Button", "IntelliMountNormalButton", UIParent, "SecureActionButtonTemplate,SecureHandlerMouseUpDownTemplate")

local SPELL_TRAVEL_FORM = 783
local SPELL_GHOST_WOLF = 2645

local playerClass = select(2, UnitClass("player"))

local function BuildCombatMacro()

    local m = "/leavevehicle [vehicleui]\n"

    m = m .. "/dismount [mounted]\n"

    if playerClass ==  "DRUID" then
        local forms = "2/3"
        if IsSpellKnown(SPELL_TRAVEL_FORM) then
            local s = GetSpellInfo(SPELL_TRAVEL_FORM)
            m = m .. string.format("/cast [outdoors,noform:%s] %s\n", forms, s)
        end
        m = m .. string.format("/cancelform [form:%s]\n", forms)
    elseif playerClass == "SHAMAN" then
        if IsSpellKnown(SPELL_GHOST_WOLF) then
            local s = GetSpellInfo(SPELL_GHOST_WOLF)
            m = m ..  "/cast [noform] " .. s .. "\n"
            m = m .. "/cancelform [form]\n"
        end
    end

    return m
end

local function SetAsInCombatAction()
    -- print("Setting action to in-combat action.")
    normalButton:SetAttribute("type", "macro")
	normalButton:SetAttribute("macrotext", BuildCombatMacro())
end

local function PreClick(self, mouseButton)

    if InCombatLockdown() then return end

    -- print("PreClick handler called. Button " .. (mouseButton or "nil"))

    -- In vehicle -> exit it
    if CanExitVehicle() then
        normalButton:SetAttribute("type", "macro")
		normalButton:SetAttribute("macrotext", SLASH_LEAVEVEHICLE1)
        return
    end

    -- Mounted -> dismount
    if IsMounted() then
        normalButton:SetAttribute("type", "macro")
		normalButton:SetAttribute("macrotext", SLASH_DISMOUNT1)
        return
    end

    --  3 = Travel Form
    --  4 = Aquatic Form
    -- 16 = Ghost Wolf
    -- 27 = Swift Flight Form
    local form = GetShapeshiftFormID()

    if playerClass == "DRUID" and form == 1 or form == 27 then
        normalButton:SetAttribute("type", "macro")
		normalButton:SetAttribute("macrotext", SLASH_CANCELFORM1)
        return
    elseif playerClass == "SHAMAN" and form == 16 then
        normalButton:SetAttribute("type", "macro")
		normalButton:SetAttribute("macrotext", SLASH_CANCELFORM1)
        return
    end

	local seahorse = self:GetAttribute("abyssSeahorse")
	if seahorse then
		normalButton:SetAttribute("type", "macro")
		normalButton:SetAttribute("macrotext", "/cast "..seahorse)
	end

	local broom = self:GetAttribute("magicBroom")
	if not IsIndoors() and IsPlayerMoving() and broom then
		normalButton:SetAttribute("type", "macro")
		normalButton:SetAttribute("macrotext", "/use item:37011")
	end

	if not IsIndoors() and self:GetAttribute("dragonwrath") then
		normalButton:SetAttribute("type", "macro")
		normalButton:SetAttribute("macrotext", "/use 16")
	end

	if IsIndoors() or IsPlayerMoving() then return end

	normalButton:SetAttribute("type", "macro")
	normalButton:SetAttribute("macrotext", "/script C_MountJournal.Summon(0)")
end

local function PostClick()
    if InCombatLockdown() then return end

    -- print("PostClick handler called.")

    SetAsInCombatAction()
end

normalButton:SetID(1)
normalButton:SetScript("PreClick", PreClick)
normalButton:SetScript("PostClick", PostClick)
normalButton:SetAttribute("type", "macro")
normalButton:SetAttribute("unit", "player")
normalButton:RegisterForClicks("AnyDown")

SetAsInCombatAction()

normalButton:SetScript("OnMouseDown", function(self)
	if not InCombatLockdown() then
		self:SetAttribute("abyssSeahorse", addon:GetAbyssalSeahorse())
	end
end)

local passengerButton = CreateFrame("Button", "IntelliMountPassengerButton", UIParent, "SecureActionButtonTemplate")
passengerButton:SetID(2)
passengerButton:SetAttribute("type", "spell")

local vendorButton = CreateFrame("Button", "IntelliMountVendorsButton", UIParent, "SecureActionButtonTemplate")
vendorButton:SetID(3)
vendorButton:SetAttribute("type", "spell")

local waterStriderButton = CreateFrame("Button", "IntelliMountWaterStriderButton", UIParent, "SecureActionButtonTemplate")
waterStriderButton:SetID(4)
waterStriderButton:SetAttribute("type", "spell")

local needUpdateBindings, needUpdateAttributes

local function Button_UpdateHotkeys(self)
	ClearOverrideBindings(self)
	local key1, key2 = GetBindingKey("INTELLIMOUNT_HOTKEY"..self:GetID())
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

	-- normalButton:SetAttribute("combatShift", addon.combatShift)
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