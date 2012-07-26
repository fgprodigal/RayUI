local R, L, P = unpack(select(2, ...)) --Inport: Engine, Locales, ProfileDB
local M = R:GetModule("Misc")

local function LoadFunc()
	local pos = "TOP"
	local backdrop = {
		bgFile = R["media"].blank, tile = true, tileSize = 0,
		edgeFile = R["media"].blank, edgeSize = R.mult,
		insets = {left = -R.mult, right = -R.mult, top = -R.mult, bottom = -R.mult},
	}

	local function ClickRoll(frame)
		RollOnLoot(frame.parent.rollid, frame.rolltype)
	end


	local function HideTip() GameTooltip:Hide() end
	local function HideTip2() GameTooltip:Hide(); ResetCursor() end


	local rolltypes = {"need", "greed", "disenchant", [0] = "pass"}
	local function SetTip(frame)
		GameTooltip:SetOwner(frame, "ANCHOR_RIGHT")
		GameTooltip:SetText(frame.tiptext)
		if not frame:IsEnabled() then
			GameTooltip:AddLine("|cffff3333Cannot ".._G[rolltypes[frame.rolltype]:upper() == "DISENCHANT" and "ROLL_DISENCHANT" or rolltypes[frame.rolltype]:upper()])
			frame:SetAlpha(0.4)
		else
			frame:SetAlpha(1)
		end
		for name,roll in pairs(frame.parent.rolls) do
			if roll == rolltypes[frame.rolltype] then
				GameTooltip:AddLine(name, 1, 1, 1)
			end
		end
		GameTooltip:Show()
	end

	local function SetButtonAlpha(frame)
		if frame:IsEnabled() then
			frame:SetAlpha(1)
		else
			frame:SetAlpha(0.4)
		end
	end

	local function SetItemTip(frame)
		if not frame.link then return end
		GameTooltip:SetOwner(frame, "ANCHOR_TOPLEFT")
		GameTooltip:SetHyperlink(frame.link)
		if IsShiftKeyDown() then GameTooltip_ShowCompareItem() end
		if IsModifiedClick("DRESSUP") then ShowInspectCursor() else ResetCursor() end
	end


	local function ItemOnUpdate(self)
		if IsShiftKeyDown() then GameTooltip_ShowCompareItem() end
		CursorOnUpdate(self)
	end


	local function LootClick(frame)
		if IsControlKeyDown() then DressUpItemLink(frame.link)
		elseif IsShiftKeyDown() then ChatEdit_InsertLink(frame.link) end
	end


	local cancelled_rolls = {}
	local function OnEvent(frame, event, rollid)
		cancelled_rolls[rollid] = true
		if frame.rollid ~= rollid then return end

		frame.rollid = nil
		frame.time = nil
		frame:Hide()
	end


	local function StatusUpdate(frame)
		if not frame.parent.rollid then return end
		local t = GetLootRollTimeLeft(frame.parent.rollid)
		local perc = t / frame.parent.time
		frame.spark:Point("CENTER", frame, "LEFT", perc * frame:GetWidth(), 0)
		frame:SetValue(t)
	end


	local function CreateRollButton(parent, ntex, ptex, htex, rolltype, tiptext, ...)
		local f = CreateFrame("Button", nil, parent)
		f:SetPoint(...)
		f:Width(28)
		f:Height(28)
		f:SetNormalTexture(ntex)
		if ptex then f:SetPushedTexture(ptex) end
		f:SetHighlightTexture(htex)
		f.rolltype = rolltype
		f.parent = parent
		f.tiptext = tiptext
		f:SetScript ("OnUpdate", SetButtonAlpha)
		f:SetScript("OnEnter", SetTip)
		f:SetScript("OnLeave", HideTip)
		f:SetScript("OnClick", ClickRoll)
		if f:IsEnabled() then
			f:GetNormalTexture():SetDesaturated(0)
		else
			f:GetNormalTexture():SetDesaturated(1)
		end
		f:SetMotionScriptsWhileDisabled(true)
		local txt = f:CreateFontString(nil, nil)
		txt:SetFont(R["media"].font, R["media"].fontsize, R["media"].fontflag)
		txt:Point("CENTER", 0, rolltype == 2 and 1 or rolltype == 0 and -1.2 or 0)
		return f, txt
	end


	local function CreateRollFrame()
		local frame = CreateFrame("Frame", nil, UIParent)
		frame:Width(328)
		frame:Height(22)
		frame:SetBackdropColor(unpack(R["media"].backdropcolor))
		frame:SetScript("OnEvent", OnEvent)
		frame:RegisterEvent("CANCEL_LOOT_ROLL")
		frame:Hide()

		local button = CreateFrame("Button", nil, frame)
		button:Point("LEFT", -24, 0)
		button:Width(22)
		button:Height(22)

		button:SetScript("OnEnter", SetItemTip)
		button:SetScript("OnLeave", HideTip2)
		button:SetScript("OnUpdate", ItemOnUpdate)
		button:SetScript("OnClick", LootClick)
		frame.button = button

		local buttonborder = CreateFrame("Frame", nil, button)
		buttonborder:Width(22)
		buttonborder:Height(22)
		buttonborder:SetPoint("CENTER", button, "CENTER")
		buttonborder:SetBackdropColor(1, 1, 1, 0)

		local buttonborder2 = CreateFrame("Frame", nil, button)
		buttonborder2:Width(22)
		buttonborder2:Height(22)
		buttonborder2:SetFrameLevel(buttonborder:GetFrameLevel()+1)
		buttonborder2:SetPoint("CENTER", button, "CENTER")
		buttonborder2:CreateShadow("Background")
		buttonborder2.shadow:SetFrameStrata("BACKGROUND")
		buttonborder2.shadow:SetFrameLevel(0)
		buttonborder2:SetBackdropColor(0, 0, 0, 0)
		buttonborder2:SetBackdropBorderColor(0, 0, 0, 1)


		frame.buttonborder = buttonborder

		local tfade = frame:CreateTexture(nil, "BORDER")
		tfade:Point("TOPLEFT", frame, "TOPLEFT", 4, 0)
		tfade:Point("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -4, 0)
		tfade:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
		tfade:SetBlendMode("ADD")
		tfade:SetGradientAlpha("VERTICAL", .1, .1, .1, 0, .1, .1, .1, 0)

		local status = CreateFrame("StatusBar", nil, frame)
		status:Width(326)
		status:Height(5)
		status:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 2, 1)
		status:CreateShadow("Background")
		status:SetScript("OnUpdate", StatusUpdate)
		status:SetFrameLevel(status:GetFrameLevel()-1)
		status:SetStatusBarTexture(R["media"].normal)
		status:SetStatusBarColor(.8, .8, .8, .9)
		status.parent = frame
		frame.status = status

		local spark = frame:CreateTexture(nil, "OVERLAY")
		spark:Width(14)
		spark:Height(25)
		spark:SetTexture("Interface\\CastingBar\\UI-CastingBar-Spark")
		spark:SetBlendMode("ADD")
		status.spark = spark

		local need, needtext = CreateRollButton(frame, "Interface\\Buttons\\UI-GroupLoot-Dice-Up", "Interface\\Buttons\\UI-GroupLoot-Dice-Highlight", "Interface\\Buttons\\UI-GroupLoot-Dice-Down", 1, NEED, "LEFT", frame.button, "RIGHT", R:Scale(5), R:Scale(-1))
		local greed, greedtext = CreateRollButton(frame, "Interface\\Buttons\\UI-GroupLoot-Coin-Up", "Interface\\Buttons\\UI-GroupLoot-Coin-Highlight", "Interface\\Buttons\\UI-GroupLoot-Coin-Down", 2, GREED, "LEFT", need, "RIGHT", 0, R:Scale(-1))
		local de, detext
		de, detext = CreateRollButton(frame, "Interface\\Buttons\\UI-GroupLoot-DE-Up", "Interface\\Buttons\\UI-GroupLoot-DE-Highlight", "Interface\\Buttons\\UI-GroupLoot-DE-Down", 3, ROLL_DISENCHANT, "LEFT", greed, "RIGHT", 0, R:Scale(-1))
		local pass, passtext = CreateRollButton(frame, "Interface\\Buttons\\UI-GroupLoot-Pass-Up", nil, "Interface\\Buttons\\UI-GroupLoot-Pass-Down", 0, PASS, "LEFT", de or greed, "RIGHT", 0, R:Scale(2.2))
		frame.needbutt, frame.greedbutt, frame.disenchantbutt = need, greed, de
		frame.need, frame.greed, frame.pass, frame.disenchant = needtext, greedtext, passtext, detext

		local bind = frame:CreateFontString()
		bind:SetPoint("LEFT", pass, "RIGHT", R:Scale(3), R:Scale(1))
		bind:SetFont(R["media"].font, R["media"].fontsize, R["media"].fontflag)
		frame.fsbind = bind

		local loot = frame:CreateFontString(nil, "ARTWORK")
		loot:SetFont(R["media"].font, R["media"].fontsize, R["media"].fontflag)
		loot:SetPoint("LEFT", bind, "RIGHT", 0, R:Scale(0.12))
		loot:SetPoint("RIGHT", frame, "RIGHT", R:Scale(-5), 0)
		loot:Height(10)
		loot:Width(200)
		loot:SetJustifyH("LEFT")
		frame.fsloot = loot

		frame.rolls = {}

		return frame
	end


	local anchor = CreateFrame("Button", nil, UIParent)
	anchor:Width(300) 
	anchor:Height(22)
	anchor:SetBackdropColor(0.25, 0.25, 0.25, 1)
	local label = anchor:CreateFontString(nil, "ARTWORK")
	label:SetFont(R["media"].font, R["media"].fontsize, R["media"].fontflag)
	label:SetAllPoints(anchor)
	label:SetText("teksLoot")

	anchor:SetScript("OnClick", anchor.Hide)
	anchor:SetScript("OnDragStart", anchor.StartMoving)
	anchor:SetScript("OnDragStop", function(self)
		self:StopMovingOrSizing()
		self.db.x, self.db.y = self:GetCenter()
	end)
	anchor:SetMovable(true)
	anchor:EnableMouse(true)
	anchor:RegisterForDrag("LeftButton")
	anchor:RegisterForClicks("RightButtonUp")
	anchor:Hide()

	local frames = {}

	local f = CreateRollFrame() -- Create one for good measure
	f:SetPoint("TOPLEFT", next(frames) and frames[#frames] or anchor, "BOTTOMLEFT", 0, R:Scale(-4))
	table.insert(frames, f)


	local function GetFrame()
		for i,f in ipairs(frames) do
			if not f.rollid then return f end
		end

		local f = CreateRollFrame()
		if pos == "TOP" then
			f:SetPoint("TOPLEFT", next(frames) and frames[#frames] or anchor, "BOTTOMLEFT", 0, R:Scale(-4))
		else
			f:SetPoint("BOTTOMLEFT", next(frames) and frames[#frames] or anchor, "TOPLEFT", 0, R:Scale(4))
		end
		table.insert(frames, f)
		return f
	end


	local function START_LOOT_ROLL(rollid, time)
		if cancelled_rolls[rollid] then return end

		local f = GetFrame()
		f.rollid = rollid
		f.time = time
		for i in pairs(f.rolls) do f.rolls[i] = nil end
		f.need:SetText(0)
		f.greed:SetText(0)
		f.pass:SetText(0)
		f.disenchant:SetText(0)

		local texture, name, count, quality, bop, canNeed, canGreed, canDisenchant = GetLootRollItemInfo(rollid)
		f.button:SetNormalTexture(texture)
		f.button:GetNormalTexture():SetTexCoord(.1, .9, .1, .9)
		f.button.link = GetLootRollItemLink(rollid)

		if canNeed then f.needbutt:Enable() else f.needbutt:Disable() end
		if canGreed then f.greedbutt:Enable() else f.greedbutt:Disable() end
		if canDisenchant then f.disenchantbutt:Enable() else f.disenchantbutt:Disable() end
		SetDesaturation(f.needbutt:GetNormalTexture(), not canNeed)
		SetDesaturation(f.greedbutt:GetNormalTexture(), not canGreed)
		SetDesaturation(f.disenchantbutt:GetNormalTexture(), not canDisenchant)


		f.fsbind:SetText(bop and "BoP" or "BoE")
		f.fsbind:SetVertexColor(bop and 1 or .3, bop and .3 or 1, bop and .1 or .3)

		local color = ITEM_QUALITY_COLORS[quality]
		f.fsloot:SetVertexColor(color.r, color.g, color.b)
		f.fsloot:SetText(name)

		f:SetBackdropBorderColor(color.r, color.g, color.b, 1)
		f.buttonborder:SetBackdropBorderColor(color.r, color.g, color.b, 1)
		f.status:SetStatusBarColor(color.r, color.g, color.b, .7)

		f.status:SetMinMaxValues(0, time)
		f.status:SetValue(time)

		f:SetPoint("CENTER", WorldFrame, "CENTER")
		f:Show()
	end


	local locale = GetLocale()
	local rollpairs = locale == "zhCN" and {
		["(.*)自动放弃了(.+)，因为他无法拾取该物品。$"]  = "pass",
		["(.*)自动放弃了(.+)，因为她无法拾取该物品。$"]  = "pass",
		["(.*)放弃了：(.+)"] = "pass",
		["(.*)选择了贪婪取向：(.+)"] = "greed",
		["(.*)选择了需求取向：(.+)"] = "need",
		["(.*)选择了分解取向：(.+)"] = "disenchant",
	} or locale == "zhTW" and {
		["(.*)自動放棄:(.+)，因為"]  = "pass",
		["(.*)放棄了:(.+)"] = "pass",
		["(.*)選擇了貪婪:(.+)"] = "greed",
		["(.*)選擇了需求:(.+)"] = "need",
		["(.*)選擇分解:(.+)"] = "disenchant",
	}or {
		["^(.*) automatically passed on: (.+) because s?he cannot loot that item.$"] = "pass",
		["^(.*) passed on: (.+|r)$"]  = "pass",
		["(.*) has selected Greed for: (.+)"] = "greed",
		["(.*) has selected Need for: (.+)"]  = "need",
		["(.*) has selected Disenchant for: (.+)"]  = "disenchant",
	}

	local function ParseRollChoice(msg)
		for i,v in pairs(rollpairs) do
			local _, _, playername, itemname = string.find(msg, i)
			if locale == "ruRU" and (v == "greed" or v == "need" or v == "disenchant")  then 
				local temp = playername
				playername = itemname
				itemname = temp
			end 
			if playername and itemname and playername ~= "Everyone" then return playername, itemname, v end
		end
	end

	local function CHAT_MSG_LOOT(msg)
		local playername, itemname, rolltype = ParseRollChoice(msg)
		if playername and itemname and rolltype then
			for _,f in ipairs(frames) do
				if f.rollid and f.button.link == itemname and not f.rolls[playername] then
					f.rolls[playername] = rolltype
					f[rolltype]:SetText(tonumber(f[rolltype]:GetText()) + 1)
					return
				end
			end
		end
	end

	anchor:RegisterEvent("PLAYER_ENTERING_WORLD")
	anchor:SetScript("OnEvent", function(frame, event)
		anchor:UnregisterEvent("PLAYER_ENTERING_WORLD")
		anchor:RegisterEvent("START_LOOT_ROLL")
		anchor:RegisterEvent("CHAT_MSG_LOOT")
		UIParent:UnregisterEvent("START_LOOT_ROLL")
		UIParent:UnregisterEvent("CANCEL_LOOT_ROLL")
		anchor:SetScript("OnEvent", function(frame, event, ...) if event == "CHAT_MSG_LOOT" then return CHAT_MSG_LOOT(...) else return START_LOOT_ROLL(...) end end)

		local anchorholder = CreateFrame("Frame", "AnchorHolder", UIParent)
		anchorholder:SetPoint("TOP", UIParent, "TOP", 0, -200)
		anchorholder:Width(anchor:GetWidth())
		anchorholder:Height(anchor:GetHeight())

		anchor:SetPoint("TOP", anchorholder, "TOP", 0, 0)
	end)

	SlashCmdList["LFrames"] = function() 
		local f = GetFrame()
		local texture = select(10, GetItemInfo(32837))
		f.button:SetNormalTexture(texture)
		f.button:GetNormalTexture():SetTexCoord(.1, .9, .1, .9)
		f.fsloot:SetVertexColor(ITEM_QUALITY_COLORS[5].r, ITEM_QUALITY_COLORS[5].g, ITEM_QUALITY_COLORS[5].b)
		f.fsloot:SetText(GetItemInfo(32837))
		f.status:SetMinMaxValues(0, 100)
		f.status:SetValue(70)
		f.status:SetStatusBarColor(ITEM_QUALITY_COLORS[5].r, ITEM_QUALITY_COLORS[5].g, ITEM_QUALITY_COLORS[5].b)
		f:Show()
	end
	SLASH_LFrames1 = "/lframes"
end

M:RegisterMiscModule("LootRoll", LoadFunc)