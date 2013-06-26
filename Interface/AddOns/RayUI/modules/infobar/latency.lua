local R, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local IF = R:GetModule("InfoBar")

local function LoadLatency()
	local stringText = "MS: %d"
	local infobar = IF:CreateInfoPanel("RayUI_InfoPanel_Latency", 80)
	infobar:SetPoint("LEFT", RayUI_InfoPanel_FPS, "RIGHT", 0, 0)
	infobar.Text:SetText(string.format(stringText, 0))

	---- SysInfo
	local sysinfo = LibStub("Tablet-2.0")
	local SysStats = {
		netTally = 0,
		lagHome = 	{cur = 0, tally = {}, avg = 0, min = 0, max = 0},
		lagWorld = 	{cur = 0, tally = {}, avg = 0, min = 0, max = 0},
	}

	local SysSection = {}
	local function SysInfo_UpdateTablet()
		resSizeExtra = 2
		local Cols, lineHeader
		wipe(SysSection)

		-- Network Category
		SysSection["network"] = {}
		SysSection["network"].cat = sysinfo:AddCategory()
		SysSection["network"].cat:AddLine("text", R:RGBToHex(0.69, 0.31, 0.31)..L["网络"], "size", 10 + resSizeExtra, "textR", 1, "textG", 1, "textB", 1)
		R:AddBlankTabLine(SysSection["network"].cat, 2)

		-- Lines
		Cols = {
			L["状态"],
			L["当前"],
			L["最大"],
			L["最小"],
			L["平均"],
		}
		SysSection["network"].lineCat = sysinfo:AddCategory("columns", #Cols)
		lineHeader = R:MakeTabletHeader(Cols, 10 + resSizeExtra, 12, {"LEFT", "RIGHT", "RIGHT", "RIGHT", "RIGHT"})
		SysSection["network"].lineCat:AddLine(lineHeader)
		R:AddBlankTabLine(SysSection["network"].lineCat, 1)

		local NetworkLines = {
			[1] = {L["本地"], "ms", "%d", SysStats.lagHome},
			[2] = {L["世界"], "ms", "%d", SysStats.lagWorld},
		}
		local line = {}
		for l = 1, #NetworkLines do
			wipe(line)
			for i = 1, #Cols do
				if i == 1 then
					line["text"] = string.format("|cffe5e5e5%s|r |cff808080(%s)|r", NetworkLines[l][1], NetworkLines[l][2])
					line["justify"] = "LEFT"
					line["size"] = 11 + resSizeExtra
					line["indentation"] = 12.5
					line["customwidth"] = 90
				elseif i == 2 then
					line["text"..i] = string.format(NetworkLines[l][3], NetworkLines[l][4].cur)
					line["justify"..i] = "RIGHT"
					line["text"..i.."R"] = 0.9
					line["text"..i.."G"] = 0.9
					line["text"..i.."B"] = 0.9
					line["indentation"..i] = 12.5
					line["customwidth"..i] = 30
				elseif i == 3 then
					line["text"..i] = string.format(NetworkLines[l][3], NetworkLines[l][4].max)
					line["justify"..i] = "RIGHT"
					line["text"..i.."R"] = 0.5
					line["text"..i.."G"] = 0.5
					line["text"..i.."B"] = 0.5
					line["indentation"..i] = 12.5
					line["customwidth"..i] = 30
				elseif i == 4 then
					line["text"..i] = string.format(NetworkLines[l][3], NetworkLines[l][4].min)
					line["justify"..i] = "RIGHT"
					line["text"..i.."R"] = 0.5
					line["text"..i.."G"] = 0.5
					line["text"..i.."B"] = 0.5
					line["indentation"..i] = 12.5
					line["customwidth"..i] = 30
				elseif i == 5 then
					line["text"..i] = string.format(NetworkLines[l][3], NetworkLines[l][4].avg)
					line["justify"..i] = "RIGHT"
					line["text"..i.."R"] = 0.5
					line["text"..i.."G"] = 0.5
					line["text"..i.."B"] = 0.5
					line["indentation"..i] = 12.5
					line["customwidth"..i] = 30
				end
			end
			SysSection["network"].lineCat:AddLine(line)
		end
	end

	local function SysInfo_OnLeave(self)
		if sysinfo:IsRegistered(self) then
			sysinfo:Close(self)
		end
	end

	local function SysInfo_OnEnter(self)
		-- Register sysinfo
		if not sysinfo:IsRegistered(self) then
			sysinfo:Register(self,
				"children", function()
					SysInfo_UpdateTablet()
				end,
				"point", "BOTTOMLEFT",
				"relativePoint", "TOPLEFT",
				"maxHeight", 500,
				"clickable", true,
				"hideWhenEmpty", true
			)
		end

		if sysinfo:IsRegistered(self) then
			-- sysinfo appearance
			sysinfo:SetColor(self, 0, 0, 0)
			sysinfo:SetTransparency(self, .65)
			sysinfo:SetFontSizePercent(self, 1)

			sysinfo:Open(self)
		end
		collectgarbage()
	end

	local function SysInfo_Update(self)
		local _, _, homecur, worldcur = GetNetStats()
		SysStats.lagHome.cur = homecur
		SysStats.lagWorld.cur = worldcur

		-- Get last 60 net updates
		local netCount = 60
		if SysStats.netTally < netCount then
			-- Tally up to 60
			SysStats.netTally = SysStats.netTally + 1

			SysStats.lagHome.tally[SysStats.netTally] = SysStats.lagHome.cur
			SysStats.lagWorld.tally[SysStats.netTally] = SysStats.lagWorld.cur

			netCount = SysStats.netTally
		else
			-- Shift our tally table down by 1
			for i = 1, netCount - 1 do
				SysStats.lagHome.tally[i] = SysStats.lagHome.tally[i + 1]
				SysStats.lagWorld.tally[i] = SysStats.lagWorld.tally[i + 1]
			end
			-- Store new values
			SysStats.lagHome.tally[netCount] = SysStats.lagHome.cur
			SysStats.lagWorld.tally[netCount] = SysStats.lagWorld.cur
		end

		-- Get Average/Min/Max
		local minLagHome, maxLagHome, totalLagHome = nil, 0, 0
		local minLagWorld, maxLagWorld, totalLagWorld = nil, 0, 0

		for i = 1, netCount do
			totalLagHome = totalLagHome + SysStats.lagHome.tally[i]
			if not minLagHome then minLagHome = SysStats.lagHome.tally[i] else minLagHome = min(minLagHome, SysStats.lagHome.tally[i]) end
			maxLagHome = max(maxLagHome, SysStats.lagHome.tally[i])

			totalLagWorld = totalLagWorld + SysStats.lagWorld.tally[i]
			if not minLagWorld then minLagWorld = SysStats.lagWorld.tally[i] else minLagWorld = min(minLagWorld, SysStats.lagWorld.tally[i]) end
			maxLagWorld = max(maxLagWorld, SysStats.lagWorld.tally[i])
		end

		SysStats.lagHome.avg = floor((totalLagHome / netCount) + 0.5)
		SysStats.lagHome.min = minLagHome
		SysStats.lagHome.max = maxLagHome

		SysStats.lagWorld.avg = floor((totalLagWorld / netCount) + 0.5)
		SysStats.lagWorld.min = minLagWorld
		SysStats.lagWorld.max = maxLagWorld

		-- Tablet
		if sysinfo:IsRegistered(self) then
			if Tablet20Frame:IsShown() then
				sysinfo:Refresh(self)
			end
		end
	end

	infobar:SetScript("OnUpdate", function(self, elapsed)
		self.LastUpdate = (self.LastUpdate or 0) - elapsed
		self.LastUpdate2 = (self.LastUpdate2 or 0) - elapsed

		if self.LastUpdate < 0 then
			local value = (select(3, GetNetStats()))
			local max = 1000
			infobar.Text:SetText(string.format(stringText, value))
			local r, g, b = R:ColorGradient(value/1000, IF.InfoBarStatusColor[3][1], IF.InfoBarStatusColor[3][2], IF.InfoBarStatusColor[3][3], 
																			IF.InfoBarStatusColor[2][1], IF.InfoBarStatusColor[2][2], IF.InfoBarStatusColor[2][3],
																			IF.InfoBarStatusColor[1][1], IF.InfoBarStatusColor[1][2], IF.InfoBarStatusColor[1][3])
			infobar.Square:SetVertexColor(r, g, b)
			self.LastUpdate = 1
		end
		if self.LastUpdate2 < 0 then
			SysInfo_Update(self)
			self.LastUpdate2 = 5
		end
	end)

	infobar:HookScript("OnEnter", SysInfo_OnEnter)
	infobar:HookScript("OnLeave", SysInfo_OnLeave)
end

IF:RegisterInfoText("Latency", LoadLatency)