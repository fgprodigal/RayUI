
local myname, ns = ...
local IconLine = ns.IconLine
local ldb, ae = LibStub:GetLibrary("LibDataBroker-1.1"), LibStub("AceEvent-3.0")


local function scan(self)
	if not ns.dbpc[self.name.."-enabled"] then
		self.player = nil
		return
	end

	local count, lastname, lasticon = 0
	for _,id in pairs(self.items) do
		local num = GetItemCount(id)
		if num and num > 0 then
			local name, _, _, _, _, _, _, _, _, texture = GetItemInfo(id)
			lastname, lasticon = name, texture
			count = count + num
		end
	end

	if count > 0 then self.player = IconLine(lasticon, lastname.." ("..count..")")
	else self.player = nil end
end


local function corkit(self, frame)
	for _,id in pairs(self.items) do
		if (GetItemCount(id) or 0) > 0 then
			return frame:SetManyAttributes("type1", "item", "item1", "item:"..id)
		end
	end
end


function ns.InitItemOpener(self)
	ns.defaultspc[self.name.."-enabled"] = true
	self.CorkIt = corkit
	self.Scan = scan
	ae.RegisterEvent(self, "BAG_UPDATE", "Scan")
end
