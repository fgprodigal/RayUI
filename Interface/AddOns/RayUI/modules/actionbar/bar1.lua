local R, L, P = unpack(select(2, ...)) --Inport: Engine, Locales, ProfileDB
local AB = R:GetModule("ActionBar")

function AB:CreateBar1()
	local bar = CreateFrame("Frame","RayUIActionBar1",UIParent, "SecureHandlerStateTemplate")
	bar:SetWidth(AB.db.buttonsize*12+AB.db.buttonspacing*11)
	bar:SetHeight(AB.db.buttonsize)
	bar:Point("BOTTOM", "UIParent", "BOTTOM", -3 * AB.db.buttonsize -3 * AB.db.buttonspacing, 235)
	bar:SetScale(AB.db.barscale)

	R:CreateMover(bar, "ActionBar1Mover", L["动作条1锚点"], true)
	
	MainMenuBarArtFrame:SetParent(bar)
	MainMenuBarArtFrame:EnableMouse(false)
	
	for i = 1, NUM_ACTIONBAR_BUTTONS do
		local button = _G["ActionButton"..i]
		button:SetSize(AB.db.buttonsize, AB.db.buttonsize)
		button:ClearAllPoints()
		-- button:SetParent(bar)
		if i == 1 then
			button:SetPoint("BOTTOMLEFT", bar, 0,0)
		else
			local previous = _G["ActionButton"..i-1]
			button:SetPoint("LEFT", previous, "RIGHT", AB.db.buttonspacing, 0)
		end
	end

	RegisterStateDriver(bar, "visibility", "[vehicleui] hide;show")
end
