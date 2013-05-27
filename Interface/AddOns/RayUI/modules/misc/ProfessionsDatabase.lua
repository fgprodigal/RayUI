local R, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local M = R:GetModule("Misc")

local function LoadFunc()
	----------------------------------------------------------------------------------------
	--	Access professions without actually having to know them(Professions Database by Vladinator)
	----------------------------------------------------------------------------------------
	local PROFESSIONS = {
		{
			80731,	-- Alchemy
			76666,	-- Blacksmithing
			74258,	-- Enchanting
			82774,	-- Engineering
			86008,	-- Inscription
			73318,	-- Jewelcrafting
			81199,	-- Leatherworking
			75156,	-- Tailoring
		},
		{
			88053,	-- Cooking
			74559,	-- First Aid
		},
	}

	-- Handle clicked links from dropdown menu
	local function DropDown_OnClick(self)
		local spellId = self.arg1
		local guid = UnitGUID("player"):sub(4)
		local _, template = GetSpellLink(spellId)
		if type(template) ~= "string" or template:len() == 0 then return end
		local chars = template:sub(select(2, template:find(guid)), template:find("|h")):len() - 3
		local maxed = type(PROFESSION_RANKS) == "table" and select(2, next(PROFESSION_RANKS[#PROFESSION_RANKS])) or 0
		local suffix = ""
		for i = 1, chars do
			suffix = suffix.."/"
		end
		local link = format("trade:%s:%d:%d:%d:%s", guid, spellId, maxed, maxed, suffix)
		local text = format("|H%s|h[%s]|h", link, GetSpellInfo(spellId) or "spellId#"..spellId)
		if IsModifiedClick() then
			local fixedLink = format("|cffffd000%s|r", text)
			if ChatEdit_GetActiveWindow() then
				ChatEdit_InsertLink(fixedLink)
			else
				print("Open the chat and shift-click", fixedLink, "to link it.")
			end
		else
			SetItemRef(link, text, "LeftButton", DEFAULT_CHAT_FRAME)
		end
	end

	-- Handle building dropdown list when menu is shown
	local function DropDown_Init()
		for i, spellIds in ipairs(PROFESSIONS) do
			UIDropDownMenu_AddButton({isTitle = 1, notCheckable = 1, text = i == 1 and PRIMARY or SECONDARY})
			for _, spellId in ipairs(spellIds) do
				local info = UIDropDownMenu_CreateInfo()
				info.notCheckable = 1
				info.text, _, info.icon = GetSpellInfo(spellId)
				info.arg1 = spellId
				info.tCoordLeft = 0.1
				info.tCoordRight = 0.9
				info.tCoordTop = 0.1
				info.tCoordBottom = 0.9
				info.func = DropDown_OnClick
				UIDropDownMenu_AddButton(info)
			end
		end
	end

	-- Create dropdown menu
	local dropdown = CreateFrame("Frame", "ProfessionsDatabaseDropDown", UIParent, "UIDropDownMenuTemplate")
	UIDropDownMenu_Initialize(dropdown, DropDown_Init, "MENU")

	-- Shows the dropdown on said frame
	local function DropDown_Show(self)
		ToggleDropDownMenu(nil, nil, dropdown, self, 0, 0)
	end

	local button = CreateFrame("Button", "ProfessionsDatabaseToggleButton", SpellBookProfessionFrame)
	R:GetModule("Skins"):Reskin(button)
	button:Size(17, 17)
	button:Point("TOPRIGHT", SpellBookProfessionFrame, "TOPRIGHT", -23, -4)
	local downtex = button:CreateTexture(nil, "ARTWORK")
	downtex:Size(7, 7)
	downtex:Point("CENTER", 0, 0)
	downtex:SetVertexColor(1, 1, 1)
	downtex:SetTexture("Interface\\AddOns\\RayUI\\media\\arrow-down-active")
	button:RegisterForClicks("LeftButtonUp")
	button:SetScript("OnClick", DropDown_Show)

	local frame = CreateFrame("Frame")
	frame:RegisterEvent("ADDON_LOADED")
	frame:SetScript("OnEvent", function(self, event, addon)
		if IsAddOnLoaded("Blizzard_TradeSkillUI") then
			local button2 = CreateFrame("Button", "ProfessionsDatabaseToggleButton", TradeSkillFrame)
			R:GetModule("Skins"):Reskin(button2)
			button2:Size(17, 17)
			button2:Point("TOPRIGHT", TradeSkillFrameCloseButton, "TOPLEFT", -2, 0)
			local downtex2 = button2:CreateTexture(nil, "ARTWORK")
			downtex2:Size(7, 7)
			downtex2:Point("CENTER", 0, 0)
			downtex2:SetVertexColor(1, 1, 1)
			downtex2:SetTexture("Interface\\AddOns\\RayUI\\media\\arrow-down-active")
			button2:RegisterForClicks("LeftButtonUp")
			button2:SetScript("OnClick", DropDown_Show)
		end
	end)
end

M:RegisterMiscModule("ProfessionsDatabase", LoadFunc)