local R, L, P, G = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, GlobalDB
local M = R:GetModule("Misc")
local mod = M:NewModule("AutoRelease", "AceEvent-3.0")

--Cache global variables
--Lua functions
--WoW API / Variables
local GetSpellInfo = GetSpellInfo
local UnitBuff = UnitBuff
local GetBattlefieldStatus = GetBattlefieldStatus
local RepopMe = RepopMe

function mod:PLAYER_DEAD()
    if not M.db.autorelease then return end
    local soulstone = GetSpellInfo(20707)
    if ((R.myclass ~= "SHAMAN") and not (soulstone and UnitBuff("player", soulstone))) then
        for i=1,5 do
            local status = GetBattlefieldStatus(i)
            if status == "active" then
                RepopMe()
                break
            end
        end
    end
end

function mod:Initialize()
    self:RegisterEvent("PLAYER_DEAD")
end

M:RegisterMiscModule(mod:GetName())
