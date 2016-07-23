local R, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local S = R:GetModule("Skins")

local function LoadSkin()
	local AlertFrameHolder = CreateFrame("Frame", "AlertFrameHolder", UIParent)
	AlertFrameHolder:SetWidth(180)
	AlertFrameHolder:SetHeight(20)
	AlertFrameHolder:SetPoint("CENTER", UIParent, "CENTER", 0, 100)

	local POSITION, ANCHOR_POINT, YOFFSET = "TOP", "BOTTOM", -10

	hooksecurefunc(AchievementAlertSystem, "setUpFunction", function(frame)
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
	end)

	hooksecurefunc(DungeonCompletionAlertSystem, "setUpFunction", function(frame)
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
	end)

	hooksecurefunc(GuildChallengeAlertSystem, "setUpFunction", function(frame)
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
	end)

	hooksecurefunc(ScenarioAlertSystem, "setUpFunction", function(frame)
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
	end)
	
	hooksecurefunc(CriteriaAlertSystem, "setUpFunction", function(frame)
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
	end)

	hooksecurefunc(LootAlertSystem, "setUpFunction", function(frame)
		if not frame.bg then
			frame.bg = CreateFrame("Frame", nil, frame)
			frame.bg:SetPoint("TOPLEFT", frame, "TOPLEFT", 8, -8)
			frame.bg:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -6, 8)
			frame.bg:SetFrameLevel(frame:GetFrameLevel()-1)
			S:CreateBD(frame.bg)

			-- Icon border
			frame.Icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
			S:CreateBG(frame.Icon)
		end
		frame.Icon:SetDrawLayer("BORDER")
		frame.Background:Kill()
		frame.BGAtlas:Kill()
		frame.PvPBackground:Kill()
		frame.IconBorder:Kill()
	end)

	hooksecurefunc(MoneyWonAlertSystem, "setUpFunction", function(frame)
		if not frame.bg then
			frame.bg = CreateFrame("Frame", nil, frame)
			frame.bg:SetPoint("TOPLEFT", frame, "TOPLEFT", 8, -8)
			frame.bg:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -6, 8)
			frame.bg:SetFrameLevel(frame:GetFrameLevel()-1)
			S:CreateBD(frame.bg)

			-- Icon border
			frame.Icon:SetDrawLayer("ARTWORK")
			frame.Icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
			S:CreateBG(frame.Icon)
		end
		frame.IconBorder:Kill()
		frame.Background:Kill()
	end)	

	-- Digsite completion alert

	do
		local frame = DigsiteCompleteToastFrame
		local icon = frame.DigsiteTypeTexture

		S:CreateBD(frame)

		frame:GetRegions():Hide()
	end

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

		icon:SetTexCoord(.08, .92, .08, .92)
		icon:SetDrawLayer("ARTWORK")
		S:CreateBG(icon)
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

		frame:GetRegions():Hide()
		frame.FollowerBG:SetAlpha(0)

		frame.bg = CreateFrame("Frame", nil, frame)
		frame.bg:SetPoint("TOPLEFT", frame, "TOPLEFT", 16, -3)
		frame.bg:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -16, 16)
		frame.bg:SetFrameLevel(frame:GetFrameLevel()-1)
		S:CreateBD(frame.bg)

		local level = frame.PortraitFrame.Level
		local cover = frame.PortraitFrame.PortraitRingCover

		frame.PortraitFrame.PortraitRing:Hide()
		frame.PortraitFrame.PortraitRingQuality:SetTexture("")

		frame.PortraitFrame.LevelBorder:SetColorTexture(0, 0, 0, .5)
		frame.PortraitFrame.LevelBorder:SetSize(44, 11)
		frame.PortraitFrame.LevelBorder:ClearAllPoints()
		frame.PortraitFrame.LevelBorder:SetPoint("BOTTOM", 0, 12)

		level:ClearAllPoints()
		level:SetPoint("BOTTOM", frame.PortraitFrame, 0, 12)

		local squareBG = CreateFrame("Frame", nil, frame.PortraitFrame)
		squareBG:SetFrameLevel(frame.PortraitFrame:GetFrameLevel()-1)
		squareBG:SetPoint("TOPLEFT", 3, -3)
		squareBG:SetPoint("BOTTOMRIGHT", -3, 11)
		S:CreateBD(squareBG, 1)
		frame.PortraitFrame.squareBG = squareBG

		if cover then
			cover:SetColorTexture(0, 0, 0)
			cover:SetAllPoints(squareBG)
		end
	end

	hooksecurefunc(GarrisonFollowerAlertSystem, "setUpFunction", function(_, _, _, _, quality)
		local color = BAG_ITEM_QUALITY_COLORS[quality]
		if color then
			GarrisonFollowerAlertFrame.PortraitFrame.squareBG:SetBackdropBorderColor(color.r, color.g, color.b)
		else
			GarrisonFollowerAlertFrame.PortraitFrame.squareBG:SetBackdropBorderColor(0, 0, 0)
		end
	end)

	hooksecurefunc(LootUpgradeAlertSystem, "setUpFunction", function(frame)
		if not frame.bg then
			local bg = CreateFrame("Frame", nil, frame)
			bg:SetPoint("TOPLEFT", 10, -10)
			bg:SetPoint("BOTTOMRIGHT", -10, 10)
			bg:SetFrameLevel(frame:GetFrameLevel()-1)
			S:CreateBD(bg)
			frame.bg = bg

			frame.Background:Hide()

			frame.Icon:SetTexCoord(.08, .92, .08, .92)
			S:CreateBG(frame.icon)
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
	end)

	AlertFrame:ClearAllPoints()
	AlertFrame:SetAllPoints(AlertFrameHolder)

	SlashCmdList.TEST_ACHIEVEMENT = function()
		PlaySound("LFG_Rewards")
		AchievementFrame_LoadUI()
		AchievementAlertSystem:ShowAlert(5780)
		AchievementAlertSystem:ShowAlert(5000)
		CriteriaAlertSystem:ShowAlert(5780)
		-- AlertFrame_AnimateIn(DungeonCompletionAlertFrame1)
		-- AlertFrame_AnimateIn(ScenarioAlertFrame1)

		local _, itemLink = GetItemInfo(6948)
		LootAlertSystem:ShowAlert(itemLink, -1, 1, 1)
		MoneyWonAlertSystem:ShowAlert(1)

		-- AlertFrame_FixAnchors()
	end
	SLASH_TEST_ACHIEVEMENT1 = "/testalerts"
end

S:RegisterSkin("RayUI", LoadSkin)
