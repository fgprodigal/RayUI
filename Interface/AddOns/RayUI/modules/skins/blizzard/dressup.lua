----------------------------------------------------------
-- Load RayUI Environment
----------------------------------------------------------
RayUI:LoadEnv("Skins")


local S = _Skins

local function LoadSkin()
    local r, g, b = _r, _g, _b
	S:SetBD(DressUpFrame)
    DressUpFrame.ModelBackground:Kill()
    DressUpFrameInset:Kill()
	DressUpFramePortrait:Kill()
    DressUpFrame:StripTextures()
    MaximizeMinimizeFrame:StripTextures()
    for _, button in pairs{MaximizeMinimizeFrame.MaximizeButton, MaximizeMinimizeFrame.MinimizeButton} do
        button:SetSize(17, 17)
        button:ClearAllPoints()
        button:SetPoint("RIGHT", DressUpFrameCloseButton, "LEFT", -1, 0)

        S:Reskin(button)

        local arrow = button:CreateFontString(nil, "OVERLAY")

        if button == MaximizeMinimizeFrame.MaximizeButton then
            arrow:FontTemplate(R["media"].arrowfont, 26 * R.mult, "OUTLINE,MONOCHROME")
            arrow:Point("CENTER", 1, -2)
            arrow:SetText("W")
        else
            arrow:FontTemplate(R["media"].arrowfont, 27 * R.mult, "OUTLINE,MONOCHROME")
            arrow:Point("CENTER", 0, -4)
            arrow:SetText("V")
        end

        button:SetScript("OnEnter", function() arrow:SetTextColor(r, g, b) end)
        button:SetScript("OnLeave", function() arrow:SetTextColor(1, 1, 1) end)
    end
	for i = 2, 5 do
		select(i, DressUpFrame:GetRegions()):Hide()
	end
	DressUpFrameResetButton:SetPoint("RIGHT", DressUpFrameCancelButton, "LEFT", -1, 0)
	S:Reskin(DressUpFrameCancelButton)
	S:Reskin(DressUpFrameResetButton)
	S:ReskinClose(DressUpFrameCloseButton)

	S:Reskin(DressUpFrameOutfitDropDown.SaveButton)
	S:ReskinDropDown(DressUpFrameOutfitDropDown)

	DressUpFrameOutfitDropDown:SetHeight(32)
	DressUpFrameOutfitDropDown.SaveButton:SetPoint("LEFT", DressUpFrameOutfitDropDown, "RIGHT", -13, 2)

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
