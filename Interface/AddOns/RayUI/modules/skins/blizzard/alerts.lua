local R, L, P = unpack(select(2, ...)) --Inport: Engine, Locales, ProfileDB
local S = R:GetModule("Skins")

local function LoadSkin()
	local AlertFrameHolder = CreateFrame("Frame", "AlertFrameHolder", UIParent)
	AlertFrameHolder:SetWidth(180)
	AlertFrameHolder:SetHeight(20)
	AlertFrameHolder:SetPoint("CENTER", UIParent, "CENTER", 0, 210)

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
						_G["AchievementAlertFrame"..i.."IconTexture"].b = S:CreateBG(_G["AchievementAlertFrame"..i.."IconTexture"])
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
				_G["AchievementAlertFrame"..i.."OldAchievement"]:Kill()

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

				-- Icon
				ChallengeModeAlertFrame1DungeonTexture:SetTexCoord(0.1, 0.9, 0.1, 0.9)
				ChallengeModeAlertFrame1DungeonTexture:ClearAllPoints()
				ChallengeModeAlertFrame1DungeonTexture:Point("LEFT", frame.bg, 9, 0)

				-- Icon border
				if not ChallengeModeAlertFrame1DungeonTexture.b then
					ChallengeModeAlertFrame1DungeonTexture.b = S:CreateBG(ChallengeModeAlertFrame1DungeonTexture)
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
                    if region:GetTexture() == "Interface\\Challenges\\challenges-main" then
                        region:Kill()
                    end
                end
            end
            ChallengeModeAlertFrame1Border:Kill()
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
                    if region:GetTexture() == "Interface\\Scenarios\\ScenariosParts" then
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
	
	hooksecurefunc("AlertFrame_SetCriteriaAnchors", function()
		for i = 1, MAX_ACHIEVEMENT_ALERTS do
			local frame = _G["CriteriaAlertFrame"..i]
			if frame then
				frame:SetAlpha(1)
				frame.SetAlpha = R.dummy

				if not frame.bg then
					frame.bg = CreateFrame("Frame", nil, frame)
					frame.bg:SetPoint("TOPLEFT", frame, "TOPLEFT", 39, -6)
					frame.bg:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -2, 6)
					frame.bg:SetFrameLevel(frame:GetFrameLevel()-1)

					-- Icon border
					if not _G["CriteriaAlertFrame"..i.."IconTexture"].b then
                        _G["CriteriaAlertFrame"..i.."IconTexture"].b = CreateFrame("Frame", nil, frame)
                        _G["CriteriaAlertFrame"..i.."IconTexture"].b:SetOutside(_G["CriteriaAlertFrame"..i.."IconTexture"], 1, 1)
                        S:CreateBD(_G["CriteriaAlertFrame"..i.."IconTexture"].b, 0)
					end
					_G["CriteriaAlertFrame"..i.."IconTexture"]:SetTexCoord(.08, .92, .08, .92)

					 frame:HookScript("OnEnter", function()
                        S:CreateBD(_G["CriteriaAlertFrame"..i.."IconTexture"].b, 0)
                        S:CreateBD(frame.bg)
                    end)

                    frame.animIn:HookScript("OnFinished", function()
                        S:CreateBD(_G["CriteriaAlertFrame"..i.."IconTexture"].b, 0)
                        S:CreateBD(frame.bg)
                    end)
				end
                _G["CriteriaAlertFrame"..i.."Unlocked"]:SetTextColor(1, 1, 1)
                _G["CriteriaAlertFrame"..i.."Name"]:SetTextColor(1, 1, 0)
                _G["CriteriaAlertFrame"..i.."Background"]:Kill()
                _G["CriteriaAlertFrame"..i.."IconBling"]:Kill()
                _G["CriteriaAlertFrame"..i.."IconOverlay"]:Kill()
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

					-- Icon border
					if not frame.Icon.b then
						frame.Icon.b = S:CreateBG(frame.Icon)
					end

					frame:HookScript("OnEnter", function()
                        S:CreateBD(frame.bg)
                    end)

                    frame.animIn:HookScript("OnFinished", function()
                        S:CreateBD(frame.bg)
                    end)
                end
                frame.Background:Kill()
                frame.Icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
                frame.IconBorder:Kill()
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

					-- Icon border
					if not frame.Icon.b then
						frame.Icon.b = S:CreateBG(frame.Icon)
					end

					frame:HookScript("OnEnter", function()
                        S:CreateBD(frame.bg)
                    end)

                    frame.animIn:HookScript("OnFinished", function()
                        S:CreateBD(frame.bg)
                    end)
				end
                frame.Background:Kill()
                frame.Icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
                frame.IconBorder:Kill()
			end
		end
	end)	

	hooksecurefunc("AlertFrame_FixAnchors", function(self, screenQuadrant)	
		if POSITION == "TOP" then
			ANCHOR_POINT = "BOTTOM"
			YOFFSET = -10
		else
			ANCHOR_POINT = "TOP"
			YOFFSET = 10
		end
        if type(rollBars) == "table" then
            local lastframe, lastShownFrame
            for i, frame in pairs(rollBars) do
                frame:ClearAllPoints()
                if i ~= 1 then
                    if POSITION == "TOP" then
                        frame:Point("TOP", lastframe, "BOTTOM", 0, -4)
                    else
                        frame:Point("BOTTOM", lastframe, "TOP", 0, 4)
                    end 
                else
                    if POSITION == "TOP" then
                        frame:Point("TOP", AlertFrameHolder, "BOTTOM", 0, -4)
                    else
                        frame:Point("BOTTOM", AlertFrameHolder, "TOP", 0, 4)
                    end
                end
                lastframe = frame

                if frame:IsShown() then
                    lastShownFrame = frame
                end
            end

            AlertFrame:ClearAllPoints()
            if lastShownFrame then
                AlertFrame:SetAllPoints(lastShownFrame)         
            else
                AlertFrame:SetAllPoints(AlertFrameHolder)                   
            end
        else
            AlertFrame:ClearAllPoints()
            AlertFrame:SetAllPoints(AlertFrameHolder)
        end	

		if screenQuadrant then
			AlertFrame_FixAnchors()
		end
	end)

	hooksecurefunc("AlertFrame_SetLootAnchors", function(alertAnchor)
		if ( MissingLootFrame:IsShown() ) then
            MissingLootFrame:ClearAllPoints()
            MissingLootFrame:SetPoint(POSITION, alertAnchor, ANCHOR_POINT)
            if ( GroupLootContainer:IsShown() ) then
                GroupLootContainer:ClearAllPoints()
                GroupLootContainer:SetPoint(POSITION, MissingLootFrame, ANCHOR_POINT, 0, YOFFSET)
            end		
        elseif ( GroupLootContainer:IsShown() ) then
            GroupLootContainer:ClearAllPoints()
            GroupLootContainer:SetPoint(POSITION, alertAnchor, ANCHOR_POINT)	
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

    hooksecurefunc("GroupLootContainer_AddFrame", function()
        AlertFrame_FixAnchors()
    end)

	hooksecurefunc(GroupLootContainer, "SetPoint", function(self, point, anchorTo, attachPoint, xOffset, yOffset)
		if _G[anchorTo] == UIParent then
			AlertFrame_FixAnchors()
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
