local R, L, P = unpack(select(2, ...)) --Inport: Engine, Locales, ProfileDB
local S = R:GetModule("Skins")

local function SkinNugRunning()
	if not S.db.nugrunning then return end
	local NugRunning = NugRunning
	local TimerBar = NugRunning and NugRunning.TimerBar

	local _ConstructTimerBar = NugRunning.ConstructTimerBar
	function NugRunning.ConstructTimerBar(w, h)
		local f = _ConstructTimerBar(w, h)

		f:SetBackdrop(nil)

		local ic = f.icon:GetParent()
		ic:CreateShadow("Background")

		f.bar.bg:Hide()
		f.bar:CreateShadow("Background")

		f.bar:SetStatusBarTexture(R["media"].normal)
		f.bar:GetStatusBarTexture():SetDrawLayer("ARTWORK")

		-- Fonts
		do
			f.timeText:SetFont(R["media"].font, R["media"].fontsize, "OUTLINE")
			f.spellText:SetFont(R["media"].font, R["media"].fontsize, "OUTLINE")
			f.spellText:SetAlpha(1)
			f.stacktext:SetFont(R["media"].font, R["media"].fontsize, "OUTLINE")
		end

		-- Force correct position of bar/icon
		TimerBar.Resize(f, w, h)

		return f
	end

	local _Resize = TimerBar.Resize
	function TimerBar.Resize(f, w, h)
		_Resize(f, w, h)

		-- Icon auto scales width :D
		local ic = f.icon:GetParent()
		ic:ClearAllPoints()
		ic:Point("TOPRIGHT", f, "TOPLEFT", -4, 0)
		ic:Point("BOTTOMRIGHT", f, "BOTTOMLEFT", -4, 0)

		f.bar:ClearAllPoints()
		f.bar:SetAllPoints(f)
		f.bar:Point("BOTTOMRIGHT", f, 0, 0)
		f.bar:Point("LEFT", ic, "RIGHT", 0, 0)

		f.timeText:SetJustifyH("RIGHT")
		f.timeText:ClearAllPoints()
		f.timeText:Point("RIGHT", -5, 0)

		f.spellText:ClearAllPoints()
		f.spellText:Point("LEFT", f.bar)
		f.spellText:Point("RIGHT", f.bar)
		f.spellText:SetWidth(f.bar:GetWidth())
	end

	local day, hour, minute = 86400, 3600, 60
	local color = "|cffff0000"
	local decimals = 5

	local floor = math.floor
	local function round(num, idp)
		local mult = 10^(idp or 0)
		return floor(num * mult + 0.5) / mult
	end

	function TimerBar.Update(f, s)
		f.bar:SetValue(s + f.startTime)
		local time = f.timeText
		if s >= day then
			time:SetFormattedText("%d%sd|r", round(s / day), color)
		elseif s >= hour then
			time:SetFormattedText("%d%sh|r", round(s / hour), color)
		elseif s >= minute * 1 then
			time:SetFormattedText("%d%sm|r", round(s / minute), color)
		elseif s >= decimals then
			time:SetFormattedText("%d", s)
		elseif s >= 0 then
			time:SetFormattedText("%.1f", s)
		else
			time:SetText(0)
		end
	end

	NRunDB_Global.localNames = true
end

S:RegisterSkin("NugRunning", SkinNugRunning)