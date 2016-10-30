local R, L, P, G = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, GlobalDB
local S = R:GetModule("Skins")

local function LoadSkin()
	local r, g, b = S["media"].classcolours[R.myclass].r, S["media"].classcolours[R.myclass].g, S["media"].classcolours[R.myclass].b

	local PVPQueueFrame = PVPQueueFrame
	local HonorFrame = HonorFrame
	local ConquestFrame = ConquestFrame
	local WarGamesFrame = WarGamesFrame

	-- Category buttons

	for i = 1, 4 do
		local bu = PVPQueueFrame["CategoryButton"..i]
		local icon = bu.Icon
		local cu = bu.CurrencyDisplay

		bu.Ring:Hide()

		S:Reskin(bu, true)

		bu.Background:SetAllPoints()
		bu.Background:SetColorTexture(r, g, b, .2)
		bu.Background:Hide()

		icon:SetTexCoord(.08, .92, .08, .92)
		icon:SetPoint("LEFT", bu, "LEFT")
		icon:SetDrawLayer("OVERLAY")
		icon.bg = S:CreateBG(icon)
		icon.bg:SetDrawLayer("ARTWORK")

		if cu then
			local ic = cu.Icon

			ic:SetSize(16, 16)
			ic:SetPoint("TOPLEFT", bu.Name, "BOTTOMLEFT", 0, -8)
			cu.Amount:SetPoint("LEFT", ic, "RIGHT", 4, 0)

			ic:SetTexCoord(.08, .92, .08, .92)
			ic.bg = S:CreateBG(ic)
			ic.bg:SetDrawLayer("BACKGROUND", 1)
		end
	end

	PVPQueueFrame.CategoryButton1.Icon:SetTexture("Interface\\Icons\\achievement_bg_winwsg")
	PVPQueueFrame.CategoryButton2.Icon:SetTexture("Interface\\Icons\\achievement_bg_killxenemies_generalsroom")
	PVPQueueFrame.CategoryButton3.Icon:SetTexture("Interface\\Icons\\ability_warrior_offensivestance")

	local englishFaction = UnitFactionGroup("player")

	hooksecurefunc("PVPQueueFrame_SelectButton", function(index)
		local self = PVPQueueFrame
		for i = 1, 4 do
			local bu = self["CategoryButton"..i]
			if i == index then
				bu.Background:Show()
			else
				bu.Background:Hide()
			end
		end
	end)

	PVPQueueFrame.CategoryButton1.Background:Show()

	-- Honor frame

	local Inset = HonorFrame.Inset
	local BonusFrame = HonorFrame.BonusFrame

	for i = 1, 9 do
		select(i, Inset:GetRegions()):Hide()
	end
	BonusFrame.WorldBattlesTexture:Hide()
	BonusFrame.ShadowOverlay:Hide()

	S:Reskin(BonusFrame.DiceButton)

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

	hooksecurefunc("HonorFrameBonusFrame_Update", function()
		local _, _, _, _, _, winHonorAmount, winConquestAmount = GetRandomBGInfo()
		local rewardIndex = 0
		if winConquestAmount and winConquestAmount > 0 then
			rewardIndex = rewardIndex + 1
			local frame = HonorFrame.BonusFrame["BattlegroundReward"..rewardIndex]
			frame.Icon:SetTexture("Interface\\Icons\\PVPCurrency-Conquest-"..englishFaction)
		end
		if winHonorAmount and winHonorAmount > 0 then
			rewardIndex = rewardIndex + 1
			local frame = HonorFrame.BonusFrame["BattlegroundReward"..rewardIndex]
			frame.Icon:SetTexture("Interface\\Icons\\PVPCurrency-Honor-"..englishFaction)
		end
	end)

	IncludedBattlegroundsDropDown:SetPoint("TOPRIGHT", BonusFrame.DiceButton, 40, 26)

	-- Honor frame specific

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

	-- Conquest Frame

	Inset = ConquestFrame.Inset

	for i = 1, 9 do
		select(i, Inset:GetRegions()):Hide()
	end
	ConquestFrame.ArenaTexture:Hide()
	ConquestFrame.RatedBGTexture:Hide()
	ConquestFrame.ArenaHeader:Hide()
	ConquestFrame.RatedBGHeader:Hide()
	ConquestFrame.ShadowOverlay:Hide()

	S:CreateBD(ConquestTooltip)

	local ConquestFrameButton_OnEnter = function(self)
		ConquestTooltip:SetPoint("TOPLEFT", self, "TOPRIGHT", 1, 0)
	end

	ConquestFrame.Arena2v2:HookScript("OnEnter", ConquestFrameButton_OnEnter)
	ConquestFrame.Arena3v3:HookScript("OnEnter", ConquestFrameButton_OnEnter)
	ConquestFrame.RatedBG:HookScript("OnEnter", ConquestFrameButton_OnEnter)

	for _, bu in pairs({ConquestFrame.Arena2v2, ConquestFrame.Arena3v3, ConquestFrame.RatedBG}) do
		S:Reskin(bu, true)
		local reward = bu.Reward

		bu.SelectedTexture:SetDrawLayer("BACKGROUND")
		bu.SelectedTexture:SetColorTexture(r, g, b, .2)
		bu.SelectedTexture:SetAllPoints()

		if reward then
			reward.Border:Hide()
			S:ReskinIcon(reward.Icon)
		end
	end

	ConquestFrame.Arena3v3:SetPoint("TOP", ConquestFrame.Arena2v2, "BOTTOM", 0, -1)

	-- War games

	Inset = WarGamesFrame.RightInset

	for i = 1, 9 do
		select(i, Inset:GetRegions()):Hide()
	end
	WarGamesFrame.InfoBG:Hide()
	WarGamesFrame.HorizontalBar:Hide()
	WarGamesFrameInfoScrollFrame.scrollBarBackground:Hide()
	WarGamesFrameInfoScrollFrame.scrollBarArtTop:Hide()
	WarGamesFrameInfoScrollFrame.scrollBarArtBottom:Hide()

	WarGamesFrameDescription:SetTextColor(.9, .9, .9)

	local function onSetNormalTexture(self, texture)
		if texture:find("Plus") then
			self.plus:Show()
		else
			self.plus:Hide()
		end
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

		local tex = S:CreateGradient(bu)
		tex:SetDrawLayer("BACKGROUND")
		tex:SetPoint("TOPLEFT", 3, -1)
		tex:SetPoint("BOTTOMRIGHT", -2, 3)

		SelectedTexture:SetDrawLayer("BACKGROUND")
		SelectedTexture:SetColorTexture(r, g, b, .2)
		SelectedTexture:SetPoint("TOPLEFT", 2, 0)
		SelectedTexture:SetPoint("BOTTOMRIGHT", -1, 2)

		bu.Icon:SetTexCoord(.08, .92, .08, .92)
		bu.Icon.bg = S:CreateBG(bu.Icon)
		bu.Icon.bg:SetDrawLayer("BACKGROUND", 1)
		bu.Icon:SetPoint("TOPLEFT", 5, -3)

		local header = button.Header

		header:GetNormalTexture():SetAlpha(0)
		header:SetHighlightTexture("")
		header:SetPushedTexture("")

		local headerBg = CreateFrame("Frame", nil, header)
		headerBg:SetSize(13, 13)
		headerBg:SetPoint("LEFT", 4, 0)
		headerBg:SetFrameLevel(header:GetFrameLevel()-1)
		S:CreateBD(headerBg, 0)

		local headerTex = S:CreateGradient(header)
		headerTex:SetAllPoints(headerBg)

		local minus = header:CreateTexture(nil, "OVERLAY")
		minus:SetSize(7, 1)
		minus:SetPoint("CENTER", headerBg)
		minus:SetTexture(R["media"].blank)
		minus:SetVertexColor(1, 1, 1)

		local plus = header:CreateTexture(nil, "OVERLAY")
		plus:SetSize(1, 7)
		plus:SetPoint("CENTER", headerBg)
		plus:SetTexture(R["media"].blank)
		plus:SetVertexColor(1, 1, 1)
		header.plus = plus

		hooksecurefunc(header, "SetNormalTexture", onSetNormalTexture)
	end

	S:ReskinCheck(WarGameTournamentModeCheckButton)

	-- Main style

	S:Reskin(HonorFrame.QueueButton)
	S:Reskin(ConquestFrame.JoinButton)
	S:Reskin(WarGameStartButton)
	S:ReskinDropDown(HonorFrameTypeDropDown)
	S:ReskinScroll(HonorFrameSpecificFrameScrollBar)
	S:ReskinScroll(WarGamesFrameScrollFrameScrollBar)
	S:ReskinScroll(WarGamesFrameInfoScrollFrameScrollBar)

	-- Role and XPbar
	for _, Hfame in pairs({HonorFrame, ConquestFrame}) do
		Hfame.RoleInset:StripTextures()
		S:ReskinCheck(Hfame.RoleInset.TankIcon:GetChildren())
		S:ReskinCheck(Hfame.RoleInset.HealerIcon:GetChildren())
		S:ReskinCheck(Hfame.RoleInset.DPSIcon:GetChildren())

		Hfame.XPBar.Frame:Hide()
		Hfame.XPBar.Bar.OverlayFrame.Text:Point("CENTER" , Hfame.XPBar.Bar.OverlayFrame, "CENTER")

		local bg = CreateFrame("Frame", nil, Hfame.XPBar.Bar)
		bg:SetPoint("TOPLEFT", 0, 1)
		bg:SetPoint("BOTTOMRIGHT", 0, -1)
		bg:SetFrameLevel(Hfame.XPBar.Bar:GetFrameLevel()-1)
		S:CreateBD(bg, .3)
		Hfame.XPBar.Bar.Background:Hide()

		Hfame.XPBar.NextAvailable.Frame:Hide()
		Hfame.XPBar.NextAvailable:ClearAllPoints()
		Hfame.XPBar.NextAvailable:SetPoint("LEFT", Hfame.XPBar.Bar, "RIGHT")
		Hfame.XPBar.NextAvailable:SetSize(25, 25)
		Hfame.XPBar.NextAvailable.Icon:SetAllPoints()
		Hfame.XPBar.NextAvailable.Icon:SetTexCoord(.08, .92, .08, .92)
		Hfame.XPBar.NextAvailable.Icon.SetTexCoord = R.dummy
		S:ReskinIcon(Hfame.XPBar.NextAvailable.Icon)

		Hfame.XPBar.NextAvailable.Frame.Show = R.dummy
		Hfame.XPBar.Levelbg = CreateFrame("Frame", nil, Hfame.XPBar)
		Hfame.XPBar.Levelbg:SetPoint("RIGHT", Hfame.XPBar.Bar, "LEFT")
		Hfame.XPBar.Levelbg:SetSize(25, 25)
		Hfame.XPBar.Levelbg:SetFrameLevel(1)
		Hfame.XPBar.Level:SetPoint("CENTER", Hfame.XPBar.Levelbg, "CENTER")
		Hfame.XPBar.Level:SetJustifyH("CENTER")
		S:CreateBD(Hfame.XPBar.Levelbg, .5)
	end

	for _, tooltip in pairs({ConquestTooltip, PVPRewardTooltip}) do
		tooltip:SetBackdrop(nil)
		S:CreateStripesThin(tooltip)
		tooltip:CreateShadow("Background")
		tooltip.stripesthin:SetInside(tooltip)
		tooltip.border:SetInside(tooltip.BackdropFrame)
		if tooltip.ItemTooltip then
		    tooltip.ItemTooltip.IconBorder:Kill()
		    tooltip.ItemTooltip.Icon:SetTexCoord(0.08, .92, .08, .92)
		    tooltip.ItemTooltip.b = CreateFrame("Frame", nil, tooltip.ItemTooltip)
		    tooltip.ItemTooltip.b:SetAllPoints(tooltip.ItemTooltip.Icon)
		    tooltip.ItemTooltip.b:CreateShadow("Background")
		    tooltip.ItemTooltip.Count:ClearAllPoints()
		    tooltip.ItemTooltip.Count:SetPoint("BOTTOMRIGHT", tooltip.ItemTooltip.Icon, "BOTTOMRIGHT", 0, 2)
		end
	end
end

S:AddCallbackForAddon("Blizzard_PVPUI", "PVP", LoadSkin)
