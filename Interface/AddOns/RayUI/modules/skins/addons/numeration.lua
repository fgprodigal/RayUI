local R, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local S = R:GetModule("Skins")

local function SkinNumeration()
	if not S.db.numeration then return end
	local Numeration = Numeration
	local window = Numeration.window

	local _OnInitialize = window.OnInitialize
	function window:OnInitialize()
		_OnInitialize(self)
		self:Height(3+Numeration.windowsettings.titleheight+Numeration.windowsettings.maxlines*(Numeration.windowsettings.lineheight+R:Scale(Numeration.windowsettings.linegap)) - R:Scale(Numeration.windowsettings.linegap))
		self:SetBackdrop(nil)
		self:CreateShadow("Background")
		-- self.title:Hide()
		self.titletext:SetJustifyH("CENTER")
		self.titletext:SetPoint("RIGHT", self.reset, "LEFT", -4, 0)

		self.reset:SetBackdrop({
			bgFile = R["media"].blank,
			edgeFile = "", tile = true, tileSize = 16, edgeSize = 0,
			insets = { left = 0, right = 0, top = 0, bottom = 0 }
		})
		self.reset:SetBackdropColor(0, 0, 0, 0)
		self.reset.text:Hide()
		self.reset.tex = self.reset:CreateTexture(nil, "ARTWORK")
		self.reset.tex:Size(8, 8)
		self.reset.tex:SetPoint("CENTER")
		self.reset.tex:SetTexture("Interface\\AddOns\\RayUI\\media\\arrow-right-active")

		self.segment:SetBackdrop({
			bgFile = R["media"].blank,
			edgeFile = "", tile = true, tileSize = 16, edgeSize = 0,
			insets = { left = 0, right = 0, top = 0, bottom = 0 }
		})
		self.segment:SetBackdropColor(0, 0, 0, 0)
	end

	local _GetLine = window.GetLine
	function window:GetLine(id)
		local f = _GetLine(self, id)
		f:SetWidth(Numeration.windowsettings.width)

		if id == 0 then
			f:ClearAllPoints()
			f:SetPoint("TOPRIGHT", self.reset, "BOTTOMRIGHT", 1, -1)
		else
			local _, anchorTo = f:GetPoint()
			f:Point("TOPRIGHT", anchorTo, "BOTTOMRIGHT", 0, -Numeration.windowsettings.linegap)
		end

		function f.SetIcon(f, icon)
			if icon then
				f:SetWidth(Numeration.windowsettings.width-Numeration.windowsettings.lineheight)
				f.icon:SetTexture(icon)
				f.icon:Show()
			else
				f:SetWidth(Numeration.windowsettings.width)
				f.icon:Hide()
			end
		end

        f:SetScript("OnEnter", function(self)
            if not self.spellId then return end
            GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
            GameTooltip:SetHyperlink("spell:"..self.spellId)
        end)

		return f
	end

	if Numeration.coresettings.shortnumbers then
		local _InitOptions = Numeration.InitOptions
		function Numeration:InitOptions()
			_InitOptions(self)
			function self.ModNumber(self, num)
				if num >= 1e6 then
					return ("%.1fm"):format(num / 1e6)
				else
					return ("%i"):format(num)
				end
			end
		end
	end

	Numeration.windowsettings.pos = { "BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -15, 30 }
	Numeration.windowsettings.width = 250
	Numeration.windowsettings.maxlines = 7
	Numeration.windowsettings.backgroundalpha = 0
	Numeration.windowsettings.titlealpha = 0
	Numeration.windowsettings.buttonhighlightcolor = {1, 1, 1}
	Numeration.windowsettings.linetexture = R["media"].normal
	Numeration.windowsettings.linefont = R["media"].font
	Numeration.windowsettings.titlefont = R["media"].font
	Numeration.windowsettings.linefontsize = R["media"].fontsize
	Numeration.windowsettings.linegap = 2
	Numeration.windowsettings.fontshadow = false
	Numeration.windowsettings.linefontstyle = "OUTLINE"
	Numeration.windowsettings.titlefontstyle = "OUTLINE"
	Numeration.windowsettings.titlefontcolor = {1, .82, 0}
	Numeration.windowsettings.lineheight = 16
end

S:RegisterSkin("Numeration", SkinNumeration)
