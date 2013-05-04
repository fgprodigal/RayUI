local R, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local B = R:GetModule("Blizzards")

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")

function B:FixTradeSkill()
	local tooltip = CreateFrame("GameTooltip", "FixTradeSkillTooltip", UIParent, "GameTooltipTemplate")
	tooltip:SetOwner(UIParent, "ANCHOR_NONE")

	local function FixedGetTradeSkillReagentItemLink(i,j)
		tooltip:ClearLines()
		tooltip:SetTradeSkillItem(i, j)
		local _, reagentLink = tooltip:GetItem()
		return reagentLink
	end

	local function new_Click(self)
		HandleModifiedItemClick(FixedGetTradeSkillReagentItemLink(TradeSkillFrame.selectedSkill, self:GetID()))
	end

	local function OnEvent(self, event, addon)
		if addon == "Blizzard_TradeSkillUI" then
			for i = 1, 8 do
				_G["TradeSkillReagent" .. i]:HookScript("OnClick", new_Click)
			end
			self:UnregisterEvent("ADDON_LOADED")
	   end
	end
	
	f:SetScript("OnEvent", OnEvent)
end