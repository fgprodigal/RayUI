local R, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local

local _, ns = ...
local oUF = RayUF or oUF

local addon = {}
ns.oUF_RaidDebuffs = addon
oUF_RaidDebuffs = ns.oUF_RaidDebuffs
if not _G.oUF_RaidDebuffs then
	_G.oUF_RaidDebuffs = addon
end

local debuff_data = {}
addon.DebuffData = debuff_data


addon.ShowDispelableDebuff = true
addon.FilterDispellableDebuff = true
addon.MatchBySpellName = true


addon.priority = 10

local function add(spell, priority)
	if addon.MatchBySpellName and type(spell) == 'number' then
		spell = GetSpellInfo(spell)
	end
	
	debuff_data[spell] = addon.priority + priority
end

function addon:RegisterDebuffs(t)
	for spell, value in pairs(t) do
		if type(t[spell]) == 'boolean' then
			local oldValue = t[spell]
			t[spell] = {
				['enable'] = oldValue,
				['priority'] = 0
			}
		else
			if t[spell].enable then
				add(spell, t[spell].priority)
			end
		end
	end
end

function addon:ResetDebuffData()
	wipe(debuff_data)
end

local DispellColor = {
	['Magic']	= {.2, .6, 1},
	['Curse']	= {.6, 0, 1},
	['Disease']	= {.6, .4, 0},
	['Poison']	= {0, .6, 0},
	['none'] = { 1, 0, 0},
}

local DispellPriority = {
	['Magic']	= 4,
	['Curse']	= 3,
	['Disease']	= 2,
	['Poison']	= 1,
}

local DispellFilter
do
	local dispellClasses = {
		['PRIEST'] = {
			['Magic'] = true,
			['Disease'] = true,
		},
		['SHAMAN'] = {
			['Magic'] = false,
			['Curse'] = true,
		},
		['PALADIN'] = {
			['Poison'] = true,
			['Magic'] = false,
			['Disease'] = true,
		},
		['MAGE'] = {
			['Curse'] = true,
		},
		['DRUID'] = {
			['Magic'] = false,
			['Curse'] = true,
			['Poison'] = true,
		},
		['MONK'] = {
			['Magic'] = false,
			['Disease'] = true,
			['Poison'] = true,
		},		
	}
	
	DispellFilter = dispellClasses[select(2, UnitClass('player'))] or {}
end

local function CheckTalentTree(tree)
	local activeGroup = GetActiveSpecGroup()
	if activeGroup and GetSpecialization(false, false, activeGroup) then
		return tree == GetSpecialization(false, false, activeGroup)
	end
end

local playerClass = select(2, UnitClass('player'))
local function CheckSpec(self, event, levels)
	-- Not interested in gained points from leveling
	if event == "CHARACTER_POINTS_CHANGED" and levels > 0 then return end
	
	--Check for certain talents to see if we can dispel magic or not
	if playerClass == "PALADIN" then
		if CheckTalentTree(1) then
			DispellFilter.Magic = true
		else
			DispellFilter.Magic = false	
		end
	elseif playerClass == "SHAMAN" then
		if CheckTalentTree(3) then
			DispellFilter.Magic = true
		else
			DispellFilter.Magic = false	
		end
	elseif playerClass == "DRUID" then
		if CheckTalentTree(4) then
			DispellFilter.Magic = true
		else
			DispellFilter.Magic = false	
		end
	elseif playerClass == "MONK" then
		if CheckTalentTree(2) then
			DispellFilter.Magic = true
		else
			DispellFilter.Magic = false	
		end		
	end
end

local eventframe = CreateFrame("Frame")
eventframe:RegisterEvent("PLAYER_ENTERING_WORLD")
eventframe:SetScript("OnEvent", function(self)
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	CheckSpec()
end)


local function formatTime(s)
	if s > 60 then
		return format('%dm', s/60), s%60
	else
		return format('%d', s), s - floor(s)
	end
end

local abs = math.abs
local function OnUpdate(self, elapsed)
	self.elapsed = (self.elapsed or 0) + elapsed
	if self.elapsed >= 0.1 then
		local timeLeft = self.endTime - GetTime()
		if self.reverse then timeLeft = abs((self.endTime - GetTime()) - self.duration) end
		if timeLeft > 0 then
			local text = formatTime(timeLeft)
			self.time:SetText(text)
		else
			self:SetScript('OnUpdate', nil)
			self.time:Hide()
		end
		self.elapsed = 0
	end
end

local function UpdateDebuff(self, name, icon, count, debuffType, duration, endTime, spellId)
	local f = self.RaidDebuffs

	if self.isForced and self:GetID() and math.fmod(self:GetID(), 2) == 0 then
		spellId = 47540
		name, _, icon = GetSpellInfo(spellId)
		count, debuffType, duration, timeLeft = 5, 'Magic', 0, 60
	end
	
	if name then
		f.icon:SetTexture(icon)
		f.icon:Show()
		f.duration = duration
		
		if f.count then
			if count and (count > 1) then
				f.count:SetText(count)
				f.count:Show()
			else
				f.count:SetText("")
				f.count:Hide()
			end
		end
		
        if ( spellId and select(4, unpack(RayUI)).Raid.RaidDebuffs.ascending[spellId]) or select(4, unpack(RayUI)).Raid.RaidDebuffs.ascending[name] then
            f.reverse = true
        else
            f.reverse = nil
        end
		
		if f.time then
			if duration and (duration > 0) then
				f.endTime = endTime
				f.nextUpdate = 0
				f:SetScript('OnUpdate', OnUpdate)
				f.time:Show()
			else
				f:SetScript('OnUpdate', nil)
				f.time:Hide()
			end
		end
		
		if f.cd then
			if duration and (duration > 0) then
				f.cd:SetCooldown(endTime - duration, duration)
				f.cd:Show()
			else
				f.cd:Hide()
			end
		end
		
        --local c = DispellColor[debuffType] or DispellColor.none
        local c = DebuffTypeColor[debuffType] or DebuffTypeColor.none
		f:SetBackdropBorderColor(c.r, c.g, c.b)
        if f.border then
            f.border:SetBackdropBorderColor(c.r, c.g, c.b)
        end
        if f.shadow then
            f.shadow:SetBackdropColor(0, 0, 0)
        end
		
		f:Show()
	else
		f:Hide()
	end
end

local blackList = {
	[105171] = true, -- Deep Corruption
	[108220] = true, -- Deep Corruption
}

local function Update(self, event, unit)
	if unit ~= self.unit then return end
	local _name, _icon, _count, _dtype, _duration, _endTime, _spellId
	local _priority, priority = 0, 0
	for i = 1, 40 do
		local name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, shouldConsolidate, spellId, canApplyAura, isBossDebuff = UnitAura(unit, i, 'HARMFUL')
		if (not name) then break end

		if addon.ShowDispelableDebuff and debuffType then
			if addon.FilterDispellableDebuff then
				DispellPriority[debuffType] = (DispellPriority[debuffType] or 0) + addon.priority --Make Dispell buffs on top of Boss Debuffs
				priority = DispellFilter[debuffType] and DispellPriority[debuffType] or 0
				if priority == 0 then
					debuffType = nil
				end
			else
				priority = DispellPriority[debuffType] or 0
			end

			if priority > _priority then
				_priority, _name, _icon, _count, _dtype, _duration, _endTime, _spellId = priority, name, icon, count, debuffType, duration, expirationTime, spellId
			end
		end
		
		--priority = debuff_data[addon.MatchBySpellName and name or spellId]
		if next(debuff_data) then
			priority = debuff_data[name] or debuff_data[spellId]
			if priority and not blackList[spellId] and (priority > _priority) then
				_priority, _name, _icon, _count, _dtype, _duration, _endTime, _spellId = priority, name, icon, count, debuffType, duration, expirationTime, spellId
			end
		else
			if ( CompactUnitFrame_UtilIsBossAura(unit, i, 'HARMFUL', false) ) then
				priority = 10
				if priority and not blackList[spellId] and (priority > _priority) then
					_priority, _name, _icon, _count, _dtype, _duration, _endTime, _spellId = priority, name, icon, count, debuffType, duration, expirationTime, spellId
				end
			end
		end
	end
	
	UpdateDebuff(self, _name, _icon, _count, _dtype, _duration, _endTime, _spellId)
	
	--Reset the DispellPriority
	DispellPriority = {
		['Magic']	= 4,
		['Curse']	= 3,
		['Disease']	= 2,
		['Poison']	= 1,
	}	
end

local function Enable(self)
	if self.RaidDebuffs then
		self:RegisterEvent('UNIT_AURA', Update)
		return true
	end
	--Need to run these always
	self:RegisterEvent("PLAYER_TALENT_UPDATE", CheckSpec)
	self:RegisterEvent("CHARACTER_POINTS_CHANGED", CheckSpec)
end

local function Disable(self)
	if self.RaidDebuffs then
		self:UnregisterEvent('UNIT_AURA', Update)
		self.RaidDebuffs:Hide()
	end
	self:UnregisterEvent("PLAYER_TALENT_UPDATE", CheckSpec)
	self:UnregisterEvent("CHARACTER_POINTS_CHANGED", CheckSpec)
end

oUF:AddElement('RaidDebuffs', Update, Enable, Disable)
