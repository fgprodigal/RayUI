local R, L, P, G = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, GlobalDB
local IF = R:GetModule("InfoBar")

--Cache global variables
--Lua functions
local string, table = string, table
local tostring = tostring
local gcinfo = gcinfo
local collectgarbage = collectgarbage
local tinsert = table.insert

--WoW API / Variables
local ResetCPUUsage = ResetCPUUsage
local UpdateAddOnMemoryUsage = UpdateAddOnMemoryUsage
local GetNumAddOns = GetNumAddOns
local IsAddOnLoaded = IsAddOnLoaded
local GetAddOnMemoryUsage = GetAddOnMemoryUsage
local GetAddOnInfo = GetAddOnInfo

--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: GameTooltip

local AddOnMemory = {}

local MemoryColor = {
    [1] = "007FFF", -- Light Blue (0-100 KB)
    [2] = "00FF00", -- Green (0.1-1 MB)
    [3] = "FFFF00", -- Yellow (1 - 2,5 MB)
    [4] = "FF7F00", -- Orange (2.5 - 5 MB)
    [5] = "FF0000", -- Red (5+ MB)
    [6] = "FFFFFF", -- White (ignored)
}

local function GetIndex(value,ignore)
    local index;

    if ignore then
        index = 6
    elseif value <= 100 then
        index = 1
    elseif value <= 1024 then
        index = 2
    elseif value <= 2560 then
        index = 3
    elseif value <= 5120 then
        index = 4
    elseif value > 5120 then
        index = 5
    end

    return index
end

local function GetFormattedMemory(value,ignore)
    local memory, suffix;
    local code = MemoryColor[GetIndex(value,ignore)]

    if value < 1024 then
        suffix = "KB"
        memory = string.format("%.0f",value)
    else
        suffix = "MB"
        memory = string.format("%.2f",value / 1024)
    end

    return tostring("|cFF"..code..memory.."|r "..suffix)
end

local function Memory_OnClick(self)
    UpdateAddOnMemoryUsage()
    local before = gcinfo()
    collectgarbage("collect")
    ResetCPUUsage()
    UpdateAddOnMemoryUsage()
    R:Print(L["共释放内存"], GetFormattedMemory(before - gcinfo()))
end

local function Memory_OnUpdate(self)
    if InCombatLockdown() then return end
    local memory = 0

    UpdateAddOnMemoryUsage()

    for i = 1, GetNumAddOns() do
        if IsAddOnLoaded(i) then
            memory = memory + GetAddOnMemoryUsage(i)
        end
    end

    self:SetText(GetFormattedMemory(memory,true))
end

local function Memory_OnEnter(self)
    GameTooltip:SetOwner(self, "ANCHOR_TOP")
    GameTooltip:AddLine(L["总内存使用"],1,1,1)
    GameTooltip:SetPrevLineJustify("CENTER")
    GameTooltip:AddDivider()

    UpdateAddOnMemoryUsage()

    AddOnMemory = {}

    local maxMemory = gcinfo()
    local addOnMemory, numDiv = 0, 0

    -- Collect AddOn-Info
    for i = 1, GetNumAddOns(), 1 do
        if IsAddOnLoaded(i) then
            local memory = GetAddOnMemoryUsage(i)
            local addOn, name = GetAddOnInfo(i)

            addOnMemory = addOnMemory + memory

            tinsert(AddOnMemory,{name,memory})
        end
    end

    table.sort(AddOnMemory, function(a,b) return a[2] > b[2] end)

    -- Setup AddOn-Info after sorting
    for i = 1, #AddOnMemory do
        local name, memory = AddOnMemory[i][1],AddOnMemory[i][2]
        local divIndex = GetIndex(memory)

        if i == 1 then
            numDiv = divIndex
        elseif i > 1 and numDiv > divIndex then
            GameTooltip:AddDivider()
            numDiv = numDiv - 1
        end

        GameTooltip:AddDoubleLine(name,GetFormattedMemory(memory),1,1,1,1,1,1)
    end

    GameTooltip:Show()
    self:SetText(GetFormattedMemory(addOnMemory,true))
end

do -- Initialize
    local info = {}

    info.title = L["总内存使用"]
    info.icon = "Interface\\Icons\\inv_gizmo_khoriumpowercore"
    info.clickFunc = Memory_OnClick
    info.onUpdate = Memory_OnUpdate
    info.interval = 10
    info.tooltipFunc = Memory_OnEnter

    IF:RegisterInfoBarType("Memory", info)
end
