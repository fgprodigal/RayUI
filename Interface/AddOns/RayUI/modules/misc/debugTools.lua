local R, L, P, G = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, GlobalDB
local M = R:GetModule("Misc")
local S = R:GetModule("Skins")

--Cache global variables
--Lua functions
--WoW API / Variables
local CreateFrame = CreateFrame
local hooksecurefunc = hooksecurefunc
local ScriptErrorsFrame_Update = ScriptErrorsFrame_Update
local ScriptErrorsFrame_OnError = ScriptErrorsFrame_OnError
local InCombatLockdown = InCombatLockdown
local GetCVarBool = GetCVarBool
local SetCVar = SetCVar
local PlaySoundFile = PlaySoundFile
local IsAddOnLoaded = IsAddOnLoaded
local LoadAddOn = LoadAddOn

--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: ScriptErrorsFrame, ScriptErrorsFrameScrollFrameText, ScriptErrorsFrameScrollFrame

--Enhanced debugtools from ElvUI
local D = M:NewModule("DebugTools", "AceEvent-3.0", "AceHook-3.0", "AceConsole-3.0")

local showErrorButton = CreateFrame("Button", nil, Minimap)
showErrorButton:Hide()
showErrorButton:Size(15, 15)
showErrorButton:SetPoint("RIGHT", -1, 0)
showErrorButton:SetScript("OnClick", function(self)
        ScriptErrorsFrame:SetParent(R.UIParent)
        D.MessagePrinted = nil
        self:Hide()
    end)

function D:ModifyErrorFrame()
    ScriptErrorsFrameScrollFrameText.cursorOffset = 0
    ScriptErrorsFrameScrollFrameText.cursorHeight = 0
    ScriptErrorsFrameScrollFrameText:SetScript("OnEditFocusGained", nil)

    local function ScriptErrors_UnHighlightText()
        ScriptErrorsFrameScrollFrameText:HighlightText(0, 0)
    end
    hooksecurefunc('ScriptErrorsFrame_Update', ScriptErrors_UnHighlightText)

    -- Unhighlight text when focus is hit
    local function UnHighlightText(self)
        self:HighlightText(0, 0)
    end
    ScriptErrorsFrameScrollFrameText:HookScript("OnEscapePressed", UnHighlightText)

    ScriptErrorsFrame:Size(500, 300)
    ScriptErrorsFrameScrollFrame:Size(ScriptErrorsFrame:GetWidth() - 45, ScriptErrorsFrame:GetHeight() - 71)

    local BUTTON_WIDTH = 75
    local BUTTON_HEIGHT = 24
    local BUTTON_SPACING = 2

    -- Add a first button
    local firstButton = CreateFrame("Button", nil, ScriptErrorsFrame, "UIPanelButtonTemplate")
    firstButton:Point("LEFT", ScriptErrorsFrame.reload, "RIGHT", BUTTON_SPACING, 0)
    firstButton:SetText(L["第一页"])
    firstButton:Height(BUTTON_HEIGHT)
    firstButton:Width(BUTTON_WIDTH)
    firstButton:SetScript("OnClick", function(self)
            ScriptErrorsFrame.index = 1
            ScriptErrorsFrame_Update()
        end)
    ScriptErrorsFrame.firstButton = firstButton
    S:Reskin(firstButton)

    -- Also add a Last button for errors
    local lastButton = CreateFrame("Button", nil, ScriptErrorsFrame, "UIPanelButtonTemplate")
    lastButton:Point("RIGHT", ScriptErrorsFrame.close, "LEFT", -BUTTON_SPACING, 0)
    lastButton:Height(BUTTON_HEIGHT)
    lastButton:Width(BUTTON_WIDTH)
    lastButton:SetText(L["最后页"])
    lastButton:SetScript("OnClick", function(self)
            ScriptErrorsFrame.index = #(ScriptErrorsFrame.order)
            ScriptErrorsFrame_Update()
        end)
    ScriptErrorsFrame.lastButton = lastButton
    S:Reskin(lastButton)
end

function D:ScriptErrorsFrame_UpdateButtons()
    local numErrors = #ScriptErrorsFrame.order
    local index = ScriptErrorsFrame.index
    if ( index == 0 ) then
        ScriptErrorsFrame.lastButton:Disable()
        ScriptErrorsFrame.firstButton:Disable()
    else
        if ( numErrors == 1 ) then
            ScriptErrorsFrame.lastButton:Disable()
            ScriptErrorsFrame.firstButton:Disable()
        else
            ScriptErrorsFrame.lastButton:Enable()
            ScriptErrorsFrame.firstButton:Enable()
        end
    end
end

function D:ScriptErrorsFrame_OnError(_, _, keepHidden)
    if keepHidden or self.MessagePrinted or not InCombatLockdown() or GetCVarBool("scriptErrors") ~= true then return end

    PlaySoundFile(R["media"].errorsound)
    R:Print(L['|cFFE30000接收到Lua错误. 可以通过点击小地图的"E"按钮查看错误.'])
    showErrorButton:Show()
    self.MessagePrinted = true
end

function D:PLAYER_REGEN_DISABLED()
    ScriptErrorsFrame:SetParent(self.HideFrame)
end

function D:TaintError(event, addonName, addonFunc)
    if GetCVarBool("scriptErrors") ~= true or not R:IsDeveloper() or addonName ~= "RayUI" then return end
    ScriptErrorsFrame_OnError(L["%s: %s 尝试调用保护函数 '%s'."]:format(event, addonName or "<name>", addonFunc or "<func>"), false)
end

function D:ShowScriptErrorsFrame()
    ScriptErrorsFrame:Show()
    ScriptErrorsFrame:SetParent(R.UIParent)
end

function D:Initialize()
    local showErrorButtonText = showErrorButton:CreateFontString(nil, "OVERLAY")
    showErrorButtonText:SetPoint("CENTER", 2, 1)
    showErrorButtonText:SetFont(R["media"].pxfont, R.mult*10, "OUTLINE,MONOCHROME")
    showErrorButtonText:SetText("|cffff0000E|r")

    SetCVar("scriptErrors", 1)
    D:ModifyErrorFrame()
    D:SecureHook("ScriptErrorsFrame_UpdateButtons")
    D:SecureHook("ScriptErrorsFrame_OnError")
    D:RegisterEvent("PLAYER_REGEN_DISABLED")
    -- D:RegisterEvent("ADDON_ACTION_BLOCKED", "TaintError")
    D:RegisterEvent("ADDON_ACTION_FORBIDDEN", "TaintError")
    D:RegisterChatCommand("error", "ShowScriptErrorsFrame")

    D.HideFrame = CreateFrame("Frame")
    D.HideFrame:Hide()

    if( not IsAddOnLoaded("Blizzard_DebugTools") ) then
        LoadAddOn("Blizzard_DebugTools")
    end
end

M:RegisterMiscModule(D:GetName())
