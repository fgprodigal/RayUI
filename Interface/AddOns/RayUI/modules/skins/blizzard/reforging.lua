local R, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local S = R:GetModule("Skins")

local function LoadSkin()
	S:SetBD(ReforgingFrame)
	ReforgingFrame:DisableDrawLayer("BACKGROUND")
	ReforgingFrame:DisableDrawLayer("BORDER")
	ReforgingFramePortrait:Hide()
	ReforgingFrameBg:Hide()
	ReforgingFrameTitleBg:Hide()
	ReforgingFramePortraitFrame:Hide()
	ReforgingFrameTopBorder:Hide()
	ReforgingFrameTopRightCorner:Hide()
	ReforgingFrameRestoreButton_LeftSeparator:Hide()
	ReforgingFrameRestoreButton_RightSeparator:Hide()
	S:Reskin(ReforgingFrameRestoreButton)
	S:Reskin(ReforgingFrameReforgeButton)
	S:ReskinClose(ReforgingFrameCloseButton)
	ReforgingFrameRestoreButton:ClearAllPoints()
	ReforgingFrameRestoreButton:SetPoint("LEFT", ReforgingFrameMoneyFrame, "RIGHT", 60, 0)
	ReforgingFrameReforgeButton:ClearAllPoints()
	ReforgingFrameReforgeButton:SetPoint("LEFT", ReforgingFrameRestoreButton, "RIGHT", 1, 0)
	
	ReforgingFrame.ButtonFrame:GetRegions():Hide()
	ReforgingFrame.ButtonFrame.ButtonBorder:Hide()
	ReforgingFrame.ButtonFrame.ButtonBottomBorder:Hide()
	ReforgingFrame.ButtonFrame.MoneyLeft:Hide()
	ReforgingFrame.ButtonFrame.MoneyRight:Hide()
	ReforgingFrame.ButtonFrame.MoneyMiddle:Hide()
	ReforgingFrame.ItemButton.Frame:Hide()
	ReforgingFrame.ItemButton.Grabber:Hide()
	ReforgingFrame.ItemButton.TextFrame:Hide()
	ReforgingFrame.ItemButton.TextGrabber:Hide()

	S:CreateBD(ReforgingFrame.ItemButton, .25)
	ReforgingFrame.ItemButton:SetHighlightTexture("")
	ReforgingFrame.ItemButton:SetPushedTexture("")

	ReforgingFrame.ItemButton:HookScript("OnEnter", function(self)
		self:SetBackdropBorderColor(1, .56, .85)
	end)
	ReforgingFrame.ItemButton:HookScript("OnLeave", function(self)
		self:SetBackdropBorderColor(0, 0, 0)
	end)

	local bg = CreateFrame("Frame", nil, ReforgingFrame.ItemButton)
	bg:SetSize(341, 50)
	bg:SetPoint("LEFT", ReforgingFrame.ItemButton, "RIGHT", -1, 0)
	bg:SetFrameLevel(ReforgingFrame.ItemButton:GetFrameLevel()-1)
	S:CreateBD(bg, .25)

	ReforgingFrame.RestoreMessage:SetTextColor(.9, .9, .9)

	hooksecurefunc("ReforgingFrame_Update", function()
		local _, icon = GetReforgeItemInfo()
		if not icon then
			ReforgingFrame.ItemButton.IconTexture:SetTexture("")
		else
			ReforgingFrame.ItemButton.IconTexture:SetTexCoord(.08, .92, .08, .92)
		end
	end)

	ReforgingFrameRestoreButton:SetPoint("LEFT", ReforgingFrameMoneyFrame, "RIGHT", 0, 1)
end

S:RegisterSkin("Blizzard_ReforgingUI", LoadSkin)