--[[
Author: Affli@RU-Howling Fjord, 
Modified: Elv
All rights reserved.
]]--
local R, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local S = R:GetModule("Skins")

local function SkinBigWigs()
	if not S.db.acp or not IsAddOnLoaded("BigWigs") then return end

	local buttonsize = 19

	-- init some tables to store backgrounds
	local freebg = {}

	-- styling functions
	local createbg = function()
		local bg = CreateFrame("Frame")
		bg:CreateShadow("Background")
		return bg
	end

	local function freestyle(bar)

		-- reparent and hide bar background
		local bg = bar:Get("bigwigs:rayui:barbg")
		if bg then
			bg:ClearAllPoints()
			bg:SetParent(UIParent)
			bg:Hide()
			freebg[#freebg + 1] = bg
		end

		-- reparent and hide icon background
		local ibg = bar:Get("bigwigs:rayui:iconbg")
		if ibg then
			ibg:ClearAllPoints()
			ibg:SetParent(UIParent)
			ibg:Hide()
			freebg[#freebg + 1] = ibg
		end

		-- replace dummies with original method functions
		bar.candyBarBar.SetPoint=bar.candyBarBar.OldSetPoint
		bar.candyBarIconFrame.SetWidth=bar.candyBarIconFrame.OldSetWidth
		bar.SetScale=bar.OldSetScale

		--Reset Positions
		--Icon
		bar.candyBarIconFrame:ClearAllPoints()
		bar.candyBarIconFrame:SetPoint("TOPLEFT")
		bar.candyBarIconFrame:SetPoint("BOTTOMLEFT")
		bar.candyBarIconFrame:SetTexCoord(0.07, 0.93, 0.07, 0.93)

		--Status Bar
		bar.candyBarBar:ClearAllPoints()
		bar.candyBarBar:SetPoint("TOPRIGHT")
		bar.candyBarBar:SetPoint("BOTTOMRIGHT")

		--BG
		bar.candyBarBackground:SetAllPoints()

		--Duration
		bar.candyBarDuration:ClearAllPoints()
		bar.candyBarDuration:SetPoint("RIGHT", bar.candyBarBar, "RIGHT", -2, 0)

		--Name
		bar.candyBarLabel:ClearAllPoints()
		bar.candyBarLabel:SetPoint("LEFT", bar.candyBarBar, "LEFT", 2, 0)
		bar.candyBarLabel:SetPoint("RIGHT", bar.candyBarBar, "RIGHT", -2, 0)
	end

	local applystyle = function(bar)

		-- general bar settings
		bar.OldHeight = bar:GetHeight()
		bar.OldScale = bar:GetScale()
		bar.OldSetScale=bar.SetScale
		bar.SetScale=R.dummy
		bar:Height(buttonsize)
		bar:SetScale(1)

		-- create or reparent and use bar background
		local bg = nil
		if #freebg > 0 then
			bg = table.remove(freebg)
		else
			bg = createbg()
		end

		bg:SetParent(bar)
		bg:ClearAllPoints()
		bg:Point("TOPLEFT", bar, "TOPLEFT", -3, 3)
		bg:Point("BOTTOMRIGHT", bar, "BOTTOMRIGHT", 3, -3)
		bg:SetFrameStrata("BACKGROUND")
		bg:Show()
		bar:Set("bigwigs:rayui:barbg", bg)

		-- create or reparent and use icon background
		local ibg = nil
		if bar.candyBarIconFrame:GetTexture() then
			if #freebg > 0 then
				ibg = table.remove(freebg)
			else
				ibg = createbg()
			end
			ibg:SetParent(bar)
			ibg:ClearAllPoints()
			ibg:Point("TOPLEFT", bar.candyBarIconFrame, "TOPLEFT", -3, 3)
			ibg:Point("BOTTOMRIGHT", bar.candyBarIconFrame, "BOTTOMRIGHT", 3, -3)
			ibg:SetFrameStrata("BACKGROUND")
			ibg:Show()
			bar:Set("bigwigs:rayui:iconbg", ibg)
		end

		-- setup timer and bar name fonts and positions
		bar.candyBarLabel:SetFont(R["media"].font, 12, "OUTLINE")
		bar.candyBarLabel:SetShadowColor(0, 0, 0, 0)
		bar.candyBarLabel:SetJustifyH("LEFT")
		bar.candyBarLabel:ClearAllPoints()
		bar.candyBarLabel:Point("LEFT", bar, "LEFT", 4, 0)

		bar.candyBarDuration:SetFont(R["media"].font, 12, "OUTLINE")
		bar.candyBarDuration:SetShadowColor(0, 0, 0, 0)
		bar.candyBarDuration:SetJustifyH("RIGHT")
		bar.candyBarDuration:ClearAllPoints()
		bar.candyBarDuration:Point("RIGHT", bar, "RIGHT", -4, 0)

		-- setup bar positions and look
		bar.candyBarBar.OldPoint, bar.candyBarBar.Anchor, bar.candyBarBar.OldPoint2, bar.candyBarBar.XPoint, bar.candyBarBar.YPoint  = bar.candyBarBar:GetPoint()
		bar.candyBarBar:ClearAllPoints()
		bar.candyBarBar:SetAllPoints(bar)
		bar.candyBarBar.OldSetPoint = bar.candyBarBar.SetPoint
		bar.candyBarBar.SetPoint=R.dummy
		bar.candyBarBar:SetStatusBarTexture(R["media"].normal)
		bar.candyBarBackground:SetTexture(unpack(R["media"].backdropcolor))

		-- setup icon positions and other things
		bar.candyBarIconFrame.OldPoint, bar.candyBarIconFrame.Anchor, bar.candyBarIconFrame.OldPoint2, bar.candyBarIconFrame.XPoint, bar.candyBarIconFrame.YPoint  = bar.candyBarIconFrame:GetPoint()
		bar.candyBarIconFrame.OldWidth = bar.candyBarIconFrame:GetWidth()
		bar.candyBarIconFrame.OldHeight = bar.candyBarIconFrame:GetHeight()
		bar.candyBarIconFrame.OldSetWidth = bar.candyBarIconFrame.SetWidth
		bar.candyBarIconFrame.SetWidth=R.dummy
		bar.candyBarIconFrame:ClearAllPoints()
		bar.candyBarIconFrame:Point("BOTTOMRIGHT", bar, "BOTTOMLEFT", -5, 0)
		bar.candyBarIconFrame:SetSize(buttonsize, buttonsize)
		bar.candyBarIconFrame:SetTexCoord(0.08, 0.92, 0.08, 0.92)
	end


	local function RegisterStyle()
		if not BigWigs then return end
		local bars = BigWigs:GetPlugin("Bars", true)
		local prox = BigWigs:GetPlugin("Proximity", true)
		if bars then
			bars:RegisterBarStyle("RayUI", {
				apiVersion = 1,
				version = 1,
				GetSpacing = function(bar) return 7 end,
				ApplyStyle = applystyle,
				BarStopped = freestyle,
				GetStyleName = function() return "RayUI" end,
			})
		end
		if prox and bars.db.profile.barStyle == "RayUI" then
			hooksecurefunc(BigWigs.pluginCore.modules.Proximity, "RestyleWindow", function()
				BigWigsProximityAnchor:CreateShadow("Background")
			end)
		end
	end

	local function PositionBWAnchor()
		if not BigWigsAnchor then return end
		BigWigsAnchor:ClearAllPoints()
		BigWigsAnchor:Point("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -5, 8)
	end


	local f = CreateFrame("Frame")
	f:RegisterEvent("ADDON_LOADED")
	f:SetScript("OnEvent", function(self, event, addon)
		if event == "ADDON_LOADED" and addon == "BigWigs_Plugins" then
			RegisterStyle()
			local profile = BigWigs3DB["profileKeys"][R.myname.." - "..R.myrealm]
			local path = BigWigs3DB["namespaces"]["BigWigs_Plugins_Bars"]["profiles"][profile]
			path.texture = "RayUI Normal"
			path.barStyle = "RayUI"
			path.font = "RayUI Font"

			local path = BigWigs3DB["namespaces"]["BigWigs_Plugins_Messages"]["profiles"][profile]
			path.font = "RayUI Font"

			local path = BigWigs3DB["namespaces"]["BigWigs_Plugins_Proximity"]["profiles"][profile]
			path.font = "RayUI Font"

			f:UnregisterEvent("ADDON_LOADED")
		elseif event == "PLAYER_ENTERING_WORLD" then
			LoadAddOn("BigWigs")
			LoadAddOn("BigWigs_Core")
			LoadAddOn("BigWigs_Plugins")
			LoadAddOn("BigWigs_Options")
			if not BigWigs then return end
			BigWigs:Enable()
			BigWigsOptions:SendMessage("BigWigs_StartConfigureMode", true)
			BigWigsOptions:SendMessage("BigWigs_StopConfigureMode")
			-- PositionBWAnchor()
		elseif event == "PLAYER_REGEN_DISABLED" then
			-- PositionBWAnchor()
		elseif event == "PLAYER_REGEN_ENABLED" then
			-- PositionBWAnchor()
		end
	end)
end

S:RegisterSkin("BigWigs", SkinBigWigs)