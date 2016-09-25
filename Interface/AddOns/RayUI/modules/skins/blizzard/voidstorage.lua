local R, L, P, G = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, GlobalDB
local S = R:GetModule("Skins")

local function LoadSkin()
	S:SetBD(VoidStorageFrame, 20, 0, 0, 20)
	S:CreateBD(VoidStoragePurchaseFrame)
	for i = 1, 10 do
		select(i, VoidStoragePurchaseFrame:GetRegions()):Hide()
	end
	VoidStorageBorderFrame:DisableDrawLayer("BACKGROUND")
	VoidStorageBorderFrame:DisableDrawLayer("BORDER")
	VoidStorageBorderFrame:DisableDrawLayer("BACKGROUND")
	VoidStorageBorderFrame:DisableDrawLayer("OVERLAY")
	VoidStorageDepositFrame:DisableDrawLayer("BACKGROUND")
	VoidStorageDepositFrame:DisableDrawLayer("BORDER")
	VoidStorageWithdrawFrame:DisableDrawLayer("BACKGROUND")
	VoidStorageWithdrawFrame:DisableDrawLayer("BORDER")
	VoidStorageCostFrame:DisableDrawLayer("BACKGROUND")
	VoidStorageCostFrame:DisableDrawLayer("BORDER")
	VoidStorageStorageFrame:DisableDrawLayer("BACKGROUND")
	VoidStorageStorageFrame:DisableDrawLayer("BORDER")
	VoidStorageFrameMarbleBg:Hide()
	select(2, VoidStorageFrame:GetRegions()):Hide()
	VoidStorageFrameLines:Hide()
	VoidStorageStorageFrameLine1:Hide()
	VoidStorageStorageFrameLine2:Hide()
	VoidStorageStorageFrameLine3:Hide()
	VoidStorageStorageFrameLine4:Hide()
	select(12, VoidStorageDepositFrame:GetRegions()):Hide()
	select(12, VoidStorageWithdrawFrame:GetRegions()):Hide()

	for _, voidButton in pairs({"VoidStorageDepositButton", "VoidStorageWithdrawButton"}) do
		for i = 1, 9 do
			local bu = _G[voidButton..i]
			local border = bu.IconBorder

			bu:SetPushedTexture("")
			_G[voidButton..i.."Bg"]:Hide()

			bu.icon:SetTexCoord(.08, .92, .08, .92)

			border:SetTexture(R["media"].blank)
			border:SetPoint("TOPLEFT", -1, 1)
			border:SetPoint("BOTTOMRIGHT", 1, -1)
			border:SetDrawLayer("BACKGROUND")

			S:CreateBDFrame(bu, .25)
		end
	end

	for i = 1, 80 do
		local bu = _G["VoidStorageStorageButton"..i]
		local buB = bu.IconBorder
		local buS = bu.searchOverlay

		_G["VoidStorageStorageButton"..i.."Bg"]:Hide()
		_G["VoidStorageStorageButton"..i.."IconTexture"]:SetTexCoord(.08, .92, .08, .92)
		
		buB:SetTexture(R["media"].blank)
		buB:SetPoint("TOPLEFT", -1, 1)
		buB:SetPoint("BOTTOMRIGHT", 1, -1)
		buB:SetDrawLayer("BACKGROUND")

		S:CreateBDFrame(bu, .25)

		buS:SetPoint("TOPLEFT", -1, 1)
		buS:SetPoint("BOTTOMRIGHT", 1, -1)
	end

	for i = 1, 2 do
		local tab = VoidStorageFrame["Page"..i]

		tab:GetRegions():Hide()
		tab:SetCheckedTexture(S["media"].checked)

		S:CreateBG(tab)
		S:CreateSD(tab, 5, 0, 0, 0, 1, 1)

		tab:GetNormalTexture():SetTexCoord(.08, .92, .08, .92)
	end

	VoidStorageFrame.Page1:ClearAllPoints()
	VoidStorageFrame.Page1:SetPoint("LEFT", VoidStorageFrame, "TOPRIGHT", 13, -60)

	S:Reskin(VoidStoragePurchaseButton)
	S:Reskin(VoidStorageHelpBoxButton)
	S:Reskin(VoidStorageTransferButton)
	S:ReskinClose(VoidStorageBorderFrame:GetChildren(), nil)
	S:ReskinInput(VoidItemSearchBox)
end

S:AddCallbackForAddon("Blizzard_VoidStorageUI", "VoidStorage", LoadSkin)
