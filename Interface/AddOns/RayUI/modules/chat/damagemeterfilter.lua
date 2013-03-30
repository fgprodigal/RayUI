local R, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local CH = R:GetModule("Chat")
-------------------------------------------------------------------------------
-- By Lockslap (US, Bleeding Hollow)
-- <Borderline Amazing>, http://ba-guild.com
-- Based on functionality provided by Prat and/or Chatter
-------------------------------------------------------------------------------

--[[ Module based on SpamageMeters by Wrug and Cybey ]]--

CH.meters = {}

local firstLines = {
	"^Recount - (.*)$", 									-- Recount
	"^Skada report on (.*) for (.*), (.*) to (.*):$",		-- Skada enUS
	"^Skada: Bericht für (.*) gegen (.*), (.*) bis (.*):$",	-- Skada deDE, might change in new Skada version
	"^Skada : (.*) pour (.*), de (.*) à (.*) :$",			-- Skada frFR
	"^(.*) - (.*)의 Skada 보고, (.*) ~ (.*):$",				-- Skada koKR
	"^Skada战斗报告：(.*)的(.*), (.*)到(.*):$",					-- Skada zhCN, might change in new Skada version
	"^Skada:(.*)來自(.*)，(.*) - (.*):$",					-- Skada zhTW, might change in new Skada version
	"^Skada: (.*) for (.*), (.*) - (.*):$",					-- Better Skada support player details
	"^(.*) Done for (.*)$"	,								-- TinyDPS
	"^Numeration: (.*) for (.*)$"  ,                        -- Numeration
	"^Numeration: (.*) - (.*)$"  ,                          -- Numeration
}
local nextLines = {
	"^(%d+). (.*)$",										-- Recount and Skada
	"^ (%d+). (.*)$", 										-- Skada, Numeration
	"^.*%%%)$", 											-- Skada player details
	"^Numeration: (.*)$",                                   -- Numeration
	"^[+-]%d+.%d",                                          -- Numeration Deathlog Details
	"^(%d+). (.*):(.*)(%d+)(.*)(%d+)%%(.*)%((%d+)%)$",		-- TinyDPS
}
local events = {
	"CHAT_MSG_CHANNEL",
	"CHAT_MSG_GUILD",
	"CHAT_MSG_OFFICER",
	"CHAT_MSG_PARTY",
	"CHAT_MSG_PARTY_LEADER",
	"CHAT_MSG_RAID",
	"CHAT_MSG_RAID_LEADER",
	"CHAT_MSG_SAY",
	"CHAT_MSG_WHISPER",
	"CHAT_MSG_YELL",
}

local function FilterLine(event, source, message, ...)
	local spam = false
	for k, v in ipairs(nextLines) do
		if message:match(v) then
			local curTime = time()
			for i, j in ipairs(CH.meters) do
				local elapsed = curTime - j.time
				if j.source == source and j.event == event and elapsed < 1 then
					local toInsert = true
					for a, b in ipairs(j.data) do
						if b == message then
							toInsert = false
						end
					end

					if toInsert then table.insert(j.data, message) end
					return true, false, nil
				end
			end
		end
	end

	for k, v in ipairs(firstLines) do
		local newID = 0
		if message:match(v) then
			local curTime = time()

			for i, j in ipairs(CH.meters) do
				local elapsed = curTime - j.time
				if j.source == source and j.event == event and elapsed < 1 then
					newID = i
					return true, true, string.format("|HRayUIDamegeMeters:%1$d|h|cFFFFFF00[%2$s]|r|h", newID or 0, message or "nil")
				end
			end

			table.insert(CH.meters, {
				source	= source,
				event	= event,
				time	= curTime,
				data	= {},
				title	= message
			})

			for i, j in ipairs(CH.meters) do
				if j.source == source and j.event == event and j.time == curTime then
					newID = i
				end
			end

			return true, true, string.format("|HRayUIDamegeMeters:%1$d|h|cFFFFFF00[%2$s]|r|h", newID or 0, message or "nil")
		end
	end
	return false, false, nil
end

local function ParseChatEvent(self, event, message, sender, ...)
	local hide = false
	for _, value in ipairs(events) do
		if event == value then
			local isRecount, isFirstLine, newMessage = FilterLine(event, sender, message)
			if isRecount then
				if isFirstLine then
					return false, newMessage, sender, ...
				else
					return true
				end
			end
		end
	end
end

function CH:DamageMeterFilter()
	for _, event in pairs(events) do
		ChatFrame_AddMessageEventFilter(event, ParseChatEvent)
	end
end
