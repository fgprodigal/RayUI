local R, L, P = unpack(select(2, ...)) --Inport: Engine, Locales, ProfileDB
local LSM = LibStub("LibSharedMedia-3.0")

SlashCmdList["RELOAD"] = function() ReloadUI() end
SLASH_RELOAD1 = "/rl"

local AddonNotSupported = {}
local BlackList = {"bigfoot", "duowan", "163ui", "neavo", "sora"}

R["RegisteredModules"] = {}

function DoSkill(name)
	for i=1,GetNumTradeSkills()do
		local skillName,skillType,numAvailable=GetTradeSkillInfo(i)
		if skillName and skillName:find(name)and numAvailable>0 then
			DoTradeSkill(i,numAvailable)
			UIErrorsFrame:AddMessage("["..skillName.."]x"..numAvailable, TradeSkillTypeColor[skillType].r, TradeSkillTypeColor[skillType].g, TradeSkillTypeColor[skillType].b)
			break
		end
	end
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

local function CreateWarningFrame()
	for index in pairs(AddonNotSupported) do
		R:Print(GetAddOnInfo(index))
	end
	local S = R:GetModule("Skins")
	local frame = CreateFrame("Frame", "RayUIWarningFrame", UIParent)
	S:SetBD(frame)
	frame:Size(400, 400)
	frame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
	-- frame:Hide()
	frame:EnableMouse(true)
	frame:SetFrameStrata("DIALOG")

	local titile = frame:CreateFontString(nil, "OVERLAY")
	titile:Point("TOPLEFT", 0, -10)
	titile:Point("TOPRIGHT", 0, -10)
	titile:SetFont(R["media"].font, R["media"].fontsize + 2, R["media"].fontflag)
	titile:SetText("由于一些很复杂的原因, 关闭以下插件后才能正常使用|cff7aa6d6Ray|r|cffff0000U|r|cff7aa6d6I|r:")

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
	button1:SetText("帮我关掉它们")
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
	button2:SetText("不，我需要它们")
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
			if (self.db[self["RegisteredModules"][i]] == nil or self.db[self["RegisteredModules"][i]].enable ~= false) and self:GetModule(self["RegisteredModules"][i]).Initialize then
				self:GetModule(self["RegisteredModules"][i]):Initialize()
			end
		end
	end
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

function R:CheckRole()
	local talentTree = GetSpecialization()
	local IsInPvPGear = false;
	local resilperc = GetCombatRatingBonus(COMBAT_RATING_RESILIENCE_PLAYER_DAMAGE_TAKEN)
	if resilperc > GetDodgeChance() and resilperc > GetParryChance() and UnitLevel("player") == MAX_PLAYER_LEVEL then
		IsInPvPGear = true;
	end
	
	self.Role = nil;
	
	if type(roles[R.myclass]) == "string" then
		self.Role = roles[R.myclass]
	elseif talentTree then
		self.Role = roles[R.myclass][talentTree]
	end
	
	if self.Role == "Tank" and IsInPvPGear then
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

function R:Round(v, decimals)
	if not decimals then decimals = 0 end
    return (("%%.%df"):format(decimals)):format(v)
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
	if v >= 1e6 then
		return ("%.1fm"):format(v / 1e6):gsub("%.?0+([km])$", "%1")
	elseif v >= 1e3 or v <= -1e3 then
		return ("%.1fk"):format(v / 1e3):gsub("%.?0+([km])$", "%1")
	else
		return v
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
	Unusable = {{3, 4, 10, 11, 13, 14, 15, 16}, {6}}
elseif R.myclass == "DRUID" then
	Unusable = {{1, 2, 3, 4, 8, 9, 14, 15, 16}, {4, 5, 6}, true}
elseif R.myclass == "HUNTER" then
	Unusable = {{5, 6, 16}, {5, 6, 7}}
elseif R.myclass == "MAGE" then
	Unusable = {{1, 2, 3, 4, 5, 6, 7, 9, 11, 14, 15}, {3, 4, 5, 6, 7}, true}
elseif R.myclass == "PALADIN" then
	Unusable = {{3, 4, 10, 11, 13, 14, 15, 16}, {}, true}
elseif R.myclass == "PRIEST" then
	Unusable = {{1, 2, 3, 4, 6, 7, 8, 9, 11, 14, 15}, {3, 4, 5, 6, 7}, true}
elseif R.myclass == "ROGUE" then
	Unusable = {{2, 6, 7, 9, 10, 16}, {4, 5, 6, 7}}
elseif R.myclass == "SHAMAN" then
	Unusable = {{3, 4, 7, 8, 9, 14, 15, 16}, {5}}
elseif R.myclass == "WARLOCK" then
	Unusable = {{1, 2, 3, 4, 5, 6, 7, 9, 11, 14, 15}, {3, 4, 5, 6, 7}, true}
elseif R.myclass == "WARRIOR" then
	Unusable = {{16}, {7}}
elseif R.myclass == "MONK" then
	Unusable = {{2, 3, 4, 6, 9, 13, 14, 15, 16}, {4, 5, 6, 7}}
end

for class = 1, 2 do
	local subs = {GetAuctionItemSubClasses(class)}
	for i, subclass in ipairs(Unusable[class]) do
		Unusable[subs[subclass]] = true
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

function R:UpdateMedia()
	--Fonts
	self["media"].font = LSM:Fetch("font", self.db["media"].font)
	self["media"].dmgfont = LSM:Fetch("font", self.db["media"].dmgfont)
	self["media"].pxfont = LSM:Fetch("font", self.db["media"].pxfont)
	self["media"].cdfont = LSM:Fetch("font", self.db["media"].cdfont)
	self["media"].fontsize = self.db["media"].fontsize
	self["media"].fontflag = self.db["media"].fontflag

	--Textures
	self["media"].blank = LSM:Fetch("background", self.db["media"].blank)
	self["media"].normal = LSM:Fetch("statusbar", self.db["media"].normal)
	self["media"].glow = LSM:Fetch("border", self.db["media"].glow)

	--Border Color
	self["media"].bordercolor = self.db["media"].bordercolor

	--Backdrop Color
	self["media"].backdropcolor = self.db["media"].backdropcolor

	--Sound
	self["media"].warning = LSM:Fetch("sound", self.db["media"].warning)
	self["media"].errorsound = LSM:Fetch("sound", self.db["media"].errorsound)

	self:UpdateBlizzardFonts()
end
