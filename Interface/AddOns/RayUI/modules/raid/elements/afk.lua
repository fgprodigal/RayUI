local R, L, P = unpack(select(2, ...)) --Inport: Engine, Locales, ProfileDB
local RA = R:GetModule("Raid")

local oUF = RayUF or oUF

local GetTime = GetTime
local floor = floor
local timer = {}

local AfkTime = function(s)
    local minute = 60
    local min = floor(s/minute)
    local sec = floor(s-(min*minute))
    if sec < 10 then sec = "0"..sec end
    if min < 10 then min = "0"..min end
    return min..":"..sec
end

oUF.Tags.Methods['RayUIRaid:afk'] = function(u)
    local name = UnitName(u)
    if(RA.db.afk and (UnitIsAFK(u) or not UnitIsConnected(u))) then
        if not timer[name] then
            timer[name] = GetTime()
        end
        local time = (GetTime()-timer[name])

        return AfkTime(time)
    elseif timer[name] then
        timer[name] = nil
    end
end
oUF.Tags.Events['RayUIRaid:afk'] = 'PLAYER_FLAGS_CHANGED UNIT_CONNECTION'

local Enable = function(self)
    if not self.freebAfk then return end
    local afktext = self.Health:CreateFontString(nil, "OVERLAY")
    afktext:SetPoint("TOP")
    afktext:SetShadowOffset(1.25, -1.25)
    afktext:SetFont(R["media"].font, R["media"].fontsize - 2, R["media"].fontflag)
    afktext:SetWidth(RA.db.width)
    afktext.frequentUpdates = 1
    self:Tag(afktext, "[RayUIRaid:afk]")
    self.AFKtext = afktext
end

oUF:AddElement('freebAfk', nil, Enable, nil)
