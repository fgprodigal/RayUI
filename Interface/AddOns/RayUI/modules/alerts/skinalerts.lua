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

        S:CreateBD(toast.bg)
    end

    toast.bg:SetFrameLevel(0)
    toast.BG:SetParent(toast.bg)
    toast.BG:SetDrawLayer("BACKGROUND", 0)
    toast.BG:SetBlendMode("ADD")

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
