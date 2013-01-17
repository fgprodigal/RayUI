local R, L, P = unpack(select(2, ...)) --Inport: Engine, Locales, ProfileDB
local B = R:NewModule("Blizzards", "AceEvent-3.0", "AceHook-3.0", "AceConsole-3.0")

function B:Initialize()
	self:TalentTaint()
end

R:RegisterModule(B:GetName())
