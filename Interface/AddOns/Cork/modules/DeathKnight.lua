local myname, Cork = ...
if Cork.MYCLASS ~= "DEATHKNIGHT" then return end


-- Presence
Cork:GenerateAdvancedSelfBuffer("Presence", {48263, 48266, 48265})


-- Bone Shield
local spellname, _, icon = GetSpellInfo(49222)
Cork:GenerateSelfBuffer(spellname, icon)


-- Path of Frost
local spellname, _, icon = GetSpellInfo(3714)
Cork:GenerateSelfBuffer(spellname, icon)


-- Horn of Winter
local spellname, _, icon = GetSpellInfo(57330)
local str_earth = GetSpellInfo(58646) -- Strength of Earth
Cork:GenerateSelfBuffer(spellname, icon, str_earth)
