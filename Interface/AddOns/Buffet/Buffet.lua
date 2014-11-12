
----------------------
--      Locals      --
----------------------

local myname, ns = ...

local defaults = {macroHP = "#showtooltip\n%MACRO%", macroMP = "#showtooltip\n%MACRO%"}
local ids, dirty = LibStub("tekIDmemo"), false
local items, bests, allitems = ns.itemdb, ns.bests, ns.allitems


-----------------------------
--      Event Handler      --
-----------------------------

Buffet = CreateFrame("frame")
Buffet:SetScript("OnEvent", function(self, event, ...) if self[event] then return self[event](self, event, ...) end end)
Buffet:RegisterEvent("ADDON_LOADED")
function Buffet:Print(...) ChatFrame1:AddMessage(string.join(" ", "|cFF33FF99Buffet|r:", ...)) end


function Buffet:ADDON_LOADED(event, addon)
	if addon:lower() ~= "buffet" then return end

	BuffetDB = setmetatable(BuffetDB or {}, {__index = defaults})
	self.db = BuffetDB

	self:UnregisterEvent("ADDON_LOADED")
	self.ADDON_LOADED = nil

	if IsLoggedIn() then self:PLAYER_LOGIN() else self:RegisterEvent("PLAYER_LOGIN") end
end


function Buffet:PLAYER_LOGIN()
	self:RegisterEvent("PLAYER_LOGOUT")

	self:RegisterEvent("PLAYER_REGEN_ENABLED")
	self:RegisterEvent("BAG_UPDATE")
	self:RegisterEvent("PLAYER_LEVEL_UP")

	self:Scan()

	self:UnregisterEvent("PLAYER_LOGIN")
	self.PLAYER_LOGIN = nil
end


function Buffet:PLAYER_LOGOUT()
	for i,v in pairs(defaults) do if self.db[i] == v then self.db[i] = nil end end
end


function Buffet:PLAYER_REGEN_ENABLED()
	if dirty then self:Scan() end
end


function Buffet:BAG_UPDATE()
	dirty = true
	if not InCombatLockdown() then self:Scan() end
end
Buffet.PLAYER_LEVEL_UP = Buffet.BAG_UPDATE


function Buffet:Scan()
	for _,t in pairs(bests) do for i in pairs(t) do t[i] = nil end end
	local mylevel = UnitLevel("player")

	for bag=0,4 do
		for slot=1,GetContainerNumSlots(bag) do
			local link = GetContainerItemLink(bag, slot)
			local id = link and ids[link]
			local reqlvl = link and select(5, GetItemInfo(link)) or 0
			if id and allitems[id] and reqlvl <= mylevel then
				local _, stack = GetContainerItemInfo(bag,slot)
				for set,setitems in pairs(items) do
					local thisbest, val = bests[set], setitems[id]
					if val and (not thisbest.val or (thisbest.val < val or thisbest.val == val and thisbest.stack > stack)) then
						thisbest.id, thisbest.val, thisbest.stack = id, val, stack
					end
				end
			end
		end
	end

	local healthstone = GetItemCount(5512) > 0 and 5512 or nil

	local food = bests.percfood.id or bests.food.id or healthstone or bests.hppot.id
	local water = bests.percwater.id or bests.water.id or bests.mppot.id

	self:Edit("AutoHP", self.db.macroHP, food, healthstone or bests.hppot.id, bests.bandage.id)
	self:Edit("AutoMP", self.db.macroMP, water, bests.mppot.id)

	dirty = false
end


function Buffet:Edit(name, substring, food, pot, mod)
	local macroid = GetMacroIndexByName(name)
	if not macroid then return end
	local hasDaughter = GetItemCount(64488) == 1

	local body = "/use [mod:alt]item:"..( hasDaughter and "64488" or "6948" )..";"
	if mod then body = body .. "[mod,target=player] item:"..mod.."; " end
	if pot then body = body .. "[combat] item:"..pot.."; " end
	body = body.."item:"..(food or "6948")

	EditMacro(macroid, name, "INV_Misc_QuestionMark", substring:gsub("%%MACRO%%", body), 1)
end
