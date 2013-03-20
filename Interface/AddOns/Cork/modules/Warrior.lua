
local myname, Cork = ...
if Cork.MYCLASS ~= "WARRIOR" then return end


-- Battle Shout
local shout = Cork:GenerateAdvancedSelfBuffer("Shouts", {6673, 469}, true)
