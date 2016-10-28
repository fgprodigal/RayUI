local R, L, P, G = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, GlobalDB
local S = R:NewModule("Skins", "AceEvent-3.0")
local LSM = LibStub("LibSharedMedia-3.0")

--Cache global variables
--Lua functions
local _G = _G
local select, unpack, assert, pairs, type = select, unpack, assert, pairs, type
local tinsert = table.insert
local wipe = table.wipe

--WoW API / Variables
local CreateFrame = CreateFrame
local IsAddOnLoaded = IsAddOnLoaded

S.modName = L["插件美化"]

S.allowBypass = {}
S.addonCallbacks = {}
S.nonAddonCallbacks = {}

local alpha
local backdropcolorr, backdropcolorg, backdropcolorb
local backdropfadecolorr, backdropfadecolorg, backdropfadecolorb
local bordercolorr, bordercolorg, bordercolorb

S["media"] = {
	["checked"] = "Interface\\AddOns\\RayUI\\media\\CheckButtonHilight",
	["arrowUp"] = "Interface\\AddOns\\RayUI\\media\\arrow-up-active",
	["arrowDown"] = "Interface\\AddOns\\RayUI\\media\\arrow-down-active",
	["arrowLeft"] = "Interface\\AddOns\\RayUI\\media\\arrow-left-active",
	["arrowRight"] = "Interface\\AddOns\\RayUI\\media\\arrow-right-active",
	["classcolours"] = R.colors.class
}

local r, g, b = S["media"].classcolours[R.myclass].r, S["media"].classcolours[R.myclass].g, S["media"].classcolours[R.myclass].b
S["media"].r, S["media"].g, S["media"].b = r, g, b

function S:CreateGradient(f)
	assert(f, "doesn't exist!")
	local tex = f:CreateTexture(nil, "BORDER")
	tex:SetPoint("TOPLEFT", 1, -1)
	tex:SetPoint("BOTTOMRIGHT", -1, 1)
	tex:SetTexture([[Interface\AddOns\RayUI\media\gradient.tga"]])
	tex:SetVertexColor(.3, .3, .3, .15)

	return tex
end

function S:CreateStripesThin(f)
	assert(f, "doesn't exist!")
	f.stripesthin = f:CreateTexture(nil, "BACKGROUND", nil, 1)
	f.stripesthin:SetAllPoints()
	f.stripesthin:SetTexture([[Interface\AddOns\RayUI\media\StripesThin]], true, true)
	f.stripesthin:SetHorizTile(true)
	f.stripesthin:SetVertTile(true)
	f.stripesthin:SetBlendMode("ADD")
end

function S:CreateBackdropTexture(f)
	assert(f, "doesn't exist!")
	local tex = f:CreateTexture(nil, "BACKGROUND")
	tex:SetDrawLayer("BACKGROUND", 1)
	tex:SetInside(f, 1, 1)
	tex:SetTexture(R["media"].gloss)
	--tex:SetGradientAlpha("VERTICAL", 0, 0, 0, .3, .35, .35, .35, .35)
	tex:SetVertexColor(backdropcolorr, backdropcolorg, backdropcolorb)
	tex:SetAlpha(0.8)
	f.backdropTexture = tex
end

function S:CreateBD(f, a)
	assert(f, "doesn't exist!")
	f:SetBackdrop({
		bgFile = R["media"].blank,
		edgeFile = R["media"].blank,
		edgeSize = R.mult,
	})
	f:SetBackdropColor(backdropfadecolorr, backdropfadecolorg, backdropfadecolorb, a or alpha)
	f:SetBackdropBorderColor(bordercolorr, bordercolorg, bordercolorb)
end

function S:CreateBG(frame)
	assert(frame, "doesn't exist!")
	local f = frame
	if frame:GetObjectType() == "Texture" then f = frame:GetParent() end

	local bg = f:CreateTexture(nil, "BACKGROUND")
	bg:Point("TOPLEFT", frame, -1, 1)
	bg:Point("BOTTOMRIGHT", frame, 1, -1)
	bg:SetTexture(R["media"].blank)
	bg:SetVertexColor(0, 0, 0)

	return bg
end

function S:CreateSD(parent, size, r, g, b, alpha, offset)
	assert(parent, "doesn't exist!")
	S:CreateStripesThin(parent)

	if R.global.general.theme~="Shadow" then return end
	local sd = CreateFrame("Frame", nil, parent)
	sd.size = size or 5
	sd.size = sd.size - 5
	sd.offset = offset or 0
	sd:Point("TOPLEFT", parent, -sd.size - 1 - sd.offset, sd.size + 1 + sd.offset)
	sd:Point("BOTTOMRIGHT", parent, sd.size + 1 + sd.offset, -sd.size - 1 - sd.offset)
	sd:CreateShadow()
	sd.shadow:SetBackdropBorderColor(r or bordercolorr, g or bordercolorg, b or bordercolorb)
	sd.border:SetBackdropBorderColor(r or bordercolorr, g or bordercolorg, b or bordercolorb)
	sd:SetAlpha(alpha or 1)
end

function S:CreatePulse(frame, speed, alpha, mult)
	assert(frame, "doesn't exist!")
	frame.speed = .02
	frame.mult = mult or 1
	frame.alpha = alpha or 1
	frame.tslu = 0
	frame:SetScript("OnUpdate", function(self, elapsed)
		elapsed = elapsed * ( speed or 5/4 )
		self.tslu = self.tslu + elapsed
		if self.tslu > self.speed then
			self.tslu = 0
			self:SetAlpha(self.alpha*(alpha or 3/5))
		end
		self.alpha = self.alpha - elapsed*self.mult
		if self.alpha < 0 and self.mult > 0 then
			self.mult = self.mult*-1
			self.alpha = 0
		elseif self.alpha > 1 and self.mult < 0 then
			self.mult = self.mult*-1
		end
	end)
end

local function StartGlow(f)
	if not f:IsEnabled() then return end
	f:SetBackdropColor(r, g, b, .5)
	f:SetBackdropBorderColor(r, g, b)
	if R.global.general.theme == "Shadow" then
		f.glow:SetAlpha(1)
		S:CreatePulse(f.glow)
	end
end

local function StopGlow(f)
	f:SetBackdropColor(0, 0, 0, 0)
	f:SetBackdropBorderColor(bordercolorr, bordercolorg, bordercolorb)
	f.glow:SetScript("OnUpdate", nil)
	f.glow:SetAlpha(0)
end

function S:Reskin(f, noGlow)
	assert(f, "doesn't exist!")
	f:SetNormalTexture("")
	f:SetHighlightTexture("")
	f:SetPushedTexture("")
	f:SetDisabledTexture("")

	if f.Left then f.Left:SetAlpha(0) end
	if f.Middle then f.Middle:SetAlpha(0) end
	if f.Right then f.Right:SetAlpha(0) end
	if f.LeftSeparator then f.LeftSeparator:Hide() end
	if f.RightSeparator then f.RightSeparator:Hide() end

	f:SetTemplate("Default", true)

	if not noGlow then
		f.glow = CreateFrame("Frame", nil, f)
		f.glow:SetBackdrop({
			edgeFile = R["media"].glow,
			edgeSize = R:Scale(4),
		})
		f.glow:SetOutside(f, 4, 4)
		f.glow:SetBackdropBorderColor(r, g, b)
		f.glow:SetAlpha(0)

		f:HookScript("OnEnter", StartGlow)
		f:HookScript("OnLeave", StopGlow)
	end

	if not f.tex then
		f.tex = S:CreateGradient(f)
	else
		f.gradient = S:CreateGradient(f)
	end
end

function S:CreateTab(f)
	assert(f, "doesn't exist!")
	f:DisableDrawLayer("BACKGROUND")

	local bg = CreateFrame("Frame", nil, f)
	bg:Point("TOPLEFT", 8, -3)
	bg:Point("BOTTOMRIGHT", -8, 0)
	bg:SetFrameLevel(f:GetFrameLevel()-1)
	S:CreateBD(bg)

	f:SetHighlightTexture(R["media"].blank)
	local hl = f:GetHighlightTexture()
	hl:Point("TOPLEFT", 9, -4)
	hl:Point("BOTTOMRIGHT", -9, 1)
	hl:SetVertexColor(r, g, b, .25)
end

function S:ReskinScroll(f)
	assert(f, "doesn't exist!")
	if f:GetName() then
		local frame = f:GetName()

		if _G[frame.."Track"] then _G[frame.."Track"]:Hide() end
		if _G[frame.."BG"] then _G[frame.."BG"]:Hide() end
		if _G[frame.."Top"] then _G[frame.."Top"]:Hide() end
		if _G[frame.."Middle"] then _G[frame.."Middle"]:Hide() end
		if _G[frame.."Bottom"] then _G[frame.."Bottom"]:Hide() end

		local bu = _G[frame.."ThumbTexture"]
		bu:SetAlpha(0)
		bu:Width(17)

		bu.bg = CreateFrame("Frame", nil, f)
		bu.bg:Point("TOPLEFT", bu, 0, -2)
		bu.bg:Point("BOTTOMRIGHT", bu, 0, 4)
		S:CreateBD(bu.bg, 0)
		S:CreateBackdropTexture(f)
		f.backdropTexture:SetInside(bu.bg, 1, 1)

		local tex = S:CreateGradient(f)
		tex:Point("TOPLEFT", bu.bg, 1, -1)
		tex:Point("BOTTOMRIGHT", bu.bg, -1, 1)

		local up = _G[frame.."ScrollUpButton"]
		local down = _G[frame.."ScrollDownButton"]

		up:Width(17)
		down:Width(17)

		S:Reskin(up)
		S:Reskin(down)

		up:SetDisabledTexture(R["media"].blank)
		local dis1 = up:GetDisabledTexture()
		dis1:SetVertexColor(0, 0, 0, .3)
		dis1:SetDrawLayer("OVERLAY")

		down:SetDisabledTexture(R["media"].blank)
		local dis2 = down:GetDisabledTexture()
		dis2:SetVertexColor(0, 0, 0, .3)
		dis2:SetDrawLayer("OVERLAY")

		local uptex = up:CreateTexture(nil, "ARTWORK")
		uptex:SetTexture("Interface\\AddOns\\RayUI\\media\\arrow-up-active")
		uptex:Size(8, 8)
		uptex:SetPoint("CENTER")
		uptex:SetVertexColor(1, 1, 1)

		local downtex = down:CreateTexture(nil, "ARTWORK")
		downtex:SetTexture("Interface\\AddOns\\RayUI\\media\\arrow-down-active")
		downtex:Size(8, 8)
		downtex:SetPoint("CENTER")
		downtex:SetVertexColor(1, 1, 1)
	else
		if f.Background then f.Background:SetTexture(nil) end
		if f.trackBG then f.trackBG:SetTexture(nil) end
		if f.Middle then f.Middle:SetTexture(nil) end
		if f.Top then f.Top:SetTexture(nil) end
		if f.Bottom then f.Bottom:SetTexture(nil) end
		if f.ScrollBarTop then f.ScrollBarTop:SetTexture(nil) end
		if f.ScrollBarBottom then f.ScrollBarBottom:SetTexture(nil) end
		if f.ScrollBarMiddle then f.ScrollBarMiddle:SetTexture(nil) end
		if f.ScrollUpButton and f.ScrollDownButton then
			if not f.ScrollUpButton.icon then
				S:Reskin(f.ScrollUpButton)
				f.ScrollUpButton:SetDisabledTexture(R["media"].blank)
				f.ScrollUpButton:Width(17)
				local uptex = f.ScrollUpButton:CreateTexture(nil, "ARTWORK")
				uptex:SetTexture("Interface\\AddOns\\RayUI\\media\\arrow-up-active")
				uptex:Size(8, 8)
				uptex:SetPoint("CENTER")
				uptex:SetVertexColor(1, 1, 1)
				f.ScrollUpButton.icon = uptex
				local dis1 = f.ScrollUpButton:GetDisabledTexture()
				dis1:SetVertexColor(0, 0, 0, .3)
				dis1:SetDrawLayer("OVERLAY")
			end

			if not f.ScrollDownButton.icon then
				S:Reskin(f.ScrollDownButton)
				f.ScrollDownButton:SetDisabledTexture(R["media"].blank)
				f.ScrollDownButton:Width(17)
				local downtex = f.ScrollDownButton:CreateTexture(nil, "ARTWORK")
				downtex:SetTexture("Interface\\AddOns\\RayUI\\media\\arrow-down-active")
				downtex:Size(8, 8)
				downtex:SetPoint("CENTER")
				downtex:SetVertexColor(1, 1, 1)
				f.ScrollDownButton.icon = downtex
				local dis2 = f.ScrollDownButton:GetDisabledTexture()
				dis2:SetVertexColor(0, 0, 0, .3)
				dis2:SetDrawLayer("OVERLAY")
			end

			if f.thumbTexture then
				local bu = f.thumbTexture
				bu:SetAlpha(0)
				bu:Width(17)

				bu.bg = CreateFrame("Frame", nil, f)
				bu.bg:Point("TOPLEFT", bu, 0, -2)
				bu.bg:Point("BOTTOMRIGHT", bu, 0, 4)
				S:CreateBD(bu.bg, 0)
				S:CreateBackdropTexture(f)
				f.backdropTexture:SetInside(bu.bg, 1, 1)

				local tex = S:CreateGradient(f)
				tex:Point("TOPLEFT", bu.bg, 1, -1)
				tex:Point("BOTTOMRIGHT", bu.bg, -1, 1)
			end
		end
	end
end

function S:ReskinDropDown(f)
	assert(f, "doesn't exist!")
	local frame = f:GetName()

	local left = _G[frame.."Left"]
	local middle = _G[frame.."Middle"]
	local right = _G[frame.."Right"]

	if left then left:SetAlpha(0) end
	if middle then middle:SetAlpha(0) end
	if right then right:SetAlpha(0) end

	local down = _G[frame.."Button"]

	down:ClearAllPoints()
	down:Point("TOPRIGHT", -18, -4)
	down:Point("BOTTOMRIGHT", -18, 8)
	down:SetWidth(19)

	S:Reskin(down)

	down:SetDisabledTexture(R["media"].blank)
	local dis = down:GetDisabledTexture()
	dis:SetVertexColor(0, 0, 0, .3)
	dis:SetDrawLayer("OVERLAY")
	dis:SetAllPoints(down)

	local downtex = down:CreateTexture(nil, "ARTWORK")
	downtex:SetTexture("Interface\\AddOns\\RayUI\\media\\arrow-down-active")
	downtex:SetSize(8, 8)
	downtex:SetPoint("CENTER")
	downtex:SetVertexColor(1, 1, 1)

	local bg = CreateFrame("Frame", nil, f)
	bg:Point("TOPLEFT", 16, -4)
	bg:Point("BOTTOMRIGHT", -18, 8)
	bg:SetFrameLevel(f:GetFrameLevel()-1)
	S:CreateBD(bg, 0)
	S:CreateBackdropTexture(bg)

	local gradient = S:CreateGradient(f)
	gradient:Point("TOPLEFT", bg, 1, -1)
	gradient:Point("BOTTOMRIGHT", bg, -1, 1)
end

local function colourClose(f)
	if f:IsEnabled() then
		for _, pixel in pairs(f.pixels) do
			pixel:SetVertexColor(r, g, b)
		end
	end
end

local function clearClose(f)
	for _, pixel in pairs(f.pixels) do
		pixel:SetVertexColor(1, 1, 1)
	end
end

function S:ReskinClose(f, a1, p, a2, x, y)
	assert(f, "doesn't exist!")
	f:Size(17, 17)

	if not a1 then
		f:Point("TOPRIGHT", -4, -4)
	else
		f:ClearAllPoints()
		f:Point(a1, p, a2, x, y)
	end

	f:SetNormalTexture("")
	f:SetHighlightTexture("")
	f:SetPushedTexture("")
	f:SetDisabledTexture("")

	S:CreateBD(f, 0)
	S:CreateBackdropTexture(f)
	S:CreateGradient(f)

	f:SetDisabledTexture(R["media"].gloss)
	local dis = f:GetDisabledTexture()
	dis:SetVertexColor(0, 0, 0, .4)
	dis:SetDrawLayer("OVERLAY")
	dis:SetAllPoints()

	f.pixels = {}

	for i = 1, 7 do
		local tex = f:CreateTexture()
		tex:SetColorTexture(1, 1, 1)
		tex:Size(1, 1)
		tex:Point("BOTTOMLEFT", 4+i, 4+i)
		tinsert(f.pixels, tex)
	end

	for i = 1, 7 do
		local tex = f:CreateTexture()
		tex:SetColorTexture(1, 1, 1)
		tex:Size(1, 1)
		tex:Point("TOPLEFT", 4+i, -4-i)
		tinsert(f.pixels, tex)
	end

	f:HookScript("OnEnter", colourClose)
	f:HookScript("OnLeave", clearClose)

	-- local text = f:CreateFontString(nil, "OVERLAY")
	-- text:SetFont(R["media"].pxfont, R.mult*10, "OUTLINE,MONOCHROME")
	-- text:Point("CENTER", 2, 1)
	-- text:SetText("x")

	-- f:HookScript("OnEnter", function(self) text:SetTextColor(1, .1, .1) end)
	-- f:HookScript("OnLeave", function(self) text:SetTextColor(1, 1, 1) end)
end

function S:ReskinInput(f, height, width)
	assert(f, "doesn't exist!")
	local frame = f:GetName()
	if frame then
		if _G[frame.."Left"] then _G[frame.."Left"]:Hide() end
		if _G[frame.."Right"] then _G[frame.."Right"]:Hide() end
		if _G[frame.."Middle"] then _G[frame.."Middle"]:Hide() end
		if _G[frame.."Mid"] then _G[frame.."Mid"]:Hide() end
	end
	if f.Left then f.Left:Hide() end
	if f.Middle then f.Middle:Hide() end
	if f.Right then f.Right:Hide() end

	local bd = CreateFrame("Frame", nil, f)
	bd:Point("TOPLEFT", -2, 0)
	bd:SetPoint("BOTTOMRIGHT")
	bd:SetFrameLevel(f:GetFrameLevel()-1)
	S:CreateBD(bd, 0)
	S:CreateBackdropTexture(f)

	local gradient = S:CreateGradient(f)
	gradient:Point("TOPLEFT", bd, 1, -1)
	gradient:Point("BOTTOMRIGHT", bd, -1, 1)

	if height then f:Height(height) end
	if width then f:Width(width) end
end

function S:ReskinArrow(f, direction)
	assert(f, "doesn't exist!")
	f:Size(18, 18)
	S:Reskin(f)

	f:SetDisabledTexture(R["media"].blank)
	local dis = f:GetDisabledTexture()
	dis:SetVertexColor(0, 0, 0, .3)
	dis:SetDrawLayer("OVERLAY")

	local tex = f:CreateTexture(nil, "ARTWORK")
	tex:Size(8, 8)
	tex:SetPoint("CENTER")

	tex:SetTexture("Interface\\AddOns\\RayUI\\media\\arrow-"..direction.."-active")
end

function S:ReskinCheck(f)
	assert(f, "doesn't exist!")
	f:SetNormalTexture("")
	f:SetPushedTexture("")
	f:SetHighlightTexture(R["media"].blank)
	local hl = f:GetHighlightTexture()
	hl:SetInside(f, 5, 5)
	hl:SetVertexColor(r, g, b, .2)

	S:CreateBackdropTexture(f)
	f.backdropTexture:SetInside(f, 5, 5)

	local bd = CreateFrame("Frame", nil, f)
	bd:SetInside(f, 4, 4)
	bd:SetFrameLevel(f:GetFrameLevel())
	S:CreateBD(bd, 0)

	local tex = S:CreateGradient(f)
	tex:SetInside(f, 5, 5)

	local ch = f:GetCheckedTexture()
	ch:SetDesaturated(true)
	ch:SetVertexColor(r, g, b)
end

function S:ReskinSlider(f)
	assert(f, "doesn't exist!")
	f:SetBackdrop(nil)
	f.SetBackdrop = R.dummy

	local bd = CreateFrame("Frame", nil, f)
	bd:Point("TOPLEFT", 1, -2)
	bd:Point("BOTTOMRIGHT", -1, 3)
	bd:SetFrameStrata("BACKGROUND")
	bd:SetFrameLevel(f:GetFrameLevel()-1)
	S:CreateBD(bd, 0)
	S:CreateBackdropTexture(bd)

	local slider = select(4, f:GetRegions())
	slider:SetTexture("Interface\\CastingBar\\UI-CastingBar-Spark")
	slider:SetBlendMode("ADD")
end

function S:SetBD(f, x, y, x2, y2)
	assert(f, "doesn't exist!")
	local bg = CreateFrame("Frame", nil, f)
	if not x then
		bg:SetPoint("TOPLEFT")
		bg:SetPoint("BOTTOMRIGHT")
	else
		bg:Point("TOPLEFT", x, y)
		bg:Point("BOTTOMRIGHT", x2, y2)
	end
	local level = f:GetFrameLevel() - 1
	if level < 0 then level = 0 end
	bg:SetFrameLevel(level)
	S:CreateBD(bg)
	S:CreateSD(bg)
	f:HookScript("OnShow", function()
		bg:SetFrameLevel(level)
	end)
end

function S:ReskinPortraitFrame(f, isButtonFrame)
	assert(f, "doesn't exist!")
	local name = f:GetName()

	_G[name.."Bg"]:Hide()
	_G[name.."TitleBg"]:Hide()
	_G[name.."Portrait"]:Hide()
	_G[name.."PortraitFrame"]:Hide()
	_G[name.."TopRightCorner"]:Hide()
	_G[name.."TopLeftCorner"]:Hide()
	_G[name.."TopBorder"]:Hide()
	_G[name.."TopTileStreaks"]:SetTexture("")
	_G[name.."BotLeftCorner"]:Hide()
	_G[name.."BotRightCorner"]:Hide()
	_G[name.."BottomBorder"]:Hide()
	_G[name.."LeftBorder"]:Hide()
	_G[name.."RightBorder"]:Hide()

	if isButtonFrame then
		_G[name.."BtnCornerLeft"]:SetTexture("")
		_G[name.."BtnCornerRight"]:SetTexture("")
		_G[name.."ButtonBottomBorder"]:SetTexture("")

		f.Inset.Bg:Hide()
		f.Inset:DisableDrawLayer("BORDER")
	end

	S:CreateBD(f)
	S:CreateSD(f)
	S:ReskinClose(_G[name.."CloseButton"])
end

function S:CreateBDFrame(f, a)
	assert(f, "doesn't exist!")
	local frame
	if f:GetObjectType() == "Texture" then
		frame = f:GetParent()
	else
		frame = f
	end

	local lvl = frame:GetFrameLevel()

	local bg = CreateFrame("Frame", nil, frame)
	bg:Point("TOPLEFT", f, -1, 1)
	bg:Point("BOTTOMRIGHT", f, 1, -1)
	bg:SetFrameLevel(lvl == 0 and 1 or lvl - 1)
	S:CreateBD(bg, a or alpha)
	return bg
end

function S:ReskinFilterButton(f)
	assert(f, "doesn't exist!")
	f.TopLeft:Hide()
	f.TopRight:Hide()
	f.BottomLeft:Hide()
	f.BottomRight:Hide()
	f.TopMiddle:Hide()
	f.MiddleLeft:Hide()
	f.MiddleRight:Hide()
	f.BottomMiddle:Hide()
	f.MiddleMiddle:Hide()

	S:Reskin(f)
	f.Icon:SetTexture(S["media"].arrowRight)

	f.Text:SetPoint("CENTER")
	f.Icon:SetPoint("RIGHT", f, "RIGHT", -5, 0)
	f.Icon:SetSize(8, 8)
end

local function colourArrow(f)
	if f:IsEnabled() then
		f.tex:SetVertexColor(r, g, b)
	end
end

local function clearArrow(f)
	f.tex:SetVertexColor(1, 1, 1)
end

S.colourArrow = colourArrow
S.clearArrow = clearArrow

function S:ReskinNavBar(f)
	assert(f, "doesn't exist!")
	local overflowButton = f.overflowButton
	if not f.GetRegions then return end

	f:GetRegions():Hide()
	f:DisableDrawLayer("BORDER")
	f.overlay:Hide()
	f.homeButton:GetRegions():Hide()

	S:Reskin(f.homeButton)
	S:Reskin(overflowButton, true)

	local tex = overflowButton:CreateTexture(nil, "ARTWORK")
	tex:SetTexture(S["media"].arrowLeft)
	tex:SetSize(8, 8)
	tex:SetPoint("CENTER")
	overflowButton.tex = tex

	overflowButton:HookScript("OnEnter", colourArrow)
	overflowButton:HookScript("OnLeave", clearArrow)
end

function S:ReskinIcon(icon)
	assert(icon, "doesn't exist!")
	icon:SetTexCoord(.08, .92, .08, .92)
	icon.bg = S:CreateBG(icon)
end

function S:ReskinExpandOrCollapse(f)
	assert(f, "doesn't exist!")
	f:SetSize(13, 13)

	S:Reskin(f)
	f.SetNormalTexture = R.dummy

	f.minus = f:CreateTexture(nil, "OVERLAY")
	f.minus:Size(7, 1)
	f.minus:SetPoint("CENTER")
	f.minus:SetTexture(R["media"].gloss)
	f.minus:SetVertexColor(1, 1, 1)

	f.plus = f:CreateTexture(nil, "OVERLAY")
	f.plus:Size(1, 7)
	f.plus:SetPoint("CENTER")
	f.plus:SetTexture(R["media"].gloss)
	f.plus:SetVertexColor(1, 1, 1)
end

function S:ReskinGarrisonPortrait(portrait, isTroop)
	assert(portrait, "doesn't exist!")
	portrait:SetSize(portrait.Portrait:GetSize())
	S:CreateBD(portrait, 1)

	portrait.Portrait:ClearAllPoints()
	portrait.Portrait:SetPoint("TOPLEFT")

	portrait.PortraitRing:Hide()
	portrait.PortraitRingQuality:SetTexture(nil)
	portrait.PortraitRingCover:SetTexture(nil)
	portrait.LevelBorder:SetAlpha(0)

	if not isTroop then
		local lvlBG = portrait:CreateTexture(nil, "BORDER")
		lvlBG:SetColorTexture(0, 0, 0, 0.5)
		lvlBG:SetPoint("TOPLEFT", portrait, "BOTTOMLEFT", 1, 12)
		lvlBG:SetPoint("BOTTOMRIGHT", portrait, -1, 1)

		local level = portrait.Level
		level:ClearAllPoints()
		level:SetPoint("CENTER", lvlBG)
	end
end

function S:ReskinIconSelectionFrame(frame, numIcons, buttonNameTemplate, frameNameOverride)
	assert(frame, "HandleIconSelectionFrame: frame argument missing")
	assert(numIcons and type(numIcons) == "number", "HandleIconSelectionFrame: numIcons argument missing or not a number")
	assert(buttonNameTemplate and type(buttonNameTemplate) == "string", "HandleIconSelectionFrame: buttonNameTemplate argument missing or not a string")

	local frameName = frameNameOverride or frame:GetName() --We need override in case Blizzard fucks up the naming (guild bank)
	local scrollFrame = _G[frameName.."ScrollFrame"]
	local editBox = _G[frameName.."EditBox"]
	local okayButton = _G[frameName.."OkayButton"] or _G[frameName.."Okay"]
	local cancelButton = _G[frameName.."CancelButton"] or _G[frameName.."Cancel"]

	frame:StripTextures()
	frame.BorderBox:StripTextures()
	scrollFrame:StripTextures()
	editBox:DisableDrawLayer("BACKGROUND") --Removes textures around it

	frame:SetTemplate("Transparent")
	frame:Height(frame:GetHeight() + 10)
	scrollFrame:Height(scrollFrame:GetHeight() + 10)

	S:Reskin(okayButton)
	S:Reskin(cancelButton)
	S:ReskinInput(editBox)

	cancelButton:ClearAllPoints()
	cancelButton:Point("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -5, 5)

	for i = 1, numIcons do
		local button = _G[buttonNameTemplate..i]
		local icon = _G[button:GetName().."Icon"]
		button:StripTextures()
		S:CreateBD(button, .25)
		button:StyleButton(1)
		icon:SetInside(button, 1, 1)
		icon:SetTexCoord(.08, .92, .08, .92)
	end
end

--Add callback for skin that relies on another addon.
--These events will be fired when the addon is loaded.
function S:AddCallbackForAddon(addonName, eventName, loadFunc, forceLoad, bypass)
	if not addonName or type(addonName) ~= "string" then
		R:Print("Invalid argument #1 to S:AddCallbackForAddon (string expected)")
		return
	elseif not eventName or type(eventName) ~= "string" then
		R:Print("Invalid argument #2 to S:AddCallbackForAddon (string expected)")
		return
	elseif not loadFunc or type(loadFunc) ~= "function" then
		R:Print("Invalid argument #3 to S:AddCallbackForAddon (function expected)")
		return
	end

	if bypass then
		self.allowBypass[addonName] = true
	end

	--Create an event registry for this addon, so that we can fire multiple events when this addon is loaded
	if not self.addonCallbacks[addonName] then
		self.addonCallbacks[addonName] = {}
	end

	if self.addonCallbacks[addonName][eventName] then
		--Don't allow a registered callback to be overwritten
		R:Print("Invalid argument #2 to S:AddCallbackForAddon (event name is already registered, please use a unique event name)")
		return
	end

	--Register loadFunc to be called when event is fired
	R.RegisterCallback(R, eventName, loadFunc)

	if forceLoad then
		R.callbacks:Fire(eventName)
	else
		--Insert eventName in this addons' registry
		self.addonCallbacks[addonName][eventName] = true
	end
end

--Add callback for skin that does not rely on a another addon.
--These events will be fired when the Skins module is initialized.
function S:AddCallback(eventName, loadFunc)
	if not eventName or type(eventName) ~= "string" then
		R:Print("Invalid argument #1 to S:AddCallback (string expected)")
		return
	elseif not loadFunc or type(loadFunc) ~= "function" then
		R:Print("Invalid argument #2 to S:AddCallback (function expected)")
		return
	end

	if self.nonAddonCallbacks[eventName] then
		--Don't allow a registered callback to be overwritten
		R:Print("Invalid argument #1 to S:AddCallback (event name is already registered, please use a unique event name)")
		return
	end

	--Add event name to registry
	self.nonAddonCallbacks[eventName] = true

	--Register loadFunc to be called when event is fired
	R.RegisterCallback(R, eventName, loadFunc)
end

function S:ADDON_LOADED(event, addon)
	if IsAddOnLoaded("Skinner") or IsAddOnLoaded("Aurora") or addon == "RayUI" then return end
	if self.allowBypass[addon] then
		if S.addonCallbacks[addon] then
			--Fire events to the skins that rely on this addon
			for event in pairs(S.addonCallbacks[addon]) do
				S.addonCallbacks[addon][event] = nil
				R.callbacks:Fire(event)
			end
		end
		return
	end

	if S.addonCallbacks[addon] then
		for event in pairs(S.addonCallbacks[addon]) do
			S.addonCallbacks[addon][event] = nil
			R.callbacks:Fire(event)
		end
	end
end

function S:Initialize()
	if not self.db.enable then
		wipe(self.addonCallbacks)
		wipe(self.nonAddonCallbacks)
		return
	end

	backdropfadecolorr, backdropfadecolorg, backdropfadecolorb, alpha = unpack(R["media"].backdropfadecolor)
	backdropcolorr, backdropcolorg, backdropcolorb = unpack(R["media"].backdropcolor)
	bordercolorr, bordercolorg, bordercolorb = unpack(R["media"].bordercolor)

	--Fire events for Blizzard addons that are already loaded
	for addon, events in pairs(self.addonCallbacks) do
		if IsAddOnLoaded(addon) then
			for event in pairs(events) do
				self.addonCallbacks[addon][event] = nil
				R.callbacks:Fire(event)
			end
		end
	end
	--Fire event for all skins that doesn't rely on a Blizzard addon
	for eventName in pairs(self.nonAddonCallbacks) do
		self.addonCallbacks[eventName] = nil
		R.callbacks:Fire(eventName)
	end

	S:RegisterEvent("ADDON_LOADED")
end

function S:Info()
	return L["|cff7aa6d6Ray|r|cffff0000U|r|cff7aa6d6I|r插件美化模块."]
end

R:RegisterModule(S:GetName())
