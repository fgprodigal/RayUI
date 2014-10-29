local R, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local S = R:NewModule("Skins", "AceEvent-3.0")
local LSM = LibStub("LibSharedMedia-3.0")
S.modName = L["插件美化"]

S.SkinFuncs = {}
S.SkinFuncs["RayUI"] = {}

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

function S:GetOptions()
	local options = {
		skadagroup = {
			order = 5,
			type = "group",
			name = L["Skada"],
			guiInline = true,
			args = {
				skada = {
					order = 1,
					name = L["启用"],
					type = "toggle",
				},
				skadaposition = {
					order = 2,
					name = L["固定Skada位置"],
					type = "toggle",
					disabled = function() return not S.db.skada end,
				},
			},
		},
		dbmgroup = {
			order = 6,
			type = "group",
			name = L["DBM"],
			guiInline = true,
			args = {
				dbm = {
					order = 1,
					name = L["启用"],
					type = "toggle",
				},
				dbmposition = {
					order = 2,
					name = L["固定DBM位置"],
					type = "toggle",
					disabled = function() return not S.db.dbm end,
				},
			},
		},
		ace3group = {
			order = 7,
			type = "group",
			name = L["ACE3控制台"],
			guiInline = true,
			args = {
				ace3 = {
					order = 1,
					name = L["启用"],
					type = "toggle",
				},
			},
		},
		acpgroup = {
			order = 8,
			type = "group",
			name = L["ACP"],
			guiInline = true,
			args = {
				acp = {
					order = 1,
					name = L["启用"],
					type = "toggle",
				},
			},
		},
		-- atlaslootgroup = {
			-- order = 9,
			-- type = "group",
			-- name = L["Atlasloot"],
			-- guiInline = true,
			-- args = {
				-- atlasloot = {
					-- order = 1,
					-- name = L["启用"],
					-- type = "toggle",
				-- },
			-- },
		-- },
		bigwigsgroup = {
			order = 10,
			type = "group",
			name = L["BigWigs"],
			guiInline = true,
			args = {
				bigwigs = {
					order = 1,
					name = L["启用"],
					type = "toggle",
				},
			},
		},
		nugrunninggroup = {
			order = 11,
			type = "group",
			name = "NugRunning",
			guiInline = true,
			args = {
				nugrunning = {
					order = 1,
					name = L["启用"],
					type = "toggle",
				},
			},
		},
		mogitgroup = {
			order = 12,
			type = "group",
			name = "MogIt",
			guiInline = true,
			args = {
				mogit = {
					order = 1,
					name = L["启用"],
					type = "toggle",
				},
			},
		},
		numerationgroup = {
			order = 13,
			type = "group",
			name = "Numeration",
			guiInline = true,
			args = {
				numeration = {
					order = 1,
					name = L["启用"],
					type = "toggle",
				},
			},
		},
	}
	return options
end

function S:CreateStripesThin(f)
	if not f then return end
	f.stripesthin = f:CreateTexture(nil, "BACKGROUND", nil, 1)
	f.stripesthin:SetAllPoints()
	f.stripesthin:SetTexture([[Interface\AddOns\RayUI\media\StripesThin]], true)
	f.stripesthin:SetHorizTile(true)
	f.stripesthin:SetVertTile(true)
	f.stripesthin:SetBlendMode("ADD")
end

function S:CreateBackdropTexture(f)
	if not f then return end
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
	if not f then return end
	f:SetBackdrop({
		bgFile = R["media"].blank,
		edgeFile = R["media"].blank,
		edgeSize = R.mult,
	})
	f:SetBackdropColor(backdropfadecolorr, backdropfadecolorg, backdropfadecolorb, a or alpha)
	f:SetBackdropBorderColor(bordercolorr, bordercolorg, bordercolorb)
end

function S:CreateBG(frame)
	if not frame then return end
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
	if not parent then return end
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
	if not frame then return end
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
	f:SetBackdropColor(r, g, b, .2)
	f:SetBackdropBorderColor(r, g, b)
	if R.global.general.theme == "Shadow" then
		f.glow:SetAlpha(1)
		S:CreatePulse(f.glow)
	end
end

local function StopGlow(f)
	if not f then return end
	f:SetBackdropColor(0, 0, 0, 0)
	f:SetBackdropBorderColor(bordercolorr, bordercolorg, bordercolorb)
	f.glow:SetScript("OnUpdate", nil)
	f.glow:SetAlpha(0)
end

function S:Reskin(f, noGlow)
	if not f then return end
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
end

function S:CreateTab(f)
	if not f then return end
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
	if not f then return end
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
end

function S:ReskinDropDown(f)
	if not f then return end
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
	if not f then return end
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

	f:SetDisabledTexture(R["media"].gloss)
	local dis = f:GetDisabledTexture()
	dis:SetVertexColor(0, 0, 0, .4)
	dis:SetDrawLayer("OVERLAY")
	dis:SetAllPoints()

	f.pixels = {}

	for i = 1, 7 do
		local tex = f:CreateTexture()
		tex:SetTexture(1, 1, 1)
		tex:Size(1, 1)
		tex:Point("BOTTOMLEFT", 4+i, 4+i)
		tinsert(f.pixels, tex)
	end

	for i = 1, 7 do
		local tex = f:CreateTexture()
		tex:SetTexture(1, 1, 1)
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
	if not f then return end
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
	S:CreateBD(f, 0)
	S:CreateBackdropTexture(f)

	if height then f:Height(height) end
	if width then f:Width(width) end
end

function S:ReskinArrow(f, direction)
	if not f then return end
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
	if not f then return end
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

	local ch = f:GetCheckedTexture()
	ch:SetDesaturated(true)
	ch:SetVertexColor(r, g, b)
end

function S:ReskinSlider(f)
	if not f then return end
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
	if not f then return end
	local bg = CreateFrame("Frame", nil, f)
	if not x then
		bg:SetPoint("TOPLEFT")
		bg:SetPoint("BOTTOMRIGHT")
	else
		bg:Point("TOPLEFT", x, y)
		bg:Point("BOTTOMRIGHT", x2, y2)
	end
	bg:SetFrameLevel(f:GetFrameLevel())
	S:CreateBD(bg)
	S:CreateSD(bg)
	f:HookScript("OnShow", function()
		bg:SetFrameLevel(f:GetFrameLevel())
	end)
end

function S:ReskinPortraitFrame(f, isButtonFrame)
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

function S:ReskinExpandOrCollapse(f)
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

function S:RegisterSkin(name, loadFunc)
	if name == 'RayUI' then
		tinsert(self.SkinFuncs["RayUI"], loadFunc)
	else
		self.SkinFuncs[name] = loadFunc
	end
end

function S:ADDON_LOADED(event, addon)
	if IsAddOnLoaded("Skinner") or IsAddOnLoaded("Aurora") or addon == "RayUI" then return end
	if self.SkinFuncs[addon] then
		self.SkinFuncs[addon]()
		self.SkinFuncs[addon] = nil
	end
end

function S:PLAYER_ENTERING_WORLD(event, addon)
	if IsAddOnLoaded("Skinner") or IsAddOnLoaded("Aurora") then return end
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	for t, skinfunc in pairs(self.SkinFuncs["RayUI"]) do
		if skinfunc then
			skinfunc()
		end
	end
	wipe(self.SkinFuncs["RayUI"])
end

function S:Initialize()
	backdropfadecolorr, backdropfadecolorg, backdropfadecolorb, alpha = unpack(R["media"].backdropfadecolor)
	backdropcolorr, backdropcolorg, backdropcolorb = unpack(R["media"].backdropcolor)
	bordercolorr, bordercolorg, bordercolorb = unpack(R["media"].bordercolor)
	for addon, loadFunc in pairs(self.SkinFuncs) do
		if addon ~= "RayUI" then
			if IsAddOnLoaded(addon) then
				loadFunc()
				self.SkinFuncs[addon] = nil
			end
		end
	end

	S:RegisterEvent("ADDON_LOADED")
	S:RegisterEvent("PLAYER_ENTERING_WORLD")
end

function S:Info()
	return L["|cff7aa6d6Ray|r|cffff0000U|r|cff7aa6d6I|r插件美化模块."]
end

R:RegisterModule(S:GetName())
