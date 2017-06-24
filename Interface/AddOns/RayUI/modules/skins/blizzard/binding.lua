----------------------------------------------------------
-- Load RayUI Environment
----------------------------------------------------------
RayUI:LoadEnv("Skins")


local S = _Skins

local function LoadSkin()
	local r, g, b = _r, _g, _b
	local KeyBindingFrame = KeyBindingFrame

	KeyBindingFrame.header:DisableDrawLayer("BACKGROUND")
	KeyBindingFrame.header:DisableDrawLayer("BORDER")
	KeyBindingFrame.scrollFrame.scrollBorderTop:Kill()
	KeyBindingFrame.scrollFrame.scrollBorderBottom:Kill()
	KeyBindingFrame.scrollFrame.scrollBorderMiddle:Kill()
	KeyBindingFrame.scrollFrame.scrollFrameScrollBarBackground:Kill()
	KeyBindingFrame.categoryList:DisableDrawLayer("BACKGROUND")
	KeyBindingFrame.bindingsContainer:SetBackdrop(nil)

	S:CreateBD(KeyBindingFrame)
	S:Reskin(KeyBindingFrame.defaultsButton)
	S:Reskin(KeyBindingFrame.unbindButton)
	S:Reskin(KeyBindingFrame.okayButton)
	S:Reskin(KeyBindingFrame.cancelButton)
	S:ReskinCheck(KeyBindingFrame.characterSpecificButton)
	S:ReskinScroll(KeyBindingFrameScrollFrameScrollBar)

	local function styleBindingButton(bu)
		local selected = bu.selectedHighlight

		for i = 1, 9 do
			select(i, bu:GetRegions()):Hide()
		end

		selected:SetTexture(R["media"].normal)
		selected:SetPoint("TOPLEFT", 1, -1)
		selected:SetPoint("BOTTOMRIGHT", -1, 1)
		selected:SetColorTexture(r, g, b, .2)

		S:Reskin(bu)
	end

	for i = 1, KEY_BINDINGS_DISPLAYED do
		local button1 = _G["KeyBindingFrameKeyBinding"..i.."Key1Button"]
		local button2 = _G["KeyBindingFrameKeyBinding"..i.."Key2Button"]

		button2:SetPoint("LEFT", button1, "RIGHT", 1, 0)

		styleBindingButton(button1)
		styleBindingButton(button2)
	end

	KeyBindingFrame.header.text:ClearAllPoints()
	KeyBindingFrame.header.text:SetPoint("TOP", KeyBindingFrame, "TOP", 0, -8)

	KeyBindingFrame.unbindButton:ClearAllPoints()
	KeyBindingFrame.unbindButton:SetPoint("BOTTOMRIGHT", -207, 16)
	KeyBindingFrame.okayButton:ClearAllPoints()
	KeyBindingFrame.okayButton:SetPoint("BOTTOMLEFT", KeyBindingFrame.unbindButton, "BOTTOMRIGHT", 1, 0)
	KeyBindingFrame.cancelButton:ClearAllPoints()
	KeyBindingFrame.cancelButton:SetPoint("BOTTOMLEFT", KeyBindingFrame.okayButton, "BOTTOMRIGHT", 1, 0)

	local line = KeyBindingFrame:CreateTexture(nil, "ARTWORK")
	line:SetSize(1, 546)
	line:SetPoint("LEFT", 205, 10)
	line:SetColorTexture(1, 1, 1, .2)
end

S:AddCallbackForAddon("Blizzard_BindingUI", "Binding", LoadSkin)
