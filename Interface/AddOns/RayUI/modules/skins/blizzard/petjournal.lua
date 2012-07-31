local R, L, P = unpack(select(2, ...)) --Inport: Engine, Locales, ProfileDB
local S = R:GetModule("Skins")

local function LoadSkin()
	for i = 1, 14 do
		if i ~= 8 then
			select(i, PetJournalParent:GetRegions()):Hide()
		end
	end
	for i = 1, 9 do
		select(i, MountJournal.MountCount:GetRegions()):Hide()
	end

	MountJournalMountButton_RightSeparator:Hide()
	MountJournal.LeftInset:Hide()
	MountJournal.RightInset:Hide()
	MountJournal.MountDisplay:GetRegions():Hide()
	MountJournal.MountDisplay.ShadowOverlay:Hide()

	local buttons = MountJournal.ListScrollFrame.buttons
	for i = 1, #buttons do
		local bu = buttons[i]

		bu:GetRegions():Hide()
		bu.selectedTexture:SetAlpha(0)
		bu:SetHighlightTexture("")

		local bg = CreateFrame("Frame", nil, bu)
		bg:SetPoint("TOPLEFT", 0, -1)
		bg:SetPoint("BOTTOMRIGHT", 0, 1)
		bg:SetFrameLevel(bu:GetFrameLevel()-1)
		S:CreateBD(bg, .25)
		bu.bg = bg

		bu.icon:SetTexCoord(.08, .92, .08, .92)
		bu.icon:SetDrawLayer("OVERLAY")
		S:CreateBG(bu.icon)

		bu.name:SetParent(bg)

		bu.DragButton:GetRegions():SetTexture(C.media.checked)
	end

	local function updateScroll()
		local buttons = MountJournal.ListScrollFrame.buttons
		for i = 1, #buttons do
			local bu = buttons[i]
			if bu.selectedTexture:IsShown() then
				bu.bg:SetBackdropColor(r, g, b, .25)
			else
				bu.bg:SetBackdropColor(0, 0, 0, .25)
			end
			if i == 2 then
				bu:SetPoint("TOPLEFT", buttons[i-1], "BOTTOMLEFT", 0, -1)
			elseif i > 2 then
				bu:SetPoint("TOPLEFT", buttons[i-1], "BOTTOMLEFT", 0, 0)
			end
		end
	end

	hooksecurefunc("MountJournal_UpdateMountList", updateScroll)
	MountJournalListScrollFrame:HookScript("OnVerticalScroll", updateScroll)
	MountJournalListScrollFrame:HookScript("OnMouseWheel", updateScroll)

	S:CreateBD(PetJournalParent)
	S:CreateSD(PetJournalParent)
	S:CreateBD(MountJournal.MountCount, .25)
	S:CreateBD(MountJournal.MountDisplay.ModelFrame, .25)

	S:Reskin(MountJournalMountButton)
	S:CreateTab(PetJournalParentTab1)
	S:CreateTab(PetJournalParentTab2)
	S:ReskinClose(PetJournalParentCloseButton)
	S:ReskinScroll(MountJournalListScrollFrameScrollBar)
	S:ReskinArrow(MountJournal.MountDisplay.ModelFrame.RotateLeftButton, "left")
	S:ReskinArrow(MountJournal.MountDisplay.ModelFrame.RotateRightButton, "right")
end

S:RegisterSkin("Blizzard_PetJournal", LoadSkin)