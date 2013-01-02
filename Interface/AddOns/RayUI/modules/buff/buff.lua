local R, L, P = unpack(select(2, ...)) --Inport: Engine, Locales, ProfileDB
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
	if(self.expiration) then
		self.expiration = math.max(self.expiration - elapsed, 0)
		if(self.expiration <= 0) then
			self:SetAlpha(1)
			self.time:SetText("")
		else
			local time = formatTime(self.expiration)
			if self.expiration <= 86400.5 and self.expiration > 3600.5 then
				self.time:SetText(NORMAL_FONT_COLOR_CODE..time.."|r")
				self:SetAlpha(1)
			elseif self.expiration <= 3600.5 and self.expiration > 60.5 then
				self.time:SetText(NORMAL_FONT_COLOR_CODE..time.."|r")
				self:SetAlpha(1)
			elseif self.expiration <= 60.5 then
				self.time:SetText("|cffff0000"..time.."|r")
				self:SetAlpha(A.AlphaFrame.BuffAlphaValue)
			end
		end
	end
end

function A:UpdateWeapon(button)
	if not button.shadow then
		button:Size(buttonsize, buttonsize)
		button:CreateShadow("Background")
		button.shadow:SetBackdropColor(0, 0, 0)
		button.border:SetBackdropBorderColor(137/255, 0, 191/255)

		button.time = _G[button:GetName().."Duration"]
		button.icon = _G[button:GetName().."Icon"]

		_G[button:GetName().."Border"]:Hide()
		button.icon:SetTexCoord(.08, .92, .08, .92)
		button.icon:SetInside(button, 1, 1)
		button.time:ClearAllPoints()
		button.time:Point("CENTER", button, "BOTTOM", 2, -1)
		button.time:SetFont(R["media"].cdfont, 11, "OUTLINE")
		button.time:SetShadowOffset(0, 0)

		button.highlight = button:CreateTexture(nil, "HIGHLIGHT")
		button.highlight:SetTexture(1,1,1,0.45)
		button.highlight:SetAllPoints(button.icon)
	end
end

function A:UpdateAuras(header, button)
	if(not button.texture) then
		button.texture = button:CreateTexture(nil, "BORDER")
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
	end

	local name, _, texture, count, dtype, duration, expiration = UnitAura(header:GetAttribute("unit"), button:GetID(), header:GetAttribute("filter"))

	if(name) then
		button.texture:SetTexture(texture)
		button.texture:SetTexCoord(.08, .92, .08, .92)
		button.count:SetText(count > 1 and count or "")
		button.expiration = expiration - GetTime()

		if(header:GetAttribute("filter") == "HARMFUL") then
			local color = DebuffTypeColor[dtype] or DebuffTypeColor.none
			button.border:SetBackdropBorderColor(color.r, color.g, color.b)
			button.texture:SetInside(button, 1, 1)
		end
	end
end

function A:ScanAuras(event, unit)
	if InCombatLockdown() then
		self:RegisterEvent("PLAYER_REGEN_ENABLED")
	end
	if(unit) then
		if(unit ~= PlayerFrame.unit) then return end
		if(unit ~= self:GetAttribute("unit")) and not InCombatLockdown() then
			self:SetAttribute("unit", unit)
		end
	end

	for index = 1, 32 do
		local child = self:GetAttribute("child" .. index)
		if(child) then
			A:UpdateAuras(self, child)
		end
	end

	if event == "PLAYER_REGEN_ENABLED" then
		self:UnregisterEvent("PLAYER_REGEN_ENABLED")
	end
end

function A:UpdateHeader(header)
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
	end

	self.ScanAuras(header)

	A:PostDrag()
end

function A:CreateAuraHeader(filter)
	local name
	if filter == "HELPFUL" then name = "RayUIPlayerBuffs" else name = "RayUIPlayerDebuffs" end

	local header = CreateFrame("Frame", name, UIParent, "SecureAuraHeaderTemplate")
	header:SetClampedToScreen(true)
	header:SetAttribute("template", "RayUIAuraTemplate30")
	header:HookScript("OnEvent", A.ScanAuras)
	header:SetAttribute("unit", "player")
	header:SetAttribute("filter", filter)
	RegisterStateDriver(header, "visibility", "[petbattle] hide; show")

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

function A:WeaponPostDrag(point)
	if not point then point = R:GetScreenQuadrant(self) end
	if string.find(point, "LEFT") then
		TempEnchant1:ClearAllPoints()
		TempEnchant2:ClearAllPoints()
		TempEnchant1:SetPoint("TOPLEFT", self, "TOPLEFT", 0, 0)
		TempEnchant2:SetPoint("LEFT", TempEnchant1, "RIGHT", spacing, 0)
	else
		TempEnchant1:ClearAllPoints()
		TempEnchant2:ClearAllPoints()
		TempEnchant1:SetPoint("TOPRIGHT", self, "TOPRIGHT", 0, 0)
		TempEnchant2:SetPoint("RIGHT", TempEnchant1, "LEFT", -spacing, 0)
	end
end

function A:UpdateWeaponText(auraButton, timeLeft)
	local duration = auraButton.duration
	if(timeLeft) then
		if(timeLeft <= 0) then
			auraButton:SetAlpha(1)
			duration:SetText("")
		else
			local time = formatTime(timeLeft)
			if timeLeft <= 86400.5 and timeLeft > 3600.5 then
				duration:SetText(NORMAL_FONT_COLOR_CODE..time.."|r")
				auraButton:SetAlpha(1)
			elseif timeLeft <= 3600.5 and timeLeft > 60.5 then
				duration:SetText(NORMAL_FONT_COLOR_CODE..time.."|r")
				auraButton:SetAlpha(1)
			elseif timeLeft <= 60.5 then
				duration:SetText("|cffff0000"..time.."|r")
				auraButton:SetAlpha(A.AlphaFrame.BuffAlphaValue)
			end
		end
	end
end

function A:Initialize()
	BuffFrame:Kill()
	ConsolidatedBuffs:Kill()
	InterfaceOptionsFrameCategoriesButton12:SetScale(0.0001)

	local AurasHolder = CreateFrame("Frame", "AurasHolder", UIParent)
	AurasHolder:Height(R:Scale(buttonsize)*4 + R:Scale(spacing)*3)
	AurasHolder:Width(R:Scale(buttonsize)*buffsperrow + R:Scale(spacing)*(buffsperrow-1))
	AurasHolder:SetFrameStrata("BACKGROUND")
	AurasHolder:SetClampedToScreen(true)
	AurasHolder:SetAlpha(0)
	AurasHolder:Point("TOPRIGHT", UIParent, "TOPRIGHT", -14, -73)
	R:CreateMover(AurasHolder, "AurasMover", L["Buff锚点"], true, A.PostDrag)

	self.BuffFrame = self:CreateAuraHeader("HELPFUL")
	self.DebuffFrame = self:CreateAuraHeader("HARMFUL")

	self.AlphaFrame = CreateFrame("Frame")
	self.AlphaFrame.BuffAlphaValue = 1
	self.AlphaFrame.BuffFrameFlashState = 1
	self.AlphaFrame.BuffFrameFlashTime = 0
	self.AlphaFrame:SetScript("OnUpdate", A.UpdateAlpha)

	self.EnchantHeader = CreateFrame("Frame", "RayUITemporaryEnchantFrame", UIParent, "SecureHandlerStateTemplate");
	self.EnchantHeader:Size(buttonsize * 2 + spacing, buttonsize)
	self.EnchantHeader:Point("TOPLEFT", Minimap, "BOTTOMLEFT", 0, -5)
	self.EnchantHeader:SetAttribute("_onstate-show", [[
			if newstate == "hide" then
				self:Hide();
			else
				self:Show();
			end
		]]);

	RegisterStateDriver(self.EnchantHeader, "show", "[petbattle] hide;show");
	self:SecureHook("AuraButton_UpdateDuration", "UpdateWeaponText")
	TemporaryEnchantFrame:SetParent(self.EnchantHeader)
	R:CreateMover(self.EnchantHeader, "WeaponEnchantMover", L["武器附魔锚点"], true, A.WeaponPostDrag)

	for i = 1, 2 do
		A:UpdateWeapon(_G["TempEnchant"..i])
	end
end

R:RegisterModule(A:GetName())
