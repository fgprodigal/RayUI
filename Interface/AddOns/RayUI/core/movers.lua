--Create a Mover frame by Elv
local R, L, P = unpack(select(2, ...)) --Inport: Engine, Locales, ProfileDB
local AddOnName = ...
local AceConfig = LibStub("AceConfigDialog-3.0")

R.CreatedMovers = {}

local print = function(...)
	return print('|cff7aa6d6Ray|r|cffff0000U|r|cff7aa6d6I|r: ', ...)
end

local function CreateMover(parent, name, text, overlay, postdrag)
	if not parent then return end --If for some reason the parent isnt loaded yet
	local S = R:GetModule("Skins")

	if overlay == nil then overlay = true end

	local p, p2, p3, p4, p5 = parent:GetPoint()

	R.Movers = R.db["movers"]

	if R.Movers == {} then R.Movers = nil end
	if R.Movers and R.Movers[name] == {} or (R.Movers and R.Movers[name] and R.Movers[name]["moved"] == false) then 
		R.Movers[name] = nil
	end

	local f = CreateFrame("Button", name, UIParent)
	f:SetFrameLevel(parent:GetFrameLevel() + 1)
	f:SetWidth(parent:GetWidth())
	f:SetHeight(parent:GetHeight())

	if overlay == true then
		f:SetFrameStrata("DIALOG")
	else
		f:SetFrameStrata("BACKGROUND")
	end
	if R["Movers"] and R["Movers"][name] then
		f:SetPoint(R["Movers"][name]["p"], UIParent, R["Movers"][name]["p2"], R["Movers"][name]["p3"], R["Movers"][name]["p4"])
	else
		f:SetPoint(p, p2, p3, p4, p5)
	end
	S:Reskin(f)
	S:CreateBD(f)
	f.SetBackdropColor = R.dummy
	f.SetBackdropBorderColor = R.dummy
	f:RegisterForDrag("LeftButton", "RightButton")
	f:SetScript("OnDragStart", function(self) 
		if InCombatLockdown() then print(ERR_NOT_IN_COMBAT) return end
		self:StartMoving() 
	end)

	f:SetScript("OnDragStop", function(self) 
		if InCombatLockdown() then print(ERR_NOT_IN_COMBAT) return end
		self:StopMovingOrSizing()

		if not R.db["movers"] then R.db["movers"] = {} end

		R.Movers = R.db["movers"]

		R.Movers[name] = {}
		local p, _, p2, p3, p4 = self:GetPoint()
		R.Movers[name]["p"] = p
		R.Movers[name]["p2"] = p2
		R.Movers[name]["p3"] = p3
		R.Movers[name]["p4"] = p4

		if postdrag ~= nil and type(postdrag) == 'function' then
			postdrag(self)
		end

		self:SetUserPlaced(false)
	end)

	parent:ClearAllPoints()
	parent:SetPoint(p3, f, p3, 0, 0)
	parent.ClearAllPoints = function() return end
	parent.SetAllPoints = function() return end
	parent.SetPoint = function() return end

	local fs = f:CreateFontString(nil, "OVERLAY")
	fs:SetFont(R["media"].font, R["media"].fontsize)
	fs:SetShadowOffset(R.mult*1.2, -R.mult*1.2)
	fs:SetJustifyH("CENTER")
	fs:SetPoint("CENTER")
	fs:SetText(text or name)
	fs:SetTextColor(1, 1, 1)
	f:SetFontString(fs)
	f.text = fs

	f:HookScript("OnEnter", function(self) 
		self.text:SetTextColor(self.glow:GetBackdropBorderColor())
	end)
	f:HookScript("OnLeave", function(self)
		self.text:SetTextColor(1, 1, 1)
	end)

	f:SetMovable(true)
	f:Hide()

	if postdrag ~= nil and type(postdrag) == 'function' then
		f:RegisterEvent("PLAYER_ENTERING_WORLD")
		f:SetScript("OnEvent", function(self, event)
			postdrag(f)
			self:UnregisterAllEvents()
		end)
	end
end

function R:CreateMover(parent, name, text, overlay, postdrag)
	local p, p2, p3, p4, p5 = parent:GetPoint()

	if R.CreatedMovers[name] == nil then 
		R.CreatedMovers[name] = {}
		R.CreatedMovers[name]["parent"] = parent
		R.CreatedMovers[name]["text"] = text
		R.CreatedMovers[name]["overlay"] = overlay
		R.CreatedMovers[name]["postdrag"] = postdrag
		R.CreatedMovers[name]["p"] = p
		R.CreatedMovers[name]["p2"] = p2 or "UIParent"
		R.CreatedMovers[name]["p3"] = p3
		R.CreatedMovers[name]["p4"] = p4
		R.CreatedMovers[name]["p5"] = p5
	end

	CreateMover(parent, name, text, overlay, postdrag)
end

function R:ToggleMovers()
	if InCombatLockdown() then print(ERR_NOT_IN_COMBAT) return end

	if RayUIMoverPopupWindow:IsShown() then
		RayUIMoverPopupWindow:Hide()
	else
		RayUIMoverPopupWindow:Show()
	end

	if RayUF or oUF then
		R:MoveoUF()
	end

	for name, _ in pairs(R.CreatedMovers) do
		if _G[name]:IsShown() then
			_G[name]:Hide()
		else
			_G[name]:Show()
		end
	end
end

function R:ResetMovers(arg)
	if InCombatLockdown() then print(ERR_NOT_IN_COMBAT) return end
	if arg == "" then
		for name, _ in pairs(R.CreatedMovers) do
			local n = _G[name]
			_G[name]:ClearAllPoints()
			_G[name]:SetPoint(R.CreatedMovers[name]["p"], R.CreatedMovers[name]["p2"], R.CreatedMovers[name]["p3"], R.CreatedMovers[name]["p4"], R.CreatedMovers[name]["p5"])


			R.Movers = nil
			R.db["movers"] = R.Movers

			for key, value in pairs(R.CreatedMovers[name]) do
				if key == "postdrag" and type(value) == 'function' then
					value(n)
				end
			end
		end
	else
		for name, _ in pairs(R.CreatedMovers) do
			for key, value in pairs(R.CreatedMovers[name]) do
				local mover
				if key == "text" then
					if arg == value then 
						_G[name]:ClearAllPoints()
						_G[name]:SetPoint(R.CreatedMovers[name]["p"], R.CreatedMovers[name]["p2"], R.CreatedMovers[name]["p3"], R.CreatedMovers[name]["p4"], R.CreatedMovers[name]["p5"])

						if R.Movers then
							R.Movers[name] = nil
						end
						R.db["movers"] = R.Movers

						if R.CreatedMovers[name]["postdrag"] ~= nil and type(R.CreatedMovers[name]["postdrag"]) == 'function' then
							R.CreatedMovers[name]["postdrag"](_G[name])
						end
					end
				end
			end
		end
	end
end

local function CreatePopup()
	local S = R:GetModule("Skins")
	local f = CreateFrame("Frame", "RayUIMoverPopupWindow", UIParent)
	f:SetFrameStrata("DIALOG")
	f:SetToplevel(true)
	f:EnableMouse(true)
	f:SetClampedToScreen(true)
	f:SetWidth(360)
	f:SetHeight(110)
	f:SetPoint("TOP", 0, -50)
	f:Hide()
	S:SetBD(f)
	f:SetMovable(true)
	f:RegisterForDrag("LeftButton")
	f:SetScript("OnDragStart", function(self) self:StartMoving() self:SetUserPlaced(false) end)
	f:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
	f:SetScript("OnShow", function() PlaySound("igMainMenuOption") end)
	f:SetScript("OnHide", function() PlaySound("gsTitleOptionExit") end)

	local title = f:CreateFontString(nil, "OVERLAY")
	title:SetFontObject(GameFontNormal)
	title:SetShadowOffset(R.mult, -R.mult)
	title:SetShadowColor(0, 0, 0)
	title:SetPoint("TOP", f, "TOP", 0, -10)
	title:SetJustifyH("CENTER")
	title:SetText("RayUI")

	local desc = f:CreateFontString(nil, "ARTWORK")
	desc:SetFontObject("GameFontHighlight")
	desc:SetJustifyV("TOP")
	desc:SetJustifyH("LEFT")
	desc:SetPoint("TOPLEFT", 18, -32)
	desc:SetPoint("BOTTOMRIGHT", -18, 48)
	desc:SetText(L["锚点已解锁，拖动锚点移动位置，完成后点击锁定按钮。"])

	local lock = CreateFrame("Button", "RayUILock", f, "OptionsButtonTemplate")
	_G[lock:GetName() .. "Text"]:SetText(L["锁定"])

	lock:SetScript("OnClick", function(self)
		R:ToggleMovers()
		AceConfig["Open"](AceConfig,"RayUI") 
	end)

	lock:SetPoint("BOTTOMRIGHT", -14, 14)
	S:Reskin(lock)

	f:RegisterEvent('PLAYER_REGEN_DISABLED')
	f:SetScript('OnEvent', function(self)
		if self:IsShown() then
			self:Hide()
		end
	end)
end

function R:ADDON_LOADED(event, addon)
	if addon ~= AddOnName then return end
	for name, _ in pairs(R.CreatedMovers) do
		local n = name
		local p, t, o, pd
		for key, value in pairs(R.CreatedMovers[name]) do
			if key == "parent" then
				p = value
			elseif key == "text" then
				t = value
			elseif key == "overlay" then
				o = value
			elseif key == "postdrag" then
				pd = value
			end
		end
		CreateMover(p, n, t, o, pd)
	end
	CreatePopup()
	self:UnregisterEvent("ADDON_LOADED")
end

function R:PLAYER_REGEN_DISABLED()
	local err = false
	for name, _ in pairs(R.CreatedMovers) do
		if _G[name]:IsShown() then
			err = true
			_G[name]:Hide()
			self:Print(name)
		end
	end
	if err == true then
		R:Print(ERR_NOT_IN_COMBAT)
	end
end

R:RegisterEvent("ADDON_LOADED")
R:RegisterEvent("PLAYER_REGEN_DISABLED")