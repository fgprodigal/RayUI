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

-- Shorten my handle
local x = addon.engine

x.colors = {
  damage = {.75,.1,.1},
  damage_crit = {1,.1,.1},
  spell_damage = {.75,.3,.85},
  spell_damage_crit = {.75,.3,.85},
  heal = {.1,.75,.1},
  heal_crit = {.1,1,.1},
  heal_peri = {.1,.5,.1},
  heal_out = {.1,.65,.1},
  heal_out_crit = {.1,1,.1},
  spell_cast = {1,.82,0},
  misstype_generic = {.5,.5,.5},
  resist_generic = {.75,.5,.5},
  resist_spell = {.5,.3,.5},
  aura_start = {1,.5,.5},
  aura_end = {.5,.5,.5},
  aura_start_harm = {1,.1,.1},
  honor = {.1,.1,1},
  faction_sub = {1,.1,.1},
  spell_reactive = {1,.82,0},
  low_health = {1,.1,.1},
  low_mana = {1,.1,.1},
  combat_begin = {1,.1,.1},
  combat_end = {.1,1,.1},
  
  -- outgoing
  out_damage = {1,.82,0},
  out_damage_crit = {1,1,0},
  out_misstype = {.5,.5,.5},
  dispell_buff = {0,1,.5},
  dispell_debuff = {1,0,.5},
  spell_interrupt = {1,.5,0},
  spell_stolen = {.9,0,.9},
  party_kill = {.2,1,.2},
  
  combo_points = {1,.82,0},
  combo_points_max = {0,.82,1},
}

x.damagecolor = {
  [1]  = {  1,  1,  0 },  -- physical
  [2]  = {  1, .9, .5 },  -- holy
  [4]  = {  1, .5,  0 },  -- fire
  [8]  = { .3,  1, .3 },  -- nature
  [16] = { .5,  1,  1 },  -- frost
  [32] = { .5, .5,  1 },  -- shadow
  [64] = {  1, .5,  1 },  -- arcane
}

x.runecolors = {
	[1] = {1, 0, 0},      -- Blood
	[2] = {0, 0.5, 0},    -- Unholy
	[3] = {0, 1, 1},      -- Frost
	[4] = {0.8, 0.1, 1},  -- Death
}
