local R, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local B = R:GetModule("Blizzards")

function B:StaticPopup_Show(which, text_arg1, text_arg2, data)
	if which == "DEATH" and not UnitIsDead("player") then 
      StaticPopup_Hide("DEATH") 
   end 
end

function B:FixDeathPopup()
	self:SecureHook("StaticPopup_Show")
end