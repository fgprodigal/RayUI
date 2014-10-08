local R, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local A = R:NewModule("Auras", "AceEvent-3.0", "AceHook-3.0")
local LSM = LibStub("LibSharedMedia-3.0")

A.modName = L["BUFF"]

local buttonsize = 30         -- Buff Size
local spacing = 8             -- Buff Spacing
local buffsperrow = 16        -- Buffs Per Row
local buffholder, debuffholder, enchantholder
local BUFF_FLASH_TIME_ON = 0.75
local BUFF_FLASH_TIME_OFF = 0.75
local BUFF_MIN_ALPHA = 0.3

local function formatTime(s)
	local day, hour, minute = 86400, 3600, 60
	if s >= day then
		return format("%dd", floor(s/day + 0.5)), s % day
	elseif s >= hour then
		return format("%dh", floor(s/hour + 0.5)), s % hour
	elseif s >= minute then
		return format("%dm", floor(s/minute + 0.5)), s % minute
	elseif s >= minute / 12 then
		return floor(s + 0.5), (s * 100 - floor(s * 100))/100
	end
	return format("%d", s), (s * 100 - floor(s * 100))/100
end

function A:UpdateAlpha(elapsed)
	self.BuffFrameFlashTime = self.BuffFrameFlashTime - elapsed
	if ( self.BuffFrameFlashTime < 0 ) then
		local overtime = -self.BuffFrameFlashTime
		if ( self.BuffFrameFlashState == 0 ) then
			self.BuffFrameFlashState = 1
			self.BuffFrameFlashTime = BUFF_FLASH_TIME_ON
		else
			self.BuffFrameFlashState = 0
			self.BuffFrameFlashTime = BUFF_FLASH_TIME_OFF
		end
		if ( overtime < self.BuffFrameFlashTime ) then
			self.BuffFrameFlashTime = self.BuffFrameFlashTime - overtime
		end
	end

	if ( self.BuffFrameFlashState == 1 ) then
		self.BuffAlphaValue = (BUFF_FLASH_TIME_ON - self.BuffFrameFlashTime) / BUFF_FLASH_TIME_ON
	else
		self.BuffAlphaValue = self.BuffFrameFlashTime / BUFF_FLASH_TIME_ON
	end
	self.BuffAlphaValue = (self.BuffAlphaValue * (1 - BUFF_MIN_ALPHA)) + BUFF_MIN_ALPHA
end

function A:UpdateTime(elapsed)
	if(self.offset) then
		local expiration = select(self.offset, GetWeaponEnchantInfo())
		if(expiration) then
			self.timeLeft = expiration / 1e3
		else
			self.timeLeft = 0
		end
	end

	if(self.timeLeft) then
		self.timeLeft = math.max(self.timeLeft - elapsed, 0)
		if(self.timeLeft <= 0) then
			self:SetAlpha(1)
			self.time:SetText("")
		else
			local time = formatTime(self.timeLeft)
			if self.timeLeft <= 86400.5 and self.timeLeft > 3600.5 then
				self.time:SetText(NORMAL_FONT_COLOR_CODE..time.."|r")
				self:SetAlpha(1)
			elseif self.timeLeft <= 3600.5 and self.timeLeft > 60.5 then
				self.time:SetText(NORMAL_FONT_COLOR_CODE..time.."|r")
				self:SetAlpha(1)
			elseif self.timeLeft <= 60.5 then
				self.time:SetText("|cffff0000"..time.."|r")
				if A.AlphaFrame then
					self:SetAlpha(A.AlphaFrame.BuffAlphaValue)
				end
			end
		end
	end
end

function A:CreateIcon(button)
	button.texture = button:CreateTexture(nil, "BORDER")
	button.texture:SetTexCoord(.08, .92, .08, .92)
	button.texture:SetAllPoints()

	button.count = button:CreateFontString(nil, "ARTWORK")
	button.count:Point("TOPRIGHT", 2, 2)
	button.count:SetFont(R["media"].cdfont, 14, "OUTLINE")

	button.time = button:CreateFontString(nil, "ARTWORK")
	button.time:Point("CENTER", button, "BOTTOM", 2, -1)
	button.time:SetFont(R["media"].cdfont, 14, "OUTLINE")

	button:SetScript("OnUpdate", A.UpdateTime)
	button:HookScript("OnClick", function(self, button)
		if button == "LeftButton" and IsShiftKeyDown() then
			local name, _, _, _, _, _, _, _, _, _, spellID = UnitAura(SecureButton_GetUnit(self:GetParent()), self:GetID(), self:GetParent():GetAttribute("filter"))
			R:Print(self:GetParent():GetAttribute("filter") == "HELPFUL" and "BUFF" or "DEBUFF", name, spellID)
		end
	end)

	button:CreateShadow("Background")
	button.shadow:SetBackdropColor(0, 0, 0)

	button.highlight = button:CreateTexture(nil, "HIGHLIGHT")
	button.highlight:SetTexture(1,1,1,0.45)
	button.highlight:SetAllPoints(button.texture)

	button:SetScript("OnAttributeChanged", A.OnAttributeChanged)
end

function A:UpdateAura(button, index)
	local filter = button:GetParent():GetAttribute("filter")
	local unit = button:GetParent():GetAttribute("unit")
	local name, rank, texture, count, dtype, duration, expirationTime, caster, isStealable, shouldConsolidate, spellID, canApplyAura, isBossDebuff = UnitAura(unit, index, filter)

	if(name) then
		if(duration > 0 and expirationTime) then
			local timeLeft = expirationTime - GetTime()
			if(not button.timeLeft) then
				button.timeLeft = timeLeft
				button:SetScript("OnUpdate", A.UpdateTime)
			else
				button.timeLeft = timeLeft
			end

			button.nextUpdate = -1
			A.UpdateTime(button, 0)
		else
			button.timeLeft = nil
			button.time:SetText("")
			button:SetScript("OnUpdate", nil)
			button:SetAlpha(1)
		end

		if(count > 1) then
			button.count:SetText(count)
		else
			button.count:SetText("")
		end		

		if filter == "HARMFUL" then
			local color = DebuffTypeColor[dtype] or DebuffTypeColor.none
			button.border:SetBackdropBorderColor(color.r, color.g, color.b)
			button.texture:SetInside(button, 1, 1)
		end
		
		button.texture:SetTexture(texture)
		button.offset = nil
	end
end

function A:UpdateTempEnchant(button, index)
	local quality = GetInventoryItemQuality("player", index)
	button.texture:SetTexture(GetInventoryItemTexture("player", index))

	-- time left
	local offset = 2
	local weapon = button:GetName():sub(-1)
	if weapon:match("2") then
		offset = 5
	end
	
	if(quality) then
		button:SetBackdropBorderColor(GetItemQualityColor(quality))
	end
	
	local expirationTime = select(offset, GetWeaponEnchantInfo())
	if(expirationTime) then
		button.offset = offset
		button:SetScript("OnUpdate", A.UpdateTime)
		button.nextUpdate = -1
		A.UpdateTime(button, 0)
	else
		button.timeLeft = nil
		button.offset = nil
		button:SetScript("OnUpdate", nil)
		button:SetAlpha(1)
		button.time:SetText("")
	end
end

function A:OnAttributeChanged(attribute, value)
	if(attribute == "index") then
		A:UpdateAura(self, value)
	elseif(attribute == "target-slot") then
		A:UpdateTempEnchant(self, value)
	end
end

function A:UpdateHeader(header)
	header:SetAttribute("consolidateTo", (R.db.Misc.raidbuffreminder == true and R.db.Misc.consolidate == true) and 1 or 0)
	header:SetAttribute("maxWraps", 1)
	header:SetAttribute("sortMethod", "TIME")
	header:SetAttribute("sortDirection", "+")
	header:SetAttribute("wrapAfter", buffsperrow)

	header:SetAttribute("minWidth", buttonsize*buffsperrow + spacing*(buffsperrow-1))
	header:SetAttribute("minHeight", buttonsize)
	header:SetAttribute("wrapYOffset", -(buttonsize + spacing))
	AurasHolder:Width(header:GetAttribute("minWidth"))

	if header:GetAttribute("filter") == "HELPFUL" then
		header:SetAttribute("separateOwn", 1)
		header:SetAttribute("maxWraps", 3)
		header:SetAttribute("minHeight", buttonsize*3 + spacing*2)
		header:SetAttribute("weaponTemplate", ("RayUIAuraTemplate%d"):format(buttonsize))
	end

	header:SetAttribute("template", ("RayUIAuraTemplate%d"):format(buttonsize))
	A:PostDrag()
end

function A:CreateAuraHeader(filter)
	local name
	if filter == "HELPFUL" then name = "RayUIPlayerBuffs" else name = "RayUIPlayerDebuffs" end

	local header = CreateFrame("Frame", name, UIParent, "SecureAuraHeaderTemplate")
	header:SetClampedToScreen(true)
	header:SetAttribute("template", "RayUIAuraTemplate30")
	header:SetAttribute("unit", "player")
	header:SetAttribute("filter", filter)
	RegisterStateDriver(header, "visibility", "[petbattle] hide; show")

	if filter == "HELPFUL" then
		header:SetAttribute('consolidateDuration', -1)
		header:SetAttribute("includeWeapons", 1)
	end

	A:UpdateHeader(header)
	header:Show()

	return header
end

function A:PostDrag(position)
	if InCombatLockdown() then return end
	local headers = {RayUIPlayerBuffs,RayUIPlayerDebuffs}
	for _, header in pairs(headers) do
		if header then
			if not position then position = R:GetScreenQuadrant(header) end
			if string.find(position, "LEFT") then
				header:SetAttribute("point", "TOPLEFT")
				header:SetAttribute("xOffset", buttonsize + spacing)
			else
				header:SetAttribute("point", "TOPRIGHT")
				header:SetAttribute("xOffset", -(buttonsize + spacing))
			end

			header:ClearAllPoints()
		end
	end

	if string.find(position, "LEFT") then
		RayUIPlayerBuffs:Point("TOPLEFT", AurasHolder, "TOPLEFT", 0, 0)

		if RayUIPlayerDebuffs then
			RayUIPlayerDebuffs:Point("BOTTOMLEFT", RayUIPlayerBuffs, "BOTTOMLEFT", 0,0)
		end
	else
		RayUIPlayerBuffs:Point("TOPRIGHT", AurasHolder, "TOPRIGHT", 0, 0)

		if RayUIPlayerDebuffs then
			RayUIPlayerDebuffs:Point("BOTTOMRIGHT", AurasHolder, "BOTTOMRIGHT", 0, 0)
		end
	end
end

function A:Initialize()
	BuffFrame:Kill()
	ConsolidatedBuffs:Kill()
	TemporaryEnchantFrame:Kill()
	InterfaceOptionsFrameCategoriesButton12:SetScale(0.0001)

	local AurasHolder = CreateFrame("Frame", "AurasHolder", UIParent)
	AurasHolder:Height(R:Scale(buttonsize)*4 + R:Scale(spacing)*3)
	AurasHolder:Width(R:Scale(buttonsize)*buffsperrow + R:Scale(spacing)*(buffsperrow-1))
	AurasHolder:SetFrameStrata("BACKGROUND")
	AurasHolder:SetClampedToScreen(true)
	AurasHolder:SetAlpha(0)
	AurasHolder:Point("TOPRIGHT", UIParent, "TOPRIGHT", -14, -53)
	R:CreateMover(AurasHolder, "AurasMover", L["Buff锚点"], true, A.PostDrag)

	self.BuffFrame = self:CreateAuraHeader("HELPFUL")
	self.DebuffFrame = self:CreateAuraHeader("HARMFUL")

	self.AlphaFrame = CreateFrame("Frame")
	self.AlphaFrame.BuffAlphaValue = 1
	self.AlphaFrame.BuffFrameFlashState = 1
	self.AlphaFrame.BuffFrameFlashTime = 0
	self.AlphaFrame:SetScript("OnUpdate", A.UpdateAlpha)
end

R:RegisterModule(A:GetName())
