local R, L, P = unpack(select(2, ...)) --Inport: Engine, Locales, ProfileDB
local CH = R:GetModule("Chat")

function CH:ChatEdit_CustomTabPressed(self)
    if strsub(tostring(self:GetText()), 1, 1) == "/" then return end

    if  (self:GetAttribute("chatType") == "SAY")  then
        if (GetNumSubgroupMembers()>0) then
            self:SetAttribute("chatType", "PARTY")
            ChatEdit_UpdateHeader(self)
        elseif (GetNumGroupMembers()>0) then
            self:SetAttribute("chatType", "RAID")
            ChatEdit_UpdateHeader(self)
        elseif (GetNumBattlefieldScores()>0) then
            self:SetAttribute("chatType", "BATTLEGROUND")
            ChatEdit_UpdateHeader(self)
        elseif (IsInGuild()) then
            self:SetAttribute("chatType", "GUILD")
            ChatEdit_UpdateHeader(self)
        else
            return
        end
    elseif (self:GetAttribute("chatType") == "PARTY") then
        if (GetNumGroupMembers()>0 and IsInRaid()) then
            self:SetAttribute("chatType", "RAID")
            ChatEdit_UpdateHeader(self)
        elseif (GetNumBattlefieldScores()>0) then
            self:SetAttribute("chatType", "BATTLEGROUND")
            ChatEdit_UpdateHeader(self)
        elseif (IsInGuild()) then
            self:SetAttribute("chatType", "GUILD")
            ChatEdit_UpdateHeader(self)
        else
            self:SetAttribute("chatType", "SAY")
            ChatEdit_UpdateHeader(self)
        end         
    elseif (self:GetAttribute("chatType") == "RAID") then
        if (GetNumBattlefieldScores()>0) then
            self:SetAttribute("chatType", "BATTLEGROUND")
            ChatEdit_UpdateHeader(self)
        elseif (IsInGuild()) then
            self:SetAttribute("chatType", "GUILD")
            ChatEdit_UpdateHeader(self)
        else
            self:SetAttribute("chatType", "SAY")
            ChatEdit_UpdateHeader(self)
        end
    elseif (self:GetAttribute("chatType") == "BATTLEGROUND") then
        if (IsInGuild) then
            self:SetAttribute("chatType", "GUILD")
            ChatEdit_UpdateHeader(self)
        else
            self:SetAttribute("chatType", "SAY")
            ChatEdit_UpdateHeader(self)
        end
    elseif (self:GetAttribute("chatType") == "GUILD") then
        self:SetAttribute("chatType", "SAY")
        ChatEdit_UpdateHeader(self)
    elseif (self:GetAttribute("chatType") ~= "WHISPER" and self:GetAttribute("chatType") ~= "BN_WHISPER") then
        self:SetAttribute("chatType", "SAY")
        ChatEdit_UpdateHeader(self)
    end
end

function CH:EasyChannel()
	self:RawHook("ChatEdit_CustomTabPressed", true)
end
