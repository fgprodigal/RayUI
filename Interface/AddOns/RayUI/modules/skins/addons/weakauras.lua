----------------------------------------------------------
-- Load RayUI Environment
----------------------------------------------------------
_LoadRayUIEnv_()


local S = R:GetModule("Skins")

local function LoadSkin()
    local function Skin_WeakAuras(frame, ftype)
        if ftype == "icon" then
            if not frame.shadow then
                frame:CreateShadow("Background")
                frame.icon:SetTexCoord(.08, .92, .08, .92)
                frame.icon.SetTexCoord = R.dummy
            end
        end

        if ftype == "aurabar" then
            if not frame.bar.shadow then
                frame.bar:CreateShadow("Background")
                frame.iconFrame:CreateShadow("Background")
                frame.iconFrame:SetAllPoints(frame.icon)
                frame.icon:SetTexCoord(.08, .92, .08, .92)
                frame.icon.SetTexCoord = R.dummy
                hooksecurefunc(frame.bar, "SetForegroundColor", function(self, r, g, b, a)
                    self.fg:SetGradient("VERTICAL", R:GetGradientColor(r, g, b))
                end)
                hooksecurefunc(frame.bar, "SetBackgroundColor", function(self, r, g, b, a)
                    self.bg:SetGradient("VERTICAL", R:GetGradientColor(r, g, b))
                end)
            end
        end
    end
    local Create_Icon, Modify_Icon = WeakAuras.regionTypes.icon.create, WeakAuras.regionTypes.icon.modify
    local Create_AuraBar, Modify_AuraBar = WeakAuras.regionTypes.aurabar.create, WeakAuras.regionTypes.aurabar.modify
    WeakAuras.regionTypes.icon.create = function(parent, data)
        local region = Create_Icon(parent, data)
        Skin_WeakAuras(region, "icon")
        return region
    end

    WeakAuras.regionTypes.aurabar.create = function(parent)
        local region = Create_AuraBar(parent)
        Skin_WeakAuras(region, "aurabar")
        return region
    end

    WeakAuras.regionTypes.icon.modify = function(parent, region, data)
        Modify_Icon(parent, region, data)
        Skin_WeakAuras(region, "icon")
    end

    WeakAuras.regionTypes.aurabar.modify = function(parent, region, data)
        Modify_AuraBar(parent, region, data)
        Skin_WeakAuras(region, "aurabar")
    end

    for weakAura, _ in pairs(WeakAuras.regions) do
        if WeakAuras.regions[weakAura].regionType == "icon"
        or WeakAuras.regions[weakAura].regionType == "aurabar" then
            Skin_WeakAuras(WeakAuras.regions[weakAura].region, WeakAuras.regions[weakAura].regionType)
        end
    end
end

S:AddCallbackForAddon("WeakAuras", "WeakAuras", LoadSkin)
