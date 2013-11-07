local R, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local B = R:GetModule("Blizzards")

function B:StaticPopup_Show(which, text_arg1, text_arg2, data)
	if which == "ADDON_ACTION_FORBIDDEN" and ((text_arg1 or "")..(text_arg2 or "")):find("IsDisabledByParentalControls") then
		StaticPopup_Hide(which)
	end
end

function B:FixBlizzardBugs()
	self:SecureHook("StaticPopup_Show")

	----------------------------------------------------------------------------------------
	--        Fix IsDisabledByParentalControls() taint
	----------------------------------------------------------------------------------------
	if GetBuildInfo() ~= "5.4.1" then return end

	setfenv(WorldMapFrame_OnShow, setmetatable({UpdateMicroButtons = function() end}, {__index = _G}))
	setfenv(FriendsFrame_OnShow, setmetatable({UpdateMicroButtons = function() end}, {__index = _G}))

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