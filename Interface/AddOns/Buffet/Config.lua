
local MAX_ACCOUNT_MACROS, MAX_CHARACTER_MACROS = 36, 18

local EDGEGAP, GAP = 16, 8
local tekbutt = LibStub("tekKonfig-Button")


if AddonLoader and AddonLoader.RemoveInterfaceOptions then AddonLoader:RemoveInterfaceOptions("Buffet") end

local frame = CreateFrame("Frame", nil, InterfaceOptionsFramePanelContainer)
frame.name = "Buffet"
frame:Hide()
frame:SetScript("OnShow", function()
	local title, subtitle = LibStub("tekKonfig-Heading").new(frame, "Buffet", "This panel allows you to quickly create the base macros for Buffet to edit.  You can also set the macro text to be used.")

	local function OnClick(self)
		local id = GetMacroIndexByName(self.name)
		if id and id ~= 0 then PickupMacro(id)
		elseif GetNumMacros() >= MAX_ACCOUNT_MACROS then Buffet:Print("All global macros in use.")
		else
			local id = CreateMacro(self.name, "INV_MISC_QUESTIONMARK", "")
			Buffet:Scan()
			PickupMacro(id)
		end
	end

	local hpbutt = tekbutt.new(frame, "TOPLEFT", subtitle, "BOTTOMLEFT", -2, -GAP)
	hpbutt:SetText("HP Macro")
	hpbutt.tiptext = "Generate a global macro for food, bandages, health potions and health stones."
	hpbutt.name = "AutoHP"
	hpbutt:SetScript("OnClick", OnClick)
	if InCombatLockdown() then hpbutt:Disable() end

	local mpbutt = tekbutt.new(frame, "TOPLEFT", hpbutt, "TOPRIGHT", GAP, 0)
	mpbutt:SetText("MP Macro")
	mpbutt.tiptext = "Generate a global macro for water, mana potions and mana stones."
	mpbutt.name = "AutoMP"
	mpbutt:SetScript("OnClick", OnClick)
	if InCombatLockdown() then mpbutt:Disable() end

	local hpmacrolabel = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
	hpmacrolabel:SetText("HP Macro")
	hpmacrolabel:SetPoint("TOPLEFT", hpbutt, "BOTTOMLEFT", 5, -GAP)

	local YOFFSET = (hpmacrolabel:GetTop() - frame:GetBottom() - EDGEGAP/3)/2
	local backdrop = {
		bgFile = "Interface\\ChatFrame\\ChatFrameBackground", insets = {left = 4, right = 4, top = 4, bottom = 4},
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", edgeSize = 16
	}

	local hpeditbox = CreateFrame("EditBox", nil, frame)
	hpeditbox:SetPoint("TOP", hpmacrolabel, "BOTTOM", 0, -5)
	hpeditbox:SetPoint("LEFT", EDGEGAP/3, 0)
	hpeditbox:SetPoint("BOTTOMRIGHT", -EDGEGAP/3, YOFFSET + EDGEGAP/3)
	hpeditbox:SetFontObject(GameFontHighlight)
	hpeditbox:SetTextInsets(8,8,8,8)
	hpeditbox:SetBackdrop(backdrop)
	hpeditbox:SetBackdropColor(.1,.1,.1,.3)
	hpeditbox:SetMultiLine(true)
	hpeditbox:SetAutoFocus(false)
	hpeditbox:SetText(Buffet.db.macroHP)
	hpeditbox:SetScript("OnEditFocusLost", function()
		local newmacro = hpeditbox:GetText()
		if not newmacro:find("%%MACRO%%") then
			Buffet:Print('Macro text must contain the string "%MACRO%".')
		else
			Buffet.db.macroHP = newmacro
			Buffet:BAG_UPDATE()
		end
	end)
	hpeditbox:SetScript("OnEscapePressed", hpeditbox.ClearFocus)
	hpeditbox.tiptext = 'Customize the macro text.  Must include the string "%MACRO%", which is replaced with the items to be used.  This setting is saved on a per-char basis.'
	hpeditbox:SetScript("OnEnter", mpbutt:GetScript("OnEnter"))
	hpeditbox:SetScript("OnLeave", mpbutt:GetScript("OnLeave"))

	local mpmacrolabel = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
	mpmacrolabel:SetText("MP Macro")
	mpmacrolabel:SetPoint("TOP", hpeditbox, "BOTTOM", 0, -GAP)
	mpmacrolabel:SetPoint("LEFT", hpmacrolabel, "LEFT")

	local mpeditbox = CreateFrame("EditBox", nil, frame)
	mpeditbox:SetPoint("TOP", mpmacrolabel, "BOTTOM", 0, -5)
	mpeditbox:SetPoint("LEFT", EDGEGAP/3, 0)
	mpeditbox:SetPoint("BOTTOMRIGHT", -EDGEGAP/3, EDGEGAP/3)
	mpeditbox:SetFontObject(GameFontHighlight)
	mpeditbox:SetTextInsets(8,8,8,8)
	mpeditbox:SetBackdrop(backdrop)
	mpeditbox:SetBackdropColor(.1,.1,.1,.3)
	mpeditbox:SetMultiLine(true)
	mpeditbox:SetAutoFocus(false)
	mpeditbox:SetText(Buffet.db.macroMP)
	mpeditbox:SetScript("OnEditFocusLost", function()
		local newmacro = mpeditbox:GetText()
		if not newmacro:find("%%MACRO%%") then
			Buffet:Print('Macro text must contain the string "%MACRO%".')
		else
			Buffet.db.macroMP = newmacro
			Buffet:BAG_UPDATE()
		end
	end)
	mpeditbox:SetScript("OnEscapePressed", mpeditbox.ClearFocus)
	mpeditbox.tiptext = hpeditbox.tiptext
	mpeditbox:SetScript("OnEnter", mpbutt:GetScript("OnEnter"))
	mpeditbox:SetScript("OnLeave", mpbutt:GetScript("OnLeave"))

	frame:SetScript("OnEvent", function(self, event)
		if event == "PLAYER_REGEN_DISABLED" then hpbutt:Disable() mpbutt:Disable()
		else hpbutt:Enable() mpbutt:Enable() end
	end)
	frame:RegisterEvent("PLAYER_REGEN_ENABLED")
	frame:RegisterEvent("PLAYER_REGEN_DISABLED")

	frame:SetScript("OnShow", nil)
end)

InterfaceOptions_AddCategory(frame)

LibStub("tekKonfig-AboutPanel").new("Buffet", "Buffet")


----------------------------------------
--      Quicklaunch registration      --
----------------------------------------

LibStub:GetLibrary("LibDataBroker-1.1"):NewDataObject("Buffet", {
	type = "launcher",
	icon = "Interface\\Icons\\INV_Misc_Food_DimSum",
	OnClick = function() InterfaceOptionsFrame_OpenToCategory(frame) end,
})
