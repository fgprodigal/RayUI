local R, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local TradeTabs = CreateFrame("Frame","TradeTabs")

local whitelist = {
	[171] = true, -- Alchemy
	[164] = true, -- Blacksmithing
	[185] = true, -- Cooking
	[333] = true, -- Enchanting
	[129] = true, -- First Aid
	[773] = true, -- Inscription
	[755] = true, -- Jewelcrafting
	[165] = true, -- Leatherworking
	[186] = true, -- Mining
	[197] = true, -- Tailoring
	[202] = true, -- Engineering
}

local onlyPrimary = {
	[171] = true, -- Alchemy	
}

local RUNEFORGING = 53428 -- Runeforging spellid

function TradeTabs:OnEvent(event,...)
	self:UnregisterEvent(event)
	if not IsLoggedIn() then
		self:RegisterEvent(event)
	elseif InCombatLockdown() then
		self:RegisterEvent("PLAYER_REGEN_ENABLED")
	else
		self:Initialize()
	end
end

local function buildSpellList()
	local p1, p2, arch, fishing, cooking, firstaid = GetProfessions()
	local profs = {p1, p2, cooking, firstaid}

	local tradeSpells = {}
	local extras = 0

	for _,prof in pairs(profs) do
		local name, icon, _, _, abilities, offset, skillLine = GetProfessionInfo(prof)  
		if whitelist[skillLine] then
			
			if onlyPrimary[skillLine] then
				abilities = 1
			end

			for i = 1, abilities do
				if not IsPassiveSpell(i + offset, BOOKTYPE_PROFESSION) then
					-- if more than one ability per profession, stick anything after the first
					-- at the end of the list, and keep track of how many are back there to insert
					-- other 'primary' skills before them
					if i > 1 then
						tinsert(tradeSpells, i + offset)
						extras = extras + 1
					else
						tinsert(tradeSpells, #tradeSpells + 1 - extras, i + offset)
					end
				end
			end
		end
	end

	return tradeSpells
end

function TradeTabs:Initialize()
	if self.initialized or not IsAddOnLoaded("Blizzard_TradeSkillUI") then return end -- Shouldn't need this, but I'm paranoid
	
	local parent = TradeSkillFrame
	
	local tradeSpells = buildSpellList()
	local i = 1
	local prev
	
	-- if player is a DK, insert runeforging at the top
	if select(2, UnitClass("player")) == "DEATHKNIGHT" then
		prev = self:CreateTab(i, parent, RUNEFORGING)
		prev:SetPoint("TOPLEFT", parent, "TOPRIGHT", 10, -44)
		i = i + 1
	end

	for i, slot in ipairs(tradeSpells) do
		local _, spellID = GetSpellBookItemInfo(slot, BOOKTYPE_PROFESSION)
		local tab = self:CreateTab(i, parent, spellID)
		i = i + 1
		
		local point,relPoint,x,y = "TOPLEFT", "BOTTOMLEFT", 0, -17
		if not prev then
			prev, relPoint, x, y = parent, "TOPRIGHT", 10, -44
		end
		tab:SetPoint(point, prev, relPoint, x, y)
		
		prev = tab
	end

	self.initialized = true
end

local function onEnter(self) 
	GameTooltip:SetOwner(self,"ANCHOR_RIGHT") GameTooltip:SetText(self.tooltip) 
	self:GetParent():LockHighlight()
end

local function onLeave(self) 
	GameTooltip:Hide()
	self:GetParent():UnlockHighlight()
end   

local function updateSelection(self)
	if IsCurrentSpell(self.spell) then
		self:SetChecked(true)
		self.clickStopper:Show()
	else
		self:SetChecked(false)
		self.clickStopper:Hide()
	end
end

local function createClickStopper(button)
	local f = CreateFrame("Frame",nil,button)
	f:SetAllPoints(button)
	f:EnableMouse(true)
	f:SetScript("OnEnter",onEnter)
	f:SetScript("OnLeave",onLeave)
	button.clickStopper = f
	f.tooltip = button.tooltip
	f:Hide()
end

function TradeTabs:CreateTab(i, parent, spellID)
	local S = R:GetModule("Skins")
	local spell, _, texture = GetSpellInfo(spellID)
	local button = CreateFrame("CheckButton","TradeTabsTab"..i,parent,"SpellBookSkillLineTabTemplate,SecureActionButtonTemplate")
	button.tooltip = spell
	button.spellID = spellID
	button.spell = spell

	button:Show()
	button:SetAttribute("type","spell")
	button:SetAttribute("spell",spell)
	
	button:SetNormalTexture(texture)
	
	button:SetScript("OnEvent",updateSelection)
	button:RegisterEvent("TRADE_SKILL_SHOW")
	button:RegisterEvent("TRADE_SKILL_CLOSE")
	button:RegisterEvent("CURRENT_SPELL_CAST_CHANGED")

	createClickStopper(button)
	updateSelection(button)

	button:GetRegions():Hide()
	button:SetCheckedTexture(S["media"].checked)
	S:CreateBG(button)
	S:CreateSD(button, 5, 0, 0, 0, 1, 1)
	button:StyleButton(true)
	button:SetPushedTexture(nil)
	select(4, button:GetRegions()):SetTexCoord(.08, .92, .08, .92)
	return button
end

TradeTabs:RegisterEvent("TRADE_SKILL_SHOW")	
TradeTabs:SetScript("OnEvent",TradeTabs.OnEvent)

TradeTabs:Initialize()
