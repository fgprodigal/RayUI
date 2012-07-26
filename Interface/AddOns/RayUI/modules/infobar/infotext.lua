local R, L, P = unpack(select(2, ...)) --Inport: Engine, Locales, ProfileDB
local IF = R:GetModule("InfoBar")

IF.InfoTextModules = {}

function IF:RegisterInfoText(name, func)
	IF.InfoTextModules[name] = func
end

function IF:LoadInfoText()
	for name, func in pairs(self.InfoTextModules) do
		func()
	end
end