local R, L, P = unpack(select(2, ...)) --Inport: Engine, Locales, ProfileDB
local AB = R:GetModule("ActionBar")

function AB:CreateBar5()
	local bar = CreateFrame("Frame","RayUIActionBar5",UIParent, "SecureHandlerStateTemplate")
	bar:SetHeight(AB.db.buttonsize*12+AB.db.buttonspacing*11)
	bar:SetWidth(AB.db.buttonsize)
	bar:Point("LEFT", "UIParent", "LEFT", 15, 0)
	bar:SetScale(AB.db.barscale)

	R:CreateMover(bar, "ActionBar5Mover", L["动作条5锚点"], true, nil, "ALL,ACTIONBARS")  

	MultiBarLeft:SetParent(bar)
	  
	for i=1, 12 do
		local button = _G["MultiBarLeftButton"..i]
		button:ClearAllPoints()
		button:SetSize(AB.db.buttonsize, AB.db.buttonsize)
		if i == 1 then
			button:SetPoint("TOPLEFT", bar, 0,0)
		else
			local previous = _G["MultiBarLeftButton"..i-1]
			button:SetPoint("TOP", previous, "BOTTOM", 0, -AB.db.buttonspacing)
		end
	end

	RegisterStateDriver(bar, "visibility", "[petbattle][overridebar][vehicleui] hide; show")

	if AB.db.bar5mouseover then
		AB.db.bar5fade = false
		bar:SetAlpha(0)
		bar:SetScript("OnEnter", function(self) UIFrameFadeIn(bar,0.5,bar:GetAlpha(),1) end)
		bar:SetScript("OnLeave", function(self) UIFrameFadeOut(bar,0.5,bar:GetAlpha(),0) end)  
		for i=1, 12 do
			local pb = _G["MultiBarLeftButton"..i]
			pb:HookScript("OnEnter", function(self) UIFrameFadeIn(bar,0.5,bar:GetAlpha(),1) end)
			pb:HookScript("OnLeave", function(self) UIFrameFadeOut(bar,0.5,bar:GetAlpha(),0) end)
		end    
	end
  end
