local R, L, P = unpack(select(2, ...)) --Inport: Engine, Locales, ProfileDB
local S = R:GetModule("Skins")

local function LoadSkin()
	S:ReskinPortraitFrame(ItemSocketingFrame, true)
	S:CreateBD(ItemSocketingScrollFrame, .25)
	ItemSocketingScrollFrame:StripTextures()
	ItemSocketingFrame:DisableDrawLayer("BORDER")
	ItemSocketingFrame:DisableDrawLayer("ARTWORK")
	ItemSocketingScrollFrameTop:SetAlpha(0)
	ItemSocketingScrollFrameBottom:SetAlpha(0)
	ItemSocketingSocket1Left:SetAlpha(0)
	ItemSocketingSocket1Right:SetAlpha(0)
	ItemSocketingSocket2Left:SetAlpha(0)
	ItemSocketingSocket2Right:SetAlpha(0)
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
		ItemSocketingFrame:HookScript("OnUpdate", function(self)
			gemColor = GetSocketTypes(i)
			local color = GEM_TYPE_INFO[gemColor]
			button.glow:SetBackdropBorderColor(color.r, color.g, color.b)
		end)
	end

	for i = 1, MAX_NUM_SOCKETS  do
		local button = _G["ItemSocketingSocket"..i]
		button:StyleButton()
	end
end

S:RegisterSkin("Blizzard_ItemSocketingUI", LoadSkin)