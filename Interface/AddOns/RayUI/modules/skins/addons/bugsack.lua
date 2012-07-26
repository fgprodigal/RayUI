local R, L, P = unpack(select(2, ...)) --Inport: Engine, Locales, ProfileDB
local S = R:GetModule("Skins")

local skinned = false
local function SkinBugSack()
	if not IsAddOnLoaded("BugSack") or not BugSack then return end

	hooksecurefunc(BugSack, "OpenSack", function()
		if skinned then return end
		BugSackFrame:StripTextures()
		S:SetBD(BugSackFrame)
		S:Reskin(BugSackPrevButton)
		S:Reskin(BugSackNextButton)
		S:Reskin(BugSackSendButton)
		BugSackSendButton:SetPoint("LEFT", BugSackPrevButton, "RIGHT", 5, 0)
		BugSackSendButton:SetPoint("RIGHT", BugSackNextButton, "LEFT", -5, 0)
		S:ReskinScroll(BugSackScrollScrollBar)
		local BugSackFrameCloseButton = select(1, BugSackFrame:GetChildren())
		S:ReskinClose(BugSackFrameCloseButton)
		BugSackTabAll:ClearAllPoints()
		BugSackTabAll:SetPoint("TOPLEFT", BugSackFrame, "BOTTOMLEFT", 0, 1)
		S:CreateTab(BugSackTabAll)
		S:CreateTab(BugSackTabSession)
		S:CreateTab(BugSackTabLast)
		skinned = true
	end)
end

S:RegisterSkin("BugSack", SkinBugSack)