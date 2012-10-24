local R, L, P = unpack(select(2, ...)) --Inport: Engine, Locales, ProfileDB
local hooked = false

local function ShowFinish(text)
	if not hooked then
		hooksecurefunc("LevelUpDisplay_BuildPetBattleWinnerList", function(self)
			if self.hooked then
				self.winnerSoundKitID = 31749
				self.hooked=nil
			end
		end)
		hooked = true
	end
	LevelUpDisplay.hooked=true
	LevelUpDisplay.type=TOAST_PET_BATTLE_WINNER
	LevelUpDisplay:Show()
	LevelUpDisplay.levelFrame.singleline:SetText(text)
end

function R:SetLayout(layout)
	if not R.db.movers then R.db.movers = {} end
	if layout == "healer" then

	elseif layout == "dps" then
		R.db.movers.ArenaHeaderMover = "TOPLEFTUIParentBOTTOM450460"
		R.db.movers.BossHeaderMover = "TOPLEFTUIParentBOTTOM450460"
		R.db.movers.RayUF_focusMover = "BOTTOMRIGHTRayUF_playerTOPLEFT-2050"
		R.db.movers.RayUFRaid15_1Mover = "BOTTOMLEFTUIParentBOTTOMLEFT15235"
		R.db.movers.RayUFRaid25_1Mover = "BOTTOMLEFTUIParentBOTTOMLEFT15235"
		R.db.movers.RayUFRaid40_6Mover = "BOTTOMLEFTRayUFRaid25_1MoverTOPLEFT0"..R.db.Raid.spacing
		R.db.movers.ActionBar5Mover = "TOPRIGHTActionBar4MoverTOPLEFT-"..R.db.ActionBar.buttonspacing.."0"
	elseif layout == "default" then
		R:ResetMovers()
	end
	R:SetMoversPositions()
	R:GetModule("ActionBar"):UpdatePosition(GetActionBarToggles())
end

function R:ChooseLayout()
	if not RayUILayoutChooser then
		local S = R:GetModule("Skins")
		local f = CreateFrame("Frame", "RayUILayoutChooser", UIParent)
		f:SetFrameStrata("TOOLTIP")
		f:Size(500, 250)
		f:Point("CENTER")
		S:SetBD(f)

		f.CloseButton = CreateFrame("Button", nil, f, "UIPanelCloseButton")
		f.CloseButton:SetScript("OnClick", function()
			R.db.layoutchosen = true
			f:Hide()
		end)
		S:ReskinClose(f.CloseButton)

		f.Title = f:CreateFontString(nil, "OVERLAY")
		f.Title:FontTemplate(nil, 17, nil)
		f.Title:Point("TOP", 0, -15)
		f.Title:SetText(L["RayUI布局选择"])

		f.Desc = f:CreateFontString(nil, "OVERLAY")
		f.Desc:FontTemplate()	
		f.Desc:Point("TOPLEFT", 20, -80)		
		f.Desc:Width(f:GetWidth() - 40)
		f.Desc:SetText(L["欢迎使用RayUI, 请选择一个布局开始使用."])

		f.Option1 = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
		f.Option1:Size(120, 30)
		f.Option1:Point("BOTTOM", 0, 30)
		f.Option1:SetText(L["默认"])
		f.Option1:SetScript("OnClick", function(self)
			R.db.layoutchosen = true
			R:SetLayout("default")
			ShowFinish(L["设置完成"])
			f:Hide()
		end)
		S:Reskin(f.Option1)

		f.Option2 = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
		f.Option2:StripTextures()
		f.Option2:Size(120, 30)
		f.Option2:Point("RIGHT", f.Option1, "LEFT", -30, 0)
		f.Option2:SetText(L["伤害输出"])
		f.Option2:SetScript("OnClick", function(self)
			R.db.layoutchosen = true
			R:SetLayout("dps")
			ShowFinish(L["设置完成"])
			f:Hide()
		end)
		S:Reskin(f.Option2)		

		f.Option3 = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
		f.Option3:StripTextures()
		f.Option3:Size(120, 30)
		f.Option3:Point("LEFT", f.Option1, "RIGHT", 30, 0)
		f.Option3:SetText(L["治疗"]..L["(未完成)"])
		f.Option3:SetEnabled(false)
		S:Reskin(f.Option3)	
	end
	RayUILayoutChooser:Show()
end
