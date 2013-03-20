
local myname, Cork = ...
local IconLine = Cork.IconLine("Interface\\OptionsFrame\\UI-OptionsFrame-NewFeatureIcon", "Quest starter")
local ldb, ae = LibStub:GetLibrary("LibDataBroker-1.1"), LibStub("AceEvent-3.0")

local bags = {}

Cork.defaultspc["Quest Starting Items-enabled"] = true

local dataobj = ldb:NewDataObject("Cork Quest Starting Items", {type = "cork", tiptext = "Warn when you have available quests from items in your bags."})

local function TestBag(bag)
	for slot=0,GetContainerNumSlots(bag) do
		local _, qid, active = GetContainerItemQuestInfo(bag, slot)
		if qid and not active then return true end
	end
end

function dataobj:Scan()
	if not Cork.dbpc["Quest Starting Items-enabled"] then
		dataobj.player = nil
		return
	end

	wipe(bags)
	for bag=0,4 do bags[bag] = TestBag(bag) end
	if next(bags) then dataobj.player = IconLine; return end
	dataobj.player = nil
end

ae.RegisterEvent("Cork Quest Starting Items", "QUEST_ACCEPTED", function() if next(bags) then dataobj:Scan() end end)
ae.RegisterEvent("Cork Quest Starting Items", "UNIT_QUEST_LOG_CHANGED", function(event, unit) if unit == "player" and next(bags) then dataobj:Scan() end end)
ae.RegisterEvent("Cork Quest Starting Items", "BAG_UPDATE", function(event, bag)
	if not Cork.dbpc["Quest Starting Items-enabled"] then return end
	bags[bag] = TestBag(bag)
	if next(bags) then dataobj.player = IconLine; return end
	dataobj.player = nil
end)

function dataobj:CorkIt(frame)
	if dataobj.player then
		for bag=0,4 do
			for slot=0,GetContainerNumSlots(bag) do
				local _, qid, active = GetContainerItemQuestInfo(bag, slot)
				if qid and not active then
					local id = GetContainerItemID(bag, slot)
					return frame:SetManyAttributes("type1", "item", "item1", "item:"..id)
				end
			end
		end
	end
end
