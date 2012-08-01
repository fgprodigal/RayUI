local R, L, P = unpack(select(2, ...)) --Inport: Engine, Locales, ProfileDB
local S = R:GetModule("Skins")

local function LoadSkin()
	local AlertFrameHolder = CreateFrame("Frame", "AlertFrameHolder", UIParent)
	AlertFrameHolder:SetWidth(180)
	AlertFrameHolder:SetHeight(20)
	AlertFrameHolder:SetPoint("CENTER", UIParent, "CENTER", 0, 250)

	local POSITION, ANCHOR_POINT, YOFFSET = "TOP", "BOTTOM", -10

	hooksecurefunc("AlertFrame_SetAchievementAnchors", function(anchorFrame)
		for i=1, MAX_ACHIEVEMENT_ALERTS do
			local frame = _G["AchievementAlertFrame"..i]
			if frame then
                frame:SetAlpha(1)
                frame.SetAlpha = R.dummy
                if not frame.bg then
                    frame.bg = CreateFrame("Frame", nil, frame)
                    frame.bg:SetPoint("TOPLEFT", _G[frame:GetName().."Background"], "TOPLEFT", -2, -6)
                    frame.bg:SetPoint("BOTTOMRIGHT", _G[frame:GetName().."Background"], "BOTTOMRIGHT", -2, 6)
                    frame.bg:SetFrameLevel(frame:GetFrameLevel()-1)

					if not _G["AchievementAlertFrame"..i.."IconTexture"].b then
						_G["AchievementAlertFrame"..i.."IconTexture"].b = CreateFrame("Frame", nil, frame)
						_G["AchievementAlertFrame"..i.."IconTexture"].b:Point("TOPLEFT", _G["AchievementAlertFrame"..i.."IconTexture"], "TOPLEFT", -1, 1)
						_G["AchievementAlertFrame"..i.."IconTexture"].b:Point("BOTTOMRIGHT", _G["AchievementAlertFrame"..i.."IconTexture"], "BOTTOMRIGHT", 1, -1)
						_G["AchievementAlertFrame"..i.."IconTexture"]:SetParent(_G["AchievementAlertFrame"..i.."IconTexture"].b)
						S:CreateBD(_G["AchievementAlertFrame"..i.."IconTexture"].b, 0)
					end

                    frame:HookScript("OnEnter", function()
                        S:CreateBD(frame.bg)
                    end)

                    frame.animIn:HookScript("OnFinished", function()
                        S:CreateBD(frame.bg)
                    end)
                end
                S:CreateBD(frame.bg)

                _G["AchievementAlertFrame"..i.."Background"]:SetTexture(nil)

                _G["AchievementAlertFrame"..i.."Unlocked"]:SetTextColor(1, 1, 1)
                _G["AchievementAlertFrame"..i.."Unlocked"]:SetShadowOffset(1, -1)

                _G["AchievementAlertFrame"..i.."IconTexture"]:SetTexCoord(.08, .92, .08, .92)
                _G["AchievementAlertFrame"..i.."IconOverlay"]:Hide()
			end
		end
	end)

	hooksecurefunc("AlertFrame_SetDungeonCompletionAnchors", function(anchorFrame)
		for i = 1, DUNGEON_COMPLETION_MAX_REWARDS do
			local frame = _G["DungeonCompletionAlertFrame"..i]
			if frame then
                frame:SetAlpha(1)
                frame.SetAlpha = R.dummy
                if not frame.bg then
                    frame.bg = CreateFrame("Frame", nil, frame)
                    frame.bg:SetPoint("TOPLEFT", frame, "TOPLEFT", -2, -6)
                    frame.bg:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -2, 6)
                    frame.bg:SetFrameLevel(frame:GetFrameLevel()-1)
					
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

					if not frame.dungeonTexture.b then
						frame.dungeonTexture.b = CreateFrame("Frame", nil, frame)
						frame.dungeonTexture.b:Point("TOPLEFT", frame.dungeonTexture, "TOPLEFT", -1, 1)
						frame.dungeonTexture.b:Point("BOTTOMRIGHT", frame.dungeonTexture, "BOTTOMRIGHT", 1, -1)
						frame.dungeonTexture:SetParent(frame.dungeonTexture.b)
						S:CreateBD(frame.dungeonTexture.b, 0)
					end

                    frame:HookScript("OnEnter", function()
                        S:CreateBD(frame.bg)
                    end)

                    frame.animIn:HookScript("OnFinished", function()
                        S:CreateBD(frame.bg)
                    end)
                end
                S:CreateBD(frame.bg)
			end
		end		
	end)

	hooksecurefunc("AlertFrame_SetGuildChallengeAnchors", function(anchorFrame)
		local frame = GuildChallengeAlertFrame

		if frame then
			frame:SetAlpha(1)
			frame.SetAlpha = R.dummy

			if not frame.bg then
				frame.bg = CreateFrame("Frame", nil, frame)
				frame.bg:SetPoint("TOPLEFT", frame, "TOPLEFT", -2, -6)
				frame.bg:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -2, 6)
				frame.bg:SetFrameLevel(frame:GetFrameLevel()-1)
				
				-- Background
				-- local region = select(2, frame:GetRegions())
				-- if region:GetObjectType() == "Texture" then
					-- if region:GetTexture() == "Interface\\GuildFrame\\GuildChallenges" then
						-- region:Kill()
					-- end
				-- end
				for i=1, GuildChallengeAlertFrame:GetNumRegions() do
					local region = select(i, GuildChallengeAlertFrame:GetRegions()) 
					if region and region:GetObjectType() == "Texture" and not region:GetName() then
						region:Kill()
					end
				end

				GuildChallengeAlertFrameEmblemBorder:Kill()

				-- Icon border
				if not GuildChallengeAlertFrameEmblemIcon.b then
					GuildChallengeAlertFrameEmblemIcon.b = CreateFrame("Frame", nil, frame)
					GuildChallengeAlertFrameEmblemIcon.b:Point("TOPLEFT", GuildChallengeAlertFrameEmblemIcon, "TOPLEFT", -2, 1)
					GuildChallengeAlertFrameEmblemIcon.b:Point("BOTTOMRIGHT", GuildChallengeAlertFrameEmblemIcon, "BOTTOMRIGHT", 2, -1)
					GuildChallengeAlertFrameEmblemIcon:SetParent(GuildChallengeAlertFrameEmblemIcon.b)
					S:CreateBD(GuildChallengeAlertFrameEmblemIcon.b, 0)
				end

				frame:HookScript("OnEnter", function()
					S:CreateBD(frame.bg)
				end)

				frame.animIn:HookScript("OnFinished", function()
					S:CreateBD(frame.bg)
				end)
			end
			S:CreateBD(frame.bg)
			SetLargeGuildTabardTextures("player", GuildChallengeAlertFrameEmblemIcon, nil, nil)
		end	
	end)

	hooksecurefunc("AlertFrame_SetChallengeModeAnchors", function(anchorFrame)
		local frame = ChallengeModeAlertFrame1

		if frame then
			frame:SetAlpha(1)
			frame.SetAlpha = R.dummy

			if not frame.bg then
				frame.bg = CreateFrame("Frame", nil, frame)
				frame.bg:SetPoint("TOPLEFT", frame, "TOPLEFT", 19, -6)
				frame.bg:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -22, 6)
				frame.bg:SetFrameLevel(frame:GetFrameLevel()-1)

				-- Background
				for i = 1, frame:GetNumRegions() do
					local region = select(i, frame:GetRegions())
					if region and region:GetObjectType() == "Texture" and not region:GetName() then
						region:Kill()
					end
				end

				ChallengeModeAlertFrame1Border:Kill()

				-- Icon
				ChallengeModeAlertFrame1DungeonTexture:SetTexCoord(0.1, 0.9, 0.1, 0.9)
				ChallengeModeAlertFrame1DungeonTexture:ClearAllPoints()
				ChallengeModeAlertFrame1DungeonTexture:Point("LEFT", frame.bg, 9, 0)

				-- Icon border
				if not ChallengeModeAlertFrame1DungeonTexture.b then
					ChallengeModeAlertFrame1DungeonTexture.b = CreateFrame("Frame", nil, frame)
					ChallengeModeAlertFrame1DungeonTexture.b:Point("TOPLEFT", ChallengeModeAlertFrame1DungeonTexture, "TOPLEFT", -1, 1)
					ChallengeModeAlertFrame1DungeonTexture.b:Point("BOTTOMRIGHT", ChallengeModeAlertFrame1DungeonTexture, "BOTTOMRIGHT", 1, -1)
					ChallengeModeAlertFrame1DungeonTexture:SetParent(ChallengeModeAlertFrame1DungeonTexture.b)
					S:CreateBD(ChallengeModeAlertFrame1DungeonTexture.b, 0)
				end

				frame:HookScript("OnEnter", function()
                        S:CreateBD(frame.bg)
                    end)

                    frame.animIn:HookScript("OnFinished", function()
                        S:CreateBD(frame.bg)
                    end)
			end
			S:CreateBD(frame.bg)
		end	
	end)

	hooksecurefunc("AlertFrame_SetScenarioAnchors", function(anchorFrame)
		local frame = ScenarioAlertFrame1

		if frame then
			frame:SetAlpha(1)
			frame.SetAlpha = R.dummy

			if not frame.bg then
				frame.bg = CreateFrame("Frame", nil, frame)
				frame.bg:SetPoint("TOPLEFT", frame, "TOPLEFT", 4, -4)
				frame.bg:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -7, 6)
				frame.bg:SetFrameLevel(frame:GetFrameLevel()-1)

				-- Background
				for i = 1, frame:GetNumRegions() do
					local region = select(i, frame:GetRegions())
					if region and region:GetObjectType() == "Texture" and not region:GetName() then
						region:Kill()
					end
				end

				-- Icon
				ScenarioAlertFrame1DungeonTexture:SetTexCoord(0.1, 0.9, 0.1, 0.9)
				ScenarioAlertFrame1DungeonTexture:ClearAllPoints()
				ScenarioAlertFrame1DungeonTexture:Point("LEFT", frame.bg, 9, 0)

				-- Icon border
				if not ScenarioAlertFrame1DungeonTexture.b then
					ScenarioAlertFrame1DungeonTexture.b = CreateFrame("Frame", nil, frame)
					ScenarioAlertFrame1DungeonTexture.b:Point("TOPLEFT", ScenarioAlertFrame1DungeonTexture, "TOPLEFT", -1, 1)
					ScenarioAlertFrame1DungeonTexture.b:Point("BOTTOMRIGHT", ScenarioAlertFrame1DungeonTexture, "BOTTOMRIGHT", 1, -1)
					ScenarioAlertFrame1DungeonTexture:SetParent(ScenarioAlertFrame1DungeonTexture.b)
					S:CreateBD(ScenarioAlertFrame1DungeonTexture.b, 0)
				end

				frame:HookScript("OnEnter", function()
                        S:CreateBD(frame.bg)
                    end)

                    frame.animIn:HookScript("OnFinished", function()
                        S:CreateBD(frame.bg)
                    end)
			end
			S:CreateBD(frame.bg)
		end
	end)
	
	hooksecurefunc("AlertFrame_SetCriteriaAnchors", function()
		for i = 1, MAX_ACHIEVEMENT_ALERTS do
			local frame = _G["CriteriaAlertFrame"..i]
			if frame then
				frame:SetAlpha(1)
				frame.SetAlpha = R.dummy

				if not frame.bg then
					frame.bg = CreateFrame("Frame", nil, frame)
					frame.bg:SetPoint("TOPLEFT", frame, "TOPLEFT", 40, -6)
					frame.bg:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -2, 6)
					frame.bg:SetFrameLevel(frame:GetFrameLevel()-1)

					_G["CriteriaAlertFrame"..i.."Unlocked"]:SetTextColor(1, 1, 1)
					_G["CriteriaAlertFrame"..i.."Name"]:SetTextColor(1, 1, 0)
					_G["CriteriaAlertFrame"..i.."Background"]:Kill()
					_G["CriteriaAlertFrame"..i.."IconBling"]:Kill()
					_G["CriteriaAlertFrame"..i.."IconOverlay"]:Kill()

					-- Icon border
					if not _G["CriteriaAlertFrame"..i.."IconTexture"].b then
						_G["CriteriaAlertFrame"..i.."IconTexture"].b = CreateFrame("Frame", nil, frame)
						_G["CriteriaAlertFrame"..i.."IconTexture"].b:Point("TOPLEFT", _G["CriteriaAlertFrame"..i.."IconTexture"], "TOPLEFT", -2, 1)
						_G["CriteriaAlertFrame"..i.."IconTexture"].b:Point("BOTTOMRIGHT", _G["CriteriaAlertFrame"..i.."IconTexture"], "BOTTOMRIGHT", 2, -1)
						_G["CriteriaAlertFrame"..i.."IconTexture"]:SetParent(_G["CriteriaAlertFrame"..i.."IconTexture"].b)
						S:CreateBD(_G["CriteriaAlertFrame"..i.."IconTexture"].b, 0)
					end
					_G["CriteriaAlertFrame"..i.."IconTexture"]:SetTexCoord(.08, .92, .08, .92)

					 frame:HookScript("OnEnter", function()
                        S:CreateBD(frame.bg)
                    end)

                    frame.animIn:HookScript("OnFinished", function()
                        S:CreateBD(frame.bg)
                    end)
				end
				S:CreateBD(frame.bg)
			end	
		end
	end)

	hooksecurefunc("AlertFrame_SetLootWonAnchors", function()
		for i=1, #LOOT_WON_ALERT_FRAMES do
			local frame = LOOT_WON_ALERT_FRAMES[i]
			if frame then
				frame:SetAlpha(1)
				frame.SetAlpha = R.dummy

				if not frame.bg then
					frame.bg = CreateFrame("Frame", nil, frame)
					frame.bg:SetPoint("TOPLEFT", frame, "TOPLEFT", 8, -8)
					frame.bg:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -6, 8)
					frame.bg:SetFrameLevel(frame:GetFrameLevel()-1)

					frame.Background:Kill()
					frame.Icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
					frame.IconBorder:Kill()

					-- Icon border
					if not frame.Icon.b then
						frame.Icon.b = CreateFrame("Frame", nil, frame)
						frame.Icon.b:Point("TOPLEFT", frame.Icon, "TOPLEFT", -1, 1)
						frame.Icon.b:Point("BOTTOMRIGHT", frame.Icon, "BOTTOMRIGHT", 1, -1)
						frame.Icon:SetParent(frame.Icon.b)
						S:CreateBD(frame.Icon.b, 0)
					end

					frame:HookScript("OnEnter", function()
                        S:CreateBD(frame.bg)
                    end)

                    frame.animIn:HookScript("OnFinished", function()
                        S:CreateBD(frame.bg)
                    end)
				end				
			end
		end	
	end)

	hooksecurefunc("AlertFrame_SetMoneyWonAnchors", function()
		for i=1, #MONEY_WON_ALERT_FRAMES do
			local frame = MONEY_WON_ALERT_FRAMES[i]
			if frame then
				frame:SetAlpha(1)
				frame.SetAlpha = R.dummy

				if not frame.bg then
					frame.bg = CreateFrame("Frame", nil, frame)
					frame.bg:SetPoint("TOPLEFT", frame, "TOPLEFT", 8, -8)
					frame.bg:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -6, 8)
					frame.bg:SetFrameLevel(frame:GetFrameLevel()-1)

					frame.Background:Kill()
					frame.Icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
					frame.IconBorder:Kill()

					-- Icon border
					if not frame.Icon.b then
						frame.Icon.b = CreateFrame("Frame", nil, frame)
						frame.Icon.b:Point("TOPLEFT", frame.Icon, "TOPLEFT", -1, 1)
						frame.Icon.b:Point("BOTTOMRIGHT", frame.Icon, "BOTTOMRIGHT", 1, -1)
						frame.Icon:SetParent(frame.Icon.b)
						S:CreateBD(frame.Icon.b, 0)
					end

					frame:HookScript("OnEnter", function()
                        S:CreateBD(frame.bg)
                    end)

                    frame.animIn:HookScript("OnFinished", function()
                        S:CreateBD(frame.bg)
                    end)
				end				
			end
		end
	end)	

	hooksecurefunc("AlertFrame_FixAnchors", function()	
		if POSITION == "TOP" then
			ANCHOR_POINT = "BOTTOM"
			YOFFSET = -10
		else
			ANCHOR_POINT = "TOP"
			YOFFSET = 10
		end

		AlertFrame:ClearAllPoints()
		AlertFrame:SetAllPoints(AlertFrameHolder)

		GroupLootContainer:ClearAllPoints()
		GroupLootContainer:SetPoint(POSITION, AlertFrame, ANCHOR_POINT)
		
		MissingLootFrame:ClearAllPoints()
		MissingLootFrame:SetPoint(POSITION, AlertFrame, ANCHOR_POINT)
		
		if pos == "TOP" or pos == "BOTTOM" then
			AlertFrame_FixAnchors()
		end
	end)

	hooksecurefunc("AlertFrame_SetLootWonAnchors", function(alertAnchor)
		for i=1, #LOOT_WON_ALERT_FRAMES do
			local frame = LOOT_WON_ALERT_FRAMES[i]
			if ( frame:IsShown() ) then
				frame:ClearAllPoints()
				frame:SetPoint(POSITION, alertAnchor, ANCHOR_POINT, 0, YOFFSET)
				alertAnchor = frame
			end
		end
	end)

	hooksecurefunc("AlertFrame_SetMoneyWonAnchors", function(alertAnchor)
		for i=1, #MONEY_WON_ALERT_FRAMES do
			local frame = MONEY_WON_ALERT_FRAMES[i]
			if ( frame:IsShown() ) then
				frame:ClearAllPoints()
				frame:SetPoint(POSITION, alertAnchor, ANCHOR_POINT, 0, YOFFSET)
				alertAnchor = frame
			end
		end
	end)

	hooksecurefunc("AlertFrame_SetAchievementAnchors", function(alertAnchor)
		if ( AchievementAlertFrame1 ) then
			for i = 1, MAX_ACHIEVEMENT_ALERTS do
				local frame = _G["AchievementAlertFrame"..i]
				if ( frame and frame:IsShown() ) then
					frame:ClearAllPoints()
					frame:SetPoint(POSITION, alertAnchor, ANCHOR_POINT, 0, YOFFSET)
					alertAnchor = frame
				end
			end
		end
	end)

	hooksecurefunc("AlertFrame_SetCriteriaAnchors", function(alertAnchor)
		if ( CriteriaAlertFrame1 ) then
			for i = 1, MAX_ACHIEVEMENT_ALERTS do
				local frame = _G["CriteriaAlertFrame"..i]
				if ( frame and frame:IsShown() ) then
					frame:ClearAllPoints()
					frame:SetPoint(POSITION, alertAnchor, ANCHOR_POINT, 0, YOFFSET)
					alertAnchor = frame
				end
			end
		end
	end)

	hooksecurefunc("AlertFrame_SetChallengeModeAnchors", function(alertAnchor)
		local frame = ChallengeModeAlertFrame1
		if ( frame:IsShown() ) then
			frame:ClearAllPoints()
			frame:SetPoint(POSITION, alertAnchor, ANCHOR_POINT, 0, YOFFSET)
		end
	end)

	hooksecurefunc("AlertFrame_SetDungeonCompletionAnchors", function(alertAnchor)
		local frame = DungeonCompletionAlertFrame1
		if ( frame:IsShown() ) then
			frame:ClearAllPoints()
			frame:SetPoint(POSITION, alertAnchor, ANCHOR_POINT, 0, YOFFSET)
		end
	end)

	hooksecurefunc("AlertFrame_SetScenarioAnchors", function(alertAnchor)
		local frame = ScenarioAlertFrame1
		if ( frame:IsShown() ) then
			frame:ClearAllPoints()
			frame:SetPoint(POSITION, alertAnchor, ANCHOR_POINT, 0, YOFFSET)
		end
	end)

	hooksecurefunc("AlertFrame_SetGuildChallengeAnchors", function(alertAnchor)
		local frame = GuildChallengeAlertFrame
		if ( frame:IsShown() ) then
			frame:ClearAllPoints()
			frame:SetPoint(POSITION, alertAnchor, ANCHOR_POINT, 0, YOFFSET)
		end
	end)

	SlashCmdList.TEST_ACHIEVEMENT = function()
		PlaySound("LFG_Rewards")
		AchievementFrame_LoadUI()
		AchievementAlertFrame_ShowAlert(5780)
		AchievementAlertFrame_ShowAlert(5000)
		GuildChallengeAlertFrame_ShowAlert(3, 2, 5)
		ChallengeModeAlertFrame_ShowAlert()
		CriteriaAlertFrame_GetAlertFrame()
		AlertFrame_AnimateIn(CriteriaAlertFrame1)
		AlertFrame_AnimateIn(DungeonCompletionAlertFrame1)
		AlertFrame_AnimateIn(ScenarioAlertFrame1)

		local _, itemLink = GetItemInfo(6948)
		LootWonAlertFrame_ShowAlert(itemLink, -1, 1, 1)
		MoneyWonAlertFrame_ShowAlert(1)

		AlertFrame_FixAnchors()
	end
	SLASH_TEST_ACHIEVEMENT1 = "/testalerts"
end

S:RegisterSkin("RayUI", LoadSkin)
