----------------------------------------------------------
-- Load RayUI Environment
----------------------------------------------------------
RayUI:LoadEnv("Misc")


local M = _Misc
local mod = M:NewModule("Exprepbar", "AceEvent-3.0")
local libAD = LibStub("LibArtifactData-1.0")


local function AddPerks()
    local _, traits = libAD:GetArtifactTraits()
    for _, data in pairs(traits) do
        local r,g,b = 1,1,1

        if data.bonusRanks > 0 then
            r,g,b = 0.4,1,0
        end

        if data.currentRank > 0 and not data.isStart then
            GameTooltip:AddDoubleLine(data.name, data.currentRank.."/"..data.maxRank, 1,1,1, r,g,b)
        end
    end
end

local function Bar_OnShow(self)
    self:SetPoint("TOPLEFT", self.anchorFrame, "BOTTOMLEFT", 0, -4)
    self:SetPoint("TOPRIGHT", self.anchorFrame, "BOTTOMRIGHT", 0, -4)
end

local function Bar_OnHide(self)
    self:SetPoint("TOPLEFT", self.anchorFrame, "BOTTOMLEFT", 0, self.height)
    self:SetPoint("TOPRIGHT", self.anchorFrame, "BOTTOMRIGHT", 0, self.height)
end

function mod:CreateBar(name, anchorFrame, height)
    local bar = CreateFrame("StatusBar", name, R.UIParent, "AnimatedStatusBarTemplate")
    bar:CreateShadow("Background")
    bar:SetFrameLevel(3)
    bar:SetHeight(height)
    bar.height = height
    bar:SetStatusBarTexture(R.media.normal)
    bar.anchorFrame = anchorFrame
    bar:SetScript("OnShow", Bar_OnShow)
    bar:SetScript("OnHide", Bar_OnHide)
    Bar_OnShow(bar)

    R.FrameLocks[name] = { parent = R.UIParent, strata = bar:GetFrameStrata() }
    return bar
end

function mod:CreateExpBar()
    self.ExpBar = self:CreateBar("RayUIExpBar", Minimap, 8)
    self.ExpBar:SetStatusBarColor(.5, 0, .75)
    R:SetStatusBarGradient(self.ExpBar)
    self.ExpBar:SetAnimatedTextureColors(0.0, 0.39, 0.88, 1.0)

    self.ExpBar.RestedExpBar = CreateFrame("StatusBar", nil, self.ExpBar)
    self.ExpBar.RestedExpBar:SetAllPoints()
    self.ExpBar.RestedExpBar:SetStatusBarTexture(R.media.normal)
    self.ExpBar.RestedExpBar:SetStatusBarColor(0, .4, .8)
    R:SetStatusBarGradient(self.ExpBar.RestedExpBar)
    self.ExpBar.RestedExpBar:SetFrameLevel(2)

    self.ExpBar:SetScript("OnEvent", self.UpdateExpBar)
    self.ExpBar:RegisterEvent("PLAYER_LEVEL_UP")
    self.ExpBar:RegisterEvent("PLAYER_XP_UPDATE")
    self.ExpBar:RegisterEvent("UPDATE_EXHAUSTION")
    self.ExpBar:RegisterEvent("UPDATE_EXPANSION_LEVEL")
    self.ExpBar:RegisterEvent("PLAYER_ENTERING_WORLD")

    self.ExpBar:SetScript("OnEnter", function(self)
            local min, max = UnitXP("player"), UnitXPMax("player")
            local rest = GetXPExhaustion()

            GameTooltip:SetOwner(self, "ANCHOR_BOTTOM", 0, -5)
            GameTooltip:AddDoubleLine(XP, format("%s/%s (%d%%)", min, max, min / max * 100), NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)
            GameTooltip:AddDoubleLine(L["剩余"], format("%d (%d%%)", max - min, (max - min) / max * 100), NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)
            if rest then
                GameTooltip:AddDoubleLine(L["双倍"], format("%d (%d%%)", rest, rest / max * 100), 0, .56, 1, HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)
            end
            GameTooltip:Show()
        end)

    self.ExpBar:SetScript("OnLeave", function()
            GameTooltip:Hide()
        end)
end

function mod:UpdateExpBar()
    local XP, maxXP = UnitXP("player"), UnitXPMax("player")
    local restXP = GetXPExhaustion()
    local maxLevel = MAX_PLAYER_LEVEL_TABLE[GetExpansionLevel()]

    if UnitLevel("player") == maxLevel then
        self:Hide()
        self.RestedExpBar:Hide()
    else
        self:SetAnimatedValues(XP, 0, maxXP, UnitLevel("player"))

        if restXP then
            self.RestedExpBar:Show()
            self.RestedExpBar:SetMinMaxValues(min(0, XP), maxXP)
            self.RestedExpBar:SetValue(XP+restXP)
        else
            self.RestedExpBar:Hide()
        end
        self:Show()
    end
end

function mod:CreateHonorBar()
    self.HonorBar = self:CreateBar("RayUIHonorBar", self.ExpBar, 8)

    self.HonorBar:SetScript("OnEvent", self.UpdateHonorBar)
    self.HonorBar:RegisterEvent("HONOR_XP_UPDATE")
    self.HonorBar:RegisterEvent("HONOR_PRESTIGE_UPDATE")
    self.HonorBar:RegisterEvent("PLAYER_ENTERING_WORLD")

    self.HonorBar:SetScript("OnEnter", function(self)
            GameTooltip:ClearLines()
            GameTooltip:SetOwner(self, "ANCHOR_BOTTOM", 0, -5)

            local current = UnitHonor("player");
            local max = UnitHonorMax("player");
            local level = UnitHonorLevel("player")
            local levelmax = GetMaxPlayerHonorLevel()

            GameTooltip:AddLine(HONOR)
            GameTooltip:SetPrevLineJustify("CENTER")
            GameTooltip:AddDivider()

            if (CanPrestige()) then
                GameTooltip:AddLine(PVP_HONOR_PRESTIGE_AVAILABLE)
                GameTooltip:AddDivider()
            end
            GameTooltip:AddDoubleLine(HONOR_LEVEL_LABEL:gsub("%%d",""), level, 1, 1, 1)
            GameTooltip:AddLine(" ")

            if (CanPrestige()) then
                GameTooltip:AddLine(PVP_HONOR_PRESTIGE_AVAILABLE);
            elseif (level == levelmax) then
                GameTooltip:AddLine(MAX_HONOR_LEVEL);
            else
                GameTooltip:AddDoubleLine(HONOR_BAR:gsub("%%d/%%d",""), format('%d / %d (%d%%)', current, max, current/max * 100), 1, 1, 1)
                GameTooltip:AddDoubleLine(L["剩余"], format("%d (%d%%)", max - current, (max - current) / max * 100), 1, 1, 1)
            end
            GameTooltip:Show()
        end)

    self.HonorBar:SetScript("OnLeave", function()
            GameTooltip:Hide()
        end)
end

function mod:UpdateHonorBar()
    local level = UnitHonorLevel("player")
    local levelmax = GetMaxPlayerHonorLevel()
    if UnitLevel("player") < MAX_PLAYER_LEVEL or level == levelmax then
        self:Hide()
    else
        self:Show()
        local current = UnitHonor("player")
        local max = UnitHonorMax("player")

        if (level == levelmax) then
            self:SetAnimatedValues(1, 0, 1, level)
        else
            self:SetAnimatedValues(current, 0, max, level)
        end

        local exhaustionStateID = GetHonorRestState()
        if (exhaustionStateID == 1) then
            self:SetStatusBarColor(1.0, 0.71, 0)
            R:SetStatusBarGradient(self)
            self:SetAnimatedTextureColors(1.0, 0.71, 0)
        else
            self:SetStatusBarColor(1.0, 0.24, 0)
            R:SetStatusBarGradient(self)
            self:SetAnimatedTextureColors(1.0, 0.24, 0)
        end
    end
end

function mod:CreateRepBar()
    self.RepBar = self:CreateBar("RayUIRepBar", self.HonorBar, 8)

    self.RepBar:SetScript("OnEvent", self.UpdateRepBar)
    self.RepBar:RegisterEvent("CHAT_MSG_COMBAT_FACTION_CHANGE")
    self.RepBar:RegisterEvent("UPDATE_FACTION")
    self.RepBar:RegisterEvent("PLAYER_ENTERING_WORLD")

    self.RepBar:SetScript("OnEnter", function(self)
            local name, rank, start, cap, value, factionID = GetWatchedFactionInfo()
            if (C_Reputation.IsFactionParagon(factionID)) then
                local currentValue, threshold = C_Reputation.GetFactionParagonInfo(factionID)
                start, cap, value = 0, threshold, currentValue
            end
            local friendID, friendRep, friendMaxRep, friendName, friendText, friendTexture, friendTextLevel, friendThreshold, nextFriendThreshold = GetFriendshipReputation(factionID)
            GameTooltip:SetOwner(self, "ANCHOR_BOTTOM", 0, -5)
            GameTooltip:ClearLines()
            GameTooltip:AddLine(name)
            GameTooltip:SetPrevLineJustify("CENTER")
            GameTooltip:AddDivider()
            if friendID then
                rank = 8
                GameTooltip:AddDoubleLine(STANDING, friendTextLevel, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, RayUF["colors"].reaction[rank][1], RayUF["colors"].reaction[rank][2], RayUF["colors"].reaction[rank][3])
            else
                GameTooltip:AddDoubleLine(STANDING, _G["FACTION_STANDING_LABEL"..rank], NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, RayUF["colors"].reaction[rank][1], RayUF["colors"].reaction[rank][2], RayUF["colors"].reaction[rank][3])
            end
            GameTooltip:AddDoubleLine(REPUTATION, string.format("%s/%s (%d%%)", value-start, cap-start, (value-start)/(cap-start)*100), NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, 1, 1, 1)
            GameTooltip:AddDoubleLine(L["剩余"], string.format("%s", cap-value), NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, 1, 1, 1)
            GameTooltip:Show()
        end)

    self.RepBar:SetScript("OnLeave", function()
            GameTooltip:Hide()
        end)

    self.RepBar:SetScript("OnMouseUp", function(self)
            GameTooltip:Hide()
            ToggleCharacter("ReputationFrame")
        end)
end

function mod:UpdateRepBar()
    local friendID, friendRep, friendMaxRep, friendName, friendText, friendTexture, friendTextLevel, friendThreshold, nextFriendThreshold
    if GetWatchedFactionInfo() then
        local name, rank, min, max, value, factionID = GetWatchedFactionInfo()
        if (C_Reputation.IsFactionParagon(factionID)) then
            local currentValue, threshold = C_Reputation.GetFactionParagonInfo(factionID)
            min, max, value = 0, threshold, currentValue
        end
        local level
        if ( ReputationWatchBar.friendshipID ) then
            friendID, friendRep, friendMaxRep, friendName, friendText, friendTexture, friendTextLevel, friendThreshold, nextFriendThreshold = GetFriendshipReputation(factionID)
            level = GetFriendshipReputationRanks(factionID)
            if ( nextFriendThreshold ) then
                min, max, value = friendThreshold, nextFriendThreshold, friendRep
            else
                min, max, value = 0, 1, 1
            end
        else
            level = rank
        end
        max = max - min
        value = value - min
        min = 0
        self:SetAnimatedValues(value, min, max, level)
        if friendID then
            rank = 8
        end
        self:SetStatusBarColor(unpack(RayUF["colors"].reaction[rank]))
        R:SetStatusBarGradient(self)
        self:SetAnimatedTextureColors(unpack(RayUF["colors"].reaction[rank]))
        self:Show()
    else
        self:Hide()
    end
end

function mod:CreateArtiBar()
    self.ArtiBar = self:CreateBar("RayUIArtiBar", self.RepBar, 8)
    self.ArtiBar:SetStatusBarColor(.901, .8, .601)
    R:SetStatusBarGradient(self.ArtiBar)
    self.ArtiBar:Hide()

    libAD.RegisterCallback(self, "ARTIFACT_POWER_CHANGED", "UpdateArtiBar")
    libAD.RegisterCallback(self, "ARTIFACT_ADDED", "UpdateArtiBar")
    libAD.RegisterCallback(self, "ARTIFACT_ACTIVE_CHANGED", "UpdateArtiBar")
    self.ArtiBar:SetScript("OnEvent", function() self:UpdateArtiBar() end)
    self.ArtiBar:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")

    self.ArtiBar:SetScript("OnEnter", function(self)
            if HasArtifactEquipped() then
                local _, data = libAD:GetArtifactInfo()

                GameTooltip:SetOwner(self, "ANCHOR_BOTTOM", 0, -5)
                GameTooltip:AddLine(string.format("%s (%s %d)", data.name, LEVEL, data.numRanksPurchased))
                GameTooltip:SetPrevLineJustify("CENTER")
                GameTooltip:AddDivider()
                GameTooltip:AddLine(ARTIFACT_POWER_TOOLTIP_TITLE:format(BreakUpLargeNumbers(data.unspentPower), BreakUpLargeNumbers(data.power), BreakUpLargeNumbers(data.maxPower)), 1, 1, 1)
                if data.numRanksPurchasable > 0 then
                    GameTooltip:AddLine(" ")
                    GameTooltip:AddLine(ARTIFACT_POWER_TOOLTIP_BODY:format(data.numRanksPurchasable), 0, 1, 0, true)
                end

                AddPerks()

                GameTooltip:Show()
            end
        end)

    self.ArtiBar:SetScript("OnLeave", function()
            GameTooltip:Hide()
        end)

    self.ArtiBar:SetScript("OnMouseUp", function(self)
            if not ArtifactFrame or not ArtifactFrame:IsShown() then
                ShowUIPanel(SocketInventoryItem(16))
            elseif ArtifactFrame and ArtifactFrame:IsShown() then
                HideUIPanel(ArtifactFrame)
            end
        end)
end

function mod:UpdateArtiBar()
    if HasArtifactEquipped() then
        local _, data = libAD:GetArtifactInfo()
        if not data.numRanksPurchased then return end
        self.ArtiBar:SetAnimatedValues(data.power, 0, data.maxPower, data.numRanksPurchasable + data.numRanksPurchased)
        self.ArtiBar:Show()
    else
        self.ArtiBar:Hide()
    end
end

function mod:Initialize()
    self:CreateExpBar()
    self:CreateHonorBar()
    self:CreateRepBar()
    self:CreateArtiBar()
end

M:RegisterMiscModule(mod:GetName())
