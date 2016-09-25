local R, L, P, G = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, GlobalDB
local S = R:GetModule("Skins")

local function LoadSkin()
	DeathRecapFrame:StripTextures()
	S:ReskinClose(DeathRecapFrame.CloseXButton)
	S:SetBD(DeathRecapFrame)
	S:Reskin(select(8, DeathRecapFrame:GetChildren())) -- bottom close button has no parentKey

	for i = 1, NUM_DEATH_RECAP_EVENTS do
		local iconBorder = DeathRecapFrame["Recap"..i].SpellInfo.IconBorder
		local icon = DeathRecapFrame["Recap"..i].SpellInfo.Icon
		iconBorder:SetAlpha(0)
		icon:SetTexCoord(.08, .92, .08, .92)
		DeathRecapFrame["Recap"..i].SpellInfo.bg = S:CreateBG(DeathRecapFrame["Recap"..i].SpellInfo)
		DeathRecapFrame["Recap"..i].SpellInfo.bg:SetOutside(icon)
		icon:SetParent(DeathRecapFrame["Recap"..i].SpellInfo)
	end

	for i=1, DeathRecapFrame:GetNumChildren() do
		local child = select(i, DeathRecapFrame:GetChildren())
		if(child:GetObjectType() == "Button" and child.GetText and child:GetText() == CLOSE) then
			S:Reskin(child)
		end
	end
end

S:AddCallbackForAddon("Blizzard_DeathRecap", "DeathRecap", LoadSkin)