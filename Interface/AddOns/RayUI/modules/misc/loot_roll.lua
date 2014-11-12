local R, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local M = R:GetModule("Misc")

R.rollBars = {}
local testMode = false
local pos = "TOP"

local function ClickRoll(frame)
	RollOnLoot(frame.parent.rollid, frame.rolltype)
end

local function HideTip() GameTooltip:Hide() end
local function HideTip2() GameTooltip:Hide(); ResetCursor() end

local rolltypes = {[1] = "need", [2] = "greed", [3] = "disenchant", [0] = "pass"}

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
		if roll == frame.rolltype then
			GameTooltip:AddLine(name, 1, 1, 1)
		end
	end
	GameTooltip:Show()
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
	if IsControlKeyDown() then
		DressUpItemLink(frame.link)
	elseif IsShiftKeyDown() then
		ChatEdit_InsertLink(frame.link)
	end
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

	if t > 1000000000 then
		frame:GetParent():Hide()
	end
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

local function GetFrame()
	for i,f in ipairs(R.rollBars) do
		if not f.rollid then return f end
	end

	local f = CreateRollFrame()
	if pos == "TOP" then
		f:Point("TOP", next(R.rollBars) and R.rollBars[#R.rollBars] or AlertFrameHolder, "BOTTOM", 0, -4)
	else
		f:Point("BOTTOM", next(R.rollBars) and R.rollBars[#R.rollBars] or AlertFrameHolder, "TOP", 0, 4)
	end
	table.insert(R.rollBars, f)
	return f
end

function M:START_LOOT_ROLL(event, rollid, time)
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
	if canNeed then f.needbutt:SetAlpha(1) else f.needbutt:SetAlpha(0.2) end
	if canGreed then f.greedbutt:SetAlpha(1) else f.greedbutt:SetAlpha(0.2) end
	if canDisenchant then f.disenchantbutt:SetAlpha(1) else f.disenchantbutt:SetAlpha(0.2) end

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
	AlertFrame_FixAnchors()

	if M.db.autodez and UnitLevel('player') == MAX_PLAYER_LEVEL and quality == 2 and not bop then
		if canDisenchant and IsSpellKnown(13262) then
			RollOnLoot(rollid, 3)
		else
			RollOnLoot(rollid, 2)
		end
	end
end

function M:LOOT_HISTORY_ROLL_CHANGED(event, itemIdx, playerIdx)
	local rollID, itemLink, numPlayers, isDone, winnerIdx, isMasterLoot = C_LootHistory.GetItem(itemIdx);
	local name, class, rollType, roll, isWinner = C_LootHistory.GetPlayerInfo(itemIdx, playerIdx);

	if name and rollType then
		for _,f in ipairs(R.rollBars) do
			if f.rollid == rollID then
				f.rolls[name] = rollType
				f[rolltypes[rollType]]:SetText(tonumber(f[rolltypes[rollType]]:GetText()) + 1)
				return
			end
		end
	end
end

SlashCmdList["LFrames"] = function() 
	local items = { 32837, 19019, 77949, 34196 }
	for _, f in pairs(R.rollBars) do
		f.rollid = nil
		f:Hide()
	end
	if testMode then
		testMode = false
	else
		testMode = true
		for i = 1, 3 do
			local f = GetFrame()
			local item = items[math.random(1,#items)]
			local quality, _, _, _, _, _, _, texture = select(3, GetItemInfo(item))
			local r, g, b = GetItemQualityColor(quality)
			f.button:SetNormalTexture(texture)
			f.button:GetNormalTexture():SetTexCoord(.1, .9, .1, .9)
			f.fsloot:SetVertexColor(r, g, b)
			f.fsloot:SetText(GetItemInfo(item))
			f.status:SetStatusBarColor(r, g, b)
			f.rollid = i
			f.time = 100000000
			f:Show()
		end
		AlertFrame_FixAnchors()
	end
end
SLASH_LFrames1 = "/lframes"

local function LoadFunc()
	UIParent:UnregisterEvent("START_LOOT_ROLL")
	UIParent:UnregisterEvent("CANCEL_LOOT_ROLL")
	M:RegisterEvent("START_LOOT_ROLL")
	M:RegisterEvent("LOOT_HISTORY_ROLL_CHANGED")
end

M:RegisterMiscModule("LootRoll", LoadFunc)
