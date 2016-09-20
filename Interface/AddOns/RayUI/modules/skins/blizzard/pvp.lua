local R, L, P, G = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, GlobalDB
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

	local Inset = HonorFrame.Inset
	local BonusFrame = HonorFrame.BonusFrame

	for i = 1, 9 do
		select(i, Inset:GetRegions()):Hide()
	end
	BonusFrame.WorldBattlesTexture:Hide()
	BonusFrame.ShadowOverlay:Hide()

	S:Reskin(BonusFrame.DiceButton)
	S:ReskinDropDown(HonorFrameTypeDropDown)

	for _, bonusButton in pairs({"RandomBGButton", "Arena1Button", "AshranButton"}) do
		local bu = BonusFrame[bonusButton]
		local reward = bu.Reward

		S:Reskin(bu, true)

		bu.SelectedTexture:SetDrawLayer("BACKGROUND")
		bu.SelectedTexture:SetColorTexture(r, g, b, .2)
		bu.SelectedTexture:SetAllPoints()

		if reward then
			reward.Border:Hide()
			S:ReskinIcon(reward.Icon)
		end
	end

	for _, bu in pairs(HonorFrame.SpecificFrame.buttons) do
		bu.Bg:Hide()
		bu.Border:Hide()

		bu:SetNormalTexture("")
		bu:SetHighlightTexture("")

		local bg = CreateFrame("Frame", nil, bu)
		bg:SetPoint("TOPLEFT", 2, 0)
		bg:SetPoint("BOTTOMRIGHT", -1, 2)
		S:CreateBD(bg, 0)
		bg:SetFrameLevel(bu:GetFrameLevel()-1)

		bu.tex = S:CreateGradient(bu)
		bu.tex:SetDrawLayer("BACKGROUND")
		bu.tex:SetPoint("TOPLEFT", bg, 1, -1)
		bu.tex:SetPoint("BOTTOMRIGHT", bg, -1, 1)

		bu.SelectedTexture:SetDrawLayer("BACKGROUND")
		bu.SelectedTexture:SetColorTexture(r, g, b, .2)
		bu.SelectedTexture:SetAllPoints(bu.tex)

		bu.Icon:SetTexCoord(.08, .92, .08, .92)
		bu.Icon.bg = S:CreateBG(bu.Icon)
		bu.Icon.bg:SetDrawLayer("BACKGROUND", 1)
		bu.Icon:SetPoint("TOPLEFT", 5, -3)
	end

	S:ReskinScroll(HonorFrameSpecificFrameScrollBar)

	S:Reskin(HonorFrameQueueButton)

	-->>>CONQUEST FRAME
	ConquestFrame.Inset:StripTextures()
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
	S:ReskinCheck(WarGameTournamentModeCheckButton)
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

		bu.tex = S:CreateGradient(bu)
		bu.tex:SetDrawLayer("BACKGROUND")
		bu.tex:SetPoint("TOPLEFT", bg, 1, -1)
		bu.tex:SetPoint("BOTTOMRIGHT", bg, -1, 1)

		SelectedTexture:SetDrawLayer("BACKGROUND")
		SelectedTexture:SetColorTexture(r, g, b, .2)
		bu.SelectedTexture:SetAllPoints(bu.tex)

		bu.Icon:SetTexCoord(.08, .92, .08, .92)
		bu.Icon.bg = S:CreateBG(bu.Icon)
		bu.Icon.bg:SetDrawLayer("BACKGROUND", 1)
		bu.Icon:SetPoint("TOPLEFT", 5, -3)
	end

	HonorFrame.XPBar.Frame:Hide()
	
	local bg = CreateFrame("Frame", nil, HonorFrame.XPBar.Bar)
	bg:SetPoint("TOPLEFT", 0, 1)
	bg:SetPoint("BOTTOMRIGHT", 0, -1)
	bg:SetFrameLevel(HonorFrame.XPBar.Bar:GetFrameLevel()-1)
	S:CreateBD(bg, .3)
	HonorFrame.XPBar.Bar.Background:Hide()
	
	HonorFrame.XPBar.NextAvailable.Frame:Hide()
	S:CreateBD(HonorFrame.XPBar.NextAvailable, .5)
	HonorFrame.XPBar.NextAvailable:ClearAllPoints()
	HonorFrame.XPBar.NextAvailable:SetPoint("LEFT", HonorFrame.XPBar.Bar, "RIGHT")
	HonorFrame.XPBar.NextAvailable:SetSize(25, 25)
	HonorFrame.XPBar.NextAvailable.Icon:SetAllPoints()
	
	HonorFrame.XPBar.NextAvailable.Frame.Show = R.dummy
	HonorFrame.XPBar.Levelbg = CreateFrame("Frame", nil, HonorFrame.XPBar)
	HonorFrame.XPBar.Levelbg:SetPoint("RIGHT", HonorFrame.XPBar.Bar, "LEFT")
	HonorFrame.XPBar.Levelbg:SetSize(25, 25)
	HonorFrame.XPBar.Levelbg:SetFrameLevel(1)
	HonorFrame.XPBar.Level:SetPoint("CENTER", HonorFrame.XPBar.Levelbg, "CENTER")
	HonorFrame.XPBar.Level:SetJustifyH("CENTER")
	S:CreateBD(HonorFrame.XPBar.Levelbg, .5)
end

S:RegisterSkin("Blizzard_PVPUI", LoadSkin)
