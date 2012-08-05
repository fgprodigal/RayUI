local addon = select(2, ...)
local view = {}
addon.views["Type"] = view
view.first = 1

local backAction = function(f)
	view.first = 1
	addon.nav.view = "Sets"
	addon.nav.set = nil
	addon:RefreshDisplay()
end

local detailAction = function(f)
	addon.nav.view = addon.types[f.typeid].view or "Units"
	addon.nav.type = f.typeid
	addon:RefreshDisplay()
end

function view:Init()
	addon.window:SetTitle("选择: 类型", .1, .1, .1)
	addon.window:SetBackAction(backAction)
end

function view:Update()
	local set = addon:GetSet(addon.nav.set)
	if not set then return end
	
	local num = #addon.types
	if addon.nav.set == "total" then
		for i,t in pairs(addon.types) do
			if t.onlyfights then
				num = num -1
			end
		end
	end
	self.first, self.last = addon:GetArea(self.first, num)
	if not self.last then return end
	
	local id = self.first - 1
	for i = self.first, self.last do
		id = id + 1
		local t = addon.types[id]
		if addon.nav.set == "total" then
			while t.onlyfights do
				id = id + 1
				t = addon.types[id]
			end
		end

		local amount = set[t.id] and set[t.id].total or 0
		if t.id2 and set[t.id2] then
			amount = amount + set[t.id2].total
		end
		for name, u in pairs(set.unit) do
			if u[t.id] then
				amount = amount + u[t.id].total
			end
			if t.id2 and u[t.id2] then
				amount = amount + u[t.id2].total
			end
		end
		
		local line = addon.window:GetLine(i-self.first)
		local c = t.c
		
		line:SetValues(1, 1)
		line:SetLeftText(" %s", t.name)
		if amount ~= 0 then
			line:SetRightText(addon:ModNumber(amount))
		else
			line:SetRightText("")
		end
		line:SetColor(c[1], c[2], c[3])
		line.typeid = id
		line:SetDetailAction(detailAction)
		line:Show()
	end
end
