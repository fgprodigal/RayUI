local R, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local S = R:GetModule("Skins")

local function LoadSkin()
	local r, g, b = S["media"].classcolours[R.myclass].r, S["media"].classcolours[R.myclass].g, S["media"].classcolours[R.myclass].b
	local ot = ObjectiveTrackerFrame
	local BlocksFrame = ot.BlocksFrame

	-- [[ Header ]]

	-- Header

	ot.HeaderMenu.Title:FontTemplate(R["media"].font, R["media"].fontsize, "OUTLINE")

	-- Minimize button

	local minimizeButton = ot.HeaderMenu.MinimizeButton

	S:ReskinExpandOrCollapse(minimizeButton)
	minimizeButton:SetSize(15, 15)
	minimizeButton.plus:Hide()

	hooksecurefunc("ObjectiveTracker_Collapse", function()
		minimizeButton.plus:Show()
	end)
	hooksecurefunc("ObjectiveTracker_Expand", function()
		minimizeButton.plus:Hide()
	end)

	-- [[ Blocks and lines ]]

	for _, headerName in pairs({"QuestHeader", "AchievementHeader", "ScenarioHeader"}) do
		local header = BlocksFrame[headerName]

		header.Background:Hide()
		header.Text:FontTemplate(R["media"].font, R["media"].fontsize, "OUTLINE")
	end

	hooksecurefunc(DEFAULT_OBJECTIVE_TRACKER_MODULE, "SetBlockHeader", function(_, block)
		if not block.headerStyled then
			block.HeaderText:FontTemplate(R["media"].font, R["media"].fontsize, "OUTLINE")
			block.headerStyled = true
		end
	end)

	hooksecurefunc(QUEST_TRACKER_MODULE, "SetBlockHeader", function(_, block)
		if not block.headerStyled then
			block.HeaderText:FontTemplate(R["media"].font, R["media"].fontsize, "OUTLINE")
			block.headerStyled = true
		end

		local itemButton = block.itemButton

		if itemButton and not itemButton.styled then
			itemButton:SetNormalTexture("")
			itemButton:SetPushedTexture("")

			itemButton.HotKey:ClearAllPoints()
			itemButton.HotKey:SetPoint("TOP", itemButton, -1, 0)
			itemButton.HotKey:SetJustifyH("CENTER")
			itemButton.HotKey:FontTemplate(R["media"].font, R["media"].fontsize, "OUTLINE")

			itemButton.icon:SetTexCoord(.08, .92, .08, .92)
			S:CreateBG(itemButton)

			itemButton.styled = true
		end
	end)

	hooksecurefunc(DEFAULT_OBJECTIVE_TRACKER_MODULE, "AddObjective", function(self, block)
		if block.module == QUEST_TRACKER_MODULE or block.module == ACHIEVEMENT_TRACKER_MODULE then
			local line = block.currentLine

			local p1, a, p2, x, y = line:GetPoint()
			line:SetPoint(p1, a, p2, x, y - 4)
		end
	end)

	local function fixBlockHeight(block)
		if block.shouldFix then
			local height = block:GetHeight()

			if block.lines then
				for _, line in pairs(block.lines) do
					if line:IsShown() then
						height = height + 4
					end
				end
			end

			block.shouldFix = false
			block:SetHeight(height + 5)
			block.shouldFix = true
		end
	end

	hooksecurefunc("ObjectiveTracker_AddBlock", function(block)
		if block.lines then
			for _, line in pairs(block.lines) do
				if not line.styled then
					line.Text:FontTemplate(R["media"].font, R["media"].fontsize, "OUTLINE")
					line.Text:SetSpacing(2)

					if line.Dash then
						line.Dash:FontTemplate(R["media"].font, R["media"].fontsize, "OUTLINE")
					end

					line:SetHeight(line.Text:GetHeight())

					line.styled = true
				end
			end
		end

		if not block.styled then
			block.shouldFix = true
			hooksecurefunc(block, "SetHeight", fixBlockHeight)
			block.styled = true
		end
	end)
end

S:RegisterSkin("RayUI", LoadSkin)