local R, L, P = unpack(select(2, ...)) --Inport: Engine, Locales, ProfileDB
local AB = R:GetModule("ActionBar")

function AB:CreateVehicleExit()
	local bar = CreateFrame("Frame", "RayUIVehicleBar", UIParent, "SecureHandlerStateTemplate")
	bar:SetHeight(AB.db.buttonsize)
	bar:SetWidth(AB.db.buttonsize)
	bar:SetPoint("BOTTOMLEFT", "RayUIActionBar3", "BOTTOMRIGHT", AB.db.buttonspacing, 0)
	bar:SetScale(AB.db.barscale)

	local veb = CreateFrame("BUTTON", nil, bar, "SecureActionButtonTemplate")
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
end
