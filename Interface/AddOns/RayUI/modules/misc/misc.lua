----------------------------------------------------------
-- Load RayUI Environment
----------------------------------------------------------
_LoadRayUIEnv_()


local M = R:NewModule("Misc", "AceEvent-3.0", "AceTimer-3.0")

--Cache global variables
--Lua functions
local table, pairs, pcall = table, pairs, pcall

--WoW API / Variables

--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: RaidCDAnchor, RaidCDMover

M.modName = L["小玩意儿"]
local error=error
M.Modules = {}

function M:RegisterMiscModule(name)
    table.insert(M.Modules, name)
end

function M:Initialize()
    local errList, errText = {}, ""
    for _, name in pairs(self.Modules) do
        local module = self:GetModule(name, true)
        if module then
            M:Debug(1, "%s Initializing...", name)
            local _, catch = pcall(module.Initialize, module)
            R:ThrowError(catch)
        else
            table.insert(errList, name)
        end
    end
end

function M:Info()
    return L["|cff7aa6d6Ray|r|cffff0000U|r|cff7aa6d6I|r的各种实用便利小功能."]
end

R:RegisterModule(M:GetName())
