local addon = select(2, ...)
local l = addon.locale
local view = {}
addon.views["Sets"] = view
view.first = 1

function view:Init()
	addon.window:SetTitle(l.sel_set, .1, .1, .1)
	addon.window:SetBackAction(nil)
end

local detailAction = function(f)
	addon.nav.view = "Type"
	addon.nav.set = f.id
	addon:RefreshDisplay()
end

local setLine = function(lineid, setid, title)
	local set = addon:GetSet(setid)
	local line = addon.window:GetLine(lineid)
	line:SetValues(1, 1)
	if title then
		line:SetLeftText(title)
	else
		line:SetLeftText("%i. %s", setid, set.name)
	end
	local datetext, timetext = addon:GetDuration(set)
	if datetext then
		line:SetRightText("%s  %s", timetext, datetext)
	else
		line:SetRightText("")
	end
	line:SetColor(.3, .3, .3)
	line.id = setid
	line:SetDetailAction(detailAction)
	line:Show()
end

function view:Update()
	setLine(0, "total", " "..l.overall)
	setLine(1, "current", " "..l.current)

	self.first, self.last = addon:GetArea(self.first, #NumerationCharDB+2)
	if not self.last then return end

	for i = self.first, self.last-2 do
		t = NumerationCharDB[i]
		setLine(i-self.first+2, i)
	end
end