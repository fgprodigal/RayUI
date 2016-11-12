local R, L, P, G = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, GlobalDB
local M = R:GetModule("Misc")
local mod = M:NewModule("Cooldowns", "AceEvent-3.0", "AceHook-3.0")

--Cache global variables
--Lua functions
local select, string, pairs, math = select, string, pairs, math
local table, tinsert = table, table.insert
local GetTime = GetTime

--WoW API / Variables
local CreateFrame = CreateFrame
local GetActionInfo = GetActionInfo
local GetActionTexture = GetActionTexture
local GetInventoryItemID = GetInventoryItemID
local GetItemInfo = GetItemInfo
local GetInventoryItemTexture = GetInventoryItemTexture
local GetContainerItemID = GetContainerItemID
local GetSpellInfo = GetSpellInfo
local GetSpellTexture = GetSpellTexture
local GetSpellCooldown = GetSpellCooldown
local GetInventoryItemCooldown = GetInventoryItemCooldown
local GetContainerItemCooldown = GetContainerItemCooldown
local GetPetActionInfo = GetPetActionInfo
local GetPetActionCooldown = GetPetActionCooldown
local GetContainerItemInfo = GetContainerItemInfo
local CooldownFrame_Set = CooldownFrame_Set
local GetSpellTabInfo = GetSpellTabInfo
local GetSpellBookItemName = GetSpellBookItemName
local GetSpellBookItemInfo = GetSpellBookItemInfo
local GetFlyoutInfo = GetFlyoutInfo
local GetFlyoutSlotInfo = GetFlyoutSlotInfo
local GetSpellCharges = GetSpellCharges
local GetContainerNumSlots = GetContainerNumSlots
local HasPetUI = HasPetUI
local UnitExists = UnitExists
local C_Timer = C_Timer

--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: NUM_PET_ACTION_SLOTS, BOOKTYPE_SPELL, BOOKTYPE_PET, GameTooltip

local spells, chargespells = { [BOOKTYPE_SPELL] = { }, [BOOKTYPE_PET] = { }, }, { [BOOKTYPE_SPELL] = { }, [BOOKTYPE_PET] = { }, }
local visible = 0
mod.icons = {}
mod.size = 30
mod.spacing = 6

local function UpdateTooltip(self)
	-- GameTooltip:SetUnitAura(self:GetParent().__owner.unit, self:GetID(), self.filter)
end

local function OnEnter(self)
	if(not self:IsVisible()) then return end

	GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT")
	self:UpdateTooltip()
end

local function OnLeave()
	GameTooltip:Hide()
end

function mod:CreateCooldownIcon(index)
    local button = CreateFrame("Button", "RayUI_CooldownsButton"..index, self.Holder)
    button:SetSize(self.size, self.size)
    button:CreateShadow("Shadow")

    local cd = CreateFrame("Cooldown", "$parentCooldown", button, "CooldownFrameTemplate")
    cd:SetAllPoints(button)

    local icon = button:CreateTexture(nil, "BORDER")
    icon:SetTexCoord(.08, .92, .08, .92)
    icon:SetAllPoints(button)

    button.UpdateTooltip = UpdateTooltip
    button:SetScript("OnEnter", OnEnter)
    button:SetScript("OnLeave", OnLeave)

    button.icon = icon
    button.cd = cd

    return button
end

local function SortByTime(a, b)
    if a and b then
        if a:IsShown() and b:IsShown() then
            local aTime = a.expirationTime or -1
            local bTime = b.expirationTime or -1
            return aTime < bTime
        elseif a:IsShown() then
            return true
        end
    end
end

function mod:SetPosition()
    table.sort(self.icons, SortByTime)

    local sizex = self.size + self.spacing
    local sizey = self.size + self.spacing
    local anchor = self.db.growthx == "LEFT" and "RIGHT" or "LEFT"
    local growthx = self.db.growthx == "LEFT" and -1 or 1
    local growthy = self.db.growthy == "DOWN" and -1 or 1
    local cols = math.floor(400 / sizex + .5)

    for i = 1, #self.icons do
        local icon = self.icons[i]

        local col = (i - 1) % cols
        local row = math.floor((i - 1) / cols)
        if not icon or not icon:IsShown() then break end

        icon:ClearAllPoints()
        icon:SetPoint("RIGHT", self.Holder, "RIGHT", col * sizex * growthx, row * sizey * growthy)
    end
end

local function IconOnUpdate(self)
    local start, duration, enabled
    if self.type == "inventory" then
        start, duration, enabled = GetContainerItemCooldown(string.split("#", self.spellID))
    elseif self.type == "slot" then
        start, duration, enabled = GetInventoryItemCooldown("player", self.spellID)
    elseif self.type == "spell" then
        start, duration, enabled = GetSpellCooldown(self.spellID)
    elseif self.type == "pet" then
        start, duration, enabled = GetPetActionCooldown(self.spellID)
    end

    if start == 0 then
        self.type = nil
        self.start = nil
        self.duration = nil
        self.expirationTime = nil
        self.spellID = nil
        self:Hide()
        self:SetScript("OnUpdate", nil)
        mod:SetPosition()
        visible = visible - 1
	end
end

function mod:RemoveCooldown(type, spellID)
    for i, icon in pairs(self.icons) do
        if icon.spellID == spellID and icon.type == type then
            self.type = nil
            self.start = nil
            self.duration = nil
            self.expirationTime = nil
            self.spellID = nil
            self:Hide()
            self:SetScript("OnUpdate", nil)
            mod:SetPosition()
            visible = visible - 1
        end
    end
end

function mod:AddCooldown(type, spellID)
    local n = visible + 1
    local start, duration, enabled, texture
    if type == "inventory" then
        texture = GetContainerItemInfo(string.split("#", spellID))
        start, duration, enabled = GetContainerItemCooldown(string.split("#", spellID))
    elseif type == "slot" then
        texture = GetInventoryItemTexture("player", spellID)
        start, duration, enabled = GetInventoryItemCooldown("player", spellID)
    elseif type == "spell" then
        texture = GetSpellTexture(spellID)
        start, duration, enabled = GetSpellCooldown(spellID)
    elseif type == "pet" then
        texture = select(3, GetPetActionInfo(spellID))
        start, duration, enabled = GetPetActionCooldown(spellID)
    end

    for i, icon in pairs(self.icons) do
        if icon.spellID == spellID and icon.type == type then
			icon.start = start
		    icon.duration = duration
		    icon.expirationTime = start + duration
		    icon.spellID = spellID
		    icon.type = type
            CooldownFrame_Set(icon.cd, start, duration, true)
			self:SetPosition()
            return
        end
    end

    local icon = self.icons[n]
    if not icon then
        icon = self:CreateCooldownIcon(n)
        tinsert(self.icons, icon)
    end
    CooldownFrame_Set(icon.cd, start, duration, true)
    icon.icon:SetTexture(texture)
    icon.start = start
    icon.duration = duration
    icon.expirationTime = start + duration
    icon.spellID = spellID
    icon.type = type
    icon:SetScript("OnUpdate", IconOnUpdate)
    icon:Show()
    visible = visible + 1

    self:SetPosition()
end

function mod:CacheBook(btype)
    local lastID
    local sb = spells[btype]
    local _, _, offset, numSpells = GetSpellTabInfo(2)
    for i = 1, offset + numSpells do
        local spellName = GetSpellBookItemName(i, btype)
        if not spellName then break end
        local spellType, spellID = GetSpellBookItemInfo(i, btype)
        if spellID and spellType == "FLYOUT" then
            local _, _, numSlots, isKnown = GetFlyoutInfo(spellID)
            if isKnown then
                for j = 1, numSlots do
                    local flyID, _, _, flyName = GetFlyoutSlotInfo(spellID, j)
                    lastID = flyID
                    if flyID then
                        sb[flyID] = flyName
                    end
                end
            end
        elseif spellID and spellType == "SPELL" and spellID ~= lastID then
            lastID = spellID
            spellName, _, _, _, _, _, spellID = GetSpellInfo(spellName)
            if spellID then
                local _, maxCharges = GetSpellCharges(spellID)
                if maxCharges and maxCharges > 1 then
                    chargespells[btype][spellID] = spellName
                else
                    sb[spellID] = spellName
                end
            end
        end
    end
end

function mod:SPELLS_CHANGED()
    self:CacheBook(BOOKTYPE_SPELL)
	if self.db.showpets then
	    self:CacheBook(BOOKTYPE_PET)
	end
end

function mod:CheckSpellBook(btype)
	local threshold = btype == BOOKTYPE_SPELL and 2.5 or 4
    for id, name in pairs(spells[btype]) do
        local start, duration, enable = GetSpellCooldown(id)
        if enable == 1 and start > 0 then
            if duration > threshold then
                local _, _, texture = GetSpellInfo(id)
                mod:AddCooldown("spell", id)
            else
                for i = 1, #self.icons do
                end
            end
        end
    end
    for id, name in pairs(chargespells[btype]) do
        local start, duration, enable = GetSpellCooldown(id)
        local currentCharges, maxCharges, cooldownStart, cooldownDuration = GetSpellCharges(id)
        if cooldownStart and cooldownDuration and currentCharges < maxCharges and enable == 1 and start > 0 and duration > threshold then
            local _, _, texture = GetSpellInfo(id)
            mod:AddCooldown("spell", id)
        end
    end
end

function mod:BAG_UPDATE_COOLDOWN()
    for i = 1, (self.db.showequip and 18) or 0, 1 do
        local start, duration, enable = GetInventoryItemCooldown("player", i)
        if enable == 1 then
            if start > 0 then
                if duration > 5 and duration < 3601 then
                    mod:AddCooldown("slot", i)
                else
                    mod:RemoveCooldown("slot", i)
                end
            end
        end
    end
    for i = 0, (self.db.showbags and 18) or 0, 1 do
        for j = 1, GetContainerNumSlots(i), 1 do
            local start, duration, enable = GetContainerItemCooldown(i, j)
            if enable == 1 then
                if start > 0 then
                    if duration > 5 and duration < 3601 then
                        mod:AddCooldown("inventory", string.join("#", i, j))
                    end
                else
                    mod:RemoveCooldown("slot", i)
                end
            end
        end
    end
end

function mod:SPELL_UPDATE_COOLDOWN()
    self:CheckSpellBook(BOOKTYPE_SPELL)
    if self.db.showpets and HasPetUI() then
        self:CheckSpellBook(BOOKTYPE_PET)
    end
end

function mod:PET_BAR_UPDATE_COOLDOWN()
    for i = 1, 10, 1 do
        local start, duration, enable = GetPetActionCooldown(i)
        if enable == 1 then
            local name, _, texture = GetPetActionInfo(i)
            if name then
                if start > 0 then
                    if duration > 5 then
                        self:AddCooldown("pet", i)
                    end
                else
                    self:RemoveCooldown("pet", i)
                end
            end
        end
    end
end

function mod:UNIT_PET()
    if UnitExists("pet") and not HasPetUI() then
        self:RegisterEvent("PET_BAR_UPDATE_COOLDOWN")
    else
        self:UnregisterEvent("PET_BAR_UPDATE_COOLDOWN")
    end
end

function mod:PLAYER_ENTERING_WORLD(event)
	self:UnregisterEvent(event)

	self:RegisterEvent("SPELLS_CHANGED")
	self:RegisterEvent("SPELL_UPDATE_COOLDOWN")
	self:RegisterEvent("SPELL_UPDATE_CHARGES", "SPELL_UPDATE_COOLDOWN")

	if self.db.showequip or self.db.showbag then
		self:RegisterEvent("BAG_UPDATE_COOLDOWN")
		self:BAG_UPDATE_COOLDOWN()
	end
	if self.db.showequip then
		self:RegisterEvent("UNIT_INVENTORY_CHANGED", "BAG_UPDATE_COOLDOWN")
	end
	if self.db.showpets then
		self:RegisterEvent("UNIT_PET")
		self:UNIT_PET()
	end

	self:SPELLS_CHANGED()
	self:SPELL_UPDATE_COOLDOWN()
end

function mod:Initialize()
    self.db = M.db.cooldowns
	if not self.db.enable then return end

    self.Holder = CreateFrame("Frame", nil, R.UIParent)
    self.Holder:Size(self.db.size)
    self.Holder:Point("BOTTOMRIGHT", R.UIParent, "BOTTOM", -80, 530)
    R:CreateMover(self.Holder, "Cooldowns Mover", L["冷却条"], true, nil, "ALL,GENERAL,ACTIONBARS")

    self:RegisterEvent("PLAYER_ENTERING_WORLD")
end

M:RegisterMiscModule(mod:GetName())
