local R, L, P, G = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, GlobalDB
local RA = R:GetModule("Raid")
local UF = R:GetModule("UnitFrames")

local oUF = RayUF or oUF

--Cache global variables
--Lua functions
local type, unpack, table = type, unpack, table
local tinsert = table.insert
local upper = string.upper

--WoW API / Variables
local CreateFrame = CreateFrame
local InCombatLockdown = InCombatLockdown
local IsInInstance = IsInInstance
local GetInstanceInfo = GetInstanceInfo
local RegisterStateDriver = RegisterStateDriver
local UnregisterStateDriver = UnregisterStateDriver

--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: RayUF

RA["mapIDs"] = {
    [30] = 40, -- Alterac Valley
    [489] = 10, -- Warsong Gulch
    [529] = 15, -- Arathi Basin
    [566] = 15, -- Eye of the Storm
    [607] = 15, -- Strand of the Ancients
    [628] = 40, -- Isle of Conquest
    [726] = 10, -- Twin Peaks
    [727] = 10, -- Silvershard mines
    [761] = 10, -- The Battle for Gilneas
    [968] = 10, -- Rated Eye of the Storm
    [998] = 10, -- Temple of Kotmogu
    [1105] = 15, -- Deepwind Gourge
    [1280] = 40, -- Southshore vs. Tarren Mill
}

function RA:Construct_RaidFrames()
    self.RaisedElementParent = CreateFrame("Frame", nil, self)
    self.RaisedElementParent:SetFrameLevel(self:GetFrameLevel() + 100)
    self.FrameBorder = RA:Construct_FrameBorder(self)
    self.Health = RA:Construct_HealthBar(self)
    self.Power = RA:Construct_PowerBar(self)
    self.Name = RA:Construct_NameText(self)
    self.Threat = RA:Construct_Threat(self)
    self.Healtext = RA:Construct_HealthText(self)
    self.Highlight = RA:Construct_Highlight(self)
    self.RaidIcon = RA:Construct_RaidIcon(self)
    self.ResurrectIcon = RA:Construct_ResurectionIcon(self)
    self.ReadyCheck = RA:Construct_ReadyCheck(self)
    self.RaidDebuffs = RA:Construct_RaidDebuffs(self)
    self.AuraWatch = RA:Construct_AuraWatch(self)
    self.RaidRoleFramesAnchor = RA:Construct_RaidRoleFrames(self)
    if RA.db.roleicon then
        self.LFDRole = RA:Construct_RoleIcon(self)
    end
    self.RayUFAfk = true
    local range = {
        insideAlpha = 1,
        outsideAlpha = RA.db.outsideRange,
    }
    self.RayUFRange = RA.db.arrow and range
    self.Range = range

    RA:ConfigureAuraWatch(self)
    UF:EnableHealPredictionAndAbsorb(self)

    self:RegisterForClicks("AnyUp")
    self:SetScript("OnEnter", RA.UnitFrame_OnEnter)
    self:SetScript("OnLeave", RA.UnitFrame_OnLeave)
end

function RA:Construct_Raid40Frames()
    self.RaisedElementParent = CreateFrame("Frame", nil, self)
    self.RaisedElementParent:SetFrameLevel(self:GetFrameLevel() + 100)
    self.FrameBorder = RA:Construct_FrameBorder(self)
    self.Health = RA:Construct_HealthBar(self)
    self.Power = RA:Construct_PowerBar(self)
    self.Name = RA:Construct_NameText(self)
    self.Threat = RA:Construct_Threat(self)
    self.Healtext = RA:Construct_HealthText(self)
    self.Highlight = RA:Construct_Highlight(self)
    self.RaidIcon = RA:Construct_RaidIcon(self)
    self.ResurrectIcon = RA:Construct_ResurectionIcon(self)
    self.ReadyCheck = RA:Construct_ReadyCheck(self)
    self.RaidDebuffs = RA:Construct_RaidDebuffs(self)
    self.AuraWatch = RA:Construct_AuraWatch(self)
    self.RaidRoleFramesAnchor = RA:Construct_RaidRoleFrames(self)
    if RA.db.roleicon then
        self.LFDRole = RA:Construct_RoleIcon(self)
    end
    self.RayUFAfk = true
    local range = {
        insideAlpha = 1,
        outsideAlpha = RA.db.outsideRange,
    }
    self.RayUFRange = RA.db.arrow and range
    self.Range = range

    RA:ConfigureAuraWatch(self)
    UF:EnableHealPredictionAndAbsorb(self)

    self:RegisterForClicks("AnyUp")
    self:SetScript("OnEnter", RA.UnitFrame_OnEnter)
    self:SetScript("OnLeave", RA.UnitFrame_OnLeave)
end

function RA:Construct_RaidTankFrames()
    self.RaisedElementParent = CreateFrame("Frame", nil, self)
    self.RaisedElementParent:SetFrameLevel(self:GetFrameLevel() + 100)
    self.FrameBorder = RA:Construct_FrameBorder(self)
    self.Health = RA:Construct_HealthBar(self)
    self.Name = RA:Construct_NameText(self)
    self.Threat = RA:Construct_Threat(self)
    self.Highlight = RA:Construct_Highlight(self)
    self.RaidIcon = RA:Construct_RaidIcon(self)
    self.RaidDebuffs = RA:Construct_RaidDebuffs(self)
    self.AuraWatch = RA:Construct_AuraWatch(self)
    if RA.db.roleicon then
        self.LFDRole = RA:Construct_RoleIcon(self)
    end
    self.RayUFAfk = true
    local range = {
        insideAlpha = 1,
        outsideAlpha = RA.db.outsideRange,
    }
    self.RayUFRange = RA.db.arrow and range
    self.Range = range

    RA:ConfigureAuraWatch(self)
    UF:EnableHealPredictionAndAbsorb(self)

    self:RegisterForClicks("AnyUp")
    self:SetScript("OnEnter", RA.UnitFrame_OnEnter)
    self:SetScript("OnLeave", RA.UnitFrame_OnLeave)
end

function RA:Construct_RaidPetsFrames()
    self.RaisedElementParent = CreateFrame("Frame", nil, self)
    self.RaisedElementParent:SetFrameLevel(self:GetFrameLevel() + 100)
    self.FrameBorder = RA:Construct_FrameBorder(self)
    self.Health = RA:Construct_HealthBar(self)
    self.Name = RA:Construct_NameText(self)
    self.Threat = RA:Construct_Threat(self)
    self.Highlight = RA:Construct_Highlight(self)
    self.RaidIcon = RA:Construct_RaidIcon(self)
    self.RaidDebuffs = RA:Construct_RaidDebuffs(self)
    self.AuraWatch = RA:Construct_AuraWatch(self)

    local range = {
        insideAlpha = 1,
        outsideAlpha = RA.db.outsideRange,
    }
    self.RayUFRange = RA.db.arrow and range
    self.Range = range

    RA:ConfigureAuraWatch(self)
    UF:EnableHealPredictionAndAbsorb(self)

    self:RegisterForClicks("AnyUp")
    self:SetScript("OnEnter", RA.UnitFrame_OnEnter)
    self:SetScript("OnLeave", RA.UnitFrame_OnLeave)
end

function RA:RaidSmartVisibility(event)
    local inInstance, instanceType = IsInInstance()
    local _, _, _, _, maxPlayers, _, _, mapID, instanceGroupSize = GetInstanceInfo()
    if event == "PLAYER_REGEN_ENABLED" then self:UnregisterEvent("PLAYER_REGEN_ENABLED") end
    if not InCombatLockdown() then
        if(inInstance and (instanceType == "raid" or instanceType == "pvp")) then
            if RA.mapIDs[mapID] then
                maxPlayers = RA.mapIDs[mapID]
            end
            UnregisterStateDriver(self, "visibility")
            if maxPlayers < 40 then
                self:Show()
            else
                self:Hide()
            end
        else
            RegisterStateDriver(self, "visibility", RA.groupConfig.raid.visibility)
        end
    else
        self:RegisterEvent("PLAYER_REGEN_ENABLED")
        return
    end
end

function RA:Raid40SmartVisibility(event)
    local inInstance, instanceType = IsInInstance()
    local _, _, _, _, maxPlayers, _, _, mapID, instanceGroupSize = GetInstanceInfo()
    if event == "PLAYER_REGEN_ENABLED" then self:UnregisterEvent("PLAYER_REGEN_ENABLED") end
    if RA.mapIDs[mapID] then
        maxPlayers = RA.mapIDs[mapID]
    end
    if not InCombatLockdown() then
        if(inInstance and (instanceType == "raid" or instanceType == "pvp")) then
            if RA.mapIDs[mapID] then
                maxPlayers = RA.mapIDs[mapID]
            end
            UnregisterStateDriver(self, "visibility")
            if maxPlayers == 40 then
                self:Show()
            else
                self:Hide()
            end
        else
            RegisterStateDriver(self, "visibility", RA.groupConfig.raid40.visibility)
        end
    else
        self:RegisterEvent("PLAYER_REGEN_ENABLED")
        return
    end
end

function RA:RaidPetsSmartVisibility(event)
    local inInstance, instanceType = IsInInstance()
    if event == "PLAYER_REGEN_ENABLED" then self:UnregisterEvent("PLAYER_REGEN_ENABLED") end
    if not InCombatLockdown() then
        if inInstance and instanceType == "raid" then
            UnregisterStateDriver(self, "state-visibility")
            self:Show()
        else
            RegisterStateDriver(self, "visibility", RA.groupConfig.raid.visibility)
        end
    else
        self:RegisterEvent("PLAYER_REGEN_ENABLED")
        return
    end
end

local function CreateLabel(frame)
    local label = CreateFrame("Frame", nil, frame, "SecureHandlerStateTemplate")
    label:SetFrameStrata("BACKGROUND")
    label:SetFrameLevel(0)
    label:SetTemplate("Transparent")
    label.text = label:CreateFontString(nil, "OVERLAY")
    label.text:FontTemplate(R["media"].pxfont, 10 * R.mult, "OUTLINE, MONOCHROME")
    label.text:SetTextColor(0.7, 0.7, 0.7)

    if RA.db.horizontal then
        label:Point("TOPRIGHT", frame, "TOPLEFT", 0, 1)
        label:Point("BOTTOMRIGHT", frame, "BOTTOMLEFT", 0, -1)
        label.text:Point("CENTER", 2, 0)
        label:Width(12)
    else
        label:Point("BOTTOMLEFT", frame, "TOPLEFT", -1, 0)
        label:Point("BOTTOMRIGHT", frame, "TOPRIGHT", 1, 0)
        label.text:Point("CENTER", 0, 1)
        label:Height(12)
    end

    return label
end

function RA:CreateHeader(parent, name, groupFilter, template, layout)
    local point, growth, xoff, yoff
    if RA.db.horizontal then
        point = "LEFT"
        xoff = RA.db.spacing
        yoff = 0
        if RA.db.growth == "UP" then
            growth = "BOTTOM"
        else
            growth = "TOP"
        end
    else
        point = "TOP"
        xoff = 0
        yoff = -RA.db.spacing
        if RA.db.growth == "RIGHT" then
            growth = "LEFT"
        else
            growth = "RIGHT"
        end
    end

    local header = RayUF:SpawnHeader(name, template, nil,
        "oUF-initialConfigFunction", ([[self:SetWidth(%d); self:SetHeight(%d);]]):format(R:Scale(RA.groupConfig[layout].width), R:Scale(RA.groupConfig[layout].height)),
        "xOffset", xoff,
        "yOffset", yoff,
        "point", point,
        "showPlayer", true,
        "showRaid", true,
        "showParty", true,
        "sortMethod", "INDEX",
        "groupFilter", groupFilter,
        "groupingOrder", "1,2,3,4,5,6,7,8",
        "groupBy", "GROUP",
        "maxColumns", 1,
        "unitsPerColumn", 5,
        "columnSpacing", RA.db.spacing,
        "columnAnchorPoint", growth)

    header:SetParent(parent)
    header:Show()
    return header
end

function RA:CreateHeaderGroup(layout, groupFilter, template)
    local stringTitle = layout:gsub("(.)", upper, 1)
    RayUF:RegisterStyle("RayUF_"..stringTitle, RA["Construct_"..stringTitle.."Frames"])
    RayUF:SetActiveStyle("RayUF_"..stringTitle)

    local numGroups = RA.groupConfig[layout].numGroups
    if numGroups then
        self[layout] = CreateFrame("Frame", "RayUF_"..stringTitle, R.UIParent, "SecureHandlerStateTemplate")
        self[layout].groups = {}
        self[layout]:Point(unpack(RA.groupConfig[layout].defaultPosition))

        if RA.db.horizontal then
            self[layout]:Size(RA.groupConfig[layout].width*5 + RA.db.spacing*4, RA.groupConfig[layout].height*numGroups + RA.db.spacing*(numGroups-1))
        else
            self[layout]:Size(RA.groupConfig[layout].width*numGroups + RA.db.spacing*(numGroups-1), RA.groupConfig[layout].height*5 + RA.db.spacing*4)
        end
        R:CreateMover(self[layout], "RayUF_"..stringTitle.."Mover", "RayUI "..stringTitle, nil, nil, "ALL,RAID", true)

        for i= 1, numGroups do
            local group = self:CreateHeader(self[layout], "RayUF_"..stringTitle.."Group"..i, i, template, layout)
            if RA.db.showlabel then
                group.label = CreateLabel(group)
                group.label.text:SetText(RA.groupConfig[layout].label or i)
                if RA.groupConfig[layout].labelvisibility then
                    RegisterStateDriver(group.label, "visibility", RA.groupConfig[layout].labelvisibility)
                else
                    RegisterStateDriver(group.label, "visibility", RA.groupConfig[layout].visibility)
                end
            end

            if i == 1 then
                if RA.db.horizontal then
                    if RA.db.growth == "UP" then
                        group:Point("BOTTOMLEFT", self[layout], "BOTTOMLEFT", 0, 0)
                    else
                        group:Point("TOPLEFT", self[layout], "TOPLEFT", 0, 0)
                    end
                else
                    if RA.db.growth == "RIGHT" then
                        group:Point("TOPLEFT", self[layout], "TOPLEFT", 0, 0)
                    else
                        group:Point("TOPRIGHT", self[layout], "TOPRIGHT", 0, 0)
                    end
                end
            else
                if RA.db.horizontal then
                    if RA.db.growth == "UP" then
                        group:Point("BOTTOMLEFT", self[layout].groups[i-1], "TOPLEFT", 0, RA.db.spacing)
                    else
                        group:Point("TOPLEFT", self[layout].groups[i-1], "BOTTOMLEFT", 0, -RA.db.spacing)
                    end
                else
                    if RA.db.growth == "RIGHT" then
                        group:Point("TOPLEFT", self[layout].groups[i-1], "TOPRIGHT", RA.db.spacing, 0)
                    else
                        group:Point("TOPRIGHT", self[layout].groups[i-1], "TOPLEFT", -RA.db.spacing, 0)
                    end
                end
            end
            self[layout].groups[i] = group
            group:Show()
        end
    else
        self[layout] = self:CreateHeader(R.UIParent, "RayUF_"..stringTitle, groupFilter, template, layout)
        self[layout]:Point(unpack(RA.groupConfig[layout].defaultPosition))
        if RA.db.showlabel and RA.groupConfig[layout].label then
            self[layout].label = CreateLabel(self[layout])
            self[layout].label.text:SetText(RA.groupConfig[layout].label)
            if RA.groupConfig[layout].labelvisibility then
                RegisterStateDriver(self[layout].label, "visibility", RA.groupConfig[layout].labelvisibility)
            else
                RegisterStateDriver(self[layout].label, "visibility", RA.groupConfig[layout].visibility)
            end
        end
        if RA.db.horizontal then
            self[layout]:Size(RA.groupConfig[layout].width*5 + RA.db.spacing*4, RA.groupConfig[layout].height)
        else
            self[layout]:Size(RA.groupConfig[layout].width, RA.groupConfig[layout].height*5 + RA.db.spacing*4)
        end
        R:CreateMover(self[layout], "RayUF_"..stringTitle.."Mover", "RayUI "..stringTitle, nil, nil, "ALL,RAID", true)
    end

    self[layout].visibility = RA.groupConfig[layout].visibility
    if RA[stringTitle.."SmartVisibility"] then
        self[layout]:SetScript("OnEvent", RA[stringTitle.."SmartVisibility"])
        RA[stringTitle.."SmartVisibility"](self[layout])
    end
end
