local R, L, P = unpack(select(2, ...)) --Inport: Engine, Locales, ProfileDB
local S = R:GetModule("Skins")

local function LoadSkin()
	CalendarFrame:DisableDrawLayer("BORDER")
	for i = 1, 15 do
		if i ~= 10 and i ~= 11 and i ~= 12 and i ~= 13 and i ~= 14 then select(i, CalendarViewEventFrame:GetRegions()):Hide() end
	end
	for i = 1, 9 do
		select(i, CalendarViewHolidayFrame:GetRegions()):Hide()
		select(i, CalendarViewRaidFrame:GetRegions()):Hide()
	end
	for i = 1, 3 do
		select(i, CalendarCreateEventTitleFrame:GetRegions()):Hide()
		select(i, CalendarViewEventTitleFrame:GetRegions()):Hide()
		select(i, CalendarViewHolidayTitleFrame:GetRegions()):Hide()
		select(i, CalendarViewRaidTitleFrame:GetRegions()):Hide()
	end
	for i = 1, 42 do
		_G["CalendarDayButton"..i]:DisableDrawLayer("BACKGROUND")
		_G["CalendarDayButton"..i.."DarkFrame"]:SetAlpha(.5)
	end
	for i = 1, 7 do
		_G["CalendarWeekday"..i.."Background"]:SetAlpha(0)
	end
	CalendarViewEventDivider:Hide()
	CalendarCreateEventDivider:Hide()
	CalendarViewEventInviteList:GetRegions():Hide()
	CalendarViewEventDescriptionContainer:GetRegions():Hide()
	select(5, CalendarCreateEventCloseButton:GetRegions()):Hide()
	select(5, CalendarViewEventCloseButton:GetRegions()):Hide()
	select(5, CalendarViewHolidayCloseButton:GetRegions()):Hide()
	select(5, CalendarViewRaidCloseButton:GetRegions()):Hide()
	CalendarCreateEventBackground:Hide()
	CalendarCreateEventFrameButtonBackground:Hide()
	CalendarCreateEventMassInviteButtonBorder:Hide()
	CalendarCreateEventCreateButtonBorder:Hide()
	CalendarEventPickerTitleFrameBackgroundLeft:Hide()
	CalendarEventPickerTitleFrameBackgroundMiddle:Hide()
	CalendarEventPickerTitleFrameBackgroundRight:Hide()
	CalendarEventPickerFrameButtonBackground:Hide()
	CalendarEventPickerCloseButtonBorder:Hide()
	CalendarCreateEventRaidInviteButtonBorder:Hide()
	CalendarMonthBackground:SetAlpha(0)
	CalendarYearBackground:SetAlpha(0)
	CalendarFrameModalOverlay:SetAlpha(.25)
	CalendarViewHolidayInfoTexture:SetAlpha(0)
	CalendarTexturePickerTitleFrameBackgroundLeft:Hide()
	CalendarTexturePickerTitleFrameBackgroundMiddle:Hide()
	CalendarTexturePickerTitleFrameBackgroundRight:Hide()
	CalendarTexturePickerFrameButtonBackground:Hide()
	CalendarTexturePickerAcceptButtonBorder:Hide()
	CalendarTexturePickerCancelButtonBorder:Hide()
	CalendarClassTotalsButtonBackgroundTop:Hide()
	CalendarClassTotalsButtonBackgroundMiddle:Hide()
	CalendarClassTotalsButtonBackgroundBottom:Hide()
	CalendarFilterFrameLeft:Hide()
	CalendarFilterFrameMiddle:Hide()
	CalendarFilterFrameRight:Hide()

	S:SetBD(CalendarFrame, 12, 0, -9, 4)
	S:CreateBD(CalendarViewEventFrame)
	S:CreateBD(CalendarViewHolidayFrame)
	S:CreateBD(CalendarViewRaidFrame)
	S:CreateBD(CalendarCreateEventFrame)
	S:CreateBD(CalendarClassTotalsButton)
	S:CreateBD(CalendarTexturePickerFrame, .7)
	S:CreateBD(CalendarViewEventInviteList, .25)
	S:CreateBD(CalendarViewEventDescriptionContainer, .25)
	S:CreateBD(CalendarCreateEventInviteList, .25)
	S:CreateBD(CalendarCreateEventDescriptionContainer, .25)
	S:CreateBD(CalendarEventPickerFrame, .25)

	for i, class in ipairs(CLASS_SORT_ORDER) do
		local bu = _G["CalendarClassButton"..i]
		bu:GetRegions():Hide()
		S:CreateBG(bu)

		local tcoords = CLASS_ICON_TCOORDS[class]
		local ic = bu:GetNormalTexture()
		ic:SetTexCoord(tcoords[1] + 0.015, tcoords[2] - 0.02, tcoords[3] + 0.018, tcoords[4] - 0.02)
	end

	local bd = CreateFrame("Frame", nil, CalendarFilterFrame)
	bd:SetPoint("TOPLEFT", 40, 0)
	bd:SetPoint("BOTTOMRIGHT", -19, 0)
	bd:SetFrameLevel(CalendarFilterFrame:GetFrameLevel()-1)
	S:CreateBD(bd, 0)

	local tex = bd:CreateTexture(nil, "BACKGROUND")
	tex:SetPoint("TOPLEFT")
	tex:SetPoint("BOTTOMRIGHT")
	tex:SetTexture(S["media"].backdrop)
	tex:SetGradientAlpha("VERTICAL", 0, 0, 0, .3, .35, .35, .35, .35)

	local downtex = CalendarFilterButton:CreateTexture(nil, "ARTWORK")
	downtex:SetTexture("Interface\\AddOns\\RayUI\\media\\arrow-down-active")
	downtex:SetSize(8, 8)
	downtex:SetPoint("CENTER")
	downtex:SetVertexColor(1, 1, 1)

	for i = 1, 6 do
		local vline = CreateFrame("Frame", nil, _G["CalendarDayButton"..i])
		vline:SetHeight(546)
		vline:SetWidth(1)
		vline:SetPoint("TOP", _G["CalendarDayButton"..i], "TOPRIGHT")
		S:CreateBD(vline)
	end
	for i = 1, 36, 7 do
		local hline = CreateFrame("Frame", nil, _G["CalendarDayButton"..i])
		hline:SetWidth(637)
		hline:SetHeight(1)
		hline:SetPoint("LEFT", _G["CalendarDayButton"..i], "TOPLEFT")
		S:CreateBD(hline)
	end

	CalendarContextMenu:SetBackdrop(nil)
	local bg = CreateFrame("Frame", nil, CalendarContextMenu)
	bg:SetPoint("TOPLEFT")
	bg:SetPoint("BOTTOMRIGHT")
	bg:SetFrameLevel(CalendarContextMenu:GetFrameLevel()-1)
	S:CreateBD(bg)

	CalendarViewEventFrame:SetPoint("TOPLEFT", CalendarFrame, "TOPRIGHT", -8, -24)
	CalendarViewHolidayFrame:SetPoint("TOPLEFT", CalendarFrame, "TOPRIGHT", -8, -24)
	CalendarViewRaidFrame:SetPoint("TOPLEFT", CalendarFrame, "TOPRIGHT", -8, -24)
	CalendarCreateEventFrame:SetPoint("TOPLEFT", CalendarFrame, "TOPRIGHT", -8, -24)
	CalendarCreateEventInviteButton:SetPoint("TOPLEFT", CalendarCreateEventInviteEdit, "TOPRIGHT", 1, 1)
	CalendarClassButton1:SetPoint("TOPLEFT", CalendarClassButtonContainer, "TOPLEFT", 5, 0)

	local cbuttons = {"CalendarViewEventAcceptButton", "CalendarViewEventTentativeButton", "CalendarViewEventDeclineButton", "CalendarViewEventRemoveButton", "CalendarCreateEventMassInviteButton", "CalendarCreateEventCreateButton", "CalendarCreateEventInviteButton", "CalendarEventPickerCloseButton", "CalendarCreateEventRaidInviteButton", "CalendarTexturePickerAcceptButton", "CalendarTexturePickerCancelButton", "CalendarFilterButton"}
	for i = 1, #cbuttons do
		local cbutton = _G[cbuttons[i]]
		S:Reskin(cbutton)
	end

	S:ReskinClose(CalendarCloseButton, "TOPRIGHT", CalendarFrame, "TOPRIGHT", -14, -4)
	S:ReskinClose(CalendarCreateEventCloseButton)
	S:ReskinClose(CalendarViewEventCloseButton)
	S:ReskinClose(CalendarViewHolidayCloseButton)
	S:ReskinClose(CalendarViewRaidCloseButton)
	S:ReskinScroll(CalendarTexturePickerScrollBar)
	S:ReskinScroll(CalendarViewEventInviteListScrollFrameScrollBar)
	S:ReskinScroll(CalendarViewEventDescriptionScrollFrameScrollBar)
	S:ReskinDropDown(CalendarCreateEventTypeDropDown)
	S:ReskinDropDown(CalendarCreateEventHourDropDown)
	CalendarCreateEventHourDropDown:SetWidth(80)
	S:ReskinDropDown(CalendarCreateEventMinuteDropDown)
	CalendarCreateEventMinuteDropDown:SetWidth(80)
	S:ReskinInput(CalendarCreateEventTitleEdit)
	S:ReskinInput(CalendarCreateEventInviteEdit)
	S:ReskinArrow(CalendarPrevMonthButton, 1)
	S:ReskinArrow(CalendarNextMonthButton, 2)
	CalendarPrevMonthButton:SetSize(19, 19)
	CalendarNextMonthButton:SetSize(19, 19)
	S:ReskinCheck(CalendarCreateEventLockEventCheck)
end

S:RegisterSkin("Blizzard_Calendar", LoadSkin)