local R, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local AB = R:GetModule("ActionBar")

function AB:CreateBarPet()
	local num = NUM_PET_ACTION_SLOTS
    local buttonsize = self.db.barpet.buttonsize
    local buttonspacing = self.db.barpet.buttonspacing

	local bar = CreateFrame("Frame","RayUIPetBar",UIParent, "SecureHandlerStateTemplate")
	bar:Point("BOTTOM", "UIParent", "BOTTOM", 0, 185)

	PetActionBarFrame:SetParent(bar)
	PetActionBarFrame:EnableMouse(false)

	local function PetBarUpdate(self, event)
		local petActionButton, petActionIcon, petAutoCastableTexture, petAutoCastShine
		for i=1, NUM_PET_ACTION_SLOTS, 1 do
			local buttonName = "PetActionButton" .. i
			petActionButton = _G[buttonName]
			petActionIcon = _G[buttonName.."Icon"]
			petAutoCastableTexture = _G[buttonName.."AutoCastable"]
			petAutoCastShine = _G[buttonName.."Shine"]
			local name, subtext, texture, isToken, isActive, autoCastAllowed, autoCastEnabled = GetPetActionInfo(i)

			if not isToken then
				petActionIcon:SetTexture(texture)
				petActionButton.tooltipName = name
			else
				petActionIcon:SetTexture(_G[texture])
				petActionButton.tooltipName = _G[name]
			end

			petActionButton.isToken = isToken
			petActionButton.tooltipSubtext = subtext

			if isActive and name ~= "PET_ACTION_FOLLOW" then
				petActionButton:SetChecked(true)
				if IsPetAttackAction(i) then
					PetActionButton_StartFlash(petActionButton)
				end
			else
				petActionButton:SetChecked(false)
				if IsPetAttackAction(i) then
					PetActionButton_StopFlash(petActionButton)
				end
			end

			if autoCastAllowed then
				petAutoCastableTexture:Show()
			else
				petAutoCastableTexture:Hide()
			end

			if autoCastEnabled then
				AutoCastShine_AutoCastStart(petAutoCastShine)
			else
				AutoCastShine_AutoCastStop(petAutoCastShine)
			end

			if texture then
				if GetPetActionSlotUsable(i) then
					SetDesaturation(petActionIcon, nil)
				else
					SetDesaturation(petActionIcon, 1)
				end
				petActionIcon:Show()
			else
				petActionIcon:Hide()
			end

			-- between level 1 and 10 on cata, we don't have any control on Pet. (I lol'ed so hard)
			-- Setting desaturation on button to true until you learn the control on class trainer.
			-- you can at least control "follow" button.
			if not PetHasActionBar() and texture and name ~= "PET_ACTION_FOLLOW" then
				PetActionButton_StopFlash(petActionButton)
				SetDesaturation(petActionIcon, 1)
				petActionButton:SetChecked(0)
			end
		end
	end

	bar:RegisterEvent("PLAYER_LOGIN")
	bar:RegisterEvent("PLAYER_CONTROL_LOST")
	bar:RegisterEvent("PLAYER_CONTROL_GAINED")
	bar:RegisterEvent("PLAYER_ENTERING_WORLD")
	bar:RegisterEvent("PLAYER_FARSIGHT_FOCUS_CHANGED")
	bar:RegisterEvent("PET_BAR_UPDATE")
	bar:RegisterEvent("PET_BAR_UPDATE_USABLE")
	bar:RegisterEvent("PET_BAR_UPDATE_COOLDOWN")
	bar:RegisterEvent("PET_BAR_HIDE")
	bar:RegisterEvent("UNIT_PET")
	bar:RegisterEvent("UNIT_FLAGS")
	bar:RegisterEvent("UNIT_AURA")
	bar:SetScript("OnEvent", function(self, event, ...)
		if event == "PLAYER_LOGIN" then
			-- bug reported by Affli on t12 BETA
			PetActionBarFrame.showgrid = 1 -- hack to never hide pet button. :X
            RegisterStateDriver(bar, "visibility", "[petbattle][overridebar][vehicleui][possessbar,@vehicle,exists]hide;[pet,novehicleui,nobonusbar:5]show;hide")
			hooksecurefunc("PetActionBar_Update", PetBarUpdate)
		elseif event == "PET_BAR_UPDATE" or event == "UNIT_PET" and arg1 == "player" 
		or event == "PLAYER_CONTROL_LOST" or event == "PLAYER_CONTROL_GAINED" or event == "PLAYER_FARSIGHT_FOCUS_CHANGED" or event == "UNIT_FLAGS"
		or arg1 == "pet" and (event == "UNIT_AURA") then
			PetBarUpdate()
		elseif event == "PET_BAR_UPDATE_COOLDOWN" then
			PetActionBar_UpdateCooldowns()
		end
	end)

    self["Handled"]["barpet"] = bar
    self:UpdatePetBar()
	R:CreateMover(bar, "PetBarMover", L["宠物动作条锚点"], true, nil, "ALL,ACTIONBARS")  
end

function AB:UpdatePetBar()
    local bar = self["Handled"]["barpet"]
    local buttonsPerRow = self.db.barpet.buttonsPerRow
    local buttonsize = self.db.barpet.buttonsize
    local buttonspacing = self.db.barpet.buttonspacing
    local numColumns = ceil(NUM_PET_ACTION_SLOTS / buttonsPerRow)

	bar:SetWidth(buttonsize*buttonsPerRow + buttonspacing*(buttonsPerRow - 1))
	bar:SetHeight(buttonsize*numColumns + buttonspacing*(numColumns - 1))

	if self.db.barpet.mouseover then
		self.db.barpet.autohide = false
		bar:SetAlpha(0)
		bar:SetScript("OnEnter", function(self) UIFrameFadeIn(bar,0.5,bar:GetAlpha(),1) end)
		bar:SetScript("OnLeave", function(self) UIFrameFadeOut(bar,0.5,bar:GetAlpha(),0) end)  
	else
		bar:SetAlpha(1)
		bar:SetScript("OnEnter", nil)
		bar:SetScript("OnLeave", nil)  
    end

    if self.db.barpet.autohide then
        bar:SetParent(RayUIActionBarHider)
    else
        bar:SetParent(UIParent)
    end

    local button, lastButton, lastColumnButton
    for i = 1, NUM_PET_ACTION_SLOTS do
		button = _G["PetActionButton"..i]
		local petAutoCastableTexture = _G["PetActionButton"..i.."AutoCastable"]
		local petAutoCastShine = _G["PetActionButton"..i.."Shine"]
		lastButton = _G["PetActionButton"..(i-1)]
		lastColumnButton = _G["PetActionButton"..(i-buttonsPerRow)]
        button:SetParent(RayUIPetBar)
		button:SetSize(buttonsize, buttonsize)
		petAutoCastableTexture:SetOutside(button, 12, 12)
		petAutoCastShine:SetAllPoints(button)
		button:ClearAllPoints()
        button.noResize = true

        if i == 1 then
			button:SetPoint("TOPLEFT", bar, "TOPLEFT", 0, 0)
        elseif (i - 1) % buttonsPerRow == 0 then
			button:SetPoint("TOPLEFT", lastColumnButton, "BOTTOMLEFT", 0, -buttonspacing)
        else
			button:SetPoint("LEFT", lastButton, "RIGHT", buttonspacing, 0)
        end

        if self.db.barpet.mouseover then
            if not self.hooks[button] then
                self:HookScript(button, "OnEnter", function() UIFrameFadeIn(bar,0.5,bar:GetAlpha(),1) end)
                self:HookScript(button, "OnLeave", function() UIFrameFadeOut(bar,0.5,bar:GetAlpha(),0) end)
            end
        else
            if not self.hooks[button] then
                self:Unhook(button, "OnEnter")
                self:Unhook(button, "OnLeave")
            end
        end
    end

    if self.db.barpet.enable then
        bar:Show()
        RegisterStateDriver(bar, "visibility", "[petbattle][overridebar][vehicleui][possessbar,@vehicle,exists] hide; [@pet,exists] show; hide")
    else
        bar:Hide()
        UnregisterStateDriver(bar, "visibility")
    end
end
