
local myname, Cork = ...
if Cork.MYCLASS ~= "DRUID" then return end


-- Mark of the Wild
local spellname, _, icon = GetSpellInfo(1126)
local EMP, KINGS = GetSpellInfo(115921), GetSpellInfo(20217)
local GRACE, MIGHT = GetSpellInfo(116956), GetSpellInfo(19740)
Cork:GenerateRaidBuffer(spellname, icon, nil, nil, function(unit)
	-- If a monk already hit this unit, we don't need to
	if UnitAura(unit, EMP) then return true end

	-- If a pally cast Kings when he should have put up Might, overwrite it
	if UnitAura(unit, KINGS) then
		-- If either mastery buff is also present, we're good and don't need to buff
		return UnitAura(unit, MIGHT) or UnitAura(unit, GRACE)
	end
end)


-- Symbiosis
local spellname, _, icon = GetSpellInfo(110309)
local dataobj = Cork:GenerateLastBuffedBuffer(spellname, icon)
dataobj.partyonly = true
dataobj.ignoreplayer = true
function dataobj:CorkIt(frame)
	if self.custom then
		if self.lasttarget then
			local macro = "/target ".. dataobj.lasttarget.. "\n/cast ".. spellname
			return frame:SetManyAttributes("type1", "macro", "macrotext1", macro)
		elseif IsInGroup() and not IsInRaid() and GetNumSubgroupMembers() == 1 then
			local macro = "/target party1\n/cast ".. spellname
			return frame:SetManyAttributes("type1", "macro", "macrotext1", macro)
		end
	end
end


-- Shapeshifts
local dobj, ref = Cork:GenerateAdvancedSelfBuffer("Fursuit", {768, 5487, 24858})
function dobj:CorkIt(frame)
	ref()
	local spell = Cork.dbpc["Fursuit-spell"]
	if self.player and Corkboard:NumLines() == 1 then
		return frame:SetManyAttributes("type1", "spell", "spell", spell, "unit", "player")
	end
end
