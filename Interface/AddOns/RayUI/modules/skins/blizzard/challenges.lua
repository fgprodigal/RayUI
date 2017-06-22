----------------------------------------------------------
-- Load RayUI Environment
----------------------------------------------------------
RayUI:LoadEnv("Skins")


local S = _Skins

local function LoadSkin()
	ChallengesFrameInset:DisableDrawLayer("BORDER")
	ChallengesFrameInsetBg:Kill()

	ChallengesFrame.WeeklyBest.Child.Star:Hide()
	ChallengesFrame.WeeklyBest.Child.Glow:Hide()
	ChallengesFrame.WeeklyBest.Child.Level:SetPoint("CENTER", ChallengesModeWeeklyBest.Child.Star, "CENTER", 0, 3)
    ChallengesFrame.WeeklyBest.Child.Label:ClearAllPoints()
 	ChallengesFrame.WeeklyBest.Child.Label:Point("TOPLEFT", ChallengesFrame.WeeklyBest.Child.Star, "TOPRIGHT", -16, 1)
 	ChallengesFrame.GuildBest:ClearAllPoints()
 	ChallengesFrame.GuildBest:Point("TOPLEFT", ChallengesFrame.WeeklyBest.Child.Star, "BOTTOMRIGHT", -16, 50)

	S:CreateBD(ChallengesFrame.GuildBest, .3)

	select(1, ChallengesFrame.GuildBest:GetRegions()):Hide()
	select(3, ChallengesFrame.GuildBest:GetRegions()):Hide()

	for i = 1, 2 do
		select(i, ChallengesFrame:GetRegions()):Hide()
	end

	hooksecurefunc("ChallengesFrame_Update", function()
		for i = 1, #ChallengesFrame.DungeonIcons do
			local bu = ChallengesFrame.DungeonIcons[i]
			if bu then
				select(1, bu:GetRegions()):Hide()
				bu.Icon:SetTexCoord(.08, .92, .08, .92)
				S:CreateBD(bu, .25)
			end
		end
	end)
end

S:AddCallbackForAddon("Blizzard_ChallengesUI", "Challenges", LoadSkin)
