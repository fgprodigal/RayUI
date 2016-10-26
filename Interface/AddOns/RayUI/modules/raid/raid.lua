local R, L, P, G = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, GlobalDB
local RA = R:NewModule("Raid", "AceEvent-3.0")

local _, ns = ...
local oUF = RayUF or oUF

--Cache global variables
--Lua functions
local _G = _G
local next = next
local type, unpack, pairs = type, unpack, pairs
local upper = string.upper

--WoW API / Variables
local CreateFrame = CreateFrame
local SetMapToCurrentZone = SetMapToCurrentZone
local IsInInstance = IsInInstance
local GetCurrentMapAreaID = GetCurrentMapAreaID
local InCombatLockdown = InCombatLockdown
local CompactRaidFrameManager_GetSetting = CompactRaidFrameManager_GetSetting
local CompactRaidFrameManager_SetSetting = CompactRaidFrameManager_SetSetting
local CompactUnitFrame_UnregisterEvents = CompactUnitFrame_UnregisterEvents
local RegisterStateDriver = RegisterStateDriver
local hooksecurefunc = hooksecurefunc

--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: UIParent, oUF_RaidDebuffs, CompactRaidFrameManager, CompactRaidFrameContainer, RayUF, DebuffTypeColor

RA.modName = L["团队"]
RA.headers = {}
RA.colorCache = {}
RA.debuffColor = {}
RA.groupConfig = {}
RA.headerstoload = {}
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

local function RegisterDebuffs()
    SetMapToCurrentZone()
    local _, instanceType = IsInInstance()
    local zone = GetCurrentMapAreaID()
    local ORD = ns.oUF_RaidDebuffs or oUF_RaidDebuffs
    if ORD then
        ORD:ResetDebuffData()

        if instanceType == "party" or instanceType == "raid" then
            if G.Raid.RaidDebuffs.instances[zone] then
                ORD:RegisterDebuffs(G.Raid.RaidDebuffs.instances[zone])
            end
        end
    end
end

local function HideCompactRaid()
    if InCombatLockdown() then return end
    CompactRaidFrameManager:Kill()
    local compact_raid = CompactRaidFrameManager_GetSetting("IsShown")
    if compact_raid and compact_raid ~= "0" then
        CompactRaidFrameManager_SetSetting("IsShown", "0")
    end
end

function RA:HideBlizzard()
    hooksecurefunc("CompactRaidFrameManager_UpdateShown", HideCompactRaid)
    CompactRaidFrameManager:HookScript("OnShow", HideCompactRaid)
    CompactRaidFrameContainer:UnregisterAllEvents()

    HideCompactRaid()
    hooksecurefunc("CompactUnitFrame_RegisterEvents", CompactUnitFrame_UnregisterEvents)
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
    local stringTitle = R:StringTitle(layout)
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
        R:CreateMover(self[layout], "RayUF_"..stringTitle.."Mover", L[stringTitle.." Mover"], nil, nil, "ALL,RAID", true)

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
        R:CreateMover(self[layout], "RayUF_"..stringTitle.."Mover", L[stringTitle.." Mover"], nil, nil, "ALL,RAID", true)
    end

    self[layout].visibility = RA.groupConfig[layout].visibility
    if RA[stringTitle.."SmartVisibility"] then
        self[layout]:SetScript("OnEvent", RA[stringTitle.."SmartVisibility"])
        RA[stringTitle.."SmartVisibility"](self[layout])
    end
end

function RA:Initialize()
    if not self.db.enable then return end

    for class, color in next, RayUF.colors.class do
        RA.colorCache[class] = RA:Hex(color)
    end

    for dtype, color in next, DebuffTypeColor do
        RA.debuffColor[dtype] = RA:Hex(color)
    end

    self.glowBorder = {
        bgFile = R["media"].blank,
        edgeFile = R["media"].glow, edgeSize = R:Scale(5),
        insets = {left = R:Scale(3), right = R:Scale(3), top = R:Scale(3), bottom = R:Scale(3)}
    }

    for i = 1, 4 do
        local frame = _G["PartyMemberFrame"..i]
        frame:UnregisterAllEvents()
        frame:Kill()

        local health = frame.healthbar
        if(health) then
            health:UnregisterAllEvents()
        end

        local power = frame.manabar
        if(power) then
            power:UnregisterAllEvents()
        end

        local spell = frame.spellbar
        if(spell) then
            spell:UnregisterAllEvents()
        end

        local altpowerbar = frame.powerBarAlt
        if(altpowerbar) then
            altpowerbar:UnregisterAllEvents()
        end
    end
    self:HideBlizzard()
    self:RegisterEvent("GROUP_ROSTER_UPDATE", "HideBlizzard")
    UIParent:UnregisterEvent("GROUP_ROSTER_UPDATE")

	for layout, config in pairs(self["headerstoload"]) do
        local stringTitle = R:StringTitle(layout)
		local groupFilter, template = unpack(config)
        self["Fetch"..stringTitle.."Settings"](self)
		self:CreateHeaderGroup(layout, groupFilter, template)
	end
    self["headerstoload"] = nil

    RegisterDebuffs()
    local ORD = ns.oUF_RaidDebuffs or oUF_RaidDebuffs
    if ORD then
        ORD.MatchBySpellName = false
    end

    local event = CreateFrame("Frame")
    event:RegisterEvent("ZONE_CHANGED_NEW_AREA")
    event:RegisterEvent("PLAYER_ENTERING_WORLD")
    event:SetScript("OnEvent", RegisterDebuffs)
end

function RA:Info()
    return L["|cff7aa6d6Ray|r|cffff0000U|r|cff7aa6d6I|r团队模块."]
end

R:RegisterModule(RA:GetName())
