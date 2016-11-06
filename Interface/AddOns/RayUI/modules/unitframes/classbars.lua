-- ClassBar from ElvUI
local R, L, P, G = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, GlobalDB
local UF = R:GetModule("UnitFrames")
local oUF = RayUF or oUF

--Cache global variables
--Lua functions
local unpack = unpack
local max, floor = math.max, math.floor
local strsub, strfind, gsub = string.sub, string.find, string.gsub

--WoW API / Variables
local CreateFrame = CreateFrame

--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: RayUF, MAX_COMBO_POINTS

function UF:Configure_ClassBar(frame, cur)
    local bars = frame[frame.ClassBar]
    if not bars then return end

    bars.origParent = frame
    frame.CLASSBAR_HEIGHT = frame.CLASSBAR_HEIGHT or 5
    local CLASSBAR_WIDTH = 200
    frame.BORDER = 1
    frame.SPACING = -2

    bars:Width(CLASSBAR_WIDTH)
    bars:Height(frame.CLASSBAR_HEIGHT)

    if (frame.ClassBar == "ClassIcons" or frame.ClassBar == "Runes") then
        if frame.ClassBar == "ClassIcons" and not cur then
            cur = 0
        end
        local maxClassBarButtons = max(UF.classMaxResourceBar[R.myclass] or 0, MAX_COMBO_POINTS)
        for i = 1, maxClassBarButtons do
            bars[i]:Hide()

            if i <= frame.MAX_CLASS_BAR then
                bars[i]:Height(bars:GetHeight())
                if frame.MAX_CLASS_BAR == 1 then
                    bars[i]:SetWidth(CLASSBAR_WIDTH)
                elseif frame.USE_MINI_CLASSBAR then
                    bars[i]:SetWidth((CLASSBAR_WIDTH - ((5 + (frame.BORDER*2 + frame.SPACING*2))*(frame.MAX_CLASS_BAR - 1)))/frame.MAX_CLASS_BAR) --Width accounts for 5px spacing between each button, excluding borders
                elseif i ~= frame.MAX_CLASS_BAR then
                    bars[i]:Width((CLASSBAR_WIDTH - ((frame.MAX_CLASS_BAR-1)*(frame.BORDER-frame.SPACING))) / frame.MAX_CLASS_BAR) --classbar width minus total width of dividers between each button, divided by number of buttons
                end

                bars[i]:GetStatusBarTexture():SetHorizTile(false)
                bars[i]:ClearAllPoints()
                if i == 1 then
                    bars[i]:Point("LEFT", bars)
                else
                    if i == frame.MAX_CLASS_BAR then
                        bars[i]:Point("LEFT", bars[i-1], "RIGHT", frame.BORDER-frame.SPACING, 0)
                        bars[i]:Point("RIGHT", bars)
                    else
                        bars[i]:Point("LEFT", bars[i-1], "RIGHT", frame.BORDER-frame.SPACING, 0)
                    end
                end

                if R.myclass == "MONK" then
                    bars[i]:SetStatusBarColor(unpack(RayUF.colors.class[R.myclass]))
                elseif R.myclass == "PALADIN" or R.myclass == "MAGE" or R.myclass == "WARLOCK" then
                    bars[i]:SetStatusBarColor(unpack(RayUF.colors.class[R.myclass]))
                elseif R.myclass == "DEATHKNIGHT" then
                    if frame.ClassBar == "Runes" then
                        local r, g, b = unpack(RayUF.colors.class["DEATHKNIGHT"])
                        bars[i]:SetStatusBarColor(r, g, b)
                        if (bars[i].bg) then
                            local mu = bars[i].bg.multiplier or 1
                            bars[i].bg:SetVertexColor(r * mu, g * mu, b * mu)
                        end
                    else
                        local r1, g1, b1 = unpack(RayUF.colors.ComboPoints[1])
                        local r2, g2, b2 = unpack(RayUF.colors.ComboPoints[2])
                        local r3, g3, b3 = unpack(RayUF.colors.ComboPoints[3])

                        local r, g, b = RayUF.ColorGradient(i, frame.MAX_CLASS_BAR > 5 and 6 or 5, r1, g1, b1, r2, g2, b2, r3, g3, b3)
                        bars[i]:SetStatusBarColor(r, g, b)
                    end
                else -- Combo Points for everyone else
                    local r1, g1, b1 = unpack(RayUF.colors.ComboPoints[1])
                    local r2, g2, b2 = unpack(RayUF.colors.ComboPoints[2])
                    local r3, g3, b3 = unpack(RayUF.colors.ComboPoints[3])

                    local r, g, b = RayUF.ColorGradient(i, frame.MAX_CLASS_BAR > 5 and 6 or 5, r1, g1, b1, r2, g2, b2, r3, g3, b3)
                    bars[i]:SetStatusBarColor(r, g, b)
                end
                bars[i]:SetOrientation("HORIZONTAL")
                if cur and cur >= i then bars[i]:Show() end
            end
        end
    elseif (frame.ClassBar == "AdditionalPower" or frame.ClassBar == "Stagger") then
        bars:SetOrientation("HORIZONTAL")
    end

    if frame.USE_CLASSBAR then
        if frame.ClassIcons and not frame:IsElementEnabled("ClassIcons") then
            frame:EnableElement("ClassIcons")
        end
        if frame.AdditionalPower and not frame:IsElementEnabled("AdditionalPower") then
            frame:EnableElement("AdditionalPower")
        end
        if frame.Runes and not frame:IsElementEnabled("Runes") then
            frame:EnableElement("Runes")
        end
        if frame.Stagger and not frame:IsElementEnabled("Stagger") then
            frame:EnableElement("Stagger")
        end
    else
        if frame.ClassIcons and frame:IsElementEnabled("ClassIcons") then
            frame:DisableElement("ClassIcons")
        end
        if frame.AdditionalPower and frame:IsElementEnabled("AdditionalPower") then
            frame:DisableElement("AdditionalPower")
        end
        if frame.Runes and frame:IsElementEnabled("Runes") then
            frame:DisableElement("Runes")
        end
        if frame.Stagger and frame:IsElementEnabled("Stagger") then
            frame:DisableElement("Stagger")
        end
    end
end

local function ToggleResourceBar(bars, overrideVisibility)
    local frame = bars.origParent or bars:GetParent()

    frame.CLASSBAR_SHOWN = (not not overrideVisibility) or frame[frame.ClassBar]:IsShown()

    local height = 5

    if bars.text then
        if frame.CLASSBAR_SHOWN then
            bars.text:SetAlpha(1)
        else
            bars.text:SetAlpha(0)
        end
    end

    frame.CLASSBAR_HEIGHT = (frame.USE_CLASSBAR and (frame.CLASSBAR_SHOWN and height) or 0)
end
UF.ToggleResourceBar = ToggleResourceBar --Make available to combobar

-------------------------------------------------------------
-- MONK, PALADIN, WARLOCK, MAGE, and COMBOS
-------------------------------------------------------------
function UF:Construct_ClassBar(frame)
    local bars = CreateFrame("Frame", nil, frame)
    bars:Point("BOTTOM", frame, "TOP", 0, 2)

    local maxBars = max(UF['classMaxResourceBar'][R.myclass] or 0, MAX_COMBO_POINTS)
    for i = 1, maxBars do
        bars[i] = CreateFrame("StatusBar", frame:GetName().."ClassIconButton"..i, bars)
        bars[i]:CreateShadow("Background")
        bars[i]:SetStatusBarTexture(R["media"].normal)
        bars[i]:GetStatusBarTexture():SetHorizTile(false)

        bars[i].bg = bars[i]:CreateTexture(nil, "BACKGROUND")
        bars[i].bg:SetAllPoints(bars[i])
        bars[i].bg:SetTexture(R["media"].normal)
        bars[i].bg:SetVertexColor(0, 0, 0)
        bars[i].bg.multiplier = .2
    end

    bars.PostUpdate = UF.UpdateClassBar
    bars.UpdateTexture = function() return end

    bars:SetScript("OnShow", ToggleResourceBar)
    bars:SetScript("OnHide", ToggleResourceBar)

    return bars
end

function UF:UpdateClassBar(cur, max, hasMaxChanged, powerType, event)
    local frame = self.origParent or self:GetParent()

    --Update this first, as we want to update the .bg colors after
    if hasMaxChanged or event == "ClassPowerEnable" then
        frame.MAX_CLASS_BAR = max
        UF:Configure_ClassBar(frame, cur)
    end

    local r, g, b
    for i=1, #self do
        r, g, b = self[i]:GetStatusBarColor()
        self[i].bg:SetVertexColor(r, g, b, 0.15)
        if(max and (i <= max)) then
            self[i].bg:Show()
        else
            self[i].bg:Hide()
        end
    end
end

-------------------------------------------------------------
-- DEATHKNIGHT
-------------------------------------------------------------
function UF:Construct_DeathKnightResourceBar(frame)
    local runes = CreateFrame("Frame", nil, frame)
    runes:Point("BOTTOM", frame, "TOP", 0, 2)

    for i = 1, UF['classMaxResourceBar'][R.myclass] do
        runes[i] = CreateFrame("StatusBar", frame:GetName().."RuneButton"..i, runes)
        runes[i]:CreateShadow("Background")
        runes[i]:SetStatusBarTexture(R["media"].normal)
        runes[i]:GetStatusBarTexture():SetHorizTile(false)

        runes[i].bg = runes[i]:CreateTexture(nil, "BACKGROUND")
        runes[i].bg:SetAllPoints(runes[i])
        runes[i].bg:SetTexture(R["media"].normal)
        runes[i].bg:SetVertexColor(0, 0, 0)
        runes[i].bg.multiplier = .2
    end

    runes.PostUpdateVisibility = UF.PostVisibilityRunes
    runes.PostUpdate = UF.PostUpdateRunes
    runes:SetScript("OnShow", ToggleResourceBar)
    runes:SetScript("OnHide", ToggleResourceBar)

    return runes
end

function UF:PostUpdateRunes(rune, rid, start, duration, runeReady)
    if runeReady then
        rune:SetAlpha(1)
    else
        rune:SetAlpha(0.4)
    end
end

function UF:PostVisibilityRunes(enabled, stateChanged)
    local frame = self.origParent or self:GetParent()

    if enabled then
        frame.ClassBar = "Runes"
        frame.MAX_CLASS_BAR = #self
    else
        frame.ClassBar = "ClassIcons"
        frame.MAX_CLASS_BAR = MAX_COMBO_POINTS
    end

    if stateChanged then
        ToggleResourceBar(frame[frame.ClassBar])
        UF:Configure_ClassBar(frame)
    end
end

-------------------------------------------------------------
-- ALTERNATIVE MANA BAR
-------------------------------------------------------------
function UF:Construct_AdditionalPowerBar(frame)
    local additionalPower = CreateFrame('StatusBar', "AdditionalPowerBar", frame)
    additionalPower:Point("BOTTOM", frame, "TOP", 0, 2)
    additionalPower:SetFrameStrata("MEDIUM")
    additionalPower:SetFrameLevel(additionalPower:GetFrameLevel() + 1)
    additionalPower.colorPower = true
    additionalPower.PostUpdate = UF.PostUpdateAdditionalPower
    additionalPower.PostUpdateVisibility = UF.PostVisibilityAdditionalPower
    additionalPower:CreateShadow("Background")
    additionalPower:SetStatusBarTexture(R["media"].normal)

    additionalPower.bg = additionalPower:CreateTexture(nil, "BACKGROUND")
    additionalPower.bg:SetAllPoints(additionalPower)
    additionalPower.bg:SetTexture(R["media"].normal)
    additionalPower.bg:SetVertexColor(0, 0, 0)
    additionalPower.bg.multiplier = .2

    additionalPower.text = frame:CreateFontString(nil, "OVERLAY")
    additionalPower.text:SetFont(R["media"].font, R["media"].fontsize, R["media"].fontflag)
    additionalPower.text:SetShadowColor(0, 0, 0, 0.2)
    additionalPower.text:SetShadowOffset(R.mult, -R.mult)

    additionalPower:SetScript("OnShow", ToggleResourceBar)
    additionalPower:SetScript("OnHide", ToggleResourceBar)

    return additionalPower
end

function UF:PostUpdateAdditionalPower(unit, min, max, event)
    local frame = self.origParent or self:GetParent()
    local powerValue = frame.Power.value
    local powerValueText = powerValue:GetText()
    local powerValueParent = powerValue:GetParent()

    if event ~= "ElementDisable" then
        local color = RayUF["colors"].power["MANA"]
        color = R:RGBToHex(color[1], color[2], color[3])

        --Attempt to remove |cFFXXXXXX color codes in order to determine if power text is really empty
        if powerValueText then
            local _, endIndex = strfind(powerValueText, "|cff")
            if endIndex then
                endIndex = endIndex + 7 --Add hex code
                powerValueText = strsub(powerValueText, endIndex)
                powerValueText = gsub(powerValueText, "%s+", "")
            end
        end
        self.text:ClearAllPoints()
        self.text:SetParent(self)
        self.text:Point("TOP", self, "BOTTOM", 0, 0)
        self.text:SetFormattedText(color.."%d%%|r", floor(min / max * 100))

        self:Show()
    end

end

function UF:PostVisibilityAdditionalPower(enabled, stateChanged)
    local frame = self.origParent or self:GetParent()

    if enabled then
        frame.ClassBar = 'AdditionalPower'
    else
        frame.ClassBar = 'ClassIcons'
        self.text:SetText()
    end

    if stateChanged then
        ToggleResourceBar(frame[frame.ClassBar])
        UF:Configure_ClassBar(frame)
    end
end

-----------------------------------------------------------
-- Stagger Bar
-----------------------------------------------------------
function UF:Construct_Stagger(frame)
    local stagger = CreateFrame("Statusbar", nil, frame)
    stagger:Point("BOTTOM", frame, "TOP", 0, 2)
    stagger:CreateShadow("Background")
    stagger.PostUpdateVisibility = UF.PostUpdateVisibilityStagger
    stagger:SetFrameStrata("LOW")

    stagger:SetScript("OnShow", ToggleResourceBar)
    stagger:SetScript("OnHide", ToggleResourceBar)

    return stagger
end

function UF:PostUpdateVisibilityStagger(event, unit, isShown, stateChanged)
    local frame = self

    if(isShown) then
        frame.ClassBar = 'Stagger'
    else
        frame.ClassBar = 'ClassIcons'
    end

    --Only update when necessary
    if(stateChanged) then
        ToggleResourceBar(frame[frame.ClassBar])
        UF:Configure_ClassBar(frame)
    end
end
