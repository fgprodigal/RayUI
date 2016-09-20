local R, L, P, G = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, GlobalDB
local S = R:GetModule("Skins")

local function LoadSkin()
	for i = 1, 15 do
		select(i, QuestChoiceFrame:GetRegions()):Hide()
	end

	for i = 17, 19 do
		select(i, QuestChoiceFrame:GetRegions()):Hide()
	end
	
	for i = 1, 4 do
		local option = QuestChoiceFrame["Option"..i]
		local rewards = option.Rewards
		local icon = rewards.Item.Icon
		local currencies = rewards.Currencies

		option.OptionText:SetTextColor(.9, .9, .9)
		rewards.Item.Name:SetTextColor(1, 1, 1)

		icon:SetTexCoord(.08, .92, .08, .92)
		icon:SetDrawLayer("BACKGROUND", 1)
		S:CreateBG(icon)
	
		S:Reskin(option.OptionButton)

		for j = 1, 3 do
			local cu = currencies["Currency"..j]

			cu.Icon:SetTexCoord(.08, .92, .08, .92)
			S:CreateBG(cu.Icon)
		end
	end

	S:CreateBD(QuestChoiceFrame)
	S:CreateSD(QuestChoiceFrame)
	S:ReskinClose(QuestChoiceFrame.CloseButton)
end

S:RegisterSkin("Blizzard_QuestChoice", LoadSkin)
