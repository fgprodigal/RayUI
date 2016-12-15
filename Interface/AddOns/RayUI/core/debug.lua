local R, L, P, G = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, GlobalDB
local D = R:NewModule("Debug", "AceEvent-3.0", "AceHook-3.0", "AceConsole-3.0", "AceTimer-3.0")
local LTD = LibStub("LibTextDump-1.0-RayUI")

--Cache global variables
--Lua functions
local select, tostring = select, tostring

--WoW API / Variables

--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: RayUIDebug

local debugger = {}
local function CreateDebugFrame(mod)
    if debugger[mod] then
        return
    end
    local function save(buffer)
        RayUIDebug[mod] = buffer
    end
    debugger[mod] = LTD:New(("%s Debug Output"):format(mod), 640, 473, save)
    debugger[mod].numDuped = 1
    debugger[mod].prevLine = ""
    return debugger[mod]
end

local function Debug(mod, ...)
    mod = mod.GetName and mod:GetName() or mod
    local modDebug = debugger[mod]
    if not modDebug then
        modDebug = CreateDebugFrame(mod)
    end
    local text = ""
    for i = 1, select("#", ...) do
        local arg = select(i, ...)
        if i > 1 then
            text = text .. ", " .. tostring(arg)
        else
            text = tostring(arg)
        end
    end
    if modDebug.prevLine == text then
        modDebug.numDuped = modDebug.numDuped + 1
    else
        if modDebug.numDuped > 1 then
            modDebug:AddLine(("^^ Repeated %d times ^^"):format(modDebug.numDuped))
            modDebug.numDuped = 1
        end
        modDebug:AddLine(text, "%H:%M:%S")
        modDebug.prevLine = text
    end
end

local function DisplayDebug(mod)
    mod = mod.GetName and mod:GetName() or mod
    if not debugger[mod] then return end
    debugger[mod]:Display()
end

function D:Initialize()
    RayUIDebug = {}
    for i = 1, #R["RegisteredModules"] do
        local module = R:GetModule(R["RegisteredModules"][i])
        module.Debug = Debug
        module.DisplayDebug = DisplayDebug
    end
end

R:RegisterModule(D:GetName())
