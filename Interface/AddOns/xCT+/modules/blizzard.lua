--[[   ____    ______      
      /\  _`\ /\__  _\   __
 __  _\ \ \/\_\/_/\ \/ /_\ \___ 
/\ \/'\\ \ \/_/_ \ \ \/\___  __\
\/>  </ \ \ \L\ \ \ \ \/__/\_\_/
 /\_/\_\ \ \____/  \ \_\  \/_/
 \//\/_/  \/___/    \/_/
 
 [=====================================]
 [  Author: Dandruff @ Whisperwind-US  ]
 [  xCT+ Version 3.x.x                 ]
 [  ©2012. All Rights Reserved.        ]
 [====================================]]

local ADDON_NAME, addon = ...
local x = addon.engine

local LSM = LibStub("LibSharedMedia-3.0");

-- Intercept Messages Sent by other Add-Ons that use CombatText_AddMessage
hooksecurefunc('CombatText_AddMessage', function(message, scrollFunction, r, g, b, displayType, isStaggered)
  local lastEntry = COMBAT_TEXT_TO_ANIMATE[ #COMBAT_TEXT_TO_ANIMATE ]
  CombatText_RemoveMessage(lastEntry)
  x:AddMessage("general", message, {r, g, b})
end)

-- Move the options up
local defaultFont, defaultSize = InterfaceOptionsCombatTextPanelTargetEffectsText:GetFont()

-- Show Combat Options Title
local fsTitle = InterfaceOptionsCombatTextPanel:CreateFontString(nil, "OVERLAY")
fsTitle:SetTextColor(1.00, 1.00, 1.00, 1.00)
fsTitle:SetFont(defaultFont, defaultSize)
fsTitle:SetText("|cff60A0FFPowered By |cffFF0000x|r|cff80F000CT|r+|r")
--fsTitle:SetPoint("TOPLEFT", 16, -90)
fsTitle:SetPoint("TOPLEFT", 180, -16)

-- Move the Effects and Floating Options
--[[InterfaceOptionsCombatTextPanelTargetEffects:ClearAllPoints()
InterfaceOptionsCombatTextPanelTargetEffects:SetPoint("TOPLEFT", 314, -132)
InterfaceOptionsCombatTextPanelEnableFCT:ClearAllPoints()
InterfaceOptionsCombatTextPanelEnableFCT:SetPoint("TOPLEFT", 18, -132)

InterfaceOptionsCombatTextPanelTargetDamage:ClearAllPoints()
InterfaceOptionsCombatTextPanelTargetDamage:SetPoint("TOPLEFT", 18, -355) ]]


-- Hide Blizzard Combat Text Toggles
InterfaceOptionsCombatTextPanelEnableFCT:Hide()
InterfaceOptionsCombatTextPanelTargetEffects:Hide()
InterfaceOptionsCombatTextPanelOtherTargetEffects:Hide()
InterfaceOptionsCombatTextPanelDodgeParryMiss:Hide()
InterfaceOptionsCombatTextPanelDamageReduction:Hide()
InterfaceOptionsCombatTextPanelRepChanges:Hide()
InterfaceOptionsCombatTextPanelReactiveAbilities:Hide()
InterfaceOptionsCombatTextPanelFriendlyHealerNames:Hide()
InterfaceOptionsCombatTextPanelCombatState:Hide()
InterfaceOptionsCombatTextPanelComboPoints:Hide()
InterfaceOptionsCombatTextPanelLowManaHealth:Hide()
InterfaceOptionsCombatTextPanelEnergyGains:Hide()
InterfaceOptionsCombatTextPanelPeriodicEnergyGains:Hide()
InterfaceOptionsCombatTextPanelHonorGains:Hide()
InterfaceOptionsCombatTextPanelAuras:Hide()

-- Direction does NOT work with xCT+ at all
InterfaceOptionsCombatTextPanelFCTDropDown:Hide()

-- FCT Options
InterfaceOptionsCombatTextPanelTargetDamage:Hide()
InterfaceOptionsCombatTextPanelPeriodicDamage:Hide()
InterfaceOptionsCombatTextPanelPetDamage:Hide()
InterfaceOptionsCombatTextPanelHealing:Hide()


function x:UpdateBlizzardFCT()
  if self.db.profile.blizzardFCT.enabled then
    DAMAGE_TEXT_FONT = LSM:Fetch("font", self.db.profile.blizzardFCT.font)
    
    -- Not working
    --COMBAT_TEXT_HEIGHT = self.db.profile.blizzardFCT.fontSize
    --CombatTextFont:SetFont(self.db.profile.blizzardFCT.font, self.db.profile.blizzardFCT.fontSize, self.db.profile.blizzardFCT.fontOutline)
  end
end

-- Turn off Blizzard's Combat Text
CombatText:UnregisterAllEvents()
CombatText:SetScript("OnLoad", nil)
CombatText:SetScript("OnEvent", nil)
CombatText:SetScript("OnUpdate", nil)


-- Create a button to delete profiles
if not xCTCombatTextConfigButton then
  CreateFrame("Button", "xCTCombatTextConfigButton", InterfaceOptionsCombatTextPanel, "UIPanelButtonTemplate")
end

xCTCombatTextConfigButton:ClearAllPoints()
xCTCombatTextConfigButton:SetPoint("TOPRIGHT", -36, -80)
xCTCombatTextConfigButton:SetSize(200, 30)
xCTCombatTextConfigButton:SetText("|cffFFFFFFGo to the |r|cffFF0000x|r|cff80F000CT|r|cff60A0FF+|r |cffFFFFFFOptions Panel...|r")
xCTCombatTextConfigButton:Show()
xCTCombatTextConfigButton:SetScript("OnClick", function(self)
  InterfaceOptionsFrameOkay:Click()
  LibStub("AceConfigDialog-3.0"):Open(ADDON_NAME)
end)

-- Interface - Addons (Ace3 Blizzard Options)
x.blizzardOptions = {
  name = "|cffFFFF00Combat Text - |r|cff60A0FFPowered By |cffFF0000x|r|cff80F000CT|r+|r",
  handler = x,
  type = 'group',
  args = {
    showConfig = {
      order = 1,
      type = 'execute',
      name = "Show Config",
      func = function() InterfaceOptionsFrameOkay:Click(); LibStub("AceConfigDialog-3.0"):Open(ADDON_NAME); GameMenuButtonContinue:Click() end,
    },
  },
}
