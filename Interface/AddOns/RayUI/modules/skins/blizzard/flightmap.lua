local R, L, P, G = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, GlobalDB
local S = R:GetModule("Skins")

local function LoadSkin()
	FlightMapFrame.BorderFrame:StripTextures()
	FlightMapFramePortraitFrame:Kill()
	FlightMapFramePortrait:Kill()
	FlightMapFrameTitleText:Kill()

	local flightmap = FlightMapFrame.ScrollContainer
	S:SetBD(flightmap, -1, 1, 1, -1)
	S:ReskinClose(FlightMapFrameCloseButton, "TOPRIGHT", flightmap, "TOPRIGHT", -4, -4)
end

S:AddCallbackForAddon("Blizzard_FlightMap", "FlightMap", LoadSkin)
