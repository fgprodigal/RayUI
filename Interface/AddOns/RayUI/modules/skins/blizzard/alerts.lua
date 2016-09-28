local R, L, P, G = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, GlobalDB
local S = R:GetModule("Skins")

local function LoadSkin()
	local AlertFrameHolder = CreateFrame("Frame", "AlertFrameHolder", UIParent)
	AlertFrameHolder:SetWidth(180)
	AlertFrameHolder:SetHeight(20)
	AlertFrameHolder:SetPoint("CENTER", UIParent, "CENTER", 0, 150)

	--[[ SKINNING FUNCTIONS ]]--
	local function SkinAchievementAlert(frame)
		if frame then
			if not frame.bg then
				frame.bg = CreateFrame("Frame", nil, frame)
				frame.bg:SetPoint("TOPLEFT", frame.Background, "TOPLEFT", -2, -6)
				frame.bg:SetPoint("BOTTOMRIGHT", frame.Background, "BOTTOMRIGHT", -2, 6)
				frame.bg:SetFrameLevel(frame:GetFrameLevel()-1)

				if not frame.Icon.Texture.b then
					frame.Icon.Texture.b = S:CreateBG(frame.Icon.Texture)
				end

				frame:HookScript("OnEnter", function()
					S:CreateBD(frame.bg)
				end)

				frame.animIn:HookScript("OnFinished", function()
					S:CreateBD(frame.bg)
				end)
			end
			S:CreateBD(frame.bg)

			frame.Background:SetTexture(nil)
			frame.OldAchievement:Kill()

			frame.Unlocked:SetTextColor(1, 1, 1)
			frame.Unlocked:SetShadowOffset(1, -1)

			frame.Icon.Texture:SetTexCoord(.08, .92, .08, .92)
			frame.Icon.Overlay:Hide()
		end
	end

	local function SkinDungeonCompletionAlert(frame)
		if frame then
			if not frame.bg then
				frame.bg = CreateFrame("Frame", nil, frame)
				frame.bg:SetPoint("TOPLEFT", frame, "TOPLEFT", -2, -6)
				frame.bg:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -2, 6)
				frame.bg:SetFrameLevel(frame:GetFrameLevel()-1)
				

				if not frame.dungeonTexture.b then
					frame.dungeonTexture.b = CreateFrame("Frame", nil, frame)
					frame.dungeonTexture.b:SetOutside(frame.dungeonTexture, 1, 1)
					S:CreateBD(frame.dungeonTexture.b, 0)
				end

				frame:HookScript("OnEnter", function()
					S:CreateBD(frame.dungeonTexture.b, 0)
					S:CreateBD(frame.bg)
				end)

				frame.animIn:HookScript("OnFinished", function()
					S:CreateBD(frame.dungeonTexture.b, 0)
					S:CreateBD(frame.bg)
				end)
			end
			frame.raidArt:Kill()
			frame.dungeonArt1:Kill()
			frame.dungeonArt2:Kill()
			frame.dungeonArt3:Kill()
			frame.dungeonArt4:Kill()
			frame.heroicIcon:Kill()

			-- Icon
			frame.dungeonTexture:SetTexCoord(.08, .92, .08, .92)
			frame.dungeonTexture:SetDrawLayer("OVERLAY")
			frame.dungeonTexture:ClearAllPoints()
			frame.dungeonTexture:Point("LEFT", frame, 7, 0)
			S:CreateBD(frame.bg)
		end
	end

	local function SkinGuildChallengeAlert(frame)
		if frame then
			if not frame.bg then
				frame.bg = CreateFrame("Frame", nil, frame)
				frame.bg:SetPoint("TOPLEFT", frame, "TOPLEFT", -2, -6)
				frame.bg:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -2, 6)
				frame.bg:SetFrameLevel(frame:GetFrameLevel()-1)

				frame:HookScript("OnEnter", function()
					S:CreateBD(frame.bg)
				end)

				frame.animIn:HookScript("OnFinished", function()
					S:CreateBD(frame.bg)
				end)
			end
			-- Background
			for i=1, GuildChallengeAlertFrame:GetNumRegions() do
				local region = select(i, GuildChallengeAlertFrame:GetRegions()) 
				if region:GetObjectType() == "Texture" then
					if region:GetTexture() == "Interface\\GuildFrame\\GuildChallenges" then
						region:Kill()
					end
				end
			end
			GuildChallengeAlertFrameEmblemBorder:Kill()
			S:CreateBD(frame.bg)
			SetLargeGuildTabardTextures("player", GuildChallengeAlertFrameEmblemIcon, nil, nil)
		end	
	end

	local function SkinScenarioAlert(frame)
		if frame then
			if not frame.bg then
				frame.bg = CreateFrame("Frame", nil, frame)
				frame.bg:SetPoint("TOPLEFT", frame, "TOPLEFT", 4, -4)
				frame.bg:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -7, 6)
				frame.bg:SetFrameLevel(frame:GetFrameLevel()-1)

				-- Icon border
				if not ScenarioAlertFrame1DungeonTexture.b then
					ScenarioAlertFrame1DungeonTexture.b = CreateFrame("Frame", nil, frame)
					ScenarioAlertFrame1DungeonTexture.b:SetOutside(ScenarioAlertFrame1DungeonTexture, 1, 1)
					S:CreateBD(ScenarioAlertFrame1DungeonTexture.b, 0)
				end

				frame:HookScript("OnEnter", function()
					S:CreateBD(frame.bg)
				end)

				frame.animIn:HookScript("OnFinished", function()
					S:CreateBD(frame.bg)
				end)
			end
			-- Background
			for i = 1, frame:GetNumRegions() do
				local region = select(i, frame:GetRegions())
				if region:GetObjectType() == "Texture" then
					if region:GetTexture() and region:GetTexture():find("Scenarios") then
						region:Kill()
					end
				end
			end

			-- Icon
			ScenarioAlertFrame1DungeonTexture:SetTexCoord(0.1, 0.9, 0.1, 0.9)
			ScenarioAlertFrame1DungeonTexture:ClearAllPoints()
			ScenarioAlertFrame1DungeonTexture:Point("LEFT", frame.bg, 9, 0)
			S:CreateBD(frame.bg)
		end
	end
	
	local function SkinCriteriaAlert(frame)
		if frame then
			if not frame.bg then
				frame.bg = CreateFrame("Frame", nil, frame)
				frame.bg:SetPoint("TOPLEFT", frame, "TOPLEFT", 39, -6)
				frame.bg:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -2, 6)
				frame.bg:SetFrameLevel(frame:GetFrameLevel()-1)

				-- Icon border
				if not frame.Icon.Texture.b then
					frame.Icon.Texture.b = CreateFrame("Frame", nil, frame)
					frame.Icon.Texture.b:SetOutside(frame.Icon.Texture, 1, 1)
					S:CreateBD(frame.Icon.Texture.b, 0)
				end
				frame.Icon.Texture:SetTexCoord(.08, .92, .08, .92)

				frame:HookScript("OnEnter", function()
					S:CreateBD(frame.Icon.Texture.b, 0)
					S:CreateBD(frame.bg)
				end)

				frame.animIn:HookScript("OnFinished", function()
					S:CreateBD(frame.Icon.Texture.b, 0)
					S:CreateBD(frame.bg)
				end)
			end
			frame.Unlocked:SetTextColor(1, 1, 1)
			frame.Name:SetTextColor(1, 1, 0)
			frame.Background:Kill()
			frame.Icon.Bling:Kill()
			frame.Icon.Overlay:Kill()
			S:CreateBD(frame.bg)
		end
	end

	local function SkinLootWonAlert(frame)
		if not frame.bg then
			frame.bg = CreateFrame("Frame", nil, frame)
			frame.bg:SetPoint("TOPLEFT", frame, "TOPLEFT", 8, -8)
			frame.bg:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -6, 8)
			frame.bg:SetFrameLevel(frame:GetFrameLevel()-1)
			S:CreateBD(frame.bg)

			-- Icon border
			S:ReskinIcon(frame.Icon)
		end
		frame.Icon:SetDrawLayer("BORDER")
		frame.Background:Kill()
		frame.BGAtlas:Kill()
		frame.PvPBackground:Kill()
		frame.IconBorder:Kill()
	end

	local function SkinMoneyWonAlert(frame)
		if not frame.bg then
			frame.bg = CreateFrame("Frame", nil, frame)
			frame.bg:SetPoint("TOPLEFT", frame, "TOPLEFT", 8, -8)
			frame.bg:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -6, 8)
			frame.bg:SetFrameLevel(frame:GetFrameLevel()-1)
			S:CreateBD(frame.bg)

			-- Icon border
			frame.Icon:SetDrawLayer("ARTWORK")
			S:ReskinIcon(frame.Icon)
		end
		frame.IconBorder:Kill()
		frame.Background:Kill()
	end

	local function SkinInvasionAlert(frame)
		if not frame.bg then
			frame.bg = CreateFrame("Frame", nil, frame)
			frame.bg:SetPoint("TOPLEFT", frame, "TOPLEFT", 4, 4)
			frame.bg:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -7, 6)
			frame.bg:SetFrameLevel(frame:GetFrameLevel()-1)
			S:CreateBD(frame.bg)
		end
	end

	local function SkinWorldQuestCompleteAlert(frame)
		if not frame.bg then
			frame.bg = CreateFrame("Frame", nil, frame)
			frame.bg:SetPoint("TOPLEFT", frame, "TOPLEFT", 10, -6)
			frame.bg:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -14, 6)
			frame.bg:SetFrameLevel(frame:GetFrameLevel()-1)
			S:CreateBD(frame.bg)
		end
	end

	-- We can test this through /run NewRecipeLearnedAlertSystem:ShowAlert(2330)
	local function SkinNewRecipeLearnedAlert(frame)
		if not frame.bg then
			frame:GetRegions():Kill()
			frame.bg = CreateFrame("Frame", nil, frame)
			frame.bg:SetPoint("TOPLEFT", frame, "TOPLEFT", 10, -6)
			frame.bg:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -14, 6)
			frame.bg:SetFrameLevel(frame:GetFrameLevel()-1)
			S:CreateBD(frame.bg)
		end
		frame.Icon:SetMask(nil)
		frame.Icon:SetDrawLayer("BORDER", 5)
		S:ReskinIcon(frame.Icon)
	end

	local function SkinDigsiteCompleteAlert(frame)
		if not frame.bg then
			frame:GetRegions():Kill()
			frame.bg = CreateFrame("Frame", nil, frame)
			frame.bg:SetPoint("TOPLEFT", frame, "TOPLEFT", 10, -6)
			frame.bg:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -14, 6)
			frame.bg:SetFrameLevel(frame:GetFrameLevel()-1)
			S:CreateBD(frame.bg)
		end
		frame.DigsiteTypeTexture:SetPoint("LEFT", -10, -14)
	end

	local function SkinStorePurchaseAlert(frame)
		if not frame.bg then
			frame:GetRegions():Kill()
			frame.bg = CreateFrame("Frame", nil, frame)
			frame.bg:SetPoint("TOPLEFT", frame, "TOPLEFT", 10, -6)
			frame.bg:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -14, 6)
			frame.bg:SetFrameLevel(frame:GetFrameLevel()-1)
			S:CreateBD(frame.bg)
		end
		-- Icon
		S:ReskinIcon(frame.Icon)
	end

	local function SkinGarrisonFollowerAlert(_, _, _, _, quality)
		local color = BAG_ITEM_QUALITY_COLORS[quality]
		if color and quality > 1 then
			GarrisonFollowerAlertFrame.PortraitFrame.squareBG:SetBackdropBorderColor(color.r, color.g, color.b)
		else
			GarrisonFollowerAlertFrame.PortraitFrame.squareBG:SetBackdropBorderColor(0, 0, 0)
		end
	end

	local function SkinLootUpgradeAlert(frame)
		if not frame.bg then
			local bg = CreateFrame("Frame", nil, frame)
			bg:SetPoint("TOPLEFT", 10, -10)
			bg:SetPoint("BOTTOMRIGHT", -10, 10)
			bg:SetFrameLevel(frame:GetFrameLevel()-1)
			S:CreateBD(bg)
			frame.bg = bg

			frame.Background:Hide()

			S:ReskinIcon(frame.icon)
			frame.Icon:SetDrawLayer("BORDER", 5)
			frame.Icon:ClearAllPoints()
			frame.Icon:SetPoint("CENTER", frame.BaseQualityBorder)
		end

		frame.BaseQualityBorder:SetTexture(R["media"].gloss)
		frame.UpgradeQualityBorder:SetTexture(R["media"].gloss)
		frame.BaseQualityBorder:SetSize(52, 52)
		frame.UpgradeQualityBorder:SetSize(52, 52)
		frame.BaseQualityBorder:SetVertexColor(frame.BaseQualityItemName:GetTextColor())
		frame.UpgradeQualityBorder:SetVertexColor(frame.UpgradeQualityItemName:GetTextColor())
	end

	local function SkinLegendaryItemAlert(frame, itemLink)
		local _, _, itemRarity = GetItemInfo(itemLink)
		local color = ITEM_QUALITY_COLORS[itemRarity]
		if color and itemRarity > 1 then
			frame.Icon.b:SetBackdropBorderColor(color.r, color.g, color.b)
		else
			frame.Icon.b:SetBackdropBorderColor(0, 0, 0)
		end
	end

	--[[ HOOKS ]]--
	-- Achievements
	hooksecurefunc(AchievementAlertSystem, "setUpFunction", SkinAchievementAlert)
	hooksecurefunc(CriteriaAlertSystem, "setUpFunction", SkinCriteriaAlert)

	-- Encounters
	hooksecurefunc(DungeonCompletionAlertSystem, "setUpFunction", SkinDungeonCompletionAlert)
	hooksecurefunc(GuildChallengeAlertSystem, "setUpFunction", SkinGuildChallengeAlert)
	hooksecurefunc(InvasionAlertSystem, "setUpFunction", SkinInvasionAlert)
	hooksecurefunc(ScenarioAlertSystem, "setUpFunction", SkinScenarioAlert)
	hooksecurefunc(WorldQuestCompleteAlertSystem, "setUpFunction", SkinWorldQuestCompleteAlert)

	-- Garrisons
	hooksecurefunc(GarrisonFollowerAlertSystem, "setUpFunction", SkinGarrisonFollowerAlert)

	-- Loot
	hooksecurefunc(LegendaryItemAlertSystem, "setUpFunction", SkinLegendaryItemAlert)
	hooksecurefunc(LootAlertSystem, "setUpFunction", SkinLootWonAlert)
	hooksecurefunc(LootUpgradeAlertSystem, "setUpFunction", SkinLootUpgradeAlert)
	hooksecurefunc(MoneyWonAlertSystem, "setUpFunction", SkinMoneyWonAlert)
	hooksecurefunc(StorePurchaseAlertSystem, "setUpFunction", SkinStorePurchaseAlert)
	-- Professions
	hooksecurefunc(DigsiteCompleteAlertSystem, "setUpFunction", SkinDigsiteCompleteAlert)
	hooksecurefunc(NewRecipeLearnedAlertSystem, "setUpFunction", SkinNewRecipeLearnedAlert)

	--[[ STATIC SKINNING ]]--
	-- Garrison building alert
	do
		local frame = GarrisonBuildingAlertFrame
		local icon = frame.Icon

		frame:GetRegions():Hide()

		frame.bg = CreateFrame("Frame", nil, frame)
		frame.bg:SetPoint("TOPLEFT", frame, "TOPLEFT", 8, -8)
		frame.bg:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -6, 8)
		frame.bg:SetFrameLevel(frame:GetFrameLevel()-1)
		S:CreateBD(frame.bg)

		icon:SetDrawLayer("ARTWORK")
		S:ReskinIcon(icon)
	end

	-- Garrison mission alert
	do
		local frame = GarrisonMissionAlertFrame

		frame.Background:Hide()
		frame.IconBG:Hide()

		frame.bg = CreateFrame("Frame", nil, frame)
		frame.bg:SetPoint("TOPLEFT", frame, "TOPLEFT", 8, -8)
		frame.bg:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -6, 8)
		frame.bg:SetFrameLevel(frame:GetFrameLevel()-1)
		S:CreateBD(frame.bg)
	end

	-- Garrison follower alert
	do
		local frame = GarrisonFollowerAlertFrame

		--Background
		for i = 1, frame:GetNumRegions() do
			local region = select(i, frame:GetRegions())
			if region:GetObjectType() == "Texture" then
				if region:GetAtlas() == "Garr_MissionToast" then
					region:Kill()
				end 
			end
		end
		frame.FollowerBG:SetAlpha(0)
		frame.DieIcon:SetAlpha(0)

		frame.bg = CreateFrame("Frame", nil, frame)
		frame.bg:SetPoint("TOPLEFT", frame, "TOPLEFT", 16, -3)
		frame.bg:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -16, 16)
		frame.bg:SetFrameLevel(frame:GetFrameLevel()-1)
		S:CreateBD(frame.bg)

		frame.PortraitFrame.PortraitRing:Kill()
		frame.PortraitFrame.PortraitRingQuality:Kill()
		frame.PortraitFrame.LevelBorder:Kill()

		local level = frame.PortraitFrame.Level
		local cover = frame.PortraitFrame.PortraitRingCover

		level:ClearAllPoints()
		level:SetPoint("BOTTOM", frame.PortraitFrame, 0, 12)

		local squareBG = CreateFrame("Frame", nil, frame.PortraitFrame)
		squareBG:SetFrameLevel(frame.PortraitFrame:GetFrameLevel()-1)
		squareBG:SetPoint("TOPLEFT", 3, -3)
		squareBG:SetPoint("BOTTOMRIGHT", -3, 11)
		S:CreateBD(squareBG)
		frame.PortraitFrame.squareBG = squareBG

		if cover then
			cover:SetColorTexture(0, 0, 0)
			cover:SetAllPoints(squareBG)
		end
	end

	--Scenario Legion Invasion Alert Frame
	do
		local frame = ScenarioLegionInvasionAlertFrame
		frame.bg = CreateFrame("Frame", nil, frame)
		frame.bg:Point("TOPLEFT", frame, "TOPLEFT", -2, -6)
		frame.bg:Point("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -2, 6)
		frame.bg:SetFrameLevel(frame:GetFrameLevel()-1)
		S:CreateBD(frame.bg)
		--Background contains the item border too, so have to remove it
		local region, icon = frame:GetRegions()
		if region and region:GetObjectType() == "Texture"then
			if region:GetAtlas() == "legioninvasion-Toast-Frame" then
				region:Kill()
			end
		end
		-- Icon border
		if icon and icon:GetObjectType() == "Texture"then
			if icon:GetTexture() == "Interface\\Icons\\Ability_Warlock_DemonicPower" then
				icon:SetDrawLayer("ARTWORK")
				S:ReskinIcon(icon)
			end
		end
	end

	-- World Quest Complete Alert
	do
		local frame = WorldQuestCompleteAlertFrame
		frame.bg = CreateFrame("Frame", nil, frame)
		frame.bg:Point("TOPLEFT", frame, "TOPLEFT", -2, -6)
		frame.bg:Point("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -2, 6)
		frame.bg:SetFrameLevel(frame:GetFrameLevel()-1)
		S:CreateBD(frame.bg)
		-- Background
		for i = 1, frame:GetNumRegions() do
			local region = select(i, frame:GetRegions())
			if region:GetObjectType() == "Texture" then
				if region:GetTexture() == "Interface\\LFGFrame\\UI-LFG-DUNGEONTOAST" then
					region:Kill()
				end
			end
		end
		--Icon
		frame.QuestTexture:SetDrawLayer("ARTWORK")
		S:ReskinIcon(frame.QuestTexture)
	end

	--Legendary Item Alert
	do
		local frame = LegendaryItemAlertFrame
		frame.Background:Kill()
		frame.Background2:Kill()
		frame.Background3:Kill()
		frame.Ring1:Kill()
		frame.Particles3:Kill()
		frame.Particles2:Kill()
		frame.Particles1:Kill()
		--Icon
		frame.Icon:SetTexCoord(.08, .92, .08, .92)
		frame.Icon:SetDrawLayer("ARTWORK")
		frame.Icon.b = CreateFrame("Frame", nil, frame)
		S:CreateBD(frame.Icon.b)
		frame.Icon.b:SetOutside(frame.Icon)
		frame.Icon:SetParent(frame.Icon.b)
		--Create Backdrop
		frame.bg = CreateFrame("Frame", nil, frame)
		frame.bg:Point("TOPLEFT", frame, "TOPLEFT", 30, -20)
		frame.bg:Point("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -10, 20)
		frame.bg:SetFrameLevel(frame:GetFrameLevel()-1)
		S:CreateBD(frame.bg)
	end

	-- Garrison ship mission alert
	do
		local frame = GarrisonShipMissionAlertFrame
		frame.Background:Kill()
		--Icon
		frame.MissionType:SetDrawLayer("ARTWORK")
		S:ReskinIcon(frame.MissionType)
		--Create Backdrop
		frame.bg = CreateFrame("Frame", nil, frame)
		frame.bg:Point("TOPLEFT", frame, "TOPLEFT", 8, -2)
		frame.bg:Point("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -6, 2)
		frame.bg:SetFrameLevel(frame:GetFrameLevel()-1)
		S:CreateBD(frame.bg)
	end
	
	-- Garrison random mission alert
	do
		local frame = GarrisonRandomMissionAlertFrame
		frame.Background:Kill()
		frame.Blank:Kill()
		frame.IconBG:Kill()
		--Icon
		frame.MissionType:SetDrawLayer("ARTWORK")
		S:ReskinIcon(frame.MissionType)
		--Create Backdrop
		frame.bg = CreateFrame("Frame", nil, frame)
		frame.bg:Point("TOPLEFT", frame, "TOPLEFT", 8, -2)
		frame.bg:Point("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -6, 2)
		frame.bg:SetFrameLevel(frame:GetFrameLevel()-1)
		S:CreateBD(frame.bg)
	end

	-- Garrison random mission alert
	do
		local frame = GarrisonTalentAlertFrame
		frame:GetRegions():Kill()
		--Icon
		frame.Icon:SetDrawLayer("ARTWORK")
		S:ReskinIcon(frame.Icon)
		--Create Backdrop
		frame.bg = CreateFrame("Frame", nil, frame)
		frame.bg:Point("TOPLEFT", frame, "TOPLEFT", 8, -2)
		frame.bg:Point("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -6, 2)
		frame.bg:SetFrameLevel(frame:GetFrameLevel()-1)
		S:CreateBD(frame.bg)
	end

	AlertFrame:ClearAllPoints()
	AlertFrame:SetAllPoints(AlertFrameHolder)

	SlashCmdList.TEST_ACHIEVEMENT = function()
		PlaySound("LFG_Rewards")
		AchievementFrame_LoadUI()
		AchievementAlertSystem:ShowAlert(5780)
		AchievementAlertSystem:ShowAlert(5000)
		CriteriaAlertSystem:ShowAlert(5780)
		NewRecipeLearnedAlertSystem:ShowAlert(2330)

		local _, itemLink = GetItemInfo(6948)
		LegendaryItemAlertSystem:ShowAlert(itemLink)
		LootAlertSystem:ShowAlert(itemLink, -1, 1, 1)
		MoneyWonAlertSystem:ShowAlert(1)
	end
	SLASH_TEST_ACHIEVEMENT1 = "/testalerts"
end

S:AddCallback("Alerts", LoadSkin)
