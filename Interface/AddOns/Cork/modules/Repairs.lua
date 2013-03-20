

local myname, Cork = ...
local SpellCastableOnUnit, IconLine = Cork.SpellCastableOnUnit, Cork.IconLine
local ldb, ae = LibStub:GetLibrary("LibDataBroker-1.1"), LibStub("AceEvent-3.0")

local SLOTIDS, ICON = {}, "Interface\\Minimap\\Tracking\\Repair"
for _,slot in pairs({"Head", "Shoulder", "Chest", "Waist", "Legs", "Feet", "Wrist", "Hands", "MainHand", "SecondaryHand"}) do SLOTIDS[slot] = GetInventorySlotInfo(slot .. "Slot") end


local function RYGColorGradient(perc)
	local relperc = perc*2 % 1
	if perc <= 0 then       return           1,       0, 0
	elseif perc < 0.5 then  return           1, relperc, 0
	elseif perc == 0.5 then return           1,       1, 0
	elseif perc < 1.0 then  return 1 - relperc,       1, 0
	else                    return           0,       1, 0 end
end


local defaults = Cork.defaultspc
defaults["Repairs-enabled"] = true
defaults["Repairs-threshold"] = .85

local dataobj = LibStub:GetLibrary("LibDataBroker-1.1"):NewDataObject("Cork Repairs", {type = "cork", tiptext = "Warn you if your equipment needs repaired and you are in a city or resting."})

local function Test()
	if not Cork.dbpc["Repairs-enabled"] or InCombatLockdown() then return end

	local min = 1
	for slot,id in pairs(SLOTIDS) do
		local v1, v2 = GetInventoryItemDurability(id)

		if v1 and v2 and v2 ~= 0 then
			min = math.min(v1/v2, min)
		end
	end

	if min >= Cork.dbpc["Repairs-threshold"] or min >= 0.15 and not IsResting() then return end

	local r,g,b = RYGColorGradient(min)
	return IconLine(ICON, string.format("Your equipment is damaged |cff%02x%02x%02x(%d%%)", r*255, g*255, b*255, min*100))
end

function dataobj:Scan() dataobj.player = Test() end

ae.RegisterEvent("Cork Repairs", "UPDATE_INVENTORY_DURABILITY", dataobj.Scan)
ae.RegisterEvent("Cork Repairs", "PLAYER_UPDATE_RESTING", dataobj.Scan)
ae.RegisterEvent("Cork Repairs", "PLAYER_REGEN_DISABLED", dataobj.Scan)
ae.RegisterEvent("Cork Repairs", "PLAYER_REGEN_ENABLED", dataobj.Scan)


----------------------
--      Config      --
----------------------

local frame = CreateFrame("Frame", nil, Cork.config)
frame:SetWidth(1) frame:SetHeight(1)
dataobj.configframe = frame
frame:Hide()

frame:SetScript("OnShow", function()
	local slider = LibStub("tekKonfig-Slider").newbare(frame, "RIGHT")
	slider.tiptext = "Durability threshold.  If the lowest equipped item durability percent is below this, a reminder will be shown when you are resting."
	slider:SetMinMaxValues(0,1)
	slider:SetValueStep(0.05)

	local slidertext = slider:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	slidertext:SetPoint("RIGHT", slider, "LEFT")

	slider:SetScript("OnValueChanged", function(self, newvalue)
		newvalue = math.floor(newvalue*20)/20
		Cork.dbpc["Repairs-threshold"] = newvalue
		slidertext:SetFormattedText("%d%%", newvalue*100)
		dataobj:Scan()
	end)


	local function Update(self) slider:SetValue(Cork.dbpc["Repairs-threshold"]) end
	frame:SetScript("OnShow", Update)
	Update(frame)
end)
