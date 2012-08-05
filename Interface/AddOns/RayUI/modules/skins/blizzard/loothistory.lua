local R, L, P = unpack(select(2, ...)) --Inport: Engine, Locales, ProfileDB
local S = R:GetModule("Skins")

local function LoadSkin()
	for i = 1, 9 do
		select(i, LootHistoryFrame:GetRegions()):Hide()
	end
	LootHistoryFrameScrollFrame:GetRegions():Hide()

	LootHistoryFrame.ResizeButton:SetPoint("TOP", LootHistoryFrame, "BOTTOM", 0, -1)
	LootHistoryFrame.ResizeButton:SetFrameStrata("LOW")

	S:ReskinArrow(LootHistoryFrame.ResizeButton, "down")
	LootHistoryFrame.ResizeButton:SetSize(32, 12)

	S:CreateBD(LootHistoryFrame)
	S:CreateSD(LootHistoryFrame)

	S:ReskinClose(LootHistoryFrame.CloseButton)
	S:ReskinScroll(LootHistoryFrameScrollFrameScrollBar)

	hooksecurefunc("LootHistoryFrame_FullUpdate", function()
		for i = 1, C_LootHistory.GetNumItems() do
			local frame = LootHistoryFrame.itemFrames[i]

			if not frame.reskinned then
				frame.NameBorderLeft:Hide()
				frame.NameBorderRight:Hide()
				frame.NameBorderMid:Hide()
				frame.IconBorder:Hide()

				frame.Icon:SetTexCoord(.08, .92, .08, .92)
				frame.Icon:SetDrawLayer("ARTWORK")
				S:CreateBG(frame.Icon)
				frame.reskinned = true
			end
		end
	end)
end

S:RegisterSkin("RayUI", LoadSkin)