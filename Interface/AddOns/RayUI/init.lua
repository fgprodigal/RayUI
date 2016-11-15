local AddOnName, Engine = ...
local AddOn = LibStub("AceAddon-3.0"):NewAddon(AddOnName, "AceConsole-3.0", "AceEvent-3.0", "AceHook-3.0")
local Locale = LibStub("AceLocale-3.0"):GetLocale(AddOnName, false)

--Cache global variables
--Lua functions
local _G = _G
local pairs = pairs

--WoW API / Variables
local CreateFrame = CreateFrame
local ToggleHelpFrame = ToggleHelpFrame
local StaticPopup_Show = StaticPopup_Show
local InCombatLockdown = InCombatLockdown
local IsAddOnLoaded = IsAddOnLoaded
local GetAddOnInfo = GetAddOnInfo
local LoadAddOn = LoadAddOn
local HideUIPanel = HideUIPanel
local hooksecurefunc = hooksecurefunc

--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: ERR_NOT_IN_COMBAT, LibStub, RayUICharacterData, BINDING_HEADER_RAYUI, GameTooltip, RayUIConfigTutorial
-- GLOBALS: GameMenuFrame, GameMenuButtonContinue, GameMenuButtonLogout, GameMenuButtonAddons

local DEFAULT_WIDTH = 850
local DEFAULT_HEIGHT = 650
AddOn.callbacks = AddOn.callbacks or LibStub("CallbackHandler-1.0"):New(AddOn)
AddOn.DF = {}
AddOn.DF["profile"] = {}
AddOn.DF["global"] = {}
AddOn.Options = {
    type = "group",
    name = AddOnName,
    args = {},
}

Engine[1] = AddOn
Engine[2] = Locale
Engine[3] = AddOn.DF["profile"]
Engine[4] = AddOn.DF["global"]

_G[AddOnName] = Engine

BINDING_HEADER_RAYUI = GetAddOnMetadata(..., "Title")

function AddOn:OnProfileChanged(event, database, newProfileKey)
    StaticPopup_Show("CFG_RELOAD")
end

function AddOn:PositionGameMenuButton()
	GameMenuFrame:SetHeight(GameMenuFrame:GetHeight() + GameMenuButtonLogout:GetHeight() - 4)
	local _, relTo, _, _, offY = GameMenuButtonLogout:GetPoint()
	if relTo ~= GameMenuFrame[AddOnName] then
		GameMenuFrame[AddOnName]:ClearAllPoints()
		GameMenuFrame[AddOnName]:Point("TOPLEFT", relTo, "BOTTOMLEFT", 0, -1)
		GameMenuButtonLogout:ClearAllPoints()
		GameMenuButtonLogout:Point("TOPLEFT", GameMenuFrame[AddOnName], "BOTTOMLEFT", 0, offY)
	end
end

function AddOn:OnInitialize()
    if not RayUICharacterData then
        RayUICharacterData = {}
    end

    local configButton = CreateFrame("Button", nil, GameMenuFrame, "GameMenuButtonTemplate")
    configButton:SetText(Locale["|cff7aa6d6Ray|r|cffff0000U|r|cff7aa6d6I|r设置"])
    configButton:SetScript("OnClick", function()
            if RayUIConfigTutorial then
                RayUIConfigTutorial:Hide()
                AddOn.global.Tutorial.configbutton = true
            end
            HideUIPanel(GameMenuFrame)
            self:OpenConfig()
        end)
    GameMenuFrame[AddOnName] = configButton

	configButton:Size(GameMenuButtonLogout:GetWidth(), GameMenuButtonLogout:GetHeight())
	configButton:Point("TOPLEFT", GameMenuButtonAddons, "BOTTOMLEFT", 0, -1)
	hooksecurefunc("GameMenuFrame_UpdateVisibleButtons", self.PositionGameMenuButton)

    self.data = LibStub("AceDB-3.0"):New("RayUIData", self.DF)
    self.data.RegisterCallback(self, "OnProfileChanged", "OnProfileChanged")
    self.data.RegisterCallback(self, "OnProfileCopied", "OnProfileChanged")
    self.data.RegisterCallback(self, "OnProfileReset", "OnProfileChanged")
    self.db = self.data.profile
    self.global = self.data.global

    self:UIScale()
    self:UpdateMedia()

    for k, v in self:IterateModules() do
        v.db = AddOn.db[k]
    end
    self:InitializeModules()
end

local f=CreateFrame("Frame")
f:RegisterEvent("PLAYER_LOGIN")
f:SetScript("OnEvent", function()
	AddOn:Initialize()
end)

function AddOn:PLAYER_REGEN_ENABLED()
    AddOn:OpenConfig()
    self:UnregisterEvent("PLAYER_REGEN_ENABLED")
end

function AddOn:PLAYER_REGEN_DISABLED()
    local err = false
    if IsAddOnLoaded("RayUI_Options") then
        local ACD = LibStub("AceConfigDialog-3.0")

        if ACD.OpenFrames[AddOnName] then
            self:RegisterEvent("PLAYER_REGEN_ENABLED")
            ACD:Close(AddOnName)
            err = true
        end
    end
    for name, _ in pairs(self.CreatedMovers) do
        if _G[name]:IsShown() then
            err = true
            _G[name]:Hide()
        end
    end
    if err == true then
        self:Print(ERR_NOT_IN_COMBAT)
        self:ToggleConfigMode(true)
    end
end

function AddOn:OpenConfig()
    if InCombatLockdown() then
        self:Print(ERR_NOT_IN_COMBAT)
        self:RegisterEvent("PLAYER_REGEN_ENABLED")
        return
    end

    if not IsAddOnLoaded("RayUI_Options") then
        local _, _, _, _, reason = GetAddOnInfo("RayUI_Options")
        if reason ~= "MISSING" and reason ~= "DISABLED" then
            LoadAddOn("RayUI_Options")
        end
    end

    local ACD = LibStub("AceConfigDialog-3.0")

    local mode = "Close"
    if not ACD.OpenFrames[AddOnName] then
        mode = "Open"
    end
    ACD[mode](ACD, AddOnName)
    GameTooltip:Hide()
end
