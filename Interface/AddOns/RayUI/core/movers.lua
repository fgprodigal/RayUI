--Create a Mover frame by Elv
local R, L, P, G = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, GlobalDB
local AddOnName = ...

--Cache global variables
--Lua functions
local _G = _G
local string = string
local ipairs = ipairs
local floor = floor
local tonumber = tonumber
local type = type
local pairs = pairs

--WoW API / Variables
local InCombatLockdown = InCombatLockdown
local CreateFrame = CreateFrame
local GetScreenWidth = GetScreenWidth
local GetScreenHeight = GetScreenHeight
local PlaySound = PlaySound
local ERR_NOT_IN_COMBAT = ERR_NOT_IN_COMBAT
local RESET = RESET

--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: RayUIParent, GameTooltip, UIDropDownMenu_SetSelectedValue, UIDropDownMenu_Initialize
-- GLOBALS: UIDropDownMenu_CreateInfo, UIDropDownMenu_AddButton, EditBox_ClearFocus, SquareButton_SetIcon
-- GLOBALS: RayUIMoverPopupWindow, GameFontNormal, RayUIMoverPopupWindowDropDown

local grid, nudgeWindow
local gridSize = 50
R.CreatedMovers = {}
local selectedValue = "GENERAL"
local MoverTypes = {
	"ALL",
	"GENERAL",
	"ACTIONBARS",
	"RAID",
	"ARENA",
}

local function SizeChanged(frame)
	if InCombatLockdown() then return; end
	frame.mover:SetSize(frame:GetSize())
end

local function GetPoint(obj)
	local point, anchor, secondaryPoint, x, y = obj:GetPoint()
	if not anchor then anchor = RayUIParent end

	return string.format("%s\031%s\031%s\031%d\031%d", point, anchor:GetName(), secondaryPoint, R:Round(x), R:Round(y))
end

local function MoverTypes_OnClick(self)
	selectedValue = self.value
	R:ToggleConfigMode(false, self.value)
	UIDropDownMenu_SetSelectedValue(RayUIMoverPopupWindowDropDown, self.value)
end

local function MoverTypes_Initialize()
	local info = UIDropDownMenu_CreateInfo()
	info.func = MoverTypes_OnClick

	for _, moverTypes in ipairs(MoverTypes) do
		info.text = L[moverTypes]
		info.value = moverTypes
		UIDropDownMenu_AddButton(info)
	end

	UIDropDownMenu_SetSelectedValue(RayUIMoverPopupWindowDropDown, selectedValue)
end

local function CreateGrid()
	grid = CreateFrame("Frame", "AlignGrid", R.UIParent)
	grid.boxSize = gridSize
	grid:SetAllPoints(R.UIParent)
	grid:Show()

	local size = 1
	local width = GetScreenWidth()
	local ratio = width / GetScreenHeight()
	local height = GetScreenHeight() * ratio

	local wStep = width / gridSize
	local hStep = height / gridSize

	for i = 0, gridSize do
		local tx = grid:CreateTexture(nil, "BACKGROUND")
		if i == gridSize / 2 then
			tx:SetColorTexture(1, 0, 0)
		else
			tx:SetColorTexture(0, 0, 0)
		end
		tx:Width(size)
		tx:SetPoint("TOPLEFT", grid, "TOPLEFT", i*wStep - (size/2), 0)
		tx:SetPoint("BOTTOMLEFT", grid, "BOTTOMLEFT", i*wStep - (size/2), 0)
	end
	height = GetScreenHeight()

	do
		local tx = grid:CreateTexture(nil, "BACKGROUND")
		tx:SetColorTexture(1, 0, 0)
		tx:Height(size)
		tx:SetPoint("TOPLEFT", grid, "TOPLEFT", 0, -(height/2) + (size/2))
		tx:SetPoint("TOPRIGHT", grid, "TOPRIGHT", 0, -(height/2) + (size/2))
	end

	for i = 1, floor((height/2)/hStep) do
		local tx = grid:CreateTexture(nil, "BACKGROUND")
		tx:SetColorTexture(0, 0, 0)

		tx:Height(size)
		tx:SetPoint("TOPLEFT", grid, "TOPLEFT", 0, -(height/2+i*hStep) + (size/2))
		tx:SetPoint("TOPRIGHT", grid, "TOPRIGHT", 0, -(height/2+i*hStep) + (size/2))

		tx = grid:CreateTexture(nil, "BACKGROUND")
		tx:SetColorTexture(0, 0, 0)

		tx:Height(size)
		tx:SetPoint("TOPLEFT", grid, "TOPLEFT", 0, -(height/2-i*hStep) + (size/2))
		tx:SetPoint("TOPRIGHT", grid, "TOPRIGHT", 0, -(height/2-i*hStep) + (size/2))
	end
end

local function ShowGrid()
	if not grid then
		CreateGrid()
	elseif grid.boxSize ~= gridSize then
		grid:Hide()
		CreateGrid()
	else
		grid:Show()
	end
end

local function HideGrid()
	if grid then
		grid:Hide()
	end
end

local function UpdateNudgeFrame(mover)
	local screenWidth, screenHeight, screenCenter = R.UIParent:GetRight(), R.UIParent:GetTop(), R.UIParent:GetCenter()
	local x, y = mover:GetCenter()

	local LEFT = screenWidth / 3
	local RIGHT = screenWidth * 2 / 3
	local TOP = screenHeight / 2

	if y >= TOP then
		y = -(screenHeight - mover:GetTop())
	else
		y = mover:GetBottom()
	end

	if x >= RIGHT then
		x = mover:GetRight() - screenWidth
	elseif x <= LEFT then
		x = mover:GetLeft()
	else
		x = x - screenCenter
	end

	x = R:Round(x, 0)
	y = R:Round(y, 0)

	nudgeWindow.xOffset:SetText(x)
	nudgeWindow.yOffset:SetText(y)
	nudgeWindow.xOffset.currentValue = x
	nudgeWindow.yOffset.currentValue = y
	nudgeWindow.title:SetText(mover.textstring)
end

local function AssignFrameToNudge(self)
	nudgeWindow.child = self
	UpdateNudgeFrame(self)
end

local function GetXYOffset(position)
	local x, y = 1, 1

	if position == "TOP" or position == "TOPLEFT" or position == "TOPRIGHT" then
		return 0, y
	elseif position == "BOTTOM" or position == "BOTTOMLEFT" or position == "BOTTOMRIGHT" then
		return 0, -y
	elseif position == "LEFT" then
		return -x, 0
	else
		return x, 0
	end
end

local function HideNudgeWindow()
	nudgeWindow:Hide()
end

local function ShowNudgeWindow()
	local mover = nudgeWindow.child
	local screenWidth, screenHeight, screenCenter = R.UIParent:GetRight(), R.UIParent:GetTop(), R.UIParent:GetCenter()
	local x, y = mover:GetCenter()

	local LEFT = screenWidth / 3
	local RIGHT = screenWidth * 2 / 3
	local TOP = screenHeight / 2
	local point, inversePoint
	if y >= TOP then
		point = "TOP"
		inversePoint = "BOTTOM"
		y = -(screenHeight - mover:GetTop())
	else
		point = "BOTTOM"
		inversePoint = "TOP"
		y = mover:GetBottom()
	end

	if x >= RIGHT then
		point = "RIGHT"
		inversePoint = "LEFT"
		x = mover:GetRight() - screenWidth
	elseif x <= LEFT then
		point = "LEFT"
		inversePoint = "RIGHT"
		x = mover:GetLeft()
	else
		x = x - screenCenter
	end

	local coordX, coordY = GetXYOffset(inversePoint)
	nudgeWindow:ClearAllPoints()
	nudgeWindow:SetPoint(point, mover, inversePoint, coordX, coordY)
	nudgeWindow.title:SetText(mover.textstring)
	nudgeWindow:Show()
	UpdateNudgeFrame(mover)
end

local function SetNudge()
	local mover = nudgeWindow.child

	local screenWidth, screenHeight, screenCenter = R.UIParent:GetRight(), R.UIParent:GetTop(), R.UIParent:GetCenter()
	local x, y = mover:GetCenter()
	local point
	local LEFT = screenWidth / 3
	local RIGHT = screenWidth * 2 / 3
	local TOP = screenHeight / 2

	if y >= TOP then
		point = "TOP"
	else
		point = "BOTTOM"
	end

	if x >= RIGHT then
		point = point.."RIGHT"
	elseif x <= LEFT then
		point = point.."LEFT"
	end

	x = tonumber(nudgeWindow.xOffset.currentValue)
	y = tonumber(nudgeWindow.yOffset.currentValue)

	mover:ClearAllPoints()
	mover:Point(point, R.UIParent, point, x, y)
	R:SaveMoverPosition(mover.name)
end

local function CreatePopup()
	local S = R:GetModule("Skins")
	local f = CreateFrame("Frame", "RayUIMoverPopupWindow", R.UIParent)
	f:SetFrameStrata("DIALOG")
	f:SetToplevel(true)
	f:EnableMouse(true)
	f:SetClampedToScreen(true)
	f:SetWidth(360)
	f:SetHeight(130)
	f:SetPoint("TOP", 0, -50)
	f:Hide()
	S:SetBD(f)
	f:SetMovable(true)
	f:RegisterForDrag("LeftButton")
	f:SetScript("OnDragStart", function(self) self:StartMoving() self:SetUserPlaced(false) end)
	f:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
	f:SetScript("OnShow", function() PlaySound("igMainMenuOption") end)
	f:SetScript("OnHide", function() PlaySound("gsTitleOptionExit") end)

	local title = f:CreateFontString(nil, "OVERLAY")
	title:SetFontObject(GameFontNormal)
	title:SetShadowOffset(R.mult, -R.mult)
	title:SetShadowColor(0, 0, 0)
	title:SetPoint("TOP", f, "TOP", 0, -10)
	title:SetJustifyH("CENTER")
	title:SetText("RayUI")

	local desc = f:CreateFontString(nil, "ARTWORK")
	desc:SetFontObject("GameFontHighlight")
	desc:SetJustifyV("TOP")
	desc:SetJustifyH("LEFT")
	desc:SetPoint("TOPLEFT", 18, -32)
	desc:SetPoint("BOTTOMRIGHT", -18, 48)
	desc:SetText(L["锚点已解锁，拖动锚点移动位置，右键单击微调，完成后点击锁定按钮。"])

	local lock = CreateFrame("Button", "RayUILock", f, "OptionsButtonTemplate")
	_G[lock:GetName() .. "Text"]:SetText(L["锁定"])

	lock:SetScript("OnClick", function(self)
		R:ToggleConfigMode(true)
		if IsAddOnLoaded("RayUI_Options") then LibStub("AceConfigDialog-3.0"):Open("RayUI") end
		selectedValue = "GENERAL"
		UIDropDownMenu_SetSelectedValue(RayUIMoverPopupWindowDropDown, selectedValue)
	end)

	lock:SetPoint("BOTTOMRIGHT", -14, 14)
	S:Reskin(lock)

	local align = CreateFrame("EditBox", f:GetName().."EditBox", f, "InputBoxTemplate")
	align:Width(50)
	align:Height(17)
	align:SetAutoFocus(false)
	align:SetScript("OnEscapePressed", function(self)
		self:SetText(gridSize)
		EditBox_ClearFocus(self)
	end)
	align:SetScript("OnEnterPressed", function(self)
		local text = self:GetText()
		if tonumber(text) then
			if tonumber(text) <= 256 and tonumber(text) >= 4 then
				gridSize = tonumber(text)
			else
				self:SetText(gridSize)
			end
		else
			self:SetText(gridSize)
		end
		ShowGrid()
		EditBox_ClearFocus(self)
	end)
	align:SetScript("OnEditFocusLost", function(self)
		self:SetText(gridSize)
	end)
	align:SetScript("OnEditFocusGained", align.HighlightText)
	align:SetScript("OnShow", function(self)
		EditBox_ClearFocus(self)
		self:SetText(gridSize)
	end)

	align.text = align:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	align.text:SetPoint("RIGHT", align, "LEFT", -4, 0)
	align.text:SetText(L["网格数"])
	align:SetPoint("TOPRIGHT", lock, "TOPLEFT", -4, -2)
	S:ReskinInput(align)

	f:RegisterEvent("PLAYER_REGEN_DISABLED")
	f:SetScript("OnEvent", function(self)
		if self:IsShown() then
			self:Hide()
		end
	end)

	local moverTypes = CreateFrame("Frame", f:GetName().."DropDown", f, "UIDropDownMenuTemplate")
	moverTypes:Point("BOTTOMRIGHT", lock, "TOPRIGHT", 18, -5)
	moverTypes:Width(160)
	S:ReskinDropDown(moverTypes)
	moverTypes.text = moverTypes:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	moverTypes.text:SetPoint("RIGHT", moverTypes, "LEFT", 2, 2)
	moverTypes.text:SetText(L["模式"])


	UIDropDownMenu_Initialize(moverTypes, MoverTypes_Initialize)

	nudgeWindow = CreateFrame("Frame", "MoverNudgeWindow", R.UIParent)
	nudgeWindow:SetFrameStrata("DIALOG")
	nudgeWindow:SetWidth(200)
	nudgeWindow:SetHeight(110)
	nudgeWindow:CreateShadow("Background")
	nudgeWindow:Point("TOP", RayUIMoverPopupWindow, "BOTTOM", 0, -15)
	nudgeWindow:SetFrameLevel(100)
	nudgeWindow:Hide()
	nudgeWindow:EnableMouse(true)
	nudgeWindow:SetClampedToScreen(true)
	RayUIMoverPopupWindow:HookScript("OnHide", function() nudgeWindow:Hide() end)

	local desc = nudgeWindow:CreateFontString("ARTWORK")
	desc:SetFontObject("GameFontHighlight")
	desc:SetJustifyV("TOP")
	desc:SetJustifyH("CENTER")
	desc:SetPoint("TOPLEFT", 18, -15)
	desc:SetPoint("BOTTOMRIGHT", -18, 28)
	nudgeWindow.title = desc

	local header = CreateFrame("Button", nil, nudgeWindow)
	header:SetTemplate("Default", true)
	header:SetWidth(100)
	header:SetHeight(25)
	header:SetPoint("CENTER", nudgeWindow, "TOP")
	header:SetFrameLevel(header:GetFrameLevel() + 2)

	local title = header:CreateFontString("OVERLAY")
	title:FontTemplate()
	title:SetPoint("CENTER", header, "CENTER")
	title:SetText(L["微调"])

	local xOffset = CreateFrame("EditBox", nudgeWindow:GetName().."XEditBox", nudgeWindow, "InputBoxTemplate")
	xOffset:Width(50)
	xOffset:Height(17)
	xOffset:SetAutoFocus(false)
	xOffset.currentValue = 0
	xOffset:SetScript("OnEscapePressed", function(self)
		self:SetText(R:Round(xOffset.currentValue))
		EditBox_ClearFocus(self)
	end)
	xOffset:SetScript("OnEnterPressed", function(self)
		local num = self:GetText()
		if tonumber(num) then
			xOffset.currentValue = num
			SetNudge()
		end
		self:SetText(R:Round(xOffset.currentValue))
		EditBox_ClearFocus(self)
	end)
	xOffset:SetScript("OnEditFocusLost", function(self)
		self:SetText(R:Round(xOffset.currentValue))
	end)
	xOffset:SetScript("OnEditFocusGained", xOffset.HighlightText)
	xOffset:SetScript("OnShow", function(self)
		EditBox_ClearFocus(self)
		self:SetText(R:Round(xOffset.currentValue))
	end)

	xOffset.text = xOffset:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	xOffset.text:SetPoint("RIGHT", xOffset, "LEFT", -4, 0)
	xOffset.text:SetText("X:")
	xOffset:SetPoint("BOTTOMRIGHT", nudgeWindow, "CENTER", -6, 8)
	nudgeWindow.xOffset = xOffset
	S:ReskinInput(xOffset)

	local yOffset = CreateFrame("EditBox", nudgeWindow:GetName().."YEditBox", nudgeWindow, "InputBoxTemplate")
	yOffset:Width(50)
	yOffset:Height(17)
	yOffset:SetAutoFocus(false)
	yOffset.currentValue = 0
	yOffset:SetScript("OnEscapePressed", function(self)
		self:SetText(R:Round(yOffset.currentValue))
		EditBox_ClearFocus(self)
	end)
	yOffset:SetScript("OnEnterPressed", function(self)
		local num = self:GetText()
		if tonumber(num) then
			yOffset.currentValue = num
			SetNudge()
		end
		self:SetText(R:Round(yOffset.currentValue))
		EditBox_ClearFocus(self)
	end)
	yOffset:SetScript("OnEditFocusLost", function(self)
		self:SetText(R:Round(yOffset.currentValue))
	end)
	yOffset:SetScript("OnEditFocusGained", yOffset.HighlightText)
	yOffset:SetScript("OnShow", function(self)
		EditBox_ClearFocus(self)
		self:SetText(R:Round(yOffset.currentValue))
	end)

	yOffset.text = yOffset:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	yOffset.text:SetPoint("RIGHT", yOffset, "LEFT", -4, 0)
	yOffset.text:SetText("Y:")
	yOffset:SetPoint("BOTTOMLEFT", nudgeWindow, "CENTER", 16, 8)
	nudgeWindow.yOffset = yOffset
	S:ReskinInput(yOffset)

	local resetButton = CreateFrame("Button", nudgeWindow:GetName().."ResetButton", nudgeWindow, "UIPanelButtonTemplate")
	resetButton:SetText(RESET)
	resetButton:SetPoint("TOP", nudgeWindow, "CENTER", 0, 2)
	resetButton:Size(100, 25)
	resetButton:SetScript("OnClick", function()
		if nudgeWindow.child.name then
			R:ResetMovers(nudgeWindow.child.textstring)
		end
	end)
	S:Reskin(resetButton)

	local upButton = CreateFrame("Button", nudgeWindow:GetName().."UpButton", nudgeWindow, "UIPanelSquareButton")
	upButton:SetPoint("BOTTOMRIGHT", nudgeWindow, "BOTTOM", -6, 4)
	upButton:SetScript("OnClick", function()
		yOffset:SetText(yOffset.currentValue + 1)
		yOffset:GetScript("OnEnterPressed")(yOffset)
	end)
	SquareButton_SetIcon(upButton, "UP");
	S:Reskin(upButton)

	local downButton = CreateFrame("Button", nudgeWindow:GetName().."DownButton", nudgeWindow, "UIPanelSquareButton")
	downButton:SetPoint("BOTTOMLEFT", nudgeWindow, "BOTTOM", 6, 4)
	downButton:SetScript("OnClick", function()
		yOffset:SetText(yOffset.currentValue - 1)
		yOffset:GetScript("OnEnterPressed")(yOffset)
	end)
	SquareButton_SetIcon(downButton, "DOWN");
	S:Reskin(downButton)

	local leftButton = CreateFrame("Button", nudgeWindow:GetName().."LeftButton", nudgeWindow, "UIPanelSquareButton")
	leftButton:SetPoint("RIGHT", upButton, "LEFT", -6, 0)
	leftButton:SetScript("OnClick", function()
		xOffset:SetText(xOffset.currentValue - 1)
		xOffset:GetScript("OnEnterPressed")(xOffset)
	end)
	SquareButton_SetIcon(leftButton, "LEFT");
	S:Reskin(leftButton)

	local rightButton = CreateFrame("Button", nudgeWindow:GetName().."RightButton", nudgeWindow, "UIPanelSquareButton")
	rightButton:SetPoint("LEFT", downButton, "RIGHT", 6, 0)
	rightButton:SetScript("OnClick", function()
		xOffset:SetText(xOffset.currentValue + 1)
		xOffset:GetScript("OnEnterPressed")(xOffset)
	end)
	SquareButton_SetIcon(rightButton, "RIGHT");
	S:Reskin(rightButton)
end

local function CreateMover(parent, name, text, overlay, postdrag, ignoreSizeChange)
	if not parent then return end
	if R.CreatedMovers[name].Created then return end

	local S = R:GetModule("Skins")

	if overlay == nil then overlay = true end

	local point, anchor, secondaryPoint, x, y = string.split("\031", GetPoint(parent))

	local f = CreateFrame("Button", name, R.UIParent)
	f:SetFrameLevel(parent:GetFrameLevel() + 1)
	f:SetWidth(parent:GetWidth())
	f:SetHeight(parent:GetHeight())

	if overlay == true then
		f:SetFrameStrata("DIALOG")
	else
		f:SetFrameStrata("BACKGROUND")
	end
	if R.db["movers"] and R.db["movers"][name] then
		if type(R.db["movers"][name]) == "table" then
			f:SetPoint(R.db["movers"][name]["p"], R.UIParent, R.db["movers"][name]["p2"], R.db["movers"][name]["p3"], R.db["movers"][name]["p4"])
			R.db["movers"][name] = GetPoint(f)
			f:ClearAllPoints()
		end

		local point, anchor, secondaryPoint, x, y = string.split("\031", R.db["movers"][name])
		f:SetPoint(point, anchor, secondaryPoint, x, y)
	else
		f:SetPoint(point, anchor, secondaryPoint, x, y)
	end
	S:Reskin(f)
	f:RegisterForDrag("LeftButton")
	f:SetScript("OnDragStart", function(self)
		if InCombatLockdown() then R:Print(ERR_NOT_IN_COMBAT) return end
		self:StartMoving()
	end)

	f:SetScript("OnDragStop", function(self)
		if InCombatLockdown() then R:Print(ERR_NOT_IN_COMBAT) return end
		self:StopMovingOrSizing()

		local screenWidth, screenHeight, screenCenter = R.UIParent:GetRight(), R.UIParent:GetTop(), R.UIParent:GetCenter()
		local x, y = self:GetCenter()
		local point

		local LEFT = screenWidth / 3
		local RIGHT = screenWidth * 2 / 3
		local TOP = screenHeight / 2

		if y >= TOP then
			point = "TOP"
			y = -(screenHeight - self:GetTop())
		else
			point = "BOTTOM"
			y = self:GetBottom()
		end

		if x >= RIGHT then
			point = point.."RIGHT"
			x = self:GetRight() - screenWidth
		elseif x <= LEFT then
			point = point.."LEFT"
			x = self:GetLeft()
		else
			x = x - screenCenter
		end

		self:ClearAllPoints()
		self:Point(point, R.UIParent, point, x, y)

		R:SaveMoverPosition(name)

		if postdrag ~= nil and type(postdrag) == "function" then
			postdrag(self, R:GetScreenQuadrant(self))
		end

		self:SetUserPlaced(false)
	end)

	if not ignoreSizeChange then
		parent:SetScript("OnSizeChanged", SizeChanged)
		parent.mover = f
	end
	parent:ClearAllPoints()
	parent:SetPoint(point, f, 0, 0)
	parent.ClearAllPoints = function() return end
	parent.SetAllPoints = function() return end
	parent.SetPoint = function() return end

	local fs = f:CreateFontString(nil, "OVERLAY")
	fs:SetFont(R["media"].font, R["media"].fontsize)
	fs:SetShadowOffset(R.mult*1.2, -R.mult*1.2)
	fs:SetJustifyH("CENTER")
	fs:SetPoint("CENTER")
	fs:SetText(text or name)
	fs:SetTextColor(1, 1, 1)
	f:SetFontString(fs)
	f.textstring = text or name
	f.name = name
	f.text = fs

	f:SetScript("OnMouseUp", function(self, btn)
		if btn=="RightButton" then
			if nudgeWindow.child == self and nudgeWindow:IsShown() then
				HideNudgeWindow()
			else
				AssignFrameToNudge(self)
				ShowNudgeWindow()
			end
		end
	end)
	f:HookScript("OnEnter", function(self)
		self.text:SetTextColor(self:GetBackdropBorderColor())
	end)
	f:HookScript("OnLeave", function(self)
		self.text:SetTextColor(1, 1, 1)
	end)

	f:SetMovable(true)
	f:Hide()

	if postdrag ~= nil and type(postdrag) == "function" then
		f:RegisterEvent("PLAYER_ENTERING_WORLD")
		f:SetScript("OnEvent", function(self, event)
			postdrag(f, R:GetScreenQuadrant(f))
			self:UnregisterAllEvents()
		end)
	end

	R.CreatedMovers[name].Created = true
end

function R:CreateMover(parent, name, text, overlay, postdrag, moverTypes, ignoreSizeChange)
	if not moverTypes then moverTypes = "ALL,GENERAL" end

	if R.CreatedMovers[name] == nil then
		R.CreatedMovers[name] = {}
		R.CreatedMovers[name]["parent"] = parent
		R.CreatedMovers[name]["text"] = text
		R.CreatedMovers[name]["overlay"] = overlay
		R.CreatedMovers[name]["postdrag"] = postdrag
		R.CreatedMovers[name]["point"] = GetPoint(parent)

		R.CreatedMovers[name]["type"] = {}
		local types = {string.split(",", moverTypes)}
		for i = 1, #types do
			local moverType = types[i]
			R.CreatedMovers[name]["type"][moverType] = true
		end
	end

	CreateMover(parent, name, text, overlay, postdrag, ignoreSizeChange)
end

function R:SaveMoverPosition(name)
	if not _G[name] then return end
	if not R.db.movers then R.db.movers = {} end

	R.db.movers[name] = GetPoint(_G[name])
end

function R:ToggleConfigMode(override, moverType)
	if InCombatLockdown() then return end
	if override ~= nil and override ~= "" then R.ConfigurationMode = override end

	if R.ConfigurationMode ~= true then
		if not RayUIMoverPopupWindow then
			CreatePopup()
		end

		RayUIMoverPopupWindow:Show()
		ShowGrid()
		if IsAddOnLoaded("RayUI_Options") then
			LibStub("AceConfigDialog-3.0"):Close("RayUI")
			GameTooltip:Hide()
		end
		R.ConfigurationMode = true
	else
		if RayUIMoverPopupWindow then
			RayUIMoverPopupWindow:Hide()
		end
		HideGrid()
		R.ConfigurationMode = false
	end

	if type(moverType) ~= "string" then
		moverType = nil
	end

	self:ToggleMovers(R.ConfigurationMode, moverType or "GENERAL")
end

function R:ToggleMovers(show, moverType)
	for name, _ in pairs(R.CreatedMovers) do
		if not show then
			_G[name]:Hide()
		else
			if R.CreatedMovers[name]["type"][moverType] then
				_G[name]:Show()
			else
				_G[name]:Hide()
			end
		end
	end
end

function R:ResetMovers(arg)
	if arg == "" or arg == nil then
		for name, _ in pairs(R.CreatedMovers) do
			local f = _G[name]
			local point, anchor, secondaryPoint, x, y = string.split("\031", R.CreatedMovers[name]["point"])
			f:ClearAllPoints()
			f:SetPoint(point, anchor, secondaryPoint, x, y)

			for key, value in pairs(R.CreatedMovers[name]) do
				if key == "postdrag" and type(value) == "function" then
					value(f, R:GetScreenQuadrant(f))
				end
			end
		end
		self.db.movers = nil
	else
		for name, _ in pairs(R.CreatedMovers) do
			for key, value in pairs(R.CreatedMovers[name]) do
				local mover
				if key == "text" then
					if arg == value then
						local f = _G[name]
						local point, anchor, secondaryPoint, x, y = string.split("\031", R.CreatedMovers[name]["point"])
						f:ClearAllPoints()
						f:SetPoint(point, anchor, secondaryPoint, x, y)

						if self.db.movers then
							self.db.movers[name] = nil
						end

						if R.CreatedMovers[name]["postdrag"] ~= nil and type(R.CreatedMovers[name]["postdrag"]) == "function" then
							R.CreatedMovers[name]["postdrag"](f, R:GetScreenQuadrant(f))
						end
					end
				end
			end
		end
	end
end

function R:SetMoversPositions()
	for name, _ in pairs(R.CreatedMovers) do
		local f = _G[name]
		local point, anchor, secondaryPoint, x, y
		if R.db["movers"] and R.db["movers"][name] and type(R.db["movers"][name]) == "string" then
			point, anchor, secondaryPoint, x, y = string.split("\031", R.db["movers"][name])
			f:ClearAllPoints()
			f:SetPoint(point, anchor, secondaryPoint, x, y)
		elseif f then
			point, anchor, secondaryPoint, x, y = string.split("\031", R.CreatedMovers[name]["point"])
			f:ClearAllPoints()
			f:SetPoint(point, anchor, secondaryPoint, x, y)
		end
	end
end

function R:LoadMovers()
	for n, _ in pairs(R.CreatedMovers) do
		local p, t, o, pd
		for key, value in pairs(R.CreatedMovers[n]) do
			if key == "parent" then
				p = value
			elseif key == "text" then
				t = value
			elseif key == "overlay" then
				o = value
			elseif key == "postdrag" then
				pd = value
			end
		end
		CreateMover(p, n, t, o, pd)
	end
end
