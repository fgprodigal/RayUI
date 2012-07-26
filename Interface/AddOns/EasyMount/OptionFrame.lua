------------------------------------------------------------
-- OptionFrame.lua
--
-- Abin
-- 2011/2/20
------------------------------------------------------------

local pairs = pairs
local CreateFrame = CreateFrame
local GameTooltip = GameTooltip

local _, addon = ...
local L = addon.L

BINDING_HEADER_EASYMOUNT_TITLE = "EasyMount"
BINDING_NAME_EASYMOUNT_HOTKEY1 = L["mount"]
BINDING_NAME_EASYMOUNT_HOTKEY2 = L["force ground mount"]

local frame = UICreateInterfaceOptionPage("EasyMountOptionFrame", "EasyMount", L["desc"])
addon.optionFrame = frame

local tabFrame = UICreateTabFrame(frame:GetName().."TabFrame", frame)
frame.tabFrame = tabFrame
tabFrame:SetSize(380, 320)
frame:AnchorToTopLeft(tabFrame, 0, -24)

tabFrame:AddTab(L["ground"], "ground")
tabFrame:AddTab(L["fly"], "fly")
tabFrame:AddTab(L["swim"], "swim")
tabFrame:AddTab(L["taq"], "taq")
tabFrame:SelectTab(1)

local list = UICreateVirtualScrollList(tabFrame:GetName().."ListFrame", tabFrame, 15)
frame.listFrame = list
list:SetPoint("TOPLEFT", 5, -12)
list:SetPoint("BOTTOMRIGHT", -7, 7)
list.key = "ground"

local function List_Update(self)
	self:Clear()
	local mounts = addon[self.key]
	if not mounts then
		return
	end

	local id, data
	for id in pairs(mounts) do
		data = addon:GetMountData(id)
		if data then
			self:InsertData(data)
		end
	end

	if self.key == "swim" and addon.seahorse and not mounts[75207] then
		data = addon:GetMountData(75207)
		if data then
			self:InsertData(data)
		end
	end
end

list:HookScript("OnShow", List_Update)

function tabFrame:OnTabSelected(id, key)
	list.key = key
	List_Update(list)
end

local function Check_OnClick(self)
	if self:GetChecked() then
		addon.db.blacklist[self.id] = nil
	else
		addon.db.blacklist[self.id] = 1
	end
	addon:UpdateAttributeLists()
end

function list:OnButtonCreated(button)
	local check = CreateFrame("CheckButton", button:GetName().."Check", button, "InterfaceOptionsCheckButtonTemplate")
	check:SetHitRectInsets(0, 0, 0, 0)
	check:SetPoint("LEFT", 4, 0)
	check:SetScript("OnClick", Check_OnClick)
	button.check = check

	local icon = button:CreateTexture(button:GetName().."Icon", "ARTWORK")
	icon:SetSize(16, 16)
	icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
	icon:SetPoint("LEFT", check, "RIGHT", 4, 0)
	button.icon = icon

	local text = button:CreateFontString(button:GetName().."Text", "ARTWORK", "GameFontHighlightLeft")
	text:SetPoint("LEFT", icon, "RIGHT", 8, 0)
	text:SetTextColor(0x71 / 0xff, 0xd5 / 0xff, 1)
	button.text = text
end

function list:OnButtonUpdate(button, data)
	button.check.id = data.id
	button.check:SetChecked(not addon.db.blacklist[data.id])
	button.icon:SetTexture(data.icon)
	button.text:SetText(data.name)
end

function list:OnButtonTooltip(button, data)
	GameTooltip:SetHyperlink(data.link)
end

SLASH_EASYMOUNT1 = "/easymount"
SLASH_EASYMOUNT2 = "/ezm"
SlashCmdList["EASYMOUNT"] = function()
	frame:Open()
end