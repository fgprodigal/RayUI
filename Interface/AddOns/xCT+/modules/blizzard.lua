--[[   ____    ______
      /\  _`\ /\__  _\   __
 __  _\ \ \/\_\/_/\ \/ /_\ \___
/\ \/'\\ \ \/_/_ \ \ \/\___  __\
\/>  </ \ \ \L\ \ \ \ \/__/\_\_/
 /\_/\_\ \ \____/  \ \_\  \/_/
 \//\/_/  \/___/    \/_/

 [=====================================]
 [  Author: Dandraffbal-Stormreaver US ]
 [  xCT+ Version 4.x.x                 ]
 [  ©2015. All Rights Reserved.        ]
 [====================================]]

-- Dont do anything for Legion
local build = select(4, GetBuildInfo())
if build >= 70000 then return end


-- TODO: Fix this up

local ADDON_NAME, addon = ...
local x = addon.engine

local LSM = LibStub("LibSharedMedia-3.0");

-- Intercept Messages Sent by other Add-Ons that use CombatText_AddMessage
hooksecurefunc('CombatText_AddMessage', function(message, scrollFunction, r, g, b, displayType, isStaggered)
  local lastEntry = COMBAT_TEXT_TO_ANIMATE[ #COMBAT_TEXT_TO_ANIMATE ]
  CombatText_RemoveMessage(lastEntry)
  x:AddMessage("general", message, {r, g, b})
end)

hooksecurefunc(InterfaceOptionsCombatTextPanel, 'refresh', function(...)
  -- @see InterfaceOptionsPanel_Refresh
  local self = InterfaceOptionsCombatTextPanel
  for _, control in pairs(self.controls) do
    if control.type == CONTROLTYPE_DROPDOWN then
      UIDropDownMenu_DisableDropDown(control)
    else
      control:Disable()
    end
  end
end)

local fsTitle, configButton
InterfaceOptionsCombatTextPanel:HookScript('OnShow', function(self)
  if not fsTitle then
    -- Show Combat Options Title
    fsTitle = self:CreateFontString(nil, "OVERLAY")
    fsTitle:SetTextColor(1.00, 1.00, 1.00, 1.00)
    fsTitle:SetFontObject(GameFontHighlightLeft)
    fsTitle:SetText("|cff60A0FFPowered By |cffFF0000x|r|cff80F000CT|r+|r")
    --fsTitle:SetPoint("TOPLEFT", 16, -90)
    fsTitle:SetPoint("TOPLEFT", 480, -16)
  end

  if not configButton then
    -- Create a button to delete profiles
    configButton = CreateFrame("Button", nil, self, "UIPanelButtonTemplate")
    configButton:ClearAllPoints()
    configButton:SetPoint("TOPRIGHT", -36, -80)
    configButton:SetSize(200, 30)
    configButton:SetText("|cffFFFFFFOpen |r|cffFF0000x|r|cff80F000CT|r|cff60A0FF+|r |cffFFFFFFOptions...|r")
    configButton:Show()
    configButton:SetScript("OnClick", function(self)
      InterfaceOptionsFrame_OnHide()
      HideUIPanel(GameMenuFrame)
      --LibStub("AceConfigDialog-3.0"):Open(ADDON_NAME)
      x:ShowConfigTool()
    end)
  end
end)

function x:UpdateBlizzardFCT()
  if self.db.profile.blizzardFCT.enabled then
    DAMAGE_TEXT_FONT = self.db.profile.blizzardFCT.fontName

    -- Not working
		--  LSM:Fetch("font", self.db.profile.blizzardFCT.font)
    --COMBAT_TEXT_HEIGHT = self.db.profile.blizzardFCT.fontSize
    --CombatTextFont:SetFont(self.db.profile.blizzardFCT.font, self.db.profile.blizzardFCT.fontSize, self.db.profile.blizzardFCT.fontOutline)
  end
end

-- Turn off Blizzard's Combat Text
CombatText:UnregisterAllEvents()
CombatText:SetScript("OnLoad", nil)
CombatText:SetScript("OnEvent", nil)
CombatText:SetScript("OnUpdate", nil)

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
      func = function() InterfaceOptionsFrame_OnHide(); HideUIPanel(GameMenuFrame); x:ShowConfigTool() end,
    },
  },
}
