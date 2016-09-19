local R, L, P, G = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, GlobalDB, GlobalDB
local IF = R:GetModule("InfoBar")

local function FPS_OnUpdate(self)
	self:SetText(format(FPS_FORMAT, math.floor(GetFramerate())))
end

do	-- Initialize
	local info = {}
	
	info.title = MOVIE_RECORDING_FRAMERATE
	info.icon = "Interface\\Icons\\SPELL_MAGIC_MANAGAIN"
	info.onUpdate = FPS_OnUpdate
	
	IF:RegisterInfoBarType("Framerate", info)
end