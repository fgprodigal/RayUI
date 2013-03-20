
local myname, Cork = ...
local UnitAura = Cork.UnitAura or UnitAura
local SpellCastableOnUnit, IconLine = Cork.SpellCastableOnUnit, Cork.IconLine
local ldb, ae = LibStub:GetLibrary("LibDataBroker-1.1"), LibStub("AceEvent-3.0")


function Cork:GenerateAdvancedSelfBuffer(modulename, spellidlist, combatonly, usestance)
	local spellname, _, defaulticon = GetSpellInfo(spellidlist[1])
	local myname = UnitName("player")
	local buffnames, icons, known = {}, {}
	for _,id in pairs(spellidlist) do
		local spellname, _, icon = GetSpellInfo(id)
		buffnames[id], icons[spellname] =  spellname, icon
	end

	Cork.defaultspc[modulename.."-spell"] = buffnames[spellidlist[1]]

	local dataobj = LibStub:GetLibrary("LibDataBroker-1.1"):NewDataObject("Cork "..modulename, {type = "cork"})

	local function RefreshKnownSpells() -- Refresh in case the player has learned this since login
		for buff in pairs(icons) do if known[buff] == nil then known[buff] = GetSpellInfo(buff) end end
	end

	function dataobj:Init()
		known = {}
		RefreshKnownSpells()
		Cork.defaultspc[modulename.."-enabled"] = known[spellname] ~= nil
	end

	function dataobj:Test(enteringcombat)
		if Cork.dbpc[modulename.."-enabled"] and not (IsResting() and not Cork.db.debug) and (not combatonly or enteringcombat or InCombatLockdown()) then
			local spell = Cork.dbpc[modulename.."-spell"]

			if usestance then
				for i=1,GetNumShapeshiftForms() do
					local _, name, isActive = GetShapeshiftFormInfo(i)
					if name == spell and isActive then return end
				end
			else
				for _,buff in pairs(buffnames) do
					local name, _, _, _, _, _, _, isMine = UnitAura("player", buff)
					if name and isMine then return end
				end
			end

			local icon = icons[spell]
			return IconLine(icon, spell)
		end
	end

	function dataobj:Scan() self.player = self:Test() end

	function dataobj:CorkIt(frame)
		RefreshKnownSpells()
		local spell = Cork.dbpc[modulename.."-spell"]
		if self.player then return frame:SetManyAttributes("type1", "spell", "spell", spell, "unit", "player") end
	end

	if usestance then
		ae.RegisterEvent(dataobj, "UPDATE_SHAPESHIFT_FORM", "Scan")
	else
		ae.RegisterEvent("Cork "..modulename, "UNIT_AURA", function(event, unit)
			if unit == "player" then dataobj.player = dataobj:Test() end
		end)
	end
	ae.RegisterEvent(dataobj, "PLAYER_UPDATE_RESTING", "Scan")
	if combatonly then
		ae.RegisterEvent("Cork "..modulename, "PLAYER_REGEN_DISABLED", function() dataobj.player = dataobj:Test(true) end)
		ae.RegisterEvent("Cork "..modulename, "PLAYER_REGEN_ENABLED", function() dataobj.player = nil end)
	end


	----------------------
	--      Config      --
	----------------------

	local frame = CreateFrame("Frame", nil, Cork.config)
	frame:SetWidth(1) frame:SetHeight(1)
	dataobj.configframe = frame
	frame:Hide()

	frame:SetScript("OnShow", function()
		local EDGEGAP, ROWHEIGHT, ROWGAP, GAP = 16, 18, 2, 4
		local buffbuttons = {}

		local function OnClick(self)
			Cork.dbpc[modulename.."-spell"] = self.buff
			for buff,butt in pairs(buffbuttons) do butt:SetChecked(butt == self) end
			dataobj:Scan()
		end

		local function OnEnter(self)
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			GameTooltip:SetHyperlink(GetSpellLink(self.buffid))
		end
		local function OnLeave() GameTooltip:Hide() end


		local lasticon
		for _,id in ipairs(spellidlist) do
			local buff = buffnames[id]

			local butt = CreateFrame("CheckButton", nil, frame)
			butt:SetWidth(ROWHEIGHT) butt:SetHeight(ROWHEIGHT)

			local tex = butt:CreateTexture(nil, "BACKGROUND")
			tex:SetAllPoints()
			tex:SetTexture(icons[buff])
			tex:SetTexCoord(4/48, 44/48, 4/48, 44/48)
			butt.icon = tex

			butt:SetPushedTexture("Interface\\Buttons\\UI-Quickslot-Depress")
			butt:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square")
			butt:SetCheckedTexture("Interface\\Buttons\\CheckButtonHilight")

			if lasticon then lasticon:SetPoint("RIGHT", butt, "LEFT", -ROWGAP, 0) end

			butt.buff = buff
			butt.buffid = id
			butt:SetScript("OnClick", OnClick)
			butt:SetScript("OnEnter", OnEnter)
			butt:SetScript("OnLeave", OnLeave)
			butt:SetMotionScriptsWhileDisabled(true)

			buffbuttons[buff], lasticon = butt, butt
		end
		lasticon:SetPoint("RIGHT", 0, 0)

		local function Update(self)
			RefreshKnownSpells()

			for buff,butt in pairs(buffbuttons) do
				butt:SetChecked(Cork.dbpc[modulename.."-spell"] == buff)
				if known[buff] then
					butt:Enable()
					butt.icon:SetVertexColor(1.0, 1.0, 1.0)
				else
					butt:Disable()
					butt.icon:SetVertexColor(0.4, 0.4, 0.4)
				end
			end
		end

		frame:SetScript("OnShow", Update)
		Update(frame)
	end)

	return dataobj, RefreshKnownSpells
end
