local R, L, P, G = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, GlobalDB
local IF = R:GetModule("InfoBar")
local LibQTip = LibStub("LibQTip-1.0")

--Cache global variables
--Lua functions
local select = select
local floor, min, max = math.floor, math.min, math.max
local format = string.format

--WoW API / Variables
local GetNetStats = GetNetStats
local GetFramerate = GetFramerate

--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: MILLISECONDS_ABBR, RayUI_InfobarTooltipFont, HOME, CHANNEL_CATEGORY_WORLD, FPS_FORMAT

local Tooltip
local LatencyColor = {
    [1] = "007FFF", -- Blue
    [2] = "00FF00", -- Green
    [3] = "FFFF00", -- Yellow
    [4] = "FF7F00", -- Orange
    [5] = "FF0000", -- Red
}
local SysStats = {
    netTally = 0,
    bwIn = {cur = 0, tally = {}, avg = 0, min = 0, max = 0},
    bwOut = {cur = 0, tally = {}, avg = 0, min = 0, max = 0},
    lagHome = {cur = 0, tally = {}, avg = 0, min = 0, max = 0},
    lagWorld = {cur = 0, tally = {}, avg = 0, min = 0, max = 0},
    fpsTally = -5,
    fps = {cur = 0, tally = {}, avg = 0, min = 0, max = 0},
}

local function GetColorCode(value)
    local index

    if value > 250 then
        index = 5
    elseif value > 100 then
        index = 4
    elseif value > 50 then
        index = 3
    elseif value > 25 then
        index = 2
    else
        index = 1
    end

    return LatencyColor[index]
end

local function GetFPSColorCode(value)
    local index

    if value > 50 then
        index = 2
    elseif value > 30 then
        index = 3
    elseif value > 15 then
        index = 4
    else
        index = 5
    end
    return LatencyColor[index]
end

local function Tooltip_OnRelease(self)
    Tooltip:SetFrameStrata("TOOLTIP")
    Tooltip = nil
end

local function RenderTooltip(anchorFrame)
    local paddingLeft, paddingRight = 5, 5
    if not Tooltip then
        Tooltip = LibQTip:Acquire("RayUI_InfobarNetworkTooltip", 5, "CENTER", "CENTER", "CENTER", "CENTER", "CENTER")
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

    -- Network
    Tooltip:SetCell(Tooltip:AddLine(), 1, L["网络"], RayUI_InfobarTooltipFont, 5)
    Tooltip:AddLine("")

    local headerLine = Tooltip:AddLine()
    Tooltip:SetCell(headerLine, 1, L["状态"], RayUI_InfobarTooltipFont, nil, nil, nil, paddingLeft, paddingRight)
    Tooltip:SetCell(headerLine, 2, L["当前"], RayUI_InfobarTooltipFont, nil, nil, nil, paddingLeft + 10, paddingRight + 10)
    Tooltip:SetCell(headerLine, 3, L["最大"], RayUI_InfobarTooltipFont, nil, nil, nil, paddingLeft + 10, paddingRight + 10)
    Tooltip:SetCell(headerLine, 4, L["最小"], RayUI_InfobarTooltipFont, nil, nil, nil, paddingLeft + 10, paddingRight + 10)
    Tooltip:SetCell(headerLine, 5, L["平均"], RayUI_InfobarTooltipFont, nil, nil, nil, paddingLeft + 10, paddingRight + 10)
    Tooltip:SetLineTextColor(headerLine, 0.9, 0.8, 0.7)
    Tooltip:AddSeparator(1, 1, 1, 1, 0.8)

    local NetworkLines = {
        [1] = {L["下行"], "kbps", "%.2f", SysStats.bwIn},
        [2] = {L["上行"], "kbps", "%.2f", SysStats.bwOut},
        [3] = {HOME , "ms", "%d", SysStats.lagHome},
        [4] = {CHANNEL_CATEGORY_WORLD, "ms", "%d", SysStats.lagWorld},
    }
    for l = 1, #NetworkLines do
        local line = Tooltip:AddLine()
        Tooltip:SetCell(line, 1, ("|cffe5e5e5%s|r |cff808080(%s)|r"):format(NetworkLines[l][1], NetworkLines[l][2]), RayUI_InfobarTooltipFont, "LEFT", nil, nil, paddingLeft, paddingRight)
        Tooltip:SetCell(line, 2, NetworkLines[l][3]:format(NetworkLines[l][4].cur), RayUI_InfobarTooltipFont, nil, nil, nil, paddingLeft, paddingRight)
        Tooltip:SetCell(line, 3, NetworkLines[l][3]:format(NetworkLines[l][4].max), RayUI_InfobarTooltipFont, nil, nil, nil, paddingLeft, paddingRight)
        Tooltip:SetCell(line, 4, NetworkLines[l][3]:format(NetworkLines[l][4].min), RayUI_InfobarTooltipFont, nil, nil, nil, paddingLeft, paddingRight)
        Tooltip:SetCell(line, 5, NetworkLines[l][3]:format(NetworkLines[l][4].avg), RayUI_InfobarTooltipFont, nil, nil, nil, paddingLeft, paddingRight)
    end
    Tooltip:AddLine("")

    -- FPS
    Tooltip:SetCell(Tooltip:AddLine(), 1, L["电脑"], RayUI_InfobarTooltipFont, 5)
    Tooltip:AddLine("")

    local headerLine = Tooltip:AddLine()
    Tooltip:SetCell(headerLine, 1, L["状态"], RayUI_InfobarTooltipFont, nil, nil, nil, paddingLeft, paddingRight)
    Tooltip:SetCell(headerLine, 2, L["当前"], RayUI_InfobarTooltipFont, nil, nil, nil, paddingLeft + 10, paddingRight + 10)
    Tooltip:SetCell(headerLine, 3, L["最大"], RayUI_InfobarTooltipFont, nil, nil, nil, paddingLeft + 10, paddingRight + 10)
    Tooltip:SetCell(headerLine, 4, L["最小"], RayUI_InfobarTooltipFont, nil, nil, nil, paddingLeft + 10, paddingRight + 10)
    Tooltip:SetCell(headerLine, 5, L["平均"], RayUI_InfobarTooltipFont, nil, nil, nil, paddingLeft + 10, paddingRight + 10)
    Tooltip:SetLineTextColor(headerLine, 0.9, 0.8, 0.7)
    Tooltip:AddSeparator(1, 1, 1, 1, 0.8)

    local ComputerLines = {
        [1] = {"FPS", SysStats.fps},
    }
    for l = 1, #ComputerLines do
        local line = Tooltip:AddLine()
        Tooltip:SetCell(line, 1, ("|cffe5e5e5%s|r"):format(ComputerLines[l][1]), RayUI_InfobarTooltipFont, "LEFT", nil, nil, paddingLeft, paddingRight)
        Tooltip:SetCell(line, 2, ComputerLines[l][2].cur, RayUI_InfobarTooltipFont, nil, nil, nil, paddingLeft, paddingRight)
        Tooltip:SetCell(line, 3, ComputerLines[l][2].max, RayUI_InfobarTooltipFont, nil, nil, nil, paddingLeft, paddingRight)
        Tooltip:SetCell(line, 4, ComputerLines[l][2].min, RayUI_InfobarTooltipFont, nil, nil, nil, paddingLeft, paddingRight)
        Tooltip:SetCell(line, 5, ComputerLines[l][2].avg, RayUI_InfobarTooltipFont, nil, nil, nil, paddingLeft, paddingRight)
    end

    Tooltip:Show()
    Tooltip:AddLine("")
    Tooltip:UpdateScrolling()
end

local timer = 1
local function Latency_OnUpdate(self)
    timer = timer + 1
    if timer > 5 then
        timer = 1
        SysStats.bwIn.cur, SysStats.bwOut.cur, SysStats.lagHome.cur, SysStats.lagWorld.cur = GetNetStats()
        if SysStats.lagHome.cur == 0 or SysStats.lagWorld.cur == 0 then return end
        SysStats.bwIn.cur = floor(SysStats.bwIn.cur * 100 + 0.5 ) / 100
        SysStats.bwOut.cur = floor(SysStats.bwOut.cur * 100 + 0.5 ) / 100

        -- Get last 60 net updates
        local netCount = 60
        if SysStats.netTally < netCount then
            -- Tally up to 60
            SysStats.netTally = SysStats.netTally + 1

            SysStats.bwIn.tally[SysStats.netTally] = SysStats.bwIn.cur
            SysStats.bwOut.tally[SysStats.netTally] = SysStats.bwOut.cur
            SysStats.lagHome.tally[SysStats.netTally] = SysStats.lagHome.cur
            SysStats.lagWorld.tally[SysStats.netTally] = SysStats.lagWorld.cur

            netCount = SysStats.netTally
        else
            -- Shift our tally table down by 1
            for i = 1, netCount - 1 do
                SysStats.bwIn.tally[i] = SysStats.bwIn.tally[i + 1]
                SysStats.bwOut.tally[i] = SysStats.bwOut.tally[i + 1]
                SysStats.lagHome.tally[i] = SysStats.lagHome.tally[i + 1]
                SysStats.lagWorld.tally[i] = SysStats.lagWorld.tally[i + 1]
            end
            -- Store new values
            SysStats.bwIn.tally[netCount] = SysStats.bwIn.cur
            SysStats.bwOut.tally[netCount] = SysStats.bwOut.cur
            SysStats.lagHome.tally[netCount] = SysStats.lagHome.cur
            SysStats.lagWorld.tally[netCount] = SysStats.lagWorld.cur
        end

        -- Get Average/Min/Max
        local minBwIn, maxBwIn, totalBwIn = nil, 0, 0
        local minBwOut, maxBwOut, totalBwOut = nil, 0, 0
        local minLagHome, maxLagHome, totalLagHome = nil, 0, 0
        local minLagWorld, maxLagWorld, totalLagWorld = nil, 0, 0

        for i = 1, netCount do
            totalBwIn = totalBwIn + SysStats.bwIn.tally[i]
            if not minBwIn then minBwIn = SysStats.bwIn.tally[i] else minBwIn = min(minBwIn, SysStats.bwIn.tally[i]) end
            maxBwIn = max(maxBwIn, SysStats.bwIn.tally[i])

            totalBwOut = totalBwOut + SysStats.bwOut.tally[i]
            if not minBwOut then minBwOut = SysStats.bwOut.tally[i] else minBwOut = min(minBwOut, SysStats.bwOut.tally[i]) end
            maxBwOut = max(maxBwOut, SysStats.bwOut.tally[i])

            totalLagHome = totalLagHome + SysStats.lagHome.tally[i]
            if not minLagHome then minLagHome = SysStats.lagHome.tally[i] else minLagHome = min(minLagHome, SysStats.lagHome.tally[i]) end
            maxLagHome = max(maxLagHome, SysStats.lagHome.tally[i])

            totalLagWorld = totalLagWorld + SysStats.lagWorld.tally[i]
            if not minLagWorld then minLagWorld = SysStats.lagWorld.tally[i] else minLagWorld = min(minLagWorld, SysStats.lagWorld.tally[i]) end
            maxLagWorld = max(maxLagWorld, SysStats.lagWorld.tally[i])
        end

        SysStats.bwIn.avg = floor((totalBwIn / netCount) * 100 + 0.5) / 100
        SysStats.bwIn.min = minBwIn
        SysStats.bwIn.max = maxBwIn

        SysStats.bwOut.avg = floor((totalBwOut / netCount) * 100 + 0.5) / 100
        SysStats.bwOut.min = minBwOut
        SysStats.bwOut.max = maxBwOut

        SysStats.lagHome.avg = floor((totalLagHome / netCount) + 0.5)
        SysStats.lagHome.min = minLagHome
        SysStats.lagHome.max = maxLagHome

        SysStats.lagWorld.avg = floor((totalLagWorld / netCount) + 0.5)
        SysStats.lagWorld.min = minLagWorld
        SysStats.lagWorld.max = maxLagWorld
    else
        SysStats.fps.cur = floor((GetFramerate() or 0) + 0.5)
        if SysStats.fps.cur == 0 then return end

        -- Get last 60 second data
        if ( (SysStats.fps.cur > 0) and (SysStats.fps.cur < 120) ) then
            if SysStats.fpsTally < 0 then
                -- Skip first 5 seconds upon login
                SysStats.fpsTally = SysStats.fpsTally + 1
            else
                local fpsCount = 60
                if SysStats.fpsTally < fpsCount then
                    -- fpsCount up to our 60-sec of total tallying
                    SysStats.fpsTally = SysStats.fpsTally + 1
                    SysStats.fps.tally[SysStats.fpsTally] = SysStats.fps.cur
                    fpsCount = SysStats.fpsTally
                else
                    -- Shift our tally table down by 1
                    for i = 1, fpsCount - 1 do
                        SysStats.fps.tally[i] = SysStats.fps.tally[i + 1]
                    end
                    SysStats.fps.tally[fpsCount] = SysStats.fps.cur
                end

                -- Get Average/Min/Max fps
                local minfps, maxfps, totalfps = nil, 0, 0
                for i = 1, fpsCount do
                    totalfps = totalfps + SysStats.fps.tally[i]
                    if not minfps then minfps = SysStats.fps.tally[i] else minfps = min(minfps, SysStats.fps.tally[i]) end
                    maxfps = max(maxfps, SysStats.fps.tally[i])
                end
                SysStats.fps.avg = floor((totalfps / fpsCount) + 0.5)
                SysStats.fps.min = minfps
                SysStats.fps.max = maxfps
            end
        end
    end

    local world = format("|cFF%s%d|r", GetColorCode(SysStats.lagWorld.cur), SysStats.lagWorld.cur)
    if Tooltip and Tooltip:IsShown() then
        RenderTooltip(self)
    end
    self:SetText(format("|cFF%s%d|rfps %sms", GetFPSColorCode(SysStats.fps.cur), SysStats.fps.cur, world))
end

do -- Initialize
    local info = {}

    info.title = L["系统信息"]
    info.icon = "Interface\\Icons\\spell_frost_stun"
    --info.icon = "Interface\\Icons\\ability_creature_cursed_04"
    info.interval = 1
    info.onUpdate = Latency_OnUpdate
    info.tooltipFunc = RenderTooltip

    IF:RegisterInfoBarType("System", info)
end
