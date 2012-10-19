-----------------------------------------------------
-- Credit Tukz, Elv
-----------------------------------------------------
local R, L, P = unpack(select(2, ...)) --Inport: Engine, Locales, ProfileDB
local LSM = LibStub("LibSharedMedia-3.0")

local function Size(frame, width, height)
	frame:SetSize(R:Scale(width), R:Scale(height or width))
end

local function Width(frame, width)
	frame:SetWidth(R:Scale(width))
end

local function Height(frame, height)
	frame:SetHeight(R:Scale(height))
end

local function Point(obj, arg1, arg2, arg3, arg4, arg5)
	-- anyone has a more elegant way for this?
	if type(arg1)=="number" then arg1 = R:Scale(arg1) end
	if type(arg2)=="number" then arg2 = R:Scale(arg2) end
	if type(arg3)=="number" then arg3 = R:Scale(arg3) end
	if type(arg4)=="number" then arg4 = R:Scale(arg4) end
	if type(arg5)=="number" then arg5 = R:Scale(arg5) end

	obj:SetPoint(arg1, arg2, arg3, arg4, arg5)
end

local function CreateShadow(f, t, thickness, texture)
	if f.shadow then return end

	local borderr, borderg, borderb, bordera = unpack(R["media"].bordercolor)
	local backdropr, backdropg, backdropb, backdropa = unpack(R["media"].backdropcolor)
	local frameLevel = f:GetFrameLevel() > 1 and f:GetFrameLevel() or 1
	local thickness = thickness or 4
	local offset = thickness - 1

	if t == "Background" then
		backdropr, backdropg, backdropb, backdropa = unpack(R["media"].backdropfadecolor)
	else
		backdropa = 0
	end

	local border = CreateFrame("Frame", nil, f)
	border:SetFrameLevel(frameLevel)
	border:Point("TOPLEFT", -1, 1)
	border:Point("TOPRIGHT", 1, 1)
	border:Point("BOTTOMRIGHT", 1, -1)
	border:Point("BOTTOMLEFT", -1, -1)
	border:CreateBorder()
	f.border = border

	local shadow = CreateFrame("Frame", nil, border)
	shadow:SetFrameLevel(frameLevel - 1)
	shadow:Point("TOPLEFT", -offset, offset)
	shadow:Point("TOPRIGHT", offset, offset)
	shadow:Point("BOTTOMRIGHT", offset, -offset)
	shadow:Point("BOTTOMLEFT", -offset, -offset)
	shadow:SetBackdrop( { 
		edgeFile = R["media"].glow,
		bgFile = R["media"].blank,
		edgeSize = R:Scale(thickness),
		insets = {left = R:Scale(thickness), right = R:Scale(thickness), top = R:Scale(thickness), bottom = R:Scale(thickness)},
	})
	shadow:SetBackdropColor( backdropr, backdropg, backdropb, backdropa )
	shadow:SetBackdropBorderColor( borderr, borderg, borderb, bordera )
	f.shadow = shadow
end

local function SetTemplate(f, t, texture)
	local r, g, b, alpha = unpack(R["media"].backdropcolor)
	f:SetBackdrop({
	  bgFile = R["media"].blank,
	})
	if t == "Transparent" then 
		r, g, b, alpha = unpack(R["media"].backdropfadecolor)
	end
	f:SetBackdropColor(r, g, b, alpha)
	f:SetBackdropBorderColor(unpack(R["media"].bordercolor))
end

local function CreateBorder(f, r, g, b, a)
	f:SetBackdrop({
		edgeFile = R["media"].blank, 
		edgeSize = R.mult,
		insets = { left = -R.mult, right = -R.mult, top = -R.mult, bottom = -R.mult }
	})
	f:SetBackdropBorderColor(r or R["media"]["bordercolor"][1], g or R["media"]["bordercolor"][2], b or R["media"]["bordercolor"][3], a or R["media"]["bordercolor"][4])
end

local function StyleButton(button, offset)
	offset = offset or 2

	if button.SetHighlightTexture and not button.hover then
		local hover = button:CreateTexture(nil, "OVERLAY")
		hover:SetTexture(1, 1, 1, 0.3)
		if offset == true then
			hover:SetAllPoints()
		else
			hover:Point("TOPLEFT", offset, -offset)
			hover:Point("BOTTOMRIGHT", -offset, offset)
		end
		button.hover = hover
		button:SetHighlightTexture(hover)
	elseif button.SetHighlightTexture and button:GetHighlightTexture() and button.hover ~= true then
		local hover = button.hover
		hover:ClearAllPoints()
		if offset == true then
			hover:SetAllPoints()
		else
			hover:Point("TOPLEFT", offset, -offset)
			hover:Point("BOTTOMRIGHT", -offset, offset)
		end
	end

	if button.SetPushedTexture and not button.pushed then
		local pushed = button:CreateTexture(nil, "OVERLAY")
		pushed:SetTexture(0.9, 0.8, 0.1, 0.3)
		if offset == true then
			pushed:SetAllPoints()
		else
			pushed:Point("TOPLEFT", offset, -offset)
			pushed:Point("BOTTOMRIGHT", -offset, offset)
		end
		button.pushed = pushed
		button:SetPushedTexture(pushed)
	elseif button.SetPushedTexture and button:GetPushedTexture() and button.pushed ~= true then
		local pushed = button.pushed
		pushed:ClearAllPoints()
		if offset == true then
			pushed:SetAllPoints()
		else
			pushed:Point("TOPLEFT", offset, -offset)
			pushed:Point("BOTTOMRIGHT", -offset, offset)
		end
	end

	if button.SetCheckedTexture and not button.checked then
		local checked = button:CreateTexture(nil, "OVERLAY")
		checked:SetTexture(23/255,132/255,209/255,0.3)
		if offset == true then
			checked:SetAllPoints()
		else
			checked:Point("TOPLEFT", offset, -offset)
			checked:Point("BOTTOMRIGHT", -offset, offset)
		end
		button.checked = checked
		button:SetCheckedTexture(checked)
	elseif button.SetCheckedTexture and button:GetCheckedTexture() and button.checked ~= true then
		local checked = button.checked
		checked:ClearAllPoints()
		if offset == true then
			checked:SetAllPoints()
		else
			checked:Point("TOPLEFT", offset, -offset)
			checked:Point("BOTTOMRIGHT", -offset, offset)
		end
	end

	if button:GetName() and _G[button:GetName().."Cooldown"] then
		local cooldown = _G[button:GetName().."Cooldown"]
		cooldown:ClearAllPoints()
		if offset == true then
			cooldown:SetAllPoints()
		else
			cooldown:Point("TOPLEFT", offset, -offset)
			cooldown:Point("BOTTOMRIGHT", -offset, offset)
		end
	elseif button:GetName() and _G[button:GetName().."Cooldown"] then
		local cooldown = _G[button:GetName().."Cooldown"]
		cooldown:ClearAllPoints()
		if offset == true then
			cooldown:SetAllPoints()
		else
			cooldown:Point("TOPLEFT", offset, -offset)
			cooldown:Point("BOTTOMRIGHT", -offset, offset)
		end
	end
end

local function CreatePanel(f, t, w, h, a1, p, a2, x, y)
	local sh = R:Scale(h)
	local sw = R:Scale(w)
	f:SetFrameLevel(1)
	f:SetHeight(sh)
	f:SetWidth(sw)
	f:SetFrameStrata("BACKGROUND")
	f:SetPoint(a1, p, a2, R:Scale(x), R:Scale(y))
	if t ~= "Transparent" then
		f:CreateShadow("Background")
	else
		f:CreateShadow(t)
	end
end

local function SetOutside(obj, anchor, xOffset, yOffset)
	xOffset = xOffset or 2
	yOffset = yOffset or 2
	anchor = anchor or obj:GetParent()

	if obj:GetPoint() then
		obj:ClearAllPoints()
	end

	obj:Point("TOPLEFT", anchor, "TOPLEFT", -xOffset, yOffset)
	obj:Point("BOTTOMRIGHT", anchor, "BOTTOMRIGHT", xOffset, -yOffset)
end

local function SetInside(obj, anchor, xOffset, yOffset)
	xOffset = xOffset or 2
	yOffset = yOffset or 2
	anchor = anchor or obj:GetParent()

	if obj:GetPoint() then
		obj:ClearAllPoints()
	end

	obj:Point("TOPLEFT", anchor, "TOPLEFT", xOffset, -yOffset)
	obj:Point("BOTTOMRIGHT", anchor, "BOTTOMRIGHT", -xOffset, yOffset)
end

local function FontTemplate(fs, font, fontSize, fontStyle)
	fs.font = font
	fs.fontSize = fontSize
	fs.fontStyle = fontStyle
	
	if not font then font = LSM:Fetch("font", R.db.media.font) end
	if not fontSize then fontSize = R.db.media.fontsize end
	
	fs:SetFont(font, fontSize, fontStyle)
	if fontStyle then
		fs:SetShadowColor(0, 0, 0, 0.2)
	else
		fs:SetShadowColor(0, 0, 0, 1)
	end
	fs:SetShadowOffset((R.mult or 1), -(R.mult or 1))
	
	R["texts"][fs] = true
end

local function Kill(object)
	if object.UnregisterAllEvents then
		object:UnregisterAllEvents()
		object:SetParent(R.HiddenFrame)
	else
		object.Show = R.dummy
	end
	object:Hide()
end

local function FadeIn(f)
	UIFrameFadeIn(f, .4, f:GetAlpha(), 1)
end

local function FadeOut(f)
	UIFrameFadeOut(f, .4, f:GetAlpha(), 0)
end

local function StripTextures(object, kill)
	for i=1, object:GetNumRegions() do
		local region = select(i, object:GetRegions())
		if region:GetObjectType() == "Texture" then
			if kill then
				region:Kill()
			else
				region:SetTexture(nil)
			end
		end
	end
end

local function CreatePulse(frame, speed, mult, alpha)
	frame.speed = speed or .05
	frame.mult = mult or 1
	frame.alpha = alpha or 1
	frame.tslu = 0
	frame:SetScript("OnUpdate", function(self, elapsed)
		self.tslu = self.tslu + elapsed
		if self.tslu > self.speed then
			self.tslu = 0
			self:SetAlpha(self.alpha)
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
	if f.shadow then
		CreatePulse(f.shadow)
	else
		CreatePulse(f.glow)
	end
end

local function StopGlow(f)
	f:SetBackdropColor(0, 0, 0, 0)
	f:SetBackdropBorderColor(0, 0, 0)
	if f.shadow then
		f.shadow:SetScript("OnUpdate", nil)
		f.shadow:SetAlpha(0)
	else
		f.glow:SetScript("OnUpdate", nil)
		f.glow:SetAlpha(0)
	end
end

local function addapi(object)
	local mt = getmetatable(object).__index
	if not object.Size then mt.Size = Size end
	if not object.Point then mt.Point = Point end
	if not object.SetTemplate then mt.SetTemplate = SetTemplate end
	if not object.CreatePanel then mt.CreatePanel = CreatePanel end
	if not object.FontTemplate then mt.FontTemplate = FontTemplate end
	if not object.CreateShadow then mt.CreateShadow = CreateShadow end
	if not object.Kill then mt.Kill = Kill end
	if not object.StyleButton then mt.StyleButton = StyleButton end
	if not object.Width then mt.Width = Width end
	if not object.Height then mt.Height = Height end
	if not object.SetOutside then mt.SetOutside = SetOutside end
	if not object.SetInside then mt.SetInside = SetInside end
	if not object.FadeIn then mt.FadeIn = FadeIn end
	if not object.FadeOut then mt.FadeOut = FadeOut end
	if not object.CreateBorder then mt.CreateBorder = CreateBorder end
	if not object.StripTextures then mt.StripTextures = StripTextures end
	if not object.CreateButton then mt.CreateButton = CreateButton end
	if not object.StartGlow then mt.StartGlow = StartGlow end
	if not object.StopGlow then mt.StopGlow = StopGlow end
end
local handled = {["Frame"] = true}
local object = CreateFrame("Frame")
addapi(object)
addapi(object:CreateTexture())
addapi(object:CreateFontString())
object = EnumerateFrames()
while object do
	if not handled[object:GetObjectType()] then
		addapi(object)
		handled[object:GetObjectType()] = true
	end

	object = EnumerateFrames(object)
end
