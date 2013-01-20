local R, L, P = unpack(select(2, ...)) --Inport: Engine, Locales, ProfileDB
local IF = R:GetModule("InfoBar")

local function LoadStatus()
	local infobar = _G["RayUIBottomInfoBar"]
	local Status = CreateFrame("Frame", nil, infobar)
	Status:EnableMouse(true)
	Status:SetFrameStrata("MEDIUM")
	Status:SetFrameLevel(3)

	local Text  = infobar:CreateFontString(nil, "OVERLAY")
	Text:SetFont(R["media"].font, R["media"].fontsize, R["media"].fontflag)
	Text:SetShadowOffset(1.25, -1.25)
	Text:SetShadowColor(0, 0, 0, 0.4)
	Text:SetPoint("BOTTOMRIGHT", infobar, "TOPRIGHT", -10, -3)
	Status:SetAllPoints(Text)

	local TANK_ICON = "|TInterface\\AddOns\\RayUI\\media\\tank.tga:14:14|t"
	local HEALER_ICON = "|TInterface\\AddOns\\RayUI\\media\\healer.tga:14:14|t"
	local DPS_ICON = "|TInterface\\AddOns\\RayUI\\media\\dps.tga:14:14|t"
	local NOBONUSREWARDS = BATTLEGROUND_HOLIDAY..": N/A"

	local function MakeIconString(tank, healer, damage)
		local str = ""
		if tank then
			str = str..TANK_ICON
		end
		if healer then
			str = str..HEALER_ICON
		end
		if damage then
			str = str..DPS_ICON
		end	

		return str
	end

	local function OnEnter(self)
		GameTooltip:SetOwner(self, "ANCHOR_TOP")
		GameTooltip:ClearLines()

		local allUnavailable = true
		local numCTA = 0
		for i=1, GetNumRandomDungeons() do
			local id, name = GetLFGRandomDungeonInfo(i)
			local tankReward = false
			local healerReward = false
			local dpsReward = false
			local unavailable = true
			for x=1, LFG_ROLE_NUM_SHORTAGE_TYPES do
				local eligible, forTank, forHealer, forDamage, itemCount = GetLFGRoleShortageRewards(id, x)
				if eligible then unavailable = false end
				if eligible and forTank and itemCount > 0 then tankReward = true end
				if eligible and forHealer and itemCount > 0 then healerReward = true end
				if eligible and forDamage and itemCount > 0 then dpsReward = true end
			end
			
			if not unavailable then
				allUnavailable = false
				local rolesString = MakeIconString(tankReward, healerReward, dpsReward)
				if rolesString ~= ""  then
					GameTooltip:AddDoubleLine(name..":", rolesString, 1, 1, 1)
				end
				if tankReward or healerReward or dpsReward then numCTA = numCTA + 1 end
			end
		end

		GameTooltip:Show()
	end

	local function OnEvent(self)
		local tankReward = false
		local healerReward = false
		local dpsReward = false
		local unavailable = true
		for i=1, GetNumRandomDungeons() do
			local id, name = GetLFGRandomDungeonInfo(i)
			for x = 1, LFG_ROLE_NUM_SHORTAGE_TYPES do
				local eligible, forTank, forHealer, forDamage, itemCount = GetLFGRoleShortageRewards(id, x)
				if eligible and forTank and itemCount > 0 then tankReward = true; unavailable = false; end
				if eligible and forHealer and itemCount > 0 then healerReward = true; unavailable = false; end
				if eligible and forDamage and itemCount > 0 then dpsReward = true; unavailable = false; end
			end
		end	

		if unavailable then
			Text:SetText(NOBONUSREWARDS)
		else
			Text:SetText(BATTLEGROUND_HOLIDAY..": "..MakeIconString(tankReward, healerReward, dpsReward))
		end
	end

	Status:SetScript("OnEnter", OnEnter)
	Status:SetScript("OnLeave", GameTooltip_Hide)
	Status:SetScript("OnEvent", OnEvent)
	Status:SetScript("OnMouseDown", function() PVEFrame_ToggleFrame("GroupFinderFrame", LFDParentFrame) end)
	Status:RegisterEvent("PLAYER_ENTERING_WORLD")
	Status:RegisterEvent("LFG_UPDATE_RANDOM_INFO")
end

IF:RegisterInfoText("CallToArms", LoadStatus)
