----------------------------------------------------------
-- Load RayUI Environment
----------------------------------------------------------
RayUI:LoadEnv("Skins")

local S = _Skins

local function SkinPostal()
    S:ReskinArrow(Postal_ModuleMenuButton, 'down')
    Postal_ModuleMenuButton:SetPoint("TOPRIGHT", -22, -2)

    local Postal_OpenAll = Postal:GetModule("OpenAll")
    hooksecurefunc(Postal_OpenAll, 'OnEnable', function(self)
        PostalOpenAllButton:StripTextures()
        S:Reskin(PostalOpenAllButton)
        -- PostalOpenAllButton:StyleButton(true)
        OpenAllMail:Hide()
        Postal_OpenAllMenuButton:StripTextures()
        S:ReskinArrow(Postal_OpenAllMenuButton, 'down')
        Postal_OpenAllMenuButton:SetPoint("LEFT", PostalOpenAllButton, "RIGHT", 2, 0)
    end)
    hooksecurefunc(Postal_OpenAll, 'OnDisable', function(self)
        OpenAllMail:Show()
    end)

    local Postal_Select = Postal:GetModule("Select")
    hooksecurefunc(Postal_Select, 'OnEnable', function(self)
        PostalSelectOpenButton:StripTextures()
        S:Reskin(PostalSelectOpenButton)
        PostalSelectReturnButton:StripTextures()
        S:Reskin(PostalSelectReturnButton)
        for i = 1, 7 do
            local cb = _G["PostalInboxCB"..i]
            S:ReskinCheck(cb)
        end
    end)
    hooksecurefunc(Postal_OpenAll, 'OnDisable', function(self)
        OpenAllMail:Show()
    end)
end

S:AddCallbackForAddon("Postal", "Postal", SkinPostal)
