----------------------------------------------------------
-- Load RayUI Environment
----------------------------------------------------------
_LoadRayUIEnv_()


local CT = R:NewModule("CombatText", "AceEvent-3.0", "AceHook-3.0", "AceTimer-3.0", "AceConsole-3.0")
local xCP = LibStub("xCombatParser-1.0-RayUI", true)
CT.modName = L["战斗文字"]

--Cache global variables
--Lua functions
local _G, pairs, unpack, type, string, table = _G, pairs, unpack, type, string, table
local tostring, tonumber = tostring, tonumber

--WoW API / Variables
local CreateFrame = CreateFrame
local GetSpellTexture = GetSpellTexture
local UnitGUID = UnitGUID
local SetCVar = SetCVar

--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: PET_ATTACK_TEXTURE, CombatText, InterfaceOptionsCombatPanelEnableFloatingCombatText, InterfaceOptionsCombatPanelEnableFloatingCombatTextText
-- GLOBALS: SCROLLING_MESSAGE_FRAME_INSERT_MODE_TOP, RayUF

local showreceived = true
local showoutput = true

local iconSize = 25
local msgiconSize = 22

local showdots = true
local showhots = true

local ctshowpet = true
local fadetime = 3

local frameIndex = {
    [1] = "outgoing",
    [2] = "incoming",
    [3] = "healing",
    [4] = "message",
    [5] = "power",
}

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

local enablePower = {
    ["MANA"] = true,
    ["RAGE"] = true,
    ["FOCUS"] = true,
    ["ENERGY"] = true,

    ["RUNES"] = false,
    ["RUNIC_POWER"] = true,
    ["SOUL_SHARDS"] = true,
    ["LUNAR_POWER"] = false,

    ["HOLY_POWER"] = false,
    ["ALTERNATE_POWER"] = false,
    ["CHI"] = false,
    ["INSANITY"] = true,

    ["ARCANE_CHARGES"] = false,
    ["FURY"] = true,
    ["PAIN"] = true,
}

local format_spell_icon = " |T%s:%d:%d:0:0:64:64:5:59:5:59|t"

local function IsMerged(spellID)
    local merged = false
    spellID = CT.merge2h[spellID] or spellID
    return CT.merges[spellID] ~= nil
end

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

function CT:AddMessage( framename, message, color)
    self.frames[framename]:AddMessage(message, unpack(color))
end

local spamHeap, spamStack, now = {}, {}, 0
local spam_format = "%s |cffffffffx%s|r"
function CT:AddSpamMessage(framename, mergeID, message, color, interval, prep)
    -- Check for a Secondary Spell ID
    mergeID = CT.merge2h[mergeID] or mergeID

    local heap, stack = spamHeap[framename], spamStack[framename]
    if heap[mergeID] then
        heap[mergeID].color = color
        table.insert(heap[mergeID].entries, message)

        if heap[mergeID].last + heap[mergeID].update <= now then
            heap[mergeID].last = now
        end
    else
        local db = CT.merges[mergeID]
        heap[mergeID] = {
            -- last update
            last = now,

            -- how often to update
            update = interval or (db and db.interval) or 3,

            prep = prep or (db and db.prep) or interval or 3,

            -- entries to merge
            entries = {
                message,
            },

            -- color
            color = color,
        }
        table.insert(stack, mergeID)
    end
end

for _, frameName in pairs(frameIndex) do
    spamHeap[frameName] = {}
    spamStack[frameName] = {}
end

local index = 1
local frames = {}

function CT.OnSpamUpdate(self, elapsed)
    -- Update 'now'
    now = now + elapsed

    -- Check to see if we are out of bounds
    if index > #frameIndex then index = 1 end
    if not frames[frameIndex[index]] then
        frames[frameIndex[index]] = 1
    end

    local heap, stack, idIndex =
    spamHeap[frameIndex[index]], -- the heap contains merge entries
    spamStack[frameIndex[index]], -- the stack contains lookup values
    frames[frameIndex[index]] -- this frame's last entry index

    -- Check to see if we are out of bounds
    if idIndex > #stack then
        idIndex = 1
    end

    -- This item contains a lot of information about what we need to merge
    local item = heap[stack[idIndex]]

    --if item then print(item.last, "+", item.update, "<", now) end
    if item and item.last + item.update <= now and #item.entries > 0 then
        item.last = now

        -- Add up all the entries
        local total = 0
        for _, amount in pairs(item.entries) do
            if not tonumber(amount) then total = amount; break end
            total = total + amount -- Add all the amounts
        end

        -- total as a string
        local message = tostring(total)

        -- Abbreviate the merged total
        if tonumber(total) then
            message = R:ShortValue(tonumber(total))
        end

        --local format_mergeCount = "%s |cffFFFFFFx%s|r"
        local strColor = "ffffff"

        -- Show healer name (colored)
        if frameIndex[index] == "healing" then
            --format_mergeCount = "%s |cffFFFF00x%s|r"
            local strColor = "ffff00"
            message = string.format("+%s", message)
        end

        -- Add merge count
        if #item.entries > 1 then
            message = string.format(spam_format, message, #item.entries)
        end

        -- Add Icons
        if type(stack[idIndex]) == "number" then
            message = CT:GetSpellTextureFormatted( stack[idIndex],
                message,
                nil,
                iconSize,
                CT.frames[frameIndex[index]].justify,
                true, -- Merge Override = true
                #item.entries )
        elseif frameIndex[index] == "outgoing" then
            message = CT:GetSpellTextureFormatted( stack[idIndex],
                message,
                nil,
                iconSize,
                CT.frames[frameIndex[index]].justify,
                true, -- Merge Override = true
                #item.entries )
        else
            if #item.entries > 1 then
                message = string.format("%s |cff%sx%s|r", message, strColor, #item.entries)
            end
        end

        CT:AddMessage(frameIndex[index], message, item.color)

        -- Clear all the old entries, we dont need them anymore
        for k in pairs(item.entries) do
            item.entries[k] = nil
        end
    end

    frames[frameIndex[index]] = idIndex + 1
    index = index + 1
end

function CT:HealingOutgoing(args)
    local critical, spellID, isHoT, amount = args.critical, args.spellId, args.prefix == "SPELL_PERIODIC", args.amount
    if isHoT and not showhots then return end
    local message = CT:GetSpellTextureFormatted( spellID, R:ShortValue(amount), critical, iconSize, "RIGHT" )
    if IsMerged(spellID) then
        CT:AddSpamMessage("outgoing", spellID, amount, spellColors["HEAL"])
    else
        CT:AddMessage("outgoing", message, spellColors["HEAL"] )
    end
end

function CT:HealingIncoming(args)
    local critical, spellID, isHoT, amount = args.critical, args.spellId, args.prefix == "SPELL_PERIODIC", args.amount
    if isHoT and not showhots then return end
    local message = CT:GetSpellTextureFormatted( spellID, "+"..R:ShortValue(amount), critical, iconSize, "LEFT" )
    CT:AddMessage("healing", message, spellColors["HEAL"] )
end

function CT:DamageOutgoing(args)
    local critical, spellID, amount, merged = args.critical, args.spellId, args.amount
    local isSwing = args.prefix == "SWING"
    if isSwing and (args:IsSourceMyPet() or args:IsSourceMyVehicle()) then
        spellID = 0
    end
    local message = CT:GetSpellTextureFormatted( spellID, R:ShortValue(amount), critical, iconSize, "RIGHT" )
    if IsMerged(spellID) then
        CT:AddSpamMessage("outgoing", spellID, amount, spellColors[args.spellSchool])
    else
        CT:AddMessage("outgoing", message, spellColors[args.spellSchool] )
    end
end

function CT:DamageIncoming(args)
    local critical, amount, spellID = args.critical, args.amount, args.spellId
    local isSwing = args.prefix == "SWING"
    if isSwing then
        spellID = 0
    end
    local message = CT:GetSpellTextureFormatted( spellID, "-"..R:ShortValue(amount), critical, iconSize, "LEFT" )
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

function CT:COMBAT_TEXT_UPDATE(event, subevent, ...)
    if subevent == "ENERGIZE" or subevent == "PERIODIC_ENERGIZE" then
        local amount, energy_type = ...
        if enablePower[energy_type] then
            CT:AddMessage("power", string.format("+%s %s", R:ShortValue(amount), _G[energy_type]), RayUF.colors.power[energy_type])
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
    f:SetMaxLines(height/(iconSize + 10))
    f:SetJustifyH(justify)
    f.justify = justify

    return f
end

function CT:Initialize()
    if not self.db.enable then return end
    self.frames = {}
    self.frames["outgoing"] = self:CreateMessageFrame("OutGoing", 150, 200, "RIGHT")
    self.frames["outgoing"]:SetPoint("BOTTOMRIGHT", "RayUF_TargetTarget", "TOPRIGHT", 0, 20)

    self.frames["incoming"] = self:CreateMessageFrame("InComing", 150, 200, "LEFT")
    self.frames["incoming"]:SetPoint("BOTTOMLEFT", "RayUF_Player", "TOPLEFT", -150, 20)

    self.frames["healing"] = self:CreateMessageFrame("Healing", 150, 200, "LEFT")
    self.frames["healing"]:SetPoint("BOTTOMLEFT", "RayUF_Player", "TOPLEFT", -250, 20)

    self.frames["message"] = self:CreateMessageFrame("Message", 256, 100, "CENTER")
    self.frames["message"]:SetPoint("BOTTOM", R.UIParent, "CENTER", 0, 200)

    self.frames["power"] = self:CreateMessageFrame("Power", 256, 100, "CENTER")
    self.frames["power"]:SetPoint("TOP", R.UIParent, "CENTER", 0, -100)

    for _, frame in pairs(self.frames) do
        R:CreateMover(frame, frame:GetName().." Mover", L[frame:GetName()], true, nil, "ALL,GENERAL")
    end

    xCP:RegisterCombat(self.CombatLogEvent)

    CT.merge = CreateFrame("FRAME")
    CT.merge:SetScript("OnUpdate", CT.OnSpamUpdate)
    CT:RegisterEvent("COMBAT_TEXT_UPDATE")

    CombatText:UnregisterAllEvents()
    CombatText:SetScript("OnLoad", nil)
    CombatText:SetScript("OnEvent", nil)
    CombatText:SetScript("OnUpdate", nil)

    InterfaceOptionsCombatPanelEnableFloatingCombatText:Disable()
    InterfaceOptionsCombatPanelEnableFloatingCombatTextText:SetTextColor(.5, .5, .5)

    SetCVar("enableFloatingCombatText", 0)
end

R:RegisterModule(CT:GetName())
