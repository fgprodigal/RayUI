local R, L, P = unpack(select(2, ...)) --Inport: Engine, Locales, ProfileDB
local S = R:GetModule("Skins")

local function LoadSkin()
	S:SetBD(WorldStateScoreFrame)
	S:ReskinScroll(WorldStateScoreScrollFrameScrollBar)
	WorldStateScoreFrame:DisableDrawLayer("BACKGROUND")
	WorldStateScoreFrameInset:DisableDrawLayer("BACKGROUND")
	WorldStateScoreFrame:DisableDrawLayer("BORDER")
	WorldStateScoreFrameInset:DisableDrawLayer("BORDER")
	WorldStateScoreFrameTopLeftCorner:Hide()
	WorldStateScoreFrameTopBorder:Hide()
	WorldStateScoreFrameTopRightCorner:Hide()
	select(2, WorldStateScoreScrollFrame:GetRegions()):Hide()
	select(3, WorldStateScoreScrollFrame:GetRegions()):Hide()
	WorldStateScoreFrameTab2:SetPoint("LEFT", WorldStateScoreFrameTab1, "RIGHT", -15, 0)
	WorldStateScoreFrameTab3:SetPoint("LEFT", WorldStateScoreFrameTab2, "RIGHT", -15, 0)
	for i = 1, 3 do
		S:CreateTab(_G["WorldStateScoreFrameTab"..i])
	end
	S:Reskin(WorldStateScoreFrameLeaveButton)
	S:ReskinClose(WorldStateScoreFrameCloseButton)
end

S:RegisterSkin("RayUI", LoadSkin)