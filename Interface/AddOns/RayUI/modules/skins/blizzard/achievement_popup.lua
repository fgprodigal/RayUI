local R, L, P = unpack(select(2, ...)) --Inport: Engine, Locales, ProfileDB
local S = R:GetModule("Skins")

local function LoadSkin()
	----AchievementAlertFrame_ShowAlert(50)  测试位置
	local AchievementHolder = CreateFrame("Frame", "AchievementHolder", UIParent)
	AchievementHolder:SetWidth(180)
	AchievementHolder:SetHeight(20)
	AchievementHolder:SetPoint("CENTER", UIParent, "CENTER", 0, 170)

	local function ReskinAchievementPopup(self, event, ...)
		local previousFrame
		for i=1, MAX_ACHIEVEMENT_ALERTS do
			local frame = _G["AchievementAlertFrame"..i]
			if frame then
                frame:SetAlpha(1)
                frame.SetAlpha = R.dummy
				frame:ClearAllPoints()

                if not frame.bg then
                    frame.bg = CreateFrame("Frame", nil, frame)
                    frame.bg:SetPoint("TOPLEFT", _G[frame:GetName().."Background"], "TOPLEFT", -2, -6)
                    frame.bg:SetPoint("BOTTOMRIGHT", _G[frame:GetName().."Background"], "BOTTOMRIGHT", -2, 8)
                    frame.bg:SetFrameLevel(frame:GetFrameLevel()-1)

                    local iconbd = CreateFrame("Frame", nil, frame)
                    iconbd:Point("TOPLEFT", _G["AchievementAlertFrame"..i.."IconTexture"], "TOPLEFT", -1, 1)
                    iconbd:Point("BOTTOMRIGHT", _G["AchievementAlertFrame"..i.."IconTexture"], "BOTTOMRIGHT", 1, -1)
                    S:CreateBD(iconbd, 0)

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

				if ( previousFrame and previousFrame:IsShown() ) then
					frame:SetPoint("TOP", previousFrame, "BOTTOM", 0, -10)
				else
					frame:SetPoint("TOP", AchievementHolder, "BOTTOM")
				end
				previousFrame = frame
			end
		end

	end

	hooksecurefunc("AchievementAlertFrame_FixAnchors", ReskinAchievementPopup)

	hooksecurefunc("DungeonCompletionAlertFrame_FixAnchors", function()
		for i=MAX_ACHIEVEMENT_ALERTS, 1, -1 do
			local frame = _G["AchievementAlertFrame"..i]
			if ( frame and frame:IsShown() ) then
				DungeonCompletionAlertFrame1:ClearAllPoints()
				DungeonCompletionAlertFrame1:SetPoint("TOP", frame, "BOTTOM", 0, -10)
				return
			end
			DungeonCompletionAlertFrame1:ClearAllPoints()
			DungeonCompletionAlertFrame1:SetPoint("TOP", AchievementHolder, "BOTTOM")
		end
	end)

	local achieveframe = CreateFrame("Frame")
	achieveframe:RegisterEvent("ACHIEVEMENT_EARNED")
	achieveframe:SetScript("OnEvent", function(self, event, ...) ReskinAchievementPopup(self, event, ...) end)

	S:SetBD(DungeonCompletionAlertFrame1, 6, -14, -6, 6)

	DungeonCompletionAlertFrame1DungeonTexture:SetDrawLayer("ARTWORK")
	DungeonCompletionAlertFrame1DungeonTexture:SetTexCoord(.02, .98, .02, .98)
	S:CreateBG(DungeonCompletionAlertFrame1DungeonTexture)

	for i = 2, 6 do
		select(i, DungeonCompletionAlertFrame1:GetRegions()):Hide()
	end

	hooksecurefunc("DungeonCompletionAlertFrame_ShowAlert", function()
		for i = 1, 3 do
			local bu = _G["DungeonCompletionAlertFrame1Reward"..i]
			if bu and not bu.reskinned then
				local ic = _G["DungeonCompletionAlertFrame1Reward"..i.."Texture"]
				_G["DungeonCompletionAlertFrame1Reward"..i.."Border"]:Hide()

				ic:SetTexCoord(.08, .92, .08, .92)
				S:CreateBG(ic)

				bu.rekinned = true
			end
		end
		for i = 2, 6 do
			select(i, DungeonCompletionAlertFrame1:GetRegions()):Hide()
		end
	end)

	--Guild Alert
	--/run GuildChallengeAlertFrame_ShowAlert(3, 2, 5)
	hooksecurefunc("GuildChallengeAlertFrame_FixAnchors", function()
		local frame
		for i=MAX_ACHIEVEMENT_ALERTS, 1, -1 do
			if _G["AchievementAlertFrame"..i] and _G["AchievementAlertFrame"..i]:IsShown() then
				frame = _G["AchievementAlertFrame"..i]
			end
		end

		if DungeonCompletionAlertFrame1:IsShown() then
			frame = DungeonCompletionAlertFrame1
		end

		if frame == nil then
			frame = AchievementHolder
		end

		GuildChallengeAlertFrame:ClearAllPoints()
		if pos == "TOP" then
			GuildChallengeAlertFrame:SetPoint("TOP", frame, "BOTTOM", 0, -10)
		else
			GuildChallengeAlertFrame:SetPoint("BOTTOM", frame, "TOP", 0, 10)
		end
	end)

	for i=1, GuildChallengeAlertFrame:GetNumRegions() do
		local region = select(i, GuildChallengeAlertFrame:GetRegions()) 
		if region and region:GetObjectType() == "Texture" and not region:GetName() then
			region:SetTexture(nil)
		end
	end

	S:SetBD(GuildChallengeAlertFrame)
	GuildChallengeAlertFrame:Height(65)
end

S:RegisterSkin("RayUI", LoadSkin)
