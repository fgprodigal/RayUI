local R, L, P = unpack(select(2, ...)) --Inport: Engine, Locales, ProfileDB
local S = R:GetModule("Skins")

local function LoadSkin()
	S:SetBD(LFDParentFrame)
	S:Reskin(LFDQueueFrameFindGroupButton)
	S:Reskin(LFDQueueFrameCancelButton)
	S:Reskin(LFDRoleCheckPopupAcceptButton)
	S:Reskin(LFDRoleCheckPopupDeclineButton)
	S:Reskin(LFDQueueFramePartyBackfillBackfillButton)
	S:Reskin(RaidFinderQueueFramePartyBackfillBackfillButton)
	S:Reskin(LFDQueueFramePartyBackfillNoBackfillButton)
	S:Reskin(RaidFinderQueueFramePartyBackfillNoBackfillButton)
	S:ReskinClose(LFDParentFrameCloseButton)
	S:ReskinClose(LFGDungeonReadyStatusCloseButton)
	S:ReskinCheck(LFGInvitePopupRoleButtonTank:GetChildren())
	S:ReskinCheck(LFGInvitePopupRoleButtonHealer:GetChildren())
	S:ReskinCheck(LFGInvitePopupRoleButtonDPS:GetChildren())
	S:CreateBD(LFGInvitePopup)
	S:CreateSD(LFGInvitePopup)
	S:ReskinCheck(LFDQueueFrameRoleButtonTank:GetChildren())
	S:ReskinCheck(LFDQueueFrameRoleButtonHealer:GetChildren())
	S:ReskinCheck(LFDQueueFrameRoleButtonDPS:GetChildren())
	S:ReskinCheck(LFDQueueFrameRoleButtonLeader:GetChildren())
	S:ReskinCheck(LFDRoleCheckPopupRoleButtonTank:GetChildren())
	S:ReskinCheck(LFDRoleCheckPopupRoleButtonHealer:GetChildren())
	S:ReskinCheck(LFDRoleCheckPopupRoleButtonDPS:GetChildren())
	S:ReskinScroll(LFDQueueFrameSpecificListScrollFrameScrollBar)
	S:ReskinScroll(LFDQueueFrameRandomScrollFrameScrollBar)
	S:ReskinDropDown(LFDQueueFrameTypeDropDown)

	LFDParentFrame:DisableDrawLayer("BACKGROUND")
	LFDParentFrame:DisableDrawLayer("BORDER")
	LFDParentFrame:DisableDrawLayer("OVERLAY")
	LFDParentFrameInset:DisableDrawLayer("BACKGROUND")
	LFDParentFrameInset:DisableDrawLayer("BORDER")
	LFDParentFrameEyeFrame:Hide()
	LFDQueueFrameCapBarShadow:Hide()
	LFDQueueFrameBackground:Hide()
	LFDQueueFrameCooldownFrameBlackFilter:SetAlpha(.6)
	LFDQueueFrameRandomScrollFrameScrollBackground:Hide()
	LFDQueueFramePartyBackfill:SetAlpha(.6)
	LFDQueueFrameCancelButton_LeftSeparator:Hide()
	LFDQueueFrameFindGroupButton_RightSeparator:Hide()
	LFDQueueFrameSpecificListScrollFrameScrollBackgroundTopLeft:Hide()
	LFDQueueFrameSpecificListScrollFrameScrollBackgroundBottomRight:Hide()
	LFDQueueFrameSpecificListScrollFrameScrollBarScrollDownButton:SetPoint("TOP", LFDQueueFrameSpecificListScrollFrameScrollBar, "BOTTOM", 0, 2)
	LFDQueueFrameRandomScrollFrameScrollBarScrollDownButton:SetPoint("TOP", LFDQueueFrameRandomScrollFrameScrollBar, "BOTTOM", 0, 2)

	LFDQueueFrameCapBarProgress:SetTexture(S["media"].backdrop)
	LFDQueueFrameCapBarCap1:SetTexture(S["media"].backdrop)
	LFDQueueFrameCapBarCap2:SetTexture(S["media"].backdrop)

	LFDQueueFrameCapBarLeft:Hide()
	LFDQueueFrameCapBarMiddle:Hide()
	LFDQueueFrameCapBarRight:Hide()
	LFDQueueFrameCapBarBG:SetTexture(nil)

	LFDQueueFrameCapBar.backdrop = CreateFrame("Frame", nil, LFDQueueFrameCapBar)
	LFDQueueFrameCapBar.backdrop:SetPoint("TOPLEFT", LFDQueueFrameCapBar, "TOPLEFT", -1, -2)
	LFDQueueFrameCapBar.backdrop:SetPoint("BOTTOMRIGHT", LFDQueueFrameCapBar, "BOTTOMRIGHT", 1, 2)
	LFDQueueFrameCapBar.backdrop:SetFrameLevel(0)
	S:CreateBD(LFDQueueFrameCapBar.backdrop)

	for i = 1, 4 do
		_G["LFDQueueFrameCapBarDivider"..i]:Hide()
	end

	for i = 1, 2 do
		local bu = _G["LFDQueueFrameCapBarCap"..i.."Marker"]
		_G["LFDQueueFrameCapBarCap"..i.."MarkerTexture"]:Hide()

		local cap = bu:CreateTexture(nil, "OVERLAY")
		cap:SetSize(1, 14)
		cap:SetPoint("CENTER")
		cap:SetTexture(S["media"].backdrop)
		cap:SetVertexColor(0, 0, 0)
	end

	LFDQueueFrameRandomScrollFrame:SetWidth(304)

	local function ReskinRewards()
		for i = 1, LFD_MAX_REWARDS do
			local button = _G["LFDQueueFrameRandomScrollFrameChildFrameItem"..i]
			local icon = _G["LFDQueueFrameRandomScrollFrameChildFrameItem"..i.."IconTexture"]

			if button then
				icon:SetTexCoord(.08, .92, .08, .92)
				if not button.reskinned then
					local cta = _G["LFDQueueFrameRandomScrollFrameChildFrameItem"..i.."ShortageBorder"]
					local count = _G["LFDQueueFrameRandomScrollFrameChildFrameItem"..i.."Count"]
					local na = _G["LFDQueueFrameRandomScrollFrameChildFrameItem"..i.."NameFrame"]

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

	LFGDungeonReadyDialog.SetBackdrop = R.dummy
	LFGDungeonReadyDialogBackground:Hide()
	LFGDungeonReadyDialogBottomArt:Hide()
	LFGDungeonReadyDialogFiligree:Hide()
	S:Reskin(LFGDungeonReadyDialogEnterDungeonButton)
	S:Reskin(LFGDungeonReadyDialogLeaveQueueButton)
	S:Reskin(LFDQueueFrameNoLFDWhileLFRLeaveQueueButton)
end

S:RegisterSkin("RayUI", LoadSkin)