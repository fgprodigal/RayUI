----------------------------------------------------------
-- Load RayUI Environment
----------------------------------------------------------
RayUI:LoadEnv("Misc")


local M = _Misc
local mod = M:NewModule("TalkingHead", "AceEvent-3.0")


function mod:ScaleTalkingHeadFrame()
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

function mod:InitializeTalkingHead()
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

function mod:PLAYER_ENTERING_WORLD(event)
    self:UnregisterEvent(event)
    TalkingHead_LoadUI()
    self:InitializeTalkingHead()
    self:ScaleTalkingHeadFrame()
end

function mod:Initialize()
    if IsAddOnLoaded("Blizzard_TalkingHeadUI") then
        self:InitializeTalkingHead()
        self:ScaleTalkingHeadFrame()
    else
        self:RegisterEvent("PLAYER_ENTERING_WORLD")
    end
end

M:RegisterMiscModule(mod:GetName())
