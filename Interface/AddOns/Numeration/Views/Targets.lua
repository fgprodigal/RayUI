local addon = select(2, ...)
local view = {}
addon.views["Targets"] = view
view.first = 1

local backAction = function(f)
	view.first = 1
	addon.nav.view = "Type"
	addon.nav.type = nil
	addon:RefreshDisplay()
end

local detailAction = function(f)
	addon.nav.view = "TargetUnits"
	addon.nav.target = f.target
	addon:RefreshDisplay()
end

function view:Init()
	local v = addon.types[addon.nav.type]
	local c = v.c
	addon.window:SetTitle(v.name, c[1], c[2], c[3])
	addon.window:SetBackAction(backAction)
end

local sorttbl = {}
local targetToValue = {}
local sorter = function(n1, n2)
	return targetToValue[n1] > targetToValue[n2]
end

local updateTables = function(set, etype)
	local total = 0
	for name,u in pairs(set.unit) do
		if u[etype] then
			total = total + u[etype].total
			if u[etype].target then
				for target,amount in pairs(u[etype].target) do
					if targetToValue[target] then
						targetToValue[target] = targetToValue[target] + amount
					else
						targetToValue[target] = amount
						tinsert(sorttbl, target)
					end
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
	local maxvalue = targetToValue[sorttbl[1]]
	for i = self.first, self.last do
		local target = sorttbl[i]
		local value = targetToValue[target]
		
		local line = addon.window:GetLine(i-self.first)
		line:SetValues(value, maxvalue)
		line:SetLeftText("%i. %s", i, target)
		line:SetRightText("%s (%02.1f%%)", addon:ModNumber(value), value/total*100)
		line:SetColor(c[1], c[2], c[3])
		line.target = target
		line:SetDetailAction(detailAction)
		line:SetReportNumber(i)
		line:Show()
	end
	
	sorttbl = wipe(sorttbl)
	targetToValue = wipe(targetToValue)
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
		local target = sorttbl[i]
		local value = targetToValue[target]
		
		addon:PrintLine("%i. %s  %s (%02.1f%%)", i, target, addon:ModNumber(value), value/total*100)
	end
	
	sorttbl = wipe(sorttbl)
	targetToValue = wipe(targetToValue)
end
