local R, L, P = unpack(select(2, ...)) --Inport: Engine, Locales, ProfileDB
local S = R:GetModule("Skins")

local function LoadSkin()
	S:SetBD(GuildRegistrarFrame, 6, -15, -26, 64)
	S:CreateBD(GuildRegistrarFrameEditBox, .25)
	GuildRegistrarFrame:DisableDrawLayer("ARTWORK")
	GuildRegistrarFramePortrait:Hide()
	GuildRegistrarFrameEditBox:SetHeight(20)
	S:Reskin(GuildRegistrarFrameGoodbyeButton)
	S:Reskin(GuildRegistrarFramePurchaseButton)
	S:Reskin(GuildRegistrarFrameCancelButton)
	select(6, GuildRegistrarFrameEditBox:GetRegions()):Hide()
	select(7, GuildRegistrarFrameEditBox:GetRegions()):Hide()
	select(2, GuildRegistrarGreetingFrame:GetRegions()):Hide()
	S:ReskinClose(GuildRegistrarFrameCloseButton, "TOPRIGHT", GuildRegistrarFrame, "TOPRIGHT", -30, -20)
end

S:RegisterSkin("Blizzard_RaidUI", LoadSkin)