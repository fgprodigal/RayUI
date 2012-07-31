local R, L, P = unpack(select(2, ...)) --Inport: Engine, Locales, ProfileDB
local S = R:GetModule("Skins")

local function LoadSkin()
	S:SetBD(PVPFrame)
	S:SetBD(PVPBannerFrame)
	PVPFramePortrait:Hide()
	PVPHonorFrameBGTex:Hide()
	PVPBannerFramePortrait:Hide()
	select(2, PVPHonorFrameInfoScrollFrameScrollBar:GetRegions()):Hide()
	select(3, PVPHonorFrameInfoScrollFrameScrollBar:GetRegions()):Hide()
	select(4, PVPHonorFrameInfoScrollFrameScrollBar:GetRegions()):Hide()
	PVPHonorFrameTypeScrollFrame:GetRegions():Hide()
	select(2, PVPHonorFrameTypeScrollFrame:GetRegions()):Hide()
	PVPFramePortraitFrame:Hide()
	PVPFrameTopBorder:Hide()
	PVPFrameTopRightCorner:Hide()
	PVPFrameLeftButton_RightSeparator:Hide()
	PVPFrameRightButton_LeftSeparator:Hide()
	PVPBannerFrameCustomizationBorder:Hide()
	PVPBannerFramePortraitFrame:Hide()
	PVPBannerFrameTopBorder:Hide()
	PVPBannerFrameTopRightCorner:Hide()
	PVPBannerFrameAcceptButton_RightSeparator:Hide()
	PVPBannerFrameCancelButton_LeftSeparator:Hide()
	PVPTeamManagementFrameWeeklyDisplay:SetPoint("RIGHT", PVPTeamManagementFrameWeeklyToggleRight, "LEFT", -2, 0)
	for i = 1, 4 do
		if _G["PVPFrameTab"..i] then S:CreateTab(_G["PVPFrameTab"..i]) end
	end

	PVPTeamManagementFrameFlag2Header:SetAlpha(0)
	PVPTeamManagementFrameFlag3Header:SetAlpha(0)
	PVPTeamManagementFrameFlag5Header:SetAlpha(0)
	PVPTeamManagementFrameFlag2HeaderSelected:SetAlpha(0)
	PVPTeamManagementFrameFlag3HeaderSelected:SetAlpha(0)
	PVPTeamManagementFrameFlag5HeaderSelected:SetAlpha(0)
	PVPTeamManagementFrameFlag2Title:SetTextColor(1, 1, 1)
	PVPTeamManagementFrameFlag3Title:SetTextColor(1, 1, 1)
	PVPTeamManagementFrameFlag5Title:SetTextColor(1, 1, 1)
	PVPTeamManagementFrameFlag2Title.SetTextColor = R.dummy
	PVPTeamManagementFrameFlag3Title.SetTextColor = R.dummy
	PVPTeamManagementFrameFlag5Title.SetTextColor = R.dummy

	local bglayers = {
		"PVPFrame",
		"PVPFrameInset",
		"PVPFrameTopInset",
		"PVPTeamManagementFrame",
		"PVPTeamManagementFrameHeader1",
		"PVPTeamManagementFrameHeader2",
		"PVPTeamManagementFrameHeader3",
		"PVPTeamManagementFrameHeader4",
		"PVPBannerFrame",
		"PVPBannerFrameInset"
	}
	for i = 1, #bglayers do
		_G[bglayers[i]]:DisableDrawLayer("BACKGROUND")
	end

	local borderlayers = {
		"PVPFrame",
		"PVPFrameInset",
		"PVPConquestFrameInfoButton",
		"PVPFrameTopInset",
		"PVPTeamManagementFrame",
		"PVPBannerFrame",
		"PVPBannerFrameInset"
	}
	for i = 1, #borderlayers do
		_G[borderlayers[i]]:DisableDrawLayer("BORDER")
	end
	PVPConquestFrame:DisableDrawLayer("ARTWORK")
	for i = 1, 3 do
		for j = 1, 2 do
			select(i, _G["PVPBannerFrameCustomization"..j]:GetRegions()):Hide()
		end
	end

	local buttons = {
		"PVPFrameLeftButton",
		"PVPFrameRightButton",
		"PVPBannerFrameAcceptButton",
		"PVPColorPickerButton1",
		"PVPColorPickerButton2",
		"PVPColorPickerButton3",
		"WarGameStartButton"
	}
	for i = 1, #buttons do
		local button = _G[buttons[i]]
		S:Reskin(button)
	end
	S:Reskin(select(6, PVPBannerFrame:GetChildren()))
	S:ReskinClose(PVPFrameCloseButton)
	S:ReskinClose(PVPBannerFrameCloseButton)
	S:ReskinScroll(PVPHonorFrameTypeScrollFrameScrollBar)
	S:ReskinScroll(PVPHonorFrameInfoScrollFrameScrollBar)
	S:ReskinInput(PVPBannerFrameEditBox, 20)
	S:ReskinInput(PVPTeamManagementFrameWeeklyDisplay)
	S:ReskinArrow(PVPTeamManagementFrameWeeklyToggleLeft, "left")
	S:ReskinArrow(PVPTeamManagementFrameWeeklyToggleRight, "right")
	S:ReskinArrow(PVPBannerFrameCustomization1LeftButton, "left")
	S:ReskinArrow(PVPBannerFrameCustomization1RightButton, "right")
	S:ReskinArrow(PVPBannerFrameCustomization2LeftButton, "left")
	S:ReskinArrow(PVPBannerFrameCustomization2RightButton, "right")

	local pvpbg = CreateFrame("Frame", nil, PVPTeamManagementFrame)
	pvpbg:SetPoint("TOPLEFT", PVPTeamManagementFrameFlag2)
	pvpbg:SetPoint("BOTTOMRIGHT", PVPTeamManagementFrameFlag5)
	S:CreateBD(pvpbg, .25)

	PVPFrameConquestBarLeft:Hide()
	PVPFrameConquestBarMiddle:Hide()
	PVPFrameConquestBarRight:Hide()
	PVPFrameConquestBarBG:Hide()
	PVPFrameConquestBarShadow:Hide()
	PVPFrameConquestBarCap1:SetAlpha(0)

	for i = 1, 4 do
		_G["PVPFrameConquestBarDivider"..i]:Hide()
	end

	PVPFrameConquestBarProgress:SetTexture(S["media"].backdrop)
	PVPFrameConquestBarProgress:SetGradient("VERTICAL", .7, 0, 0, .8, 0, 0)
	local qbg = CreateFrame("Frame", nil, PVPFrameConquestBar)
	qbg:SetPoint("TOPLEFT", -1, -2)
	qbg:SetPoint("BOTTOMRIGHT", 1, 2)
	qbg:SetFrameLevel(PVPFrameConquestBar:GetFrameLevel()-1)
	S:CreateBD(qbg, .25)

	local function CaptureBar()
		if not NUM_EXTENDED_UI_FRAMES then return end
		for i = 1, NUM_EXTENDED_UI_FRAMES do
			local barname = "WorldStateCaptureBar"..i
			local bar = _G[barname]

			if bar and bar:IsVisible() then
				bar:ClearAllPoints()
				bar:SetPoint("TOP", UIParent, "TOP", 0, -120)
				if not bar.skinned then
					local left = _G[barname.."LeftBar"]
					local right = _G[barname.."RightBar"]
					local middle = _G[barname.."MiddleBar"]

					left:SetTexture(S["media"].backdrop)
					right:SetTexture(S["media"].backdrop)
					middle:SetTexture(S["media"].backdrop)
					left:SetDrawLayer("BORDER")
					middle:SetDrawLayer("ARTWORK")
					right:SetDrawLayer("BORDER")

					left:SetGradient("VERTICAL", .1, .4, .9, .2, .6, 1)
					right:SetGradient("VERTICAL", .7, .1, .1, .9, .2, .2)
					middle:SetGradient("VERTICAL", .8, .8, .8, 1, 1, 1)

					_G[barname.."RightLine"]:SetAlpha(0)
					_G[barname.."LeftLine"]:SetAlpha(0)
					select(4, bar:GetRegions()):Hide()
					_G[barname.."LeftIconHighlight"]:SetAlpha(0)
					_G[barname.."RightIconHighlight"]:SetAlpha(0)

					bar.bg = bar:CreateTexture(nil, "BACKGROUND")
					bar.bg:SetPoint("TOPLEFT", left, -1, 1)
					bar.bg:SetPoint("BOTTOMRIGHT", right, 1, -1)
					bar.bg:SetTexture(S["media"].backdrop)
					bar.bg:SetVertexColor(0, 0, 0)

					bar.bgmiddle = CreateFrame("Frame", nil, bar)
					bar.bgmiddle:SetPoint("TOPLEFT", middle, -1, 1)
					bar.bgmiddle:SetPoint("BOTTOMRIGHT", middle, 1, -1)
					S:CreateBD(bar.bgmiddle, 0)

					bar.skinned = true
				end
			end
		end
	end

	hooksecurefunc("UIParent_ManageFramePositions", CaptureBar)

	select(2, WarGamesFrameInfoScrollFrameScrollBar:GetRegions()):Hide()
	select(3, WarGamesFrameInfoScrollFrameScrollBar:GetRegions()):Hide()
	select(4, WarGamesFrameInfoScrollFrameScrollBar:GetRegions()):Hide()
	WarGamesFrameBGTex:Hide()
	WarGamesFrameBarLeft:Hide()
	select(3, WarGamesFrame:GetRegions()):Hide()
	WarGameStartButton_RightSeparator:Hide()
	S:ReskinScroll(WarGamesFrameScrollFrameScrollBar)
	S:ReskinScroll(WarGamesFrameInfoScrollFrameScrollBar)

	for i = 1, 6 do
		local button = _G["WarGamesFrameScrollFrameButton"..i.."WarGame"]
		local icon = _G["WarGamesFrameScrollFrameButton"..i.."WarGameIcon"]

		local bg = CreateFrame("Frame", nil, button)
		bg:Point("TOPLEFT", icon, "TOPLEFT", -1, 1)
		bg:Point("BOTTOMRIGHT", icon, "BOTTOMRIGHT", 1, -1)
		S:CreateBD(bg, 0)

		button:StripTextures()
		button:StyleButton()
		button:GetHighlightTexture():Point("TOPLEFT", 2, 0)
		button:GetHighlightTexture():Point("BOTTOMRIGHT", -2, 0)
		button:GetPushedTexture():Point("TOPLEFT", 2, 0)
		button:GetPushedTexture():Point("BOTTOMRIGHT", -2, 0)
		select(2, button:GetRegions()):SetTexture(23/255,132/255,209/255,0.5)
	end
end

S:RegisterSkin("RayUI", LoadSkin)