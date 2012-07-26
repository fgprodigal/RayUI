local R, L, P = unpack(select(2, ...)) --Inport: Engine, Locales, ProfileDB
local S = R:GetModule("Skins")

local function LoadSkin()
	S:SetBD(GMSurveyFrame, 0, 0, -32, 4)
	S:CreateBD(GMSurveyCommentFrame, .25)
	for i = 1, 11 do
		S:CreateBD(_G["GMSurveyQuestion"..i], .25)
	end

	for i = 1, 11 do
		select(i, GMSurveyFrame:GetRegions()):Hide()
	end
	GMSurveyHeaderLeft:Hide()
	GMSurveyHeaderRight:Hide()
	GMSurveyHeaderCenter:Hide()
	GMSurveyScrollFrameTop:SetAlpha(0)
	GMSurveyScrollFrameMiddle:SetAlpha(0)
	GMSurveyScrollFrameBottom:SetAlpha(0)
	S:Reskin(GMSurveySubmitButton)
	S:Reskin(GMSurveyCancelButton)
	S:ReskinClose(GMSurveyCloseButton, "TOPRIGHT", GMSurveyFrame, "TOPRIGHT", -36, -4)
	S:ReskinScroll(GMSurveyScrollFrameScrollBar)
end

S:RegisterSkin("Blizzard_GMSurveyUI", LoadSkin)