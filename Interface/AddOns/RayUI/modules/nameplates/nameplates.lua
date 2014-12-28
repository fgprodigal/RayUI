local R, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local NP = R:NewModule("NamePlates", "AceEvent-3.0", "AceHook-3.0", "AceTimer-3.0")
NP.modName = L["姓名板"]

local FONTSIZE = 9
local hpHeight = 10
local hpWidth = 110
local iconSize = 23		--Size of all Icons, RaidIcon/ClassIcon/Castbar Icon
local cbHeight = 5
local cbWidth = 110
local OVERLAY = [=[Interface\TargetingFrame\UI-TargetingFrame-Flash]=]
local numChildren = -1
local frames = {}

local goodR, goodG, goodB = unpack(RayUF["colors"].reaction[5])
local badR, badG, badB = unpack(RayUF["colors"].reaction[1])
local transitionR, transitionG, transitionB = 218/255, 197/255, 92/255
local transitionR2, transitionG2, transitionB2 = 240/255, 154/255, 17/255

local BattleGroundHealers = {}
local PlayerFaction
local factionOpposites = {
	["Horde"] = 1,
	["Alliance"] = 0,
}
local Healers = {
	["恢復"] = true,
	["恢复"] = true,
	["神聖"] = true,
	["神圣"] = true,
	["戒律"] = true,
	["织雾"] = true,
	["織霧"] = true,
}

local DebuffWhiteList = {
	-- Death Knight
	[GetSpellInfo(47476)] = true, --strangulate
	-- Druid
	[GetSpellInfo(33786)] = true, --Cyclone
	[GetSpellInfo(339)] = true, --Entangling Roots
	[GetSpellInfo(78675)] = true, --Solar Beam
	-- Hunter
	[GetSpellInfo(3355)] = true, --Freezing Trap Effect
	-- Mage
	[GetSpellInfo(31661)] = true, --Dragon's Breath
	[GetSpellInfo(61305)] = true, --Polymorph
	[GetSpellInfo(122)] = true, --Frost Nova
	[GetSpellInfo(82691)] = true, --Ring of Frost
	-- Paladin
	[GetSpellInfo(20066)] = true, --Repentance
	[GetSpellInfo(10326)] = true, --Turn Evil
	[GetSpellInfo(853)] = true, --Hammer of Justice
	-- Priest
	[GetSpellInfo(605)] = true, --Mind Control
	[GetSpellInfo(64044)] = true, --Psychic Horror
	[GetSpellInfo(8122)] = true, --Psychic Scream
	[GetSpellInfo(9484)] = true, --Shackle Undead
	[GetSpellInfo(15487)] = true, --Silence
	-- Rogue
	[GetSpellInfo(2094)] = true, --Blind
	[GetSpellInfo(1776)] = true, --Gouge
	[GetSpellInfo(6770)] = true, --Sap
	-- Shaman
	[GetSpellInfo(51514)] = true, --Hex
	[GetSpellInfo(3600)] = true, --Earthbind
	[GetSpellInfo(8056)] = true, --Frost Shock
	[GetSpellInfo(63685)] = true, --Freeze
	-- Warlock
	[GetSpellInfo(710)] = true, --Banish
	[GetSpellInfo(6789)] = true, --Death Coil
	[GetSpellInfo(5782)] = true, --Fear
	[GetSpellInfo(5484)] = true, --Howl of Terror
	[GetSpellInfo(6358)] = true, --Seduction
	[GetSpellInfo(30283)] = true, --Shadowfury
	-- Racial
	[GetSpellInfo(25046)] = true, --Arcane Torrent
	[GetSpellInfo(20549)] = true, --War Stomp
	--PVE
}

local PlateBlacklist = {
	--圖騰
	[GetSpellInfo(2062)] = true,  --土元素圖騰
	[GetSpellInfo(2894)] = true,  --火元素圖騰
	[GetSpellInfo(5394)] = true,  --治療之泉圖騰
	[GetSpellInfo(8190)] = true,  --熔岩圖騰
	[GetSpellInfo(3599)] = true,  --灼熱圖騰

	--亡者大軍
	["亡者军团食尸鬼"] = true,
	["食屍鬼大軍"] = true,
	["Army of the Dead Ghoul"] = true,

	--陷阱
	["Venomous Snake"] = true,
	["毒蛇"] = true,
	["剧毒蛇"] = true,

	["Viper"] = true,
	["響尾蛇"] = true,

	--Misc
	["Lava Parasite"] = true,
	["熔岩蟲"] = true,
	["熔岩寄生虫"] = true,
}

function NP:GetOptions()
	local options = {
		showdebuff = {
			order = 5,
			name = L["显示debuff"],
			type = "toggle",
		},
		combat = {
			order = 6,
			name = L["自动显示/隐藏"],
			type = "toggle",
		},
		showhealer = {
			order = 7,
			name = L["战场中标识治疗"],
			type = "toggle",
		},
		smooth = {
			order = 7,
			name = L["平滑变化"],
			type = "toggle",
		},
		fadeValue = {
			order = 8,
			name = L["非目标透明度"],
			type = "range",
			min = 0.0, max = 0.9, step = 0.01,
			isPercent = true,
		},
		fade = {
			order = 9,
			name = L["透明度渐变"],
			type = "toggle",
		},
	}
	return options
end

function NP:CheckHealers()
	for i = 1, GetNumBattlefieldScores() do
		local name, _, _, _, _, faction, _, _, _, _, _, _, _, _, _, talentSpec = GetBattlefieldScore(i)
		if name then
			name = name:match("(.+)%-.+") or name
			if name and Healers[talentSpec] and factionOpposites[PlayerFaction] == faction then
				BattleGroundHealers[name] = talentSpec
			elseif name and BattleGroundHealers[name] then
				BattleGroundHealers[name] = nil
			end
		end
	end
end

local function RoundColors(r, g, b)
	return floor(r*100+.5)/100, floor(g*100+.5)/100, floor(b*100+.5)/100
end

local function QueueObject(parent, object)
	parent.queue = parent.queue or {}
	parent.queue[object] = true
end

local function HideObjects(parent)
	for object in pairs(parent.queue) do
		objectType = object:GetObjectType()  
		if objectType == "Texture" then
			object.OldTexture = object:GetTexture()
			object:SetTexture("")
			object:SetTexCoord(0, 0, 0, 0)
		elseif objectType == "FontString" then
			object:SetWidth(0.001)
		elseif objectType == "StatusBar" then
			object:SetStatusBarTexture("")
		else
			object:Hide()
		end
	end
end

--Create a fake backdrop frame using textures
local function CreateVirtualFrame(parent, point)
	if point == nil then point = parent end

	if point.backdrop or parent.backdrop then return end

	local noscalemult = R.mult * UIParent:GetScale()
	parent.backdrop = CreateFrame("Frame", nil ,parent)
	parent.backdrop:SetAllPoints()
	if R.global.general.theme == "Shadow" then
		parent.backdrop:SetBackdrop({
			bgFile = R["media"].blank,
			edgeFile = R["media"].glow,
			edgeSize = 3*noscalemult,
			insets = {
				top = 3*noscalemult, left = 3*noscalemult, bottom = 3*noscalemult, right = 3*noscalemult
			}
		})
		parent.backdrop:SetPoint("TOPLEFT", point, -3*noscalemult, 3*noscalemult)
		parent.backdrop:SetPoint("BOTTOMRIGHT", point, 3*noscalemult, -3*noscalemult)
	else
		parent.backdrop:SetBackdrop({
			bgFile = R["media"].blank,
			edgeFile = R["media"].blank,
			edgeSize = noscalemult,
			insets = {
				top = noscalemult, left = noscalemult, bottom = noscalemult, right = noscalemult
			}
		})
		parent.backdrop:SetPoint("TOPLEFT", point, -noscalemult, noscalemult)
		parent.backdrop:SetPoint("BOTTOMRIGHT", point, noscalemult, -noscalemult)
	end
	parent.backdrop:SetBackdropColor(.05, .05, .05, .9)
	parent.backdrop:SetBackdropBorderColor(0, 0, 0, 1)
	if parent:GetFrameLevel() - 1 >0 then
		parent.backdrop:SetFrameLevel(parent:GetFrameLevel() - 1)
	else
		parent.backdrop:SetFrameLevel(0)
	end
end

local function UpdateAuraAnchors(frame)
	for i = 1, 5 do
		if frame.icons and frame.icons[i] and frame.icons[i]:IsShown() then
			if frame.icons.lastShown then
				frame.icons[i]:SetPoint("LEFT", frame.icons.lastShown, "RIGHT", 2, 0)
			else
				frame.icons[i]:SetPoint("LEFT",frame.icons,"LEFT")
			end
			frame.icons.lastShown = frame.icons[i]
		end
	end

	frame.icons.lastShown = nil;
end

--Create our Aura Icons
local function CreateAuraIcon(parent)
	local noscalemult = R.mult * UIParent:GetScale()
	local button = CreateFrame("Frame",nil,parent)
	button:SetScript("OnHide", function(self) UpdateAuraAnchors(self:GetParent():GetParent()) end)
	button:SetWidth(20)
	button:SetHeight(20)

	if R.global.general.theme == "Shadow" then
		button.shadow = CreateFrame("Frame", nil, button)
		button.shadow:SetFrameLevel(0)
		button.shadow:Point("TOPLEFT", -2*noscalemult, 2*noscalemult)
		button.shadow:Point("BOTTOMRIGHT", 2*noscalemult, -2*noscalemult)
		button.shadow:SetBackdrop( {
			edgeFile = R["media"].glow,
			bgFile = R["media"].blank,
			edgeSize = R:Scale(4),
			insets = {left = R:Scale(4), right = R:Scale(4), top = R:Scale(4), bottom = R:Scale(4)},
		})
		button.shadow:SetBackdropColor( 0, 0, 0 )
		button.shadow:SetBackdropBorderColor( 0, 0, 0 )
	end

	button.bord = button:CreateTexture(nil, "BORDER")
	button.bord:SetTexture(0, 0, 0, 1)
	button.bord:SetPoint("TOPLEFT",button,"TOPLEFT", noscalemult,-noscalemult)
	button.bord:SetPoint("BOTTOMRIGHT",button,"BOTTOMRIGHT",-noscalemult,noscalemult)

	button.icon = button:CreateTexture(nil, "OVERLAY")
	button.icon:SetPoint("TOPLEFT",button,"TOPLEFT", noscalemult*2,-noscalemult*2)
	button.icon:SetPoint("BOTTOMRIGHT",button,"BOTTOMRIGHT",-noscalemult*2,noscalemult*2)
	button.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)

	button.text = button:CreateFontString(nil, "OVERLAY")
	button.text:Point("CENTER", button, "BOTTOM", 1, 1)
	button.text:SetJustifyH("CENTER")
	button.text:SetFont(R["media"].font, 10, "OUTLINE")
	button.text:SetShadowColor(0, 0, 0, 0)

	button.count = button:CreateFontString(nil,"OVERLAY")
	button.count:SetFont(R["media"].font,9,R["media"].fontflag)
	button.count:SetShadowColor(0, 0, 0, 0.4)
	button.count:SetPoint("TOPRIGHT", button, "TOPRIGHT", 2, 2)
	return button
end

local day, hour, minute, second = 86400, 3600, 60, 1
local function formatTime(s)
	if s >= day then
		return format("%dd", ceil(s / hour))
	elseif s >= hour then
		return format("%dh", ceil(s / hour))
	elseif s >= minute then
		return format("%dm", ceil(s / minute))
		-- elseif s >= minute / 12 then
	elseif s >= 0 then
		return floor(s)
	end

	return format("%.1f", s)
end

local function UpdateAuraTimer(self, elapsed)
	if not self.timeLeft then return end
	self.elapsed = (self.elapsed or 0) + elapsed
	if self.elapsed >= 0.1 then
		if not self.firstUpdate then
			self.timeLeft = self.timeLeft - self.elapsed
		else
			self.timeLeft = self.timeLeft - GetTime()
			self.firstUpdate = false
		end
		if self.timeLeft > 0 then
			local time = formatTime(self.timeLeft)
			self.text:SetText(time)
			if self.timeLeft <= 5 then
				self.text:SetTextColor(1, 0, 0)
			elseif self.timeLeft <= minute then
				self.text:SetTextColor(1, 1, 0)
			else
				self.text:SetTextColor(1, 1, 1)
			end
		else
			self.text:SetText("")
			self:SetScript("OnUpdate", nil)
			self:Hide()
		end
		self.elapsed = 0
	end
end

--Update an Aura Icon
local function UpdateAuraIcon(button, unit, index, filter)
	local name,_,icon,count,debuffType,duration,expirationTime,_,_,_,spellID = UnitAura(unit,index,filter)

	-- if debuffType then
	-- button.bord:SetTexture(DebuffTypeColor[debuffType].r, DebuffTypeColor[debuffType].g, DebuffTypeColor[debuffType].b)
	-- else
	-- button.bord:SetTexture(1, 0, 0, 1)
	-- end
	button.icon:SetTexture(icon)
	button.firstUpdate = true
	button.expirationTime = expirationTime
	button.duration = duration
	button.spellID = spellID
	button.timeLeft = expirationTime
	if count > 1 then
		button.count:SetText(count)
	else
		button.count:SetText("")
	end
	if not button:GetScript("OnUpdate") then
		button:SetScript("OnUpdate", UpdateAuraTimer)
	end
	button:Show()
end

--Filter auras on nameplate, and determine if we need to update them or not.
local function OnAura(frame, unit)
	if not frame.icons or not frame.unit or not NP.db.showdebuff then return end
	local i = 1
	for index = 1,40 do
		if i > 5 then return end
		local match
		local name,_,_,_,_,duration,_,caster,_,_,spellid = UnitAura(frame.unit,index,"HARMFUL")

		if caster == "player" and duration>0 then match = true end
		if DebuffWhiteList[name] then match = true end

		if duration and match == true then
			if not frame.icons[i] then frame.icons[i] = CreateAuraIcon(frame.icons) end
			local icon = frame.icons[i]
			if i == 1 then icon:SetPoint("LEFT",frame.icons,"LEFT") end
			if i ~= 1 and i <= 5 then icon:SetPoint("LEFT", frame.icons[i-1], "RIGHT", 2, 0) end
			i = i + 1
			UpdateAuraIcon(icon, frame.unit, index, "HARMFUL")
		end
	end
	for index = i, #frame.icons do frame.icons[index]:Hide() end
end

local function CastBar_OnShow(frame)
	frame._parent.castBar:Show()
end

local function CastBar_OnHide(frame)
	frame._parent.castBar:Hide()
end

local function CastBar_OnValueChanged(self, value)
	local myPlate = self._parent
	local min, max = self:GetMinMaxValues()
	local isChannel = value < myPlate.castBar:GetValue()
	myPlate.castBar:SetMinMaxValues(min, max)
	myPlate.castBar:SetValue(value)
	myPlate.castBar.time:SetFormattedText("%.1f ", value)

	if(myPlate.castBar.oldshield:IsShown()) then
		myPlate.castBar:SetStatusBarColor(1, 0, 0)
		myPlate.castBar.shield:Show()
	else
		myPlate.castBar:SetStatusBarColor(0, 1, 0)
		myPlate.castBar.shield:Hide()
	end
end

--Determine whether or not the cast is Channelled or a Regular cast so we can grab the proper Cast Name
local function UpdateCastText(frame, curValue)
	local minValue, maxValue = frame:GetMinMaxValues()

	-- if UnitChannelInfo("target") then
	frame.time:SetFormattedText("%.1f ", curValue)
	-- end

	-- if UnitCastingInfo("target") then
	-- frame.time:SetFormattedText("%.1f ", maxValue - curValue)
	-- end
end

--Create our blacklist for nameplates, so prevent a certain nameplate from ever showing
local function CheckFilter(frame, ...)
	if PlateBlacklist[frame.hp.oldname:GetText()] then
		frame:SetScript("OnUpdate", function() end)
		frame.hp:Hide()
		frame.cb:Hide()
		frame.overlay:Hide()
		frame.hp.oldlevel:Hide()
	end

	local name = gsub(frame.hp.oldname:GetText(), "%s%(%*%)","")
	if BattleGroundHealers[name] then
		frame.healerIcon:Show()
	else
		frame.healerIcon:Hide()
	end
end

--Color Nameplate
local function Colorize(frame, r, g, b)
	frame.hp.originalr, frame.hp.originalg, frame.hp.originalb = r, g, b

	for class, color in pairs(RAID_CLASS_COLORS) do
		local bb = b
		if class == "MONK" then
			bb = bb - 0.01
		end
		if RAID_CLASS_COLORS[class].r == r and RAID_CLASS_COLORS[class].g == g and RAID_CLASS_COLORS[class].b == bb then
			frame.hasClass = true
			frame.isFriendly = false
			frame.hp:SetStatusBarColor(unpack(RayUF.colors.class[class]))
			return
		end
	end

	frame.isTapped = nil

	if r>=.5 and r<=.6 and g>=.5 and g<=.6 and b>=.5 and b<=.6 then -- tapped
		r,g,b = 0.6, 0.6, 0.6
		frame.isFriendly = false
		frame.isTapped = true
	elseif g+b == 0 then
		-- hostile
		r,g,b = unpack(RayUF.colors.reaction[1])
		frame.isFriendly = false
	elseif r+b == 0 then
		-- friendly npc
		r,g,b = unpack(RayUF.colors.power["MANA"])
		frame.isFriendly = true
	elseif r+g > 1.95 then
		-- neutral
		r,g,b = unpack(RayUF.colors.reaction[4])
		frame.isFriendly = false
	elseif r+g == 0 then
		-- friendly player
		r,g,b = unpack(RayUF.colors.reaction[5])
		frame.isFriendly = true
	else
		-- enemy player
		frame.isFriendly = false
	end
	frame.hasClass = false

	frame.hp:SetStatusBarColor(r,g,b)
end

local function UpdateColoring(frame)
	local r, g, b = RoundColors(frame.healthOriginal:GetStatusBarColor())

	if (r ~= frame.hp.originalr or g ~= frame.hp.originalg or b ~= frame.hp.originalb) then
		Colorize(frame, r, g, b)
	end
end

local function OnHealthValueChanged(frame)
	local frame = frame:GetParent()
	frame.hp:SetMinMaxValues(frame.healthOriginal:GetMinMaxValues())
	frame.hp:SetValue(frame.healthOriginal:GetValue() - 1)
	frame.hp:SetValue(frame.healthOriginal:GetValue())
end

--HealthBar OnShow, use this to set variables for the nameplate, also size the healthbar here because it likes to lose it's
--size settings when it gets reshown
local function OnFrameShow(frame)
	local frame = frame:GetParent()

	local r, g, b = frame.hp:GetStatusBarColor()

	--Have to reposition this here so it doesnt resize after being hidden
	frame.hp:ClearAllPoints()
	frame.hp:SetSize(hpWidth, hpHeight)
	frame.hp:SetPoint("CENTER", frame, "CENTER", 0, 0)
	frame.hp:GetStatusBarTexture():SetHorizTile(true)

	frame.hp:SetMinMaxValues(frame.healthOriginal:GetMinMaxValues())
	frame.hp:SetValue(frame.healthOriginal:GetValue())

	--Colorize Plate
	local r, g, b = RoundColors(frame.healthOriginal:GetStatusBarColor())
	Colorize(frame, r, g, b)
	frame.hp.rcolor, frame.hp.gcolor, frame.hp.bcolor = frame.hp:GetStatusBarColor()
	frame.hp.hpbg:SetTexture(frame.hp.rcolor, frame.hp.gcolor, frame.hp.bcolor, 0.1)
	frame.hp.name:SetJustifyH("LEFT")
	frame.hp.name:SetTextColor(frame.hp.rcolor, frame.hp.gcolor, frame.hp.bcolor)
	frame.hp.name:ClearAllPoints()
	frame.hp.name:SetPoint("BOTTOMLEFT", frame.hp, "TOPLEFT", 0, -1)
	frame.hp.name:SetPoint("BOTTOMRIGHT", frame.hp, "TOPRIGHT", -20, -1)
	frame.hp.name:SetFont(R["media"].font, FONTSIZE, R["media"].fontflag)

	frame.hp.value:Show()

	frame.overlay:ClearAllPoints()
	frame.overlay:SetAllPoints(frame.hp)

	if not frame.icons then
		frame.icons = CreateFrame("Frame", nil, frame)
		frame.icons:SetPoint("BOTTOMRIGHT", frame.hp, "TOPRIGHT", 0, 11)
		frame.icons:SetPoint("BOTTOMLEFT", frame.hp, "TOPLEFT", 0, 11)
		frame.icons:SetHeight(25)
		frame.icons:SetFrameLevel(frame.hp:GetFrameLevel()+2)
		frame:RegisterEvent("UNIT_AURA")
		frame:HookScript("OnEvent", OnAura)
	end

	local isSmallNP, noscalemult
	if frame.hp:GetEffectiveScale() < 1 then
		isSmallNP = true
	end

	if isSmallNP then
		local scale = 1 / frame:GetEffectiveScale()
		frame.hp:SetWidth(hpWidth * scale - 80)
		frame.hp:SetHeight(hpHeight * scale)
		frame.hp.value:Hide()
		frame.hp.name:SetJustifyH("CENTER")
		frame.hp.name:ClearAllPoints()
		frame.hp.name:SetFont(R["media"].font, FONTSIZE * scale, R["media"].fontflag)
		frame.hp.name:SetPoint("BOTTOMLEFT", frame.hp, "TOPLEFT", 0, -1)
		frame.hp.name:SetPoint("BOTTOMRIGHT", frame.hp, "TOPRIGHT", 0, -1)
		noscalemult = R.mult * UIParent:GetScale() * scale
		frame.icons:Hide()
	else
		noscalemult = R.mult * UIParent:GetScale()
		frame.icons:Show()
	end

	frame.hp.backdrop:ClearAllPoints()
	if R.global.general.theme == "Shadow" then
		frame.hp.backdrop:SetPoint("TOPLEFT", frame.hp, -3*noscalemult, 3*noscalemult)
		frame.hp.backdrop:SetPoint("BOTTOMRIGHT", frame.hp, 3*noscalemult, -3*noscalemult)
	else
		frame.hp.backdrop:SetPoint("TOPLEFT", frame.hp, -noscalemult, noscalemult)
		frame.hp.backdrop:SetPoint("BOTTOMRIGHT", frame.hp, noscalemult, -noscalemult)
	end

	local level, mylevel = tonumber(frame.hp.oldlevel:GetText()), UnitLevel("player")

	--Set the name text
	if frame.hp.boss:IsShown() then
		frame.hp.name:SetText(R:RGBToHex(0.8, 0.05, 0).."?? |r "..frame.hp.oldname:GetText())
	elseif isSmallNP then
		frame.hp.name:SetText(frame.hp.oldname:GetText())
	elseif frame.hp.elite:IsShown() then
		frame.hp.name:SetText(R:RGBToHex(frame.hp.oldlevel:GetTextColor())..level.."+ |r"..frame.hp.oldname:GetText())
	else
		frame.hp.name:SetText(R:RGBToHex(frame.hp.oldlevel:GetTextColor())..level.." |r"..frame.hp.oldname:GetText())
	end

	frame.icons:SetScale(frame.hp:GetScale())

	CheckFilter(frame)
	HideObjects(frame)
end

local function OnFrameUpdate(self, e)
	self.defaultAlpha = self:GetAlpha()

	if self.defaultAlpha == 1 and UnitExists("target")  then
		self.currentAlpha = 1
	elseif UnitExists("target") then
		self.currentAlpha = NP.db.fadeValue
	else
		self.currentAlpha = 1
	end

	if NP.db.fade then
		self.lastAlpha = self.lastAlpha or 0
		self.lastAlpha  = self.lastAlpha + (self.currentAlpha - self.lastAlpha)/18

		if (self.lastAlpha == self.currentAlpha or math.abs(self.lastAlpha - self.currentAlpha) < .02) then
			self:SetAlpha(self.currentAlpha)
		else
			self:SetAlpha(self.lastAlpha)
		end
	else
		self:SetAlpha(self.currentAlpha)
	end
end

--We need to reset everything when a nameplate it hidden, this is so theres no left over data when a nameplate gets reshown for a differant mob.
local function OnFrameHide(frame)
	frame.hp:SetStatusBarColor(frame.hp.rcolor, frame.hp.gcolor, frame.hp.bcolor)
	frame.overlay:Hide()
	frame.cb:Hide()
	frame.unit = nil
	frame.threatStatus = nil
	frame.guid = nil
	frame.hasClass = nil
	frame.isFriendly = nil
	frame.isTapped = nil
	frame.hp.rcolor = nil
	frame.hp.gcolor = nil
	frame.hp.bcolor = nil
	if frame.icons then
		for _,icon in ipairs(frame.icons) do
			icon:Hide()
		end
	end
	frame:GetChildren().lastAlpha = 0
	frame:GetChildren().fadingTo = nil
	frame:SetScript("OnUpdate",nil)
end

--This is where we create most "Static" objects for the nameplate, it gets fired when a nameplate is first seen.
local function SkinObjects(frame, nameFrame)
	local noscalemult = R.mult * UIParent:GetScale()
	local oldhp, cb = frame:GetChildren()
	local threat, hpborder, overlay, oldlevel, bossicon, raidicon, elite = frame:GetRegions()
	local oldname = nameFrame:GetRegions()
	local _, cbborder, cbshield, cbicon, cbtext, cbshadow = cb:GetRegions()

	if not frame.hp then
		--Health Bar
		frame.healthOriginal = oldhp
		frame.hp = CreateFrame("Statusbar", nil, frame)
		if NP.db.smooth then
			R:SmoothBar(frame.hp)
		end
		frame.hp:SetFrameLevel(oldhp:GetFrameLevel())
		frame.hp:SetFrameStrata(oldhp:GetFrameStrata())
		frame.hp:SetStatusBarTexture(R["media"].normal)
		CreateVirtualFrame(frame.hp)
		frame.hp.hpbg = frame.hp:CreateTexture(nil, "BORDER")
		frame.hp.hpbg:SetAllPoints(frame.hp)
		frame.hp.hpbg:SetTexture(1,1,1,0.1)
	end

	frame.hp.oldlevel = oldlevel
	frame.hp.boss = bossicon
	frame.hp.elite = elite

	if not frame.threat then
		frame.threat = threat
	end

	if not frame.hp.value then
		frame.hp.value = frame.hp:CreateFontString(nil, "OVERLAY")
		frame.hp.value:SetFont(R["media"].font, FONTSIZE, R["media"].fontflag)
		frame.hp.value:SetShadowColor(0, 0, 0, 0.4)
		frame.hp.value:SetPoint("BOTTOMRIGHT", frame.hp, "TOPRIGHT", 0, -1)
		frame.hp.value:SetJustifyH("RIGHT")
		frame.hp.value:SetTextColor(1,1,1)
		frame.hp.value:SetShadowOffset(R.mult, -R.mult)
	end

	if not frame.hp.name then
		--Create Name Text
		frame.hp.name = frame.hp:CreateFontString(nil, "OVERLAY")
		frame.hp.name:SetPoint("BOTTOMLEFT", frame.hp, "TOPLEFT", 0, -1)
		frame.hp.name:SetPoint("BOTTOMRIGHT", frame.hp, "TOPRIGHT", -20, -1)
		frame.hp.name:SetFont(R["media"].font, FONTSIZE, R["media"].fontflag)
		frame.hp.name:SetJustifyH("LEFT")
		frame.hp.name:SetShadowColor(0, 0, 0, 0.4)
		frame.hp.name:SetShadowOffset(R.mult, -R.mult)
		frame.hp.oldname = oldname
	end

	frame.hp:HookScript("OnShow", OnFrameShow)
	frame.healthOriginal:HookScript("OnValueChanged", OnHealthValueChanged)

	--Cast Bar
	frame.castBar = CreateFrame("StatusBar", nil, frame)
	frame.castBar:SetStatusBarTexture(R["media"].normal)
	frame.castBar:SetPoint("TOPLEFT", frame.hp, "BOTTOMLEFT", 0, -5)	
	frame.castBar:SetPoint("TOPRIGHT", frame.hp, "BOTTOMRIGHT", 0, -5)	
	frame.castBar:SetSize(cbWidth, cbHeight)	
	frame.castBar:SetFrameStrata("BACKGROUND")
	frame.castBar:SetFrameLevel(0)
	CreateVirtualFrame(frame.castBar)

	frame.castBar.time = frame.castBar:CreateFontString(nil, "ARTWORK")
	frame.castBar.time:SetPoint("TOPRIGHT", frame.castBar, "BOTTOMRIGHT", 0, -1)
	frame.castBar.time:SetFont(R["media"].font, FONTSIZE, R["media"].fontflag)
	frame.castBar.time:SetJustifyH("RIGHT")
	frame.castBar.time:SetShadowColor(0, 0, 0, 0.4)
	frame.castBar.time:SetTextColor(1, 1, 1)
	frame.castBar.time:SetShadowOffset(R.mult, -R.mult)

	frame.castBar.name = cbtext
	frame.castBar.name:SetParent(frame.castBar)
	frame.castBar.name:ClearAllPoints()
	frame.castBar.name:SetPoint("TOPLEFT", frame.castBar, "BOTTOMLEFT", 0, -1)
	frame.castBar.name:SetFont(R["media"].font, FONTSIZE, R["media"].fontflag)
	frame.castBar.name:SetJustifyH("LEFT")
	frame.castBar.name:SetTextColor(1, 1, 1)
	frame.castBar.name:SetShadowColor(0, 0, 0, 0.4)
	frame.castBar.name:SetShadowOffset(R.mult, -R.mult)

	frame.castBar.icon = cbicon
	frame.castBar.icon:SetParent(frame.castBar)
	frame.castBar.icon:SetTexCoord(.07, .93, .07, .93)
	frame.castBar.icon:SetDrawLayer("OVERLAY")
	frame.castBar.icon:ClearAllPoints()
	frame.castBar.icon:SetSize(20, 20)
	frame.castBar.icon:SetPoint("TOPRIGHT", frame.hp, "TOPLEFT", -3, 0)
	if not frame.castBar.icon.backdrop then
		frame.castBar.icon.backdrop = CreateFrame("Frame", nil ,cb)
		frame.castBar.icon.backdrop:SetAllPoints()
		if R.global.general.theme == "Shadow" then
			frame.castBar.icon.backdrop:SetBackdrop({
				bgFile = R["media"].blank,
				edgeFile = R["media"].glow,
				edgeSize = 3*noscalemult,
				insets = {
					top = 3*noscalemult, left = 3*noscalemult, bottom = 3*noscalemult, right = 3*noscalemult
				}
			})
			frame.castBar.icon.backdrop:SetPoint("TOPLEFT", frame.castBar.icon, -3*noscalemult, 3*noscalemult)
			frame.castBar.icon.backdrop:SetPoint("BOTTOMRIGHT", frame.castBar.icon, 3*noscalemult, -3*noscalemult)
		else
			frame.castBar.icon.backdrop:SetBackdrop({
				bgFile = R["media"].blank,
				edgeFile = R["media"].blank,
				edgeSize = noscalemult,
				insets = {
					top = noscalemult, left = noscalemult, bottom = noscalemult, right = noscalemult
				}
			})
			frame.castBar.icon.backdrop:SetPoint("TOPLEFT", frame.castBar.icon, -noscalemult, noscalemult)
			frame.castBar.icon.backdrop:SetPoint("BOTTOMRIGHT", frame.castBar.icon, noscalemult, -noscalemult)
		end
		frame.castBar.icon.backdrop:SetBackdropColor(.05, .05, .05, .9)
		frame.castBar.icon.backdrop:SetBackdropBorderColor(0, 0, 0, 1)
		if cb:GetFrameLevel() - 1 >0 then
			frame.castBar.icon.backdrop:SetFrameLevel(cb:GetFrameLevel() - 1)
		else
			frame.castBar.icon.backdrop:SetFrameLevel(0)
		end
	end

	if not frame.castBar.shield then
		frame.castBar.shield = frame.castBar:CreateTexture(nil, "ARTWORK")
		frame.castBar.shield:SetTexture("Interface\\AddOns\\RayUI\\media\\shield")
		frame.castBar.shield:SetTexCoord(0, .53125, 0, .6875)

		frame.castBar.shield:SetSize(12, 17)
		frame.castBar.shield:SetPoint("CENTER", frame.castBar, 0, -1)

		frame.castBar.shield:SetBlendMode("BLEND")
		frame.castBar.shield:SetDrawLayer("ARTWORK", 7)
		frame.castBar.shield:SetVertexColor(1, .1, .1)

		frame.castBar.shield:Hide()
	end

	frame.castBar.oldshield = cbshield
	frame.castBar.oldshield:ClearAllPoints()
	frame.castBar.oldshield:SetPoint("TOP", frame.castBar, "BOTTOM")
	cb._parent = frame
	cb:HookScript("OnShow", CastBar_OnShow)
	cb:HookScript("OnHide", CastBar_OnHide)
	cb:HookScript("OnValueChanged", CastBar_OnValueChanged)
	frame.cb = cb

	--Highlight
	overlay:SetParent(frame:GetParent())
	overlay:SetTexture(1,1,1,0.15)
	overlay:SetAllPoints(frame.hp)
	frame.overlay = overlay

	if not frame.targetGlow then
		frame.targetGlow = frame.hp:CreateTexture(nil, "BACKGROUND")
		frame.targetGlow:SetTexture("Interface\\AddOns\\RayUI\\media\\nameplate-target-glow")
		frame.targetGlow:SetTexCoord(0, .593, 0, .875)
		frame.targetGlow:SetPoint("TOPLEFT", frame.hp, "BOTTOMLEFT", 0, 0)
		frame.targetGlow:SetPoint("TOPRIGHT", frame.hp, "BOTTOMRIGHT", 0, 0)
		frame.targetGlow:SetVertexColor(.3, .7, 1, 1)
		-- frame.targetGlow:SetSize(hpWidth, 5)
		frame.targetGlow:SetHeight(5)
		frame.targetGlow:Hide()
	end

	--Reposition and Resize RaidIcon
	raidicon:ClearAllPoints()
	raidicon:SetPoint("BOTTOM", frame.hp, "TOP", 0, 2)
	raidicon:SetSize(iconSize*1.4, iconSize*1.4)
	raidicon:SetTexture([[Interface\AddOns\RayUI\media\raidicons.blp]])
	frame.raidicon = raidicon

	--Heal Icon
	if not frame.healerIcon then
		frame.healerIcon = frame:CreateTexture(nil, 'ARTWORK')
		frame.healerIcon:SetPoint("BOTTOM", frame.hp, "TOP", 0, 16)
		frame.healerIcon:SetSize(35, 35)
		frame.healerIcon:SetTexture([[Interface\AddOns\RayUI\media\healer.tga]])
	end

	--Hide Old Stuff
	QueueObject(frame, oldhp)
	QueueObject(frame, oldlevel)
	QueueObject(frame, threat)
	QueueObject(frame, hpborder)
	QueueObject(frame, cbshield)
	QueueObject(frame, cbborder)
	QueueObject(frame, cbshadow)
	QueueObject(frame, oldname)
	QueueObject(frame, bossicon)
	QueueObject(frame, elite)
	QueueObject(frame, cb)

	OnFrameShow(frame.hp)

	frame:HookScript("OnHide", OnFrameHide)
	frame:GetParent():HookScript("OnUpdate", OnFrameUpdate)
	frames[frame:GetParent()] = true
	frame.RayUIPlate = true

	if not cb:IsShown() then
		frame.castBar:Hide()
	else
		CastBar_OnShow(cb)
	end
end

local function UpdateThreat(frame, elapsed)
	frame.hp:Show()
	if frame.hasClass == true or frame.isTapped == true then return end

	if frame.threat:IsShown() then
		--Ok we either have threat or we're losing/gaining it
		local r, g, b = frame.threat:GetVertexColor()
		if g + b == 0 then
			--Have Threat
			if R.Role == "Tank" then
				frame.hp:SetStatusBarColor(goodR, goodG, goodB)
				frame.hp.hpbg:SetTexture(goodR, goodG, goodB, 0.1)
				--frame.hp.backdrop:SetBackdropBorderColor(0, 0, 0, 1)
				frame.threatStatus = "GOOD"
			else
				frame.hp:SetStatusBarColor(badR, badG, badB)
				frame.hp.hpbg:SetTexture(badR, badG, badB, 0.1)
				--frame.hp.backdrop:SetBackdropBorderColor(badR, badG, badB, 1)
				frame.threatStatus = "BAD"
			end
		else
			--Losing/Gaining Threat
			if R.Role == "Tank" then
				if frame.threatStatus == "GOOD" then
					--Losing Threat
					frame.hp:SetStatusBarColor(transitionR2, transitionG2, transitionB2)
					frame.hp.hpbg:SetTexture(transitionR2, transitionG2, transitionB2, 0.1)
					--frame.hp.backdrop:SetBackdropBorderColor(badR, badG, badB, 1)
				else
					--Gaining Threat
					frame.hp:SetStatusBarColor(transitionR, transitionG, transitionB)
					frame.hp.hpbg:SetTexture(transitionR, transitionG, transitionB, 0.1)
					--frame.hp.backdrop:SetBackdropBorderColor(0, 0, 0, 1)
				end
			else
				if frame.threatStatus == "GOOD" then
					--Losing Threat
					frame.hp:SetStatusBarColor(transitionR, transitionG, transitionB)
					frame.hp.hpbg:SetTexture(transitionR, transitionG, transitionB, 0.1)
					--frame.hp.backdrop:SetBackdropBorderColor(0, 0, 0, 1)
				else
					--Gaining Threat
					frame.hp:SetStatusBarColor(transitionR2, transitionG2, transitionB2)
					frame.hp.hpbg:SetTexture(transitionR2, transitionG2, transitionB2, 0.1)
					--frame.hp.backdrop:SetBackdropBorderColor(badR, badG, badB, 1)
				end
			end
		end
	else
		if InCombatLockdown() and frame.isFriendly ~= true then
			--No Threat
			if R.Role == "Tank" then
				frame.hp:SetStatusBarColor(badR, badG, badB)
				frame.hp.hpbg:SetTexture(badR, badG, badB, 0.1)
				--frame.hp.backdrop:SetBackdropBorderColor(badR, badG, badB, 1)
				frame.threatStatus = "BAD"
			else
				frame.hp:SetStatusBarColor(goodR, goodG, goodB)
				frame.hp.hpbg:SetTexture(goodR, goodG, goodB, 0.1)
				--frame.hp.backdrop:SetBackdropBorderColor(0, 0, 0, 1)
				frame.threatStatus = "GOOD"
			end
		else
			--Set colors to their original, not in combat
			frame.hp:SetStatusBarColor(frame.hp.rcolor, frame.hp.gcolor, frame.hp.bcolor)
			frame.hp.hpbg:SetTexture(frame.hp.rcolor, frame.hp.gcolor, frame.hp.bcolor, 0.1)
			--frame.hp.backdrop:SetBackdropBorderColor(0, 0, 0, 1)
			frame.threatStatus = nil
		end
	end
end

--When becoming intoxicated blizzard likes to re-show the old level text, this should fix that
local function HideDrunkenText(frame, ...)
	if frame and frame.hp.oldlevel and frame.hp.oldlevel:IsShown() then
		frame.hp.oldlevel:Hide()
	end
end

--Force the name text of a nameplate to be behind other nameplates unless it is our target
local function AdjustNameLevel(frame, ...)
	if UnitExists("target") and UnitGUID("target") == frame.guid and frame:GetAlpha() == 1 then
		frame.hp.name:SetDrawLayer("OVERLAY")
	else
		frame.hp.name:SetDrawLayer("ARTWORK")
	end
end

--Health Text, also border coloring for certain plates depending on health
local function ShowHealth(frame, ...)
	-- show current health value
	local minHealth, maxHealth = frame.healthOriginal:GetMinMaxValues()
	local valueHealth = frame.healthOriginal:GetValue()
	local d =(valueHealth/maxHealth)*100

	--Match values
	frame.hp:SetValue(valueHealth - 1)	--Bug Fix 4.1
	frame.hp:SetValue(valueHealth)

	frame.hp.value:SetText(string.format("%d%%", math.floor((valueHealth/maxHealth)*100)))

	--Change frame style if the frame is our target or not
	frame.hp.name:SetTextColor(frame.hp:GetStatusBarColor())

	if UnitExists("target") and UnitGUID("target") == frame.guid and frame:GetAlpha() == 1 then
		--Targetted Unit
		frame.hp.name:SetTextColor(1, 1, 1)
		frame.targetGlow:Show()
	else
		--Not Targetted
		frame.hp.name:SetTextColor(frame.hp:GetStatusBarColor())
		frame.targetGlow:Hide()
	end

	--Setup frame shadow to change depending on enemy players health, also setup targetted unit to have white shadow
	if frame.hasClass == true or frame.isFriendly == true then
		if(d <= 50 and d >= 20) then
			frame.hp.backdrop:SetBackdropBorderColor(1, 1, 0, 1)
		elseif(d < 20) then
			frame.hp.backdrop:SetBackdropBorderColor(1, 0, 0, 1)
		else
			frame.hp.backdrop:SetBackdropBorderColor(0, 0, 0, 1)
		end
	elseif (frame.hasClass ~= true and frame.isFriendly ~= true) then
		frame.hp.backdrop:SetBackdropBorderColor(0, 0, 0, 1)
	end
end

--Scan all visible nameplate for a known unit.
local function CheckUnit_Guid(frame, ...)
	--local numParty, numRaid = GetNumSubgroupMembers(), GetNumGroupMembers()
	if UnitExists("target") and frame:GetParent():GetAlpha() == 1 and UnitName("target") == frame.hp.oldname:GetText() then
		frame.guid = UnitGUID("target")
		frame.unit = "target"
		OnAura(frame, "target")
	elseif frame.overlay:IsShown() and UnitExists("mouseover") and UnitName("mouseover") == frame.hp.oldname:GetText() then
		frame.guid = UnitGUID("mouseover")
		frame.unit = "mouseover"
		OnAura(frame, "mouseover")
	else
		frame.unit = nil
	end
end

--Attempt to match a nameplate with a GUID from the combat log
local function MatchGUID(frame, destGUID, spellID)
	if not frame.guid then return end


	if frame.guid == destGUID then
		for _,icon in ipairs(frame.icons) do
			if icon.spellID == spellID then
				icon:Hide()
			end
		end
	end
end

--Run a function for all visible nameplates, we use this for the blacklist, to check unitguid, and to hide drunken text
local function ForEachPlate(functionToRun, ...)
	for frame in pairs(frames) do
		if frame:IsShown() then
			functionToRun(select(1,frame:GetChildren()), ...)
		end
	end
end

--Check if the frames default overlay texture matches blizzards nameplates default overlay texture
local function HookFrames(...)
	for index = 1, select("#", ...) do
		local frame = select(index, ...)

		if(not frames[frame] and (frame:GetName() and frame:GetName():find("NamePlate%d"))) then
			SkinObjects(frame:GetChildren())
		end
	end
end

function NP:COMBAT_LOG_EVENT_UNFILTERED(_, _, event, ...)
	if event == "SPELL_AURA_REMOVED" or event == "SPELL_AURA_BROKEN" or event == "SPELL_AURA_BROKEN_SPELL" then
		local _, sourceGUID, _, _, _, destGUID, _, _, _, spellID = ...

		if sourceGUID == UnitGUID("player") then
			ForEachPlate(MatchGUID, destGUID, spellID)
		end
	end
end

function NP:PLAYER_ENTERING_WORLD()
	SetCVar("threatWarning", 3)
	SetCVar("bloatthreat", 0)
	SetCVar("bloattest", 1)
	SetCVar("ShowClassColorInNameplate", 1)
	SetCVar("bloatnameplates", 0)
	if NP.db.combat then
		if InCombatLockdown() then
			SetCVar("nameplateShowEnemies", 1)
		else
			SetCVar("nameplateShowEnemies", 0)
		end
	end
	wipe(BattleGroundHealers)
	local inInstance, instanceType = IsInInstance()
	if inInstance and instanceType == "pvp" and self.db.showhealer then
		self.CheckHealerTimer = self:ScheduleRepeatingTimer("CheckHealers", 3)
		self:CheckHealers()
	else
		if self.CheckHealerTimer then
			self:CancelTimer(self.CheckHealerTimer)
			self.CheckHealerTimer = nil
		end
	end
	PlayerFaction = UnitFactionGroup("player")
end

function NP:PLAYER_REGEN_ENABLED()
	SetCVar("nameplateShowEnemies", 0)
end

function NP:PLAYER_REGEN_DISABLED()
	SetCVar("nameplateShowEnemies", 1)
end

function NP:Info()
	return L["|cff7aa6d6Ray|r|cffff0000U|r|cff7aa6d6I|r姓名板模块."]
end

function NP:Initialize()
	self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	self:RegisterEvent("PLAYER_ENTERING_WORLD")
	if self.db.combat then
		self:RegisterEvent("PLAYER_REGEN_ENABLED")
		self:RegisterEvent("PLAYER_REGEN_DISABLED")
	end
	CreateFrame("Frame"):SetScript("OnUpdate", function(self, elapsed)
		if(WorldFrame:GetNumChildren() ~= numChildren) then
			numChildren = WorldFrame:GetNumChildren()
			HookFrames(WorldFrame:GetChildren())
		end

		ForEachPlate(ShowHealth)
		ForEachPlate(HideDrunkenText)
		ForEachPlate(CheckUnit_Guid)
		ForEachPlate(UpdateColoring)

		if(self.elapsed and self.elapsed > 0.2) then
			ForEachPlate(UpdateThreat, self.elapsed)
			ForEachPlate(AdjustNameLevel)
			self.elapsed = 0
		else
			self.elapsed = (self.elapsed or 0) + elapsed
		end

		ForEachPlate(CheckFilter)
	end)
end

R:RegisterModule(NP:GetName())
