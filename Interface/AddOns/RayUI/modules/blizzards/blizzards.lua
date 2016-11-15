local R, L, P, G = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, GlobalDB
local B = R:NewModule("Blizzards", "AceEvent-3.0", "AceHook-3.0", "AceConsole-3.0")

function B:Initialize()
    CreateFrame("Frame"):SetScript("OnUpdate", function(self, elapsed)
		if LFRBrowseFrame.timeToClear then
			LFRBrowseFrame.timeToClear = nil
		end
	end)
end

R:RegisterModule(B:GetName())
