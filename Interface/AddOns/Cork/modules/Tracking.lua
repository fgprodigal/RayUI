
local myname, Cork = ...
local SpellCastableOnUnit, IconLine = Cork.SpellCastableOnUnit, Cork.IconLine
local ldb, ae = LibStub:GetLibrary("LibDataBroker-1.1"), LibStub("AceEvent-3.0")

local NOTRACKING = "Interface\\Minimap\\Tracking\\None"
local textures, spells = {}, {}


local dataobj = LibStub:GetLibrary("LibDataBroker-1.1"):NewDataObject("Cork Tracking", {type = "cork", tiptext = "Warn when you are not tracking anything on the minimap."})

local function Test()
	if not Cork.dbpc["Tracking-enabled"] then return end

	for i=1,GetNumTrackingTypes() do
		local name, texture, active, category = GetTrackingInfo(i)
		if active and category == "spell" then return
		elseif active then return IconLine(textures[Cork.dbpc["Tracking-spell"]], Cork.dbpc["Tracking-spell"]) end
	end
	return IconLine(textures[Cork.dbpc["Tracking-spell"]], Cork.dbpc["Tracking-spell"])
--~ 	local x = GetTrackingTexture()
--~ 	if x == mybuff then return end
end

local function UpdateSpells()
	for i in pairs(spells) do spells[i] = nil end
	for i=1,GetNumTrackingTypes() do
		local name, texture, active, category = GetTrackingInfo(i)
		textures[name] = texture
		if category == "spell" then table.insert(spells, name) end
	end
end

function dataobj:Init()
	local name, texture, active, category = GetTrackingInfo(1)
	Cork.defaultspc["Tracking-enabled"] = category ~= "other"
	Cork.defaultspc["Tracking-spell"] = name
	UpdateSpells()
end
function dataobj:Scan() dataobj.player = Test() end

ae.RegisterEvent("Cork Tracking", "MINIMAP_UPDATE_TRACKING", dataobj.Scan)

function dataobj:CorkIt(frame)
	local spell = Cork.dbpc["Tracking-spell"]
	local id
	for i = 1, GetNumTrackingTypes() do
		if GetTrackingInfo(i) == spell then
			id = i
			break
		end
	end
	if id then
		if self.player then return frame:SetManyAttributes("type1", "macro", "macrotext1", "/run SetTracking("..id..", true)") end
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

	local function OnClick(self)
		Cork.dbpc["Tracking-spell"] = self.spell
		Update()
		dataobj:Scan()
	end

	local function OnEnter(self)
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:SetText(self.spell, nil, nil, nil, nil, true)
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
		local lasticon
		for i,spell in ipairs(spells) do
			local butt = buffbuttons[i]
			butt.icon:SetTexture(textures[spell])
			butt:SetChecked(Cork.dbpc["Tracking-spell"] == spell)
			if lasticon then lasticon:SetPoint("RIGHT", butt, "LEFT", -ROWGAP, 0) end
			lasticon, butt.spell = butt, spell
		end
		if lasticon then lasticon:SetPoint("RIGHT", 0, 0) end
	end

	frame:SetScript("OnShow", Update)
	Update(frame)
end)
