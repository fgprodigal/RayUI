local R, L, P = unpack(select(2, ...)) --Inport: Engine, Locales, ProfileDB
local UF = R:GetModule("UnitFrames")
local oUF = RayUF or oUF

local PLAYER_WIDTH = 220
local PLAYER_HEIGHT = 32
local TARGET_WIDTH = 220
local TARGET_HEIGHT = 32
local SMALL_WIDTH = 140
local SMALL_HEIGHT = 8
local PET_HEIGHT = 18
local BOSS_WIDTH = 190
local BOSS_HEIGHT = 22
local PARTY_WIDTH = 170
local PARTY_HEIGHT = 32
local ENERGY_WIDTH = 200
local ENERGY_HEIGHT = 3

local UnitFrame_OnEnter = function(self)
	if IsShiftKeyDown() or not UnitAffectingCombat("player") then
		UnitFrame_OnEnter(self)
	end
	self.Mouseover:Show()
	self.isMouseOver = true
	for _, element in ipairs(self.mouseovers) do
		element:ForceUpdate()
	end
end

local UnitFrame_OnLeave = function(self)
	UnitFrame_OnLeave(self)
	self.Mouseover:Hide()
	self.isMouseOver = nil
	for _, element in ipairs(self.mouseovers) do
		element:ForceUpdate()
	end
end

local function Fader(frame)
	frame.Fader = true
	frame.FadeSmooth = 0.5
	frame.FadeMinAlpha = 0
	frame.FadeMaxAlpha = 1
end

function UF:DPSLayout(frame, unit)
	-- Register Frames for Click
	frame:RegisterForClicks("AnyUp")
	frame:SetScript("OnEnter", UnitFrame_OnEnter)
	frame:SetScript("OnLeave", UnitFrame_OnLeave)

	-- Setup Menu
	frame.menu = self.SpawnMenu

	-- Frame Level
	frame:SetFrameLevel(5)

	frame.textframe = CreateFrame("Frame", nil, frame)
	frame.textframe:SetAllPoints()
	frame.textframe:SetFrameLevel(frame:GetFrameLevel()+5)

	-- Health
	local health = self:ConstructHealthBar(frame, true, true)
	health:SetPoint("LEFT")
	health:SetPoint("RIGHT")
	health:SetPoint("TOP")
	health:CreateShadow("Background")
	frame.Health = health

	-- Name
	local name = frame.textframe:CreateFontString(nil, "OVERLAY")
	name:SetFont(R["media"].font, 15, R["media"].fontflag)
	frame.Name = name

	-- mouseover highlight
    local mouseover = health:CreateTexture(nil, "OVERLAY")
	mouseover:SetAllPoints(health)
	mouseover:SetTexture("Interface\\AddOns\\RayUI\\media\\mouseover")
	mouseover:SetVertexColor(1,1,1,.36)
	mouseover:SetBlendMode("ADD")
	mouseover:Hide()
	frame.Mouseover = mouseover

	-- threat highlight
	local Thrt = health:CreateTexture(nil, "OVERLAY")
	Thrt:SetAllPoints(health)
	Thrt:SetTexture("Interface\\AddOns\\RayUI\\media\\threat")
	Thrt:SetBlendMode("ADD")
	Thrt:Hide()
	Thrt.Override = UF.UpdateThreatStatus
	frame.ThreatHlt = Thrt

	-- update threat
	frame:RegisterEvent("PLAYER_TARGET_CHANGED", UF.UpdateThreatStatus)
	frame:RegisterEvent("UNIT_THREAT_LIST_UPDATE", UF.UpdateThreatStatus)
	frame:RegisterEvent("UNIT_THREAT_SITUATION_UPDATE", UF.UpdateThreatStatus)

	-- SpellRange
	frame.SpellRange = {
		  insideAlpha = 1,
		  outsideAlpha = 0.3}

	if unit == "player" then
		health:SetSize(PLAYER_WIDTH, PLAYER_HEIGHT * (1 - self.db.powerheight) - 10)
		health.value:Point("LEFT", health, "LEFT", 5, 0)
		name:Point("TOPLEFT", health, "BOTTOMLEFT", 0, 3)
		name:Point("TOPRIGHT", health, "BOTTOMRIGHT", 0, 3)
		name:SetJustifyH("LEFT")

		if self.db.healthColorClass then
			frame:Tag(name, "[RayUF:name] [RayUF:info]")
		else
			frame:Tag(name, "[RayUF:color][RayUF:name] [RayUF:info]")
		end

		-- Separated Energy Bar
		if self.db.separateEnergy and R.myclass == "ROGUE" then
			local EnergyBarHolder = CreateFrame("Frame", nil, frame)
			EnergyBarHolder:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 311)
			EnergyBarHolder:SetSize(ENERGY_WIDTH, ENERGY_HEIGHT + 13)
			local EnergyBar = CreateFrame("Statusbar", "RayUF_EnergyBar", EnergyBarHolder)
			EnergyBar:SetStatusBarTexture(R["media"].normal)
			EnergyBar:SetStatusBarColor(unpack(self.db.powerColorClass and oUF.colors.class[R.myclass] or oUF.colors.power["ENERGY"]))
			EnergyBar:SetPoint("BOTTOM", 0, 3)
			EnergyBar:SetSize(ENERGY_WIDTH, ENERGY_HEIGHT)
			EnergyBar:CreateShadow("Background")
			EnergyBar.shadow:SetBackdropColor(.12, .12, .12, 1)
			EnergyBar.text = EnergyBar:CreateFontString(nil, "OVERLAY")
			EnergyBar.text:SetPoint("CENTER")
			EnergyBar.text:SetFont(R["media"].font, R["media"].fontsize + 2, R["media"].fontflag)
            EnergyBar:RegisterEvent("UNIT_POWER_FREQUENT")
			EnergyBar:SetScript("OnEvent", function(frame)
				frame:SetMinMaxValues(0, UnitPowerMax("player"))
				frame:SetValue(UnitPower("player"))
				frame.text:SetText(UnitPower("player"))
			end)
			R:CreateMover(EnergyBarHolder, "EnergyBarMover", L["能量条锚点"], true, nil, "ALL,RAID15,RAID25,RAID40")
		else
			local power = self:ConstructPowerBar(frame, true, true)
			power:SetPoint("LEFT")
			power:SetPoint("RIGHT")
			power:SetPoint("BOTTOM") 
			power.value:Point("RIGHT", health, "RIGHT", -5, 0)
			power:SetWidth(PLAYER_WIDTH)
			power:SetHeight(PLAYER_HEIGHT * self.db.powerheight)
			power:CreateShadow("Background")
			frame.Power = power
		end

        frame.Portrait = self:ConstructPortrait(frame)

		-- Vengeance Bar
		if self.db.vengeance then
			local VengeanceBarHolder = CreateFrame("Frame", nil, frame)
			VengeanceBarHolder:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 317)
			VengeanceBarHolder:SetSize(ENERGY_WIDTH, ENERGY_HEIGHT)
			local VengeanceBar = CreateFrame("Statusbar", "RayUF_VengeanceBar", VengeanceBarHolder)
			VengeanceBar:SetStatusBarTexture(R["media"].normal)
			VengeanceBar:SetStatusBarColor(unpack(self.db.powerColorClass and oUF.colors.class[R.myclass] or oUF.colors.power["RAGE"]))
			VengeanceBar:SetPoint("CENTER")
			VengeanceBar:SetSize(ENERGY_WIDTH, ENERGY_HEIGHT)
			VengeanceBar:CreateShadow("Background")
			VengeanceBar.shadow:SetBackdropColor(.12, .12, .12, 1)
			VengeanceBar.Text = VengeanceBar:CreateFontString(nil, "OVERLAY")
			VengeanceBar.Text:SetPoint("CENTER")
			VengeanceBar.Text:SetFont(R["media"].font, R["media"].fontsize + 2, R["media"].fontflag)
			R:CreateMover(VengeanceBarHolder, "VengeanceBarMover", L["复仇条锚点"], true, nil, "ALL,RAID15,RAID25,RAID40")
			frame.Vengeance = VengeanceBar
		end

		-- CastBar
        local castbar = self:ConstructCastBar(frame)
        castbar:ClearAllPoints()
        castbar:Point("BOTTOM",UIParent,"BOTTOM",0,305)
        castbar:Width(350)
        castbar:Height(5)
        castbar.Text:ClearAllPoints()
        castbar.Text:SetPoint("BOTTOMLEFT", castbar, "TOPLEFT", 5, -2)
        castbar.Time:ClearAllPoints()
        castbar.Time:SetPoint("BOTTOMRIGHT", castbar, "TOPRIGHT", -5, -2)
        castbar.Icon:Hide()
        castbar.Iconbg:Hide()
        R:CreateMover(castbar, "PlayerCastBarMover", L["施法条锚点"], true, nil, "ALL,RAID15,RAID25,RAID40")
        frame.Castbar = castbar

		-- Debuffs
		local debuffs = CreateFrame("Frame", nil, frame)
		debuffs:SetHeight(PLAYER_HEIGHT - 11)
		debuffs:SetWidth(PLAYER_WIDTH)
		debuffs:Point("BOTTOMRIGHT", frame, "TOPRIGHT", 0, 8)
		debuffs.spacing = 3.8
		debuffs["growth-x"] = "LEFT"
		debuffs["growth-y"] = "UP"
		debuffs.size = PLAYER_HEIGHT - 11
		debuffs.initialAnchor = "BOTTOMRIGHT"
		debuffs.num = 9
		debuffs.PostCreateIcon = self.PostCreateIcon
		debuffs.PostUpdateIcon = self.PostUpdateIcon

		frame.Debuffs = debuffs

		-- Fader
		Fader(frame)

		-- ClassBar
		if R.myclass == "MONK" then
			frame.Harmony = self:ConstructMonkResourceBar(frame)
		elseif R.myclass == "DEATHKNIGHT" then
			frame.Runes = self:ConstructDeathKnightResourceBar(frame)
		elseif R.myclass == "PALADIN" then
			frame.HolyPower = self:ConstructPaladinResourceBar(frame)
		elseif R.myclass == "WARLOCK" then
			frame.ShardBar = self:ConstructWarlockResourceBar(frame)
		elseif R.myclass == "PRIEST" then
			frame.ShadowOrbs = self:ConstructPriestResourceBar(frame)
		elseif R.myclass == "SHAMAN" then
			frame.TotemBar = self:ConstructShamanResourceBar(frame)
		elseif R.myclass == "DRUID" then
			frame.EclipseBar = self:ConstructDruidResourceBar(frame)
		end

		self:ConstructThreatBar()
		-- Experienc & Reputation
		local experience = CreateFrame("StatusBar", nil, frame)
		experience:SetStatusBarTexture(R["media"].normal)
		experience:SetStatusBarColor(0.58, 0.0, 0.55)
		experience:GetStatusBarTexture():SetHorizTile(false)

		experience:Point("TOPLEFT", RayUIBottomInfoBar, "TOPLEFT", 0, 0)
		experience:Point("BOTTOMRIGHT", RayUIBottomInfoBar, "BOTTOMRIGHT", 0, 0)
		experience:SetParent(RayUIBottomInfoBar)
		experience:SetFrameStrata("BACKGROUND")
		experience:SetFrameLevel(1)

		experience.Rested = CreateFrame("StatusBar", nil, experience)
		experience.Rested:SetStatusBarTexture(R["media"].normal)
		experience.Rested:SetStatusBarColor(0, 0.39, 0.88)
		experience.Rested:GetStatusBarTexture():SetHorizTile(false)
		experience.Rested:SetAllPoints(experience)
		experience.Rested:SetFrameStrata("BACKGROUND")
		experience.Rested:SetFrameLevel(0)

		experience.Tooltip = true

		local reputation = CreateFrame("StatusBar", nil, frame)
		reputation:SetStatusBarTexture(R["media"].normal)
		reputation:SetStatusBarColor(0, .7, 1)
		reputation:GetStatusBarTexture():SetHorizTile(false)

		reputation:Point("TOPLEFT", RayUIBottomInfoBar, "TOPLEFT", 0, 0)
		reputation:Point("BOTTOMRIGHT", RayUIBottomInfoBar, "BOTTOMRIGHT", 0, 0)
		reputation:SetParent(RayUIBottomInfoBar)
		reputation:SetFrameStrata("BACKGROUND")
		reputation:SetFrameLevel(1)

		reputation.PostUpdate = function(frame, event, unit, bar)
            local name, id = GetWatchedFactionInfo()
            bar:SetStatusBarColor(FACTION_BAR_COLORS[id].r, FACTION_BAR_COLORS[id].g, FACTION_BAR_COLORS[id].b)
        end
		reputation.Tooltip = true
		reputation.colorStanding = true

		frame:SetScript("OnEnter", UnitFrame_OnEnter)
		frame:SetScript("OnLeave", UnitFrame_OnLeave)

		RayUIThreatBar:HookScript("OnShow", function()
			if RayUIThreatBar:GetAlpha() > 0 then
				experience:SetAlpha(0)
				reputation:SetAlpha(0)
			end
		end)
		RayUIThreatBar:HookScript("OnHide", function()
			experience:SetAlpha(1)
			reputation:SetAlpha(1)
		end)
		hooksecurefunc(RayUIThreatBar, "SetAlpha", function()
			if RayUIThreatBar:GetAlpha() > 0 then
				experience:SetAlpha(0)
				reputation:SetAlpha(0)
			else
				experience:SetAlpha(1)
				reputation:SetAlpha(1)
			end
		end)

		frame.Experience = experience
		frame.Reputation = reputation

		-- Heal Prediction
		local mhpb = CreateFrame("StatusBar", nil, frame)
		mhpb:SetPoint("BOTTOMLEFT", frame.Health:GetStatusBarTexture(), "BOTTOMRIGHT")
		mhpb:SetPoint("TOPLEFT", frame.Health:GetStatusBarTexture(), "TOPRIGHT")
		mhpb:SetWidth(health:GetWidth())
		mhpb:SetStatusBarTexture(R["media"].blank)
		mhpb:SetStatusBarColor(0, 1, 0.5, 0.25)

		local ohpb = CreateFrame("StatusBar", nil, frame)
		ohpb:SetPoint("BOTTOMLEFT", mhpb:GetStatusBarTexture(), "BOTTOMRIGHT", 0, 0)
		ohpb:SetPoint("TOPLEFT", mhpb:GetStatusBarTexture(), "TOPRIGHT", 0, 0)
		ohpb:SetWidth(mhpb:GetWidth())
		ohpb:SetStatusBarTexture(R["media"].blank)
		ohpb:SetStatusBarColor(0, 1, 0, 0.25)

		frame.HealPrediction = {
			myBar = mhpb,
			otherBar = ohpb,
			maxOverflow = 1,
			PostUpdate = function(frame)
				if frame.myBar:GetValue() == 0 then frame.myBar:SetAlpha(0) else frame.myBar:SetAlpha(1) end
				if frame.otherBar:GetValue() == 0 then frame.otherBar:SetAlpha(0) else frame.otherBar:SetAlpha(1) end
			end
		}

		local Combat = frame:CreateTexture(nil, "OVERLAY")
		Combat:SetSize(20, 20)
		Combat:ClearAllPoints()
		Combat:Point("LEFT", health, "LEFT", -10, -5)
		frame.Combat = Combat
		frame.Combat:SetTexture("Interface\\AddOns\\RayUI\\media\\combat")
		frame.Combat:SetVertexColor(0.6, 0, 0)

		local Resting = frame:CreateTexture(nil, "OVERLAY")
		Resting:SetSize(20, 20)
		Resting:Point("BOTTOM", Combat, "BOTTOM", 0, 25)
		frame.Resting = Resting
		frame.Resting:SetTexture("Interface\\AddOns\\RayUI\\media\\rested")
		frame.Resting:SetVertexColor(0.8, 0.8, 0.8)

		if UF.db.aurabar then
            frame.AuraBars = self:Construct_AuraBarHeader(frame)
            frame.AuraBars:SetPoint("BOTTOMLEFT", frame, "TOPLEFT", 0, 33)
            frame.AuraBars:SetPoint("BOTTOMRIGHT", frame, "TOPRIGHT", 0, 33)
        end
	end

	if unit == "target" then
		health:SetSize(TARGET_WIDTH, TARGET_HEIGHT * (1 - self.db.powerheight) - 10)
		health.value:Point("LEFT", health, "LEFT", 5, 0)
		name:Point("TOPLEFT", health, "BOTTOMLEFT", 0, 3)
		name:Point("TOPRIGHT", health, "BOTTOMRIGHT", 0, 3)
		name:SetJustifyH("RIGHT")
		if self.db.healthColorClass then
			frame:Tag(name, "[RayUF:name] [RayUF:info]")
		else
			frame:Tag(name, "[RayUF:color][RayUF:name] [RayUF:info]")
		end
		self:FocusText(frame)
		local power = self:ConstructPowerBar(frame, true, true)
		power:SetPoint("LEFT")
		power:SetPoint("RIGHT")
		power:SetPoint("BOTTOM") 
		power.value:Point("RIGHT", health, "RIGHT", -5, 0)
		power:SetWidth(PLAYER_WIDTH)
		power:SetHeight(PLAYER_HEIGHT * self.db.powerheight)
		power:CreateShadow("Background")
		frame.Power = power

        frame.Portrait = self:ConstructPortrait(frame)

		local castbar = self:ConstructCastBar(frame)
		castbar:ClearAllPoints()
		castbar:Point("TOPRIGHT", frame, "TOPRIGHT", 0, -65)
		castbar:Width(health:GetWidth()-27)
		castbar:Height(20)
		castbar.Text:ClearAllPoints()
		castbar.Text:SetPoint("LEFT", castbar, "LEFT", 5, 0)
		castbar.Time:ClearAllPoints()
		castbar.Time:SetPoint("RIGHT", castbar, "RIGHT", -5, 0)
		frame.Castbar = castbar

		-- Auras
		local buffs = CreateFrame("Frame", nil, frame)
		buffs:SetHeight(PLAYER_HEIGHT - 11)
		buffs:SetWidth(PLAYER_WIDTH)
		buffs:Point("TOPLEFT", frame, "BOTTOMLEFT", 0, -5)
		buffs.spacing = 3.8
		buffs["growth-x"] = "RIGHT"
		buffs["growth-y"] = "DOWN"
		buffs.size = PLAYER_HEIGHT - 11
		buffs.initialAnchor = "TOPLEFT"
		buffs.num = 9
		buffs.PostCreateIcon = self.PostCreateIcon
		buffs.PostUpdateIcon = self.PostUpdateIcon

		local debuffs = CreateFrame("Frame", nil, frame)
		debuffs:SetHeight(PLAYER_HEIGHT - 11)
		debuffs:SetWidth(PLAYER_WIDTH)
		debuffs:Point("BOTTOMLEFT", frame, "TOPLEFT", 0, 8)
		debuffs.spacing = 3.8
		debuffs["growth-x"] = "RIGHT"
		debuffs["growth-y"] = "UP"
		debuffs.size = PLAYER_HEIGHT - 11
		debuffs.initialAnchor = "BOTTOMLEFT"
		debuffs.num = 9
		debuffs.PostCreateIcon = self.PostCreateIcon
		debuffs.PostUpdateIcon = self.PostUpdateIcon
		debuffs.CustomFilter = self.CustomFilter

		frame.Buffs = buffs
		frame.Debuffs = debuffs

		-- Combo Bar
		local bars = CreateFrame("Frame", nil, frame)
		bars:SetWidth(35)
		bars:SetHeight(5)
		bars:Point("BOTTOMLEFT", frame, "TOP", - bars:GetWidth()*2.5 - 10, 1)

		bars:SetBackdropBorderColor(0,0,0,0)
		bars:SetBackdropColor(0,0,0,0)

		for i = 1, 5 do
			bars[i] = CreateFrame("StatusBar", frame:GetName().."_Combo"..i, bars)
			bars[i]:SetHeight(5)
			bars[i]:SetStatusBarTexture(R["media"].normal)
			bars[i]:GetStatusBarTexture():SetHorizTile(false)

			if i == 1 then
				bars[i]:SetPoint("LEFT", bars)
			else
				bars[i]:SetPoint("LEFT", bars[i-1], "RIGHT", 5, 0)
			end
			bars[i]:SetAlpha(0.15)
			bars[i]:SetWidth(35)
			bars[i].bg = bars[i]:CreateTexture(nil, "BACKGROUND")
			bars[i].bg:SetAllPoints(bars[i])
			bars[i].bg:SetTexture(R["media"].normal)
			bars[i].bg.multiplier = .2

			bars[i]:CreateShadow("Background")
			bars[i].shadow:SetFrameStrata("BACKGROUND")
			bars[i].shadow:SetFrameLevel(0)
		end

		bars[1]:SetStatusBarColor(255/255, 0/255, 0)
		bars[2]:SetStatusBarColor(255/255, 0/255, 0)
		bars[3]:SetStatusBarColor(255/255, 255/255, 0)
		bars[4]:SetStatusBarColor(255/255, 255/255, 0)
		bars[5]:SetStatusBarColor(0, 1, 0)

		frame.CPoints = bars
		frame.CPoints.Override = self.ComboDisplay

		if self.db.separateEnergy and R.myclass == "ROGUE" then
			bars:SetParent(RayUF_EnergyBar)
			bars:ClearAllPoints()
			bars:Point("BOTTOMLEFT", RayUF_EnergyBar, "TOPLEFT", 0, 3)
			for i = 1, 5 do
				bars[i]:SetHeight(3)
				bars[i]:SetWidth((ENERGY_WIDTH- 20)/5)
				bars[i]:SetAlpha(0)
			end
		end

		-- Heal Prediction
		local mhpb = CreateFrame("StatusBar", nil, frame)
		mhpb:SetPoint("BOTTOMLEFT", frame.Health:GetStatusBarTexture(), "BOTTOMRIGHT")
		mhpb:SetPoint("TOPLEFT", frame.Health:GetStatusBarTexture(), "TOPRIGHT")
		mhpb:SetWidth(health:GetWidth())
		mhpb:SetStatusBarTexture(R["media"].blank)
		mhpb:SetStatusBarColor(0, 1, 0.5, 0.25)

		local ohpb = CreateFrame("StatusBar", nil, frame)
		ohpb:SetPoint("BOTTOMLEFT", mhpb:GetStatusBarTexture(), "BOTTOMRIGHT", 0, 0)
		ohpb:SetPoint("TOPLEFT", mhpb:GetStatusBarTexture(), "TOPRIGHT", 0, 0)
		ohpb:SetWidth(mhpb:GetWidth())
		ohpb:SetStatusBarTexture(R["media"].blank)
		ohpb:SetStatusBarColor(0, 1, 0, 0.25)

		frame.HealPrediction = {
			myBar = mhpb,
			otherBar = ohpb,
			maxOverflow = 1,
			PostUpdate = function(frame)
				if frame.myBar:GetValue() == 0 then frame.myBar:SetAlpha(0) else frame.myBar:SetAlpha(1) end
				if frame.otherBar:GetValue() == 0 then frame.otherBar:SetAlpha(0) else frame.otherBar:SetAlpha(1) end
			end
		}

		if UF.db.aurabar then
            frame.AuraBars = self:Construct_AuraBarHeader(frame)
            frame.AuraBars:SetPoint("BOTTOMLEFT", frame, "TOPLEFT", 0, 33)
            frame.AuraBars:SetPoint("BOTTOMRIGHT", frame, "TOPRIGHT", 0, 33)
        end
	end

	if unit == "party" or unit == "focus" then
		health:SetSize(PARTY_WIDTH, PARTY_HEIGHT * (1 - self.db.powerheight) - 10)
		health.value:Point("LEFT", health, "LEFT", 5, 0)
		name:Point("TOPLEFT", health, "BOTTOMLEFT", 0, 3)
		name:Point("TOPRIGHT", health, "BOTTOMRIGHT", 0, 3)
		name:SetJustifyH("LEFT")
		if self.db.healthColorClass then
			frame:Tag(name, "[RayUF:name] [RayUF:info]")
		else
			frame:Tag(name, "[RayUF:color][RayUF:name] [RayUF:info]")
		end
		local power = self:ConstructPowerBar(frame, true, true)
		power:SetPoint("LEFT")
		power:SetPoint("RIGHT")
		power:SetPoint("BOTTOM") 
		power.value:Point("RIGHT", health, "RIGHT", -5, 0)
		power:SetWidth(PLAYER_WIDTH)
		power:SetHeight(PLAYER_HEIGHT * self.db.powerheight)
		power:CreateShadow("Background")
		frame.Power = power

        frame.Portrait = self:ConstructPortrait(frame)
	end

	if unit == "party" then
		-- Heal Prediction
		local mhpb = CreateFrame("StatusBar", nil, frame)
		mhpb:SetPoint("BOTTOMLEFT", frame.Health:GetStatusBarTexture(), "BOTTOMRIGHT")
		mhpb:SetPoint("TOPLEFT", frame.Health:GetStatusBarTexture(), "TOPRIGHT")
		mhpb:SetWidth(health:GetWidth())
		mhpb:SetStatusBarTexture(R["media"].blank)
		mhpb:SetStatusBarColor(0, 1, 0.5, 0.25)

		local ohpb = CreateFrame("StatusBar", nil, frame)
		ohpb:SetPoint("BOTTOMLEFT", mhpb:GetStatusBarTexture(), "BOTTOMRIGHT", 0, 0)
		ohpb:SetPoint("TOPLEFT", mhpb:GetStatusBarTexture(), "TOPRIGHT", 0, 0)
		ohpb:SetWidth(mhpb:GetWidth())
		ohpb:SetStatusBarTexture(R["media"].blank)
		ohpb:SetStatusBarColor(0, 1, 0, 0.25)

		frame.HealPrediction = {
			myBar = mhpb,
			otherBar = ohpb,
			maxOverflow = 1,
			PostUpdate = function(frame)
				if frame.myBar:GetValue() == 0 then frame.myBar:SetAlpha(0) else frame.myBar:SetAlpha(1) end
				if frame.otherBar:GetValue() == 0 then frame.otherBar:SetAlpha(0) else frame.otherBar:SetAlpha(1) end
			end
		}
	end

	if unit == "focus" then
		-- CastBar
		local castbar = self:ConstructCastBar(frame)
		castbar:ClearAllPoints()
		castbar:Point("CENTER", UIParent, "CENTER", 0, 100)
		castbar:Width(250)
		castbar:Height(5)
		castbar.Text:ClearAllPoints()
		castbar.Text:SetPoint("BOTTOMLEFT", castbar, "TOPLEFT", 5, -2)
		castbar.Time:ClearAllPoints()
		castbar.Time:SetPoint("BOTTOMRIGHT", castbar, "TOPRIGHT", -5, -2)
		castbar.Iconbg:SetSize(25, 25)
		castbar.Iconbg:ClearAllPoints()
		castbar.Iconbg:SetPoint("BOTTOM", castbar, "TOP", 0, 5)
		castbar:SetParent(UIParent)
		frame.Castbar = castbar

		self:ClearFocusText(frame)

		-- Debuffs
		local debuffs = CreateFrame("Frame", nil, frame)
		debuffs:SetHeight(PARTY_HEIGHT - 10)
		debuffs:SetWidth(PARTY_WIDTH)
		debuffs:Point("BOTTOMRIGHT", frame, "TOPRIGHT", 0, 7)
		debuffs.spacing = 3.8
		debuffs["growth-x"] = "LEFT"
		debuffs["growth-y"] = "UP"
		debuffs.size = PARTY_HEIGHT - 11
		debuffs.initialAnchor = "BOTTOMRIGHT"
		debuffs.num = 7
		debuffs.PostCreateIcon = self.PostCreateIcon
		debuffs.PostUpdateIcon = self.PostUpdateIcon
		debuffs.onlyShowPlayer = true

		frame.Debuffs = debuffs
	end

	if unit == "targettarget" or unit == "pet" or unit == "pettarget" or unit == "focustarget" then
		health:SetSize(SMALL_WIDTH, SMALL_HEIGHT * 0.9)
		health.value:Point("LEFT", frame, "LEFT", 5, 0)
		if unit == "pet" then
			health:SetHeight(PET_HEIGHT * 0.9)
			name:Point("TOP", health, 0, 7)
		else
			name:Point("TOP", health, 0, 12)
		end
		name:SetFont(R["media"].font, 14, R["media"].fontflag)
		if self.db.healthColorClass then
			frame:Tag(name, "[RayUF:name]")
		else
			frame:Tag(name, "[RayUF:color][RayUF:name]")
		end
	end

	if unit == "pet" then
		--Dummy Cast Bar, so we don't see an extra castbar while in vehicle
		local castbar = CreateFrame("StatusBar", nil, frame)
		frame.Castbar = castbar

		-- Fader
		Fader(frame)
	end

	if unit == "targettarget" then
		-- Debuffs
		local debuffs = CreateFrame("Frame", nil, frame)
		debuffs:SetHeight(PLAYER_HEIGHT - 11)
		debuffs:SetWidth(SMALL_WIDTH)
		debuffs:Point("TOPLEFT", frame, "BOTTOMLEFT", 1, -5)
		debuffs.spacing = 5
		debuffs["growth-x"] = "RIGHT"
		debuffs["growth-y"] = "DOWN"
		debuffs.size = PLAYER_HEIGHT - 11
		debuffs.initialAnchor = "TOPLEFT"
		debuffs.num = 5
		debuffs.PostCreateIcon = self.PostCreateIcon
		debuffs.PostUpdateIcon = self.PostUpdateIcon
		debuffs.CustomFilter = function(_, unit) if UnitIsEnemy(unit, "player") then return false end return true end

		frame.Debuffs = debuffs

		-- Buffs
		local buffs = CreateFrame("Frame", nil, frame)
		buffs:SetHeight(PLAYER_HEIGHT - 11)
		buffs:SetWidth(SMALL_WIDTH)
		buffs:Point("TOPLEFT", frame, "BOTTOMLEFT", 1, -5)
		buffs.spacing = 5
		buffs["growth-x"] = "RIGHT"
		buffs["growth-y"] = "DOWN"
		buffs.size = PLAYER_HEIGHT - 11
		buffs.initialAnchor = "TOPLEFT"
		buffs.num = 5
		buffs.PostCreateIcon = self.PostCreateIcon
		buffs.PostUpdateIcon = self.PostUpdateIcon
		buffs.CustomFilter = function(_, unit) if UnitIsFriend(unit, "player") then return false end return true end

		frame.Buffs = buffs
	end

	if (unit and unit:find("arena%d") and self.db.showArenaFrames == true) or (unit and unit:find("boss%d") and self.db.showBossFrames == true) then
		health:SetSize(BOSS_WIDTH, BOSS_HEIGHT * (1 - self.db.powerheight)-2)
		health.value:Point("LEFT", frame, "LEFT", 5, 0)
		name:Point("BOTTOM", health, -6, -15)
		name:Point("LEFT", health, 0, 0)
		name:SetJustifyH("LEFT")
		if self.db.healthColorClass then
			frame:Tag(name, "[RayUF:name] [RayUF:info]")
		else
			frame:Tag(name, "[RayUF:color][RayUF:name] [RayUF:info]")
		end
		local power = self:ConstructPowerBar(frame, true, true)
		power:SetPoint("LEFT")
		power:SetPoint("RIGHT")
		power:SetPoint("BOTTOM") 
		power.value:Point("RIGHT", frame, "RIGHT", -5, 0)
		power:SetWidth(BOSS_WIDTH)
		power:SetHeight(BOSS_HEIGHT * self.db.powerheight)
		power:CreateShadow("Background")
		frame.Power = power

        frame.Portrait = self:ConstructPortrait(frame)

		local debuffs = CreateFrame("Frame", nil, frame)
		debuffs:SetHeight(BOSS_HEIGHT)
		debuffs:SetWidth(BOSS_WIDTH)
		debuffs:Point("BOTTOMLEFT", frame, "TOPLEFT", 1, 2)
		debuffs.spacing = 6
		debuffs["growth-x"] = "RIGHT"
		debuffs["growth-y"] = "UP"
		debuffs.size = PLAYER_HEIGHT - 12
		debuffs.initialAnchor = "BOTTOMLEFT"
		debuffs.num = 7
		debuffs.PostCreateIcon = self.PostCreateIcon
		debuffs.PostUpdateIcon = self.PostUpdateIcon
		debuffs.onlyShowPlayer = true
		frame.Debuffs = debuffs

		-- CastBar
		local castbar = self:ConstructCastBar(frame)
		castbar:ClearAllPoints()
		castbar:SetAllPoints(frame)
		castbar.Time:ClearAllPoints()
		castbar.Time:Point("RIGHT", frame.Health, "RIGHT", -2, 0)
		castbar.Text:ClearAllPoints()
		castbar.Text:Point("LEFT", frame.Health, "LEFT", 2, 0)
		castbar.Iconbg:ClearAllPoints()
		castbar.Iconbg:Point("RIGHT", frame, "LEFT", -2, 1)
		castbar.shadow:Hide()
		castbar.bg:Hide()
		frame.Castbar = castbar
	end

	if (unit and unit:find("boss%d") and self.db.showBossFrames == true) then
		-- Alternative Power Bar
		local altpp = CreateFrame("StatusBar", nil, frame)
		altpp:SetStatusBarTexture(R["media"].normal)
		altpp:GetStatusBarTexture():SetHorizTile(false)
		altpp:SetFrameStrata("LOW")
		altpp:SetHeight(4)
		altpp:Point("TOPLEFT", frame, "BOTTOMLEFT", 0, -2)
		altpp:Point("TOPRIGHT", frame, "BOTTOMRIGHT", 0, -2)
		altpp.bg = altpp:CreateTexture(nil, "BORDER")
		altpp.bg:SetAllPoints(altpp)
		altpp.bg:SetTexture(R["media"].normal)
		altpp.bg:SetVertexColor( 0,  0.76, 1)
		altpp.bd = self:CreateBackdrop(altpp, altpp)
		altpp.text = altpp:CreateFontString(nil, "OVERLAY")
		altpp.text:SetFont(R["media"].font, 12, R["media"].fontflag)
		altpp.text:SetPoint("CENTER")
		altpp.PostUpdate = self.PostAltUpdate
		frame.AltPowerBar = altpp
	end

	if (unit and unit:find("arena%d") and self.db.showArenaFrames == true) then
		local trinkets = CreateFrame("Frame", nil, frame)
		trinkets:SetHeight(BOSS_HEIGHT)
		trinkets:SetWidth(BOSS_HEIGHT)
		trinkets:SetPoint("LEFT", frame, "RIGHT", 5, 0)
		trinkets:CreateShadow("Background")
		trinkets.shadow:SetFrameStrata("BACKGROUND")
		trinkets.trinketUseAnnounce = true
		trinkets.trinketUpAnnounce = true
		frame.Trinket = trinkets
	end

    local leader = frame:CreateTexture(nil, "OVERLAY")
    leader:SetSize(16, 16)
    leader:Point("TOPLEFT", frame, "TOPLEFT", 7, 10)
    frame.Leader = leader

	-- Assistant Icon
	local assistant = frame:CreateTexture(nil, "OVERLAY")
    assistant:Point("TOPLEFT", frame, "TOPLEFT", 7, 10)
    assistant:SetSize(16, 16)
    frame.Assistant = assistant

    local masterlooter = frame:CreateTexture(nil, "OVERLAY")
    masterlooter:SetSize(16, 16)
    masterlooter:Point("TOPLEFT", frame, "TOPLEFT", 20, 10)
    frame.MasterLooter = masterlooter
	frame.MasterLooter:SetTexture("Interface\\AddOns\\RayUI\\media\\looter")
	frame.MasterLooter:SetVertexColor(0.8, 0.8, 0.8)

    local LFDRole = frame:CreateTexture(nil, "OVERLAY")
    LFDRole:SetSize(16, 16)
    LFDRole:Point("TOPLEFT", frame, -10, 10)
	frame.LFDRole = LFDRole
	frame.LFDRole:SetTexture("Interface\\AddOns\\RayUI\\media\\lfd_role")

    local PvP = frame:CreateTexture(nil, "OVERLAY")
    PvP:SetSize(35, 35)
    PvP:Point("TOPRIGHT", frame, 22, 8)
    frame.PvP = PvP
	frame.PvP.Override = function(frame, event, unit)
		if(unit ~= frame.unit) then return end

		if(frame.PvP) then
			local factionGroup = UnitFactionGroup(unit)
            if factionGroup == "Neutral" then
                frame.PvP:SetTexture(nil)
                frame.PvP:Hide()
            else
                if(UnitIsPVPFreeForAll(unit)) then
                    frame.PvP:SetTexture[[Interface\TargetingFrame\UI-PVP-FFA]]
                    frame.PvP:Show()
                elseif(factionGroup and UnitIsPVP(unit)) then
                    frame.PvP:SetTexture([[Interface\AddOns\RayUI\media\UI-PVP-]]..factionGroup)
                    frame.PvP:Show()
                else
                    frame.PvP:Hide()
                end
            end
        end
	end

    local QuestIcon = frame:CreateTexture(nil, "OVERLAY")
    QuestIcon:SetSize(24, 24)
    QuestIcon:Point("BOTTOMRIGHT", frame, 15, -2)
    frame.QuestIcon = QuestIcon
	frame.QuestIcon:SetTexture("Interface\\AddOns\\RayUI\\media\\quest")
	frame.QuestIcon:SetVertexColor(0.8, 0.8, 0.8)

    local ricon = frame:CreateTexture(nil, "OVERLAY")
    ricon:Point("BOTTOM", frame, "TOP", 0, -7)
    ricon:SetSize(24, 24)
	ricon:SetTexture("Interface\\AddOns\\RayUI\\media\\raidicons.blp")
    frame.RaidIcon = ricon

	frame.mouseovers = {}
	tinsert(frame.mouseovers, frame.Health)

	if frame.Power then
		if frame.Power.value then 
			tinsert(frame.mouseovers, frame.Power)
		end
	end
end

function UF:LoadDPSLayout()
	oUF:RegisterStyle("RayUF", function(frame, unit)
		UF:DPSLayout(frame, unit)
	end)
	oUF:SetActiveStyle("RayUF")

	local RayUF_Parent = CreateFrame("Frame", "RayUF_Parent", UIParent, "SecureHandlerStateTemplate");
	RayUF_Parent:SetAllPoints(UIParent)
	RegisterStateDriver(RayUF_Parent, "visibility", "[petbattle] hide;show")

	-- Player
	local player = oUF:Spawn("player", "RayUF_player")
	player:Point("BOTTOMRIGHT", RayUF_Parent, "BOTTOM", -80, 390)
	player:Size(PLAYER_WIDTH, PLAYER_HEIGHT)
	player:SetParent(RayUF_Parent)
    R:CreateMover(player, player:GetName().."Mover", "Player Frame", nil, nil, "ALL,RAID15,RAID25,RAID40")

	-- Target
	local target = oUF:Spawn("target", "RayUF_target")
	target:Point("BOTTOMLEFT", RayUF_Parent, "BOTTOM", 80, 390)
	target:Size(TARGET_WIDTH, TARGET_HEIGHT)
	target:SetParent(RayUF_Parent)
    R:CreateMover(target, target:GetName().."Mover", "Target Frame", nil, nil, "ALL,RAID15,RAID25,RAID40")

	-- Focus
	local focus = oUF:Spawn("focus", "RayUF_focus")
	focus:Point("BOTTOMRIGHT", RayUF_player, "TOPLEFT", -20, 20)
	focus:Size(PARTY_WIDTH, PARTY_HEIGHT)
	focus:SetParent(RayUF_Parent)
    R:CreateMover(focus, focus:GetName().."Mover", "Focus Frame", nil, nil, "ALL,RAID15,RAID25,RAID40")

	-- Target's Target
	local tot = oUF:Spawn("targettarget", "RayUF_targettarget")
	tot:Point("BOTTOMLEFT", RayUF_target, "TOPRIGHT", 5, 30)
	tot:Size(SMALL_WIDTH, SMALL_HEIGHT)
	tot:SetParent(RayUF_Parent)
    R:CreateMover(tot, tot:GetName().."Mover", "ToT Frame", nil, nil, "ALL,RAID15,RAID25,RAID40")

	-- Player's Pet
	local pet = oUF:Spawn("pet", "RayUF_pet")
	pet:Point("BOTTOM", RayUIPetBar, "TOP", 0, 3)
	pet:Size(SMALL_WIDTH, PET_HEIGHT)
	pet:SetParent(RayUF_Parent)
    R:CreateMover(pet, pet:GetName().."Mover", "Pet Frame", nil, nil, "ALL,RAID15,RAID25,RAID40")

	-- Focus's target
	local focustarget = oUF:Spawn("focustarget", "RayUF_focustarget")
	focustarget:Point("BOTTOMRIGHT", RayUF_focus, "BOTTOMLEFT", -10, 1)
	focustarget:Size(SMALL_WIDTH, SMALL_HEIGHT)
	focustarget:SetParent(RayUF_Parent)
    R:CreateMover(focustarget, focustarget:GetName().."Mover", "Focus Target Frame", nil, nil, "ALL,RAID15,RAID25,RAID40")

	if self.db.showArenaFrames and not IsAddOnLoaded("Gladius") then
        local ArenaHeader = CreateFrame("Frame", nil, UIParent)
        ArenaHeader:Point("TOPRIGHT", RayUF_Parent, "RIGHT", -80, 200)
        ArenaHeader:Width(BOSS_WIDTH)
        ArenaHeader:Height(R:Scale(BOSS_HEIGHT)*5 + R:Scale(36)*4)
		local arena = {}
		for i = 1, 5 do
			arena[i] = oUF:Spawn("arena"..i, "RayUFArena"..i)
			if i == 1 then
				arena[i]:Point("TOPRIGHT", ArenaHeader, "TOPRIGHT", 0, 0)
			else
				arena[i]:Point("TOP", arena[i-1], "BOTTOM", 0, -36)
			end
			arena[i]:Size(BOSS_WIDTH, BOSS_HEIGHT)
			arena[i]:SetParent(RayUF_Parent)
		end
        R:CreateMover(ArenaHeader, "ArenaHeaderMover", "Arena Frames", nil, nil, "ALL,ARENA")
	end

	if self.db.showBossFrames then
        local BossHeader = CreateFrame("Frame", nil, UIParent)
        BossHeader:Point("TOPRIGHT", RayUF_Parent, "RIGHT", -80, 200)
        BossHeader:Width(BOSS_WIDTH)
        BossHeader:Height(R:Scale(BOSS_HEIGHT)*MAX_BOSS_FRAMES + R:Scale(36)*(MAX_BOSS_FRAMES-1))
		local boss = {}
		for i = 1, MAX_BOSS_FRAMES do
			boss[i] = oUF:Spawn("boss"..i, "RayUFBoss"..i)
			if i == 1 then
				boss[i]:Point("TOPRIGHT", BossHeader, "TOPRIGHT", 0, 0)
			else
				boss[i]:Point("TOP", boss[i-1], "BOTTOM", 0, -36)             
			end
			boss[i]:Size(BOSS_WIDTH, BOSS_HEIGHT)
			boss[i]:SetParent(RayUF_Parent)
		end
        R:CreateMover(BossHeader, "BossHeaderMover", "Boss Frames", nil, nil, "ALL,RAID15,RAID25,RAID40")
	end
end

UF.Layouts["DPS"] = UF.LoadDPSLayout
