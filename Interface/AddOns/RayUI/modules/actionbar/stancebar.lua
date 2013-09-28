local R, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local AB = R:GetModule("ActionBar")

function AB:CreateStanceBar()
	local num = NUM_STANCE_SLOTS
	local num2 = NUM_POSSESS_SLOTS

	local bar = CreateFrame("Frame","RayUIStanceBar",UIParent, "SecureHandlerStateTemplate")
	bar:SetWidth(AB.db.buttonsize*num+AB.db.buttonspacing*(num-1))
	bar:SetHeight(AB.db.buttonsize)
	bar:SetPoint("BOTTOMLEFT", "UIParent", "BOTTOMLEFT", 15, 202)
	bar:SetScale(AB.db.barscale)

	if self.db.stancebarfade then
		bar:SetParent(RayUIActionBarHider)
	else
		bar:SetParent(UIParent)
	end

	R:CreateMover(bar, "StanceBarMover", L["职业条锚点"], true, nil, "ALL,ACTIONBARS")  

	StanceBarFrame:SetParent(bar)
	StanceBarFrame:EnableMouse(false)

	for i=1, num do
		local button = _G["StanceButton"..i]
		button:SetSize(AB.db.buttonsize, AB.db.buttonsize)
		button:ClearAllPoints()
		if i == 1 then
			button:SetPoint("BOTTOMLEFT", bar, 0,0)
		else
			local previous = _G["StanceButton"..i-1]      
			button:SetPoint("LEFT", previous, "RIGHT", AB.db.buttonspacing, 0)
		end
	end

	PossessBarFrame:SetParent(bar)
	PossessBarFrame:EnableMouse(false)

	for i=1, num2 do
		local button = _G["PossessButton"..i]
		button:SetSize(AB.db.buttonsize, AB.db.buttonsize)
		button:ClearAllPoints()
		if i == 1 then
			button:SetPoint("BOTTOMLEFT", bar, 0, 0)
		else
			local previous = _G["PossessButton"..i-1]
			button:SetPoint("LEFT", previous, "RIGHT", AB.db.buttonspacing, 0)
		end
	end

	local function RayUIMoveShapeshift()
		if InCombatLockdown() then return end
		StanceButton1:SetPoint("BOTTOMLEFT", bar, 0,0)
	end
	hooksecurefunc("StanceBar_Update", RayUIMoveShapeshift)


	if AB.db.stancebarmouseover then    
		AB.db.stancebarfade = false  
		bar:SetAlpha(0)
		bar:SetScript("OnEnter", function(self) UIFrameFadeIn(bar,0.5,bar:GetAlpha(),1) end)
		bar:SetScript("OnLeave", function(self) UIFrameFadeOut(bar,0.5,bar:GetAlpha(),0) end)  
		for i=1, num do
			local pb = _G["StanceButton"..i]
			pb:HookScript("OnEnter", function(self) UIFrameFadeIn(bar,0.5,bar:GetAlpha(),1) end)
			pb:HookScript("OnLeave", function(self) UIFrameFadeOut(bar,0.5,bar:GetAlpha(),0) end)
		end    
	end

	RegisterStateDriver(bar, "visibility", "[petbattle][overridebar][vehicleui] hide; show")
end
