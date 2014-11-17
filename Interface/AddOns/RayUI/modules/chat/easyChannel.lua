local R, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local CH = R:GetModule("Chat")

local cycles = {
	{
        chatType = "SAY",   --SAY
        use = function(self, editbox) return 1 end,
	},
--[[     {
        chatType = "YELL",  --大喊
        use = function(self, editbox) return 1 end,
    }, ]]
    {
        chatType = "PARTY",  --小队
        use = function(self, editbox) return IsInGroup() end,
    },
    {
        chatType = "RAID",  --团队
        use = function(self, editbox) return IsInRaid() end,
    },
    {
        chatType = "INSTANCE_CHAT",  --副本
        use = function(self, editbox) return select(2, IsInInstance()) == 'pvp' end,
    },
    {
        chatType = "GUILD",   --工会
        use = function(self, editbox) return IsInGuild() end,
    },
--[[     {
        chatType = "CHANNEL",
        use = function(self, editbox, currChatType)
            if currChatType~="CHANNEL" then
                currNum = IsShiftKeyDown() and 21 or 0
            else
                currNum = editbox:GetAttribute("channelTarget");
            end
            local h, r, step = currNum+1, 20, 1
            if IsShiftKeyDown() then h, r, step = currNum-1, 1, -1 end
            for i=h,r,step do
                local channelNum, channelName = GetChannelName(i);
                if channelNum > 0 and not channelName:find("本地防务 %-") and not channelName:find("本地防務 %-") and not channelName:find("LFGForwarder") and not channelName:find("TCForwarder") then
                    editbox:SetAttribute("channelTarget", i);
                    return true;
                end
            end
        end,
    }, ]]
    {
        chatType = "SAY",
        use = function(self, editbox) return 1 end,
    },
}

function CH:ChatEdit_CustomTabPressed(self)
    if not R.global.Tutorial.tabchannel then
        RayUITabChannelTutorial:Hide()
        R.global.Tutorial.tabchannel = true
    end
	if strsub(tostring(self:GetText()), 1, 1) == "/" then return end
    local currChatType = self:GetAttribute("chatType")
    for i, curr in ipairs(cycles) do
        if curr.chatType== currChatType then
            local h, r, step = i+1, #cycles, 1
            if IsShiftKeyDown() then h, r, step = i-1, 1, -1 end
            if currChatType=="CHANNEL" then h = i end --频道仍然要测试一下
            for j=h, r, step do
                if cycles[j]:use(self, currChatType) then
                    self:SetAttribute("chatType", cycles[j].chatType);
                    ChatEdit_UpdateHeader(self);
                    return;
                end
            end
        end
    end
end

function CH:EasyChannel()
	self:RawHook("ChatEdit_CustomTabPressed", true)
end
