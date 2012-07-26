local R, L, P = unpack(select(2, ...)) --Inport: Engine, Locales, ProfileDB
local CH = R:GetModule("Chat")

local colorneed, colorgreed, colorde = "|cff4dd6ff", "|cffffff00", "|cffff00ff"
local rollcolors, coloredwords = {[ROLL_DISENCHANT] = colorde, [GREED] = colorgreed, [NEED] = colorneed}, {}
for i,v in pairs(rollcolors) do coloredwords[i] = v..i end
CH.rolls = {}
frames = {}
local iszhTW = GetLocale() == "zhTW"

local function FindRoll(link, player, hasselected)
	for i,roll in ipairs(CH.rolls) do
		if roll._link == link and not roll._winner and (not roll[player] or hasselected) then return roll end
	end
	local newroll = {_link = link}
	table.insert(CH.rolls, newroll)
	return newroll
end

function FindFrame()
	wipe(frames)
	for i = 1, 7 do
		local name = "ChatFrame"..i
		for i,v in pairs(_G[name].messageTypeList) do
			if v == "LOOT" then
				frames[name] = true
			end
		end
	end
end

function CH:CHAT_MSG_LOOT(event, msg)
	FindFrame()
	local rolltype, rollval, link, player = msg:match(L["（(.+)%+职责加成）(%d+)点：(.+)（(.+)）"])
	if not player then
		rolltype, rollval, link, player = msg:match(L["（(.+)）(%d+)点：(.+)（(.+)）"])
		if iszhTW then link, player, rollval = rollval, link, player end
	end

	if player then
		local roll = FindRoll(link, player, true)
		roll[player] = {rolltype, rollcolors[rolltype]..rollval, select(2, UnitClass(player))}
		return
	end
	local player, selection, link = msg:match(L["(.+)选择了(.+)取向：(.+)"])
	if player and player ~= "" then
		player = player == YOU and UnitName("player") or player
		FindRoll(link, player)[player] = {selection, nil}
		return
	end

	local player, link = msg:match(L["(.*)赢得了：(.+)"])
	if player then
		player = player == YOU and UnitName("player") or player
		for i, roll in ipairs(CH.rolls) do
			if roll._link == link and roll[player] and not roll._printed then
				roll._printed = true
				roll._winner = player
				local rolltype = roll[roll._winner][1]
				local r, g, b = 1, 1, 1
				if roll[roll._winner][3] then
					r, g, b = RAID_CLASS_COLORS[roll[roll._winner][3]].r, RAID_CLASS_COLORS[roll[roll._winner][3]].g, RAID_CLASS_COLORS[roll[roll._winner][3]].b
				end
				local name, server = UnitName(player)
				if (server and server ~= "") then
					name = name.."-"..server
				end
				local msg = string.format(L["%s|HRayUILootCollector:%d|h[%s]|h|r %s 赢得了 %s "], rollcolors[rolltype], i, rolltype, "|Hplayer:"..(name or player).."|h["..R:RGBToHex(r, g, b)..player.."|r]|h", link)
					for cf in pairs(frames) do
						_G[cf]:AddMessage(msg)
					end
				return
			end
		end
		return
	end
end

function CH:RollFilter()
	if (GetLocale() ~= "zhCN" and GetLocale() ~= "zhTW") then return end
	self:RegisterEvent("CHAT_MSG_LOOT")
	ChatFrame_AddMessageEventFilter("CHAT_MSG_LOOT", function(self, event, msg)
		if msg:match(L["(.*)赢得了：(.+)"]) or msg:match(L["(.+)选择了(.+)取向：(.+)"]) or msg:match(L["（(.+)）(%d+)点：(.+)（(.+)）"]) or msg:match(L["（(.+)%+职责加成）(%d+)点：(.+)（(.+)）"])
			or msg:match(L["你放弃了："]) or msg:match(L["自动放弃了"]) or (msg:match(L["放弃了："]) and not msg:match(L["所有人都放弃了："])) then
			return true
		end
	end)
end