local R, L, P, G = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, GlobalDB
local M = R:GetModule("Misc")
local mod = M:NewModule("Focuser", "AceEvent-3.0")

--Cache global variables
--Lua functions
local pairs = pairs

--WoW API / Variables
local CreateFrame = CreateFrame
local InCombatLockdown = InCombatLockdown
local SetOverrideBindingClick = SetOverrideBindingClick

--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: RayUF

local modifier = "shift" -- shift, alt or ctrl
local mouseButton = "1" -- 1 = left, 2 = right, 3 = middle, 4 and 5 = thumb buttons if there are any
local waitforHook = {}

function mod:HookOuf()
    for _, object in pairs(RayUF.objects) do
        self:SetFocusHotkey(object)
    end
end

function mod:SetFocusHotkey(frame)
    if InCombatLockdown() then
        if not frame.FocuserHooked then
            waitforHook[frame] = true
        end
    else
        if not frame.FocuserHooked then
            frame:SetAttribute(modifier.."-type"..mouseButton,"focus")
            frame.FocuserHooked = true
        end
        waitforHook[frame] = nil
    end
end

function mod:PLAYER_REGEN_ENABLED()
    if not InCombatLockdown() then
        for frame in pairs(waitforHook) do
            self:SetFocusHotkey(frame)
        end
    end
end

function mod:Initialize()
    local FocuserButton = CreateFrame("CheckButton", "FocuserButton", R.UIParent, "SecureActionButtonTemplate")
    FocuserButton:SetAttribute("type1","macro")
    FocuserButton:SetAttribute("macrotext","/focus mouseover")
    SetOverrideBindingClick(FocuserButton, true, modifier.."-BUTTON"..mouseButton, "FocuserButton")
    self:HookOuf()

    self:RegisterEvent("PLAYER_REGEN_ENABLED")
    self:RegisterEvent("GROUP_ROSTER_UPDATE", "HookOuf")
end

M:RegisterMiscModule(mod:GetName())
