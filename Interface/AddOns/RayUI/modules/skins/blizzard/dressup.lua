local R, L, P, G = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, GlobalDB
local S = R:GetModule("Skins")

local function LoadSkin()
	S:SetBD(DressUpFrame, 10, -12, -34, 74)
	DressUpFramePortrait:Hide()
	DressUpBackgroundTopLeft:Hide()
	DressUpBackgroundTopRight:Hide()
	DressUpBackgroundBotLeft:Hide()
	DressUpBackgroundBotRight:Hide()
	for i = 2, 5 do
		select(i, DressUpFrame:GetRegions()):Hide()
	end
	DressUpFrameResetButton:SetPoint("RIGHT", DressUpFrameCancelButton, "LEFT", -1, 0)
	S:Reskin(DressUpFrameCancelButton)
	S:Reskin(DressUpFrameResetButton)
	S:ReskinClose(DressUpFrameCloseButton, "TOPRIGHT", DressUpFrame, "TOPRIGHT", -38, -16)

	S:Reskin(DressUpFrameOutfitDropDown.SaveButton)
	S:Reskin(DressUpFrameCancelButton)
	S:Reskin(DressUpFrameResetButton)
	S:ReskinDropDown(DressUpFrameOutfitDropDown)
	S:ReskinClose(DressUpFrameCloseButton, "TOPRIGHT", DressUpFrame, "TOPRIGHT", -38, -16)

	DressUpFrameOutfitDropDown:SetHeight(32)
	DressUpFrameOutfitDropDown.SaveButton:SetPoint("LEFT", DressUpFrameOutfitDropDown, "RIGHT", -13, 2)
	DressUpFrameResetButton:SetPoint("RIGHT", DressUpFrameCancelButton, "LEFT", -1, 0)

	-- SideDressUp

	for i = 1, 4 do
		select(i, SideDressUpFrame:GetRegions()):Hide()
	end
	select(5, SideDressUpModelCloseButton:GetRegions()):Hide()

	SideDressUpModel:HookScript("OnShow", function(self)
		self:ClearAllPoints()
		self:SetPoint("LEFT", self:GetParent():GetParent(), "RIGHT", 1, 0)
	end)

	S:Reskin(SideDressUpModelResetButton)
	S:ReskinClose(SideDressUpModelCloseButton)

	SideDressUpModel.bg = CreateFrame("Frame", nil, SideDressUpModel)
	SideDressUpModel.bg:SetPoint("TOPLEFT", 0, 1)
	SideDressUpModel.bg:SetPoint("BOTTOMRIGHT", 1, -1)
	SideDressUpModel.bg:SetFrameLevel(SideDressUpModel:GetFrameLevel()-1)
	S:CreateBD(SideDressUpModel.bg)

	-- [[ DressUpModelControlFrame Button ]]
	DressUpModelControlFrame:DisableDrawLayer("BACKGROUND")
	local buttons = {
		"ZoomIn",
		"ZoomOut",
		"Pan",
		"RotateLeft",
		"RotateRight",
		"RotateReset",
	}
	for i = 1, #buttons do
		local cb = _G["DressUpModelControlFrame"..buttons[i].."Button"]
		_G["DressUpModelControlFrame"..buttons[i].."ButtonBg"]:Hide()

		S:Reskin(cb)
	end
end

S:AddCallback("DressUp", LoadSkin)