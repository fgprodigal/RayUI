local R, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local LSM = LibStub("LibSharedMedia-3.0")

SlashCmdList["RELOAD"] = function() ReloadUI() end
SLASH_RELOAD1 = "/rl"

R["RegisteredModules"] = {}
R.resolution           = GetCVar("gxResolution")
R.screenheight         = tonumber(string.match(R.resolution, "%d+x(%d+)"))
R.screenwidth          = tonumber(string.match(R.resolution, "(%d+)x+%d"))
R.mult                 = 1

R.HiddenFrame = CreateFrame("Frame")
R.HiddenFrame:Hide()

local AddonNotSupported = {}
local BlackList = {"bigfoot", "duowan", "163ui", "neavo", "sora"}
local demoFrame

local ItemUpgrade = setmetatable ({
	[1]   =  8, -- 1/1
	[373] =  4, -- 1/2
	[374] =  8, -- 2/2
	[375] =  4, -- 1/3
	[376] =  4, -- 2/3
	[377] =  4, -- 3/3
	[378] =  7, -- 1/1
	[379] =  4, -- 1/2
	[380] =  4, -- 2/2
	[445] =  0, -- 0/2
	[446] =  4, -- 1/2
	[447] =  8, -- 2/2
	[451] =  0, -- 0/1
	[452] =  8, -- 1/1
	[453] =  0, -- 0/2
	[454] =  4, -- 1/2
	[455] =  8, -- 2/2
	[456] =  0, -- 0/1
	[457] =  8, -- 1/1
	[458] =  0, -- 0/4
	[459] =  4, -- 1/4
	[460] =  8, -- 2/4
	[461] = 12, -- 3/4
	[462] = 16, -- 4/4
	[465] =  0, -- 0/2
	[466] =  4, -- 1/2
	[467] =  8, -- 2/2
	[468] =  0, -- 0/4
	[469] =  4, -- 1/4
	[470] =  8, -- 2/4
	[471] = 12, -- 3/4
	[472] = 16, -- 4/4
	[476] =  0, -- 0/2
	[477] =  4, -- 1/2
	[478] =  8, -- 2/2
	[479] =  0, -- 0/1
	[480] =  8, -- 1/1
	[491] =  0, -- 0/2
	[492] =  4, -- 1/2
	[493] =  8, -- 2/2
	[494] =  0, -- 0/4
	[495] =  4, -- 1/4
	[496] =  8, -- 2/4
	[497] = 12, -- 3/4
	[498] = 16, -- 4/4
	[504] = 12, -- thanks Dridzt
	[505] = 16,
	[506] = 20,
	[507] = 24,
},{__index=function() return 0 end})

function R.dummy()
	return
end

function R:UIScale()
	R.lowversion = false

	if R.screenwidth < 1600 then
		R.lowversion = true
	elseif R.screenwidth >= 3840 or (UIParent:GetWidth() + 1 > R.screenwidth) then
		local width = R.screenwidth
		local height = R.screenheight

		-- because some user enable bezel compensation, we need to find the real width of a single monitor.
		-- I don"t know how it really work, but i"m assuming they add pixel to width to compensate the bezel. :P

		-- HQ resolution
		if width >= 9840 then width = 3280 end                   	                -- WQSXGA
		if width >= 7680 and width < 9840 then width = 2560 end                     -- WQXGA
		if width >= 5760 and width < 7680 then width = 1920 end 	                -- WUXGA & HDTV
		if width >= 5040 and width < 5760 then width = 1680 end 	                -- WSXGA+

		-- adding height condition here to be sure it work with bezel compensation because WSXGA+ and UXGA/HD+ got approx same width
		if width >= 4800 and width < 5760 and height == 900 then width = 1600 end   -- UXGA & HD+

		-- low resolution screen
		if width >= 4320 and width < 4800 then width = 1440 end 	                -- WSXGA
		if width >= 4080 and width < 4320 then width = 1360 end 	                -- WXGA
		if width >= 3840 and width < 4080 then width = 1224 end 	                -- SXGA & SXGA (UVGA) & WXGA & HDTV

		if width < 1600 then
			R.lowversion = true
		end

		-- register a constant, we will need it later for launch.lua
		R.eyefinity = width
	end

	if R.lowversion == true then
		R.ResScale = 0.9
	else
		R.ResScale = 1
	end

	self.mult = 768/string.match(GetCVar("gxResolution"), "%d+x(%d+)")/self.global.general.uiscale
end

function R:Scale(x)
	return (self.mult*math.floor(x/self.mult+.5))
end

function R:RegisterModule(name)
	if self.initialized then
		self:GetModule(name):Initialize()
		tinsert(self["RegisteredModules"], name)
	else
		tinsert(self["RegisteredModules"], name)
	end
end

function R:TableIsEmpty(t)
	if type(t) ~= "table" then
		return true
	else
		return next(t) == nil
	end
end

function R:GetItemUpgradeLevel(iLink)
	if not iLink then
		return 0
	else
		local _, _, itemRarity, itemLevel, _, _, _, _, itemEquip = GetItemInfo(iLink)
		local code = string.match(iLink, ":(%d+):%d:%d|h")
		if not itemLevel then return 0 end
		return itemLevel + ItemUpgrade[tonumber(code)]
	end
end

local function CreateWarningFrame()
	for index in pairs(AddonNotSupported) do
		R:Print(GetAddOnInfo(index))
	end
	local S = R:GetModule("Skins")
	local frame = CreateFrame("Frame", "RayUIWarningFrame", UIParent)
	S:SetBD(frame)
	frame:Size(400, 400)
	frame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
	frame:EnableMouse(true)
	frame:SetFrameStrata("DIALOG")

	local titile = frame:CreateFontString(nil, "OVERLAY")
	titile:Point("TOPLEFT", 0, -10)
	titile:Point("TOPRIGHT", 0, -10)
	titile:SetFont(R["media"].font, R["media"].fontsize + 2, R["media"].fontflag)
	titile:SetText("由於一些很複雜的原因, 關閉以下外掛程式後才能正常使用|cff7aa6d6Ray|r|cffff0000U|r|cff7aa6d6I|r:")

	local scrollArea = CreateFrame("ScrollFrame", "RayUIWarningFrameScroll", frame, "UIPanelScrollFrameTemplate")
	scrollArea:Point("TOPLEFT", frame, "TOPLEFT", 8, -40)
	scrollArea:Point("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -30, 50)

	S:ReskinScroll(RayUIWarningFrameScrollScrollBar)

	local messageFrame = CreateFrame("EditBox", nil, frame)
	messageFrame:SetFont(R["media"].font, R["media"].fontsize, R["media"].fontflag)
	messageFrame:EnableMouse(false)
	messageFrame:EnableKeyboard(false)
	messageFrame:SetMultiLine(true)
	messageFrame:SetMaxLetters(99999)
	messageFrame:Size(400, 400)

	scrollArea:SetScrollChild(messageFrame)

	for i in pairs(AddonNotSupported) do
		local name, title, notes, enabled, loadable, reason, security = GetAddOnInfo(i)
		messageFrame:SetText(messageFrame:GetText().."\n"..name)
	end

	local button1 = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
	button1:Size(150, 30)
	button1:Point("BOTTOMLEFT", 10, 10)
	S:Reskin(button1)
	button1:SetText("幫我關掉它們")
	button1:SetScript("OnClick", function()
		for i = 1, GetNumAddOns() do
			if AddonNotSupported[i] then
				DisableAddOn(i)
			end
		end
		ReloadUI()
	end)

	local button2 = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
	button2:Size(150, 30)
	button2:Point("BOTTOMRIGHT", -10, 10)
	S:Reskin(button2)
	button2:SetText("不，我需要它們")
	button2:SetScript("OnClick", function()
		for i = 1, GetNumAddOns() do
			if GetAddOnInfo(i) == "RayUI" then
				DisableAddOn(i)
			end
		end
		ReloadUI()
	end)
end

local function CheckAddon()
	for i = 1, GetNumAddOns() do
		local name, title, notes, enabled, loadable, reason, security = GetAddOnInfo(i)
		if enabled then
			for _, word in pairs(BlackList) do
				if (name and name:lower():find(word)) or (title and title:lower():find(word)) then
					AddonNotSupported[i] = true
				end
			end
		end
	end
	if R:TableIsEmpty(AddonNotSupported) then
		return false
	else
		CreateWarningFrame()
		return true
	end
end

function R:InitializeModules()
	if CheckAddon() then
		return
	else
		for i = 1, #self["RegisteredModules"] do
			local module = self:GetModule(self["RegisteredModules"][i])
			if (self.db[self["RegisteredModules"][i]] == nil or self.db[self["RegisteredModules"][i]].enable ~= false) and module.Initialize then
				local _, catch = pcall(module.Initialize, module)
				if catch and GetCVarBool("scriptErrors") == 1 then
					ScriptErrorsFrame_OnError(catch, false)
				end
			end
		end
	end
end

function R:PLAYER_ENTERING_WORLD()
	RequestTimePlayed()
	Advanced_UIScaleSlider:Kill()
	Advanced_UseUIScale:Kill()
	SetCVar("useUiScale", 1)
	SetCVar("uiScale", R.global.general.uiscale)
	DEFAULT_CHAT_FRAME:AddMessage("欢迎使用|cff7aa6d6Ray|r|cffff0000U|r|cff7aa6d6I|r(v"..R.version..")，插件发布网址: |cff8A9DDE[|Hurl:http://rayui.cn|hhttp://rayui.cn|h]|r")
	self:UnregisterEvent("PLAYER_ENTERING_WORLD" )

	local eventcount = 0
	local RayUIGarbageCollector = CreateFrame("Frame")
	RayUIGarbageCollector:RegisterAllEvents()
	RayUIGarbageCollector:SetScript("OnEvent", function(self, event, addon)
		eventcount = eventcount + 1
		if QuestDifficultyColors["trivial"].r ~= 0.50 then
			QuestDifficultyColors["trivial"].r = 0.50
			QuestDifficultyColors["trivial"].g = 0.50
			QuestDifficultyColors["trivial"].b = 0.50
			QuestDifficultyColors["trivial"].font = QuestDifficulty_Trivial
		end
		if InCombatLockdown() then return end

		if eventcount > 6000 then
			collectgarbage("collect")
			eventcount = 0
		end
	end)
	for k, v in self:IterateModules() do
		if v.OnLoadErrors then
			for _, errors in pairs(v.OnLoadErrors) do
				error(errors, 2)
			end
			wipe(v.OnLoadErrors)
		end
	end
end

function R:Initialize()
	self:LoadMovers()

	if not self.db.layoutchosen then
		self:ChooseLayout()
	end

	self:CheckRole()
	self:RegisterEvent("PLAYER_ENTERING_WORLD", "CheckRole")
	self:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED", "CheckRole")
	self:RegisterEvent("PLAYER_TALENT_UPDATE", "CheckRole")
	self:RegisterEvent("CHARACTER_POINTS_CHANGED", "CheckRole")
	self:RegisterEvent("UNIT_INVENTORY_CHANGED", "CheckRole")
	self:RegisterEvent("UPDATE_BONUS_ACTIONBAR", "CheckRole")
	self:RegisterEvent("UPDATE_SHAPESHIFT_FORM", "CheckRole")
	self:RegisterEvent("PLAYER_ENTERING_WORLD")
	self:Delay(5, function() collectgarbage("collect") end)

	local configButton = CreateFrame("Button", "RayUIConfigButton", GameMenuFrame, "GameMenuButtonTemplate")
	configButton:SetSize(GameMenuButtonContinue:GetWidth(), GameMenuButtonContinue:GetHeight())
	configButton:SetPoint("TOP", GameMenuButtonContinue, "BOTTOM", 0, -16)
	configButton:SetText(L["|cff7aa6d6Ray|r|cffff0000U|r|cff7aa6d6I|r设置"])
	configButton:SetScript("OnClick", function()
		if RayUIConfigTutorial then
			RayUIConfigTutorial:Hide()
			R.global.Tutorial.configbutton = true
		end
		HideUIPanel(GameMenuFrame)
		self:OpenConfig()
	end)
	GameMenuFrame:HookScript("OnShow", function() GameMenuFrame:SetHeight(GameMenuFrame:GetHeight() + configButton:GetHeight() + 16) end)

	local S = self:GetModule("Skins")
	S:Reskin(configButton)
end

--Check the player"s role
local roles = {
	PALADIN = {
		[1] = "Caster",
		[2] = "Tank",
		[3] = "Melee",
	},
	PRIEST = "Caster",
	WARLOCK = "Caster",
	WARRIOR = {
		[1] = "Melee",
		[2] = "Melee",
		[3] = "Tank",	
	},
	HUNTER = "Melee",
	SHAMAN = {
		[1] = "Caster",
		[2] = "Melee",
		[3] = "Caster",	
	},
	ROGUE = "Melee",
	MAGE = "Caster",
	DEATHKNIGHT = {
		[1] = "Tank",
		[2] = "Melee",
		[3] = "Melee",	
	},
	DRUID = {
		[1] = "Caster",
		[2] = "Melee",
		[3] = "Tank",	
		[4] = "Caster"
	},
	MONK = {
		[1] = "Tank",
		[2] = "Caster",
		[3] = "Melee",	
	},
}

local healingClasses = {
	PALADIN = 1,
	SHAMAN = 3,
	DRUID = 4,
	MONK = 2,
	PRIEST = {1, 2}
}

local gladStance = GetSpellInfo(156291)
function R:CheckRole()
	local role = self.Role
	local talentTree = GetSpecialization()
	local IsInPvPGear = false;
	local resilperc = GetCombatRatingBonus(COMBAT_RATING_RESILIENCE_PLAYER_DAMAGE_TAKEN)
	if resilperc > GetDodgeChance() and resilperc > GetParryChance() and UnitLevel("player") == MAX_PLAYER_LEVEL then
		IsInPvPGear = true;
	end

	self.Role = nil;

	if type(roles[self.myclass]) == "string" then
		self.Role = roles[self.myclass]
	elseif talentTree then
		self.Role = roles[self.myclass][talentTree]
	end

	if self.Role == "Tank" and (IsInPvPGear or UnitBuff("player", gladStance)) then
		self.Role = "Melee"
	end

	if not self.Role then
		local playerint = select(2, UnitStat("player", 4));
		local playeragi	= select(2, UnitStat("player", 2));
		local base, posBuff, negBuff = UnitAttackPower("player");
		local playerap = base + posBuff + negBuff;

		if (playerap > playerint) or (playeragi > playerint) then
			self.Role = "Melee";
		else
			self.Role = "Caster";
		end
	end

	if healingClasses[self.myclass] then
		local tree = healingClasses[self.myclass]
		if type(tree) == "number" then
			if talentTree == tree then
				self.isHealer = true
				return
			end
		elseif type(tree) == "table" then
			for _, index in pairs(tree) do
				if index == talentTree then
					self.isHealer = true
					return
				end
			end
		end
	end
	self.isHealer = false

	if(self.Role ~= role) then
		self.callbacks:Fire("RoleChanged")
	end
end

local tmp={}
function R:Print(...)
	local n=0
	for i=1, select("#", ...) do
		n=n+1
		tmp[n] = tostring(select(i, ...))
	end
	DEFAULT_CHAT_FRAME:AddMessage("|cff7aa6d6Ray|r|cffff0000U|r|cff7aa6d6I|r: " .. table.concat(tmp," ",1,n) )
end

function R:Debug(...)
	if not R:IsDeveloper() then return end
	local n=0
	for i=1, select("#", ...) do
		n=n+1
		tmp[n] = tostring(select(i, ...))
	end
	DEFAULT_CHAT_FRAME:AddMessage("|cffff0000debug|r: " .. table.concat(tmp," ",1,n) )
end

function R:ColorGradient(perc, ...)
	if perc >= 1 then
		local r, g, b = select(select("#", ...) - 2, ...)
		return r, g, b
	elseif perc <= 0 then
		local r, g, b = ...
		return r, g, b
	end

	local num = select("#", ...) / 3
	local segment, relperc = math.modf(perc*(num-1))
	local r1, g1, b1, r2, g2, b2 = select((segment*3)+1, ...)

	return r1 + (r2-r1)*relperc, g1 + (g2-g1)*relperc, b1 + (b2-b1)*relperc
end

function R:Round(num, idp)
	if(idp and idp > 0) then
		local mult = 10 ^ idp
		return floor(num * mult + 0.5) / mult
	end
	return floor(num + 0.5)
end

local waitTable = {}
local waitFrame
function R:Delay(delay, func, ...)
	if(type(delay)~="number" or type(func)~="function") then
		return false
	end
	if(waitFrame == nil) then
		waitFrame = CreateFrame("Frame","WaitFrame", UIParent)
		waitFrame:SetScript("onUpdate",function (self,elapse)
			local count = #waitTable
			local i = 1
			while(i<=count) do
				local waitRecord = tremove(waitTable,i)
				local d = tremove(waitRecord,1)
				local f = tremove(waitRecord,1)
				local p = tremove(waitRecord,1)
				if(d>elapse) then
					tinsert(waitTable,i,{d-elapse,f,p})
					i = i + 1
				else
					count = count - 1
					f(unpack(p))
				end
			end
		end)
	end
	tinsert(waitTable,{delay,func,{...}})
	return true
end

function R:RGBToHex(r, g, b)
	r = r <= 1 and r >= 0 and r or 0
	g = g <= 1 and g >= 0 and g or 0
	b = b <= 1 and b >= 0 and b or 0
	return string.format("|cff%02x%02x%02x", r*255, g*255, b*255)
end

function R:ShortValue(v)
	if self.global.general.numberType == 1 then
		if v >= 1e6 or v <= -1e6 then
			return ("%.1fm"):format(v / 1e6):gsub("%.?0+([km])$", "%1")
		elseif v >= 1e3 or v <= -1e3 then
			return ("%.1fk"):format(v / 1e3):gsub("%.?0+([km])$", "%1")
		else
			return v
		end
	else
		if v >= 1e8 or v <= -1e8 then
			return ("%.1f" .. SECOND_NUMBER_CAP):format(v / 1e8):gsub("%.?0+([km])$", "%1")
		elseif v >= 1e4 or v <= -1e4 then
			return ("%.1f" .. FIRST_NUMBER_CAP):format(v / 1e4):gsub("%.?0+([km])$", "%1")
		else
			return v
		end
	end
end

function R:ShortenString(string, numChars, dots)
	local bytes = string:len()
	if (bytes <= numChars) then
		return string
	else
		local len, pos = 0, 1
		while(pos <= bytes) do
			len = len + 1
			local c = string:byte(pos)
			if (c > 0 and c <= 127) then
				pos = pos + 1
			elseif (c >= 192 and c <= 223) then
				pos = pos + 2
			elseif (c >= 224 and c <= 239) then
				pos = pos + 3
				len = len + 1
			elseif (c >= 240 and c <= 247) then
				pos = pos + 4
				len = len + 1
			end
			if (len == numChars) then break end
		end

		if (len == numChars and pos <= bytes) then
			return string:sub(1, pos - 1)..(dots and "..." or "")
		else
			return string
		end
	end
end

function R:GetScreenQuadrant(frame)
	local x, y = frame:GetCenter()
	local screenWidth = GetScreenWidth()
	local screenHeight = GetScreenHeight()
	local point

	if not frame:GetCenter() then
		return "UNKNOWN", frame:GetName()
	end

	if (x > (screenWidth / 4) and x < (screenWidth / 4)*3) and y > (screenHeight / 4)*3 then
		point = "TOP"
	elseif x < (screenWidth / 4) and y > (screenHeight / 4)*3 then
		point = "TOPLEFT"
	elseif x > (screenWidth / 4)*3 and y > (screenHeight / 4)*3 then
		point = "TOPRIGHT"
	elseif (x > (screenWidth / 4) and x < (screenWidth / 4)*3) and y < (screenHeight / 4) then
		point = "BOTTOM"
	elseif x < (screenWidth / 4) and y < (screenHeight / 4) then
		point = "BOTTOMLEFT"
	elseif x > (screenWidth / 4)*3 and y < (screenHeight / 4) then
		point = "BOTTOMRIGHT"
	elseif x < (screenWidth / 4) and (y > (screenHeight / 4) and y < (screenHeight / 4)*3) then
		point = "LEFT"
	elseif x > (screenWidth / 4)*3 and y < (screenHeight / 4)*3 and y > (screenHeight / 4) then
		point = "RIGHT"
	else
		point = "CENTER"
	end

	return point
end

local Unusable

if R.myclass == "DEATHKNIGHT" then
	Unusable = {{3, 4, 10, 11, 13, 14, 15, 16}, {7}}
elseif R.myclass == "DRUID" then
	Unusable = {{1, 2, 3, 4, 8, 9, 14, 15, 16}, {4, 5, 7}, true}
elseif R.myclass == "HUNTER" then
	Unusable = {{5, 6, 16}, {5, 6, 7}}
elseif R.myclass == "MAGE" then
	Unusable = {{1, 2, 3, 4, 5, 6, 7, 9, 11, 14, 15}, {3, 4, 5, 7}, true}
elseif R.myclass == "PALADIN" then
	Unusable = {{3, 4, 10, 11, 13, 14, 15, 16}, {}, true}
elseif R.myclass == "PRIEST" then
	Unusable = {{1, 2, 3, 4, 6, 7, 8, 9, 11, 14, 15}, {3, 4, 5, 7}, true}
elseif R.myclass == "ROGUE" then
	Unusable = {{2, 6, 7, 9, 10, 16}, {4, 5, 6, 7}}
elseif R.myclass == "SHAMAN" then
	Unusable = {{3, 4, 7, 8, 9, 14, 15, 16}, {5}}
elseif R.myclass == "WARLOCK" then
	Unusable = {{1, 2, 3, 4, 5, 6, 7, 9, 11, 14, 15}, {3, 4, 5, 7}, true}
elseif R.myclass == "WARRIOR" then
	Unusable = {{16}, {}}
elseif R.myclass == "MONK" then
	Unusable = {{2, 3, 4, 6, 9, 13, 14, 15, 16}, {4, 5, 7}}
end

for class = 1, 2 do
	local subs = {GetAuctionItemSubClasses(class)}
	for i, subclass in ipairs(Unusable[class]) do
		if subs[subclass] then
			Unusable[subs[subclass]] = true
		end
	end
	Unusable[class] = nil
	subs = nil
end

function R:IsClassUnusable(subclass, slot)
	if subclass then
		return Unusable[subclass] or slot == "INVTYPE_WEAPONOFFHAND" and Unusable[3]
	end
end

function R:IsItemUnusable(...)
	if ... then
		local subclass, _, slot = select(7, GetItemInfo(...))
		return R:IsClassUnusable(subclass, slot)
	end
end

function R:AddBlankTabLine(cat, ...)
	local blank = {"blank", true, "fakeChild", true, "noInherit", true}
	local cnt = ... or 1
	for i = 1, cnt do
		cat:AddLine(blank)
	end
end

function R:MakeTabletHeader(col, size, indentation, justifyTable)
	local header = {}
	local colors = {}
	colors = {0.9, 0.8, 0.7}

	for i = 1, #col do
		if ( i == 1 ) then
			header["text"] = col[i]
			header["justify"] = justifyTable[i]
			header["size"] = size
			header["textR"] = colors[1]
			header["textG"] = colors[2]
			header["textB"] = colors[3]
			header["indentation"] = indentation
		else
			header["text"..i] = col[i]
			header["justify"..i] = justifyTable[i]
			header["size"..i] = size
			header["text"..i.."R"] = colors[1]
			header["text"..i.."G"] = colors[2]
			header["text"..i.."B"] = colors[3]
			header["indentation"] = indentation
		end
	end
	return header
end

R["media"] = {}
R["texts"] = {}

function R:UpdateFontTemplates()
	for text, _ in pairs(self["texts"]) do
		if text then
			text:FontTemplate(text.font, text.fontSize, text.fontStyle);
		else
			self["texts"][text] = nil;
		end
	end
end

function R:UpdateMedia()
	--Fonts
	self["media"].font = LSM:Fetch("font", self.global["media"].font)
	self["media"].dmgfont = LSM:Fetch("font", self.global["media"].dmgfont)
	self["media"].pxfont = LSM:Fetch("font", self.global["media"].pxfont)
	self["media"].cdfont = LSM:Fetch("font", self.global["media"].cdfont)
	self["media"].fontsize = self.global["media"].fontsize
	self["media"].fontflag = self.global["media"].fontflag

	--Textures
	self["media"].blank = LSM:Fetch("statusbar", self.global["media"].blank)
	self["media"].normal = LSM:Fetch("statusbar", self.global["media"].normal)
	self["media"].gloss = LSM:Fetch("statusbar", self.global["media"].gloss)
	self["media"].glow = LSM:Fetch("border", self.global["media"].glow)

	--Border Color
	self["media"].bordercolor = self.global["media"].bordercolor

	--Backdrop Color
	self["media"].backdropcolor = self.global["media"].backdropcolor
	self["media"].backdropfadecolor = self.global["media"].backdropfadecolor

	--Sound
	self["media"].warning = LSM:Fetch("sound", self.global["media"].warning)
	self["media"].errorsound = LSM:Fetch("sound", self.global["media"].errorsound)

	self:UpdateBlizzardFonts()
end

function R:CreateDemoFrame()
	local S = R:GetModule("Skins")
	demoFrame = CreateFrame("Frame", "RayUIDemoFrame", LibStub("AceConfigDialog-3.0").OpenFrames["RayUI"].frame)
	demoFrame:Size(300, 200)
	demoFrame:Point("LEFT", LibStub("AceConfigDialog-3.0").OpenFrames["RayUI"].frame, "RIGHT", 20, 0)
	demoFrame:SetTemplate("Transparent")
	demoFrame.outBorder = CreateFrame("Frame", nil, demoFrame)
	demoFrame.outBorder:SetOutside(demoFrame, 1, 1)
	demoFrame.outBorder:CreateShadow()
	demoFrame.title = demoFrame:CreateFontString(nil, "OVERLAY")
	demoFrame.title:FontTemplate()
	demoFrame.title:SetText("Demo Frame")
	demoFrame.title:Point("TOPLEFT", 10, -5)
	demoFrame.inlineFrame1 = CreateFrame("Frame", nil, demoFrame)
	demoFrame.inlineFrame1:SetFrameLevel(demoFrame:GetFrameLevel() + 1)
	demoFrame.inlineFrame1:Size(150, 150)
	demoFrame.inlineFrame1:Point("TOPLEFT", 10, -30)
	demoFrame.inlineFrame1:SetTemplate("Transparent")
	demoFrame.button1 = CreateFrame("Button", nil, demoFrame, "UIPanelButtonTemplate")
	demoFrame.button1:Point("BOTTOMLEFT", 30, 40)
	demoFrame.button1:SetText("Test")
	demoFrame.button1:Size(100, 20)
	S:Reskin(demoFrame.button1)
	demoFrame.button2 = CreateFrame("Button", nil, demoFrame, "UIPanelButtonTemplate")
	demoFrame.button2:Point("BOTTOMRIGHT", -10, 10)
	demoFrame.button2:SetText("Close")
	demoFrame.button2:Size(100, 20)
	demoFrame.button2:SetScript("OnClick", function() demoFrame:Hide() end)
	S:Reskin(demoFrame.button2)

	tinsert(UISpecialFrames, demoFrame:GetName())
end

function R:UpdateDemoFrame()
	local borderr, borderg, borderb = unpack(R.global.media.bordercolor)
	local backdropr, backdropg, backdropb = unpack(R.global.media.backdropcolor)
	local backdropfader, backdropfadeg, backdropfadeb, backdropfadea = unpack(R.global.media.backdropfadecolor)
	if not demoFrame then
		self:CreateDemoFrame()
	end
	if not demoFrame:IsShown() then
		demoFrame:Show()
	end
	demoFrame:SetBackdropColor(backdropfader, backdropfadeg, backdropfadeb, backdropfadea)
	demoFrame:SetBackdropBorderColor(borderr, borderg, borderb)
	demoFrame.outBorder.border:SetBackdropBorderColor(borderr, borderg, borderb)
	demoFrame.inlineFrame1:SetBackdropColor(backdropfader, backdropfadeg, backdropfadeb, backdropfadea)
	demoFrame.inlineFrame1:SetBackdropBorderColor(borderr, borderg, borderb)
	demoFrame.button1:SetBackdropColor(backdropfader, backdropfadeg, backdropfadeb, backdropfadea)
	demoFrame.button1:SetBackdropBorderColor(borderr, borderg, borderb)
	demoFrame.button1.backdropTexture:SetVertexColor(backdropr, backdropg, backdropb)
	demoFrame.button2:SetBackdropColor(backdropfader, backdropfadeg, backdropfadeb, backdropfadea)
	demoFrame.button2:SetBackdropBorderColor(borderr, borderg, borderb)
	demoFrame.button2.backdropTexture:SetVertexColor(backdropr, backdropg, backdropb)
end

local CPU_USAGE = {}
local function CompareCPUDiff(module)
	local greatestUsage, greatestCalls, greatestName
	local greatestDiff = 0
	local mod = R:GetModule(module, true) or R

	for name, oldUsage in pairs(CPU_USAGE) do
		local newUsage, calls = GetFunctionCPUUsage(mod[name], true)
		local differance = newUsage - oldUsage

		if differance > greatestDiff then
			greatestName = name
			greatestUsage = newUsage
			greatestCalls = calls
			greatestDiff = differance
		end
	end

	if(greatestName) then
		R:Print(greatestName .. " 为CPU占用最多的函数, 用时: " .. greatestUsage .. "ms. 共执行 " .. greatestCalls .. " 次.")
	else
		R:Print("nothing happened.")
	end
end

function R:GetTopCPUFunc(msg)
	if GetCVar("scriptProfile") ~= "1" then return end

	local module, delay = string.split(",",msg)

	module = module == "nil" and nil or module
	delay = delay == "nil" and nil or tonumber(delay)

	wipe(CPU_USAGE)
	local mod = self:GetModule(module, true) or self
	for name, func in pairs(mod) do
		if type(mod[name]) == "function" and name ~= "GetModule" then
			CPU_USAGE[name] = GetFunctionCPUUsage(mod[name], true)
		end
	end

	self:Delay(delay or 5, CompareCPUDiff, module)
	self:Print("Calculating CPU Usage..")
end

R.Developer = { "夏琉君", "鏡婲水月", "Divineseraph", "水月君", "夏翎", }

function R:IsDeveloper()
	for _, name in pairs(R.Developer) do
		if name == R.myname then
			return true
		end
	end
	return false
end

function R:ADDON_LOADED(event, addon)
	self:UnregisterEvent("ADDON_LOADED")
end
R:RegisterEvent("ADDON_LOADED")
