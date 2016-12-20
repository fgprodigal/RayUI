local R, L, P, G = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, GlobalDB
local CT = R:NewModule("CombatText", "AceEvent-3.0", "AceHook-3.0", "AceTimer-3.0", "AceConsole-3.0")
local xCP = LibStub("xCombatParser-1.0-RayUI", true)
-- CT.modName = L["CombatText"]

--Cache global variables
--Lua functions
local _G, unpack, type, string = _G, unpack, type, string

--WoW API / Variables
local CreateFrame = CreateFrame
local GetSpellTexture = GetSpellTexture
local UnitGUID = UnitGUID
local SetCVar = SetCVar

--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: PET_ATTACK_TEXTURE, CombatText, InterfaceOptionsCombatPanelEnableFloatingCombatText, InterfaceOptionsCombatPanelEnableFloatingCombatTextText

local showreceived = true
local showoutput = true

local iconSize = 30
local msgiconSize = 22

local showdots = true
local showhots = true

local ctshowpet = true
local fadetime = 3

local frames = {}
-- local spellColors = {
-- [0] = { 0, 1, 0 }, -- heal
-- [1] = { 1, 1, 0 }, -- physical
-- [2] = { 1, .9, .5 }, -- holy
-- [4] = { 1, .5, 0 }, -- fire
-- [8] = { .3, 1, .3 }, -- nature
-- [16] = { .5, 1, 1 }, -- frost
-- [32] = { .5, .5, 1 }, -- shadow
-- [64] = { 1, .5, 1 }, -- arcane
-- }
local spellColors = {
    -- Vanilla Schools
    [SCHOOL_MASK_PHYSICAL] = { 1.00, 1.00, 1.00 },
    [SCHOOL_MASK_HOLY] = { 1.00, 0.90, 0.50 },
    [SCHOOL_MASK_FIRE] = { 1.00, 0.5, 0 },
    [SCHOOL_MASK_NATURE] = { 0.30, 1.00, 0.30 },
    [SCHOOL_MASK_FROST] = { 0.5, 1.00, 1.00 },
    [SCHOOL_MASK_SHADOW] = { 0.50, 0.50, 1.00 },
    [SCHOOL_MASK_ARCANE] = { 1.00, 0.50, 1.00 },

    -- Physical and a Magical
    [SCHOOL_MASK_PHYSICAL + SCHOOL_MASK_FIRE] = { 1.00, 0.58, 0.59 },
    [SCHOOL_MASK_PHYSICAL + SCHOOL_MASK_FROST] = { 0.65, 0.65, 0.95 },
    [SCHOOL_MASK_PHYSICAL + SCHOOL_MASK_ARCANE] = { 0.87, 0.87, 0.87 },
    [SCHOOL_MASK_PHYSICAL + SCHOOL_MASK_NATURE] = { 0.70, 1.00, 0.70 },
    [SCHOOL_MASK_PHYSICAL + SCHOOL_MASK_SHADOW] = { 1.00, 0.85, 1.00 },
    [SCHOOL_MASK_PHYSICAL + SCHOOL_MASK_HOLY] = { 1.00, 1.00, 0.83 },

    -- Two Magical Schools
    [SCHOOL_MASK_FIRE + SCHOOL_MASK_FROST] = { 0.65, 0.23, 0.54 },
    [SCHOOL_MASK_FIRE + SCHOOL_MASK_ARCANE] = { 0.87, 0.45, 0.47 },
    [SCHOOL_MASK_FIRE + SCHOOL_MASK_NATURE] = { 0.70, 0.58, 0.29 },
    [SCHOOL_MASK_FIRE + SCHOOL_MASK_SHADOW] = { 1.00, 0.43, 0.59 },
    [SCHOOL_MASK_FIRE + SCHOOL_MASK_HOLY] = { 1.00, 0.58, 0.24 },
    [SCHOOL_MASK_FROST + SCHOOL_MASK_ARCANE] = { 0.53, 0.53, 0.83 },
    [SCHOOL_MASK_FROST + SCHOOL_MASK_NATURE] = { 0.35, 0.65, 0.65 },
    [SCHOOL_MASK_FROST + SCHOOL_MASK_SHADOW] = { 0.65, 0.50, 0.95 },
    [SCHOOL_MASK_FROST + SCHOOL_MASK_HOLY] = { 0.65, 0.65, 0.60 },
    [SCHOOL_MASK_ARCANE + SCHOOL_MASK_NATURE] = { 0.58, 0.87, 0.58 },
    [SCHOOL_MASK_ARCANE + SCHOOL_MASK_SHADOW] = { 0.87, 0.73, 0.87 },
    [SCHOOL_MASK_ARCANE + SCHOOL_MASK_HOLY] = { 0.87, 0.87, 0.53 },
    [SCHOOL_MASK_NATURE + SCHOOL_MASK_SHADOW] = { 0.70, 0.85, 0.70 },
    [SCHOOL_MASK_NATURE + SCHOOL_MASK_HOLY] = { 0.70, 1.00, 0.35 },
    [SCHOOL_MASK_SHADOW + SCHOOL_MASK_HOLY] = { 1.00, 0.85, 0.65 },

    -- Three or More Schools
    [SCHOOL_MASK_FIRE + SCHOOL_MASK_FROST + SCHOOL_MASK_NATURE]
    = { 0.57, 0.48, 0.49 },

    [SCHOOL_MASK_FIRE + SCHOOL_MASK_FROST + SCHOOL_MASK_ARCANE + SCHOOL_MASK_NATURE + SCHOOL_MASK_SHADOW]
    = { 0.69, 0.58, 0.65 },

    [SCHOOL_MASK_FIRE + SCHOOL_MASK_FROST + SCHOOL_MASK_ARCANE + SCHOOL_MASK_NATURE + SCHOOL_MASK_SHADOW + SCHOOL_MASK_HOLY]
    = { 0.74, 0.65, 0.59 },

    [SCHOOL_MASK_PHYSICAL + SCHOOL_MASK_FIRE + SCHOOL_MASK_FROST + SCHOOL_MASK_ARCANE + SCHOOL_MASK_NATURE + SCHOOL_MASK_SHADOW + SCHOOL_MASK_HOLY]
    = { 0.78, 0.70, 0.65 },

    ["HEAL"] = { 0, 1.00, 0 },
    ["MISS"] = { 0.50, 0.50, 0.50 },
    ["DISPEL_BUFF"] = { 0, 1.00, 0.50 },
    ["INTERRUPT"] = { 1.00, 0, 0.50 },
}

local format_spell_icon = " |T%s:%d:%d:0:0:64:64:5:59:5:59|t"

function CT:GetSpellTextureFormatted( spellID, message, critical, iconSize, justify )
    iconSize = critical and ( iconSize + 10 ) or iconSize
    local icon = ""
    if spellID == 0 then
        icon = PET_ATTACK_TEXTURE
    elseif type(spellID) == "string" then
        icon = spellID
    else
        icon = GetSpellTexture( spellID ) or ""
    end

    if icon ~= "" then
        if justify == "LEFT" then
            message = string.format( critical and "%s |cffff0000*|r%s|cffff0000*|r" or "%s %s", string.format(format_spell_icon, icon, iconSize, iconSize), message)
        else
            message = string.format( critical and "|cffff0000*|r%s|cffff0000*|r%s" or "%s%s", message, string.format(format_spell_icon, icon, iconSize, iconSize))
        end
    else
        message = string.format( critical and "|cffff0000*|r%s|cffff0000*|r%" or "%s", message)
    end

    return message
end

function CT:AddMessage( frame, message, color)
    self.frames[frame]:AddMessage(message, unpack(color))
end

function CT:HealingOutgoing(args)
    local critical, spellID, isHoT, amount = args.critical, args.spellId, args.prefix == "SPELL_PERIODIC", args.amount
    if isHoT and not showhots then return end
    local message = CT:GetSpellTextureFormatted( spellID, R:ShortValue(amount), critical, iconSize, "RIGHT" )
    CT:AddMessage("outgoing", message, spellColors["HEAL"] )
end

function CT:HealingIncoming(args)
    local critical, spellID, isHoT, amount = args.critical, args.spellId, args.prefix == "SPELL_PERIODIC", args.amount
    if isHoT and not showhots then return end
    local message = CT:GetSpellTextureFormatted( spellID, R:ShortValue(amount), critical, iconSize, "LEFT" )
    CT:AddMessage("incomingheal", message, spellColors["HEAL"] )
end

function CT:DamageOutgoing(args)
    local critical, spellID, amount, merged = args.critical, args.spellId, args.amount
    local isEnvironmental, isSwing, isAutoShot, isDoT = args.prefix == "ENVIRONMENTAL", args.prefix == "SWING", spellID == 75, args.prefix == "SPELL_PERIODIC"
    local message = CT:GetSpellTextureFormatted( spellID, R:ShortValue(amount), critical, iconSize, "RIGHT" )
    CT:AddMessage("outgoing", message, spellColors[args.spellSchool] )
end

function CT:DamageIncoming(args)
    local critical, amount, spellID = args.critical, args.amount, args.spellId
    local message = CT:GetSpellTextureFormatted( spellID, R:ShortValue(amount), critical, iconSize, "LEFT" )
    CT:AddMessage("incoming", message, spellColors[args.spellSchool] )
end

function CT:OutgoingMiss(args)
    local message, spellId = _G["COMBAT_TEXT_"..args.missType], args.spellId
    message = CT:GetSpellTextureFormatted( spellId, message, nil, iconSize, "RIGHT" )
    CT:AddMessage("outgoing", message, spellColors["MISS"] )
end

function CT:IncomingMiss(args)
    local message, spellId = _G["COMBAT_TEXT_"..args.missType], args.extraSpellId
    message = CT:GetSpellTextureFormatted( spellId, message, nil, iconSize, "LEFT" )
    CT:AddMessage("incoming", message, spellColors["MISS"] )
end

function CT:InterruptedUnit(args)
    local message = CT:GetSpellTextureFormatted( args.extraSpellId, args.extraSpellName, nil, msgiconSize, "LEFT" )
    CT:AddMessage("message", string.format("%s: %s", _G["ACTION_" .. args.event], message), spellColors["INTERRUPT"] )
end

function CT:SpellDispel(args)
    local message = CT:GetSpellTextureFormatted( args.extraSpellId, args.extraSpellName, nil, msgiconSize, "LEFT" )
    CT:AddMessage("message", string.format("%s: %s", _G["ACTION_" .. args.event], message), args.auraType == "BUFF" and spellColors["DISPEL_BUFF"] or spellColors["INTERRUPT"] )
end

function CT:SpellStolen(args)
    local message = CT:GetSpellTextureFormatted( args.extraSpellId, args.extraSpellName, nil, msgiconSize, "LEFT" )
    CT:AddMessage("message", string.format("%s: %s", _G["ACTION_" .. args.event], message), args.auraType == "BUFF" and spellColors["DISPEL_BUFF"] or spellColors["INTERRUPT"] )
end

function CT.CombatLogEvent(args)
    -- Is the source someone we care about?
    if args.isPlayer or args:IsSourceMyVehicle() or ctshowpet and args:IsSourceMyPet() then
        if args.suffix == "_HEAL" then
            CT:HealingOutgoing(args)

        elseif args.suffix == "_DAMAGE" then
            CT:DamageOutgoing(args)

        elseif args.suffix == "_MISSED" then
            CT:OutgoingMiss(args)

        elseif args.event == "PARTY_KILL" then
            -- CT:KilledUnit(args)

        elseif args.event == "SPELL_INTERRUPT" then
            CT:InterruptedUnit(args)

        elseif args.event == "SPELL_DISPEL" then
            CT:SpellDispel(args)

        elseif args.event == "SPELL_STOLEN" then
            CT:SpellStolen(args)

        end
    end

    -- Is the destination someone we care about?
    if args.atPlayer or args:IsDestinationMyVehicle() then
        if args.suffix == "_HEAL" then
            CT:HealingIncoming(args)

        elseif args.suffix == "_DAMAGE" then
            CT:DamageIncoming(args)

        elseif args.suffix == "_MISSED" then
            CT:IncomingMiss(args)

        end
    end
end

function CT:CreateMessageFrame(name, width, height, justify)
    local f = CreateFrame("ScrollingMessageFrame", "RayUI_CombatText_"..name, R.UIParent)
    f:SetFont(R["media"].dmgfont, R["media"].fontsize+2, "OUTLINE")
    f:SetFadeDuration(0.2)
    f:SetTimeVisible(fadetime)
    f:SetSpacing(2)
    f:SetWidth(width)
    f:SetHeight(height)
    f:SetMaxLines(height/(R["media"].fontsize+2))
    f:SetJustifyH(justify)

    return f
end

function CT:Initialize()
    self.frames = {}
    self.frames["outgoing"] = self:CreateMessageFrame("OutGoing", 150, 200, "RIGHT")
    self.frames["outgoing"]:SetPoint("BOTTOMRIGHT", "RayUF_TargetTarget", "TOPRIGHT", 0, 20)
    self.frames["incoming"] = self:CreateMessageFrame("InComing", 150, 200, "LEFT")
    self.frames["incoming"]:SetPoint("BOTTOMLEFT", "RayUF_Player", "TOPLEFT", -150, 20)
    self.frames["incomingheal"] = self:CreateMessageFrame("InComingHeal", 150, 200, "LEFT")
    self.frames["incomingheal"]:SetPoint("BOTTOMLEFT", "RayUF_Player", "TOPLEFT", -250, 20)
    self.frames["message"] = self:CreateMessageFrame("Message", 256, 100, "CENTER")
    self.frames["message"]:SetPoint("BOTTOM", R.UIParent, "CENTER", 0, 200)

    xCP:RegisterCombat(self.CombatLogEvent)

    CombatText:UnregisterAllEvents()
    CombatText:SetScript("OnLoad", nil)
    CombatText:SetScript("OnEvent", nil)
    CombatText:SetScript("OnUpdate", nil)

    InterfaceOptionsCombatPanelEnableFloatingCombatText:Disable()
    InterfaceOptionsCombatPanelEnableFloatingCombatTextText:SetTextColor(.5, .5, .5)

    SetCVar("enableFloatingCombatText", 0)
end

R:RegisterModule(CT:GetName())
