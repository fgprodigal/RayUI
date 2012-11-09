local addon = select(2, ...)
local view = {}
local l = addon.locale
addon.views["Deathlog-Detail"] = view
view.first = 999

local spellIcon = addon.spellIcon
local spellName = addon.spellName
local colorhex = addon.colorhex

local backAction = function(f)
	view.first = 999
	addon.nav.view = "Deathlog"
	addon.nav.id = nil
	addon:RefreshDisplay()
end

function view:Init()
	local v = addon.types[addon.nav.type]
	addon.window:SetTitle(v.name, v.c[1], v.c[2], v.c[3])
	addon.window:SetBackAction(backAction)

	local set = addon:GetSet(addon.nav.set)
	if not set then return end
	local dl = set.deathlog
	if not dl then return end
	local entry = dl[addon.nav.id]
	if not entry then return end

	local playerName = strsplit("#", entry[0])
	addon.window:SetTitle(format("%s: %s", v.name, playerName), v.c[1], v.c[2], v.c[3])
end

local schoolColor = {
	["1"] = "FFFFFF",	-- Physical
	["2"] = "FFE680",	-- Holy
	["4"] = "FF8000",	-- Fire
	["8"] = "4DFF4D",	-- Nature
	["16"] = "80FFFF",	-- Frost
	["20"] = "CC3399",	-- Frostfire
	["32"] = "8080FF",	-- Shadow
	["64"] = "FF80FF",	-- Arcane
}

local eventColors = {
	DT = {.66, .25, .25},
	HT = {.25, .66, .35},
}
local eventText = {}
eventText.DT = function(event, spellId, srcName, spellSchool, amount, overkill, resisted, blocked, absorbed, modifier)
	overkill = (overkill~="") and string.format("|cff943DA1>%s|r", overkill) or ""
	absorbed = (absorbed~="") and string.format("|cffFFFF00-%s|r", absorbed) or ""
	blocked = (blocked~="") and string.format("|cffAAAAAA-%s|r", blocked) or ""
	resisted = (resisted~="") and string.format("|cff800080-%s|r", resisted) or ""
	return string.format("|cffFF0000%+7d%s|r%s%s%s%s [%s - |cff%s%s|r]", -tonumber(amount), modifier, overkill, absorbed, blocked, resisted, srcName, schoolColor[spellSchool] or "FFFF00", spellName[spellId] or spellId)
end
eventText.DM = function(event, spellId, srcName, spellSchool, missType, amountMissed)
	return string.format("  |cffAAAAAA%s|r [%s - |cff%s%s|r]", missType, srcName, schoolColor[spellSchool] or "FFFF00", spellName[spellId] or spellId)
end
eventText.HT = function(event, spellId, srcName, amount, overhealing, modifier)
	overhealing = (overhealing~="") and string.format("|cff00B480>%i|r", overhealing) or ""
	return string.format("|cff00FF00%+7d%s|r%s [%s - %s]", amount, modifier, overhealing, srcName, spellName[spellId] or spellId)
end
eventText.AB = function(event, spellId, modifier, stacks)
	stacks = (stacks~="") and string.format(" (%s)", stacks) or ""
	return string.format("    %s|cff%s[%s]|r%s", modifier, (event == "AB") and "B2B200" or "008080", spellName[spellId] or spellId, stacks)
end
eventText.AD = eventText.AB
eventText.X = function(event, spellId)
	return "    "..l.death
end
function view:Update()
	local set = addon:GetSet(addon.nav.set)
	if not set then return end
	local dl = set.deathlog
	if not dl then return backAction() end
	local dld = dl[addon.nav.id]
	if not dld then return backAction() end

	-- display
	self.first, self.last = addon:GetArea(self.first, #dld)
	if not self.last then return end

	for i = self.first, self.last do
		local entry = dld[i]
		local line = addon.window:GetLine(i-self.first)

		local rtime, healthpct, spellId, event, info = strsplit("#", entry)
		spellId = tonumber(spellId) or spellId
		healthpct = tonumber(healthpct)
		local text = eventText[event](event, spellId, strsplit(":", info))
		local c = eventColors[event]
		local icon = spellIcon[spellId] or ""

		if c == nil then
			line:SetValues(100, 100)
			line:SetColor(.2, .2, .2)
		else
			line:SetValues(healthpct, 100)
			line:SetColor(c[1], c[2], c[3])
		end
		line:SetIcon(icon)
		line.spellId = spellId ~= 0 and spellId or nil
		line:SetLeftText("|cffAAAAAA%s|r%s", rtime, text)
		line:SetRightText("%s%%", healthpct)
		line:SetDetailAction(nil)
		line:SetReportNumber(#dld-i+1)
		line:Show()
	end
end

local reportText = {}
reportText.DT = function(event, spellId, srcName, spellSchool, amount, overkill, resisted, blocked, absorbed, modifier)
	overkill = (overkill~="") and string.format(">%s", overkill) or ""
	absorbed = (absorbed~="") and string.format(ABSORB_TRAILER, absorbed) or ""
	blocked = (blocked~="") and string.format(BLOCK_TRAILER, blocked) or ""
	resisted = (resisted~="") and string.format(RESIST_TRAILER, resisted) or ""
	return string.format("%+d%s%s%s%s%s [%s - %s]", -tonumber(amount), modifier, overkill, absorbed, blocked, resisted, srcName, GetSpellLink(spellId) or spellName[spellId] or spellId)
end
reportText.DM = function(event, spellId, srcName, spellSchool, missType, amountMissed)
	return string.format("%s [%s - %s]", missType, srcName, GetSpellLink(spellId) or spellName[spellId] or spellId)
end
reportText.HT = function(event, spellId, srcName, amount, overhealing, modifier)
	overhealing = (overhealing~="") and string.format(">%i", overhealing) or ""
	return string.format("%+d%s%s [%s - %s]", amount, modifier, overhealing, srcName, GetSpellLink(spellId) or spellName[spellId] or spellId)
end
reportText.AB = function(event, spellId, modifier, stacks)
	stacks = (stacks~="") and string.format(" (%s)", stacks) or ""
	return string.format("%s%s%s", modifier, GetSpellLink(spellId) or spellName[spellId] or spellId, stacks)
end
reportText.AD = reportText.AB
reportText.X = function(event, spellId)
	return l.death
end
function view:Report(merged, num_lines)
	local set = addon:GetSet(addon.nav.set)
	local dld = set.deathlog[addon.nav.id]

	if #dld == 0 then return end
	if #dld < num_lines then
		num_lines = #dld
	end

	-- display
	addon:PrintHeaderLine(set)
	for i = 1, num_lines do
		local entry = dld[#dld-num_lines+i]

		local rtime, healthpct, spellId, event, info = strsplit("#", entry)
		spellId = tonumber(spellId) or spellId
		healthpct = tonumber(healthpct)
		local text = reportText[event](event, spellId, strsplit(":", info))

		addon:PrintLine("%s -- %s%%  %s", rtime, healthpct, text)
	end
end