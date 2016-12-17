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
 [  ©2016. All Rights Reserved.        ]
 [====================================]]

-- No locals for NOOP
local noop = function() end

local AddonName, addon = ...
addon.engine = LibStub("AceAddon-3.0"):NewAddon(AddonName, "AceConsole-3.0")

xCT_Plus = addon.engine

-- No Operation
addon.noop = noop

-- Fixed in 5.4.2
-- Work around for http://us.battle.net/wow/en/forum/topic/10388639018
--[[hooksecurefunc("StaticPopup_Show", function(popup)
  if(popup == "ADDON_ACTION_FORBIDDEN") then
    StaticPopup_Hide(popup);
  end
end)]]
