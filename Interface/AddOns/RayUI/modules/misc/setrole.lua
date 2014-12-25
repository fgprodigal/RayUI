local R, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local M = R:GetModule("Misc")
local S = R:GetModule("Skins")

local t = {
	["Melee"] = "DAMAGER",
	["Caster"] = "DAMAGER",
	["Tank"] = "TANK",
}

local gladStance = GetSpellInfo(156291)

function M:SetRole()
	local spec = GetSpecialization()
	if UnitLevel("player") >= 10 and not InCombatLockdown() then
		if spec == nil then
			UnitSetRole("player", "NONE")
		elseif spec ~= nil then
			if GetNumGroupMembers() > 0 then
				if R.isHealer then
					UnitSetRole("player", "HEALER")
				else
					local tempRole
					if R.Role == "Tank" and UnitBuff("player", gladStance) then
						tempRole = "Melee"
					end
					UnitSetRole("player", t[tempRole or R.Role])
				end
			end
		end
	end
end

local function LoadFunc()
	R.RegisterCallback(M, "RoleChanged", "SetRole")
	
	local f = CreateFrame("Frame")
	f:RegisterEvent("GROUP_ROSTER_UPDATE")
	f:SetScript("OnEvent", M.SetRole)
	RolePollPopup:SetScript("OnShow", function() StaticPopupSpecial_Hide(RolePollPopup) end)
end

M:RegisterMiscModule("SetRole", LoadFunc)