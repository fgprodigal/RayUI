----------------------------------------------------------
-- Load RayUI Environment
----------------------------------------------------------
RayUI:LoadEnv("Skins")

local S = _Skins

local function SkinProgressBar(line)
    local progressBar = line.ProgressBar
    local bar = progressBar.Bar
    local label = bar.Label
    local icon = bar.Icon

    icon:SetMask(nil)
    icon:SetDrawLayer("BORDER")

    if not progressBar.styled then
        bar.BarFrame:Kill()
        bar.BarBG:Kill()
        bar.IconBG:Kill()

        if icon:IsShown() then
            icon:ClearAllPoints()
            icon:SetPoint("RIGHT", 35, 2)
            S:ReskinIcon(icon)
        end

        bar:SetStatusBarTexture(R["media"].normal)
        R:SetStatusBarGradient(bar, true)

        label:ClearAllPoints()
        label:SetPoint("CENTER", 0, -1)
        label:FontTemplate(nil, nil, "OUTLINE")

        bar:CreateShadow("Background")

        progressBar.styled = true
    end
end

local function LoadSkin()
    local r, g, b = _r, _g, _b
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

        header:StripTextures()
        header.Text:FontTemplate(R["media"].font, R["media"].fontsize, "OUTLINE")
    end

    BONUS_OBJECTIVE_TRACKER_MODULE.Header:StripTextures()

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
                itemButton:SetNormalTexture(nil)
                itemButton:StyleButton(true)
                itemButton:CreateShadow("Background")

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

    hooksecurefunc(DEFAULT_OBJECTIVE_TRACKER_MODULE, "AddProgressBar", function(self, block, line, questID)
            local progressBar = self.usedProgressBars[block] and self.usedProgressBars[block][line]
            if not progressBar.Bar.styled then
                R:SetStatusBarGradient(progressBar.Bar, true)
                progressBar.Bar:CreateShadow("Background")
                progressBar.Bar:SetStatusBarTexture(R["media"].normal)
                progressBar.Bar:DisableDrawLayer("ARTWORK")
                progressBar.Bar.Label:SetDrawLayer("OVERLAY")
                progressBar.Bar.Label:FontTemplate(nil, nil, "OUTLINE")

                progressBar.Bar.styled = true
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

    -- [[ Bonus objective progress bar ]]

    hooksecurefunc(BONUS_OBJECTIVE_TRACKER_MODULE, "AddProgressBar", function(_, _, line)
            SkinProgressBar(line)
        end)

    WORLD_QUEST_TRACKER_MODULE.Header:StripTextures()
    WORLD_QUEST_TRACKER_MODULE.Header.Text:FontTemplate(R["media"].font, R["media"].fontsize, "OUTLINE")
    local bg = WORLD_QUEST_TRACKER_MODULE.Header:CreateTexture(nil, "ARTWORK")
    bg:SetTexture([[Interface\LFGFrame\UI-LFG-SEPARATOR]])
    bg:SetTexCoord(0, 0.6640625, 0, 0.3125)
    bg:SetVertexColor(r * 0.7, g * 0.7, b * 0.7)
    bg:SetPoint("BOTTOMLEFT", -30, -4)
    bg:SetSize(210, 30)

    hooksecurefunc(WORLD_QUEST_TRACKER_MODULE, "AddObjective", function(_, block)
            local itemButton = block.itemButton
            if itemButton and not itemButton.styled then
                itemButton:SetNormalTexture(nil)
                itemButton:StyleButton(true)
                itemButton:CreateShadow("Background")

                itemButton.HotKey:ClearAllPoints()
                itemButton.HotKey:SetPoint("TOP", itemButton, -1, 0)
                itemButton.HotKey:SetJustifyH("CENTER")
                itemButton.HotKey:FontTemplate(R["media"].font, R["media"].fontsize, "OUTLINE")

                itemButton.icon:SetTexCoord(.08, .92, .08, .92)
                S:CreateBG(itemButton)

                itemButton.styled = true
            end
        end)

    hooksecurefunc(WORLD_QUEST_TRACKER_MODULE, "AddProgressBar", function(_, _, line)
            SkinProgressBar(line)
        end)

    --Scenario Tracker ProgressBar
    hooksecurefunc(SCENARIO_TRACKER_MODULE, "AddProgressBar", function(_, _, line)
            if not line.ProgressBar.Bar.styled then
                R:SetStatusBarGradient(line.ProgressBar.Bar, true)
                line.ProgressBar.Bar:Height(18)
                line.ProgressBar.Bar:CreateShadow("Background")
                line.ProgressBar.Bar:SetStatusBarTexture(R["media"].normal)
                line.ProgressBar.Bar.BarFrame:Hide()
                line.ProgressBar.Bar.IconBG:SetAlpha(0)
                line.ProgressBar.Bar.BarFrame2:Hide()
                line.ProgressBar.Bar.BarFrame3:Hide()
                line.ProgressBar.Bar.Icon:ClearAllPoints()
                line.ProgressBar.Bar.Icon:SetPoint("LEFT", line.ProgressBar.Bar, "RIGHT", R.Border*3, 0)
                line.ProgressBar.Bar.Icon:SetMask("")
                line.ProgressBar.Bar.Icon:SetTexCoord(.08, .92, .08, .92)
                line.ProgressBar.Bar.Label:SetDrawLayer("OVERLAY")
                line.ProgressBar.Bar.Label:FontTemplate(nil, nil, "OUTLINE")

                line.ProgressBar.Bar.styled = true
            end
        end)
end

S:AddCallback("ObjectiveTracker", LoadSkin)
