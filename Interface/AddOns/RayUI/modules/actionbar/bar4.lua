local R, L, P = unpack(select(2, ...)) --Inport: Engine, Locales, ProfileDB
local AB = R:GetModule("ActionBar")

function AB:CreateBar4()
	local bar = CreateFrame("Frame","RayUIActionBar4",UIParent, "SecureHandlerStateTemplate")
	bar:SetHeight(AB.db.buttonsize*12+AB.db.buttonspacing*11)
	bar:SetWidth(AB.db.buttonsize)
	bar:Point("RIGHT", "UIParent", "RIGHT", -15, 0)
	bar:SetScale(AB.db.barscale)

	R:CreateMover(bar, "ActionBar4Mover", L["动作条4锚点"], true, nil, "ALL,ACTIONBARS")  

	MultiBarRight:SetParent(bar)
	  
	for i=1, 12 do
		local button = _G["MultiBarRightButton"..i]
		button:ClearAllPoints()
		button:SetSize(AB.db.buttonsize, AB.db.buttonsize)
		if i == 1 then
			button:SetPoint("TOPLEFT", bar, 0,0)
		else
			local previous = _G["MultiBarRightButton"..i-1]
			button:SetPoint("TOP", previous, "BOTTOM", 0, -AB.db.buttonspacing)
		end
	end

	RegisterStateDriver(bar, "visibility", "[petbattle][overridebar][vehicleui] hide; show")

	if AB.db.bar4mouseover then    
		AB.db.bar4fade = false
		bar:SetAlpha(0)
		bar:SetScript("OnEnter", function(self) UIFrameFadeIn(bar,0.5,bar:GetAlpha(),1) end)
		bar:SetScript("OnLeave", function(self) UIFrameFadeOut(bar,0.5,bar:GetAlpha(),0) end)  
		for i=1, 12 do
			local pb = _G["MultiBarRightButton"..i]
			pb:HookScript("OnEnter", function(self) UIFrameFadeIn(bar,0.5,bar:GetAlpha(),1) end)
			pb:HookScript("OnLeave", function(self) UIFrameFadeOut(bar,0.5,bar:GetAlpha(),0) end)
		end    
	end
  end
