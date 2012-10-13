local R, L, P = unpack(select(2, ...))
local RM = R:NewModule("Reminder", "AceTimer-3.0")
RM.CreatedReminders = {}

function RM:GetTexture(frame)
	frame:Show()
	local texture = frame.icon:GetTexture()
	frame:Hide()
	return texture
end

function RM:PlayerHasFilteredBuff(db, checkPersonal)
	for buff, value in pairs(db) do
		if value == true then
			local name = GetSpellInfo(buff)
			local _, _, icon, _, _, _, _, unitCaster, _, _, _ = UnitBuff("player", name)
			if checkPersonal then
				if (name and icon and unitCaster == "player") then
					return true
				end
			else
				if (name and icon) then
					return true
				end
			end
		end
	end

	return false
end

function RM:UpdateReminderIcon(event, unit)
	local db = P["Reminder"].filters[R.myclass][self.groupName]

	self:Hide()
	self.icon:SetTexture(nil)

	if not db or not db.enable or (not db.spellGroup and not db.weaponCheck and not db.stanceCheck) then return end

	--Level Check
	if db.level and UnitLevel("player") < db.level then return end

	--Negate Spells Check
	if db.negateGroup and RM:PlayerHasFilteredBuff(db.negateGroup) then return end

	local hasOffhandWeapon = OffhandHasWeapon()
	local hasMainHandEnchant, _, _, hasOffHandEnchant, _, _ = GetWeaponEnchantInfo()
	if db.spellGroup then
		for buff, value in pairs(db.spellGroup) do
			if value == true then
				local name = GetSpellInfo(buff)
				local usable, nomana = IsUsableSpell(name)
				if (usable or nomana) and IsSpellKnown(buff) then
					self.icon:SetTexture(select(3, GetSpellInfo(buff)))
					break
				end
			end
		end

		if (not RM:GetTexture(self) and event == "PLAYER_ENTERING_WORLD") then
			self:UnregisterAllEvents()
			self:RegisterEvent("LEARNED_SPELL_IN_TAB")
			return
		elseif (RM:GetTexture(self) and event == "LEARNED_SPELL_IN_TAB") then
			self:UnregisterAllEvents()
			self:RegisterEvent("UNIT_AURA")
			if db.combat then
				self:RegisterEvent("PLAYER_REGEN_ENABLED")
				self:RegisterEvent("PLAYER_REGEN_DISABLED")
			end

			if db.instance or db.pvp then
				self:RegisterEvent("ZONE_CHANGED_NEW_AREA")
			end

			if db.role then
				self:RegisterEvent("UNIT_INVENTORY_CHANGED")
			end
		end
		self:Hide()
	elseif db.stanceCheck and GetNumShapeshiftForms() > 0 then
        local index = GetShapeshiftForm()
        if index < 1 or index > GetNumShapeshiftForms() then
			self.icon:SetTexture(GetShapeshiftFormInfo(1))
        end

		if db.combat then
			self:RegisterEvent("PLAYER_REGEN_ENABLED")
			self:RegisterEvent("PLAYER_REGEN_DISABLED")
		end

		if db.instance or db.pvp then
			self:RegisterEvent("ZONE_CHANGED_NEW_AREA")
		end
	elseif db.weaponCheck then
		self:UnregisterAllEvents()
		self:RegisterEvent("UNIT_INVENTORY_CHANGED")

		if not hasOffhandWeapon and hasMainHandEnchant then
			self.icon:SetTexture(GetInventoryItemTexture("player", 16))
		else
			if not hasOffHandEnchant then
				self.icon:SetTexture(GetInventoryItemTexture("player", 17))
			end

			if not hasMainHandEnchant then
				self.icon:SetTexture(GetInventoryItemTexture("player", 16))
			end
		end

		if db.combat then
			self:RegisterEvent("PLAYER_REGEN_ENABLED")
			self:RegisterEvent("PLAYER_REGEN_DISABLED")
		end

		if db.instance or db.pvp then
			self:RegisterEvent("ZONE_CHANGED_NEW_AREA")
		end

		if db.role then
			self:RegisterEvent("UNIT_INVENTORY_CHANGED")
		end
	end

	local _, instanceType = IsInInstance()
	local roleCheck, treeCheck, combatCheck, instanceCheck, PVPCheck

	if db.role then
		if db.role == R.Role then
			roleCheck = true
		else
			roleCheck = nil
		end
	else
		roleCheck = true
	end

	if db.tree then
		if db.tree == GetSpecialization() then
			treeCheck = true
		else
			treeCheck = nil
		end
	else
		treeCheck = true
	end

	if db.combat then
		if InCombatLockdown() then
			combatCheck = true
		else
			combatCheck = nil
		end
	else
		combatCheck = true
	end

	if db.instance and (instanceType == "party" or instanceType == "raid") then
		instanceCheck = true
	else
		instanceCheck = nil
	end

	if db.pvp and (instanceType == "arena" or instanceType == "pvp") then
		PVPCheck = true
	else
		PVPCheck = nil
	end

	if not db.pvp and not db.instance then
		PVPCheck = true
		instanceCheck = true
	end

	if db.reverseCheck and not (db.role or db.tree) then db.reverseCheck = nil end
	if not RM:GetTexture(self) or UnitInVehicle("player") then self:Hide() return end

	if db.spellGroup then
		if roleCheck and treeCheck and combatCheck and (instanceCheck or PVPCheck) and not RM:PlayerHasFilteredBuff(db.spellGroup, db.personal) then
			self.hint = L["缺少"]..L[self.groupName]
			self:Show()
		elseif combatCheck and (instanceCheck or PVPCheck) and db.reverseCheck and (not roleCheck or not treeCheck) and RM:PlayerHasFilteredBuff(db.spellGroup, db.personal) and GetSpecialization() and not (db.talentTreeException == GetSpecialization()) then
			self.hint = L["请取消"]..L[self.groupName]
			self:Show()
		end
	elseif db.stanceCheck and GetNumShapeshiftForms() > 0 then
		if roleCheck and treeCheck and combatCheck and (instanceCheck or PVPCheck) then
            local index = GetShapeshiftForm()
            if index < 1 or index > GetNumShapeshiftForms() then
                self.hint = L["缺少"]..L[self.groupName]
                self:Show()
                self.icon:SetTexture(GetShapeshiftFormInfo(1))
            end
        end
	elseif db.weaponCheck then
		if roleCheck and treeCheck and combatCheck and (instanceCheck or PVPCheck) then
			if not hasOffhandWeapon and not hasMainHandEnchant then
				self.hint = L["缺少"]..L[self.groupName]
				self:Show()
				self.icon:SetTexture(GetInventoryItemTexture("player", 16))
			elseif hasOffhandWeapon and (not hasMainHandEnchant or not hasOffHandEnchant) then
				if not hasMainHandEnchant then
					self.icon:SetTexture(GetInventoryItemTexture("player", 16))
				else
					self.icon:SetTexture(GetInventoryItemTexture("player", 17))
				end
				self.hint = L["缺少"]..L[self.groupName]
				self:Show()
			end
		end
	end

	if self:IsShown() then
		if not RM.SoundThrottled then
			RM.SoundThrottled = true
			PlaySoundFile(R["media"].warning)
			RM:ScheduleTimer("ThrottleSound", 5)
		end
	end
end

function RM:ThrottleSound()
	self.SoundThrottled = nil
	self:CancelAllTimers()
end

function RM:CreateReminder(name, index)
	if self.CreatedReminders[name] then return end

	local frame = CreateFrame("Button", "ReminderIcon"..index, UIParent)
	frame:CreateShadow("Background")
	frame:Size(40, 40)
	frame.groupName = name
	frame:Point("CENTER", UIParent, "CENTER", 0, 200)
	frame.icon = frame:CreateTexture(nil, "OVERLAY")
	frame.icon:SetTexCoord(.08, .92, .08, .92)
	frame.icon:SetAllPoints()
	frame:StyleButton(true)
	frame:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_TOP", 0, 5)
		GameTooltip:ClearLines()
		GameTooltip:AddLine(self.hint)
		GameTooltip:Show()
	end)
	frame:SetScript("OnLeave", GameTooltip_Hide)
	frame:Hide()

	frame:RegisterUnitEvent("UNIT_AURA", "player")
	frame:RegisterEvent("PLAYER_ENTERING_WORLD")
	frame:RegisterEvent("UNIT_INVENTORY_CHANGED")
	frame:RegisterEvent("PLAYER_REGEN_ENABLED")
	frame:RegisterEvent("PLAYER_REGEN_DISABLED")
	frame:RegisterEvent("UNIT_ENTERING_VEHICLE")
	frame:RegisterEvent("UNIT_ENTERED_VEHICLE")
	frame:RegisterEvent("UNIT_EXITING_VEHICLE")
	frame:RegisterEvent("UNIT_EXITED_VEHICLE")
	frame:SetScript("OnEvent", RM.UpdateReminderIcon)

	self.CreatedReminders[name] = frame
end

function RM:UpdateAllIcons()
	for name, frame in pairs(self.CreatedReminders) do
		RM.UpdateReminderIcon(frame)
	end
end

function RM:CheckForNewReminders()
	local db = P["Reminder"].filters[R.myclass]
	if not db then return end

	local index = 0
	for groupName, _ in pairs(db) do
		index = index + 1
		self:CreateReminder(groupName, index)
	end

	self:UpdateAllIcons()
end

function RM:Initialize()
	RM:CheckForNewReminders()
end

R:RegisterModule(RM:GetName())
