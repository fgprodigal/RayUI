local R, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
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
		-- TimerBar.Resize(f, w, h)

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
		f.timeText:Point("RIGHT", -5, 1)

		f.spellText:ClearAllPoints()
		f.spellText:Point("LEFT", f.bar, 0, 1)
		f.spellText:Point("RIGHT", f.bar, 0, 1)
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

	local defaultColor = {1, 1, 0}
	local visualstackwidth  = 10
	local visualstacksmax  = 5
	function TimerBar.SetCount(self,amount)
		if not amount then return end
		local stacks = self.visualstacks
		if not stacks then
			stacks = CreateFrame("FRAME", nil, self.bar)
			S:CreateBD(stacks, 1)
			stacks:Height(visualstackwidth+2)
			stacks:Point("LEFT", 2, 0)
			stacks.tex = {}
			self.visualstacks = stacks
		end
		if amount > 1 and amount <= visualstacksmax then
			local width = (visualstackwidth*amount)+(amount-1)+2
			stacks:Width(width)
			stacks:Show()
			for i = 1, amount do
				if not stacks.tex[i] then
					local tex = stacks:CreateTexture(nil, "ARTWORK")
					tex:SetTexture(R["media"].normal)
					tex:Point("TOP", 0, -1)
					tex:Point("BOTTOM", 0, 1)
					if i == 1 then
						tex:Point("RIGHT", -1, 0)
					else
						tex:Point("RIGHT", stacks.tex[i-1], "LEFT", -1, 0)
					end
					tex:SetWidth(visualstackwidth)
					stacks.tex[i] = tex
				end
				local r,g,b = unpack(self.opts.stackcolor and self.opts.stackcolor[i] or defaultColor)
				stacks.tex[i]:SetVertexColor(r,g,b)
				stacks.tex[i]:Show()
			end
			-- Hide stack textures that are not needed
			for i = amount+1, visualstacksmax do
				if not stacks.tex[i] then break end
				stacks.tex[i]:Hide()
			end
		else
			stacks:Hide()
		end
		-- Handle text
		if amount < 1 or amount < visualstacksmax then
			self.stacktext:Hide()
		else
			self.stacktext:SetText(amount)
			self.stacktext:Show()
		end
	end

	NRunDB_Global = NRunDB_Global or {}
	NRunDB_Global.localNames = true
end

S:RegisterSkin("NugRunning", SkinNugRunning)