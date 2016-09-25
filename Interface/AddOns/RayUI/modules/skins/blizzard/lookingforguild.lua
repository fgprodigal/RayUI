local R, L, P, G = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, GlobalDB
local S = R:GetModule("Skins")

local function LoadSkin()
	local r, g, b = S["media"].classcolours[R.myclass].r, S["media"].classcolours[R.myclass].g, S["media"].classcolours[R.myclass].b
	
	S:SetBD(LookingForGuildFrame)
	S:CreateBD(LookingForGuildInterestFrame, .25)
	LookingForGuildInterestFrameBg:Hide()
	S:CreateBD(LookingForGuildAvailabilityFrame, .25)
	LookingForGuildAvailabilityFrameBg:Hide()
	S:CreateBD(LookingForGuildRolesFrame, .25)
	LookingForGuildRolesFrameBg:Hide()
	S:CreateBD(LookingForGuildCommentFrame, .25)
	LookingForGuildCommentFrameBg:Hide()
	S:CreateBD(LookingForGuildCommentInputFrame, .12)
	LookingForGuildFrame:DisableDrawLayer("BACKGROUND")
	LookingForGuildFrame:DisableDrawLayer("BORDER")
	LookingForGuildFrameInset:DisableDrawLayer("BACKGROUND")
	LookingForGuildFrameInset:DisableDrawLayer("BORDER")
	S:CreateBD(GuildFinderRequestMembershipFrame)
	for i = 1, 9 do
		select(i, LookingForGuildCommentInputFrame:GetRegions()):Hide()
	end
	for i = 1, 3 do
		for j = 1, 6 do
			select(j, _G["LookingForGuildFrameTab"..i]:GetRegions()):Hide()
			select(j, _G["LookingForGuildFrameTab"..i]:GetRegions()).Show = R.dummy
		end
	end
	for i = 1, 6 do
		select(i, GuildFinderRequestMembershipFrameInputFrame:GetRegions()):Hide()
	end
	LookingForGuildFrameTabardBackground:Hide()
	LookingForGuildFrameTabardEmblem:Hide()
	LookingForGuildFrameTabardBorder:Hide()
	LookingForGuildFramePortraitFrame:Hide()
	LookingForGuildFrameTopBorder:Hide()
	LookingForGuildFrameTopRightCorner:Hide()

	S:Reskin(LookingForGuildBrowseButton)
	S:Reskin(GuildFinderRequestMembershipFrameAcceptButton)
	S:Reskin(GuildFinderRequestMembershipFrameCancelButton)
	S:ReskinClose(LookingForGuildFrameCloseButton)
	S:ReskinCheck(LookingForGuildQuestButton)
	S:ReskinCheck(LookingForGuildDungeonButton)
	S:ReskinCheck(LookingForGuildRaidButton)
	S:ReskinCheck(LookingForGuildPvPButton)
	S:ReskinCheck(LookingForGuildRPButton)
	S:ReskinCheck(LookingForGuildWeekdaysButton)
	S:ReskinCheck(LookingForGuildWeekendsButton)
	S:ReskinInput(GuildFinderRequestMembershipFrameInputFrame)

	-- [[ Browse frame ]]

	S:Reskin(LookingForGuildRequestButton)
	S:ReskinScroll(LookingForGuildBrowseFrameContainerScrollBar)

	for i = 1, 5 do
		local bu = _G["LookingForGuildBrowseFrameContainerButton"..i]

		bu:SetBackdrop(nil)
		bu:SetHighlightTexture("")

		-- my client crashes if I put this in a var? :x
		bu:GetRegions():SetTexture(R["media"].blank)
		bu:GetRegions():SetVertexColor(r, g, b, .2)
		bu:GetRegions():SetPoint("TOPLEFT", 1, -1)
		bu:GetRegions():SetPoint("BOTTOMRIGHT", -1, 2)

		local bg = S:CreateBDFrame(bu, .25)
		bg:SetPoint("TOPLEFT")
		bg:SetPoint("BOTTOMRIGHT", 0, 1)
	end

	-- [[ Role buttons ]]

	for _, roleButton in pairs({LookingForGuildTankButton, LookingForGuildHealerButton, LookingForGuildDamagerButton}) do
		S:ReskinCheck(roleButton.checkButton)
	end
end

S:AddCallbackForAddon("Blizzard_LookingForGuildUI", "LookingForGuild", LoadSkin)
