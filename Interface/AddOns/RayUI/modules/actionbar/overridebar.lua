local R, L, P = unpack(select(2, ...)) --Inport: Engine, Locales, ProfileDB
local AB = R:GetModule("ActionBar")

function AB:CreateOverrideBar()
	local num = NUM_OVERRIDE_BUTTONS
	local bar = CreateFrame("Frame","RayUIOverrideBar",UIParent, "SecureHandlerStateTemplate")
	bar:SetWidth(AB.db.buttonsize*(num+1)+AB.db.buttonspacing*num)
	bar:SetHeight(AB.db.buttonsize)
	bar:Point("BOTTOM", UIParent, "BOTTOM", 0, 235)
	bar:SetScale(AB.db.barscale)

	OverrideActionBar:SetParent(bar)
	OverrideActionBar:EnableMouse(false)
	OverrideActionBar:SetScript("OnShow", nil)

	local leaveButtonPlaced = false
  
	for i=1, num+1 do
		local button = _G["OverrideActionBarButton"..i]
		if not button and not leaveButtonPlaced then
			button = OverrideActionBar.LeaveButton
			leaveButtonPlaced = true
		end
		if not button then
			break
		end
		button:SetSize(AB.db.buttonsize, AB.db.buttonsize)
		button:ClearAllPoints()
		if i == 1 then
			button:SetPoint("BOTTOMLEFT", bar, 0,0)
		else
			local previous = _G["OverrideActionBarButton"..i-1]      
			button:SetPoint("LEFT", previous, "RIGHT", AB.db.buttonspacing, 0)
		end
	end

	RegisterStateDriver(bar, "visibility", "[vehicleui] show;hide")
	RegisterStateDriver(OverrideActionBar, "visibility", "[vehicleui] show;hide")
end