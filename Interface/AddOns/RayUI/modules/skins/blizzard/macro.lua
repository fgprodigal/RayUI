local R, L, P, G = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, GlobalDB
local S = R:GetModule("Skins")

local function LoadSkin()
    MacroPopupFrame:StripTextures()
    MacroPopupScrollFrame:StripTextures()
    MacroPopupFrame.BorderBox:StripTextures()
    MacroPopupFrame.BG:Kill()
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
    MacroPopupNameLeft:Hide()
    MacroPopupNameMiddle:Hide()
    MacroPopupNameRight:Hide()
    MacroFrameTextBackground:SetBackdrop(nil)
    select(2, MacroFrameSelectedMacroButton:GetRegions()):Hide()
    MacroFrameSelectedMacroBackground:SetAlpha(0)
    MacroButtonScrollFrameTop:Hide()
    MacroButtonScrollFrameBottom:Hide()

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

    S:ReskinClose(MacroFrameCloseButton)
    S:ReskinScroll(MacroButtonScrollFrameScrollBar)
    S:ReskinScroll(MacroFrameScrollFrameScrollBar)
    S:ReskinScroll(MacroPopupScrollFrameScrollBar)

    for i = 1, MAX_ACCOUNT_MACROS do
        local bu = _G["MacroButton"..i]
        local ic = _G["MacroButton"..i.."Icon"]

        if bu then
            bu:StripTextures()
            bu.pushed = true
            bu:StyleButton(1)
            S:CreateBD(bu, .25)
        end

        if ic then
            ic:SetInside(bu, 1, 1)
            ic:SetTexCoord(.08, .92, .08, .92)
        end
    end

    ShowUIPanel(MacroFrame)
	HideUIPanel(MacroFrame)
	MacroPopupFrame:Show()
	MacroPopupFrame:Hide()
    S:ReskinIconSelectionFrame(MacroPopupFrame, NUM_MACRO_ICONS_SHOWN, "MacroPopupButton", "MacroPopup")
end

S:AddCallbackForAddon("Blizzard_MacroUI", "Macro", LoadSkin)
