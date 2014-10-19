local R, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local S = R:GetModule("Skins")

local function LoadSkin()
	S:SetBD(VoidStorageFrame, 20, 0, 0, 20)
	S:CreateBD(VoidStoragePurchaseFrame)
	for i = 1, 10 do
		select(i, VoidStoragePurchaseFrame:GetRegions()):Hide()
	end
	VoidStorageBorderFrame:SetFrameStrata("HIGH")
	VoidStorageBorderFrame:SetFrameLevel(10)
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

	for i = 1, 9 do
		local bu1 = _G["VoidStorageDepositButton"..i]
		local bu2 = _G["VoidStorageWithdrawButton"..i]

		_G["VoidStorageDepositButton"..i.."Bg"]:Hide()
		_G["VoidStorageWithdrawButton"..i.."Bg"]:Hide()

		_G["VoidStorageDepositButton"..i.."IconTexture"]:SetTexCoord(.08, .92, .08, .92)
		_G["VoidStorageWithdrawButton"..i.."IconTexture"]:SetTexCoord(.08, .92, .08, .92)

		bu1:StyleButton(1)
		if not bu1.border then
			local border = CreateFrame("Frame", nil, bu1)
			border:Point("TOPLEFT", -1, 1)
			border:Point("BOTTOMRIGHT", 1, -1)
			border:SetFrameStrata("BACKGROUND")
			border:SetFrameLevel(0)
			bu1.border = border
			bu1.border:CreateBorder()
		end
		bu1:SetNormalTexture("")
		bu1:SetFrameStrata("HIGH")

		bu2:StyleButton(1)
		if not bu2.border then
			local border = CreateFrame("Frame", nil, bu2)
			border:Point("TOPLEFT", -1, 1)
			border:Point("BOTTOMRIGHT", 1, -1)
			border:SetFrameStrata("BACKGROUND")
			border:SetFrameLevel(0)
			bu2.border = border
			bu2.border:CreateBorder()
		end
		bu2:SetNormalTexture("")
		bu2:SetFrameStrata("HIGH")
	end

	for i = 1, 80 do
		local bu = _G["VoidStorageStorageButton"..i]

		_G["VoidStorageStorageButton"..i.."Bg"]:Hide()
		_G["VoidStorageStorageButton"..i.."IconTexture"]:SetTexCoord(.08, .92, .08, .92)

		bu:StyleButton(1)
		if not bu.border then
			local border = CreateFrame("Frame", nil, bu)
			border:Point("TOPLEFT", -1, 1)
			border:Point("BOTTOMRIGHT", 1, -1)
			border:SetFrameStrata("BACKGROUND")
			border:SetFrameLevel(0)
			bu.border = border
			bu.border:CreateBorder()
		end
		bu:SetNormalTexture("")
		bu:SetFrameStrata("HIGH")
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

S:RegisterSkin("Blizzard_VoidStorageUI", LoadSkin)
