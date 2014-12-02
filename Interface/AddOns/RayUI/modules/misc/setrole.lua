local R, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local M = R:GetModule("Misc")
local S = R:GetModule("Skins")

local t = {
	["Melee"] = "DAMAGER",
	["Caster"] = "DAMAGER",
	["Tank"] = "TANK",
}

local function LoadFunc()
	local function SetRole()
		local spec = GetSpecialization()
		if UnitLevel("player") >= 10 and not InCombatLockdown() then
			if spec == nil then
				UnitSetRole("player", "NONE")
			elseif spec ~= nil then
				if GetNumGroupMembers() > 0 then
					if R.isHealer then
						UnitSetRole("player", "HEALER")
					else
						UnitSetRole("player", t[R.Role])
					end
				end
			end
		end
	end

	local frame = CreateFrame("Frame")
	frame:RegisterEvent("PLAYER_TALENT_UPDATE")
	frame:RegisterEvent("GROUP_ROSTER_UPDATE")
	frame:RegisterEvent("PLAYER_ENTERING_BATTLEGROUND")

	frame:SetScript("OnEvent", SetRole)

	RolePollPopup:SetScript("OnShow", function() StaticPopupSpecial_Hide(RolePollPopup) end)
end

M:RegisterMiscModule("SetRole", LoadFunc)