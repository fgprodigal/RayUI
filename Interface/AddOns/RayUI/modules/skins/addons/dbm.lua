--[[
Author: Affli@RU-Howling Fjord, 
Modified: Elv
All rights reserved.
]]--
local R, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local S = R:GetModule("Skins")

local function SkinDBM()
	local croprwicons = true			-- crops blizz shitty borders from icons in RaidWarning messages
	local rwiconsize = 18			-- RaidWarning icon size, because 12 is small for me. Works only if croprwicons=true
	local buttonsize = 20

	local function ApplyMyStyle(self)
		if not S.db.dbm or not S.db.dbmposition then return end
		if DBM_GUI_Option_57 then
			DBM_GUI_Option_57:Kill()
		end
		self.options.BarYOffset = 6
		self.options.ExpandUpwards = false
		if self.mainAnchor then
			self.mainAnchor:ClearAllPoints()
			self.mainAnchor:SetPoint("TOPLEFT", Minimap, "TOPRIGHT", self.options.Width/2 + 35 + buttonsize, self.options.BarYOffset)
		end
		if self.secAnchor then
			self.secAnchor:ClearAllPoints()
			self.secAnchor:SetPoint("BOTTOM", UIParent, "BOTTOM", - self.options.HugeWidth/2 - 80, 650)
		end
	end

	local function SkinBars(self)
		ApplyMyStyle(self)
		for bar in self:GetBarIterator() do
			if not bar.injected then
				function bar:ApplyStyle()
					local frame = bar.frame
					local tbar = _G[frame:GetName().."Bar"]
					local spark = _G[frame:GetName().."BarSpark"]
					local texture = _G[frame:GetName().."BarTexture"]
					local icon1 = _G[frame:GetName().."BarIcon1"]
					local icon2 = _G[frame:GetName().."BarIcon2"]
					local name = _G[frame:GetName().."BarName"]
					local timer = _G[frame:GetName().."BarTimer"]

					if not (icon1.overlay) then
						icon1.overlay = CreateFrame("Frame", "$parentIcon1Overlay", tbar)
						icon1.overlay:CreatePanel(template, buttonsize, buttonsize, "RIGHT", tbar, "LEFT", - 4, 0)

						local backdroptex = icon1.overlay:CreateTexture(nil, "BORDER")
						backdroptex:SetTexture([=[Interface\Icons\Spell_Nature_WispSplode]=])
						backdroptex:Point("TOPLEFT", icon1.overlay, "TOPLEFT", 0, 0)
						backdroptex:Point("BOTTOMRIGHT", icon1.overlay, "BOTTOMRIGHT", 0, 0)
						backdroptex:SetTexCoord(0.08, 0.92, 0.08, 0.92)
					end

					if not (icon2.overlay) then
						icon2.overlay = CreateFrame("Frame", "$parentIcon2Overlay", tbar)
						icon2.overlay:CreatePanel(template, buttonsize, buttonsize, "LEFT", tbar, "RIGHT", 4, 0)

						local backdroptex = icon2.overlay:CreateTexture(nil, "BORDER")
						backdroptex:SetTexture([=[Interface\Icons\Spell_Nature_WispSplode]=])
						backdroptex:Point("TOPLEFT", icon2.overlay, "TOPLEFT", 0, 0)
						backdroptex:Point("BOTTOMRIGHT", icon2.overlay, "BOTTOMRIGHT", 0, 0)
						backdroptex:SetTexCoord(0.08, 0.92, 0.08, 0.92)
					end

					if bar.color then
						tbar:SetStatusBarColor(bar.color.r, bar.color.g, bar.color.b)
					else
						tbar:SetStatusBarColor(bar.owner.options.StartColorR, bar.owner.options.StartColorG, bar.owner.options.StartColorB)
					end

					if bar.enlarged then frame:Width(bar.owner.options.HugeWidth) else frame:Width(bar.owner.options.Width) end
					if bar.enlarged then tbar:Width(bar.owner.options.HugeWidth) else tbar:Width(bar.owner.options.Width) end

					if not frame.styled then
						frame:SetScale(1)
						frame.SetScale=R.dummy
						frame:SetHeight(buttonsize)
						frame:CreateShadow("Background")
						frame.styled=true
					end

					if not spark.killed then
						spark:SetAlpha(0)
						spark:SetTexture(nil)
						spark.killed=true
					end

					if not icon1.styled then
						icon1:SetTexCoord(0.08, 0.92, 0.08, 0.92)
						icon1:ClearAllPoints()
						icon1:Point("TOPLEFT", icon1.overlay, 0, 0)
						icon1:Point("BOTTOMRIGHT", icon1.overlay, 0, 0)
						icon1.styled=true
					end

					if not icon2.styled then
						icon2:SetTexCoord(0.08, 0.92, 0.08, 0.92)
						icon2:ClearAllPoints()
						icon2:Point("TOPLEFT", icon2.overlay, 0, 0)
						icon2:Point("BOTTOMRIGHT", icon2.overlay, 0, 0)
						icon2.styled=true
					end

					if not texture.styled then
						texture:SetTexture(R["media"].normal)
						texture.styled=true
					end

					tbar:SetStatusBarTexture(R["media"].normal)
					if not tbar.styled then
						tbar:Point("TOPLEFT", frame, "TOPLEFT", 0, 0)
						tbar:Point("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 0, 0)

						tbar.styled=true
					end

					if not name.styled then
						name:ClearAllPoints()
						name:Point("LEFT", frame, "LEFT", 4, 0)
						name:SetWidth(165)
						name:SetHeight(8)
						name:SetFont(R["media"].font, 12, "OUTLINE")
						name:SetJustifyH("LEFT")
						name:SetShadowColor(0, 0, 0, 0)
						name.SetFont = R.dummy
						name.styled=true
					end

					if not timer.styled then
						timer:ClearAllPoints()
						timer:Point("RIGHT", frame, "RIGHT", -4, 0)
						timer:SetFont(R["media"].font, 12, "OUTLINE")
						timer:SetJustifyH("RIGHT")
						timer:SetShadowColor(0, 0, 0, 0)
						timer.SetFont = R.dummy
						timer.styled=true
					end

					if bar.owner.options.IconLeft then icon1:Show() icon1.overlay:Show() else icon1:Hide() icon1.overlay:Hide() end
					if bar.owner.options.IconRight then icon2:Show() icon2.overlay:Show() else icon2:Hide() icon2.overlay:Hide() end
					tbar:SetAlpha(1)
					frame:SetAlpha(1)
					texture:SetAlpha(1)
					frame:Show()
					bar:Update(0)
					bar.injected=true
				end
				bar:ApplyStyle()
			end
		end
	end

	local function SkinBossTitle()
		local anchor = DBMBossHealthDropdown:GetParent()
		if not anchor.styled then
			local header = {anchor:GetRegions()}
			if header[1]:IsObjectType("FontString") then
				header[1]:SetFont(R["media"].font, 12, "OUTLINE")
				header[1]:SetTextColor(1,1,1,1)
				header[1]:SetShadowColor(0, 0, 0, 0)
				anchor.styled = true
			end
			header=nil
		end
		anchor=nil
	end

	local function SkinBoss()
		local count = 1
		while (_G[format("DBM_BossHealth_Bar_%d", count)]) do
			local bar = _G[format("DBM_BossHealth_Bar_%d", count)]
			local background = _G[bar:GetName().."BarBorder"]
			local progress = _G[bar:GetName().."Bar"]
			local name = _G[bar:GetName().."BarName"]
			local timer = _G[bar:GetName().."BarTimer"]
			local prev = _G[format("DBM_BossHealth_Bar_%d", count-1)]

			if (count == 1) then
				local	_, anch, _ ,_, _ = bar:GetPoint()
				bar:ClearAllPoints()
				if DBM_SavedOptions.HealthFrameGrowUp then
					bar:Point("BOTTOM", anch, "TOP" , 0 , 12)
				else
					bar:Point("TOP", anch, "BOTTOM" , 0, -buttonsize)
				end
			else
				bar:ClearAllPoints()
				if DBM_SavedOptions.HealthFrameGrowUp then
					bar:Point("TOPLEFT", prev, "TOPLEFT", 0, buttonsize+4)
				else
					bar:Point("TOPLEFT", prev, "TOPLEFT", 0, -(buttonsize+4))
				end
			end

			if not bar.styled then
				bar:SetHeight(buttonsize)
				bar:CreateShadow("Background")
				background:SetNormalTexture(nil)
				bar.styled=true
			end

			if not progress.styled then
				progress:SetStatusBarTexture(R["media"].normal)
				progress.styled=true
			end
			progress:ClearAllPoints()
			progress:Point("TOPLEFT", bar, "TOPLEFT", 0, 0)
			progress:Point("BOTTOMRIGHT", bar, "BOTTOMRIGHT", 0, 0)

			if not name.styled then
				name:ClearAllPoints()
				name:Point("LEFT", bar, "LEFT", 4, 0)
				name:SetFont(R["media"].font, 12, "OUTLINE")
				name:SetJustifyH("LEFT")
				name:SetShadowColor(0, 0, 0, 0)
				name.styled=true
			end

			if not timer.styled then
				timer:ClearAllPoints()
				timer:Point("RIGHT", bar, "RIGHT", -4, 0)
				timer:SetFont(R["media"].font, 12, "OUTLINE")
				timer:SetJustifyH("RIGHT")
				timer:SetShadowColor(0, 0, 0, 0)
				timer.styled=true
			end
			count = count + 1
		end
	end

	-- mwahahahah, eat this ugly DBM.
	hooksecurefunc(DBT,"CreateBar",SkinBars)
	hooksecurefunc(DBT,"ApplyStyle",ApplyMyStyle)
	hooksecurefunc(DBM.BossHealth,"Show",SkinBossTitle)
	hooksecurefunc(DBM.BossHealth,"AddBoss",SkinBoss)
	hooksecurefunc(DBM.BossHealth,"UpdateSettings",SkinBoss)
	DBM.RangeCheck:Show()
	DBM.RangeCheck:Hide()

	local function SkinRange(self, range, filter, forceshow, redCircleNumPlayers)
		DBMRangeCheck:SetBackdrop(nil)
		DBMRangeCheck:CreateShadow("Background")

		if not self.styled then
			DBMRangeCheckRadar:CreateShadow("Background")
			DBMRangeCheckRadar.text:SetFont(R["media"].font, R["media"].fontsize, R["media"].fontflag)
			DBMRangeCheckRadar.text:SetShadowColor(0, 0, 0)
			DBMRangeCheckRadar.text:SetShadowOffset(R.mult, -R.mult)
			DBMRangeCheckRadar.styled = true
		end
		if S.db.dbmposition then
			DBMRangeCheckRadar:ClearAllPoints()
			DBMRangeCheckRadar:Point("TOPLEFT", Minimap, "BOTTOMLEFT", 0, -70)
		end
	end
	hooksecurefunc(DBM.RangeCheck, "Show", SkinRange)

	hooksecurefunc(DBM, "ShowUpdateReminder", function()
		for i = UIParent:GetNumChildren(), 1, -1 do
			local frame = select(i, UIParent:GetChildren())

			local editBox = frame:GetChildren()
			if editBox and editBox:GetObjectType() == "EditBox" and editBox:GetText() == "http://www.deadlybossmods.com" and not frame.styled then
				S:CreateBD(frame)

				select(6, editBox:GetRegions()):Hide()
				select(7, editBox:GetRegions()):Hide()
				select(8, editBox:GetRegions()):Hide()

				local bg = S:CreateBDFrame(editBox, .25)
				bg:SetPoint("TOPLEFT", -2, -6)
				bg:SetPoint("BOTTOMRIGHT", 2, 8)

				S:Reskin(select(2, frame:GetChildren()))

				frame.styled = true
			end
		end
	end)

	if DBM.InfoFrame then
		DBM.InfoFrame:Show(5, "test")
		DBM.InfoFrame:Hide()
		DBMInfoFrame:HookScript("OnShow",function(self)
			self:SetBackdrop(nil)
			self:CreateShadow("Background")
		end)
	end

	local RaidNotice_AddMessage_ = RaidNotice_AddMessage
	RaidNotice_AddMessage = function(noticeFrame, textString, colorInfo)
		if textString:find("|T") then
			if textString:match(":(%d+):(%d+)") then
				local size1, size2 = textString:match(":(%d+):(%d+)")
				size1, size2 = size1 + 6, size2 + 6
				textString = string.gsub(textString,":(%d+):(%d+)",":"..size1..":"..size2..":0:0:64:64:5:59:5:59")
			elseif textString:match(":(%d+)|t") then
				local size = textString:match(":(%d+)|t")
				size = size + 6
				textString = string.gsub(textString,":(%d+)|t",":"..size..":"..size..":0:0:64:64:5:59:5:59|t")
			end
		end
		return RaidNotice_AddMessage_(noticeFrame, textString, colorInfo)
	end

	local ForceOptions = function()
		local db = DBT_AllPersistentOptions["Default"] or DBT_PersistentOptions["DBM"] or nil
		if not db then
			R:Print("DBM配置写入失败")
			return
		end
		db.Scale = 1
		db.HugeScale = 1
		db.BarXOffset = 0
		db.BarYOffset = 6
		db.HugeBarYOffset = 6
		db.Texture = "RayUI Normal"
		db.Font = "RayUI Font"
	end

	local loadOptions = CreateFrame("Frame")
	loadOptions:RegisterEvent("PLAYER_LOGIN")
	loadOptions:SetScript("OnEvent", ForceOptions)
end

S:RegisterSkin("DBM-Core", SkinDBM)

local function SkinGUI()
	DBM_GUI_OptionsFrameHeader:SetTexture(nil)
	DBM_GUI_OptionsFramePanelContainer:SetBackdrop(nil)
	DBM_GUI_OptionsFrameBossModsList:SetBackdrop(nil)
	DBM_GUI_OptionsFrameBossMods:DisableDrawLayer("BACKGROUND")
	DBM_GUI_OptionsFrameDBMOptions:DisableDrawLayer("BACKGROUND")

	if DBM_GUI_OptionsFramecheck then
		S:Reskin(DBM_GUI_OptionsFramecheck)
		S:Reskin(DBM_GUI_OptionsFramecheck2)
		DBM_GUI_OptionsFrameSoundMM:Kill()
		DBM_GUI_OptionsFrameWebsite:Kill()
		DBM_GUI_OptionsFrameWebsiteButton:Kill()
		DBM_GUI_OptionsFrameTranslation:Kill()
	end

	for i = 1, 2 do
		_G["DBM_GUI_OptionsFrameTab"..i.."Left"]:SetAlpha(0)
		_G["DBM_GUI_OptionsFrameTab"..i.."Middle"]:SetAlpha(0)
		_G["DBM_GUI_OptionsFrameTab"..i.."Right"]:SetAlpha(0)
		_G["DBM_GUI_OptionsFrameTab"..i.."LeftDisabled"]:SetAlpha(0)
		_G["DBM_GUI_OptionsFrameTab"..i.."MiddleDisabled"]:SetAlpha(0)
		_G["DBM_GUI_OptionsFrameTab"..i.."RightDisabled"]:SetAlpha(0)
	end

	local count = 1

	local function styleDBM()
		local option = _G["DBM_GUI_Option_"..count]
		while option do
			local objType = option:GetObjectType()
			if objType == "CheckButton" then
				S:ReskinCheck(option)
			elseif objType == "Slider" then
				S:ReskinSlider(option)
			elseif objType == "EditBox" then
				S:ReskinInput(option)
			elseif option:GetName():find("DropDown") then
				S:ReskinDropDown(option)
			elseif objType == "Button" then
				S:Reskin(option)
			elseif objType == "Frame" then
				option:SetBackdrop(nil)
			end

			count = count + 1
			option = _G["DBM_GUI_Option_"..count]
			if not option then
				option = _G["DBM_GUI_DropDown"..count]
			end
		end
	end

	DBM:RegisterOnGuiLoadCallback(function()
		styleDBM()
		hooksecurefunc(DBM_GUI, "UpdateModList", styleDBM)
		DBM_GUI_OptionsFrameBossMods:HookScript("OnShow", styleDBM)
	end)

	DBM_GUI_OptionsFrame:StripTextures()
	S:SetBD(DBM_GUI_OptionsFrame)
	S:Reskin(DBM_GUI_OptionsFrameOkay)
	S:Reskin(DBM_GUI_OptionsFrameWebsiteButton)
	S:ReskinScroll(DBM_GUI_OptionsFramePanelContainerFOVScrollBar)
	S:ReskinScroll(DBM_GUI_OptionsFrameBossModsListScrollBar)
end

S:RegisterSkin("DBM-GUI", SkinGUI)
