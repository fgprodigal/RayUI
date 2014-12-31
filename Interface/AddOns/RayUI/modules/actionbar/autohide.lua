local R, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local AB = R:GetModule("ActionBar")

local hider = CreateFrame("Frame", "RayUIActionBarHider", UIParent)
RegisterStateDriver(hider, "visibility", "[combat][@target,exists][vehicleui]show")

local function pending()
	if UnitAffectingCombat("player") then return true end
	if UnitExists("target") then return true end
	if UnitInVehicle("player") then return true end
	if SpellBookFrame:IsShown() then return true end
	if IsAddOnLoaded("Blizzard_MacroUI") and MacroFrame:IsShown() then return true end
	if HoverBind and HoverBind.active then return true end
end

local function FadeOutActionButton()
	local fadeInfo = {}
	fadeInfo.mode = "OUT"
	fadeInfo.timeToFade = 0.5
	fadeInfo.finishedFunc = function()
		if InCombatLockdown() or pending() then return end
		RayUIActionBarHider:Hide()
	end
	fadeInfo.startAlpha = RayUIActionBarHider:GetAlpha()
	fadeInfo.endAlpha = 0
	R:UIFrameFade(RayUIActionBarHider, fadeInfo)
end

local function FadeInActionButton()
	if not InCombatLockdown() then
		RayUIActionBarHider:Show()
	end
	R:UIFrameFadeIn(RayUIActionBarHider, 0.5, RayUIActionBarHider:GetAlpha(), 1)
end

function AB:OnAutoHideEvent(event, addon)
	if event == "ADDON_LOADED" then
		if addon == "Blizzard_MacroUI" then
			self:UnregisterEvent("ADDON_LOADED")
			MacroFrame:HookScript("OnShow", function(self, event)
				FadeInActionButton()
			end)
			MacroFrame:HookScript("OnHide", function(self, event)
				if not pending() then
					FadeOutActionButton()
				end
			end)
		end
	end
	if pending() then
		FadeInActionButton()
	else
		FadeOutActionButton()
	end
end

function AB:EnableAutoHide()
	AB:RegisterEvent("PLAYER_ENTERING_WORLD", "OnAutoHideEvent")
	AB:RegisterEvent("PLAYER_REGEN_ENABLED", "OnAutoHideEvent")
	AB:RegisterEvent("PLAYER_REGEN_DISABLED", "OnAutoHideEvent")
	AB:RegisterEvent("PLAYER_TARGET_CHANGED", "OnAutoHideEvent")
	AB:RegisterEvent("UNIT_ENTERED_VEHICLE", "OnAutoHideEvent")
	AB:RegisterEvent("UNIT_EXITED_VEHICLE", "OnAutoHideEvent")
	AB:RegisterEvent("ADDON_LOADED", "OnAutoHideEvent")

	SpellBookFrame:HookScript("OnShow", function(self, event)
		FadeInActionButton()
	end)

	SpellBookFrame:HookScript("OnHide", function(self, event)
		if not pending() then
			FadeOutActionButton()
		end
	end)
end
