local R, L, P, G = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, GlobalDB
local S = R:GetModule("Skins")

--form ElvUI

--Cache global variables
--Lua functions

--WoW API / Variables

--Global variables that we don't cache, list them here for mikk's FindGlobals script
-- GLOBALS: 

local function LoadSkin()
	--Quest Choise
	AdventureMapQuestChoiceDialog:StripTextures()
	S:SetBD(AdventureMapQuestChoiceDialog)

	-- Rewards
	local function SkinRewards()
		for reward in pairs(AdventureMapQuestChoiceDialog.rewardPool.activeObjects) do
			if not reward.isSkinned then
				S:CreateBD(reward)
				S:ReskinIcon(reward.Icon)
				reward.Icon:SetDrawLayer("OVERLAY")
				reward.ItemNameBG:Hide()
				reward.isSkinned = true
			end
		end
	end
	hooksecurefunc(AdventureMapQuestChoiceDialog, "RefreshRewards", SkinRewards)

	-- Quick Fix for the Font Color
	AdventureMapQuestChoiceDialog.Details.Child.TitleHeader:SetTextColor(1, 1, 0)
	AdventureMapQuestChoiceDialog.Details.Child.ObjectivesHeader:SetTextColor(1, 1, 0)

	--Buttons
	S:ReskinClose(AdventureMapQuestChoiceDialog.CloseButton)
	S:ReskinScroll(AdventureMapQuestChoiceDialog.Details.ScrollBar)
	S:Reskin(AdventureMapQuestChoiceDialog.AcceptButton)
	S:Reskin(AdventureMapQuestChoiceDialog.DeclineButton)
end

S:AddCallbackForAddon("Blizzard_AdventureMap", "AdventureMap", LoadSkin)
