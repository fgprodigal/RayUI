local R, L, P = unpack(select(2, ...)) --Inport: Engine, Locales, ProfileDB
local M = R:GetModule("Misc")

local function LoadFunc()
	local f = CreateFrame("Frame")

	f:RegisterEvent("PLAYER_ENTERING_WORLD")

	f:SetScript("OnEvent", function()
		if UnitIsAFK("player") then
			SendChatMessage("","AFK")
		end
	end)
end

M:RegisterMiscModule("AFKFix", LoadFunc)