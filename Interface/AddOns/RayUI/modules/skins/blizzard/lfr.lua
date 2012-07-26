local R, L, P = unpack(select(2, ...)) --Inport: Engine, Locales, ProfileDB
local S = R:GetModule("Skins")

local function LoadSkin()
	S:Reskin(LFRQueueFrameFindGroupButton)
	S:Reskin(LFRQueueFrameAcceptCommentButton)
	S:Reskin(LFRBrowseFrameSendMessageButton)
	S:Reskin(LFRBrowseFrameInviteButton)
	S:Reskin(LFRBrowseFrameRefreshButton)
	S:ReskinCheck(LFRQueueFrameRoleButtonTank:GetChildren())
	S:ReskinCheck(LFRQueueFrameRoleButtonHealer:GetChildren())
	S:ReskinCheck(LFRQueueFrameRoleButtonDPS:GetChildren())
	S:ReskinDropDown(LFRBrowseFrameRaidDropDown)
	LFRQueueFrame:DisableDrawLayer("BACKGROUND")
	LFRBrowseFrame:DisableDrawLayer("BACKGROUND")
	for i = 1, 7 do
		_G["LFRBrowseFrameColumnHeader"..i]:DisableDrawLayer("BACKGROUND")
	end
	S:SetBD(RaidParentFrame)
	RaidParentFrame:DisableDrawLayer("BACKGROUND")
	RaidParentFrame:DisableDrawLayer("BORDER")
	RaidParentFrameInset:DisableDrawLayer("BORDER")
	RaidFinderFrameRoleInset:DisableDrawLayer("BORDER")
	LFRQueueFrameRoleInset:DisableDrawLayer("BORDER")
	LFRQueueFrameListInset:DisableDrawLayer("BORDER")
	LFRQueueFrameCommentInset:DisableDrawLayer("BORDER")
	LFRQueueFrameRoleInsetBg:Hide()
	LFRQueueFrameListInsetBg:Hide()
	LFRQueueFrameCommentInsetBg:Hide()
	RaidFinderQueueFrameBackground:Hide()
	RaidParentFrameInsetBg:Hide()
	RaidFinderFrameRoleInsetBg:Hide()
	RaidFinderFrameRoleBackground:Hide()
	RaidParentFramePortraitFrame:Hide()
	RaidParentFramePortrait:Hide()
	RaidParentFrameTopBorder:Hide()
	RaidParentFrameTopRightCorner:Hide()
	RaidFinderFrameFindRaidButton_RightSeparator:Hide()
	RaidFinderFrameCancelButton_LeftSeparator:Hide()

	for i = 1, 3 do
		S:CreateTab(_G["RaidParentFrameTab"..i])
	end

	for i = 1, 2 do
		local tab = _G["LFRParentFrameSideTab"..i]
		tab:GetRegions():Hide()
		S:CreateBG(tab)
		S:CreateSD(tab, 5, 0, 0, 0, 1, 1)
		select(2, tab:GetRegions()):SetTexCoord(.08, .92, .08, .92)

		if i == 1 then
			local a1, p, a2, x, y = tab:GetPoint()
			tab:SetPoint(a1, p, a2, x + 11, y)
		end

		tab:StyleButton(true)
		tab:SetPushedTexture(nil)
	end

	local function ReskinRewards()
		for i = 1, LFD_MAX_REWARDS do
			local button = _G["RaidFinderQueueFrameScrollFrameChildFrameItem"..i]
			local icon = _G["RaidFinderQueueFrameScrollFrameChildFrameItem"..i.."IconTexture"]

			if button then
				icon:SetTexCoord(.08, .92, .08, .92)
				if not button.reskinned then
					local cta = _G["RaidFinderQueueFrameScrollFrameChildFrameItem"..i.."ShortageBorder"]
					local count = _G["RaidFinderQueueFrameScrollFrameChildFrameItem"..i.."Count"]
					local na = _G["RaidFinderQueueFrameScrollFrameChildFrameItem"..i.."NameFrame"]

					S:CreateBG(icon)
					icon:SetDrawLayer("OVERLAY")
					count:SetDrawLayer("OVERLAY")
					na:SetTexture(0, 0, 0, .25)
					na:SetSize(118, 39)
					cta:SetAlpha(0)

					button.bg2 = CreateFrame("Frame", nil, button)
					button.bg2:SetPoint("TOPLEFT", na, "TOPLEFT", 10, 0)
					button.bg2:SetPoint("BOTTOMRIGHT", na, "BOTTOMRIGHT")
					S:CreateBD(button.bg2, 0)

					button.reskinned = true
				end
			end
		end
	end
	hooksecurefunc("LFDQueueFrameRandom_UpdateFrame", ReskinRewards)

	S:Reskin(RaidFinderFrameFindRaidButton)
	S:Reskin(RaidFinderFrameCancelButton)
	S:Reskin(RaidFinderQueueFrameIneligibleFrameLeaveQueueButton)
	S:ReskinDropDown(RaidFinderQueueFrameSelectionDropDown)
	S:ReskinClose(RaidParentFrameCloseButton)
end

S:RegisterSkin("RayUI", LoadSkin)