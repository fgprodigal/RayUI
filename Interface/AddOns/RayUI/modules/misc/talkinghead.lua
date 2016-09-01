local R, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local M = R:GetModule("Misc")

local function ScaleTalkingHeadFrame()
	local scale = 1
	local width = TalkingHeadFrame:GetWidth() * scale
	local height = TalkingHeadFrame:GetHeight() * scale
	TalkingHeadFrame.dirtyWidth = width
	TalkingHeadFrame.dirtyHeight = height

	TalkingHeadFrame:SetScale(scale)
	TalkingHeadFrame:GetScript("OnSizeChanged")(TalkingHeadFrame) --Resize mover

	--Reset Model Camera
	local model = TalkingHeadFrame.MainFrame.Model
	if model.uiCameraID then
		model:RefreshCamera()
		Model_ApplyUICamera(model, model.uiCameraID)
	end
end

local function InitializeTalkingHead()
	--Prevent WoW from moving the frame around
	TalkingHeadFrame.ignoreFramePositionManager = true
	UIPARENT_MANAGED_FRAME_POSITIONS["TalkingHeadFrame"] = nil

	--Set default position
	TalkingHeadFrame:ClearAllPoints()
	TalkingHeadFrame:SetPoint("BOTTOM", 0, 50)

	R:CreateMover(TalkingHeadFrame, "TalkingHeadFrameMover", "Talking Head Frame")
	
	--Iterate through all alert subsystems in order to find the one created for TalkingHeadFrame, and then remove it.
	--We do this to prevent alerts from anchoring to this frame when it is shown.
	for index, alertFrameSubSystem in ipairs(AlertFrame.alertFrameSubSystems) do
		if alertFrameSubSystem.anchorFrame and alertFrameSubSystem.anchorFrame == TalkingHeadFrame then
			table.remove(AlertFrame.alertFrameSubSystems, index)
		end
	end
end

local function LoadFunc()
	if IsAddOnLoaded("Blizzard_TalkingHeadUI") then
		InitializeTalkingHead()
		ScaleTalkingHeadFrame()
	else
		local f = CreateFrame("Frame")
		f:RegisterEvent("PLAYER_ENTERING_WORLD")
		f:SetScript("OnEvent", function(self, event)
			self:UnregisterEvent(event)
			TalkingHead_LoadUI();
			InitializeTalkingHead()
			ScaleTalkingHeadFrame()
		end)
	end
end

M:RegisterMiscModule("TalkingHead", LoadFunc)