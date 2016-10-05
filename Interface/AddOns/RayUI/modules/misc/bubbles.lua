local R, L, P, G = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, GlobalDB
local M = R:GetModule("Misc")
local mod = M:NewModule("BubbleSkin", "AceTimer-3.0")

--Cache global variables
--Lua functions
local select, unpack, type = select, unpack, type
local strfind, strlower = string.find, string.lower

--WoW API / Variables
local CreateFrame = CreateFrame

--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: UIParent, WorldFrame

function mod:UpdateBubbleBorder()
    if not self.text then return end

    local r, g, b = self.text:GetTextColor()
    self:SetBackdropBorderColor(r, g, b, .8)
end

function mod:SkinBubble(frame)
    local mult = R.mult * UIParent:GetScale()
    for i=1, frame:GetNumRegions() do
        local region = select(i, frame:GetRegions())
        if region:GetObjectType() == "Texture" then
            region:SetTexture(nil)
        elseif region:GetObjectType() == "FontString" then
            frame.text = region
        end
    end

    if R.global.general.theme == "Shadow" then
        frame:SetBackdrop({
                edgeFile = R["media"].glow,
                bgFile = R["media"].blank,
                tile = false, tileSize = 0, edgeSize = 5,
                insets = {left = 4, right = 4, top = 4, bottom = 4}
            })
    else
        frame:SetBackdrop({
                edgeFile = R["media"].blank,
                bgFile = R["media"].blank,
                tile = false, tileSize = 0, edgeSize = mult,
            })
    end
    frame:SetClampedToScreen(false)
    frame:SetBackdropBorderColor(unpack(R["media"].bordercolor))
    frame:SetBackdropColor(.1, .1, .1, .6)
    mod.UpdateBubbleBorder(frame)
    frame:HookScript("OnShow", mod.UpdateBubbleBorder)
end

function mod:IsChatBubble(frame)
    for i = 1, frame:GetNumRegions() do
        local region = select(i, frame:GetRegions())

        if region.GetTexture and region:GetTexture() and type(region:GetTexture() == "string") then
            if strfind(strlower(region:GetTexture()), "chatbubble%-background") then return true end
        end
    end
    return false
end

local numChildren = 0
function mod:Initialize()
    local frame = CreateFrame('Frame')
    frame.lastupdate = -2

    frame:SetScript("OnUpdate", function(self, elapsed)
            self.lastupdate = self.lastupdate + elapsed
            if (self.lastupdate < .1) then return end
            self.lastupdate = 0

            local count = WorldFrame:GetNumChildren()
            if(count ~= numChildren) then
                for i = numChildren + 1, count do
                    local frame = select(i, WorldFrame:GetChildren())

                    if mod:IsChatBubble(frame) then
                        mod:SkinBubble(frame)
                    end
                end
                numChildren = count
            end
        end)
end

M:RegisterMiscModule(mod:GetName())
