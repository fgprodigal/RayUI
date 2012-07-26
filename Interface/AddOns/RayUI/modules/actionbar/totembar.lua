local R, L, P = unpack(select(2, ...)) --Inport: Engine, Locales, ProfileDB
local AB = R:GetModule("ActionBar")

-- Tex Coords for empty buttons
local SLOT_EMPTY_TCOORDS = {
	[EARTH_TOTEM_SLOT] = {
		left	= 66 / 128,
		right	= 96 / 128,
		top		= 3 / 256,
		bottom	= 32 / 256,
	},
	[FIRE_TOTEM_SLOT] = {
		left	= 68 / 128,
		right	= 97 / 128,
		top		= 100 / 256,
		bottom	= 129 / 256,
	},
	[WATER_TOTEM_SLOT] = {
		left	= 39 / 128,
		right	= 69 / 128,
		top		= 209 / 256,
		bottom	= 238 / 256,
	},
	[AIR_TOTEM_SLOT] = {
		left	= 66 / 128,
		right	= 96 / 128,
		top		= 36 / 256,
		bottom	= 66 / 256,
	},
}

-- the color we use for border
local bordercolors = {
	{0.752,0.172,0.02},   -- Fire
	{0.741,0.580,0.04},   -- Earth
	{0,0.443,0.631},   -- Water
	{0.6,1,0.945},   -- Air
}

function AB:StyleTotemFlyout(flyout)
	-- remove blizzard flyout texture
	flyout.top:SetTexture(nil)
	flyout.middle:SetTexture(nil)
	flyout:SetFrameStrata('MEDIUM')

	-- Skin buttons
	local last = nil

	for _,button in ipairs(flyout.buttons) do
		button:CreateShadow("Background")
		button.shadow:SetBackdropColor(0, 0, 0)
		local icon = select(1,button:GetRegions())
		icon:SetTexCoord(.09,.91,.09,.91)
		icon:SetDrawLayer("ARTWORK")
		icon:Point("TOPLEFT", 2, -2)
		icon:Point("BOTTOMRIGHT", -2, 2)
		if not InCombatLockdown() then
			button:ClearAllPoints()
			button:Point("BOTTOM",last,"TOP",0,4)
		end
		if button:IsVisible() then last = button end
		button:CreateBorder(flyout.parent:GetBackdropBorderColor())
		button:StyleButton()
	end

	flyout.buttons[1]:SetPoint("BOTTOM",flyout,"BOTTOM")

	if flyout.type == "slot" then
		local tcoords = SLOT_EMPTY_TCOORDS[flyout.parent:GetID()]
		flyout.buttons[1].icon:SetTexCoord(tcoords.left,tcoords.right,tcoords.top,tcoords.bottom)
	end

	-- Skin Close button
	local close = MultiCastFlyoutFrameCloseButton
	close:CreateShadow("Background")
	close:GetHighlightTexture():SetTexture([[Interface\Buttons\ButtonHilight-Square]])
	close:GetHighlightTexture():Point("TOPLEFT",close,"TOPLEFT",1,-1)
	close:GetHighlightTexture():Point("BOTTOMRIGHT",close,"BOTTOMRIGHT",-1,1)
	close:GetNormalTexture():SetTexture(nil)
	close:ClearAllPoints()
	close:Point("BOTTOMLEFT",last,"TOPLEFT",0,4)
	close:Point("BOTTOMRIGHT",last,"TOPRIGHT",0,4)
	close:CreateBorder(last:GetBackdropBorderColor())
	close:Height(8)

	flyout:ClearAllPoints()
	flyout:Point("BOTTOM",flyout.parent,"TOP",0,4)
end

function AB:StyleTotemOpenButton(button, _, parent)
	button:GetHighlightTexture():SetAlpha(0)
	button:GetNormalTexture():SetAlpha(0)
	button:Height(20)
	button:ClearAllPoints()
	button:Point("BOTTOMLEFT", parent, "TOPLEFT", 0, -3)
	button:Point("BOTTOMRIGHT", parent, "TOPRIGHT", 0, -3)
	if not button.visibleBut then
		button.visibleBut = CreateFrame("Frame",nil,button)
		button.visibleBut:Height(8)
		button.visibleBut:Width(AB.db.buttonsize)
		button.visibleBut:SetPoint("CENTER")
		button.visibleBut.highlight = button.visibleBut:CreateTexture(nil,"HIGHLIGHT")
		button.visibleBut.highlight:SetTexture([[Interface\Buttons\ButtonHilight-Square]])
		button.visibleBut.highlight:Point("TOPLEFT",button.visibleBut,"TOPLEFT",1,-1)
		button.visibleBut.highlight:Point("BOTTOMRIGHT",button.visibleBut,"BOTTOMRIGHT",-1,1)
		button.visibleBut:CreateShadow("Background")
	end
	button.visibleBut:CreateBorder(parent:GetBackdropBorderColor())
end

function AB:StyleTotemSlotButton(button, index)
	button:CreateShadow("Background")
	button.shadow:SetBackdropColor(0, 0, 0)
	button.overlayTex:SetTexture(nil)
	button.background:SetDrawLayer("ARTWORK")
	button.background:ClearAllPoints()
	button.background:Point("TOPLEFT",button,"TOPLEFT",2, -2)
	button.background:Point("BOTTOMRIGHT",button,"BOTTOMRIGHT",-2, 2)
	if not InCombatLockdown() then button:Size(AB.db.buttonsize) end
	button:CreateBorder(unpack(bordercolors[((index-1) % 4) + 1]))
	button:StyleButton()
end

function AB:StyleTotemActionButton(button, _, index)
	local icon = select(1,button:GetRegions())
	icon:SetTexCoord(.09,.91,.09,.91)
	icon:SetDrawLayer("ARTWORK")
	icon.SetVertexColor = R.dummy
	icon:Point("TOPLEFT",button,"TOPLEFT",2,-2)
	icon:Point("BOTTOMRIGHT",button,"BOTTOMRIGHT",-2,2)
	button.overlayTex:SetTexture(nil)
	button.overlayTex:Hide()
	button:GetNormalTexture():SetAlpha(0)
	if button.slotButton and not InCombatLockdown() then
		button:ClearAllPoints()
		button:SetAllPoints(button.slotButton)
		button:SetFrameLevel(button.slotButton:GetFrameLevel()+1)
	end
	button:SetBackdropColor(0,0,0,0)
	button:StyleButton()
end

function AB:FixBackdrop(button)
	if button:GetName() and button:GetName():find("MultiCast") and button:GetNormalTexture() then
		button:GetNormalTexture():SetAlpha(0)
	end
end

function AB:StyleTotemSpellButton(button, index)
	if not button then return end
	local icon = select(1,button:GetRegions())
	local HotKey = _G[button:GetName().."HotKey"]
	if HotKey then
		HotKey:ClearAllPoints()
		HotKey:SetPoint("TOPRIGHT", 0, 0)
		HotKey:SetFont(R["media"].pxfont, R.mult*10, "OUTLINE,MONOCHROME")
		HotKey:SetShadowColor(0, 0, 0, 0.3)
		HotKey.ClearAllPoints = R.dummy
		HotKey.SetPoint = R.dummy
		if not AB.db.hotkeys == true then
			HotKey:SetText("")
			HotKey:Hide()
			HotKey.Show = R.dummy
		end
	end
	icon:SetTexCoord(.09,.91,.09,.91)
	icon:SetDrawLayer("ARTWORK")
	icon:SetAllPoints()
	button:CreateShadow("Background")
	button.shadow:SetBackdropColor(0, 0, 0)
	button:GetNormalTexture():SetTexture(nil)
	if not InCombatLockdown() then button:Size(AB.db.buttonsize) end
	_G[button:GetName().."Highlight"]:SetTexture(nil)
	_G[button:GetName().."NormalTexture"]:SetTexture(nil)
	if index == 0 or index == 5 then
		button:StyleButton(true)
	else
		button:StyleButton()
	end
end

function AB:CreateBarTotem()
	if R.myclass ~= "SHAMAN" then return end

	if MultiCastActionBarFrame then
		-- MultiCastActionBarFrame:SetScript("OnUpdate", nil)
		-- MultiCastActionBarFrame:SetScript("OnShow", nil)
		-- MultiCastActionBarFrame:SetScript("OnHide", nil)
		MultiCastActionBarFrame:Height(AB.db.buttonsize)
		MultiCastActionBarFrame:SetParent(RayUIStanceBar)
		MultiCastActionBarFrame:ClearAllPoints()
		MultiCastActionBarFrame:Point("LEFT", -2, -2)

		hooksecurefunc("MultiCastActionButton_Update",function(actionbutton) if not InCombatLockdown() then actionbutton:SetAllPoints(actionbutton.slotButton) end end)
		hooksecurefunc(MultiCastActionBarFrame, "SetPoint", function(self, p) if not InCombatLockdown() and p ~= "LEFT" then self:ClearAllPoints() self:Point("LEFT", -2, -2) end end)

		MultiCastActionBarFrame.ignoreFramePositionManager = true

		-- MultiCastActionBarFrame.SetParent = R.dummy
		-- MultiCastActionBarFrame.SetPoint = R.dummy
		-- MultiCastRecallSpellButton.SetPoint = R.dummy -- bug fix, see http://www.tukui.org/v2/forums/topic.php?id=2405
	end

	AB:SecureHook("MultiCastFlyoutFrame_ToggleFlyout", "StyleTotemFlyout")
	AB:SecureHook("MultiCastFlyoutFrameOpenButton_Show", "StyleTotemOpenButton")
	AB:SecureHook("MultiCastSlotButton_Update", "StyleTotemSlotButton")
	AB:SecureHook("MultiCastActionButton_Update", "StyleTotemActionButton")
	AB:SecureHook("ActionButton_ShowGrid", "FixBackdrop")
	hooksecurefunc("MultiCastSummonSpellButton_Update", function(self) AB:StyleTotemSpellButton(self,0) end)
	hooksecurefunc("MultiCastRecallSpellButton_Update", function(self) AB:StyleTotemSpellButton(self,5) end)
end