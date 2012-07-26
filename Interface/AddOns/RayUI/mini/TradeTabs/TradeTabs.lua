local R, L, P = unpack(select(2, ...)) --Inport: Engine, Locales, ProfileDB
local TradeTabs = CreateFrame("Frame","TradeTabs")

local tradeSpells = { -- Spell order in this table determines the tab order
	28596, -- Alchemy
	29844, -- Blacksmithing
	28029, -- Enchanting
	30350, -- Engineering
	45357, -- Inscription
	28897, -- Jewel Crafting
	32549, -- Leatherworking
	53428, -- Runeforging
	2656,  -- Smelting
	26790, -- Tailoring

	33359, -- Cooking
	27028, -- First Aid

	13262, -- Disenchant
	51005, -- Milling
	31252, -- Prospecting
	818,   -- Basic Campfire
	78670, --考古?
}

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


function TradeTabs:Initialize()
	if self.initialized or not IsAddOnLoaded("Blizzard_TradeSkillUI") then return end -- Shouldn't need this, but I'm paranoid

	for i=1,#tradeSpells do
		local n = GetSpellInfo(tradeSpells[i])
		tradeSpells[n] = -1
		tradeSpells[i] = n
	end

	local parent = TradeSkillFrame
	if SkilletFrame then
		parent = SkilletFrame
		self:UnregisterAllEvents()
	elseif ATSWFrame then -- ATSW support
		parent = ATSWFrame
		self:UnregisterAllEvents()
	end

	for i=1,MAX_SPELLS do
	--	local n = GetSpellName(i,"spell")
		local n = GetSpellBookItemName(i, "spell")
		if tradeSpells[n] then
			tradeSpells[n] = i
		end
	end

	local prev
	for i,spell in ipairs(tradeSpells) do
		local spellid = tradeSpells[spell]
		if type(spellid) == "number" and spellid > 0 then
		local tab = self:CreateTab(spell,spellid,parent)
		local point,relPoint,x,y = "TOPLEFT","BOTTOMLEFT",0,-17
		if not prev then
				prev,relPoint,x,y = parent,"TOPRIGHT",13,-44
			if (parent == SkilletFrame) or Skinner then x = 0 end -- Special case. ew
			end
			tab:SetPoint(point,prev,relPoint,x,y)
			prev = tab
		end
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
	if IsCurrentSpell(self.spellID,"spell") then
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

function TradeTabs:CreateTab(spell,spellID,parent)
	local S = R:GetModule("Skins")
    local button = CreateFrame("CheckButton",nil,parent,"SpellBookSkillLineTabTemplate,SecureActionButtonTemplate")
    button.tooltip = spell
	button:Show()
    button:SetAttribute("type","spell")
    button:SetAttribute("spell",spell)
    button.spellID = spellID
    button:GetRegions():Hide()
	button:SetCheckedTexture(S["media"].checked)
	S:CreateBG(button)
	S:CreateSD(button, 5, 0, 0, 0, 1, 1)
	button:SetNormalTexture(GetSpellTexture(spellID, "spell"))
	button:StyleButton(true)
	button:SetPushedTexture(nil)
	select(4, button:GetRegions()):SetTexCoord(.08, .92, .08, .92)
	button:SetScript("OnEvent",updateSelection)
	button:RegisterEvent("TRADE_SKILL_SHOW")
	button:RegisterEvent("TRADE_SKILL_CLOSE")
	button:RegisterEvent("CURRENT_SPELL_CAST_CHANGED")

    createClickStopper(button)
    updateSelection(button)
	return button
end

TradeTabs:RegisterEvent("TRADE_SKILL_SHOW")
TradeTabs:SetScript("OnEvent",TradeTabs.OnEvent)

TradeTabs:Initialize()