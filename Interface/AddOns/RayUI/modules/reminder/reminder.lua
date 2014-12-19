local R, L, P = unpack(select(2, ...))
local RM = R:NewModule("Reminder", "AceTimer-3.0")
RM.CreatedReminders = {}

function RM:PlayerHasFilteredBuff(frame, db, checkPersonal)
	for buff, value in pairs(db) do
		if value == true then
			local name = GetSpellInfo(buff);
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

	return false;
end

function RM:PlayerHasFilteredDebuff(frame, db)
	for debuff, value in pairs(db) do
		if value == true then
			local name = GetSpellInfo(debuff)
			local _, _, icon, _, _, _, _, unitCaster, _, _, _ = UnitDebuff("player", name)
		
			if (name and icon) then
				return true
			end
		end
	end
	
	return false;
end

function RM:CanSpellBeUsed(id)
	local name = GetSpellInfo(id)
	local start, duration, enabled = GetSpellCooldown(name)
	if enabled == 0 or start == nil or duration == nil then 
		return false
	elseif start > 0 and duration > 1.5 then	--On Cooldown
		return false
	else --Off Cooldown
		return true
	end
end

function RM:ReminderIcon_OnUpdate(elapsed)
	if self.ForceShow and self.icon:GetTexture() then return; end
	if(self.elapsed and self.elapsed > 0.2) then
		local db = P["Reminder"].filters[R.myclass][self.groupName]
		if not db or not db.enable or UnitIsDeadOrGhost("player") then return; end
		if db.CDSpell then
			local filterCheck = RM:FilterCheck(self)
			local name = GetSpellInfo(db.CDSpell)
			local start, duration, enabled = GetSpellCooldown(name)
			if(duration and duration > 0) then
				self.cooldown:SetCooldown(start, duration)
				self.cooldown:Show()
			else
				self.cooldown:Hide()
			end
					
			if RM:CanSpellBeUsed(db.CDSpell) and filterCheck then				
				if db.OnCooldown == "HIDE" then				
					RM:UpdateColors(self, db.CDSpell)
					RM.ReminderIcon_OnEvent(self)
				else
					self:SetAlpha(db.cdFade or 0)
				end
			elseif filterCheck then
				if db.OnCooldown == "HIDE" then
					self:SetAlpha(db.cdFade or 0)
				else					
					RM:UpdateColors(self, db.CDSpell)
					RM.ReminderIcon_OnEvent(self)
				end
			else
				self:SetAlpha(0)
			end	
			
			self.elapsed = 0
			return			
		end
	
		if db.spellGroup then
			for buff, value in pairs(db.spellGroup) do
				if value == true and RM:CanSpellBeUsed(buff) then				
					self:SetScript("OnUpdate", nil)
					RM.ReminderIcon_OnEvent(self)
				end
			end		
		end
	
		self.elapsed = 0
	else
		self.elapsed = (self.elapsed or 0) + elapsed
	end
end

function RM:FilterCheck(frame, isReverse)
	local _, instanceType = IsInInstance()
	local roleCheck, treeCheck, combatCheck, instanceCheck, PVPCheck
	
	local db = P["Reminder"].filters[R.myclass][frame.groupName]
	
	if db.role then
		if db.role == R.Role or db.role == "ANY" then
			roleCheck = true
		else
			roleCheck = nil
		end
	else
		roleCheck = true
	end

	if db.tree then
		if db.tree == GetSpecialization() or db.tree == "ANY" then
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
	
	if isReverse and (combatCheck or instanceCheck or PVPCheck) then
		return true
	elseif roleCheck and treeCheck and (combatCheck or instanceCheck or PVPCheck) then
		return true
	else
		return false
	end
end

function RM:ReminderIcon_OnEvent(event, unit)
	if (event == "UNIT_AURA" and unit ~= "player") then return; end
	
	local db = P["Reminder"].filters[R.myclass][self.groupName]
	
	self.cooldown:Hide()
	self:SetAlpha(0)
	self.icon:SetTexture(nil)

	if not db or not db.enable or (not db.spellGroup and not db.weaponCheck and not db.CDSpell) or UnitIsDeadOrGhost("player") then 
		self:SetScript("OnUpdate", nil)
		self:SetAlpha(0)
		self.icon:SetTexture(nil);	
		
		if not db then
			RM.CreatedReminders[self.groupName] = nil
		end
		return; 
	end
	
	--Level Check
	if db.level and UnitLevel("player") < db.level and not self.ForceShow then return; end
	
	--Negate Spells Check
	if db.negateGroup and RM:PlayerHasFilteredBuff(self, db.negateGroup) and not self.ForceShow then return; end
	
	local hasOffhandWeapon = OffhandHasWeapon()
	local hasMainHandEnchant, _, _, hasOffHandEnchant, _, _ = GetWeaponEnchantInfo()
	local hasBuff, hasDebuff
	if db.spellGroup and not db.CDSpell then
		for buff, value in pairs(db.spellGroup) do
			if value == true then
				local name = GetSpellInfo(buff)
				local usable, nomana = IsUsableSpell(name)
				if usable and not RM:CanSpellBeUsed(buff) then
					self:SetScript("OnUpdate", RM.ReminderIcon_OnUpdate)
					return
				end
				
				if (usable or nomana) or not db.strictFilter or self.ForceShow then
					self.icon:SetTexture(select(3, GetSpellInfo(buff)))
					break
				end		
			end
		end

		if (not self.icon:GetTexture() and event == "PLAYER_ENTERING_WORLD") then
			self:UnregisterAllEvents()
			self:RegisterEvent("LEARNED_SPELL_IN_TAB")
			return
		elseif (self.icon:GetTexture() and event == "LEARNED_SPELL_IN_TAB") then
			self:UnregisterAllEvents()
			self:RegisterEvent("UNIT_AURA")
			self:RegisterEvent("ACTIONBAR_UPDATE_COOLDOWN")
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
		
		hasBuff, hasDebuff = RM:PlayerHasFilteredBuff(self, db.spellGroup, db.personal), RM:PlayerHasFilteredDebuff(self, db.spellGroup)
	end
	
	if db.weaponCheck then
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
	
	if db.CDSpell then
		if type(db.CDSpell) == "boolean" then return; end
		local name = GetSpellInfo(db.CDSpell)
		local usable, nomana = IsUsableSpell(name)
		if not usable then return; end
		
		self:SetScript("OnUpdate", RM.ReminderIcon_OnUpdate)
		
		self.icon:SetTexture(select(3, GetSpellInfo(db.CDSpell)))

		self:UnregisterAllEvents()
	end
	
	if self.ForceShow and self.icon:GetTexture() then
		self:SetAlpha(1)
		return
	elseif self.ForceShow then
		print("Attempted to show a reminder icon that does not have any spells. You must add a spell first.")
		return
	end
	
	if not self.icon:GetTexture() or UnitInVehicle("player") then return; end

	local filterCheck = RM:FilterCheck(self)
	local reverseCheck = RM:FilterCheck(self, true)
	
	if db.CDSpell then
		if filterCheck then
			self:SetAlpha(1)
		end
		return
	end
	
	local activeTree = GetSpecialization()
	if db.spellGroup and not db.weaponCheck then
		if filterCheck and ((not hasBuff) and (not hasDebuff)) and not db.reverseCheck then
			self:SetAlpha(1)
		elseif reverseCheck and db.reverseCheck and (hasBuff or hasDebuff) and not (db.talentTreeException == activeTree) then
			self:SetAlpha(1)
		elseif reverseCheck and db.reverseCheck and ((not hasBuff) and (not hasDebuff)) and (db.talentTreeException == activeTree) then
			self:SetAlpha(1)
		end
	elseif db.weaponCheck then
		if filterCheck then
			if not hasOffhandWeapon and not hasMainHandEnchant then
				self:SetAlpha(1)
				self.icon:SetTexture(GetInventoryItemTexture("player", 16))
			elseif hasOffhandWeapon and (not hasMainHandEnchant or not hasOffHandEnchant) then				
				if not hasMainHandEnchant then
					self.icon:SetTexture(GetInventoryItemTexture("player", 16))
				else
					self.icon:SetTexture(GetInventoryItemTexture("player", 17))
				end
				self:SetAlpha(1)
			end
		end
	end
	
	if not db.disableSound and self:GetAlpha() == 1 then
		if not RM.SoundThrottled then
			RM.SoundThrottled = true
			PlaySoundFile(R["media"].warning)
			RM:ScheduleTimer("ThrottleSound", 10)
		end
	end
end

function RM:ThrottleSound()
	self.SoundThrottled = nil
	self:CancelAllTimers()
end

function RM:GetReminderIcon(name)
	return self.CreatedReminders[name]
end

function RM:ToggleIcon(name)
	local frame = self:GetReminderIcon(name)
	if not frame then return; end
	if not frame.ForceShow then
		frame.ForceShow = true
	else
		frame.ForceShow = nil
	end
	
	RM.ReminderIcon_OnEvent(frame)
end

function RM:CreateReminder(name, index)
	if self.CreatedReminders[name] then return end

	local frame = CreateFrame("Button", "ReminderIcon"..index, UIParent)
	frame:CreateShadow("Background")
	frame:Size(57, 57)
	frame.groupName = name
	frame:Point("BOTTOM", RayUF_player, "TOP", 0, 130)
	R:CreateMover(frame, "ReminderMover", L["重要buff提醒锚点"], true, nil)
	frame.icon = frame:CreateTexture(nil, "OVERLAY")
	frame.icon:SetTexCoord(.08, .92, .08, .92)
	frame.icon:SetAllPoints()
	frame:EnableMouse(false)
	frame:SetAlpha(0)
	
	local cd = CreateFrame("Cooldown", nil, frame)
	cd:SetAllPoints(frame.icon)	
	frame.cooldown = cd

	frame:RegisterUnitEvent("UNIT_AURA", "player")
	frame:RegisterEvent("PLAYER_ENTERING_WORLD")
	frame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
	frame:RegisterEvent("UNIT_INVENTORY_CHANGED")
	frame:RegisterEvent("PLAYER_REGEN_ENABLED")
	frame:RegisterEvent("PLAYER_REGEN_DISABLED")
	frame:RegisterEvent("UNIT_ENTERING_VEHICLE")
	frame:RegisterEvent("UNIT_ENTERED_VEHICLE")
	frame:RegisterEvent("UNIT_EXITING_VEHICLE")
	frame:RegisterEvent("UNIT_EXITED_VEHICLE")
	frame:SetScript("OnEvent", RM.ReminderIcon_OnEvent)

	self.CreatedReminders[name] = frame
end

function RM:CheckForNewReminders()
	local db = P["Reminder"].filters[R.myclass]
	if not db then return end

	local index = 0
	for groupName, _ in pairs(db) do
		index = index + 1
		self:CreateReminder(groupName, index)
	end
end

function RM:Initialize()
	RM:CheckForNewReminders()
end

R:RegisterModule(RM:GetName())
