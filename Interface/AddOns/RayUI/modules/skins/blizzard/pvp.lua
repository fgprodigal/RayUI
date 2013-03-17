local R, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local S = R:GetModule("Skins")

local function LoadSkin()
	PVPUIFrame:StripTextures()
	S:SetBD(PVPUIFrame)
	PVPUIFrame.LeftInset:StripTextures()
	PVPUIFrame.Shadows:StripTextures()

	S:ReskinClose(PVPUIFrameCloseButton)

	for i=1, 2 do
		S:CreateTab(_G["PVPUIFrameTab"..i])
	end

	for i=1, 3 do
		local button = _G["PVPQueueFrameCategoryButton"..i]
		button:SetTemplate('Default')
		button.Background:Kill()
		button.Ring:Kill()
		button.Icon:Size(45)
		button.Icon:SetTexCoord(.15, .85, .15, .85)
		S:Reskin(button)
	end

	for i=1, 3 do
		local button = _G["PVPArenaTeamsFrameTeam"..i]
		button.Background:Kill()
		S:Reskin(button)
	end

	-->>>HONOR FRAME
	S:ReskinDropDown(HonorFrameTypeDropDown)

	HonorFrame.Inset:StripTextures()
	--HonorFrame.Inset:SetTemplate("Transparent")

	S:ReskinScroll(HonorFrameSpecificFrameScrollBar)
	S:Reskin(HonorFrameSoloQueueButton)
	S:Reskin(HonorFrameGroupQueueButton)
	HonorFrame.BonusFrame:StripTextures()
	HonorFrame.BonusFrame.ShadowOverlay:StripTextures()
	-->>>CONQUEST FRAME
	ConquestFrame.Inset:StripTextures()
	ConquestPointsBarLeft:Kill()
	ConquestPointsBarRight:Kill()
	ConquestPointsBarMiddle:Kill()
	ConquestPointsBarBG:Kill()
	ConquestPointsBarShadow:Kill()
	ConquestPointsBar.progress:SetTexture(R["media"].normal)
	ConquestFrame:StripTextures()
	ConquestFrame.ShadowOverlay:StripTextures()
	S:Reskin(ConquestJoinButton, true)

	-->>>WARGRAMES FRAME
	WarGamesFrame:StripTextures()
	WarGamesFrame.RightInset:StripTextures()
	S:Reskin(WarGameStartButton, true)
	S:ReskinScroll(WarGamesFrameScrollFrameScrollBar)
	WarGamesFrame.HorizontalBar:StripTextures()

	-->>>ARENATEAMS
	PVPArenaTeamsFrame:StripTextures()
	ArenaTeamFrame.TopInset:StripTextures()
	ArenaTeamFrame.BottomInset:StripTextures()
	ArenaTeamFrame.WeeklyDisplay:StripTextures()
	S:ReskinArrow(ArenaTeamFrame.weeklyToggleRight, "left")
	S:ReskinArrow(ArenaTeamFrame.weeklyToggleLeft, "right")
	ArenaTeamFrame:StripTextures()
	ArenaTeamFrame.TopShadowOverlay:StripTextures()

	for i=1, 4 do
		_G["ArenaTeamFrameHeader"..i.."Left"]:Kill()
		_G["ArenaTeamFrameHeader"..i.."Middle"]:Kill()
		_G["ArenaTeamFrameHeader"..i.."Right"]:Kill()
		_G["ArenaTeamFrameHeader"..i]:SetHighlightTexture(nil)
	end

	S:Reskin(ArenaTeamFrame.AddMemberButton, true)

	-->>>PVP BANNERS
	PVPBannerFrame:StripTextures()
	PVPBannerFramePortrait:SetAlpha(0)
	PVPBannerFrame:SetTemplate("Transparent")
	S:ReskinClose(PVPBannerFrameCloseButton)
	S:ReskinInput(PVPBannerFrameEditBox)
	-- PVPBannerFrameEditBox.backdrop:SetOutside(PVPBannerFrameEditBox, 2, -5) ---<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<CHECK THIS WITH NON-PIXELPERFECT
	PVPBannerFrame.Inset:StripTextures()

	S:Reskin(PVPBannerFrameAcceptButton, true)

	--Duplicate button name workaround
	for i=1, PVPBannerFrame:GetNumChildren() do
		local child = select(i, PVPBannerFrame:GetChildren())
		if child and child:GetObjectType() == "Button" and child:GetWidth() == 80 then
			S:Reskin(child, true)
		end
	end

	for i=1, 3 do
		S:Reskin(_G["PVPColorPickerButton"..i])
		_G["PVPColorPickerButton"..i]:SetHeight(_G["PVPColorPickerButton"..i]:GetHeight() - 2)
	end

	PVPBannerFrameCustomizationFrame:StripTextures()

	for i=1, 2 do
		_G["PVPBannerFrameCustomization"..i]:StripTextures()
		S:ReskinArrow(_G["PVPBannerFrameCustomization"..i.."RightButton"], "right")
		S:ReskinArrow(_G["PVPBannerFrameCustomization"..i.."LeftButton"], "left")
	end
end

S:RegisterSkin("Blizzard_PVPUI", LoadSkin)