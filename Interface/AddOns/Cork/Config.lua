

local myname, Cork = ...

local GAP = 8
local tekcheck = LibStub("tekKonfig-Checkbox")


local frame = CreateFrame("Frame", nil, InterfaceOptionsFramePanelContainer)
Cork.config = frame
frame.name = "Cork"
frame:Hide()

frame:SetScript("OnShow", function()
	local EDGEGAP, ROWHEIGHT, ROWGAP, GAP = 16, 16, 2, 4

	local title, subtitle = LibStub("tekKonfig-Heading").new(frame, "Cork", "Most of these settings are saved on a per-talent spec basis.  Settings will automatically switch when you swap specs.")

	local showanchor = tekcheck.new(frame, nil, "Show anchor", "TOPLEFT", subtitle, "BOTTOMLEFT", -2, -GAP)
	showanchor.tiptext = "Toggle the tooltip anchor. \n|cffffff9aThis setting is global."
	showanchor:SetScript("OnClick", function(self)
		Cork.db.showanchor = not Cork.db.showanchor
		if Cork.db.showanchor then Cork.anchor:Show() else Cork.anchor:Hide() end
	end)


	local resetanchor = LibStub("tekKonfig-Button").new_small(frame, "LEFT", showanchor, "RIGHT", 105, 0)
	resetanchor:SetWidth(60) resetanchor:SetHeight(18)
	resetanchor.tiptext = "Click to reset the anchor to it's default position. \n|cffffff9aPosition is a global setting."
	resetanchor:SetText("Reset")
	resetanchor:SetScript("OnClick", function()
		Cork.db.point, Cork.db.x, Cork.db.y = nil
		Cork.anchor:ClearAllPoints()
		Cork.anchor:SetPoint(Cork.db.point, Cork.db.x, Cork.db.y)
		Cork.Update()
	end)


	local showbg = tekcheck.new(frame, nil, "Show toolip in BG", "TOPLEFT", showanchor, "BOTTOMLEFT", 0, -GAP)
	showbg.tiptext = "Show the tooltip when in a battleground or outdoor PvP zone.  When the tooltip is hidden the macro will still work."
	showbg:SetScript("OnClick", function(self)
		Cork.db.showbg = not Cork.db.showbg
		Cork.Update()
	end)


	local bindwheel = tekcheck.new(frame, nil, "Bind mousewheel", "TOPLEFT", showbg, "BOTTOMLEFT", 0, -GAP)
	bindwheel.tiptext = "Bind to mousewheel when out of combat and needs are present. \n|cffffff9aThis setting is global."
	bindwheel:SetScript("OnClick", function(self)
		Cork.db.bindwheel = not Cork.db.bindwheel
		Cork.UpdateMouseBinding()
	end)


	if tekDebug then
		local showunit = tekcheck.new(frame, nil, "Debug mode", "TOPLEFT", bindwheel, "BOTTOMLEFT", 0, -GAP)
		showunit.tiptext = "Ignores rest state and shows unitIDs (target, party1, raidpet5) in tooltip."
		showunit:SetChecked(Cork.db.debug)
		showunit:SetScript("OnClick", function(self)
			Cork.db.debug = not Cork.db.debug
			Cork.Update()
		end)
	end

	local group = LibStub("tekKonfig-Group").new(frame, "Modules", "TOP", subtitle, "BOTTOM", 0, -GAP-22)
	group:SetPoint("LEFT", frame, "CENTER", -40, 0)
	group:SetPoint("BOTTOMRIGHT", -EDGEGAP, EDGEGAP)


	local macrobutt = LibStub("tekKonfig-Button").new_small(frame, "BOTTOMRIGHT", group, "TOPRIGHT")
	macrobutt:SetWidth(60) macrobutt:SetHeight(18)
	macrobutt.tiptext = "Click to generate a macro, or pick it up if already generated."
	macrobutt:SetText("Macro")
	macrobutt:SetScript("OnClick", Cork.GenerateMacro)


	local corknames, anchor = {}
	local tekcheck = LibStub("tekKonfig-Checkbox")
	local NUMROWS = math.floor((group:GetHeight()-EDGEGAP+ROWGAP + 2) / (ROWHEIGHT+ROWGAP))
	for name in pairs(Cork.corks) do table.insert(corknames, (name:gsub("Cork ", ""))) end
	table.sort(corknames)
	local function OnClick(self)
		Cork.dbpc[self.name.."-enabled"] = not Cork.dbpc[self.name.."-enabled"]
		PlaySound(Cork.dbpc[self.name.."-enabled"] and "igMainMenuOptionCheckBoxOn" or "igMainMenuOptionCheckBoxOff")
		Cork.corks["Cork ".. self.name]:Scan()
	end
	for i=1,NUMROWS do
		local name = corknames[i]
		if name then
			local row = CreateFrame("Button", nil, group)
			if anchor then row:SetPoint("TOP", anchor , "BOTTOM", 0, -ROWGAP)
			else row:SetPoint("TOP", 0, -EDGEGAP/2) end
			row:SetPoint("LEFT", EDGEGAP/2, 0)
			row:SetPoint("RIGHT", -EDGEGAP/2, 0)
			row:SetHeight(ROWHEIGHT)
			anchor = row


			local check = tekcheck.new(row, ROWHEIGHT+4, nil, "LEFT")
			check:SetScript("OnClick", OnClick)
			check.name = name
			check.tiptext = Cork.corks["Cork "..name].tiptext
			check.tiplink = Cork.corks["Cork "..name].tiplink
			check:SetChecked(Cork.dbpc[name.."-enabled"])


			local title = row:CreateFontString(nil, "BACKGROUND", "GameFontHighlightSmall")
			title:SetPoint("LEFT", check, "RIGHT", 4, 0)
			title:SetText(name)


			local configframe = Cork.corks["Cork "..name].configframe
			if configframe then
				configframe:SetPoint("RIGHT", row)
				configframe:SetFrameLevel(row:GetFrameLevel() + 1)
				configframe:Show()
			end
		end
	end


	local function Update(self)
		showanchor:SetChecked(Cork.db.showanchor)
		showbg:SetChecked(Cork.db.showbg)
		bindwheel:SetChecked(Cork.db.bindwheel)
	end

	frame:SetScript("OnShow", Update)
	Update(frame)
end)

InterfaceOptions_AddCategory(frame)


----------------------------
--      LDB Launcher      --
----------------------------

local ldb = LibStub:GetLibrary("LibDataBroker-1.1")
local dataobj = ldb:GetDataObjectByName("CorkLauncher") or ldb:NewDataObject("CorkLauncher", {type = "launcher", icon = "Interface\\Icons\\INV_Drink_11", tocname = "Cork"})
dataobj.OnClick = function() InterfaceOptionsFrame_OpenToCategory(frame) end


----------------------------
--       Key Binding      --
----------------------------

setglobal("BINDING_HEADER_CORK", "Cork")
setglobal("BINDING_NAME_CLICK CorkFrame:LeftButton", "Click the Cork frame")
