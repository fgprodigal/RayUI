--[[----------------------------------------------------------------------------

  LiteMount/UIOptionsMounts.lua

  Options frame for the mount list.

  Copyright 2011,2012 Mike Battersby

----------------------------------------------------------------------------]]--

function LiteMountOptionsBit_OnClick(self)
    local spellid = self:GetParent().spellid

    if self:GetChecked() then
        LM_Options:SetSpellFlagBit(spellid, self.defflags, self.flagbit)
    else
        LM_Options:ClearSpellFlagBit(spellid, self.defflags, self.flagbit)
    end
    LiteMountOptions_UpdateMountList()
end

-- Because we get attached inside the blizzard options container, we
-- are size 0x0 on create and even after OnShow, we have to trap
-- OnSizeChanged on the scrollframe to make the buttons correctly.
local function CreateMoreButtons(self)
    HybridScrollFrame_CreateButtons(self, "LiteMountOptionsButtonTemplate",
                                    0, -1, "TOPLEFT", "TOPLEFT",
                                    0, -1, "TOP", "BOTTOM")

    for _,b in ipairs(self.buttons) do
        b:SetWidth(b:GetParent():GetWidth())
        b.bit1.flagbit = LM_FLAG_BIT_RUN
        b.bit2.flagbit = LM_FLAG_BIT_FLY
        b.bit3.flagbit = LM_FLAG_BIT_SWIM
        b.bit4.flagbit = LM_FLAG_BIT_AQ
        b.bit5.flagbit = LM_FLAG_BIT_VASHJIR
    end
end

local function EnableDisableSpell(spellid, onoff)
    if onoff == "0" then
        LM_Options:AddExcludedSpell(spellid)
    else
        LM_Options:RemoveExcludedSpell(spellid)
    end
end

local function BitButtonUpdate(checkButton, mount)
    local flags = mount:Flags()
    local defflags = mount:DefaultFlags()

    local checked = bit.band(flags, checkButton.flagbit) == checkButton.flagbit
    checkButton:SetChecked(checked)

    checkButton.defflags = defflags

    -- If we changed this from the default then color the background
    if bit.band(flags, checkButton.flagbit) == bit.band(defflags, checkButton.flagbit) then
        checkButton.modified:Hide()
    else
        checkButton.modified:Show()
    end
end

local function UpdateMountButton(button, mount)
    button.icon:SetNormalTexture(mount:Icon())
    button.name:SetText(mount:Name())
    button.spellid = mount:SpellId()
    button.mountid = mount:MountID()

    if not InCombatLockdown() then
        mount:SetupActionButton(button.icon)
    end

    BitButtonUpdate(button.bit1, mount)
    BitButtonUpdate(button.bit2, mount)
    BitButtonUpdate(button.bit3, mount)
    BitButtonUpdate(button.bit4, mount)
    BitButtonUpdate(button.bit5, mount)

    if LM_Options:IsExcludedSpell(button.spellid) then
        button.enabled:SetChecked(false)
    else
        button.enabled:SetChecked(true)
    end
    button.enabled.setFunc = function(setting)
                            EnableDisableSpell(button.spellid, setting)
                            button.enabled:GetScript("OnEnter")(button.enabled)
                        end

    if GameTooltip:GetOwner() == button.enabled then
        button.enabled:GetScript("OnEnter")(button.enabled)
    end

end

local function GetFilteredMountList()
    local lmom = LiteMountOptionsMounts

    mounts = LiteMount:GetAllMounts()

    local filtertext = lmom.filter:GetText()
    if filtertext == SEARCH then
        filtertext = ""
    else
        filtertext = string.lower(filtertext)
    end
    if filtertext ~= "" then
        for i = #mounts, 1, -1 do
            if not string.find(string.lower(mounts[i]:Name()), filtertext) then
                table.remove(mounts, i)
            end
        end
    end
    return mounts
end

function LiteMountOptions_UpdateMountList()

    local scrollFrame = LiteMountOptionsMounts.scrollFrame
    local offset = HybridScrollFrame_GetOffset(scrollFrame)
    local buttons = scrollFrame.buttons

    if not buttons then return end

    mounts = GetFilteredMountList()

    for i = 1, #buttons do
        local button = buttons[i]
        local index = offset + i
        if index <= #mounts then
            UpdateMountButton(button, mounts[index])
            button:Show()
        else
            button:Hide()
        end
    end

    local totalHeight = scrollFrame.buttonHeight * #mounts
    local shownHeight = scrollFrame.buttonHeight * #buttons

    HybridScrollFrame_Update(scrollFrame, totalHeight, shownHeight)
end

function LiteMountOptionsScrollFrame_OnSizeChanged(self, w, h)
    CreateMoreButtons(self)
    LiteMountOptions_UpdateMountList()

    self.stepSize = self.buttonHeight
    self.update = LiteMountOptions_UpdateMountList
end

function LiteMountOptionsMounts_OnLoad(self)

    LiteMount_Frame_AutoLocalize(self)

    -- Because we're the wrong size at the moment we'll only have 1 button
    CreateMoreButtons(self.scrollFrame)

    self.parent = LiteMountOptions.name
    self.name = MOUNTS
    self.title:SetText("LiteMount : " .. self.name)
    self.default = function ()
            for _,m in LiteMount:GetAllMounts() do
                LM_Options:ResetSpellFlags(m:SpellId())
            end
            LM_Options:SetExcludedSpells({})
            LiteMountOptions_UpdateMountList()
        end

    InterfaceOptions_AddCategory(self)

    -- We need to refresh the icon SecureActionButtons after exiting combat
    self:RegisterEvent("PLAYER_REGEN_ENABLED")
    self:SetScript("OnEvent", function () LiteMountOptions_UpdateMountList() end)
end


function LiteMountOptionsMounts_OnShow(self)
    LiteMountOptions.CurrentOptionsPanel = self
    LiteMountOptions_UpdateMountList()
end

