
local tip = CreateFrame("GameTooltip", "BimboScanTip", nil, "GameTooltipTemplate")
tip:SetOwner(WorldFrame, "ANCHOR_NONE")


local tcache = {}
for i=1,30 do tcache[i] = _G["BimboScanTipTexture"..i] end


tip.icon = setmetatable({}, {
	__index = function(t, key)
		if tip:NumLines() >= key and tcache[key] then
			local v = tcache[key]:GetTexture()
			t[key] = v
			return v
		end
		return nil
	end,
})


for _,m in pairs{"SetHyperlink", "SetInventoryItem"} do
	local orig = tip[m]
	tip[m] = function(self, ...)
		self:ClearLines()
		for i in pairs(self.icon) do self.icon[i] = nil end
		for i in pairs(tcache) do tcache[i]:SetTexture(nil) end
		if not self:IsOwned(WorldFrame) then self:SetOwner(WorldFrame, "ANCHOR_NONE") end

		return orig(self, ...)
	end
end
