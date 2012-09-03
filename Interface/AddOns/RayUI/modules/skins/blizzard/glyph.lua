local R, L, P = unpack(select(2, ...)) --Inport: Engine, Locales, ProfileDB
local S = R:GetModule("Skins")

local function LoadSkin()
	local r, g, b = S["media"].classcolours[R.myclass].r, S["media"].classcolours[R.myclass].g, S["media"].classcolours[R.myclass].b
	GlyphFrameBackground:Hide()
	GlyphFrameSideInset:DisableDrawLayer("BACKGROUND")
	GlyphFrameSideInset:DisableDrawLayer("BORDER")
	S:CreateBG(GlyphFrameClearInfoFrame)
	GlyphFrameClearInfoFrameIcon:SetTexCoord(.08, .92, .08, .92)

	for i = 1, 2 do
		_G["GlyphFrameHeader"..i.."Left"]:Hide()
		_G["GlyphFrameHeader"..i.."Middle"]:Hide()
		_G["GlyphFrameHeader"..i.."Right"]:Hide()

	end

	for i = 1, #GlyphFrame.scrollFrame.buttons do
		local bu = _G["GlyphFrameScrollFrameButton"..i]
		local ic = _G["GlyphFrameScrollFrameButton"..i.."Icon"]

		local bg = CreateFrame("Frame", nil, bu)
		bg:Point("TOPLEFT", 39, -2)
		bg:Point("BOTTOMRIGHT", -1, 2)
		bg:SetFrameLevel(bu:GetFrameLevel()-1)
		S:CreateBD(bg, .25)

		_G["GlyphFrameScrollFrameButton"..i.."Name"]:SetParent(bg)
		_G["GlyphFrameScrollFrameButton"..i.."TypeName"]:SetParent(bg)
		bu:StyleButton()
		bu.disabledBG:SetTexture("")
		select(4, bu:GetRegions()):SetAlpha(0)

		local check = select(2, bu:GetRegions())
		check:Point("TOPLEFT", 39, -3)
		check:Point("BOTTOMRIGHT", -1, 3)
		check:SetTexture(S["media"].backdrop)
		check:SetVertexColor(r, g, b, .2)

		S:CreateBG(ic)

		ic:SetTexCoord(.08, .92, .08, .92)
	end

	S:ReskinInput(GlyphFrameSearchBox)
	S:ReskinScroll(GlyphFrameScrollFrameScrollBar)
	S:ReskinDropDown(GlyphFrameFilterDropDown)
end

S:RegisterSkin("Blizzard_GlyphUI", LoadSkin)