local R, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local IF = R:GetModule("InfoBar")

local classIcon = [[Interface\Icons\ability_monk_essencefont]]

local function AddPerks()
	local forceHide, header
	
	if not ArtifactFrame:IsShown() then
		forceHide = true
		SocketInventoryItem(16)
	end
	
	for i, powerID in ipairs(C_ArtifactUI.GetPowers()) do
		--local spellID, cost, currentRank, maxRank, bonusRanks, x, y, prereqsMet, isStart, isGoldMedal, isFinal = C_ArtifactUI.GetPowerInfo(powerID)
		local spellID, _, rank, maxRank, bonus = C_ArtifactUI.GetPowerInfo(powerID)
		local isStart = select(9, C_ArtifactUI.GetPowerInfo(powerID))
		local r,g,b = 1,1,1
		
		if bonus > 0 then
			r,g,b = 0.4,1,0
		end
		
		if rank > 0 and not isStart then
			if not header then
				header = true
				GameTooltip:AddDivider()
			end
			
			GameTooltip:AddDoubleLine(GetSpellInfo(spellID), rank.."/"..maxRank, 1,1,1, r,g,b)
		end
	end	
	
	if ArtifactFrame:IsShown() and forceHide then
		HideUIPanel(ArtifactFrame)
	end
end

local function Artifact_OnClick(self)
	if HasArtifactEquipped() then
		local frame = ArtifactFrame
		local activeID = C_ArtifactUI.GetArtifactInfo()
		local equippedID = C_ArtifactUI.GetEquippedArtifactInfo()
		
		if frame:IsShown() and activeID == equippedID then
			HideUIPanel(frame)
		else
			SocketInventoryItem(16)
		end
	end
end

local function Artifact_OnUpdate(self)
	if HasArtifactEquipped() then
		local name, icon, totalXP, pointsSpent = select(3, C_ArtifactUI.GetEquippedArtifactInfo())
		local numPointsAvailableToSpend, xp, xpForNextPoint = MainMenuBar_GetNumArtifactTraitsPurchasableFromXP(pointsSpent, totalXP)
		
		self.Icon:SetTexture(icon)
		self:SetText(totalXP.." "..POWER_TYPE_POWER)
	else
		self.Icon:SetTexture(classIcon)
		self:SetText(ITEM_QUALITY6_DESC)
	end
end

local function Artifact_OnEnter(self)
	if HasArtifactEquipped() then
		local title,r,g,b = select(2, C_ArtifactUI.GetEquippedArtifactArtInfo())
		local name, icon, totalXP, pointsSpent = select(3, C_ArtifactUI.GetEquippedArtifactInfo())
		local points, xp, xpMax = MainMenuBar_GetNumArtifactTraitsPurchasableFromXP(pointsSpent, totalXP)

		GameTooltip:SetOwner(self, "ANCHOR_TOP")
		GameTooltip:AddLine(title,r,g,b,false)
		GameTooltip:SetPrevLineJustify("CENTER")
		GameTooltip:AddDivider()
		GameTooltip:AddLine(ARTIFACT_POWER_TOOLTIP_TITLE:format(BreakUpLargeNumbers(ArtifactWatchBar.totalXP), BreakUpLargeNumbers(ArtifactWatchBar.xp), BreakUpLargeNumbers(ArtifactWatchBar.xpForNextPoint)), 1, 1, 1)
		if ArtifactWatchBar.numPointsAvailableToSpend > 0 then
			GameTooltip:AddLine(" ")
			GameTooltip:AddLine(ARTIFACT_POWER_TOOLTIP_BODY:format(ArtifactWatchBar.numPointsAvailableToSpend), 0, 1, 0, true)
		end
			
		AddPerks()

		GameTooltip:Show()
	end
end

local function Artifact_OnInit()
	LoadAddOn("Blizzard_ArtifactUI")
end

do	-- Initialize
	local info = {}

	info.title = ITEM_QUALITY6_DESC
	info.icon = classIcon
	info.initFunc = Artifact_OnInit
	info.clickFunc = Artifact_OnClick
	info.onUpdate = Artifact_OnUpdate
	info.tooltipFunc = Artifact_OnEnter
	
	IF:RegisterInfoBarType("Artifact", info)
end
