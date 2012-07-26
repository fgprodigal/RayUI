local R, L, P = unpack(select(2, ...)) --Inport: Engine, Locales, ProfileDB
local CF = R:NewModule("CooldownFlash", "AceEvent-3.0", "AceHook-3.0")
CF.modName = L["中部冷却闪光"]

local lib = LibStub("LibCooldown")

local filter = {
	["pet"] = "all",
	["item"] = {
		[6948] = true, -- hearthstone
	},
	["spell"] = {
	},
}

function CF:Initialize()
	local flash = CreateFrame("Frame", nil, UIParent)
	flash.icon = flash:CreateTexture(nil, "OVERLAY")
	flash:SetPoint("CENTER", UIParent)
	flash:Size(80, 80)
	flash:CreateShadow()
	flash.icon:SetAllPoints()
	flash.icon:SetTexCoord(.08, .92, .08, .92)
	flash:Hide()
	flash:SetScript("OnUpdate", function(self, e)
		flash.e = flash.e + e
		if flash.e > .75 then
			flash:Hide()
		elseif flash.e < .25 then
			flash:SetAlpha(flash.e*4)
		elseif flash.e > .5 then
			flash:SetAlpha(1-(flash.e%.5)*4)
		end
	end)
	flash:UnregisterEvent("PLAYER_ENTERING_WORLD")
	flash:SetScript("OnEvent", nil)

	lib:RegisterCallback("stop", function(id, class)
		if filter[class]=="all" or filter[class][id] then return end
		flash.icon:SetTexture(class=="item" and GetItemIcon(id) or select(3, GetSpellInfo(id)))
		flash.e = 0
		flash:Show()
	end)
end

function CF:Info()
	return L["|cff7aa6d6Ray|r|cffff0000U|r|cff7aa6d6I|r中部冷却闪光模块, 技能冷却结束时在屏幕中部显示闪烁技能图标."]
end

R:RegisterModule(CF:GetName())