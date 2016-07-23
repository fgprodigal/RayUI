local R, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local mod = R:GetModule('NamePlates')
local LSM = LibStub("LibSharedMedia-3.0")

function mod:UpdateElement_Name(frame)
	local name, realm = UnitName(frame.displayedUnit)
	if((not self.db.units[frame.UnitType].showName and frame.UnitType ~= "PLAYER") or not name) then return end
	if frame.UnitType == "PLAYER" and not self.db.units[frame.UnitType].showName then frame.Name:SetText() return end 

	frame.Name:SetText(name)

	if(frame.UnitType == "FRIENDLY_PLAYER" or frame.UnitType == "ENEMY_PLAYER") then
		local _, class = UnitClass(frame.displayedUnit)
		local color = RAID_CLASS_COLORS[class]
		if(class and color) then
			frame.Name:SetTextColor(color.r, color.g, color.b)
		end
	elseif(not self.db.units[frame.UnitType].healthbar.enable) then
		local reactionType = UnitReaction(frame.unit, "player")
		local r, g, b
		if(reactionType == 4) then
			r, g, b = unpack(RayUF.colors.reaction[4])
		elseif(reactionType > 4) then
			r, g, b = unpack(RayUF.colors.reaction[5])
		else
			r, g, b = unpack(RayUF.colors.reaction[1])
		end	
		
		frame.Name:SetTextColor(r, g, b)
	else
		frame.Name:SetTextColor(1, 1, 1)
	end
end

function mod:ConfigureElement_Name(frame)
	local name = frame.Name
	
	name:SetJustifyH("LEFT")
	name:ClearAllPoints()
	if(self.db.units[frame.UnitType].healthbar.enable or frame.isTarget) then
		name:SetJustifyH("LEFT")
		name:SetPoint("BOTTOMLEFT", frame.HealthBar, "TOPLEFT", 0, 2)
		name:SetPoint("BOTTOMRIGHT", frame.Level, "BOTTOMLEFT")
	else
		name:SetJustifyH("CENTER")
		name:SetPoint("TOP", frame, "CENTER")
	end
	
	name:SetFont(LSM:Fetch("font", R.global.media.font), R.global.media.fontsize, R.global.media.fontflag)
end

function mod:ConstructElement_Name(frame)
	return frame:CreateFontString(nil, "OVERLAY")
end