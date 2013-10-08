local modifier = "shift" -- shift, alt or ctrl
local mouseButton = "1" -- 1 = left, 2 = right, 3 = middle, 4 and 5 = thumb buttons if there are any
local waitforHook = {}
local FocuserButton

local function SetFocusHotkey(frame)
	if InCombatLockdown() then
		waitforHook[frame] = true
	else
		frame:SetAttribute(modifier.."-type"..mouseButton,"focus")
		waitforHook[frame] = nil
	end
end

local eventFrame = CreateFrame("Frame", nil)
eventFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
eventFrame:RegisterEvent("PLAYER_LOGIN")
eventFrame:SetScript("OnEvent", function(self, event)
	if not FocuserButton then
		-- Keybinding override so that models can be shift/alt/ctrl+clicked
		FocuserButton = CreateFrame("CheckButton", "FocuserButton", UIParent, "SecureActionButtonTemplate")
		FocuserButton:SetAttribute("type1","macro")
		FocuserButton:SetAttribute("macrotext","/focus mouseover")
		SetOverrideBindingClick(FocuserButton, true, modifier.."-BUTTON"..mouseButton, "FocuserButton")
	end
	if event=="PLAYER_LOGIN" then
		-- Set the keybindings on the default unit frames since we won't get any CreateFrame notification about them
		local duf = {
			PlayerFrame,
			PetFrame,
			PartyMemberFrame1,
			PartyMemberFrame2,
			PartyMemberFrame3,
			PartyMemberFrame4,
			PartyMemberFrame1PetFrame,
			PartyMemberFrame2PetFrame,
			PartyMemberFrame3PetFrame,
			PartyMemberFrame4PetFrame,
			TargetFrame,
		}

		for i,frame in pairs(duf) do
			SetFocusHotkey(frame)
		end
	else
		if not InCombatLockdown() then
			for frame in pairs(waitforHook) do
				SetFocusHotkey(frame)
			end
		end
	end
end)

local function CreateFrame_Hook(type, name, parent, template)
	if name and name.lower and (name:lower():find("rayuf") or name:lower():find("rayuiraid")) then
		SetFocusHotkey(_G[name])
	end
end

hooksecurefunc("CreateFrame", CreateFrame_Hook)