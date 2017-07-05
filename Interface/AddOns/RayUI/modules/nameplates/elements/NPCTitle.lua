----------------------------------------------------------
-- Load RayUI Environment
----------------------------------------------------------
RayUI:LoadEnv("NamePlates")


local mod = _NamePlates
local LSM = LibStub("LibSharedMedia-3.0")


local tooltip = CreateFrame("GameTooltip", "RayUI_NPCTitle", UIParent, "GameTooltipTemplate")
tooltip:SetPoint("CENTER")
tooltip:SetSize(200, 200)
GameTooltip_SetDefaultAnchor(tooltip, UIParent)

function mod:UpdateElement_NPCTitle(frame)
	frame.NPCTitle:SetText("")
	if not UnitIsPlayer(frame.unit) and not UnitPlayerControlled(frame.unit) and not UnitIsUnit("target", frame.unit) and not self.db.units[frame.UnitType].healthbar then
		tooltip:SetOwner(UIParent, "ANCHOR_NONE")
		tooltip:SetUnit(frame.unit)
		tooltip:Show()

		local title = RayUI_NPCTitleTextLeft2:GetText();
		tooltip:Hide()
		if not title or title:find('^Level ') or title:find('^'..LEVEL) then return end
		frame.NPCTitle:SetText(title)
		local reactionType = UnitReaction(frame.unit, "player")
		local r, g, b
		if(reactionType == 4) then
			r, g, b = unpack(RayUF.colors.reaction[4])
		elseif(reactionType > 4) then
			r, g, b = unpack(RayUF.colors.reaction[5])
		else
			r, g, b = unpack(RayUF.colors.reaction[1])
		end

		frame.NPCTitle:SetTextColor(r - 0.1, g - 0.1, b - 0.1)
	end
end

function mod:ConfigureElement_NPCTitle(frame)
	local title = frame.NPCTitle

	title:SetJustifyH("CENTER")
	title:SetPoint("TOP", frame.Name, "BOTTOM", 0, -2)

	title:SetFont(LSM:Fetch("font", R["media"].font), self.db.fontsize, "OUTLINE")
end

function mod:ConstructElement_NPCTitle(frame)
	return frame:CreateFontString(nil, "OVERLAY")
end
