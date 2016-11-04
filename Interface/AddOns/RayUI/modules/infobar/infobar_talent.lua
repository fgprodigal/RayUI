local R, L, P, G = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, GlobalDB
local IF = R:GetModule("InfoBar")
local LibQTip = LibStub("LibQTip-1.0")

--Cache global variables
--Lua functions
local ipairs, select, unpack = ipairs, select, unpack
local string = string
local wipe = table.wipe
local format = string.format

--WoW API / Variables
local GetSpecialization = GetSpecialization
local SetSpecialization = SetSpecialization
local GetNumSpecGroups = GetNumSpecGroups
local GetSpecializationInfo = GetSpecializationInfo
local GetNumSpecializations = GetNumSpecializations
local UnitLevel = UnitLevel
local GetActiveSpecGroup = GetActiveSpecGroup
local GetLootSpecialization = GetLootSpecialization
local GetSpecializationInfoByID = GetSpecializationInfoByID
local SetLootSpecialization = SetLootSpecialization
local TalentFrame_LoadUI = TalentFrame_LoadUI
local ShowUIPanel = ShowUIPanel
local HideUIPanel = HideUIPanel

--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: TALENTS, ACTIVE_PETS, NONE, NORMAL_FONT_COLOR, EQUIPMENT_MANAGER, PlayerTalentFrame, RayUI_InfobarTooltipFont
-- GLOBALS: SELECT_LOOT_SPECIALIZATION, UNKNOWN

local Tooltip
local ActiveColor = {0, 0.9, 0}
local InactiveColor = {0.3, 0.3, 0.3}

local function Tooltip_OnRelease(self)
    Tooltip:SetFrameStrata("TOOLTIP")
    Tooltip = nil
end

local function GetCurrentLootSpecName()
    local lsID = GetLootSpecialization()
    if (lsID == 0) then
        local specIndex = GetSpecialization()
        local _, specName = GetSpecializationInfo(specIndex)
        return specName or UNKNOWN
    else
        local _, specName = GetSpecializationInfoByID(lsID)
        return specName
    end
end

local function Spec_OnMouseUp(self, talentGroup)
    if GetSpecialization() == talentGroup then return end
    SetSpecialization(talentGroup)
end

local function LootSpec_OnMouseUp(self, talentGroup)
    if GetCurrentLootSpecName() == GetSpecializationInfo(talentGroup) then return end
    SetLootSpecialization(GetSpecializationInfo(talentGroup))
end

local function RenderTooltip(anchorFrame)
    local paddingLeft, paddingRight = 25, 25
    if not Tooltip then
        Tooltip = LibQTip:Acquire("RayUI_InfobarTalentTooltip", 1, "CENTER")
        Tooltip:SetAutoHideDelay(0.001, anchorFrame)
        Tooltip:SetBackdrop(nil)
        Tooltip:SmartAnchorTo(anchorFrame)
        Tooltip:SetHighlightTexture([[Interface\QuestFrame\UI-QuestTitleHighlight]])
        Tooltip:CreateShadow("Background")
        if not Tooltip.stripesthin then
            R:GetModule("Skins"):CreateStripesThin(Tooltip)
            Tooltip.stripesthin:SetInside(Tooltip, 1, 1)
        end

        Tooltip.OnRelease = Tooltip_OnRelease
    end
    Tooltip:Clear()

    -- Spec
    Tooltip:SetCell(Tooltip:AddLine(), 1, TALENTS, RayUI_InfobarTooltipFont)
    Tooltip:AddLine("")
    Tooltip:AddSeparator(1, 1, 1, 1, 0.8)

    local active = GetSpecialization()
    local numTalentGroups = GetNumSpecializations()

    for talentGroup = 1, numTalentGroups do
        local SpecColor = (active == talentGroup) and ActiveColor or InactiveColor
        local line = Tooltip:AddLine()
        Tooltip:SetCell(line, 1, R:RGBToHex(unpack(SpecColor))..string.format("|T%s:%d:%d:0:0:64:64:5:59:5:59|t %s", select(4, GetSpecializationInfo(talentGroup)), 12, 12, select(2, GetSpecializationInfo(talentGroup))), RayUI_InfobarTooltipFont, nil, nil, nil, paddingLeft, paddingRight)
        Tooltip:SetLineScript(line, "OnMouseUp", Spec_OnMouseUp, talentGroup)
    end
    Tooltip:AddLine(" ")

    --LootSpec
    Tooltip:SetCell(Tooltip:AddLine(), 1, SELECT_LOOT_SPECIALIZATION, RayUI_InfobarTooltipFont)
    Tooltip:AddLine("")
    Tooltip:AddSeparator(1, 1, 1, 1, 0.8)
    local curLootSpecName = GetCurrentLootSpecName()
    for talentGroup = 1, numTalentGroups do
        local SpecColor = (select(2, GetSpecializationInfo(talentGroup)) == curLootSpecName) and ActiveColor or InactiveColor
        local line = Tooltip:AddLine()
        Tooltip:SetCell(line, 1, R:RGBToHex(unpack(SpecColor))..string.format("|T%s:%d:%d:0:0:64:64:5:59:5:59|t %s", select(4, GetSpecializationInfo(talentGroup)), 12, 12, select(2, GetSpecializationInfo(talentGroup))), RayUI_InfobarTooltipFont, nil, nil, nil, paddingLeft, paddingRight)
        Tooltip:SetLineScript(line, "OnMouseUp", LootSpec_OnMouseUp, talentGroup )
    end

    Tooltip:Show()
    Tooltip:AddLine("")
    Tooltip:UpdateScrolling()
end

local function Spec_OnEnter(self)
    local numTalentGroups = GetNumSpecializations()

    if numTalentGroups > 0 and UnitLevel("player") >= 10 then
        RenderTooltip(self)
    end
end

local function Spec_Update(self)
    local numTalentGroups = GetNumSpecGroups()
    local active = GetActiveSpecGroup()
    local talent, loot = "", ""
    if GetSpecialization(false, false, active) then
        talent = format("|T%s:14:14:0:0:64:64:4:60:4:60|t", select(4, GetSpecializationInfo(GetSpecialization(false, false, active))) or "")
    end
    local specialization = GetLootSpecialization()
    if specialization == 0 then
        local specIndex = GetSpecialization();

        if specIndex then
            local specID, _, _, texture = GetSpecializationInfo(specIndex);
            loot = format("|T%s:14:14:0:0:64:64:4:60:4:60|t", texture or "")
        else
            loot = "N/A"
        end
    else
        local specID, _, _, texture = GetSpecializationInfoByID(specialization);
        if specID then
            loot = format("|T%s:14:14:0:0:64:64:4:60:4:60|t", texture or "")
        else
            loot = "N/A"
        end
    end
    if GetSpecialization(false, false, active) and select(2, GetSpecializationInfo(GetSpecialization(false, false, active))) then
        self:SetText(format("%s: %s | %s", TALENTS, talent, loot))
    else
        self:SetText(NONE..TALENTS)
    end
end

local function Spec_OnEvent(self)
    Spec_Update(self)
    if Tooltip and Tooltip:IsShown() then
        RenderTooltip(self)
    end
end

local function Spec_OnClick(self, button)
    local specIndex = GetSpecialization()
    if UnitLevel("player") <10 then return end
    if not specIndex then return end

    if not PlayerTalentFrame then
        TalentFrame_LoadUI()
    end

    if not PlayerTalentFrame:IsShown() then
        ShowUIPanel(PlayerTalentFrame)
    else
        HideUIPanel(PlayerTalentFrame)
    end
end

do -- Initialize
    local info = {}

    info.title = TALENTS
    info.icon = 132222
    info.clickFunc = Spec_OnClick
    info.events = { "PLAYER_ENTERING_WORLD", "CHARACTER_POINTS_CHANGED", "PLAYER_TALENT_UPDATE", "ACTIVE_TALENT_GROUP_CHANGED", "PLAYER_LOOT_SPEC_UPDATED" }
    info.eventFunc = Spec_OnEvent
    info.initFunc = Spec_OnEvent
    info.tooltipFunc = Spec_OnEnter

    IF:RegisterInfoBarType("Talent", info)
end
