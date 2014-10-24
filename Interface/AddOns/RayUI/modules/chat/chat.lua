local R, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local CH = R:NewModule("Chat", "AceEvent-3.0", "AceHook-3.0", "AceTimer-3.0", "AceConsole-3.0")
CH.modName = L["聊天栏"]

local ChatHistoryEvent = CreateFrame("Frame")
local tokennum, matchTable = 1, {}
local currentLink
local lines = {}
local frame = nil
local editBox = nil
local isf = nil
local sizes = {
	":14:14",
	":16:16",
	":12:20",
	":14",
}

CH.LinkHoverShow = {
	["achievement"] = true,
	["enchant"]     = true,
	["glyph"]       = true,
	["item"]        = true,
	["quest"]       = true,
	["spell"]       = true,
	["talent"]      = true,
	["unit"]        = true,
}

local function GetTimeForSavedMessage()
	local randomTime = select(2, ("."):split(GetTime() or "0."..math.random(1, 999), 2)) or 0
	return time().."."..randomTime
end

local function GetColor(className, isLocal)
	if isLocal then
		local found
		for k,v in pairs(LOCALIZED_CLASS_NAMES_FEMALE) do
			if v == className then className = k found = true break end
		end
		if not found then
			for k,v in pairs(LOCALIZED_CLASS_NAMES_MALE) do
				if v == className then className = k break end
			end
		end
	end
	local tbl = R.colors.class[className]
	local color = ("%02x%02x%02x"):format(tbl.r*255, tbl.g*255, tbl.b*255)
	return color
end

local changeBNetName = function(misc, id, moreMisc, fakeName, tag, colon)
	local _, charName, _, _, _, _, _, englishClass = BNGetToonInfo(id)
	if englishClass and englishClass ~= "" then
		fakeName = "[|cFF"..GetColor(englishClass, true)..fakeName.."|r]"
	end
	return misc..id..moreMisc..fakeName..tag..(colon == ":" and ":" or colon)
end

function CH:GetColoredName(event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12)
	local chatType = strsub(event, 10)
	if ( strsub(chatType, 1, 7) == "WHISPER" ) then
		chatType = "WHISPER"
	end
	if ( strsub(chatType, 1, 7) == "CHANNEL" ) then
		chatType = "CHANNEL"..arg8
	end
	local info = ChatTypeInfo[chatType]

	--ambiguate guild chat names
	if (chatType == "GUILD") then
		arg2 = Ambiguate(arg2, "guild")
	else
		arg2 = Ambiguate(arg2, "none")
	end

	if ( info and info.colorNameByClass and arg12 ) then
		local localizedClass, englishClass, localizedRace, englishRace, sex = GetPlayerInfoByGUID(arg12)

		if ( englishClass ) then
			local classColorTable = R.colors.class[englishClass]
			if ( not classColorTable ) then
				return arg2
			end
			return string.format("\124cff%.2x%.2x%.2x", classColorTable.r*255, classColorTable.g*255, classColorTable.b*255)..arg2.."\124r"
		end
	end

	return arg2
end

local function CreatCopyFrame()
	local S = R:GetModule("Skins")
	frame = CreateFrame("Frame", "CopyFrame", UIParent)
	table.insert(UISpecialFrames, frame:GetName())
	S:SetBD(frame)
	frame:SetScale(1)
	frame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
	frame:Size(400,400)
	frame:Hide()
	frame:EnableMouse(true)
	frame:SetFrameStrata("DIALOG")

	local scrollArea = CreateFrame("ScrollFrame", "CopyScroll", frame, "UIPanelScrollFrameTemplate")
	scrollArea:Point("TOPLEFT", frame, "TOPLEFT", 8, -30)
	scrollArea:Point("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -30, 8)

	S:ReskinScroll(CopyScrollScrollBar)

	editBox = CreateFrame("EditBox", "CopyBox", frame)
	editBox:SetMultiLine(true)
	editBox:SetMaxLetters(99999)
	editBox:EnableMouse(true)
	editBox:SetAutoFocus(false)
	editBox:SetFontObject(ChatFontNormal)
	editBox:SetWidth(scrollArea:GetWidth())
	editBox:Height(200)
	editBox:SetScript("OnEscapePressed", function()
		frame:Hide()
	end)

	--EXTREME HACK..
	editBox:SetScript("OnTextSet", function(self)
		local text = self:GetText()

		for _, size in pairs(sizes) do
			if string.find(text, size) then
				self:SetText(string.gsub(text, size, ":12:12"))
			end
		end
	end)

	scrollArea:SetScrollChild(editBox)

	local close = CreateFrame("Button", "CopyCloseButton", frame, "UIPanelCloseButton")
	close:EnableMouse(true)
	close:SetScript("OnMouseUp", function()
		frame:Hide()
	end)

	S:ReskinClose(close)
	close:ClearAllPoints()
	close:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -7, -5)
	isf = true
end

local function GetLines(...)
	--[[		Grab all those lines		]]--
	local ct = 1
	for i = select("#", ...), 1, -1 do
		local region = select(i, ...)
		if region:GetObjectType() == "FontString" then
			lines[ct] = tostring(region:GetText())
			ct = ct + 1
		end
	end
	return ct - 1
end

local function Copy(cf)
	local _, size = cf:GetFont()
	FCF_SetChatWindowFontSize(cf, cf, 0.01)
	local lineCt = GetLines(cf:GetRegions())
	local text = table.concat(lines, "\n", 1, lineCt)
	FCF_SetChatWindowFontSize(cf, cf, size)
	if not isf then CreatCopyFrame() end
	if frame:IsShown() then frame:Hide() return end
	frame:Show()
	editBox:SetText(text)
end

local function ChatCopyButtons(id)
	local cf = _G[format("ChatFrame%d",  id)]
	local tab = _G[format("ChatFrame%dTab", id)]
	local name = FCF_GetChatWindowInfo(id)
	local point = GetChatWindowSavedPosition(id)
	local _, fontSize = FCF_GetChatWindowInfo(id)
	local button = _G[format("ButtonCF%d", id)]

	if not button then
		local button = CreateFrame("Button", format("ButtonCF%d", id), cf)
		button:Height(22)
		button:Width(20)
		button:SetAlpha(0)
		button:SetPoint("TOPRIGHT", 0, 0)
		button:SetTemplate("Default", true)

		local buttontex = button:CreateTexture(nil, "OVERLAY")
		buttontex:SetPoint("TOPLEFT", button, "TOPLEFT", 2, -2)
		buttontex:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -2, 2)
		buttontex:SetTexture([[Interface\AddOns\RayUI\media\copy.tga]])

		if id == 1 then
			button:SetScript("OnMouseUp", function(self, btn)
				if btn == "RightButton" then
					ToggleFrame(ChatMenu)
				else
					Copy(cf)
				end
			end)
		else
			button:SetScript("OnMouseUp", function(self, btn)
				Copy(cf)
			end)
		end

		button:SetScript("OnEnter", function()
			button:SetAlpha(1)
		end)
		button:SetScript("OnLeave", function() button:SetAlpha(0) end)
	end

end

function CH:GetOptions()
	local options = {
		width = {
			order = 5,
			name = L["长度"],
			type = "range",
			min = 300, max = 600, step = 1,
		},
		height = {
			order = 6,
			name = L["高度"],
			type = "range",
			min = 100, max = 300, step = 1,
		},
		spacer = {
			order = 7,
			name = " ",
			desc = " ",
			type = "description",
		},
		autohide = {
			order = 8,
			name = L["自动隐藏聊天栏"],
			desc = L["短时间内没有消息则自动隐藏聊天栏"],
			type = "toggle",
		},
		autohidetime = {
			order = 9,
			name = L["自动隐藏时间"],
			desc = L["设置多少秒没有新消息时隐藏"],
			type = "range",
			min = 5, max = 60, step = 1,
			disabled = function() return not self.db.autohide end,
		},
		autoshow = {
			order = 10,
			name = L["自动显示聊天栏"],
			desc = L["频道内有信消息则自动显示聊天栏，关闭后如有新密语会闪烁提示"],
			type = "toggle",
		},
	}
	return options
end

function CH:Info()
	return L["|cff7aa6d6Ray|r|cffff0000U|r|cff7aa6d6I|r聊天模块."]
end

function CH:EditBox_MouseOn()
	for i =1, #CHAT_FRAMES do
		local eb = _G["ChatFrame"..i.."EditBox"]
		local tab = _G["ChatFrame"..i.."Tab"]
		eb:EnableMouse(true)
		tab:EnableMouse(false)
	end
end

function  CH:EditBox_MouseOff()
	for i =1, #CHAT_FRAMES do
		local eb = _G["ChatFrame"..i.."EditBox"]
		local tab = _G["ChatFrame"..i.."Tab"]
		eb:EnableMouse(false)
		tab:EnableMouse(true)
	end
end

local tlds = {
	ONION = true,
	-- Copied from http://data.iana.org/TLD/tlds-alpha-by-domain.txt
	-- Version 2008041301, Last Updated Mon Apr 21 08:07:00 2008 UTC
	AC = true,
	AD = true,
	AE = true,
	AERO = true,
	AF = true,
	AG = true,
	AI = true,
	AL = true,
	AM = true,
	AN = true,
	AO = true,
	AQ = true,
	AR = true,
	ARPA = true,
	AS = true,
	ASIA = true,
	AT = true,
	AU = true,
	AW = true,
	AX = true,
	AZ = true,
	BA = true,
	BB = true,
	BD = true,
	BE = true,
	BF = true,
	BG = true,
	BH = true,
	BI = true,
	BIZ = true,
	BJ = true,
	BM = true,
	BN = true,
	BO = true,
	BR = true,
	BS = true,
	BT = true,
	BV = true,
	BW = true,
	BY = true,
	BZ = true,
	CA = true,
	CAT = true,
	CC = true,
	CD = true,
	CF = true,
	CG = true,
	CH = true,
	CI = true,
	CK = true,
	CL = true,
	CM = true,
	CN = true,
	CO = true,
	COM = true,
	COOP = true,
	CR = true,
	CU = true,
	CV = true,
	CX = true,
	CY = true,
	CZ = true,
	DE = true,
	DJ = true,
	DK = true,
	DM = true,
	DO = true,
	DZ = true,
	EC = true,
	EDU = true,
	EE = true,
	EG = true,
	ER = true,
	ES = true,
	ET = true,
	EU = true,
	FI = true,
	FJ = true,
	FK = true,
	FM = true,
	FO = true,
	FR = true,
	GA = true,
	GB = true,
	GD = true,
	GE = true,
	GF = true,
	GG = true,
	GH = true,
	GI = true,
	GL = true,
	GM = true,
	GN = true,
	GOV = true,
	GP = true,
	GQ = true,
	GR = true,
	GS = true,
	GT = true,
	GU = true,
	GW = true,
	GY = true,
	HK = true,
	HM = true,
	HN = true,
	HR = true,
	HT = true,
	HU = true,
	ID = true,
	IE = true,
	IL = true,
	IM = true,
	IN = true,
	INFO = true,
	INT = true,
	IO = true,
	IQ = true,
	IR = true,
	IS = true,
	IT = true,
	JE = true,
	JM = true,
	JO = true,
	JOBS = true,
	JP = true,
	KE = true,
	KG = true,
	KH = true,
	KI = true,
	KM = true,
	KN = true,
	KP = true,
	KR = true,
	KW = true,
	KY = true,
	KZ = true,
	LA = true,
	LB = true,
	LC = true,
	LI = true,
	LK = true,
	LR = true,
	LS = true,
	LT = true,
	LU = true,
	LV = true,
	LY = true,
	MA = true,
	MC = true,
	MD = true,
	ME = true,
	MG = true,
	MH = true,
	MIL = true,
	MK = true,
	ML = true,
	MM = true,
	MN = true,
	MO = true,
	MOBI = true,
	MP = true,
	MQ = true,
	MR = true,
	MS = true,
	MT = true,
	MU = true,
	MUSEUM = true,
	MV = true,
	MW = true,
	MX = true,
	MY = true,
	MZ = true,
	NA = true,
	NAME = true,
	NC = true,
	NE = true,
	NET = true,
	NF = true,
	NG = true,
	NI = true,
	NL = true,
	NO = true,
	NP = true,
	NR = true,
	NU = true,
	NZ = true,
	OM = true,
	ORG = true,
	PA = true,
	PE = true,
	PF = true,
	PG = true,
	PH = true,
	PK = true,
	PL = true,
	PM = true,
	PN = true,
	PR = true,
	PRO = true,
	PS = true,
	PT = true,
	PW = true,
	PY = true,
	QA = true,
	RE = true,
	RO = true,
	RS = true,
	RU = true,
	RW = true,
	SA = true,
	SB = true,
	SC = true,
	SD = true,
	SE = true,
	SG = true,
	SH = true,
	SI = true,
	SJ = true,
	SK = true,
	SL = true,
	SM = true,
	SN = true,
	SO = true,
	SR = true,
	ST = true,
	SU = true,
	SV = true,
	SY = true,
	SZ = true,
	TC = true,
	TD = true,
	TEL = true,
	TF = true,
	TG = true,
	TH = true,
	TJ = true,
	TK = true,
	TL = true,
	TM = true,
	TN = true,
	TO = true,
	TP = true,
	TR = true,
	TRAVEL = true,
	TT = true,
	TV = true,
	TW = true,
	TZ = true,
	UA = true,
	UG = true,
	UK = true,
	UM = true,
	US = true,
	UY = true,
	UZ = true,
	VA = true,
	VC = true,
	VE = true,
	VG = true,
	VI = true,
	VN = true,
	VU = true,
	WF = true,
	WS = true,
	YE = true,
	YT = true,
	YU = true,
	ZA = true,
	ZM = true,
	ZW = true,
}

local function RegisterMatch(text)
	local token = "\255\254\253"..tokennum.."\253\254\255"
	matchTable[token] = string.gsub(text, "%%", "%%%%")
	tokennum = tokennum + 1
	return token
end

local function Link(link, ...)
	if link == nil then
		return ""
	end
	return RegisterMatch(string.format("|cff8A9DDE|Hurl:%s|h[%s]|h|r", link, link))
end

local function Link_TLD(link, tld, ...)
	if link == nil or tld == nil then
		return ""
	end
	if tlds[tld:upper()] then
        return RegisterMatch(string.format("|cff8A9DDE|Hurl:%s|h[%s]|h|r", link, link))
    else
        return RegisterMatch(link)
    end
end

local patterns = {
		-- X://Y url
	{ pattern = "^(%a[%w%.+-]+://%S+)", matchfunc=Link},
	{ pattern = "%f[%S](%a[%w%.+-]+://%S+)", matchfunc=Link},
		-- www.X.Y url
	{ pattern = "^(www%.[-%w_%%]+%.%S+)", matchfunc=Link},
	{ pattern = "%f[%S](www%.[-%w_%%]+%.%S+)", matchfunc=Link},
		-- "W X"@Y.Z email (this is seriously a valid email)
	--{ pattern = "^(%"[^%"]+%"@[-%w_%%%.]+%.(%a%a+))", matchfunc=Link_TLD},
	--{ pattern = "%f[%S](%"[^%"]+%"@[-%w_%%%.]+%.(%a%a+))", matchfunc=Link_TLD},
		-- X@Y.Z email
	{ pattern = "(%S+@[-%w_%%%.]+%.(%a%a+))", matchfunc=Link_TLD},
		-- XXX.YYY.ZZZ.WWW:VVVV/UUUUU IPv4 address with port and path
	{ pattern = "^([0-2]?%d?%d%.[0-2]?%d?%d%.[0-2]?%d?%d%.[0-2]?%d?%d:[0-6]?%d?%d?%d?%d/%S+)", matchfunc=Link},
	{ pattern = "%f[%S]([0-2]?%d?%d%.[0-2]?%d?%d%.[0-2]?%d?%d%.[0-2]?%d?%d:[0-6]?%d?%d?%d?%d/%S+)", matchfunc=Link},
		-- XXX.YYY.ZZZ.WWW:VVVV IPv4 address with port (IP of ts server for example)
	{ pattern = "^([0-2]?%d?%d%.[0-2]?%d?%d%.[0-2]?%d?%d%.[0-2]?%d?%d:[0-6]?%d?%d?%d?%d)%f[%D]", matchfunc=Link},
	{ pattern = "%f[%S]([0-2]?%d?%d%.[0-2]?%d?%d%.[0-2]?%d?%d%.[0-2]?%d?%d:[0-6]?%d?%d?%d?%d)%f[%D]", matchfunc=Link},
		-- XXX.YYY.ZZZ.WWW/VVVVV IPv4 address with path
	{ pattern = "^([0-2]?%d?%d%.[0-2]?%d?%d%.[0-2]?%d?%d%.[0-2]?%d?%d%/%S+)", matchfunc=Link},
	{ pattern = "%f[%S]([0-2]?%d?%d%.[0-2]?%d?%d%.[0-2]?%d?%d%.[0-2]?%d?%d%/%S+)", matchfunc=Link},
		-- XXX.YYY.ZZZ.WWW IPv4 address
	{ pattern = "^([0-2]?%d?%d%.[0-2]?%d?%d%.[0-2]?%d?%d%.[0-2]?%d?%d%)%f[%D]", matchfunc=Link},
	{ pattern = "%f[%S]([0-2]?%d?%d%.[0-2]?%d?%d%.[0-2]?%d?%d%.[0-2]?%d?%d%)%f[%D]", matchfunc=Link},
		-- X.Y.Z:WWWW/VVVVV url with port and path
	{ pattern = "^([-%w_%%%.]+[-%w_%%]%.(%a%a+):[0-6]?%d?%d?%d?%d/%S+)", matchfunc=Link_TLD},
	{ pattern = "%f[%S]([-%w_%%%.]+[-%w_%%]%.(%a%a+):[0-6]?%d?%d?%d?%d/%S+)", matchfunc=Link_TLD},
		-- X.Y.Z:WWWW url with port (ts server for example)
	{ pattern = "^([-%w_%%%.]+[-%w_%%]%.(%a%a+):[0-6]?%d?%d?%d?%d)%f[%D]", matchfunc=Link_TLD},
	{ pattern = "%f[%S]([-%w_%%%.]+[-%w_%%]%.(%a%a+):[0-6]?%d?%d?%d?%d)%f[%D]", matchfunc=Link_TLD},
		-- X.Y.Z/WWWWW url with path
	{ pattern = "^([-%w_%%%.]+[-%w_%%]%.(%a%a+)/%S+)", matchfunc=Link_TLD},
	{ pattern = "%f[%S]([-%w_%%%.]+[-%w_%%]%.(%a%a+)/%S+)", matchfunc=Link_TLD},
		-- X.Y.Z url
	{ pattern = "^([-%w_%%%.]+[-%w_%%]%.(%a%a+))", matchfunc=Link_TLD},
	{ pattern = "%f[%S]([-%w_%%%.]+[-%w_%%]%.(%a%a+))", matchfunc=Link_TLD},
}

local function filterFunc(frame, event, msg, ...)
	if not msg then return false, msg, ... end
	for i, v in ipairs(patterns) do
		msg = string.gsub(msg, v.pattern, v.matchfunc)
	end
	for k,v in pairs(matchTable) do
		msg = string.gsub(msg, k, v)
		matchTable[k] = nil
	end
	return false, msg, ...
end

function CH:OnHyperlinkEnter(frame, linkData, link)
	local t = linkData:match("^(.-):")
	if CH.LinkHoverShow[t] then
		ShowUIPanel(GameTooltip)
		-- GameTooltip:SetOwner(UIParent, "ANCHOR_CURSOR")
		GameTooltip:SetOwner(ChatBG, "ANCHOR_TOPLEFT", 0, 80)
		GameTooltip:SetHyperlink(link)
		GameTooltip:Show()
	end
end

function CH:OnHyperlinkLeave(frame, linkData, link)
	local t = linkData:match("^(.-):")
	if CH.LinkHoverShow[t] then
		HideUIPanel(GameTooltip)
	end
end

function CH:OnMouseScroll(frame, dir)
    local bb = _G[frame:GetName().."ButtonFrameBottomButton"]
	if dir > 0 then
		if IsShiftKeyDown() then
			frame:ScrollToTop()
		elseif IsControlKeyDown() then
			--only need to scroll twice because of blizzards scroll
			frame:ScrollUp()
			frame:ScrollUp()
		end
	elseif dir < 0 then
		if IsShiftKeyDown() then
			frame:ScrollToBottom()
		elseif IsControlKeyDown() then
			--only need to scroll twice because of blizzards scroll
			frame:ScrollDown()
			frame:ScrollDown()
		end
	end
    if frame:AtBottom() then
        bb:Hide()
    else
        bb:Show()
    end
end

function CH:LinkHoverOnLoad()
	for i = 1, #CHAT_FRAMES do
		local cf = _G["ChatFrame"..i]
		self:HookScript(cf, "OnHyperlinkEnter", "OnHyperlinkEnter")
		self:HookScript(cf, "OnHyperlinkLeave", "OnHyperlinkLeave")
	end
end

local function nocase(s)
    s = string.gsub(s, "%a", function (c)
       return string.format("[%s%s]", string.lower(c),
                                          string.upper(c))
    end)
    return s
end

local function changeName(msgHeader, name, msgCnt, chatGroup, displayName, msgBody)
	if name ~= R.myname then
		msgBody = msgBody:gsub("("..nocase(R.myname)..")" , "|cffffff00>>|r|cffff0000%1|r|cffffff00<<|r")
	end
	return ("|Hplayer:%s%s%s|h[%s]|h%s"):format(name, msgCnt, chatGroup, displayName, msgBody)
end

function CH:AddMessage(text, ...)
	if text:find(INTERFACE_ACTION_BLOCKED) then return end
	if string.find(text, "EUI:.*") then return end
	if not text:find("BN_CONVERSATION") then
		text = text:gsub("|h%[(%d+)%. .-%]|h", "|h[%1]|h")
		-- text = text:gsub("%[(%d0?)%. .-%]", "[%1]") --custom channels
		-- text = text:gsub("CHANNEL:", "")
	end
	if text and type(text) == "string" then
		text = text:gsub("(|Hplayer:([^:]+)([:%d+]*)([:%w+]*)|h%[(.-)%]|h)(.-)$", changeName)
	end
	if CHAT_TIMESTAMP_FORMAT then
		local timeStamp = BetterDate(CHAT_TIMESTAMP_FORMAT, time()):gsub("%[([^]]*)%]","%%[%1%%]")
		text = text:gsub(timeStamp, "")
	end
	if CH.timeOverride then
		if CHAT_TIMESTAMP_FORMAT then
			text = ("|cffffffff|HTimeCopy|h|r%s|h%s"):format(BetterDate(CHAT_TIMESTAMP_FORMAT:gsub("64C2F5", "7F7F7F"), CH.timeOverride), text)
		else
			text = ("|cffffffff|HTimeCopy|h|r%s|h%s"):format(BetterDate("|cff7F7F7F[%H:%M]|r ", CH.timeOverride), text)
		end
		CH.timeOverride = nil
	else
		text = ("|cffffffff|HTimeCopy|h|r%s|h%s"):format(BetterDate(CHAT_TIMESTAMP_FORMAT or "|cff64C2F5[%H:%M]|r ", time()), text)
	end
	text = string.gsub(text, "%[(%d+)%. .-%]", "[%1]")
	text = string.gsub(text, "(%[|HBNplayer:%S-|k:)(%d-)(:%S-|h)%[(%S-)%](|?h?)(%]:?)", changeBNetName)
    text = string.gsub(text, "EUI", "ElvUI")
	return self.OldAddMessage(self, text, ...)
end

function CH:SetChatPosition()
	for i = 1, #CHAT_FRAMES do
		if _G["ChatFrame"..i] == COMBATLOG then
			_G["ChatFrame"..i]:ClearAllPoints()
			_G["ChatFrame"..i]:SetPoint("TOPLEFT", _G["ChatBG"], "TOPLEFT", 2,  -CombatLogQuickButtonFrame_Custom:GetHeight())
			_G["ChatFrame"..i]:SetPoint("BOTTOMRIGHT", _G["ChatBG"], "BOTTOMRIGHT", -2, 4)
		else
			_G["ChatFrame"..i]:ClearAllPoints()
			_G["ChatFrame"..i]:SetPoint("TOPLEFT", _G["ChatBG"], "TOPLEFT", 2, -2)
			_G["ChatFrame"..i]:SetPoint("BOTTOMRIGHT", _G["ChatBG"], "BOTTOMRIGHT", -2, 4)
		end
		FCF_SavePositionAndDimensions(_G["ChatFrame"..i])
		local _, _, _, _, _, _, shown, _, docked, _ = GetChatWindowInfo(i)
		if shown and not docked then
			FCF_DockFrame(_G["ChatFrame"..i])
		end
	end
end

local function updateFS(self, inc, flags, ...)
	local fstring = self:GetFontString()
		if (inc or self.ffl) then
			fstring:SetFont(R["media"].font, R["media"].fontsize+2, R["media"].fontflag)
		else
			fstring:SetFont(R["media"].font, R["media"].fontsize, R["media"].fontflag)
		end

		fstring:SetShadowOffset(1,-1)

	if(...) then
		fstring:SetTextColor(...)
	end

	if (inc or self.ffl) then
		fstring:SetTextColor(1,0,0)
	end

	local x = fstring:GetText()
	if x then
		fstring:SetText(x:upper())
	end
end

function CH:FaneifyTab(frame, sel)
	local i = frame:GetID()
	if(i == SELECTED_CHAT_FRAME:GetID()) then
		updateFS(frame,nil, nil, .5, 1, 1)
	else
		updateFS(frame,nil, nil, 1, 1, 1)
	end
end

function CH:FCF_StartAlertFlash(frame)
	local ID = frame:GetID()
	local tab = _G["ChatFrame" .. ID .. "Tab"]
	tab.ffl = true
	updateFS(tab, true, nil, 1,0,0)
end

function CH:FCF_StopAlertFlash(frame)
	_G["ChatFrame" .. frame:GetID() .. "Tab"].ffl = nil
end

function CH:FCF_Tab_OnClick(tab)
    local id = tab:GetID()
    local chatFrame = _G["ChatFrame"..id]
    local bb = _G["ChatFrame"..id.."ButtonFrameBottomButton"]

    if chatFrame:AtBottom() then
        bb:Hide()
    else
        bb:Show()
    end
end

function CH:ChatEdit_AddHistory(editBox, line)
	if line:find("/rl") then return; end

	if ( strlen(line) > 0 ) then
		for i, text in pairs(RayUICharacterData.ChatEditHistory) do
			if text == line then
				return
			end
		end

		table.insert(RayUICharacterData.ChatEditHistory, #RayUICharacterData.ChatEditHistory + 1, line)
		if #RayUICharacterData.ChatEditHistory > 15 then
			table.remove(RayUICharacterData.ChatEditHistory, 1)
		end
	end
end

function CH:SaveChatHistory(event, ...)
	local temp = {...}
	if #temp > 0 then
		temp[20] = event
		local timeForMessage = GetTimeForSavedMessage()
		RayUICharacterData.ChatHistory[timeForMessage] = temp

		local c, k = 0
		for id, data in pairs(RayUICharacterData.ChatHistory) do
			c = c + 1
			if (not k) or k > id then
				k = id
			end
		end

		if c > 128 then
			RayUICharacterData.ChatHistory[k] = nil
		end
	end
end

function CH:DisplayChatHistory()
	local temp, data = {}
	for id, _ in pairs(RayUICharacterData.ChatHistory) do
		table.insert(temp, tonumber(id))
	end

	table.sort(temp, function(a, b)
		return a < b
	end)

	for i = 1, #temp do
		data = RayUICharacterData.ChatHistory[tostring(temp[i])]
		if (time() - temp[i]) > 21600 then
			RayUICharacterData.ChatHistory[tostring(temp[i])] = nil
		else
			if type(data) == "table" and data[20] ~= nil then
				CH.timeOverride = temp[i]
				ChatFrame_MessageEventHandler(DEFAULT_CHAT_FRAME, data[20], data[1], data[2], data[3], data[4], data[5], data[6], data[7], data[8], data[9], data[10], data[11], data[12], data[13], data[14], data[15])
			end
		end
	end
end

function CH:ApplyStyle(event, ...)
	for _, frameName in pairs(CHAT_FRAMES) do
		local cf = _G[frameName]
        if not cf.styled then
            local tab = _G[frameName.."Tab"]
            local eb = _G[frameName.."EditBox"]
            local i = cf:GetID()

            cf:SetParent(ChatBG)
            local ebParts = {"Left", "Mid", "Right", "Middle"}
            for j = 1, #CHAT_FRAME_TEXTURES do
                _G[frameName..CHAT_FRAME_TEXTURES[j]]:SetTexture(nil)
            end
            for _, ebPart in ipairs(ebParts) do
                if _G[frameName.."EditBoxFocus"..ebPart] then
                    _G[frameName.."EditBoxFocus"..ebPart]:SetHeight(18)
                    _G[frameName.."EditBoxFocus"..ebPart]:SetTexture(nil)
                    _G[frameName.."EditBoxFocus"..ebPart].SetTexture = function() return end
                end
                if _G[frameName.."EditBox"..ebPart] then
                    _G[frameName.."EditBox"..ebPart]:SetTexture(nil)
                    _G[frameName.."EditBox"..ebPart].SetTexture = function() return end
                end
                if _G[frameName.."TabHighlight"..ebPart] then
                    _G[frameName.."TabHighlight"..ebPart]:SetTexture(nil)
                    _G[frameName.."TabHighlight"..ebPart].SetTexture = function() return end
                end
                if _G[frameName.."TabSelected"..ebPart] then
                    _G[frameName.."TabSelected"..ebPart]:SetTexture(nil)
                    _G[frameName.."TabSelected"..ebPart].SetTexture = function() return end
                end
                if _G[frameName.."Tab"..ebPart] then
                    _G[frameName.."Tab"..ebPart]:SetTexture(nil)
                    _G[frameName.."Tab"..ebPart].SetTexture = function() return end
                end
            end
            if not _G[frameName.."EditBoxBG"] then
                local chatebbg = CreateFrame("Frame", frameName.."EditBoxBG" , _G[frameName.."EditBox"])
                chatebbg:SetPoint("TOPLEFT", -2, -5)
                chatebbg:SetPoint("BOTTOMRIGHT", 2, 4)
                _G[frameName.."EditBoxLanguage"]:Kill()
            end
            ChatCopyButtons(i)
            if i ~= 2 then
                cf.OldAddMessage = cf.AddMessage
                cf.AddMessage = CH.AddMessage
            end

            _G[frameName.."ButtonFrame"]:Kill()
            tab:SetAlpha(0)
            tab.noMouseAlpha = 0
            cf:SetFading(false)
            cf:SetMinResize(0,0)
            cf:SetMaxResize(0,0)
            cf:SetClampedToScreen(false)
            cf:SetClampRectInsets(0,0,0,0)
            _G[frameName.."TabText"]:SetFont(R["media"].font, 13)
            local editbox = CreateFrame("Frame", nil, UIParent)
            editbox:Height(22)
            editbox:SetWidth(ChatBG:GetWidth())
            editbox:SetPoint("BOTTOMLEFT", cf, "TOPLEFT",  -2, 6)
            editbox:CreateShadow("Background")
            editbox:Hide()
            eb:SetAltArrowKeyMode(false)
            eb:ClearAllPoints()
            eb:Point("TOPLEFT", editbox, 2, 6)
            eb:Point("BOTTOMRIGHT", editbox, -2, -3)
            eb:SetParent(UIParent)
            eb:Hide()
            eb:HookScript("OnShow", function(self)
                editbox.wpos = 100
                editbox.wspeed = 600
                editbox.wlimit = ChatBG:GetWidth()
                editbox.wmod = 1
                editbox:SetScript("OnUpdate", R.simple_width)
                UIFrameFadeIn(editbox, .3, 0, 1)
            end)
            eb:HookScript("OnHide", function(self)
                editbox:Hide()
            end)
            hooksecurefunc("ChatEdit_UpdateHeader", function()
                local type = eb:GetAttribute("chatType")
                if ( type == "CHANNEL" ) then
                    local id = eb:GetAttribute("channelTarget")
                    if id == 0 then
                        editbox.border:SetBackdropBorderColor(unpack(R["media"].bordercolor))
                    else
                        editbox.border:SetBackdropBorderColor(ChatTypeInfo[type..id].r,ChatTypeInfo[type..id].g,ChatTypeInfo[type..id].b)
                    end
                else
                    editbox.border:SetBackdropBorderColor(ChatTypeInfo[type].r,ChatTypeInfo[type].g,ChatTypeInfo[type].b)
                end
            end)
            local function BottomButtonClick(self)
                self:GetParent():ScrollToBottom()
                self:Hide()
            end
            local bb = _G[frameName.."ButtonFrameBottomButton"]
            local flash = _G[frameName.."ButtonFrameBottomButtonFlash"]
            R:GetModule("Skins"):ReskinArrow(bb, "down")
            bb:SetParent(cf)
            bb:ClearAllPoints()
            bb:SetPoint("TOPRIGHT", cf, "TOPRIGHT", 0, -20)
            bb.SetPoint = R.dummy
            --flash:ClearAllPoints()
            --flash:Point("TOPLEFT", -3, 3)
            --flash:Point("BOTTOMRIGHT", 3, -3)
            bb:Hide()
            flash:Kill()
            bb:SetScript("OnClick", BottomButtonClick)
            local font, path = cf:GetFont()
            cf:SetFont(font, path, R["media"].fontflag)
            cf:SetShadowColor(0, 0, 0, 0)

			self:SecureHook(eb, "AddHistoryLine", "ChatEdit_AddHistory")
			for i, text in pairs(RayUICharacterData.ChatEditHistory) do
				eb:AddHistoryLine(text)
			end

            cf.styled = true
        end
	end
end

function CH:SetChat()
	local whisperFound
	for i = 1, #CHAT_FRAMES do
		local chatName, _, _, _, _, _, shown = FCF_GetChatWindowInfo(_G["ChatFrame"..i]:GetID())
		if chatName == WHISPER then
			if shown then
				whisperFound = true
			elseif not shown and not whisperFound  then
				_G["ChatFrame"..i]:Show()
				whisperFound = true
			end
		end
	end
	if not whisperFound then
		FCF_OpenNewWindow(WHISPER)
	end
	for i = 1, #CHAT_FRAMES do
		local frame = _G["ChatFrame"..i]
		FCF_SetChatWindowFontSize(nil, frame, 15)
		FCF_SetWindowAlpha(frame , 0)
		local chatName = FCF_GetChatWindowInfo(frame:GetID())
		if chatName == WHISPER then
			ChatFrame_RemoveAllMessageGroups(frame)
			ChatFrame_AddMessageGroup(frame, "WHISPER")
			ChatFrame_AddMessageGroup(frame, "BN_WHISPER")
		end
	end
    ChatFrame1:SetFrameLevel(8)
    FCF_SavePositionAndDimensions(ChatFrame1)
	FCF_SetLocked(ChatFrame1, 1)
	ChangeChatColor("CHANNEL1", 195/255, 230/255, 232/255)
	ChangeChatColor("CHANNEL2", 232/255, 158/255, 121/255)
	ChangeChatColor("CHANNEL3", 232/255, 228/255, 121/255)
	ToggleChatColorNamesByClassGroup(true, "SAY")
	ToggleChatColorNamesByClassGroup(true, "EMOTE")
	ToggleChatColorNamesByClassGroup(true, "YELL")
	ToggleChatColorNamesByClassGroup(true, "GUILD")
	ToggleChatColorNamesByClassGroup(true, "OFFICER")
	ToggleChatColorNamesByClassGroup(true, "GUILD_ACHIEVEMENT")
	ToggleChatColorNamesByClassGroup(true, "ACHIEVEMENT")
	ToggleChatColorNamesByClassGroup(true, "WHISPER")
	ToggleChatColorNamesByClassGroup(true, "PARTY")
	ToggleChatColorNamesByClassGroup(true, "PARTY_LEADER")
	ToggleChatColorNamesByClassGroup(true, "RAID")
	ToggleChatColorNamesByClassGroup(true, "RAID_LEADER")
	ToggleChatColorNamesByClassGroup(true, "RAID_WARNING")
	ToggleChatColorNamesByClassGroup(true, "INSTANCE_CHAT")
	ToggleChatColorNamesByClassGroup(true, "INSTANCE_CHAT_LEADER")
	ToggleChatColorNamesByClassGroup(true, "CHANNEL1")
	ToggleChatColorNamesByClassGroup(true, "CHANNEL2")
	ToggleChatColorNamesByClassGroup(true, "CHANNEL3")
	ToggleChatColorNamesByClassGroup(true, "CHANNEL4")
	ToggleChatColorNamesByClassGroup(true, "CHANNEL5")
	ToggleChatColorNamesByClassGroup(true, "CHANNEL6")
	ToggleChatColorNamesByClassGroup(true, "CHANNEL7")
	ToggleChatColorNamesByClassGroup(true, "CHANNEL8")
	ToggleChatColorNamesByClassGroup(true, "CHANNEL9")
	ToggleChatColorNamesByClassGroup(true, "CHANNEL10")
	ToggleChatColorNamesByClassGroup(true, "CHANNEL11")

	FCFDock_SelectWindow(GENERAL_CHAT_DOCK, ChatFrame1)
end

function CH:SetItemRef(link, text, button, chatFrame)
	local linkType, id = strsplit(":", link)
	if linkType == "TimeCopy" then
		frame = GetMouseFocus():GetParent()
		local text
		for i = 1, select("#", frame:GetRegions()) do
			local obj = select(i, frame:GetRegions())
			if obj:GetObjectType() == "FontString" and obj:IsMouseOver() then
				text = obj:GetText()
			end
		end
		text = text:gsub("|c%x%x%x%x%x%x%x%x(.-)|r", "%1")
		text = text:gsub("|H.-|h(.-)|h", "%1")
		local ChatFrameEditBox = ChatEdit_ChooseBoxForSend()
		if (not ChatFrameEditBox:IsShown()) then
			ChatEdit_ActivateChat(ChatFrameEditBox)
		end
		ChatFrameEditBox:SetText(text)
		ChatFrameEditBox:HighlightText()
	elseif linkType == "url" then
		currentLink = string.sub(link, 5)
		StaticPopup_Show("UrlCopyDialog")
	elseif linkType == "RayUIDamegeMeters" then
		local meterID = tonumber(id)
		ShowUIPanel(ItemRefTooltip)
		if not ItemRefTooltip:IsShown() then
			ItemRefTooltip:SetOwner(UIParent, "ANCHOR_PRESERVE")
		end
		ItemRefTooltip:ClearLines()
		ItemRefTooltip:AddLine(CH.meters[meterID].title)
		ItemRefTooltip:AddLine(string.format(L["发布者"]..": %s", CH.meters[meterID].source))
		for k, v in ipairs(CH.meters[meterID].data) do
			local left, right = v:match("^(.*)  (.*)$")
			if left and right then
				ItemRefTooltip:AddDoubleLine(left, right, 1, 1, 1, 1, 1, 1)
			else
				ItemRefTooltip:AddLine(v, 1, 1, 1)
			end
		end
		ItemRefTooltip:Show()
	else
		return self.hooks.SetItemRef(link, text, button)
	end
end

function CH:PET_BATTLE_CLOSE()
	for _, frameName in pairs(CHAT_FRAMES) do
		local frame = _G[frameName]
		if frame and _G[frameName.."Tab"]:GetText():match(PET_BATTLE_COMBAT_LOG) then
			FCF_Close(frame)
		end
	end
end

function CH:Initialize()
	if not RayUICharacterData.ChatEditHistory then
		RayUICharacterData.ChatEditHistory = {}
	end

	if not RayUICharacterData.ChatHistory then
		RayUICharacterData.ChatHistory = {}
	end

	ChatFrameMenuButton:Kill()
	ChatFrameMenuButton:SetScript("OnShow", kill)
	FriendsMicroButton:Hide()
	FriendsMicroButton:Kill()

	if not _G["ChatBG"] then
		local ChatBG = CreateFrame("Frame", "ChatBG", UIParent)
		ChatBG:CreatePanel("Default", self.db.width, self.db.height, "BOTTOMLEFT",UIParent,"BOTTOMLEFT",15,30)
		GeneralDockManager:SetParent(ChatBG)
	end

	CHAT_INSTANCE_CHAT_GET = "|Hchannel:INSTANCE|h".."[I]".."|h %s:\32"
	CHAT_INSTANCE_CHAT_LEADER_GET = "|Hchannel:INSTANCE|h".."[IL]".."|h %s:\32"
	--CHAT_BATTLEGROUND_GET = "|Hchannel:Battleground|h".."[BG]".."|h %s:\32"
	--CHAT_BATTLEGROUND_LEADER_GET = "|Hchannel:Battleground|h".."[BG]".."|h %s:\32"
	CHAT_BN_WHISPER_GET = "%s:\32"
	CHAT_GUILD_GET = "|Hchannel:Guild|h".."[G]".."|h %s:\32"
	CHAT_OFFICER_GET = "|Hchannel:o|h".."[O]".."|h %s:\32"
	CHAT_PARTY_GET = "|Hchannel:Party|h".."[P]".."|h %s:\32"
	CHAT_PARTY_GUIDE_GET = "|Hchannel:party|h".."[PL]".."|h %s:\32"
	CHAT_PARTY_LEADER_GET = "|Hchannel:party|h".."[PL]".."|h %s:\32"
	CHAT_RAID_GET = "|Hchannel:raid|h".."[R]".."|h %s:\32"
	CHAT_RAID_LEADER_GET = "|Hchannel:raid|h".."[RL]".."|h %s:\32"
	CHAT_RAID_WARNING_GET = "[RW]".." %s:\32"
	CHAT_SAY_GET = "%s:\32"
	CHAT_WHISPER_GET = "%s:\32"
	CHAT_YELL_GET = "%s:\32"
	ERR_FRIEND_ONLINE_SS = ERR_FRIEND_ONLINE_SS:gsub("%]%|h", "]|h|cff00ffff")
	ERR_FRIEND_OFFLINE_S = ERR_FRIEND_OFFLINE_S:gsub("%%s", "%%s|cffff0000")

	TIMESTAMP_FORMAT_HHMM = "|cff64C2F5[%I:%M]|r "
	TIMESTAMP_FORMAT_HHMMSS = "|cff64C2F5[%I:%M:%S]|r "
	TIMESTAMP_FORMAT_HHMMSS_24HR = "|cff64C2F5[%H:%M:%S]|r "
	TIMESTAMP_FORMAT_HHMMSS_AMPM = "|cff64C2F5[%I:%M:%S %p]|r "
	TIMESTAMP_FORMAT_HHMM_24HR = "|cff64C2F5[%H:%M]|r "
	TIMESTAMP_FORMAT_HHMM_AMPM = "|cff64C2F5[%I:%M %p]|r "

	CHAT_FRAME_TAB_NORMAL_NOMOUSE_ALPHA = 0
	CHAT_FRAME_TAB_SELECTED_NOMOUSE_ALPHA = 0

	ChatTypeInfo.EMOTE.sticky = 0
	ChatTypeInfo.YELL.sticky = 0
	ChatTypeInfo.RAID_WARNING.sticky = 1
	ChatTypeInfo.WHISPER.sticky = 0
	ChatTypeInfo.BN_WHISPER.sticky = 0

	ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL_JOIN", function(msg) return true end)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL_LEAVE", function(msg) return true end)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL_NOTICE", function(msg) return true end)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_AFK", function(msg) return true end)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_DND", function(msg) return true end)

	self:SecureHook("ChatFrame_OpenChat", "EditBox_MouseOn")
	self:SecureHook("ChatEdit_OnShow", "EditBox_MouseOn")
	self:SecureHook("ChatEdit_SendText", "EditBox_MouseOff")
	self:SecureHook("ChatEdit_OnHide", "EditBox_MouseOff")
	self:SecureHook("FloatingChatFrame_OnMouseScroll", "OnMouseScroll")
	self:SecureHook("FCFTab_UpdateColors", "FaneifyTab")
	self:SecureHook("FCF_StartAlertFlash")
	self:SecureHook("FCF_StopAlertFlash")
    self:SecureHook("FCF_Tab_OnClick")

	local events = {
		"CHAT_MSG_BATTLEGROUND", "CHAT_MSG_BATTLEGROUND_LEADER",
		"CHAT_MSG_CHANNEL", "CHAT_MSG_EMOTE",
		"CHAT_MSG_GUILD", "CHAT_MSG_OFFICER",
		"CHAT_MSG_PARTY", "CHAT_MSG_RAID",
		"CHAT_MSG_RAID_LEADER", "CHAT_MSG_RAID_WARNING", "CHAT_MSG_PARTY_LEADER",
		"CHAT_MSG_SAY", "CHAT_MSG_WHISPER","CHAT_MSG_BN_WHISPER",
		"CHAT_MSG_WHISPER_INFORM", "CHAT_MSG_YELL", "CHAT_MSG_BN_WHISPER_INFORM","CHAT_MSG_BN_CONVERSATION"
	}
	for _,event in ipairs(events) do
		ChatFrame_AddMessageEventFilter(event, filterFunc)
	end

	self:RegisterEvent("UPDATE_CHAT_WINDOWS", "ApplyStyle")
	self:RegisterEvent("UPDATE_FLOATING_CHAT_WINDOWS", "ApplyStyle")
    self:SecureHook("FCF_OpenTemporaryWindow", "ApplyStyle")
	self:RegisterEvent("PET_BATTLE_CLOSE")
	self:ApplyStyle()

	self:LinkHoverOnLoad()
	self:AutoHide()
	self:SpamFilter()
	self:DamageMeterFilter()
	self:EasyChannel()
    self:EnableDumpTool()
	self:ScheduleRepeatingTimer("SetChatPosition", 1)
	self:RawHook("SetItemRef", true)
	self:RawHook("GetColoredName", true)

	ChatHistoryEvent:RegisterEvent("CHAT_MSG_BATTLEGROUND")
	ChatHistoryEvent:RegisterEvent("CHAT_MSG_BATTLEGROUND_LEADER")
	ChatHistoryEvent:RegisterEvent("CHAT_MSG_BN_WHISPER")
	ChatHistoryEvent:RegisterEvent("CHAT_MSG_BN_WHISPER_INFORM")
	ChatHistoryEvent:RegisterEvent("CHAT_MSG_CHANNEL")
	ChatHistoryEvent:RegisterEvent("CHAT_MSG_EMOTE")
	ChatHistoryEvent:RegisterEvent("CHAT_MSG_GUILD")
	ChatHistoryEvent:RegisterEvent("CHAT_MSG_GUILD_ACHIEVEMENT")
	ChatHistoryEvent:RegisterEvent("CHAT_MSG_OFFICER")
	ChatHistoryEvent:RegisterEvent("CHAT_MSG_PARTY")
	ChatHistoryEvent:RegisterEvent("CHAT_MSG_PARTY_LEADER")
	ChatHistoryEvent:RegisterEvent("CHAT_MSG_RAID")
	ChatHistoryEvent:RegisterEvent("CHAT_MSG_RAID_LEADER")
	ChatHistoryEvent:RegisterEvent("CHAT_MSG_RAID_WARNING")
	ChatHistoryEvent:RegisterEvent("CHAT_MSG_SAY")
	ChatHistoryEvent:RegisterEvent("CHAT_MSG_WHISPER")
	ChatHistoryEvent:RegisterEvent("CHAT_MSG_WHISPER_INFORM")
	ChatHistoryEvent:RegisterEvent("CHAT_MSG_YELL")
    -- ChatHistoryEvent:RegisterEvent("PLAYER_LOGIN")
	ChatHistoryEvent:SetScript("OnEvent", function(self, event, ...)
        if event =="PLAYER_LOGIN" then
            ChatHistoryEvent:UnregisterEvent("PLAYER_LOGIN")
            CH:DisplayChatHistory()
        else
            CH:SaveChatHistory(event, ...)
        end
	end)
    CH:DisplayChatHistory()

	SetCVar("profanityFilter", 0)
	SetCVar("chatStyle", "classic")

	self:RegisterChatCommand("setchat", "SetChat")
end

StaticPopupDialogs["UrlCopyDialog"] = {
	text = L["URL Ctrl+C复制"],
	button2 = CLOSE,
	hasEditBox = 1,
	editBoxWidth = 400,
	OnShow = function(frame)
		local editBox = _G[frame:GetName().."EditBox"]
		if editBox then
			editBox:SetText(currentLink)
			editBox:SetFocus()
			editBox:HighlightText(0)
		end
		local button = _G[frame:GetName().."Button2"]
		if button then
			button:ClearAllPoints()
			button:SetWidth(200)
			button:SetPoint("CENTER", editBox, "CENTER", 0, -30)
		end
	end,
	EditBoxOnEscapePressed = function(frame) frame:GetParent():Hide() end,
	timeout = 0,
	whileDead = 1,
	hideOnEscape = 1,
	maxLetters=1024, -- this otherwise gets cached from other dialogs which caps it at 10..20..30...
}

R:RegisterModule(CH:GetName())
