local addon = select(2, ...)
local view = {}
addon.views["Deathlog"] = view
view.first = 1

local spellIcon = addon.spellIcon
local spellName = addon.spellName
local colorhex = addon.colorhex

local backAction = function(f)
	view.first = 1
	addon.nav.view = "Type"
	addon.nav.type = nil
	addon:RefreshDisplay()
end

local detailAction = function(f)
	addon.nav.view = "Deathlog-Detail"
	addon.nav.id = f.id
	addon:RefreshDisplay()
end

function view:Init()
	local v = addon.types[addon.nav.type]
	local c = v.c
	addon.window:SetTitle(v.name, c[1], c[2], c[3])
	addon.window:SetBackAction(backAction)
end

local schoolColor = {
	["1"] = "FFFFFF", -- physical		1,1,1
	["2"] = "FFFFA0", -- holy			1,1,0.627
	["4"] = "FF4D00", -- fire			1,0.5,0.5 // 1,0.3,0
	["8"] = "80FF80", -- nature			0.5,1,0.5
	["16"] = "669AE6", -- frost			0.5,0.5,1 // 0.4,0.6,0.9
	["20"] = "D35779", -- frostfire		0.824,0.314,0.471
--	["24"] = "FFFFFF", -- froststorm	
	["32"] = "A100A1", -- shadow		0.628,0,0.628
--	["40"] = "FFFFFF", -- shadowstorm	
--	["48"] = "FFFFFF", -- shadowfrost	
	["64"] = "FFBAFF", -- arcane		1, 0.725, 1
}
local eventColors = {
	DEATH = {.66, .25, .25},
	REZZ = {.25, .5, .85},
}
local eventInfo = {}
eventInfo.DEATH = function(event, playerName, class, spellId, srcName, spellSchool, amount)
	local icon
	local text
	if spellId == "" then
		spellId = nil
		icon = [[Interface\TargetingFrame\UI-TargetingFrame-Skull]]
		text = string.format("|cff%s%s|r", colorhex[class], playerName)
	else
		spellId = tonumber(spellId) or spellId
		icon = spellIcon[spellId] or ""
		text = string.format("|cff%s%s|r < |cffFF0000%+d|r [%s - |cff%s%s|r]", colorhex[class], playerName, -tonumber(amount), srcName, schoolColor[spellSchool] or "FFFF00", spellName[spellId])
	end
	return icon, text, spellId
end
eventInfo.REZZ = function(event, playerName, class, spellId, rezzerName)
	spellId = tonumber(spellId)
	local icon = spellIcon[spellId]
	local text = string.format("|cff%s%s|r < [%s - |cff4080D9%s|r]", colorhex[class], playerName, rezzerName, spellName[spellId])
	return icon, text, spellId
end
function view:Update()
	local set = addon:GetSet(addon.nav.set)
	if not set then return end
	local dl = set.deathlog
	if not dl then return end
	
	-- display
	self.first, self.last = addon:GetArea(self.first, #dl)
	if not self.last then return end

	local total = set.start and set.now and (set.now-set.start) or 1
	for i = self.first, self.last do
		local entry = dl[i]
		local line = addon.window:GetLine(i-self.first)
		
		local playerName, class, event, info = strsplit("#", entry[0])
		local icon, text, spellId = eventInfo[event](event, playerName, class, strsplit(":", info))
		local c = eventColors[event]
		
		line:SetValues(set.start and (entry.time-set.start) or 1, total)
		line:SetIcon(icon)
		line.spellId = spellId
		line:SetLeftText(text)
		line:SetRightText("")
		if set.start then
			line:SetRightText("%.1fs", entry.time-set.start)
		else
			line:SetRightText("")
		end
		line:SetColor(c[1], c[2], c[3])
		if entry[1] then
			line.id = i
			line:SetDetailAction(detailAction)
		else
			line:SetDetailAction(nil)
		end
		line:Show()
	end
end
