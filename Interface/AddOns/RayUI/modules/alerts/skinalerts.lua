local R, L, P, G = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, GlobalDB
local AL = R:GetModule("Alerts")
local S = R:GetModule("Skins")

--Cache global variables
--Lua functions
--WoW API / Variables
local CreateFrame = CreateFrame

function AL:SkinToast(toast, toastType)
    local r, g, b = toast.Border:GetVertexColor()
    -- toast.BG:Kill()
    toast.Border:Kill()
    toast.Icon:SetTexCoord(.08, .92, .08, .92)
    if toast.IconBorder then toast.IconBorder:Kill() end

    if not toast.bg then
        toast.bg = CreateFrame("Frame", nil, toast)
        toast.bg:SetOutside(toast.BG, 1, 1)
        toast.bg:SetFrameLevel(toast:GetFrameLevel() - 1)

        S:CreateBD(toast.bg)

        toast.BG:SetParent(toast.bg)
    end

    toast.BG:SetBlendMode("ADD")
    toast.BG:SetAlpha(0.3)

    if toastType == "item" then
        if not toast.Icon.b then
            toast.Icon.b = CreateFrame("Frame", nil, toast)
            S:CreateBD(toast.Icon.b)
            toast.Icon.b:SetOutside(toast.Icon)
            toast.Icon.b:SetFrameLevel(toast:GetFrameLevel() - 1)
        end
        toast.Icon.b:SetBackdropBorderColor(r, g, b)
    end
end
