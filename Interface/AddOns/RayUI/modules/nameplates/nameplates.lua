-- Nameplate from ElvUI
local R, L, P, G = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, GlobalDB
local mod = R:NewModule('NamePlates', 'AceHook-3.0', 'AceEvent-3.0', 'AceTimer-3.0')
local LSM = LibStub("LibSharedMedia-3.0")

--Cache global variables
--Lua functions
local pairs, type = pairs, type
local twipe = table.wipe
local string = string
local format, match = string.format, string.match

--WoW API / Variables
local CreateFrame = CreateFrame
local C_NamePlate_GetNamePlateForUnit = C_NamePlate.GetNamePlateForUnit
local C_NamePlate_GetNamePlates = C_NamePlate.GetNamePlates
local GetArenaOpponentSpec = GetArenaOpponentSpec
local GetBattlefieldScore = GetBattlefieldScore
local GetNumArenaOpponentSpecs = GetNumArenaOpponentSpecs
local GetNumBattlefieldScores = GetNumBattlefieldScores
local GetSpecializationInfoByID = GetSpecializationInfoByID
local hooksecurefunc = hooksecurefunc
local IsInInstance = IsInInstance
local RegisterUnitWatch = RegisterUnitWatch
local SetCVar = SetCVar
local UnitCanAttack = UnitCanAttack
local UnitExists = UnitExists
local UnitGroupRolesAssigned = UnitGroupRolesAssigned
local UnitHasVehicleUI = UnitHasVehicleUI
local UnitIsPlayer = UnitIsPlayer
local UnitIsUnit = UnitIsUnit
local UnitName = UnitName
local UnitPowerType = UnitPowerType
local UnregisterUnitWatch = UnregisterUnitWatch
local UNKNOWN = UNKNOWN

--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: NamePlateDriverFrame, UIParent, InterfaceOptionsNamesPanelUnitNameplates

--Taken from Blizzard_TalentUI.lua
local healerSpecIDs = {
    105, --Druid Restoration
    270, --Monk Mistweaver
    65, --Paladin Holy
    256, --Priest Discipline
    257, --Priest Holy
    264, --Shaman Restoration
}

mod.HealerSpecs = {}
mod.Healers = {};

--Get localized healing spec names
for _, specID in pairs(healerSpecIDs) do
    local _, name = GetSpecializationInfoByID(specID)
    if name and not mod.HealerSpecs[name] then
        mod.HealerSpecs[name] = true
    end
end

function mod:CheckBGHealers()
    local name, _, talentSpec
    for i = 1, GetNumBattlefieldScores() do
        name, _, _, _, _, _, _, _, _, _, _, _, _, _, _, talentSpec = GetBattlefieldScore(i);
        if name then
            name = name:match("(.+)%-.+") or name
            if name and self.HealerSpecs[talentSpec] then
                self.Healers[name] = talentSpec
            elseif name and self.Healers[name] then
                self.Healers[name] = nil;
            end
        end
    end
end

function mod:CheckArenaHealers()
    local numOpps = GetNumArenaOpponentSpecs()
    if not (numOpps > 1) then return end

    for i=1, 3 do
        local name = UnitName(format('arena%d', i))
        if name and name ~= UNKNOWN then
            local s = GetArenaOpponentSpec(i)
            local _, talentSpec = nil, UNKNOWN
            if s and s > 0 then
                _, talentSpec = GetSpecializationInfoByID(s)
            end

            if talentSpec and talentSpec ~= UNKNOWN and self.HealerSpecs[talentSpec] then
                self.Healers[name] = talentSpec
            end
        end
    end
end

function mod:PLAYER_ENTERING_WORLD()
    twipe(self.Healers)
    local inInstance, instanceType = IsInInstance()
    if inInstance and instanceType == 'pvp' and self.db.markHealers then
        self.CheckHealerTimer = self:ScheduleRepeatingTimer("CheckBGHealers", 3)
        self:CheckBGHealers()
    elseif inInstance and instanceType == 'arena' and self.db.markHealers then
        self:RegisterEvent('UNIT_NAME_UPDATE', 'CheckArenaHealers')
        self:RegisterEvent("ARENA_OPPONENT_UPDATE", 'CheckArenaHealers');
        self:CheckArenaHealers()
    else
        self:UnregisterEvent('UNIT_NAME_UPDATE')
        self:UnregisterEvent("ARENA_OPPONENT_UPDATE")
        if self.CheckHealerTimer then
            self:CancelTimer(self.CheckHealerTimer)
            self.CheckHealerTimer = nil;
        end
    end
end

function mod:SetFrameScale(frame, scale)
    if(frame.HealthBar.currentScale ~= scale) then
        if(frame.HealthBar.scale:IsPlaying()) then
            frame.HealthBar.scale:Stop()
        end
        frame.HealthBar.scale.width:SetChange(self.db.hpWidth * scale)
        frame.HealthBar.scale.height:SetChange(self.db.hpHeight * scale)
        frame.HealthBar.scale:Play()
        frame.HealthBar.currentScale = scale
    end
end

function mod:GetNamePlateForUnit(unit)
    if unit ~= "player" then
        return C_NamePlate_GetNamePlateForUnit(unit)
    end
end

function mod:SetTargetFrame(frame)
    --Match parent's frame level for targetting purposes. Best time to do it is here.
    local parent = self:GetNamePlateForUnit(frame.unit);
    if(parent) then
        if frame:GetFrameLevel() < 100 then
            frame:SetFrameLevel(parent:GetFrameLevel() + 100)
        end

        frame:SetFrameLevel(parent:GetFrameLevel() + 3)
        frame.Glow:SetFrameLevel(parent:GetFrameLevel() + 1)
        frame.Buffs:SetFrameLevel(parent:GetFrameLevel() + 2)
        frame.Debuffs:SetFrameLevel(parent:GetFrameLevel() + 2)
    end

    local targetExists = UnitExists("target")
    if(UnitIsUnit(frame.unit, "target") and not frame.isTarget) then
        frame:SetFrameLevel(parent:GetFrameLevel() + 5)
        frame.Glow:SetFrameLevel(parent:GetFrameLevel() + 3)
        frame.Buffs:SetFrameLevel(parent:GetFrameLevel() + 4)
        frame.Debuffs:SetFrameLevel(parent:GetFrameLevel() + 4)

        self:SetFrameScale(frame, self.db.targetScale)
        frame.isTarget = true
        if frame.UnitType == "FRIENDLY_NPC" then
            frame.Name:ClearAllPoints()
            frame.Level:ClearAllPoints()
            frame.HealthBar.r, frame.HealthBar.g, frame.HealthBar.b = nil, nil, nil
            frame.CastBar:Hide()
            self:ConfigureElement_HealthBar(frame)
            self:ConfigureElement_PowerBar(frame)
            self:ConfigureElement_CastBar(frame)
            self:ConfigureElement_Glow(frame)
            self:ConfigureElement_Elite(frame)
            self:ConfigureElement_Detection(frame)
            self:ConfigureElement_NPCTitle(frame)

            self:ConfigureElement_Level(frame)
            self:ConfigureElement_Name(frame)
            self:RegisterEvents(frame, frame.unit)
            self:UpdateElement_All(frame, frame.unit, true)
        end

        if(targetExists) then
            frame:SetAlpha(1)
        end
    elseif (frame.isTarget) then
        self:SetFrameScale(frame, frame.ThreatScale or 1)
        frame.isTarget = nil
        if frame.UnitType == "FRIENDLY_NPC" then
            self:UpdateAllFrame(frame)
        end

        if(targetExists and not UnitIsUnit(frame.unit, "player")) then
            frame:SetAlpha(0.6)
        else
            frame:SetAlpha(1)
        end
    else
        if(targetExists and not UnitIsUnit(frame.unit, "player")) then
            frame:SetAlpha(0.6)
        else
            frame:SetAlpha(1)
        end
    end

    if (self.db.displayStyle == "TARGET" and not frame.isTarget and frame.UnitType ~= "PLAYER") then
        frame:Hide()
    else
        frame:Show()
    end
end

function mod:StyleFrame(frame, useMainFrame)
    local parent = frame

    if(parent:GetObjectType() == "Texture") then
        parent = frame:GetParent()
    end

    if useMainFrame then
        parent:CreateShadow("Background")
        return
    end

    parent:CreateShadow("Background")
end

function mod:DISPLAY_SIZE_CHANGED()
    self.mult = R.mult --[[* UIParent:GetScale()]]
end

function mod:CheckUnitType(frame)
    local role = UnitGroupRolesAssigned(frame.unit)
    local CanAttack = UnitCanAttack(self.playerUnitToken, frame.displayedUnit)

    if(role == "HEALER" and frame.UnitType ~= "HEALER") then
        self:UpdateAllFrame(frame)
    elseif(role ~= "HEALER" and frame.UnitType == "HEALER") then
        self:UpdateAllFrame(frame)
    elseif frame.UnitType == "FRIENDLY_PLAYER" then
        self:UpdateAllFrame(frame)
    elseif(frame.UnitType == "FRIENDLY_NPC" or frame.UnitType == "HEALER") then
        if(CanAttack) then
            self:UpdateAllFrame(frame)
        end
    elseif(frame.UnitType == "ENEMY_PLAYER" or frame.UnitType == "ENEMY_NPC") then
        if(not CanAttack) then
            self:UpdateAllFrame(frame)
        end
    end
end

function mod:NAME_PLATE_UNIT_ADDED(event, unit, frame)
    local frame = frame or self:GetNamePlateForUnit(unit);
    frame.UnitFrame.unit = unit
    frame.UnitFrame.displayedUnit = unit
    self:UpdateInVehicle(frame, true)

    local CanAttack = UnitCanAttack(unit, self.playerUnitToken)
    local isPlayer = UnitIsPlayer(unit)

    if(UnitIsUnit(unit, "player")) then
        frame.UnitFrame.UnitType = "PLAYER"
    elseif(not CanAttack and isPlayer) then
        local role = UnitGroupRolesAssigned(unit)
        if(role == "HEALER") then
            frame.UnitFrame.UnitType = role
        else
            frame.UnitFrame.UnitType = "FRIENDLY_PLAYER"
        end
    elseif(not CanAttack and not isPlayer) then
        frame.UnitFrame.UnitType = "FRIENDLY_NPC"
    elseif(CanAttack and isPlayer) then
        frame.UnitFrame.UnitType = "ENEMY_PLAYER"
        self:UpdateElement_HealerIcon(frame.UnitFrame)
    else
        frame.UnitFrame.UnitType = "ENEMY_NPC"
    end

    if(frame.UnitFrame.UnitType == "PLAYER") then
        mod.PlayerFrame = frame
    end

    if frame.UnitType ~= "FRIENDLY_NPC" or self.db.displayStyle ~= "ALL" then
        self:ConfigureElement_HealthBar(frame.UnitFrame)
        self:ConfigureElement_PowerBar(frame.UnitFrame)
        self:ConfigureElement_CastBar(frame.UnitFrame)
        self:ConfigureElement_Glow(frame.UnitFrame)

        if self.db.showauras then
            self:UpdateAuraIcons(frame.UnitFrame.Buffs)
        end

        if self.db.showauras then
            self:UpdateAuraIcons(frame.UnitFrame.Debuffs)
        end
    end

    self:ConfigureElement_Level(frame.UnitFrame)
    self:ConfigureElement_Name(frame.UnitFrame)
    self:ConfigureElement_Elite(frame.UnitFrame)
    self:ConfigureElement_Detection(frame.UnitFrame)
    self:ConfigureElement_NPCTitle(frame.UnitFrame)
    self:RegisterEvents(frame.UnitFrame, unit)
    self:UpdateElement_All(frame.UnitFrame, unit)
    if (self.db.displayStyle == "TARGET" and not frame.UnitFrame.isTarget and frame.UnitFrame.UnitType ~= "PLAYER") then
        frame.UnitFrame:Hide()
    else
        frame.UnitFrame:Show()
    end
end

function mod:NAME_PLATE_UNIT_REMOVED(event, unit, frame, ...)
    local frame = frame or self:GetNamePlateForUnit(unit);
    frame.UnitFrame.unit = nil

    local unitType = frame.UnitFrame.UnitType
    if(frame.UnitFrame.UnitType == "PLAYER") then
        mod.PlayerFrame = nil
    end

    self:HideAuraIcons(frame.UnitFrame.Buffs)
    self:HideAuraIcons(frame.UnitFrame.Debuffs)
    frame.UnitFrame:UnregisterAllEvents()
    frame.UnitFrame.Glow.r, frame.UnitFrame.Glow.g, frame.UnitFrame.Glow.b = nil, nil, nil
    frame.UnitFrame.Glow:Hide()
    frame.UnitFrame.HealthBar.r, frame.UnitFrame.HealthBar.g, frame.UnitFrame.HealthBar.b = nil, nil, nil
    frame.UnitFrame.HealthBar:Hide()
    frame.UnitFrame.PowerBar:Hide()
    frame.UnitFrame.CastBar:Hide()
    frame.UnitFrame.AbsorbBar:Hide()
    frame.UnitFrame.HealPrediction:Hide()
    frame.UnitFrame.PersonalHealPrediction:Hide()
    frame.UnitFrame.Name:ClearAllPoints()
    frame.UnitFrame.Level:ClearAllPoints()
    frame.UnitFrame.Level:SetText("")
    frame.UnitFrame.Name:SetText("")
    frame.UnitFrame:Hide()
    frame.UnitFrame.isTarget = nil
    frame.UnitFrame.displayedUnit = nil
    frame.ThreatData = nil
    frame.UnitFrame.UnitType = nil
    frame.UnitFrame.TopLevelFrame = nil
end

function mod:UpdateAllFrame(frame)
    local unit = frame.unit
    mod:NAME_PLATE_UNIT_REMOVED("NAME_PLATE_UNIT_REMOVED", unit)
    mod:NAME_PLATE_UNIT_ADDED("NAME_PLATE_UNIT_ADDED", unit)
end

function mod:ConfigureAll()
    self:ForEachPlate("UpdateAllFrame")
    self:UpdateCVars()
end

function mod:ForEachPlate(functionToRun, ...)
    for _, frame in pairs(C_NamePlate_GetNamePlates()) do
        if(frame and frame.UnitFrame) then
            self[functionToRun](self, frame.UnitFrame, ...)
        end
    end
end

function mod:SetBaseNamePlateSize()
    local self = mod
    local baseWidth = self.db.hpWidth
    local baseHeight = self.db.cbHeight + self.db.hpHeight + 30
    NamePlateDriverFrame:SetBaseNamePlateSize(baseWidth, baseHeight)
end

function mod:UpdateInVehicle(frame, noEvents)
    if ( UnitHasVehicleUI(frame.unit) ) then
        if ( not frame.inVehicle ) then
            frame.inVehicle = true;
            if(UnitIsUnit(frame.unit, "player")) then
                frame.displayedUnit = "vehicle"
            else
                local prefix, id, suffix = string.match(frame.unit, "([^%d]+)([%d]*)(.*)")
                frame.displayedUnit = prefix.."pet"..id..suffix;
            end
            if(not noEvents) then
                self:RegisterEvents(frame, frame.unit)
                self:UpdateElement_All(frame)
            end
        end
    else
        if ( frame.inVehicle ) then
            frame.inVehicle = false;
            frame.displayedUnit = frame.unit;
            if(not noEvents) then
                self:RegisterEvents(frame, frame.unit)
                self:UpdateElement_All(frame)
            end
        end
    end
end

function mod:UpdateElement_All(frame, unit, noTargetFrame)
    if (frame.UnitType ~= "FRIENDLY_NPC" or (self.db.displayStyle ~= "ALL") or frame.isTarget) then
        mod:UpdateElement_MaxHealth(frame)
        mod:UpdateElement_Health(frame)
        mod:UpdateElement_HealthColor(frame)

        mod:UpdateElement_Glow(frame)
        mod:UpdateElement_Cast(frame)
        mod:UpdateElement_Auras(frame)
        mod:UpdateElement_HealPrediction(frame)
        if frame.UnitType == "HEALER" or frame.UnitType == "FRIENDLY_PLAYER" then
            frame.PowerBar:Show()
            mod.OnEvent(frame, "UNIT_DISPLAYPOWER", unit or frame.unit)
        else
            frame.PowerBar:Hide()
        end
    end
    mod:UpdateElement_RaidIcon(frame)
    mod:UpdateElement_HealerIcon(frame)
    mod:UpdateElement_Name(frame)
    mod:UpdateElement_Level(frame)
    mod:UpdateElement_Elite(frame)
    mod:UpdateElement_Detection(frame)
    mod:UpdateElement_NPCTitle(frame)

    if(not noTargetFrame) then --infinite loop lol
        mod:SetTargetFrame(frame)
    end
end

function mod:NAME_PLATE_CREATED(event, frame)
    frame.UnitFrame = CreateFrame("BUTTON", frame:GetName().."UnitFrame", R.UIParent);
    frame.UnitFrame:EnableMouse(false)
    frame.UnitFrame:SetAllPoints(frame)
    frame.UnitFrame:SetFrameStrata("BACKGROUND")
    frame.UnitFrame:SetScript("OnEvent", mod.OnEvent)

    frame.UnitFrame.HealthBar = self:ConstructElement_HealthBar(frame.UnitFrame)
    frame.UnitFrame.PowerBar = self:ConstructElement_PowerBar(frame.UnitFrame)
    frame.UnitFrame.CastBar = self:ConstructElement_CastBar(frame.UnitFrame)
    frame.UnitFrame.Level = self:ConstructElement_Level(frame.UnitFrame)
    frame.UnitFrame.Name = self:ConstructElement_Name(frame.UnitFrame)
    frame.UnitFrame.Glow = self:ConstructElement_Glow(frame.UnitFrame)
    frame.UnitFrame.Buffs = self:ConstructElement_Auras(frame.UnitFrame, "LEFT")
    frame.UnitFrame.Debuffs = self:ConstructElement_Auras(frame.UnitFrame, "RIGHT")
    frame.UnitFrame.HealerIcon = self:ConstructElement_HealerIcon(frame.UnitFrame)
    frame.UnitFrame.RaidIcon = self:ConstructElement_RaidIcon(frame.UnitFrame)
    frame.UnitFrame.DetectionModel = self:ConstructElement_Detection(frame.UnitFrame)
    frame.UnitFrame.Elite = self:ConstructElement_Elite(frame.UnitFrame)
    frame.UnitFrame.NPCTitle = self:ConstructElement_NPCTitle(frame.UnitFrame)
end

function mod:OnEvent(event, unit, ...)
    if (unit and self.displayedUnit and (not UnitIsUnit(unit, self.displayedUnit) and not ((unit == "vehicle" or unit == "player") and (self.displayedUnit == "vehicle" or self.displayedUnit == "player")))) then
        return
    end

    if(event == "UNIT_HEALTH" or event == "UNIT_HEALTH_FREQUENT") then
        mod:UpdateElement_Health(self)
        mod:UpdateElement_HealPrediction(self)
        mod:UpdateElement_Glow(self)
    elseif(event == "UNIT_ABSORB_AMOUNT_CHANGED" or event == "UNIT_HEAL_ABSORB_AMOUNT_CHANGED" or event == "UNIT_HEAL_PREDICTION") then
        mod:UpdateElement_HealPrediction(self)
    elseif(event == "UNIT_MAXHEALTH") then
        mod:UpdateElement_MaxHealth(self)
        mod:UpdateElement_HealPrediction(self)
        mod:UpdateElement_Glow(self)
    elseif(event == "UNIT_NAME_UPDATE") then
        mod:UpdateElement_Name(self)
        mod:UpdateElement_HealthColor(self) --Unit class sometimes takes a bit to load
    elseif(event == "UNIT_LEVEL") then
        mod:UpdateElement_Level(self)
    elseif(event == "UNIT_THREAT_LIST_UPDATE") then
        mod:Update_ThreatList(self)
        mod:UpdateElement_HealthColor(self)
    elseif(event == "PLAYER_TARGET_CHANGED") then
        mod:SetTargetFrame(self)
        mod:UpdateElement_Glow(self)
        mod:UpdateElement_HealthColor(self)
    elseif(event == "UNIT_AURA") then
        mod:UpdateElement_Auras(self)
    elseif(event == "PLAYER_ROLES_ASSIGNED" or event == "UNIT_FACTION") then
        mod:CheckUnitType(self)
    elseif(event == "RAID_TARGET_UPDATE") then
        mod:UpdateElement_RaidIcon(self)
    elseif(event == "UNIT_MAXPOWER") then
        mod:UpdateElement_MaxPower(self)
    elseif(event == "UNIT_POWER" or event == "UNIT_POWER_FREQUENT" or event == "UNIT_DISPLAYPOWER") then
        local powerType, powerToken = UnitPowerType(self.displayedUnit)
        local arg1 = ...
        self.PowerToken = powerToken
        self.PowerType = powerType

        if arg1 == powerToken or event == "UNIT_DISPLAYPOWER" then
            mod:UpdateElement_Power(self)
        end
    elseif ( event == "UNIT_ENTERED_VEHICLE" or event == "UNIT_EXITED_VEHICLE" or event == "UNIT_PET" ) then
        mod:UpdateInVehicle(self)
        mod:UpdateElement_All(self, unit, true)
    else
        mod:UpdateElement_Cast(self, event, unit, ...)
    end
end

function mod:RegisterEvents(frame, unit)
    local displayedUnit;
    if ( unit ~= frame.displayedUnit ) then
        displayedUnit = frame.displayedUnit;
    end

    if(frame.UnitType ~= "FRIENDLY_NPC" or frame.isTarget) then
        frame:RegisterUnitEvent("UNIT_MAXHEALTH", unit, displayedUnit);
        frame:RegisterUnitEvent("UNIT_HEALTH", unit, displayedUnit);
        frame:RegisterUnitEvent("UNIT_HEALTH_FREQUENT", unit, displayedUnit);
        frame:RegisterUnitEvent("UNIT_ABSORB_AMOUNT_CHANGED", unit, displayedUnit);
        frame:RegisterUnitEvent("UNIT_HEAL_ABSORB_AMOUNT_CHANGED", unit, displayedUnit);
        frame:RegisterUnitEvent("UNIT_HEAL_PREDICTION", unit, displayedUnit);
    end

    frame:RegisterEvent("UNIT_NAME_UPDATE");
    frame:RegisterUnitEvent("UNIT_LEVEL", unit, displayedUnit);

    if(frame.UnitType ~= "FRIENDLY_NPC" or frame.isTarget) then
        if(frame.UnitType == "ENEMY_NPC") then
            frame:RegisterUnitEvent("UNIT_THREAT_LIST_UPDATE", unit, displayedUnit);
        end

        if frame.UnitType == "HEALER" or frame.UnitType == "FRIENDLY_PLAYER" then
            frame:RegisterUnitEvent("UNIT_POWER", unit, displayedUnit)
            frame:RegisterUnitEvent("UNIT_POWER_FREQUENT", unit, displayedUnit)
            frame:RegisterUnitEvent("UNIT_DISPLAYPOWER", unit, displayedUnit)
            frame:RegisterUnitEvent("UNIT_MAXPOWER", unit, displayedUnit)
        end

        if frame.UnitType ~= "FRIENDLY_NPC" then
            frame:RegisterEvent("UNIT_SPELLCAST_INTERRUPTED");
            frame:RegisterEvent("UNIT_SPELLCAST_DELAYED");
            frame:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START");
            frame:RegisterEvent("UNIT_SPELLCAST_CHANNEL_UPDATE");
            frame:RegisterEvent("UNIT_SPELLCAST_CHANNEL_STOP");
            frame:RegisterEvent("UNIT_SPELLCAST_INTERRUPTIBLE");
            frame:RegisterEvent("UNIT_SPELLCAST_NOT_INTERRUPTIBLE");
            frame:RegisterUnitEvent("UNIT_SPELLCAST_START", unit, displayedUnit);
            frame:RegisterUnitEvent("UNIT_SPELLCAST_STOP", unit, displayedUnit);
            frame:RegisterUnitEvent("UNIT_SPELLCAST_FAILED", unit, displayedUnit);
        end

        frame:RegisterEvent("PLAYER_ENTERING_WORLD");

        if self.db.showauras then
            frame:RegisterUnitEvent("UNIT_AURA", unit, displayedUnit)
        end
        frame:RegisterEvent("RAID_TARGET_UPDATE")
        mod.OnEvent(frame, "PLAYER_ENTERING_WORLD")
    end

    frame:RegisterEvent("UNIT_ENTERED_VEHICLE")
    frame:RegisterEvent("UNIT_EXITED_VEHICLE")
    frame:RegisterEvent("UNIT_PET")
    frame:RegisterEvent("PLAYER_TARGET_CHANGED");
    frame:RegisterEvent("PLAYER_ROLES_ASSIGNED")
    frame:RegisterEvent("UNIT_FACTION")
end

function mod:UpdateCVars()
    R:LockCVar("nameplateShowSelf", "0")
    R:LockCVar("nameplateMotion", self.db.motionType == "STACKED" and "1" or "0")
    R:LockCVar("nameplateShowAll", self.db.displayStyle ~= "ALL" and "0" or "1")
    R:LockCVar("nameplateShowFriendlyMinions", self.db.friendly_minions == true and "1" or "0")
    R:LockCVar("nameplateShowEnemyMinions", self.db.enemy_minions == true and "1" or "0")
    R:LockCVar("nameplateShowEnemyMinus", self.db.enemy_minors == true and "1" or "0")

    R:LockCVar("nameplateOtherTopInset", -1)
    R:LockCVar("nameplateOtherBottomInset", -1)
    R:LockCVar("nameplateMaxDistance", 50)
end

function mod:UpdateVehicleStatus(event, unit)
    if ( UnitHasVehicleUI("player") ) then
        self.playerUnitToken = "vehicle"
    else
        self.playerUnitToken = "player"
    end
end

function mod:PLAYER_REGEN_DISABLED()
    if(self.db.showFriendlyCombat == "TOGGLE_ON") then
        SetCVar("nameplateShowFriends", 1)
    elseif(self.db.showFriendlyCombat == "TOGGLE_OFF") then
        SetCVar("nameplateShowFriends", 0)
    end

    if(self.db.showEnemyCombat == "TOGGLE_ON") then
        SetCVar("nameplateShowEnemies", 1)
    elseif(self.db.showEnemyCombat == "TOGGLE_OFF") then
        SetCVar("nameplateShowEnemies", 0)
    end
end

function mod:PLAYER_REGEN_ENABLED()
    if(self.db.showFriendlyCombat == "TOGGLE_ON") then
        SetCVar("nameplateShowFriends", 0)
    elseif(self.db.showFriendlyCombat == "TOGGLE_OFF") then
        SetCVar("nameplateShowFriends", 1)
    end

    if(self.db.showEnemyCombat == "TOGGLE_ON") then
        SetCVar("nameplateShowEnemies", 0)
    elseif(self.db.showEnemyCombat == "TOGGLE_OFF") then
        SetCVar("nameplateShowEnemies", 1)
    end
end

function mod:Initialize()
    if not self.db.enable then return end

    R.NamePlates = mod

    self:UpdateVehicleStatus()

    InterfaceOptionsNamesPanelUnitNameplates:Kill()
    NamePlateDriverFrame:UnregisterAllEvents()
    NamePlateDriverFrame.ApplyFrameOptions = R.dummy
    self:RegisterEvent("NAME_PLATE_CREATED");
    self:RegisterEvent("NAME_PLATE_UNIT_ADDED");
    self:RegisterEvent("NAME_PLATE_UNIT_REMOVED");
    self:RegisterEvent("PLAYER_REGEN_ENABLED");
    self:RegisterEvent("PLAYER_REGEN_DISABLED");
    self:RegisterEvent("DISPLAY_SIZE_CHANGED");
    self:RegisterEvent("UNIT_ENTERED_VEHICLE", "UpdateVehicleStatus")
    self:RegisterEvent("UNIT_EXITED_VEHICLE", "UpdateVehicleStatus")
    self:RegisterEvent("UNIT_PET", "UpdateVehicleStatus")

    self:DISPLAY_SIZE_CHANGED() --Run once for good measure.
    self:SetBaseNamePlateSize()

    self:RegisterEvent("PLAYER_ENTERING_WORLD")
    self:RegisterEvent("PLAYER_LOGIN", "UpdateCVars")

    R.NamePlates = self
end

function mod:Info()
    return L["|cff7aa6d6Ray|r|cffff0000U|r|cff7aa6d6I|r姓名板模块."]
end
mod.modName = L["姓名板"]

R:RegisterModule(mod:GetName())
