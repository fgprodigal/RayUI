local R, L, P = unpack(select(2, ...)) --Inport: Engine, Locales, ProfileDB
local AB = R:GetModule("ActionBar")

function AB:CreateExtraButton()
	local holder = CreateFrame('Frame', nil, UIParent)
	holder:Point("CENTER", UIParent, "BOTTOM", 500, 510)
	holder:Size(ExtraActionBarFrame:GetSize())

	ExtraActionBarFrame:SetParent(holder)
	ExtraActionBarFrame:ClearAllPoints()
	ExtraActionBarFrame:SetPoint("CENTER", holder, "CENTER")
	ExtraActionBarFrame.ignoreFramePositionManager  = true
	-- UIPARENT_MANAGED_FRAME_POSITIONS.ExtraActionBarFrame = nil
	-- UIPARENT_MANAGED_FRAME_POSITIONS.PlayerPowerBarAlt.extraActionBarFrame = nil
	-- UIPARENT_MANAGED_FRAME_POSITIONS.CastingBarFrame.extraActionBarFrame = nil
	ExtraActionButton1Cooldown:Point("TOPLEFT", 1, -1)
	ExtraActionButton1Cooldown:Point("BOTTOMRIGHT", -1, 1)
	ExtraActionButton1:StyleButton(true)

	PlayerPowerBarAlt:ClearAllPoints()
	PlayerPowerBarAlt:SetPoint("TOP", UIParent, "TOP", 0, -108)
	PlayerPowerBarAlt.ignoreFramePositionManager = true

	R:CreateMover(holder, "BossButton", "BossButton", true, nil, "ALL,ACTIONBARS,RAID15,RAID25,RAID40")
end
