----------------------------------------------------------
-- Load RayUI Environment
----------------------------------------------------------
RayUI:LoadEnv("Misc")


local M = _Misc
local mod = M:NewModule("SetRole", "AceEvent-3.0")
local S = R.Skins

function mod:SetRole()
    local spec = GetSpecialization()
    if UnitLevel("player") >= 10 and not InCombatLockdown() then
        if spec == nil and UnitGroupRolesAssigned("player") ~= "NONE" then
            UnitSetRole("player", "NONE")
        elseif spec ~= nil then
            if GetNumGroupMembers() > 0 then
				if UnitGroupRolesAssigned("player") ~= R:GetPlayerRole() then
					UnitSetRole("player", R:GetPlayerRole())
				end
            end
        end
    end
end

function mod:Initialize()
    R.RegisterCallback(mod, "RoleChanged", "SetRole")
    self:RegisterEvent("GROUP_ROSTER_UPDATE", "SetRole")
    RolePollPopup:SetScript("OnShow", function() StaticPopupSpecial_Hide(RolePollPopup) end)
end

M:RegisterMiscModule(mod:GetName())
