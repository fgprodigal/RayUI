local R, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local S = R:GetModule("Skins")

local function LoadSkin()
	MacroFrameText:SetFont(R["media"].font, 14)
	S:ReskinPortraitFrame(MacroFrame, true)
	S:CreateBD(MacroFrameScrollFrame, .25)
	S:CreateBD(MacroPopupFrame)
	S:CreateBD(MacroPopupEditBox, .25)
	select(18, MacroFrame:GetRegions()):Hide()
	MacroHorizontalBarLeft:Hide()
	select(21, MacroFrame:GetRegions()):Hide()
	for i = 1, 6 do
		select(i, MacroFrameTab1:GetRegions()):Hide()
		select(i, MacroFrameTab2:GetRegions()):Hide()
		select(i, MacroFrameTab1:GetRegions()).Show = R.dummy
		select(i, MacroFrameTab2:GetRegions()).Show = R.dummy
	end
	for i = 1, 5 do
		select(i, MacroPopupFrame:GetRegions()):Hide()
	end
	MacroPopupScrollFrame:GetRegions():Hide()
	select(2, MacroPopupScrollFrame:GetRegions()):Hide()
	MacroPopupNameLeft:Hide()
	MacroPopupNameMiddle:Hide()
	MacroPopupNameRight:Hide()
	MacroFrameTextBackground:SetBackdrop(nil)
	select(2, MacroFrameSelectedMacroButton:GetRegions()):Hide()
	MacroFrameSelectedMacroBackground:SetAlpha(0)
	MacroButtonScrollFrameTop:Hide()
	MacroButtonScrollFrameBottom:Hide()

	for i = 1, MAX_ACCOUNT_MACROS do
		local bu = _G["MacroButton"..i]
		local ic = _G["MacroButton"..i.."Icon"]

		select(2, bu:GetRegions()):Hide()
		bu:StyleButton(1)
		bu:SetPushedTexture(nil)

		ic:Point("TOPLEFT", 1, -1)
		ic:Point("BOTTOMRIGHT", -1, 1)
		ic:SetTexCoord(.08, .92, .08, .92)

		S:CreateBD(bu, .25)
	end

	for i = 1, NUM_MACRO_ICONS_SHOWN do
		local bu = _G["MacroPopupButton"..i]
		local ic = _G["MacroPopupButton"..i.."Icon"]

		select(2, bu:GetRegions()):Hide()
		bu:StyleButton(1)
		bu:SetPushedTexture(nil)

		ic:Point("TOPLEFT", 1, -1)
		ic:Point("BOTTOMRIGHT", -1, 1)
		ic:SetTexCoord(.08, .92, .08, .92)

		S:CreateBD(bu, .25)
	end

	MacroFrameSelectedMacroButton:StyleButton(true)
	MacroFrameSelectedMacroButton:SetPoint("TOPLEFT", MacroFrameSelectedMacroBackground, "TOPLEFT", 12, -16)
	MacroFrameSelectedMacroButtonIcon:SetPoint("TOPLEFT", 1, -1)
	MacroFrameSelectedMacroButtonIcon:SetPoint("BOTTOMRIGHT", -1, 1)
	MacroFrameSelectedMacroButtonIcon:SetTexCoord(.08, .92, .08, .92)

	S:CreateBD(MacroFrameSelectedMacroButton, .25)

	S:Reskin(MacroDeleteButton)
	S:Reskin(MacroNewButton)
	S:Reskin(MacroExitButton)
	S:Reskin(MacroEditButton)
	S:Reskin(MacroSaveButton)
	S:Reskin(MacroCancelButton)
	S:Reskin(MacroPopupOkayButton)
	S:Reskin(MacroPopupCancelButton)
	MacroPopupFrame:ClearAllPoints()
	MacroPopupFrame:SetPoint("TOPLEFT", MacroFrame, "TOPRIGHT", -32, -40)

	S:ReskinClose(MacroFrameCloseButton, "TOPRIGHT", MacroFrame, "TOPRIGHT", -38, -14)
	S:ReskinScroll(MacroButtonScrollFrameScrollBar)
	S:ReskinScroll(MacroFrameScrollFrameScrollBar)
	S:ReskinScroll(MacroPopupScrollFrameScrollBar)
end

S:RegisterSkin("Blizzard_MacroUI", LoadSkin)
