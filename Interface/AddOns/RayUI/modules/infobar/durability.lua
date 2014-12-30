local R, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local IF = R:GetModule("InfoBar")

local function LoadDurability()
	local stringText = DURABILITY..": %d%%"
	local infobar = IF:CreateInfoPanel("RayUI_InfoPanel_Durability", 100)
	infobar:SetPoint("LEFT", RayUI_InfoPanel_Talent, "RIGHT", 0, 0)
	infobar.Text:SetText(string.format(stringText, 100))

	local Slots = {
			[1] = {1, INVTYPE_HEAD, 1000},
			[2] = {3, INVTYPE_SHOULDER, 1000},
			[3] = {5, INVTYPE_ROBE, 1000},
			[4] = {6, INVTYPE_WAIST, 1000},
			[5] = {9, INVTYPE_WRIST, 1000},
			[6] = {10, INVTYPE_HAND, 1000},
			[7] = {7, INVTYPE_LEGS, 1000},
			[8] = {8, INVTYPE_FEET, 1000},
			[9] = {16, INVTYPE_WEAPONMAINHAND, 1000},
			[10] = {17, INVTYPE_WEAPONOFFHAND, 1000},
			[11] = {18, INVTYPE_RANGED, 1000}
		}
	local tooltipString = "%d %%"

	infobar:SetScript("OnEvent", function(self)
		local Total = 0
		local current, max

		for i = 1, 11 do
			if GetInventoryItemLink("player", Slots[i][1]) ~= nil then
				current, max = GetInventoryItemDurability(Slots[i][1])
				if current then 
					Slots[i][3] = current/max
					Total = Total + 1
				end
			end
		end
		table.sort(Slots, function(a, b) return a[3] < b[3] end)
		local value = floor(Slots[1][3]*100)

		infobar.Text:SetText(string.format(stringText, value))
		local r, g, b = R:ColorGradient(value/100, IF.InfoBarStatusColor[1][1], IF.InfoBarStatusColor[1][2], IF.InfoBarStatusColor[1][3], 
																	IF.InfoBarStatusColor[2][1], IF.InfoBarStatusColor[2][2], IF.InfoBarStatusColor[2][3],
																	IF.InfoBarStatusColor[3][1], IF.InfoBarStatusColor[3][2], IF.InfoBarStatusColor[3][3])
		infobar.Square:SetVertexColor(r, g, b)
	end)
	infobar:HookScript("OnEnter", function(self)
		if not InCombatLockdown() then
			GameTooltip:SetOwner(infobar, "ANCHOR_NONE")
			GameTooltip:SetPoint("BOTTOMLEFT", infobar, "TOPLEFT", 0, 0)
			GameTooltip:ClearLines()
			GameTooltip:AddLine(DURABILITY..":")
			for i = 1, 11 do
				if Slots[i][3] ~= 1000 then
					green = Slots[i][3]*2
					red = 1 - green
					GameTooltip:AddDoubleLine(Slots[i][2], format(tooltipString, floor(Slots[i][3]*100)), 1 ,1 , 1, red + 1, green, 0)
				end
			end
			GameTooltip:Show()
		end
	end)
	infobar:HookScript("OnLeave", GameTooltip_Hide)
	infobar:HookScript("OnMouseDown", function() GameTooltip_Hide() ToggleCharacter("PaperDollFrame") end)
	infobar:RegisterEvent("UPDATE_INVENTORY_DURABILITY")
	infobar:RegisterEvent("MERCHANT_SHOW")
	infobar:RegisterEvent("PLAYER_ENTERING_WORLD")
end

IF:RegisterInfoText("Durability", LoadDurability)
