local R, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local IF = R:GetModule("InfoBar")

local menuFrame = CreateFrame("Frame", "LootSpecializationClickMenu", UIParent, "UIDropDownMenuTemplate")
local menuList = {
	{ text = SELECT_LOOT_SPECIALIZATION, isTitle = true, notCheckable = true },
	{ notCheckable = true, func = function() SetLootSpecialization(0) end },
	{ notCheckable = true },
	{ notCheckable = true },
	{ notCheckable = true },
	{ notCheckable = true }
}

local function LoadTalent()
	local infobar = IF:CreateInfoPanel("RayUI_InfoPanel_Talent", 70)
	infobar:SetPoint("LEFT", RayUI_InfoPanel_Latency, "RIGHT", 0, 0)
	infobar.Text:SetText(NONE..TALENTS)

	local spec = LibStub("Tablet-2.0")

	local SpecEquipList = {}

	local function SpecChangeClickFunc(self, ...)
		if ... then
			if GetSpecialization(false, false, 1) == ... then return end
			SetSpecialization(...)
		end
	end

	local function SpecGearClickFunc(self, index, equipName)
		if not index then return end

		EquipmentManager_EquipSet(equipName)
	end

	local function SpecAddEquipListToCat(self, cat)
		resSizeExtra = 2
		local numTalentGroups = GetNumSpecGroups()

		-- Sets
		local line = {}
		if #SpecEquipList > 0 then
			for k, v in ipairs(SpecEquipList) do
				local _, _, _, isEquipped = GetEquipmentSetInfo(k)

				wipe(line)
				for i = 1, 2 do
					if i == 1 then
						line["text"] = string.format("|T%s:%d:%d:0:0:64:64:5:59:5:59|t %s", SpecEquipList[k].icon, 10 + resSizeExtra, 10 + resSizeExtra, SpecEquipList[k].name)
						line["size"] = 10 + resSizeExtra
						line["justify"] = "LEFT"
						line["textR"] = 0.9
						line["textG"] = 0.9
						line["textB"] = 0.9
						line["hasCheck"] = true
						line["isRadio"] = true
						line["checked"] = isEquipped
						line["func"] = function() SpecGearClickFunc(self, k, SpecEquipList[k].name) end
						line["customwidth"] = 110
					elseif i == 2 then
						line["text"..i] = isEquipped and ACTIVE_PETS or ""
						line["size"..i] = 10 + resSizeExtra
						line["justify"..i] = "LEFT"
						line["text"..i.."R"] = isEquipped and 0 or 0.3
						line["text"..i.."G"] = isEquipped and 0.9 or 0.3
						line["text"..i.."B"] = isEquipped and 0 or 0.3
					end
				end

				cat:AddLine(line)
			end
		end
	end

	local SpecSection = {}

	local function SpecAddTalentGroupLineToCat(self, cat, talentGroup)
		resSizeExtra = 2

		local ActiveColor = {0, 0.9, 0}
		local InactiveColor = {0.3, 0.3, 0.3}

		local IsPrimary = GetSpecialization(false, false, 1)

		local line = {}
		for i = 1, 2 do
			local SpecColor = (IsPrimary == talentGroup) and ActiveColor or InactiveColor
			if i == 1 then
                if talentGroup then
                    line["text"] = string.format("|T%s:%d:%d:0:0:64:64:5:59:5:59|t %s", select(4, GetSpecializationInfo(talentGroup)), 10 + resSizeExtra, 10 + resSizeExtra, select(2, GetSpecializationInfo(talentGroup)))
                else
                    line["text"] = NONE..TALENTS 
                end
				line["justify"] = "LEFT"
				line["size"] = 10 + resSizeExtra
				line["textR"] = 0.9
				line["textG"] = 0.9
				line["textB"] = 0.9
				line["hasCheck"] = true
				line["checked"] = IsPrimary == talentGroup
				line["isRadio"] = true
				line["func"] = function() SpecChangeClickFunc(self, talentGroup) end
				line["customwidth"] = 130
			else
				line["text"..i] = IsPrimary == talentGroup and ACTIVE_PETS or ""
				line["justify"..i] = "RIGHT"
				line["size"..i] = 10 + resSizeExtra
				line["text"..i.."R"] = SpecColor[1]
				line["text"..i.."G"] = SpecColor[2]
				line["text"..i.."B"] = SpecColor[3]
				line["customwidth"..i] = 20
			end
		end
		cat:AddLine(line)
	end

	local function Spec_UpdateTablet(self)
		resSizeExtra = 2
		local Cols, lineHeader

		local numTalentGroups = GetNumSpecializations()

		if numTalentGroups > 0 and UnitLevel("player") >= 10 then
			wipe(SpecSection)

			-- Spec Category
			SpecSection["specs"] = {}
			SpecSection["specs"].cat = spec:AddCategory()
			SpecSection["specs"].cat:AddLine("text", R:RGBToHex(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)..TALENTS.."|r", "size", 10 + resSizeExtra, "textR", 1, "textG", 1, "textB", 1)

			-- Talent Cat
			SpecSection["specs"].talentCat = spec:AddCategory("columns", 2)
			R:AddBlankTabLine(SpecSection["specs"].talentCat, 2)

			for i = 1, numTalentGroups do
				SpecAddTalentGroupLineToCat(self, SpecSection["specs"].talentCat, i)
			end
		end
		
		local numEquipSets = GetNumEquipmentSets()
		if numEquipSets > 0 then

			-- Equipment Category
			SpecSection["equipment"] = {}
			SpecSection["equipment"].cat = spec:AddCategory()
			if numTalentGroups > 0 then
				R:AddBlankTabLine(SpecSection["equipment"].cat, 2)
			end
			SpecSection["equipment"].cat:AddLine("text", R:RGBToHex(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)..EQUIPMENT_MANAGER.."|r", "size", 10 + resSizeExtra, "textR", 1, "textG", 1, "textB", 1)
			R:AddBlankTabLine(SpecSection["equipment"].cat, 2)

			-- Equipment Cat
			SpecSection["equipment"].equipCat = spec:AddCategory("columns", 2)
			R:AddBlankTabLine(SpecSection["equipment"].equipCat, 1)

			SpecAddEquipListToCat(self, SpecSection["equipment"].equipCat)
		end

		-- Hint
		if (numTalentGroups > 0 and UnitLevel("player") >= 10) and (numEquipSets > 0) then
			spec:SetHint(L["<点击天赋> 切换天赋."].."\n"..L["<点击套装> 装备套装."])
		elseif numTalentGroups > 0 and UnitLevel("player") >= 10 then
			spec:SetHint(L["<点击天赋> 切换天赋."])
		elseif numEquipSets > 0 then
			spec:SetHint(L["<点击套装> 装备套装."])
		end
	end

	local function Spec_OnEnter(self)
		local active = GetActiveSpecGroup(false, false)
		if InCombatLockdown() or not GetSpecialization(false, false, active) or not select(2, GetSpecializationInfo(GetSpecialization(false, false, active))) then return end
		-- Register spec
		if not spec:IsRegistered(self) then
			spec:Register(self,
				"children", function()
					Spec_UpdateTablet(self)
				end,
				"point", "BOTTOMRIGHT",
				"relativePoint", "TOPRIGHT",
				"maxHeight", 500,
				"clickable", true,
				"hideWhenEmpty", true
			)
		end

		if spec:IsRegistered(self) then
			-- spec appearance
			spec:SetColor(self, 0, 0, 0)
			spec:SetTransparency(self, .65)
			spec:SetFontSizePercent(self, 1)

			-- Open
			spec:Open(self)
		end

		collectgarbage()
	end

	local function Spec_Update(self)
		local numTalentGroups = GetNumSpecGroups()

		-- Gear sets
		wipe(SpecEquipList)
		local numEquipSets = GetNumEquipmentSets()
		if numEquipSets > 0 then
			for index = 1, numEquipSets do
				local equipName, equipIcon = GetEquipmentSetInfo(index)
				SpecEquipList[index] = {
					name = equipName,
					icon = equipIcon or 132632,
				}
			end
		end

		local active = GetActiveSpecGroup(false, false)
		local talent, loot = "", ""
		if GetSpecialization(false, false, active) then
			talent = format("|T%s:14:14:0:0:64:64:4:60:4:60|t", select(4, GetSpecializationInfo(GetSpecialization(false, false, active))) or "")
		end
		local specialization = GetLootSpecialization()
		if specialization == 0 then
			local specIndex = GetSpecialization();
			
			if specIndex then
				local specID, _, _, texture = GetSpecializationInfo(specIndex);
				loot = format("|T%s:14:14:0:0:64:64:4:60:4:60|t", texture or "")
			else
				loot = "N/A"
			end
		else
			local specID, _, _, texture = GetSpecializationInfoByID(specialization);
			if specID then
				loot = format("|T%s:14:14:0:0:64:64:4:60:4:60|t", texture or "")
			else
				loot = "N/A"
			end
		end
		if GetSpecialization(false, false, active) and select(2, GetSpecializationInfo(GetSpecialization(false, false, active))) then
			infobar.Text:SetText(format("%s: %s %s: %s", TALENTS, talent, LOOT, loot))
		else
            infobar.Text:SetText(NONE..TALENTS)
		end
		infobar:SetWidth(infobar.Text:GetWidth() + IF.gap*2)
	end

	infobar:HookScript("OnEnter", Spec_OnEnter)

	local function OnEvent(self, event, ...)
		if event == "PLAYER_LOGIN" then
			self:UnregisterEvent("PLAYER_LOGIN")
			self:RegisterEvent("PLAYER_ENTERING_WORLD");
			self:RegisterEvent("CHARACTER_POINTS_CHANGED");
			self:RegisterEvent("PLAYER_TALENT_UPDATE");
			self:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
			self:RegisterEvent("EQUIPMENT_SETS_CHANGED")
			self:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
			self:RegisterEvent("PLAYER_LOOT_SPEC_UPDATED")
			return
		end

		if spec:IsRegistered(self) then
			C_Timer.After(0.25, function() spec:Refresh(self) end)
		end
		Spec_Update(self)
	end

	infobar:RegisterEvent("PLAYER_LOGIN")
	infobar:HookScript("OnEvent", OnEvent)

	infobar:SetScript("OnMouseDown", function(self, button)
		local specIndex = GetSpecialization()
		if UnitLevel("player") <10 then return end
		if not specIndex then return end

		if button == "LeftButton" then
			if not PlayerTalentFrame then
				TalentFrame_LoadUI()
			end
			
			if not PlayerTalentFrame:IsShown() then
				ShowUIPanel(PlayerTalentFrame)
			else
				HideUIPanel(PlayerTalentFrame)
			end
		else
			spec:Close()
			local specID, specName = GetSpecializationInfo(specIndex)
			menuList[2].text = format(LOOT_SPECIALIZATION_DEFAULT, specName)

			for index = 1, 4 do
				local id, name = GetSpecializationInfo(index)
				if ( id ) then
					menuList[index + 2].text = name
					menuList[index + 2].func = function() SetLootSpecialization(id) end
				else
					menuList[index + 2] = nil
				end
			end

			EasyMenu(menuList, menuFrame, "cursor", -15, -7, "MENU", 2)
		end
	end)
end

IF:RegisterInfoText("Talent", LoadTalent)
