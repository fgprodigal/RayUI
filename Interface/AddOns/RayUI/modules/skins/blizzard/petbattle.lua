local R, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local S = R:GetModule("Skins")

local function LoadSkin()
	local f = PetBattleFrame
	local bf = f.BottomFrame
	local infoBars = {
		f.ActiveAlly,
		f.ActiveEnemy
	}

	-- TOP FRAMES
	f:StripTextures()

	f.TopArtLeft:ClearAllPoints()
	f.TopArtLeft:SetPoint("TOPRIGHT", f, "TOP", 0, -40)
	f.TopArtRight:ClearAllPoints()
	f.TopArtRight:SetPoint("TOPLEFT", f, "TOP", 0, -40)
	f.TopVersusText:ClearAllPoints()
	f.TopVersusText:SetPoint("TOP", f, "TOP", 0, -46)
	for index, infoBar in pairs(infoBars) do
		infoBar.Border:SetAlpha(0)
		infoBar.Border2:SetAlpha(0)
		infoBar.healthBarWidth = 300

		infoBar.IconBackdrop = CreateFrame("Frame", nil, infoBar)
		infoBar.IconBackdrop:SetAllPoints(infoBar.Icon)
		infoBar.IconBackdrop:CreateShadow()
		infoBar.BorderFlash:Kill()
		infoBar.HealthBarBG:Kill()
		infoBar.HealthBarFrame:Kill()
		infoBar.HealthBarBackdrop = CreateFrame("Frame", nil, infoBar)
		infoBar.HealthBarBackdrop:SetFrameLevel(infoBar:GetFrameLevel() - 1)
		infoBar.HealthBarBackdrop:CreateShadow("Background")
		infoBar.HealthBarBackdrop:Width(infoBar.healthBarWidth)
		infoBar.ActualHealthBar:SetTexture(R["media"].normal)

		infoBar.PetTypeFrame = CreateFrame("Frame", nil, infoBar)
		infoBar.PetTypeFrame:Size(100, 23)
		infoBar.PetTypeFrame.text = infoBar.PetTypeFrame:CreateFontString(nil, "OVERLAY")
		infoBar.PetTypeFrame.text:SetFont(R["media"].font, R["media"].fontsize, "OUTLINE")
		infoBar.PetTypeFrame.text:SetShadowColor(0, 0, 0, 1)
		infoBar.PetTypeFrame.text:SetShadowOffset(R.mult, -R.mult)
		infoBar.PetTypeFrame.text:SetText("")

		infoBar.ActualHealthBar:ClearAllPoints()
		infoBar.Name:ClearAllPoints()
		infoBar.Name:SetFont(R["media"].font, R["media"].fontsize, "OUTLINE")

		infoBar.FirstAttack = infoBar:CreateTexture(nil, "ARTWORK")
		infoBar.FirstAttack:Size(30)
		infoBar.FirstAttack:SetTexture("Interface\\PetBattles\\PetBattle-StatIcons")		
		if index == 1 then
			infoBar.HealthBarBackdrop:Point("TOPLEFT", infoBar.ActualHealthBar, "TOPLEFT", 0, 0)
			infoBar.HealthBarBackdrop:Point("BOTTOMLEFT", infoBar.ActualHealthBar, "BOTTOMLEFT", 0, 0)
			infoBar.ActualHealthBar:SetVertexColor(171/255, 214/255, 116/255)
			f.Ally2.iconPoint = infoBar.IconBackdrop
			f.Ally3.iconPoint = infoBar.IconBackdrop

			infoBar.ActualHealthBar:Point("BOTTOMLEFT", infoBar.Icon, "BOTTOMRIGHT", 10, 0)		
			infoBar.Name:Point("BOTTOMLEFT", infoBar.ActualHealthBar, "TOPLEFT", 0, 10)
			infoBar.PetTypeFrame:SetPoint("BOTTOMRIGHT",infoBar.HealthBarBackdrop, "TOPRIGHT", 0, 4)
			infoBar.PetTypeFrame.text:SetPoint("RIGHT")			

			infoBar.FirstAttack:SetPoint("LEFT", infoBar.HealthBarBackdrop, "RIGHT", 5, 0)
			infoBar.FirstAttack:SetTexCoord(infoBar.SpeedIcon:GetTexCoord())
			infoBar.FirstAttack:SetVertexColor(.1,.1,.1,1)

		else
			infoBar.HealthBarBackdrop:Point("TOPRIGHT", infoBar.ActualHealthBar, "TOPRIGHT", 0, 0)
			infoBar.HealthBarBackdrop:Point("BOTTOMRIGHT", infoBar.ActualHealthBar, "BOTTOMRIGHT", 0, 0)
			infoBar.ActualHealthBar:SetVertexColor(196/255,  30/255,  60/255)
			f.Enemy2.iconPoint = infoBar.IconBackdrop
			f.Enemy3.iconPoint = infoBar.IconBackdrop	

			infoBar.ActualHealthBar:Point("BOTTOMRIGHT", infoBar.Icon, "BOTTOMLEFT", -10, 0)
			infoBar.Name:Point("BOTTOMRIGHT", infoBar.ActualHealthBar, "TOPRIGHT", 0, 10)		

			infoBar.PetTypeFrame:SetPoint("BOTTOMLEFT",infoBar.HealthBarBackdrop, "TOPLEFT", 2, 4)
			infoBar.PetTypeFrame.text:SetPoint("LEFT")			

			infoBar.FirstAttack:SetPoint("RIGHT", infoBar.HealthBarBackdrop, "LEFT", -5, 0)
			infoBar.FirstAttack:SetTexCoord(.5, 0, .5, 1)
			infoBar.FirstAttack:SetVertexColor(.1,.1,.1,1)			
		end

		infoBar.HealthText:ClearAllPoints()
		infoBar.HealthText:SetPoint("CENTER", infoBar.HealthBarBackdrop, "CENTER")

		infoBar.PetType:ClearAllPoints()
		infoBar.PetType:SetAllPoints(infoBar.PetTypeFrame)
		infoBar.PetType:SetFrameLevel(infoBar.PetTypeFrame:GetFrameLevel() + 2)
		infoBar.PetType:SetAlpha(0)		

		infoBar.LevelUnderlay:SetAlpha(0)
		infoBar.Level:SetFontObject(NumberFont_Outline_Huge)
		infoBar.Level:ClearAllPoints()
		infoBar.Level:Point("BOTTOMLEFT", infoBar.Icon, "BOTTOMLEFT", 2, 2)
		if infoBar.SpeedIcon then
			infoBar.SpeedIcon:ClearAllPoints()
			infoBar.SpeedIcon:SetPoint("CENTER") -- to set
			infoBar.SpeedIcon:SetAlpha(0)
			infoBar.SpeedUnderlay:SetAlpha(0)		
		end
	end

	-- PETS SPEED INDICATOR UPDATE
	hooksecurefunc("PetBattleFrame_UpdateSpeedIndicators", function(self)
		if not f.ActiveAlly.SpeedIcon:IsShown() and not f.ActiveEnemy.SpeedIcon:IsShown() then
			f.ActiveAlly.FirstAttack:Hide()
			f.ActiveEnemy.FirstAttack:Hide()
			return
		end

		for i, infoBar in pairs(infoBars) do
			infoBar.FirstAttack:Show()
			if infoBar.SpeedIcon:IsShown() then
				infoBar.FirstAttack:SetVertexColor(0,1,0,1)
			else
				infoBar.FirstAttack:SetVertexColor(.8,0,.3,1)
			end
		end
	end)


	-- PETS UNITFRAMES PET TYPE UPDATE
	hooksecurefunc("PetBattleUnitFrame_UpdatePetType", function(self)
		if self.PetType then
			local petType = C_PetBattles.GetPetType(self.petOwner, self.petIndex)
			if self.PetTypeFrame then
				self.PetTypeFrame.text:SetText(_G["BATTLE_PET_DAMAGE_NAME_"..petType])
			end
		end
	end)	

	-- PETS UNITFRAMES AURA SKINS
	hooksecurefunc("PetBattleAuraHolder_Update", function(self)
		if not self.petOwner or not self.petIndex then return end

		local nextFrame = 1
		for i=1, C_PetBattles.GetNumAuras(self.petOwner, self.petIndex) do
			local auraID, instanceID, turnsRemaining, isBuff = C_PetBattles.GetAuraInfo(self.petOwner, self.petIndex, i)
			if (isBuff and self.displayBuffs) or (not isBuff and self.displayDebuffs) then
				local frame = self.frames[nextFrame]

				-- always hide the border
				frame.DebuffBorder:Hide()

				if not frame.isSkinned then
					frame.bg = CreateFrame("Frame", nil, frame)
					frame.bg:Point("TOPLEFT", frame.Icon, "TOPLEFT", 0, 0)
					frame.bg:Point("BOTTOMRIGHT", frame.Icon, "BOTTOMRIGHT", 0, 0)
					frame.bg:CreateShadow("Backgound")
					frame.Icon:SetTexCoord(.08, .92, .08, .92)
					frame.isSkinned = true
				end

				if isBuff then
					frame.bg.shadow:SetBackdropBorderColor(0, 1, 0)
				else
					frame.bg.shadow:SetBackdropBorderColor(1, 0, 0)
				end

				-- move duration and change font
				frame.Duration:SetFont(R["media"].font, R["media"].fontsize, "OUTLINE")
				frame.Duration:SetShadowColor(0, 0, 0, 1)
				frame.Duration:SetShadowOffset(R.mult, -R.mult)
				frame.Duration:ClearAllPoints()
				frame.Duration:SetPoint("TOP", frame.Icon, "BOTTOM", 1, -4)
				if turnsRemaining > 0 then
					frame.Duration:SetText(turnsRemaining)
				end
				nextFrame = nextFrame + 1
			end
		end
end)

	-- WEATHER
	hooksecurefunc("PetBattleWeatherFrame_Update", function(self)
		local weather = C_PetBattles.GetAuraInfo(LE_BATTLE_PET_WEATHER, PET_BATTLE_PAD_INDEX, 1)
		if weather then
			self.Icon:Hide()
			self.Name:Hide()
			self.DurationShadow:Hide()
			self.Label:Hide()
			self.Duration:SetPoint("CENTER", self, 0, 8)
			self:ClearAllPoints()
			self:SetPoint("TOP", UIParent, 0, -15)
		end
	end)	

	hooksecurefunc("PetBattleUnitFrame_UpdateDisplay", function(self)
		self.Icon:SetTexCoord(.08, .92, .08, .92)
        if self.Name and self.petOwner and self.petIndex and self.petIndex <= C_PetBattles.GetNumPets(self.petOwner) then
            self.Name:SetText(ITEM_QUALITY_COLORS[C_PetBattles.GetBreedQuality(self.petOwner,self.petIndex)-1].hex..self.Name:GetText().."|r")
        end
	end)

	f.TopVersusText:ClearAllPoints()
	f.TopVersusText:SetPoint("TOP", f, "TOP", 0, -42)

	-- TOOLTIPS SKINNING
	local function SkinPetTooltip(tt)
		tt.Background:SetTexture(nil)
		if tt.Delimiter1 then
			tt.Delimiter1:SetTexture(nil)
			tt.Delimiter2:SetTexture(nil)
		end
		if tt.HealthBorder then
			tt.HealthBorder:SetTexture(nil)
			if not tt.hbd then
				tt.hbd = CreateFrame("Frame", nil, tt)
				tt.hbd:Point("TOPLEFT", tt.HealthBorder, "TOPLEFT", 0, 0)
				tt.hbd:Point("BOTTOMRIGHT", tt.HealthBorder, "BOTTOMRIGHT", 0, -1)
				tt.hbd:SetFrameLevel(0)
				S:CreateBD(tt.hbd)
			end
		end
		if tt.HealthBG then
			tt.HealthBG:SetTexture(nil)
		end
		if tt.XPBorder then
			tt.XPBorder:SetTexture(nil)
			if not tt.xpbd then
				tt.xpbd = CreateFrame("Frame", nil, tt)
				tt.xpbd:Point("TOPLEFT", tt.XPBorder, "TOPLEFT", 0, 0)
				tt.xpbd:Point("BOTTOMRIGHT", tt.XPBorder, "BOTTOMRIGHT", 0, -1)
				tt.xpbd:SetFrameLevel(0)
				S:CreateBD(tt.xpbd)
			end
		end
		if tt.XPBG then
			tt.XPBG:SetTexture(nil)
		end
		if tt.ActualHealthBar then
			tt.ActualHealthBar:SetTexture(R["media"].normal)
		end
		if tt.XPBar then
			tt.XPBar:SetTexture(R["media"].normal)
		end
		tt.BorderTop:SetTexture(nil)
		tt.BorderTopLeft:SetTexture(nil)
		tt.BorderTopRight:SetTexture(nil)
		tt.BorderLeft:SetTexture(nil)
		tt.BorderRight:SetTexture(nil)
		tt.BorderBottom:SetTexture(nil)
		tt.BorderBottomRight:SetTexture(nil)
		tt.BorderBottomLeft:SetTexture(nil)
        tt:SetBackdrop(nil)
        tt:CreateShadow("Background")
        tt.border:SetInside(tt, 3, 3)
        tt.shadow:SetAllPoints(tt)
		tt.border:SetBackdropBorderColor(unpack(R["media"].bordercolor))
		tt.shadow:SetBackdropBorderColor(unpack(R["media"].bordercolor))
	end

	SkinPetTooltip(PetBattlePrimaryAbilityTooltip)
	SkinPetTooltip(PetBattlePrimaryUnitTooltip)
	SkinPetTooltip(BattlePetTooltip)
	SkinPetTooltip(FloatingBattlePetTooltip)
	SkinPetTooltip(FloatingPetBattleAbilityTooltip)


	-- TOOLTIP DEFAULT POSITION
	hooksecurefunc("PetBattleAbilityTooltip_Show", function()
		local t = PetBattlePrimaryAbilityTooltip
		t:ClearAllPoints()
		t:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -4, -4)
	end)


	local extraInfoBars = {
		f.Ally2,
		f.Ally3,
		f.Enemy2,
		f.Enemy3
	}	

	for index, infoBar in pairs(extraInfoBars) do
		infoBar.BorderAlive:SetAlpha(0)
		infoBar.HealthBarBG:SetAlpha(0)
		infoBar.HealthDivider:SetAlpha(0)	
		infoBar:Size(40)
		infoBar:CreateShadow("Background")
		infoBar:ClearAllPoints()

		infoBar.healthBarWidth = 40
		infoBar.ActualHealthBar:SetTexture(R["media"].normal)
		infoBar.ActualHealthBar:ClearAllPoints()
		infoBar.ActualHealthBar:SetPoint("TOPLEFT", infoBar, "BOTTOMLEFT", 0, -5)	

		infoBar.HealthBarBackdrop = CreateFrame("Frame", nil, infoBar)
		infoBar.HealthBarBackdrop:SetFrameLevel(infoBar:GetFrameLevel() - 1)
		infoBar.HealthBarBackdrop:CreateShadow("Background")
		infoBar.HealthBarBackdrop:Width(infoBar.healthBarWidth)
		infoBar.HealthBarBackdrop:Point("TOPLEFT", infoBar.ActualHealthBar, "TOPLEFT", 0, 0)
		infoBar.HealthBarBackdrop:Point("BOTTOMLEFT", infoBar.ActualHealthBar, "BOTTOMLEFT", 0, 0)		
	end

	f.Ally2:SetPoint("TOPRIGHT", f.Ally2.iconPoint, "TOPLEFT", -6, -2)
	f.Ally3:SetPoint("TOPRIGHT", f.Ally2, "TOPLEFT", -8, 0)
	f.Enemy2:SetPoint("TOPLEFT", f.Enemy2.iconPoint, "TOPRIGHT", 6, -2)
	f.Enemy3:SetPoint("TOPLEFT", f.Enemy2, "TOPRIGHT", 8, 0)

	---------------------------------
	-- PET BATTLE ACTION BAR SETUP --
	---------------------------------

	local bar = CreateFrame("Frame", "RayUIPetBattleActionBar", f)
	bar:SetSize (52*6 + 7*10, 52 * 1 + 10*2)
	bar:EnableMouse(true)
	-- bar:CreateShadow("Background")
	bar:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 30)
	bar:SetFrameLevel(0)
	bar:SetFrameStrata("BACKGROUND")

	bf:StripTextures()
	bf.TurnTimer:StripTextures()
	bf.TurnTimer.SkipButton:SetParent(bar)
	S:Reskin(bf.TurnTimer.SkipButton)

	bf.TurnTimer.SkipButton:Width(bar:GetWidth())
	bf.TurnTimer.SkipButton:ClearAllPoints()
	bf.TurnTimer.SkipButton:SetPoint("BOTTOM", bar, "TOP", 0, 1)
	bf.TurnTimer.SkipButton.ClearAllPoints = R.dummy
	bf.TurnTimer.SkipButton.SetPoint = R.dummy

	bf.TurnTimer:Size(bf.TurnTimer.SkipButton:GetWidth(), bf.TurnTimer.SkipButton:GetHeight())
	bf.TurnTimer:ClearAllPoints()
	bf.TurnTimer:SetPoint("TOP", UIParent, "TOP", 0, -140)
	bf.TurnTimer.TimerText:SetPoint("CENTER")	

	bf.FlowFrame:StripTextures()
	bf.MicroButtonFrame:Kill()
	bf.Delimiter:StripTextures()
	bf.xpBar:SetParent(bar)
	bf.xpBar:Width(bar:GetWidth() - 4)
	bf.xpBar:CreateShadow("Background")
	bf.xpBar:ClearAllPoints()
	bf.xpBar:SetPoint("BOTTOM", bf.TurnTimer.SkipButton, "TOP", 0, 3)
	bf.xpBar:SetScript("OnShow", function(self) self:StripTextures() self:SetStatusBarTexture(R["media"].normal) end)

	-- PETS SELECTION SKIN
	for i = 1, 3 do
		local pet = bf.PetSelectionFrame["Pet"..i]

		pet.HealthBarBG:SetAlpha(0)
		pet.HealthDivider:SetAlpha(0)
		pet.ActualHealthBar:SetAlpha(0)
		pet.SelectedTexture:SetAlpha(0)
		pet.MouseoverHighlight:SetAlpha(0)
		pet.Framing:SetAlpha(0)
		pet.Icon:SetAlpha(0)
		pet.Name:SetAlpha(0)
		pet.DeadOverlay:SetAlpha(0)
		pet.Level:SetAlpha(0)
		pet.HealthText:SetAlpha(0)
	end	

	-- MOVE DEFAULT POSITION OF PETS SELECTION
	hooksecurefunc("PetBattlePetSelectionFrame_Show", function()
		bf.PetSelectionFrame:ClearAllPoints()
		bf.PetSelectionFrame:SetPoint("BOTTOM", bf.xpBar, "TOP", 0, 8)
	end)


	local function SkinPetButton(self)
		local r, g, b = unpack(RayUF.colors.class[R.myclass])
		if not self.shadow then
			self:CreateShadow()
		end
		self:SetNormalTexture("")
		self.Icon:SetTexCoord(.08, .92, .08, .92)
		self.Icon:SetParent(self.shadow)
		self.Icon:SetDrawLayer("BORDER")
		self.checked = true
		self:StyleButton(true)

		local pushed = self:GetPushedTexture()
		pushed:SetTexture(r, g, b, .2)
		pushed:SetDrawLayer("BACKGROUND")
		pushed:SetAllPoints()

		self.SelectedHighlight:SetTexture(r, g, b, .2)
		self.SelectedHighlight:SetAllPoints()
		-- self.SelectedHighlight:SetAlpha(0)
		-- self:SetFrameStrata("LOW")
	end

	hooksecurefunc("PetBattleFrame_UpdateActionBarLayout", function(self)
		for i=1, NUM_BATTLE_PET_ABILITIES do
			local b = bf.abilityButtons[i]
			SkinPetButton(b)
			b:SetParent(bar)
			b:ClearAllPoints()
			if i == 1 then
				b:SetPoint("BOTTOMLEFT", 10, 10)
			else
				local previous = bf.abilityButtons[i-1]
				b:SetPoint("LEFT", previous, "RIGHT", 10, 0)
			end
		end

		bf.SwitchPetButton:ClearAllPoints()
		bf.SwitchPetButton:SetPoint("LEFT", bf.abilityButtons[3], "RIGHT", 10, 0)
		SkinPetButton(bf.SwitchPetButton)
		bf.CatchButton:SetParent(bar)
		bf.CatchButton:ClearAllPoints()
		bf.CatchButton:SetPoint("LEFT", bf.SwitchPetButton, "RIGHT", 10, 0)
		SkinPetButton(bf.CatchButton)
		bf.ForfeitButton:SetParent(bar)
		bf.ForfeitButton:ClearAllPoints()
		bf.ForfeitButton:SetPoint("LEFT", bf.CatchButton, "RIGHT", 10, 0)
		SkinPetButton(bf.ForfeitButton)
	end)

    hooksecurefunc("PetBattleUnitTooltip_UpdateForUnit", function(self, petOwner, petIndex)
        local rarity = C_PetBattles.GetBreedQuality(petOwner,petIndex)
		local speciesID=C_PetBattles.GetPetSpeciesID(petOwner,petIndex)
		local name, icon, petType, creatureID, sourceText, description, isWild, canBattle, tradable = C_PetJournal.GetPetInfoBySpeciesID(speciesID)
        self.Name:SetText(ITEM_QUALITY_COLORS[rarity-1].hex..name)
		if ( petOwner == LE_BATTLE_PET_ALLY ) then
			self.xpbd:Show()
		else
			self.xpbd:Hide()
		end
    end)
end

S:RegisterSkin("RayUI", LoadSkin)
