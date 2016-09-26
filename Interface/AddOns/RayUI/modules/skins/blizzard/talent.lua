local R, L, P, G = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, GlobalDB
local S = R:GetModule("Skins")

local function LoadSkin()
	local r, g, b = S["media"].classcolours[R.myclass].r, S["media"].classcolours[R.myclass].g, S["media"].classcolours[R.myclass].b
	PlayerTalentFrameTalents:DisableDrawLayer("BORDER")
	PlayerTalentFrameTalentsBg:Hide()
	PlayerTalentFrameActiveSpecTabHighlight:SetTexture("")
	PlayerTalentFrameTitleGlowLeft:SetTexture("")
	PlayerTalentFrameTitleGlowRight:SetTexture("")
	PlayerTalentFrameTitleGlowCenter:SetTexture("")

	for i = 1, 6 do
		select(i, PlayerTalentFrameSpecialization:GetRegions()):Hide()
	end

	select(7, PlayerTalentFrameSpecialization:GetChildren()):DisableDrawLayer("OVERLAY")

	for i = 1, 5 do
		select(i, PlayerTalentFrameSpecializationSpellScrollFrameScrollChild:GetRegions()):Hide()
	end

	PlayerTalentFrameSpecializationSpellScrollFrameScrollChild.Seperator:SetColorTexture(1, 1, 1)
	PlayerTalentFrameSpecializationSpellScrollFrameScrollChild.Seperator:SetAlpha(.2)

	if R.myclass == "HUNTER" then
		for i = 1, 6 do
			select(i, PlayerTalentFramePetSpecialization:GetRegions()):Hide()
		end
		select(7, PlayerTalentFramePetSpecialization:GetChildren()):DisableDrawLayer("OVERLAY")
		for i = 1, 5 do
			select(i, PlayerTalentFramePetSpecializationSpellScrollFrameScrollChild:GetRegions()):Hide()
		end

		PlayerTalentFramePetSpecializationSpellScrollFrameScrollChild.Seperator:SetColorTexture(1, 1, 1)
		PlayerTalentFramePetSpecializationSpellScrollFrameScrollChild.Seperator:SetAlpha(.2)

		for i = 1, GetNumSpecializations(false, true) do
			local _, _, _, icon = GetSpecializationInfo(i, false, true)
			PlayerTalentFramePetSpecialization["specButton"..i].specIcon:SetTexture(icon)
		end
	end

	hooksecurefunc("PlayerTalentFrame_UpdateTabs", function()
		for i = 1, NUM_TALENT_FRAME_TABS do
			local tab = _G["PlayerTalentFrameTab"..i]
			local a1, p, a2, x = tab:GetPoint()

			tab:ClearAllPoints()
			tab:Point(a1, p, a2, x, 2)
		end
	end)

	for i = 1, NUM_TALENT_FRAME_TABS do
		S:CreateTab(_G["PlayerTalentFrameTab"..i])
	end

	for _, frame in pairs({PlayerTalentFrameSpecialization, PlayerTalentFramePetSpecialization}) do
		local scrollChild = frame.spellsScroll.child

		scrollChild.ring:Hide()
		scrollChild.specIcon:SetTexCoord(.08, .92, .08, .92)
		S:CreateBG(scrollChild.specIcon)
	end

	hooksecurefunc("PlayerTalentFrame_UpdateSpecFrame", function(self, spec)
		local playerTalentSpec = GetSpecialization(nil, self.isPet, PlayerSpecTab2:GetChecked() and 2 or 1)
		local shownSpec = spec or playerTalentSpec or 1

		local id, _, _, icon = GetSpecializationInfo(shownSpec, nil, self.isPet)
		local scrollChild = self.spellsScroll.child

		scrollChild.specIcon:SetTexture(icon)

		local index = 1
		local bonuses
		if self.isPet then
			bonuses = {GetSpecializationSpells(shownSpec, nil, self.isPet)}
		else
			bonuses = SPEC_SPELLS_DISPLAY[id]
		end

		for i = 1, #bonuses, 2 do
			local frame = scrollChild["abilityButton"..index]
			local _, icon = GetSpellTexture(bonuses[i])

			frame.icon:SetTexture(icon)
			frame.subText:SetTextColor(.75, .75, .75)

			if not frame.styled then
				frame.ring:Hide()
				frame.icon:SetTexCoord(.08, .92, .08, .92)
				S:CreateBG(frame.icon)

				frame.styled = true
			end

			index = index + 1
		end

		for i = 1, GetNumSpecializations(nil, self.isPet) do
			local bu = self["specButton"..i]

			if bu.disabled then
				bu.roleName:SetTextColor(.5, .5, .5)
			else
				bu.roleName:SetTextColor(1, 1, 1)
			end
		end
	end)

	for i = 1, GetNumSpecializations(false, nil) do
		local _, _, _, icon = GetSpecializationInfo(i, false, nil)
		PlayerTalentFrameSpecialization["specButton"..i].specIcon:SetTexture(icon)
	end

	PlayerTalentFrameSpecializationLearnButton.Flash:SetTexture("")

	local buttons = {"PlayerTalentFrameSpecializationSpecButton", "PlayerTalentFramePetSpecializationSpecButton"}

	for _, name in pairs(buttons) do
		for i = 1, 4 do
			local bu = _G[name..i]

			bu.bg:SetAlpha(0)
			bu.ring:Hide()
			_G[name..i.."Glow"]:SetTexture("")

			S:Reskin(bu, true)

			bu.learnedTex:SetTexture("")
			bu.selectedTex:SetTexture(R["media"].gloss)
			bu.selectedTex:SetVertexColor(r, g, b, .2)
			bu.selectedTex:SetDrawLayer("BACKGROUND")
			bu.selectedTex:SetAllPoints()

			bu.specIcon:SetTexCoord(.08, .92, .08, .92)
			bu.specIcon:SetSize(58, 58)
			bu.specIcon:SetPoint("LEFT", bu, "LEFT")
			bu.specIcon:SetDrawLayer("OVERLAY")
			local bg = S:CreateBG(bu.specIcon)
			bg:SetDrawLayer("BORDER")
		end
	end

	for i = 1, MAX_TALENT_TIERS do
		local row = _G["PlayerTalentFrameTalentsTalentRow"..i]
		_G["PlayerTalentFrameTalentsTalentRow"..i.."Bg"]:Hide()
		row:DisableDrawLayer("BORDER")

		row.TopLine:SetDesaturated(true)
		row.TopLine:SetVertexColor(r, g, b)
		row.BottomLine:SetDesaturated(true)
		row.BottomLine:SetVertexColor(r, g, b)

		for j = 1, NUM_TALENT_COLUMNS do
			local bu = _G["PlayerTalentFrameTalentsTalentRow"..i.."Talent"..j]
			local ic = _G["PlayerTalentFrameTalentsTalentRow"..i.."Talent"..j.."IconTexture"]

			bu:SetHighlightTexture("")
			bu.Slot:SetAlpha(0)
			bu.knownSelection:SetAlpha(0)

			ic:SetDrawLayer("ARTWORK")
			ic:SetTexCoord(.08, .92, .08, .92)
			S:CreateBG(ic)

			bu.bg = CreateFrame("Frame", nil, bu)
			bu.bg:SetPoint("TOPLEFT", 10, 0)
			bu.bg:SetPoint("BOTTOMRIGHT")
			bu.bg:SetFrameLevel(bu:GetFrameLevel()-1)
			S:CreateBD(bu.bg, .25)
		end
	end

	hooksecurefunc("TalentFrame_Update", function()
		for i = 1, MAX_TALENT_TIERS do
			for j = 1, NUM_TALENT_COLUMNS do
				local bu = _G["PlayerTalentFrameTalentsTalentRow"..i.."Talent"..j]
				if bu.knownSelection:IsShown() then
					bu.bg:SetBackdropColor(r, g, b, .2)
				else
					bu.bg:SetBackdropColor(0, 0, 0, .25)
				end
			end
		end
	end)

	for i = 1, 2 do
		local tab = _G["PlayerSpecTab"..i]
		_G["PlayerSpecTab"..i.."Background"]:Hide()

		local bg = CreateFrame("Frame", nil, tab)
		bg:Point("TOPLEFT", -1, 1)
		bg:Point("BOTTOMRIGHT", 1, -1)
		bg:SetFrameLevel(tab:GetFrameLevel()-1)
		S:CreateBD(bg)

		S:CreateSD(tab, 5, 0, 0, 0, 1, 1)

		select(2, tab:GetRegions()):SetTexCoord(.08, .92, .08, .92)

		tab:StyleButton(true)
		tab:SetPushedTexture(nil)
	end

	hooksecurefunc("PlayerTalentFrame_UpdateSpecs", function()
		PlayerSpecTab1:SetPoint("TOPLEFT", PlayerTalentFrame, "TOPRIGHT", 11, -36)
		PlayerSpecTab2:SetPoint("TOP", PlayerSpecTab1, "BOTTOM")
	end)

	PlayerTalentFrameTalentsTutorialButton.Ring:Hide()
	PlayerTalentFrameTalentsTutorialButton:SetPoint("TOPLEFT", PlayerTalentFrame, "TOPLEFT", -12, 12)
	PlayerTalentFrameSpecializationTutorialButton.Ring:Hide()
	PlayerTalentFrameSpecializationTutorialButton:SetPoint("TOPLEFT", PlayerTalentFrame, "TOPLEFT", -12, 12)

	S:ReskinPortraitFrame(PlayerTalentFrame, true)
	S:Reskin(PlayerTalentFrameSpecializationLearnButton)
	S:Reskin(PlayerTalentFrameActivateButton)
	S:Reskin(PlayerTalentFramePetSpecializationLearnButton)

	-- PvP Talents
	
	PlayerTalentFramePVPTalents.XPBar.Frame:Hide()
	
	local bg = CreateFrame("Frame", nil, PlayerTalentFramePVPTalents.XPBar.Bar)
	bg:SetPoint("TOPLEFT", 0, 1)
	bg:SetPoint("BOTTOMRIGHT", 0, -1)
	bg:SetFrameLevel(PlayerTalentFramePVPTalents.XPBar.Bar:GetFrameLevel()-1)
	S:CreateBD(bg, .3)
	PlayerTalentFramePVPTalents.XPBar.Bar.Background:Hide()
	
	PlayerTalentFramePVPTalents.XPBar.NextAvailable.Frame:Hide()
	S:CreateBD(PlayerTalentFramePVPTalents.XPBar.NextAvailable, .5)
	PlayerTalentFramePVPTalents.XPBar.NextAvailable:ClearAllPoints()
	PlayerTalentFramePVPTalents.XPBar.NextAvailable:SetPoint("LEFT", PlayerTalentFramePVPTalents.XPBar.Bar, "RIGHT")
	PlayerTalentFramePVPTalents.XPBar.NextAvailable:SetSize(25, 25)
	PlayerTalentFramePVPTalents.XPBar.NextAvailable.Icon:SetAllPoints()
	
	PlayerTalentFramePVPTalents.XPBar.NextAvailable.Frame.Show = R.dummy
	PlayerTalentFramePVPTalents.XPBar.Levelbg = CreateFrame("Frame", nil, PlayerTalentFramePVPTalents.XPBar)
	PlayerTalentFramePVPTalents.XPBar.Levelbg:SetPoint("RIGHT", PlayerTalentFramePVPTalents.XPBar.Bar, "LEFT")
	PlayerTalentFramePVPTalents.XPBar.Levelbg:SetSize(25, 25)
	PlayerTalentFramePVPTalents.XPBar.Levelbg:SetFrameLevel(1)
	PlayerTalentFramePVPTalents.XPBar.Level:SetPoint("CENTER", PlayerTalentFramePVPTalents.XPBar.Levelbg, "CENTER")
	PlayerTalentFramePVPTalents.XPBar.Level:SetJustifyH("CENTER")
	S:CreateBD(PlayerTalentFramePVPTalents.XPBar.Levelbg, .5)
	
	for i = 1, 7 do
		select(i, PlayerTalentFramePVPTalents.Talents:GetRegions()):Hide()
	end
	
	for i = 1, 6 do
		PlayerTalentFramePVPTalents.Talents["Tier"..i].Bg:SetAlpha(0)
		PlayerTalentFramePVPTalents.Talents["Tier"..i].TopLine:SetDesaturated(true)
		PlayerTalentFramePVPTalents.Talents["Tier"..i].TopLine:SetVertexColor(r, g, b)
		PlayerTalentFramePVPTalents.Talents["Tier"..i].BottomLine:SetDesaturated(true)
		PlayerTalentFramePVPTalents.Talents["Tier"..i].BottomLine:SetVertexColor(r, g, b)
		for j = 1, 3 do
			local bu = PlayerTalentFramePVPTalents.Talents["Tier"..i]["Talent"..j]
			bu.LeftCap:Hide()
			bu.RightCap:Hide()
			bu.Slot:Hide()
			bu.Cover:SetAlpha(0)
			bu.knownSelection:SetAlpha(0)
			bu.learnSelection:SetAlpha(0)
			bu.highlight:Hide()
			
			bu.Icon:SetTexCoord(.08, .92, .08, .92)
			local iconbg = S:CreateBG(bu.Icon)
			iconbg:SetDrawLayer("BACKGROUND", -1)
			
			bu.bg = CreateFrame("Frame", nil, bu)
			bu.bg:SetPoint("TOPLEFT", 10, 0)
			bu.bg:SetPoint("BOTTOMRIGHT")
			bu.bg:SetFrameLevel(bu:GetFrameLevel()-1)
			S:CreateBD(bu.bg, .25)
		end
	end
		
	hooksecurefunc("PVPTalentFrame_Update", function()
		for i = 1, 6 do
			for j = 1, 3 do
				local bu = PlayerTalentFramePVPTalents.Talents["Tier"..i]["Talent"..j]
				if bu.knownSelection:IsShown() then
					bu.bg:SetBackdropColor(r, g, b, .2)
				else
					bu.bg:SetBackdropColor(0, 0, 0, .25)
				end
			end
		end
	end)

	--Create portrait element for the PvP Talent Frame so we can see prestige
	local portrait = PlayerTalentFramePVPTalents:CreateTexture(nil, "OVERLAY")
	portrait:SetSize(57,57)
	portrait:SetPoint("CENTER", PlayerTalentFramePVPTalents.PortraitBackground, "CENTER", 0, 0);
	--Kill background
	PlayerTalentFramePVPTalents.PortraitBackground:Kill()
	--Reposition portrait by repositioning the background
	PlayerTalentFramePVPTalents.PortraitBackground:ClearAllPoints()
	PlayerTalentFramePVPTalents.PortraitBackground:SetPoint("TOPLEFT", PlayerTalentFrame, "TOPLEFT", 5, -5)
	--Reposition the wreath
	PlayerTalentFramePVPTalents.SmallWreath:ClearAllPoints()
	PlayerTalentFramePVPTalents.SmallWreath:SetPoint("TOPLEFT", PlayerTalentFrame, "TOPLEFT", -2, -25)
	--Update texture according to prestige
	hooksecurefunc("PlayerTalentFramePVPTalents_SetUp", function()
		local prestigeLevel = UnitPrestige("player")
		if (prestigeLevel > 0) then
			portrait:SetTexture(GetPrestigeInfo(prestigeLevel))
		end
	end)

	-- Prestige Level Dialog
	PVPTalentPrestigeLevelDialog:StripTextures()
	S:SetBD(PVPTalentPrestigeLevelDialog)
	PVPTalentPrestigeLevelDialog.Laurel:SetAtlas("honorsystem-prestige-laurel", true) --Re-add textures removed by StripTextures()
	PVPTalentPrestigeLevelDialog.TopDivider:SetAtlas("honorsystem-prestige-rewardline", true)
	PVPTalentPrestigeLevelDialog.BottomDivider:SetAtlas("honorsystem-prestige-rewardline", true)
	S:Reskin(PVPTalentPrestigeLevelDialog.Accept)
	S:Reskin(PVPTalentPrestigeLevelDialog.Cancel)
	S:ReskinClose(PVPTalentPrestigeLevelDialog.CloseButton) --There are 2 buttons with the exact same name, may not be able to skin it properly until fixed by Blizzard.
end

S:AddCallbackForAddon("Blizzard_TalentUI", "Talent", LoadSkin)
