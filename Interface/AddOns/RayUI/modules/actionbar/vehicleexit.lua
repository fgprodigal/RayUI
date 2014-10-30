local R, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local AB = R:GetModule("ActionBar")

function AB:CreateVehicleExit()
	local holder = CreateFrame("Frame", nil, UIParent, SecureHandlerStateTemplate)
	holder:SetHeight(AB.db.buttonsize)
	holder:SetWidth(AB.db.buttonsize)

	local bar = CreateFrame("Frame", "RayUIVehicleBar", holder, "SecureHandlerStateTemplate")
	bar:Show()
	bar:SetAllPoints()

	local veb = CreateFrame("BUTTON", nil, bar, "SecureActionButtonTemplate")
	veb:Show()
	veb:SetAllPoints()
	veb:CreateShadow("Background")
	veb:RegisterForClicks("AnyUp")
	veb:SetNormalTexture("Interface\\Vehicles\\UI-Vehicles-Button-Exit-Up")
	veb:GetNormalTexture():SetPoint("TOPLEFT", -4, 4)
	veb:GetNormalTexture():SetPoint("BOTTOMRIGHT", 4, -4)
	veb:GetNormalTexture():SetTexCoord(.08, .92, .08, .92)
	veb:SetPushedTexture("Interface\\Vehicles\\UI-Vehicles-Button-Exit-Down")
	veb:GetPushedTexture():SetPoint("TOPLEFT", -4, 4)
	veb:GetPushedTexture():SetPoint("BOTTOMRIGHT", 4, -4)
	veb:GetPushedTexture():SetTexCoord(.08, .92, .08, .92)
	veb:SetHighlightTexture("Interface\\Vehicles\\UI-Vehicles-Button-Exit-Down")
	veb:GetHighlightTexture():SetPoint("TOPLEFT", -4, 4)
	veb:GetHighlightTexture():SetPoint("BOTTOMRIGHT", 4, -4)
	veb:GetHighlightTexture():SetTexCoord(.08, .92, .08, .92)
	veb:SetScript("OnClick", function(self) VehicleExit() end)
	local function UpdateTooltip(self)
		if (GetCVar("UberTooltips") == "1") then
			GameTooltip_SetDefaultAnchor(GameTooltip, self);
		else
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
		end
		GameTooltip:SetText(LEAVE_VEHICLE)
		self.UpdateTooltip = UpdateTooltip
	end
	veb:SetScript("OnEnter", function(self)
		UpdateTooltip(self)
	end)
	veb:SetScript("OnLeave", GameTooltip_Hide)
    RegisterStateDriver(veb, "visibility", "[petbattle][overridebar][vehicleui][possessbar] hide; [@vehicle,exists] show; hide")
    RegisterStateDriver(bar, "visibility", "[petbattle][overridebar][vehicleui][possessbar] hide; show")

    if not self.db.bar2.enable and not self.db.bar3.enable and not ( R.db.movers and R.db.movers.ActionBar1Mover ) then
        holder:SetPoint("LEFT", "RayUIActionBar1", "RIGHT", AB.db.buttonspacing, 0)
    else--[[ if not ( R.db.movers and R.db.movers.ActionBar1Mover ) then ]]
        holder:SetPoint("BOTTOMLEFT", "RayUIActionBar3", "BOTTOMRIGHT", AB.db.buttonspacing, 0)
    end

	R:CreateMover(holder, "VehicleExitButtonMover", L["离开载具按钮"], true, nil, "ALL,ACTIONBARS")
end
