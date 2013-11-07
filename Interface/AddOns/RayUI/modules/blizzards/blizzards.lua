local R, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local B = R:NewModule("Blizzards", "AceEvent-3.0", "AceHook-3.0", "AceConsole-3.0")

function B:Initialize()
	self:TalentTaint()
	self:FixDeathPopup()
	self:FixBlizzardBugs()
end

R:RegisterModule(B:GetName())
