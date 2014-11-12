local R, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local S = R:GetModule("Skins")

local function LoadSkin()
	S:ReskinPortraitFrame(MailFrame, true)
	S:ReskinPortraitFrame(OpenMailFrame, true)

	MailFrameInset:DisableDrawLayer("BORDER")
	SendMailMoneyInset:DisableDrawLayer("BORDER")
	InboxFrame:GetRegions():Hide()
	MailFrameInsetBg:Hide()
	MailFrameTopBorder:Hide()
	MailFrameTopTileStreaks:Hide()
	SendMailMoneyBg:Hide()
	SendMailMoneyInsetBg:Hide()

	for i = 10, 14 do
	select(i, MailFrame:GetRegions()):Hide()
	end

	for i = 15, 17 do
	select(i, MailFrame:GetRegions()):SetAlpha(0)
	end

	select(18, MailFrame:GetRegions()):Hide()
	select(25, OpenMailFrame:GetRegions()):Hide()

	S:ReskinClose(MailFrameCloseButton)

	MailTextFontNormal:SetTextColor(1, 1, 1)

	OpenMailLetterButton:StripTextures()
	OpenMailLetterButton:StyleButton(true)
	OpenMailLetterButtonIconTexture:SetTexCoord(.08, .92, .08, .92)
	OpenMailMoneyButton:StyleButton(true)
	OpenMailMoneyButtonIconTexture:SetTexCoord(.08, .92, .08, .92)
	OpenMailFrameIcon:Hide()
	OpenMailHorizontalBarLeft:Hide()
	select(13, OpenMailFrame:GetRegions()):Hide()
	OpenStationeryBackgroundLeft:Hide()
	OpenStationeryBackgroundRight:Hide()
	for i = 4, 7 do
		select(i, SendMailFrame:GetRegions()):Hide()
	end
	SendStationeryBackgroundLeft:Hide()
	SendStationeryBackgroundRight:Hide()
	SendScrollBarBackgroundTop:Hide()
	select(4, SendMailScrollFrame:GetRegions()):Hide()
	OpenScrollBarBackgroundTop:Hide()
	select(2, OpenMailScrollFrame:GetRegions()):Hide()
	InboxPrevPageButton:GetRegions():Hide()
	InboxNextPageButton:GetRegions():Hide()

	SendMailMailButton:Point("RIGHT", SendMailCancelButton, "LEFT", -1, 0)
	OpenMailDeleteButton:Point("RIGHT", OpenMailCancelButton, "LEFT", -1, 0)
	OpenMailReplyButton:Point("RIGHT", OpenMailDeleteButton, "LEFT", -1, 0)
	SendMailMoneySilver:Point("LEFT", SendMailMoneyGold, "RIGHT", 1, 0)
	SendMailMoneyCopper:Point("LEFT", SendMailMoneySilver, "RIGHT", 1, 0)

	local buttons = {
		"SendMailMailButton",
		"SendMailCancelButton",
		"OpenMailReplyButton",
		"OpenMailDeleteButton",
		"OpenMailCancelButton",
		"OpenMailReportSpamButton"
	}
	for i = 1, #buttons do
		local button = _G[buttons[i]]
		S:Reskin(button)
	end

	for i = 1, 2 do
		S:CreateTab(_G["MailFrameTab"..i])
	end

	for i = 1, 5 do
		select(i, MailFrame:GetRegions()):Hide()
	end

	local inputs = {
		"SendMailNameEditBox",
		"SendMailSubjectEditBox",
		"SendMailMoneyGold",
		"SendMailMoneySilver",
		"SendMailMoneyCopper"
	}
	for i = 1, #inputs do
		input = _G[inputs[i]]
		S:ReskinInput(input)
	end

	S:ReskinArrow(InboxPrevPageButton, "left")
	S:ReskinArrow(InboxNextPageButton, "right")
	S:ReskinScroll(SendMailScrollFrameScrollBar)
	S:ReskinScroll(OpenMailScrollFrameScrollBar)

	local bg = CreateFrame("Frame", nil, OpenMailLetterButton)
	bg:Point("TOPLEFT", -1, 1)
	bg:Point("BOTTOMRIGHT", 1, -1)
	bg:SetFrameLevel(OpenMailLetterButton:GetFrameLevel()-1)
	S:CreateBD(bg)

	for i = 1, INBOXITEMS_TO_DISPLAY do
		local it = _G["MailItem"..i]
		local bu = _G["MailItem"..i.."Button"]
		local st = _G["MailItem"..i.."ButtonSlot"]
		local ic = _G["MailItem"..i.."Button".."Icon"]
		local line = select(3, _G["MailItem"..i]:GetRegions())

		local a, b = it:GetRegions()
		a:Hide()
		b:Hide()

		bu:StyleButton(true)
		bu:SetPushedTexture(nil)

		st:Hide()
		line:Hide()
		ic:SetTexCoord(.08, .92, .08, .92)

		local bg = CreateFrame("Frame", nil, bu)
		bg:Point("TOPLEFT", -1, 1)
		bg:Point("BOTTOMRIGHT", 1, -1)
		bg:SetFrameLevel(bu:GetFrameLevel()-1)
		S:CreateBD(bg, 0)
	end

	for i = 1, ATTACHMENTS_MAX_SEND do
		local button = _G["SendMailAttachment"..i]
		local ic = _G["OpenMailAttachmentButton"..i.."IconTexture"]

		button:StripTextures()
		button:StyleButton(true)
		ic:SetTexCoord(.08, .92, .08, .92)

		local bg = CreateFrame("Frame", nil, button)
		bg:Point("TOPLEFT", -1, 1)
		bg:Point("BOTTOMRIGHT", 1, -1)
		bg:SetFrameLevel(0)
		S:CreateBD(bg, .25)
	end

	for i = 1, ATTACHMENTS_MAX_RECEIVE do
		local bu = _G["OpenMailAttachmentButton"..i]
		local ic = _G["OpenMailAttachmentButton"..i.."IconTexture"]

		bu:StripTextures()
		bu:StyleButton(true)
		ic:SetTexCoord(.08, .92, .08, .92)

		local bg = CreateFrame("Frame", nil, bu)
		bg:Point("TOPLEFT", -1, 1)
		bg:Point("BOTTOMRIGHT", 1, -1)
		bg:SetFrameLevel(0)
		S:CreateBD(bg, .25)
	end

	for i = 1, ATTACHMENTS_MAX_RECEIVE do
			local bu = _G["OpenMailAttachmentButton"..i]
			local ic = _G["OpenMailAttachmentButton"..i.."IconTexture"]

			bu:SetNormalTexture("")
			bu:SetPushedTexture("")
			ic:SetTexCoord(.08, .92, .08, .92)

			local bg = CreateFrame("Frame", nil, bu)
			bg:Point("TOPLEFT", -1, 1)
			bg:Point("BOTTOMRIGHT", 1, -1)
			bg:SetFrameLevel(0)
			S:CreateBD(bg, .25)
		end

	hooksecurefunc("SendMailFrame_Update", function()
		for i = 1, ATTACHMENTS_MAX_SEND do
			local button = _G["SendMailAttachment"..i]
			if button:GetNormalTexture() then
				button:GetNormalTexture():SetTexCoord(.08, .92, .08, .92)
			end
			button:StyleButton(true)
		end
	end)
end

S:RegisterSkin("RayUI", LoadSkin)