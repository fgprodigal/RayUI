local R, L, P = unpack(select(2, ...)) --Inport: Engine, Locales, ProfileDB
local AB = R:GetModule("ActionBar")

function AB:CreateBar3()
	local bar = CreateFrame("Frame","RayUIActionBar3",UIParent, "SecureHandlerStateTemplate")
	bar:SetWidth(AB.db.buttonsize*12+AB.db.buttonspacing*11)
	bar:SetHeight(AB.db.buttonsize)
	bar:Point("BOTTOM", ActionBar1Mover, "TOP", 0, AB.db.buttonspacing)
	bar:SetScale(AB.db.barscale)

	R:CreateMover(bar, "ActionBar3Mover", L["动作条3锚点"], true, nil, "ALL,ACTIONBARS")

	MultiBarBottomRight:SetParent(bar)
	  
	for i=1, 12 do
		local button = _G["MultiBarBottomRightButton"..i]
		button:SetSize(AB.db.buttonsize, AB.db.buttonsize)
		button:ClearAllPoints()
		if i == 1 then
			button:SetPoint("BOTTOMLEFT", bar, 0,0)
		else
			local previous = _G["MultiBarBottomRightButton"..i-1]      
			button:SetPoint("LEFT", previous, "RIGHT", AB.db.buttonspacing, 0)
		end
	end

	RegisterStateDriver(bar, "visibility", "[petbattle][overridebar][vehicleui] hide; show")

	if AB.db.bar3mouseover then  
		AB.db.bar3fade = false
		bar:SetAlpha(0)
		bar:SetScript("OnEnter", function(self) UIFrameFadeIn(bar,0.5,bar:GetAlpha(),1) end)
		bar:SetScript("OnLeave", function(self) UIFrameFadeOut(bar,0.5,bar:GetAlpha(),0) end)  
		for i=1, 12 do
			local pb = _G["MultiBarBottomRightButton"..i]
			pb:HookScript("OnEnter", function(self) UIFrameFadeIn(bar,0.5,bar:GetAlpha(),1) end)
			pb:HookScript("OnLeave", function(self) UIFrameFadeOut(bar,0.5,bar:GetAlpha(),0) end)
		end    
	end
end
