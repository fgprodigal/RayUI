
local myname, Cork = ...
local UnitAura = Cork.UnitAura or UnitAura
local ldb, ae = LibStub:GetLibrary("LibDataBroker-1.1"), LibStub("AceEvent-3.0")
local blist = {npc = true, vehicle = true, focus = true, target = true}
for i=1,5 do blist["arena"..i], blist["arenapet"..i] = true, true end


function Cork:GenerateLastBuffedBuffer(spellname, icon)
	local SpellCastableOnUnit, IconLine = Cork.SpellCastableOnUnit, Cork.IconLine


	local dataobj = ldb:NewDataObject("Cork "..spellname, {type = "cork", tiplink = GetSpellLink(spellname)})


	local f = CreateFrame("Frame")
	f:Hide()

	local endtime, elapsed
	local function Test()
		if (IsResting() and not Cork.db.debug) then return end
		if not Cork.dbpc[spellname.."-enabled"]
			or (dataobj.onlyrebuffs and not dataobj.lasttarget)
			or (dataobj.partyonly and not IsInGroup()) then

			dataobj.lasttarget, dataobj.custom = nil
			f:Hide()
			return
		end

		local start, duration = GetSpellCooldown(spellname)
		if start == 0 then
			if dataobj.lasttarget then
				if not UnitAura(dataobj.lasttarget, spellname) then
					local _, class = UnitClass(dataobj.lasttarget)
					return IconLine(icon, dataobj.lasttarget, class)
				end

				return
			else
				return IconLine(icon, spellname)
			end
		end
		endtime = start + duration
		f:Show()
	end


	ae.RegisterEvent("Cork "..spellname, "PLAYER_UPDATE_RESTING", function()
		dataobj.custom = Test()
	end)

	function dataobj:GROUP_ROSTER_UPDATE()
		if dataobj.lasttarget and not (UnitInRaid(dataobj.lasttarget) or UnitInParty(dataobj.lasttarget)) then
			dataobj.lasttarget, dataobj.custom = nil
		end
		dataobj:Scan()
	end
	ae.RegisterEvent(dataobj, "GROUP_ROSTER_UPDATE")

	ae.RegisterEvent("Cork "..spellname, "UNIT_PET", function()
		if dataobj.lasttarget and not (UnitInParty(dataobj.lasttarget) or UnitInRaid(dataobj.lasttarget)) then
			dataobj.lasttarget, dataobj.custom = nil
		end
	end)

	ae.RegisterEvent("Cork "..spellname, "UNIT_SPELLCAST_SUCCEEDED", function(event, unit, spell)
		if unit == "player" and spell == spellname then dataobj.custom = Test() end
	end)

	ae.RegisterEvent("Cork "..spellname, "UNIT_AURA", function(event, unit)
		if not Cork.dbpc[spellname.."-enabled"] or blist[unit] then return end

		local name, _, _, _, _, _, _, caster = UnitAura(unit, spellname)
		local iscaster = name and caster and UnitIsUnit('player', caster)
		local playertargetted = UnitIsUnit('player', unit)

		if iscaster then
			if not (self.ignoreplayer and playertargetted) then
				dataobj.lasttarget, dataobj.custom = UnitName(unit), nil
			end
		elseif not name and UnitName(unit) == dataobj.lasttarget then
			dataobj.custom = Test()
		end
	end)


	local function TestUnit(unit)
		if not UnitExists(unit) or GetNumGroupMembers() == 0 then return end
		local name, _, _, _, _, _, _, caster = UnitAura(unit, spellname)
		if not name or not caster or not UnitIsUnit('player', caster) then return end
		dataobj.lasttarget = UnitName(unit)
		return true
	end
	local function FindCurrent()
		if TestUnit("player") then return true end
		for i=1,GetNumSubgroupMembers() do if TestUnit("party"..i) or TestUnit("partypet"..i) then return true end end
		for i=1,GetNumGroupMembers() do if TestUnit("raid"..i) or TestUnit("raidpet"..i) then return true end end
	end

	function dataobj:Init()
		FindCurrent()
		Cork.defaultspc[spellname.."-enabled"] = GetSpellInfo(spellname) ~= nil
	end

	function dataobj:Scan()
		dataobj.custom = Test()
	end

	function dataobj:CorkIt(frame)
		if self.custom then return
			frame:SetManyAttributes("type1", "spell", "spell", spellname, "unit", dataobj.lasttarget)
		end
	end

	f:SetScript("OnShow", function() elapsed = GetTime() end)
	f:SetScript("OnHide", function() dataobj.custom, endtime = Test() end)
	f:SetScript("OnUpdate", function(self, elap)
		elapsed = elapsed + elap
		if not endtime or elapsed >= endtime then self:Hide() end
	end)


	----------------------
	--      Config      --
	----------------------

	local frame = CreateFrame("Frame", nil, Cork.config)
	frame:SetWidth(1) frame:SetHeight(1)
	dataobj.configframe = frame
	frame:Hide()

	frame:SetScript("OnShow", function()
		local butt = LibStub("tekKonfig-Button").new_small(frame, "RIGHT")
		butt:SetWidth(60) butt:SetHeight(18)
		butt:SetText("Clear")
		butt:SetScript("OnClick", function(self)
			self:Hide() lasttarget, dataobj.custom = nil
		end)

		local text = butt:CreateFontString(nil, "BACKGROUND", "GameFontHighlightSmall")
		text:SetPoint("RIGHT", butt, "LEFT", -4, 0)

		local function Refresh()
			if dataobj.lasttarget then
				butt:Show()
				text:SetText(dataobj.lasttarget)
			else butt:Hide() end
		end

		local callbackname = "LibDataBroker_AttributeChanged_Cork "..spellname
		ldb.RegisterCallback("Cork "..spellname, callbackname, Refresh)

		frame:SetScript("OnShow", Refresh)
		Refresh()
	end)

	return dataobj
end
