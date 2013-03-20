
local myname, Cork = ...
local UnitAura = UnitAura
local ldb, ae = LibStub:GetLibrary("LibDataBroker-1.1"), LibStub("AceEvent-3.0")


local spellname, _, icon = GetSpellInfo(57139)
local spellname2 = GetSpellInfo(44102)

local iconline = Cork.IconLine(icon, spellname)

local dataobj = LibStub:GetLibrary("LibDataBroker-1.1"):NewDataObject("Cork "..spellname, {
	type = "cork",
	priority = 7,
	tiptext = "Warn when you are not well fed.",
	nobg = true,
})

Cork.defaultspc[spellname.."-enabled"] = UnitLevel("player") >= 10

local function Test(unit) if Cork.dbpc[spellname.."-enabled"] and not (UnitAura("player", spellname) or UnitAura("player", spellname2)) and not (IsResting() and not Cork.db.debug) then return iconline end end

LibStub("AceEvent-3.0").RegisterEvent("Cork "..spellname, "UNIT_AURA", function(event, unit) if unit == "player" then dataobj.custom = Test() end end)
LibStub("AceEvent-3.0").RegisterEvent("Cork "..spellname, "PLAYER_UPDATE_RESTING", function() dataobj.custom = Test() end)

function dataobj:Scan() self.custom = Test() end

function dataobj:CorkIt(frame)
	local macro = Cork.dbpc[spellname.."-macro"]
	local id = Cork.dbpc[spellname.."-item"]
	if self.custom and id and GetItemCount(id) > 0 then
		return frame:SetManyAttributes("type1", "item", "item1", "item:"..id)
	end
end


----------------------
--      Config      --
----------------------

local frame = CreateFrame("Frame", nil, Cork.config)
frame:SetWidth(1) frame:SetHeight(1)
dataobj.configframe = frame
frame:Hide()

frame:SetScript("OnShow", function()
	local EDGEGAP, ROWHEIGHT, ROWGAP, GAP = 16, 18, 2, 4
	local Update
	local FOOD = GetAuctionItemSubClasses(4)

	local function GetFoods()
		local t = {}
		local mylevel = UnitLevel('player')

		if Cork.dbpc[spellname.."-item"] then
			t[Cork.dbpc[spellname.."-item"]] = true
		end

		for bag=0,4 do
			for slot=1,GetContainerNumSlots(bag) do
				local id = GetContainerItemID(bag, slot)
				if id then
					local _, _, _, _, reqlevel, _, subtype = GetItemInfo(id)
					if subtype == FOOD and reqlevel <= mylevel then t[id] = true end
				end
			end
		end

		local sorted = {}
		for i in pairs(t) do table.insert(sorted, i) end
		table.sort(sorted)
		return sorted
	end

	local function OnClick(self)
		Cork.dbpc[spellname.."-item"] = self.itemid
		Update()
		dataobj:Scan()
	end

	local function OnEnter(self)
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:SetHyperlink("item:"..self.itemid)
	end
	local function OnLeave() GameTooltip:Hide() end


	local buffbuttons = setmetatable({}, {__index = function(t, i)
		local butt = CreateFrame("CheckButton", nil, frame)
		butt:SetWidth(ROWHEIGHT) butt:SetHeight(ROWHEIGHT)

		local tex = butt:CreateTexture(nil, "BACKGROUND")
		tex:SetAllPoints()
		tex:SetTexCoord(4/48, 44/48, 4/48, 44/48)
		butt.icon = tex

		butt:SetPushedTexture("Interface\\Buttons\\UI-Quickslot-Depress")
		butt:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square")
		butt:SetCheckedTexture("Interface\\Buttons\\CheckButtonHilight")

		butt:SetScript("OnClick", OnClick)
		butt:SetScript("OnEnter", OnEnter)
		butt:SetScript("OnLeave", OnLeave)

		t[i] = butt
		return butt
	end})

	function Update(self)
		for _,f in pairs(buffbuttons) do f:Hide(); f:ClearAllPoints() end
		local foods = GetFoods()
		local lasticon
		for i,id in ipairs(foods) do
			local butt = buffbuttons[id]
			butt.icon:SetTexture(GetItemIcon(id))
			butt:SetChecked(Cork.dbpc[spellname.."-item"] == id)
			butt:Show()
			if lasticon then lasticon:SetPoint("RIGHT", butt, "LEFT", -ROWGAP, 0) end
			lasticon, butt.itemid = butt, id
		end
		if lasticon then lasticon:SetPoint("RIGHT", 0, 0) end
	end

	frame:SetScript("OnShow", Update)
	Update(frame)
end)
