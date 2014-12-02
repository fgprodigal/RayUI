local R, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local M = R:GetModule("Misc")

local function LoadFunc()
	----------------------------------------------------------------------------------------
	--	Enchantment scroll on TradeSkill frame(OneClickEnchantScroll by Sara.Festung)
	----------------------------------------------------------------------------------------
	local frame = CreateFrame("Frame")
	frame:RegisterEvent("ADDON_LOADED")
	frame:SetScript("OnEvent", function(self, event, addon)
		if IsAddOnLoaded("Blizzard_TradeSkillUI") and not IsAddOnLoaded("OneClickEnchantScroll") then
			local oldfunc = TradeSkillFrame_SetSelection
			local button = CreateFrame("Button", "TradeSkillCreateScrollButton", TradeSkillFrame, "MagicButtonTemplate")
			R:GetModule("Skins"):Reskin(button)
			button:Point("TOPRIGHT", TradeSkillCreateButton, "TOPLEFT", -1, 0)
			button:Point("BOTTOMLEFT", TradeSkillCreateAllButton, "BOTTOMLEFT", 0, 0)
			button:SetScript("OnClick", function()
				DoTradeSkill(TradeSkillFrame.selectedSkill)
				UseItemByName(38682)
			end)
			button:Hide()

			function TradeSkillFrame_SetSelection(id)
				oldfunc(id)
				local skillName, _, _, _, altVerb = GetTradeSkillInfo(id)
				if IsTradeSkillGuild() or IsTradeSkillLinked() then
					button:Hide()
				elseif altVerb and CURRENT_TRADESKILL == GetSpellInfo(7411) and GetItemInfo(38682) then
					button:Show()
					local creatable = 1
					if not skillName then
						creatable = nil
					end
					local scrollnum = GetItemCount(38682)
					TradeSkillCreateScrollButton:SetText(GetItemInfo(38682).." ("..scrollnum..")")
					if scrollnum == 0 then
						creatable = nil
					end
					for i = 1, GetTradeSkillNumReagents(id) do
						local _, _, reagentCount, playerReagentCount = GetTradeSkillReagentInfo(id, i)
						if playerReagentCount < reagentCount then
							creatable = nil
						end
					end
					if creatable then
						TradeSkillCreateScrollButton:Enable()
					else
						TradeSkillCreateScrollButton:Disable()
					end
				else
					button:Hide()
				end
			end
		end
	end)
end

M:RegisterMiscModule("OneClickEnchantScroll", LoadFunc)