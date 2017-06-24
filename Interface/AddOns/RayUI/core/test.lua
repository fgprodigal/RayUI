----------------------------------------------------------
-- Load RayUI Environment
----------------------------------------------------------
RayUI:LoadEnv()


local T = R:NewModule("Test", "AceEvent-3.0", "AceHook-3.0", "AceConsole-3.0", "AceTimer-3.0")

function T:Initialize()
end

R:RegisterModule(T:GetName())