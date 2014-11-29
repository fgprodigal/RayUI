local R, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local B = R:NewModule("Bags", "AceHook-3.0", "AceEvent-3.0", "AceTimer-3.0")
local S = R:GetModule("Skins")

local cargBags = select(2, ...).cargBags

B.modName = L["背包"]

function B:GetOptions()
	local options = {
		bagSize = {
			order = 5,
			type = "range",
			name = L["背包格大小"],
			min = 15, max = 45, step = 1,
			set = function(info, value) R.db.Bags[ info[#info] ] = value B:Layout() end,
		},			
		sortInverted = {
			order = 7,
			type = "toggle",
			name = L["逆序整理"],
			set = function(info, value) R.db.Bags[ info[#info] ] = value end,
		},				
		bagWidth = {
			order = 8,
			type = "range",
			name = L["背包面板宽度"],
			min = 8, max = 20, step = 1,
			set = function(info, value) R.db.Bags[ info[#info] ] = value B:Layout() end,
		},
		bankWidth = {
			order = 9,
			type = "range",
			name = L["银行面板宽度"],
			min = 8, max = 20, step = 1,
			set = function(info, value) R.db.Bags[ info[#info] ] = value B:Layout(true) end,
		},
	}
	return options
end

function B:Tooltip_Show()
	GameTooltip:SetOwner(self:GetParent(), "ANCHOR_TOP", 0, 4)
	GameTooltip:ClearLines()
	GameTooltip:AddLine(self.ttText)
	if self.ttText2 then
		GameTooltip:AddLine(" ")
		GameTooltip:AddDoubleLine(self.ttText2, self.ttText2desc, 1, 1, 1)
	end
	GameTooltip:Show()
end

function B:Tooltip_Hide()
	GameTooltip:Hide()
end

function B:OpenBags()
	cargBags.blizzard:Show()
end

function B:CloseBags()
	cargBags.blizzard:Hide()
end

local equipSetTip = CreateFrame("GameTooltip", "RayUICheckEquipSetTip", UIParent, "GameTooltipTemplate")

local function CheckEquipmentSet(item)
	if not item.bagID or not item.slotID then return false end
	equipSetTip:SetOwner(UIParent, "ANCHOR_NONE")
    equipSetTip:ClearLines()
    equipSetTip:SetBagItem(item.bagID, item.slotID)
	equipSetTip:Show()

	for index = 1, equipSetTip:NumLines() do
		if string.match(_G["RayUICheckEquipSetTipTextLeft" .. index]:GetText(), string.gsub(EQUIPMENT_SETS,"%%s\124r","")) then
			return true
		end
	end
	return false
end

function B:Initialize()
	if B.db.bagWidth > 20 then B.db.bagWidth = 10 end
	if B.db.bankWidth > 20 then B.db.bankWidth = 12 end

	local RayUI_ContainerFrame = cargBags:NewImplementation("RayUI_ContainerFrame")	-- Let the magic begin!
	RayUI_ContainerFrame:RegisterBlizzard() -- register the frame for use with BLizzard's ToggleBag()-functions

	-- A highlight function styles the button if they match a certain condition
	local function highlightFunction(button, match)
		button:SetAlpha(match and 1 or 0.1)
	end

	local f = {}
	function RayUI_ContainerFrame:OnInit()
		local consumable = select(4, GetAuctionItemClasses())
		-- The filters control which items go into which container
		local INVERTED = -1 -- with inverted filters (using -1), everything goes into this bag when the filter returns false
		local onlyBags = function(item) return item.bagID >= 0 and item.bagID <= 4 and not CheckEquipmentSet(item) and item.type ~= consumable end
		local onlyBank =		function(item) return item.bagID == -1 or item.bagID >= 5 and item.bagID <= 11 and not CheckEquipmentSet(item) and item.type ~= consumable end
		local onlyReagent =		function(item) return item.bagID == -3 end
		local onlyBagSets =		function(item) return CheckEquipmentSet(item) and not (item.bagID == -1 or item.bagID >= 5 and item.bagID <= 11) end
		local onlyBagConsumables =		function(item) return item.type == consumable and not (item.bagID == -1 or item.bagID >= 5 and item.bagID <= 11) end
		local onlyBankSets =	function(item) return CheckEquipmentSet(item) and not (item.bagID >= 0 and item.bagID <= 4) end
		local onlyBankConsumables =		function(item) return item.type == consumable and not (item.bagID >= 0 and item.bagID <= 4) end
		local onlyRareEpics =	function(item) return item.rarity and item.rarity > 3 end
		local onlyEpics =		function(item) return item.rarity and item.rarity > 3 end
		local hideJunk =		function(item) return not item.rarity or item.rarity > 0 end
		local hideEmpty =		function(item) return item.texture ~= nil end

		local MyContainer = RayUI_ContainerFrame:GetContainerClass()
		-- Bagpack
		f.main = MyContainer:New("Main", {
			Columns = B.db.bagWidth,
			Bags = "backpack+bags",
			Movable = true,
		})
		f.main:SetFilter(onlyBags, true)
		f.main:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -55, 30) -- bagpack position

		-- Bank frame and bank bags
		f.bank = MyContainer:New("Bank", {
			Columns = B.db.bankWidth,
			Bags = "bankframe+bank",
		})
		f.bank:SetFilter(onlyBank, true) -- Take only items from the bank frame
		f.bank:SetPoint("BOTTOMRIGHT", "RayUI_ContainerFrameMain", "BOTTOMLEFT", -25, 0) -- bank frame position
		f.bank:Hide() -- Hide at the beginning

		-- Reagent frame and bank bags
		f.reagent = MyContainer:New("Reagent", {Columns = B.db.bankWidth, Bags = "bankreagent"})
		f.reagent:SetFilter(onlyReagent, true)
		f.reagent:SetParent(f.bank)
		f.reagent:SetPoint("BOTTOMRIGHT", "RayUI_ContainerFrameBank", "BOTTOMLEFT", -25, 0)

		f.consumables = MyContainer:New("Consumables", {Columns = B.db.bagWidth, Bags = "backpack+bags"})
		f.consumables:SetFilter(onlyBagConsumables, true)
		f.consumables:SetParent(f.main)
		f.consumables:SetPoint("BOTTOMLEFT", f.main,"TOPLEFT", 0, 3)

		f.sets = MyContainer:New("ItemSets", {Columns = B.db.bagWidth, Bags = "backpack+bags"})
		f.sets:SetFilter(onlyBagSets, true)
		f.sets:SetParent(f.main)
		f.sets:SetPoint("BOTTOMLEFT", f.consumables,"TOPLEFT", 0, 3)

		f.bankconsumables = MyContainer:New("BankConsumables", {Columns = B.db.bankWidth, Bags = "backpack+bags"})
		f.bankconsumables:SetFilter(onlyBankConsumables, true)
		f.bankconsumables:SetParent(f.bank)
		f.bankconsumables:SetPoint("BOTTOMLEFT", f.bank,"TOPLEFT", 0, 3)

		f.banksets = MyContainer:New("BankItemSets", {Columns = B.db.bankWidth, Bags = "bankframe+bank"})
		f.banksets:SetFilter(onlyBankSets, true)
		f.banksets:SetParent(f.bank)
		f.banksets:SetPoint("BOTTOMLEFT", f.bankconsumables,"TOPLEFT", 0, 3)
	end

	-- Bank frame toggling
	function RayUI_ContainerFrame:OnBankOpened()
		self:GetContainer("Bank"):Show()
	end

	function RayUI_ContainerFrame:OnBankClosed()
		self:GetContainer("Bank"):Hide()
	end

	-- Class: ItemButton appearencence classification
	local MyButton = RayUI_ContainerFrame:GetItemButtonClass()
	MyButton:Scaffold("RayUI")
	function MyButton:OnUpdate(item)
		-- color the border based on bag type
		local bagType = select(2, GetContainerNumFreeSlots(self.bagID));
		-- ammo / soulshards
		if(bagType and (bagType > 0 and bagType < 8)) then
			self.Border:SetVertexColor(0.85, 0.85, 0.35, 1);
			-- profession bags
		elseif(bagType and bagType > 4) then
			self.Border:SetVertexColor(0.1, 0.65, 0.1, 1);
			-- normal bags
		else
			self.Border:SetVertexColor(.7, .7, .7, .9);
		end
	end

	--	Class: BagButton is the template for all buttons on the BagBar
	local BagButton = RayUI_ContainerFrame:GetClass("BagButton", true, "BagButton")
	-- We color the CheckedTexture golden, not bright yellow
	function BagButton:OnCreate()
		self:GetCheckedTexture():SetVertexColor(0.3, 0.9, 0.9, 0.5)
	end

	-- Class: Container (Serves as a base for all containers/bags)
	-- Fetch our container class that serves as a basis for all our containers/bags

	local UpdateDimensions = function(self)
		local width, height = self:LayoutButtons("grid", self.Settings.Columns, 3, 6, -45)
		--local width, height = self:GetWidth(), self:GetHeight()
		local margin = 60			-- Normal margin space for infobar
		if self.BagBar and self.BagBar:IsShown() then
			margin = margin + 40	-- Bag button space
		end
		self:SetHeight(height + margin)
	end

	local MyContainer = RayUI_ContainerFrame:GetContainerClass()
	function MyContainer:OnContentsChanged()
		-- sort our buttons based on the slotID
		self:SortButtons("bagSlot")
		-- Order the buttons in a layout, ("grid", columns, spacing, xOffset, yOffset) or ("circle", radius (optional), xOffset, yOffset)
		local width, height = self:LayoutButtons("grid", self.Settings.Columns, 3, 6, -45)
		self:SetSize(width + 12, height + 12)
		if (self.UpdateDimensions) then self:UpdateDimensions() end -- Update the bag's height
		if self.name == "ItemSets" or self.name == "Consumables" then
			local width, height = self:LayoutButtons("grid", self.Settings.Columns, 3, 6, -25)
			self:SetSize(width + 12, height + 32)
		end

		if self.name == "BankItemSets" or self.name == "BankConsumables" then
			local width, height = self:LayoutButtons("grid", self.Settings.Columns, 3, 6, -25)
			self:SetSize(width + 12, height + 32)
		end

		if RayUI_ContainerFrameItemSets:GetHeight()<33 then
			f.sets:Hide()
		else
			f.sets:Show()
		end

		if RayUI_ContainerFrameConsumables:GetHeight()<33 then
			f.consumables:Hide()
		else
			f.consumables:Show()
		end

		if RayUI_ContainerFrameBankItemSets:GetHeight()<33 then
			f.banksets:Hide()
		else
			f.banksets:Show()
		end

		if RayUI_ContainerFrameBankConsumables:GetHeight()<33 then
			f.bankconsumables:Hide()
		else
			f.bankconsumables:Show()
		end
	end

	-- OnCreate is called every time a new container is created 
	function MyContainer:OnCreate(name, settings)
		settings = settings or {}
		self.Settings = settings
		self.UpdateDimensions = UpdateDimensions

		self:EnableMouse(true)

		self:CreateShadow("Background")
		self:SetBackdropColor(0, 0, 0, 0.9)
		self:SetBackdropBorderColor(0, 0, 0, 0.8)

		self:SetParent(settings.Parent or RayUI_ContainerFrame)
		self:SetFrameStrata("HIGH")

		if(settings.Movable) then
			self:SetMovable(true)
			self:RegisterForClicks("LeftButton", "RightButton")
			self:SetScript("OnMouseDown", function()
				self:ClearAllPoints() 
				self:StartMoving()
			end)
		end
		self:SetScript("OnMouseUp",  self.StopMovingOrSizing)

		settings.Columns = settings.Columns or 10
		if name == "Bank" or name == "Main" then -- don't need all that junk on "other" sections
			--Sort Button
			self.sortButton = CreateFrame("Button", nil, self)
			self.sortButton:Point("TOPLEFT", self, "TOPLEFT", 5, -4)
			self.sortButton:Size(55, 10)
			self.sortButton.ttText = L["整理背包"]
			self.sortButton:SetScript("OnEnter", B.Tooltip_Show)
			self.sortButton:SetScript("OnLeave", B.Tooltip_Hide)
			self.sortButton:SetScript("OnClick", function() B:CommandDecorator(B.SortBags, self.name == "Bank" and "bank" or "bags")() end)
			S:Reskin(self.sortButton)

			--Stack Button
			self.stackButton = CreateFrame("Button", nil, self)
			self.stackButton:Point("LEFT", self.sortButton, "RIGHT", 3, 0)
			self.stackButton:Size(55, 10)
			self.stackButton.ttText = L["堆叠物品"]
			self.stackButton:SetScript("OnEnter", B.Tooltip_Show)
			self.stackButton:SetScript("OnLeave", B.Tooltip_Hide)
			self.stackButton:SetScript("OnClick", function() B:CommandDecorator(B.Compress, self.name == "Bank" and "bank" or "bags")() end)
			S:Reskin(self.stackButton)

			--Bagbar Button
			self.bagsButton = CreateFrame("Button", nil, self)
			self.bagsButton:Point("LEFT", self.stackButton, "RIGHT", 3, 0)
			self.bagsButton:Size(55, 10)
			self.bagsButton.ttText = L["显示背包"]
			self.bagsButton:SetScript("OnEnter", B.Tooltip_Show)
			self.bagsButton:SetScript("OnLeave", B.Tooltip_Hide)
			self.bagsButton:SetScript("OnClick", function()
				if(self.BagBar:IsShown()) then
					self.BagBar:Hide()
				else
					self.BagBar:Show()
				end
				self:UpdateDimensions()
			end)
			S:Reskin(self.bagsButton)

			local infoFrame = CreateFrame("Button", nil, self)
			infoFrame:Point("TOPLEFT", self, "TOPLEFT", 5, -21)
			infoFrame:Point("TOPRIGHT", self, "TOPRIGHT", -5, -21)
			infoFrame:SetHeight(20)

			-- This one shows currencies, ammo and - most important - money!
			local tagDisplay = self:SpawnPlugin("TagDisplay", "[money]", infoFrame)
			tagDisplay:SetFont(R["media"].font, R["media"].fontsize)
			tagDisplay:SetPoint("RIGHT", infoFrame, "RIGHT", 0, 0)

			-- Plugin: SearchBar
			local searchText = infoFrame:CreateFontString(nil, "OVERLAY")
			searchText:SetPoint("LEFT", infoFrame, "LEFT", 0, 0)
			searchText:SetFont(R["media"].font, R["media"].fontsize)
			searchText:SetText(SEARCH) -- our searchbar comes up when we click on infoFrame		

			local search = self:SpawnPlugin("SearchBar", infoFrame)
			search.highlightFunction = highlightFunction -- same as above, only for search
			search.isGlobal = true -- This would make the search apply to all containers instead of just this one
			search:ClearAllPoints()
			search:SetPoint("LEFT", infoFrame, 0, 0)
			search:SetPoint("RIGHT", infoFrame, 0, 0)
			search:SetHeight(20)
			self.Search.Left:Hide()
			self.Search.Right:Hide()
			self.Search.Center:Hide()
			RayUI[1]:GetModule("Skins"):ReskinInput(self.Search)

			-- Plugin: BagBar
			local bagBar = self:SpawnPlugin("BagBar", settings.Bags)
			bagBar:SetSize(bagBar:LayoutButtons("grid", 7))
			bagBar.highlightFunction = highlightFunction -- from above, optional, used when hovering over bag buttons
			bagBar.isGlobal = true -- This would make the hover-effect apply to all containers instead of the current one
			bagBar:Hide()
			bagBar:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT", 5, 5)
			self.BagBar = bagBar
			-- creating button for toggling BagBar on and off
			self:UpdateDimensions()

			local closebutton = CreateFrame("Button", nil, self)
			closebutton:SetFrameLevel(30)
			closebutton:SetSize(14,14)
			RayUI[1]:GetModule("Skins"):ReskinClose(closebutton)
			closebutton:ClearAllPoints()
			closebutton:SetPoint("TOPRIGHT", -6, -3)

			closebutton:SetScript("OnClick", function(self) 
				if RayUI_ContainerFrame:AtBank() and self.name == "Bank" then 
					CloseBankFrame() 
				else 
					CloseAllBags() 
				end 
			end)
		elseif name == "ItemSets" or name == "BankItemSets" then
			local setname = self:CreateFontString(nil,"OVERLAY")
			setname:SetPoint("TOPLEFT", self, "TOPLEFT",5,-5)
			setname:SetFont(R["media"].font, R["media"].fontsize, "THINOUTLINE")
			setname:SetText(string.format(EQUIPMENT_SETS,' '))
		elseif name == "Consumables" or name == "BankConsumables" then
			local consumable = select(4, GetAuctionItemClasses())
			local setname = self:CreateFontString(nil,"OVERLAY")
			setname:SetPoint("TOPLEFT", self, "TOPLEFT",5,-5)
			setname:SetFont(R["media"].font, R["media"].fontsize, "THINOUTLINE")
			setname:SetText(consumable)
		elseif name == "Reagent" then
			local setname = self:CreateFontString(nil,"OVERLAY")
			setname:SetPoint("TOPLEFT", self, "TOPLEFT",5,-5)
			setname:SetFont(R["media"].font, R["media"].fontsize, "THINOUTLINE")
			setname:SetText(REAGENT_BANK)
			
			--Sort Button
			self.sortButton = CreateFrame("Button", nil, self)
			self.sortButton:Point("TOPLEFT", self, "TOPLEFT", 5, -24)
			self.sortButton:Size(55, 10)
			self.sortButton.ttText = L["整理背包"]
			self.sortButton:SetScript("OnEnter", B.Tooltip_Show)
			self.sortButton:SetScript("OnLeave", B.Tooltip_Hide)
			self.sortButton:SetScript("OnClick", SortReagentBankBags)
			S:Reskin(self.sortButton)
	
			--Deposit Button
			self.depositButton = CreateFrame("Button", nil, self)
			self.depositButton:Point("LEFT", self.sortButton, "RIGHT", 3, 0)
			self.depositButton:Size(55, 10)
			self.depositButton.ttText = REAGENTBANK_DEPOSIT
			self.depositButton:SetScript("OnEnter", B.Tooltip_Show)
			self.depositButton:SetScript("OnLeave", B.Tooltip_Hide)
			self.depositButton:SetScript("OnClick", DepositReagentBank)
			S:Reskin(self.depositButton)

			if not IsReagentBankUnlocked() then
				local buyReagent = CreateFrame("Button", nil, self, "UIPanelButtonTemplate")
				buyReagent:SetText(BANKSLOTPURCHASE)
				buyReagent:SetWidth(buyReagent:GetTextWidth() + 20)
				buyReagent:Point("TOPRIGHT", self, "TOPRIGHT", -5, -14)
				buyReagent:SetScript("OnEnter", function(self)
					GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
					GameTooltip:AddLine(REAGENT_BANK_HELP, 1, 1, 1, true)
					GameTooltip:Show()
				end)
				buyReagent:SetScript("OnLeave", function()
					GameTooltip:Hide()
				end)
				buyReagent:SetScript("OnClick", function()
					StaticPopup_Show("CONFIRM_BUY_REAGENTBANK_TAB")
				end)
				buyReagent:SetScript("OnEvent", function(...)
					buyReagent:UnregisterEvent("REAGENTBANK_PURCHASED")
					buyReagent:Hide()
				end)
				S:Reskin(buyReagent)
				buyReagent:RegisterEvent("REAGENTBANK_PURCHASED")
			end
		end

		if name == "Main" or name == "ItemSets" or name == "Consumables" then
			self:HookScript("OnShow", function()
				R:GetModule("Tooltip"):GameTooltip_SetDefaultAnchor(GameTooltip)
			end)
			self:HookScript("OnHide", function()
				R:GetModule("Tooltip"):GameTooltip_SetDefaultAnchor(GameTooltip)
			end)
		end
	end

	self:OpenBags()
	self:CloseBags()
	self:RawHook("OpenBag","OpenBags", true)
	self:HookScript(TradeFrame, "OnShow", "OpenBags")
	self:HookScript(TradeFrame, "OnHide", "CloseBags")
end

function B:Info()
	return L["|cff7aa6d6Ray|r|cffff0000U|r|cff7aa6d6I|r背包模块."]
end

R:RegisterModule(B:GetName())
