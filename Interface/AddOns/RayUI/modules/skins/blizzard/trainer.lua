local R, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local S = R:GetModule("Skins")

local function LoadSkin()
	local r, g, b = S["media"].classcolours[R.myclass].r, S["media"].classcolours[R.myclass].g, S["media"].classcolours[R.myclass].b
	S:SetBD(ClassTrainerFrame)
	ClassTrainerFrame:StripTextures()
	ClassTrainerFrame:DisableDrawLayer("BACKGROUND")
	ClassTrainerFrame:DisableDrawLayer("BORDER")
	ClassTrainerFrameInset:DisableDrawLayer("BORDER")
	ClassTrainerFrameBottomInset:DisableDrawLayer("BORDER")
	ClassTrainerFrameInsetBg:Hide()
	ClassTrainerFramePortrait:Hide()
	ClassTrainerFramePortraitFrame:Hide()
	ClassTrainerFrameTopBorder:Hide()
	ClassTrainerFrameTopRightCorner:Hide()
	ClassTrainerFrameBottomInsetBg:Hide()
	ClassTrainerTrainButton_LeftSeparator:Hide()

	ClassTrainerStatusBarSkillRank:ClearAllPoints()
	ClassTrainerStatusBarSkillRank:SetPoint("CENTER", ClassTrainerStatusBar, "CENTER", 0, 0)

	local bg = CreateFrame("Frame", nil, ClassTrainerFrameSkillStepButton)
	bg:SetPoint("TOPLEFT", 42, -2)
	bg:SetPoint("BOTTOMRIGHT", 0, 2)
	bg:SetFrameLevel(ClassTrainerFrameSkillStepButton:GetFrameLevel()-1)
	S:CreateBD(bg, .25)

	ClassTrainerFrameSkillStepButton:SetHighlightTexture(nil)
	select(6, ClassTrainerFrameSkillStepButton:GetRegions()):Kill()
	select(7, ClassTrainerFrameSkillStepButton:GetRegions()):SetAlpha(0)

	local check = select(4, ClassTrainerFrameSkillStepButton:GetRegions())
	check:SetPoint("TOPLEFT", 43, -3)
	check:SetPoint("BOTTOMRIGHT", -1, 3)
	check:SetTexture(R["media"].gloss)
	check:SetVertexColor(r, g, b, .2)

	local icbg = CreateFrame("Frame", nil, ClassTrainerFrameSkillStepButton)
	icbg:Point("TOPLEFT", ClassTrainerFrameSkillStepButtonIcon, -1, 1)
	icbg:Point("BOTTOMRIGHT", ClassTrainerFrameSkillStepButtonIcon, 1, -1)
	S:CreateBD(icbg, 0)

	ClassTrainerFrameSkillStepButtonIcon:SetTexCoord(.08, .92, .08, .92)

	for i = 1, 8 do
		local bu = _G["ClassTrainerScrollFrameButton"..i]
		local ic = _G["ClassTrainerScrollFrameButton"..i.."Icon"]

		local bg = CreateFrame("Frame", nil, bu)
		bg:SetPoint("TOPLEFT", 42, -6)
		bg:SetPoint("BOTTOMRIGHT", 0, 6)
		bg:SetFrameLevel(bu:GetFrameLevel()-1)
		S:CreateBD(bg, .25)

		bu:StyleButton()
		bu:GetHighlightTexture():SetPoint("TOPLEFT", 43, -6)
		bu:GetHighlightTexture():SetPoint("BOTTOMRIGHT", -1, 7)
		bu:GetPushedTexture():SetPoint("TOPLEFT", 43, -6)
		bu:GetPushedTexture():SetPoint("BOTTOMRIGHT", -1, 7)

		_G["ClassTrainerScrollFrameButton"..i.."Name"]:SetParent(bg)
		_G["ClassTrainerScrollFrameButton"..i.."SubText"]:SetParent(bg)
		_G["ClassTrainerScrollFrameButton"..i.."MoneyFrame"]:SetParent(bg)
		select(4, bu:GetRegions()):Kill()
		select(5, bu:GetRegions()):SetAlpha(0)

		local check = select(2, bu:GetRegions())
		check:SetPoint("TOPLEFT", 43, -6)
		check:SetPoint("BOTTOMRIGHT", -1, 7)
		check:SetTexture(R["media"].gloss)
		check:SetVertexColor(r, g, b, .2)

		ic:SetTexCoord(.08, .92, .08, .92)
		S:CreateBG(ic)
	end

	ClassTrainerStatusBarLeft:Hide()
	ClassTrainerStatusBarMiddle:Hide()
	ClassTrainerStatusBarRight:Hide()
	ClassTrainerStatusBarBackground:Hide()
	ClassTrainerStatusBar:SetPoint("TOPLEFT", ClassTrainerFrame, "TOPLEFT", 64, -35)
	ClassTrainerStatusBar:SetStatusBarTexture(R["media"].gloss)

	ClassTrainerStatusBar:GetStatusBarTexture():SetGradient("VERTICAL", .1, .3, .9, .2, .4, 1)

	local bd = CreateFrame("Frame", nil, ClassTrainerStatusBar)
	bd:Point("TOPLEFT", -1, 1)
	bd:Point("BOTTOMRIGHT", 1, -1)
	bd:SetFrameLevel(ClassTrainerStatusBar:GetFrameLevel()-1)
	S:CreateBD(bd, .25)

	S:Reskin(ClassTrainerTrainButton)

	S:ReskinClose(ClassTrainerFrameCloseButton)
	S:ReskinScroll(ClassTrainerScrollFrameScrollBar)
	S:ReskinDropDown(ClassTrainerFrameFilterDropDown)
end

S:RegisterSkin("Blizzard_TrainerUI", LoadSkin)