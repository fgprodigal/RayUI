local R, L, P, G = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, GlobalDB
local IF = R:GetModule("InfoBar")

--Cache global variables
--Lua functions
local format = string.format
local floor = math.floor

--WoW API / Variables
local GetFramerate = GetFramerate

--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: FPS_FORMAT

local function FPS_OnUpdate(self)
    self:SetText(format(FPS_FORMAT, floor(GetFramerate())))
end

do -- Initialize
    local info = {}

    info.title = MOVIE_RECORDING_FRAMERATE
    info.icon = "Interface\\Icons\\SPELL_MAGIC_MANAGAIN"
    info.onUpdate = FPS_OnUpdate

    IF:RegisterInfoBarType("Framerate", info)
end
