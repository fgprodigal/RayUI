local R, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local S = R:GetModule("Skins")

local function LoadSkin()
	local r, g, b = S["media"].classcolours[R.myclass].r, S["media"].classcolours[R.myclass].g, S["media"].classcolours[R.myclass].b
	S:SetBD(CharacterFrame)
	S:SetBD(PetStableFrame)
	local frames = {
		"CharacterFrame",
		"CharacterFrameInset",
		"CharacterFrameInsetRight",
		"CharacterModelFrame",
	}
	for i = 1, #frames do
		_G[frames[i]]:DisableDrawLayer("BACKGROUND")
		_G[frames[i]]:DisableDrawLayer("BORDER")
	end
	CharacterModelFrame:DisableDrawLayer("OVERLAY")
	CharacterFramePortrait:Hide()
	CharacterFrameExpandButton:GetNormalTexture():SetAlpha(0)
	CharacterFrameExpandButton:GetPushedTexture():SetAlpha(0)
	CharacterStatsPaneTop:Hide()
	CharacterStatsPaneBottom:Hide()
	CharacterFramePortraitFrame:Hide()
	CharacterFrameTopRightCorner:Hide()
	CharacterFrameTopBorder:Hide()
	CharacterFrameExpandButton:SetPoint("BOTTOMRIGHT", CharacterFrameInset, "BOTTOMRIGHT", -14, 6)
	ReputationListScrollFrame:GetRegions():Hide()
	ReputationDetailCorner:Hide()
	ReputationDetailDivider:Hide()
	select(2, ReputationListScrollFrame:GetRegions()):Hide()
	select(3, ReputationDetailFrame:GetRegions()):Hide()
	for i = 1, 4 do
		select(i, GearManagerDialogPopup:GetRegions()):Hide()
	end
	GearManagerDialogPopupScrollFrame:GetRegions():Hide()
	select(2, GearManagerDialogPopupScrollFrame:GetRegions()):Hide()
	ReputationDetailFrame:SetPoint("TOPLEFT", ReputationFrame, "TOPRIGHT", 1, -28)
	PaperDollEquipmentManagerPaneEquipSet:SetWidth(PaperDollEquipmentManagerPaneEquipSet:GetWidth()-1)
	PaperDollEquipmentManagerPaneSaveSet:SetPoint("LEFT", PaperDollEquipmentManagerPaneEquipSet, "RIGHT", 1, 0)
	GearManagerDialogPopup:SetPoint("LEFT", PaperDollFrame, "RIGHT", 1, 0)
	PaperDollSidebarTabs:GetRegions():Hide()
	select(2, PaperDollSidebarTabs:GetRegions()):Hide()
	select(6, PaperDollEquipmentManagerPaneEquipSet:GetRegions()):Hide()

	S:ReskinClose(CharacterFrameCloseButton)
	S:ReskinScroll(CharacterStatsPaneScrollBar)
	S:ReskinScroll(PaperDollTitlesPaneScrollBar)
	S:ReskinScroll(PaperDollEquipmentManagerPaneScrollBar)
	S:ReskinScroll(ReputationListScrollFrameScrollBar)
	S:ReskinScroll(GearManagerDialogPopupScrollFrameScrollBar)
	S:ReskinArrow(CharacterFrameExpandButton, "left")
	S:Reskin(PaperDollEquipmentManagerPaneEquipSet)
	S:Reskin(PaperDollEquipmentManagerPaneSaveSet)
	S:Reskin(GearManagerDialogPopupOkay)
	S:Reskin(GearManagerDialogPopupCancel)
	S:ReskinClose(ReputationDetailCloseButton)
	S:ReskinCheck(ReputationDetailAtWarCheckBox)
	S:ReskinCheck(ReputationDetailInactiveCheckBox)
	S:ReskinCheck(ReputationDetailMainScreenCheckBox)
	S:ReskinCheck(ReputationDetailLFGBonusReputationCheckBox)
	S:ReskinInput(GearManagerDialogPopupEditBox)

	hooksecurefunc("CharacterFrame_Expand", function()
		select(15, CharacterFrameExpandButton:GetRegions()):SetTexture("Interface\\AddOns\\RayUI\\media\\arrow-left-active")
	end)

	hooksecurefunc("CharacterFrame_Collapse", function()
		select(15, CharacterFrameExpandButton:GetRegions()):SetTexture("Interface\\AddOns\\RayUI\\media\\arrow-right-active")
	end)

	hooksecurefunc("PaperDollFrame_CollapseStatCategory", function(categoryFrame)
			categoryFrame.BgMinimized:Hide()
		end)

	hooksecurefunc("PaperDollFrame_ExpandStatCategory", function(categoryFrame)
		categoryFrame.BgTop:Hide()
		categoryFrame.BgMiddle:Hide()
		categoryFrame.BgBottom:Hide()
	end)

	local titles = false
	hooksecurefunc("PaperDollTitlesPane_Update", function()
		if titles == false then
			for i = 1, 17 do
				_G["PaperDollTitlesPaneButton"..i]:DisableDrawLayer("BACKGROUND")
			end
			titles = true
		end
	end)

	for i = 1, 4 do
		S:CreateTab(_G["CharacterFrameTab"..i])
	end

	EquipmentFlyoutFrameButtons:DisableDrawLayer("BACKGROUND")
	EquipmentFlyoutFrameButtons:DisableDrawLayer("ARTWORK")

	local slots = {
		"Head",
		"Neck",
		"Shoulder",
		"Shirt",
		"Chest",
		"Waist",
		"Legs",
		"Feet",
		"Wrist",
		"Hands",
		"Finger0",
		"Finger1",
		"Trinket0",
		"Trinket1",
		"Back",
		"MainHand",
		"SecondaryHand",
		"Tabard"
	}

	for i = 1, #slots do
		local slot = _G["Character"..slots[i].."Slot"]
		local ic = _G["Character"..slots[i].."SlotIconTexture"]
		_G["Character"..slots[i].."SlotFrame"]:Hide()

		slot.backgroundTextureName = ""
		slot.checkRelic = nil
		slot:SetNormalTexture("")
		slot:StripTextures()
		slot:StyleButton()
		slot.ignoreTexture:SetTexture([[Interface\PaperDollInfoFrame\UI-GearManager-LeaveItem-Transparent]])
		slot:SetBackdrop({
					bgFile = R["media"].blank, 
					insets = { left = -R.mult, right = -R.mult, top = -R.mult, bottom = -R.mult }
				})
		ic:SetTexCoord(.08, .92, .08, .92)
		ic:Point("TOPLEFT", 2, -2)
		ic:Point("BOTTOMRIGHT", -2, 2)
		slot.glow = CreateFrame("Frame", nil, slot)
		slot.glow:SetAllPoints()
		slot.glow:CreateBorder()

		hooksecurefunc(slot.IconBorder, "SetVertexColor", function(self, r, g, b)
			self:GetParent().glow:SetBackdropBorderColor(r, g, b)
			self:GetParent():SetBackdropColor(0, 0, 0)
		end)
		hooksecurefunc(slot.IconBorder, "Hide", function(self)
			self:GetParent().glow:SetBackdropBorderColor(0, 0, 0)
			self:GetParent():SetBackdropColor(0, 0, 0, 0)
		end)
	end

	select(9, CharacterMainHandSlot:GetRegions()):Kill()
	select(9, CharacterSecondaryHandSlot:GetRegions()):Kill()

	local function SkinItemFlyouts()
		for i = 1, (EquipmentFlyoutFrame.totalItems or 0) do
			local bu = _G["EquipmentFlyoutFrameButton"..i]
			local icon = _G["EquipmentFlyoutFrameButton"..i.."IconTexture"]
			if bu and not bu.reskinned then
				bu:SetNormalTexture("")
				bu.IconBorder:Kill()
				bu:StyleButton()
				_G["EquipmentFlyoutFrameButton"..i.."IconTexture"]:SetTexCoord(.08, .92, .08, .92)
				icon:Point("TOPLEFT", 2, -2)
				icon:Point("BOTTOMRIGHT", -2, 2)
				hooksecurefunc(bu.IconBorder, "SetVertexColor", function(self, r, g, b)
					self:GetParent().glow:SetBackdropBorderColor(r, g, b)
					self:GetParent():SetBackdropColor(0, 0, 0)
				end)
				hooksecurefunc(bu.IconBorder, "Hide", function(self)
					self:GetParent().glow:SetBackdropBorderColor(0, 0, 0)
					self:GetParent():SetBackdropColor(0, 0, 0, 0)
				end)
				bu.reskinned = true
			end
		end
	end
	EquipmentFlyoutFrameButtons:HookScript("OnShow", SkinItemFlyouts)
	hooksecurefunc("EquipmentFlyout_Show", SkinItemFlyouts)

	local function ColorFlyOutItemBorder(self)
		local location = self.location
		local glow = self.glow
		if(not glow) then
			self.glow = glow
			glow = CreateFrame("Frame", nil, self)
			glow:SetAllPoints()
			glow:CreateBorder()
			self.glow = glow
			self:SetBackdrop({
					bgFile = R["media"].blank, 
					insets = { left = -R.mult, right = -R.mult, top = -R.mult, bottom = -R.mult }
				})
			self.glow:SetBackdropBorderColor(self.IconBorder:GetVertexColor())
			self:SetBackdropColor(0, 0, 0)
		end
		if (not location) or (location >= EQUIPMENTFLYOUT_FIRST_SPECIAL_LOCATION) then
			self.glow:Point("TOPLEFT", 1, -1)
			self.glow:Point("BOTTOMRIGHT", -1, 1)
			self.glow:SetBackdropBorderColor(0, 0, 0)
			self:SetBackdropColor(0, 0, 0, 0)
			return
		end
	end

	hooksecurefunc("EquipmentFlyout_DisplayButton", ColorFlyOutItemBorder)

	for i = 1, #PAPERDOLL_SIDEBARS do
		local tab = _G["PaperDollSidebarTab"..i]

		if i == 1 then
			for i = 1, 4 do
				local region = select(i, tab:GetRegions())
				region:SetTexCoord(0.16, 0.86, 0.16, 0.86)
				region.SetTexCoord = R.dummy
			end
		end

		tab.Highlight:SetTexture(r, g, b, .2)
		tab.Highlight:Point("TOPLEFT", 3, -4)
		tab.Highlight:Point("BOTTOMRIGHT", -1, 0)
		tab.Hider:SetTexture(.3, .3, .3, .4)
		tab.TabBg:SetAlpha(0)

		select(2, tab:GetRegions()):ClearAllPoints()
		if i == 1 then
			select(2, tab:GetRegions()):Point("TOPLEFT", 3, -4)
			select(2, tab:GetRegions()):Point("BOTTOMRIGHT", -1, 0)
		else
			select(2, tab:GetRegions()):Point("TOPLEFT", 2, -4)
			select(2, tab:GetRegions()):Point("BOTTOMRIGHT", -1, -1)
		end

		tab.bg = CreateFrame("Frame", nil, tab)
		tab.bg:Point("TOPLEFT", 1, -3)
		tab.bg:Point("BOTTOMRIGHT", 0, -1)
		tab.bg:SetFrameLevel(0)
		S:CreateBD(tab.bg)

		tab.Hider:Point("TOPLEFT", tab.bg, 1, -1)
		tab.Hider:Point("BOTTOMRIGHT", tab.bg, -1, 1)
	end

	for i = 1, NUM_GEARSET_ICONS_SHOWN do
		local bu = _G["GearManagerDialogPopupButton"..i]
		local ic = _G["GearManagerDialogPopupButton"..i.."Icon"]

		bu:SetCheckedTexture(S["media"].checked)
		select(2, bu:GetRegions()):Hide()
		ic:Point("TOPLEFT", 1, -1)
		ic:Point("BOTTOMRIGHT", -1, 1)
		ic:SetTexCoord(.08, .92, .08, .92)

		S:CreateBD(bu, .25)
		bu.pushed = true
		bu:StyleButton(1)
	end

	local sets = false
	PaperDollSidebarTab3:HookScript("OnClick", function()
		if sets == false then
			for i = 1, 8 do
				local bu = _G["PaperDollEquipmentManagerPaneButton"..i]
				local bd = _G["PaperDollEquipmentManagerPaneButton"..i.."Stripe"]
				local ic = _G["PaperDollEquipmentManagerPaneButton"..i.."Icon"]
				_G["PaperDollEquipmentManagerPaneButton"..i.."BgTop"]:SetAlpha(0)
				_G["PaperDollEquipmentManagerPaneButton"..i.."BgMiddle"]:Hide()
				_G["PaperDollEquipmentManagerPaneButton"..i.."BgBottom"]:SetAlpha(0)

				bd:Hide()
				bd.Show = R.dummy
				ic:SetTexCoord(.08, .92, .08, .92)

				S:CreateBG(ic)
			end
			sets = true
		end
	end)

	-- Reputation frame
	local function UpdateFactionSkins()
		for i = 1, GetNumFactions() do
			local statusbar = _G["ReputationBar"..i.."ReputationBar"]

			if statusbar then
				statusbar:SetStatusBarTexture(R["media"].gloss)

				if not statusbar.reskinned then
				--	S:CreateBD(statusbar, .25)
					local frame = CreateFrame("Frame",nil, statusbar)
					S:CreateBD(frame, .25)
					frame:SetFrameLevel(statusbar:GetFrameLevel() -1)
					frame:Point("TOPLEFT", -1, 1)
					frame:Point("BOTTOMRIGHT", 1, -1)
					statusbar.reskinned = true
				end

				_G["ReputationBar"..i.."Background"]:SetTexture(nil)
				-- _G["ReputationBar"..i.."LeftLine"]:SetAlpha(0)
				-- _G["ReputationBar"..i.."BottomLine"]:SetAlpha(0)
				_G["ReputationBar"..i.."ReputationBarHighlight1"]:SetTexture(nil)
				_G["ReputationBar"..i.."ReputationBarHighlight2"]:SetTexture(nil)
				_G["ReputationBar"..i.."ReputationBarAtWarHighlight1"]:SetTexture(nil)
				_G["ReputationBar"..i.."ReputationBarAtWarHighlight2"]:SetTexture(nil)
				_G["ReputationBar"..i.."ReputationBarLeftTexture"]:SetTexture(nil)
				_G["ReputationBar"..i.."ReputationBarRightTexture"]:SetTexture(nil)
			end
		end
	end

	ReputationFrame:HookScript("OnShow", UpdateFactionSkins)
	hooksecurefunc("ReputationFrame_OnEvent", UpdateFactionSkins)

	-- Pet stuff
	if R.myclass == "HUNTER" or R.myclass == "MAGE" or R.myclass == "DEATHKNIGHT" or R.myclass == "WARLOCK" then
		if R.myclass == "HUNTER" then
			PetStableFrame:DisableDrawLayer("BACKGROUND")
			PetStableFrame:DisableDrawLayer("BORDER")
			PetStableFrameInset:DisableDrawLayer("BACKGROUND")
			PetStableFrameInset:DisableDrawLayer("BORDER")
			PetStableBottomInset:DisableDrawLayer("BACKGROUND")
			PetStableBottomInset:DisableDrawLayer("BORDER")
			PetStableLeftInset:DisableDrawLayer("BACKGROUND")
			PetStableLeftInset:DisableDrawLayer("BORDER")
			PetStableFramePortrait:Hide()
			PetStableModelShadow:Hide()
			PetStableFramePortraitFrame:Hide()
			PetStableFrameTopBorder:Hide()
			PetStableFrameTopRightCorner:Hide()
			PetStableModelRotateLeftButton:Hide()
			PetStableModelRotateRightButton:Hide()

			PetStableSelectedPetIcon:SetTexCoord(.08, .92, .08, .92)
			local bd = CreateFrame("Frame", nil, PetStableFrame)
			bd:Point("TOPLEFT", PetStableSelectedPetIcon, -1, 1)
			bd:Point("BOTTOMRIGHT", PetStableSelectedPetIcon, 1, -1)
			S:CreateBD(bd, .25)

			S:ReskinClose(PetStableFrameCloseButton)
			S:ReskinArrow(PetStablePrevPageButton, "left")
			S:ReskinArrow(PetStableNextPageButton, "right")

			for i = 1, 10 do
				local bu = _G["PetStableStabledPet"..i]
				local bd = CreateFrame("Frame", nil, bu)
				bd:Point("TOPLEFT", -1, 1)
				bd:Point("BOTTOMRIGHT", 1, -1)
				bd:SetFrameLevel(0)
				S:CreateBD(bd, .25)
				bu:StripTextures()
				bu:StyleButton(true)
				_G["PetStableStabledPet"..i.."IconTexture"]:SetTexCoord(.08, .92, .08, .92)
			end

			for i = 1, 5 do
				local bu = _G["PetStableActivePet"..i]
				local bd = CreateFrame("Frame", nil, bu)
				bd:Point("TOPLEFT", -1, 1)
				bd:Point("BOTTOMRIGHT", 1, -1)
				bd:SetFrameLevel(0)
				S:CreateBD(bd, .25)
				bu:StripTextures()
				bu:StyleButton(true)
				_G["PetStableActivePet"..i.."IconTexture"]:SetTexCoord(.08, .92, .08, .92)
			end
		end

		local function FixTab()
			if CharacterFrameTab2:IsShown() then
				CharacterFrameTab3:SetPoint("LEFT", CharacterFrameTab2, "RIGHT", -15, 0)
			else
				CharacterFrameTab3:SetPoint("LEFT", CharacterFrameTab1, "RIGHT", -15, 0)
			end
		end
		CharacterFrame:HookScript("OnEvent", FixTab)
		CharacterFrame:HookScript("OnShow", FixTab)

		PetModelFrameRotateLeftButton:Hide()
		PetModelFrameRotateRightButton:Hide()
		PetModelFrameShadowOverlay:Hide()
		PetPaperDollPetModelBg:SetAlpha(0)
	end
end

S:RegisterSkin("RayUI", LoadSkin)