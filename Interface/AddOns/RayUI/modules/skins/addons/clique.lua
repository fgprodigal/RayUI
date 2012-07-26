local R, L, P = unpack(select(2, ...)) --Inport: Engine, Locales, ProfileDB
local S = R:GetModule("Skins")

local function SkinClique()
	local tab = _G["CliqueSpellTab"]
	tab:GetRegions():Hide()
	tab:SetCheckedTexture(R.checked)
	tab:GetNormalTexture():SetTexCoord(.08, .92, .08, .92)
	S:CreateBG(tab)
	S:CreateSD(tab, 5, 0, 0, 0, 1, 1)
	select(4, tab:GetRegions()):SetTexCoord(.08, .92, .08, .92)
	CliqueConfig:StripTextures()
	CliqueConfigInset:StripTextures()
	S:SetBD(CliqueConfig)
	CliqueConfigPage1Column1:DisableDrawLayer("BACKGROUND")
	CliqueConfigPage1Column2:DisableDrawLayer("BACKGROUND")
	S:ReskinClose(CliqueConfigCloseButton)
	S:Reskin(CliqueConfigPage1ButtonSpell)
	CliqueConfigPage1ButtonSpell_RightSeparator:Kill()
	S:Reskin(CliqueConfigPage1ButtonOther)
	CliqueConfigPage1ButtonOther_RightSeparator:Kill()
	S:Reskin(CliqueConfigPage1ButtonOptions)
	CliqueConfigPage1ButtonOptions_LeftSeparator:Kill()
end

S:RegisterSkin("Clique", SkinClique)