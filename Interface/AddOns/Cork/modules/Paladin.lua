
local myname, Cork = ...
if Cork.MYCLASS ~= "PALADIN" then return end


-- Seals
Cork:GenerateAdvancedSelfBuffer("Seal", {20154, 20165, 31801, 20164}, false, true)


-- Righteous Fury
local spellname, _, icon = GetSpellInfo(25780)
Cork:GenerateSelfBuffer(spellname, icon)


-- Beacon of Light
local spellname, _, icon = GetSpellInfo(53563)
local dataobj = Cork:GenerateLastBuffedBuffer(spellname, icon)
dataobj.partyonly = true
dataobj.ignoreplayer = true
