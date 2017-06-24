----------------------------------------------------------
-- Load RayUI Environment
----------------------------------------------------------
RayUI:LoadEnv()


local AddOn = LibStub("AceAddon-3.0"):NewAddon(_AddOnName, "AceConsole-3.0", "AceEvent-3.0", "AceHook-3.0")
local Locale = LibStub("AceLocale-3.0"):GetLocale(_AddOnName, false)


local DEFAULT_WIDTH = 850
local DEFAULT_HEIGHT = 650
AddOn.callbacks = AddOn.callbacks or LibStub("CallbackHandler-1.0"):New(AddOn)
AddOn.DF = {}
AddOn.DF["profile"] = {}
AddOn.DF["global"] = {}
AddOn.Options = {
    type = "group",
    name = _AddOnName,
    args = {},
}

R = AddOn
L = Locale
P = AddOn.DF["profile"]
G = AddOn.DF["global"]

BINDING_HEADER_RAYUI = GetAddOnMetadata(..., "Title")

function AddOn:OnProfileChanged(event, database, newProfileKey)
    StaticPopup_Show("CFG_RELOAD")
end

function AddOn:PositionGameMenuButton()
	GameMenuFrame:SetHeight(GameMenuFrame:GetHeight() + GameMenuButtonLogout:GetHeight() - 4)
	local _, relTo, _, _, offY = GameMenuButtonLogout:GetPoint()
	if relTo ~= GameMenuFrame[_AddOnName] then
		GameMenuFrame[_AddOnName]:ClearAllPoints()
		GameMenuFrame[_AddOnName]:Point("TOPLEFT", relTo, "BOTTOMLEFT", 0, -1)
		GameMenuButtonLogout:ClearAllPoints()
		GameMenuButtonLogout:Point("TOPLEFT", GameMenuFrame[_AddOnName], "BOTTOMLEFT", 0, offY)
	end
end

function AddOn:OnInitialize()
    if not _G.RayUICharacterData then
        _G.RayUICharacterData = {}
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
    GameMenuFrame[_AddOnName] = configButton

	configButton:Size(GameMenuButtonLogout:GetWidth(), GameMenuButtonLogout:GetHeight())
	configButton:Point("TOPLEFT", GameMenuButtonAddons, "BOTTOMLEFT", 0, -1)
	hooksecurefunc("GameMenuFrame_UpdateVisibleButtons", self.PositionGameMenuButton)

    self:LoadDeveloperConfig()

    self.data = LibStub("AceDB-3.0"):New("RayUIData", self.DF)
    self.data.RegisterCallback(self, "OnProfileChanged", "OnProfileChanged")
    self.data.RegisterCallback(self, "OnProfileCopied", "OnProfileChanged")
    self.data.RegisterCallback(self, "OnProfileReset", "OnProfileChanged")
    self.db = self.data.profile
    self.global = self.data.global

    self:UIScale()
    self:UpdateMedia()

    if self.global.general.theme == "Pixel" then
		self.Border = self.mult
		self.Spacing = 0
		self.PixelMode = true
	end

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

        if ACD.OpenFrames[_AddOnName] then
            self:RegisterEvent("PLAYER_REGEN_ENABLED")
            ACD:Close(_AddOnName)
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
        else
            self:Print("请先启用RayUI_Options插件.")
            return
        end
    end

    local ACD = LibStub("AceConfigDialog-3.0")

    local mode = "Close"
    if not ACD.OpenFrames[_AddOnName] then
        mode = "Open"
    end
    ACD[mode](ACD, _AddOnName)
    GameTooltip:Hide()
end
