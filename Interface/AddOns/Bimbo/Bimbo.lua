
local tip = BimboScanTip

local links = {}
local slots = {"BackSlot", "ChestSlot", "FeetSlot", "Finger0Slot", "Finger1Slot", "HandsSlot", "HeadSlot", "LegsSlot", "MainHandSlot", "NeckSlot", "SecondaryHandSlot", "ShoulderSlot", "Trinket0Slot", "Trinket1Slot", "WaistSlot", "WristSlot"}
local enchantables = {BackSlot = true, Finger0Slot = true, Finger1Slot = true, NeckSlot = true, MainHandSlot = true}
local _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, wands = GetAuctionItemSubClasses(1)


local function GetSocketCount(link, slot, unit)
	local num, filled = 0, 0
	if slot then
		local slotid = GetInventorySlotInfo(slot)
		tip:SetInventoryItem(unit, slotid)
	else
		tip:SetHyperlink(link)
	end
	for i=1,10 do if tip.icon[i] then num = num + 1 end end

	for i=1,num do
		if GetItemGem(link, i) then filled = filled + 1 end
	end

	return num, filled
end


local parentframes = {}
local meta = {
	__index = function(t,i)
		local slot = _G[parentframes[t]..i]
		local shine = LibStub("tekShiner").new(slot, 1, 0, 0)
		shine:SetAllPoints(slot)
		t[i] = shine
		return shine
	end
}
local playerGlows, inspectGlows = setmetatable({}, meta), setmetatable({}, meta)
parentframes[playerGlows], parentframes[inspectGlows] = "Character", "Inspect"

local function Check(unit, report)
	local glows = unit == "target" and inspectGlows or playerGlows
	local isplayer = unit == "player"
	local level = UnitLevel(unit)

	for i in pairs(links) do links[i] = nil end
	for _,v in pairs(slots) do links[v] = GetInventoryItemLink(unit, GetInventorySlotInfo(v)) end
	for _,f in pairs(glows) do f:Hide() end

	if links.SecondaryHandSlot then
		-- Can't enchant offhand frills
		local _, _, _, _, _, _, _, _, slottype = GetItemInfo(links.SecondaryHandSlot)
		enchantables.SecondaryHandSlot = slottype ~= "INVTYPE_HOLDABLE"
	end

	local found = false
	for slot,check in pairs(enchantables) do
		local link = check and links[slot]
		if link and link:match("item:%d+:0") then
			found = true
			glows[slot]:Show()
			if report then print(link, "没有附魔") end
		end
	end

	for slot,link in pairs(links) do
		local num, filled = GetSocketCount(link, slot, unit)
		if filled < num then
			found = true
			glows[slot]:Show()
			if report then print(link, "没有宝石") end
		end
	end

	if not found and report then print("所有的装备都已经附魔并且镶嵌宝石") end
end



local butt = LibStub("tekKonfig-Button").new_small(PaperDollFrame, "BOTTOMLEFT", 12, 12)
butt:SetWidth(45) butt:SetHeight(18)
butt:SetText("Bimbo")
butt:SetScript("OnEvent", function(self, event, ...) self[event](self, event, ...) end)
butt:SetScript("OnShow", function() Check("player") end)
butt:SetScript("OnClick", function() Check("player", true) end)
butt:SetScript("OnLeave", function() GameTooltip:Hide() end)
butt:SetScript("OnEnter", function(self)
	GameTooltip:SetOwner(self, "ANCHOR_NONE")
	GameTooltip:SetPoint("TOPLEFT", self, "BOTTOMLEFT")
	GameTooltip:ClearLines()
	GameTooltip:SetText("点击以显示没有附魔及镶嵌宝石的装备。")
	GameTooltip:Show()
end)


function butt:UNIT_INVENTORY_CHANGED(event, unit)
	if unit == "player" and self:IsVisible() then Check("player") end
end
butt:RegisterEvent("UNIT_INVENTORY_CHANGED")


function butt:PLAYER_TARGET_CHANGED()
	if InspectFrame and InspectFrame:IsVisible() then Check("target") end
end

function butt:PLAYER_ENTERING_WORLD()
	local S = unpack(RayUI):GetModule("Skins")
	S:Reskin(butt)
	butt:UnregisterEvent("PLAYER_ENTERING_WORLD")
end
butt:RegisterEvent("PLAYER_ENTERING_WORLD")

function butt:ADDON_LOADED(event, addon)
	if addon ~= "Blizzard_InspectUI" then return end

	local butt2 = LibStub("tekKonfig-Button").new_small(InspectPaperDollItemsFrame, "BOTTOMLEFT", 12, 12)
	butt2:SetText("Bimbo")
	butt2:SetWidth(45) butt2:SetHeight(18)
	butt2:SetScript("OnShow", butt.PLAYER_TARGET_CHANGED)
	butt2:SetScript("OnClick", function() Check("target", true) end)
	butt2:SetScript("OnEnter", butt:GetScript("OnEnter"))
	butt2:SetScript("OnLeave", butt:GetScript("OnLeave"))

	self:RegisterEvent("PLAYER_TARGET_CHANGED")
	self:UnregisterEvent("ADDON_LOADED")
	self.ADDON_LOADED = nil
end
butt:RegisterEvent("ADDON_LOADED")


if IsLoggedIn() and butt:IsVisible() then Check("player") end
if IsAddOnLoaded("Blizzard_InspectUI") and butt.ADDON_LOADED then butt:ADDON_LOADED("ADDON_LOADED", "Blizzard_InspectUI") end
