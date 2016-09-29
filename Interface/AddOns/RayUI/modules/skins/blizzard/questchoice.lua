local R, L, P, G = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, GlobalDB
local S = R:GetModule("Skins")

local function LoadSkin()
	for i = 1, 15 do
		select(i, QuestChoiceFrame:GetRegions()):Hide()
	end

	for i = 17, 19 do
		select(i, QuestChoiceFrame:GetRegions()):Hide()
	end
	
	for i = 1, #QuestChoiceFrame.Options do
		local option = QuestChoiceFrame["Option"..i]
		local rewards = option.Rewards
		local item = rewards.Item
		local currencies = rewards.Currencies

		option.OptionText:SetTextColor(.9, .9, .9)

		item.Name:SetTextColor(1, 1, 1)
		item.Icon:SetTexCoord(.08, .92, .08, .92)
		item.Icon:SetDrawLayer("BACKGROUND", 1)
		item.bg = S:CreateBG(item.Icon)


		for j = 1, 3 do
			local cu = currencies["Currency"..j]

			cu.Icon:SetTexCoord(.08, .92, .08, .92)
			S:CreateBG(cu.Icon)
		end
		S:Reskin(option.OptionButton)
	end

	hooksecurefunc("QuestChoiceFrame_ShowRewards", function(numOptions)
		for i = 1, numOptions do
			local rewards = QuestChoiceFrame["Option"..i].Rewards
			rewards.Item.Name:SetTextColor(rewards.Item.IconBorder:GetVertexColor())
			rewards.Item.IconBorder:Hide()
		end
	end)

	S:SetBD(QuestChoiceFrame)
	S:ReskinClose(QuestChoiceFrame.CloseButton)
end

S:AddCallbackForAddon("Blizzard_QuestChoice", "QuestChoice", LoadSkin)