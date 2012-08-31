local addonName = select(1, ...)
------------------------------------------------------
-- MEDIA & CONFIG ------------------------------------
------------------------------------------------------
local R, L, P = unpack(RayUI)
local S = R:GetModule("Skins")
local LSM = LibStub("LibSharedMedia-3.0")
local font = { LSM:Fetch("font", P["media"].font), 13, "THINOUTLINE" }
------------------------------------------------------
-- INITIAL FRAME CREATION ----------------------------
------------------------------------------------------
stAddonManager = CreateFrame("Frame", "stAddonManager", UIParent)
stAddonManager:SetFrameStrata("HIGH")
stAddonManager.header = CreateFrame("Frame", "stAddonmanager_Header", stAddonManager)

stAddonManager.header:SetPoint("CENTER", UIParent, "CENTER", 0, 200)
stAddonManager:SetPoint("TOP", stAddonManager.header, "TOP", 0, 0)

------------------------------------------------------
-- FUNCTIONS -----------------------------------------
------------------------------------------------------
function stAddonManager:UpdateAddonList(queryString)
	local addons = {}
	for i=1, GetNumAddOns() do
		local name, title, notes, enabled, loadable, reason, security = GetAddOnInfo(i)
		local lwrTitle, lwrName = strlower(title), strlower(name)
		if (queryString and (strfind(lwrTitle,strlower(queryString)) or strfind(lwrName,strlower(queryString)))) or (not queryString) then
			addons[i] = {}
			addons[i].name = name
			addons[i].title = title
			addons[i].notes = notes
			addons[i].enabled = enabled
			if GetAddOnMetadata(i, "version") then
				addons[i].version = GetAddOnMetadata(i, "version")
			end
			if GetAddOnDependencies(i) then
				addons[i].dependencies = {GetAddOnDependencies(i)}
			end
			if GetAddOnOptionalDependencies(i) then
				addons[i].optionaldependencies = {GetAddOnOptionalDependencies(i)}
			end
		end
	end
	return addons
end

local function GetEnabledAddons()
	local EnabledAddons = {}
		for i=1, GetNumAddOns() do
			local name, _, _, enabled = GetAddOnInfo(i)
			if enabled then
				tinsert(EnabledAddons, name)
			end
		end
	return EnabledAddons
end

local function LoadProfileWindow()
	local self = stAddonManager
	if self.ProfileWindow then ToggleFrame(self.ProfileWindow) return end
	
	local window = CreateFrame("Frame", "stAddonManager_ProfileWindow", self)
	window:SetPoint("TOPLEFT", self, "TOPRIGHT", 5, 0)
	window:SetSize(200, 350)
	S:CreateBD(window)
		
	local header = CreateFrame("Frame", "stAddonmanager_ProfileWindow_Header", window)
	header:SetPoint("TOP", window, "TOP", 0, 0)
	S:CreateBD(header)
	header:SetSize(window:GetWidth(), 20)
	
	local hTitle = header:CreateFontString(nil, "OVERLAY")
	hTitle:SetFont(unpack(font))
	hTitle:SetPoint("CENTER")
	hTitle:SetText("檔案")
	header.title = hTitle
	window.header = header
	
	local scrollFrame = CreateFrame("ScrollFrame", window:GetName().."_ScrollFrame", window, "UIPanelScrollFrameTemplate")
	scrollFrame:SetPoint("TOPLEFT", header, "BOTTOMLEFT", 5, -57)
	scrollFrame:SetWidth(window:GetWidth()-35)
	scrollFrame:SetHeight(window:GetHeight()-85)
	S:ReskinScroll(_G[window:GetName().."_ScrollFrameScrollBar"])
	scrollFrame:SetFrameLevel(window:GetFrameLevel()+1)
	
	scrollFrame.Anchor = CreateFrame("Frame", window:GetName().."_ScrollAnchor", scrollFrame)
	scrollFrame.Anchor:SetPoint("TOPLEFT", scrollFrame, "TOPLEFT", 0, -3)
	scrollFrame.Anchor:SetWidth(window:GetWidth()-40)
	scrollFrame.Anchor:SetHeight(scrollFrame:GetHeight()-4)
	scrollFrame.Anchor:SetFrameLevel(scrollFrame:GetFrameLevel()+1)
	scrollFrame:SetScrollChild(scrollFrame.Anchor)
	
	local EnableAll = CreateFrame("Button", window:GetName().."_EnableAllButton", window)
	S:CreateBD(EnableAll)
	EnableAll:SetSize((window:GetWidth()-15)/2, 20)
	EnableAll:SetPoint("TOPLEFT", header, "BOTTOMLEFT", 5, -5)
	EnableAll.text = EnableAll:CreateFontString(nil, "OVERLAY")
	EnableAll.text:SetFont(unpack(font))
	EnableAll.text:SetText("全部啓用")
	EnableAll.text:SetPoint("CENTER")
	EnableAll:SetScript("OnEnter", function(self) self.text:SetTextColor(0/255, 170/255, 255/255) self:SetBackdropColor(.2, .2, .2, .6) end)
	EnableAll:SetScript("OnLeave", function(self) self.text:SetTextColor(255/255, 255/255, 255/255) S:CreateBD(self) end)
	EnableAll:SetScript("OnClick", function(self)
		for i, addon in pairs(stAddonManager.AllAddons) do
			EnableAddOn(addon.name)
			stAddonManager.Buttons[i]:SetBackdropColor(0/255, 170/255, 255/255)
			addon.enabled = true
		end
	end)
	
	local DisableAll = CreateFrame("Button", window:GetName().."_DisableAllButton", window)
	S:CreateBD(DisableAll)
	DisableAll:SetSize(EnableAll:GetSize())
	DisableAll:SetPoint("TOPRIGHT", header, "BOTTOMRIGHT", -5, -5)
	DisableAll.text = DisableAll:CreateFontString(nil, "OVERLAY")
	DisableAll.text:SetFont(unpack(font))
	DisableAll.text:SetText("全部禁用")
	DisableAll.text:SetPoint("CENTER")
	DisableAll:SetScript("OnEnter", function(self) self.text:SetTextColor(0/255, 170/255, 255/255) self:SetBackdropColor(.2, .2, .2, .6) end)
	DisableAll:SetScript("OnLeave", function(self) self.text:SetTextColor(255/255, 255/255, 255/255) S:CreateBD(self) end)
	DisableAll:SetScript("OnClick", function(self)
		for i, addon in pairs(stAddonManager.AllAddons) do
			if addon.name ~= addonName then			
				DisableAddOn(addon.name)
				stAddonManager.Buttons[i]:SetBackdropColor(unpack(P["media"].backdropcolor))
				addon.enabled = false
			end
		end
	end)
	
	if not stAddonProfiles then
		stAddonProfiles = {}
	end
	
	local SaveProfile = CreateFrame("Button", window:GetName().."_SaveProfileButton", window)
	S:CreateBD(SaveProfile)
	SaveProfile:SetHeight(20)
	SaveProfile:SetPoint("TOPLEFT", EnableAll, "BOTTOMLEFT", 0, -5)
	SaveProfile:SetPoint("TOPRIGHT", DisableAll, "BOTTOMRIGHT", 0, -5)
	SaveProfile.text = SaveProfile:CreateFontString(nil, "OVERLAY")
	SaveProfile.text:SetFont(unpack(font))
	SaveProfile.text:SetText("新檔案")
	SaveProfile.text:SetPoint("CENTER")
	SaveProfile:SetScript("OnEnter", function(self) self.text:SetTextColor(0/255, 170/255, 255/255) self:SetBackdropColor(.2, .2, .2, .6) end)
	SaveProfile:SetScript("OnLeave", function(self) self.text:SetTextColor(255/255, 255/255, 255/255) S:CreateBD(self) end)
	SaveProfile:SetScript("OnClick", function(self)
		if not self.editbox then
			local ebox = CreateFrame("EditBox", nil, self)
			S:CreateBD(ebox)
			ebox:SetAllPoints(self)
			ebox:SetFont(unpack(font))
			ebox:SetText("Profile Name")
			ebox:SetAutoFocus(false)
			ebox:SetFocus(true)
			ebox:HighlightText()
			ebox:SetTextInsets(3, 0, 0, 0)
			ebox:SetScript("OnEditFocusGained", function(self) self:HighlightText() end)
			ebox:SetScript("OnEscapePressed", function(self) self:SetText("Profile Name") self:ClearFocus() self:Hide() end)
			ebox:SetScript("OnEnterPressed", function(self)
				local profileName = self:GetText()
				self:ClearFocus()
				self:SetText("Profile Name")
				self:Hide()
				if not profileName then return end
				stAddonProfiles[profileName] = GetEnabledAddons()
				stAddonManager:UpdateProfileList()
			end)
	
			self.editbox = ebox
		else
			self.editbox:Show()
			self.editbox:SetFocus(true)
			self.editbox:HighlightText()
		end
	end)
	self.SaveProfile = SaveProfile
	
	self:SetScript("OnHide", function(self)
		if self.SaveProfile.editbox then self.SaveProfile.editbox:Hide() end
		window:Hide()
		self.profileButton.text:SetText(">")
	end)
	
	local function CreateMenuButton(parent, width, height, text, ...)
		local button = CreateFrame("Button", nil, parent)
		button:SetFrameLevel(parent:GetFrameLevel()+1)
		button:SetSize(width, height)
		S:CreateBD(button)
		if ... then button:SetPoint(...) end
		
		button.text = button:CreateFontString(nil, "OVERLAY")
		button.text:SetFont(unpack(font))
		button.text:SetPoint("CENTER")
		if text then button.text:SetText(text) end
		
		button:SetScript("OnEnter", function(self) self.text:SetTextColor(0/255, 170/255, 255/255) self:SetBackdropColor(.2, .2, .2, .6) end)
		button:SetScript("OnLeave", function(self) self.text:SetTextColor(255/255, 255/255, 255/255) S:CreateBD(self) end)	
		
		return button
	end
	
	local buttons = {}
	function stAddonManager:UpdateProfileList()
		local i = 1
		
		local sort = function(t, func)
			local temp = {}
			local i = 0

			for n in pairs(t) do
				table.insert(temp, n)
			end

			table.sort(temp, func)
			
			local iter = function()
				i = i + 1
				if temp[i] == nil then
					return nil
				else
					return temp[i], t[temp[i]]
				end
			end

			return iter
		end
		
		for i=1, #buttons do
			buttons[i]:Hide()
			buttons[i].overlay:Hide()
			buttons[i]:SetHeight(20)
		end

		for profileName, addonList in sort(stAddonProfiles, function(a, b) return strlower(b) > strlower(a) end) do
			if not buttons[i] then
				local button = CreateMenuButton(scrollFrame.Anchor, scrollFrame:GetWidth()-4, 20, "<Profile Name>")
				button.text:ClearAllPoints()
				button.text:SetPoint("CENTER", button, "TOP", 0, -10)
				
				local overlay = CreateFrame("Frame", nil, button)
				overlay:EnableMouse(true) --just to stop the mouseover highlight when your mouse goes between the buttons
				overlay:SetPoint("BOTTOM", button, "BOTTOM", 0, 3)
				overlay:SetPoint("TOP", button, "TOP", 0, -20)
				overlay:SetWidth(button:GetWidth()-10)
				overlay:SetFrameLevel(button:GetFrameLevel()+1)
				overlay:Hide()
				
				overlay.set = CreateMenuButton(overlay, overlay:GetWidth(), 18, "Set to..", "TOP", overlay, "TOP", 0, 0)
				overlay.add = CreateMenuButton(overlay, overlay:GetWidth(), 18, "Add to..", "TOP", overlay.set, "BOTTOM", 0, -3)
				overlay.remove = CreateMenuButton(overlay, overlay:GetWidth(), 18, "Remove from..", "TOP", overlay.add, "BOTTOM", 0, -3)
				overlay.delete = CreateMenuButton(overlay, overlay:GetWidth(), 18, "Delete Profile", "TOP", overlay.remove, "BOTTOM", 0, -3)
				
				button.overlay = overlay
				
				button:SetScript("OnClick", function(self)
					if self.overlay:IsShown() then
						for i=1, #buttons do
							buttons[i].overlay:Hide()
							buttons[i]:SetHeight(20)
						end						
					else
						for i=1, #buttons do
							buttons[i].overlay:Hide()
							buttons[i]:SetHeight(20)
						end
						
						self.overlay:Show()
						self:SetHeight(25+(18*4)+(3*3))
					end
				end)
				
				buttons[i] = button
			end
			
			buttons[i]:Show()
			buttons[i].text:SetText(profileName)
			local overlay = buttons[i].overlay
			overlay.set:SetScript("OnClick", function(self)
				DisableAllAddOns()
				for i, name in pairs(addonList) do EnableAddOn(name) end
				stAddonManager.AllAddons = stAddonManager:UpdateAddonList()
				stAddonManager:UpdateList(stAddonManager.AllAddons)
			end)
			overlay.add:SetScript("OnClick", function(self)
				for i, name in pairs(addonList) do EnableAddOn(name) end
				stAddonManager.AllAddons = stAddonManager:UpdateAddonList()
				stAddonManager:UpdateList(stAddonManager.AllAddons)
			end)
			overlay.remove:SetScript("OnClick", function(self)
				for i, name in pairs(addonList) do if name ~= addonName then DisableAddOn(name) end end
				stAddonManager.AllAddons = stAddonManager:UpdateAddonList()
				stAddonManager:UpdateList(stAddonManager.AllAddons)
			end)
			overlay.delete:SetScript("OnClick", function(self)
				if IsShiftKeyDown() then
					stAddonProfiles[profileName] = nil
					stAddonManager:UpdateProfileList()
				else
					print("|cff00aaffst|rAddonManager: Are you sure you want to delete this profile? Hold down shift and click again if you are.")
				end
			end)
			
			i = i + 1
		end
		
		local prevButton
		for i,button in pairs(buttons) do
			if i == 1 then
				button:SetPoint("TOPLEFT", scrollFrame.Anchor, "TOPLEFT", 4, -2)
			else
				button:SetPoint("TOP", prevButton, "BOTTOM", 0, -3)
			end
			prevButton = button
		end
	end
	stAddonManager:UpdateProfileList()
	
	self.ProfileWindow = window
end

local function LoadWindow()
	if stAddonManager.Loaded then stAddonManager:Show(); return  end
	local window = stAddonManager
	local header = window.header
	
	tinsert(UISpecialFrames,window:GetName());
	
	window:SetSize(400,350)
	header:SetSize(400,20)
	
	S:CreateBD(window)
	S:CreateSD(window)
	S:CreateBD(header)
	
	header:EnableMouse(true)
	header:SetMovable(true)
	header:SetScript("OnMouseDown", function(self) self:StartMoving() end)
	header:SetScript("OnMouseUp", function(self) self:StopMovingOrSizing() end)
	
	local hTitle = stAddonManager.header:CreateFontString(nil, "OVERLAY")
	hTitle:SetFont(unpack(font))
	hTitle:SetPoint("CENTER")
	hTitle:SetText("|cff00aaffst|rAddonManager")
	header.title = hTitle 

	local close = CreateFrame("Button", nil, header)
	close:SetPoint("RIGHT", header, "RIGHT", 0, 0)
	close:SetFrameLevel(header:GetFrameLevel()+2)
	close:SetSize(20, 20)
	close.text = close:CreateFontString(nil, "OVERLAY")
	close.text:SetFont(unpack(font))
	close.text:SetText("x")
	close.text:SetPoint("CENTER", close, "CENTER", 0, 0)
	close:SetScript("OnEnter", function(self) self.text:SetTextColor(0/255, 170/255, 255/255) self:SetBackdropColor(.2, .2, .2, .6) end)
	close:SetScript("OnLeave", function(self) self.text:SetTextColor(255/255, 255/255, 255/255) S:CreateBD(self) end)
	close:SetScript("OnClick", function() window:Hide() end)
	header.close = close
	
	local addonListBG = CreateFrame("Frame", window:GetName().."_ScrollBackground", window)
	addonListBG:SetPoint("TOPLEFT", header, "TOPLEFT", 10, -50)
	addonListBG:SetWidth(window:GetWidth()-20)
	addonListBG:SetHeight(window:GetHeight()-60)
	S:CreateBD(addonListBG)
	
	--Create scroll frame (God damn these things are a pain)
	local scrollFrame = CreateFrame("ScrollFrame", window:GetName().."_ScrollFrame", window, "UIPanelScrollFrameTemplate")
	scrollFrame:SetPoint("TOPLEFT", addonListBG, "TOPLEFT", 0, -2)
	scrollFrame:SetWidth(addonListBG:GetWidth()-25)
	scrollFrame:SetHeight(addonListBG:GetHeight()-5)
	S:ReskinScroll(_G[window:GetName().."_ScrollFrameScrollBar"])
	scrollFrame:SetFrameLevel(window:GetFrameLevel()+1)
	
	scrollFrame.Anchor = CreateFrame("Frame", window:GetName().."_ScrollAnchor", scrollFrame)
	scrollFrame.Anchor:SetPoint("TOPLEFT", scrollFrame, "TOPLEFT", 0, -3)
	scrollFrame.Anchor:SetWidth(window:GetWidth()-40)
	scrollFrame.Anchor:SetHeight(scrollFrame:GetHeight())
	scrollFrame.Anchor:SetFrameLevel(scrollFrame:GetFrameLevel()+1)
	scrollFrame:SetScrollChild(scrollFrame.Anchor)
	
	--Load up addon information
	stAddonManager.AllAddons = stAddonManager:UpdateAddonList()
	stAddonManager.FilteredAddons = stAddonManager:UpdateAddonList()
	stAddonManager.showEnabled = true
	stAddonManager.showDisabled = true
	
	stAddonManager.Buttons = {}
	
	-- local lockedAddons = {}
	-- if not stLockedAddons then
		-- stLockedAddons = {}
	-- else
		-- lockedAddons = {}
	-- end
	
	--Create initial list
	for i, addon in pairs(stAddonManager.AllAddons) do
		local button = CreateFrame("Frame", nil, scrollFrame.Anchor)
		button:SetFrameLevel(scrollFrame.Anchor:GetFrameLevel() + 1)
		button:SetSize(16, 16)
		S:CreateBD(button)
		if addon.enabled then
		button:SetBackdropColor(0/255, 170/255, 255/255)
		end
		
		if i == 1 then
		button:SetPoint("TOPLEFT", scrollFrame.Anchor, "TOPLEFT", 5, -5)
		else
		button:SetPoint("TOP", stAddonManager.Buttons[i-1], "BOTTOM", 0, -5)
		end
		button.text = button:CreateFontString(nil, "OVERLAY")
		button.text:SetFont(unpack(font))
		button.text:SetJustifyH("LEFT")
		button.text:SetPoint("LEFT", button, "RIGHT", 8, 0)
		button.text:SetPoint("RIGHT", scrollFrame.Anchor, "RIGHT", 0, 0)
		button.text:SetText(addon.title)
		
		button:SetScript("OnEnter", function(self)
			GameTooltip:SetOwner(self, "ANCHOR_BOTTOMLEFT", -3, self:GetHeight())
			GameTooltip:ClearLines()
			
			if addon.version then GameTooltip:AddDoubleLine(addon.title, addon.version)
			else GameTooltip:AddLine(addon.title) end
			if addon.notes then	GameTooltip:AddLine(addon.notes, nil, nil, nil, true) end
			if addon.dependencies then GameTooltip:AddLine("Dependencies: "..unpack(addon.dependencies), 1, .5, 0, true) end
			if addon.optionaldependencies then GameTooltip:AddLine("Optional Dependencies: "..unpack(addon.optionaldependencies), 1, .5, 0, true) end
			
			GameTooltip:Show()
		end)
		
		button:SetScript("OnMouseDown", function(self)
			if addon.enabled then
				self:SetBackdropColor(unpack(R["media"].backdropcolor))
				DisableAddOn(addon.name)
				addon.enabled = false
			else
				self:SetBackdropColor(0/255, 170/255, 255/255)
				EnableAddOn(addon.name)
				addon.enabled = true
			end
		end)
			
		stAddonManager.Buttons[i] = button
	end
		
	 function stAddonManager:UpdateList(AddonsTable)
		--Start off by hiding all of the buttons
		for _, b in pairs(stAddonManager.Buttons) do b:Hide() end
		
		local bIndex = 1
		for i, addon in pairs(AddonsTable) do
			local button = stAddonManager.Buttons[bIndex]
			button:Show()
			if addon.enabled then
				button:SetBackdropColor(0/255, 170/255, 255/255)
			else
				button:SetBackdropColor(unpack(R["media"].backdropcolor))
			end
			
			button:SetScript("OnMouseDown", function(self)
				if addon.enabled then
					self:SetBackdropColor(unpack(R["media"].backdropcolor))
					DisableAddOn(addon.name)
					addon.enabled = false
				else
					self:SetBackdropColor(0/255, 170/255, 255/255)
					EnableAddOn(addon.name)
					addon.enabled = true
				end
			end)
			
			button.text:SetText(addon.title)
			bIndex = bIndex+1
		end
	end
		
	--Search Bar
	local searchBar = CreateFrame("EditBox", window:GetName().."_SearchBar", window)
	searchBar:SetFrameLevel(window:GetFrameLevel()+1)
	searchBar:SetPoint("TOPLEFT", header, "BOTTOMLEFT", 10, -5)
	searchBar:SetWidth(250)
	searchBar:SetHeight(20)
	S:CreateBD(searchBar)
	searchBar:SetFont(unpack(font))
	searchBar:SetText("搜索")
	searchBar:SetAutoFocus(false)
	searchBar:SetTextInsets(3, 0, 0 ,0)
	searchBar:SetScript("OnEnterPressed", function(self) self:ClearFocus() end)
	searchBar:SetScript("OnEscapePressed", function(self) searchBar:SetText("Search") stAddonManager:UpdateList(stAddonManager.AllAddons) searchBar:ClearFocus() end)
	searchBar:SetScript("OnEditFocusGained", function(self) self:HighlightText() end)
	searchBar:SetScript("OnTextChanged", function(self, input)
		if input then
			stAddonManager.FilteredAddons = stAddonManager:UpdateAddonList(self:GetText())
			stAddonManager:UpdateList(stAddonManager.FilteredAddons)
		end
	end)
		
	local sbClear = CreateFrame("Button", nil, searchBar)
	sbClear:SetPoint("RIGHT", searchBar, "RIGHT", 0, 0)
	sbClear:SetFrameLevel(searchBar:GetFrameLevel()+2)
	sbClear:SetSize(20, 20)
	sbClear.text = sbClear:CreateFontString(nil, "OVERLAY")
	sbClear.text:SetFont(unpack(font))
	sbClear.text:SetText("x")
	sbClear.text:SetPoint("CENTER", sbClear, "CENTER", 0, 0)
	sbClear:SetScript("OnEnter", function(self) self.text:SetTextColor(0/255, 170/255, 255/255) end)
	sbClear:SetScript("OnLeave", function(self) self.text:SetTextColor(255/255, 255/255, 255/255) end)
	sbClear:SetScript("OnClick", function(self) searchBar:SetText("Search") stAddonManager:UpdateList(stAddonManager.AllAddons) searchBar:ClearFocus() end)
	searchBar.clear = sbClear
	stAddonManager.searchBar = searchBar

	local profileButton = CreateFrame("Button", window:GetName().."_ProfileWindowButton", window)
	profileButton:SetPoint("TOPRIGHT", header, "BOTTOMRIGHT", -10, -5)
	profileButton:SetSize(20, 20)
	S:CreateBD(profileButton)
	profileButton.text = profileButton:CreateFontString(nil, "OVERLAY")
	profileButton.text:SetFont(unpack(font))
	profileButton.text:SetText(">")
	profileButton.text:SetPoint("CENTER", profileButton, "CENTER", 0, 0)
	profileButton:SetScript("OnEnter", function(self) self.text:SetTextColor(0/255, 170/255, 255/255) self:SetBackdropColor(.2, .2, .2, .6) end)
	profileButton:SetScript("OnLeave", function(self) self.text:SetTextColor(255/255, 255/255, 255/255) S:CreateBD(self) end)
	profileButton:SetScript("OnClick", function(self)
		LoadProfileWindow()
		if stAddonManager.ProfileWindow:IsShown() then
			self.text:SetText("<")
		else
			self.text:SetText(">")
		end
	end)
	stAddonManager.profileButton = profileButton
	
	local reloadButton = CreateFrame("Button", window:GetName().."_ReloadUIButton", window)
	reloadButton:SetPoint("LEFT", searchBar, "RIGHT", 5, 0)
	reloadButton:SetPoint("RIGHT", profileButton, "LEFT", -5, 0)
	reloadButton:SetHeight(searchBar:GetHeight())
	reloadButton.text = reloadButton:CreateFontString(nil, "OVERLAY")
	reloadButton.text:SetPoint("CENTER")
	reloadButton.text:SetFont(unpack(font))
	reloadButton.text:SetText("重載")
	reloadButton:SetScript("OnEnter", function(self) self.text:SetTextColor(0/255, 170/255, 255/255) self:SetBackdropColor(.2, .2, .2, .6) end)
	reloadButton:SetScript("OnLeave", function(self) self.text:SetTextColor(255/255, 255/255, 255/255) S:CreateBD(self) end)
	reloadButton:SetScript("OnClick", function(self)
		if InCombatLockdown() then return end
		ReloadUI()
	end)
	S:CreateBD(reloadButton)
	stAddonManager.reloadButton = reloadButton
	
	stAddonManager.Loaded = true
end

SLASH_STADDONMANAGER1, SLASH_STADDONMANAGER2, SLASH_STADDONMANAGER3 = "/staddonmanager", "/stam", "/staddon"
SlashCmdList["STADDONMANAGER"] = LoadWindow

local function CheckForAddon(event, addon, addonName)
	return ((event == "PLAYER_ENTERING_WORLD" and IsAddOnLoaded(addonName)) or (event == "ADDON_LOADED" and addon == addonName))
end

local gmbAddOns = CreateFrame("Button", "GameMenuButtonAddOns", GameMenuFrame, "GameMenuButtonTemplate")
gmbAddOns:SetSize(GameMenuButtonMacros:GetWidth(), GameMenuButtonMacros:GetHeight())
GameMenuFrame:SetHeight(GameMenuFrame:GetHeight()+GameMenuButtonMacros:GetHeight());
GameMenuButtonLogout:SetPoint("TOP", gmbAddOns, "BOTTOM", 0, -2)
gmbAddOns:SetPoint("TOP", GameMenuButtonMacros, "BOTTOM", 0, -2)
gmbAddOns:SetText("|cff00aaffst|rAddonManager")
gmbAddOns:SetScript("OnClick", function()
	HideUIPanel(GameMenuFrame);
	LoadWindow()
end)

S:Reskin(gmbAddOns)
local font = {GameMenuButtonMacros:GetFontString():GetFont()}
local shadow = {GameMenuButtonMacros:GetFontString():GetShadowOffset()}
gmbAddOns:GetFontString():SetFont(unpack(font))
gmbAddOns:GetFontString():SetShadowOffset(unpack(shadow))