local R, L, P = unpack(select(2, ...)) --Inport: Engine, Locales, ProfileDB
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
	for i = 1, 5 do
		local bu = _G["LookingForGuildBrowseFrameContainerButton"..i]
		S:CreateBD(bu, .25)
		bu:SetHighlightTexture("")
		bu:GetRegions():SetTexture(S["media"].backdrop)
		bu:GetRegions():SetVertexColor(r, g, b, .2)
	end
	for i = 1, 9 do
		select(i, LookingForGuildCommentInputFrame:GetRegions()):Hide()
	end
	for i = 1, 3 do
		for j = 1, 6 do
			select(j, _G["LookingForGuildFrameTab"..i]:GetRegions()):Hide()
			select(j, _G["LookingForGuildFrameTab"..i]:GetRegions()).Show = R.dummy
		end
	end
	LookingForGuildFrameTabardBackground:Hide()
	LookingForGuildFrameTabardEmblem:Hide()
	LookingForGuildFrameTabardBorder:Hide()
	LookingForGuildFramePortraitFrame:Hide()
	LookingForGuildFrameTopBorder:Hide()
	LookingForGuildFrameTopRightCorner:Hide()
	LookingForGuildBrowseButton_LeftSeparator:Hide()
	LookingForGuildRequestButton_RightSeparator:Hide()

	S:Reskin(LookingForGuildBrowseButton)
	S:Reskin(LookingForGuildRequestButton)

	S:ReskinScroll(LookingForGuildBrowseFrameContainerScrollBar)
	S:ReskinClose(LookingForGuildFrameCloseButton)
	S:ReskinCheck(LookingForGuildQuestButton)
	S:ReskinCheck(LookingForGuildDungeonButton)
	S:ReskinCheck(LookingForGuildRaidButton)
	S:ReskinCheck(LookingForGuildPvPButton)
	S:ReskinCheck(LookingForGuildRPButton)
	S:ReskinCheck(LookingForGuildWeekdaysButton)
	S:ReskinCheck(LookingForGuildWeekendsButton)
	S:ReskinCheck(LookingForGuildTankButton:GetChildren())
	S:ReskinCheck(LookingForGuildHealerButton:GetChildren())
	S:ReskinCheck(LookingForGuildDamagerButton:GetChildren())
	S:CreateBD(GuildFinderRequestMembershipFrame)
	S:CreateSD(GuildFinderRequestMembershipFrame)
	for i = 1, 6 do
		select(i, GuildFinderRequestMembershipFrameInputFrame:GetRegions()):Hide()
	end
	S:Reskin(GuildFinderRequestMembershipFrameAcceptButton)
	S:Reskin(GuildFinderRequestMembershipFrameCancelButton)
	S:ReskinInput(GuildFinderRequestMembershipFrameInputFrame)
end

S:RegisterSkin("Blizzard_LookingForGuildUI", LoadSkin)