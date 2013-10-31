local R, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local B = R:GetModule("Blizzards")

function B:FixBlizzardBugs()
	----------------------------------------------------------------------------------------
	--        Fix IsDisabledByParentalControls() taint
	----------------------------------------------------------------------------------------
	setfenv(WorldMapFrame_OnShow, setmetatable({UpdateMicroButtons = function() end}, {__index = _G}))
	setfenv(FriendsFrame_OnShow, setmetatable({UpdateMicroButtons = function() end}, {__index = _G}))
	setfenv(SpellBookFrame_OnShow, setmetatable({UpdateMicroButtons = function() end}, {__index = _G}))
	setfenv(SpellBookFrame_OnHide, setmetatable({UpdateMicroButtons = function() end}, {__index = _G}))

	local ParentalControls = CreateFrame("Frame")
	ParentalControls:RegisterEvent("ADDON_LOADED")
	ParentalControls:SetScript("OnEvent", function(self, event, addon)
		if addon == "Blizzard_AchievementUI" then
			setfenv(AchievementFrame_OnShow, setmetatable({UpdateMicroButtons = function() end}, {__index = _G}))
			setfenv(AchievementFrame_OnHide, setmetatable({UpdateMicroButtons = function() end}, {__index = _G}))
		elseif addon == "Blizzard_TalentUI" then
			setfenv(PlayerTalentFrame_OnShow, setmetatable({UpdateMicroButtons = function() end}, {__index = _G}))
			setfenv(PlayerTalentFrame_OnHide, setmetatable({UpdateMicroButtons = function() end}, {__index = _G}))
		end
	end)
end