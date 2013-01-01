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
fsTitle:SetTextColor(1.00, 0.82, 0.00, 1.00)
fsTitle:SetFont(defaultFont, defaultSize + 6)
fsTitle:SetText("xCT+ Combat Text Options")
fsTitle:SetPoint("TOPLEFT", 16, -90)

-- Move the Effects and Floating Options
InterfaceOptionsCombatTextPanelTargetEffects:ClearAllPoints()
InterfaceOptionsCombatTextPanelTargetEffects:SetPoint("TOPLEFT", 314, -132)
InterfaceOptionsCombatTextPanelEnableFCT:ClearAllPoints()
InterfaceOptionsCombatTextPanelEnableFCT:SetPoint("TOPLEFT", 18, -132)

InterfaceOptionsCombatTextPanelTargetDamage:ClearAllPoints()
InterfaceOptionsCombatTextPanelTargetDamage:SetPoint("TOPLEFT", 18, -355)

local initCVars = true
local lastState = false

-- Hide invalid Objects
function x:UpdateHeadNumbers()
  if initCVars then
    lastState = self.db.profile.blizzardFCT.blizzardHeadNumbers
    SetCVar("CombatLogPeriodicSpells", self.db.profile.blizzardFCT.vars["CombatLogPeriodicSpells"])
    SetCVar("PetMeleeDamage", self.db.profile.blizzardFCT.vars["PetMeleeDamage"])
    SetCVar("CombatDamage", self.db.profile.blizzardFCT.vars["CombatDamage"])
    SetCVar("CombatHealing", self.db.profile.blizzardFCT.vars["CombatHealing"])
    
    initCVars = false
  end

  -- Always hide or show interface objects
  if self.db.profile.blizzardFCT.blizzardHeadNumbers then
    InterfaceOptionsCombatTextPanelTargetDamage:Show()
    InterfaceOptionsCombatTextPanelPeriodicDamage:Show()
    InterfaceOptionsCombatTextPanelPetDamage:Show()
    InterfaceOptionsCombatTextPanelHealing:Show()
  else
    InterfaceOptionsCombatTextPanelTargetDamage:Hide()
    InterfaceOptionsCombatTextPanelPeriodicDamage:Hide()
    InterfaceOptionsCombatTextPanelPetDamage:Hide()
    InterfaceOptionsCombatTextPanelHealing:Hide()
  end

  -- Update if current state does not equal last state
  local update = (self.db.profile.blizzardFCT.blizzardHeadNumbers ~= lastState)
  
  if update then
    if self.db.profile.blizzardFCT.blizzardHeadNumbers then
      SetCVar("CombatLogPeriodicSpells", self.db.profile.blizzardFCT.vars["CombatLogPeriodicSpells"])
      SetCVar("PetMeleeDamage", self.db.profile.blizzardFCT.vars["PetMeleeDamage"])
      SetCVar("CombatDamage", self.db.profile.blizzardFCT.vars["CombatDamage"])
      SetCVar("CombatHealing", self.db.profile.blizzardFCT.vars["CombatHealing"])
    else
      -- backup cVars
      self.db.profile.blizzardFCT.vars["CombatLogPeriodicSpells"] = GetCVar("CombatLogPeriodicSpells")
      self.db.profile.blizzardFCT.vars["PetMeleeDamage"] = GetCVar("PetMeleeDamage")
      self.db.profile.blizzardFCT.vars["CombatDamage"] = GetCVar("CombatDamage")
      self.db.profile.blizzardFCT.vars["CombatHealing"] = GetCVar("CombatHealing")
      
      SetCVar("CombatLogPeriodicSpells", 0)
      SetCVar("PetMeleeDamage", 0)
      SetCVar("CombatDamage", 0)
      SetCVar("CombatHealing", 0)
    end
    
    -- our new state
    lastState = self.db.profile.blizzardFCT.blizzardHeadNumbers
  end
end

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

-- Direction does NOT work with xCT+ at all
InterfaceOptionsCombatTextPanelFCTDropDown:Hide()


-- Create a button to delete profiles
if not xCTCombatTextConfigButton then
  CreateFrame("Button", "xCTCombatTextConfigButton", InterfaceOptionsCombatTextPanel, "UIPanelButtonTemplate")
end

xCTCombatTextConfigButton:ClearAllPoints()
xCTCombatTextConfigButton:SetPoint("BOTTOMRIGHT", -18, 18)
xCTCombatTextConfigButton:SetSize(180, 26)
xCTCombatTextConfigButton:SetText("|cffFFFFFFMore |r|cffFF0000x|r|cffFFFFFFCT+ Options...|r")
xCTCombatTextConfigButton:Show()
xCTCombatTextConfigButton:SetScript("OnClick", function(self)
  --if not x.configuring then
    InterfaceOptionsFrameOkay:Click()
    LibStub("AceConfigDialog-3.0"):Open(ADDON_NAME)
  --end
end)

x.blizzardOptions = {
  name = "|cffFF0000x|rCT+ - e|cffFF0000X|rtreme Combat Text",
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
