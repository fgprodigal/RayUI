----------------------------------------------------------
-- Load RayUI Environment
----------------------------------------------------------
RayUI:LoadEnv("Misc")


local M = _Misc
local mod = M:NewModule("BubbleSkin", "AceTimer-3.0")

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

    if not R.PixelMode then
        frame:SetBackdrop({
                edgeFile = R["media"].glow,
                bgFile = R["media"].blank,
                tile = false, tileSize = 0, edgeSize = 3,
                insets = {left = 3, right = 3, top = 3, bottom = 3}
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
    frame.isSkinned = true
end

local function ChatBubble_OnUpdate(self, elapsed)
	if not mod.lastupdate then
		mod.lastupdate = -2 -- wait 2 seconds before hooking frames
	end
	mod.lastupdate = mod.lastupdate + elapsed
	if (mod.lastupdate < .1) then return end
	mod.lastupdate = 0
	for _, chatBubble in pairs(C_ChatBubbles.GetAllChatBubbles()) do
		if not chatBubble.isSkinned then
			mod:SkinBubble(chatBubble)
		end
	end
end

function mod:Initialize()
    local frame = CreateFrame("Frame")

    frame:SetScript("OnUpdate", ChatBubble_OnUpdate)
end

M:RegisterMiscModule(mod:GetName())
