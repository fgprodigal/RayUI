local R, L, P, G = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, GlobalDB
local M = R:GetModule("Misc")
local mod = M:NewModule("TotemBar", "AceEvent-3.0")

--Cache global variables
--Lua functions
local _G = _G

--WoW API / Variables
local CreateFrame = CreateFrame
local GetTotemInfo = GetTotemInfo
local CooldownFrame_Set = CooldownFrame_Set

--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: MAX_TOTEMS, RayUIActionBar1

local eventFrame = CreateFrame("Frame")

local function Update(self,event)
    local displayedTotems = 0
    for i=1, MAX_TOTEMS do
        local haveTotem, name, startTime, duration, icon = GetTotemInfo(i);
        if haveTotem and icon and icon ~= "" then
            mod.totembar[i]:Show()
            mod.totembar[i].iconTexture:SetTexture(icon)
            displayedTotems = displayedTotems + 1
            CooldownFrame_Set(mod.totembar[i].cooldown, startTime, duration, true, true)

            for d=1, MAX_TOTEMS do
                if _G["TotemFrameTotem"..d.."IconTexture"]:GetTexture() == icon then
                    _G["TotemFrameTotem"..d]:ClearAllPoints();
                    _G["TotemFrameTotem"..d]:SetParent(mod.totembar[i].holder);
                    _G["TotemFrameTotem"..d]:SetAllPoints(mod.totembar[i].holder);
                end
            end
        else
            mod.totembar[i]:Hide()
        end
    end
end

function mod:ToggleTotemEnable()
    if M.db.totembar.enable then
        self.totembar:Show()
        eventFrame:RegisterEvent("PLAYER_TOTEM_UPDATE", Update)
        eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD", Update)
        eventFrame:SetScript("OnEvent", Update)
        Update()
    else
        self.totembar:Hide()
        eventFrame:UnregisterEvent("PLAYER_TOTEM_UPDATE")
        eventFrame:UnregisterEvent("PLAYER_ENTERING_WORLD")
    end
end

function mod:PositionAndSizeTotem()
    local db = M.db.totembar

    for i=1, MAX_TOTEMS do
        local button = self.totembar[i]
        local prevButton = self.totembar[i-1]
        button:Size(db.size)
        button:ClearAllPoints()
        if db.growthDirection == "HORIZONTAL" and db.sortDirection == "ASCENDING" then
            if i == 1 then
                button:SetPoint("LEFT", self.totembar, "LEFT", 0, 0)
            elseif prevButton then
                button:SetPoint("LEFT", prevButton, "RIGHT", db.spacing, 0)
            end
        elseif db.growthDirection == "VERTICAL" and db.sortDirection == "ASCENDING" then
            if i == 1 then
                button:SetPoint("TOP", self.totembar, "TOP", 0, 0)
            elseif prevButton then
                button:SetPoint("TOP", prevButton, "BOTTOM", 0, -db.spacing)
            end
        elseif db.growthDirection == "HORIZONTAL" and db.sortDirection == "DESCENDING" then
            if i == 1 then
                button:SetPoint("RIGHT", self.totembar, "RIGHT", 0, 0)
            elseif prevButton then
                button:SetPoint("RIGHT", prevButton, "LEFT", -db.spacing, 0)
            end
        else
            if i == 1 then
                button:SetPoint("BOTTOM", self.totembar, "BOTTOM", 0, 0)
            elseif prevButton then
                button:SetPoint("BOTTOM", prevButton, "TOP", 0, db.spacing)
            end
        end
    end

    if db.growthDirection == "HORIZONTAL" then
        self.totembar:Width(db.size*(MAX_TOTEMS) + db.spacing*(MAX_TOTEMS) + db.spacing)
        self.totembar:Height(db.size + db.spacing*2)
    else
        self.totembar:Height(db.size*(MAX_TOTEMS) + db.spacing*(MAX_TOTEMS) + db.spacing)
        self.totembar:Width(db.size + db.spacing*2)
    end
    Update()
end

function mod:Initialize()
    local bar = CreateFrame("Frame", "RayUI_TotemBar", R.UIParent)
    bar:SetPoint("TOPRIGHT", RayUIActionBar1, "TOPLEFT", -4, 0)
    self.totembar = bar;

    for i=1, MAX_TOTEMS do
        local frame = CreateFrame("Button", bar:GetName().."Totem"..i, bar)
        frame:SetID(i)
        frame:CreateShadow("Background")
        frame:StyleButton(true)
        frame:Hide()
        frame.holder = CreateFrame("Frame", nil, frame)
        frame.holder:SetAlpha(0)
        frame.holder:SetAllPoints()

        frame.iconTexture = frame:CreateTexture(nil, "ARTWORK")
        frame.iconTexture:SetInside(2)
        frame.iconTexture:SetTexCoord(.08, .92, .08, .92)

        frame.cooldown = CreateFrame("Cooldown", frame:GetName().."Cooldown", frame, "CooldownFrameTemplate")
        frame.cooldown:SetReverse(true)
        frame.cooldown:SetInside(2)
        self.totembar[i] = frame
    end

    self:ToggleTotemEnable()
    self:PositionAndSizeTotem()

    R:CreateMover(bar, "TotemBarMover", L["图腾条"]);
end

M:RegisterMiscModule(mod:GetName())
