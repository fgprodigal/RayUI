----------------------------------------------------------
-- Load RayUI Environment
----------------------------------------------------------
RayUI:LoadEnv("Misc")


local M = _Misc
local mod = M:NewModule("AutoInvite", "AceEvent-3.0")


local hideStatic = false
function mod:AutoAcceptInvite(event, leaderName)
    if not M.db.autoAcceptInvite then return end

    if event == "PARTY_INVITE_REQUEST" then
        if QueueStatusMinimapButton:IsShown() then return end
        if IsInGroup() then return end
        hideStatic = true

        -- Update Guild and Friendlist
        if GetNumFriends() > 0 then ShowFriends() end
        if IsInGuild() then GuildRoster() end
        local inGroup = false

        for friendIndex = 1, GetNumFriends() do
            local friendName = GetFriendInfo(friendIndex)
            if friendName == leaderName then
                AcceptGroup()
                inGroup = true
                break
            end
        end

        if not inGroup then
            for guildIndex = 1, GetNumGuildMembers() do
                local guildMemberName = GetGuildRosterInfo(guildIndex)
                guildMemberName = guildMemberName:match("(.+)%-.+") or guildMemberName
                if guildMemberName == leaderName then
                    AcceptGroup()
                    inGroup = true
                    break
                end
            end
        end

        if not inGroup then
            for bnIndex = 1, BNGetNumFriends() do
                local _, _, _, _, name = BNGetFriendInfo(bnIndex)
                leaderName = leaderName:match("(.+)%-.+") or leaderName
                if name == leaderName then
                    AcceptGroup()
                    break
                end
            end
        end
    elseif event == "GROUP_ROSTER_UPDATE" and hideStatic == true then
        StaticPopup_Hide("PARTY_INVITE")
        StaticPopup_Hide("PARTY_INVITE_XREALM")
        hideStatic = false
    end
end

function mod:AutoInvite(event, arg1, arg2, ...)
    if not M.db.autoInvite then return end
    local keywords = {string.split(" ", M.db.autoInviteKeywords)}
    if (not IsInGroup() or UnitIsGroupLeader("player") or UnitIsGroupAssistant("player")) then
        for _, keyword in pairs(keywords) do
            if keyword == arg1:lower() then
                if event == "CHAT_MSG_WHISPER" then
                    InviteUnit(arg2)
                elseif event == "CHAT_MSG_BN_WHISPER" then
                    local _, toonName, _, realmName = BNGetGameAccountInfo(select(11, ...))
                    InviteUnit(toonName.."-"..realmName)
                end
                return
            end
        end
    end
end

function mod:Initialize()
    self:RegisterEvent("PARTY_INVITE_REQUEST", "AutoAcceptInvite")
    self:RegisterEvent("GROUP_ROSTER_UPDATE", "AutoAcceptInvite")
    self:RegisterEvent("CHAT_MSG_WHISPER", "AutoInvite")
    self:RegisterEvent("CHAT_MSG_BN_WHISPER", "AutoInvite")
end

M:RegisterMiscModule(mod:GetName())
