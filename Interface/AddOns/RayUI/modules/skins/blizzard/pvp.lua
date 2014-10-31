local R, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local S = R:GetModule("Skins")

local function LoadSkin()
	local r, g, b = S["media"].classcolours[R.myclass].r, S["media"].classcolours[R.myclass].g, S["media"].classcolours[R.myclass].b

	PVPUIFrame:StripTextures()

	S:ReskinClose(PVPUIFrameCloseButton)

	for i=1, 2 do
		S:CreateTab(_G["PVPUIFrameTab"..i])
	end

	for i=1, 4 do
		local button = _G["PVPQueueFrameCategoryButton"..i]
		button:SetTemplate('Default')
		button.Background:Kill()
		button.Ring:Kill()
		button.Icon:Size(45)
		button.Icon:SetTexCoord(.15, .85, .15, .85)
		S:Reskin(button)
	end

	--[[for i=1, 3 do
		local button = _G["PVPArenaTeamsFrameTeam"..i]
		button.Background:Kill()
		S:Reskin(button)
	end]]

	-->>>HONOR FRAME
	S:ReskinDropDown(HonorFrameTypeDropDown)

	HonorFrame.Inset:StripTextures()
	--HonorFrame.Inset:SetTemplate("Transparent")

	S:ReskinScroll(HonorFrameSpecificFrameScrollBar)
	S:Reskin(HonorFrameSoloQueueButton)
	S:Reskin(HonorFrameGroupQueueButton)
	HonorFrame.BonusFrame:StripTextures()
	HonorFrame.BonusFrame.ShadowOverlay:StripTextures()
	-->>>CONQUEST FRAME
	ConquestFrame.Inset:StripTextures()
	ConquestPointsBarLeft:Kill()
	ConquestPointsBarRight:Kill()
	ConquestPointsBarMiddle:Kill()
	ConquestPointsBarBG:Kill()
	ConquestPointsBarShadow:Kill()
	ConquestPointsBar.progress:SetTexture(R["media"].normal)
	ConquestFrame:StripTextures()
	ConquestFrame.ShadowOverlay:StripTextures()
	S:Reskin(ConquestJoinButton, true)

	local bg = CreateFrame("Frame", nil, ConquestPointsBar)
	S:CreateBD(ConquestPointsBar, .25)
	bg:SetPoint("TOPLEFT", -1, -2)
	bg:SetPoint("BOTTOMRIGHT", 1, 2)

	-->>>WARGRAMES FRAME
	WarGamesFrame:StripTextures()
	WarGamesFrame.RightInset:StripTextures()
	S:Reskin(WarGameStartButton, true)
	S:ReskinScroll(WarGamesFrameScrollFrameScrollBar)
	WarGamesFrame.HorizontalBar:StripTextures()

	local RoleInset = HonorFrame.RoleInset

	RoleInset:DisableDrawLayer("BACKGROUND")
	RoleInset:DisableDrawLayer("BORDER")

	for _, roleButton in pairs({RoleInset.HealerIcon, RoleInset.TankIcon, RoleInset.DPSIcon}) do
		S:ReskinCheck(roleButton.checkButton)
	end

	for _, button in pairs(WarGamesFrame.scrollFrame.buttons) do
		local bu = button.Entry
		local SelectedTexture = bu.SelectedTexture

		bu.Bg:Hide()
		bu.Border:Hide()

		bu:SetNormalTexture("")
		bu:SetHighlightTexture("")

		local bg = CreateFrame("Frame", nil, bu)
		bg:SetPoint("TOPLEFT", 2, 0)
		bg:SetPoint("BOTTOMRIGHT", -1, 2)
		S:CreateBD(bg, 0)
		bg:SetFrameLevel(bu:GetFrameLevel()-1)

		SelectedTexture:SetDrawLayer("BACKGROUND")
		SelectedTexture:SetTexture(r, g, b, .2)
		SelectedTexture:SetPoint("TOPLEFT", 2, 0)
		SelectedTexture:SetPoint("BOTTOMRIGHT", -1, 2)

		bu.Icon:SetTexCoord(.08, .92, .08, .92)
		bu.Icon.bg = S:CreateBG(bu.Icon)
		bu.Icon.bg:SetDrawLayer("BACKGROUND", 1)
		bu.Icon:SetPoint("TOPLEFT", 5, -3)
	end
end

S:RegisterSkin("Blizzard_PVPUI", LoadSkin)
