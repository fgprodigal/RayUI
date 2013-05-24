local R, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local S = R:GetModule("Skins")

local function LoadSkin()
	ItemUpgradeFrame:DisableDrawLayer("BACKGROUND")
	ItemUpgradeFrame:DisableDrawLayer("BORDER")
	ItemUpgradeFrameMoneyFrameLeft:Hide()
	ItemUpgradeFrameMoneyFrameMiddle:Hide()
	ItemUpgradeFrameMoneyFrameRight:Hide()
	ItemUpgradeFrame.ButtonFrame:GetRegions():Hide()
	ItemUpgradeFrame.ButtonFrame.ButtonBorder:Hide()
	ItemUpgradeFrame.ButtonFrame.ButtonBottomBorder:Hide()
	ItemUpgradeFrame.ItemButton.Frame:Hide()
	ItemUpgradeFrame.ItemButton.Grabber:Hide()
	ItemUpgradeFrame.ItemButton.TextFrame:Hide()
	ItemUpgradeFrame.ItemButton.TextGrabber:Hide()

	S:CreateBD(ItemUpgradeFrame.ItemButton, .25)
	ItemUpgradeFrame.ItemButton:SetHighlightTexture("")
	ItemUpgradeFrame.ItemButton:SetPushedTexture("")
	ItemUpgradeFrame.ItemButton.IconTexture:Point("TOPLEFT", 1, -1)
	ItemUpgradeFrame.ItemButton.IconTexture:Point("BOTTOMRIGHT", -1, 1)

	local bg = CreateFrame("Frame", nil, ItemUpgradeFrame.ItemButton)
	bg:SetSize(341, 50)
	bg:SetPoint("LEFT", ItemUpgradeFrame.ItemButton, "RIGHT", -1, 0)
	bg:SetFrameLevel(ItemUpgradeFrame.ItemButton:GetFrameLevel()-1)
	S:CreateBD(bg, .25)

	ItemUpgradeFrame.ItemButton:HookScript("OnEnter", function(self)
		self:SetBackdropBorderColor(1, .56, .85)
	end)
	ItemUpgradeFrame.ItemButton:HookScript("OnLeave", function(self)
		self:SetBackdropBorderColor(0, 0, 0)
	end)

	hooksecurefunc("ItemUpgradeFrame_Update", function()
		if GetItemUpgradeItemInfo() then
			ItemUpgradeFrame.ItemButton.IconTexture:SetTexCoord(.08, .92, .08, .92)
		else
			ItemUpgradeFrame.ItemButton.IconTexture:SetTexture("")
		end
	end)

	local bg = CreateFrame("Frame", nil, ItemUpgradeFrame)
	bg:SetAllPoints(ItemUpgradeFrame)
	bg:SetFrameLevel(ItemUpgradeFrame:GetFrameLevel()-1)
	S:CreateBD(bg)

	S:ReskinPortraitFrame(ItemUpgradeFrame)
	S:Reskin(ItemUpgradeFrameUpgradeButton)
end

S:RegisterSkin("Blizzard_ItemUpgradeUI", LoadSkin)
