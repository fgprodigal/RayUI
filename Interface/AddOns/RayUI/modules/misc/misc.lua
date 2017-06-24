----------------------------------------------------------
-- Load RayUI Environment
----------------------------------------------------------
RayUI:LoadEnv("Misc")


local M = R:NewModule("Misc", "AceEvent-3.0", "AceTimer-3.0")

M.modName = L["小玩意儿"]
_Misc = M

_Modules = {}

function M:RegisterMiscModule(name)
    table.insert(_Modules, name)
end

function M:Initialize()
    local errList, errText = {}, ""
    for _, name in pairs(_Modules) do
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
