local addon = select(2, ...)
local view = {}
addon.views["Spells"] = view
view.first = 1

local spellName = addon.spellName
local spellIcon = addon.spellIcon

local backAction = function(f)
	view.first = 1
	addon.nav.view = "Type"
	addon.nav.type = nil
	addon:RefreshDisplay()
end

local detailAction = function(f)
	addon.nav.view = "SpellUnits"
	addon.nav.spell = f.spell
	addon:RefreshDisplay()
end

function view:Init()
	local v = addon.types[addon.nav.type]
	local c = v.c
	addon.window:SetTitle(v.name, c[1], c[2], c[3])
	addon.window:SetBackAction(backAction)
end

local sorttbl = {}
local spellToValue = {}
local sorter = function(s1, s2)
	return spellToValue[s1] > spellToValue[s2]
end

local updateTables = function(set, etype)
	local total = 0
	for name,u in pairs(set.unit) do
		if u[etype] then
			total = total + u[etype].total
			for id,amount in pairs(u[etype].spell) do
				if spellToValue[id] then
					spellToValue[id] = spellToValue[id] + amount
				else
					spellToValue[id] = amount
					tinsert(sorttbl, id)
				end
			end
		end
	end
	table.sort(sorttbl, sorter)
	return total
end

function view:Update(merged)
	local set = addon:GetSet(addon.nav.set)
	if not set then return end
	local etype = addon.types[addon.nav.type].id

	-- compile and sort information table
	local total = updateTables(set, etype)

	-- display
	self.first, self.last = addon:GetArea(self.first, #sorttbl)
	if not self.last then return end

	local c = addon.types[addon.nav.type].c
	local maxvalue = spellToValue[sorttbl[1]]
	for i = self.first, self.last do
		local id = sorttbl[i]
		local value = spellToValue[id]
		local name, icon = spellName[id], spellIcon[id]

		if name == nil then
			name = id
			icon = [[Interface\Icons\inv_misc_questionmark]]
		elseif id == 0 then
			icon = ""
		end

		local line = addon.window:GetLine(i-self.first)
		line:SetValues(value, maxvalue)
		line:SetLeftText("%i. %s", i, name)
		line:SetRightText("%s (%02.1f%%)", addon:ModNumber(value), value/total*100)
		line:SetColor(c[1], c[2], c[3])
		line:SetIcon(icon)
		line.spellId = id
		line.spell = id
		line:SetDetailAction(detailAction)
		line:SetReportNumber(i)
		line:Show()
	end

	sorttbl = wipe(sorttbl)
	spellToValue = wipe(spellToValue)
end

function view:Report(merged, num_lines)
	local set = addon:GetSet(addon.nav.set)
	if not set then return end
	local etype = addon.types[addon.nav.type].id

	-- compile and sort information table
	local total = updateTables(set, etype)
	if #sorttbl == 0 then return end
	if #sorttbl < num_lines then
		num_lines = #sorttbl
	end

	-- display
	addon:PrintHeaderLine(set)
	for i = 1, num_lines do
		local value = spellToValue[sorttbl[i]]
		local name = GetSpellLink(sorttbl[i]) or "["..sorttbl[i].."]"

		addon:PrintLine("%i. %s  %s (%02.1f%%)", i, name, addon:ModNumber(value), value/total*100)
	end

	sorttbl = wipe(sorttbl)
	spellToValue = wipe(spellToValue)
end
