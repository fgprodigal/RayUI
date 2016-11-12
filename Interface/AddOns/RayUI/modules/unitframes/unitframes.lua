local R, L, P, G = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, GlobalDB
local UF = R:NewModule("UnitFrames", "AceEvent-3.0", "AceTimer-3.0")
local oUF = RayUF or oUF

--Cache global variables
--Lua functions
local unpack, pairs = unpack, pairs
local gsub = string.gsub

--WoW API / Variables
local CreateFrame = CreateFrame
local IsAddOnLoaded = IsAddOnLoaded

--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: RayUF, RayUF_Player, RayUF_Target, RayUIPetBar, RayUF_Focus, MAX_BOSS_FRAMES, SpellActivationOverlayFrame

UF.modName = L["头像"]

UF.Layouts = {}
UF.unitstoload = {}

UF.classMaxResourceBar = {
    ["DEATHKNIGHT"] = 6,
    ["PALADIN"] = 5,
    ["WARLOCK"] = 5,
    ["MONK"] = 6,
    ["MAGE"] = 4,
    ["ROGUE"] = 8,
    ["DRUID"] = 5
}

function UF:Construct_UnitFrames(frame, unit)
    frame:RegisterForClicks("AnyUp")
    frame:SetScript("OnEnter", self.UnitFrame_OnEnter)
    frame:SetScript("OnLeave", self.UnitFrame_OnLeave)

    frame.RaisedElementParent = CreateFrame("Frame", nil, frame)
    frame.RaisedElementParent:SetFrameLevel(frame:GetFrameLevel() + 100)
    frame:SetFrameLevel(5)

    local stringTitle = R:StringTitle(unit)
    if stringTitle:find("target") then
        stringTitle = gsub(stringTitle, "target", "Target")
    end
    stringTitle = gsub(stringTitle, "%d", "")
    self["Construct_"..stringTitle.."Frame"](self, frame, unit)
    if self.db.units[unit] then
        frame:SetPoint(unpack(self.db.units[unit].defaultPosition))
    end
end

function UF:LoadFakeUnitFrames()
    local player = CreateFrame("Frame", "RayUF_Player", R.UIParent)
    player:Point("BOTTOMRIGHT", R.UIParent, "BOTTOM", -80, 390)
    player:Size(220, 32)
    player:Show()

    local target = CreateFrame("Frame", "RayUF_Target", R.UIParent)
    target:Point("BOTTOMLEFT", R.UIParent, "BOTTOM", 80, 390)
    target:Size(220, 32)
    target:Show()

    local focus = CreateFrame("Frame", "RayUF_Focus", R.UIParent)
    focus:Point("BOTTOMRIGHT", RayUF_Player, "TOPLEFT", -20, 20)
    focus:Size(170, 32)
    focus:Show()
end

function UF:LoadUnitFrames()
    for _, unit in pairs(self["unitstoload"]) do
        local frameName = R:StringTitle(unit)
        frameName = frameName:gsub("t(arget)", "T%1")
        if not self[unit] then
            self[unit] = RayUF:Spawn(unit, "RayUF_"..frameName)
            R:CreateMover(self[unit], self[unit]:GetName().."Mover", L[frameName.." Mover"], nil, nil, "ALL,GENERAL,RAID")
        end
    end

    if self.db.units.arena.enable and not IsAddOnLoaded("Gladius") then
        local ArenaHeader = CreateFrame("Frame", nil, R.UIParent)
        ArenaHeader:Point("TOPRIGHT", R.UIParent, "RIGHT", -110, 200)
        ArenaHeader:Width(self.db.units.arena.width)
        ArenaHeader:Height(R:Scale(self.db.units.arena.height)*5 + R:Scale(36)*4)
        self.arena = {}
        for i = 1, 5 do
            self.arena[i] = RayUF:Spawn("arena"..i, "RayUF_Arena"..i)
            if i == 1 then
                self.arena[i]:Point("TOPRIGHT", ArenaHeader, "TOPRIGHT", 0, 0)
            else
                self.arena[i]:Point("TOP", self.arena[i-1], "BOTTOM", 0, -36)
            end
            self.arena[i]:Show()
        end
        R:CreateMover(ArenaHeader, "ArenaHeaderMover", "Arena", nil, nil, "ALL,ARENA")
        self:RegisterEvent("ARENA_PREP_OPPONENT_SPECIALIZATIONS", "UpdatePrep")
        self:RegisterEvent("ARENA_OPPONENT_UPDATE", "UpdatePrep")
        self:RegisterEvent("PLAYER_ENTERING_WORLD", "UpdatePrep")
    end

    if self.db.units.boss.enable then
        local BossHeader = CreateFrame("Frame", nil, R.UIParent)
        BossHeader:Point("TOPRIGHT", R.UIParent, "RIGHT", -80, 200)
        BossHeader:Width(self.db.units.boss.width)
        BossHeader:Height(R:Scale(self.db.units.boss.height)*MAX_BOSS_FRAMES + R:Scale(36)*(MAX_BOSS_FRAMES-1))
        local boss = {}
        for i = 1, MAX_BOSS_FRAMES do
            boss[i] = RayUF:Spawn("boss"..i, "RayUF_Boss"..i)
            if i == 1 then
                boss[i]:Point("TOPRIGHT", BossHeader, "TOPRIGHT", 0, 0)
            else
                boss[i]:Point("TOP", boss[i-1], "BOTTOM", 0, -36)
            end
            boss[i]:Size(self.db.units.boss.width, self.db.units.boss.height)
            boss[i]:Show()
        end
        R:CreateMover(BossHeader, "BossHeaderMover", "首领头像", nil, nil, "ALL,RAID15,RAID25,RAID40")
    end

    if self.db.smartAura then
        SpellActivationOverlayFrame:SetFrameStrata("BACKGROUND")
        SpellActivationOverlayFrame:SetFrameLevel(0)
    end
end

function UF:Initialize()
    if self.db.enable then
        RayUF:RegisterStyle("RayUF", function(frame, unit)
                UF:Construct_UnitFrames(frame, unit)
            end)
        self:LoadUnitFrames()
    else
        self:LoadFakeUnitFrames()
    end
end

function UF:Info()
    return L["|cff7aa6d6Ray|r|cffff0000U|r|cff7aa6d6I|r头像模块."]
end

R:RegisterModule(UF:GetName())
