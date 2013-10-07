local R, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local S = R:GetModule("Skins")

local function LoadSkin()
	S:ReskinPortraitFrame(ItemSocketingFrame, true)
	S:CreateBD(ItemSocketingScrollFrame, .25)
	ItemSocketingScrollFrame:StripTextures()
	ItemSocketingFrame:DisableDrawLayer("ARTWORK")
	ItemSocketingScrollFrameTop:SetAlpha(0)
	ItemSocketingScrollFrameBottom:SetAlpha(0)
	ItemSocketingSocket1Left:SetAlpha(0)
	ItemSocketingSocket1Right:SetAlpha(0)
	ItemSocketingSocket2Left:SetAlpha(0)
	ItemSocketingSocket2Right:SetAlpha(0)

	for i = 36, 51 do
		select(i, ItemSocketingFrame:GetRegions()):Hide()
	end

	local title = select(18, ItemSocketingFrame:GetRegions())
	title:ClearAllPoints()
	title:SetPoint("TOP", 0, -5)

	S:Reskin(ItemSocketingSocketButton)
	S:ReskinClose(ItemSocketingCloseButton, "TOPRIGHT", ItemSocketingFrame, "TOPRIGHT", -6, -12)
	S:ReskinScroll(ItemSocketingScrollFrameScrollBar)
	for i = 1, MAX_NUM_SOCKETS  do
		local button = _G["ItemSocketingSocket"..i]
		local button_bracket = _G["ItemSocketingSocket"..i.."BracketFrame"]
		local button_bg = _G["ItemSocketingSocket"..i.."Background"]
		local button_icon = _G["ItemSocketingSocket"..i.."IconTexture"]
		local shine = _G["ItemSocketingSocket"..i.."Shine"]
		button:StripTextures()
		button:StyleButton()
		button:SetBackdrop({
			bgFile = R["media"].blank, 
			insets = { left = -R.mult, right = -R.mult, top = -R.mult, bottom = -R.mult }
		})
		button:SetBackdropColor(0, 0, 0, .5)
		button.glow = CreateFrame("Frame", nil, button)
		button.glow:SetAllPoints()
		shine:SetAllPoints()
		button.glow:CreateBorder()
		button_bracket:Kill()
		button_bg:Kill()
		button_icon:SetTexCoord(.08, .92, .08, .92)
		button_icon:ClearAllPoints()
		button_icon:Point("TOPLEFT", 2, -2)
		button_icon:Point("BOTTOMRIGHT", -2, 2)
	end

	hooksecurefunc("ItemSocketingFrame_Update", function()
		for i = 1, MAX_NUM_SOCKETS do
			local color = GEM_TYPE_INFO[GetSocketTypes(i)]
			_G["ItemSocketingSocket"..i].glow:SetBackdropBorderColor(color.r, color.g, color.b)
		end

		local num = GetNumSockets()
		if num == 3 then
			ItemSocketingSocket1:SetPoint("BOTTOM", ItemSocketingFrame, "BOTTOM", -75, 39)
		elseif num == 2 then
			ItemSocketingSocket1:SetPoint("BOTTOM", ItemSocketingFrame, "BOTTOM", -35, 39)
		else
			ItemSocketingSocket1:SetPoint("BOTTOM", ItemSocketingFrame, "BOTTOM", 0, 39)
		end
	end)
end

S:RegisterSkin("Blizzard_ItemSocketingUI", LoadSkin)