local R, L, P, G = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, GlobalDB
local AB = R:GetModule("ActionBar")

--Cache global variables
--Lua functions
local _G = _G

--WoW API / Variables
local CreateFrame = CreateFrame
local RegisterStateDriver = RegisterStateDriver

--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: OverrideActionBar, NUM_OVERRIDE_BUTTONS

function AB:CreateOverrideBar()
    local num = NUM_OVERRIDE_BUTTONS
    local bar = CreateFrame("Frame","RayUIOverrideBar", R.UIParent, "SecureHandlerStateTemplate")
	bar:SetFrameStrata("LOW")
    bar:SetWidth(AB.db.buttonsize*(num+1)+AB.db.buttonspacing*num)
    bar:SetHeight(AB.db.buttonsize)
    bar:Point("BOTTOM", R.UIParent, "BOTTOM", 0, 235)
    bar:SetScale(AB.db.barscale)

    OverrideActionBar:SetParent(bar)
    OverrideActionBar:EnableMouse(false)
    OverrideActionBar:SetScript("OnShow", nil)

    local leaveButtonPlaced = false

    for i=1, num do
        local button = _G["OverrideActionBarButton"..i]
        button:SetSize(AB.db.buttonsize, AB.db.buttonsize)
        button:ClearAllPoints()
        if i == 1 then
            button:SetPoint("BOTTOMLEFT", bar, 0,0)
        else
            local previous = _G["OverrideActionBarButton"..i-1]
            button:SetPoint("LEFT", previous, "RIGHT", AB.db.buttonspacing, 0)
        end
    end

    OverrideActionBar.LeaveButton:SetSize(AB.db.buttonsize, AB.db.buttonsize)
    OverrideActionBar.LeaveButton:ClearAllPoints()
    OverrideActionBar.LeaveButton:SetPoint("LEFT", _G["OverrideActionBarButton"..num] , "RIGHT", AB.db.buttonspacing, 0)
    OverrideActionBar.LeaveButton:CreateShadow()
    OverrideActionBar.LeaveButton:GetNormalTexture():SetTexCoord(0.09, 0.16, 0.37, 0.43)
    OverrideActionBar.LeaveButton:StyleButton(true)
    OverrideActionBar.LeaveButton:SetPushedTexture(nil)

    RegisterStateDriver(bar, "visibility", "[petbattle] hide; [overridebar][vehicleui][possessbar,@vehicle,exists] show; hide")
    RegisterStateDriver(OverrideActionBar, "visibility", "[overridebar][vehicleui][possessbar,@vehicle,exists] show; hide")
end
