local R, L, P, G = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, GlobalDB
local S = R:GetModule("Skins")

local function LoadSkin()
	ChallengesFrameInset:DisableDrawLayer("BORDER")
	ChallengesFrameInsetBg:Kill()

	ChallengesModeWeeklyBest.Child.Star:Hide()
	ChallengesModeWeeklyBest.Child.Glow:Hide()
	ChallengesModeWeeklyBest.Child.Level:SetPoint("CENTER", ChallengesModeWeeklyBest.Child.Star, "CENTER", 0, 3)
	
	S:CreateBD(ChallengesFrame.GuildBest, .3)
	
	select(1, ChallengesFrame.GuildBest:GetRegions()):Hide()
	select(3, ChallengesFrame.GuildBest:GetRegions()):Hide()
	
	for i = 1, 2 do
		select(i, ChallengesFrame:GetRegions()):Hide()
	end

	hooksecurefunc("ChallengesFrame_Update", function()
		for i = 1, 9 do
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
