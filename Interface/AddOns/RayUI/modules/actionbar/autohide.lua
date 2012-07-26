local R, L, P = unpack(select(2, ...)) --Inport: Engine, Locales, ProfileDB
local AB = R:GetModule("ActionBar")

local rabs = {}

local function pending()
	if UnitAffectingCombat("player") then return true end
	if UnitExists("target") then return true end
	if UnitInVehicle("player") then return true end
	if SpellBookFrame:IsShown() then return true end
	if IsAddOnLoaded("Blizzard_MacroUI") and MacroFrame:IsShown() then return true end
	if HoverBind and HoverBind.active then return true end
end

local function FadeOutActionButton()
	for _, v in ipairs(rabs) do 
		if _G[v]:GetAlpha()>0 then
			local fadeInfo = {}
			fadeInfo.mode = "OUT"
			fadeInfo.timeToFade = 0.5
			fadeInfo.finishedFunc = function() _G[v]:Hide() end
			fadeInfo.startAlpha = _G[v]:GetAlpha()
			fadeInfo.endAlpha = 0
			R:UIFrameFade(_G[v], fadeInfo)
		end 
	end
end

local function FadeInActionButton()
	for _, v in ipairs(rabs) do
		if _G[v]:GetAlpha()<1 then
			_G[v]:Show()
			R:UIFrameFadeIn(_G[v], 0.5, _G[v]:GetAlpha(), 1)
		end
	end
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
	if event == "PLAYER_REGEN_ENABLED" and self.needPosition then
		self:UpdatePosition(GetActionBarToggles())
	end
end

function AB:EnableAutoHide()
	if RayUIStanceBar and AB.db.stancebarfade then table.insert(rabs, "RayUIStanceBar") end
	if RayUIPetBar and AB.db.petbarfade then table.insert(rabs, "RayUIPetBar") end
	if RayUIActionBar1 and AB.db.bar1fade then table.insert(rabs, "RayUIActionBar1") end
	if RayUIActionBar2 and AB.db.bar2fade then table.insert(rabs, "RayUIActionBar2") end
	if RayUIActionBar3 and AB.db.bar3fade then table.insert(rabs, "RayUIActionBar3") end
	if RayUIActionBar4 and AB.db.bar4fade then table.insert(rabs, "RayUIActionBar4") end
	if RayUIActionBar5 and AB.db.bar5fade then table.insert(rabs, "RayUIActionBar5") end

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

	-- function AB:Test()
		-- if StaticPopup1:IsShown() then
			-- FadeInActionButton()
		-- else
			-- FadeOutActionButton()
		-- end
	-- end

	-- AB:SecureHook(self, "ActivateBindMode", "Test")
end