local R, L, P = unpack(select(2, ...)) --Inport: Engine, Locales, ProfileDB
local M = R:GetModule("Misc")

local function LoadFunc()
	local RayUIWatchFrame = CreateFrame("Frame", nil, UIParent)
	local RayUIWatchFrameHolder = CreateFrame("Frame", nil, UIParent)
	RayUIWatchFrameHolder:SetWidth(250)
	RayUIWatchFrameHolder:SetHeight(22)
	RayUIWatchFrameHolder:SetPoint("RIGHT", UIParent, "RIGHT", -80, 290)
	R:CreateMover(RayUIWatchFrameHolder, "WatchFrameMover", L["任务追踪锚点"], true)

	local function init()
		RayUIWatchFrame:UnregisterEvent("PLAYER_ENTERING_WORLD")
		RayUIWatchFrame:RegisterEvent("CVAR_UPDATE")
		RayUIWatchFrame:SetScript("OnEvent", function(_,_,cvar,value)
			RayUIWatchFrame:SetWidth(250)
		end)
		RayUIWatchFrame:ClearAllPoints()
		RayUIWatchFrame:SetPoint("TOP", RayUIWatchFrameHolder, "TOP", 0, 5)
	end

	local function setup()
		local screenheight = GetScreenHeight()
		RayUIWatchFrame:SetHeight(screenheight / 1.6)

		RayUIWatchFrame:SetWidth(250)

		WatchFrame:SetParent(RayUIWatchFrame)
		WatchFrame:SetClampedToScreen(false)
		WatchFrame:ClearAllPoints()
		WatchFrame.ClearAllPoints = function() end
		WatchFrame:SetPoint("TOPLEFT", 32,-2.5)
		WatchFrame:SetPoint("BOTTOMRIGHT", 4,0)
		WatchFrame.SetPoint = R.dummy

		-- WatchFrameTitle:SetParent(RayUIWatchFrame)
		WatchFrameCollapseExpandButton:SetParent(RayUIWatchFrame)
		WatchFrameCollapseExpandButton.Disable = R.dummy

		-- WatchFrameTitle:Hide()
		-- WatchFrameTitle.Show = R.dummy
	end

	local f = CreateFrame("Frame")
	f:Hide()
	f.elapsed = 0
	f:SetScript("OnUpdate", function(self, elapsed)
		f.elapsed = f.elapsed + elapsed
		if f.elapsed > .5 then
			setup()
			f:Hide()
		end
	end)

	RayUIWatchFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
	RayUIWatchFrame:SetScript("OnEvent", function()
		SetCVar("watchFrameWidth", 0)
		InterfaceOptionsObjectivesPanelWatchFrameWidth:Kill()
		init()
		f:Show()
	end)

	--进出副本自动收放任务追踪
	local autocollapse = CreateFrame("Frame")
	autocollapse:RegisterEvent("ZONE_CHANGED_NEW_AREA")
	autocollapse:RegisterEvent("PLAYER_ENTERING_WORLD")
	autocollapse:SetScript("OnEvent", function(self)
	   if IsInInstance() then
		  WatchFrame.userCollapsed = true
		  WatchFrame_Collapse(WatchFrame)
	   else
		  WatchFrame.userCollapsed = nil
		  WatchFrame_Expand(WatchFrame)
	   end
	end)

	hooksecurefunc("WatchFrameItem_OnLoad", function(self)
		local icon = _G[self:GetName().."IconTexture"]
		local hotkey = _G[self:GetName().."HotKey"]
		_G[self:GetName().."NormalTexture"]:SetTexture(nil)
		icon:SetTexCoord(.08, .92, .08, .92)
		self:CreateShadow("Background")
		self:StyleButton(true)
		if hotkey:GetText() == _G['RANGE_INDICATOR'] then
			hotkey:SetText('')
		end
	end)

	hooksecurefunc("WatchFrameItem_OnUpdate", function(self)
		local hotkey = _G[self:GetName().."HotKey"]
		local icon = _G[self:GetName().."IconTexture"]
		local valid = IsQuestLogSpecialItemInRange(self:GetID());
		if ( valid == 0 ) then
			icon:SetVertexColor(1.0, 0.1, 0.1)
		else
			icon:SetVertexColor(1, 1, 1)
		end
	end)
end

M:RegisterMiscModule("WatchFrame", LoadFunc)