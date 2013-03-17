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

-- Textures
local x = addon.engine
x.BLANK_ICON = "Interface\\AddOns\\" .. ADDON_NAME .. "\\media\\blank"
x.new = "\124TInterface\\OptionsFrame\\UI-OptionsFrame-NewFeatureIcon:0:0:0:-1\124t"

x.runeIcons = {

  [1] = "\124TInterface\\PlayerFrame\\UI-PlayerFrame-Deathknight-Blood:0:0:0:-1\124t";
  [2] = "\124TInterface\\PlayerFrame\\UI-PlayerFrame-Deathknight-Unholy:0:0:0:-1\124t";
  [3] = "\124TInterface\\PlayerFrame\\UI-PlayerFrame-Deathknight-Frost:0:0:0:-1\124t";
  [4] = "\124TInterface\\PlayerFrame\\UI-PlayerFrame-Deathknight-Death:0:0:0:-1\124t";
--[===[
  [1] = "\124TInterface\\PlayerFrame\\UI-PlayerFrame-DeathKnight-Blood-Off.tga:0:0:0:-1\124t",
	[2] = "\124TInterface\\PlayerFrame\\UI-PlayerFrame-DeathKnight-Death-Off.tga:0:0:0:-1\124t",
	[3] = "\124TInterface\\PlayerFrame\\UI-PlayerFrame-DeathKnight-Frost-Off.tga:0:0:0:-1\124t",
	[4] = "\124TInterface\\PlayerFrame\\UI-PlayerFrame-Deathknight-Chromatic-Off.tga:0:0:0:-1\124t",
  ]===]
}

  

-- Fonts
local LSM = LibStub("LibSharedMedia-3.0")
LSM:Register("font", "HOOGE (xCT)", [[Interface\AddOns\]] .. ADDON_NAME .. [[\media\HOOGE.TTF]], LSM.LOCALE_BIT_ruRU + LSM.LOCALE_BIT_western)
LSM:Register("font", "Homespun (xCT+)", [[Interface\AddOns\]] .. ADDON_NAME .. [[\media\homespun.ttf]], LSM.LOCALE_BIT_ruRU + LSM.LOCALE_BIT_western)


-- /run print(" \124TInterface\\Icons\\inv_gloves_mail_challengehunter_d_01:20:20:0:-1\124t")
-- /run print(" \124TInterface\\Icons\\gloves_mail_challengehunter_d_01:20:20:0:-1\124t")
-- /run print(" \124TInterface\\OptionsFrame\\UI-OptionsFrame-NewFeatureIcon:20:20:0:-1\124t")
-- /run print(" \124TInterface\\Icons\\inv_stave_2h_pvppandarias1_c_01:20:20:0:-1\124t")

if UnitName("PLAYER") == "Dandruff" or UnitName("PLAYER") == "Dandraffbal" then
  local settings = CreateFrame("FRAME")
  settings:RegisterEvent("PLAYER_ENTERING_WORLD")
  settings:SetScript("OnEvent", function(self, event, ...)
  
      -- Change Zone Font Text to something cooler :)
      PVPArenaTextString:SetFont([[Interface\AddOns\xCT+\media\homespun.ttf]], 30, "MONOCHROMEOUTLINE")
      PVPInfoTextString:SetFont([[Interface\AddOns\xCT+\media\homespun.ttf]], 10, "MONOCHROMEOUTLINE")
      ZoneTextString:SetFont([[Interface\AddOns\xCT+\media\homespun.ttf]], 30, "MONOCHROMEOUTLINE")
      SubZoneTextString:SetFont([[Interface\AddOns\xCT+\media\homespun.ttf]], 20, "MONOCHROMEOUTLINE")
      
      -- Change the Errors frame fonts to be cooolio!
      UIErrorsFrame:SetFont([[Interface\AddOns\xCT+\media\homespun.ttf]], 10, "MONOCHROMEOUTLINE")
      UIErrorsFrame:SetShadowColor(0, 0, 0, 0)
      
      -- Change the Raid Warning stuff
      RaidWarningFrameSlot1:SetFont([[Interface\AddOns\xCT+\media\homespun.ttf]], 20, "MONOCHROMEOUTLINE")
      RaidWarningFrameSlot1:SetShadowColor(0, 0, 0, 0)
      RaidWarningFrameSlot2:SetFont([[Interface\AddOns\xCT+\media\homespun.ttf]], 20, "MONOCHROMEOUTLINE")
      RaidWarningFrameSlot2:SetShadowColor(0, 0, 0, 0)
      
      -- Change the Raid Boss Emote stuff
      RaidBossEmoteFrameSlot1:SetFont([[Interface\AddOns\xCT+\media\homespun.ttf]], 20, "MONOCHROMEOUTLINE")
      RaidBossEmoteFrameSlot1:SetShadowColor(0, 0, 0, 0)
      RaidBossEmoteFrameSlot2:SetFont([[Interface\AddOns\xCT+\media\homespun.ttf]], 20, "MONOCHROMEOUTLINE")
      RaidBossEmoteFrameSlot2:SetShadowColor(0, 0, 0, 0)
      
      -- Unregister all this crap-ola
      self:UnregisterEvent("PLAYER_ENTERING_WORLD")
      self:SetScript("OnEvent", nil)
      self = nil
    end)
end