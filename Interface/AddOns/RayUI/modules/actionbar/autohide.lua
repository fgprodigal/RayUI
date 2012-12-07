local R, L, P = unpack(select(2, ...)) --Inport: Engine, Locales, ProfileDB
local AB = R:GetModule("ActionBar")

local hider = CreateFrame("Frame", "RayUIActionBarHider", UIParent)

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
	fadeInfo.finishedFunc = function() RayUIActionBarHider:Hide() end
	fadeInfo.startAlpha = RayUIActionBarHider:GetAlpha()
	fadeInfo.endAlpha = 0
	R:UIFrameFade(RayUIActionBarHider, fadeInfo)
end

local function FadeInActionButton()
	RayUIActionBarHider:Show()
	R:UIFrameFadeIn(RayUIActionBarHider, 0.5, RayUIActionBarHider:GetAlpha(), 1)
end

function AB:OnAutoHideEvent(event, addon)
	if event == "PLAYER_ENTERING_WORLD" then
		self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	elseif event == "ADDON_LOADED" then
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
	AB:RegisterEvent("PLAYER_REGEN_ENABLED", "OnAutoHideEvent")
	AB:RegisterEvent("PLAYER_REGEN_DISABLED", "OnAutoHideEvent")
	AB:RegisterEvent("PLAYER_TARGET_CHANGED", "OnAutoHideEvent")
	AB:RegisterEvent("PLAYER_ENTERING_WORLD", "OnAutoHideEvent")
	AB:RegisterEvent("UNIT_ENTERED_VEHICLE", "OnAutoHideEvent")
	AB:RegisterEvent("UNIT_EXITED_VEHICLE", "OnAutoHideEvent")
	AB:RegisterEvent("ADDON_LOADED", "OnAutoHideEvent")

	local buttons = 0

	local function UpdateButtonNumber()
		for i=1, GetNumFlyouts() do
			local x = GetFlyoutID(i)
			local _, _, numSlots, isKnown = GetFlyoutInfo(x)
			if isKnown then
				buttons = numSlots
				break
			end
		end
	end

	hooksecurefunc("ActionButton_UpdateFlyout", UpdateButtonNumber)
	local function SetUpFlyout()
		for i=1, buttons do
			local button = _G["SpellFlyoutButton"..i]
			if button then
				if button:GetParent():GetParent():GetParent() == MultiBarLeft and AB.db.bar5mouseover then
					button:SetScript("OnEnter", function(self) R:UIFrameFadeIn(RayUIActionBar5,0.5,RayUIActionBar5:GetAlpha(),1) end)
					button:SetScript("OnLeave", function(self) R:UIFrameFadeOut(RayUIActionBar5,0.5,RayUIActionBar5:GetAlpha(),0) end)
				end
				if button:GetParent():GetParent():GetParent() == MultiBarRight and AB.db.bar4mouseover then
					button:SetScript("OnEnter", function(self) R:UIFrameFadeIn(RayUIActionBar4,0.5,RayUIActionBar4:GetAlpha(),1) end)
					button:SetScript("OnLeave", function(self) R:UIFrameFadeOut(RayUIActionBar4,0.5,RayUIActionBar4:GetAlpha(),0) end)
				end
				if button:GetParent():GetParent():GetParent() == MultiBarBottomRight and AB.db.bar3mouseover then
					button:SetScript("OnEnter", function(self) R:UIFrameFadeIn(RayUIActionBar3,0.5,RayUIActionBar3:GetAlpha(),1) end)
					button:SetScript("OnLeave", function(self) R:UIFrameFadeOut(RayUIActionBar3,0.5,RayUIActionBar3:GetAlpha(),0) end)
				end
				if button:GetParent():GetParent():GetParent() == MultiBarBottomLeft and AB.db.bar2mouseover then
					button:SetScript("OnEnter", function(self) R:UIFrameFadeIn(RayUIActionBar2,0.5,RayUIActionBar2:GetAlpha(),1) end)
					button:SetScript("OnLeave", function(self) R:UIFrameFadeOut(RayUIActionBar2,0.5,RayUIActionBar2:GetAlpha(),0) end)
				end
			end
		end
	end
	SpellFlyout:HookScript("OnShow", SetUpFlyout)

	SpellBookFrame:HookScript("OnShow", function(self, event)
		FadeInActionButton()
	end)

	SpellBookFrame:HookScript("OnHide", function(self, event)
		if not pending() then
			FadeOutActionButton()
		end
	end)
end
