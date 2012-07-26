local R, L, P = unpack(select(2, ...)) --Inport: Engine, Locales, ProfileDB
local S = R:GetModule("Skins")

local function LoadSkin()
	local r, g, b = S["media"].classcolours[R.myclass].r, S["media"].classcolours[R.myclass].g, S["media"].classcolours[R.myclass].b
	TimeManagerFrame:StripTextures()
	S:SetBD(TimeManagerFrame, 5, -10, -48, 10)
	S:ReskinClose(TimeManagerCloseButton, "TOPRIGHT", TimeManagerFrame, "TOPRIGHT", -51, -13)
	S:ReskinDropDown(TimeManagerAlarmHourDropDown)
	TimeManagerAlarmHourDropDown:SetWidth(80)
	S:ReskinDropDown(TimeManagerAlarmMinuteDropDown)
	TimeManagerAlarmMinuteDropDown:SetWidth(80)
	S:ReskinDropDown(TimeManagerAlarmAMPMDropDown)
	TimeManagerAlarmAMPMDropDown:SetWidth(90)
	S:ReskinCheck(TimeManagerMilitaryTimeCheck)
	S:ReskinCheck(TimeManagerLocalTimeCheck)
	S:ReskinInput(TimeManagerAlarmMessageEditBox)
	TimeManagerAlarmEnabledButton:SetNormalTexture(nil)
	TimeManagerAlarmEnabledButton.SetNormalTexture = R.dummy
	S:Reskin(TimeManagerAlarmEnabledButton)

	TimeManagerStopwatchFrame:StripTextures()
	TimeManagerStopwatchCheck:CreateBorder()
	TimeManagerStopwatchCheck:GetNormalTexture():SetTexCoord(.08, .92, .08, .92)
	TimeManagerStopwatchCheck:GetNormalTexture():ClearAllPoints()
	TimeManagerStopwatchCheck:GetNormalTexture():Point("TOPLEFT", 2, -2)
	TimeManagerStopwatchCheck:GetNormalTexture():Point("BOTTOMRIGHT", -2, 2)
	local hover = TimeManagerStopwatchCheck:CreateTexture("frame", nil, TimeManagerStopwatchCheck) -- hover
	hover:SetTexture(1, 1, 1, 0.3)
	hover:Point("TOPLEFT", TimeManagerStopwatchCheck, 2, -2)
	hover:Point("BOTTOMRIGHT", TimeManagerStopwatchCheck, -2, 2)
	TimeManagerStopwatchCheck:SetHighlightTexture(hover)

	StopwatchFrame:StripTextures()
	S:SetBD(StopwatchFrame)

	StopwatchTabFrame:StripTextures()
	S:ReskinClose(StopwatchCloseButton)
	-- S:HandleNextPrevButton(StopwatchPlayPauseButton)
	-- S:HandleNextPrevButton(StopwatchResetButton)
	-- StopwatchPlayPauseButton:Point("RIGHT", StopwatchResetButton, "LEFT", -4, 0)
	-- StopwatchResetButton:Point("BOTTOMRIGHT", StopwatchFrame, "BOTTOMRIGHT", -4, 6)
end

S:RegisterSkin("Blizzard_TimeManager", LoadSkin)