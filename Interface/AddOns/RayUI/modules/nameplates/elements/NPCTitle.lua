local R, L, P, G = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, GlobalDB
local mod = R:GetModule('NamePlates')
local LSM = LibStub("LibSharedMedia-3.0")

--Cache global variables
--Lua functions
local unpack = unpack

--WoW API / Variables
local UnitIsPlayer = UnitIsPlayer
local UnitIsUnit = UnitIsUnit
local UnitPlayerControlled = UnitPlayerControlled
local UnitReaction = UnitReaction

--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: UIParent, RayUI_NPCTitleTextLeft2, RayUF, LEVEL

local tooltip = CreateFrame("GameTooltip", "RayUI_NPCTitle", UIParent, "GameTooltipTemplate")
tooltip:SetPoint("CENTER")
tooltip:SetSize(200, 200)
GameTooltip_SetDefaultAnchor(tooltip, UIParent)

function mod:UpdateElement_NPCTitle(frame)
	frame.NPCTitle:SetText("")
	if not UnitIsPlayer(frame.unit) and not UnitPlayerControlled(frame.unit) and not UnitIsUnit("target", frame.unit) and frame.UnitType == "FRIENDLY_NPC" then
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
