local R, L, P, G = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB

local AddOn = {}

function AddOn.MikScrollingBattleText()
	MSBTProfiles_SavedVars = MSBTProfiles_SavedVars or {}
	MSBTProfiles_SavedVars.profiles = MSBTProfiles_SavedVars.profiles or {}
	MSBTProfiles_SavedVars.profiles.RayUI = {
		["critFontName"] = "RayUI Combat",
		["normalOutlineIndex"] = 2,
		["animationSpeed"] = 100,
		["creationVersion"] = "5.7.128",
		["critFontSize"] = 20,
		["events"] = {
			["NOTIFICATION_COMBAT_ENTER"] = {
				["disabled"] = true,
			},
			["NOTIFICATION_SHADOW_ORBS_CHANGE"] = {
				["scrollArea"] = "Static",
			},
			["NOTIFICATION_PET_COOLDOWN"] = {
				["disabled"] = true,
			},
			["NOTIFICATION_ALT_POWER_LOSS"] = {
				["scrollArea"] = "Static",
			},
			["NOTIFICATION_POWER_LOSS"] = {
				["scrollArea"] = "Static",
			},
			["NOTIFICATION_CHI_CHANGE"] = {
				["scrollArea"] = "Static",
			},
			["NOTIFICATION_ALT_POWER_GAIN"] = {
				["scrollArea"] = "Static",
			},
			["NOTIFICATION_EXPERIENCE_GAIN"] = {
				["disabled"] = false,
			},
			["NOTIFICATION_HOLY_POWER_FULL"] = {
				["scrollArea"] = "Static",
			},
			["NOTIFICATION_COMBAT_LEAVE"] = {
				["disabled"] = true,
			},
			["NOTIFICATION_HOLY_POWER_CHANGE"] = {
				["scrollArea"] = "Static",
			},
			["NOTIFICATION_CP_FULL"] = {
				["disabled"] = true,
			},
			["NOTIFICATION_ITEM_COOLDOWN"] = {
				["disabled"] = true,
			},
			["NOTIFICATION_CP_GAIN"] = {
				["disabled"] = true,
			},
			["NOTIFICATION_SHADOW_ORBS_FULL"] = {
				["scrollArea"] = "Static",
			},
			["NOTIFICATION_POWER_GAIN"] = {
				["scrollArea"] = "Static",
			},
			["NOTIFICATION_CHI_FULL"] = {
				["scrollArea"] = "Static",
			},
			["NOTIFICATION_COOLDOWN"] = {
				["disabled"] = true,
			},
		},
		["scrollAreas"] = {
			["Static"] = {
				["stickyDirection"] = "Up",
				["scrollHeight"] = 60,
				["offsetY"] = -220,
				["stickyAnimationStyle"] = "Static",
			},
			["Incoming"] = {
				["stickyDirection"] = "Up",
				["direction"] = "Up",
				["offsetX"] = -305,
				["stickyBehavior"] = "MSBT_NORMAL",
				["behavior"] = "MSBT_NORMAL",
				["offsetY"] = -73,
				["animationStyle"] = "Straight",
				["stickyAnimationStyle"] = "Static",
			},
			["Notification"] = {
				["stickyDirection"] = "Up",
				["scrollHeight"] = 105,
				["offsetX"] = -174,
				["animationSpeed"] = 50,
				["offsetY"] = 150,
				["stickyAnimationStyle"] = "Static",
			},
			["Outgoing"] = {
				["stickyDirection"] = "Up",
				["direction"] = "Up",
				["offsetX"] = 306,
				["stickyBehavior"] = "MSBT_NORMAL",
				["behavior"] = "MSBT_NORMAL",
				["offsetY"] = -73,
				["animationStyle"] = "Straight",
				["stickyAnimationStyle"] = "Static",
			},
		},
		["normalFontName"] = "RayUI Combat",
		["critOutlineIndex"] = 2,
		["normalFontSize"] = 16,
	}

	MSBTProfiles_SavedVarsPerChar = MSBTProfiles_SavedVarsPerChar or {}
	MSBTProfiles_SavedVarsPerChar.currentProfileName = MSBTProfiles_SavedVarsPerChar.currentProfileName or "RayUI"
end

local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:SetScript("OnEvent", function(self, event, addon)
	if event == "PLAYER_ENTERING_WORLD" then
		for addon in pairs(AddOn) do
			if IsAddOnLoaded(addon) then
				AddOn[addon]()
				AddOn[addon] = nil
			end
		end
	elseif event == "ADDON_LOADED" then
		if AddOn[addon] then
			AddOn[addon]()
			AddOn[addon] = nil
		end
	end
end)