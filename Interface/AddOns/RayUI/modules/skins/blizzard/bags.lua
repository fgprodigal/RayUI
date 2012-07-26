local R, L, P = unpack(select(2, ...)) --Inport: Engine, Locales, ProfileDB
local S = R:GetModule("Skins")

local function LoadSkin()
	local r, g, b = S["media"].classcolours[R.myclass].r, S["media"].classcolours[R.myclass].g, S["media"].classcolours[R.myclass].b
	S:ReskinCheck(TokenFramePopupInactiveCheckBox)
	S:ReskinCheck(TokenFramePopupBackpackCheckBox)
	S:ReskinClose(TokenFramePopupCloseButton)
	TokenFramePopupCorner:Hide()
	TokenFramePopup:SetPoint("TOPLEFT", TokenFrame, "TOPRIGHT", 1, -28)
	TokenFrame:HookScript("OnShow", function()
		for i=1, GetCurrencyListSize() do
			local button = _G["TokenFrameContainerButton"..i]

			if button and not button.reskinned then
				button.highlight:SetPoint("TOPLEFT", 1, 0)
				button.highlight:SetPoint("BOTTOMRIGHT", -1, 0)
				button.highlight.SetPoint = R.dummy
				button.highlight:SetTexture(r, g, b, .2)
				button.highlight.SetTexture = R.dummy
				button.categoryMiddle:SetAlpha(0)
				button.categoryLeft:SetAlpha(0)
				button.categoryRight:SetAlpha(0)

				if button.icon and button.icon:GetTexture() then
					button.icon:SetTexCoord(.08, .92, .08, .92)
					S:CreateBG(button.icon)
				end
				button.reskinned = true
			end
		end
	end)
end

S:RegisterSkin("RayUI", LoadSkin)