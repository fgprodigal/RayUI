local R, L, P, G = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, GlobalDB
local mod = R:GetModule('NamePlates')
local LSM = LibStub("LibSharedMedia-3.0")

--Cache global variables
--Lua functions
local max = math.max
local unpack = unpack
local format = format

--WoW API / Variables
local CreateAnimationGroup = CreateAnimationGroup
local CreateFrame = CreateFrame
local IsInGroup = IsInGroup
local IsInRaid = IsInRaid
local UnitClass = UnitClass
local UnitDetailedThreatSituation = UnitDetailedThreatSituation
local UnitGetIncomingHeals = UnitGetIncomingHeals
local UnitGetTotalAbsorbs = UnitGetTotalAbsorbs
local UnitGetTotalHealAbsorbs = UnitGetTotalHealAbsorbs
local UnitHealth = UnitHealth
local UnitHealthMax = UnitHealthMax
local UnitIsConnected = UnitIsConnected
local UnitIsTapDenied = UnitIsTapDenied
local UnitIsUnit = UnitIsUnit
local UnitPlayerControlled = UnitPlayerControlled
local UnitReaction = UnitReaction
local RAID_CLASS_COLORS = RAID_CLASS_COLORS
local CUSTOM_CLASS_COLORS = CUSTOM_CLASS_COLORS

--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: RayUF

local goodR, goodG, goodB = unpack(RayUF["colors"].reaction[5])
local badR, badG, badB = unpack(RayUF["colors"].reaction[1])
local transitionR, transitionG, transitionB = 218/255, 197/255, 92/255
local transitionR2, transitionG2, transitionB2 = 240/255, 154/255, 17/255
local tankedByTankR, tankedByTankG, tankedByTankB = .8, 0.1, 1

function mod:UpdateElement_HealthColor(frame)
    if(not frame.HealthBar:IsShown()) then return end

    local r, g, b;
    local scale = 1
    if ( not UnitIsConnected(frame.unit) ) then
        r, g, b = 0.3, 0.3, 0.3
    else
        if ( frame.HealthBar.ColorOverride ) then
            --[[local healthBarColorOverride = frame.optionTable.healthBarColorOverride;
            r, g, b = healthBarColorOverride.r, healthBarColorOverride.g, healthBarColorOverride.b;]]
        else
            --Try to color it by class.
            local _, class = UnitClass(frame.displayedUnit);
            local classColor = RAID_CLASS_COLORS[class];
            if ( (frame.UnitType == "FRIENDLY_PLAYER" or frame.UnitType == "HEALER" or frame.UnitType == "ENEMY_PLAYER" or frame.UnitType == "PLAYER") and classColor and not frame.inVehicle ) then
                -- Use class colors for players if class color option is turned on
                r, g, b = classColor.r, classColor.g, classColor.b;
            elseif ( not UnitPlayerControlled(frame.unit) and UnitIsTapDenied(frame.unit) ) then
                -- Use grey if not a player and can't get tap on unit
                r, g, b = 0.6, 0.6, 0.6
            else
                -- Use color based on the type of unit (neutral, etc.)
                local isTanking, status = UnitDetailedThreatSituation("player", frame.unit)
                if status then
                    if(status == 3) then --Securely Tanking
                        if(R:GetPlayerRole() == "TANK") then
                            r, g, b = goodR, goodG, goodB
                            scale = 0.8
                        else
                            r, g, b = badR, badG, badB
                            scale = 1.2
                        end
                    elseif(status == 2) then --insecurely tanking
                        if(R:GetPlayerRole() == "TANK") then
                            r, g, b = transitionR2, transitionG2, transitionB2
                        else
                            r, g, b = transitionR, transitionG, transitionB
                        end
                    elseif(status == 1) then --not tanking but threat higher than tank
                        if(R:GetPlayerRole() == "TANK") then
                            r, g, b = transitionR, transitionG, transitionB
                        else
                            r, g, b = transitionR2, transitionG2, transitionB2
                        end
                    else -- not tanking at all
                        if(R:GetPlayerRole() == "TANK") then
                            --Check if it is being tanked by an offtank.
                            if (IsInRaid() or IsInGroup()) and frame.isBeingTanked then
                                r, g, b = tankedByTankR, tankedByTankG, tankedByTankB
                                scale = 0.8
                            else
                                r, g, b = badR, badG, badB
                                scale = 1.2
                            end
                        else
                            if (IsInRaid() or IsInGroup()) and frame.isBeingTanked then
                                r, g, b = tankedByTankR, tankedByTankG, tankedByTankB
                                scale = 0.8
                            else
                                r, g, b = goodR, goodG, goodB
                                scale = 0.8
                            end
                        end
                    end
                else
                    --By Reaction
                    local reactionType = UnitReaction(frame.unit, "player")
                    if(reactionType == 4) then
                        r, g, b = unpack(RayUF.colors.reaction[4])
                    elseif(reactionType > 4) then
                        r, g, b = unpack(RayUF.colors.reaction[5])
                    else
                        r, g, b = unpack(RayUF.colors.reaction[1])
                    end
                end
            end
        end
    end

    if ( r ~= frame.HealthBar.r or g ~= frame.HealthBar.g or b ~= frame.HealthBar.b ) then
        frame.HealthBar:SetStatusBarColor(r, g, b);
        frame.HealthBar.r, frame.HealthBar.g, frame.HealthBar.b = r, g, b;
    end

    if not frame.isTarget then
        frame.ThreatScale = scale
        self:SetFrameScale(frame, scale)
    end
end

local function UpdateFillBar(frame, previousTexture, bar, amount)
    if ( amount == 0 ) then
        bar:Hide();
        return previousTexture;
    end

    bar:ClearAllPoints()
    bar:Point("TOPLEFT", previousTexture, "TOPRIGHT");
    bar:Point("BOTTOMLEFT", previousTexture, "BOTTOMRIGHT");

    local totalWidth = frame:GetSize();
    bar:SetWidth(totalWidth);

    return bar:GetStatusBarTexture();
end

function mod:UpdateElement_HealPrediction(frame)
    local unit = frame.displayedUnit or frame.unit
    local myIncomingHeal = UnitGetIncomingHeals(unit, 'player') or 0
    local allIncomingHeal = UnitGetIncomingHeals(unit) or 0
    local totalAbsorb = UnitGetTotalAbsorbs(unit) or 0
    local myCurrentHealAbsorb = UnitGetTotalHealAbsorbs(unit) or 0
    local health, maxHealth = UnitHealth(unit), UnitHealthMax(unit)

    local overHealAbsorb = false
    if(health < myCurrentHealAbsorb) then
        overHealAbsorb = true
        myCurrentHealAbsorb = health
    end

    local maxOverflow = 1
    if(health - myCurrentHealAbsorb + allIncomingHeal > maxHealth * maxOverflow) then
        allIncomingHeal = maxHealth * maxOverflow - health + myCurrentHealAbsorb
    end

    local otherIncomingHeal = 0
    if(allIncomingHeal < myIncomingHeal) then
        myIncomingHeal = allIncomingHeal
    else
        otherIncomingHeal = allIncomingHeal - myIncomingHeal
    end

    local overAbsorb = false
    if(health - myCurrentHealAbsorb + allIncomingHeal + totalAbsorb >= maxHealth or health + totalAbsorb >= maxHealth) then
        if(totalAbsorb > 0) then
            overAbsorb = true
        end

        if(allIncomingHeal > myCurrentHealAbsorb) then
            totalAbsorb = max(0, maxHealth - (health - myCurrentHealAbsorb + allIncomingHeal))
        else
            totalAbsorb = max(0, maxHealth - health)
        end
    end

    if(myCurrentHealAbsorb > allIncomingHeal) then
        myCurrentHealAbsorb = myCurrentHealAbsorb - allIncomingHeal
    else
        myCurrentHealAbsorb = 0
    end

    frame.PersonalHealPrediction:SetMinMaxValues(0, maxHealth)
    frame.PersonalHealPrediction:SetValue(myIncomingHeal)
    frame.PersonalHealPrediction:Show()

    frame.HealPrediction:SetMinMaxValues(0, maxHealth)
    frame.HealPrediction:SetValue(otherIncomingHeal)
    frame.HealPrediction:Show()

    frame.AbsorbBar:SetMinMaxValues(0, maxHealth)
    frame.AbsorbBar:SetValue(totalAbsorb)
    frame.AbsorbBar:Show()

    local previousTexture = frame.HealthBar:GetStatusBarTexture();
    previousTexture = UpdateFillBar(frame.HealthBar, previousTexture, frame.PersonalHealPrediction , myIncomingHeal);
    previousTexture = UpdateFillBar(frame.HealthBar, previousTexture, frame.HealPrediction, allIncomingHeal);
    previousTexture = UpdateFillBar(frame.HealthBar, previousTexture, frame.AbsorbBar, totalAbsorb);
end

function mod:UpdateElement_MaxHealth(frame)
    local maxHealth = UnitHealthMax(frame.displayedUnit);
    frame.HealthBar:SetMinMaxValues(0, maxHealth)
end

function mod:UpdateElement_Health(frame)
    local health = UnitHealth(frame.displayedUnit);
    local _, maxHealth = frame.HealthBar:GetMinMaxValues()
    frame.HealthBar:SetValue(health)
    frame.HealthBar.text:SetText(format("%.1f%%", health / maxHealth * 100))
end

function mod:ConfigureElement_HealthBar(frame, configuring)
    local healthBar = frame.HealthBar
    local absorbBar = frame.AbsorbBar
    local isShown = healthBar:IsShown()

    --Position
    healthBar:SetPoint("BOTTOM", frame, "BOTTOM", 0, self.db.cbHeight + 3)
    if(UnitIsUnit(frame.unit, "target") and not frame.isTarget) then
        healthBar:SetHeight(self.db.hpHeight * self.db.targetScale)
        healthBar:SetWidth(self.db.hpWidth * self.db.targetScale)
    else
        healthBar:SetHeight(self.db.hpHeight)
        healthBar:SetWidth(self.db.hpWidth)
    end

    --Texture
    healthBar:SetStatusBarTexture(LSM:Fetch("statusbar", "RayUI Normal"))
    if(not configuring) and (frame.UnitType ~= "FRIENDLY_NPC" or frame.isTarget) then
        healthBar:Show()
    end
    absorbBar:Hide()

    healthBar.text:Point("CENTER", healthBar, "CENTER", 0, 1)
    healthBar.text:SetFont(LSM:Fetch("font", "RayUI Font"), self.db.fontsize, "OUTLINE")
end

function mod:ConstructElement_HealthBar(parent)
    local frame = CreateFrame("StatusBar", "$parentHealthBar", parent)
    self:StyleFrame(frame)

    parent.AbsorbBar = CreateFrame("StatusBar", "$parentAbsorbBar", frame)
    parent.AbsorbBar:SetStatusBarTexture(LSM:Fetch("background", "RayUI Blank"))
    parent.AbsorbBar:SetStatusBarColor(1, 1, 0, 0.25)

    parent.HealPrediction = CreateFrame("StatusBar", "$parentHealPrediction", frame)
    parent.HealPrediction:SetStatusBarTexture(LSM:Fetch("background", "RayUI Blank"))
    parent.HealPrediction:SetStatusBarColor(0, 1, 0, 0.25)

    parent.PersonalHealPrediction = CreateFrame("StatusBar", "$parentPersonalHealPrediction", frame)
    parent.PersonalHealPrediction:SetStatusBarTexture(LSM:Fetch("background", "RayUI Blank"))
    parent.PersonalHealPrediction:SetStatusBarColor(0, 1, 0.5, 0.25)

    frame.text = frame:CreateFontString(nil, "OVERLAY")
    frame.text:SetWordWrap(false)
    frame.scale = CreateAnimationGroup(frame)

    frame.scale.width = frame.scale:CreateAnimation("Width")
    frame.scale.width:SetDuration(0.2)
    frame.scale.height = frame.scale:CreateAnimation("Height")
    frame.scale.height:SetDuration(0.2)
    frame:Hide()
    return frame
end
