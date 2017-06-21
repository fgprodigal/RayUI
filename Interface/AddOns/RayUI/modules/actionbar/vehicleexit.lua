----------------------------------------------------------
-- Load RayUI Environment
----------------------------------------------------------
_LoadRayUIEnv_()


local AB = R:GetModule("ActionBar")
local S = R:GetModule("Skins")

--Cache global variables
--Lua functions
local _G = _G

--WoW API / Variables
local CreateFrame = CreateFrame
local MainMenuBarVehicleLeaveButton_OnEnter = MainMenuBarVehicleLeaveButton_OnEnter
local GameTooltip_Hide = GameTooltip_Hide
local UnitOnTaxi = UnitOnTaxi
local TaxiRequestEarlyLanding = TaxiRequestEarlyLanding
local VehicleExit = VehicleExit
local CanExitVehicle = CanExitVehicle
local ActionBarController_GetCurrentActionBarState = ActionBarController_GetCurrentActionBarState

--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: LE_ACTIONBAR_STATE_MAIN

function AB:CreateVehicleExit()
	local holder = CreateFrame("Frame", nil, R.UIParent, "SecureHandlerStateTemplate")
	holder:SetHeight(AB.db.buttonsize)
	holder:SetWidth(AB.db.buttonsize)

	local bar = CreateFrame("Frame", "RayUIVehicleBar", holder)
	bar:SetFrameStrata("HIGH")
	bar:Show()
	bar:SetAllPoints()

	local veb = CreateFrame("BUTTON", nil, bar)
	veb:Show()
	veb:SetAllPoints()
	veb:CreateShadow("Background")
	veb:RegisterForClicks("AnyUp")
    veb.icon = veb:CreateFontString(nil, "OVERLAY")
    veb.icon:FontTemplate(R["media"].octicons, 20*R.mult, "OUTLINE")
    veb.icon:Point("CENTER", 2, -1)
    veb.icon:SetText("")
	veb:SetScript("OnClick", function(self)
		if ( UnitOnTaxi("player") ) then
			TaxiRequestEarlyLanding()
			self:EnableMouse(false)
		else
			VehicleExit()
		end
	end)
	veb:SetScript("OnEnter", MainMenuBarVehicleLeaveButton_OnEnter)
    veb:HookScript("OnEnter", function() veb.icon:SetTextColor(S["media"].r, S["media"].g, S["media"].b) end)
	veb:SetScript("OnLeave", GameTooltip_Hide)
    veb:HookScript("OnLeave", function() veb.icon:SetTextColor(1, 1, 1) end)
	veb:RegisterEvent("PLAYER_ENTERING_WORLD")
	veb:RegisterEvent("UPDATE_BONUS_ACTIONBAR")
	veb:RegisterEvent("UPDATE_MULTI_CAST_ACTIONBAR")
	veb:RegisterEvent("UNIT_ENTERED_VEHICLE")
	veb:RegisterEvent("UNIT_EXITED_VEHICLE")
	veb:RegisterEvent("VEHICLE_UPDATE")
	veb:SetScript("OnEvent", function(self)
		if ( CanExitVehicle() and ActionBarController_GetCurrentActionBarState() == LE_ACTIONBAR_STATE_MAIN ) then
			self:Show()
			self:EnableMouse(true)
		else
			self:Hide()
		end
	end)

    if not self.db.bar2.enable and not self.db.bar3.enable and not ( R.db.movers and R.db.movers.ActionBar1Mover ) then
        holder:SetPoint("LEFT", "RayUIActionBar1", "RIGHT", AB.db.buttonspacing, 0)
    else--[[ if not ( R.db.movers and R.db.movers.ActionBar1Mover ) then ]]
        holder:SetPoint("BOTTOMLEFT", "RayUIActionBar3", "BOTTOMRIGHT", AB.db.buttonspacing, 0)
    end

	R:CreateMover(holder, "VehicleExitButtonMover", L["离开载具按钮"], true, nil, "ALL,ACTIONBARS")
end
