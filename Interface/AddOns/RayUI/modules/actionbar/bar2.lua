local R, L, P = unpack(select(2, ...)) --Inport: Engine, Locales, ProfileDB
local AB = R:GetModule("ActionBar")

function AB:CreateBar2()
	local bar = CreateFrame("Frame","RayUIActionBar2",UIParent, "SecureHandlerStateTemplate")
	bar:SetWidth(AB.db.buttonsize*6+AB.db.buttonspacing*5)
	bar:SetHeight(AB.db.buttonsize*2+AB.db.buttonspacing)
	bar:Point("BOTTOMLEFT", ActionBar1Mover, "BOTTOMRIGHT", AB.db.buttonspacing, 0)
	bar:SetScale(AB.db.barscale)

	R:CreateMover(bar, "ActionBar2Mover", L["动作条2锚点"], true, nil, "ALL,ACTIONBARS")  

	MultiBarBottomLeft:SetParent(bar)
	  
	for i=1, 12 do
		local button = _G["MultiBarBottomLeftButton"..i]
		button:SetSize(AB.db.buttonsize, AB.db.buttonsize)
		button:ClearAllPoints()
		if i == 1 then
			button:SetPoint("TOPLEFT", bar, 0,0)
		elseif i==7 then
			button:SetPoint("BOTTOMLEFT", bar, 0,0)
		else
			local previous = _G["MultiBarBottomLeftButton"..i-1]      
			button:SetPoint("LEFT", previous, "RIGHT", AB.db.buttonspacing, 0)
		end
	end
	
	RegisterStateDriver(bar, "visibility", "[petbattle][overridebar][vehicleui] hide; show")
	  
	if AB.db.bar2mouseover then
		AB.db.bar2fade = false
		bar:SetAlpha(0)
		bar:SetScript("OnEnter", function(self) UIFrameFadeIn(bar,0.5,bar:GetAlpha(),1) end)
		bar:SetScript("OnLeave", function(self) UIFrameFadeOut(bar,0.5,bar:GetAlpha(),0) end)  
		for i=1, 12 do
			local pb = _G["MultiBarBottomLeftButton"..i]
			pb:HookScript("OnEnter", function(self) UIFrameFadeIn(bar,0.5,bar:GetAlpha(),1) end)
			pb:HookScript("OnLeave", function(self) UIFrameFadeOut(bar,0.5,bar:GetAlpha(),0) end)
		end    
	end
end
