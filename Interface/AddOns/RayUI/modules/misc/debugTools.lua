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
local StaticPopup_Hide = StaticPopup_Hide
local LoadAddOn = LoadAddOn

--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: ScriptErrorsFrame, ScriptErrorsFrameScrollFrameText, ScriptErrorsFrameScrollFrame, UIParent

--Enhanced debugtools from ElvUI
local D = M:NewModule("DebugTools", "AceEvent-3.0", "AceHook-3.0", "AceConsole-3.0")

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

    self.MessagePrinted = true
end

function D:PLAYER_REGEN_ENABLED()
	ScriptErrorsFrame:SetParent(UIParent)
	self.MessagePrinted = nil
end

function D:PLAYER_REGEN_DISABLED()
    ScriptErrorsFrame:SetParent(self.HideFrame)
end

function D:TaintError(event, addonName, addonFunc)
    if GetCVarBool("scriptErrors") ~= true or addonName ~= "RayUI" then return end
    R:ThrowError(L["%s: %s 尝试调用保护函数 '%s'."]:format(event, addonName or "<name>", addonFunc or "<func>"))
    -- ScriptErrorsFrame_OnError(L["%s: %s 尝试调用保护函数 '%s'."]:format(event, addonName or "<name>", addonFunc or "<func>"), nil, false)
end

function D:ShowScriptErrorsFrame()
    ScriptErrorsFrame:Show()
    ScriptErrorsFrame:SetParent(R.UIParent)
end

function D:StaticPopup_Show(name)
	if(name == "ADDON_ACTION_FORBIDDEN") then
		StaticPopup_Hide(name)
	end
end

function D:Initialize()
    if( not IsAddOnLoaded("Blizzard_DebugTools") ) then
        LoadAddOn("Blizzard_DebugTools")
    end

    SetCVar("scriptErrors", 1)
    self:ModifyErrorFrame()
    self:SecureHook("ScriptErrorsFrame_UpdateButtons")
    self:SecureHook("ScriptErrorsFrame_OnError")
    self:SecureHook('StaticPopup_Show')
    self:RegisterEvent("PLAYER_REGEN_DISABLED")
    self:RegisterEvent("PLAYER_REGEN_ENABLED")
    if R:IsDeveloper() then
        self:RegisterEvent("ADDON_ACTION_BLOCKED", "TaintError")
        self:RegisterEvent("ADDON_ACTION_FORBIDDEN", "TaintError")
    end
    self:RegisterChatCommand("error", "ShowScriptErrorsFrame")

    self.HideFrame = CreateFrame("Frame")
    self.HideFrame:Hide()
end

M:RegisterMiscModule(D:GetName())
