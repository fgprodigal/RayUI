local R, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local CH = R:GetModule("Chat")

----------------------------------------------------------------------------------
-- 屏蔽关键字
----------------------------------------------------------------------------------
local SpamList = {
	"蛋糕",
	"淘寶",
	"旺旺",
	"皇冠",
	"牛肉",
	"月餅",
	"季餅",
	"手工",
	"皇冠",
}

----------------------------------------------------------------------------------
-- 交易频道过滤
----------------------------------------------------------------------------------
local function TRADE_FILTER(self, event, arg1, arg2)
	if (SpamList and SpamList[1]) then
		for i, SpamList in pairs(SpamList) do
			if arg2 == UnitName("player") then return end
			if (arg1:find(SpamList)) then
				return true
			end
		end
	end
end

function CH:SpamFilter()
	ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", TRADE_FILTER)
end