local R, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local IF = R:GetModule("InfoBar")

local function LoadFPS()
	local stringText = "FPS: %d"
	local infobar = IF:CreateInfoPanel("RayUI_InfoPanel_FPS", 70)
	infobar:SetPoint("TOPLEFT", 10, 0)
	infobar.Text:SetText(string.format(stringText, 0))

	---- SysInfo
	local sysinfo = LibStub("Tablet-2.0")
	local SysStats = {
		fpsTally = -5,
		fps = 		{cur = 0, tally = {}, avg = 0, min = 0, max = 0},
	}

	local SysSection = {}
	local function SysInfo_UpdateTablet()
		resSizeExtra = 2
		local Cols, lineHeader
		wipe(SysSection)

		-- Computer Category
		SysSection["computer"] = {}
		SysSection["computer"].cat = sysinfo:AddCategory()
		SysSection["computer"].cat:AddLine("text", R:RGBToHex(0.69, 0.31, 0.31)..L["电脑"], "size", 10 + resSizeExtra, "textR", 1, "textG", 1, "textB", 1)
		R:AddBlankTabLine(SysSection["computer"].cat, 2)

		-- Lines
		Cols = {
			L["状态"],
			L["当前"],
			L["最大"],
			L["最小"],
			L["平均"],
		}
		SysSection["computer"].lineCat = sysinfo:AddCategory("columns", #Cols)
		lineHeader = R:MakeTabletHeader(Cols, 10 + resSizeExtra, 12, {"LEFT", "RIGHT", "RIGHT", "RIGHT", "RIGHT"})
		SysSection["computer"].lineCat:AddLine(lineHeader)
		R:AddBlankTabLine(SysSection["computer"].lineCat, 1)

		local ComputerLines = {
			[1] = {L["FPS"], SysStats.fps},
		}
		local line = {}
		for l = 1, #ComputerLines do
			for i = 1, #Cols do
				if i == 1 then
					line["text"] = string.format("|cffe5e5e5%s|r", ComputerLines[l][1])
					line["justify"] = "LEFT"
					line["size"] = 11 + resSizeExtra
					line["indentation"] = 12.5
					line["customwidth"] = 90
				elseif i == 2 then
					line["text"..i] = ComputerLines[l][2].cur
					line["justify"..i] = "RIGHT"
					line["text"..i.."R"] = 0.9
					line["text"..i.."G"] = 0.9
					line["text"..i.."B"] = 0.9
					line["indentation"..i] = 12.5
					line["customwidth"..i] = 30
				elseif i == 3 then
					line["text"..i] = ComputerLines[l][2].max
					line["justify"..i] = "RIGHT"
					line["text"..i.."R"] = 0.5
					line["text"..i.."G"] = 0.5
					line["text"..i.."B"] = 0.5
					line["indentation"..i] = 12.5
					line["customwidth"..i] = 30
				elseif i == 4 then
					line["text"..i] = ComputerLines[l][2].min
					line["justify"..i] = "RIGHT"
					line["text"..i.."R"] = 0.5
					line["text"..i.."G"] = 0.5
					line["text"..i.."B"] = 0.5
					line["indentation"..i] = 12.5
					line["customwidth"..i] = 30
				elseif i == 5 then
					line["text"..i] = ComputerLines[l][2].avg
					line["justify"..i] = "RIGHT"
					line["text"..i.."R"] = 0.5
					line["text"..i.."G"] = 0.5
					line["text"..i.."B"] = 0.5
					line["indentation"..i] = 12.5
					line["customwidth"..i] = 30
				end
			end
			SysSection["computer"].lineCat:AddLine(line)
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
		-- FPS
		SysStats.fps.cur = floor((GetFramerate() or 0) + 0.5)

		-- Get last 60 second data
		if ( (SysStats.fps.cur > 0) and (SysStats.fps.cur < 120) ) then
			if SysStats.fpsTally < 0 then
				-- Skip first 5 seconds upon login
				SysStats.fpsTally = SysStats.fpsTally + 1
			else
				local fpsCount = 60
				if SysStats.fpsTally < fpsCount then
					-- fpsCount up to our 60-sec of total tallying
					SysStats.fpsTally = SysStats.fpsTally + 1
					SysStats.fps.tally[SysStats.fpsTally] = SysStats.fps.cur
					fpsCount = SysStats.fpsTally
				else
					-- Shift our tally table down by 1
					for i = 1, fpsCount - 1 do
						SysStats.fps.tally[i] = SysStats.fps.tally[i + 1]
					end
					SysStats.fps.tally[fpsCount] = SysStats.fps.cur
				end

				-- Get Average/Min/Max fps
				local minfps, maxfps, totalfps = nil, 0, 0
				for i = 1, fpsCount do
					totalfps = totalfps + SysStats.fps.tally[i]
					if not minfps then minfps = SysStats.fps.tally[i] else minfps = min(minfps, SysStats.fps.tally[i]) end
					maxfps = max(maxfps, SysStats.fps.tally[i])
				end
				SysStats.fps.avg = floor((totalfps / fpsCount) + 0.5)
				SysStats.fps.min = minfps
				SysStats.fps.max = maxfps
			end
		end

		-- Tablet
		if sysinfo:IsRegistered(self) then
			if Tablet20Frame:IsShown() then
				sysinfo:Refresh(self)
			end
		end
	end

	infobar:SetScript("OnUpdate", function(self, elapsed)
		self.LastUpdate = (self.LastUpdate or 0) - elapsed

		if self.LastUpdate < 0 then
			local value = floor(GetFramerate())
			local max = GetCVar("MaxFPS")
			local r, g, b = R:ColorGradient(value/60, IF.InfoBarStatusColor[1][1], IF.InfoBarStatusColor[1][2], IF.InfoBarStatusColor[1][3], 
																			IF.InfoBarStatusColor[2][1], IF.InfoBarStatusColor[2][2], IF.InfoBarStatusColor[2][3],
																			IF.InfoBarStatusColor[3][1], IF.InfoBarStatusColor[3][2], IF.InfoBarStatusColor[3][3])
			infobar.Square:SetVertexColor(r, g, b)
			infobar.Text:SetText(string.format(stringText, value))
			self.LastUpdate = 1
			SysInfo_Update(self)
		end
	end)

	infobar:HookScript("OnEnter", SysInfo_OnEnter)
	infobar:HookScript("OnLeave", SysInfo_OnLeave)
end

IF:RegisterInfoText("FPS", LoadFPS)